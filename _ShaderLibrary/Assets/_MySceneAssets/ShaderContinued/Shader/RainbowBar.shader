Shader "Unlit/RainbowBar"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Height ("Height", Range(0,1)) = 1 // so we don't have to remap it. (0,1) is easier for the math    
        _BoarderSize("BoarderSize", Range(0,0.5)) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        

        Pass
        {
            ZWrite Off // otherwise transparency collission mess   
            Blend SrcAlpha OneMinusSrcAlpha // src * srcAplpha + dst * (1-srcAlpha) -> alphaBlending
            

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Height;
            float _BoarderSize;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);                    
                o.uv = v.uv;                   
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }


            float4 frag (Interpolators i) : SV_Target
            {
                // rounded corner clipping  
                float2 coords = i.uv;
                coords.x *= 8;
                float2 pointOnLineSeg = float2 ( clamp(coords.x, 0.5, 7.5), 0.5);
                float sdf = distance(coords, pointOnLineSeg)  * 2 - 1;
                clip(-sdf);

                // Boarder
                float boarderSdf = sdf + _BoarderSize;
    
                float pd = fwidth(boarderSdf); // screen space partial derivate
        
                float boarderMask = saturate(boarderSdf / pd);





                // return float4(boarderMask.xxx, 1);

                //fwidth()
                

                // Create mask which changes how health changes -> across what does it change
                float heightbarMask = _Height > i.uv.x; 
                // clip(heightbarMask - 0.5); // transparency without sorting issues what you normally get with transparency (still writing to the zBuffer)            
                float3 heightbarColor = tex2D(_MainTex, float2(_Height, i.uv.y));
                

                // Flash if hit the right height
                // 0.1, 0.2, 0.35, 0.4, 0.46, 0.65, 0.8, 0.89)                
                if(_Height == 0.1)
                {
                    float flash = cos(_Time.y * 4) * 0.4 + 1;
                    heightbarColor *= flash;
                }
                
                if(_Height == 0.65)
                {
                    float flash = cos(_Time.y * 4) * 0.4 + 1;
                    heightbarColor *= flash;
                }

                // stop color at purple
                if(_Height >= 0.89)
                {
                    
                    heightbarColor = float3(0.3,0,0.9);
                }

                return float4(heightbarColor * heightbarMask * boarderMask, 1);
                

                
            }
            ENDCG
        }
    }
}











// sample the texture
// float4 col = tex2D(_MainTex, i.uv);

// float heightbarMask = _Height > floor(i.uv.x * 7)/7;
// return heightbarMask;
// return float4( i.uv, 0, 0);

//clip(heightbarMask - 0.5); // transparency without sorting issues what you normally get with transparency (still writing to the zBuffer)

 /*
                float3 bgColor = float3(0,0,0);
                float3 outColor = lerp(bgColor, heightbarColor, heightbarMask);
                return float4(outColor, 0);
                */

// return float4(heightbarColor, heightbarMask * 1.0);
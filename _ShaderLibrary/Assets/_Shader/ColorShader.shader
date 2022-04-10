Shader "Unlit/ColorShader"
{
    Properties // ownDefined inputData  
    {
        
        _Value ("Value", Float) = 1.0     
    }
    SubShader 
    {
        Tags { "RenderType"="Opaque" }
          

        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"

            
           float _Value;  

            // automatically filled out by unity
            struct MeshData  // perVertex meshData    
            {
                float4 vertex : POSITION; // vertexPosition   
                float3 normals : NORMAL; // normalDirection of a vertex      
               
                float2 uv0 : TEXCOORD0; // uv0 coordinates -> diffuse/normal map textures 
                
            };

            struct Interpolaters // v2f 
            { 
                
                float4 vertex : SV_POSITION; // clipSpacePosition of the vertex
                // float2 uv : TEXCOORD0;                    
            };   

                                  

            Interpolaters vert (MeshData v)                                                          
            {
                Interpolaters o;
                o.vertex = UnityObjectToClipPos(v.vertex); 
                return o;  
            }

            

            // actual fragmentShader
            float4 frag (Interpolaters i) : SV_Target
            {          
                return float4(1,1, 0,1);
            }
            ENDCG 
        }
    }
}

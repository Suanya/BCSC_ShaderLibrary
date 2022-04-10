Shader "Unlit/CleanBaseShader"
{
    Properties 
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
      
            struct MeshData  
            {
                float4 vertex : POSITION; 
                float3 normals : NORMAL;    
                
                
                float2 uv0 : TEXCOORD0; 
                 
            };

            struct Interpolaters // v2f
            { 
                 // float2 uv : TEXCOORD0;  
                float4 vertex : SV_POSITION; // clipSpacePosition of the vertex                       
            };  

            Interpolaters vert (MeshData v)                                                          
            {
                Interpolaters o;
                o.vertex = UnityObjectToClipPos(v.vertex);    
                return o;
            }

            float4 frag (Interpolaters i) : SV_Target
            {          
                return 0;
            }
            ENDCG 
        }
    }
}

// Upgrade NOTE: replaced 'defined USING_DIRECTIONAL_LIGHT' with 'defined (USING_DIRECTIONAL_LIGHT)'

Shader "MayoHa/Toon/ToonLit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp Texture",2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf ToonRamp

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        #pragma lighting TooonRamp exclude_path:prepass

        inline half4 LightingToonRamp(SurfaceOutput s,half3 lightDir,half atten){
            #if defined (USING_DIRECTIONAL_LIGHT)
                lightDir = normalize(lightDir);
            #endif
            float d = saturate(dot(s.Normal,lightDir));
            float3 ramp = tex2D(_RampTex,float2(d,d)).rgb;
            float4 col;
            col.rgb = ramp * _LightColor0.rgb * s.Albedo * (atten * 2);
            col.a = 0;
            return col;
        }

        fixed4 _Color;


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

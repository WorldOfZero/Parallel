Shader "Custom/PortalShader" {
	Properties {
		_Color ("Canvas Color", Color) = (1,1,1,1)
		_MainTex ("Emission (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Exponent("Exponent", Range(0,24)) = 2
	}
	SubShader {
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _Exponent;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float x = (IN.uv_MainTex.x - 0.5f) * 2;
			float y = (IN.uv_MainTex.y - 0.5f) * 2;
			float radius = sqrt(x*x + y*y);
			clip(1 - radius);

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = _Color;
			o.Emission = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = pow(min(1, 10 * (1 - radius)), _Exponent);
			o.Emission *= o.Alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

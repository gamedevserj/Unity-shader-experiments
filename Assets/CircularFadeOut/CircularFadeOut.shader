Shader "Unlit/CircularFadeOut"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_FadeAmount("Fade Amount", Range(0.0,1.0)) = 0.0
		_FadeSmoothing("Fade Smoothing", Range(0.0,1.0)) = 0.0
		_Tiling("Tiling", Vector) = (1.0, 1.0, 0.0, 0.0)
		_Offset("Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
		_Hypotenuse("Hypotenuse", Float) = 1.0
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}

			Cull Off
			Lighting Off
			ZWrite Off
			Blend One OneMinusSrcAlpha

			Pass
			{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct appdata_t
				{
					float4 vertex   : POSITION;
					float4 color    : COLOR;
					float2 uv		: TEXCOORD0;
				};

				struct v2f
				{
					float4 vertex   : SV_POSITION;
					fixed4 color	: COLOR;
					float2 uv		: TEXCOORD0;
				};

				v2f vert(appdata_t i)
				{
					v2f OUT;
					OUT.vertex = UnityObjectToClipPos(i.vertex);
					OUT.uv = i.uv;
					OUT.color = i.color;

					return OUT;
				}

				sampler2D _MainTex;
				float _FadeAmount;
				float _FadeSmoothing;
				float2 _Tiling;
				float2 _Offset;
				float _Hypotenuse;


				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 c = i.color;
					float2 center = i.uv * _Tiling - _Offset;
                    
                    float fadeDistance = length(center);
                    
                    float invertedFadeAmount = 1.0 - _FadeAmount;
                    
					float remappedFade = (invertedFadeAmount * (invertedFadeAmount * _Hypotenuse + _FadeSmoothing) - _FadeSmoothing);

					float fadeMask = smoothstep(0., 1.0 * _FadeSmoothing, fadeDistance - remappedFade);

					c.rgba *= fadeMask;
					return c;
				}
			ENDCG
			}
		}
}



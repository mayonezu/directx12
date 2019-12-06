Shader "Hidden/LEDImageEffectShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		//画面縦方向の分割数
		_Division("Division Num", Int) = 40
		//輝度しきい値　LEDの点灯判断で使用
		_Threshold("LED Active Luminance Threshold", Float) = 0.4

		_BGColor("Back Ground Color", Color) = (0, 0, 0, 1)
		_ActiveColor("LED Active Color", Color) = (0.8, 0.1, 0.1, 1)
		_InactiveColor("LED Inactive Color", Color) = (0.1, 0.1, 0.1, 1)
		_Size("LED Size", Range(0 , 1)) = 0.4
	}

	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			half _Division;
			half _Threshold;
			fixed4 _BGColor;
			fixed4 _ActiveColor;
			fixed4 _InactiveColor;
			half _Size;

			fixed4 frag(v2f i) : SV_Target
			{
				half2 pos = i.uv * _ScreenParams.xy;
				//分割数と解像度(_ScreenParams)に応じて、画面をブロックとして分割するためのサイズを算出
				half blockSize = _ScreenParams.y / _Division;
				//描画箇所のブロックを特定し、そのブロックの中心のUV座標を取得
				float2 blockCenter = floor(pos / blockSize) * blockSize + blockSize * 0.5;
				half2 uv = blockCenter / _ScreenParams.xy;
				//輝度を取得
				fixed luminance = Luminance(tex2D(_MainTex, uv)).r;
				//サイズに応じて塗りつぶし
				if (distance(blockCenter, pos) < blockSize * _Size)
				{
					//輝度がしきい値以上なら点灯色、未満なら消灯色　
					if (luminance >= _Threshold)
					{
						return _ActiveColor;
					}
					else
					{
						return _InactiveColor;
					}
				}
				return _BGColor;
			}
			ENDCG
		}
	}
}



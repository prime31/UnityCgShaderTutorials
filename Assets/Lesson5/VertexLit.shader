Shader "_Shaders/Vertex Lit"
{
	Properties
	{
		_MainTex ( "Base (RGB)", 2D ) = "white" {}
		_Color( "Diffuse Material Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
	}
	
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		
		Pass
		{
CGPROGRAM
#pragma exclude_renderers ps3 xbox360
#pragma fragmentoption ARB_precision_hint_fastest
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "../Shared/Prime31.cginc"


// uniforms
uniform sampler2D _MainTex;
uniform float4 _MainTex_ST;
uniform fixed4 _Color;


struct vertexInput
{
	float4 vertex : POSITION; // position (in object coordinates, i.e. local or model coordinates)
	float3 normal : NORMAL; // surface normal vector (in object coordinates; usually normalized to unit length)
	float4 texcoord : TEXCOORD0;  // 0th set of texture coordinates (a.k.a. “UV”; between 0 and 1)
};


struct fragmentInput
{
	float4 pos : SV_POSITION;
    float4 color : COLOR0;
    half2 uv : TEXCOORD0;
};


fragmentInput vert( vertexInput i )
{
	fragmentInput o;
	o.pos = mul( UNITY_MATRIX_MVP, i.vertex );
	o.uv = TRANSFORM_TEX( i.texcoord, _MainTex );
	
	
	
	o.color = _Color;
    
	return o;
}


half4 frag( fragmentInput i ) : COLOR
{
	return tex2D( _MainTex, i.uv ) * i.color;
}

ENDCG
		} // end Pass
	} // end SubShader
	
	FallBack "Diffuse"
}

Shader "_Shaders/Vertex Lit"
{
	Properties
	{
		_MainTex ( "Base (RGB)", 2D ) = "white" {}
		_Color( "Diffuse Material Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
	}
	
	SubShader
	{
		Tags { "LightMode" = "ForwardBase" }
		
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
uniform fixed4 _LightColor0;


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
	
	// first off, we need the normal to be in world space
	float3 normalDirection = NORMAL_TO_WORLD( i.normal );
	
	// we will only be dealing with a single directional light
	float3 lightDirection = normalize( _WorldSpaceLightPos0.xyz );
	
	
	// calculate diffuse lighting = IncomingLight * DiffuseColor * ( N dot L )
	// we use max in case the dot is negative which would indicate the light is on the wrong side
	float ndotl = dot( normalDirection, lightDirection );
	float3 diffuse = _LightColor0.xyz * _Color.rgb * max( 0.0, ndotl );
	
	o.color = half4( diffuse, 1.0 );
    
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

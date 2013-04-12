
#define NORMAL_TO_WORLD( normal ) normalize( mul( float4( normal, 1.0 ), _World2Object ).xyz )
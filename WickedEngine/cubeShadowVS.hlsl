#include "globals.hlsli"
#include "objectInputLayoutHF.hlsli"


struct GS_CUBEMAP_IN
{
	float4 Pos		: SV_POSITION;    // World position
};

GS_CUBEMAP_IN main(Input_Shadow_POS input)
{
	GS_CUBEMAP_IN Out = (GS_CUBEMAP_IN)0;


	float4x4 WORLD = MakeWorldMatrixFromInstance(input.instance);

	Out.Pos = mul(float4(input.pos.xyz, 1), WORLD);


	return Out;
}
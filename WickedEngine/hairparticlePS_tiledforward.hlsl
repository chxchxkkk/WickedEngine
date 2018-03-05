#define DISABLE_DECALS
#define DISABLE_ENVMAPS
#include "globals.hlsli"
#include "objectHF.hlsli"
#include "hairparticleHF.hlsli"
#include "ditherHF.hlsli"

[earlydepthstencil]
GBUFFEROutputType_Thin main(VertexToPixel input)
{
	float4 color = texture_0.Sample(sampler_linear_clamp, input.tex);
	color.a *= 1.0 - input.fade;
	clip(color.a - 1.0f / 256.0f); // cancel heaviest overdraw for the alpha composition effect
	float opacity = 1;
	color.rgb = DEGAMMA(color.rgb);
	float3 V = g_xCamera_CamPos - input.pos3D;
	float dist = length(V);
	V /= dist;
	float emissive = 0;
	Surface surface = CreateSurface(input.pos3D, input.nor, V, color, 0, 0, 1);
	float ao = 1;
	float sss = 0;
	float2 pixel = input.pos.xy;
	float depth = input.pos.z;
	float3 diffuse = 0;
	float3 specular = 0;
	float3 reflection = 0;
	float2 velocity = ((input.pos2DPrev.xy / input.pos2DPrev.w - g_xFrame_TemporalAAJitterPrev) - (input.pos2D.xy / input.pos2D.w - g_xFrame_TemporalAAJitter)) * float2(0.5f, -0.5f);

	TiledLighting(pixel, surface, diffuse, specular, reflection);
	VoxelGI(surface, diffuse, reflection, ao);

	ApplyLighting(surface, diffuse, specular, ao, opacity, color);

	ApplyFog(dist, color);

	return CreateGbuffer_Thin(color, surface, velocity);
}
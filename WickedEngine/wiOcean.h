#ifndef _OCEAN_SIMULATOR_H
#define _OCEAN_SIMULATOR_H

#include "CommonInclude.h"
#include "wiGraphicsAPI.h"
#include "wiFFTGenerator.h"
#include "wiSceneSystem_Decl.h"

#include <vector>

class wiOcean
{
public:
	wiOcean(const wiSceneSystem::WeatherComponent& weather);
	~wiOcean();

	void UpdateDisplacementMap(const wiSceneSystem::WeatherComponent& weather, float time, GRAPHICSTHREAD threadID);
	void Render(const wiSceneSystem::CameraComponent& camera, const wiSceneSystem::WeatherComponent& weather, float time, GRAPHICSTHREAD threadID);

	wiGraphicsTypes::Texture2D* getDisplacementMap();
	wiGraphicsTypes::Texture2D* getGradientMap();

	static void Initialize();
	static void CleanUp();
	static void LoadShaders();

protected:
	wiGraphicsTypes::Texture2D* m_pDisplacementMap;		// (RGBA32F)
	wiGraphicsTypes::Texture2D* m_pGradientMap;			// (RGBA16F)


	void initHeightMap(const wiSceneSystem::WeatherComponent& weather, XMFLOAT2* out_h0, float* out_omega);


	// Initial height field H(0) generated by Phillips spectrum & Gauss distribution.
	wiGraphicsTypes::GPUBuffer* m_pBuffer_Float2_H0;

	// Angular frequency
	wiGraphicsTypes::GPUBuffer* m_pBuffer_Float_Omega;

	// Height field H(t), choppy field Dx(t) and Dy(t) in frequency domain, updated each frame.
	wiGraphicsTypes::GPUBuffer* m_pBuffer_Float2_Ht;

	// Height & choppy buffer in the space domain, corresponding to H(t), Dx(t) and Dy(t)
	wiGraphicsTypes::GPUBuffer* m_pBuffer_Float_Dxyz;


	wiGraphicsTypes::GPUBuffer* m_pImmutableCB;
	wiGraphicsTypes::GPUBuffer* m_pPerFrameCB;
};

#endif	// _OCEAN_SIMULATOR_H

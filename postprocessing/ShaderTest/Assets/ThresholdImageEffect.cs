using System;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

namespace ComicShader.ImageEffects
{
    /// <summary>
    /// 濃度の上限と下限を指定して、指定した色でベタ塗りするイメージエフェクトです
    /// 指定範囲外の濃度の部分は透明な色になります
    /// </summary>
    [ExecuteInEditMode]
    [AddComponentMenu("CommicShader/ImageEffects/ThresholdImageEffect")]
    public class ThresholdImageEffect : ImageEffectBase
    {

        /// <summary>
        /// ベタで塗る色（注：濃度しか見られていないので彩度のある色指定は未対応）
        /// </summary>
        public Color color;

        /// <summary>
        /// 上限値
        /// </summary>
        [Range(0.0f, 1.0f)]
        public float upperThresholdValue;

        /// <summary>
        /// 下限値
        /// </summary>
        [Range(0.0f, 1.0f)]
        public float lowerThresholdValue;

        // Called by camera to apply image effect
        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            material.SetColor("_Color", color);
            material.SetFloat("_ThresholdUpper", upperThresholdValue);
            material.SetFloat("_ThresholdLower", lowerThresholdValue);
            Graphics.Blit(source, destination, material);
        }
    }
}
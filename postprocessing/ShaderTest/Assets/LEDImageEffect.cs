using UnityEngine;
using UnityStandardAssets.ImageEffects;

[ExecuteInEditMode]
public class LEDImageEffect : ImageEffectBase
{
    private string m_ShaderName = "Hidden/LEDImageEffectShader";
       //画面分割数(縦)
    public uint m_Division = 40;
       //輝度のしきい値　LED点灯判断で使用
    public float m_Threshold = 0.5f;
    public Color m_BGColor = Color.black;
    public Color m_ActiveColor = Color.red;
    public Color m_InactiveColor = new Color(0.1f, 0.1f, 0.1f, 1.0f);
    public float m_Size = 0.4f;

    public void Reset()
    {
        shader = Shader.Find(m_ShaderName);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_Division", m_Division);
        material.SetFloat("_Threshold", m_Threshold);
        material.SetColor("_BGColor", m_BGColor);
        material.SetColor("_ActiveColor", m_ActiveColor);
        material.SetColor("_InactiveColor", m_InactiveColor);
        material.SetFloat("_Size", m_Size);
        Graphics.Blit(source, destination, material);
    }
}

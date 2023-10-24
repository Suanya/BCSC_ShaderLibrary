using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;

public class WarpSpeed : MonoBehaviour
{
    public VisualEffect _warpSpeedVFX;
    public float rate = 0.02f;
    public MeshRenderer _cylinder;
    public float _delay = 2.5f;

    private bool warpActive;

    // Start is called before the first frame update
    void Start()
    {
        _warpSpeedVFX.Stop();
        _warpSpeedVFX.SetFloat("_WarpAmount", 0);

        _cylinder.material.SetFloat("_Active", 0);
    }
     
    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            warpActive = true;
            StartCoroutine(ActivateParticles());
            StartCoroutine(ActivateShader());
        }
        if(Input.GetKeyUp(KeyCode.Space))
        {
            warpActive = false;
            StartCoroutine(ActivateParticles());
            StartCoroutine(ActivateShader());
        }
    }


    IEnumerator ActivateParticles()
    {
        if (warpActive)
        {
            _warpSpeedVFX.Play();

            float amount = _warpSpeedVFX.GetFloat("_WarpAmount");
            while (amount < 1)
            {
                amount += rate;
                _warpSpeedVFX.SetFloat("_WarpAmount", amount);
                yield return new WaitForSeconds(0.1f);
            }
        }
        else
        {
            float amount = _warpSpeedVFX.GetFloat("_WarpAmount");
            while (amount > 0 && !warpActive) ;
            {
                amount -= rate;
                _warpSpeedVFX.SetFloat("_WarpAmount", amount);
                yield return new WaitForSeconds(0.1f);

                if (amount <= 0 + rate)
                {
                    amount = 0;
                    _warpSpeedVFX.SetFloat("_WarpAmount", amount);
                    _warpSpeedVFX.Stop();
                }
            }
        }
    }

        IEnumerator ActivateShader()
        {
        
            if (warpActive)
            {
                yield return new WaitForSeconds(_delay);

                float amount = _cylinder.material.GetFloat("_Active");
                while (amount < 1)
                {
                    amount += rate;
                    _cylinder.material.SetFloat("_Active", amount);
                    yield return new WaitForSeconds(0.1f);
                }
            }
            else
            {
                float amount = _cylinder.material.GetFloat("_Active");
                while (amount > 0 && !warpActive);
                {
                    amount -= rate;
                    _cylinder.material.SetFloat("_Active", amount);
                    yield return new WaitForSeconds(0.1f);

                    if (amount <= 0 + rate)
                    {
                        amount = 0;
                        _cylinder.material.SetFloat("_Active", amount);

                    }
                }
            }

        }
    }


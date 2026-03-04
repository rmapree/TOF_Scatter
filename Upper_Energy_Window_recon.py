
# This will be to deal with data once the energy window data has already been selected
# Will do first without normalisation just to make it easier
# I can do this without using STIR and can use sirf instead

import sirf.STIR as PET
import os
import numpy as np
import sys

unscatter_data_upper_EW_TOF_file = sys.argv[1]
scatter_data_upper_EW_TOF_file = sys.argv[2]
atten_image_file = sys.argv[3] 
act_image_input =  sys.argv[4] # can be a template or something as well (initial image style) 
#sys.argv[6] = norm_TOF_file


def create_acq_model(attn_image,acq_template,act_image):
    acq_model_f_att = PET.AcquisitionModelUsingRayTracingMatrix()
    asm_att = PET.AcquisitionSensitivityModel(attn_image, acq_model_f_att)
    asm_att.set_up(acq_template)
    attn_factors = asm_att.forward(acq_template.get_uniform_copy(1))
    asm = PET.AcquisitionSensitivityModel(attn_factors)
    acq_model = PET.AcquisitionModelUsingRayTracingMatrix()
    acq_model.set_num_tangential_LORs(8)
    acq_model.set_acquisition_sensitivity(asm)
    acq_model.set_up(acq_template, act_image)
    return acq_model

def OSEM(acq_data, acq_model, initial_image):
        
    # create reconstructor
    obj_fun = PET.make_Poisson_loglikelihood(acq_data)
    obj_fun.set_acquisition_model(acq_model)
    recon = PET.OSMAPOSLReconstructor()
    recon.set_objective_function(obj_fun)
    recon.set_num_subsets(1)
    recon.set_num_subiterations(100)
    recon.set_current_estimate(initial_image)
    recon.set_up(initial_image)
    recon.process()
    reconstruction_data = recon.get_output()
    return reconstruction_data



unscatter_data_upper_EW_TOF_arr = PET.AcquisitionData(unscatter_data_upper_EW_TOF_file).as_array()
unscatter_data_upper_EW_TOF = PET.AcquisitionData(unscatter_data_upper_EW_TOF_file)
scatter_data_upper_EW_TOF = PET.AcquisitionData(scatter_data_upper_EW_TOF_file).as_array()
prompts_TOF_arr = scatter_data_upper_EW_TOF + unscatter_data_upper_EW_TOF_arr
prompts_TOF = unscatter_data_upper_EW_TOF.clone()
prompts_TOF.fill(prompts_TOF_arr)
#norm_TOF = PET.AcquisitionData(norm_TOF_file)
atten_image = PET.ImageData(atten_image_file)
acq_template = prompts_TOF.clone()
acq_template.fill(0)
act_image_init = PET.ImageData(act_image_input)
act_image_init.fill(1)
recon_data_name = 'upper_ew_TOF_recon'
acq_model = create_acq_model(atten_image,prompts_TOF,act_image_init)

recon_data = OSEM(prompts_TOF, acq_model, act_image_init)
recon_data.write('upper_energy_window')

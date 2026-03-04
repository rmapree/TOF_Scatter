# Just get the upper energy window
# Running initial SimSET TOF simulation
# For now this is just for different energy windows and doing initial reconstruction using highest energy window


# Do initial reconstruction - can do this with normalisation as is just initial recon to get correct ish values 
# Does this need to be a reconstruction using TOF information?
# These can all be path names
# For this example I need to add scatter and no scatter together


unscatter=/home/treeves/devel/build/sources/STIR/src/SimSET/examples/TOF_Scatter_Simulation/noscatter500.hs
scatter=/home/treeves/devel/build/sources/STIR/src/SimSET/examples/TOF_Scatter_Simulation/scatter500.hs
atten_image_file=/SAN/medic/Energy_PET_STIR_Sims/Image_Data/XCAT/XCAT_brain_atn_mod_TOF_scatter_test.hv
act_image_input=/SAN/medic/Energy_PET_STIR_Sims/Image_Data/XCAT/XCAT_brain_act_mod_TOF_scatter_test.hv

python3 Upper_Energy_Window_recon.py "${unscatter}" "${scatter}" "${atten_image_file}" "${act_image_input}"

# Write out recon file - this happens as a result of the upper_energy script

# Write in recon file to do TOF scatter simulation

# need to call run simset whilst inputting the correct variables so will essentially create my own 'how to run simset' file

: ${SIMSET_DIR:=/home/treeves/2.9.2}
export SIMSET_DIR

PATH=/home/treeves/devel/build/sources/STIR/src/SimSET/scripts:$PATH


#All STIR utilities/scripts have to be in your path, e.g. if your
#INSTALL_PREFIX was ~/STIR-bin, you could do
#   PATH=$PATH:~/STIR-bin/bin

# give the simulation a name. All output files will go into a new subdirectory of this name
SIM_NAME=/SAN/medic/Energy_PET_STIR_Sims/TOF_Scatter_Project/TOF_new_run
# number of decays to simulate
PHOTONS=4000000
# specify names/locations of input files
EMISS_DATA=/SAN/medic/Energy_PET_STIR_Sims/TOF_Scatter_Project/upper_energy_window.hv
ATTEN_DATA=${atten_image_file}
templ_dir=/home/treeves/devel/build/sources/STIR/src/SimSET/examples
DIR_INPUT=/home/treeves/devel/build/sources/STIR/src/SimSET/examples


TEMPLATE_PHG=${templ_dir}/template_phg_TOF_scatter.rec
TEMPLATE_BIN=${templ_dir}/template_bin_TOF_scatter.rec
#TEMPLATE_BIN_2=${templ_dir}/template_bin_energy_params_2.rec
TEMPLATE_DET=${templ_dir}/template_det.rec
# specify scanner
SCANNER="GE Discovery 690"
# maximum ring difference to store in conversion from SimSET to Interfile projdata
NUM_SEG=0
# export all variables
export SIM_NAME EMISS_DATA ATTEN_DATA TEMPLATE_PHG TEMPLATE_BIN TEMPLATE_DET
export PHOTONS NUM_SEG SCANNER
export DIR_INPUT
DIR_OUTPUT=${SIM_NAME}
export DIR_OUTPUT


# set the simulation going
run_SimSET_TOF_Scatter.sh

echo "Current working directory: $(pwd)"

# Start phg in background
#$SIMSET_DIR/bin/phg "${DIR_OUTPUT}/phg.rec" > "${DIR_OUTPUT}/phg.log" 2>&1 &

PHG_PID=$!

# Wait for phg to finish
wait $PHG_PID

# need to modify to make a phg file where only TOF scatter is output rather than everything else

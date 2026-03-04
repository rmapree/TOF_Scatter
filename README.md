Using SimSET to do TOF Scatter estimation.
Files that are needed:
- Data with energy
- Normalisation
- Attenuation file

This will work by reconstructing an 'upper energy window' with normalisation. This would maybe be in the ranges of 490-520 to exclude scatter but this energy window needs to be investigated. 
This gives an 'initial image' like in SSS. 
This image is then used as the input for SimSET scatter simulation. Using the correct number of TOF bins (need to check that the resolution matches the scanner etc.). 
Main issue with this is no normalisation or detection efficiencies on scatter estimate. 

To generate initial data to check if method will work, use phg_tomos.rec to generate files that are binned into different energy windows. 
These energy windows are one energy window for both photons so will only include photons that are both above the energy threshold. 

The file TOF_recon_scatter_file.sh should take all inputs, an image for size of init image, attenuation image, for testing purposes only: unscatter and scatter files from SimSET upper energy window output.
The file Upper_Energy_Window_recon.py can be used for the initial energy window reconstruction.
The TOF_recon_scatter_file.sh should then also take the outputs from Upper_Energy_Window_recon.py (this path will need to be specified in the script) to carry out the scatter forward projection. 
There will be both the unscatter and scatter file output and this file will be for the whole energy window instead of just the upper energy window. 


This script references the bash scripts included in STIR that have been set up for running and converting SimSET files to STIR data to reduce the work required. 
If any modified versions of these scripts are required, they will be provided in the repository.

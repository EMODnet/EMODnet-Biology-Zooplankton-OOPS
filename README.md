# EMODnet-Biology-Zooplankton-OOPS
Workflow for the calculation of OOPS zooplankton gridded abundance maps

See http://www.emodnet-biology.eu/blog/oops

This directory contains all the steps to create the latest gridded map products of zooplankton.

# Data
The data that was used for these products are the SAHFOS/Marine Biological Association (UK) data (https://www.cprsurvey.org/) from the North Atlantic, from 1958 to 2016.

All data is available here:
CPR Survey. (2018). Operational Oceanographic Products and Services (OOPS) CPR Survey Data Extract (2016) [Data set]. Marine Biological Association. https://doi.org/10.17031/W508-X849

 # preprocessing
 The raw csv file is first preprocessed in https://github.com/EMODnet/EMODnet-Biology-Zooplankton-OOPS/blob/master/00_Preprocess_OOPS-data.R.
 
This script:
 
1. load original datafile
2. calculate for each species/variable the log(x +1)
3. create for each species a txt file: bigfile_*species*.txt that can be read by DIVAnd

 # Calculation of optimal interpolation parameters:
 
 In the next file, the optimal interpolation parameters are calculated
 https://github.com/EMODnet/EMODnet-Biology-Zooplankton-OOPS/blob/master/01_OOPS_1yr_param_calculation_2000_2016.ipynb
 
 The script:
 
 * The script loops over the variable names in varname
    * The script calculates the optimal signal-to-noise (e) and correlation length (l) parameters for the (full) years 2000 to 2016 by cross validation.
    * These optimal parameters are stored in
       *  /varname/varname_newe.txt
        * /varname/varname_newl.txt

 # Calculation of DIVA interpolated products:
 
 https://github.com/EMODnet/EMODnet-Biology-Zooplankton-OOPS/blob/master/02_OOPS_diva3d_calculation_1param.ipynb
 
 
* The script loops over the variable names in _varname_
    * the signal-to-noise (e) and correlation length (l) parameters calculated in the previous script are loaded from
        * /_varname_/*varname*_newe.txt
        * /_varname_/*varname*_newl.txt
    * these parameters are first filtered (only l < 500 000 and e < 15 are retained) and then averaged
    * with these new averaged parameters the diva product is calculated: 1 diva interpolated map
        * per species
        * per season
        * per year
    * the output netcdf files are stored in /_varname_/netcdf_all/"


 
 # combining all the separate NetCDF files for one species per season
 https://github.com/EMODnet/EMODnet-Biology-Zooplankton-OOPS/blob/master/03_Postprocessing_Combine_Netcdfs_per_season.ipynb
 
The script

* loops over the variable names in varname
* creates a new directory /varname/netcdf_season/
* and combines the data of the netcdfs in /varname/netcdf_all into 4 netcdfs (one per season): varname_StartyearEndyear_season.nc

with as season a number between 1 and 4:

1. months 1-3
2. months 4-6
3. months 7-9
4. months 10-12

 


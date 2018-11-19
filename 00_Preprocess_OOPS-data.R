# script to preprocess the oops data:
# 1. load original datafile
# 2. calculate for each species/variable the log(x +1)
# 3. create for each species a txt file: bigfile_*species*.txt 

#set wd
setwd("C:/Users/.../.../DIVA Workshop")

#Read data from csv files
species <- read.csv("C:/Users/.../oops-2016.csv", header=TRUE)

# "bigdatafile" can be imported to DIVA:
# see notebook 7: reading data
# https://github.com/gher-ulg/divand.jl/blob/master/src/load_obs.jl

# TAB-separated
	# longitude,
	# latitutde,
	# field value (e.g., temperature, salinity, chlorophyll concentration, ...),
	# depth,
	# time, tries the Julia 'DateTime' function
		# (Julia format: of the bigfile: "y-m-dTH:M:S")
		# (x <- strptime(c("2006-01-08 10:07:52", "2006-08-07 19:33:02"),
               "%Y-%m-%d %H:%M:%S", tz = "EST5EDT"))
	# measurement identifier.
# Example lines of a bigfile:
# 28.3333 43.167 15.7020 0.0 0 1991 09 03 16 1991-09-03T16:25 Cruise:WOD05_BG000003-11570900-28.3333-43.167 36
# 28.3333 43.167 15.7380 10.0 0 1991 09 03 16 1991-09-03T16:25 Cruise:WOD05_BG000003-11570900-28.3333-43.167 36

# create log abundance:
species$log.chli <- log(species$Chlorophyll_Index + 1)
	#species$log.tot_cop <- log(species$Total.Copepods + 1)
species$log.tem_lon <- log(species$Temora.longicornis + 1)
species$log.aca_spp <- log(species$Acartia.spp...unidentified. + 1)
species$log.oit_spp <- log(species$Oithona.spp. + 1)
species$log.cal_fin <- log(species$Calanus.finmarchicus + 1)
species$log.cal_hel <- log(species$Calanus.helgolandicus + 1)
species$log.met_luc <- log(species$Metridia.lucens + 1)
species$log.tot_lar <- log(species$Total.Large.Copepods + 1)
species$log.tot_sma <- log(species$Total.Small.Copepods + 1)
species$ratio_large_to_small <- species$log.tot_lar / (species$log.tot_lar + species$log.tot_sma)
	#species$log.tot_dia <- log(species$Total.Diatoms + 1)
	#species$log.tot_din <- log(species$Total.Dinoflagellates + 1)

# replace NA -> 0
species[is.na(species)] <- 0
head(species)

species$depth <- 0
species$bot.depth <- 0
species$Cruise <- "SAHFOS_CPR"
species$QF <- 1
species$QV<- 1
species$type <- "A"
species$date <- paste(species$year, "-", species$Month, sep = "")
# convert to POSIXct
species$DateTime <- format(as.POSIXct(species$Midpoint_Date_Local, format = "%Y-%m-%d %H:%M", tz="UTC"),
format = "%Y-%m-%dT%H:%M")

# Make 1 datafile for each species
spec <- c("log.chli","log.tem_lon","log.aca_spp","log.oit_spp",
		"log.cal_fin", "log.cal_hel", "log.met_luc", "log.tot_lar",
		"log.tot_sma", "ratio_large_to_small")

for (sp in spec){
	print(sp)
	dataforBigfile_sp <- species[c("Longitude", # longitude
			"Latitude", # latitude
			sp, # value
			"depth",# depth
			"Year", # will not be read
			"Month",# will not be read
			"Year", # will not be read
			"Month",# will not be read
			"Year", # will not be read
			"DateTime", # time
			"Cruise", # identifier
			"Year")] # will not be read
	dataforBigfile_sp <- format(dataforBigfile_sp, nsmall = 1)

	# tab: "\t"
	write.table(dataforBigfile_sp, paste0("bigfile_", sp, ".txt"), sep=" ", quote = FALSE,
	col.names = FALSE, row.names = FALSE)
}

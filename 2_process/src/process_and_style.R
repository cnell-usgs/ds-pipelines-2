
combine_nwis_data <- function(download_files = c('1_fetch/out/nwis_01427207_data.csv','1_fetch/out/nwis_01432160_data.csv','1_fetch/out/nwis_01435000_data.csv','1_fetch/out/nwis_01436690_data.csv','1_fetch/out/nwis_01466500_data.csv','1_fetch/out/nwis_01477050_data.csv')){
  
  data_out <- data.frame(agency_cd = c(), site_no = c(), dateTime = c(), 
                         X_00010_00000 = c(), X_00010_00000_cd = c(), tz_cd = c())
  
  for (download_file in download_files){
    
    # read the downloaded data and append it to the existing data.frame
    these_data <- read_csv(download_file, col_types = 'ccTdcc')
    data_out <- rbind(data_out, these_data)
  }
  
  return(data_out)
  
}


process_and_style <- function(input_data, site_filename = '1_fetch/out/site_info.csv'){
  
  nwis_data <- input_data
  site_info <- read_csv(site_filename)
  
  nwis_data_clean <- nwis_data %>%
    rename(water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, tz_cd) %>%
    left_join(site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)
  
  #return(nwis_data_clean)
  write_csv(nwis_data_clean, '2_process/out/nwis_data_clean.csv')
  
}
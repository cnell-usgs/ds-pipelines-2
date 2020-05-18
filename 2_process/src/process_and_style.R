combine_nwis_data <- function(download_files){

  for (download_file in download_files){

    # read the downloaded data and append it to the existing data.frame
    these_data <- read_csv(download_file, col_types = 'ccTdcc')
    data_out <- rbind(data_out, these_data)
  }
  
  write_csv(data_out, '2_process/out/nwis_data.csv')
  
}


process_and_style <- function(nwis_data_path = '2_process/out/nwis_data.csv', site_filename = '1_fetch/out/site_info.csv'){
  
  nwis_data <- read_csv(nwis_data_path)
  site_info <- read_csv(site_filename)
  
  nwis_data_clean <- nwis_data %>%
    rename(water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, tz_cd) %>%
    left_join(site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)
    
  return(nwis_data_clean)
  
}




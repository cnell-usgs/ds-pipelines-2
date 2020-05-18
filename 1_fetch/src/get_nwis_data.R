
download_nwis_data <- function(site_nums = c("01427207", "01432160", "01435000", "01436690", "01466500", "01477050"), parameterCd = '00010', dl_dir = '1_fetch/out'){
  
  # create the file names that are needed for download_nwis_site_data
  # tempdir() creates a temporary directory that is wiped out when you start a new R session; 
  # replace tempdir() with "1_fetch/out" or another desired folder if you want to retain the download
  download_files <- file.path(dl_dir, paste0('nwis_', site_nums, '_data.csv'))
  

  # loop through files to download 
  for (download_file in download_files){
    download_nwis_site_data(download_file, parameterCd = parameterCd)
    
  }
  return(download_files)
  
}

nwis_site_info <- function(fileout, nwis_data_path = '2_process/out/nwis_data.csv'){
  
  site_data <- read_csv(nwis_data_path)
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
}


download_nwis_site_data <- function(filepath, parameterCd, startDate="2014-05-01", endDate="2015-05-01"){
  
  # filepaths look something like directory/nwis_01432160_data.csv,
  # remove the directory with basename() and extract the 01432160 with the regular expression match
  site_num <- basename(filepath) %>% 
    stringr::str_extract(pattern = "(?:[0-9]+)")
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try scmake() again')
  }
  # -- end of do-not-edit block
  
  write_csv(data_out, path = filepath)
  return(filepath)
}








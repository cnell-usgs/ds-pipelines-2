plot_nwis_timeseries <- function(filepath, input_path = '2_process/out/nwis_data_clean.csv', width = 12, height = 7, units = 'in'){
  
  # read in processed and styled data
  site_data_styled <- read_csv(input_path)
  
  ggplot(data = site_data_styled, aes(x = dateTime, y = water_temperature, color = station_name)) +
    geom_line() + theme_bw()
  ggsave(filepath, width = width, height = height, units = units)
}
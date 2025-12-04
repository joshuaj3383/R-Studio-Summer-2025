library(tidyverse)
library(ggplot2)

tourism_data <- read.csv("tourism_data.csv", skip = 4) 

# Clean data (only 1995 - 2020) and convert to data long
tourism_long <- tourism_data %>%
  pivot_longer(cols = "X1995":"X2020", names_prefix = "X", values_to = "tourism_dollars", names_to = "year") %>%
  mutate( # Keep everything as numeric
    year = as.integer(year),
    tourism_dollars = as.numeric(tourism_dollars)
  )

#plotting function
tourism_plot <- function(..., years = c(1995, 2020)) {
  selected_countries <- c(...)
  
  data <- tourism_long %>%
    filter(Country.Name %in% selected_countries) %>%
    filter(year >= years[1], year <= years[2])
  
  ggplot(data, aes(year, tourism_dollars, color = Country.Name, group = Country.Name)) + geom_point() + geom_line() + 
    scale_y_log10() + labs( x = "Year", y = "Dollars")
}

#examples
tourism_plot("China", "Ghana", "United States")
tourism_plot("Aruba", "Gabon", "Serbia", years = c(1998, 2013))

  
  

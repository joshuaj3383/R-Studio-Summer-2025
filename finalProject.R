library(dplyr)
library(ggplot2)
library(tidyverse)

start_date <- as.Date("2020-04-12") # First date in the database
end_date <- as.Date("2022-09-20") # Last date in the database before they change formats, note that the last date is 3-9-23

# For testing purposes or if you don't want to wait for everything to load
#end_date <- as.Date("2020-05-12") 

# Gets the list of urls using the url pattern
all_dates <- seq(start_date, end_date, by = "day") # https://stat.ethz.ch/R-manual/R-devel/library/base/html/seq.Date.html
formatted_dates <- format(all_dates, "%m-%d-%Y")
base_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/"
urls <- paste0(base_url, formatted_dates, ".csv")


covid_data <- data.frame()
for (u in urls) {
  message("Reading: ", u) # Makes sure you know it is downloading
  temp <- tryCatch({
    read.csv(u)
  }, error = function(e) NULL)
  if (!is.null(temp)) {
    tryCatch({ # After 9/20/22 they changed the column names, this is to catch any other errors
      covid_data <- rbind(covid_data, temp)
    }, error = function(e) NULL)
  }
}

# Clean up dates into R's date type (ex: 2021-01-02 05:30:44 -> 2021-01-02)
covid_data$Date <- as.Date(covid_data$Last_Update)

state_cases <- function(state_name, start = start_date, end = end_date) {
  df <- covid_data %>%
    filter(Province_State == state_name, Date >= start, Date <= end) %>%
    group_by(Date) %>%
    summarise(Cases = sum(Confirmed, na.rm = TRUE))
  ggplot(df, aes(Date, Cases)) +
    geom_line(color = "blue") +
    labs(title = paste("COVID Cases in", state_name), x = "Date", y = "Cases")
}

state_deaths <- function(state_name, start = start_date, end = end_date) {
  df <- covid_data %>%
    filter(Province_State == state_name, Date >= start, Date <= end) %>%
    group_by(Date) %>%
    summarise(Deaths = sum(Deaths, na.rm = TRUE))
  ggplot(df, aes(x = Date, y = Deaths)) +
    geom_line(color = "red") +
    labs(title = paste("COVID Deaths in", state_name), x = "Date", y = "Deaths")
}

national_cases <- function(start = start_date, end = end_date) {
  df <- covid_data %>%
    filter(Date >= start, Date <= end) %>%
    group_by(Date) %>%
    summarise(Cases = sum(Confirmed, na.rm = TRUE))
  ggplot(df, aes(Date, Cases)) +
    geom_line(color = "blue") +
    labs(title = "National COVID Cases", x = "Date", y = "Cases")
}

national_deaths <- function(start = start_date, end = end_date) {
  df <- covid_data %>%
    filter(Date >= start, Date <= end) %>%
    group_by(Date) %>%
    summarise(Deaths = sum(Deaths, na.rm = TRUE))
  ggplot(df, aes(Date, Deaths)) +
    geom_line(color = "red") +
    labs(title = "National COVID Deaths", x = "Date", y = "Deaths")
}

state_positivity <- function(state_name, start = start_date, end = end_date) {
  df <- covid_data %>%
    filter(Province_State == state_name, Date >= start, Date <= end) %>%
    group_by(Date) %>%
    summarise(Positivity = sum(Confirmed, na.rm = TRUE) / sum(Total_Test_Results, na.rm = TRUE) * 100)
  ggplot(df, aes(Date, Positivity)) +
    geom_line(color = "purple") +
    labs(title = paste("COVID Positivity Rate in", state_name),
         x = "Date", y = "Positivity Rate (%)")
}




state_cases("New York")
state_deaths("Florida")
national_cases()
national_deaths()
state_positivity("Texas", start = as.Date("2021-04-20"), end = as.Date("2021-04-30"))



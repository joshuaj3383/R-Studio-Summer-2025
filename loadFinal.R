

library(lubridate)
library(dplyr)


start_date <- as.Date("2020-04-12")
end_date <- Sys.Date() - 1   # yesterday
all_dates <- seq(start_date, end_date, by = "day")

# ----------------------------
# 2. Format dates as MM-DD-YYYY
# ----------------------------
formatted_dates <- format(all_dates, "%m-%d-%Y")

# ----------------------------
# 3. Construct GitHub URLs
# ----------------------------
base_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/"
urls <- paste0(base_url, formatted_dates, ".csv")

# ----------------------------
# 4. Read & combine CSV files
# ----------------------------
covid_data <- data.frame()  # empty master dataframe

for (u in urls) {
  temp <- tryCatch({
    read.csv(u)
  }, error = function(e) NULL)  # skip if file not found
  
  if (!is.null(temp)) {
    covid_data <- rbind(covid_data, temp)
  }
}

# ----------------------------
# 5. Basic data check
# ----------------------------
cat("Final dataset dimensions:", dim(covid_data), "\n")
cat("Column names:\n")
print(names(covid_data))

# Example: summarize total cases per state
state_summary <- covid_data %>%
  group_by(Province_State) %>%
  summarise(total_cases = sum(Confirmed, na.rm = TRUE)) %>%
  arrange(desc(total_cases))

print(head(state_summary))

# ----------------------------
# 6. Example function: plot cases for a state
# ----------------------------
state_cases <- function(state_name) {
  df <- covid_data %>%
    filter(Province_State == state_name) %>%
    arrange(as.Date(Last_Update))
  
  plot(as.Date(df$Last_Update), df$Confirmed, type = "l",
       main = paste("COVID Cases in", state_name),
       xlab = "Date", ylab = "Cases")
}

state_cases("New York")


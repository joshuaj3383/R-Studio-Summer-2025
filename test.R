# TOURISM RECEIPTS VISUALIZATION SCRIPT
# Generates comparison plot for China, Ghana, and United States

# 1. LOAD REQUIRED PACKAGES
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("scales")) install.packages("scales")

library(tidyverse)
library(scales)

# 2. LOAD AND CLEAN DATA
tourism_data <- read.csv("/home/him/Summer2025/RR_Studio/tourism/API_ST.INT.RCPT.CD_DS2_en_csv_v2_30557.csv", skip = 4)

# Clean and reshape data
tidy_tourism <- tourism_data %>%
  select(Country = Country.Name, matches("^X[0-9]{4}$")) %>%
  pivot_longer(
    cols = -Country,
    names_to = "Year",
    values_to = "Receipts"
  ) %>%
  mutate(
    Year = as.numeric(str_remove(Year, "X")),
    Receipts = as.numeric(Receipts)
  ) %>%
  filter(!is.na(Receipts))

# 3. CREATE THE VISUALIZATION
ggplot(
  data = filter(tidy_tourism, Country %in% c("China", "Ghana", "United States")),
  aes(x = Year, y = Receipts, color = Country)
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_y_log10(
    labels = dollar_format(),
    breaks = trans_breaks("log10", function(x) 10^x),
    limits = c(1e5, 1e12)  # Adjust based on your data range
  ) +
  scale_x_continuous(breaks = seq(1990, 2020, by = 5)) +
  scale_color_manual(
    values = c("China" = "#E41A1C", 
               "Ghana" = "#377EB8", 
               "United States" = "#4DAF4A")
  ) +
  labs(
    title = "International Tourism Receipts Comparison",
    subtitle = "China, Ghana, and United States",
    x = "Year",
    y = "Tourism Receipts (log scale, current US$)",
    caption = "Source: World Bank"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5)
  )

# 4. SAVE THE PLOT
ggsave("tourism_comparison.png", width = 10, height = 6, dpi = 300)
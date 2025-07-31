# Load required libraries
library(tidyverse)
library(ggplot2)
library(readr)
library(scales)

# Read the data
df <- read_csv("C:/Users/kelgr/Desktop/MSc/Dissertation/R/Conflict_Civilians_v2.csv")
df$Percent <- as.numeric(gsub("%", "", df$Percent))

# Create the dataframe with corrected headings for plot 
df$Country <- factor(df$Country, levels = c("RWA", "UGA", "DRC", "AOI"))
df$Transition <- factor(df$Transition,
                        levels = c("H to N", "No Conflict H to N", "N to H", "No Conflict N to H", 
                                   "AOI H to N", "AOI N to H"),
                        labels = c("Conflict HI → N", "Away From Conflict HI → N", "Conflict N → HI", "Away From Conflict N → HI",
                                   "Overall HI → N", "Overall N → HI")
)

df$Period <- factor(df$Period)

# Plot the data
ggplot(df, aes(x = Country, y = Percent / 100, fill = Transition)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  facet_wrap(~ Period) +
  coord_cartesian(clip = "off") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_fill_manual(
    values = c(
      "Conflict HI → N" = "#1b9e77",
      "Away From Conflict HI → N" = "#aeebd7",
      "Conflict N → HI" = "#d95f02",
      "Away From Conflict N → HI" = "#fab9a0",
      "Overall HI → N" = "#13319e",
      "Overall N → HI" = "#bfcaf2"
    )
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "bottom") +
  labs(
    y = "Land Cover Change",
    x = "Area",
    fill = "Transition",
    title = "Land Cover Transitions Between Natural and Human-Impacted Areas by Country"
  )


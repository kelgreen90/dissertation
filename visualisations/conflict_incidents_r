library(tidyverse)

# Read the data
conflict_data <- read_csv("C:/Users/kelgr/Desktop/MSc/Dissertation/R/ConflictSummary_Civilians.csv")

# Convert to long format
conflict_long <- pivot_longer(conflict_data, cols = -year, names_to = "Country", values_to = "Incidents")

# Plot the data
ggplot(conflict_long, aes(x = as.numeric(year), y = Incidents, fill = Country)) +
  geom_col() +
  geom_vline(xintercept = 2003, linetype = "dotted", color = "grey", linewidth = 1) +
  geom_vline(xintercept = 2015, linetype = "dotted", color = "grey", linewidth = 1) +
  annotate("text", x = 2003, y = Inf, label = "2003", angle = 90, vjust = 1.1, hjust = 1.1, color = "grey") +
  annotate("text", x = 2015, y = Inf, label = "2015", angle = 90, vjust = 1.1, hjust = 1.1, color = "grey") +
  facet_wrap(~ Country, scales = "free_y") +  # separate y-axes for each country
  coord_cartesian(clip = "off") +
  labs(
    title = "Conflict Incidents by Year per Country",
    x = "Year", y = "Number of Incidents"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.9),
    legend.position = "top"
  ) +
  scale_x_continuous(
    breaks = seq(1990, 2025, 5),
    labels = as.character(seq(1990, 2025, 5))
  ) +
  theme(strip.text = element_text(face = "bold")) +
  scale_fill_manual(values = c("DRC" = "#8fc4a1", "RWA" = "#41b6c4", "UGA" = "#225ea8"))

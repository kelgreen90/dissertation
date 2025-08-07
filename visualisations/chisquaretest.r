library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)

# Read your CSV
df <- read_csv("C:/Users/kelgr/Desktop/MSc/Dissertation/R/ChiSquare_v2.csv")

# Sum areas by Conflict_Status, Country, Time
summary_df <- df %>%
  group_by(Country, Time, Conflict_Status) %>%
  summarise(
    HA_to_N = sum(Area_km2[Transition_Type == "N to HA"], na.rm = TRUE),
    Total_No_Transition = sum(Area_km2[Transition_Type == "No Transition"], na.rm = TRUE),
    .groups = "drop"
  )

# Pivot longer for testing
test_df <- summary_df %>%
  pivot_longer(cols = c(HA_to_N, Total_No_Transition), names_to = "Status_Type", values_to = "Area")

# Run chi-square test
results <- data.frame(
  Country = character(),
  Time = character(),
  ChiSq = numeric(),
  P_value = numeric(),
  Method = character(),
  stringsAsFactors = FALSE
)

unique_groups <- unique(test_df %>% select(Country, Time))

for (i in 1:nrow(unique_groups)) {
  country_i <- unique_groups$Country[i]
  time_i <- unique_groups$Time[i]
  
  subset_i <- test_df %>% filter(Country == country_i, Time == time_i)
  
  # Make 2x2 matrix: rows = Status_Type (Transition/No_Transition), cols = Conflict_Status
  mat <- matrix(
    c(
      subset_i$Area[subset_i$Status_Type == "HA_to_N" & subset_i$Conflict_Status == "Conflict"],
      subset_i$Area[subset_i$Status_Type == "HA_to_N" & subset_i$Conflict_Status == "No Conflict"],
      subset_i$Area[subset_i$Status_Type == "No_Transition" & subset_i$Conflict_Status == "Conflict"],
      subset_i$Area[subset_i$Status_Type == "No_Transition" & subset_i$Conflict_Status == "No Conflict"]
    ),
    nrow = 2,
    byrow = TRUE
  )
  
  # Run test (chi-square if all cells >=5, else fisher)
  if (all(mat >= 5)) {
    test <- chisq.test(mat)
    method <- "Chi-sq"
  } else {
    test <- fisher.test(mat)
    method <- "Fisher"
  }
  
  results <- results %>% 
    add_row(
      Country = country_i,
      Time = time_i,
      ChiSq = test$statistic,
      P_value = test$p.value,
      Method = method
    )
}

# Bonferroni correction
results <- results %>%
  mutate(
    p_adj = p.adjust(P_value, method = "bonferroni"),
    Significance = sapply(p_adj, function(p) {
      if (p < 0.001) "p < 0.001"
      else if (p < 0.01) "p < 0.01"
      else if (p < 0.05) "p < 0.05"
      else "ns"
    })
  )

# Plot significance heatmap
ggplot(results, aes(x = Country, y = Time, fill = Significance)) +
  geom_tile(color = "white") +
  #geom_text(aes(label = Significance), size = 5) +
  scale_fill_manual(
    values = c("p < 0.001" = "#67000d", "p < 0.01" = "#cb181d", "p < 0.05" = "#fb6a4a", "ns" = "#fcbba1"),
    name = "Significance"
  ) +
  labs(
    title = "Significance of Overall Land Cover Change Differences\nBetween Conflict and No Conflict Areas",
    x = "Country",
    y = "Time Span"
  ) +
  theme_minimal(base_size = 14) +
  theme(panel.grid = element_blank())

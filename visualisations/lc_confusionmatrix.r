library(tidyverse)
library(reshape2)

# Class names
classes <- c("Forest", "Cropland", "Shrubland", "Grassland", "Built-Up", "Water", "Barren")

# Function to build one long-format confusion matrix with year label
make_conf_matrix <- function(mat, year) {
  df <- melt(mat, varnames = c("Actual", "Predicted"), value.name = "Count")
  df$Year <- year
  return(df)
}

# Add each confusion matrix

# 1987
mat_1987 <- matrix(c(
  33, 0, 0, 0, 0, 0, 0,
  1,14, 0, 1, 2, 0, 2,
  0, 0,12, 0, 0, 0, 0,
  0, 0, 3, 4, 1, 0, 0,
  0, 4, 0, 0, 7, 0, 1,
  0, 0, 0, 0, 0, 8, 0,
  0, 0, 1, 0, 0, 0,11
), nrow = 7, byrow = TRUE, dimnames = list(classes, classes))

# 2003
mat_2003 <- matrix(c(
  33, 0, 0, 0, 0, 0, 0,
  0,14, 1, 0, 0, 0, 0,
  1, 2, 6, 2, 0, 0, 0,
  0, 1, 0, 6, 0, 0, 0,
  0, 2, 0, 0, 6, 0, 0,
  0, 0, 0, 0, 0, 7, 1,
  0, 1, 0, 0, 1, 0, 6
), nrow = 7, byrow = TRUE, dimnames = list(classes, classes))

# 2015
mat_2015 <- matrix(c(
  33, 0, 0, 0, 0, 0, 0,
  0,13, 2, 0, 0, 0, 0,
  2, 1, 7, 0, 1, 0, 0,
  0, 0, 1, 6, 0, 0, 0,
  1, 1, 0, 0, 6, 0, 0,
  0, 0, 0, 0, 0, 7, 1,
  0, 1, 0, 0, 0, 1, 6
), nrow = 7, byrow = TRUE, dimnames = list(classes, classes))

# 2024
mat_2024 <- matrix(c(
  33, 0, 0, 0, 0, 0, 0,
  0,10, 1, 4, 0, 0, 0,
  0, 0, 9, 0, 1, 0, 1,
  0, 1, 0, 6, 0, 0, 0,
  1, 2, 0, 0, 5, 0, 0,
  0, 0, 0, 0, 0, 8, 0,
  1, 0, 0, 0, 0, 0, 7
), nrow = 7, byrow = TRUE, dimnames = list(classes, classes))

# Combine all years
df_all <- bind_rows(
  make_conf_matrix(mat_1987, "1987"),
  make_conf_matrix(mat_2003, "2003"),
  make_conf_matrix(mat_2015, "2015"),
  make_conf_matrix(mat_2024, "2024")
)

class_levels <- c("Forest", "Cropland", "Shrubland", "Grassland", "Built-Up", "Water", "Barren")

df_all <- df_all %>%
  mutate(
    Actual = factor(Actual, levels = rev(class_levels)),
    Predicted = factor(Predicted, levels = class_levels)
  )

ggplot(df_all, aes(x = Predicted, y = Actual, fill = Count)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Count), size = 3) +
  scale_fill_gradient(low = "white", high = "#268c26") +
  facet_wrap(~ Year) +
  labs(
    title = "Land Cover Classification Confusion Matrices",
    x = "Predicted Class",
    y = "Actual Class",
    fill = "Count"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    strip.text = element_text(face = "bold")
  )

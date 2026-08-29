# The Balancing Beam of Performance
# Refreshed analysis for the public, anonymized portfolio dataset.
# The public dataset intentionally omits exact dates, cities, and family names.

library(tidyverse)
library(broom)
library(sandwich)
library(lmtest)

# 1) Load data -----------------------------------------------------------
gym <- read_csv("data/gymnastics_public.csv", show_col_types = FALSE) %>%
  mutate(
    level = factor(level, levels = c("Bronze", "Silver", "Gold")),
    only_dad = as.integer(spectator_group == "Only Dad"),
    breakfast_bin = case_when(
      breakfast_recorded == "Yes" ~ 1,
      breakfast_recorded == "No" ~ 0,
      TRUE ~ NA_real_
    ),
    warmed_up_bin = if_else(warmed_up_label == "Yes", 1, 0)
  )

# 2) Data audit ----------------------------------------------------------
missingness <- gym %>%
  summarise(
    meets = n(),
    breakfast_unknown = sum(is.na(breakfast_bin)),
    lunch_unknown = sum(lunch_recorded == "Unknown / not recorded"),
    only_dad_meets = sum(only_dad)
  )
print(missingness)

# 3) Descriptive spectator comparison ----------------------------------
spectator_summary <- gym %>%
  group_by(spectator_group) %>%
  summarise(
    n = n(),
    mean_allaround = mean(allaround_score),
    sd_allaround = sd(allaround_score),
    median_allaround = median(allaround_score),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_allaround))
print(spectator_summary)

# Primary descriptive contrast
primary_summary <- gym %>%
  mutate(group = if_else(only_dad == 1, "Only Dad", "All other meets")) %>%
  group_by(group) %>%
  summarise(n = n(), mean = mean(allaround_score), sd = sd(allaround_score), .groups = "drop")
print(primary_summary)

# Welch t-test (shown as a familiar reference, but interpreted cautiously
# because Only Dad has n = 3)
print(t.test(allaround_score ~ only_dad, data = gym))

# 4) Exact permutation test --------------------------------------------
# With 27 meets and only 3 Only-Dad meets, all C(27, 3) assignments are feasible.
y <- gym$allaround_score
k <- sum(gym$only_dad)
observed <- mean(y[gym$only_dad == 1]) - mean(y[gym$only_dad == 0])
combos <- combn(seq_along(y), k)
perm_diff <- apply(combos, 2, function(idx) {
  mean(y[idx]) - mean(y[-idx])
})
exact_p <- mean(abs(perm_diff) >= abs(observed))
cat("Observed mean difference:", observed, "\n")
cat("Exact two-sided permutation p-value:", exact_p, "\n")

# 5) Regression with small-sample-conscious robust SEs -----------------
# Do not include overlapping dad_present / mom_present / only_dad indicators
# in the same model. Use a single pre-specified contrast plus level.
model_level <- lm(allaround_score ~ only_dad + level, data = gym)
robust_level <- coeftest(model_level, vcov = vcovHC(model_level, type = "HC3"))
print(robust_level)

# Expanded exploratory model. Keep interpretation modest with n = 27.
model_context <- lm(
  allaround_score ~ only_dad + level + distance_from_home_miles + warmup_hour,
  data = gym
)
print(coeftest(model_context, vcov = vcovHC(model_context, type = "HC3")))

# 6) Secondary questions ------------------------------------------------
# Travel distance
print(cor.test(gym$distance_from_home_miles, gym$allaround_score, method = "pearson"))

# Warm-up time of day
print(cor.test(gym$warmup_hour, gym$allaround_score, method = "pearson"))

# Breakfast: descriptive only because 17/27 meets are unknown and the
# observed "No" group contains only 2 meets.
gym %>%
  filter(!is.na(breakfast_bin)) %>%
  group_by(breakfast_bin) %>%
  summarise(n = n(), mean = mean(allaround_score), sd = sd(allaround_score), .groups = "drop") %>%
  print()

# Lunch cannot be estimated from this historical dataset because the only
# explicitly recorded lunch observations are "Yes"; there is no usable No group.

# Warm-up completion also cannot be meaningfully estimated: 26 Yes vs 1 No.

# 7) Event-level descriptive contrast ----------------------------------
event_comparison <- gym %>%
  mutate(group = if_else(only_dad == 1, "Only Dad", "All other meets")) %>%
  pivot_longer(c(vault_score, bars_score, beam_score, floor_score),
               names_to = "event", values_to = "score") %>%
  group_by(event, group) %>%
  summarise(n = n(), mean = mean(score), .groups = "drop")
print(event_comparison)

# 8) What NOT to do yet -------------------------------------------------
# - Do not mean/median-impute meal variables.
# - Do not treat N/A as No.
# - Do not lean on random forest / SHAP with only 27 meets.
# - Do not claim causality: spectator attendance was not randomized.
# - Do not combine level and year indiscriminately; they are strongly tied.

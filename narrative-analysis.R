
#######################################################################################################
############################################ IMPORT ###################################################
#######################################################################################################

# Set working directory
setwd("~/Desktop/sdut-asylum")

# Import asylum-case.csv
library(readr)
cases <- read_csv("asylum-cases.csv", col_types = cols(CIRCUIT_COURT = col_character(), 
                                                       IDNCASE = col_character(), 
                                                       IDNPROCEEDING = col_character(), 
                                                       X1 = col_skip()))
View(cases)
# Row count == 146348

#######################################################################################################
########################################### ANALYSIS ##################################################
#######################################################################################################

# Calculate outcomes by judge and their base city
library(dplyr)
judge_outcomes <- cases %>%
  group_by(BASE_CITY, JUDGE_NAME) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            REPRESENTED = mean(REPRESENTED),
            DETAINED = mean(DETAINED)) %>%
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1),
         REPRESENTED = percent(REPRESENTED, .1),
         DETAINED = percent(DETAINED, .1))

# Calculate outcomes by court
library(scales)
court_outcomes <- cases %>%
  group_by(BASE_CITY) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME)) %>%
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate court spreads -- showing range of judge decisions in each court
court_spread <- judge_outcomes %>%
  group_by(BASE_CITY) %>%
  summarise(DEPORTED_MIN = min(ORDERED_DEPORTED), 
            DEPORTED_MAX = max(ORDERED_DEPORTED),
            DEPORTED_SPREAD = (DEPORTED_MAX - DEPORTED_MIN),
            GRANTED_MIN = min(RELIEF_GRANTED),
            GRANTED_MAX = max(RELIEF_GRANTED),
            GRANTED_SPREAD = (GRANTED_MAX - GRANTED_MIN)) %>% 
  mutate(DEPORTED_MIN = percent(DEPORTED_MIN, .1), 
         DEPORTED_MAX = percent(DEPORTED_MAX, .1),
         DEPORTED_SPREAD = percent(DEPORTED_SPREAD, .1),
         GRANTED_MIN = percent(GRANTED_MIN, .1),
         GRANTED_MAX = percent(GRANTED_MAX, .1),
         GRANTED_SPREAD = percent(GRANTED_SPREAD, .1))

# Calculate outcomes by circuit court
circuit_outcomes <- cases %>%
  group_by(CIRCUIT_COURT) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            CIRCUIT_COUNT = n()) %>%
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED,.1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE,.1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME,.1),
         CIRCUIT_SHARE = percent(CIRCUIT_COUNT/146348, .1))

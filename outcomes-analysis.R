
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

# The following calculates outcomes depending on variables that may impact an asylum seeker's case
## Findings were used in interactive chart published in Part 2 of "Returned" series

# Calculate outcomes with no variables
library(dplyr)
library(scales)
outcomes_overall <- cases %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate outcomes by nationality, only including top 10 countries with most cases
# Determine 10 countries with most cases
nations_count <- table(cases$NATIONALITY) %>% as.data.frame()

# Create new table of the top 10 countries with most cases
nations_list <- nations_count %>% filter(Freq > 2208)

# Filter cases df to countries that appear in final_nations
nations_final <- cases[cases$NATIONALITY %in% nations_list$Var1, ]
# Row count == 128,928

# Calculate outcomes by top 10 most frequent nationalities
outcomes_nationality <- nations_final %>%
  group_by(NATIONALITY) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

remove(nations_count, nations_list, nations_final)

# Calculate outcomes by circuit court
outcomes_circuit <- cases %>%
  group_by(CIRCUIT_COURT) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate outcomes by representation or no representation
## 0 = The asylum seeker did not have legal representation
## 1 = The asylum seeker had legal representation
outcomes_representation <- cases %>%
  group_by(REPRESENTED) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate outcomes by custody status
outcomes_custody <- cases %>%
  group_by(CUSTODY) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate outcomes by the fiscal year the case was decided
outcomes_year <- cases %>%
  group_by(COMP_FISCAL_YEAR) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate outcomes for cases with a judge who used to work for ICE/INS
## 0 = The asylum seeker was assigned a judge who did not previously work for ICE/INS
## 1 = The asylum seeker was assigned a judge who previously worked for ICE/INS
outcomes_ice <- cases %>%
  group_by(ICE_OR_INS) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

# Calculate outcomes by base city (court location), only including top 15 with most cases
# Determine top 15
base_count <- table(cases$BASE_CITY) %>% as.data.frame()

# Create new table of the top 15 base cities
base_list <- base_count %>% filter(Freq > 2415)

# Filter cases df to base cities that appear in base_list
base_final <- cases[cases$BASE_CITY %in% base_list$Var1, ]
# Row count == 97,793

# Calculate outcomes for top 15 base cities
outcomes_base <- base_final %>%
  group_by(BASE_CITY) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            COUNT = n()) %>% 
  mutate(ORDERED_DEPORTED = percent(ORDERED_DEPORTED, .1),
         RELIEF_GRANTED = percent(RELIEF_GRANTED, .1),
         VOLUNTARY_DEPARTURE = percent(VOLUNTARY_DEPARTURE, .1),
         OTHER_OUTCOME = percent(OTHER_OUTCOME, .1))

remove(base_count, base_list, base_final)

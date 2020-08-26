
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
# Row count == 146,348

# Import appeal cases data
appeals <- read_csv("appeal-cases.csv", 
                    col_types = cols(IDNAPPEAL = col_character(), 
                                     IDNCASE = col_character(), IDNPROCEEDING = col_character(), 
                                     X1 = col_skip()))
## Row count == 44,291

#######################################################################################################
####################################### CASES ANALYSIS ################################################
#######################################################################################################

# Calculate outcomes by court location and judges
library(dplyr)
outcomes <- cases %>% 
  group_by(BASE_CITY,
           JUDGE_NAME) %>%
  summarise(ORDERED_DEPORTED = mean(ORDERED_DEPORTED),
            RELIEF_GRANTED = mean(RELIEF_GRANTED),
            VOLUNTARY_DEPARTURE = mean(VOLUNTARY_DEPARTURE),
            OTHER_OUTCOME = mean(OTHER_OUTCOME),
            DETAINED = mean(DETAINED),
            RELEASED = mean(RELEASED),
            NEVER_DETAINED = mean(NEVER_DETAINED),
            REPRESENTED = mean(REPRESENTED),
            COUNT_CASES = n())

# Create columns to simplify outcomes
## Initial outcomes in cases
cases$INITIAL_OUTCOME <- ifelse(cases$DECISION == "ADMINISTRATIVE CLOSING - OTHER", "OTHER",
                                   ifelse(cases$DECISION == "FAILURE TO PROSECUTE (DHS CASES ONLY)", "OTHER",
                                          ifelse(cases$DECISION == "FINAL GRANT OF EOIR 42B/SUSP", "OTHER",
                                                 ifelse(cases$DECISION == "OTHER", "OTHER",
                                                        ifelse(cases$DECISION == "OTHER ADMINISTRATIVE COMPLETION","OTHER",
                                                               ifelse(cases$DECISION == "PROSECUTORIAL DISCRETION - TERMINATED", "OTHER",
                                                                      ifelse(cases$DECISION == "PROSECUTORIAL DISCRETION - ADMIN CLOSE", "OTHER",      
                                                                             ifelse(cases$DECISION == "TEMPORARY PROTECTED STATUS", "OTHER",
                                                                                    ifelse(cases$DECISION == "TERMINATED", "OTHER",
                                                                                           ifelse(cases$DECISION == "RELIEF GRANTED", "RELIEF GRANTED",
                                                                                                  ifelse(cases$DECISION == "REMOVE", "ORDERED DEPORTED",
                                                                                                         ifelse(cases$DECISION == "VOLUNTARY DEPARTURE", "VOLUNTARY DEPARTURE","ERROR"))))))))))))

## Final outcomes in cases
cases$FINAL_OUTCOME <- ifelse(cases$LAST_DECISION == "ADMINISTRATIVE CLOSING - OTHER", "OTHER",
                                 ifelse(cases$LAST_DECISION == "FAILURE TO PROSECUTE (DHS CASES ONLY)", "OTHER",
                                        ifelse(cases$LAST_DECISION == "FINAL GRANT OF EOIR 42B/SUSP", "OTHER",
                                               ifelse(cases$LAST_DECISION == "OTHER", "OTHER",
                                                      ifelse(cases$LAST_DECISION == "OTHER ADMINISTRATIVE COMPLETION","OTHER",
                                                             ifelse(cases$LAST_DECISION == "PROSECUTORIAL DISCRETION - TERMINATED", "OTHER",
                                                                    ifelse(cases$LAST_DECISION == "PROSECUTORIAL DISCRETION - ADMIN CLOSE", "OTHER",      
                                                                           ifelse(cases$LAST_DECISION == "TEMPORARY PROTECTED STATUS", "OTHER",
                                                                                  ifelse(cases$LAST_DECISION == "REMOVE", "ORDERED DEPORTED",
                                                                                         ifelse(cases$LAST_DECISION == "TERMINATED", "OTHER", cases$LAST_DECISION))))))))))

# Create tables to count initial and final outcomes
final_outcomes <- table(cases$FINAL_OUTCOME) %>% as.data.frame()
final_outcomes <- final_outcomes %>% rename("OUTCOME" = "Var1",
                                          "FINALFREQ" = "Freq")
initial_outcomes <- table(cases$INITIAL_OUTCOME) %>% as.data.frame()
initial_outcomes <- initial_outcomes %>% rename("OUTCOME" = "Var1",
                                              "INITIALFREQ" = "Freq")

# Merge tables together
outcome_changes <- merge(final_outcomes,initial_outcomes,
                         by=c("OUTCOME"),
                         all.x = TRUE,
                         all.y = TRUE)

# Calculate change
outcome_changes$CHANGE <- (outcome_changes$FINALFREQ - outcome_changes$INITIALFREQ)
outcome_changes$PERCENTCHANGE <- (outcome_changes$CHANGE/outcome_changes$INITIALFREQ*100)

#######################################################################################################
##################################### APPEALS ANALYSIS ################################################
#######################################################################################################

# Join appeals with cases based on the IDNPROCEEDING ID
appeal_cases <- left_join(appeals, cases, by = "IDNPROCEEDING")
## Row count should stay the same == 44,291

# Remove duplicate columns
appeal_cases <- appeal_cases %>% 
  select(-IDNCASE.y, -JUDGE_NAME.y, -BASE_CITY.y)

# Rename columns
appeal_cases <- appeal_cases %>% rename(IDNCASE = IDNCASE.x,
                                        JUDGE_NAME = JUDGE_NAME.x,
                                        BASE_CITY = BASE_CITY.x)

# Get overall BIA outcomes
summary(appeal_cases)
## Judge decision overruled mean == .1271 ~ rate of 12.7 per 100 cases
## Judge decision upheld mean == 0.6283 ~ rate of 62.8 per 100 cases

# Analyze appeals by judge
judgeBIACount <- appeal_cases %>%
  group_by(JUDGE_NAME) %>%
  count()

# Calculate individual judge stats
judgeAppealStats <- appeal_cases %>%
  group_by(BASE_CITY,
           JUDGE_NAME) %>%
  summarise(DECISIONS_UPHELD = mean(BIA_UPHELD),
            DECISIONS_OVERRULED = mean(BIA_OVERRULED),
            DECISIONS_OTHER = mean(BIA_OTHER),
            BIANODECISION = mean(BIA_NODECISION),
            COUNT_APPEALS = n())

# Calculate how many judges get overruled in at least 1/5 of their appealed cases
onefifthoverruled <- judgeAppealStats %>% filter(DECISIONS_OVERRULED >= .2)
## Total == 113 judges who were overruled by the BIA in at least 1/5 of appealed cases

quantile(onefifthoverruled$COUNT_APPEALS)
#0%  25%  50%  75% 100% 
#3   25   45   75  506

# Eliminate skewed results and filter to judges with at least 25 appeal decisions
onefifthoverruled25 <- onefifthoverruled %>% filter(COUNT_APPEALS >= 25)
## Final total == 86 judges were overruled by the BIA in at least 1/5 of appealed cases

# Analyze judges with 25 appealed cases or more
twentyfivers <- judgeAppealStats %>% filter(COUNT_APPEALS >= 25)
## 394 judges had 25 or more cases appealed

quantile(twentyfivers$DECISIONS_OVERRULED)
# 0%        25%        50%        75%       100% 
#0.000    0.069      0.122       0.192     0.500 
## Overall reversal rate midpoint == 12.2 among judges with 25 or more appeals

# Merge judge stats with outcomes
outcomePlusAppeal <- left_join(judgeAppealStats,
                               outcomes,
                               by = c("BASE_CITY", ("JUDGE_NAME")))

# Filter appeal_cases to those where judge was overruled
judgeOverruled <- appeal_cases %>% filter(BIA_OVERRULED == 1)
## Row count == 5,629

# Who filed overruled cases?
table(judgeOverruled$APPEAL_FILED_BY)
# Alien  Both   DHS   Other 
# 4456   127    360    686 

# Remove appeals filed by DHS
judgeOverruled <- judgeOverruled %>% filter(APPEAL_FILED_BY != "DHS")
## Row count == 5,269

# How many overruled cases had attorneys?
table(judgeOverruled$APPEAL_REPPED)
#    0 (no attorney)    1 (had attorney)
#       778                 4491

# Compare that to how many had attorneys, among all appealed cases
table(appeal_cases$APPEAL_REPPED)
#    0 (no attorney)    1 (had attorney)
#       8803               35488 

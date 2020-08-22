
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
################################### LOGISTIC REGRESSION ###############################################
#######################################################################################################

library(stats)
# If judge used to work for ICE or INS
glmTest1 <- glm(ORDERED_DEPORTED ~ ICE_OR_INS,
                data = cases,
                family = "binomial")
summary(glmTest1)
exp(coef(glmTest1))

# (Intercept) ICE_OR_INS2 
# 0.8121963   1.3796972
## An applicant is 1.4 times more likely to be ordered deported if their judge used to work for ICE or INS.

# Is a detained asylum seeker in 5th circuit (Texas) more likely to be ordered deported than a non-detained in 2nd circuit (New York)?
# Filter to 2nd non-detained and 5th detained cases
c2V5 <- cases[(cases$CIRCUIT_COURT == 2 & cases$DETAINED == 0) | 
                    (cases$CIRCUIT_COURT == 5 & cases$DETAINED == 1),]

# Create new column for circuit courts we're testing
c2V5$c2 <- ifelse(c2V5$CIRCUIT_COURT == 2,1,0)
c2V5$c5 <- ifelse(c2V5$CIRCUIT_COURT == 5,1,0)

glmTest2 <- glm(ORDERED_DEPORTED ~ c2,
                data = c2V5,
                family = "binomial")

summary(glmTest2)
exp(coef(glmTest2))

# (Intercept)          c2 
# 3.5273834       0.1095966 

glmTest3 <- glm(ORDERED_DEPORTED ~ c5,
                data = c2V5,
                family = "binomial")

summary(glmTest3)
exp(coef(glmTest3))

# (Intercept)          c5 
# 0.3865894       9.1243676 

## A detained asylum seeker in the 5th circuit is 9.1 times more likely to be ordered deported than a non-detained applicant in the 2nd circuit.

# Is a detained asylum seeker in Texas more likely to be ordered deported than a nonedetained applicant in New York?
# Filter to 2nd non-detained and 5th detained cases
nyVtexas <- cases[(cases$STATE == "New York" & cases$DETAINED == 0) | (cases$STATE == "Texas" & cases$DETAINED == 1),]

# Create new column for circuit courts we're testing
nyVtexas$ny <- ifelse(nyVtexas$STATE == "New York",1,0)
nyVtexas$tex <- ifelse(nyVtexas$STATE == "Texas",1,0)

glmTest4 <- glm(ORDERED_DEPORTED ~ ny,
                data = nyVtexas,
                family = "binomial")

summary(glmTest4)
exp(coef(glmTest4))

# (Intercept)          ny 
# 3.4181524       0.1071201

glmTest5 <- glm(ORDERED_DEPORTED ~ tex,
                 data = nyVtexas,
                 family = "binomial")

summary(glmTest5)
exp(coef(glmTest5))

# (Intercept)         tex 
# 0.3661527       9.3353204 

## A detained asylum seeker in Texas is 9.3 times more likely to be ordered deported than a non-detained applicant in New York.

# Is and applicant from Somalia more or less likely to be granted asylum than someone from China?
# Filter to Somali and Chinese applicants
somaliaVchina <- cases %>% filter(NATIONALITY %in% c("CHINA", "SOMALIA"))

# Create new flagged column for Somalia
somaliaVchina$SOMALI <- ifelse(somaliaVchina$NATIONALITY == "SOMALIA",1,0)

# Create new flagged column for China
somaliaVchina$CHINESE <- ifelse(somaliaVchina$NATIONALITY == "CHINA",1,0)

glmTest6 <- glm(RELIEF_GRANTED ~ CHINESE,
                 data = somaliaVchina,
                 family = "binomial")

summary(glmTest6)
exp(coef(glmTest6))

# (Intercept)     Chinese 
# 0.8609941       2.2459560

glmTest7 <- glm(RELIEF_GRANTED ~ SOMALI,
                 data = somaliaVchina,
                 family = "binomial")

summary(glmTest7)
exp(coef(glmTest7))

# (Intercept)    Somalian 
# 1.9337549     0.4452447 

## Chinese applicants are 2.2 times more likely to be granted asylum than applicants from Somalia.

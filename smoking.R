
library(ggplot2)
library(data.table)
library(magrittr)
library(tidyr)
library(ggrepel)
library(patchwork)
library(ggrepel)
library(dplyr)

#Read the data

smoking_dt <- as.data.table(fread("extdata\\smoking.csv"))

#Exploratory Analysis

#Investigate Null Values

smoking[is.na(smoking), .N]

#Separate oral data in a different table

oral_dt <- smoking[oral == "Y", c('gender', 'age','dental caries', 'tartar', 'smoking')]
oral_dt

#set order
oral_dt <- setorder(oral_dt, cols="age")
oral_dt

#change column name
colnames(oral_dt)[3] <- "caries"
oral_dt


#Investigate different ages
ages <- oral_dt[, sort(unique(age))]
ages
#20 25 30 35 40 45 50 55 60 65 70 75 80 85

min_age <- oral_dt[, min(age)]

#min age = 20

max_age <- oral_dt[, max(age)]
max_age

#max age = 85

mean_age <- oral_dt[, round(mean(age))]
mean_age

#mean_age = 44

sd_age <- oral_dt[, round(sd(age))]
sd_age

#standard deviation = 12


#Analysis per Gender

number_of_women <- oral_dt[gender == "F", .N]

#number of women = 20291

number_of_men <- oral_dt[gender == "M", .N]

#number of men = 35401

proportion_of_women <- round(n_women/nrow(oral_dt)*100)
proportion_of_women

#proportion of women = 36%

proportion_of_men <- round(n_men/nrow(oral_dt)*100)
proportion_of_men

#proportion of men = 64%

#Bar plot
dist_gender <- ggplot(oral_dt, aes(gender, color = factor(gender), fill = factor(gender))) + geom_bar() + labs(x = "Gender", y = "Number of people", title = "Distribution per Gender")
dist_gender

#Analysis per age

#Goal: investigate the quantitative distribution of the variables per age

#Data transformation
ages <- oral_dt[, .N, by = age]
ages[, caries := oral_dt[caries == "1",.N, by = age]$N][, no_caries := oral_dt[caries == "0",.N, by = age]$N][,
                         tartar := oral_dt[tartar == "Y",.N, by = age]$N][, 
                         no_tartar := oral_dt[tartar == "N",.N, by = age]$N][, 
                         smoking := oral_dt[smoking == "1",.N, by = age]$N][, 
                         no_smoking := oral_dt[smoking == "0",.N, by = age]$N][,
                         males := oral_dt[gender == "M",.N, by = age]$N]
females <- oral_dt[gender == "F", .N, by = age]
ages <- merge(ages, females, by = 'age', all = TRUE)
colnames(ages)[2]  <- "total"
colnames(ages)[10]  <- "females"
setcolorder(ages, c("age","females","males","caries", "no_caries", "tartar", "no_tartar", "smoking", "no_smoking", "total"))

#Replacement of Null Values for '0'
ages <- ages %>% replace_na(list(females = 0))
ages[is.na(age), .N]

#Table 1: Number of observations per Age

ages


#Sample distribution per age

#Visualization


ages_plot <- ggplot(ages, aes(age, total, color = factor(age), fill = factor(age))) + geom_col() + labs(x = "Number of People", y = "Age", title = "Sample Distribution per Age")
ages_plot

women_plot <- ggplot(ages, aes(age, females, color = factor(age), fill = factor(age))) + geom_col() + labs(x = "Number of Women", y = "Age", title = "Women's Distribution per Age")
women_plot

men_plot <- ggplot(ages, aes(age, males, color = factor(age), fill = factor(age))) + geom_col() + labs(x = "Number of Women", y = "Age", title = "Men's Distribution per Age")
men_plot


ages_plot/women_plot/men_plot

#Statistical Analysis of Ages

boxplot_gender <- ggplot(oral_dt, aes(gender, age)) + geom_boxplot() + labs(x = "Gender", y = "Mean Age")
boxplot_gender

#Welch-test

#Ho: true difference in means between group F and group M is equal to 0

#H1: true difference in means between group F and group M is not equal to 0

welch_test_ages <- t.test(age ~ gender, oral_dt)
welch_test_ages$p.value #P-value = 0

#The Welch test suggests that the difference in ages between both men and women is statistically significant

#Analysis of Smokers per Gender

smokers_per_gender <- ggplot(oral_dt, aes(smoking, color = factor(smoking), fill = factor(smoking))) + geom_bar(width = 0.5) + facet_wrap(~gender) + labs(x ="1 = Smoker, 0 = Non Smoker", y = "Number of People", title = "Number of Smokers per Gender")
smokers_per_gender

#The plots shows that a considerably large number of men smoke

#Let's test it!

#Since both variables are binary I apply Fischer test

smokers <- oral_dt[smoking == "1", .(smokers = .N), by = gender]
non_smokers <- oral_dt[smoking == "0", .(non_smokers = .N), by = gender]
cont_smoking <- merge(smokers, non_smokers, by = "gender")
cont_smoking
cont_smoking[, gender := NULL]
cont_smoking

#     gender smokers non_smokers  odds
#1:      F     859       19432    0.04420543
#2:      M   19596       15805    1.239861
#                                 0.03565355

fisher.test(cont_smoking, alternative = "less")$p.value

#The data suggest that is more likely that a man smokes

#Analysis of Caries per gender

caries_per_gender <- ggplot(oral_dt, aes(caries, color = factor(caries), fill = factor(caries))) + geom_bar(width = 0.5) + facet_wrap(~gender) + labs(x ="1 = Caries, 0 = No Caries", y = "Number of People", title = "Analysis of Caries per Gender")
caries_per_gender

#Fischer test

caries <- oral_dt[caries == "1", .(caries = .N), by = gender]
non_caries <- oral_dt[caries == "0", .(non_caries = .N), by = gender]
cont_caries <- merge(caries, non_caries, by = "gender")
cont_caries
cont_caries[, gender := NULL]
cont_caries


#     gender caries non_caries
#1:      F   3402      16889
#2:      M   8479      26922


fisher.test(cont_caries, alternative = "less")$p.value #P-value = 7.579532e-91

#The data suggests that men are more likely to have caries

#Analysis Tartar per Gender

tartar_per_gender <- ggplot(oral_dt, aes(tartar, color = factor(tartar), fill = factor(tartar))) + geom_bar(width = 0.5) + facet_wrap(~gender) + labs(x ="Y = Tartar, N = No Tartar", y = "Number of People")
tartar_per_gender

#Fischer test

tartar <- oral_dt[tartar == "Y", .(tartar = .N), by = gender]
non_tartar <- oral_dt[tartar == "N", .(non_tartar = .N), by = gender]
cont_tartar <- merge(tartar, non_tartar, by = "gender")
cont_tartar
cont_tartar[, gender := NULL]
cont_tartar

#   gender tartar non_tartar  odds
#1:      F  10534       9757 1.079635
#2:      M  20406      14995 1.360854
#                            0.7933514

#Fisher test

fisher.test(cont_tartar, alternative = "less")$p.value

#The data suggests that men are more likely to have tartar


#Relationship Smoking/Caries


smoking_caries <- ggplot(oral_dt, aes(caries, color = factor(caries), fill = factor(caries))) + geom_bar(width = 0.5) + facet_wrap(~smoking) + labs(x ="0 = Non Smokers, 1 = Smokers", y = "Number of people", title = "Analysis of caries on smoking")
smoking_caries

#The number of smokers and non-smokers with caries is very similar

#Fisher test

caries <- oral_dt[caries == "1", .(caries = .N), by = smoking]
no_caries <- oral_dt[caries == "0", .(no_caries = .N), by = smoking]
cont_caries_smoking <- merge(caries, no_caries, by = "smoking")
cont_caries_smoking
cont_caries_smoking[, smoking := NULL]
cont_caries_smoking

#     smoking caries no_caries
#1:       0   6375     28862
#2:       1   5506     14949

fisher.test(cont_caries_smoking, alternative = "less")$p.value #P-value = 3.453742e-130

#The data suggests that smokers are more likely to have caries. 

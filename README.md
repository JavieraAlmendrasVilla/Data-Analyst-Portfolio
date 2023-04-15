# Data Analyst Portfolio

## About

Hello! My name is Javiera Almendras Villa, and I hold a Doctor of Dental Surgery degree from the Universidad de la Frontera in Chile, as well as a Bachelor of Science (B.Sc) degree in International Business and Economics from the Otto-von-Guericke University of Magdeburg in Germany. Currently, I am pursuing a Master of Science (M.Sc) degree in Management and Technology with a specialization in Operations and Supply Chain Management and Computer Engineering at the Technical University of Munich in Germany.

## Table of Content
- [Body effects of smoking](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking.R)
## Portfolio Projects

### Body effects of smoking
*code:* [Smoking-data](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking.R)<br>
*source:* [Goverment of South Korea](https://www.kaggle.com/datasets/kukuroo3/body-signal-of-smoking)<br>

**Description:** The entire dataset contains health data with a total of 55692 observations and 27 variables. For this project, I specifically investigated the variables related to oral health.<br>
*age*: 5-years gap<br>
*gender*: femenine / masculine<br>
*caries*: dental caries<br>
*tartar*: tartar status<br>
*smoking*: smoking status<br>

**Skills:** Data cleansing, data visualization, descriptive statistics, hypothesis testing, analysis of binary variables, Welch's t-test, Fisher's exact test.<br>
**Technology:** R programming language using tidyr, magrittr, and data.table libraries for data manipulation and ggplot2 library for visualization.<br>
**Results:** The analysis of the data indicates that, overall, men and individuals who smoke are more prone to develop caries.<br>
**Analysis:**<br>

Reading the data:
```r
head(smoking_dt)
```

  | ID  | gender | age  |  height(cm) | weight(kg) | waist(cm) | eyesight(left) | eyesight(right) | hearing(left) | hearing(right) | systolic | relaxation | 
  | ----|--------| ---- |------------ | -----------| ----------| -------------  | --------------- |-------------- |----------------|----------|------------|
1:|  0  |    F   |  40  |     155     |     60     |    81.3   |       1.2      |       1.0       |       1       |        1       |    114   |     73     |
2:|  1  |    F   |  40  |     160     |     60     |    81.0   |       0.8      |       0.6       |       1       |        1       |    119   |     70     |        
3:|  2  |    M   |  55  |     170     |     60     |    80.0   |       0.8      |       0.8       |       1       |        1       |    138   |     86     | 
4:|  3  |    M   |  40  |     165     |     70     |    88.0   |       1.5      |       1.5       |       1       |        1       |    100   |     60     |
5:|  4  |    F   |  40  |     155     |     60     |    86.0   |       1.0      |       1.0       |       1       |        1       |    120   |     74     |
6:|  5  |    M   |  30  |     180     |     75     |    85.0   |       1.2      |       1.2       |       1       |        1       |    128   |     76     |               

  | Cholesterol | triglyceride | HDL | LDL | hemoglobin | Urine protein serum | creatinine | AST | ALT | Gtp | oral | dental caries | tartar | smoking |
  | ------------|--------------| ----| ----|------------|---------------------|------------|-----|-----|-----|------|---------------|--------|---------|   
1:|     215     |      82      |  73 | 126 |    12.9    |          1          |     0.7    |  18 |  19 |  27 |   Y  |        0      |    Y   |    0    |
2:|     192     |     115      |  42 | 127 |    12.7    |          1          |     0.6    |  22 |  19 |  18 |   Y  |        0      |    Y   |    0    |
3:|     242     |     182      |  55 | 151 |    15.8    |          1          |     1.0    |  21 |  16 |  22 |   Y  |        0      |    N   |    1    |
4:|     322     |     254      |  45 | 226 |    14.7    |          1          |     1.0    |  19 |  26 |  18 |   Y  |        0      |    Y   |    0    |
5:|     184     |      74      |  62 | 107 |    12.5    |          1          |     0.6    |  16 |  14 |  22 |   Y  |        0      |    N   |    0    |
6:|     217     |     199      |  48 | 129 |    16.2    |          1          |     1.2    |  18 |  27 |  33 |   Y  |        0      |    Y   |    0    |
 

First, I separated the oral data into a different table called ``` oral_dt ```

```r
oral_dt <- smoking[oral == "Y", c('gender', 'age','dental caries', 'tartar', 'smoking')]

#set order
oral_dt <- setorder(oral_dt, cols="age")

#change column name
colnames(oral_dt)[3] <- "caries"
```
```r
head(oral_dt)
```
|    | gender   | age   | caries  | tartar   | smoking   |
|---:|:--------:|:-----:|:-------:|:--------:|:---------:|
| 1  | M        | 20    | 0       | Y        | 1         |
| 2  | M        | 20    | 0       | N        | 0         |
| 3  | M        | 20    | 0       | N        | 0         |
| 4  | M        | 20    | 0       | Y        | 1         |
| 5  | M        | 20    | 1       | Y        | 0         |
| 6  | M        | 20    | 0       | Y        | 0         |

Secondly, I performed an nnalysis per gender

```r
number_of_women <- oral_dt[gender == "F", .N]
```
Number of women = 20291
```r
number_of_men <- oral_dt[gender == "M", .N]
```
Number of men = 35401
```r
proportion_of_women <- round(n_women/nrow(oral_dt)*100)
```
Proportion of women = 36%
```r
proportion_of_men <- round(n_men/nrow(oral_dt)*100)
```
Proportion of men = 64%

I found that the data is imbalanced towards men with a 64% of males.
This is clearly depicted in the following bar plot:

```r
dist_gender <- ggplot(oral_dt, aes(gender, color = factor(gender), fill = factor(gender))) + geom_bar() + labs(x = "Gender", y = "Number of people", title = "Distribution per Gender")
```

**Distribution of the sample per gender**

![Distribution of the sample per gender](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/Dist%20per%20gender.jpeg)

This boxplot shows the difference between the mean age of females and males

![difference in mean ages](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/boxplot%20gender.jpeg)

Furthermore, I tested the statistical significance of the mean age using the Welch-test.

```r
#Welch-test
#Ho: true difference in means between group F and group M is equal to 0
#H1: true difference in means between group F and group M is not equal to 0

welch_test_ages <- t.test(age ~ gender, oral_dt)
welch_test_ages$p.value #P-value = 0
```
The Welch test supports the hypothesis that the difference in ages between men and women is statistically significant.

Next, I investigasted the sample distribution per age and the number of smokers per gender

```r
ages_plot <- ggplot(ages, aes(age, total, color = factor(age), fill = factor(age))) + geom_col() + labs(x = "Number of People", y = "Age", title = "Sample Distribution per Age")

women_plot <- ggplot(ages, aes(age, females, color = factor(age), fill = factor(age))) + geom_col() + labs(x = "Number of Women", y = "Age", title = "Women's Distribution per Age")

men_plot <- ggplot(ages, aes(age, males, color = factor(age), fill = factor(age))) + geom_col() + labs(x = "Number of Women", y = "Age", title = "Men's Distribution per Age")

ages_plot/women_plot/men_plot
```
**Distribution per Gender**

![Distribution per Gender](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/3%20ages%20plot.jpeg)

**Distribution of Smokers per Gender**

![smokers per gender](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking-plot_smokers_per_gender.jpeg)


Moreover, I anlized the prevalence of Caries per gender

```r
caries_per_gender <- ggplot(oral_dt, aes(caries, color = factor(caries), fill = factor(caries))) + geom_bar(width = 0.5) + facet_wrap(~gender) + labs(x ="1 = Caries, 0 = No Caries", y = "Number of People", title = "Analysis of Caries per Gender")
```

**Distribution of Caries per Gender**

![caries per gender](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking-caries_per_gender.jpeg)

The plots show a similar prevalence of caries among both genders. Therefore, I applied the Fisher test to examine the likelihood that one gender is more likely to develop caries.

```r
#Fischer test

caries <- oral_dt[caries == "1", .(caries = .N), by = gender]
non_caries <- oral_dt[caries == "0", .(non_caries = .N), by = gender]
cont_caries <- merge(caries, non_caries, by = "gender")
cont_caries[, gender := NULL]

#     gender caries non_caries
#1:      F   3402      16889
#2:      M   8479      26922

fisher.test(cont_caries, alternative = "less")

Fisher's Exact Test for Count Data

data:  cont_caries
p-value < 2.2e-16
alternative hypothesis: true odds ratio is less than 1
95 percent confidence interval:
 0.0000000 0.6638809
sample estimates:
odds ratio 
 0.6395845 

```
The Fisher test concludes that men are more likely to have caries.

Lastly, I examined the relationship between smoking and having caries.

```r
smoking_caries <- ggplot(oral_dt, aes(caries, color = factor(caries), fill = factor(caries))) + geom_bar(width = 0.5) + facet_wrap(~smoking) + labs(x ="0 = Non Smokers, 1 = Smokers", y = "Number of people", title = "Analysis of caries on smoking")

```

![caries on smoking](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking-plot_caries_on_smoking.jpeg)

The plots show that the number of individuals with caries among smokers and non-smokers is similar, although the proportion of non-smokers without caries is much larger. I applied the Fisher test to compare the likelihood of having caries between both samples.

```r
#Fisher test

caries <- oral_dt[caries == "1", .(caries = .N), by = smoking]
no_caries <- oral_dt[caries == "0", .(no_caries = .N), by = smoking]
cont_caries_smoking <- merge(caries, no_caries, by = "smoking")
cont_caries_smoking[, smoking := NULL]

#     smoking caries no_caries
#1:       0   6375     28862
#2:       1   5506     14949

fisher.test(cont_caries_smoking, alternative = "less")$p.value #P-value = 3.453742e-130

Fisher's Exact Test for Count Data

data:  cont_caries_smoking
p-value < 2.2e-16
alternative hypothesis: true odds ratio is less than 1
95 percent confidence interval:
 0.0000000 0.6208944
sample estimates:
odds ratio 
 0.5996702 
```

The test supports the hypothesis that there is a significant association between smoking and the development of caries, with smokers being more likely to have caries compared to non-smokers.

see the [*full code*](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking.R)













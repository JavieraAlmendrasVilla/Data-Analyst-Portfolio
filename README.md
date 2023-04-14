# Data Analyst Portfolio

## About

Hello! My name is Javiera Almendras Villa, and I hold a Doctor of Dental Surgery degree from the Universidad de la Frontera in Chile, as well as a Bachelor of Science (B.Sc) degree in International Business and Economics from the Otto-von-Guericke University of Magdeburg in Germany. Currently, I am pursuing a Master of Science (M.Sc) degree in Management and Technology with a specialization in Operations and Supply Chain Management and Computer Engineering at the Technical University of Munich in Germany.

## Table of Content
- [Body effects of smoking](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking.R)
## Portfolio Projects

### Body effects of smoking
*code:* [Smoking-data](https://github.com/JavieraAlmendrasVilla/Data-Analyst-Portfolio/blob/main/smoking.R)<br>
*source:* [Goverment of Korea](https://www.kaggle.com/datasets/kukuroo3/body-signal-of-smoking)<br>

**Description:** The entire dataset contains health data with a total of 55692 obsvervations and 27 variables. In this project I investigated the variables for Oral health.<br>
*age*: 5-years gap<br>
*gender*: femenine / masculine<br>
*caries*: dental caries<br>
*tartar*: tartar status<br>
*smoking*: smoking status<br>
**Skills:** data cleaning, data visualization, descriptive statistics, hipothesis testing, analysis of binary variables, Fisher test.<br>
**Technology:** R<br>
**Results:** The data suggest that men and smokers in general are more likely to have caries.<br>
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
 
 
```r
#Separate oral data in a different table:
oral_dt <- smoking[oral == "Y", c('gender', 'age','dental caries', 'tartar', 'smoking')]
oral_dt

#set order
oral_dt <- setorder(oral_dt, cols="age")
oral_dt

#change column name
colnames(oral_dt)[3] <- "caries"
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

Analysis per Gender

```r
#Analysis per Gender
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
```r
#Bar plot
dist_gender <- ggplot(oral_dt, aes(gender, color = factor(gender), fill = factor(gender))) + geom_bar() + labs(x = "Gender", y = "Number of people", title = "Distribution per Gender")
dist_gender
```
















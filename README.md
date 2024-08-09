# BigDataAnalytics_NeuralNetworkML
---
Author: "Quan Duong"
---

## Problem Statement

Tayko Software is a software catalog firm that sells games and educational software. It started as a software manufacturer and then added third-party titles to its offerings. It recently revised its collection of items in a new catalog, which it mailed out to its customers. This mailing yielded 2000 purchases. Based on these data, Tayko wants to devise a model predicting whether a new customer will make a purchase when they receive the new catalog.

## Import library and import the data set

```{r Purchase}
library(randomForest)
library(neuralnet)
library(caret)

Tayko.df <- read.csv("C:\\Users\\duong\\OneDrive\\Desktop\\QUAN\\Spring 2024\\Big Data Analytics\\CIS4930_CSV_Tayko.csv")
Tayko.df <- subset(Tayko.df, select=-c(id)) ##Remove variable id from the imported data because we will not use it as a predictor. 
Tayko.df$Purchase <- as.factor(Tayko.df$Purchase)
```

### Data partition using a 6:4 ratio

```{r}
train.index <- sample(c(1:dim(Tayko.df)[1]), dim(Tayko.df)[1]*0.6)  
train.df <- Tayko.df[train.index, ]
valid.df <- Tayko.df[-train.index, ]
```

## Logistic Regression

```{r}
lr <- glm(as.factor(Purchase) ~ ., data = train.df, family = "binomial") 
# Prediction: Logistic Regression
lr.pred.prob <- predict(lr, valid.df, type ="response")
lr.pred <-ifelse(lr.pred.prob > 0.5, 1, 0)
```

##Confusion Matrix Evaluation

```{r}
confusionMatrix(as.factor(lr.pred), as.factor(valid.df$Purchase))

```

## Neural Network

```{r}
nn <- neuralnet(as.factor(Purchase) ~ ., data = train.df, hidden = 5, stepmax=1e5)
# Prediction: Neural Network
nn.pred.results <- compute(nn, valid.df)
nn.pred.prob<-nn.pred.results$net.result[,2]
nn.pred <-ifelse(nn.pred.prob > 0.5, 1, 0)
```

Confusion Matrix Evaluation

```{r}
confusionMatrix(as.factor(nn.pred), as.factor(valid.df$Purchase))
```

## Model Performance Comparison

We have developed two models, a logistic regression model and a neural network model, to predict customer purchases for Tayko. Here, we compare the performance of both models based on their confusion matrices.

### Logistic Regression Model Performance

-   **Accuracy**: 76.12%
-   **Sensitivity (True Positive Rate)**: 79.64%
-   **Specificity (True Negative Rate)**: 72.82%
-   **Positive Predictive Value (PPV)**: 73.40%
-   **Negative Predictive Value (NPV)**: 79.16%

### Neural Network Model Performance

-   **Accuracy**: 75.5%
-   **Sensitivity (True Positive Rate)**: 78.61%
-   **Specificity (True Negative Rate)**: 72.57%
-   **Positive Predictive Value (PPV)**: 72.97%
-   **Negative Predictive Value (NPV)**: 78.27%

### Comparison and Conclusion

The logistic regression model shows slightly better performance in terms of accuracy, sensitivity, specificity, and predictive values. However, the difference in performance metrics between the two models is minimal.

### Expected Success in Terms of Customer Purchase

If Tayko selects 100 new customers classified as "purchase" by each model and sends them new catalogs, the expected number of customers who will purchase Tayko products according to each model's PPV is as follows:

-   **Logistic Regression Model**: Approximately 72.9 of the 100 customers targeted are expected to make a purchase.
-   **Neural Network Model**: Approximately 73.4 of the 100 customers targeted are expected to make a purchase.

Both models show similar performance metrics, with the logistic regression model showing a marginally better performance in accuracy, sensitivity, specificity, and predictive values. However, the difference in expected successful purchases (based on PPV) between the two models is minimal, with both models expected to yield around 73 successful purchases out of 100 targeted customers.

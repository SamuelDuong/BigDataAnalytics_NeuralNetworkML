install.packages("forecast")
library("forecast")
#rm(list = ls())

Tayko.df <- read.csv("data_file_path.csv")
dim(Tayko.df)
names(Tayko.df)

# select variables for regression
selected.var <- c("Spending","Address_US","Freq","last_update",
                  "Web","Gender","Address_RES")

# partition data
set.seed(1)  # set seed for reproducing the partition
train.index <- sample(c(1:2000), 1200)  
train.df <- Tayko.df[train.index, selected.var]
valid.df <- Tayko.df[-train.index, selected.var]
dim(train.df)
dim(valid.df)

Tayko.lm <- lm(Spending ~ Freq, data = train.df)
summary(Tayko.lm)

Tayko.lm <- lm(Spending ~ last_update, data = train.df)
summary(Tayko.lm)


Tayko.lm <- lm(Spending ~ ., data = train.df)
summary(Tayko.lm)

Tayko.lm.pred <- predict(Tayko.lm, valid.df)
accuracy(Tayko.lm.pred, valid.df$Spending)


#histogram

all.residuals <- valid.df$Spending - Tayko.lm.pred
par(mfrow = c(1, 1))
hist(all.residuals, breaks = 50, xlab = "Residuals", main = "")


# Variable selection
Tayko.lm.step <- step(Tayko.lm, direction = "backward")
sum_back<-summary(Tayko.lm.step)

null<-lm(Spending~1, data=train.df)    #For Forward Selection, you need to start with a null model without any predictors
Tayko.lm.step <-step(null, scope=list(lower=null, upper=Tayko.lm), direction="forward")
sum_for<-summary(Tayko.lm.step)


Tayko.lm.step <-step(null, scope=list(lower=null, upper=Tayko.lm), direction="both")
sum_both<-summary(Tayko.lm.step)











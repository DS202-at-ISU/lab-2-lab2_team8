library(tidyverse)
library(caret)
library(party)

library(classdata)

View(ames)
str(ames)
dim(ames)

# see if any NA values
sapply(ames, function(x) table(is.na(x)))

# Remove parcel id and address cuz they useless,
# sale date might also useless
# Remove multi sale column 6469 NAs!!
# Remove `FinishedBsmtArea (sf)` for now cuz so many NAs (2200 rows)
# deal with it later like can we interpolate those values?

ames_clean <- subset(ames, select = -c(`Parcel ID`, Address, `Sale Date`, `Multi Sale`, `FinishedBsmtArea (sf)`))

# for other NAs, remove only rows having NA cuz not that many

ames_clean <- filter(ames_clean, `Sale Price` > 25000 & `Sale Price` <= 1000000
                                 , !is.na(YearBuilt) & YearBuilt > 1850
                                 , !is.na(Acres) & Acres > 0 & Acres < 5
                                 , `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000
                                 #, `FinishedBsmtArea (sf)` < 2000 # Don't uncomment cuz we deleted this column
                                 , !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000
                                 , !is.na(Style) & !is.na(Occupancy) & !is.na(Bedrooms) & Bedrooms != 0 & Neighborhood != "(0) None")


# Change AC, Fireplace, and Bedrooms to Factor
ames_clean$AC <- factor(ames_clean$AC)
ames_clean$FirePlace <- factor(ames_clean$FirePlace)
ames_clean$Bedrooms <- factor(ames_clean$Bedrooms)
# Feature Engineering
ames_clean <- ames_clean %>% mutate(
  PriceClass = NA,
  PriceClass = if_else(`Sale Price` > 25000  & `Sale Price` <= 125000,
                   1, PriceClass),
  PriceClass = if_else(`Sale Price` > 125000 & `Sale Price` <= 400000,
                   2, PriceClass),
  PriceClass = if_else(`Sale Price` > 400000 & `Sale Price` <= 550000,
                   3, PriceClass),
  PriceClass = if_else(`Sale Price` > 550000 & `Sale Price` <= 750000,
                   4, PriceClass),
  PriceClass = if_else(`Sale Price` > 750000 & `Sale Price` <= 1000000,
                   5, PriceClass)
)
ames_clean$PriceClass <- factor(ames_clean$PriceClass)

ames_test <- ames_clean

View(ames_test)

#ames_test[sapply(ames_test, is.factor)] <- sapply(ames_test[sapply(ames_test, is.factor)], unclass)
#ames_test[sapply(ames_test, is.factor)] <- data.matrix(ames_test[sapply(ames_test, is.factor)])

for (i in colnames(ames_test)){
  if(is.factor(unlist(ames_test[i]))){
    ames_test[paste(i,"new")] <- unclass(unlist(ames_test[i]))
    #ames_test[paste(i,"new")] <- as.numeric(unclass(unlist(ames_test[i])))
  }
}

# This guy just for visualization of only QUANTITATIVE, Won't work if CATEGORICAL
# So filter out CATEGORICAL by like keep(ames_clean, is.numeric)
# apparently keep(function(x) is.numeric(x) | is.integer()) not needed cuz
# apparently just is.numeric passes num and int
ames_test %>% keep(is.numeric) %>% gather() %>%
  ggplot(aes(x=value)) +
  geom_histogram(fill="steelblue", alpha=.7) +
  theme_minimal() +
  facet_wrap(~key, scales="free")

# apparently just is.numeric passes num and int??? so using is double for only original QUANTITATIVE
# also cor does between exact same type, so only double X double or int X int, can't mix and match
# so either only new QUANT (which are CAT) or only orgignal QUANT
cor(ames_test %>% keep(is.double)) %>%
  as.data.frame %>% mutate(var2=rownames(.)) %>%
  pivot_longer(!var2, values_to = "value") %>%
  ggplot(aes(x=name,y=var2,fill=abs(value),label=round(value,2))) +
  geom_tile() + geom_label() + xlab("") + ylab("") +
  ggtitle("Correlation matrix of our predictors") +
  labs(fill="Correlation\n(absolute):")

# if you want mix n match then like this, essentially changing all new QUANT(our CAT) of type int as num
#ames_test2 <- ames_test
#ames_test2[sapply(ames_test2, is.numeric)] <- data.matrix(ames_test2[sapply(ames_test2, is.numeric)])
#cor(ames_test2 %>% keep(is.numeric)) %>%
#  as.data.frame %>% mutate(var2=rownames(.)) %>%
#  pivot_longer(!var2, values_to = "value") %>%
#  ggplot(aes(x=name,y=var2,fill=abs(value),label=round(value,2))) +
#  geom_tile() + geom_label() + xlab("") + ylab("") +
#  ggtitle("Correlation matrix of our predictors") +
#  labs(fill="Correlation\n(absolute):")

# plotting all Sale Price VS QUANT scatterplots together
ames_test %>% select_if(is.double) %>%
  pivot_longer(!`Sale Price`, values_to = "value") %>%
  ggplot(aes(x=value, y=`Sale Price`)) +
  geom_point() +
  theme_minimal() +
  facet_wrap(~name, scales="free")

# if wanna find average sale price per QUANT value, just for better graph, especially for year
#ames_test %>% select_if(is.double) %>%
#  pivot_longer(!`Sale Price`, values_to = "value") %>%
#  group_by(name, value) %>% summarise(avg_sale_price = mean(`Sale Price`)) %>%
#  ggplot(aes(x=value, y=avg_sale_price)) +
#  geom_point() +
#  theme_minimal() +
#  facet_wrap(~name, scales="free")


# plotting all Sale Price for CAT so histogram with fill or boxplots

# all histogram with fill in 1 plot
function_CAT_SalePrice <- function(x){
  x_CAT_n_1QUANT <- data.frame(matrix(ncol = 0, nrow = dim(x)[1]))
  x_CAT_n_1QUANT <- cbind(x_CAT_n_1QUANT, x['Sale Price'], select_if(x, is.factor))
  return (x_CAT_n_1QUANT)
}
ames_test %>% function_CAT_SalePrice() %>%
  pivot_longer(!`Sale Price`, values_to = "value") %>%
  ggplot(aes(x=`Sale Price`, fill=value)) + # can use x=log(`Sale Price`) to make distribution more normal
  geom_histogram(show.legend = FALSE) +
  facet_wrap(~name, scales="free")
# all boxplots with fill in 1 plot
ames_test %>% function_CAT_SalePrice() %>%
  pivot_longer(!`Sale Price`, values_to = "value") %>%
  ggplot(aes(y=`Sale Price`, x = value)) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(~name, scales="free")

# is preprocessing required for us?
# also preprocessing apparently only applied on x variables? y is outcome we wanna predict
# like acres, lotarea, totalliving area might need log?
# but then what about sale price? should that also be passed as log?
# like should we predict log of sale price as opposed to direct sale price?
# then we can also do e^log(saleprice) to get final sale price ig

ames_test$`Sale Price` <- log(ames_test$`Sale Price`)
ames_test$`LotArea(sf)` <- log(ames_test$`LotArea(sf)`)
ames_test$`TotalLivingArea (sf)` <- log(ames_test$`TotalLivingArea (sf)`)

# be very carefule if 0 in your values cuz you can't take log 0, well, log 0 is -Inf (negative infinite)
# so it messes computation if passing through ML model or using anywhere

set.seed(2024)
split <- sample(1:nrow(ames_test), as.integer(0.7*nrow(ames_test)), F)

train <- ames_test[split, ]
test  <- ames_test[-split,]

x_train <- train[,names(train) != "Sale Price"]
x_test  <- test [,names(test ) != "Sale Price"]

y_train <- unlist(train[,"Sale Price"])
y_test <- unlist(test[,"Sale Price"])

set.seed(2024)

tree1 <- party::ctree(y_train ~ ., data=cbind(x_train, y_train),
                      controls = ctree_control(minsplit=1, mincriterion = .01))
plot(tree1)

mod <- caret::train(x_train, y_train, method="rf",
                    tuneGrid = expand.grid(mtry = seq(1,ncol(x_train),by=1)),
                    trControl = trainControl(method="cv", number=2, verboseIter = T))
mod

plot(varImp(mod), main="Feature importance of random forest model on training data")

predictions <- predict(mod, newdata = x_test)
#confusionMatrix(predictions, y_test) # for CAT, NOT QUANT

dff <- cbind(predictions, y_test)

as.data.frame(dff) %>% ggplot(aes(x = predictions, y = y_test)) + geom_point() + geom_abline(aes(intercept = 0 , slope = 1))


#--------------------------


mean(ames_clean$`Sale Price`)
median(ames_clean$`Sale Price`)
ggplot(ames_clean, aes(`Sale Price`)) + geom_histogram(binwidth = 10000)
ggplot(as.data.frame(dff), aes(predictions)) + geom_histogram(binwidth = 10000)

as.data.frame(dff) %>% gather() %>%
  ggplot(aes(x=value)) +
  geom_histogram(fill="steelblue", alpha=.7) +
  theme_minimal() +
  facet_wrap(~key, scales="free")

# RNN, RSTM, Transformers, ARIMA for time series forecasting
# do distance from 45 degree line analysis to get bounds to see patterns of remaining outliers

# outlier analysis
ames_outliers <- filter(ames, `Sale Price` > 10000 & `Sale Price` < 100000
                        , !is.na(Acres) & Acres > 0 #& Acres < 5
                        )

ames_outliers$Bedrooms <- factor(ames_outliers$Bedrooms)

# PRICE WITH QUANT
ames_outliers %>% keep(is.numeric) %>% gather() %>%
  ggplot(aes(x=value)) +
  geom_histogram(fill="steelblue", alpha=.7) +
  theme_minimal() +
  facet_wrap(~key, scales="free")

ames_outliers %>% select_if(is.numeric) %>%
  pivot_longer(!`Sale Price`, values_to = "value") %>%
  ggplot(aes(x=value, y=`Sale Price`)) +
  geom_point() +
  theme_minimal() +
  facet_wrap(~name, scales="free")

# all boxplots with fill in 1 plot PRICE WITH CAT
ames_outliers %>% function_CAT_SalePrice() %>%
  pivot_longer(!`Sale Price`, values_to = "value") %>%
  ggplot(aes(y=`Sale Price`, x = value)) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(~name, scales="free")

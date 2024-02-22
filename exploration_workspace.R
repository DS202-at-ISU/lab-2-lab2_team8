library(tidyverse)
library(ggplot2)
library(classdata)

View(ames)
str(ames)
dim(ames)

# There are 16 columns
# Parcel ID: Useless, just an identifier
# Address: Kinda Useless?
# Style: IMPORTANT, CATEGORICAL
# Occupancy: IMPORTANT, CATEGORICAL
# Sale Date: Maybe important? for time series analysis? most likely QUANTITATIVE
# Sale Price: IMPORTANT, QUANTITATIVE (MAIN VARIABLE)
# Multi Sale: Maybe Important? CATEGORICAL (mostly NAs tho, watch out!)
# YearBuilt: Maybe important? for time series analysis? most likely QUANTITATIVE
# Acres: IMPORTANT, QUANTITATIVE
# TotalLivingArea (sf): IMPORTANT, QUANTITATIVE
# Bedrooms: IMPORTANT, CATEGORICAL
# FinishedBsmtArea (sf): IMPORTANT, QUANTITATIVE
# LotArea(sf): IMPORTANT, QUANTITATIVE
# AC: IMPORTANT, CATEGORICAL
# FirePlace: IMPORTANT, CATEGORICAL
# Neighborhood: IMPORTANT, CATEGORICAL

# "AC", "FirePlace", "Bedrooms", and "Multi Sale" are chr type
# Consider using factor() to convert them to categorical

# plotting bar charts for CATEGORICAL to see if anything interesting pops up
ggplot(data = ames, aes(Style)) + geom_bar() + coord_flip()
ggplot(data = ames, aes(Occupancy)) + geom_bar()
# multi_sale <- factor(ames$`Multi Sale`, exclude = NULL)
ggplot(data = ames, aes(factor(`Multi Sale`, exclude = NULL))) + geom_bar()
ggplot(data = ames, aes(factor(Bedrooms, exclude = 0))) + geom_bar() # use filter for removing NA values
ggplot(data = ames, aes(factor(AC, exclude = NULL))) + geom_bar()
ggplot(data = ames, aes(factor(FirePlace, exclude = NULL))) + geom_bar()
ggplot(data = ames, aes(Neighborhood)) + geom_bar() + coord_flip()





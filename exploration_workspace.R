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
# Has NA as a category so try filter
ggplot(data = filter(ames, !is.na(Style)), aes(Style)) + geom_bar() + coord_flip()

ggplot(data = ames, aes(Occupancy)) + geom_bar()

#ggplot(data = ames, aes(factor(`Multi Sale`, exclude = NULL))) + geom_bar()
# for some reason, this ^ guy doesn't always work on first try.
# Also, creates NA as a category when works
# try filter
ggplot(data = filter(ames, !is.na(`Multi Sale`)), aes(`Multi Sale`)) + geom_bar()

ggplot(data = ames, aes(factor(Bedrooms))) + geom_bar()
# Has 0 bedrooms and NA as category so use filter for removing NA values
# You may consider excluding 0 because 0 bedrooms might not make sense
ggplot(data = filter(ames, !is.na(Bedrooms)), aes(factor(Bedrooms))) + geom_bar()
ggplot(data = filter(ames, !is.na(Bedrooms)), aes(factor(Bedrooms, exclude = 0))) + geom_bar()

ggplot(data = ames, aes(factor(AC))) + geom_bar()
# I dont think AC has NA, use below if has NA
#ggplot(data = filter(ames, !is.na(AC)), aes(factor(AC))) + geom_bar()

ggplot(data = ames, aes(factor(FirePlace))) + geom_bar()
# I dont think FirePlace has NA, use below if has NA
# ggplot(data = filter(ames, !is.na(FirePlace)), aes(factor(FirePlace))) + geom_bar()

ggplot(data = ames, aes(Neighborhood)) + geom_bar() + coord_flip()





library(tidyverse)
library(ggplot2)
library(classdata)

View(ames)
str(ames)
dim(ames)

# TIP: see for each column if they have NA first
# by using anyNA() for each column

# There are 16 columns
# Parcel ID: Useless, just an identifier
# Address: Kinda Useless?
# Style: IMPORTANT, CATEGORICAL
# Occupancy: IMPORTANT, CATEGORICAL
# Sale Date: Maybe important? for time series analysis? most likely QUANTITATIVE
# Sale Price: IMPORTANT, QUANTITATIVE (MAIN VARIABLE)
# Multi Sale: Maybe Important? CATEGORICAL (mostly NAs tho, watch out!) Useless ig
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

####################################
# plotting bar charts for CATEGORICAL to see if anything interesting pops up
####################################

#ggplot(data = ames, aes(Style)) + geom_bar() + coord_flip()
# Has NA as a category so try filter
ggplot(data = filter(ames, !is.na(Style)), aes(Style)) + geom_bar() + coord_flip()

# Has NA as a category so try filter
ggplot(data = filter(ames, !is.na(Occupancy)), aes(Occupancy)) + geom_bar()

#ggplot(data = ames, aes(factor(`Multi Sale`))) + geom_bar()
# for some reason, this ^ guy doesn't always work on first try.
# Also, creates NA as a category when works
# try filter
ggplot(data = filter(ames, !is.na(`Multi Sale`)), aes(factor(`Multi Sale`))) + geom_bar()
ggplot(data = filter(ames, !is.na(`Multi Sale`)), aes(`Multi Sale`)) + geom_bar()
# no difference between 2 above cuz only Y, no N

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
# what's the deal with 0 none type neighborhood?
ggplot(data = filter(ames, Neighborhood != "(0) None"), aes(Neighborhood)) + geom_bar() + coord_flip()

####################################
# Let's try to plot some histograms for QUANTITATIVE
####################################

ggplot(data = ames, aes(`Sale Date`)) + geom_histogram()
# doesn't make sense to find range

#ggplot(data = filter(ames, `Sale Price` > 0 & `Sale Price` <= 10), aes(`Sale Price`)) + geom_histogram(binwidth = 0.5)
# there are few houses more than a million and they messing up histogram, too much right skew
# also there are some extremely cheap houses, like $1, $2, $3. what's the deal with those?
# uncomment above to see
# so lets choose range below
ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000)

ggplot(data = filter(ames, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1)
# need YearBuilt > 1850 cuz even tho no houses built before then, scale was from 0, so to adjust scale

ggplot(data = filter(ames, !is.na(Acres) & Acres > 2.5 & Acres < 5), aes(Acres)) + geom_histogram(binwidth = 0.025)
ggplot(data = filter(ames, !is.na(Acres) & Acres > 1 & Acres <= 2.5), aes(Acres)) + geom_histogram(binwidth = 0.01)
ggplot(data = filter(ames, !is.na(Acres) & Acres > 0 & Acres <= 1), aes(Acres)) + geom_histogram(binwidth = 0.005)
# need multiple Acre ranges cuz heavily skewed data; varying binwidths for better visualization

# from now on wont comment for justifying every single range and binwidth
ggplot(data = filter(ames, `TotalLivingArea (sf)` >= 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25)
ggplot(data = filter(ames, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25)

ggplot(data = filter(ames, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10)

ggplot(data = filter(ames, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100)

####################################
# Let's try to plot some histograms for QUANTITATIVE with CATEGORICAL fills to see trends
####################################
# CAN TRY CATEGORICAL WITH OTHER CATEGORICAL FILLS BUT MAY NOT BE USEFUL SINCE MAIN VARIABLE IS QUANTITATIVE


ggplot(data = ames, aes(`Sale Date`)) + geom_histogram()

ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000)

ggplot(data = filter(ames, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1)

ggplot(data = filter(ames, !is.na(Acres) & Acres > 2.5 & Acres < 5), aes(Acres)) + geom_histogram(binwidth = 0.025)
ggplot(data = filter(ames, !is.na(Acres) & Acres > 1 & Acres <= 2.5), aes(Acres)) + geom_histogram(binwidth = 0.01)
ggplot(data = filter(ames, !is.na(Acres) & Acres > 0 & Acres <= 1), aes(Acres)) + geom_histogram(binwidth = 0.005)

ggplot(data = filter(ames, `TotalLivingArea (sf)` >= 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25)
ggplot(data = filter(ames, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25)

ggplot(data = filter(ames, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10)

ggplot(data = filter(ames, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100)



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
#ggplot(data = filter(ames, !is.na(`Multi Sale`)), aes(`Multi Sale`)) + geom_bar()
# no difference between 2 above cuz only Y, no N

#ggplot(data = ames, aes(factor(Bedrooms))) + geom_bar()
# Has 0 bedrooms and NA as category so use filter for removing NA values
# You may consider excluding 0 because 0 bedrooms might not make sense
#ggplot(data = filter(ames, !is.na(Bedrooms)), aes(factor(Bedrooms))) + geom_bar()
ggplot(data = filter(ames, !is.na(Bedrooms)), aes(factor(Bedrooms, exclude = 0))) + geom_bar()

ggplot(data = ames, aes(factor(AC))) + geom_bar()
# I dont think AC has NA, use below if has NA
#ggplot(data = filter(ames, !is.na(AC)), aes(factor(AC))) + geom_bar()

ggplot(data = ames, aes(factor(FirePlace))) + geom_bar()
# I dont think FirePlace has NA, use below if has NA
# ggplot(data = filter(ames, !is.na(FirePlace)), aes(factor(FirePlace))) + geom_bar()

# ggplot(data = ames, aes(Neighborhood)) + geom_bar() + coord_flip()
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
# Let's try to plot some boxplots for QUANTITATIVE
####################################

# remember to ignore NAs for categorical when filling
ames_clean_Style <- filter(ames, !is.na(Style))
ames_clean_Occupancy <- filter(ames, !is.na(Occupancy))
ames_clean_Bedrooms <- filter(ames, !is.na(Bedrooms) & Bedrooms != 0)
ames_clean_Neighborhood <- filter(ames, Neighborhood != "(0) None")
# instead, can also do general like below (but it'll have few rows, above style is for if we only care about particular categorical)
#ames_clean <- filter(ames, !is.na(Style) & !is.na(Occupancy) & !is.na(Bedrooms) & Bedrooms != 0 & Neighborhood != "(0) None")

ggplot(data = ames, aes(`Sale Date`)) + geom_boxplot()

# Sale Price boxplots

# Use below style if wanna have separate graph for each boxplot
#ggplot(data = filter(ames_clean_Style, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_boxplot() + facet_wrap(~Style)
# Use below style if wanna have all boxplots for various categories in 1 graph
ggplot(data = filter(ames_clean_Style, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, y = Style)) + geom_boxplot()#GOOD

#ggplot(data = filter(ames_clean_Occupancy, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_boxplot() + facet_wrap(~Occupancy)
ggplot(data = filter(ames_clean_Occupancy, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, y = Occupancy)) + geom_boxplot()#GOOD

#ggplot(data = filter(ames_clean_Bedrooms, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_boxplot() + facet_wrap(~factor(Bedrooms))
ggplot(data = filter(ames_clean_Bedrooms, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, y = factor(Bedrooms))) + geom_boxplot()#GOOD

#ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_boxplot() + facet_wrap(~factor(AC))
ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, y = factor(AC))) + geom_boxplot()

#ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_boxplot() + facet_wrap(~factor(FirePlace))
ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, y = factor(FirePlace))) + geom_boxplot()

#ggplot(data = filter(ames_clean_Neighborhood, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_boxplot() + facet_wrap(~Neighborhood)
#ggplot(data = filter(ames_clean_Neighborhood, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, x = Neighborhood)) + geom_boxplot()
ggplot(data = filter(ames_clean_Neighborhood, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`, y = Neighborhood)) + geom_boxplot()#GOOD

# Other boxplots

ggplot(data = filter(ames, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_boxplot()

ggplot(data = filter(ames, !is.na(Acres) & Acres > 2.5 & Acres < 5), aes(Acres)) + geom_boxplot()
ggplot(data = filter(ames, !is.na(Acres) & Acres > 1 & Acres <= 2.5), aes(Acres)) + geom_boxplot()
ggplot(data = filter(ames, !is.na(Acres) & Acres > 0 & Acres <= 1), aes(Acres)) + geom_boxplot()

ggplot(data = filter(ames, `TotalLivingArea (sf)` >= 3000), aes(`TotalLivingArea (sf)`)) + geom_boxplot()
ggplot(data = filter(ames, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_boxplot()

ggplot(data = filter(ames, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_boxplot()

ggplot(data = filter(ames, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_boxplot()

####################################
# Let's try to plot some histograms for QUANTITATIVE with CATEGORICAL fills to see trends
####################################
# CAN TRY CATEGORICAL WITH OTHER CATEGORICAL FILLS BUT MAY NOT BE USEFUL SINCE MAIN VARIABLE IS QUANTITATIVE
# like ggplot based on one categorical and geom bar fill(weight) based on other
# or like ggplot based on one categorical and facet wrap using one categorical and geombar(fill with other categorical) this will give 3 categorical comparison

ggplot(data = ames_clean_Style, aes(`Sale Date`)) + geom_histogram(aes(fill = Style))
ggplot(data = ames_clean_Occupancy, aes(`Sale Date`)) + geom_histogram(aes(fill = Occupancy))
ggplot(data = ames_clean_Bedrooms, aes(`Sale Date`)) + geom_histogram(aes(fill = factor(Bedrooms)))
ggplot(data = ames, aes(`Sale Date`)) + geom_histogram(aes(fill = factor(AC)))
ggplot(data = ames, aes(`Sale Date`)) + geom_histogram(aes(fill = factor(FirePlace)))
ggplot(data = ames_clean_Neighborhood, aes(`Sale Date`)) + geom_histogram(aes(fill = Neighborhood))

ggplot(data = filter(ames_clean_Style, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000, aes(fill = Style))
ggplot(data = filter(ames_clean_Occupancy, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000, aes(fill = Occupancy))
ggplot(data = filter(ames_clean_Bedrooms, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000, aes(fill = factor(Bedrooms)))
ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000, aes(fill = factor(AC)))
ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000, aes(fill = factor(FirePlace)))
ggplot(data = filter(ames_clean_Neighborhood, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(`Sale Price`)) + geom_histogram(binwidth = 10000, aes(fill = Neighborhood))

ggplot(data = filter(ames_clean_Style, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1, aes(fill = Style))
ggplot(data = filter(ames_clean_Occupancy, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1, aes(fill = Occupancy))
ggplot(data = filter(ames_clean_Bedrooms, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1, aes(fill = factor(Bedrooms)))
ggplot(data = filter(ames, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1, aes(fill = factor(AC)))
ggplot(data = filter(ames, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1, aes(fill = factor(FirePlace)))
ggplot(data = filter(ames_clean_Neighborhood, !is.na(YearBuilt) & YearBuilt > 1850), aes(YearBuilt)) + geom_histogram(binwidth = 1, aes(fill = Neighborhood))

ames_AcresTypes <- filter(ames, !is.na(Acres) & Acres > 0)
ames_AcresTypes$AcresType <- with(ames_AcresTypes, ifelse(Acres > 2.5 & Acres < 5,'L',
                                                          ifelse(Acres > 1 & Acres <= 2.5, 'M', 'S')))
ames_AT_clean_Style <- filter(ames_AcresTypes, !is.na(Style))
ames_AT_clean_Occupancy <- filter(ames_AcresTypes, !is.na(Occupancy))
ames_AT_clean_Bedrooms <- filter(ames_AcresTypes, !is.na(Bedrooms) & Bedrooms != 0)
ames_AT_clean_Neighborhood <- filter(ames_AcresTypes, Neighborhood != "(0) None")
ggplot(data = ames_AT_clean_Style, aes(Acres)) + facet_wrap(~factor(AcresType), scales = "free") + geom_histogram(aes(fill = Style))
ggplot(data = ames_AT_clean_Occupancy, aes(Acres)) + facet_wrap(~factor(AcresType), scales = "free") + geom_histogram(aes(fill = Occupancy))
ggplot(data = ames_AT_clean_Bedrooms, aes(Acres)) + facet_wrap(~factor(AcresType), scales = "free") + geom_histogram(aes(fill = factor(Bedrooms)))
ggplot(data = ames_AcresTypes, aes(Acres)) + facet_wrap(~factor(AcresType), scales = "free") + geom_histogram(aes(fill = factor(AC)))
ggplot(data = ames_AcresTypes, aes(Acres)) + facet_wrap(~factor(AcresType), scales = "free") + geom_histogram(aes(fill = factor(FirePlace)))
ggplot(data = ames_AT_clean_Neighborhood, aes(Acres)) + facet_wrap(~factor(AcresType), scales = "free") + geom_histogram(aes(fill = Neighborhood))

ggplot(data = filter(ames, `TotalLivingArea (sf)` >= 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25)# dont care about this for now
ggplot(data = filter(ames, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25)
ggplot(data = filter(ames_clean_Style, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25, aes(fill = Style))
ggplot(data = filter(ames_clean_Occupancy, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25, aes(fill = Occupancy))
ggplot(data = filter(ames_clean_Bedrooms, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25, aes(fill = factor(Bedrooms)))
ggplot(data = filter(ames, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25, aes(fill = factor(AC)))
ggplot(data = filter(ames, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25, aes(fill = factor(FirePlace)))
ggplot(data = filter(ames_clean_Neighborhood, `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000), aes(`TotalLivingArea (sf)`)) + geom_histogram(binwidth = 25, aes(fill = Neighborhood))

ggplot(data = filter(ames_clean_Style, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10, aes(fill = Style))
ggplot(data = filter(ames_clean_Occupancy, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10, aes(fill = Occupancy))
ggplot(data = filter(ames_clean_Bedrooms, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10, aes(fill = factor(Bedrooms)))
ggplot(data = filter(ames, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10, aes(fill = factor(AC)))
ggplot(data = filter(ames, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10, aes(fill = factor(FirePlace)))
ggplot(data = filter(ames_clean_Neighborhood, `FinishedBsmtArea (sf)` < 2000), aes(`FinishedBsmtArea (sf)`)) + geom_histogram(binwidth = 10, aes(fill = Neighborhood))

ggplot(data = filter(ames_clean_Style, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100, aes(fill = Style))
ggplot(data = filter(ames_clean_Occupancy, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100, aes(fill = Occupancy))
ggplot(data = filter(ames_clean_Bedrooms, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100, aes(fill = factor(Bedrooms)))
ggplot(data = filter(ames, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100, aes(fill = factor(AC)))
ggplot(data = filter(ames, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100, aes(fill = factor(FirePlace)))
ggplot(data = filter(ames_clean_Neighborhood, !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000), aes(`LotArea(sf)`)) + geom_histogram(binwidth = 100, aes(fill = Neighborhood))

####################################
# Let's try to plot some scatterplots for QUANTITATIVE with QUANTITATIVE, specifically sale price, may use fill with CATEGORICAL
####################################

# play around with acres, living area, salesprice, etc ranges to find oddities
# filter doesn't like filter(data = ames, ...), it only needs name of dataframe, no need data = , like filter(ames, ...)
ames_clean_scatterplot <- filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000
                                     , !is.na(YearBuilt) & YearBuilt > 1850
                                     , !is.na(Acres) & Acres > 0 & Acres < 5
                                     , `TotalLivingArea (sf)` > 25 & `TotalLivingArea (sf)` < 3000
                                     , `FinishedBsmtArea (sf)` < 2000
                                     , !is.na(`LotArea(sf)`) & `LotArea(sf)` > 100 & `LotArea(sf)` < 15000
                                     , !is.na(Style) & !is.na(Occupancy) & !is.na(Bedrooms) & Bedrooms != 0 & Neighborhood != "(0) None")

ggplot(data = ames_clean_scatterplot, aes(x = YearBuilt, y = `Sale Price`)) + geom_point()#GOOD

ggplot(data = ames_clean_scatterplot, aes(x = Acres, y = `Sale Price`)) + geom_point()

ggplot(data = ames_clean_scatterplot, aes(x = `TotalLivingArea (sf)`, y = `Sale Price`)) + geom_point()

ggplot(data = ames_clean_scatterplot, aes(x = `FinishedBsmtArea (sf)`, y = `Sale Price`)) + geom_point()

ggplot(data = ames_clean_scatterplot, aes(x = `LotArea(sf)`, y = `Sale Price`)) + geom_point()

# Let's look at YearBuilt VS Sale Price in detail
# We can try to plot average sale price in that year
# on Mac, cmd + shift + m is the shortcut for pipe operator

ames_clean_scatterplot %>%
  group_by(YearBuilt) %>%
  summarise(avg_sale_price = mean(`Sale Price`)) %>%
  ggplot(aes(x = YearBuilt, y = avg_sale_price)) + geom_line()#GOOD

# now let's see for some categories
ames_clean_scatterplot %>%
  group_by(YearBuilt, Occupancy) %>%
  summarise(avg_sale_price = mean(`Sale Price`)) %>%
  ggplot(aes(x = YearBuilt, y = avg_sale_price, color = Occupancy)) + geom_line()#GOOD

# Let's see categorical fills for other QUANTITATIVE vars
# Acres VS Sale Price
ggplot(data = ames_clean_scatterplot, aes(x = Acres, y = `Sale Price`, color = Style)) + geom_point()
ggplot(data = ames_clean_scatterplot, aes(x = Acres, y = `Sale Price`, color = Occupancy)) + geom_point()#GOOD

# TotalLivingArea (sf) VS Sale Price
ggplot(data = ames_clean_scatterplot, aes(x = `TotalLivingArea (sf)`, y = `Sale Price`, color = Style)) + geom_point()

ames_clean_scatterplot %>%
  group_by(Style, `TotalLivingArea (sf)`) %>%
  summarise(avg_sale_price = mean(`Sale Price`)) %>%
  ggplot(aes(x = `TotalLivingArea (sf)`, y = avg_sale_price, color = Style)) + geom_point()#GOOD

ames_clean_scatterplot %>%
  group_by(Occupancy, `TotalLivingArea (sf)`) %>%
  summarise(avg_sale_price = mean(`Sale Price`)) %>%
  ggplot(aes(x = `TotalLivingArea (sf)`, y = avg_sale_price, color = Occupancy)) + geom_point()#GOOD

# LotArea(sf) VS Sale Price
ames_clean_scatterplot %>%
  group_by(Style, `LotArea(sf)`) %>%
  summarise(avg_sale_price = mean(`Sale Price`)) %>%
  ggplot(aes(x = `LotArea(sf)`, y = avg_sale_price, color = Style)) + geom_point()#GOOD

ames_clean_scatterplot %>%
  group_by(Occupancy, `LotArea(sf)`) %>%
  summarise(avg_sale_price = mean(`Sale Price`)) %>%
  ggplot(aes(x = `LotArea(sf)`, y = avg_sale_price, color = Occupancy)) + geom_point()#GOOD



# Histogram of Sale Price
ggplot(data = filter(ames, `Sale Price` > 10000 & `Sale Price` <= 1000000), aes(x = `Sale Price`)) +
  geom_histogram(binwidth = 50000, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Sale Prices",
       x = "Sale Price",
       y = "Frequency")


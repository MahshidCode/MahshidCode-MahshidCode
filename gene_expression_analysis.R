# set working directory
# setwd("F:/GEO/script")

# load libraries
library(GEOquery)
library(tidyverse)
library(dplyr)

# read the data
dat <- read.csv(file = "F:/GEO/GSE183947_fpkm.csv")
dim(dat)

# get metadata
gse <- getGEO(GEO = 'GSE183947', GSEMatrix = TRUE)
gse

metadata <- pData(phenoData(gse[[1]]))
head(metadata)
metadata.subset <- select(metadata, c(1,10,11,17))

metadata.modified <- metadata %>%
  select(1,10,11,17) %>%
  rename(tissue = characteristics_ch1) %>%
  rename(metastasis = characteristics_ch1.1) %>%
  mutate(tissue = gsub("tissue: ", "", tissue)) %>%
  mutate(metastasis = gsub("metastasis: ", "", metastasis))

head(dat)

# reshaping data
dat.long <- dat %>%
  rename(gene = X) %>%
  gather(key = 'samples', value = 'FPKM', -gene)

# join dataframes = dat.long + metadata.modified
dat.long <- dat.long %>%
  left_join(., metadata.modified, by = c("samples" = "description"))

head(dat.long)

# explore data
dat.long %>% 
  filter(gene == 'BRCA1' | gene == 'BRCA2') %>%
  group_by(gene, tissue) %>%
  summarize(mean_FPKM = mean(FPKM),
            median_FPKM = median(FPKM)) %>%
  arrange(-mean_FPKM)

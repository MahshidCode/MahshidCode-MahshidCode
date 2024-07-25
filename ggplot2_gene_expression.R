# load libraries
library(tidyverse)
library(ggplot2)


# load data
head(dat.long)


# basic format for ggplot2
# ggplot(data, aes(x = variable, y = variable1)) + 
#  geom_col()


# 1. barplot
dat.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(.,aes(x = samples, y = FPKM, fill = tissue)) +
  geom_col()


# 2. density
dat.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(., aes(x = FPKM, fill = tissue)) + 
  geom_density(alpha = 0.2)


# 3. boxplot
dat.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(., aes(x= metastasis, y = FPKM)) +
  geom_boxplot()


# 4. violin plot
dat.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(., aes(x = metastasis, y = FPKM)) +
  geom_violin()


# 5. scatter plot
dat.long %>%
  filter(gene == 'BRCA1' | gene == 'BRCA2') %>%
  spread(., key = gene, value = FPKM) %>%
  ggplot(., aes(x = BRCA1, y = BRCA2, colour = tissue)) +
  geom_point() +
  geom_smooth(method = 'lm', se = FALSE)


# 6. heatmap
genes.of.interest <- c('BRCA1', 'BRCA2', 'TP53', 'ALK', 'MYCN')

dat.long %>%
  filter(gene %in% genes.of.interest) %>%
  ggplot(., aes(x = samples, y = gene, fill = FPKM)) + 
  geom_tile()

# change the color scale to make it easier to interpret
genes.of.interest <- c('BRCA1', 'BRCA2', 'ALK', 'TP53', 'MYCN')

dat.long %>%
  filter(gene %in% genes.of.interest) %>%
  ggplot(., aes(x = samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'magenta')

# way 1: use save PDF of plot
genes.of.interest <- c('BRCA1', 'BRCA2', 'ALK', 'TP53', 'MYCN')

p <- dat.long %>%
  filter(gene %in% genes.of.interest) %>%
  ggplot(., aes(x = samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'magenta')

ggsave(p, filename = 'heatmap_save1.pdf', width = 10, height = 8)


# way 2: use pdf() to save as a PDF file  
genes.of.interest <- c('BRCA1', 'BRCA2', 'ALK', 'TP53', 'MYCN')
  

  # Create the heatmap  
pdf('heatmap.pdf', width = 10, height = 8)
dat.long %>%  
  filter(gene %in% genes.of.interest) %>%  
  ggplot(., aes(x = samples, y = gene, fill = FPKM)) +  
  geom_tile() +  
  scale_fill_gradient(low = 'white', high = 'magenta')  

  # Close the device  
dev.off()

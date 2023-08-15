# %% Plot results nice(r)
library(R.matlab)
library(tidyverse)
library(ggpubr)
library(ggsignif)
source("C:\\Users\\user\\Desktop\\brain_stuff\\ggplot_theme_Publication-master\\ggplot_theme_Publication-2.R")

setwd("C:\\Users\\user\\Desktop\\brain_stuff\\philipp\\sleeppaper\\data")
restacws <- readMat("restacws.mat")$acws / 1000 # rois x simulations 
restacwstau60 <- readMat("restacws2.mat")$acws / 1000
sinacws <- drop(readMat("sineacws2.mat")$acws) / 1000

rois  <- c("V1", "V2", "V4", "DP", "MT", "8m", "5", "8l", "TEO", "2", "F1", "STPc", "7A", 
    "46d", "10", "9/46v", "9/46d", "F5", "TEpd", "PBr", "7m", "7B", "F2", 
    "STPi", "ProM", "F7", "8B", "STPr", "24c")

rownames(restacws) <- rois
rownames(restacwstau60) <- rois
rownames(sinacws) <- rois

rtbl <- pivot_longer(as_tibble(restacws, rownames = "ROI"), 
    names_to = "simulation", values_to = "rest", cols = !ROI)

rtautbl <- pivot_longer(as_tibble(restacwstau60, rownames = "ROI"), 
    names_to = "simulation", values_to = "rest_tau60", cols = !ROI)

stbl <- pivot_longer(as_tibble(sinacws, rownames = "ROI"), 
    names_to = "simulation", values_to = "siny", cols = !ROI)

nicetibble <- full_join(rtbl, rtautbl)
nicetibble <- full_join(nicetibble, stbl)

nicert <- pivot_longer(nicetibble, names_to = "situation", values_to = "acw0", 
    cols = c("rest", "rest_tau60", "siny"))

cs <- c("#7CFB4C", "#EA3C24", "#A4FC4E")
p <- ggplot(nicert, aes(x = situation, y = acw0)) + 
    geom_violin(mapping = aes(fill = situation)) + 
    scale_fill_manual(values = cs) + 
    geom_boxplot(width=0.1, color="black", alpha=0.2) +
    facet_wrap(~factor(ROI, levels = rois), scales = "free_y") + 
    #stat_compare_means(label = "p.signif", 
    #comparisons = list(c(1, 2), c(2, 3)), hide.ns = FALSE,
    #label.y.npc = 0.6) + 
    geom_signif(
    comparisons = list(c(1, 2), c(2, 3)),
    map_signif_level = TRUE,
    # y_position = c(0.1, 0.2)
    textsize = 2.5,
    step_increase = -0.01) + 
    labs(x = "", y = "ACW-0") + 
    scale_x_discrete(labels=c("rest" = "tau_E = 20", "rest_tau60" = "tau_E = 60","siny" = "tau_E = 60 + sine")) +
    theme_Publication() + theme(legend.position = "none", axis.text.x = element_text(angle = 90),
    panel.grid.major.x = element_blank())
ggsave("ggfigure.jpg", units = "cm", height = 34)

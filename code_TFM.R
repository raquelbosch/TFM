#!/usr/bin/env Rscript

### Iterations new method for two-class classification model
### Author: Raquel Bosch Romeu

pacman::p_load(ExPosition, ks, dendextend, CDCA)

# load database
wd <- ""
load(paste0(wd,"db_nps.RData"))
db <- db_nps  # Data base used

# Parameters
n_iterations = 1000


# Initiation of variables to save results
confusion_matrix_two_coor <- matrix(data = NA, nrow = n_iterations, ncol = 4, 
                                    byrow = FALSE)
colnames(confusion_matrix_two_coor) <- c("TN", "FP", "FN", "TP")
confusion_matrix_theta <- matrix(data = NA, nrow = n_iterations, ncol = 4, 
                                 byrow = FALSE)
colnames(confusion_matrix_theta) <- c("TN", "FP", "FN", "TP")
prediction_parameters_two_coor <- matrix(data = NA, nrow = n_iterations, 
                                         ncol = 6, byrow = FALSE)
colnames(prediction_parameters_two_coor) <- c("NPV", "PPV", "accuracy", 
                                              "f1_score", "cohens_kappa", "mcc")
prediction_parameters_theta <- matrix(data = NA, nrow = n_iterations, ncol = 6, 
                                      byrow = FALSE)
colnames(prediction_parameters_theta) <- c("NPV", "PPV", "accuracy", 
                                           "f1_score", "cohens_kappa", "mcc")
# the difference between the distance to the two maximums is saved.  
# It will be used to construct the ROC and precision-recall curves
dist_diff_two_coor <- list(score = list(), class = list())
dist_diff_theta <- list(score = list(), class = list())


for (i in 1:n_iterations) {
  
  # Analysis with the two polar coordinates
  results_two_coor <- CDCA::CategoricalDataClassificationAnalysis(db, 270, 
                                                                  coordinates = "two")

  # Save results 
  confusion_matrix_two_coor[i,] <- results_two_coor$results$confusion_matrix
  prediction_parameters_two_coor[i, ] <- results_two_coor$results$predictive_parameters
  # The differences between the distance to the maxima of each class is saved
  dist_diff_two_coor$score[[i]] <- results_two_coor$prediction$difference
  dist_diff_two_coor$class[[i]] <- results_two_coor$prediction$real
  
  # Analysis with the angular coordinate  
  results_theta <- CDCA::CategoricalDataClassificationAnalysis(db, 270,
                                                               coordinates = "theta")
  
  confusion_matrix_theta[i,] <- results_theta$results$confusion_matrix
  prediction_parameters_theta[i, ] <- results_theta$results$predictive_parameters
  dist_diff_theta$score[[i]] <- results_theta$prediction$difference
  dist_diff_theta$class[[i]] <- results_theta$prediction$real
}

save(confusion_matrix_two_coor, prediction_parameters_two_coor, 
     confusion_matrix_theta, prediction_parameters_theta,
     file = paste0(wd, "results_analysis.RData"))

save(dist_diff_two_coor, dist_diff_theta, 
     file = paste0(wd, "results_dist_diff.RData"))



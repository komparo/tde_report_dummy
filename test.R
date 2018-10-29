library(certigo)

datasets <- load_call_git(
  "https://github.com/komparo/tde_dataset_dyntoy",
  derived_file_directory = "results/datasets"
)
datasets$design <- datasets$design[1, ]

models <- load_call_git(
  "https://github.com/komparo/tde_method_random",
  derived_file_directory = "results/models",
  datasets = datasets
)
models$design <- models$design[1, ]

scores <- load_call_git(
  "https://github.com/komparo/tde_metric_dummy",
  derived_file_directory = "results/scores",
  models = models
)
scores$design <- scores$design[1, ]

report <- load_call(
  "workflow.R",
  derived_file_directory = "results/report",
  datasets = datasets,
  models = models,
  scores = scores
)

#' @examples 
#' report$calls[[1]]$debug()

workflow <- workflow(
  datasets,
  models,
  scores,
  report
)

workflow$reset()
workflow$run()


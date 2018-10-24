pull_or_clone <- function(repo, local_path) {
  if (fs::dir_exists(local_path)) {
    git2r::pull(local_path)
  } else {
    git2r::clone(repo, local_path = local_path)
  }
}

pull_or_clone("https://github.com/komparo/tde_method_random", local_path = "modules/method")
pull_or_clone("https://github.com/komparo/tde_method_random", local_path = "modules/method")
pull_or_clone("https://github.com/komparo/tde_metric_dummy", local_path = "modules/metric")

source("modules/metric/workflow.R")
datasets <- generate_dataset_calls(
  workflow_folder = "modules/dataset",
  datasets_folder = "data/datasets",
  dataset_design = dataset_design_all[1:4, ]
) %>% call_collection(id = "datasets")

source("modules/method/workflow.R")
methods <- generate_method_calls(
  workflow_folder = "modules/method",
  method_design = method_design_all[1, ],
  datasets = datasets,
  models_folder = "data/models"
) %>% call_collection(id = "methods")

source("modules/dataset/workflow.R")
metrics <- generate_metric_calls(
  workflow_folder = "modules/metric",
  metric_design = metric_design_all[1, ],
  methods = methods,
  scores_folder = "data/scores"
) %>% call_collection(id = "metrics")

source('workflow.R')
report <- generate_report_calls(
  datasets = datasets,
  methods = methods,
  metrics = metrics
) %>% call_collection(id = "reports")

workflow <- workflow(
  datasets,
  methods,
  metrics,
  report
)

workflow$reset()
workflow$run()


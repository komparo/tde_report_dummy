source('workflow.R')

if(fs::dir_exists("modules")) fs::dir_delete("modules")
git2r::clone("https://github.com/komparo/tde_dataset_dyntoy", local_path = "modules/dataset")
git2r::clone("https://github.com/komparo/tde_method_random", local_path = "modules/method")
git2r::clone("https://github.com/komparo/tde_metric_dummy", local_path = "modules/metric")

source("modules/dataset/workflow.R")
source("modules/method/workflow.R")
source("modules/metric/workflow.R")

datasets <- generate_dataset_calls(
  workflow_folder = "modules/dataset",
  datasets_folder = "data/datasets",
  dataset_design = dataset_design_all[1:2, ]
) %>% call_collection(id = "datasets")

methods <- generate_method_calls(
  workflow_folder = "modules/method",
  method_design = method_design_all[1, ],
  datasets = datasets,
  models_folder = "data/models"
) %>% call_collection(id = "methods")

metrics <- generate_metric_calls(
  workflow_folder = "modules/metric",
  metric_design = metric_design_all[1, ],
  methods = methods,
  scores_folder = "data/scores"
) %>% call_collection(id = "metrics")

report <- generate_report_calls(
  datasets = datasets,
  methods = methods,
  metrics = metrics
) %>% call_collection(id = "reports")

workflow <- workflow(
  list(
    datasets,
    methods,
    metrics,
    report
  )
)

workflow$reset()
workflow$run()


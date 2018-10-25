library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

generate_report_calls <- function(datasets, methods, metrics, workflow_folder = ".", reports_folder = "report") {
  design <- list(
    script = script_file(str_glue("{workflow_folder}/scripts/report.Rmd")),
    executor = docker_executor(container = "rocker/tidyverse"),
    rendered = derived_file(str_glue("{reports_folder}/index.html")),
    datasets = datasets$design %>% select(meta, expression) %>% map(object_set) %>% object_set(),
    scores = metrics$design %>% select(dataset_id, method_id, accuracy) %>% map(object_set) %>% object_set()
  )
  
  rmd_call(
    "komparo/dummy",
    design = design,
    inputs = c("script", "executor", "datasets", "scores"),
    outputs = "rendered"
  )
}

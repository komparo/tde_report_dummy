library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

get_call <- function(datasets, models, scores) {
  design <- list(
    script = script_file(str_glue("scripts/report.Rmd")),
    executor = docker_executor(container = "rocker/tidyverse"),
    rendered = derived_file(str_glue("index.html")),
    datasets = datasets$design %>% select(meta, expression) %>% map(object_set) %>% object_set(),
    scores = scores$design %>% select(dataset_id, method_id, scores) %>% map(object_set) %>% object_set()
  )
  
  rmd_call(
    design = design,
    inputs = exprs(script, executor, datasets, scores),
    outputs = exprs(rendered)
  )
}

library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

generate_report_calls <- function(datasets, methods, metrics, workflow_folder = ".", reports_folder = "report") {
  rscript_call(
    "komparo/dummy",
    inputs = list(
      script = script_file(str_glue("{workflow_folder}/scripts/run.R")),
      markdown = script_file(str_glue("{workflow_folder}/scripts/report.Rmd"))
    ) %>% c(
      datasets$outputs %>% select(meta, expression) %>% map(object_set),
      methods$outputs %>% select(tde_overall) %>% map(object_set),
      metrics$outputs %>% select()
    ),
    outputs = str_glue("{reports_folder}/index.html") %>% map(derived_file) %>% set_names("report")
  )
}

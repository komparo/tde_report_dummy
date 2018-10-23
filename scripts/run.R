library(rmarkdown)

report_dir <- fs::path_dir(outputs[["report"]])
report_file <- fs::path_file(outputs[["report"]])

render(inputs[["markdown"]], output_dir = report_dir, output_file = report_file)

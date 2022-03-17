df <- mtcars
df$name <- row.names(mtcars)

p <- plot_ly(
  data = df,
  x = ~cyl,
  y = ~disp, 
  type = "scatter",
  mode = "markers"
)

widget_file_size <- function(p) {
  d <- getwd()
  withr::with_dir(d, htmlwidgets::saveWidget(p, "index.html"))
  f <- file.path(d, "index.html")
  mb <- round(file.info(f)$size / 1e6, 3)
  message("File is: ", mb," MB")
}
widget_file_size(p)
#> File is: 3.495 MB
widget_file_size(partial_bundle(p))
#> File is: 1.068 MB

# Commit, Push

# Use this code to embed
# <iframe id="igraph" scrolling="no" style="border:none;" seamless="seamless" src="https://github.com/castels/dataFlow/blob/main/index.html" height="525" width="100%"></iframe>
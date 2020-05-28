
library(purrr)
library(stringr)

doc_list <-list.files(pattern=".*\\.html")

# doc_list <- c( "covid_moscow_v3.html")
convert_html2pdf <-function(x) {
  system(paste0("\"C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe\" --javascript-delay 1 ", x, " ",
                           str_remove(x, "\\.html"), ".pdf"))
}

doc_list %>% map( convert_html2pdf )

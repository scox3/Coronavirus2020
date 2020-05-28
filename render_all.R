##Render.all

library(rmarkdown)

doc_list <- c( "apple_mobility_msk.Rmd", "covid_deceased_msk.Rmd", "covid_eu_trend estimate.Rmd", 
"us_daily.Rmd", "worldometer_global.Rmd", "worldometer_us_states.Rmd", "covid_moscow_v3.Rmd")

#doc_list <- c( "worldometer_us_states.Rmd")


lapply( doc_list, rmarkdown::render, output_format = "html_document", envir=new.env(), encoding = "UTF-8")

lapply( doc_list, rmarkdown::render, output_format = "word_document", envir=new.env(), encoding = "UTF-8")


# rmarkdown::render("covid_moscow_v3.Rmd", output_format = "html_document")
# rmarkdown::render("covid_moscow_v3.Rmd", output_format = "word_document")

# doc_list %>%
# str_remove("\.Rmd") %>%
# function(x) system(paste0("wkhtmltopdf --javascript-delay 1 ", x, ".html ",
#  x, ".pdf"))

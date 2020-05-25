

library(rvest)
library(purrr)

get_rpn_covid_updates_list <- function() {
  html1 <- read_html("https://www.rospotrebnadzor.ru/region/rss/rss.php")
#  html1 %>% xml_structure()
  
  a1 <- html1%>% html_nodes(".news-item") 
  
  idx <- a1 %>% html_text() %>% str_detect("COVID-2019")
  
  if( length(idx) == 0 ) print("Nothing retrieved!")
  
  covid_rss_links <- data.table( dates = a1[idx] %>% 
                                 html_nodes( ".news-date-time" ) %>% 
                                 html_text() %>% 
                                 as.Date(format="%d.%m.%Y"),
                               hrefs = a1[idx] %>% 
                                 html_nodes( "a" ) %>% 
                                 html_attr("href") )
  
  covid_rss_links[ , hrefs := paste0( "https://www.rospotrebnadzor.ru", hrefs), by = dates]
  return(copy(covid_rss_links))
}


get_rpn_covid_msk_update <- function( href ) { 
  
  b <- read_html(href)
  
  b.date <- b %>% html_nodes(".news-date-time") %>% html_text() %>% as.Date(format="%d.%m.%Y")
  
  
  b1 <- b %>% html_nodes(".news-detail") %>% html_nodes("div")
  idx <- b1%>% html_text() %>% str_detect("1\\. Москва")
  
  b2 <- b1 %>% html_text() %>% str_subset("^\\d+\\. ") 
  
  
  #<div>1. Москва - 2560</div>
  dt1 <- data.table( date = b.date,
                     num = b2 %>% str_extract("^\\d+\\. ") %>% str_remove("\\. ") %>% as.numeric,
                    val = b2 %>% str_extract("- .+$") %>% str_remove("- ") %>% as.numeric,
                    name = b2 %>% str_extract("\\. .+ -") %>%  str_remove("^\\. ") %>% str_remove(" -") )
  return(copy(dt1))
  
} 

update_CovidMoscowDB <- function(CovidMoscowDB) {
  dt.rpn_rss_list <- get_rpn_covid_updates_list()

  rpn_covid_updates <- dt.rpn_rss_list[ !dates %in% CovidMoscowDB$date, hrefs ]  %>% 
    map( get_rpn_covid_msk_update) %>% rbindlist
  
  if( dim(rpn_covid_updates)[1] > 0 ) {
    CovidMoscowDB.1 <- rbind( CovidMoscowDB, 
         rpn_covid_updates[num==1, .(date, newCases=val, 0, week.day = wday(date))], use.names=FALSE)
    CovidMoscowDB.1[ , TotalCases := cumsum(newCases)] 
    
  } else {
    CovidMoscowDB.1 <- CovidMoscowDB
  } 
  
  return( copy(CovidMoscowDB.1))
}






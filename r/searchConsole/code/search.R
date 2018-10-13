library(bigrquery)
library(searchConsoleR)
library(googleAuthR)
library(dplyr)

options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/bigquery",
                                        "https://www.googleapis.com/auth/webmasters"))
gar_auth_service(json_file = "keys.json") -> serviceToken
set_service_token("keys.json")

'xxxx' -> project
'xxxx' -> dataset
'xxxx' -> pageLevelTableName
'xxxx' -> siteLevelTableName
'xxxx' -> website
Sys.Date() -3 -> currentDate
Sys.Date() -365 -> lastYear

query_exec(paste0("SELECT date(max(date)) FROM `xxxx.xxxx`"), 
           project, 
           use_legacy_sql = FALSE,
           useQueryCache = FALSE) -> date
as.Date(date[[1]]) +1 -> pageLevelDate

if(pageLevelDate <= currentDate) {
  search_analytics(website, 
                   pageLevelDate,
                   pageLevelDate,
                   c('query', 
                     'page',
                     'date',
                     'device',
                     'country'), 
                   searchType= 'web',
                   dimensionFilterExp = c("country == USA"),
                   rowLimit = 30000) %>% 
    mutate(date = as.POSIXct(date),
           clicks = as.integer(clicks),
           impressions = as.integer(impressions)) %>% 
    arrange(query, date) -> pageLevelQueries
  
  if(sum(pageLevelQueries$impressions) > 0) {
    pageLevelJob <- insert_upload_job(project, 
                                      dataset, 
                                      pageLevelTableName,
                                      pageLevelQueries,
                                      billing = project,
                                      create_disposition = 'CREATE_IF_NEEDED',
                                      write_disposition = 'WRITE_APPEND')
    wait_for(pageLevelJob)
  }
}

rm(pageLevelQueries,
   pageLevelTableName,
   pageLevelDate,
   pageLevelJob)

## Site Level Work
query_exec(paste0("SELECT date(max(date)) FROM `xxxx.xxxx`"), 
           project, 
           use_legacy_sql = FALSE,
           useQueryCache = FALSE) -> date
as.Date(date[[1]]) +1 -> siteLevelDate

if(siteLevelDate <= currentDate) {
  search_analytics(website, 
                   siteLevelDate,
                   siteLevelDate,
                   c('query',
                     'date',
                     'device',
                     'country'), 
                   searchType= 'web',
                   aggregationType = 'byProperty',
                   dimensionFilterExp = c("country == USA"),
                   rowLimit = 10000) %>% 
    mutate(date = as.POSIXct(date),
           clicks = as.integer(clicks),
           impressions = as.integer(impressions),
           device = tolower(device),
           countryName = tolower(countryName)) %>% 
    arrange(query, date) ->  siteLevelQueries
  
  if(sum(siteLevelQueries$impressions) > 0) {
    siteLevelJob <- insert_upload_job(project, 
                                      dataset, 
                                      siteLevelTableName,
                                      siteLevelQueries,
                                      billing = project,
                                      write_disposition = 'WRITE_APPEND',
                                      create_disposition = 'CREATE_IF_NEEDED')
    wait_for(siteLevelJob)
  }
}

rm(website,
   date,
   currentDate,
   lastYear, 
   siteLevelQueries,
   project,
   dataset,
   siteLevelTableName,
   siteLevelDate,
   siteLevelJob)
# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

aou_tables <- function() {
  cdmDatabaseSchema=Sys.getenv('WORKSPACE_CDR')
  t<-bigrquery::bq_dataset_tables(Sys.getenv('WORKSPACE_CDR'))
  tbls=unlist(purrr::map(t,'table'))
  tbls

}

aou_run <-function(sql){
  billing=Sys.getenv('GOOGLE_PROJECT')
  cdmDatabaseSchema=Sys.getenv('WORKSPACE_CDR')
  sql <- SqlRender::render(sql,cdmDatabaseSchema=cdmDatabaseSchema)
  sql <- SqlRender::translate(sql,targetDialect = 'bigquery')
  sql=stringr::str_replace_all(sql,'r2019q4r3','R2019Q4R3')
  #cat(sql)
  q <- bigrquery::bq_project_query(billing, sql)
  out<-bigrquery::bq_table_download(q)
  out
}


#' run sql command
#'
#' @param sql code to be executed
#'
#' @return
#' @export
aou_run <-function(sql){
  billing=Sys.getenv('GOOGLE_PROJECT')
  cdmDatabaseSchema=Sys.getenv('WORKSPACE_CDR')
  sql <- SqlRender::render(sql,cdmDatabaseSchema=cdmDatabaseSchema)
  sql <- SqlRender::translate(sql,targetDialect = 'bigquery')
  sql=stringr::str_replace_all(sql,'r2019q4r3','R2019Q4R3')
  cat(sql)
  q <- bigrquery::bq_project_query(billing, sql)
  out<-bigrquery::bq_table_download(q)
  list(query=sql,result=out)
}


#' Write data into bucket
#'
#' @param data data frame with the data
#' @param destination_filename  name of the file to store the data
#'
#' @return
#' @export
aou_write<-function(data,destination_filename){


  # store the dataframe in current workspace
  write_excel_csv(data, destination_filename)

  # Get the bucket name
  my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

  # Copy the file from current workspace to the bucket
  system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

  # Check if file is in the bucket
  #system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)
}


#' List columns of a table
#'
#' @param table name of table (e.g., person)
#'
#' @return data frame with fields and type and description
#' @export
aou_tbl_fields<-function(table){
  cdm2=map_chr(stringr::str_split(Sys.getenv('WORKSPACE_CDR'),pattern = '\\.'),c(2))
  project2=map_chr(stringr::str_split(Sys.getenv('WORKSPACE_CDR'),pattern = '\\.'),c(1))

  bqtable=list(projectId=project2,datasetId=cdm2,tableId=table)
  #bqtable
  f=bigrquery::bq_table_fields(bqtable)
  #f
  out=data.frame(table=table,name=purrr::map_chr(f,'name'),type=purrr::map_chr(f,'type'),mode=purrr::map_chr(f,'mode'), description=(purrr::map_chr(f,'description')))
  out
}


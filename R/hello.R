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
 t<-bigrbq_dataset_tables(Sys.getenv('WORKSPACE_CDR'))


  pluck(t[[1]],table)

  names(t[[1]])

  t[[1]]
  #map(t,str)
  #map_chr(t,table)
  tbls=map(t,'table') %>% unlist()
  tbls
  data.frame(tbl=tbls)

}

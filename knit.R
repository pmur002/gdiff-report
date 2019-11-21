
## Execute as Rscript knit.R <filename>
args <- commandArgs()
extras <- grep("--args", args) + 1
filename <- args[extras[1]]

## Make sure that all <!--begin.rcode line are NOT indented
## (else enclosed code will not get indented right)
rhtml <- readLines(filename)
rhtml <- gsub(" +<!--begin.rcode", "<!--begin.rcode", rhtml)
writeLines(rhtml, filename)

## Generate HTML
library(knitr)
knit(filename)



TARFILE = ../gdiff-deposit-$(shell date +'%Y-%m-%d').tar.gz
Rscript = Rscript

all:
	make docker

%.xml: %.cml %.bib
	# Protect HTML special chars in R code chunks
	$(Rscript) -e 't <- readLines("$*.cml"); writeLines(gsub("str>", "strong>", gsub("<rcode([^>]*)>", "<rcode\\1><![CDATA[", gsub("</rcode>", "]]></rcode>", t))), "$*.xml")'
	$(Rscript) toc.R $*.xml
	$(Rscript) bib.R $*.xml

%.Rhtml : %.xml
	# Transform to .Rhtml
	xsltproc knitr.xsl $*.xml > $*.Rhtml

%.html : %.Rhtml
	# Use knitr to produce HTML
	$(Rscript) knit.R $*.Rhtml

docker:
	# Ensure docker images are up to date
	cp ../../Rgdiff/gdiff_0.1-0.tar.gz .
	sudo docker build -f Dockerfiles/Dockerfile-gdiff-test -t pmur002/gdiff-test .
	sudo docker build -f Dockerfiles/Dockerfile-gdiff-report -t pmur002/gdiff-report .
        # -v docker.sock 
        #   so that docker container run within the report docker container uses
        #   the same docker server
        # -v $(shell pwd):$(shell pwd) -w $(shell pwd)
        #   so that gdiff-report container has same working directory path as
        #   local host, so that gdiff-test container sees same working dir
	sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(shell pwd):$(shell pwd) -w $(shell pwd) --rm pmur002/gdiff-report make gdiff.html

web:
	make docker
	cp -r ../gdiff-report/* ~/Web/Reports/QA/gdiff/

zip:
	make docker
	tar zcvf $(TARFILE) ./*

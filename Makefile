UNAME	=	$(shell uname)
PDFTEX	=	pdflatex --shell-escape -halt-on-error
PDFBLD	=	$(PDFTEX) $(*F).tex > /dev/null
BIBTEX	=	bibtex
BIBBLD	=	-$(BIBTEX) $(*F) > /dev/null

ifeq ($(UNAME),Darwin)
PDFOPN	=	open -a /Applications/Adobe\ Reader.app
endif

DOCS	=	report slides

.PHONY: clean view slides report

default: slides.pdf

all: $(DOCS:%=%.pdf)

view: $(DOCS)

%.aux: %.tex
	$(PDFBLD)

%.pdf: %.aux
	$(PDFBLD)

%.bbl: %.aux
	$(BIBBLD)
	$(PDFBLD)

report: report.pdf
	$(PDFOPN) $<

report.pdf: report.bbl

report.bbl: bib/misc.bib

slides: slides.pdf
	$(PDFOPN) $<

slides.aux: slides/10-pathfinding.tex
slides.aux: slides/20-algorithm.tex
slides.aux: slides/30-gpuvscpu.tex
slides.aux: slides/90-conclusion.tex

clean:
	$(RM) *.log *.aux *.toc *.out *.blg *.bbl *.nav *.snm *.synctex.gz
	$(RM) $(DOCS:%=%.pdf)
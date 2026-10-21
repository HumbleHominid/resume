# make              standard CV + generic letter -> cv/cv.pdf, cover_letters/cover_letter.pdf
# make APP=<name>   tailored build -> applications/<name>/{cv,cover_letter,cl_cv}.pdf
# make new APP=<name>  start applications/<name>/letter.tex from the generic letter

TEX = pdflatex -interaction=nonstopmode -halt-on-error -file-line-error
SET_APP = \def\app{$(APP)}

# $(call latex,<run dir>,<jobname>,<out dir>,<tex input>): quiet build.
# Prints LaTeX warnings on success, the log's errors on failure.
latex = @cd $(1) && $(TEX) -jobname=$(2) -output-directory=$(3) "$(4)" >/dev/null \
	&& { grep -h "LaTeX Warning" $(3)/$(2).log; echo "built $(patsubst $(CURDIR)/%,%,$(3))/$(2).pdf"; } \
	|| { grep -h -A2 -E ':[0-9]+: |^!' $(3)/$(2).log; echo "FAILED: see $(patsubst $(CURDIR)/%,%,$(3))/$(2).log"; exit 1; }

ifeq ($(APP),)
CV_OUT := $(CURDIR)/cv
CL_OUT := $(CURDIR)/cover_letters
else
CV_OUT := $(CURDIR)/applications/$(APP)
CL_OUT := $(CV_OUT)
endif

.PHONY: all new

all:
	@test -f details.tex || { echo "missing details.tex (copy details.example.tex and fill it in)"; exit 1; }
	@test -z "$(APP)" -o -f applications/$(APP)/letter.tex || { echo "missing applications/$(APP)/letter.tex (try: make new APP=$(APP))"; exit 1; }
	$(call latex,cv,cv,$(CV_OUT),$(SET_APP)\input{cv})
	$(call latex,cover_letters,cover_letter,$(CL_OUT),$(SET_APP)\input{cover_letter})
ifneq ($(APP),)
	$(call latex,.,cl_cv,$(CV_OUT),\documentclass{article}\usepackage{pdfpages}\begin{document}\includepdf[pages=-]{$(CL_OUT)/cover_letter}\includepdf[pages=-]{$(CV_OUT)/cv}\end{document})
endif

new:
	@test -n "$(APP)" || { echo "usage: make new APP=<name>"; exit 1; }
	@test ! -e applications/$(APP) || { echo "applications/$(APP) already exists"; exit 1; }
	mkdir -p applications/$(APP)
	cp cover_letters/generic.tex applications/$(APP)/letter.tex

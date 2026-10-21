# Resume

My CV and cover letters, written in LaTeX. Both can be tailored for individual job applications.

## Requirements

- A TeX distribution with `pdflatex`, such as TeX Live or MacTeX
- `make`

## Building

First copy `details.example.tex` to `details.tex` and fill in your details. `details.tex` is gitignored.

```sh
make                    # standard CV + generic cover letter
make new APP=<name>     # start a new application from the generic letter
make APP=<name>         # build a tailored application
```

| Command | Output |
| --- | --- |
| `make` | `cv/cv.pdf` (committed), `cover_letters/cover_letter.pdf` (local only) |
| `make APP=<name>` | `applications/<name>/cv.pdf`, `cover_letter.pdf`, and `cl_cv.pdf` (letter + CV combined) |

The build prints one line for each PDF it makes. If a build fails, it prints the error and the path of the log file.

## Layout

```
cv/cv.tex                        CV (AltaCV class)
cover_letters/cover_letter.tex   Letter frame: header, closing, signature
cover_letters/generic.tex        Default letter body
macros.tex                       Contact-detail formatting shared by both documents
details.tex                      Personal details (gitignored; start from details.example.tex)
applications/<name>/             Per-application files (gitignored)
  letter.tex                       Letter body for this application
  cv_options.tex                   Optional CV overrides
```

`applications/` is never committed, so the letters and tailored CVs stay local. The only committed PDF is `cv/cv.pdf`, the standard CV, which shows just email and city. The cover letter PDF prints the full address and phone number, so it stays local.

## Tailoring the CV

The **Tailoring** block at the top of `cv/cv.tex` sets the defaults. It contains:

- toggles for optional entries (`exp-*` for experience, `proj-*` for projects, `sec-*` for sections)
- `\cvtaglinetext` and `\cvsummarytext`, the tagline and summary

To change the CV for one application, create `applications/<name>/cv_options.tex`:

```latex
\toggletrue{exp-fs-ta}       % show the ML Teaching Assistant role
\togglefalse{proj-arcadia}   % hide the Arcadia project
\renewcommand{\cvsummarytext}{A summary written for this role.}
```

To add a new optional entry, declare it with `\newtoggle` in the Tailoring block, then wrap the entry:

```latex
\iftoggle{exp-example}{
\divider{}

\cvevent{...}
}{}
```

Changes that should apply to every application, like a new job or project, go directly in `cv/cv.tex`.

## Writing a cover letter

`applications/<name>/letter.tex` holds only the body paragraphs. Start each paragraph with `\paragraph{}`. The frame in `cover_letter.tex` adds the contact header, the closing paragraph and the signature. Escape LaTeX special characters (`\&`, `\%`, `\$`).

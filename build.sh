#!/bin/sh
# ./build.sh        → build/how-to-disappear-on-ethereum.pdf + how-to-disappear-on-ethereum.pdf (A5, RGB)
# ./build.sh print [pages] → matching reading and print PDFs
#                     optional page count includes covers (e.g. 32 for Printo)
#                     (A5 + 5mm bleed, CMYK, fonts outlined, padded to a multiple of 4,
#                      front cover = page 1, back cover = last page)
set -e
cd "$(dirname "$0")"
build_mode=${1:-screen}
requested_pages=${2:-}
mkdir -p build/src
# The approved layers figure is the supplied PNG in design/assets/.
# Earlier thread artwork remains available for reference.
# Pass only current chapter files to pandoc; removed chapters may still
# have old generated copies in build/src.
set --
for f in book/*.md; do
  b=$(basename "$f" .md)
  # drop the summary/fact-check block; make footnote ids unique per chapter
  awk 'NR==1 && /^---$/ {yaml=1} yaml {print; if (NR>1 && /^---$/) yaml=0; next} /^---$/ {exit} {print}' "$f" \
    | sed "s/\[\^\([0-9][0-9]*\)\]/[^$b-\1]/g" > "build/src/$b.md"
  set -- "$@" "build/src/$b.md"
done
render_book() {
  pandoc "$@" --from markdown+raw_tex --lua-filter editorial/references.lua \
    --template design/template.tex --pdf-engine=xelatex --top-level-division=chapter
}
if [ "$build_mode" != "print" ]; then
  render_book "$@" -o build/how-to-disappear-on-ethereum.pdf
  cp build/how-to-disappear-on-ethereum.pdf how-to-disappear-on-ethereum.pdf
  echo "→ how-to-disappear-on-ethereum.pdf (repository copy)"
  echo "→ build/how-to-disappear-on-ethereum.pdf ($(pdfinfo build/how-to-disappear-on-ethereum.pdf | awk '/^Pages/{print $2}') pages)"
  exit 0
fi
T=build/tmp; mkdir -p $T
# Render both editions from the same captured chapter files. A print build
# must also refresh the reading copy, including the same blank pages.
render_book "$@" -o $T/screen.pdf
render_book "$@" -V bleed=5mm -o $T/raw.pdf
n=$(pdfinfo $T/raw.pdf | awk '/^Pages/{print $2}')
screen_n=$(pdfinfo $T/screen.pdf | awk '/^Pages/{print $2}')
target_pages=$(( (n + 3) / 4 * 4 ))
if [ -n "$requested_pages" ]; then
  case "$requested_pages" in
    *[!0-9]*) echo "Page count must be a positive multiple of 4." >&2; exit 1 ;;
  esac
  if [ "$requested_pages" -lt "$n" ] || [ $((requested_pages % 4)) -ne 0 ]; then
    echo "Page count must be at least $n and a multiple of 4." >&2; exit 1
  fi
  target_pages=$requested_pages
fi
if [ "$screen_n" -ne "$n" ]; then
  echo "Reading and print layouts have different page counts; exports stopped." >&2
  exit 1
fi
pad_book() {
  input_pdf=$1; output_pdf=$2
  pad=$((target_pages - n))
  if [ "$pad" -eq 0 ]; then cp "$input_pdf" "$output_pdf"; return; fi
  # Preserve links and bookmarks. Put the first blank inside the front
  # cover; any further padding stays before the back cover.
  W=$(pdfinfo "$input_pdf" | awk '/Page size/{print $3}')
  H=$(pdfinfo "$input_pdf" | awk '/Page size/{print $5}')
  gs -q -o $T/blank.pdf -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=$W -dDEVICEHEIGHTPOINTS=$H -c "showpage"
  set -- "$input_pdf" --pages . 1 "$T/blank.pdf" 1 . "2-$((n-1))"
  i=1
  while [ "$i" -lt "$pad" ]; do set -- "$@" "$T/blank.pdf" 1; i=$((i+1)); done
  qpdf "$@" . "$n" -- "$output_pdf"
}
pad_book $T/screen.pdf $T/reading.pdf
pad_book $T/raw.pdf $T/padded.pdf
gs -q -o build/how-to-disappear-on-ethereum-print.pdf -sDEVICE=pdfwrite -dNoOutputFonts \
   -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK -dPDFSETTINGS=/prepress \
   -dDownsampleColorImages=false -dDownsampleGrayImages=false \
   -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode \
   -dAutoFilterGrayImages=false -dGrayImageFilter=/FlateEncode $T/padded.pdf
mv $T/reading.pdf build/how-to-disappear-on-ethereum.pdf
cp build/how-to-disappear-on-ethereum.pdf how-to-disappear-on-ethereum.pdf
rm -rf $T
echo "→ how-to-disappear-on-ethereum.pdf (repository copy)"
echo "→ build/how-to-disappear-on-ethereum.pdf ($target_pages pages, matching reading copy)"
echo "→ build/how-to-disappear-on-ethereum-print.pdf ($(pdfinfo build/how-to-disappear-on-ethereum-print.pdf | awk '/^Pages/{print $2}') pages incl. covers, $pad blank page(s) added, $(pdfinfo build/how-to-disappear-on-ethereum-print.pdf | grep 'Page size' | sed 's/Page size: *//'))"

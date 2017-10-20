#!/usr/bin/env sh

OUTPUT_FILE=xkcdbook_2ed.pdf

perl makebook.pl
/usr/local/bin/wkhtmltopdf \
    --images \
    --page-width 6in --page-height 9in \
    --dpi 380 \
    --footer-center "- [page] -" \
    --footer-font-name "Helvetica" \
    --footer-font-size 10 \
    xkcdbook.html $OUTPUT_FILE

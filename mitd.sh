#!/bin/bash
D="https://innovazione.gov.it"
curl "$D/dipartimento/posizioni-lavorative/" -o pl.htm
echo -n "<rss version=\"2.0\"><channel><title>MITD</title><lastBuildDate>"
grep -o '[0-9]*\ [a-z]*\ 2021' pl.htm \
| head -n1 \
| tr -d '\n'
echo "</lastBuildDate>"
grep -oP '<a[^>]*text-primary[^>]*>[^>]*</a>' pl.htm \
| sed "s|^.*href=\"|$D|;s|\"[^>]*>\ *|\t|;s|\ *<.*$||" \
| while read -r L T; do
   echo "<item><title>$T</title><guid>$L</guid></item>"
done
echo "</channel></rss>"

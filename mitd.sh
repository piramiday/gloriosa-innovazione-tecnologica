#!/bin/bash
echo "<rss version=\"2.0\"><channel><title>MITD</title><lastBuildDate>$(date)</lastBuildDate>"
D="https://innovazione.gov.it"
curl "$D/dipartimento/posizioni-lavorative/" \
| grep -oP '<a[^>]*text-primary[^>]*>[^>]*</a>' \
| sed "s|^.*href=\"|$D|;s|\"[^>]*>\ *|\t|;s|\ *<.*$||" \
| while read -r L T; do
   echo "<item><title>$T</title><guid>$L</guid></item>"
done
echo "</channel></rss>"

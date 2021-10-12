#!/bin/bash
set -e
D="https://pica.cineca.it"
O="pica.htm"
curl -s "$D/cineca/" -o "$O"
N=$(grep -c 'class="card">' "$O")
grep 'class="card"' "$O" \
| head -n$N \
| cut -d'"' -f2 \
> _1
grep 'class="search_title"' "$O" \
| head -n$N \
| sed 's/<[^>]*>//g;s/^\ *//;s/\ *//' \
> _2
grep 'class="default_call-desc"' "$O" \
| head -n$N \
| sed 's/<[^>]*>//g;s/^\ *//;s/\ *//' \
> _3
grep 'class="default_call-data"' "$O" -A1 \
| grep time \
| head -n$N \
| sed 's/<[^>]*>//g;s/^\ *//;s/\ *//' \
> _4
echo "<rss version=\"2.0\"><channel><title>PICA</title><lastBuildDate>$(date)</lastBuildDate>"
while IFS=$'\t' read -r H T L P; do
   PP=$(echo "$P" | sed 's|\([0-9]*\)-\([0-9]*\)-\([0-9]*\)\ \([0-9]*\):\([0-9]*\)|\3/\2/\1 \4:\5|')
   echo "   <item><title>$T</title><guid>$D$H</guid><pubDate>$(date -d "$PP")</pubDate><description>$L</description></item>"
done < <( paste _? )
echo "</channel></rss>"
rm -f _{1,2,3,4} "$O"

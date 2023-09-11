#!/bin/bash

urls="$(pwd)/urls.txt"
poc="$(pwd)/xss.txt"

# Llamamos a Dalfox 
echo "Empezamos a probar XSS con dalfox"
for line in $urls
do
  dalfox url "$line" -o xss.txt
done 

# Llamamos a xsstrike
echo "Empezamos a escanear con xsstrike"
for line in $urls
do
  python3 /root/tools/XSStrike/xsstrike.py -u "$line" --crawl -l 3 >> $poc
done


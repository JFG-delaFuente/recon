#!/bin/bash

urls="$(pwd)/urls.txt"
poc="$(pwd)/xss.txt"
templates="/root/nuclei-templates/reflected-xss"

# Llamamos a nuclei para probar XSS
echo "Empezamos a escanear los XSS con nuclei"
for line in $(cat $urls)
do
  nuclei -u "$line" -t $templates 
done

# Llamamos a Dalfox
#echo "Empezamos a probar XSS con dalfox"
#for line in $(cat $urls)
#do
#  echo $urls, $line
#  dalfox url "$line" -o xss.txt
#done



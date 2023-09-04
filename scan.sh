#!/bin/bash

# Variables
id="$1"
ppath="$(pwd)"
scope_path="$ppath/scope/$id"

timestamp=$(date +%s)
scan_path="$ppath/scans/$id-$timestamp"

# Exit if scope path does not exists
if [ ! -d $scope_path ]; then
    echo "Path no existe"
    exit 1
fi

mkdir -p "$scan_path"
cd "$scan_path"

############################################### Empezamos a escanear #####>
echo "Empezamos a escanear las roots"
cat "$scope_path/roots.txt"
cp -v "$scope_path/roots.txt" "$scan_path/roots.txt"

# Buscar subdominios
cat "$scan_path/roots.txt" | assetfinder --subs-only | anew subs.txt | wc -l
lines=$(cat "$scan_path/roots.txt")
for line in $lines
do
    python3 /root/tools/Sublist3r/sublist3r.py -d $line | anew subs.txt | wc -l
done



# Probar si resuelven los subdominios
cat "$scan_path/subs.txt" | httprobe -c 50 --prefer-https | anew resolve.txt | wc -l

# Crawling
timeout 6000s cat "$scan_path/resolve.txt" | waybackurls >> crawl.txt

# Sacar parametros
arjun -w $ppath/subs.txt -oT parameters
paramspider -l $ppath/subs.txt | anew parameters
#################################################### LOGICA DE SCAN ######>

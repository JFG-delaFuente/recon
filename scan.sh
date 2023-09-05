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



# Prueba de subdomain takeovers
#subjack -w "$scan_path/subs.txt" -t 100 -timeout 30 -o results.txt -ssl`


# Probar si resuelven los subdominios
cat "$scan_path/subs.txt" | httprobe -c 50 --prefer-https | anew resolve.txt | wc -l

# Crawling
timeout 6000s cat "$scan_path/resolve.txt" | waybackurls >> crawl.txt

# Eliminar aquellos que no dan status code 200
cat "$scan_path/crawl.txt" | httpx -mc 200 -timeout 1 >> urls.txt # timeout de 1 segundo


#################################################### LOGICA DE SCAN ######>

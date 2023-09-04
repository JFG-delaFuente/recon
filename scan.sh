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

# Utilizamos las tools
# cat "$scan_path/roots.txt" | /home/jose/tools/haktrails/haktrails subdom>
cat "$scan_path/roots.txt" | subfinder | anew subs.txt | wc -l
#cat "$scan_path/roots.txt" | /home/jose/tools/shuffledns/cmd/shuffledns/s>

# DNS RESOLUTION - Resolve discovered subdomains
#/home/jose/tools/puredns/puredns resolve "$scan_path/subs.txt" -r "$ppath>
#/home/jose/tools/dnsx/cmd/dnsx/dnsx -l "$scan_path/resolved.txt" -json -o>

# Probar si resuelven los subdominios
cat "$scan_path/subs.txt" | httpx -mc 200 | anew resolve.txt | wc -l

# Crawling
timeout 3000s cat "$scan_path/resolve.txt" | waybackurls >> crawl.txt

#################################################### LOGICA DE SCAN ######>

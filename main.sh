#!/bin/bash

# ------------------------------------------------------------
# Subdomain Enumeration Pipeline
#
# Automates passive and active subdomain enumeration using
# Sublist3r, Subfinder, PureDNS, AltDNS, and MassDNS.
# ------------------------------------------------------------

if [[ $# -ne 1 ]]; then
	echo "Usage: ./main.sh <domain>"
	exit 1
fi

domain="$1"

####################################
# Configuration
####################################

# Update these paths to match your local installation.
PYTHON_PATH=~/python3_venv/bin/
GO_PACKAGES_PATH=~/go/bin/

MAX_FOR_ALT=50

OUTPUT_DIR="outputs/$domain/"
mkdir -p "$OUTPUT_DIR"

####################################
# Step 1 - Passive Enumeration
####################################
"${PYTHON_PATH}python" ./Sublist3r/sublist3r.py -d "$domain" -o "${OUTPUT_DIR}sublistr.txt"
"${GO_PACKAGES_PATH}subfinder" -d "$domain" -o "${OUTPUT_DIR}subfinder.txt"

cat "${OUTPUT_DIR}sublistr.txt" "${OUTPUT_DIR}subfinder.txt" | sort -u > "${OUTPUT_DIR}passive.txt"

####################################
# Step 2 - Active Enumeration
####################################
"${GO_PACKAGES_PATH}puredns" bruteforce wordlists/subdomains-top1million-20000.txt "$domain" -r wordlists/resolvers-trusted.txt -w "${OUTPUT_DIR}puredns.txt"

####################################
# Step 3 - Alternate Hostname Enumeration
####################################
cat "${OUTPUT_DIR}passive.txt" "${OUTPUT_DIR}puredns.txt" | sort -u | head -n $MAX_FOR_ALT > "${OUTPUT_DIR}pre_altdns.txt"
altdns -i "${OUTPUT_DIR}pre_altdns.txt" -w wordlists/altdns-words.txt -o "${OUTPUT_DIR}gen_subs.txt"
massdns -s 100 -r wordlists/resolvers-trusted.txt -t A -o S -w "${OUTPUT_DIR}massdns.out" "${OUTPUT_DIR}gen_subs.txt"
awk '{print $1}' "${OUTPUT_DIR}massdns.out" | sed 's/.$//' > "$OUTPUT_DIR"altdns.txt

####################################
# Step 4 - Generate Final Results
####################################
final_size=$(cat "${OUTPUT_DIR}altdns.txt" "${OUTPUT_DIR}puredns.txt" "${OUTPUT_DIR}passive.txt" | sort -u  | wc -l | cut -d ' ' -f 1)
echo -n "final.txt will contain $final_size unique subdomains. Create it? (y/n): "
read isCreate

if [[ $isCreate == 'y' ]]; then
	cat "${OUTPUT_DIR}altdns.txt" "${OUTPUT_DIR}puredns.txt" "${OUTPUT_DIR}passive.txt" | sort -u > "${OUTPUT_DIR}final.txt"
	echo "final.txt is in $OUTPUT_DIR directory"
else
	echo "You can access generated subdomains in the text files in $OUTPUT_DIR"
fi

####################################
# Step 5 - Cleanup
####################################
rm -f "${OUTPUT_DIR}massdns.out"
rm -f "${OUTPUT_DIR}gen_subs.txt"

## Acknowledgements - sublister, subfinder, puredns, seclists, trickest resolvers, altdns, massdns

# Time Taken
# Sublister, Subfinder, PureDns - 2 Mins
# AltDns & MassDns - 10 Mins with 50 Max Size
# AltDns & MassDns - 15 Mins with 100 Max Size

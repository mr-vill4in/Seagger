#!/bin/bash

echo -n "file name:"
read file 

subfinder -dL $file -o subfinder_d.txt

# Subdomain collection
cat $file | while read in; do
    assetfinder "$in" | tee -a assetfinder.txt
done

# Merge results
cat subfinder_d.txt | tee -a sub.txt
cat assetfinder.txt | tee -a sub.txt

rm assetfinder.txt subfinder_d.txt 

# Normalize protocol
sed -i 's/http:\/\//https:\/\//g' sub.txt

# Deduplicate
sort sub.txt | uniq | tee -a sub3.txt 
rm sub.txt

# Filter only in-scope domains
cat $file | while read in; do
    cat sub3.txt | grep "$in" | tee -a subdomain.txt
done

rm sub3.txt

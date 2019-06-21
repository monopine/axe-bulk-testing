# Uncomment Sites and add urls to test in the following format. 'http://example/1' 'http://example/2' 'http://example/3'
#Sites=( 'http://example/1' 'http://example/2' 'http://example/3' )

counter=0;

rm -rf results/axe-results*.json

for url in "${Sites[@]}";
do
	# see axe documentation for sample flags and try axe -h for 
	axe $url -s results/axe-results-$counter.json --show-errors --load-delay 90
	counter=$((counter+1))
done

# remove the wrapping braces of each file
sed -i -e :a -e '1d;$d;N;2,2ba' -e 'P;D' results/axe-results-*.json

#comma delimate all results into one file
sed -s '$a,' results/axe-results-*.json > results/all-results.json

# Remove last line
sed -i -e '$d' results/all-results.json

# add braces to the beginning and end of the file
sed -i '1s/^/[/' results/all-results.json
sed -i -e "\$a]" results/all-results.json

node axe-report.js

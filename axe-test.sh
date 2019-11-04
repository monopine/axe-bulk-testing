# Add urls to Sites array to test -- bash arrays aren't comma delimated ;)
# TODO: Parse these from an input source instead from the hardcoded array below ¯\_(ツ)_/¯
# -------------------------------------------------
# Sites=( 
# 'http://example/1' 
# 'http://example/2'
# 'http://example/3'
# )
# -------------------------------------------------
# This script requires axe-cli
# https://github.com/dequelabs/axe-cli
# -------------------------------------------------

Sites=(
	'https://10up.com/' 
	'https://10up.com/about/'
	'https://10up.com/our-work/'
	'https://10up.com/giving-back/'
	'https://10up.com/blog/'
)

counter=0;

# Optionally remove previous results by uncommenting:
# rm -rf results/axe-results*.json

# generate unique results folders
timestamp=$(date +%s)

if [ -d "results" ] 
then
    mkdir results
fi

mkdir results/results-$timestamp

for url in "${Sites[@]}";
do
	# see axe documentation for sample flags and try axe -h for help
	axe $url --rules image-alt -s results/results-$timestamp/axe-results-$counter.json --show-errors --load-delay=500
	counter=$((counter+1))
done

# remove the wrapping braces of each file
sed -i -e :a -e '1d;$d;N;2,2ba' -e 'P;D' results/results-$timestamp/axe-results-*.json

#comma delimate all results into one file
sed -s '$a,' results/results-$timestamp/axe-results-*.json > results/results-$timestamp/all-results.json

# Remove last line
sed -i -e '$d' results/results-$timestamp/all-results.json

# add braces to the beginning and end of the file
sed -i '1s/^/[/' results/results-$timestamp/all-results.json
sed -i -e "\$a]" results/results-$timestamp/all-results.json

node axe-report.js results/results-$timestamp/all-results.json

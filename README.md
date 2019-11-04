# axe-bulk-testing
Bulk testing script for Axe a11y testing

## To Install ##
- `npm install`
- To run the test, edit axe-test.sh with url's to be tested and run `./axe-test.sh` from the terminal (make sure it's executable `chmod +x axe-test.sh`)
- Results are output to the results directory

## Configuration ##
By default, the script just checks for the existance of `alt` data on images. To perform additional tests, edit the axe cli command being run. See the line below `# see axe documentation for sample flags and try axe -h for help` to edit cli flags.
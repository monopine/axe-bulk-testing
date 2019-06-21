var fs = require('fs');
var report = require('./results/all-results.json');

let reportOutput = [];

report.forEach( function( entry ) {

	if ( entry.violations.length ) {

		entry.violations.forEach( function( violation ) {

			let nodes = violation.nodes.map( function( node ) {
				return node.html
			});

			const item = {
				"url": entry.url,
				"violation": violation.id,
				"items": nodes
			};

			reportOutput.push( item );

		});

	}

});

var matchHtmlRegExp = /["'&<>]/

var escapeHTML = function (string) {
	var str = '' + string
	var match = matchHtmlRegExp.exec(str)

	if (!match) {
		return str
	}

	var escape
	var html = ''
	var index = 0
	var lastIndex = 0

	for (index = match.index; index < str.length; index++) {
		switch (str.charCodeAt(index)) {
			case 34: // "
				escape = '&quot;'
				break
			case 38: // &
				escape = '&amp;'
				break
			case 39: // '
				escape = '&#39;'
				break
			case 60: // <
				escape = '&lt;'
				break
			case 62: // >
				escape = '&gt;'
				break
			default:
				continue
		}

		if (lastIndex !== index) {
			html += str.substring(lastIndex, index)
		}
  
		lastIndex = index + 1
		html += escape
	}
  
	return lastIndex !== index
	  ? html + str.substring(lastIndex, index)
	  : html
}

var buildReport = function( reportObj ) {

	let HTML = reportObj.map( function( entry ){

		const items = escapeHTML( entry.items );

		return `
			<div class="entry">
				<h2>${entry.violation}</h2>
				<h3>${entry.url}</h3>
				<p><code>${items}</code></p>
			</div>
		`;
	});

	HTML = HTML.join('\n');

	return `
		<!doctype html>
		<html class="no-js" lang="">
		
		<head>
		  <meta charset="utf-8">
		  <title>Axe Report</title>
		  <meta name="description" content="">
		  <!-- Place favicon.ico in the root directory -->
		</head>
		
		<body>
		
			<h1>Axe Report</h1>
			${HTML}
		</body>
		
		</html>
	
	`;

};

var data = buildReport( reportOutput );

fs.writeFile("test-report.html", data, (err) => {
	if (err) console.log(err);
	console.log("Successfully Written to File.");
});
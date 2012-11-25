$(document).ready(function() {

	specialQueries = {
		"feynman" : "Always go with the chocolate ice cream.",
		"big data" : "Give man Hadoop cluster he gain insight for a day. Teach man build Hadoop cluster he soon leave for better job — @BigDataBorat",
		"dieter rams" : "Good design is as little design as possible.",
		"openpaper" : "♥",
		"42" : "A clever one you are!",
		"hacker news": "Only the finest source of technology awesomeness and asshatery.",
		"ivory tower": "RIP: Destroyed by OpenPaper - 2012.",
		"science": "Well, dont't be too specific...",
		"answer": "42",
		"neo": "Blue or red pill?",
		"awesome": "I know what you are but what am I?",
		"map reduce": "Ain't no party like a map reduce party.",
		"ted": "Good name.",
		"queen's": "Cha Gheill!",
		"bayes": "Is this Bayesian? You know I'm a strict Bayesian, right?",
		"statistics": "An exhaustive peer-reviewed study has revealed 62.381527% of all statistics are made up on the spot.",
		"john connors": "The machines rose from the ashes of the nuclear fire.",
		"euclid": "function gcd(a, b) { return b ? gcd(b, a % b) : a; }",
		"singularity": "Technology has been a double-edged sword since fire kept us warm but burned down our villages - Kurzweil."
	};

	// Validate keyup event is alphabetic character
	// If character is valid set focus to next input box
	$("form").delegate ("input", "keyup", function() {
		isSpecial(($(this).val()).toLowerCase());	
	});

})

var isSpecial = function( letters ) {

	if ( specialQueries[ letters ] ) {
		$("p").text( specialQueries [letters] );
		$("input").css('borderColor', "#9eedc1");
		$("input").css('boxShadow', "#9eedc1");
	} else {
		$("p").text( "Academic papers for all." );
		$("input").css('borderColor', "#9ecaed");
		$("input").css('boxShadow', "#9ecaed");
	}

} 
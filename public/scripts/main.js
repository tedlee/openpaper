$(document).ready(function() {

	specialQueries = {
		"feynman" : "Always go with the chocolate ice cream.", 
		"tyson" : "Space is awesome",
		"big data" : "Give man Hadoop cluster he gain insight for a day. Teach man build Hadoop cluster he soon leave for better job — @BigDataBorat",
		"dieter rams" : "Good design is as little design as possible.",
		"openpaper" : "♥",
		"42" : "A clever one you are!",
		"hacker news": "Only the finest source of technology awesomeness and asshatery"
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
	} else {
		$("p").text( "Academic papers for all." );
	}

} 
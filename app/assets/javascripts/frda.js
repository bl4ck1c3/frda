$(document).ready(function(){

  $('.scrollspy-content').scrollspy({offset: 30});

  $('.overview .nav-pills a:first').tab('show');

	// elements defined with these classes can be hidden by default and then show when the page loads
	//  useful when you have non javascript friendly DOM elements you need to hide for no JS browsers so you can include a <noscript> tag with
	//   non JS versions
  showOnLoad();

});

function showOnLoad() {
	$(".showOnLoad").show();
	$('.showOnLoad').removeClass('hidden');	
}

<?php
/*
Plugin Name: Processing js Easy
Plugin URI:
Description: Includes and executes graphical javascript applications that have been written with processing (.pde). HowTo: Upload your processing .pde files via ftp into the wp-content/uploads/ directory. You can also use .txt files and the media uploader, whatever you prefer. Use [processing]file_name.pde[/processing] in your page or post. If the browser can not show the content, the plugin provides the file as a download and a link to the processing website. Thanks to Ramoonus, who did the foundation for this. I did this plugin, because his direct text didn't work for me with the new Wordpress Version. The Version Number of this plugin will always be the same as the Processing JS Version.
Version: 1.4.1
Author: Julian Kogler
Author URI: http://ny24.at
License: GPL2
*/
/*  Copyright 2013 Julian Kogler

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License, version 2, as 
    published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/

/* Registers the script tag in Wordpress */
wp_enqueue_script('processing', plugins_url('processing.js', __FILE__), false, '1.4.1');

/* Main Code */
function a_function_that_does_processing( $name, $content="" ) {
	/* Sets the path of the blog in $path */
	$path = get_bloginfo(wpurl);
	/* Open the content - if it can't open, show thumbnail and an alternative download of the source code */
	echo '<canvas datasrc="'.$path.'/wp-content/uploads/'.$content.'">';
	echo '<p><b>Unfortunately your browser is not able to show this content.</b>';
	/* If the Post has a thumbnail, show it */
	if(has_post_thumbnail()){
		echo get_the_post_thumbnail();
	}
	echo'<p>You can download <a href="'.$path.'/wp-content/uploads/'.$content.'">'.$content.'</a> (Sourcecode) and compile it with <a href="http://processing.org/download/">Processing</a>.</p></canvas>';
}
/* Generating the shortcode */
add_shortcode("processing", "a_function_that_does_processing");
?>
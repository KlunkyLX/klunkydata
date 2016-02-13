<?php
/*
Plugin Name: Processing.js
Plugin URI: http://www.ramoonus.nl/wordpress/processing-js/
Description: Processing.js is the sister project of the popular Processing visual programming language, designed for the web. Processing.js makes your data visualizations, digital art, interactive animations, educational graphs, video games, etc. work using web standards and without any plug-ins. 
Version: 1.4.8
Author: Ramoonus
Author URI: http://www.ramoonus.nl/
License: GPL2
*/

/* Javascript */
function rw_processing() {
	wp_deregister_script( 'processing' ); //deregister
	// when debug is truewp_enqueue_script( 'processing', plugins_url( '/js/processing-1.4.8.min.js', __FILE__ ), false, '1.4.8' );
	// wp_enqueue_script( 'processing', plugins_url( '/js/processing-1.4.8.js', __FILE__ ), false, '1.4.8' );
	// else
	wp_enqueue_script( 'processing', plugins_url( '/js/processing-1.4.8.min.js', __FILE__ ), false, '1.4.8' );
}

add_action( 'init', 'rw_processing' );

/* Shortcode */
function rw_processing_sc( $attr, $content ) {
	// open
	echo '<script type="text/processing" data-processing-target="processingcanvas">';
	// return content
	echo $content;
	// close
	echo '</script>';
	echo '<canvas id="processingcanvas"></canvas>';
}

add_shortcode( "processing", "rw_processing_sc" );
add_shortcode( "processingjs", "rw_processing_sc" );

/* Remove WordPress Auto P */
remove_filter( 'the_content', 'wpautop' );
remove_filter( 'the_content', 'wptexturize' );
// return after processing
add_filter( 'the_content', 'wpautop', 99 );
add_filter( 'the_content', 'wptexturize', 99 );
?>
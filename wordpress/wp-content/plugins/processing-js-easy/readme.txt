=== Processing-js-Easy ===
Contributors: Ny24
Donate link:
Tags: Javascript, Graphic, Processing, processingjs, processing-js, Application, processing js, js, App
Requires at least: 3.5.1
Tested up to: 3.5.1
Stable tag: trunk
License: GPLv2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html

Includes and executes graphical javascript applications that have been written with processing (.pde)

== Description ==

I created this plugin, because direct code didn't work for me with the new Wordpress Version.
The Version Number of this plugin will always be the same as the Processing JS Version.

If you want responsive Processing, try this directly in the .pde file:

void draw(){
	size(window.innerWidth, window.innerHeight);
}

Thanks to:
- Ramoonus, who did the foundation for this.
- Processing JS (http://processingjs.org/)

== Installation ==


1. Content must be in the `/wp-content/plugins/processing-js-easy` directory
2. Activate the plugin through the 'Plugins' menu in WordPress
3. Upload your processing .pde files via ftp into the wp-content/uploads/ directory.
   You can also use .txt files and the media uploader, whatever you prefer
4. Use [processing]file_name.pde[/processing] in your page or post.
   If the browser can't show the content, the plugin provides the file as a download and a link to the processing website.

== Frequently Asked Questions ==

- none -

== Screenshots ==

- none -

== Changelog ==

= 1.4.1 = First Version (due to Processingjs Version)
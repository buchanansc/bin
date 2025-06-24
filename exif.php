#!/usr/bin/env php
<?php
/**
 * Manipulate EXIF data of JPEG images.
 *
 * @author    Scott Buchanan
 * @copyright 2025 Scott Buchanan
 * @license   http://www.opensource.org/licenses/mit-license.php The MIT License
 * @version   r4 2025-06-23
 * @link      https://github.com/buchanansc
 */
require_once ('CLIScript.php'); 

function showEXIF($file)
{
	$data = exif_read_data($file);
	print_r($data);
	exit;
}

/**
 * This needs to be updated as it renders the image all over again.
 */
function removeEXIF($file)
{
	try {
		$res = imagecreatefromjpeg($file);
		imagejpeg($res, $file, 100);
	} catch(Exception $e) {
	   	echo 'Exception caught: ',  $e->getMessage(), "\n";
	}
}

$script = new CLIScript(array(
	'name' => 'exif.php',
	'description' => 'Manipulate EXIF data of JPEG images.',
	'usage' => '[OPTION]... [FILE]',
	'options' => array(
		'show' => array(
			'short' => 's:',
			'long' => 'show:',
			'description' => 'Show EXIF data'
		),
		'remove' => array(
			'short' => 'r:',
			'long' => 'remove:',
			'description' => 'Delete EXIF data'
		)
	)
));

$args = $script->getArgs();

if($_SERVER['argc'] <= 1) {
	$script->usage();
	exit;
} else
	array_shift($_SERVER['argv']);

$file = array_pop($_SERVER['argv']);

if(!is_file($file))
	trigger_error("No file found");

if(exif_imagetype($file) != IMAGETYPE_JPEG)
	trigger_error("Not a JPEG image");

if ($script->getArg("show"))
	showEXIF($file);
else if ($script->getArg("remove"))
	removeEXIF($file);
else
	$script->usage();




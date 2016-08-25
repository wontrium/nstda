<?php  
  
//include('connect_realtime.php');  
  
	function url_get_contents ($Url) {
    		if (!function_exists('curl_init')){ 
        		die('CURL is not installed!');
    		}
    		$ch = curl_init();
    		curl_setopt($ch, CURLOPT_URL, $Url);
    		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    		$output = curl_exec($ch);
    		curl_close($ch);
    		return $output;
	}
	header("content-type:text/html;charset=UTF-8");
	$url = "http://122.155.171.124/other/nstdamap/location.php";
	$json = file_get_contents($url);
	//$json = url_get_contents($url);
	$data = json_decode($json, true);
	// print_r($data);
	//echo "<table>";	
	foreach ($data['vehicle'] as $items => $item) {
		if ($item['id'] == 1) {
			$returnString = ($item['latitude'] . '&' . $item['longitude'] .  '&' . $item['heading'] . '&' . 0 . '&' . 0 .  '&' . $item['id'] . '#'); 

		} else if ($item['id'] == 2) {
			$returnString .= ($item['latitude'] . '&' . $item['longitude'] .  '&' . $item['heading'] . '&' . 0 . '&' . 0 .  '&' . $item['id'] . '#'); 

		} else if ($item['id'] == 3) {
			$returnString .= ($item['latitude'] . '&' . $item['longitude'] .  '&' . $item['heading'] . '&' . 0 . '&' . 0 .  '&' . $item['id']); 

		}

	}
	//echo "</table>";
	echo $returnString;
  
?>  
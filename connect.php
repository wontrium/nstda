<?php  
  
$user = 'root';  
$pass = '';  
$dbName = 'nstda_map';  
  
$mysqli = new mysqli("localhost", $user, $pass, $dbName);  
  
if($mysqli->connect_errno)  
{  
    echo "Failed to connect: " . $mysqli->connect_error;  
} 
  
?>  
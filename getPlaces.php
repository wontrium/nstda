<?php  
  
include('connect.php');  
  
$query = 'SELECT * FROM place ORDER BY id_place ASC';  
  
$result = $mysqli->query($query);  
  
$returnString = '';  
  
while($row = $result->fetch_assoc())  
{  
    $returnString .= ($row['name'] . '&' . $row['latitude'] . '&' . $row['longitude'] . '#');  
}  
  
echo $returnString;  
  
?>  
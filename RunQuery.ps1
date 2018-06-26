param(
    [string]$database,
    [string]$query,
    [string]$login,
    [string]$file_output,
    [string]$password

)
$query_data = Get-Content -path $query
$connection = New-Object -TypeName System.Data.OleDb.OleDbConnection
$connection.ConnectionString = "Provider=OraOLEDB.Oracle;Data Source=" + $database + ";Persist Security Info=False;Password=" + $password + ";User ID=" + $login
$command = $connection.CreateCommand()
$command.CommandText = $query_data

$connection.Open()
$datareader = $command.ExecuteReader()

$data = @()
$row = ""
while ($datareader.read()){
    For ($i=0; $i -lt $datareader.FieldCount; $i++){
        $row = $row + "`"" +  $datareader.GetValue($i).ToString()  + "`","
    }
    $data = $data + $row
    $row = ""
}

$header=""
For ($i=0; $i -lt $datareader.FieldCount; $i++){
    $header = $header + "`"" +  $datareader.GetName($i).ToString()  + "`","
}

    

New-Item "$file_output" -Type File
Add-Content -Path "$file_output" -Value $header

foreach ($lrow in $data){
    Add-Content -Path "$file_output" -Value $lrow
    #Write-Host $lrow
}
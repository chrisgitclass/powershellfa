# Replace this with yours ;)
$YourURI = 'https://fapowershellapi.azurewebsites.net/api/HttpTrigger1?code=cKEEWtWqMdh1wX5sz1SYz/Dyhz6l3BRyqwFdzaPj1UKhiDRZMuqJ8Q=='

# Try a normal GET
#Invoke-RestMethod -Method Get -Uri $YourURI
# GET using the "name" query parameter
Invoke-RestMethod -Method Get -Uri "$($YourURI)&Name=World!&tag=chrisgitclass"

# Use the POST method provided
#$Body = @{Name = 'Max Power'} | ConvertTo-Json
#write-output $Body
#Invoke-RestMethod -Method Post -Body $Body -Uri "$($YourURI)" -ContentType 'application/json'
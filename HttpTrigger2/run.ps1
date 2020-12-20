using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP2 triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}





# Supported query parameters:
  # tag

# Create an empty list to append results into
$ResultList = New-Object System.Collections.Generic.List[object]

# Set the URI, with or without a user-supplied tag
$BaseURI = 'https://api.github.com'
If ($Request.Query.tag) {
    Write-Host "2Doing tag....."
    $BaseURI = "$($BaseURI)/users/$($Request.Query.tag)"
}

Try {
    # Get the latest 10 posts (RSS feed default is 10 per page)
    Write-Host "Doing tag.....$($BaseURI)"
    $iwr = Invoke-WebRequest -Uri "$BaseURI" -UseBasicParsing
} Catch {
    # Invoke-WebRequest is weird. Just silently fail
    Write-Host "Doing tag.....ERROR ($ERROR[0])"
}


Write-Host "iwr..... ($iwr)"
If ($iwr) {
    
    Write-Host "2iwr..... $($iwr.updated_at)"
    # Cast the RSS feed as XML
    $xml = $iwr | ConvertFrom-Json

        # Assemble the most useful properties in an object
        $newObject = [PSCustomObject]@{
            Date        = $xml.updated_at -as [DateTime]
            url         = $xml.url
            id          = $xml.id
        }
        
        Write-Host "newObject..... ($newObject)"
        # Append the object into the collection
        [void]$ResultList.Add($newObject)

    # Return the objects in JSON format. Azure Functions likes Out-String
    $return = $ResultList | ConvertTo-Json | Out-String

    # By default, Azure Functions wants to output the contents of $res
    #Out-File -Encoding Ascii -FilePath $res -inputObject $return
} Else {
    # Can't get Azure Functions to respect -Verbose, even trying this:
    # https://justingrote.github.io/2017/12/25/Powershell-Azure-Functions-The-Missing-Manual.html#logs-panel-and-verbosedebug-output
    # help, haha
    Write-Verbose 'Invoke-WebRequest returned no results' 4>&1
}
























Write-Host "return=$return"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $return
})

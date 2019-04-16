using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger GetGroup function processed a request."

# Interact with query parameters or the body of the request.
$DisplayName = $Request.Query.DisplayName
if (-not $DisplayName) {
    $DisplayName = $Request.Body.DisplayName
}

if ($DisplayName) {
    $status = [HttpStatusCode]::OK
       
    #region Check if Group Exists
    $params = @{
        'DisplayName'  = $DisplayName
        'ClientID'     = $env:ClientID
        'ClientSecret' = $env:ClientSecret
        'TenantID'     = $env:Tenantid
        'Verbose'      = $true
    }
    $body = Get-AADGroup @params
    #endregion
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Please pass a DisplayName for Azure Active Directory Group on the query string or in the request body."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })
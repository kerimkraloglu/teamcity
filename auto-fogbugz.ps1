$buildType = $args[0]
$user = $args[1]
$pass = $args[2]
$pair = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$Headers = @{
    Authorization = $basicAuthValue
}
$Url = "http://localhost/httpAuth/app/rest/builds"
$body = @{	
	locator = 'buildType:(id:'+$buildType+'),running:true'
	fields= 'count,build(buildTypeId,status,number,agent)'	
}
$response = Invoke-WebRequest -Uri $Url -Body $body -Headers $Headers 

IF($response.StatusCode -eq '200'){
	$xml = [xml]$response.Content

	$assignedTo = $args[3]
	$buildId = $args[4]
	$title = $args[5]
	$event = $([System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'Turkey Standard Time').ToString()) + " - " + "http://127.0.0.1:8111/buildConfiguration/" + $buildType + "/" + $args[6] + "?buildTab=log"

	IF(($xml.builds.build.buildTypeId -eq $buildType) -and ($xml.builds.build.number -eq $buildId)){
		switch -CaseSensitive ($xml.builds.build.status) 
		{ 
			'SUCCESS' {
				Write-Host ($xml.builds.build.status)
				break
			} 
			'FAILURE' {
				$postParams = @{
					token = "your fogbugz token";
					ixPersonAssignedTo = $assignedTo;
					sCategory = "Task";
					ixProject = $args[7];
					ixArea = $args[8];
					ixFixFor = $args[9];
					sTitle = "#" + $buildId + " " + $title + " - Tests Failed";
					sEvent = $event;
					sTags = "TeamCity";
				}
				$json = $postParams | ConvertTo-Json
				Invoke-WebRequest -Uri 'https://teamcity.fogbugz.com/api/new' -Method POST -Body $json -ContentType 'application/json' -UseBasicParsing
				break
			} 
			default { Write-Host ('Unknown status') }
		}
	}
	ELSE{
		Write-Host ('BuildTypeID or BuildID was not found.')
	}
}
ELSE{
	Write-Host ('Something went wrong')
}


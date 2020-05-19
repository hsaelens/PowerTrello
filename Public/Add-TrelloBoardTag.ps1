function Add-TrelloBoardTag {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[object]$Board,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$TagId
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try {
			$uri = '{0}/boards/{1}/idTags' -f $script:baseUrl, $Board.id
			$body = @{
				key = $trelloConfig.APIKey
				token=$trelloConfig.AccessToken
				value = $tagId
			}
			$invParams = @{
				Uri = $uri
				Method = 'POST'
				Body = $body
			}
			$null = Invoke-RestMethod @invParams
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}
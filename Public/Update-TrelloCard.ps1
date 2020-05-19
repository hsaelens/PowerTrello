function Update-TrelloCard {
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[object]$Card,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Description,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[datetime]$Due,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ListId
	)

	$ErrorActionPreference = 'Stop'

	$invParams = @{
		Method = 'PUT'
	}

	$paramToTrelloFieldMap = @{
		'Name'        = 'name'
		'Description' = 'desc'
		'Due'         = 'due'
		'ListId'      = 'idList'
	}
	$PSBoundParameters.GetEnumerator().where({ $_.Key -ne 'Card' }).foreach({
			$fieldName = $paramToTrelloFieldMap[$_.Key]
			if ($_.Key -eq 'Due') {
				$fieldValue = Get-Date -Date $_.Value -Format 'yyyy-MM-dd'
			} else {
			if ($_.Value.Length -gt 16384)
			{
			  $fieldValue = $_.Value[0..16381] + "..."
			} else {
				$fieldValue = $_.Value
			}
			}
			$invParams.Uri = '{0}/cards/{1}?{2}={3}&{4}' -f $script:baseUrl, $Card.id, $fieldName, $fieldValue, $trelloConfig.String
			$null = Invoke-RestMethod @invParams
		})
}
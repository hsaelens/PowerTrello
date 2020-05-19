function Update-TrelloBoard {
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[object]$Board,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Description
	)

	$ErrorActionPreference = 'Stop'

	$invParams = @{
		Method = 'PUT'
	}

	$paramToTrelloFieldMap = @{
		'Name'        = 'name'
		'Description' = 'desc'
	}
	$PSBoundParameters.GetEnumerator().where({ $_.Key -ne 'Board' }).foreach({
			$fieldName = $paramToTrelloFieldMap[$_.Key]
			if ($_.Value.Length -gt 16384)
			{
			  $fieldValue = $_.Value[0..16381] + "..."
			} else {
				$fieldValue = $_.Value
			}
			$invParams.Uri = '{0}/boards/{1}?{2}={3}&{4}' -f $script:baseUrl, $Board.id, $fieldName, $fieldValue, $trelloConfig.String
			$null = Invoke-RestMethod @invParams
		})
}
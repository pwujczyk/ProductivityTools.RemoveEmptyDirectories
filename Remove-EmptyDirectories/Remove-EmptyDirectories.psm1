function RemoveThumbsDb{
	[CmdletBinding(SupportsShouldProcess=$true)]
	param ($directories)

	$directoriesWithThumbsDb=$directories | Where-Object { $_.GetFiles("Thumbs.db","AllDirectories")}
	foreach($thumbDB in $directoriesWithThumbsDb)
	{
		$dir=$($thumbDB.FullName)
		Write-Host "Directory $dir"
		$files=@(Get-ChildItem -LiteralPath $dir -Attributes !Directory,!Directory+Hidden)
		if ($files.Length-eq 1)
		{
			$thumbDB=$files[0].FullName
			Write-Verbose "Directory $thumbDB contains only Thumbs.db candidate to remove"
			if($PSCmdlet.ShouldProcess("$thumbDB","Remove-Item")){
				Remove-Item -LiteralPath $thumbDB -Force
			}
		}
	}
}


function Remove-EmptyDirectories {
	
	[CmdletBinding(SupportsShouldProcess=$true)]
	param ([string]$Path, [switch]$Recurse, [switch]$FirstRemoveThumbDbFromEmptyDirectories)

	$directories=Get-ChildItem -Directory $Path -Recurse:$Recurse

	if($FirstRemoveThumbDbFromEmptyDirectories)
	{
		RemoveThumbsDb $directories
	}

	Write-Verbose "All directories"
	$directories | ForEach-Object { Write-Verbose $_.FullName}

	$directoriesWithFiles=$directories | Where-Object {-not $_.GetFiles("*","AllDirectories")}
	Write-Verbose "Directories without files"
	$directoriesWithFiles | ForEach-Object { Write-Verbose $_.FullName}

	
	foreach($directory in $directoriesWithFiles){
		if($PSCmdlet.ShouldProcess("$($directory.FullName)","Remove-Item")){
			Remove-Item -LiteralPath $directory.FullName
		}
	}
}

Export-ModuleMember Remove-EmptyDirectories
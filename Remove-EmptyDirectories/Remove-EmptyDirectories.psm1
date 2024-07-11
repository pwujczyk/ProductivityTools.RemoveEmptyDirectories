# This is a private helper function
function RemoveThumbsDb {
	[CmdletBinding(SupportsShouldProcess=$true)]
	param (
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[System.IO.DirectoryInfo[]]$Directories
	)

	PROCESS {
		Write-Verbose "Searching for directories containing only Thumbs.db..."
		# The input $Directories should already be sorted by path length descending.
		foreach ($directory in $Directories) {
			# Get all items in the current directory. -Force to see hidden items.
			$items = @(Get-ChildItem -LiteralPath $directory.FullName -Force)

			# Check if the directory contains exactly one item, and that item is a file named "Thumbs.db"
			if ($items.Count -eq 1 -and $items[0].Name -eq 'Thumbs.db' -and -not $items[0].PSIsContainer) {
				$thumbDbPath = $items[0].FullName
				if ($PSCmdlet.ShouldProcess($thumbDbPath, "Remove file (makes parent directory empty)")) {
					Write-Verbose "Removing '$thumbDbPath' from directory '$($directory.FullName)'"
					Remove-Item -LiteralPath $thumbDbPath -Force
				}
			}
		}
	}
}

function Remove-EmptyDirectories {
	[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
	param(
		[Parameter(Position=0, HelpMessage="The path to search for empty directories. Defaults to the current directory.")]
		[string]$Path,

		[Parameter(HelpMessage="Recursively search subdirectories.")]
		[switch]$Recurse,

		[Parameter(HelpMessage="First remove Thumbs.db from directories that only contain that file.")]
		[switch]$FirstRemoveThumbDbFromEmptyDirectories
	)

	$searchPath = if ([string]::IsNullOrEmpty($Path)) { $PWD.Path } else { $Path }
	Write-Verbose "Starting search in path: $searchPath"

	# Get all directories. We add -Force to include hidden directories.
	# We sort by the length of the FullName descending. This ensures we process the deepest directories first.
	$allDirectories = Get-ChildItem -Path $searchPath -Recurse:$Recurse -Directory -Force | Sort-Object { $_.FullName.Length } -Descending

	if ($FirstRemoveThumbDbFromEmptyDirectories) {
		RemoveThumbsDb -Directories $allDirectories
	}

	Write-Verbose "Searching for empty directories..."
	foreach ($directory in $allDirectories) {
		# After potentially removing Thumbs.db, we check if the directory is empty.
		if ((Get-ChildItem -LiteralPath $directory.FullName -Force).Count -eq 0) {
			if ($PSCmdlet.ShouldProcess($directory.FullName, "Remove empty directory")) {
				Write-Verbose "Removing empty directory '$($directory.FullName)'"
				Remove-Item -LiteralPath $directory.FullName -Force
			}
		}
	}
}

Export-ModuleMember -Function Remove-EmptyDirectories
param (
	[string]$package = "",
    [string]$target = "",
    [string]$ignoreSite = " "
 )

[console]::ForegroundColor = "Yellow"
 Write-Host `n`n"Package:"`t`t$package
 Write-Host "Target root:"`t`t$target`n`n

[console]::ForegroundColor = "White"
$files = Get-ChildItem $target
$updatePackageFolders = Get-ChildItem $package

 function Update-Sites {
 	Param ([object]$path)

	if ($path.FullName -notlike "*$($ignoreSite)*")
	{

		Write-Host Updating site...`t`t$path

	 	#Write-Host "$($path.FullName)\_app_offline.htm"
	 	Rename-Item -Path "$($path.FullName)\_app_offline.htm" -NewName "app_offline.htm"

        #del "$($path.FullName)\_app_offline.htm"

        #Copy-Item -Path "$($package)\app_offline.htm" -Destination "$($path.FullName)\app_offline.htm" -Force

        del "$($path.FullName)\admin" -r
	 	del "$($path.FullName)\*.version"
		#del "$($path.FullName)\*.txt"

		foreach ($folder in $updatePackageFolders)
		{
			Copy-Item -Path $folder.FullName -Destination $path.FullName -recurse -Force
			#Write-Host "$($folder.FullName) -Destination $($path.FullName))"
		}

		#Write-Host "$($path.FullName)\app_offline.htm"
		Rename-Item -Path "$($path.FullName)\app_offline.htm" -NewName "_app_offline.htm"
	}
 }

foreach ($file in $files)
{
	if([System.IO.File]::Exists($file.FullName + '\Web.config'))
    {
    	Update-Sites $file
    } else {

		$tmp = Get-ChildItem $file.FullName

		foreach ($t in $tmp){
			Update-Sites $t
		}

    }
}

[console]::ForegroundColor = "Green"
Write-Host `n`n"Complete"
[console]::ForegroundColor = "Gray"

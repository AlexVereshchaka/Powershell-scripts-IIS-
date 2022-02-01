$sites = Get-Content -Path D:\scripts\allsites.txt
foreach ($site in $sites)
	{
		Write-Host "$site size"
		(Get-ChildItem D:\iis\websites\$site\ftp\ -Recurse | Measure-Object -Property Length -Sum).Sum /1GB
	}

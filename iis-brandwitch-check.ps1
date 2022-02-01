$tmpfile = "D:\scripts\ids.txt"
$yymm = 2201

if (Test-Path -Path $tmpfile)
{
	Clear-Content $tmpfile
}
else { New-Item -Path $tmpfile }
Get-Website | Select -ExpandProperty ID | Out-File -FilePath $tmpfile
$sites = Get-Content -Path $tmpfile
foreach ($site in $sites)
	{
		if (Test-Path -Path C:\inetpub\logs\LogFiles\W3SVC$site\u_ex$yymm*.log)
		{
			$size = & "C:\Program Files (x86)\Log Parser 2.2\logparser.exe" -i:IISW3C -stats:OFF -headers:OFF "SELECT DIV(SUM(sc-bytes), 1048576) AS [Sent MB] FROM C:\inetpub\logs\LogFiles\W3SVC$site\u_ex$yymm*.log"
			try { $intsize = [int]$size/1024 }
			catch
			{
				Write-Warning -Message "Issue with site $site"
				Write-Host "----------"
			}
			if ($intsize -gt 50)
			{
				& appcmd list site -id:$site
				Write-Host ($intsize) -ForegroundColor "Red"
				Write-Host "----------"
			}
		}
	}
Clear-Content $tmpfile
Write-Host ('Done.')
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

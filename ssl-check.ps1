Import-Module WebAdministration
$bindings = Get-ChildItem -Path 'IIS:\SSLBindings'
$counter = 0
foreach ($n in $bindings)
{
    if (($n.host -like '*treepl.co' -or $n.host -like '*trialsite.co') -and $n.Sites -and $n.thumbprint -notlike '96F2E70B68BCFA25C750B7B6AC5B8D8DEC4BF763')
     {
        write-host $n.host
        $counter++
     }
}
if ($counter -eq 0)
{
    Write-Host 'All good.'
}

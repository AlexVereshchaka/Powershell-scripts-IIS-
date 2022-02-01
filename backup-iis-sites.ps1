param (
    [string]$sitesPath = "",
    [string]$backupPath = ""
)

function Backup-Sites {
    Param ([object]$path, [string]$backPath)

    Write-Host Backuping site...`t`t$path

    $ftpPath = Join-Path -Path $path.FullName -ChildPath '\ftp'
    $ftpDestinationPath = Join-Path -Path $backPath -ChildPath "$($path.Name)\ftp"
    Copy-Item $ftpPath -Destination $ftpDestinationPath -Recurse -Force

    $sdfPath = Join-Path -Path $path.FullName -ChildPath '\App_Data\treepl-cms.sdf'
    $sdfDestinationPath = Join-Path -Path $backPath -ChildPath "$($path.Name)\App_Data"
    New-Item -path $sdfDestinationPath -ItemType Directory -Force | out-null 
    Copy-Item $sdfPath -Destination $sdfDestinationPath\'\treepl-cms.sdf' -Recurse -Force
}

$sites = Get-ChildItem $sitesPath

foreach ($site in $sites)
{
    if([System.IO.File]::Exists($site.FullName + '\Web.config'))
    {
        Backup-Sites $site $backupPath
    } else {
        
        $tmp = Join-Path -Path $backupPath -ChildPath $site.Name
        New-Item -path $tmp -ItemType Directory -Force | out-null 
        $res = Get-Item $tmp

        $innerSites = Get-ChildItem $site.FullName

        foreach ($innerSite in $innerSites)
        {
            Backup-Sites $innerSite $tmp
        }
    }
}

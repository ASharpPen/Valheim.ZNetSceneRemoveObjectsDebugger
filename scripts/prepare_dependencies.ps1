# Quick'n'dirty NStrip script for preparing dependencies. Expects NStrip.exe placed in same folder. See https://github.com/bbepis/NStrip

# Output directory to place libraries in. 
# Eg., "C:\YOUR-PATH\Valheim.ZNetSceneRemoveObjectsDebugger\src\Libs"
$outputDir = 

# Path to bepinex profile from which to pick up unity files and potentially mods.
# Eg., C:\Users\YOUR-USER\AppData\Roaming\r2modmanPlus-local\Valheim\profiles\SOME-PROFILE
$profilePath = 

# Path to Valheim main folder for getting the game dlls.
$additionalDependenciesDir = "D:\Games\Steam\steamapps\common\Valheim\valheim_Data\Managed"

function Strip
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $Source,

    [Parameter(Mandatory=$true, Position=1)]
    [string]
    $TargetDir,

    [Parameter(Mandatory=$false, Position=2)]
    [switch]
    $Publicize
  )

  $out = "$outputDir\$TargetDir"

  if (-not(Test-Path $out))
  {
    New-Item -ItemType Directory -Path $out
  }

  if (Test-Path -Path $Source -PathType Leaf)
  {
    $file = Split-Path $Source -Leaf
    $out = Join-Path $out $file
  }

  if($Publicize) { 
    & .\Nstrip.exe -p -cg -d $additionalDependenciesDir $Source $out
  }
  else {
    & .\Nstrip.exe -cg -d $additionalDependenciesDir $Source $out
  }
  
  Write-Host "-Source $Source -TargetDir $out"
}

function CopyFile
{
  [Cmdletbinding()]
  param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $Source,

    [Parameter(Mandatory=$true, Position=1)]
    [string]
    $TargetDir
  )

  $out = "$outputDir\$TargetDir"

  if (-not(Test-Path $out))
  {
    New-Item -ItemType Directory -Path $out
  }

  if (Test-Path -Path $Source -PathType Leaf)
  {
    Copy-Item $Source -Destination $out
  }

  Write-Host "-Source $Source -TargetDir $out"
}

# Valheim
Strip "$additionalDependenciesDir\assembly_valheim.dll" "Valheim" -Publicize
Strip "$additionalDependenciesDir\assembly_utils.dll" "Valheim" -Publicize

# Unit
CopyFile "$profilePath\unstripped_corlib\UnityEngine.dll" "Unity"
CopyFile "$profilePath\unstripped_corlib\UnityEngine.CoreModule.dll" "Unity"
CopyFile "$profilePath\unstripped_corlib\UnityEngine.PhysicsModule.dll" "Unity"
CopyFile "$profilePath\unstripped_corlib\UnityEngine.ImageConversionModule.dll" "Unity"
CopyFile "$profilePath\unstripped_corlib\UnityEngine.UI.dll" "Unity"

Write-Host "Done"
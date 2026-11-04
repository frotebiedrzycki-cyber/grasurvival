$ErrorActionPreference = 'Stop'
$project = 'D:\BlackwoodSurvival\BlackwoodSurvival.uproject'
if (-not (Test-Path -LiteralPath $project)) {
    $near = Join-Path $PSScriptRoot 'BlackwoodSurvival.uproject'
    if (Test-Path -LiteralPath $near) { $project = $near }
    else {
        $project = (Read-Host 'Wpisz pelna sciezke do BlackwoodSurvival.uproject lub katalogu projektu').Trim('"')
        if (Test-Path -LiteralPath $project -PathType Container) { $project = Join-Path $project 'BlackwoodSurvival.uproject' }
    }
}
if (-not (Test-Path -LiteralPath $project -PathType Leaf)) { throw "Nie znaleziono projektu: $project" }
$root = Split-Path -Parent (Resolve-Path -LiteralPath $project).Path
$worldFile = Join-Path $root 'Source\BlackwoodSurvival\Private\BWWorldDirector.cpp'
$menuFile = Join-Path $root 'Source\BlackwoodSurvival\Private\BWMainMenuWidget.cpp'
foreach ($file in @($worldFile, $menuFile)) { if (-not (Test-Path -LiteralPath $file)) { throw "Brakuje pliku $file" } }
$utf8 = [System.Text.UTF8Encoding]::new($false)
$world = [System.IO.File]::ReadAllText($worldFile)
$menu = [System.IO.File]::ReadAllText($menuFile)
$oldInclude = '#include "Engine/SkyLight.h"'
$newInclude = $oldInclude + "`n" + '#include "Components/SkyLightComponent.h"'
if ($world.Contains('#include "Components/SkyLightComponent.h"')) { Write-Host 'SkyLightComponent: juz poprawiony.' }
elseif ($world.Contains($oldInclude)) { $world = $world.Replace($oldInclude, $newInclude) }
else { throw 'Nie znaleziono znacznika SkyLight w BWWorldDirector.cpp; nie wprowadzam zmian.' }
if ($menu.Contains('float VerticalPadding)') -and $menu.Contains('FMargin(8.f, VerticalPadding)')) {
    Write-Host 'MainMenuWidget: juz poprawiony.'
} else {
    if (-not $menu.Contains('float Padding)') -or -not $menu.Contains('FMargin(8.f, Padding)')) { throw 'Nieoczekiwana wersja BWMainMenuWidget.cpp; nie wprowadzam zmian.' }
    $menu = $menu.Replace('float Padding)', 'float VerticalPadding)').Replace('FMargin(8.f, Padding)', 'FMargin(8.f, VerticalPadding)')
}
$backup = Join-Path $root 'BACKUP_PRZED_0_6_1'
New-Item -ItemType Directory -Path $backup -Force | Out-Null
Copy-Item -LiteralPath $worldFile -Destination (Join-Path $backup 'BWWorldDirector.cpp') -Force
Copy-Item -LiteralPath $menuFile -Destination (Join-Path $backup 'BWMainMenuWidget.cpp') -Force
[System.IO.File]::WriteAllText($worldFile, $world, $utf8)
[System.IO.File]::WriteAllText($menuFile, $menu, $utf8)
Write-Host 'GOTOWE: poprawiono dwa bledy C2027 i C4458.' -ForegroundColor Green
Write-Host "Kopie plikow w: $backup"
Write-Host 'Uruchom ponownie kompilacje BLACKWOOD. Jesli pojawia sie inne bledy, wklej log.'

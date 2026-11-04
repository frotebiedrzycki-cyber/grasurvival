# BLACKWOOD v0.6.1 — poprawki C2027 i C4458

Błędy zgłoszone podczas kompilacji pod Unreal Engine 5.8:

- `BWWorldDirector.cpp(115)`: brak kompletnej definicji `USkyLightComponent`. Dodany `#include "Components/SkyLightComponent.h"`.
- `BWMainMenuWidget.cpp(34)`: zmienna lambda `Padding` zasłania pole klasy `UUserWidget::Padding`. Zmieniono nazwę na `VerticalPadding`, również w `FMargin`.

## Użycie

Zamknij Unreal Engine. Pobierz `BLACKWOOD_FIX_0_6_1.ps1` do komputera, następnie uruchom PowerShell i wykonaj:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\sciezka\do\BLACKWOOD_FIX_0_6_1.ps1"
```

Skrypt domyślnie szuka `D:\BlackwoodSurvival\BlackwoodSurvival.uproject`; jeśli go nie znajdzie, zapyta o folder. Przed nadpisaniem tworzy kopie plików w `BACKUP_PRZED_0_6_1`.

Następnie spróbuj kompilacji (najlepiej przez `DIAGNOZA_BLACKWOOD_UE58.cmd`). Ta poprawka dotyczy **dwóch błędów z podanego logu**; nie jest dowodem przejścia pełnej kompilacji w UE5.8.

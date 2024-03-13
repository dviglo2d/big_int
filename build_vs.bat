:: Меняем кодировку консоли на UTF-8
chcp 65001

:: Указываем путь к cmake.exe. Без system32 в PATH ссылки на папки не создаются
set "PATH=%SystemRoot%\system32;c:\programs\cmake\bin"

set build_type=Debug
::set build_type=Release
::set build_type=MinSizeRel
::set build_type=RelWithDebInfo

set "generator=Visual Studio 17"

set "repo_dir=%~dp0"
:: Удаляем обратный слэш в конце
set "repo_dir=%repo_dir:~0,-1%"

:: Генерируем проект
cmake "%repo_dir%" -B "%repo_dir%/../build_vs" -G "%generator%" -A x64^
  -D DV_BIG_INT_BUILD_TESTER=1 -D DV_BIG_INT_UB_SANITIZER=1

:: Компилируем проект
cmake --build "%repo_dir%/../build_vs" --config %build_type%

:: Ждём нажатие Enter перед закрытием консоли
pause

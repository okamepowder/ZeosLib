@setlocal
@rem CODE PAGE UTF-8
chcp 65001

cd "%~dp0" && "C:\Program Files\Git\bin\bash.exe" --login -i -c "./sample-update.sh"

@endlocal

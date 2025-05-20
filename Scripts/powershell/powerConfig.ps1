# powercfg /q
## Get the currently active power plan GUID
$OriginalPlan = $(powercfg -getactivescheme).split()[3]
## Duplicate Current Active Plan
$Duplicate = powercfg -duplicatescheme $OriginalPlan
## Change Name of Duplicated Plan
$CurrentPlan = powercfg -changename ($Duplicate).split()[3] "Custom Power Plan"
## Set New Plan as Active Plan
$SetActiveNewPlan = powercfg -setactive ($Duplicate).split()[3]
## Get the New Plan
$NewPlan = $(powercfg -getactivescheme).split()[3]

## Define power setting GUIDs
$PowerGUID         = '4f971e89-eebd-4455-a8de-9e59040e7347'
$PowerButtonGUID   = '7648efa3-dd9c-4e3e-b566-50f929386280'
$LidClosedGUID     = '5ca83367-6e45-459f-a27b-476b1d01c936'
$SleepGUID         = '96996bc0-ad50-47ec-923b-6f41874dd9eb'
$NetworkCardGUID   = '12bbebe6-58d6-4636-95bb-3218d4c519a6'
$USBGUID           = '2a737441-1930-4402-8d77-b2bebba308a3'
$USBSuspendGUID    = '48e6b7a6-50f5-4782-a5d4-53bb8f07e226'
$HardDiskGUID      = '0012ee47-9041-4b5d-9b77-535fba8b1442'
$HardDiskSleepGUID = '6738e2c4-e8a5-4a42-b16a-e040e769756e'

## POWER BUTTON
# PowerButton - On Battery - 1 = Sleep
# powercfg /setdcvalueindex $NewPlan $PowerGUID $PowerButtonGUID 3
# PowerButton - While plugged in - 3 = Shutdown
# powercfg /setacvalueindex $NewPlan $PowerGUID $PowerButtonGUID 3

## SLEEP BUTTON
## SleepButton - On Battery - 0 = Do Nothing
# powercfg /setdcvalueindex $NewPlan $PowerGUID $SleepGUID 0
## SleepButton - While plugged in - 0 = Do Nothing
# powercfg /setacvalueindex $NewPlan $PowerGUID $SleepGUID 0

## LID CLOSED
## On Battery - 0 = Do Nothing
# powercfg /setdcvalueindex $NewPlan $PowerGUID $LidClosedGUID 0
## While plugged in - 0 = Do Nothing
powercfg /setacvalueindex $NewPlan $PowerGUID $LidClosedGUID 0

## NETWORK CARD
## On Battery - 0 = Never
powercfg /setdcvalueindex $NewPlan $NetworkCardGUID $PowerGUID 0
## While plugged in - 0 = Never
powercfg /setacvalueindex $NewPlan $NetworkCardGUID $PowerGUID 0

## USB - Set USB selective suspend to disabled (never sleep)
## On Battery - 0 = Disabled
# powercfg /setdcvalueindex $NewPlan $USBGUID $PowerGUID 0
## While plugged in - 0 = Disabled
powercfg /setacvalueindex $NewPlan $USBGUID $USBSuspendGUID 0

## HARD DISK - Set to never turn off
## On Battery - 0 = Never
# powercfg /setdcvalueindex $NewPlan $HardDiskGUID $PowerGUID 0
## While plugged in - 0 = Never
powercfg /setacvalueindex $NewPlan $HardDiskGUID $HardDiskSleepGUID 0

## PLAN SETTINGS
## Display Mode - On Battery - 15 = 15 Minutes - While plugged in - 0 = Never
powercfg -change -monitor-timeout-dc 15
powercfg -change -monitor-timeout-ac 0
## Sleep Mode - On Battery - 15 = 15 Minutes - While plugged in - 0 = Never
powercfg -change -standby-timeout-dc 15
powercfg -change -standby-timeout-ac 0

## Apply the new power plan
powercfg /s $NewPlan

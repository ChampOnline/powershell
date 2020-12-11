# Script changeprinters.ps1 by finzlbrother aka rzlbrnft
$ErrorActionPreference = "SilentlyContinue"

# Read print server from the arguments
$OldPrintserver = "dc01"
$NewPrintserver = "DC03"

# Script ends here if no arguments present
if($OldPrintserver -and $NewPrintserver)
{ 
	# Read all existing printers on the old server
	$Printers = Get-WMIObject Win32_Printer -Filter "Name LIKE '%$OldPrintserver%' " 

	# Create empty array for list of old printers
	$oldPrinters = @() 

	if($Printers) 
	{ 
		  # Define network object
		  $global:net = new-Object -com WScript.Network 
          #Get-CimInstance -ClassName Win32_Printer -Filter "Default=True" > asugabe des Default Printers

		  # Path to new printer connection is generated and connected, if printer is default the new printer is also set to default
		  foreach ($Printer in $Printers) 
		  { 

			$newPrinter = "\\" + $NewPrintserver + "\" + $Printer.Sharename

			$global:net.AddWindowsPrinterConnection($newPrinter) 
			if ($Printer.Default) {	$global:net.SetDefaultPrinter($newPrinter) } 
			
			$newPrinter = "" 
			$oldPrinters += $Printer.Name

		  } 

		  #Old printers are deleted
		  foreach ($oldPrinter in $oldPrinters)
		  {
			#$global:net.RemovePrinterConnection($oldPrinter) 
            Remove-Printer -Name $oldPrinter
		  }
	} 
}
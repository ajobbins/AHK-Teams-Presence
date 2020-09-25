#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Set the Webhook URI to POST to
WebhookURI = https://<YOUR URL HERE>

; Set the base directory containing the MS Teams status icons
dir := "C:\<YOUR PATH HERE>"

; File names for the icons
img := [ "available.png"
	, "busy.png"
	, "dnd.png"
	, "away.png"
	, "alert.png" ]
CurrentStatus = None
PreviousStatus = None
LoopCount = 0

SendWebhook()
{
	; POSTs a JSON payload  {"status":"%CurrentStatus%"} to the Webhook URI defined
  global
	try {
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.Open("POST", WebhookURI, 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	Body = {"status":"%CurrentStatus%"}
	WinHTTP.Send(Body)
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
  }
}

	loop
	{
	 CurrentStatus = Unavailable	 
	    for i, v in img {
		    CoordMode Pixel
			ImageSearch, FoundX, FoundY, 1350,1020, 1725, 1080, *5 %dir%\%v%
			if !errorlevel {
				
			switch % img[a_index]
			{
			case "available.png": CurrentStatus = Available
			case "busy.png": CurrentStatus = Busy
			case "dnd.png": CurrentStatus = Do Not Disturb
			case "away.png": CurrentStatus = Away
			case "alert.png": CurrentStatus = %PreviousStatus%
			}
			}	
		}
		if (PreviousStatus != CurrentStatus) {
			SendWebhook()
			}
			PreviousStatus = %CurrentStatus%
			LoopCount++
			sleep 10000
			if (LoopCount > 29) {
				SendWebhook()
				LoopCount = 0
			  
			}
	}

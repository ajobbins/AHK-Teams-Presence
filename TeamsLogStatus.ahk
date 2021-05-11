#NoEnv
#Warn ; Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#SingleInstance force
#Persistent


; Set the Webhook URI to POST to
WebhookURI = <ADD YOUR WEBHOOK URI HERE e.g. https://your-home-assistant:8123/api/webhook/some_hook_id>

;Set a default Status
CurrentStatus = Unknown

; Send a heartbeat webhook anyway every 5 mins
SetTimer, SendWebhook, 300000


lt := new CLogTailer("C:\Users\<USER>\AppData\Roaming\Microsoft\Teams\logs.txt", Func("NewLine"))
return


NewLine(text)
{
global CurrentStatus
ReadStatus := RegExMatch(text, "StatusIndicatorStateService: Added (?!NewActivity)(\w+)", StatusText)
if (ReadStatus != 0)
 {
 CurrentStatus := RegExReplace(StatusText1, "[^A-Z\s]\K([A-Z])", " $1")
 SendWebhook()
 }
}


class CLogTailer {
	__New(logfile, callback){
		this.file := FileOpen(logfile, "r-d")
		this.callback := callback
		; Move seek to end of file
		this.file.Seek(0, 2)
		fn := this.WatchLog.Bind(this)
		SetTimer, % fn, 100
	}
	
	WatchLog(){
		Loop {
			p := this.file.Tell()
			l := this.file.Length
			line := this.file.ReadLine(), "`r`n"
			len := StrLen(line)
			if (len){
				RegExMatch(line, "[\r\n]+", matches)
				if (line == matches)
					continue
				this.callback.Call(Trim(line, "`r`n"))
			}
		} until (p == l)
	}
}

; ----------------------
; Function to POST a JSON payload to the Webhook URI defined
; ----------------------
SendWebhook()
{

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

> [!NOTE]
> This project was built to support Microsoft Teams classic. New Microsoft Teams is not currently supported.
> At this stage, the project will not be updated to support the New Microsoft Teams, but pull requests are welcome.

# AHK-Teams-Presence
AutoHotKey Script for reading MS Team status from the teams log file on Windows and publishing webhook. The script tails the log file for changes and when a RegEx match is found for a status change, the status is published as a webhook. Regardless of state, an update webhook is sent approximately every 5 minutes as a form of keep-alive.

## Dependencies

Make sure you are running a recent version of [AutoHotKey](https://www.autohotkey.com/). This script also works OK with the [portable verison](https://www.portablefreeware.com/index.php?id=217) of AHK

## Setting Up
Copy the files in this repo to somewhere AHK can execute them

## Script Configuration
In TeamsLogStatus.ahk, update the following:

WebhookURI : Set this to the URI where your webhook posts to e.g. https://your-home-assistant:8123/api/webhook/some_hook_id

On the line (19) beginning with 'lt := new CLogTailer', add your local windows username to the file path and confirm the filepath is correct for your teams log file

## Running
Execute the script manually or set up a task to run it automatically

## Processing Output
The script simply passes a status as a JSON payload as a POST to the URI configured. It's up to you how to process that in a useful way. In my own use case, the webhook is processed by my Home Assistant instance and updates an input_text helper. An example Home Assistant automation is provided.

## Not Working / To Do

The script tails the log file (which can get quite large) and at present, when first run will not determine a status. I intended to add a function on load to read the log file in full (or from the end backwards) to find the current/latest status, however I have not had time to implement this. The workaround is to load the script before starting Teams, or to toggle your status to something else manually then "Reset status". I've been running this now for a couple of months and it's been very reliable.

I am also moving away from Teams as a platform (due to a job change) so am unlikley to maintain this going forward.

Pull requests to maintain or to solve the lack of status on load are welcome.

## Credits

Credit to [cjsmile999](https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75896&sid=f6e2b86cd0ec8262c29d58e99906d3f7) on the AHK forums for the starter code for the log tailer

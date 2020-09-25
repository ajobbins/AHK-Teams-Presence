# AHK-Teams-Presence
AutoHotKey Script for reading MS Team status from tray icon and publishing webhook. The sc-ipt scans the screen approximately onces every 10 seconds, and a webhook is pushed only if the status is changed. Regardless of state, an update webhook is sent approximately every 5 minutes as a form of keep-alive.

## Dependencies

Make sure you are running a recent version of [AutoHotKey](https://www.autohotkey.com/). This script also works OK with the [portable verison](https://www.portablefreeware.com/index.php?id=217) of AHK

## Setting Up
Copy the files in this repo to somewhere AHK can execute them
The images in this repo may not work if your taskbar is a differnt colour. In this case, take and trim screenshots of your own system tray icons and replace the examples provided here. Transparency in your taskbar will be problematic.

## Script Configuration
In update_status.ahk, update the following variables:

WebhookURI : Set this to the URI where your webhook posts to

dir : Set this to the base directory where the images to check are located

## Running
Execute the script manually or set up a task to run it automatically

## Processing Output
The script simply passes a status as a JSON payload as a POST to the URI configured. It's up to you how to process that in a useful way. In my own use case, the webhook is processed by my Home Assistant instance and updates an input_text helper. An example Home Assistant automation is provided.

## Limitations

This script determine yours teams status by looking at the icon in the system tray, and as such is quite limited. A detailed status cannot be determined as the status colour in the icon can represent several states. For example - 'Do Not Distrub' and 'Presenting' both share the same icon, but this script cannot determine which it is.

As this script needs to see the see the screen, it's unable to assess your presence if the screen is off, or something is obscuring the system tray icon - for example presenting in full screen mode. The script will provide a status of 'Unavailable' if the presence cannot be determined.

One key limitation is the system icon changes when you have unread chat messages or other alerts. The system tray icon changes to an alert 'bell' ![Teams Alert Icon](https://raw.githubusercontent.com/ajobbins/AHK-Teams-Presence/master/icons/alert.png)  regardless of presence status. This script ignored the 'alert' status and maintains the last known status until the alert is cleared. This may result in an incorrect status if your actual status has changed before clearing the alert.

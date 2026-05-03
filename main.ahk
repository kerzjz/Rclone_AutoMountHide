#Requires AutoHotkey v2.0
#NoTrayIcon

DetectHiddenWindows True  ; ← 关键：能找到被 RBTray 收进托盘的隐藏窗口

mounts := [
    {remote: "A",  drive: "A", label: "A",  extra: ""}, 
    {remote: "B",     drive: "B", label: "B",     extra: ""},
    {remote: "C", drive: "C", label: "C", extra: ""},
    {remote: "D",  drive: "D", label: "D",  extra: ""}
]

BASE_ARGS := "--network-mode --log-level error --vfs-cache-mode off --buffer-size 4M"

if !ProcessExist("RBTray.exe")
    Run "RBTray.exe"
Sleep 500

for m in mounts {
    winTitle := "RCLONE_" m.remote "_" m.drive
    
    if WinExist(winTitle)
        continue
    
    cmd := Format('cmd /k title {1} && rclone mount {2}: {3}: --volname "{4}" {5} {6}',
        winTitle, m.remote, m.drive, m.label, BASE_ARGS, m.extra)
    
    Run cmd,, "Min"
    Sleep 800
}

Sleep 2000

for m in mounts {
    winTitle := "RCLONE_" m.remote "_" m.drive
    if WinExist(winTitle) {
        WinActivate(winTitle)
        WinWaitActive(winTitle,, 3)
        Send("^!{Down}")
        Sleep 400
    }
}

ExitApp()

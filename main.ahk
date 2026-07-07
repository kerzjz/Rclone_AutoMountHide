#Requires AutoHotkey v2.0
#NoTrayIcon

DetectHiddenWindows True

mounts := [
    {remote: "A",  drive: "A", label: "A"},
;    {remote: "B",     drive: "B", label: "B"},
;    {remote: "C", drive: "C", label: "C"},
;    {remote: "D",  drive: "D", label: "D"}
]

BASE_ARGS := "--network-mode --vfs-cache-mode writes --dir-cache-time 10s --poll-interval 15s --vfs-cache-poll-interval 30s --log-level error --buffer-size 4M"

; ========== 1. 等待 Explorer 完全就绪（关键！）==========
; 开机自启时 Explorer 可能还没初始化完，WinFsp 的注册通知会丢
loop 60 {
    if ProcessExist("explorer.exe")
        break
    Sleep 10000
}
; 再多给 Explorer 3 秒稳定时间
Sleep 3000

; ========== 2. 启动 RBTray ==========
if !ProcessExist("RBTray.exe") {
    Run "RBTray.exe"
    Sleep 1500
}

; ========== 3. 启动挂载（带重试机制）==========
for m in mounts {
    winTitle := "RCLONE_" m.remote "_" m.drive
    
    if WinExist(winTitle)
        continue
    
    ; 先确保盘符没有被之前的僵尸挂载占用
    if DirExist(m.drive ":\") {
        ; 盘符已被占用，可能是上次僵尸挂载，尝试清理
        RunWait Format('cmd /c net use {1}: /delete /y 2>nul', m.drive),, "Hide"
    }
    
    cmd := Format('cmd /k title {1} && rclone mount {2}: {3}: --volname "{4}" {5}',
        winTitle, m.remote, m.drive, m.label, BASE_ARGS)
    
    Run cmd,, "Min"
    Sleep 2000
    
    ; ========== 4. 验证挂载是否真的生效（核心修复）==========
    ; rclone 返回命令提示符不代表盘符已注册到 Explorer
    mounted := false
    loop 20 {  ; 最多等 10 秒
        if DirExist(m.drive ":\") {
            mounted := true
            break
        }
        Sleep 500
    }
    
    ; 如果 10 秒后盘符还是没出现，杀掉重来
    if !mounted {
        if WinExist(winTitle) {
            WinClose(winTitle)
            WinWaitClose(winTitle,, 5)
        }
        ; 等 2 秒再试一次
        Sleep 2000
        Run cmd,, "Min"
        Sleep 3000
    }
    
    Sleep 1000
}

; ========== 5. 收进托盘 ==========
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

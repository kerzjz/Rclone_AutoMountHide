# Rclone_AutoMountHide Project Documentation

![](https://img.shields.io/badge/License-MIT-blue)

[中文](README.md) | English

## Feature Introduction
Developed based on AutoHotkey v2.0, this utility enables **batch automated mounting for multiple Rclone cloud drives**. It uses a structured configuration array to centrally manage mounting tasks, launches all Rclone mount processes in the background, and automatically starts RBTray. All command-line mount windows are minimized and docked to the system tray. The entire process runs silently with no pop-ups or foreground windows, delivering **seamless background automation**.

## Core Features
1. **Modular Configuration Management**  
All mounting rules are maintained in a built-in array. Mount entries, drive letters, volume labels and custom runtime parameters can be added, removed or modified quickly with clear and maintainable logic.

2. **Automatic Dependency Startup**  
The program checks whether RBTray is running. If not, it launches RBTray automatically, eliminating manual pre-start operation.

3. **Staggered Launch Mechanism**  
Mount tasks start sequentially with delays to avoid resource contention, initialization conflicts and mount failures caused by simultaneous command-line window creation.

4. **Automatic Window Minimization to Tray**  
Locates each mount command-line window one by one, activates it, and uses the RBTray hotkey rule to minimize all windows and keep them resident in the system tray.

5. **Silent Self-Termination**  
The script hides its own tray icon during execution and exits automatically after all mounts complete, leaving no background process or tray icon resident.

6. **Full Rclone Parameter Compatibility**  
Comes with stable default mount arguments. Custom cache policies, buffer sizes, network modes and other advanced Rclone options can be appended freely.

## System Requirements & Dependencies
- Supported System: All Windows desktop versions
- Required Components:
  1. [AutoHotkey v2.0](https://www.autohotkey.com/)
  2. [Rclone](https://rclone.org/) — Pre-configured remote cloud drive remotes required
  3. RBTray — Window minimize-to-tray utility

## Configuration Guide
Edit the top-level `mounts` array with any text editor:
- remote: Exact name of your configured Rclone remote
- drive: Assign a single uppercase letter as the local mount drive
- label: Custom volume name displayed in File Explorer
- extra: Additional Rclone startup arguments; leave empty to use default parameters

## Usage Instructions
1. Place `RBTray.exe` in the same folder as the script, or add its directory to system `Path` for global calling.
2. Modify the `mounts` array according to your cloud drives and available drive letters.
3. Run `Rclone_AutoMountHide.ahk`. Wait several seconds for all cloud drives to mount and be minimized to the system tray.
4. Create a shortcut and place it in the Windows Startup folder to enable **silent automatic mounting on system boot**.

## Notes
1. Confirm occupied drives and virtual disks before assigning mount letters to avoid conflicts and mount failures.
2. Adjust built-in sleep delays based on device performance; increase delays on low-spec hardware for better stability.
3. To unmount, restore the corresponding CMD window from the system tray and close the process safely.
4. If you change RBTray’s global hotkey, update the hotkey command inside the script accordingly, otherwise window minimization will not work.

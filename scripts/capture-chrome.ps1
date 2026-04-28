Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$signature = @'
using System;
using System.Runtime.InteropServices;
public class Win32Api {
  [DllImport("user32.dll")] public static extern IntPtr FindWindow(string c, string w);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr h, ref POINT p);
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc p, IntPtr l);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, System.Text.StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern int GetWindowTextLength(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
  [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }
}
'@
Add-Type -TypeDefinition $signature -ErrorAction SilentlyContinue

$found = $null
$enumProc = [Win32Api+EnumProc]{
  param($h, $l)
  if (-not [Win32Api]::IsWindowVisible($h)) { return $true }
  $len = [Win32Api]::GetWindowTextLength($h)
  if ($len -eq 0) { return $true }
  $sb = New-Object System.Text.StringBuilder ($len + 1)
  [void][Win32Api]::GetWindowText($h, $sb, $sb.Capacity)
  $title = $sb.ToString()
  if ($title -match 'localhost:5173' -or $title -match 'Dashboard Agents') {
    $script:found = @{ Handle = $h; Title = $title }
    return $false
  }
  return $true
}
[void][Win32Api]::EnumWindows($enumProc, [IntPtr]::Zero)

if (-not $found) {
  Write-Host "ERROR: Chrome window with localhost:5173 not found"
  exit 1
}

Write-Host ("Found window: " + $found.Title)
$h = $found.Handle

[void][Win32Api]::ShowWindow($h, 9)
[void][Win32Api]::SetForegroundWindow($h)
Start-Sleep -Milliseconds 800

$client = New-Object Win32Api+RECT
[void][Win32Api]::GetClientRect($h, [ref]$client)
$origin = New-Object Win32Api+POINT
$origin.X = 0; $origin.Y = 0
[void][Win32Api]::ClientToScreen($h, [ref]$origin)

$w = $client.Right - $client.Left
$hh = $client.Bottom - $client.Top
Write-Host ("Client area: " + $w + "x" + $hh + " at " + $origin.X + "," + $origin.Y)

$bmp = New-Object System.Drawing.Bitmap $w, $hh
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($origin.X, $origin.Y, 0, 0, (New-Object System.Drawing.Size $w, $hh))
$g.Dispose()

$out = "C:\wamp64\www\dashboard-agents-landing\assets\dashboard-screenshot.png"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host ("Saved: " + $out)

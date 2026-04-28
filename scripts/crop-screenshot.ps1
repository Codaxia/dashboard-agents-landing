Add-Type -AssemblyName System.Drawing

$src = "C:\wamp64\www\dashboard-agents-landing\assets\dashboard-screenshot.png"
$dst = "C:\wamp64\www\dashboard-agents-landing\assets\dashboard-screenshot.png"

$img = [System.Drawing.Image]::FromFile($src)
Write-Host ("Original: " + $img.Width + "x" + $img.Height)

# Crop top 130px (Chrome tabs + address bar + bookmarks bar)
$cropTop = 130
$newW = $img.Width
$newH = $img.Height - $cropTop

$bmp = New-Object System.Drawing.Bitmap $newW, $newH
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImage($img, (New-Object System.Drawing.Rectangle 0, 0, $newW, $newH), 0, $cropTop, $newW, $newH, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$img.Dispose()

$bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host ("Cropped: " + $newW + "x" + $newH + " -> " + $dst)

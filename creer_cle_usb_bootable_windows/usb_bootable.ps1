# Blabla Team - Création clef USB bootable et installation du fichier iso sur la clef

# Lance Powershell en mode admin
#function Start-PSAdmin {Start-Process PowerShell -Verb RunAs}

##################################################################################################################################

. .\choisir_un_fichier.ps1

##################################################################################################################################


# Récupère le fichier iso

If ($Show -eq "") {break}
$file = Select-FileDialog -Title "Choisir le fichier iso/img" -Directory "F:\Conversion_iso" -Filter "Fichier iso |*.ISO;*.IMG"
Write-Host "Le fichier iso se trouve à > $file" -ForegroundColor yellow -BackgroundColor black

#=======================================================================================

# Nomme la clé USB et choisit le type de partition"

#$label = name-label
#if ($label -is [array]) { $slabel=$label[0] } else {$slabel=$label}

# Start Form Build
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing      

#################################################
# CONFIGURATION DE LA WINDOWS FORM
#################################################

# Creation de la form principale
$form = New-Object Windows.Forms.Form

# Pour bloquer le resize du form et supprimer les icones Minimize and Maximize
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.ForeColor = [System.Drawing.Color]::black
$form.BackColor = [System.Drawing.Color]::Ivory
$form.MaximizeBox = $False
$form.MinimizeBox = $False

# Choix du titre
$form.Text = "Paramétrages de la clef USB"

# Choix de la taille
$form.Size = New-Object System.Drawing.Size(400,340)

#################################################
# AJOUT DES COMPOSANTS
#################################################

# TextBox
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.AutoSize = $true
$textbox.Location = New-Object System.Drawing.Point(20,80)
$textbox.Name = 'textbox_sw'
$textbox.Size = New-Object System.Drawing.Size(110,20)
$textbox.Text = "keyUSB_boot"
$textbox.MaxLength = 11
$form.Add_Shown({$form.Activate(); $textbox.Focus()}) # donne le focus à la text box
#$textBox.Add_TextChanged({$this.Text = $this.Text -replace "[^a-z 0-9 _]",""})

$textBox.Add_TextChanged({
    if ($this.Text -match '[^a-z0-9_]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^a-z0-9_]',''
        # move the cursor to the end of the text:
        $this.SelectionStart = $this.Text.Length

        # or leave the cursor where it was before the replace
        #$this.SelectionStart = $cursorPos - 1
       # $this.SelectionLength = 0
    }
})

#$textbox = New-Object System.Text.RegularExpressions.Regex.IsMatch($textbox.Text, "^[a-zA-Z0-9 ]")
#$textbox = New-Object System.Text.RegularExpressions.Regex($textbox.Text, "^[a-zA-Z0-9 ]")
#$textbox = System.Text.RegularExpressions.Regex.IsMatch($textbox.Text, "^[ 0-9]")

# Label 1
$label_prez = New-Object System.Windows.Forms.Label
$label_prez.AutoSize = $true
$label_prez.Location = New-Object System.Drawing.Point(220,20)
$label_prez.Size = New-Object System.Drawing.Size(100,20)
$label_prez.Text = "Choix de la partition"

# Label 2
$label_un = New-Object System.Windows.Forms.Label
$label_un.AutoSize = $true
$label_un.Location = New-Object System.Drawing.Point(20,20)
$label_un.Name = 'label_password'
$label_un.Size = New-Object System.Drawing.Size(100,20)
$label_un.Text = "Choisir un nom pour la clé USB`nQue des chiffres et/ou des lettres`nPas de caractères spéciaux`n11 caractères max."

# Bouton OK
$button_ok = New-Object System.Windows.Forms.Button
$button_ok.Text = "OK"
$button_ok.Size = New-Object System.Drawing.Size(355,40)
$button_ok.Location = New-Object System.Drawing.Size(20,130)

# Bouton Annuler
$button_quit = New-Object System.Windows.Forms.Button
$button_quit.Text = "Annuler"
$button_quit.Size = New-Object System.Drawing.Size(355,40)
$button_quit.Location = New-Object System.Drawing.Size(20,180)

# CheckBox x3
$checkbox_un = New-Object System.Windows.Forms.CheckBox
$checkbox_un.AutoSize = $true
$checkbox_un.Location = New-Object System.Drawing.Point(240,50)
$checkbox_un.Name = 'checkbox_un'
$checkbox_un.Size = New-Object System.Drawing.Size(80,20)
$checkbox_un.Text = 'FAT32'
$checkbox_un.Enabled=$True
$checkbox_un.Checked=$false

$checkbox_deux = New-Object System.Windows.Forms.CheckBox
$checkbox_deux.AutoSize = $true
$checkbox_deux.Location = New-Object System.Drawing.Point(240,70)
$checkbox_deux.Name = 'checkbox_deux'
$checkbox_deux.Size = New-Object System.Drawing.Size(80,20)
$checkbox_deux.Text = 'NTFS'
$checkbox_deux.Enabled=$True
$checkbox_deux.Checked=$false

$checkbox_trois = New-Object System.Windows.Forms.CheckBox
$checkbox_trois.AutoSize = $true
$checkbox_trois.Location = New-Object System.Drawing.Size(240,90)
$checkbox_trois.Name = 'checkbox_trois'
$checkbox_trois.Size = New-Object System.Drawing.Size(80,20)
$checkbox_trois.Text = 'exFAT'
$checkbox_trois.Enabled = $true
$checkbox_trois.Checked = $False

#################################################

# Ajout des composants a la Form
$form.Controls.Add($checkbox_un)
$form.Controls.Add($checkbox_deux)
$form.Controls.Add($checkbox_trois)
$form.Controls.Add($button_ok)
$form.Controls.Add($textbox)
$form.Controls.Add($label_prez)
$form.Controls.Add($label_un)
$form.controls.Add($button_quit)

#################################################
# GESTION DES EVENEMENTS
#################################################

# Checkboxes test

$Global:fs=""

$checkbox_un.Add_CheckStateChanged(

{
    switch ($checkbox_un.Checked) {
        $true { $checkbox_deux.Enabled = $false; $checkbox_deux.Checked = $false; $checkbox_trois.Enabled = $false; $checkbox_trois.Checked = $false; $Global:fs="FAT32"; break }
        $false { $checkbox_deux.Enabled = $true; $checkbox_deux.Checked = $false; $checkbox_trois.Enabled = $true; $checkbox_trois.Checked = $false; $Global:fs=""; break }
    }
})

$checkbox_deux.Add_CheckStateChanged(

{

    switch ($checkbox_deux.Checked) {
        $true { $checkbox_un.Enabled = $false; $checkbox_un.Checked = $false; $checkbox_trois.Enabled = $false; $checkbox_trois.Checked = $false; $Global:fs="NTFS"; break }
        $false { $checkbox_un.Enabled = $true; $checkbox_un.Checked = $false; $checkbox_trois.Enabled = $true; $checkbox_trois.Checked = $false; $Global:fs=""; break }
    }

})


$checkbox_trois.Add_CheckStateChanged(

{

    switch ($checkbox_trois.Checked) {
        $true { $checkbox_un.Enabled = $false; $checkbox_un.Checked = $false; $checkbox_deux.Enabled = $false; $checkbox_deux.Checked = $false; $Global:fs="exFAT"; break }
        $false { $checkbox_un.Enabled = $true; $checkbox_un.Checked = $false; $checkbox_deux.Enabled = $true; $checkbox_deux.Checked = $false; $Global:fs=""; break }
    }

})

# EventHandler

$boxtext = [System.EventHandler]{ $textbox.Text; $form.Close();}

#################################################

# Gestion event quand on clique sur le bouton OK
$button_ok.Add_Click($boxtext)

# Gestion event quand on clique sur le bouton Annuler
$button_quit.Add_Click(
{
Write-Host 'Projet annuler';
[environment]::exit(0)
})

# Affichage de la Windows
$form.ShowDialog() | Out-Null
if ($fs -eq "") {$fs='FAT32'}

write-host "La clé usb s'appelle" $textbox.Text -ForegroundColor Yellow -BackgroundColor Black  # This is what is returned from the function
Write-Host "Le système de fichier choisi est :" $fs -ForegroundColor Yellow -BackgroundColor Black


#=======================================================================================

# Sélectionne et Formate la clé USB
$Results = Get-Disk |
Where-Object BusType -eq USB |
Out-GridView -Title 'Choisir une clef USB à formater' -OutputMode Single |
Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru |
New-Partition -UseMaximumSize -IsActive -AssignDriveLetter |
Format-Volume -FileSystem $fs -NewFileSystemLabel $textbox.Text

Write-Host "Lettre assignée à la clef USB :" $Results.DriveLetter -ForegroundColor Yellow -BackgroundColor Black
# Monte le fichier iso
$Volumes = (Get-Volume).Where({$_.DriveLetter}).DriveLetter
Mount-DiskImage -ImagePath $file
Write-Host 'Fichier' $file -ForegroundColor yellow -BackgroundColor black

# Récupère la lettre du lecteur iso
$ISO = (Compare-Object -ReferenceObject $Volumes -DifferenceObject (Get-Volume).Where({$_.DriveLetter}).DriveLetter).InputObject
Write-Host "La lettre assignée au fichier ISO monté est : $ISO" -ForegroundColor yellow -BackgroundColor black
Write-Host '=============================================================================================================' -ForegroundColor Yellow -BackgroundColor Black

# ===================================================================================================================================
# Installe les fichiers sur la clé USB
Set-Location -Path "$($ISO):\boot"
bootsect.exe /nt60 "$($Results.DriveLetter):"
Copy-Item -Path "$($ISO):\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose


# FIN
Write-Host "C'est fini !" -ForegroundColor Green -BackgroundColor Black
Dismount-DiskImage -ImagePath $file
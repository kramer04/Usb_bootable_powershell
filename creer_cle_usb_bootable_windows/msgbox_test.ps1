# Blabla Team - boîte de dialogue pour sélectionner le nom de la clef USB

Function name-label
{

# Incorporate Visual Basic into script
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

    # show the Pop Up with the following text.
    $label = [Microsoft.VisualBasic.Interaction]::InputBox("Pas plus de 11 caractères`r`n`
    1) Que des lettres ou des chiffres`
    2) Pas de caractères bizarres comme $ * µ %"`
    , "Nom de la clef USB", "")

   
    # caractères bizarres interdits
    $biz='[~#%&*{}\[\]\\:<>?/|+"$£¤ù%*µ!§/.;,?()@éèçà]'
    While  (($label -match $biz) -or ($label.length -gt 12))
            {
            if ($label -match $biz) {Write-Host 'Pas de caractères spéciaux comme @ % ù etc...' $label -ForegroundColor DarkRed -BackgroundColor White}
            if ($label.length -gt 12) {Write-Host 'Trop long ! Pas plus de 11 caractères' $label -ForegroundColor DarkRed -BackgroundColor White}
            if (($label -match $biz) -and ($label.length -gt 12)) {Write-Host 'Trop long ! Pas de caractères spéciaux' $label -ForegroundColor DarkRed -BackgroundColor White}
            $label = [Microsoft.VisualBasic.Interaction]::InputBox("Pas plus de 11 caractères`r`n`
            1) Que des lettres ou des chiffres`
            2) Pas de caractères bizarres $ * µ %`
            3) Pas plus de 11 caractères`
            Vous venez d'entrer ce nom $label","Nom de la clef USB", "")
            }
   

    # si réponse OUI
    If ($label -eq "") # OK or Cancel button pushed with no input
    {
        write-host "Vous venez d'appuyer sur OK ou ANNULER avec un nom de volume vide" -ForegroundColor Red -BackgroundColor Black

        # Open new popup with the folloing text
        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        $answer = [System.Windows.Forms.MessageBox]::Show("Voulez-vous vraiment annuler ?","Annuler ?",4,"question")
    }

        if ($answer -eq "YES") # Yes button selected for cancel
        {
            write-host "Projet annuler par l'utilisateur" -ForegroundColor Green -BackgroundColor Black
            Exit     # Quit the program
        }
    elseif ($answer -eq "NO")
        {
            # You selected no, open a new pop up window with the following text
            $a = new-object -comobject wscript.shell
            $intAnswer = $a.popup("Vous n'avez pas entrer un nom pour la clé USB`r `n Nouvel essai !",0,"ERREUR !",0)
            $answer=""
            name-label # Restart function
        }

    return $label
}
# Vérifier que le serveur est un contrôleur de domaine
$domainName = "infra.lan"
$domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain

if ($domain -eq $domainName) {
    Write-Host "Le serveur est maintenant un contrôleur de domaine. Poursuite de la configuration..."

    # Créer les OU
    $ouDev = "OU=Dev,DC=infra,DC=lan"
    $ouFinance = "OU=Finance,DC=infra,DC=lan"
    $ouRH = "OU=RH,DC=infra,DC=lan"
    $ouAdmins = "OU=Admins,DC=infra,DC=lan"

    New-ADOrganizationalUnit -Name "Dev" -Path "DC=infra,DC=lan" -ErrorAction SilentlyContinue
    New-ADOrganizationalUnit -Name "Finance" -Path "DC=infra,DC=lan" -ErrorAction SilentlyContinue
    New-ADOrganizationalUnit -Name "RH" -Path "DC=infra,DC=lan" -ErrorAction SilentlyContinue
    New-ADOrganizationalUnit -Name "Admins" -Path "DC=infra,DC=lan" -ErrorAction SilentlyContinue

    # Créer les groupes dans leurs OU respectives
    New-ADGroup -Name "Développement" -SamAccountName "Developpement" -GroupCategory Security -GroupScope Global -Path $ouDev -ErrorAction SilentlyContinue
    New-ADGroup -Name "Finance" -SamAccountName "Finance" -GroupCategory Security -GroupScope Global -Path $ouFinance -ErrorAction SilentlyContinue
    New-ADGroup -Name "RH" -SamAccountName "RH" -GroupCategory Security -GroupScope Global -Path $ouRH -ErrorAction SilentlyContinue
    New-ADGroup -Name "Administrateurs" -SamAccountName "Administrateurs" -GroupCategory Security -GroupScope Global -Path $ouAdmins -ErrorAction SilentlyContinue

    # Créer un utilisateur dans chaque OU et l’ajouter au groupe correspondant
    # 1. Utilisateur dev1
    $password = ConvertTo-SecureString "MotDePasse123!" -AsPlainText -Force
    New-ADUser -Name "dev1" -SamAccountName "dev1" -UserPrincipalName "dev1@infra.lan" `
        -GivenName "Dev" -Surname "User1" -DisplayName "Dev User1" -Path $ouDev `
        -AccountPassword $password -Enabled $true -PasswordNeverExpires $true -ErrorAction SilentlyContinue
    Add-ADGroupMember -Identity "Développement" -Members "dev1"

    # 2. Utilisateur finance1
    New-ADUser -Name "finance1" -SamAccountName "finance1" -UserPrincipalName "finance1@infra.lan" `
        -GivenName "Finance" -Surname "User1" -DisplayName "Finance User1" -Path $ouFinance `
        -AccountPassword $password -Enabled $true -PasswordNeverExpires $true -ErrorAction SilentlyContinue
    Add-ADGroupMember -Identity "Finance" -Members "finance1"

    # 3. Utilisateur rh1
    New-ADUser -Name "rh1" -SamAccountName "rh1" -UserPrincipalName "rh1@infra.lan" `
        -GivenName "RH" -Surname "User1" -DisplayName "RH User1" -Path $ouRH `
        -AccountPassword $password -Enabled $true -PasswordNeverExpires $true -ErrorAction SilentlyContinue
    Add-ADGroupMember -Identity "RH" -Members "rh1"

    # 4. Utilisateur admin1
    New-ADUser -Name "admin1" -SamAccountName "admin1" -UserPrincipalName "admin1@infra.lan" `
        -GivenName "Admin" -Surname "User1" -DisplayName "Admin User1" -Path $ouAdmins `
        -AccountPassword $password -Enabled $true -PasswordNeverExpires $true -ErrorAction SilentlyContinue
    Add-ADGroupMember -Identity "Administrateurs" -Members "admin1"

    # Configuration DHCP (inchangée)
    Start-Service DHCP
    Add-DhcpServerInDC -DnsName $domainName -IPAddress "192.168.1.1"
    Add-DhcpServerV4Scope -Name "Plage DHCP 192.168.1.100 - 192.168.1.200" `
        -StartRange 192.168.1.100 -EndRange 192.168.1.200 `
        -SubnetMask 255.255.255.0 -State Active

    Add-DhcpServerV4ExclusionRange -ScopeId 192.168.1.0 -StartRange 192.168.1.1 -EndRange 192.168.1.1

    Write-Host "Configuration terminée : OUs, groupes, utilisateurs et DHCP configurés."

} else {
    Write-Host "Le serveur n'est pas encore un contrôleur de domaine. Veuillez redémarrer et réessayer."
}

# Vérifier si le serveur est bien un contrôleur de domaine (juste pour s'assurer que le script est exécuté après la promotion)
$domainName = "infra.lan"
$domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain

if ($domain -eq $domainName) {
    Write-Host "Le serveur est maintenant un contrôleur de domaine. Poursuite de la configuration..."

    # Étape 3 : Créer les groupes dans Active Directory
    New-ADGroup -Name "Développement" -SamAccountName "Developpement" -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=infra,DC=lan"
    New-ADGroup -Name "Finance" -SamAccountName "Finance" -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=infra,DC=lan"
    New-ADGroup -Name "RH" -SamAccountName "RH" -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=infra,DC=lan"
    New-ADGroup -Name "Administrateurs" -SamAccountName "Administrateurs" -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=infra,DC=lan"

    # Étape 4 : Créer des utilisateurs
    New-ADUser -Name "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@infra.lan" -GivenName "John" -Surname "Doe" -DisplayName "John Doe" -Enabled $true -PasswordNeverExpires $true -PassThru
    Add-ADGroupMember -Identity "Développement" -Members "jdoe"

    New-ADUser -Name "Jane Doe" -SamAccountName "jdoe_fin" -UserPrincipalName "jdoe_fin@infra.lan" -GivenName "Jane" -Surname "Doe" -DisplayName "Jane Doe" -Enabled $true -PasswordNeverExpires $true -PassThru
    Add-ADGroupMember -Identity "Finance" -Members "jdoe_fin"

    # Créer un utilisateur administrateur
    New-ADUser -Name "Admin User" -SamAccountName "adminuser" -UserPrincipalName "adminuser@infra.lan" -GivenName "Admin" -Surname "User" -DisplayName "Admin User" -Enabled $true -PasswordNeverExpires $true -PassThru
    Add-ADGroupMember -Identity "Administrateurs" -Members "adminuser"

    # Étape 5 : Configurer le serveur DHCP
    Start-Service DHCP
    Add-DhcpServerInDC -DnsName $domainName -IPAddress "192.168.1.1"
    Add-DhcpServerV4Scope -Name "Plage DHCP 192.168.1.100 - 192.168.1.200" `
        -StartRange 192.168.1.100 -EndRange 192.168.1.200 `
        -SubnetMask 255.255.255.0 -State Active

    Add-DhcpServerV4ExclusionRange -ScopeId 192.168.1.0 -StartRange 192.168.1.1 -EndRange 192.168.1.1

    # Finalisation
    Write-Host "Le domaine infra.lan est configuré, les groupes et utilisateurs ont été créés, et le service DHCP est opérationnel."
} else {
    Write-Host "Le serveur n'est pas encore un contrôleur de domaine. Veuillez redémarrer et réessayer."
}

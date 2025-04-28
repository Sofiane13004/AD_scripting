# Étape 1 : Installer les rôles Active Directory, DNS et DHCP
Install-WindowsFeature -Name AD-Domain-Services, DNS, DHCP -IncludeManagementTools

# Étape 2 : Promouvoir le serveur en contrôleur de domaine et créer le domaine 'infra.lan'
$domainName = "infra.lan"
$domainAdminPassword = ConvertTo-SecureString "MotDePasseAdmin123!" -AsPlainText -Force

# Promouvoir le serveur en contrôleur de domaine
Install-ADDSForest -DomainName $domainName -DomainNetbiosName "INFRA" -InstallDNS `
    -SafeModeAdministratorPassword $domainAdminPassword `
    -CreateDnsDelegation:$false `
    -Force:$true

# Redémarrer le serveur après la promotion pour appliquer les changements
Restart-Computer -Force

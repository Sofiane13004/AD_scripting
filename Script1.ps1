# Étape 1 : Installer les rôles Active Directory, DNS et DHCP
Install-WindowsFeature -Name AD-Domain-Services, DNS, DHCP -IncludeManagementTools

# Vérifier que les rôles sont bien installés
if ((Get-WindowsFeature -Name AD-Domain-Services).InstallState -eq 'Installed' -and 
    (Get-WindowsFeature -Name DNS).InstallState -eq 'Installed' -and 
    (Get-WindowsFeature -Name DHCP).InstallState -eq 'Installed') {

    Write-Output "Les rôles AD, DNS et DHCP ont été installés avec succès."

    # Étape 2 : Promouvoir le serveur en contrôleur de domaine et créer le domaine 'infra.lan'
    $domainName = "infra.lan"
    $domainAdminPassword = ConvertTo-SecureString "MotDePasseAdmin123!" -AsPlainText -Force

    try {
        # Promouvoir le serveur en contrôleur de domaine
        Install-ADDSForest -DomainName $domainName -DomainNetbiosName "INFRA" -InstallDNS `
            -SafeModeAdministratorPassword $domainAdminPassword `
            -CreateDnsDelegation:$false `
            -Force:$true

        Write-Output "Promotion réussie. Redémarrage nécessaire."
        # Redémarrer le serveur après la promotion
        Restart-Computer -Force
    }
    catch {
        Write-Output "Erreur lors de la promotion du contrôleur de domaine : $_"
    }
} else {
    Write-Output "Erreur : Les rôles ne sont pas correctement installés."
}

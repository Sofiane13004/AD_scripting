Script de Déploiement d'un Contrôleur de Domaine avec AD, DNS et DHCP
Description
Ce script PowerShell automatise l'installation et la configuration d'un serveur Windows en tant que contrôleur de domaine pour un nouveau domaine par exemple : infra.lan.
Il installe également les services DNS et DHCP, crée des groupes et utilisateurs Active Directory, puis configure une plage DHCP.

Fonctionnalités
Installation des rôles : Active Directory Domain Services, DNS, et DHCP.

Promotion du serveur en contrôleur de domaine (infra.lan).

Comment utiliser le script PowerShell
Prérequis
Avant de lancer ton script :

Tu dois être sur un serveur Windows récent (Windows Server 2016/2019/2022).

Tu dois avoir des droits administrateur sur ce serveur.

Le serveur doit déjà avoir une adresse IP fixe (ex: 192.168.1.1).

Le serveur doit pouvoir redémarrer automatiquement (puisque ton script le force).

Étapes pour lancer ton script
1. Ouvrir PowerShell en mode administrateur
Clique droit sur l'icône PowerShell → Exécuter en tant qu'administrateur.

2. Changer la politique d'exécution si nécessaire
Si PowerShell bloque ton script à cause de la sécurité, tape ceci pour autoriser l'exécution temporairement :

powershell
Copier
Modifier
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Cela te permet de lancer ton script sans modifier la sécurité globale du serveur.

3. Lancer le script
Place ton script dans un fichier, par exemple setup_infra.ps1.

Dans PowerShell, navigue jusqu'au dossier où est ton fichier, par exemple :

powershell
Copier
Modifier
cd C:\Chemin\Vers\Ton\Script
Puis lance ton script :

powershell
Copier
Modifier
.\setup_infra.ps1
Ce qu'il va se passer automatiquement
Le script installe Active Directory, DNS et DHCP.

Il promeut ton serveur comme contrôleur de domaine pour infra.lan.

Il redémarre le serveur pour appliquer les changements.

Après redémarrage, il vérifie que ton serveur est bien contrôleur de domaine.

Il crée les groupes AD (Développement, Finance, RH, Administrateurs).

Il crée les utilisateurs (John Doe, Jane Doe, Admin User) et les ajoute aux bons groupes.

Il démarre et configure le serveur DHCP pour ton réseau.

Infos supplémentaires
Le redémarrage interrompt le script : tu dois relancer manuellement le script après redémarrage, mais il va vérifier tout seul si le serveur est déjà contrôleur de domaine, et continuer la configuration.

Important : Quand tu relances, tu n’as pas besoin de refaire les installations, le script saute directement aux créations des utilisateurs, groupes, DHCP, etc.

Résultat final
À la fin :

Ton domaine infra.lan est fonctionnel.

Ton serveur est un contrôleur de domaine, DNS et DHCP.

Tu as des groupes et des utilisateurs prêts.

Ton DHCP attribue les IPs entre 192.168.1.100 et 192.168.1.200.




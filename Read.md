Script de Déploiement d'un Contrôleur de Domaine avec AD, DNS et DHCP
Description
Ce script PowerShell automatise l'installation et la configuration d'un serveur Windows en tant que contrôleur de domaine pour un nouveau domaine par exemple : infra.lan.
Il installe également les services DNS et DHCP, crée des groupes et utilisateurs Active Directory, puis configure une plage DHCP.

Fonctionnalités
Installation des rôles : Active Directory Domain Services, DNS, et DHCP.

Promotion du serveur en contrôleur de domaine (infra.lan).

Création automatique de groupes AD :

Développement

Finance

Ressources Humaines (RH)

Administrateurs

Création automatique d'utilisateurs :

John Doe (Développement)

Jane Doe (Finance)

Admin User (Administrateurs)

Configuration du serveur DHCP avec :

Une plage d'adresses IP de 192.168.1.100 à 192.168.1.200.

Exclusion de l'adresse IP du serveur 192.168.1.1.

Détail des étapes
1. Installation des rôles Windows
Utilisation de Install-WindowsFeature pour installer :

AD DS (Active Directory Domain Services)

DNS

DHCP

Avec les outils de gestion associés.

2. Promotion du serveur en contrôleur de domaine
Création d'une nouvelle forêt avec infra.lan comme nom de domaine.

Installation du service DNS intégré.

Définition du mot de passe pour le mode de restauration des services d'annuaire.

3. Redémarrage du serveur
Le serveur redémarre pour finaliser la promotion.

Vérification que le serveur appartient bien au domaine infra.lan.

4. Création des groupes Active Directory
Chaque groupe est créé dans le conteneur Users du domaine.

5. Création des utilisateurs
Chaque utilisateur est créé avec un mot de passe qui n'expire jamais.

Chaque utilisateur est automatiquement ajouté à son groupe respectif.

6. Configuration du service DHCP
Démarrage du service DHCP.

Ajout du serveur DHCP dans Active Directory.

Création d'une plage DHCP active.

Définition d'une exclusion pour l'adresse IP principale du serveur.

Remarques importantes
Mot de passe : Actuellement en clair dans le script (MotDePasseAdmin123!), il est recommandé de le sécuriser autrement pour une utilisation en production.

Adresse IP : Le serveur est supposé avoir l'IP 192.168.1.1.

Exécution : Ce script doit être exécuté avec des droits administrateur.

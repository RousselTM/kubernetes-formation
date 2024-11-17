# Registry harbord
Dans cette configuration Vagrant,vous allez pouvoir déployer une VM dans laquelle on aura préinstallé un moteur Docker.
```bash 
git clone https://github.com/RousselTM/docker-formation.git
cd docker-formation/TP/2_registry_harbor
vagrant up
vagrant ssh formation-docker
```
Il faudra passer en root
```bash 
sudo su - root
```

Pour vous aider, on aura aussi récupéré les sources (offline) du regsitre harbor qu'on aura stocké dans /opt
```bash 
cd /opt
```
Nous aurons aussi positionné un fichier de conf qu'il faudra personnaliser en fonction de vos besoins 
```bash 
vi harbor.yaml
```
Une fois le fichier de configuration modifié, il ne vous reste plus qu'à lancer le script d'installation avec les bons paramaètres(voir documentation). Exemple 
```bash 
./install.sh --with-trivy
```
#Please do NOT set --with-chartmuseum, as chartmusuem has been deprecated and removed.

#Please do NOT set --with-notary, as notary has been deprecated and removed.

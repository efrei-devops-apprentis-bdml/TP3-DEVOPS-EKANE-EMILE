# TP3_Devops
## Author : Emile EKANE
## Date : 2020-06-12

## Docs

> Retrouvez l'exercice précédent sur ce [lien] (https://github.com/ekane3/TP2_Devops) pour plus de contexte.

- Configuration d'un workflow GitHub Action qui build et push automatiquement l'image sur ACR a chaque nouveau commit et le déploiement sur Azure Container Instance.  

```yaml

# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

name: Publish Docker image

on: push

jobs:
  push_to_registry-linux:
    name: Push Docker image to Docker Hub
    runs-on: ubuntu-latest
    steps:

      # Checkout the repo
      - name: Check out the repo
        uses: actions/checkout@v3

      # Login to Azure
      - name: "Login via Azure CLI"
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      # Login to ACR and Build and push the image
      - name: "Build and push image"
        uses: azure/docker-login@v1
        with:
          login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
          username: ${{ secrets.REGISTRY_USERNAME }}
          password: ${{ secrets.REGISTRY_PASSWORD }}
      - run: |
          docker build . -t ${{ secrets.REGISTRY_LOGIN_SERVER }}/${{ secrets.ID_EFREI }}:v1
          docker push ${{ secrets.REGISTRY_LOGIN_SERVER }}/${{ secrets.ID_EFREI }}:v1
      # Deploy to Azure Container Instances (ACI)
      - name: "Deploy to Azure Container Instances"
        uses: "azure/aci-deploy@v1"
        with:
          resource-group: ${{ secrets.RESOURCE_GROUP }}
          dns-name-label: devops-${{ secrets.ID_EFREI }}
          image: ${{ secrets.REGISTRY_LOGIN_SERVER }}/${{ secrets.ID_EFREI }}:v1
          registry-login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
          registry-username: ${{ secrets.REGISTRY_USERNAME }}
          registry-password: ${{ secrets.REGISTRY_PASSWORD }}
          secure-environment-variables: API_KEY=${{ secrets.API_KEY }}
          name: ${{ secrets.ID_EFREI }}
          location: "france central"
```  

- Transformons notre wrapper en API
```python
import requests
import json
import os

from flask import Flask, render_template, request

app = Flask(__name__)

# create a function that returns the weather for a specific location using env lat and lon
@app.route('/')
def index( ):
    args = request.args
    
    lat = args['lat']
    lon = args['lon']
    api_key = os.environ['API_KEY']
    
    res = requests.get(f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}').text
    
    return f"{res}\n"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
```

### Pour éxecuter l'api.

- Run API qui renvoie la météo en utilisant la commande suivant en utilisant notre image:  

Commande:
```cmd
curl "http://devops-20211212.francecentral.azurecontainer.io/?lat=5.902785&lon=102.754175"
```   


### Important links
- DockerHub : https://hub.docker.com/repository/docker/ekane3/efrei-devops-tp2  

- Lien GitHub : https://github.com/ekane3/TP2_Devops
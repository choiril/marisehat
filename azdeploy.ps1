az login

az group create --name klinikmarisehat --location "Southeast Asia"

az deployment group create --resource-group klinikmarisehat --template-file "d:\Template\azure\templatearm\azuredeploy.json"
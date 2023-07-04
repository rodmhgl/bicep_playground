@description('Location used for the deployment.')
param location string = resourceGroup().location

@description('The name of the Storage Account being deployed. Must be unique.')
param storageAccountName string = '${prefix}${uniqueString(resourceGroup().id)}'

@description('The name of the App Service being deployed.')
param appServiceAppName string = '${prefix}${uniqueString(resourceGroup().id)}'

@description('Prefix used for the naming standard.')
param prefix string = 'azlab'

@description('The environment type we are deploying to.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('The SKU of the Storage Account being deployed.')
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  //checkov:skip=CKV_AZURE_35:Lab Resource
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  //checkov:skip=CKV_AZURE_15:Lab Resource
  //checkov:skip=CKV_AZURE_16:Lab Resource
  //checkov:skip=CKV_AZURE_17:Lab Resource
  //checkov:skip=CKV_AZURE_18:Lab Resource
  //checkov:skip=CKV_AZURE_35:Lab Resource
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: environmentType
    prefix: prefix
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName

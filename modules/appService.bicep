param prefix string
param location string
param appServiceAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('The name of the App Service Plan being deployed.')
var appServicePlanName = '${prefix}-launch-plan-starter'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  //checkov:skip=CKV_AZURE_15:Lab Resource
  //checkov:skip=CKV_AZURE_16:Lab Resource
  //checkov:skip=CKV_AZURE_17:Lab Resource
  //checkov:skip=CKV_AZURE_18:Lab Resource
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppHostName  string = appServiceApp.properties.defaultHostName

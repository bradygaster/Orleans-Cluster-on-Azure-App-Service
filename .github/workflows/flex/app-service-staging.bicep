param appName string
param location string
param stagingSubnetId string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param storageConnectionString string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: '${appName}-plan'
}

resource appService 'Microsoft.Web/sites@2021-03-01' existing = {
  name: appName
}

resource stagingSlot 'Microsoft.Web/sites/slots@2022-03-01' = {
  name: '${appName}stg'
  location: location
  parent: appService
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: stagingSubnetId
    siteConfig: {
      http20Enabled: true
      vnetPrivatePortsCount: 2
      webSocketsEnabled: true
      netFrameworkVersion: 'v6.0'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'ORLEANS_AZURE_STORAGE_CONNECTION_STRING'
          value: storageConnectionString
        }
        {
          name: 'ORLEANS_CLUSTER_ID'
          value: 'Staging'
        }
      ]
      alwaysOn: true
    }
  }
}

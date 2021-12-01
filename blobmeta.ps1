  ## Cek account access keys

  $Storage = "klmsstorage"

  $ContainerName = "resep"

  $BlobName = "resep-bragis.jpg"

  $Context = New-AzStorageContext -StorageAccountName $Storage -StorageAccountKey $Key

  $Blob = Get-AzStorageBlob -Context $Context -Container $ContainerName -Blob $BlobName

  $Container = Get-AzStorageContainer -Context $Context -Container $ContainerName

  ## Melihat sistem properties dari Container
  Write-Host "Container name = " $Container.Name 

  ## Melihat lebih detail sistem properties dari container
  Write-Host "Container Uri = " $Container.CloudBlobContainer.Uri 

  ##melihat Metadata Container
  Write-Host "Container metadata = " $Container.CloudBlobContainer.Metadata 

  ## Melihat sistem properties dari blob
  Write-Host "blob type = " $Blob.BlobType 
  Write-Host "blob name = " $Blob.Name 
  Write-Host "Last modified on = " $Blob.LastModified

  ##  Melihat detail sistem properties dari blob
  Write-Host "Etag = " $Blob.ICloudBlob.Properties.Etag 

  ## Melihat metadata dari blob
  Write-Host "Metadata = " $Blob.ICloudBlob.Metadata
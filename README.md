# Membuat Azure Storage Accoount dan Blob Container

Dokumentasi penggunaan sourcecode untuk Capstone Project, Klinik MariSehat Track Cloud Fundamental dari Microsoft pada Studi Independen Kampus Merdeka.

## Deploy Local Template

Untuk mempermudah dalam mendeploy, maka menggunakan Template Azure Resourse Manager (ARM) secara lokal, dalam file template terdapat beberapa pengaturan seperti:

* Menggunakan Souteast Asia

* Blob Encryption

* Delete Retention terhadap blob
  
* Menggunakan duplikasi Zona dengan ZRS
  
* Menggunakan TLS versi 1.2
  
* Hanya menggunakan akses HTTPS
  
* Mengaktifkan Sharde Key Acces
  
* Terdapat FileService untuk mempermudah share atau migrasi dan
  
* Soft Delete terhadap Blob

Untuk menggunakan template ini bisa menggunakan Azure CLI dan PowerShell, untuk PowerShell perlu install modul Azure dengan perintah:

```bash
Install-Module Az
```

Langkah selanjutnya sebagai berikut:

```bash
## Login ke Azure
az login

## Membuat Resource Group, untuk lokasi saya buat di Souteast Asia karena terdekat di Indonesia
az group create --name klinikmarisehat --location "Southeast Asia"

## Deploy Template
az deployment group create --resource-group klinikmarisehat --template-file "d:\Template\azure\templatearm\azuredeploy.json"
```

Untuk template-file bisa disesuaikan dengan lokasi dari file azuredeploy.json. Bisa juga menggunakan link seperti github dan lain-lain.

## LifeCycle Management

```bash
az storage account management-policy create --account-name klmsstorage --policy policy.json --resource-group klinikmarisehat
```

Dalam file policy.json terdapat pengaturan lifecycle management sebagai berikut:

* Cool Tier untuk blob yang di modifikasi 30 hari terkahir.

* Archive Tier untuk blob yang di modifikasi 90 hari terakhir. Karena AzurePass tidak mensupport Archive Tier maka tidak bisa dijalankan.

* Menghapus blob apabila blob telah lewat dari 2.555 hari setelah dimodifikasi.

* Menghapus versi blob sebelumnya setelah 90 hari dari tanggal pembuatannya.

## Blob Metadata

Metadata dan system properties pada blob Azure dapat kita tentukan dengan menggunakan Azure CLI seperti berikut:

* Set storage account context:
  
  ```bash
  ## Cek account access keys
  az storage account keys list --resource-group klinikmarisehat --account-name klmsstorage

  $Key = "<StorageAccountKey>"
  
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
  ```

## Blob Leasing

Lease Blob memungkinkan untuk menentukan kepemilikan blob dengan jangka waktu tertentu. Setelah menjalan perintah berikut akan tampil lease-ID, lease-ID lah yang kita berikan ke pihak ketiga.

```bash
## lease blob
az storage blob lease acquire --blob-name "resep-bragis.jpg" --container-name "resep" --account-name "klmsstorage" --account-key "<StorageAccountKey>" --lease-duration 30

## memperbarui lease blob
az storage blob lease renew --blob-name "resep-bragis.jpg" --container-name "resep" --account-name "klmsstorage" --account-key "<StorageAccountKey>" --lease-id "<id>"
```

LeasingID inilah yang kita berikan kepihak ketiga apabila ingin mengakses blob tersebut untuk dijadikan sebuah aplikasi.

## Upload data

Data beberapa cara untuk melakukan upload data, bisa menggunakan AzCopy ataupun Microsoft Azure Storage Explorer. Dalam praktek ini menggunakan Microsoft Azure Storage Explorer.

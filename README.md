<!-- TOC -->

- [1. cloudflare-r2-upload action script](#1-cloudflare-r2-upload-action-script)
    - [1.1. Example usage](#11-example-usage)
    - [1.2. Inputs](#12-inputs)
        - [1.2.1. `endpoint`](#121-endpoint)
        - [1.2.2. `accesskeyid`](#122-accesskeyid)
        - [1.2.3. `secretaccesskey`](#123-secretaccesskey)
        - [1.2.4. `bucket`](#124-bucket)
        - [1.2.5. `file`](#125-file)
        - [1.2.6. `destination`](#126-destination)

<!-- /TOC -->

# 1. cloudflare-r2-upload action script
* This action uploads a file to Cloudflare R2 (or any other S3 provider)

## 1.1. Example usage
```
uses: george012/cloudflare-r2-upload@latest
with:
  endpoint: ${{ secrets.S3_COMPATIBILITY_ENDPOINT }}
  accesskeyid: ${{ secrets.S3_COMPATIBILITY_ACCESS_KEY_ID }}
  secretaccesskey: ${{ secrets.S3_COMPATIBILITY_SECRET_ACCESS_KEY }}
  bucket: 'bucket_name'
  file: './custom_path/pre_upload_file_pre.zip'
  destination: '/public_path/upload_over_file_name.zip'
```

## 1.2. Inputs

### 1.2.1. `endpoint`

* <font color=red>Required</font> The S3 endpoint URL.

### 1.2.2. `accesskeyid`

* <font color=red>Required</font> The S3 access key ID.

### 1.2.3. `secretaccesskey`

* <font color=red>Required</font> The S3 access key.

### 1.2.4. `bucket`
* <font color=red>Required</font>  The S3 bucket you want to upload to.

### 1.2.5. `file`

* <font color=red>Required</font> Which file you want to upload

### 1.2.6. `destination`

* <font color=green>Optional</font> Where you want the file to end up. Defaults to '/(filename)'.

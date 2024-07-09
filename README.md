# ramp_data

## s3 との同期

同期

```bash
s3cmd sync docs/rekion/ s3://rekion/iiif/
```

アクセス権の変更

```bash
s3cmd setacl s3://rekion/iiif/ --acl-public --recursive
```

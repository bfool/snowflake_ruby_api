## Example


- Dynamic DSN search

```
# With User and Pwd
api/v1/snowflake/#{DSN}?UID=XXX&PWD=XXX&SQL=#{Base64}


# Without User and Pwd
api/v1/snowflake/#{DSN}?SQL=#{Base64}
```

- Search with driver connection

```
api/v1/snowflake?DRIVER=#{DriverPath}&SERVER=#{ServerAddress}&UID=#{User}&PWD=#{PWD}&SCHEMA=#{Schema}&DATABASE=#{DB}&SQL=#{SQL}
```

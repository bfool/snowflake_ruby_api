## An API for connect to SnowFlake

## Dependence

### ODBC
Open Database Connectivity is a standard application programming interface(API)
for accessing database management systems(DBMS).

About ODBC install, Please reference [SnowFlake Guide.](https://docs.snowflake.com/en/user-guide/odbc.html)

### Sequel

[Sequel](https://github.com/jeremyevans/sequel) is a simple, flexible, and powerful SQL database access toolkit for Ruby.

## How to use

### Dynamic DSN search

```
# With User and Pwd
api/v1/snowflake/#{DSN}?UID=XXX&PWD=XXX&SQL=#{Base64}


# Without User and Pwd
api/v1/snowflake/#{DSN}?SQL=#{Base64}
```

### Search with driver connection

```
api/v1/snowflake?DRIVER=#{DriverPath}&SERVER=#{ServerAddress}&UID=#{User}&PWD=#{PWD}&SCHEMA=#{Schema}&DATABASE=#{DB}&SQL=#{SQL}
```

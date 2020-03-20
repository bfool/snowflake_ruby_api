class SnowflakesController < ApplicationController
  include DecodeSqlConcern

  def fetch_data_with_driver
    drvconnect = 
      "driver=#{params[:DRIVER]};"\
      "server=#{params[:SERVER]};"\
      "uid=#{params[:UID]};"\
      "pwd=#{params[:PWD]};"\
      "schema=#{params[:SCHEMA]};"\
      "database=#{params[:DATABASE]};"

    result = Sequel.odbc(drvconnect: drvconnect).fetch(sql).all

    render json: result
  end

  def fetch_data
    dsn = params[:dsn]
    options = {
      user: params[:UID],
      password: params[:PWD]
    }

    result = Sequel.odbc(dsn, options).fetch(sql).all

    render json: result
  end
end

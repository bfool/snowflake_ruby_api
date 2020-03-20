#!/usr/bin/env puma

application = 'snowflake_ruby_api'

app_path = "/home/deploy/app/#{application}"
shared_path = "#{app_path}/shared"
current_path = "#{app_path}/current"

directory "#{current_path}"
rackup "#{current_path}/config.ru"
environment 'production'
pidfile "#{shared_path}/tmp/pids/puma.pid"
state_path "#{shared_path}/tmp/pids/puma.state"
stdout_redirect "#{shared_path}/log/puma_access.log", "#{shared_path}/log/puma_error.log", true

threads 0,8
workers 0
port ( ENV["PUMA_PORT"]&.to_i || 8080 )

worker_timeout 90

prune_bundler

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "#{current_path}/Gemfile"
end

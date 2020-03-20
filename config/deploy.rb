# config valid for current version and patch releases of Capistrano
lock "~> 3.12.1"

set :application, 'snowflake_ruby_api'
set :repo_url, ''

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :deploy_user, "deploy"
set :keep_releases, 10
set :deploy_to, "/home/#{fetch(:deploy_user)}/app/snowflake_ruby_api"

set :bundle_without,  %w{development test}.join(" ")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads")

set :use_sudo, false

set :rails_env, fetch(:stage)
set :default_env, path: "~/.rbenv/shims:~/.rbenv/bin:$PATH"
set :depoly_via, :remote_cache
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"
set :conditionally_migrate, true

# for rbenv
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.6.5'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# for puma
set :puma_config_path, -> { File.join(current_path, "config", "puma_production.rb") }
set :init_system, :systemd
set :bundler_path, "/home/deploy/.rbenv/shims/bundle"

set :pty, false

namespace :deploy do
  after :publishing, 'web:restart'
  after :finishing, :cleanup
end

namespace :web do
  task :setup_config do
    on roles(:web) do
      upload_customize_config('web')
      upload_customize_config('web', 'socket')
    end
  end

  task :setup_socket do
    on roles(:web) do
      execute :systemctl, "--user", "start", "web-#{fetch(:application)}.socket"
    end
  end

  task :stop do
    on roles(:web) do
      execute :systemctl, "--user", "stop", "web-#{fetch(:application)}.service"
    end
  end

  task :restart do
    on roles(:web) do
      execute :systemctl, "--user", "restart", "web-#{fetch(:application)}.service"
    end
  end
end

def upload_customize_config(app, type = 'service')
  template = File.read("config//deploy/templates/#{app}.#{type}.capistrano.erb")
  systemd_path = fetch(:service_unit_path, fetch_systemd_unit_path)
  execute :mkdir, "-p", systemd_path
  upload!(
    StringIO.new(ERB.new(template).result(binding)),
    "#{systemd_path}/#{app}-#{fetch(:application)}.#{type}"
  )
  execute :systemctl, "--user", "daemon-reload"
  execute :systemctl, "--user", "enable", "#{app}-#{fetch(:application)}.#{type}"
end

set :rails_env, "development"
set :deployment_host, "frda-dev.stanford.edu"
set :bundle_without, [:deployment]

role :web, deployment_host
role :app, deployment_host
role :db,  deployment_host, :primary => true

namespace :deploy do
  namespace :assets do
    task :symlink do ; end
    task :precompile do ; end
  end
end

after "deploy:update_code", "db:symlink_sqlite"
after "deploy", "db:loadfixtures"

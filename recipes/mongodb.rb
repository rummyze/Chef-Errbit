# https://docs.chef.io/resources/apt_repository/
# https://docs.chef.io/infra_language/checking_platforms/

apt_repository 'mongodb' do
  distribution node['lsb']['codename'] + "/mongodb-org/4.4"
  components value_for_platform('ubuntu' => {'default' => ['multiverse']},'debian' => {'default' => ['main']})
  arch value_for_platform('ubuntu' => {'default' => 'amd64'})
  uri 'http://repo.mongodb.org/apt/' + node[:platform]
  key 'https://www.mongodb.org/static/pgp/server-4.4.asc'
end

apt_update do
  action :update
end
  
package "mongodb"
  
execute 'start mongodb' do
   command 'sudo service mongodb start'
  end
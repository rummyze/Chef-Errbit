include_recipe 'errbit::mongodb'
include_recipe 'errbit::errbit'

apt_update do
    action :update
  end

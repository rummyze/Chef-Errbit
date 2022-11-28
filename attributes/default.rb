# https://docs.chef.io/attribute_sources/

default['errbit']['config']['port'] = "80"
default['errbit']['config']['host'] = "errbit.example.com"
default['errbit']['password']     = "$1$qqO27xay$dtmwY9NMmJiSa47xhUZm0." #errbit

if node['errbit_port']
  default['errbit']['config']['port'] = node['errbit_port']
end

if node['errbit_host']
  default['errbit']['config']['host'] = node['errbit_host']
end


if node['errbit_admin_passowrd']
  default['errbit']['password']  = node['errbit_admin_passowrd']
end
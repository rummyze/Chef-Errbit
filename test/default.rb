# - Please, include as many tests as you consider valuable, but we expect that at least open port

describe port(27017) do
  it { should be_listening }
end

describe port(8080) do
  it { should be_listening }
end

describe systemd_service('mongodb') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe systemd_service('errbit.service') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

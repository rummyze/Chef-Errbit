package ['git','nodejs','python'] 

git '/errbit' do 
    repository 'https://github.com/errbit/errbit.git'
    action :sync
end

bash 'install ruby' do 
    code <<-EOH 
    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
    curl -sSL https://get.rvm.io | bash \
    && usermod -a -G rvm root \
    && source /etc/profile.d/rvm.sh \
    && rvm install ruby-2.7.6 \
    && rvm --default use ruby-2.7.6 \
    && echo "gem: --no-document" >> /etc/gemrc \
    && gem update --system "3.3.21" \
    && gem install bundler --version "2.3.21" \
    && bundle config --global frozen 1 \
    && bundle config --global disable_shared_gems false
    cd /usr/local/rvm
    sudo chmod -R ugo+x gems
    EOH
end
template "/errbit/.env" do
    source ".env.erb"
  end

bash 'Build errbit' do
    code <<-EOH
    cd /errbit
    bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5 \
    && bundle clean --force \
    && RAILS_ENV=production bundle exec rake assets:precompile \
    && rm -rf /errbit/tmp/* \
    && chmod 777 /errbit/tmp
    EOH
    cwd "/errbit"
    flags "-l"
  end

# https://docs.chef.io/resources/systemd_unit/
# https://www.shubhamdipt.com/blog/how-to-create-a-systemd-service-in-linux/
# https://errbit.com/docs/master/deployment.html
systemd_unit 'errbit.service' do
    content <<~EOU
    [Unit]
    Description=Errbit
    After=network.target
    [Service]
    WorkingDirectory=/errbit
    Environment=HOME=/errbit
    ExecStart=/bin/bash -l -c "PORT=#{node['errbit']['config']['port']} bundle exec puma -C config/puma.default.rb"
    Restart=always
    [Install]
    WantedBy=multi-user.target
    EOU
    action [:create, :enable, :start]
  end

REPO = 'git@github.com:gnke/puppet.git'

desc "Run puppet on #{ENV['CLIENT']}"
task :apply do
  sh 'git push origin master'
  commands = <<-BOOTSTRAP
  git config --global user.email = "gerald.nke@gmail.com" && \
  git config --global user.name "Gerald Ke" && \
  pull-updates
BOOTSTRAP

  sh "ssh -A vagrant@#{ENV['CLIENT']} -p 2222 \"#{commands}\""
end

desc "Bootstrap puppet on #{ENV['CLIENT']}"
task :bootstrap do
  port = ENV['port'] || 22
  hostname = ENV['HOSTNAME'] || ENV['CLIENT']

  # install puppet & git
  # set hostname
  # clone puppet repo and run puppet apply
  sh "ssh-add /home/gerald/.vagrant.d/insecure_private_key"
  commands = <<-BOOTSTRAP
  wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb && \
  sudo dpkg -i puppetlabs-release-precise.deb && \
  sudo apt-get update -y && \
  sudo apt-get install -y git puppet && \
  sudo hostname #{hostname} && \
  sudo su -c 'echo #{hostname} > /etc/hostname' && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  git clone #{REPO} puppet && \
  sudo puppet apply --modulepath=/home/vagrant/puppet/modules /home/vagrant/puppet/manifests/site.pp
BOOTSTRAP

  sh "ssh -A vagrant@#{ENV['CLIENT']} -p 2222 \"#{commands}\""
end

desc 'Add syntax check hook to your git repo'
task :add_check do
  here = File.dirname(__FILE__)
  sh "ln -s #{here}/hooks/check_syntax.sh #{here}/.git/hooks/pre-commit"
  puts 'Puppet syntax check added'
end

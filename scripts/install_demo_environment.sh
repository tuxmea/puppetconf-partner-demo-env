demo_pwd="`pwd`/puppetconf-partner-demo-env"
cwd=`pwd`
username=`whoami`

if ! [ `uname -s` == "Darwin" ]; then
  echo "This install script only works on Mac OS X"
  exit 1
fi

[ -d $demo_pwd ] || git clone https://github.com/puppetlabs/puppetconf-partner-demo-env.git $demo_pwd || \
  (echo "git is not installed. Follow the XCode instructions that appeared on your screen to install git and then re-run the installer command." && exit 2)

# Make sure we have sudo permissions
echo "Type in your local password (What you use to log into you Mac):"
sudo echo 'Installing system requirements......'

which puppet || sudo gem install puppet --no-rdoc --no-ri

which librarian-puppet || sudo gem install librarian-puppet --no-rdoc --no-ri

cd $demo_pwd/scripts
librarian-puppet install
cd $cwd

sudo FACTER_username=$username puppet apply --modulepath $demo_pwd/scripts/modules $demo_pwd/scripts/demo_requirements.pp


cat <<End-of-message
-------------------------------------
The demo environment should now be operational.

A directory named pe-demo-env has been created
for you. Go into that directory 
with `cd pe-demo-env`,then you can use the 
following commands to operate the environment.

To see a list of available demo environments. run
  $ vagrant demo list

To select one or ore demo environments, run
  $ vagrant demo use demo_1,demo_2

To spin up the demo environment VMs, run
  $ vagrant up

To get IP addresses to connect to the demo hosts, run
  $ vagrant hosts list
-------------------------------------
End-of-message

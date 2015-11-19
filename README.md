1. Install RVM - https://rvm.io/rvm/install

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source $HOME/.rvm/scripts/rvm
```

2. `gem install bundler`
3. `bundle install`
4. `kitchen test -c=3`

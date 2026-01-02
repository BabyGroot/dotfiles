# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias ls='ls -G'
alias reload_shell='source ~/.zshrc'
alias grep='grep --color=always'

# GIT
alias gs='git status'
alias gc='git checkout'
alias gd='git diff'
alias glo='git log --pretty=oneline'
alias gpush='git push'
alias gpull='git pull'
alias gcom='git commit'
alias gfo='git fetch origin'
alias grm='git pull --rebase origin main'
alias cc='convco commit'
alias gbl='git branch | grep -v "main" | grep -v "^\*"'
alias gbclean='git branch | grep -v "main" | grep -v "^\*" | xargs git branch -D'

# Ruby, Rake, Rails and Rubocop
alias runspec='bundle exec rspec'
alias copm='git fetch origin master && git diff-tree -r --no-commit-id --name-only head origin/master | xargs rubocop'
alias copd='git fetch origin master && git add -N .; git diff --name-only | xargs rubocop'
alias copac='rubocop --auto-correct'
alias rake='bundle exec rake'
alias rails='bundle exec rails'
alias rebuild_test_db='rake db:drop db:create db:migrate RAILS_ENV=test'
alias swaggerize='rake rswag:specs:swaggerize'

# Kubernetes
alias kctx='kubectx'
alias kpods='kubectl get pods -o wide'
alias k_console_ops='kubectl exec -n console -it $(get_console_ops_box) -- /bin/bash'
alias k_pm_ops='kubectl exec -n fellowship-of-the-coin -it $(get_pm_ops_box) -- /bin/bash'
alias k_ls_ops='kubectl exec -n fellowship-of-the-coin -it $(get_ls_ops_box) -- /bin/bash'
alias k_console='kubectl config set-context --current --namespace=console'
alias k_fotc='kubectl config set-context --current --namespace=fellowship-of-the-coin'
alias k='kubectl'

# Maven
alias mvn='./mvnw'
alias mvnb='./mvnw clean install'

# Terraform
alias tfmt='terraform fmt -recursive'
alias tf='terraform'

# SSM
alias ssm_redactor='aws ssm start-session --target "i-0595f1e0fed6b5c1b" --region "eu-west-1"'

# Teleport
alias tlogin='tsh login --proxy=teleport.wezatele.awsmmcn.private:443'
alias tldev='tsh login teleport.eu-dev.awsmmcn.private'
alias tlstg='tsh login teleport.eu-staging.awsmmcn.private'
alias tlprod='tsh login teleport.eu-prod.awsmmcn.private'
alias tkls='tsh kube ls'
alias tkldev='tsh kube login dev-eu-aug22'
alias tklstg='tsh kube login staging-eu-aug22'
alias tklprod='tsh kube login production-eu-aug22'
alias tdbls='tsh db ls'
alias tldbdev='tsh db login --db-user=iam_user --db-name=alf console-dev-cluster'
alias tpdbdev='tsh proxy db -p 3080 console-dev-cluster'
alias tldbstg='tsh db login --db-user=iam_user --db-name=alf_staging eng-console-staging-cluster'
alias tpdbstg='tsh proxy db -p 3081 eng-console-staging-cluster'
alias tldbprod='tsh db login --db-user=iam_user --db-name=alf eng-console-production-cluster-reader'
alias tpdbprod='tsh proxy db -p 3083 eng-console-production-cluster-reader'

# Dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Indie
alias platform="cd /Users/indiecampers/indiecampers"
alias website="cd /Users/indiecampers/goindie-website"
alias run-platform="bundle exec rails server -p 3001"
alias run-website="yarn dev_start"
alias run-sidekiq="bundle exec sidekiq"
alias accounting="cd /Users/indiecampers/go-indie-accounting"
alias backoffice="cd /Users/indiecampers/backoffice_api"
alias prd-jumpbox="ssh -i ~/.ssh/jumpkey.pem ec2-user@prod-indie-all-jumpbox.goindie.online"
alias stg-jumpbox="ssh -i ~/.ssh/jumpkey.pem ec2-user@stag-indie-all-jumpbox.goindie.online"
alias start-stg-jumpbox="aws ec2 start-instances --instance-ids i-0506fd455827d14f0"
alias start-prd-jumpbox="aws ec2 start-instances --instance-ids i-0aabbd5c560c0ccad"
alias run_ci_tests="bundle exec rspec"
alias run_ci_parallel="bundle exec rake parallel:spec"

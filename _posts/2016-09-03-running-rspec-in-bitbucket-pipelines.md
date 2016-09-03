---
layout: post
title: Running Rspec in bitbucket pipelines
author: Ramkumar K R
---
Recently, I integrated bitbucket pipelines into the development workflow of my organization. We use the rails framework and rspec to run our tests. 

## Bitbucket pipelines
This is a new CI system from bitbucket based on docker. A YAML file which is very similar to the docker compose file is required to run the build.
You can know more about bitbucket pipelines from [here](https://bitbucket.org/product/features/pipelines).

## Steps to start using bitbucket pipelines

### Get an invite
Since pipelines are still in beta, you need an invite to start using bibtbucket pipelines. You can request for an invite from bitbucket from the [pipelines features page](https://bitbucket.org/product/features/pipelines).

### Understanding the structure of the YAML file
Before diving into the specifics, you may need to understand the structure of the `bitbucket-pipelines.yml` file. Bitbucket provides an excellent explanation for this. It can be accessed [here](https://confluence.atlassian.com/bitbucket/configure-bitbucket-pipelines-yml-792298910.html)

### Docker image 
 You need a docker image to start with. I used the offical rails 4.2.4 docker image for this. (note that this build is deprecated and you may have to use the ruby image for newer updates.)
 Private docker images are also supported. The advantage of using a private docker image is that you can install all your dependencies upfront and reduce your build time considerably. You can get more info about using private docker images in [here](https://confluence.atlassian.com/bitbucket/use-docker-images-as-build-environments-in-bitbucket-pipelines-792298897.html) 

### Installing dependencies
  My organization had a bunch of private dependencies. Since I do not use a private docker image, I had to install them during the build. In order to access these private repositories, I created a new pair of RSA keys and cloned them using SSH.
  
**Things to note**

- The SSH keys should not have a passphrase. You may have to generate keys without a passphrase. The command I used was 
  `ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa`

- You may need to add a list of known hosts. Example - `echo "domain ssh-rsa <some key>" >> ~/.ssh/known_hosts`

The SSH key can be configured as a secret environment variable. You can also encode the key using base64
 and decode it as a step in the build. More details can be found in this [question](https://answers.atlassian.com/questions/38853952/pulling-private-repositories-inside-pipelines).

### Sending Notifications
Currently sending notifications is not supported by pipelines. You can instead make a CURL call to a service such as slack which provides webhooks for sending notifications.
```
curl -X POST -H 'Content-type: application/json' \
--data '{"text":"Build Successful"}' \
 "http://www.example.com"
 ```



#### *That's it!. Once you can access your repositories and install your dependencies, you can just run `bundle` and then run the test command. Since I use rspec here, I just run `bundle exec rspec`*
 
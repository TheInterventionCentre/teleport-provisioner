# teleport-provisioner
Terraform provisioner for infrastructure at IVS (teleport)

# Requirements

Make sure you have the `google-cloud` client installed, authenticated and with a vaild project set:

`gcloud auth login`
`gcloud config set project`
   
   
You should also have a DNS record to point your domain/subdomain to the external
fixed ip provided by google cloud. This is tricky, because at the time of
creation, you still don't have an external IP. So you might want to do this in
two steps. Apply a first time to get all infrastructure, get the external IP and
change your DNS, then wait until DNS are propagated and apply again.

## Deployment

After deployment log into the server and create a new user (as an example, here we use `testuser`).

``` sh
sudo docker exec teleport tctl users add admin --roles=editor,auditor,access --logins=root
```


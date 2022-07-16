# teleport-provisioner
Teleport provisioner for infrastructure at IVS

## DNS records

| Type  | Hostname                      | Value                                    |
| ----- | ----------------------------- | ---------------------------------------- |
| A     | `test1.evgeniy-khyst.com`     | directs to IP address `X.X.X.X`          |
| A     | `test2.evgeniy-khyst.com`     | directs to IP address `X.X.X.X`          |
| CNAME | `www.test1.evgeniy-khyst.com` | is an alias of `test1.evgeniy-khyst.com` |
| CNAME | `www.test2.evgeniy-khyst.com` | is an alias of `test2.evgeniy-khyst.com` |
   

## Deployment


https://github.com/nginx-proxy/nginx-proxy

After deployment log into the server and create a new user (as an example, here we use `testuser`).

``` sh
sudo docker exec teleport tctl users add testuser --roles=editor,access --logins=root,ubuntu,ec2-user
```


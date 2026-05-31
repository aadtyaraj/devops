# Super Duper Secrets

create secret manifest > kubeseal it to generate sealed secret > apply sealed secret > automatically creates unsealed secret

```bash
k -n sealed create secret generic mysecret --from-literal username=admin --from-literal password=admin321 --dry-run=client -o json > mysecret.json

kubeseal -f mysecret.json -w mysealedsecret.yaml -o yaml 

k apply -f mysealedsecret.yaml

k -n sealed get secret mysecret
```

note: both secret and sealed secret should have the same namespace

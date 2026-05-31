# Hashicorp Vault

## Deploy vault in cluster

So the basic idea is that I deploy HashiCorp Vault using its Helm chart. The Helm chart actually creates, using the custom values file we provided, a high-availability cluster for Vault. It deploys Vault as a stateful set so that they get persistent fully qualified domain names.  
 
We then go ahead and get into each of the pods created by the stateful set and unseal the Vault so that we can generate the root token that would be required to read the decryption key. Once we have unsealed each of the pods, we are able to create an authentication path for authentication and then enable a method for authentication. We use the key-value operation to put our secrets into a specific path in Vault. When we enable the Kubernetes authentication method, we are able to provide it with a configuration file that allows the service account that we mentioned to actually authenticate to Vault and read the secrets. The capabilities of the service account can be controlled through the config file for Vault that we actually create. When we deploy the application, which uses the service account that we configured, it is able to read those secrets effectively.

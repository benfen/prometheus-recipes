# Prometheus Recipes

This repository is a collection of generated [kube-prometheus](https://github.com/coreos/kube-prometheus/) configurations used to get up and running with Prometheus (and friends) quickly in a development environment.

## Choose a Recipe

_Only apply one set of configurations to a cluster._

With that being said, you can apply a configuration to as many namespaces within a cluster as you would like.  Just pass a comma-separated list of namespaces to apply it to.

```bash
# This will create all three of these namespaces (if they don't exist) and ensure that prometheus watches them.
./prometheus-recipes.sh testns,test2,other-namespace
```

Note that prometheus-recipes will __not__ delete any namespaces that it creates in this manner.  It will only clean up its own monitoring namespace.

### Basic

The basic recipe is effectively the kube-prometheus [example](https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/example.jsonnet) with a little bash magic on top. There are no prerequisites, just apply the configurations:

```bash
./prometheus-recipes.sh
```

## Connecting Services to Prometheus

To connect a service to this Prometheus, make sure that the namespace it is in is being tracked by prometheus (see above for details on this).  Once you have run the `prometheus-recipes.sh` script, you can create service monitor within your own namespace to connect to this prometheus:

```yml
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: mymetricmonitor
spec:
  endpoints:
  - interval: 15s
    port: mymetricport
  selector:
    matchLabels:
      app: mymetricmaker
```

And that's it!

## Troubleshooting

If you run into issues creating the role bindings (particularly on gke), run `kubectl create clusterrolebinding $binding_name --clusterrole=cluster-admin --user=$my_username` to add the appropriate permissions.

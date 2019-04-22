# Prometheus Recipes

This repository is a collection of generated [kube-prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus) configurations used to get up and running with Prometheus (and friends) quickly in a development environment.

## Choose a Recipe

_Only apply one set of configurations to a cluster._

### Basic

The basic recipe is effectively the kube-prometheus [example](https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/example.jsonnet). There are no prerequisites, just apply the configurations:

```
$ kubectl apply -f basic/
```

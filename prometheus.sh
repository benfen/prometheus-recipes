#!/bin/bash

defaults="default kube-system monitoring"

namespaceFile="build/namespaces.yml"
roleBindingFile="build/prometheus-roleBindingSpecificNamespaces.yaml"
roleFile="build/prometheus-roleSpecificNamespaces.yaml"

mkdir -p build

echo "---" > $namespaceFile
printf "apiVersion: rbac.authorization.k8s.io/v1\nkind: RoleBindingList\nitems:\n" > $roleBindingFile
printf "apiVersion: rbac.authorization.k8s.io/v1\nkind: RoleList\nitems:\n" > $roleFile

NAMESPACE_TEMPLATE="\
apiVersion: v1
kind: Namespace
metadata:
  name: NAMESPACE
---"

ROLE_BINDING_TEMPLATE="\
- apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: prometheus-k8s
    namespace: NAMESPACE
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: Role
    name: prometheus-k8s
  subjects:
  - kind: ServiceAccount
    name: prometheus-k8s
    namespace: monitoring"

ROLE_TEMPLATE="\
- apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    name: prometheus-k8s
    namespace: NAMESPACE
  rules:
  - apiGroups:
    - \"\"
    resources:
    - services
    - endpoints
    - pods
    verbs:
    - get
    - list
    - watch"

for name in $defaults
do
    echo "$ROLE_BINDING_TEMPLATE" | sed "s/NAMESPACE/$name/" >> $roleBindingFile
    echo "$ROLE_TEMPLATE" | sed "s/NAMESPACE/$name/" >> $roleFile
done

IFS=","
for name in $namespaces
do
    echo "$ROLE_BINDING_TEMPLATE" | sed "s/NAMESPACE/$name/" >> $roleBindingFile
    echo "$ROLE_TEMPLATE" | sed "s/NAMESPACE/$name/" >> $roleFile
    echo "$NAMESPACE_TEMPLATE" | sed "s/NAMESPACE/$name/" >> $namespaceFile
done

if [ "on" == $delete ]; then
    kubectl delete -f core
    kubectl delete -f core/prometheus
    kubectl delete -f extra/alertmanager
    kubectl delete -f extra/grafana
    kubectl delete -f extra/kube-state-metrics
    kubectl delete -f extra/node-exporter

    kubectl delete -f $roleBindingFile
    kubectl delete -f $roleFile
else
    kubectl apply -f core
    kubectl apply -f core/prometheus
  
    if [ "on" == $deploy_alertmanager ]; then
        kubectl apply -f extra/alertmanager
    fi

    if [ "on" == $deploy_grafana ]; then
        kubectl apply -f extra/grafana
    fi

    if [ "on" == $deploy_kube_state_metrics ]; then
        kubectl apply -f extra/kube-state-metrics
    fi

    if [ "on" == $deploy_node_exporter ]; then
        kubectl apply -f extra/node-exporter
    fi

    kubectl apply -f build
fi

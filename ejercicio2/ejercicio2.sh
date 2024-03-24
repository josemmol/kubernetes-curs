#!/bin/bash
#Aquest script resoldrà l'exercici 2 de la pràctica final 

#Creació del clúster
kind create cluster --name madronalex2 --config kind-config.yaml

#Creació del namespace exercici2
kubectl apply -f nsexercici2.yml

#Afegir repositori bitnami:
helm repo add bitnami https://charts.bitnami.com/bitnami

#Comprovar que s'ha afegit el repositori
helm repo list

#Instal·lació del nginx de bitnami
helm install myweb-nginx bitnami/nginx -n exercici2

#Esperar que nginx arranqui
sleep 20

#Mostrar l'estat del release del helm
helm status nginx-bitnami

#Mostrar els pots
kubectl get pods -n exercici2

#Abans de fer aquesta passa s'ha d'haver descarregat 
#els values amb la següent instrucció
#$helm show values bitnami/nginx > values.yaml
#canviar "tag: 1.25.4-debian-12-r3" per "tag: 1.25.4-xxxxxx-12-r3"
#Mostram els canvis fets al fitxer values.yaml
grep -B 4 "tag: 1.25.4-xxxxxx-12-r3" values.yaml

#Actualitzar el chart amb els valor de values.yaml
helm upgrade --install -f values.yaml myweb-nginx bitnami/nginx -n exercici2

#Esperar que nginx arranqui
sleep 20

#Mostrar l'estat del release del helm
helm status nginx-bitnami

#Mostrar els pots
kubectl get pods -n exercici2

#Rollback a la versió previa
helm rollback myweb-nginx 1 -n exercici2

#Esperar que nginx arranqui
sleep 20

#Mostrar l'estat del release del helm
helm status nginx-bitnami

#Mostrar els pots
kubectl get pods -n exercici2

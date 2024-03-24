#!/bin/bash
#Aquest script resoldrà l'exercici 1 de la pràctica final 

#Creació del clúster
kind create cluster --name madronal --config kind-config.yaml

#Creació dels tres sistems
#Desplegament del primer sistema web

#Creació del namespace frontend
kubectl apply -f nsfrontend.yml

#Creació del namespace backend
kubectl apply -f nsbackend.yml

#Creació del volum persistend
kubectl apply -f prfinalpv.yml

#Creació del volum persistend claim
kubectl apply -f prfinalpvc.yml

#Creació del sist postgresql
kubectl apply -f prfinalsistpostgresql.yml

#Creació del servei postgresql-service per accedir a la BD
kubectl apply -f prfinalservicepostgresql.yml

#Creació del sistema web static
kubectl apply -f prfinalsistwebstatic.yml

#Creació del servei http static
kubectl apply -f prfinalservicehttpstatic.yml

#Creació del configmap per al sistema web
kubectl apply -f prfinalcmappostgresqldbconfig.yml

#Creació del sercret al sistema web
kubectl apply -f prfinaldbsecret.yml

#Creació del sistema web
kubectl apply -f prfinalsistweb.yml

#Creació del servei http static
kubectl apply -f prfinalservicehttp.yml

#Creacio de l'ingres
kubectl apply -f prfinalingreshttp.yml

#Creació de l'ingres controler
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
#kubectl apply -f deploy.yaml



#!/bin/bash
#Aquest script resoldrà l'exercici 1 de la pràctica final 

#Creació del clúster
kind create cluster --name madronal --config kind-config.yaml

#Creació dels tres sistems
#Desplegament del primer sistema web

#Creació del namespace frontend
kubectl apply -f frontend.yml





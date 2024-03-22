# Introducio Kubernetes

## Introducció

Aquest és un curs d’introducció a kubernetes.

## Pràctica 1: Instal·lar un clúster de kubernetes

Per fer la instal·lació del clúster de kubernetes s'ha seguit el següent enllaç:

https://github.com/ciberado/k8s-lab-based-training/tree/master/0100-PROVISIONING/050-kind

Per definir el clúster s'ha utilitzat el següent fitxer:

[kind-config.yaml](/kind-config.yaml)

## Pràctica 2: Creació i desplegament de pods (NO EVALUABLE)

Enuciat al classroom
https://classroom.google.com/u/1/c/NjAxMzY1MjUzNTU5/a/NjU0OTQwMzk4Mzk2/details

### Primera passa: Etiquetar els nodes del clúster de la pràctica 1

Els nodes han de tenir les següents labels:
          worker1: size=Large
          worker2: size=Medium
          worker3: size=Small

Mostrar els nodes del clúster:
```
sudo kubectl get node
```

Mostrar els labels dels nodes:
```
sudo kubectl get node --show-labels
```

Afegir el label size als nodes del clúster:
```
kubsudo kubectl label nodes local-cluster-worker size=Large
sudo kubectl label nodes local-cluster-worker2 size=Medium
sudo kubectl label nodes local-cluster-worker3 size=Small
```

### Segona passa: Instal·lació 1: Desplegar un pod amb vàries etiquetes que tingui dos contenidors un web i un cache.

Addicionalment, té com a requisits un mínim de 100 MB de ram. Ha de desplegar només en el worker3. Ha de tenir configurat una estratègia de control perquè es reiniciï en cas de problemes. Ha de fer-se en un namespace amb nom practica2inst1.

Aquest seria el fitxer yml de configuració del pod **inst1-pod**:

[pr2inst1.yml](/pr2inst1.yml)

Abans de desplegar el pod s’ha de crear el namespace **practica2inst1**.
```
sudo kubectl create namespace practica2inst1
```

Per desplegar el pod:
```
sudo kubectl apply -f pr2inst1.yml
```

Comprovar que el pot s'ha desplegat
```
sudo kubectl get pods -A
```
o indicant el namespace **practica2inst1**
```
sudo kubectl get pods --namespace=practica2inst1
```

Mostrar la descripció del pod **inst1-pod** al namespace **practica2inst1**
```
sudo kubectl describe pod inst1-pod --namespace=practica2inst1
```

Per eliminar els pods d'un namespace
```
sudo kubectl delete pods --all --namespace=practica2inst1
```


### Tercera Passa: Instal·lació 2: Desplegament d’una aplicació web amb 2 rèpliques del mateix servidor web. 


Addicionalment, ha de desplegar-se en els nodes de grandària Medium o Large i han de tenir uns healthchecks que controlin el correcte funcionament. Els pods no poden executar-se en el mateix node. Una vegada estigui funcionant afegir una rèplica més i mostrar l'estat del desplegament. Ha de fer-se en un namespace amb nom practica2inst2.

Aquest seria el fitxer yml de configuració del replicaSet **servidor-web-rs**:

[pr2inst2.yml](/pr2inst2.yml)

Abans de desplegar el pod s'ha de crear el namespace **practica2inst2**.
```
sudo kubectl create namespace practica2inst2
```

Per desplegar el replicaSet:
```
sudo kubectl apply -f pr2inst2.yml
```

Comprovar que el replicaset s'ha desplegat*
```
sudo kubectl get pods --namespace=practica2inst2
```
o
```
sudo kubectl get replicaset --namespace=practica2inst2
```

Mostrar la descripció del pods al namespace **practica2inst1**
```
sudo kubectl describe pod --namespace=practica2inst2
```

Afegir una rèplica al replicaset **servidor-web-rs**
```
sudo kubectl scale replicaset servidor-web-rs --replicas=3 --namespace=practica2inst2
```

Això que es doni aquest error per incomplatibiliatat dels nodes
``` 
Warning  FailedScheduling  103s  default-scheduler  0/4 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }, 2 node(s) didn't match Pod's node affinity/selector, 2 node(s) didn't match pod anti-affinity rules. preemption: 0/4 nodes are available: 2 No preemption victims found for incoming pod, 2 Preemption is not helpful for scheduling.
```

### Quarta passa: Instal·lació 3: Desplegament d'una aplicació web amb 2 repliques del mateix servidor web.

Han de tenir uns healthchecks que controlin el correcte funcionament. Els pods no poden executar-se en el mateix node (es pot reaprofitar la instal·lació 2 si es vol). Addicionalment ha de desplegar-se una aplicació (cache) i han de tenir uns healthchecks que controlin el correcte funcionament. Els pods no poden executar-se en el mateix node. Cada pod web haver de córrer en un node on hi hagi un pod cache.

`sudo kubectl get pods --namespace=practica2inst2`
```
NAME                    READY   STATUS    RESTARTS   AGE
servidor-web-rs-d9thv   1/1     Running   0          19m
servidor-web-rs-kj5xs   1/1     Running   0          19m
servidor-web-rs-t88vr   0/1     Pending   0          10m
```

### Quarta passa: Instal·lació 3: Desplegament d'una aplicació web amb 2 repliques del mateix servidor web.

Han de tenir uns healthchecks que controlin el correcte funcionament. Els pods no poden executar-se en el mateix node (es pot reaprofitar la instal·lació 2 si es vol). Addicionalment ha de desplegar-se una aplicació (cache) i han de tenir uns healthchecks que controlin el correcte funcionament. Els pods no poden executar-se en el mateix node. Cada pod web haver de córrer en un node on hi hagi un pod cache. Ha de fer-se en un namespace amb nom practica2inst3.

#### Opció 1:
Un replica set amb dos contenidors

Cream el namespace
```
sudo kubectl create namespace practica2inst3v1
```

Cream un replicaset amb dos contenidors diferents.

[pr2inst3v1rs1.yml](/pr2inst3v1rs1.yml)

Desplegar el replicaset
```
sudo kubectl apply -f pr2inst3v1rs1.yml
```

Comprovam el desplagament.
```
sudo kubectl get pods --namespace=practica2inst3v1

```

#### Opció 2:
Dos replicasets un amb contenidors web i un altre amb contenidors cache.

Cream el namespace
```
sudo kubectl create namespace practica2inst3v2
```

Cream dos replicaset amb un contenidor cada un.


[pr2inst3v2rs1.yml](/pr2inst3v2rs1.yml)

[pr2inst3v2rs2.yml](/pr2inst3v2rs2.yml)

Deplegar els dos replicaset
```
sudo kubectl apply -f pr2inst3v2rs1.yml
sudo kubectl apply -f pr2inst3v2rs2.yml
```

Comprovam el desplagament.
```
sudo kubectl get pods --namespace=practica2inst3v2
```

#### Opció 3:
Dos replicasets un amb contenidors web i un altre amb contenidors cache.

Cream el namespace a partir d'un yaml

[pr2inst3v3nsv3.yml](/pr2inst3v3nsv3.yml)

```
sudo kubectl apply -f pr2inst3v3nsv3.yml
```

Cream dos replicaset amb un contenidor cada un.


[pr2inst3v3rs1.yml](/pr2inst3v3rs1.yml)

[pr2inst3v3rs2.yml](/pr2inst3v3rs2.yml)

Deplegar els dos replicaset
```
sudo kubectl apply -f pr2inst3v3rs1.yml
sudo kubectl apply -f pr2inst3v3rs2.yml
```

Comprovam el desplegament.
```
sudo kubectl get pods --namespace=practica2inst3v3
```

## Pàctica 4: Practica final

Per poder executar el kind des de qualsevol lloc hem de posar el kind al path per això ho fem amb la següent instrucció.
```
export PATH="/home/jmmol/go/bin/:$PATH"
```
Una vegada fet això cream el directori de treball per a la pràctica final
```
mkdir practicafinal
cd practicafinal
```

Creació del clúster
```
kind create cluster --name madronal --config kind-config.yaml
```

## Dubtes
* Com és fa per llançar un conjunt de replicasets o pods. Es pot fer amb un sol yaml?
* Es pot llançar un replicaset amb replicas igual a 0?
* Es pot fer un pot que indiqui el nombre de tipus de contenidors i un nobre de tipus d'un altre?
* Com puc fer un deployment que inclogui varis pods de diferents tipus per exemple web-store web-tickets web-chat?
* com puc fer que un pod de dos cotainers s'executi un primer contenidor i fins que aquest no hagi arrancat no arrangui el segon?
* Es poden definir ordres d'execusió dels pods?



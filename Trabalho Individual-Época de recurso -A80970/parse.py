import pandas as pd 
import numpy as np
import math
import random


#ler dados
data = pd.read_excel(r'cidades.xlsx',encoding='utf-8')

data['city'] = data['city'].str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
data['admin'] = data['admin'].str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
data['capital'] = data['capital'].str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')

lines = data.values


dist_dict = {
    'Braga' : ['Porto','Viana do Castelo', 'Vila Real'],
    'Viana do Castelo' : ['Braga'],
    'Porto' : ['Braga', 'Vila Real', 'Aveiro', 'Viseu'],
    'Vila Real' : ['Porto', 'Braga', 'Braganca', 'Viseu'],
    'Braganca' : ['Vila Real', 'Guarda', 'Viseu'],
    'Aveiro' : ['Viseu','Porto','Coimbra'],
    'Viseu' : ['Aveiro', 'Porto', 'Vila Real', 'Guarda', 'Braganca', 'Coimbra'],
    'Guarda' : ['Braganca', 'Castelo Branco', 'Viseu', 'Coimbra'],
    'Coimbra' : ['Aveiro', 'Viseu', 'Leiria', 'Castelo Branco', 'Guarda'],
    'Castelo Branco' : ['Guarda', 'Coimbra', 'Leiria', 'Santarem', 'Portalegre'],
    'Leiria' : ['Coimbra', 'Castelo Branco', 'Santarem', 'Lisboa'],
    'Santarem' : ['Leiria', 'Lisboa', 'Setubal', 'Portalegre', 'Evora', 'Castelo Branco'],
    'Portalegre' : ['Castelo Branco', 'Santarem', 'Evora'],
    'Lisboa' : ['Leiria', 'Santarem', 'Setubal'],
    'Setubal' : ['Evora', 'Beja', 'Santarem', 'Lisboa'],
    'Evora' : ['Setubal', 'Santarem', 'Portalegre', 'Beja'],
    'Beja' : ['Setubal', 'Evora', 'Faro'],
    'Faro' : ['Beja']
}

#defenicao de algumas funcoes auxiliares

def cidadesDo_distrito(dist):
    ans = []
    for l in lines:
        if l[4] == dist:
            ans.append(l[0])
    return ans


def distancia(cidade1,cidade2):
    lat1=0
    long1=0
    lat2=0
    long2=0
    for l in lines:
        if l[0] == cidade1:
            lat1 = l[2]
            long1 = l[3]
        elif l[0] == cidade2:
            lat2 = l[2]
            long2 = l[3]
        else:
            continue
    ret = math.sqrt(((lat1-lat2)**2) + ((long1-long2)**2))
    return ret

def randomNCitys(N=100):
    cidIds = set()
    for _ in range(0,N):
        cId = random.randint(1,285)
        if cId in cidIds:
            continue
        else:
            cidIds.add(cId)
    return cidIds


def Idcidade(cidade):
    for l in lines:
        if cidade == l[1]:
            return l[0]
        else:
            continue

#criacao das cidades

cidfile = open('plsrc/cidades.pl','w+',encoding='utf-8')
cidfile.write(r'%cidade(ID,Nome,Latitide,Longitude,Admin,Capital)')
cidfile.write('\n')

for l in lines:
    s = "cidade({},'{}',{},{},'{}','{}').\n".format(l[0],l[1],l[2],l[3],l[4],l[5])
    cidfile.write(s)
cidfile.close()


#ciarcao das caracteristicas

carfile = open('plsrc/caracteristicas.pl','w+',encoding='utf-8')
carfile.write(r'%hotel5Estrelas(ID)')
carfile.write('\n')
carfile.write(r'%monumentos(ID)')
carfile.write('\n')
carfile.write(r'%especialidadeGastronomica(ID)')
carfile.write('\n')
carfile.write(r'%espacosVerdes(ID)')
carfile.write('\n')
carfile.write(r'%atividadesNoturnas(ID)')
carfile.write('\n')

carfile.write('\n\n\n')
carfile.write(r'%---------- Cidades Com 5 Estrelas -----------')
carfile.write('\n\n\n')

hoteis = set()

for k , v in dist_dict.items():
    s = 'hotel5Estrelas({}).\n'.format(Idcidade(k))
    hoteis.add(s)
    

cidComhotel=randomNCitys(100)
for i in cidComhotel:
    s = 'hotel5Estrelas({}).\n'.format(i)
    hoteis.add(s)

for s in hoteis:
    carfile.write(s)

carfile.write('\n\n\n')
carfile.write(r'%---------- Cidades Com Monumentos -----------')
carfile.write('\n\n\n')

monumentos = set()

for k , v in dist_dict.items():
    s = 'monumentos({}).\n'.format(Idcidade(k))
    monumentos.add(s)
    

cidComMonumento=randomNCitys(100)
for i in cidComMonumento:
    s = 'monumentos({}).\n'.format(i)
    monumentos.add(s)

for s in monumentos:
    carfile.write(s)

carfile.write('\n\n\n')
carfile.write(r'%---------- Cidades Com Especialidades Gastronomicas -----------')
carfile.write('\n\n\n')

EspeGast = set()

for k , v in dist_dict.items():
    s = 'especialidadeGastronomica({}).\n'.format(Idcidade(k))
    EspeGast.add(s)

cidComEP=randomNCitys(100)
for i in cidComEP:
    s = 'especialidadeGastronomica({}).\n'.format(i)
    EspeGast.add(s)

for s in EspeGast:
    carfile.write(s)

carfile.write('\n\n\n')
carfile.write(r'%---------- Cidades Com Espaços Verdes -----------')
carfile.write('\n\n\n')

EspVerd = set()

for k , v in dist_dict.items():
    s = 'espacosVerdes({}).\n'.format(Idcidade(k))
    EspVerd.add(s)

cidComEV=randomNCitys(100)
for i in cidComEV:
    s = 'espacosVerdes({}).\n'.format(i)
    EspVerd.add(s)
for s in EspVerd:
    carfile.write(s)

carfile.write('\n\n\n')
carfile.write(r'%---------- Cidades Com Atividades Noturnas -----------')
carfile.write('\n\n\n')

ActNot = set()

cidComAN=randomNCitys(100)
for i in cidComAN:
    s = 'atividadesNoturnas({}).\n'.format(i)
    ActNot.add(s)

for s in ActNot:
    carfile.write(s)

carfile.close()

#criação dos arcos

arcos = set()
acrfile = open('plsrc/grafo.pl','w+',encoding='utf-8')
acrfile.write(r'%arco(IDCidade1,IDCidade2,Distancia)')
acrfile.write('\n')
for k , v in dist_dict.items():
    cidadesk = cidadesDo_distrito(k)
    cap = Idcidade(k)
    for ck in cidadesk:
        if cap == ck:
            continue
        s = 'arco({},{},{}).\n'.format(ck,cap,distancia(ck,cap))
        a = 'arco({},{},{}).\n'.format(cap,ck,distancia(cap,ck))
        arcos.add(a)
        arcos.add(s)
    for ad in v:
        cap1 = Idcidade(ad)
        cap2 = Idcidade(k)
        s = 'arco({},{},{}).\n'.format(cap2,cap1,distancia(cap2,cap1))
        arcos.add(s)




for s in arcos:
    acrfile.write(s)


acrfile.close()
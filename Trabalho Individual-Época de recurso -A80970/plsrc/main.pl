%-------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI
%
% Davide Matos - A80970

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- include('cidades.pl').
:- include('grafo.pl').
:- include('caracteristicas.pl').


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ). % definição de um invariante



%--------------------------------- - - - - - - - - - -  -  Solucoes
% Termo, Predicado, Lista -> {V,F}
solucoes(T,Q,S) :- findall(T,Q,S).

%--------------------------------- - - - - - - - - - -  -
% Predicado nao
nao(Questao) :-
    Questao,!,fail.
nao(_).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Predicado comprimento
comprimento(S,N) :-
    length(S,N).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Predicado que da print
escrever([]).
escrever([X|T]) :-
    write(X),
    nl ,
    escrever(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Predicado que adiciona a uma lista
add(X, [], [X]).
add(X, [Y | T], [X,Y | T]) :- X @< Y, !.
add(X, [Y | T1], [Y | T2]) :- add(X, T1, T2).




%----------------------------------------------------------------%
%                        NÃO INFORMADA                           %
%----------------------------------------------------------------%

%-------------------------DEPTH FIRST-------------------------

%--------------------------QUERIE 1--------------------------
% escolher um qualquer percuso entre duas cidades

percurso(Origem,Destino, [Origem|Caminho], Dist) :-                             		% funçao principal
    percursoAux(Origem, Destino,Caminho, Dist,[]).                              		% Lista de Visitados inicialmente Vazio

percursoAux(Destino,Destino, [], 0,_).                                                  % caso de paragem
percursoAux(Origem,Destino ,[Prox|Caminho], Dist,Visitados) :-
    Origem \= Destino,                                                                  % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                          			% procura o arco adjacente
    nao(member(Prox,Visitados)),                                                        % verifica que o Proximo nao está na lista de Visitados
    percursoAux(Prox, Destino, Caminho, Dist2,[Origem|Visitados]),
    Dist is Dist1 + Dist2.	                                                         	% somar as distancias

adjacente(Origem, Prox, Dist) :-                                              		 	% vai buscar o arco
    arco(Origem,Prox, Dist).                                                   			% Procura o arco Origem,Destino


caminhos(Origem,Destino):-
    findall((S,Dist),percurso(Origem,Destino,S,Dist),L),                        % imprime todos
    escrever(L).

% Exemplo caminhos(21,23).

%----------------------------------QUERIE 2-----------------------------------------
% Selecionar apenas cidades com uma determinhada caracteristica para um determinado trajeto.

%primeira query para a caracteristica hotel5estrelas.

percursocarHotel(Origem,Destino,[Origem|Percurso],Dist) :-
	percursocarHotelAux(Origem,Destino,Percurso,Dist,[]).

percursocarHotelAux(Dest, Dest, [], 0 , _ ).
percursocarHotelAux(Origem, Dest, [Prox|Caminho], Dist, Visitados) :-
    Origem \= Dest,                                                                          % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                                         % Procura arco adjacente
    nao(member(Prox,Visitados)),                                                            % Verifica que o proximo nao esta na lista de Visitados
    hotel5Estrelas(Prox),                                                                   % Verificar a proxima cidade tem hotel 5 estrelas
    percursocarHotelAux(Prox, Dest, Caminho, Dist2, [Origem | Visitados]),
    Dist is Dist1 + Dist2.                                                                  % somar as distancias




todosHotel(Origem,Destino):-
    findall((S,Dist,Car),percursocarHotel(Origem,Destino,S,Dist),L),
    escrever(L).      % print listas

% Exemplo todoshotel(2,32).

%query para a caracteristica monumentos.

percursocarMonumento(Origem,Destino,[Origem|Percurso],Dist) :-
	percursocarMonumentoAux(Origem,Destino,Percurso,Dist,[]).

percursocarMonumentoAux(Dest, Dest, [], 0 , _ ).
percursocarMonumentoAux(Origem, Dest, [Prox|Caminho], Dist, Visitados) :-
    Origem \= Dest,                                                                          % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                                         % Procura arco adjacente
    nao(member(Prox,Visitados)),                                                            % Verifica que o proximo nao esta na lista de Visitados
    monumentos(Prox),                                                                       % Verificar a proxima cidade tem monumentos
    percursocarMonumentoAux(Prox, Dest, Caminho, Dist2, [Origem | Visitados]),
    Dist is Dist1 + Dist2.                                                                  % somar as distancias




todosMonumento(Origem,Destino):-
    findall((S,Dist,Car),percursocarMonumento(Origem,Destino,S,Dist),L),
    escrever(L).      % print listas

% Exemplo todosMonumento(2,32).

%query para a caracteristica especialidades gastronimocas.

percursocarEspGast(Origem,Destino,[Origem|Percurso],Dist) :-
	percursocarEspGastAux(Origem,Destino,Percurso,Dist,[]).

percursocarEspGastAux(Dest, Dest, [], 0 , _ ).
percursocarEspGastAux(Origem, Dest, [Prox|Caminho], Dist, Visitados) :-
    Origem \= Dest,                                                                          % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                                         % Procura arco adjacente
    nao(member(Prox,Visitados)),                                                            % Verifica que o proximo nao esta na lista de Visitados
    especialidadeGastronomica(Prox),                                                         % Verificar a proxima cidade tem especialidades gastronomicas
    percursocarEspGastAux(Prox, Dest, Caminho, Dist2, [Origem | Visitados]),
    Dist is Dist1 + Dist2.                                                                  % somar as distancias




todosEspGast(Origem,Destino):-
    findall((S,Dist,Car),percursocarEspGast(Origem,Destino,S,Dist),L),
    escrever(L).      % print listas

% Exemplo todosEspGast(2,32).

%query para a caracteristica espaços verdes.

percursocarEspVerde(Origem,Destino,[Origem|Percurso],Dist) :-
	percursocarEspVerdeAux(Origem,Destino,Percurso,Dist,[]).

percursocarEspVerdeAux(Dest, Dest, [], 0 , _ ).
percursocarEspVerdeAux(Origem, Dest, [Prox|Caminho], Dist, Visitados) :-
    Origem \= Dest,                                                                          % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                                         % Procura arco adjacente
    nao(member(Prox,Visitados)),                                                            % Verifica que o proximo nao esta na lista de Visitados
    espacosVerdes(Prox),                                                         % Verificar a proxima cidade tem espaços verdes
    percursocarEspVerdeAux(Prox, Dest, Caminho, Dist2, [Origem | Visitados]),
    Dist is Dist1 + Dist2.                                                                  % somar as distancias




todosEspVerde(Origem,Destino):-
    findall((S,Dist,Car),percursocarEspVerde(Origem,Destino,S,Dist),L),
    escrever(L).      % print listas

% Exemplo todosEspVerde(2,32).

%query para a caracteristica actividades noturnas.

percursocarAtiNoct(Origem,Destino,[Origem|Percurso],Dist) :-
	percursocarAtiNoctAux(Origem,Destino,Percurso,Dist,[]).

percursocarAtiNoctAux(Dest, Dest, [], 0 , _ ).
percursocarAtiNoctAux(Origem, Dest, [Prox|Caminho], Dist, Visitados) :-
    Origem \= Dest,                                                                          % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                                         % Procura arco adjacente
    nao(member(Prox,Visitados)),                                                            % Verifica que o proximo nao esta na lista de Visitados
    atividadesNoturnas(Prox),                                                         % Verificar a proxima cidade tem atividades noturnas
    percursocarAtiNoctAux(Prox, Dest, Caminho, Dist2, [Origem | Visitados]),
    Dist is Dist1 + Dist2.                                                                  % somar as distancias




todosAtiNoct(Origem,Destino):-
    findall((S,Dist,Car),percursocarAtiNoct(Origem,Destino,S,Dist),L),
    escrever(L).      % print listas

% Exemplo todosAtiNoct(2,32).


%----------------------------------QUERIE 3-----------------------------------------
% Escolher um trajeto que passa por cidades que excluem um determinada caracteristica.


percursoExccarAtiNoct(Origem,Destino,[Origem|Percurso],Dist) :-
	percursoExccarAtiNoctAux(Origem,Destino,Percurso,Dist,[]).

percursoExccarAtiNoctAux(Dest, Dest, [], 0 , _ ).
percursoExccarAtiNoctAux(Origem, Dest, [Prox|Caminho], Dist, Visitados) :-
    Origem \= Dest,                                                                          % se Origem diferente de Destino
    adjacente(Origem, Prox, Dist1),                                                         % Procura arco adjacente
    nao(member(Prox,Visitados)),                                                            % Verifica que o proximo nao esta na lista de Visitados
    nao(atividadesNoturnas(Prox)),                                                         % Verificar a proxima cidade nao tem atividades noturnas
    percursoExccarAtiNoctAux(Prox, Dest, Caminho, Dist2, [Origem | Visitados]),
    Dist is Dist1 + Dist2.                                                                  % somar as distancias




todosExcAtiNoct(Origem,Destino):-
    findall((S,Dist,Car),percursoExccarAtiNoct(Origem,Destino,S,Dist),L),
    escrever(L).      % print listas



%----------------------------------QUERIE 4-----------------------------------------
% identificar a cidade dum trajeto com o maior numerode ligaçoes.

maiorNrConecoes([Origem|Caminho],L) :-
    maiorNrConecoesAux(Origem,Caminho,[],[]).


maiorNrConecoesAux(C,[],[],L):-
    nrConecoes(C,A),
    append([A],L,L1),
    max_in_list(L1,R),
    write(R).


maiorNrConecoesAux(Origem,[Prox|Caminho],Visitados,L):-
    adjacente(Origem,Prox,_),
    nao(member(Prox,Visitados)),
    nrConecoes(Origem,R),
    maiorNrConecoesAux(Prox,Caminho,[Origem|Visitados],L1),
    append([R],L1,L).




nrConecoes(Id,L) :-
	findall(X,adjacente(Id,_,_),Z),
	length(Z,L).




max_in_list([Max],Max).                

max_in_list([H,K|T],M) :-
    H =< K,                           
    min_in_list([K|T],M).               

max_in_list([H,K|T],M) :-
    H > K,                             
    min_in_list([H|T],M).           


min_in_list([(P,Min)],(P,Min)).                 % We've found the minimum

min_in_list([(A,H),(B,K)|T],(C,M)) :-
    H =< K,                             % H is less than or equal to K
    min_in_list([(A,H)|T],(C,M)).               % so use H

min_in_list([(A,H),(B,K)|T],(C,M)) :-
    H > K,                              % H is greater than K
    min_in_list([(B,K)|T],(C,M)).               % so use K

%----------------------------------QUERIE 5-----------------------------------------
% Escolher o menor percurso (critério de menor numero de cidades).



menorPercursoCidades(Origem,Destino):-
    findall((P,Dist,T),percurso2(Origem,Destino,Dist,P,T),L),
    min_in_list2(L,R),
    write(R).


percurso2(Origem,Destino,Dist,[Origem|Percurso],T) :-
	percursoAux2(Origem,Destino,Percurso,Dist,[],T).

percursoAux2(Destino,Destino,[],0,_,0).
percursoAux2(Origem,Destino,[Proximo|Percurso],Dist,Visitados,T) :-
	Origem \= Destino,
	arco(Origem,Proximo,Dist1),
	\+member(Proximo,Visitados),
	percursoAux2(Proximo,Destino,Percurso,Dist2,[Origem|Visitados],T1),
    T is T1+1,
	Dist is Dist1 + Dist2.

min_in_list2([(P,D,Min)],(P,D,Min)).                

min_in_list2([(A,D,H),(B,E,K)|T],(C,F,M)) :-
    H =< K,                            
    min_in_list2([(A,D,H)|T],(C,F,M)).              

min_in_list2([(A,D,H),(B,E,K)|T],(C,F,M)) :-
    H > K,                             
    min_in_list2([(B,E,K)|T],(C,F,M)).      

%exemplo menorPercursoCidades(3,10).

%----------------------------------QUERIE 6-----------------------------------------
% Escolher o menor percurso (critério da distancia).

maisPercursoDistancia(O,D) :- findall((P,Dist),caminhos(O,D,Dist,P),L),
	              min_in_list(L,R),
                  write(R).


min_in_list([(P,Min)],(P,Min)).                

min_in_list([(A,H),(B,K)|T],(C,M)) :-
    H =< K,                             
    min_in_list([(A,H)|T],(C,M)).               

min_in_list([(A,H),(B,K)|T],(C,M)) :-
    H > K,                            
    min_in_list([(B,K)|T],(C,M)).            


%----------------------------------QUERIE 7-----------------------------------------
% Percurso que passa so por cidades admin.

todosAdmin(Origem,Destino) :-
	findall((P,Dist),municipio(Origem,Destino,P,Dist,'admin'),L),
	escrever(L). 

municipio(Origem,Destino,[Origem|Caminho],Dist,'admin') :-
	municipioAux(Origem,Destino,Caminho,Dist,'admin',[]).

municipioAux(Destino,Destino,[],0,_,_).
municipioAux(Origem,Destino,[Proximo|Caminho],Dist,'admin',Visitados) :-
	Origem \= Destino,
	adjacente(Origem,Proximo,Dist1),
	cidade(Proximo,_,_,_,_,'admin'),
	nao(member(Proximo,Visitados)),
	municipioAux(Proximo,Destino,Caminho,Dist2,'admin',[Origem|Visitados]),
	Dist is (Dist1 + Dist2).



%----------------- Query 8 ---------------------------------%
% Percurso com cidades intermediarias.



percursoPor(Origem,Destino,Intermedios) :-
	findall((P,Dist),percurso(Origem,Destino,P,Dist),L),
	testa(L,Intermedios,R),
    escrever(R).

%Filtra os Percursos que cumprem com o itenerario

testa([(X,D)|T],L,R) :- 
testa(T,L,K), 
temTodos(L,X), append([(X,D)],K,R).  

%verifica se uma lista tem elementos de outra
temTodos([],_).
temTodos([H|T],L) :- member(H,L),temTodos(T,L).

%exemplo percursoPor(2,10,[32]).
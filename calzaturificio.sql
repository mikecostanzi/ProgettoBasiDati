create database calzaturificio;

use calzaturificio;

/* CREAZIONE DELLE TABELLE COI RELATIVI ATTRIBUTI */

create table Persona(
Codice_pers varchar(16) not null,
via varchar(40) not null,
n_civico varchar(5) not null,
citta varchar(20) not null,
cap char(5) not null,
nome varchar(40) not null,
telefono char(10) not null,
email varchar(40) not null,
primary key (Codice_pers)
);

create table Cliente(
P_iva_cliente char(11) not null references Persona(Codice_pers),
primary key (P_iva_cliente)
);
create table Dipendente(
Codice_dip char(16) not null references Persona(Codice_pers),
cognome varchar(40) not null,
ruolo varchar(3) not null,
check(ruolo="ia" or ruolo="ip" or ruolo="ocq" or ruolo="os" or ruolo="oc" or ruolo="a"),
primary key(Codice_dip)
);

create table Fornitore(
Codice_forn char(11) not null references Persona(Codice_pers),
primary key(Codice_forn)
);

create table Tipologia(
Tipo_forn varchar(2) not null,
check(Tipo_forn="m" or Tipo_forn="s" or Tipo_forn="ms" or Tipo_forn="t"),
primary key(Tipo_forn)
);

create table Rifornimento(
Codice_fornitore char(11) not null references Fornitore(Codice_forn),
Tipo_fornitore varchar(2) not null references Tipologia(Tipo_forn),
primary key(Codice_fornitore, Tipo_fornitore)
);

create table Contratto(
Codice_cont int not null auto_increment,
data date not null,
primary key(Codice_cont)
);

create table ContrattoAcquisto(
Codice_acqu int not null references Contratto(Codice_cont),
importo numeric(7,2),
check(importo > 0),
Fornitore char(11),
primary key(Codice_acqu),
foreign key(Fornitore) references Fornitore(Codice_forn)
);

create table ContrattoVendita(
Codice_ven int not null references Contratto(Codice_cont),
prezzo numeric(7,2),
check(prezzo > 0),
Cliente char(11),
primary key(Codice_ven),
foreign key(Cliente) references Cliente(P_iva_cliente)
);

create table ContrattoLavoro(
Codice_lav int not null references Contratto(Codice_cont),
stipendio numeric(7,2) not null,
check(stipendio > 0),
durata varchar(13) not null,
check(durata = "indeterminato" or durata = "3mesi" or durata = "6mesi" or durata = "12mesi" or durata = "24mesi"),
Dipendente char(16) not null,
primary key(Codice_lav),
foreign key(Dipendente) references Dipendente(Codice_dip)
);

create table Materiale(
Codice_mat int not null,
settore tinyint not null,
check(settore > 0 and settore < 4),
scaffale char not null,
ripiano tinyint not null,
check(ripiano > 0 and ripiano < 21),
altre_spec varchar(40) not null,
colore varchar(40) not null,
prezzo numeric(5,2) not null,
check(prezzo > 0),
tipologia varchar(20) not null,
check (tipologia = "materiaprima" or tipologia="prodottofinito" or tipologia="semilavorato"),
quantita int not null,
check(quantita >= 0),
primary key(Codice_mat)
);

create table MateriaPrima(
Codice_mat_prim int not null references Materiale(Codice_mat),
categoria varchar(8) not null,
check(categoria = "polimero" or categoria = "vernice"),
elasticita tinyint not null,
check(elasticita > 0 and elasticita < 100),
durezza tinyint not null,
check(durezza > 0 and durezza < 100),
primary key(Codice_mat_prim)
);

create table ProdottoFinito(
Codice_prod_fin int not null references Materiale(Codice_mat),
imballaggio varchar(9) not null,
check(imballaggio = "primario" or imballaggio = "terziario"),
primary key(Codice_prod_fin)
);
create table Semilavorato(
Codice_semi int not null references Materiale(Codice_mat),
primary key(Codice_semi)
);

create table catal_vendita(
ContrVendita int not null references ContrattoVendita(Codice_ven),
materiale int not null references Materiale(Codice_mat),
prezzo numeric(5,2) not null,
quantita int not null,
primary key(ContrVendita, materiale)
);

create table catal_semilavorato(
ContrAcquisto int not null references ContrattoAcquisto(Codice_acqu),
materiale int not null references Semilavorato(Codice_semi),
prezzo numeric(5,2) not null,
quantita int not null,
primary key(ContrAcquisto, materiale)
);

create table catal_materiaprima(
ContrAcquisto int not null references ContrattoAcquisto(Codice_acqu),
materiale int not null references MateriaPrima(Codice_mat_prim),
prezzo numeric(5,2) not null,
quantita int not null,
primary key(ContrAcquisto, materiale)
);

/* FINE CREAZIONE TABELLE
   
   INIZIO INSERIMENTO DATI
*/


insert into  Cliente(P_iva_cliente)
values  ('39571973287'),
        ('56482598467');

insert into Contratto(Codice_cont, data)
values  (1, '2022-09-15'),
        (2, '2022-01-27'),
        (3, '2016-01-15'),
        (4, '2018-01-12'),
        (13, '2020-01-16'),
        (14, '2021-01-14');

insert into  ContrattoAcquisto(Codice_acqu, importo, Fornitore)
values  (1, 2216.00, '21678469315'),
        (2, 1500.00, '63189567432');


insert into ContrattoLavoro(Codice_lav, stipendio, durata, Dipendente)
values  (3, 1600.00, '3mesi', 'LVLBCR45P23L605N'),
        (4, 1451.00, 'indeterminato', 'FZJVHY58S05L319Z');

insert into ContrattoVendita(Codice_ven, prezzo, Cliente)
values  (13, 1263.00, '56482598467'),
        (14, 2634.00, '39571973287');

insert into  Dipendente(Codice_dip, cognome, ruolo)
values  ('FZJVHY58S05L319Z', 'Di Blasio', 'ocq'),
        ('LVLBCR45P23L605N', 'Di Sasso', 'oc');

insert into Fornitore(Codice_forn)
values  ('21678469315'),
        ('63189567432');

insert into Materiale(Codice_mat, settore, scaffale, ripiano, altre_spec, colore, prezzo, tipologia, quantita)
values  (101, 1, 'A', 20, 'brillantini', 'viola', 30.00, 'semilavorato', 10),
        (102, 2, 'B', 15, 'vernice ', 'verde', 10.00, 'materiaprima', 3),
        (103, 2, 'C', 10, 'tacco ', 'rosso', 15.00, 'semilavorato', 6),
        (104, 3, 'D', 7, 'suola gommata', 'blu', 45.00, 'prodottofinito', 20),
        (105, 1, 'F', 5, 'suola gommata', 'nera', 27.00, 'prodottofinito', 8),
        (106, 3, 'R', 10, 'polimero semirigido', 'blu scuro', 12.00, 'materiaprima', 17);

insert into MateriaPrima(Codice_mat_prim, categoria, elasticita, durezza)
values  (102, 'vernice', 50, 4),
        (106, 'polimero', 10, 2);

insert into Persona(Codice_pers, via, n_civico, citta, cap, nome, telefono, email)
values  ('21678469315', 'Viale Svezia', '9', 'Padova', '55012', 'Salmaso Grup', '0498308250', 'fornitore01@gmail.com'),
        ('39571973287', 'Via Felice Orsini', '9', 'Pesaro', '61122', 'Alessandro', '3258265849', 'cliente02@gmail.com'),
        ('56482598467', 'Via Ranieri', '126/A', 'Ancona', '56022', 'Massimo', '4365494524', 'cliente01@gmail.com'),
        ('63189567432', 'Via Provinciale Francesca', '126', 'Santa Maria Monte', '56022', 'Tomaificio Nuova Cabor', '0587706432', 'fornitore02@gmail.com'),
        ('FZJVHY58S05L319Z', 'Via Alborato', '84/C', 'Vasto', '66054', 'Mario', '5307662481', 'dipendente01@gmail.com'),
        ('LVLBCR45P23L605N', 'Via del Martello', '8', 'Pisa', '56121', 'Giacomo', '5154624586', 'dipendente02@gmail.com');

insert into ProdottoFinito(Codice_prod_fin, imballaggio)
values  (104, 'primario'),
        (105, 'terziario');

insert into Rifornimento(Codice_fornitore, Tipo_fornitore)
values  ('21678469315', 'm'),
        ('63189567432', 'ms');

insert into Semilavorato(Codice_semi)
values  (101),
        (103);

insert into Tipologia(Tipo_forn)
values  ('m'),
        ('ms');

/* FINE INSERIMENTO DATI */
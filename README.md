> **Come leggere questa guida:** per visualizzare correttamente il contenuto di questo file, nell'Explorer di VS Code fai **tasto destro** su `README.md` e scegli **"Open Preview"**.

# Lezione Bash03 - Comandi filtro

## Obiettivo

In questa lezione imparerai a **cercare file** nel filesystem, a descrivere **pattern di testo** con le espressioni regolari, e a usare strumenti potenti come **grep**, **sed** e **awk** per filtrare, trasformare e riformattare dati dalla riga di comando. Alla fine sarai in grado di combinare questi strumenti per analizzare log, correggere testi e estrarre informazioni da file strutturati.

---

## ⚠️ Prima di iniziare: crea l'ambiente

Apri il terminale e lancia lo script di setup per creare i file e le cartelle necessarie agli esercizi:

```bash
cd /workspaces/Lezione_Bash03
bash setup.sh
```

Se durante gli esercizi combini qualche guaio e vuoi ricominciare, puoi rilanciare lo script in qualsiasi momento: cancellerà tutto e ricreerà l'ambiente da zero.

---

## Blocco 1 - Cercare file con `find`

### Obiettivo

Trovare file e directory nel filesystem in base al nome, al tipo, e eseguire comandi sui risultati.

### Ingredienti

| Comando / Opzione | Descrizione |
|---|---|
| `find <percorso>` | Cerca ricorsivamente a partire da `<percorso>` |
| `-name "pattern"` | Filtra per nome (supporta wildcards `*`, `?`, `[...]`) |
| `-type f` | Cerca solo file regolari |
| `-type d` | Cerca solo directory |
| `-exec <cmd> {} \;` | Esegue `<cmd>` su ogni risultato trovato |

### Come combinarli

`find` esplora un albero di directory e restituisce tutto ciò che corrisponde ai criteri. A differenza di `ls`, **cerca ricorsivamente** in tutte le sotto-directory.

```bash
# Trova tutti i file .java nel progetto
find esercizi/progetto -name "*.java"

# Trova solo le directory dentro progetto
find esercizi/progetto -type d

# Trova tutti i file .cfg (configurazione)
find esercizi/progetto -name "*.cfg"
```

L'opzione `-name` è **case-sensitive**: `"*.java"` non trova `App.JAVA`. Per ignorare maiuscole/minuscole, usa `-iname`:

```bash
find esercizi/progetto -iname "*.java"
```

> ⚠️ **Importante:** il pattern di `-name` va sempre tra virgolette `" "`, altrimenti la shell espande le wildcards prima che `find` possa usarle.

#### Eseguire comandi sui risultati con `-exec`

`-exec` è molto potente: esegue un comando su ogni file trovato. Il simbolo `{}` viene sostituito con il percorso del file, e `\;` chiude il comando:

```bash
# Trova tutti i file .java e mostra le prime 3 righe di ciascuno
find esercizi/progetto -name "*.java" -exec head -n 3 {} \;

# Trova tutti i file .cfg e conta le righe di ciascuno
find esercizi/progetto -name "*.cfg" -exec wc -l {} \;
```

### Esercizio 1.1

1. Trova tutti i file `.java` dentro `esercizi/progetto`
2. Trova tutte le directory dentro `esercizi/progetto`
3. Trova tutti i file il cui nome contiene la parola `config` (in qualunque cartella sotto `esercizi`)
4. Trova tutti i file `.java` e per ciascuno mostra il nome del file (`-exec echo {} \;` come verifica)

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Tutti i file .java
find esercizi/progetto -name "*.java"
# Output:
# esercizi/progetto/src/main/App.java
# esercizi/progetto/src/main/Server.java
# esercizi/progetto/src/test/TestApp.java
# esercizi/progetto/src/utils/Logger.java
# esercizi/progetto/src/utils/Config.java

# 2. Tutte le directory
find esercizi/progetto -type d
# Output:
# esercizi/progetto
# esercizi/progetto/src
# esercizi/progetto/src/main
# esercizi/progetto/src/test
# esercizi/progetto/src/utils
# esercizi/progetto/config
# esercizi/progetto/docs
# esercizi/progetto/build
# esercizi/progetto/assets
# esercizi/progetto/assets/img
# esercizi/progetto/assets/css

# 3. File con "config" nel nome (case-insensitive per trovare anche Config.java)
find esercizi -iname "*config*"
# Output:
# esercizi/progetto/config
# esercizi/progetto/src/utils/Config.java

# 4. Mostrare i percorsi dei file .java
find esercizi/progetto -name "*.java" -exec echo {} \;
# (stesso output del punto 1)
```

</details>

---

## Blocco 2 - Espressioni regolari

### Obiettivo

Imparare la sintassi delle espressioni regolari (regex), un linguaggio per descrivere **pattern di testo**.

### Ingredienti

| Simbolo | Significato | Esempio | Cosa matcha |
|---|---|---|---|
| `.` | Un carattere qualsiasi | `c.sa` | `casa`, `cosa`, `c3sa` |
| `*` | Zero o più ripetizioni del precedente | `ab*c` | `ac`, `abc`, `abbc`, `abbbc` |
| `+` | Una o più ripetizioni del precedente | `ab+c` | `abc`, `abbc` (non `ac`) |
| `?` | Zero o una ripetizione del precedente | `colou?r` | `color`, `colour` |
| `[...]` | Uno dei caratteri elencati | `[aeiou]` | una vocale |
| `[^...]` | Qualsiasi carattere **tranne** quelli elencati | `[^0-9]` | un non-digit |
| `^` | Inizio della riga | `^Errore` | righe che iniziano con "Errore" |
| `$` | Fine della riga | `\.txt$` | righe che finiscono con ".txt" |
| `\d` | Una cifra (equivale a `[0-9]`) | `\d{3}` | tre cifre |
| `\w` | Un carattere "parola" (lettera, cifra, `_`) | `\w+` | una o più lettere/cifre |
| `{n}` | Esattamente n ripetizioni | `[0-9]{4}` | quattro cifre |
| `{n,m}` | Da n a m ripetizioni | `[0-9]{2,4}` | da due a quattro cifre |
| `(...)` | Gruppo (per raggruppare sotto-pattern) | `(ab)+` | `ab`, `abab`, `ababab` |
| `\|` | Alternativa (OR) | `gatto\|cane` | `gatto` oppure `cane` |

### Come combinarli

Le espressioni regolari sono un **linguaggio trasversale**: si usano in `grep`, `sed`, `awk`, e in tutti i linguaggi di programmazione (Python, Java, JavaScript...). Imparare la sintassi base una volta sola serve ovunque.

**Differenza importante rispetto alle wildcards della shell:**

| | Wildcards (shell) | Regex |
|---|---|---|
| `*` | "qualsiasi sequenza di caratteri" | "zero o più ripetizioni del carattere precedente" |
| `?` | "esattamente un carattere" | "zero o una ripetizione del precedente" |
| Dove si usano | `ls`, `cp`, `mv`, `find -name` | `grep`, `sed`, `awk`, linguaggi |

Non confonderle! Quando usi `find -name "*.txt"`, il `*` è una wildcard. Quando usi `grep "^[0-9].*txt$"`, il `.*` è una regex (`.` = qualsiasi carattere, `*` = ripetuto zero o più volte).

**Esempi di pattern:**

```
^[A-Z]              → righe che iniziano con una lettera maiuscola
[0-9]{1,3}\.[0-9]   → un numero da 1 a 3 cifre, punto, una cifra (es: "192.1", "7.5")
^$                   → righe vuote (inizio riga subito seguito da fine riga)
[a-z]+@[a-z]+\.[a-z] → pattern base di un indirizzo email
```

> ⚠️ **Nota:** il punto `.` nelle regex significa "qualsiasi carattere". Se vuoi cercare un punto letterale, devi "escaparlo" con il backslash: `\.`

### Esercizio 2.1

Questo è un esercizio teorico. Per ciascun pattern, scrivi cosa matcherebbe:

1. `^#` → righe che iniziano con...?
2. `[0-9]+` → che tipo di testo cattura?
3. `\.java$` → righe che finiscono con...?
4. `^$` → che tipo di righe?
5. `[A-Z][a-z]+` → che tipo di parole?

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

1. `^#` → righe che iniziano con il carattere `#` (tipicamente commenti)
2. `[0-9]+` → una o più cifre consecutive (un numero)
3. `\.java$` → righe che finiscono con `.java` (il `\.` matcha il punto letterale)
4. `^$` → righe vuote (nessun carattere tra inizio e fine riga)
5. `[A-Z][a-z]+` → parole che iniziano con una maiuscola seguita da una o più minuscole (es: `Mario`, `Roma`)

</details>

---

## Blocco 3 - `grep` con espressioni regolari

### Obiettivo

Potenziare il comando `grep` (già visto nella Lezione Bash02) con le espressioni regolari e le opzioni avanzate, e combinarlo con `find` in pipeline.

### Ingredienti

| Comando / Opzione | Descrizione |
|---|---|
| `grep "pattern" <file>` | Cerca righe che contengono il pattern |
| `grep -E "pattern"` | Abilita le **Extended Regex** (per usare `+`, `?`, `\|`, `{}`) |
| `grep -i "pattern"` | Ignora maiuscole/minuscole |
| `grep -c "pattern"` | Conta il numero di righe che matchano |
| `grep -v "pattern"` | Mostra le righe che **NON** matchano (inverti) |
| `grep -r "pattern" <dir>` | Cerca ricorsivamente in tutti i file di una directory |
| `grep -n "pattern"` | Mostra il numero di riga accanto a ogni risultato |

### Come combinarli

Nella Lezione Bash02 abbiamo usato `grep` con testo semplice. Ora possiamo cercare **pattern complessi** con le regex.

```bash
# Cerca righe che contengono un indirizzo IP (pattern semplificato)
grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" esercizi/log/server.log

# Cerca tutte le righe di tipo ERROR o WARN
grep -E "ERROR|WARN" esercizi/log/server.log

# Cerca righe che iniziano con una data (4 cifre seguite da un trattino)
grep -E "^[0-9]{4}-" esercizi/log/server.log

# Cerca email in un file (pattern semplificato)
grep -E "[a-z._]+@[a-z]+\.[a-z]+" esercizi/dati/contatti.txt
```

**Combinare opzioni:**

```bash
# Conta quante righe di errore ci sono nel log
grep -c "ERROR" esercizi/log/server.log

# Mostra tutte le righe che NON sono INFO (cioè WARN e ERROR)
grep -v "INFO" esercizi/log/server.log

# Cerca "TODO" in tutto il progetto, con numero di riga
grep -rn "TODO" esercizi/progetto/
```

#### Combo: `find` + `grep` in pipeline

Puoi combinare `find` e `grep` per cercare testo solo in certi tipi di file:

```bash
# Trova tutti i file .java e cerca "TODO" in ciascuno
find esercizi/progetto -name "*.java" -exec grep -n "TODO" {} \;

# Stessa cosa ma mostrando anche il nome del file
find esercizi/progetto -name "*.java" -exec grep -l "TODO" {} \;
```

L'opzione `-l` di grep mostra solo i **nomi dei file** che contengono il pattern, senza le righe.

Un altro modo è usare `find` con la pipeline e `xargs` (se lo conosci), ma `-exec` è già sufficiente per i nostri scopi.

**Confronto tra approcci:**

| Cosa vuoi fare | Comando |
|---|---|
| Cercare testo in **tutti** i file di una directory | `grep -r "pattern" directory/` |
| Cercare testo solo in file di un **certo tipo** | `find dir -name "*.ext" -exec grep "pattern" {} \;` |
| Trovare **quali file** contengono un certo testo | `grep -rl "pattern" directory/` |

### Esercizio 3.1

1. Cerca tutte le righe che contengono `ERROR` nel file `esercizi/log/server.log`
2. Cerca tutte le righe di tipo `ERROR` **oppure** `WARN` (usa `-E` e `|`)
3. Conta quanti `WARN` ci sono nel log del server
4. Mostra solo le righe che **non** sono `INFO` nel log del server
5. Cerca ricorsivamente la parola `TODO` in tutto il progetto, mostrando il numero di riga

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Righe con ERROR
grep "ERROR" esercizi/log/server.log
# Output:
# 2024-01-15 08:10:32 ERROR [auth] Account admin bloccato dopo 2 tentativi falliti
# 2024-01-15 08:30:00 ERROR [db] Timeout connessione al database dopo 30s
# 2024-01-15 08:55:30 ERROR [http] GET /api/orders 500 2005ms
# 2024-01-15 09:15:03 ERROR [auth] Account root bloccato dopo 3 tentativi falliti

# 2. ERROR oppure WARN
grep -E "ERROR|WARN" esercizi/log/server.log
# Output: tutte le righe ERROR e WARN (4 ERROR + 7 WARN = 11 righe)

# 3. Contare i WARN
grep -c "WARN" esercizi/log/server.log
# Output: 7

# 4. Righe che NON sono INFO
grep -v "INFO" esercizi/log/server.log
# Output: tutte le righe ERROR e WARN

# 5. TODO in tutto il progetto con numero di riga
grep -rn "TODO" esercizi/progetto/
# Output:
# esercizi/progetto/assets/css/style.css:20:/* TODO: aggiungere stile responsive */
# esercizi/progetto/src/test/TestApp.java:7:        // TODO: scrivere test per avvio applicazione
# esercizi/progetto/src/test/TestApp.java:12:        // TODO: verificare caricamento configurazione
# esercizi/progetto/src/main/App.java:13:        // TODO: implementare menu principale
# esercizi/progetto/src/main/Server.java:8:    // TODO: aggiungere gestione connessioni multiple
# esercizi/progetto/src/main/Server.java:13:        // TODO: implementare protocollo HTTP
# esercizi/progetto/src/utils/Config.java:7:    // TODO: implementare parsing del file di configurazione
# esercizi/progetto/src/utils/Logger.java:22:        // TODO: implementare scrittura su file
```

</details>

---

### Esercizio 3.2

1. Cerca tutti gli indirizzi email nel file `esercizi/dati/contatti.txt` usando una regex
2. Cerca nel log degli accessi (`accessi.log`) tutte le richieste con codice di risposta `401`
3. Trova **quali file** `.java` contengono la parola `import` (usa `find` + `grep -l`)

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Cercare email (pattern semplificato)
grep -E "[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+" esercizi/dati/contatti.txt
# Output:
#   Email: mario.rossi@gmail.com
#   Email: l.bianchi@outlook.it
#   Email: p.verdi@yahoo.com
#   Email: anna_neri@libero.it
#   Email: supporto@azienda.it
#   Email: segreteria@scuola.edu.it

# 2. Richieste con codice 401
grep "401" esercizi/log/accessi.log
# Output:
# 192.168.1.50 - admin [15/Jan/2024:08:10:30] "POST /login" 401 128
# 192.168.1.50 - admin [15/Jan/2024:08:10:31] "POST /login" 401 128
# 10.0.0.5 - guest [15/Jan/2024:08:45:00] "POST /login" 401 128
# 203.0.113.42 - root [15/Jan/2024:09:15:00] "POST /login" 401 128
# 203.0.113.42 - root [15/Jan/2024:09:15:01] "POST /login" 401 128
# 203.0.113.42 - root [15/Jan/2024:09:15:02] "POST /login" 401 128

# 3. Quali file .java contengono "import"
find esercizi/progetto -name "*.java" -exec grep -l "import" {} \;
# Output:
# esercizi/progetto/src/main/App.java
# esercizi/progetto/src/main/Server.java
# esercizi/progetto/src/test/TestApp.java
# esercizi/progetto/src/utils/Logger.java
# esercizi/progetto/src/utils/Config.java
```

</details>

---

## Blocco 4 - `sed`: cercare e sostituire nel testo

### Obiettivo

Usare `sed` per sostituire testo nei file, con stringhe semplici e con espressioni regolari.

### Ingredienti

| Comando / Opzione | Descrizione |
|---|---|
| `sed 's/vecchio/nuovo/' <file>` | Sostituisce la **prima** occorrenza per riga |
| `sed 's/vecchio/nuovo/g' <file>` | Sostituisce **tutte** le occorrenze per riga |
| `sed -i 's/vecchio/nuovo/g' <file>` | Modifica il file **direttamente** (in-place) |
| `sed -E 's/regex/nuovo/g' <file>` | Usa le Extended Regex nella ricerca |
| `sed '/pattern/d' <file>` | Cancella le righe che matchano il pattern |

### Come combinarli

`sed` (**s**tream **ed**itor) legge un file riga per riga, applica le trasformazioni e stampa il risultato. Senza `-i`, non modifica il file originale — stampa solo il risultato a schermo:

```bash
# Sostituisce "1.0.3" con "2.0.0" (solo output, il file non cambia)
sed 's/1.0.3/2.0.0/g' esercizi/progetto/config/app.cfg

# Per modificare davvero il file, aggiungi -i
sed -i 's/1.0.3/2.0.0/g' esercizi/progetto/config/app.cfg
```

> ⚠️ **Attenzione:** con `-i` le modifiche sono irreversibili! Prova sempre prima senza `-i` per vedere l'effetto. Se combini un guaio, rilancia `bash setup.sh`.

**Sostituzioni con regex:**

```bash
# Rimuovi tutti i commenti (righe che iniziano con #) da un file di config
sed '/^#/d' esercizi/progetto/config/app.cfg

# Rimuovi righe vuote
sed '/^$/d' esercizi/dati/contatti.txt

# Sostituisci tutti gli indirizzi IP con "XXX.XXX.XXX.XXX" (anonimizzazione)
sed -E 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/XXX.XXX.XXX.XXX/g' esercizi/log/accessi.log
```

**Combinare più sostituzioni:**

```bash
# Puoi concatenare più operazioni con -e
sed -e 's/vecchio1/nuovo1/g' -e 's/vecchio2/nuovo2/g' file.txt
```

### Esercizio 4.1

Il file `esercizi/dati/testo_da_correggere.txt` contiene diversi errori di battitura. Correggili con `sed`:

1. Prima leggi il file con `cat` per individuare gli errori
2. Correggi "scoula" in "scuola"
3. Correggi "qeusto" in "questo"
4. Correggi "opertivi" in "operativi"
5. Correggi "calcolaotri" in "calcolatori"
6. Correggi "Pyhton" in "Python"
7. Correggi "pò" in "po'" (con l'apostrofo)
8. Correggi "stuenti" in "studenti"
9. Verifica il risultato finale

> **Suggerimento:** usa prima senza `-i` per controllare, poi applica tutte le correzioni con `-i`.

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# Prima controlliamo il file
cat esercizi/dati/testo_da_correggere.txt

# Applichiamo tutte le correzioni in un colpo solo
sed -i \
  -e 's/scoula/scuola/g' \
  -e 's/qeusto/questo/g' \
  -e 's/opertivi/operativi/g' \
  -e 's/calcolaotri/calcolatori/g' \
  -e 's/Pyhton/Python/g' \
  -e 's/pò/po'"'"'/g' \
  -e 's/stuenti/studenti/g' \
  esercizi/dati/testo_da_correggere.txt

# Verifica
cat esercizi/dati/testo_da_correggere.txt
```

**Nota:** la sostituzione di "pò" con "po'" richiede attenzione alle virgolette. Un'alternativa è usare virgolette doppie: `sed -i "s/pò/po'/g" file.txt`

</details>

---

### Esercizio 4.2

1. Aggiorna la versione dell'applicazione da `1.0.3` a `2.0.0` in **tutti** i file del progetto che la contengono (prima trova quali file con `grep -r`, poi usa `sed -i` con `find -exec`)
2. Nel file `accessi.log`, sostituisci la vecchia email del docente `prof@vecchiamail.it` con `prof@nuovamail.it` nel file `testo_da_correggere.txt`

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Prima vediamo quali file contengono "1.0.3"
grep -r "1.0.3" esercizi/progetto/
# Output: App.java, deploy.sh, config/app.cfg, docs/README.md, index.html

# Ora sostituiamo in tutti quei file
find esercizi/progetto -type f -exec sed -i 's/1.0.3/2.0.0/g' {} \;

# Verifica
grep -r "2.0.0" esercizi/progetto/

# 2. Sostituire l'email del docente
sed -i 's/prof@vecchiamail.it/prof@nuovamail.it/g' esercizi/dati/testo_da_correggere.txt

# Verifica
grep "prof@" esercizi/dati/testo_da_correggere.txt
# Output: Per contattare il docente scrivere a prof@nuovamail.it
```

</details>

---

## Blocco 5 - `awk`: estrarre e riformattare dati

### Obiettivo

Usare `awk` per selezionare campi da file strutturati, filtrare righe con condizioni e riformattare l'output.

### Ingredienti

| Comando / Opzione | Descrizione |
|---|---|
| `awk '{print $1}' <file>` | Stampa il **primo campo** di ogni riga |
| `awk '{print $1, $3}' <file>` | Stampa il primo e il terzo campo |
| `awk -F',' '{print $2}' <file>` | Usa `,` come separatore di campo |
| `awk '$3 > 7' <file>` | Mostra solo le righe dove il terzo campo è > 7 |
| `awk '{print $NF}' <file>` | Stampa l'**ultimo** campo |
| `NR` | Numero della riga corrente |
| `NF` | Numero di campi nella riga corrente |

### Come combinarli

`awk` tratta ogni riga come un **record** diviso in **campi**. Per default, il separatore è lo spazio (o tabulazione). Puoi cambiarlo con `-F`.

```bash
# Il file studenti.csv usa la virgola come separatore
# Stampa solo cognome e media (campi 2 e 5)
awk -F',' '{print $2, $5}' esercizi/dati/studenti.csv
```

**Nota:** la prima riga di un CSV è l'intestazione. Per saltarla puoi usare `NR > 1`:

```bash
# Stampa cognome e media, saltando l'intestazione
awk -F',' 'NR > 1 {print $2, $5}' esercizi/dati/studenti.csv
```

**Filtrare con condizioni:**

```bash
# Studenti con media superiore a 8
awk -F',' '$5 > 8' esercizi/dati/studenti.csv

# Studenti della classe 4A
awk -F',' '$4 == "4A"' esercizi/dati/studenti.csv
```

**Riformattare l'output:**

```bash
# Formattare come "COGNOME Nome - media: X"
awk -F',' 'NR > 1 {print toupper($2), $3, "- media:", $5}' esercizi/dati/studenti.csv
```

**Separatori diversi:**

Il file `dipendenti.csv` usa il punto e virgola `;` come separatore:

```bash
# Stampa nome, cognome e stipendio dei dipendenti
awk -F';' 'NR > 1 {print $3, $2, "-", $5, "€"}' esercizi/dati/dipendenti.csv
```

**awk nei log:**

Nei file di log separati da spazi, ogni "parola" è un campo:

```bash
# Dal log del server, estrai solo orario e livello (campi 2 e 3)
awk '{print $2, $3}' esercizi/log/server.log

# Mostra solo le righe di errore con orario
awk '$3 == "ERROR" {print $2, $0}' esercizi/log/server.log
```

**awk al posto di cut:**

`awk` può fare tutto ciò che fa il comando `cut`, ma con più flessibilità:

```bash
# Questi due comandi producono lo stesso risultato:
cut -d',' -f2 esercizi/dati/studenti.csv
awk -F',' '{print $2}' esercizi/dati/studenti.csv

# Ma awk può anche riformattare, filtrare, calcolare...
```

### Esercizio 5.1

Lavora sul file `esercizi/dati/studenti.csv`:

1. Stampa solo i nomi e cognomi di tutti gli studenti (senza intestazione)
2. Mostra solo gli studenti con media maggiore o uguale a 8
3. Mostra gli studenti della classe `4B` nel formato: `COGNOME - media`

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Nomi e cognomi (campi 3 e 2, saltando l'header)
awk -F',' 'NR > 1 {print $3, $2}' esercizi/dati/studenti.csv
# Output:
# Mario Rossi
# Laura Bianchi
# Paolo Verdi
# Anna Neri
# Luca Ferrari
# Sara Romano
# Marco Colombo
# Giulia Ricci
# Andrea Marino
# Elena Greco

# 2. Studenti con media >= 8 (saltando l'header)
awk -F',' 'NR > 1 && $5 >= 8' esercizi/dati/studenti.csv
# Output:
# 1002,Bianchi,Laura,4A,8.2,laura.bianchi@studenti.edu
# 1004,Neri,Anna,4B,9.1,anna.neri@studenti.edu
# 1007,Colombo,Marco,4A,8.5,marco.colombo@studenti.edu
# 1010,Greco,Elena,4B,8.9,elena.greco@studenti.edu

# 3. Studenti 4B formattati
awk -F',' '$4 == "4B" {print $2, "- media:", $5}' esercizi/dati/studenti.csv
# Output:
# Verdi - media: 6.8
# Neri - media: 9.1
# Romano - media: 7.0
# Ricci - media: 6.3
# Greco - media: 8.9
```

</details>

---

### Esercizio 5.2

Lavora sul file `esercizi/dati/dipendenti.csv` (separatore `;`):

1. Stampa la lista dei dipendenti nel formato: `Nome Cognome (Reparto)`
2. Mostra solo i dipendenti del reparto `Sviluppo` con il loro stipendio
3. Mostra i dipendenti con stipendio superiore a 30000

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Nome Cognome (Reparto)
awk -F';' 'NR > 1 {print $3, $2, "(" $4 ")"}' esercizi/dati/dipendenti.csv
# Output:
# Marco Bianchi (Sviluppo)
# Anna Rossi (Marketing)
# Luca Verdi (Sviluppo)
# Sara Neri (Amministrazione)
# Paolo Ferrari (Sviluppo)
# Elena Romano (Marketing)
# Andrea Colombo (Amministrazione)
# Giulia Ricci (Sviluppo)
# Francesco Marino (Marketing)
# Chiara Greco (Amministrazione)

# 2. Dipendenti Sviluppo con stipendio
awk -F';' '$4 == "Sviluppo" {print $3, $2, "-", $5, "€"}' esercizi/dati/dipendenti.csv
# Output:
# Marco Bianchi - 32000 €
# Luca Verdi - 35000 €
# Paolo Ferrari - 38000 €
# Giulia Ricci - 33000 €

# 3. Stipendio > 30000
awk -F';' 'NR > 1 && $5 > 30000 {print $3, $2, "-", $5, "€"}' esercizi/dati/dipendenti.csv
# Output:
# Marco Bianchi - 32000 €
# Luca Verdi - 35000 €
# Paolo Ferrari - 38000 €
# Giulia Ricci - 33000 €
```

</details>

---

## Esercizi extra

### Extra 1 - Caccia ai TODO

Trova tutti i `TODO` nei file `.java` del progetto e crea un report `todo_report.txt` nella cartella `sandbox` che elenchi, per ogni TODO trovato, il file e la riga.

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

find esercizi/progetto -name "*.java" -exec grep -n "TODO" {} \; > esercizi/sandbox/todo_report.txt

# Oppure, con il nome del file visibile:
grep -rn "TODO" esercizi/progetto/src/ > esercizi/sandbox/todo_report.txt

cat esercizi/sandbox/todo_report.txt
```

</details>

---

### Extra 2 - Analisi di sicurezza

Analizzando `esercizi/log/accessi.log`:

1. Trova tutte le richieste con codice `401` (login falliti)
2. Estrai solo gli indirizzi IP di chi ha fallito il login (usa `awk`)
3. Conta quante volte ciascun IP ha fallito (usa `sort` e `uniq -c`)
4. Salva il risultato in `sandbox/report_sicurezza.txt`

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# Tutto in una pipeline
grep "401" esercizi/log/accessi.log | awk '{print $1}' | sort | uniq -c | sort -rn > esercizi/sandbox/report_sicurezza.txt

cat esercizi/sandbox/report_sicurezza.txt
# Output:
#       3 203.0.113.42
#       2 192.168.1.50
#       1 10.0.0.5
```

**Lettura:** l'IP `203.0.113.42` ha fallito 3 volte — possibile attacco brute force!

</details>

---

### Extra 3 - Pulizia configurazioni

1. Crea nella `sandbox` una copia del file `app.cfg`
2. Sulla copia, rimuovi tutte le righe di commento (che iniziano con `#`) e le righe vuote
3. Il risultato deve contenere solo le righe di configurazione effettive

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

cp esercizi/progetto/config/app.cfg esercizi/sandbox/app_pulito.cfg

sed -i -e '/^#/d' -e '/^$/d' esercizi/sandbox/app_pulito.cfg

cat esercizi/sandbox/app_pulito.cfg
# Output:
# app.name=DemoApp
# app.version=1.0.3
# app.port=8080
# app.debug=true
# db.host=localhost
# db.port=5432
# db.name=demo_db
# db.user=admin
# db.password=changeme
# log.level=INFO
# log.file=app.log
# log.max_size=10MB
```

**Nota:** se hai già eseguito l'esercizio 4.2, la versione sarà `2.0.0` invece di `1.0.3`. Se vuoi ripartire, rilancia `bash setup.sh`.

</details>

---

### Extra 4 - Registro voti

Lavora sul file `esercizi/dati/voti_registro.txt`:

1. Mostra solo i voti di `Colombo` (usa `grep`)
2. Estrai dal registro solo data, cognome e voto (campi 1, 3, 5) — attenzione al separatore!
3. Mostra solo le righe con voto `9`, formattate come: `DATA - COGNOME: VOTO`

<details>
<summary>Solo dopo aver svolto l'esercizio, apri qui per vedere la soluzione</summary>

```bash
cd /workspaces/Lezione_Bash03

# 1. Voti di Colombo
grep "Colombo" esercizi/dati/voti_registro.txt
# Output:
# 2024-09-20 | Colombo | 9 | scritto
# 2024-10-05 | Colombo | 8 | orale
# 2024-11-12 | Colombo | 9 | pratico
# 2024-12-10 | Colombo | 8 | scritto

# 2. Estrarre data, cognome e voto (il separatore è " | ")
awk -F' \\| ' '!/^#/ && NF > 1 {print $1, $2, $3}' esercizi/dati/voti_registro.txt
# Output:
# 2024-09-20 Rossi 7
# 2024-09-20 Bianchi 8
# ...

# 3. Solo i 9, formattati
awk -F' \\| ' '$3 == " 9 " || $3 == "9" {gsub(/ /, "", $3); print $1, "-", $2 ": " $3}' esercizi/dati/voti_registro.txt
# Modo più semplice:
grep " 9 " esercizi/dati/voti_registro.txt | awk -F' \\| ' '{gsub(/ /, "", $1); gsub(/ /, "", $2); gsub(/ /, "", $3); print $1, "-", $2 ":", $3}'
# Output:
# 2024-09-20 - Colombo: 9
# 2024-11-12 - Colombo: 9
# 2024-12-10 - Marino: 9
```

**Nota:** il formato del file usa ` | ` (con spazi) come separatore, quindi bisogna usare `' \\| '` come campo separatore in awk, oppure combinare grep e awk in pipeline. Esistono diversi modi per ottenere lo stesso risultato — l'importante è arrivare all'output corretto!

</details>

---

## Riepilogo comandi

### find

| Comando | Descrizione |
|---------|-------------|
| `find <dir> -name "pattern"` | Cerca file per nome (con wildcards) |
| `find <dir> -iname "pattern"` | Come `-name` ma ignora maiuscole/minuscole |
| `find <dir> -type f` | Cerca solo file regolari |
| `find <dir> -type d` | Cerca solo directory |
| `find <dir> -name "..." -exec <cmd> {} \;` | Esegue un comando su ogni risultato |

### grep (opzioni avanzate)

| Comando | Descrizione |
|---------|-------------|
| `grep -E "regex" <file>` | Usa Extended Regex |
| `grep -i "pattern" <file>` | Ignora maiuscole/minuscole |
| `grep -c "pattern" <file>` | Conta le righe che matchano |
| `grep -v "pattern" <file>` | Mostra le righe che NON matchano |
| `grep -r "pattern" <dir>` | Cerca ricorsivamente in una directory |
| `grep -n "pattern" <file>` | Mostra il numero di riga |
| `grep -l "pattern" <file>` | Mostra solo i nomi dei file |

### sed

| Comando | Descrizione |
|---------|-------------|
| `sed 's/old/new/' <file>` | Sostituisce la prima occorrenza per riga |
| `sed 's/old/new/g' <file>` | Sostituisce tutte le occorrenze |
| `sed -i 's/old/new/g' <file>` | Modifica il file direttamente |
| `sed -E 's/regex/new/g' <file>` | Sostituzione con Extended Regex |
| `sed '/pattern/d' <file>` | Cancella le righe che matchano |
| `sed -e '...' -e '...' <file>` | Applica più operazioni |

### awk

| Comando | Descrizione |
|---------|-------------|
| `awk '{print $1}' <file>` | Stampa il primo campo |
| `awk -F',' '{print $2}' <file>` | Usa `,` come separatore |
| `awk 'NR > 1' <file>` | Salta la prima riga (header) |
| `awk '$3 > 7' <file>` | Filtra con condizione |
| `awk '{print $NF}' <file>` | Stampa l'ultimo campo |
| `awk '{print NR, $0}' <file>` | Stampa con numero di riga |

### Espressioni regolari

| Simbolo | Significato |
|---------|-------------|
| `.` | Un carattere qualsiasi |
| `*` | Zero o più del precedente |
| `+` | Uno o più del precedente |
| `?` | Zero o uno del precedente |
| `[abc]` | Uno tra a, b, c |
| `[^abc]` | Qualsiasi tranne a, b, c |
| `[0-9]` | Una cifra |
| `[a-z]` | Una lettera minuscola |
| `^` | Inizio riga |
| `$` | Fine riga |
| `\|` | Alternativa (OR) |
| `{n}` | Esattamente n ripetizioni |
| `{n,m}` | Da n a m ripetizioni |
| `\.` | Punto letterale (escape) |

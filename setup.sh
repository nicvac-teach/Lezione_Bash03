#!/bin/bash

# ============================================
# SETUP - Lezione Bash03
# Comandi filtro: find, regex, grep, sed, awk
# ============================================

echo "🔧 Creazione ambiente di esercitazione..."
echo ""

# Directory base (rileva automaticamente la directory del repository)
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Pulizia ambiente precedente (se esiste)
rm -rf "$BASE_DIR/esercizi"

# ============================================
# STRUTTURA DIRECTORY
# ============================================

mkdir -p "$BASE_DIR/esercizi/progetto/src/main"
mkdir -p "$BASE_DIR/esercizi/progetto/src/test"
mkdir -p "$BASE_DIR/esercizi/progetto/src/utils"
mkdir -p "$BASE_DIR/esercizi/progetto/config"
mkdir -p "$BASE_DIR/esercizi/progetto/docs"
mkdir -p "$BASE_DIR/esercizi/progetto/build"
mkdir -p "$BASE_DIR/esercizi/progetto/assets/img"
mkdir -p "$BASE_DIR/esercizi/progetto/assets/css"
mkdir -p "$BASE_DIR/esercizi/log"
mkdir -p "$BASE_DIR/esercizi/dati"
mkdir -p "$BASE_DIR/esercizi/sandbox"

# ============================================
# FILE SORGENTI DEL PROGETTO
# ============================================

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/src/main/App.java"
package main;

import utils.Logger;
import utils.Config;

public class App {
    private static final String VERSION = "1.0.3";

    public static void main(String[] args) {
        Logger logger = new Logger("app.log");
        Config config = Config.load("config/app.cfg");
        logger.info("Applicazione avviata - versione " + VERSION);
        // TODO: implementare menu principale
        System.out.println("Benvenuto nell'applicazione!");
    }
}
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/src/main/Server.java"
package main;

import utils.Logger;
import java.net.ServerSocket;

public class Server {
    private int port = 8080;
    // TODO: aggiungere gestione connessioni multiple

    public void start() {
        Logger logger = new Logger("server.log");
        logger.info("Server avviato sulla porta " + port);
        // TODO: implementare protocollo HTTP
        System.out.println("Server in ascolto...");
    }
}
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/src/test/TestApp.java"
package test;

import main.App;

public class TestApp {
    public static void testAvvio() {
        // TODO: scrivere test per avvio applicazione
        System.out.println("Test avvio: OK");
    }

    public static void testConfig() {
        // TODO: verificare caricamento configurazione
        System.out.println("Test config: PASSED");
    }
}
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/src/utils/Logger.java"
package utils;

import java.io.FileWriter;
import java.time.LocalDateTime;

public class Logger {
    private String filename;

    public Logger(String filename) {
        this.filename = filename;
    }

    public void info(String message) {
        write("INFO", message);
    }

    public void error(String message) {
        write("ERROR", message);
    }

    private void write(String level, String message) {
        // TODO: implementare scrittura su file
        System.out.println("[" + level + "] " + message);
    }
}
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/src/utils/Config.java"
package utils;

import java.io.BufferedReader;
import java.io.FileReader;

public class Config {
    // TODO: implementare parsing del file di configurazione

    public static Config load(String path) {
        System.out.println("Caricamento configurazione da: " + path);
        return new Config();
    }
}
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/src/main/index.html"
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>La Mia Applicazione</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
</head>
<body>
    <h1>Benvenuto</h1>
    <p>Email di contatto: info@example.com</p>
    <p>Supporto: supporto@azienda.it</p>
    <p>Versione: 1.0.3</p>
</body>
</html>
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/assets/css/style.css"
/* Stile principale dell'applicazione */
body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
    color: #333333;
    margin: 0;
    padding: 20px;
}

h1 {
    color: #0066cc;
    border-bottom: 2px solid #0066cc;
}

.container {
    max-width: 960px;
    margin: 0 auto;
}

/* TODO: aggiungere stile responsive */
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/docs/README.md"
# Progetto Demo

## Descrizione
Applicazione dimostrativa per il corso di informatica.

## Autori
- Mario Rossi (mario.rossi@studenti.edu)
- Laura Bianchi (laura.bianchi@studenti.edu)

## Requisiti
- Java 17 o superiore
- Connessione di rete per il modulo Server

## Note
Ultima modifica: 15 gennaio 2024
Versione corrente: 1.0.3
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/config/app.cfg"
# Configurazione applicazione
app.name=DemoApp
app.version=1.0.3
app.port=8080
app.debug=true

# Database
db.host=localhost
db.port=5432
db.name=demo_db
db.user=admin
db.password=changeme

# Logging
log.level=INFO
log.file=app.log
log.max_size=10MB
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/config/database.cfg"
# Configurazione database
host=192.168.1.100
port=5432
database=produzione
user=db_admin
password=s3cur3_p4ss!
max_connections=50
timeout=30
EOF

# File build (vuoti/compilati)
touch "$BASE_DIR/esercizi/progetto/build/App.class"
touch "$BASE_DIR/esercizi/progetto/build/Server.class"
touch "$BASE_DIR/esercizi/progetto/build/TestApp.class"

# Immagini placeholder
touch "$BASE_DIR/esercizi/progetto/assets/img/logo.png"
touch "$BASE_DIR/esercizi/progetto/assets/img/banner.jpg"
touch "$BASE_DIR/esercizi/progetto/assets/img/icon_home.svg"
touch "$BASE_DIR/esercizi/progetto/assets/img/icon_settings.svg"
touch "$BASE_DIR/esercizi/progetto/assets/img/screenshot01.png"
touch "$BASE_DIR/esercizi/progetto/assets/img/screenshot02.png"

# Script di progetto
cat << 'EOF' > "$BASE_DIR/esercizi/progetto/build.sh"
#!/bin/bash
echo "Compilazione in corso..."
javac -d build/ src/main/*.java src/utils/*.java
echo "Build completata!"
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/deploy.sh"
#!/bin/bash
# Deploy versione 1.0.3
echo "Deploy in corso..."
echo "Versione: 1.0.3"
echo "Deploy completato!"
EOF

# ============================================
# FILE DI LOG
# ============================================

cat << 'EOF' > "$BASE_DIR/esercizi/log/server.log"
2024-01-15 08:00:01 INFO  [main] Server avviato sulla porta 8080
2024-01-15 08:00:02 INFO  [main] Connessione al database stabilita
2024-01-15 08:05:15 INFO  [http] GET /index.html 200 12ms
2024-01-15 08:05:16 INFO  [http] GET /style.css 200 3ms
2024-01-15 08:10:30 WARN  [auth] Tentativo login fallito per utente admin da 192.168.1.50
2024-01-15 08:10:31 WARN  [auth] Tentativo login fallito per utente admin da 192.168.1.50
2024-01-15 08:10:32 ERROR [auth] Account admin bloccato dopo 2 tentativi falliti
2024-01-15 08:15:00 INFO  [http] GET /api/users 200 45ms
2024-01-15 08:15:01 INFO  [http] POST /api/users 201 120ms
2024-01-15 08:20:00 WARN  [http] GET /api/reports 403 5ms
2024-01-15 08:25:10 INFO  [http] GET /index.html 200 8ms
2024-01-15 08:30:00 ERROR [db] Timeout connessione al database dopo 30s
2024-01-15 08:30:05 INFO  [db] Riconnessione al database riuscita
2024-01-15 08:35:00 INFO  [http] DELETE /api/users/42 200 30ms
2024-01-15 08:40:15 INFO  [http] GET /api/products 200 22ms
2024-01-15 08:45:00 WARN  [auth] Tentativo login fallito per utente guest da 10.0.0.5
2024-01-15 08:50:00 INFO  [http] PUT /api/products/7 200 55ms
2024-01-15 08:55:30 ERROR [http] GET /api/orders 500 2005ms
2024-01-15 09:00:00 INFO  [main] Backup automatico avviato
2024-01-15 09:05:00 INFO  [main] Backup completato - 1.2GB
2024-01-15 09:10:00 INFO  [http] GET /index.html 200 10ms
2024-01-15 09:15:00 WARN  [auth] Tentativo login fallito per utente root da 203.0.113.42
2024-01-15 09:15:01 WARN  [auth] Tentativo login fallito per utente root da 203.0.113.42
2024-01-15 09:15:02 WARN  [auth] Tentativo login fallito per utente root da 203.0.113.42
2024-01-15 09:15:03 ERROR [auth] Account root bloccato dopo 3 tentativi falliti
2024-01-15 09:20:00 INFO  [http] GET /api/dashboard 200 150ms
2024-01-15 09:25:00 INFO  [http] POST /api/login 200 80ms
2024-01-15 09:30:00 INFO  [main] Server in esecuzione da 1h 30m - nessun problema critico
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/log/accessi.log"
192.168.1.10 - mario.rossi [15/Jan/2024:08:05:15] "GET /index.html" 200 1024
192.168.1.10 - mario.rossi [15/Jan/2024:08:05:16] "GET /style.css" 200 512
192.168.1.20 - laura.bianchi [15/Jan/2024:08:10:00] "GET /index.html" 200 1024
192.168.1.50 - admin [15/Jan/2024:08:10:30] "POST /login" 401 128
192.168.1.50 - admin [15/Jan/2024:08:10:31] "POST /login" 401 128
192.168.1.20 - laura.bianchi [15/Jan/2024:08:15:00] "GET /api/users" 200 2048
192.168.1.30 - paolo.verdi [15/Jan/2024:08:20:00] "GET /api/reports" 403 64
192.168.1.10 - mario.rossi [15/Jan/2024:08:25:10] "GET /index.html" 200 1024
192.168.1.30 - paolo.verdi [15/Jan/2024:08:30:00] "DELETE /api/users/42" 200 256
192.168.1.40 - anna.neri [15/Jan/2024:08:35:00] "GET /api/products" 200 4096
10.0.0.5 - guest [15/Jan/2024:08:45:00] "POST /login" 401 128
192.168.1.40 - anna.neri [15/Jan/2024:08:50:00] "PUT /api/products/7" 200 512
192.168.1.10 - mario.rossi [15/Jan/2024:08:55:30] "GET /api/orders" 500 64
203.0.113.42 - root [15/Jan/2024:09:15:00] "POST /login" 401 128
203.0.113.42 - root [15/Jan/2024:09:15:01] "POST /login" 401 128
203.0.113.42 - root [15/Jan/2024:09:15:02] "POST /login" 401 128
192.168.1.20 - laura.bianchi [15/Jan/2024:09:20:00] "GET /api/dashboard" 200 8192
192.168.1.10 - mario.rossi [15/Jan/2024:09:25:00] "POST /api/login" 200 256
EOF

# ============================================
# FILE DATI STRUTTURATI
# ============================================

cat << 'EOF' > "$BASE_DIR/esercizi/dati/studenti.csv"
matricola,cognome,nome,classe,media,email
1001,Rossi,Mario,4A,7.5,mario.rossi@studenti.edu
1002,Bianchi,Laura,4A,8.2,laura.bianchi@studenti.edu
1003,Verdi,Paolo,4B,6.8,paolo.verdi@studenti.edu
1004,Neri,Anna,4B,9.1,anna.neri@studenti.edu
1005,Ferrari,Luca,4A,5.5,luca.ferrari@studenti.edu
1006,Romano,Sara,4B,7.0,sara.romano@studenti.edu
1007,Colombo,Marco,4A,8.5,marco.colombo@studenti.edu
1008,Ricci,Giulia,4B,6.3,giulia.ricci@studenti.edu
1009,Marino,Andrea,4A,7.8,andrea.marino@studenti.edu
1010,Greco,Elena,4B,8.9,elena.greco@studenti.edu
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/dati/dipendenti.csv"
id;cognome;nome;reparto;stipendio;citta
D001;Bianchi;Marco;Sviluppo;32000;Milano
D002;Rossi;Anna;Marketing;28000;Roma
D003;Verdi;Luca;Sviluppo;35000;Milano
D004;Neri;Sara;Amministrazione;26000;Napoli
D005;Ferrari;Paolo;Sviluppo;38000;Torino
D006;Romano;Elena;Marketing;30000;Roma
D007;Colombo;Andrea;Amministrazione;27000;Milano
D008;Ricci;Giulia;Sviluppo;33000;Bologna
D009;Marino;Francesco;Marketing;29000;Roma
D010;Greco;Chiara;Amministrazione;25000;Napoli
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/dati/contatti.txt"
Rubrica contatti - aggiornata al 15/01/2024

Mario Rossi
  Email: mario.rossi@gmail.com
  Telefono: 333-1234567
  Indirizzo: Via Roma 15, 70100 Bari

Laura Bianchi
  Email: l.bianchi@outlook.it
  Telefono: 320-9876543
  Indirizzo: Corso Italia 42, 80100 Napoli

Paolo Verdi
  Email: p.verdi@yahoo.com
  Telefono: 347-5551234
  Indirizzo: Via Garibaldi 8, 20100 Milano

Anna Neri
  Email: anna_neri@libero.it
  Telefono: 338-4445566
  Indirizzo: Piazza Duomo 1, 50100 Firenze

Supporto tecnico
  Email: supporto@azienda.it
  Telefono: 080-5551000
  Indirizzo: Via Amendola 173, 70126 Bari

Segreteria scuola
  Email: segreteria@scuola.edu.it
  Telefono: 080-5552000
  Indirizzo: Via Marconi 100, 70100 Bari
EOF

cat << 'EOF' > "$BASE_DIR/esercizi/dati/voti_registro.txt"
# Registro voti - Informatica 4A - Primo quadrimestre
# Formato: DATA | COGNOME | VOTO | TIPO
2024-09-20 | Rossi | 7 | scritto
2024-09-20 | Bianchi | 8 | scritto
2024-09-20 | Ferrari | 5 | scritto
2024-09-20 | Colombo | 9 | scritto
2024-09-20 | Marino | 7 | scritto
2024-10-05 | Rossi | 8 | orale
2024-10-05 | Bianchi | 9 | orale
2024-10-05 | Ferrari | 6 | orale
2024-10-05 | Colombo | 8 | orale
2024-10-05 | Marino | 7 | orale
2024-11-12 | Rossi | 7 | pratico
2024-11-12 | Bianchi | 8 | pratico
2024-11-12 | Ferrari | 5 | pratico
2024-11-12 | Colombo | 9 | pratico
2024-11-12 | Marino | 8 | pratico
2024-12-10 | Rossi | 8 | scritto
2024-12-10 | Bianchi | 7 | scritto
2024-12-10 | Ferrari | 6 | scritto
2024-12-10 | Colombo | 8 | scritto
2024-12-10 | Marino | 9 | scritto
EOF

# ============================================
# FILE CON ERRORI DA CORREGGERE (per sed)
# ============================================

cat << 'EOF' > "$BASE_DIR/esercizi/dati/testo_da_correggere.txt"
Benvenuti nel corso di Informatica della scoula IISS Marconi.

In qeusto corso imparerete i fondamenti della programmazione,
dei sistemi opertivi e delle reti di calcolaotri.

Il linguaggio principale sarà Pyhton, ma vedremo anche Java
e un pò di HTML per le pagine web.

Gli orari delle lezioni sono:
- Lunedì: 8:00 - 10:00 (laboratorio)
- Mercoledì: 10:00 - 12:00 (aula)
- Venerdì: 14:00 - 16:00 (laboratorio)

Per contattare il docente scrivere a prof@vecchiamail.it
oppure usare il registro elettronico.

Buon lavoro a tutti gli stuenti!
EOF

# ============================================
# FILE NASCOSTO
# ============================================

cat << 'EOF' > "$BASE_DIR/esercizi/progetto/.env"
# Variabili d'ambiente - NON committare!
DB_PASSWORD=supersegreta123
API_KEY=sk-abc123def456ghi789
SECRET_TOKEN=jwt_t0k3n_s3gr3t0
ADMIN_EMAIL=admin@azienda.it
EOF

# ============================================
# COMPLETAMENTO
# ============================================

echo "✅ Ambiente creato con successo!"
echo ""
echo "📁 Struttura creata in: $BASE_DIR/esercizi/"
echo ""
echo "Contenuto:"
if command -v tree &> /dev/null; then
    tree "$BASE_DIR/esercizi/" -a --dirsfirst
else
    echo "(installa 'tree' per una visualizzazione migliore: sudo apt install tree)"
    find "$BASE_DIR/esercizi/" | head -50
fi
echo ""
echo "🚀 Sei pronto per iniziare gli esercizi! Apri il README.md"

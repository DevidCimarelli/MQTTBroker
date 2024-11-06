# Setup MQTT Broker with Mosquitto and Docker Compose

Questo script Bash configura un broker MQTT utilizzando **Mosquitto** e **Docker Compose**. Controlla se Docker è in esecuzione, verifica lo stato di un container Mosquitto specifico, e crea la struttura delle directory e dei file di configurazione necessari per l'uso di Docker Compose.

## Requisiti

- **Docker** e **Docker Compose** installati sul sistema.
- **Systemd** per gestire il servizio Docker.

## Funzionalità

1. **Verifica Docker**: Controlla se Docker è in esecuzione; in caso contrario, lo avvia.
2. **Controllo Container**: Verifica se un container MQTT chiamato `mosquitto` esiste:
   - Se il container è in esecuzione, offre l'opzione di fermarlo o continuare a usarlo.
   - Se il container non è in esecuzione, lo avvia e visualizza i log.
3. **Struttura Directory**: Crea la struttura delle directory `mosquitto/config`, `mosquitto/data`, e `mosquitto/log` per la configurazione e i dati.
4. **File di Configurazione**: Genera i file `docker-compose.yml` e `mosquitto.conf` se non esistono.
5. **Avvio Broker**: Esegue Docker Compose per avviare il broker MQTT Mosquitto.

## Installazione

1. **Clonare il repository** (se pertinente) o copiare lo script in una cartella sul sistema.
2. Assicurarsi che Docker e Docker Compose siano installati e funzionanti.
3. Rendere eseguibile lo script:
    `chmod +x setup_mosquitto.sh`.

## Esecuzione

**Eseguire lo script**: Per avviare lo script -> `./setup_mosquitto.sh`.    

## Struttura directory

1. `mosquitto/config/mosquitto.conf`: File di configurazione per il broker MQTT.
2. `mosquitto/data`: Cartella per i dati persistenti del broker.
3. `mosquitto/log`: Cartella per i log generati dal broker.

## Comandi utili

1. `docker-compose -f docker-compose.yml up -d` -> avvia il broker MQTT.
2. `docker-compose -f docker-compose.yml down` -> ferma il broker MQTT.
3. `docker logs -f mosquitto` -> visulizza i log.


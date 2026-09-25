## About The Project

AirSense is a comprehensive full-stack application designed to monitor, track, and analyze air quality and environmental pollution through IoT devices. Whether you are an individual tracking local air health or an administrator managing multiple sensor locations, AirSense provides a real-time, interactive dashboard and a highly scalable backend architecture.

### Key Features

* **Real-Time IoT Ingestion (MQTTnet):** Seamlessly receives and processes real-time air quality data from remote IoT sensors via the MQTT protocol.
* **Intuitive User Interface (Angular):** A highly responsive and structured client application allowing users to view current air pollution metrics, track historical data, and manage sensor locations.
* **Robust Server Logic (C# / ASP.NET Core 8):** The backend utilizes a clean architecture with the CQRS pattern (MediatR). It handles secure authorization (including OAuth with Google and GitHub), email notifications, and processes complex environmental data.
* **Reliable Data Storage (Microsoft SQL Server):** The application utilizes MS SQL Server and Entity Framework Core to securely store user accounts, historical air quality readings, and location metrics.

### Built With

## Getting Started

Follow these instructions to get a local copy of the project up and running.

### Prerequisites

You will need to have Docker installed on your machine to build and run the containers.

* [Docker Desktop](https://www.docker.com/products/docker-desktop/?utm_source=gemini) (includes Docker Compose)
* Git

### Installation & Launch

1. Clone the repository
```sh
git clone https://github.com/OleksiiIhnatiev/AirSense.git

```


2. Navigate to the project directory
```sh
cd AirSense

```


3. Build and launch the application using Docker Compose
```sh
docker-compose up -d --build

```


4. Once the containers are running, open your browser and navigate to the Angular client:
```text
http://localhost:4200/

```


*(Note: Verify the exact client port in your docker-compose mappings if customized)*

### Managing the Application

* **To stop the application:**
Run the following command to stop and remove the containers, networks, and volumes tied to the application:
```sh
docker-compose down

```


* **To apply code changes:**
If you modify the source code or configurations, you need to rebuild the Docker images. Run the launch command again with the `--build` flag:
```sh
docker-compose up -d --build

```



## Usage

### Web Interface

1. **Register/Login:** Create a standard account or authenticate quickly using Google or GitHub OAuth.
2. **Dashboard Overview:** Monitor real-time air pollution data fetched directly from connected IoT sensors.
3. **Location Management:** Add and track different geographical locations to monitor region-specific air quality.
4. **Historical Analysis:** Select specific timeframes and generate historical air pollution reports to identify long-term environmental trends.

### IoT Integration

AirSense includes an active MQTT broker connection logic tailored for remote hardware.

1. Ensure your IoT devices are configured to publish JSON payloads containing environmental metrics (e.g., CO2, PM2.5, Humidity).
2. Point the devices to the designated MQTT broker endpoint configured in the `appsettings.json` of the `.NET` backend.
3. The API will automatically ingest, validate, and store the payload into the SQL database.

## Roadmap

* [x] Basic Angular UI setup and component routing
* [x] Clean Architecture C# API with CQRS (MediatR)
* [x] Database Integration (MS SQL Server / EF Core)
* [x] Secure User Authentication (JWT, Google/GitHub OAuth)
* [x] Real-time IoT Data Ingestion via MQTT
* [ ] Advanced graphical data visualization (Charts.js / D3)
* [ ] Export reports to PDF/CSV
* [ ] Push notifications for dangerous air quality levels

See the open issues for a full list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Contact

Oleksii Ihnatiev - [LinkedIn](https://www.linkedin.com/in/oleksii-ihnatiev-75232a329/?utm_source=gemini)

Project Link: [https://github.com/OleksiiIhnatiev/AirSense](https://www.google.com/search?q=https://github.com/OleksiiIhnatiev/AirSense&utm_source=gemini)

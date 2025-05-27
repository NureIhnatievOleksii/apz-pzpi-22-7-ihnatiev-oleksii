import {
  Component,
  AfterViewInit,
  OnInit,
  inject,
  signal,
  computed,
  ViewChild,
} from '@angular/core';
import * as L from 'leaflet';
import { AirPollutionService } from '../../../services/air-pollution.service';
import { FormBuilder, FormGroup } from '@angular/forms';
import { MatPaginator } from '@angular/material/paginator';
import { AuthService } from '../../../services/auth.service';
export interface AirQualityResponse {
  coord: Coord;
  list: AirQualityEntry[];
}

export interface Coord {
  lon: number;
  lat: number;
}

export interface AirQualityEntry {
  main: Main;
  components: Components;
  dt: number; // timestamp (Unix)
}

export interface Main {
  aqi: number;
}

export interface AirQualityDataIoT {
  co: number;
  no: number;
  no2: number;
  o3: number;
  so2: number;
  pm2_5: number;
  pm10: number;
  nh3: number;
  measuredAt: string;
  deviceId: string;
  isSynced: boolean;
}

export interface Components {
  co: number;
  no: number;
  no2: number;
  o3: number;
  so2: number;
  pm2_5: number;
  pm10: number;
  nh3: number;
}

@Component({
  selector: 'app-comments-list',
  templateUrl: './comments-list.component.html',
  styleUrls: ['./comments-list.component.scss'],
})
export class CommentsListComponent implements AfterViewInit, OnInit {
  private map!: L.Map;

  airPollutionService = inject(AirPollutionService);
  authService = inject(AuthService);

  weatherAirPolution = signal<AirQualityResponse | null>(null);
  weatherAirPolutionList = signal<AirQualityResponse | null>(null);
  AirPolutionIoT = signal<AirQualityDataIoT | null>(null);
  rangeForm!: FormGroup;
  fb = inject(FormBuilder);
  @ViewChild(MatPaginator) paginator!: MatPaginator;
  airQualityScore = computed(() => {
    const data = this.AirPolutionIoT();
    if (!data) return null;

    function getScore(value: number, limits: number[]) {
      if (value <= limits[0]) return 5;
      if (value <= limits[1]) return 4;
      if (value <= limits[2]) return 3;
      if (value <= limits[3]) return 2;
      return 1;
    }

    const scores = [
      getScore(data.co, [1, 2, 5, 10]),
      getScore(data.no, [0.04, 0.06, 0.1, 0.2]),
      getScore(data.no2, [0.04, 0.08, 1.2, 1.8]),
      getScore(data.o3, [0.05, 0.1, 0.15, 0.2]),
      getScore(data.so2, [0.05, 0.1, 0.5, 1]),
      getScore(data.pm2_5, [10, 20, 35, 55]),
      getScore(data.pm10, [20, 40, 75, 100]),
      getScore(data.nh3, [0.2, 0.5, 1, 2]),
    ];

    const avg = scores.reduce((sum, s) => sum + s, 0) / scores.length;
    return Math.round(avg);
  });
  ngOnInit(): void {
    this.airPollutionService.getAirPollution().subscribe((weatherData) => {
      this.weatherAirPolution.set(weatherData);
      this.coords = [weatherData.coord.lat, weatherData.coord.lon];
    });
    this.rangeForm = this.fb.group({
      dateRange: this.fb.group({
        start: [null],
        end: [null],
      }),
    });

    this.rangeForm.get('dateRange')!.valueChanges.subscribe((value) => {
      const { start, end } = value;
      if (start && end) {
        // Преобразуем Date в ISO-строку (только дата без времени)
        const startISO = start.toISOString().split('T')[0];
        const endISO = end.toISOString().split('T')[0];
        this.airPollutionService
          .getAirPollutionHistory(startISO, endISO)
          .subscribe({
            next: (data) => {
              this.weatherAirPolutionList.set(data);
            },
            error: (err) => {
              console.error('Ошибка при получении истории:', err);
            },
          });

        console.log('Диапазон дат изменён:', startISO, endISO);
      }
    });
    setInterval(() => {
      this.airPollutionService
        .getAirPollutionIoT()
        .subscribe((data) => this.AirPolutionIoT.set(data));
    }, 1000);
  }

  pageSize = 5;
  pageIndex = 0;

  pagedComponentsList = signal<AirQualityEntry[]>([]);
  private coords: L.LatLngExpression = [50.4500336, 30.5241361];
  components = computed<AirQualityEntry | null>(() => {
    const data = this.weatherAirPolution();
    if (data && data.list.length > 0) {
      return data.list[0];
    }
    return null;
  });

  componentsListHistory = computed<AirQualityEntry[] | null>(() => {
    const data = this.weatherAirPolutionList();
    if (data && data.list.length > 0) {
      return data.list;
    }
    return null;
  });

  ngAfterViewInit(): void {
    this.initMap();
  }

  private initMap(): void {
    this.map = L.map('map', {
      center: this.coords,
      zoom: 13,
    });

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
    }).addTo(this.map);

    // Создаем красный маркер с иконкой в виде перевёрнутой капли
    const redIcon = L.icon({
      iconUrl:
        'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png',
      shadowUrl:
        'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.3/images/marker-shadow.png',
      iconSize: [25, 41], // размер иконки
      iconAnchor: [12, 41], // точка "острия" на иконке, которая указывает на координату
      popupAnchor: [1, -34], // точка для всплывающей подсказки
      shadowSize: [41, 41],
    });

    L.marker(this.coords, { icon: redIcon })
      .addTo(this.map)
      .bindPopup('Выбранная точка')
      .openPopup();
  }
}

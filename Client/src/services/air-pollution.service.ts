import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../environments/environment';
import { ErrorHandlingService } from './error-handling.service';
import { jwtDecode } from 'jwt-decode';
import {
  AirQualityDataIoT,
  AirQualityResponse,
} from '../app/components/comments-list/comments-list.component';

@Injectable({
  providedIn: 'root',
})
export class AirPollutionService {
  private readonly baseApiUrl = environment.apiUrl;
  public authStatusSubject = new BehaviorSubject<boolean>(this.isLoggedIn());
  private tokenKey = 'authToken';

  constructor(
    private httpClient: HttpClient,
    private errorHandlingService: ErrorHandlingService
  ) {}

  public isLoggedIn(): boolean {
    return !!localStorage.getItem(this.tokenKey);
  }

  public getAirPollutionHistory(
    startDate: string,
    endDate: string
  ): Observable<AirQualityResponse> {
    const token = localStorage.getItem(this.tokenKey);
    const decoded = jwtDecode(token);

    const userId =
      decoded[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'
      ];

    const url = `${this.baseApiUrl}/api/air-pollution/history`;

    const params = new HttpParams()
      .set('userId', userId)
      .set('start', startDate)
      .set('end', endDate);

    return this.httpClient
      .get<AirQualityResponse>(url, { params })
      .pipe(this.errorHandlingService.handleError<AirQualityResponse>());
  }

  public getAirPollutionIoT(): Observable<AirQualityDataIoT> {
    const url = `${this.baseApiUrl}/api/air-pollution/IoT`;

    return this.httpClient
      .get<AirQualityDataIoT>(url)
      .pipe(this.errorHandlingService.handleError<AirQualityDataIoT>());
  }

  public getAirPollution(): Observable<AirQualityResponse> {
    const token = localStorage.getItem(this.tokenKey);

    // Якщо токен відсутній — викидаємо помилку
    if (!token || typeof token !== 'string') {
      throw new Error('Користувач не аутентифікований або токен недійсний.');
    }

    let decoded: any;
    try {
      decoded = jwtDecode(token);
    } catch (err) {
      throw new Error('Не вдалося декодувати токен.');
    }

    const userId =
      decoded[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'
      ];

    const url = `${this.baseApiUrl}/api/air-pollution/${userId}`;
    return this.httpClient
      .get<AirQualityResponse>(url)
      .pipe(this.errorHandlingService.handleError<AirQualityResponse>());
  }

  public logout(): Observable<void> {
    const token = localStorage.getItem(this.tokenKey);
    const url = `${this.baseApiUrl}/api/Auth/Logout`;
    return this.httpClient.post<void>(url, { token }).pipe(
      tap(() => {
        localStorage.removeItem(this.tokenKey);
        this.authStatusSubject.next(false);
      }),
      this.errorHandlingService.handleError<void>()
    );
  }
}

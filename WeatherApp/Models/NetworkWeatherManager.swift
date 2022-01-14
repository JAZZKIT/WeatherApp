import Foundation
import CoreLocation

protocol NetworkWeatherMangerDelegate: AnyObject {
    func updateInteface(_: NetworkWeatherManger, with currentWeather: CurrentWeather)
}

class NetworkWeatherManger {
    
    weak var delegate: NetworkWeatherMangerDelegate?
    
    enum RequestType {
        case cityname(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    // Generic method
    func fetchCurrentWeather(for requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityname(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withURL: urlString)
    }
    
//    func fetchCurrentWeather(for city: String) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
//        performRequest(withURL: urlString)
//    }
//
//    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
//        performRequest(withURL: urlString)
//    }
    
    fileprivate func performRequest(withURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(with: data) {
                    self.delegate?.updateInteface(self, with: currentWeather)
                }
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(with data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(WeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
 }

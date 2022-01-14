import Foundation


struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, feelsLike = "feels_like"
    }
}

struct Weather: Decodable {
    let id: Int
}

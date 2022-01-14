import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManger()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { cityName in self.networkWeatherManager.fetchCurrentWeather(for: .cityname(city: cityName))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        //networkWeatherManager.fetchCurrentWeather(for: "Montreal")
    }
}

// MARK: - NetworkWeatherMangerDelegate

extension ViewController: NetworkWeatherMangerDelegate {
    func updateInteface(_: NetworkWeatherManger, with currentWeather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = currentWeather.cityName
            self.temperatureLabel.text = currentWeather.temperatureString
            self.feelsLikeTemperatureLabel.text = currentWeather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: currentWeather.systemIconNameString)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(for: .coordinate(latitude: latitude, longitude: longitude))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


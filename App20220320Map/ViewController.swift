//
//  ViewController.swift
//  App20220320Map
//
//  Created by grace on 2022/3/26.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    var locationManager: CLLocationManager!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 地圖類型
        myMapView.mapType = .standard
        
        // 不想讓使用者改變位置...
        // Ref. https://developer.apple.com/documentation/mapkit/mkmapview
//        myMapView.isScrollEnabled = false
//        myMapView.isZoomEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        initDispatchQueue()
        getUserLocation()
    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        // 持續取得位置
        locationManager?.delegate = self
        // 設定精準度 (Features -> Location -> Freeway Drive)
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.activityType = .automotiveNavigation
        locationManager?.startUpdatingLocation()
        myMapView.userTrackingMode = .followWithHeading
        
        print("===========")
        print(locationManager.location ?? "")
        print("===========")
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [self] timer in
            print("location:\(String(describing: self.locationManager.location) )")
        })

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 有更新時取得其最新位置
        let coordinate = locations[0].coordinate
        print("coordinate: \(coordinate.longitude)")
    }
    
    func initDispatchQueue() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            let latitude: CLLocationDegrees = 25.02701099962633
            let longitude: CLLocationDegrees = 121.52298765688852
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // 區域
            let xScale: CLLocationDegrees = 0.01
            let yScale: CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta: xScale)
            let regin: MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: span)
                        self.myMapView.setRegion(regin, animated: true)

            // 大頭針
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "古亭"
            annotation.subtitle = "古亭捷運站"
            self.myMapView.addAnnotation(annotation)
        }

    }
    
    @IBAction func setMapTypeAction(_ sender: UISegmentedControl) {
        // 取得目前位置
        if let coordinate = locationManager.location?.coordinate{
            let xScale: CLLocationDegrees = 0.01
            let yScale: CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta: xScale)
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            myMapView.setRegion(region, animated: true)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            myMapView.mapType = .standard
            break;
        case 1:
            myMapView.mapType = .satellite
            break;
        case 2:
            myMapView.mapType = .hybrid
            break;
        default:
            break;
        }
    }
    
    
    @IBAction func mapLongPress(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: myMapView)
        let location = myMapView.convert(touchPoint, toCoordinateFrom: myMapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "自選地點"
        self.myMapView.addAnnotation(annotation)
    }
}


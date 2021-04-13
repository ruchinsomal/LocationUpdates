//
//  MapViewController.swift
//  LocationUpdate
//
//  Created by Ruchin Somal on 2021-04-13.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var selectedLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Selected Locaton"
        //      mapView.userTrackingMode = .follow
        annotationForLocation()
    }
    
    func annotationForLocation() {
        guard let location = selectedLocation else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.title = location.description
        annotation.coordinate = location.coordinate
        mapView.addAnnotations([annotation])
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

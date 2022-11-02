//
//  ContentView.swift
//  loction2
//
//  Created by hessah abdullah aljarallah on 01/04/1444 AH.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View{
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear{
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
}


final class ContentViewModel:NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    var locationManager:CLLocationManager?
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }else{
            print("Show an alert letting them know this is off and to go turn it on.")
        }
    }
   private func checKLocationAuthoriza(){
        guard let locationManager = locationManager else{return}
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to  parental controls.")
        case .denied:
            print("Your have denied this app location permission. Go into setting to change it.")
        case .authorizedAlways,.authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            break
        }
            
            
        }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checKLocationAuthoriza()
    }
        
    }
    

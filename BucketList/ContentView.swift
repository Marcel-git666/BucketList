//
//  ContentView.swift
//  BucketList
//
//  Created by Marcel Mravec on 09.10.2022.
//

import MapKit
import LocalAuthentication
import SwiftUI


struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    
    @State private var isUnlocked = false
    
    @State private var mapReagion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                                           
    var locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of LOndon", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $mapReagion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    NavigationLink {
                        Text(location.name)
                    } label: {
                        Circle()
                            .stroke(.red, lineWidth: 3)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .navigationTitle(isUnlocked ? "L. Explorer unlocked": "L. Eplorer locked")
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    //we have authenticated successfully
                    isUnlocked = true
                } else {
                    //there was a problem
                }
            }
        } else {
            //no biometrics
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

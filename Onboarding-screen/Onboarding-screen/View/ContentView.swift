//
//  ContentView.swift
//  Onboarding-screen
//
//  Created by Md Shohidur Rahman on 9/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

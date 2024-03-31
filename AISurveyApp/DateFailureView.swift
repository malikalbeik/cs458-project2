//
//  DateFailureView.swift
//  AISurveyApp
//
//  Created by Malik Albeik on 31/03/2024.
//

import SwiftUI

struct DateFailureView: View {
    var body: some View {
        VStack {
            Text("Submission failed!")
                .font(.headline)
                .padding().accessibilityIdentifier("DateFailureMessage")

            Text("Your date format is either in the future or invalid.")
                .padding()
        }
    }
}

#Preview {
    DateFailureView()
}

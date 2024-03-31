import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            Text("Thank you for your participation!")
                .font(.headline)
                .padding().accessibilityIdentifier("SuccessMessage")

            Text("Your survey has been received.")
                .padding()
        }
    }
}

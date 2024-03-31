import SwiftUI

// ContentView including the form and navigation to SuccessView
struct ContentView: View {
    @State private var response = SurveyResponse()
    @State private var showingSuccessPage = false // Controls navigation to SuccessView
    @State private var showingDateFailedPage = false // Controls navigation to SuccessView

    let aiModels = ["ChatGPT", "Bard", "Claude", "Copilot"]

    // Checks if all fields are filled appropriately
    private var isFormFilled: Bool {
        !response.nameSurname.isEmpty &&
        !response.birthDate.isEmpty &&
        !response.educationLevel.isEmpty &&
        !response.city.isEmpty &&
        !response.gender.isEmpty &&
        !response.triedAIModels.isEmpty &&
        response.triedAIModels.allSatisfy { model in !(response.modelsDefects[model]?.isEmpty ?? true) } &&
        !response.beneficialUseCase.isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name-Surname", text: $response.nameSurname)
                        .accessibilityIdentifier("NameSurname")
                    TextField("Birth Date", text: $response.birthDate)
                        .accessibilityIdentifier("BirthDate")
                    TextField("Education Level", text: $response.educationLevel)
                        .accessibilityIdentifier("EducationLevel")
                    TextField("City", text: $response.city)
                        .accessibilityIdentifier("City")
                    TextField("Gender", text: $response.gender)
                        .accessibilityIdentifier("Gender")
                }
                
                Section(header: Text("AI Experience")) {
                    ForEach(aiModels, id: \.self) { model in
                        MultipleSelectionRow(title: model, isSelected: self.response.triedAIModels.contains(model)) {
                            if self.response.triedAIModels.contains(model) {
                                self.response.triedAIModels.removeAll(where: { $0 == model })
                            } else {
                                self.response.triedAIModels.append(model)
                            }
                        }
                        .accessibilityIdentifier("\(model)Checkbox")
                    }
                    if !response.triedAIModels.isEmpty {
                        ForEach(response.triedAIModels, id: \.self) { model in
                            TextField("\(model) Defects", text: Binding(get: { self.response.modelsDefects[model, default: ""] }, set: { self.response.modelsDefects[model] = $0 }))
                                .accessibilityIdentifier("DefectsField_\(model)")
                        }
                    }
                    TextField("Beneficial AI Use Case", text: $response.beneficialUseCase)
                        .accessibilityIdentifier("BeneficialUseCaseField")
                }
                
                if isFormFilled {
                    Button("Send") {
                        if  !isValidBirthDate(dateString: response.birthDate) {
                            showingDateFailedPage = true
                        }
                        else {
                            showingSuccessPage = true
                        }
                    }
                    .accessibilityIdentifier("SendButton")
                }
            }
            .navigationBarTitle("AI Survey")
            // NavigationLink to SuccessView, activated programmatically
            .background(NavigationLink(destination: SuccessView(), isActive: $showingSuccessPage) { EmptyView() })
            .background(NavigationLink(destination: DateFailureView(), isActive: $showingDateFailedPage) { EmptyView() })
        }
    }
    // Validate the birth date format and check if it's not in the future
    func isValidBirthDate(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }
        
        return date <= Date()
    }
}

// A helper view for selecting AI models
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        .accessibilityIdentifier("\(title)SelectionRow")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

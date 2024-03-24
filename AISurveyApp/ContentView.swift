import SwiftUI

struct ContentView: View {
    @State private var response = SurveyResponse()
    @State private var showingAlert = false
    let aiModels = ["ChatGPT", "Bard", "Claude", "Copilot"]

    // Computed property to check if all fields are filled appropriately
    private var isFormFilled: Bool {
        !response.nameSurname.isEmpty &&
        !response.educationLevel.isEmpty &&
        !response.city.isEmpty &&
        !response.gender.isEmpty &&
        !response.triedAIModels.isEmpty &&
        response.triedAIModels.allSatisfy { model in
            !(response.modelsDefects[model]?.isEmpty ?? true)
        } &&
        !response.beneficialUseCase.isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name-Surname", text: $response.nameSurname)
                    DatePicker("Birth Date", selection: $response.birthDate, displayedComponents: .date)
                    TextField("Education Level", text: $response.educationLevel)
                    TextField("City", text: $response.city)
                    TextField("Gender", text: $response.gender)
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
                    }
                    if !response.triedAIModels.isEmpty {
                        ForEach(response.triedAIModels, id: \.self) { model in
                            TextField("\(model) Defects", text: Binding(
                                get: { self.response.modelsDefects[model, default: ""] },
                                set: { self.response.modelsDefects[model] = $0 }
                            ))
                        }
                    }
                    TextField("Beneficial AI Use Case", text: $response.beneficialUseCase)
                }
                
                if isFormFilled {
                    Button("Send") {
                        // Handle the send action here
                        showingAlert = true
                    }
                }
            }
            .navigationBarTitle("AI Survey")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Survey Submitted"), message: Text("Thank you for your participation!"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

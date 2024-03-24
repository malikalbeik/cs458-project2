//
//  SurveyResponse.swift
//  AISurveyApp
//
//  Created by Malik Albeik on 24/03/2024.
//

import Foundation

struct SurveyResponse: Identifiable {
    let id = UUID()
    var nameSurname: String = ""
    var birthDate: Date = Date()
    var educationLevel: String = ""
    var city: String = ""
    var gender: String = ""
    var triedAIModels: [String] = []
    var modelsDefects: [String: String] = [:] // Key: Model Name, Value: Defect
    var beneficialUseCase: String = ""
}

//
//  HealthProfile.swift
//  Heal
//
//  Created by Anak Agung Gede Agung Davin on 18/10/22.
//

import Foundation
import HealthKit

class HKProfile {

    var healthStore = HKHealthStore()

    // most likely interchangable data
    func readData(completion: @escaping(Bool, Error?) -> Void) {
            var age: Int?
            var sex: HKBiologicalSex?
            var sexData: String = "Not Retrived"

            do {
                let birthDay = try healthStore.dateOfBirthComponents()
                let calendar = Calendar.current
                let currentYear = calendar.component(.year, from: Date() )
                age = currentYear - birthDay.year!
            } catch {}

            do {
                let getSex = try healthStore.biologicalSex()
                sex = getSex.biologicalSex
                if let data = sex {
                    sexData = self.getReadableBiologicalSex(biologicalSex: data)
                }
            } catch {}

            print("Age: \(age ?? 0)")
            print("Sex: \(sexData)")
    }

    func getReadableBiologicalSex(biologicalSex: HKBiologicalSex?) -> String {
        var biologicalSexTest = "Not Retrived"

        if biologicalSex != nil {
            switch biologicalSex!.rawValue {
            case 0:
                biologicalSexTest = ""
            case 1:
                biologicalSexTest = "Female"
            case 2:
                biologicalSexTest = "Male"
            case 3:
                biologicalSexTest = "Other"
            default:
                biologicalSexTest = ""
            }
        }

        return biologicalSexTest
    }

    // data that always updated
    func readRecentData() {
        let irregularType = HKCategoryType(HKCategoryTypeIdentifier.irregularHeartRhythmEvent)
        let weightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!

        let queryWeight = HKSampleQuery(sampleType: weightType,
                                        predicate: nil,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: nil) { (query, results, error) in

            if let result = results?.last as? HKQuantitySample {
                print("weight => \(result.quantity)")
            }
        }

        let queryHeight = HKSampleQuery(sampleType: heightType,
                                        predicate: nil,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: nil) { (query, results, error) in

            if let result = results?.last as? HKQuantitySample {
                print("height => \(result.quantity)")
            }
        }

        let queryIrregular = HKSampleQuery(sampleType: irregularType,
                                           predicate: nil,
                                           limit: HKObjectQueryNoLimit,
                                           sortDescriptors: nil) { (query, results, error) in

            if let result = results?.last as? HKCategorySample {
                print("Hasil \(result.description)")
            }
        }

        self.healthStore.execute(queryIrregular)
        self.healthStore.execute(queryHeight)
        self.healthStore.execute(queryWeight)

    }
}

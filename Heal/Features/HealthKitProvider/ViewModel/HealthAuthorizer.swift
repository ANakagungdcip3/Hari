//
//  HealthAuthorizer.swift
//  Heal
//
//  Created by Anak Agung Gede Agung Davin on 18/10/22.
//

import Foundation
import HealthKit
import CoreData

class HKAuthorize {

    var healthStore: HKHealthStore?
    var getProfile = HKProfile()
    var getECG = HKEcgs()

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func authorizeHealthKit(viewContext: NSManagedObjectContext, completion: @escaping (Bool, Error?) -> Void) {

        print("Trying to access HealthKit")
        let healthKitTypes: Set = [HKObjectType.electrocardiogramType(),
                                   HKCategoryType(HKCategoryTypeIdentifier.irregularHeartRhythmEvent),
                                   HKCharacteristicType(HKCharacteristicTypeIdentifier.dateOfBirth),
                                   HKCharacteristicType(HKCharacteristicTypeIdentifier.biologicalSex),
                                   HKQuantityType(HKQuantityTypeIdentifier.height),
                                   HKQuantityType(HKQuantityTypeIdentifier.bodyMass)]

        let typesToWrite: Set = [HKCategoryType(HKCategoryTypeIdentifier.chestTightnessOrPain),
                                 HKCategoryType(HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat),
                                 HKCategoryType(HKCategoryTypeIdentifier.shortnessOfBreath)]

        healthStore?.requestAuthorization(toShare: typesToWrite, read: healthKitTypes, completion: { (success, error) in
            if !success {
                print("We had an error here: \n\(String(describing: error))")
            } else {
                self.getProfile.readData { success, error in
                    print("Succesfully read data")
                }
                self.getECG.readECGs(viewContext)
                self.getProfile.readRecentData()
            }
        })
    }

}

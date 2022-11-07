//
//  ProfilePageNew.swift
//  Heal
//
//  Created by Anak Agung Gede Agung Davin on 31/10/22.
//

import SwiftUI
import CoreData

struct ProfilePageNew: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.name, ascending: true)],
        animation: .default)
    private var itemsProfile: FetchedResults<Profile>

    @EnvironmentObject var authProc: HKAuthorize
    @ObservedObject var notification: NotificationHelper
    @State private var name = ""
    @State private var doBirth = Date()
    @State private var gender = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var commorbit = ""
    @State private var custom = true

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.white, .white, Color(hex: "E37777")], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        // ini buat ilustrasi
                        .frame(width: 100, height: 100)

                    Field(title: "Nama", text: $name)
                    DatePicker(selection: $doBirth, displayedComponents: .date) {
                        Text("Tanggal Lahir")
                    }.padding()
                        .foregroundColor(Color(hex: "E37777"))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "E37777"), style: StrokeStyle(lineWidth: 2))
                    )
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .font(.title3)
                    .frame(maxWidth: .infinity)

                    Field(title: "Jenis Kelamin", text: $gender)
                    Field(title: "Tinggi", text: $height)
                    Field(title: "Berat", text: $weight)
                    Field(title: "Penyakit Bawaan", text: $commorbit)

                    Toggle("Notification", isOn: self.$notification.isOn).onChange(of: self.notification.isOn) { newValue in
                        notification.notifSchedule(isOn: newValue)
                    }

                    Button("Sinkronisasi dengan Apple Health") {
                        gender = authProc.getProfile.sexs
                        height = String(authProc.getProfile.height)
                        weight = String(authProc.getProfile.weight)
                        doBirth = authProc.getProfile.dob
                        // calling function autofill after tapped
                        // brt masukin dulu healthkit profile
                        // ke coredata yg profile, ntar tarik dari situ masukin ke state aja
                    }
                }.padding()
            }.navigationTitle("Profile")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        }
        //        .onAppear(){
        //            self.profile = HKProfile()
    }
}

struct ProfilePageNew_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageNew(notification: NotificationHelper())
    }
}

struct Field: View {
    var title: String
    var text: Binding<String>

    var body: some View {
        TextField(title, text: text)
            .padding()
            .foregroundColor(Color(hex: "E37777"))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "E37777"), style: StrokeStyle(lineWidth: 2))
            )
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .font(.title3)
            .frame(maxWidth: .infinity)
    }

//    private func onExpandTapped() {
//            isHidden.toggle()
//            UIApplication.shared.endEditing()
//        }
}
//
// extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
// }

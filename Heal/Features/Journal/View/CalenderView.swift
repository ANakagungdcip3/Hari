//
//  CalenderView.swift
//  Journal_Sympta
//
//  Created by Nur Mutmainnah Rahim on 11/10/22.
//  swiftlint:disable identifier_name
//  swiftlint:disable line_length

import SwiftUI
import CoreData
//show UI Calender
struct CalenderView: View {
    @FetchRequest(entity: Ecg.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ecg.avgBPM, ascending: true)])
    var BPMValues: FetchedResults<Ecg>
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var calenderViewModel = DetailJournalViewModel()
    @State var dictionaryDate: [Date: [Ecg]] = [:]
    func change() {
        //Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYY-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        
        for i in 0..<BPMValues.count {
            let dates = dateFormatter.string(from: BPMValues[i].timeStampECG ?? Date())
            let dated = dateFormatter.date(from: dates)
            var bpms = dictionaryDate[dated ?? Date()] ?? []
            bpms.append(BPMValues[i])
            dictionaryDate[dated ?? Date()] = bpms
            
        }
        
        //print(dictionaryDate)
        //print(BPMValues[0].timeStampECG)
    }

    //initialisation variabel "currentDate" from "JournalView.swift"
    @Binding var currentDate: Date
    
    //Month update on arrow button click
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack (spacing: 50){
            //Mark : Title
            Text("Jurnalmu")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .position(x:210, y:45)
                .foregroundColor(Color("ColorText"))
            VStack {
                HStack (spacing: 20){
                    //Mark : Month & Year
                    Text(extraDate()[0])
                        .font(.title2.bold())
                        .position(x:100, y:12)
                        .foregroundColor(Color("ColorText"))
                    //Mark : Button Next/Previous
                    //Button Left
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(Color("ColorText"))
                    }
                    
                    //Button Right
                    Button {
                        withAnimation{
                            currentMonth += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(Color("ColorText"))
                    }
                    .padding(.horizontal,30)
                }
                
                //Mark: Calender Aja
                //list days
                let days: [String] = ["Min","Sen","Sel","Rab","Kam","Jum","Sab"]
                //show days inline
                HStack(spacing: -20) {
                    ForEach(days,id: \.self){ day in
                        Text(day)
                        //.font(.callout)
                        //.fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color("ColorText"))
                    }
                    .padding(15)
                }
                
                //Show date in here
                
                
                //dates
                //masukkan tanggal ke tiap kolom hari(day)
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns,spacing: 15) {
                    //Mark: UI if Clicked Date
                    ForEach(extractDate()){value in
                        cardView(value: value)
                            .background(
                                Capsule()
                                    .fill(Color("bgCard"))
                                    .padding(.horizontal,8)
                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                                
                            )
                        
                            .onTapGesture {
                                currentDate = value.date
                            }
                        
                    }
                }
                .padding(.top,-20)
                .padding(12)
            }
            .background(Rectangle()
                .fill(.white)
                .frame(width:360, height:280))
            //.cornerRadius(10)
            
            //Mark: Second Title
            Text("Jurnal Hari Ini")
                .font(.title2.bold()) //font
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .padding(.top,-30)
                .padding(.bottom,-100)
                .foregroundColor(Color("ColorText"))
            
            HStack {
                VStack {
                    //Mark : Card Journal
                    if let card = dictionaryDate.first(where: { card in
                        return isSameDay(date1: card.key, date2: currentDate)
                    }){
                        ForEach(card.value, id: \.self){ cardd in
                                HStack {
                                    VStack {
                                        //Mark: BPM Value
                                        Text(String(cardd.avgBPM))
                                            .font(.custom("SFProRounded-Bold", size: 20).bold())
                                            .foregroundColor(Color("ColorText"))
                                        Text("BPM")
                                            .font(.custom("SFProRounded-Bold", size: 10).bold())
                                            .foregroundColor(Color("ColorText"))
                                    }
                                    .frame(width: 70, height: 54)
                                    .background(.white).cornerRadius(10)
                                    .padding(.leading, 15)
                                    
                                    VStack{
                                        HStack {
                                            //Date Card Journal
                                            Text(cardd.timeStampECG!.toString(dateFormat: "dd MMM YYYY"))
                                                .foregroundColor(Color("ColorText"))
                                            Text(cardd.timeStampECG!.toString(dateFormat: "HH : mm"))
                                                .foregroundColor(Color("ColorText"))
                                            
                                            //Mark : Go To Detail View
                                            NavigationLink {
                                                DetailJournal(journalData: calenderViewModel, ecg: cardd.avgBPM, date: cardd.timeStampECG!.toString(dateFormat: "dd MMMM YYYY"), hour:cardd.timeStampECG!.toString(dateFormat: "HH : mm"), coreDataItem: cardd, xPoints: cardd.xAxis!, yPoints: cardd.yAxis!)
                                            } label: {
                                                Text("Edit")
                                            }
                                        }
                                        HStack {
                                            Image("Img_BPM")
                                            Image("Img_ECG")
                                            Image("Img_Act")
                                        }
                                    }
                                }
                            //}
                        }//batas foreach
                        .frame(width: 328, height: 80)
                        .background(Color("bgCard")).cornerRadius(10)
                        //.background(Color(UIColor(red: 846, green: 0.677, blue: 0.769, alpha: 1))).cornerRadius(10)
                    }
                    //If EKG Empty
                    else {
                        Text("Tidak Ada Data Tercatat")
                    }
                    
                }
                
            }
            
        }
        .onChange(of: currentMonth) { newValue in
            //update month
            currentDate = getCurrentMonth()
            
        }
        .onAppear() {
            if dictionaryDate == [:] {
                change()
            }
        }
    }
    @ViewBuilder
    func cardView(value: DateValue)-> some View{
        VStack {
            if value.day != -1{
                //mark kalau ada card
                if let card = dictionaryDate.first(where: { card in
                    return isSameDay(date1: card.key, date2: value.date)
                }){
                    Text("\(value.day)")
                        .foregroundColor(isSameDay(date1: card.key, date2: currentDate) ? .white: .primary)
                        .frame(maxWidth: .infinity)
                    
                    
                    Circle()
                        .fill(isSameDay(date1: card.key, date2: currentDate) ? .white: .blue)
                        .frame(width: 5, height: 5)
                }
                else {
                    //tanggal hari ini
                    Text("\(value.day)")
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .black : .primary)
                        .frame(maxWidth: .infinity)
                }
                
                
                
            }
        }
        
    }
    
    //checking dates
    func isSameDay(date1: Date,date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    //extraxting year and month
    func extraDate()->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: "")
    }
    
    func getCurrentMonth()->Date{
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    //fungsi buat ngambil kumpulan tanggal
    func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        //getting current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            //getting day
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
            
        }
        //adding offset days to get exact week
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
    
    
    
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}


//extending date to get current month dates
extension Date{
    func getAllDates()->[Date]{
        let calendar = Calendar.current
        
        //getting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to:startDate)!
        }
    }
    
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

//List To DO:
//Change color text date

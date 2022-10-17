//
//  ContentView.swift
//  CustomTagsView
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack{
            Text("Enter Tag Here:")
                .padding()
            TextField("Enter tag", text: $viewModel.tagText, onCommit: {
                viewModel.addTag()
            })
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder()
                    .foregroundColor(.black)
            )
            .padding()
            
            VStack(alignment: .leading, spacing: 4){
                ForEach(viewModel.rows, id:\.self){ rows in
                    HStack(spacing: 6){
                        ForEach(rows){ row in
                            Text(row.name)
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                                .padding(.trailing, 30)
                                .padding(.vertical, 8)
                                .background(
                                    ZStack(alignment: .trailing){
                                        Capsule()
                                            .fill(.gray.opacity(0.3))
                                        Button{
                                            viewModel.removeTag(by: row.id)
                                        } label:{
                                            Image(systemName: "xmark")
                                                .frame(width: 15, height: 15)
                                                .padding(.trailing, 8)
                                                .foregroundColor(.red)
                                        }
                                    }
                                )
                        }
                    }
                    .frame(height: 28)
                    .padding(.bottom, 10)
                }
            }
            .padding(24)
            
            Spacer()
        }
    }
}

struct Tag: Identifiable, Hashable{
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
}


class ContentViewModel: ObservableObject{
    
    @Published var rows: [[Tag]] = []
    @Published var tags: [Tag] = [Tag(name: "XCode"), Tag(name: "IOS"), Tag(name: "IOS App Development"), Tag(name: "Swift"), Tag(name: "SwiftUI")]
    @Published var tagText = ""
    
    init(){
        getTags()
    }
    
    func addTag(){
        tags.append(Tag(name: tagText))
        tagText = ""
        getTags()
    }
    
    func removeTag(by id: String){
        tags = tags.filter{ $0.id != id }
        getTags()
    }
    
    
    func getTags(){
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        
        let screenWidth = UIScreen.screenWidth - 10
        let tagSpaceing: CGFloat = 56
        
        if !tags.isEmpty{
            
            for index in 0..<tags.count{
                self.tags[index].size = tags[index].name.getSize()
            }
            
            tags.forEach{ tag in
                
                totalWidth += (tag.size + tagSpaceing)
                
                if totalWidth > screenWidth{
                    totalWidth = (tag.size + tagSpaceing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                }else{
                    currentRow.append(tag)
                }
            }
            
            if !currentRow.isEmpty{
                rows.append(currentRow)
                currentRow.removeAll()
            }
            
            self.rows = rows
        }else{
            self.rows = []
        }
        
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.width
}

extension String{
    func getSize() -> CGFloat{
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
}

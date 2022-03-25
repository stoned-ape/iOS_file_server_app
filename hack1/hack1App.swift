//
//  hack1App.swift
//  hack1
//
//  Created by Apple1 on 4/20/21.
//

import SwiftUI



@main
struct main{
    public static func main(){
        print("main")
        globals_init()
        run_cpp_server()
        hack1App.main()
    }
}

struct hack1App:App{
    var body:some Scene{
        WindowGroup{
            ContentView()
        }
    }
}

struct ContentView:View{
    var body:some View{
        VStack{
            HStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width:60,height:60,alignment:.center)
            Text("iOS HTTP Server")
            }
            linkview()
                .frame(width:100,height:20,alignment:.center)
                .onTapGesture{
                    let url=URL(string:"http://127.0.0.1:8000")!
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url)
                    }else{
                        print("url error")
                    }
                }
                .padding()
            Text("select a file to serve")
            hackview()
        }
    }
}

struct linkview:UIViewRepresentable{
    func makeUIView(context:Context)->some UIView{
        print("linkview.makeUIView()")
        let view=UILabel()
        view.textColor = .cyan
        view.text=String(NSString(utf8String:globals.url)!)
        return view
    }
    func updateUIView(_ uiView:UIViewType,context:Context){}
}


func make_browser()->UIDocumentBrowserViewController{
    return UIDocumentBrowserViewController(
        forOpening:[.item,.content,.compositeContent,.diskImage,.data,.directory,.resolvable,
                    .symbolicLink,.executable,.mountPoint,.aliasFile,.urlBookmarkData,.url,
                    .fileURL,.text,.plainText,.utf8PlainText,.utf16ExternalPlainText,
                    .utf16PlainText,.delimitedText,.commaSeparatedText,.tabSeparatedText,
                    .utf8TabSeparatedText,.rtf,.html,.xml,.yaml,.sourceCode,
                    .assemblyLanguageSource,.cSource,.objectiveCSource,.swiftSource,
                    .cPlusPlusSource,.objectiveCPlusPlusSource,.cHeader,.cPlusPlusHeader,
                    .script,.appleScript,.osaScript,.osaScriptBundle,.javaScript,.shellScript,
                    .perlScript,.pythonScript,.rubyScript,.phpScript,.json,.propertyList,
                    .xmlPropertyList,.binaryPropertyList,.pdf,.rtfd,.flatRTFD,.webArchive,.image,
                    .jpeg,.tiff,.gif,.png,.icns,.bmp,.ico,.rawImage,.svg,.livePhoto,.heif,.heic,
                    .webP,.threeDContent,.usd,.usdz,.realityFile,.sceneKitScene,
                    .arReferenceObject,.audiovisualContent,.movie,.video,.audio,.quickTimeMovie,
                    .mpeg,.mpeg2Video,.mpeg2TransportStream,.mp3,.mpeg4Movie,.mpeg4Audio,
                    .appleProtectedMPEG4Audio,.appleProtectedMPEG4Video,.avi,.aiff,.wav,.midi,
                    .playlist,.m3uPlaylist,.folder,.volume,.package,.bundle,.pluginBundle,
                    .spotlightImporter,.quickLookGenerator,.xpcService,.framework,.application,
                    .applicationBundle,.applicationExtension,.unixExecutable,.exe,
                    .systemPreferencesPane,.archive,.gzip,.bz2,.zip,.appleArchive,.spreadsheet,
                    .presentation,.database,.message,.contact,.vCard,.toDoItem,.calendarEvent,
                    .emailMessage,.internetLocation,.internetShortcut,.font,.bookmark,.pkcs12,
                    .x509Certificate,.epub,.log
        ]
    )
}


struct hackview:UIViewRepresentable{
    var del=delegate()
    var browser=make_browser()
    func makeUIView(context: Context)->some UIView{
        print("hackview.makeUIView()")
        browser.delegate=del
        browser.shouldShowFileExtensions=true
        browser.allowsDocumentCreation=false
        return browser.view
    }
    func updateUIView(_ uiView:UIViewType,context:Context){
        print("hackview.updateUIView()")
    }
}

class delegate:NSObject,UIDocumentBrowserViewControllerDelegate{
    func documentBrowser(_ controller:UIDocumentBrowserViewController,didPickDocumentsAt urls:[URL]){
        print("didPickDocumentsAt")
        print(urls)
        controller.revealDocument(at:urls[0],importIfNeeded:true)
        
        for url in urls{
            guard url.startAccessingSecurityScopedResource()else{
                print("error")
                continue
            }
            let data=try! Data(contentsOf:url)
            allocate_buf(Int32(data.count))
            data.copyBytes(to:globals.data,count:data.count);
            url.stopAccessingSecurityScopedResource()
        }
        
    }
}



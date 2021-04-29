//
//  ViewController.swift
//  demoMath
//
//  Created by mac on 22/04/21.
//

import UIKit
import iosMath
import  Combine

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblTest: MTMathUILabel!
    var str = "<img src=\"http://latex.codecogs.com/gif.latex?%5Cbinom%7Bn%7D%7Bk%7D%20%3D%20%5Cfrac%7Bn%21%7D%7Bk%21%28n-k%29%21%7D>"
    // there \ afte src= in your string
    let htmlString = "<img src=http://latex.codecogs.com/gif.latex?%5Cbinom%7Bn%7D%7Bk%7D%20%3D%20%5Cfrac%7Bn%21%7D%7Bk%21%28n-k%29%21%7D>"

    //More Content Not Showing in second Line"
    
    
    
    
    
    @IBOutlet var lblDemo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testHTMLString()
        
    }
    
    private func testHTMLString() {
        
        if let attributedText = htmlString.attributedHtmlString {
            
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            //   attributedString.setFontFace(font: UIFont(name: "Mulish-Regular", size: 16.0) ?? UIFont.init())
            
            if attributedString.string.contains("\\(") {
                let tempMutableString = NSMutableAttributedString(attributedString: attributedString)
                let pattern = #"\\\((.*?)\\\)"#
                let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
                let testString = attributedString.string
                let stringRange = NSRange(location: 0, length: testString.utf16.count)
                let matches = regex.matches(in: testString, range: stringRange)
                if matches.isEmpty {
                    lblDemo.attributedText = attributedString
                } else {
                    for match in matches {
                        for rangeIndex in 1 ..< match.numberOfRanges {
                            let substring = (testString as NSString).substring(with: match.range(at: rangeIndex))
                            //  let image = imageWithLabel(string: substring)
                            //   let flip = UIImage(cgImage: image.cgImage!, scale: 2.5, orientation: .downMirrored)
                            let attachment = NSTextAttachment()
                            // attachment.image = flip
                            //  attachment.bounds = CGRect(x: 0, y: -flip.size.height/2 + 5, width: flip.size.width, height: flip.size.height)
                            let replacement = NSAttributedString(attachment: attachment)
                            let finalRange = tempMutableString.string.range(of: "\\(\(substring)\\)", options: .forcedOrdering, range: tempMutableString.string.startIndex..<tempMutableString.string.endIndex, locale: Locale(identifier: "en-US"))
                            tempMutableString.replaceCharacters(in:  NSRange(finalRange!, in: tempMutableString.string), with: replacement)
                            lblDemo.attributedText = tempMutableString
                        }
                    }
                }
            } else {
                lblDemo.attributedText = attributedString
            }
            
        }
    }

}


//MARK:- String extension - convert html to NSAttributedString
extension String {
    
    var utfData: Data {
        return Data(utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        do {
            return try NSAttributedString(data: utfData, options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}


import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <style>
                            body {
                                padding: 0 20px;
                            }
                            h2 {
                                text-align: center;
                            }
                            p {
                                font-size: 115%;
                            }
                        </style>
                    </head>
                    <body>
                        <h2>\(detailItem.title)</h2>
                        <p>\(detailItem.body)</p>
                        <i>Signature Count: \(detailItem.signatureCount)</i>
                    </body>
                </html>
                """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

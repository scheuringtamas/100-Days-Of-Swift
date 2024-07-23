import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions: [Petition] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .done, target: self, action: #selector(credits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTapped))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        } else {
            showError()
        }
        
        func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, please check your connection and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func credits() {
        let ac = UIAlertController(title: "The data comes from the We The People API of the Whitehouse", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func filterButtonTapped() {
        let ac = UIAlertController(
            title: "Filter",
            message: "Please enter a string to filter by.",
            preferredStyle: .alert
        )
        
        ac.addTextField()
        
        ac.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                if let filterString = ac.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) {
                    guard let self = self else { return }
                    
                    self.filteredPetitions = self.petitions.filter { petition in
                        petition.title.localizedCaseInsensitiveContains(filterString)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        )
        
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


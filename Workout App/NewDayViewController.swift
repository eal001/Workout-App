//
//  NewDayViewController.swift
//  Workout App
//
//  Created by Elliot Lee on 12/15/20.
//

import UIKit

class NewDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NewDayViewControllerDelegate {
    
    var exercises : [Exercise] = [Exercise]()
    var routine_delegate : NewRoutineViewControllerDelegate?
    var stored_cell : Exercise?
    var returning_index : Int?

    @IBOutlet weak var day_name_field: UITextField!
    @IBOutlet weak var new_exercise_button: UIButton!
    @IBOutlet weak var exercise_table: UITableView!
    @IBOutlet weak var name_indicator_field: UILabel!
    @IBOutlet weak var name_background: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercise_table.dataSource = self
        exercise_table.delegate = self
        
        exercise_table.rowHeight = Constants.STD_ROW_HEIGHT
        self.view.backgroundColor = Constants.BACKGROUND()
        name_background.backgroundColor = Constants.SECTION()
        name_indicator_field.textColor = Constants.TEXT()
        day_name_field.backgroundColor = Constants.SECTION()
        exercise_table.backgroundColor = Constants.BACKGROUND()
        day_name_field.textColor = Constants.TEXT()
        new_exercise_button.tintColor = Constants.TINT()
        
        if let previous = routine_delegate as? NewRoutineViewController {
            self.day_name_field?.text = previous.stored_cell?.name
            self.exercises = previous.stored_cell?.exercises ?? [Exercise]()
        }
        
    }
    
    /*
     what to do when the view is touched
     --remove keyboard
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
     the sections of exercises in this "day" is 1
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     the name of the section(s)
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.EXERCISES
    }
    
    /*
     the number of exercises should be reresentative of the actual exercise array count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    /*
     the cell anmes should be that of the exercise names
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_0, for: indexPath)
        cell.textLabel?.text = exercises[indexPath.row].name
        cell.backgroundColor = Constants.CELL_0()
        cell.textLabel?.textColor = Constants.TEXT()
        return cell
    }
    
    /*
     implement on tapped funtionality
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stored_cell = exercises[indexPath.row]
        returning_index = indexPath.row
    }
    
    /*
     implement delete fuctionality
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        exercise_table.reloadData()
    }
    
    /*
     the color and style of the tableview header
     */
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.SECTION()
        
        if let sect_header = view as? UITableViewHeaderFooterView {
            sect_header.textLabel?.textColor = Constants.TEXT()
        }
        
    }
    
    // MARK: - Navigation
    /*
     this function needs to exist, becasue in another function it is going to be used to pass data back
     into this view controller
     */
    func append_exercises(_ exercise: Exercise) {
        if(exercise.name == ""){
            return;
        }
        self.exercises.append(exercise)
        exercise_table.reloadData()
    }
    
    func edit_exercise(_ exercise: Exercise) {
        if returning_index == nil {
            return
        }
        if exercise.name == ""{
            exercises.remove(at: returning_index ?? 0)
            exercise_table.reloadData()
            return
        }
        exercises[returning_index ?? 0].name = exercise.name
        exercises[returning_index ?? 0].type = exercise.type
        exercises[returning_index ?? 0].sets = exercise.sets
        exercise_table.reloadData()
    }
    
    /*
     call this function when this current view controller dissapears
     */
    override func viewWillDisappear(_ animated: Bool) {
        if(self.isMovingFromParent){
            //add only if we didnt come from a cell
            //a clickale cell will never have an emty string as a name
            var will_add = Constants.ZERO_STR
            if let previous = routine_delegate as? NewRoutineViewController {
                will_add = previous.stored_cell?.name ?? ""
            }
            if(will_add == ""){
                routine_delegate?.append_days( day_name_field?.text ?? "", exercises )
            } else {
                routine_delegate?.edit_day( day_name_field?.text ?? "", exercises)
            }
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        self.view.endEditing(true)
        if let destination = segue.destination as? NewExerciseViewController {
            destination.delegate = self
        }
        stored_cell = nil
    }
    

}

protocol NewDayViewControllerDelegate {
    func append_exercises(_ exercises : Exercise )
    func edit_exercise(_ exercise : Exercise)
}

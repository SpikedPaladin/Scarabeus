[GtkTemplate (ui = "/me/paladin/Scarabeus/main-page.ui")]
public class MainPage : Adw.NavigationPage {
    private string main_path { get; set; default = ""; }
    private string sample_path { get; set; default = ""; }
    
    public bool search_available { get; set; }
    
    [GtkChild]
    private unowned Adw.ActionRow main_info;
    [GtkChild]
    private unowned Adw.ActionRow sample_info;
    [GtkChild]
    private unowned Adw.SpinRow context_size;
    
    [GtkCallback]
    private void start_search() {
        nav.push(new ResultPage(main_path, sample_path, (int) context_size.value));
    }
    
    [GtkCallback]
    private void select_main() {
        select_main_async.begin();
    }
    
    [GtkCallback]
    private void select_sample() {
        select_sample_async.begin();
    }
    
    private void update_button() {
        search_available = sample_path != main_path && sample_path != "" && main_path != "";
    }
    
    private async void select_main_async() {
        var folder = yield select_folder();
        
        if (folder != null) {
            main_info.subtitle = main_path = folder.get_path();
            
            update_button();
        }
    }
    
    private async void select_sample_async() {
        var folder = yield select_folder();
        
        if (folder != null) {
            sample_info.subtitle = sample_path = folder.get_path();
            
            update_button();
        }
    }
    
    private async File? select_folder() {
        var dialog = new Gtk.FileDialog();
        
        try {
            var folder = yield dialog.select_folder(Example.instance.main_window, null);
            if (folder != null) {
                return folder;
            }
        } catch (Error err) {}
        
        return null;
    }
}
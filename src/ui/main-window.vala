public unowned Adw.NavigationView nav;

[GtkTemplate (ui = "/me/paladin/Scarabeus/main-window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Adw.NavigationView nav_view;
    
    public MainWindow(Gtk.Application app) {
        Object(application: app);
        
        nav = nav_view;
    }
    
    public static void ensure_types() {
        typeof(MainPage).ensure();
    }
}

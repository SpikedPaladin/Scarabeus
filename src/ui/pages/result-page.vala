[GtkTemplate (ui = "/me/paladin/Scarabeus/result-page.ui")]
public class ResultPage : Adw.NavigationPage {
    private string main_path { get; set; default = ""; }
    private string sample_path { get; set; default = ""; }
    
    public Gtk.NoSelection model { get; set; }
    public ListStore store = new ListStore(typeof(Scarabeus.CorruptFile));
    
    [GtkChild]
    private unowned Gtk.Stack stack;
    [GtkChild]
    private unowned Gtk.ListBox list_box;
    
    public ResultPage(string main_path, string sample_path, int context_size) {
        this.main_path = main_path;
        this.sample_path = sample_path;
        model = new Gtk.NoSelection(store);
        
        list_box.bind_model(store, (object) => {
            var item = (Scarabeus.CorruptFile) object;
            
            var row = new Adw.ExpanderRow() {
                title = item.path
            };
            
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 3) {
                margin_end = 12,
                margin_start = 12,
                margin_top = 6,
                margin_bottom = 6
            };
            box.append(new Gtk.Label(item.main_content) {
                use_markup = true,
                css_classes = { "title" },
                wrap = true
            });
            box.append(new Gtk.Label((string) item.main_bytes) {
                css_classes = { "subtitle" },
                halign = Gtk.Align.START,
                wrap = true
            });
            row.add_row(box);
            
            
            box = new Gtk.Box(Gtk.Orientation.VERTICAL, 3) {
                margin_end = 12,
                margin_start = 12,
                margin_top = 6,
                margin_bottom = 6
            };
            box.append(new Gtk.Label(item.sample_content) {
                use_markup = true,
                css_classes = { "title" },
                wrap = true
            });
            box.append(new Gtk.Label((string) item.sample_bytes) {
                css_classes = { "subtitle" },
                halign = Gtk.Align.START,
                wrap = true
            });
            row.add_row(box);
            
            return row;
        });
        
        load_uri.begin(context_size);
    }
    
    public async void load_uri(int context_size) {
        Scarabeus.CorruptFile[]? files = null;
        
        new Thread<void>("io", () => {
            try {
                var scanner = new Scarabeus.Scanner(main_path, sample_path, context_size);
                files = scanner.find_corrupted();
            } catch (Error err) {
                warning("Error while loading texture: %s", err.message);
            stack.visible_child_name = "error";
            } finally {
                Idle.add(load_uri.callback);
            }
        });
        
        yield;
        if (files != null) {
            if (files.length > 0) {
                stack.visible_child_name = "success";
                foreach (var file in files) {
                    store.append(file);
                }
            } else {
                stack.visible_child_name = "error";
            }
        }
    }
}

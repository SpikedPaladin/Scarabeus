project(
    'scarabeus',
    
    [ 'c', 'vala' ],
    version: '1.0.0',
    meson_version: '>= 0.50.0',
)

gnome = import('gnome')

name = meson.project_name()
output = name.to_lower()

api_version = '1.0'
lib_name = meson.project_name() + '-' + api_version
gir_name = 'Scarabeus-' + api_version

subdir('data')
subdir('src')

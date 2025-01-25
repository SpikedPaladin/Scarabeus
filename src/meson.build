deps = [
    dependency('libadwaita-1'),
    dependency('scarabeus-1.0'),
]

sources = files(
    'app.vala',
)

subdir('ui')

app = executable(
    output,
    
    resources,
    sources,
    dependencies: deps,
    win_subsystem: 'windows',
    install: true,
)

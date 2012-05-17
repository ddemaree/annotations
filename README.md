# Annotations

Extracts and displays annotations from source code comments like these:

```ruby
class MyModel
  def find(id)
    # TODO: Find the thing
  end
end
```

The output looks like this:

    ./lib/my_model.rb:
      * [ 17] [TODO] Find the thing

If this looks familiar from Rails, it's because Annotations is derived/forked from the annotations code in Rails 3.2.1, now extracted into its own gem so it can be used in non-Rails (or even non-Ruby) projects.

Annotations looks for TODO, FIXME, and OPTIMIZE comments in the following kinds of source code files:

<table>
  <thead>
    <tr class="header-row">
      <th>Syntax</th>
      <th>Supported file extensions</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Ruby</b></td>
      <td>.rb, .builder, Gemfile, Rakefile</td>
    </tr>
    <tr>
      <td><b>ERb</b></td>
      <td>.erb, .rhtml</td>
    </tr>
    <tr>
      <td><b>CoffeeScript</b></td>
      <td>.coffee</td>
    </tr>
    <tr>
      <td><b>Sass</b></td>
      <td>.scss, .sass</td>
    </tr>
    <tr>
      <td><b>PHP</b></td>
      <td>.php</td>
    </tr>
  </tbody>
</table>

## Installation

Add this line to your application's Gemfile:

    gem 'annotations'

Or install it yourself as:

    $ gem install annotations

## Usage

Add the Annotations tasks to your Rakefile:

```ruby
require 'annotations/rake_task'

Annotations::RakeTask.new
```

This will add the following tasks:

  $ bundle exec rake -T notes
  rake notes                     # Enumerate all annotations
  rake notes:custom[annotation]  # Enumerate a custom annotation
  rake notes:fixme               # Enumerate all FIXME annotations
  rake notes:optimize            # Enumerate all OPTIMIZE annotations
  rake notes:todo                # Enumerate all TODO annotations

If you want to name the tasks something other than "notes", just pass the name you want to use into `RakeTask.new`:

```ruby
Annotations::RakeTask.new(:devnotes)
```

You can also set the default tag list when defining the task, using this block syntax:

```ruby
Annotations::RakeTask.new do |t|
  # This will add an additional 'WTF' annotation; it will be included in
  # `rake notes`, and a `rake notes:wtf` task will be added
  t.tags = [:fixme, :optimize, :todo, :wtf]
end
```

Once your `Rakefile` is set up, run the tasks to view your notes:

    rake notes

### Runtime options

**Filter by file extension:** Only display annotations for certain kinds of files. (Thanks for Gabriel Schammah for contributing this feature.)

    rake notes:todo ext=js,rb,coffee

## Roadmap

* Ability to set/limit the search path(s) for annotations (currently set to '.')
* Color output
* Standalone command-line tool (e.g. `annotations wtf todo --color`)
* More robust handling of different extensions/comment formats, plus the ability to easily add in new ones
* Test coverage!!

## Contributing

Fork the project, make some changes on a feature branch, then send a pull request.
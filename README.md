# Strigo GitHub class exercise examples

## Quick start

1. Create a `.strigo/config.yml` file in your exercises repository (or fork this repository).
1. Edit the `.strigo/config.yml` file:

   ```yaml
   ---
   classes:
     - exercises:
         # `file` is relative to .strigo directory
         - file: "../Exercise.md"
           title: "Title!"
   ```

1. Edit your class in Strigo and choose to fetch exercises from GitHub.
1. Done!

---

## Configuration file structure

- `classes` - A list of classes (required)
  - `class_id` - The ID of the class you'd like to fetch exercises for (optional if the repository only supports one class)
  - `exercises` - A list of class' exercises (required)
    - `file` - The path to the markup file (relative to the `.strigo` directory). Supported extensions are `md` (Markdown) and `rst` (reStructured Text). Any other extension should be overridden by the `syntax` field (see below)
    - `title` - The title of the exercise
    - `syntax` - Overrides the file extension as used in the `file` field (`md` / `md-extended` / `rst`)

---

## Main concepts

1. **Hello world**

   Just configure the order of the files, set titles and you're good to go.

   ```yaml
   ---
   classes:
     - exercises:
         # `file` is relative to .strigo directory
         # supported extensions are "md" | "rst"
         - file: "../hello-world/hello.md"
           title: "Hello!"
         - file: "../hello-world/world.md"
           title: "World!"
   ```

1. **Multiple classes in a single repository**

   You can configure multiple classes in a single repository, by defining class IDs for each class.

   ```yaml
   ---
   classes:
     - class_id: "<class_id_1>"
       exercises:
         - file: "../1.md"
           title: "Title 1!"
         - file: "../2.md"
           title: "Title 2!"
     - class_id: "<class_id_2>"
       exercises:
         - file: "../3.md"
           title: "Title 3!"
         - file: "../4.md"
           title: "Title 4!"
   ```

1. **Reusing exercises for different classes**

   There is no restriction on using the same file for multiple classes, or even using the same file multiple times for the same class.

   ```yaml
   ---
   classes:
     - class_id: "<class_id_1>"
       exercises:
         - file: "../1.md"
           title: "Title 1!"
         - file: "../1.md"
           title: "Title 1!"
     - class_id: "<class_id_2>"
       exercises:
         - file: "../1.md"
           title: "Title 1!"
   ```

1. **Markup syntaxes**

   You can use different markup syntaxes by using the `syntax` field for each Exercise

   ```yaml
   ---
   classes:
     - class_id: "<class_id_1>"
       exercises:
         - file: "../1.txt"
           title: "Markdown!"
           # `syntax` is optional
           # supported syntaxes are "md" | "md-extended" | "rst"
           # uses file extension as fallback
           syntax: "md"
         - file: "../2.txt"
           title: "Title 1!"
           syntax: "rst"
   ```
   
   Exercises with `md-extended` syntax will be treated as Markdown file with the following extended capabilities:
   
   1. **Duration**
      
      You can mention the expected duration in format `hh:mm:ss` anywhere in your Markdown exercise file:
      ```md
      Duration: 1:30:00
      ```
   2. Info block
      
      You can add informative blocks of type `Positive`, `Negative` or `Neutral` anywhere in your Markdown exercise file:
      ```md
      Positive
      : This will appear in a Positive info box.
      
      Neutral
      : This will appear in a Neutral info box.
      
      Negative
      : This will appear in a Negative info box.
      ```

1. **Relative vs absolute paths to images**

   Your exercises repository can have images stored within it. Fetching these exercises will upload the images to Strigo. If the image could not be accessed for some reason, we will replace it with a placeholder instead.

   Absolute image paths will not be affected, so if the image cannot be accessed, it won't show up for your students.

1. **Relative vs absolute links**

   Your exercises source files can have links pointing anywhere on the web. Clicking on the link will open a new tab and redirect to its destination. Local links will be replaced with absolute URL to the same location. Please make sure your users have access to the link's destination.


1. **Public vs private repositories**

   Both public and private repositories should be configured the same way. Please follow [Strigo's Guidelines](http://help.strigo.io/en/articles/4951906-fetching-lab-exercises-from-github) for more details.

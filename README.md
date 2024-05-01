# Strigo.io GitHub Managed Exercises Repository

## Quick Start Guide

1. Fork this repository or create a new `.strigo/config.yml` file in your existing repository.
1. Configure the `.strigo/config.yml` with your exercise settings:

   ```yaml
   ---
   classes:
     - exercises:
         - file: "../hello-world/hello.md"
           title: "Hello!"
   ```

1. In Strigo, configure your class to fetch exercises from GitHub.
1. Setup complete!

## Configuration File Schema

1. **`classes`**: List of classes (mandatory).
   - **`class_id`**: Identifier for the class, needed if managing multiple classes (optional).
   - **`exercises`**: List of exercises for the class (mandatory).
     - **`file`**: Path to the exercise file, relative to `.strigo` directory, supports `.md` and `.rst` (mandatory).
     - **`title`**: Title of the exercise (mandatory).
     - **`syntax`**: File syntax, if not inferable from extension (optional).
     - **`exercise_type`**: Either `lesson` (default) or `challenge` (optional).
     - **`scripts`**: Script settings (required for exercise type `challenge`).
       - **`file`**: Path to the challenge validation script file (mandatory).
       - **`lab_resource_index`**: Virtual lab machine index, starting from 0 (mandatory).

## Public vs Private Repositories

Both public and private repositories can be configured following the same schema. For detailed guidance, refer to [Strigo's Guidelines](http://help.strigo.io/en/articles/4951906-fetching-lab-exercises-from-github) for more details.

## Core Concepts

1. **Basic Configuration Example**

   Simple setup with exercise files and titles.

   ```yaml
   ---
   classes:
     - exercises:
         - file: "../hello-world/hello.md"
           title: "Hello!"
         - file: "../hello-world/world.md"
           title: "World!"
   ```

1. **Challenge Exercises**

   Set up validated lab exercises that include practical tasks and script-based validations.

   ```yaml
   ---
   classes:
     - exercises:
         - file: "../hello-world/hello.md"
           title: "Practical Challenge"
           exercise_type: "challenge"
           scripts:
             - file: "../scripts/challenge.sh"
               lab_resource_index: 0
   ```

1. **Markup Syntax Flexibility**

   Support for different markup syntaxes by specifying the `syntax` field.

   ```yaml
   ---
   classes:
     - exercises:
         - file: "../markup-syntaxes/markdown.md"
           syntax: "md"
           title: "Markdown Example"
         - file: "../markup-syntaxes/restructured.rst"
           syntax: "rst"
           title: "Restructured Example"
   ```

1. **Advanced Markdown Features**

   Incorporate features like duration, informative blocks, and Frontmatter metadata.

   ```yaml
   ---
   classes:
     - exercises:
         - file: "../markup-syntaxes/markdown-extended.md"
           syntax: "md-extended"
           title: "Extended markdown"
   ```

   And then in `../markup-syntaxes/markdown-extended.md`:

   1. **Duration**

      You can mention the expected duration in format `hh:mm:ss` anywhere in your Markdown exercise file:

      ```md
      Duration: 1:30:00
      ```

   1. **Info block**

      You can add informative blocks of type `Positive`, `Negative` or `Neutral` anywhere in your Markdown exercise file (old and new syntax, both supported):

      ```md
      Positive
      : This will appear in a Positive info box (old syntax).

      > aside positive
      >
      > This will appear in a Positive info box (new syntax).

      Neutral
      : This will appear in a Neutral info box (old syntax).

      > aside neutral
      >
      > This will appear in a Neutral info box (new syntax).

      Negative
      : This will appear in a Negative info box (old syntax).

      > aside negative
      >
      > This will appear in a Negative info box (new syntax).
      ```

   1. **Frontmatter**

      If your files have Frontmatter metadata set, it will be escaped:

      ```
      ---
      title: Exercise with Frontmatter
      author: John Doe
      email: john.doe@domain.com
      address: Some location
      tags:
        - tag1
        - tag2
        - tag3
      ---
      ```

1. **Relative vs Absolute Paths to Images**

   Your exercises repository can have images stored within it. Fetching these exercises will upload the images to Strigo. If the image could not be accessed for some reason, we will replace it with a placeholder instead.

   Absolute image paths will not be affected, so if the image cannot be accessed, it won't show up for your students.

1. **Relative vs Absolute Links**

   Your exercises source files can have links pointing anywhere on the web. Clicking on the link will open a new tab and redirect the learner to its destination. Local links will be replaced with absolute URL to the same location. Please make sure your users have access to the link's destination.

## Additional Use-Cases

1. **Multiple Classes in a Single Repository**

   Define multiple classes within a single repository by using class IDs.

   ```yaml
   ---
   classes:
     - class_id: "class1"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Class 1 Exercise 1"
         - file: "../hello-world/world.md"
           title: "Class 1 Exercise 2"
     - class_id: "class2"
       exercises:
         - file: "../markup-syntaxes/markdown.md"
           title: "Class 2 Exercise 1"
         - file: "../markup-syntaxes/markdown-extended.md"
           title: "Class 2 Exercise 2"
   ```

1. **Reusing Exercises Across Classes**

   Utilize the same exercises across different classes or multiple times within the same class.

   ```yaml
   ---
   classes:
     - class_id: "class1"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Reusable Exercise"
         - file: "../hello-world/hello.md"
           title: "Reusable Exercise Again"
     - class_id: "class2"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Reusable Exercise"
   ```

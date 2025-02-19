# Strigo.io GitHub Managed Resources Repository

## Quick Start Guide

1. Fork this repository or create a new `.strigo/config.yml` file in your existing repository.
2. Customize the `.strigo/config.yml` file with the lab resources and exercise configurations that suit your training needs:

   ```yaml
   ---
   classes:
     - lab_resources:
         - display_name: "AWS EC2 Instance"
           platform_type: "lab"
           image_platform: "linux"
           view_interface: "desktop"
           cloud_provider: "aws"
           aws_vm_definition:
             machine_size: "t2.micro"
             ami_region_mapping:
               eu-west-1:
                 image_id: "ami-0b32f4a77e48fcb24"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Hello!"
         - file: "../hello-world/world.md"
           title: "World!"
   ```

3. Log in to Strigo, navigate to your class settings, and configure the class to fetch lab resources and exercises from your GitHub repository.
4. Save your changes, and your setup is ready to use!

## Configuration File Schema

1. **`classes`**: Defines the training classes (mandatory).
   - **`class_id`**: A unique identifier for the class. This field is required if managing multiple classes within a single repository (optional).
   - **`lab_resources`**: List of lab resources for the class (optional).
     - **`display_name`**: Name of the lab resource displayed to learners (mandatory).
     - **`platform_type`**: Type of platform (mandatory). Possible values:
       - `"lab"`: Used for interactive labs.
     - **`image_platform`**: Operating system platform. Possible values:
       - `"linux"`
       - `"windows"`
     - **`cloud_provider`**: Cloud provider name. Possible values:
       - `"aws"`
     - **`view_interface`**: Interface type. Possible values:
       - `"desktop"`
       - `"terminal"`
     - **`aws_vm_definition`**: AWS-specific configuration.
       - **`machine_size`**: The instance type for the AWS VM, e.g., `"t2.micro"` (mandatory).
       - **`ami_region_mapping`**: A map of AWS regions to AMI configurations (mandatory). Each entry contains:
         - **`image_id`**: The AMI ID for the region (mandatory).
       - **`custom_username`**: Custom username for the AWS VM (optional).
       - **`custom_password`**: Custom password for the AWS VM (optional).
     - **`user_data`**: User data script for VM initialization (optional).
     - **`post_launch_script`**: Script executed after the VM launch (optional).
   - **`exercises`**: List of exercises for the class (optional).
     - **`file`**: Path to the exercise file, relative to `.strigo` directory (mandatory).
     - **`title`**: Title of the exercise (mandatory).
     - **`syntax`**: Syntax of the exercise file. Possible values:
       - `"md"`
       - `"md-extended"`
       - `"rst"`
       - `"html"`
     - **`exercise_type`**: The type of exercise. Possible values:
       - `"lesson"` (default)
       - `"lab-challenge"`
     - **`scripts`**: Scripts for exercise validation (required for `"lab-challenge"` exercise type). Each entry contains:
       - **`file`**: Path to the validation script file (mandatory).
       - **`lab_resource_index`**: Index of the lab resource to run the script on (starting from 0) (mandatory).

## Public vs Private Repositories

Both public and private repositories can be configured following the same schema. For detailed guidance, refer to [Strigo's Guidelines](http://help.strigo.io/en/articles/4951906-fetching-lab-exercises-from-github) for more details.

## Core Concepts

1. **Basic Configuration Example**

   Simple setup with lab resources and exercises.

   ```yaml
   ---
   classes:
     - lab_resources:
         - display_name: "AWS EC2 Instance"
           platform_type: "lab"
           image_platform: "linux"
           view_interface: "desktop"
           cloud_provider: "aws"
           aws_vm_definition:
             machine_size: "t2.micro"
             ami_region_mapping:
               eu-west-1:
                 image_id: "ami-0b32f4a77e48fcb24"
       exercises:
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
           exercise_type: "lab-challenge"
           scripts:
             - file: "../scripts/lab-challenge.sh"
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

1. **Navigation Buttons**

   Navigation buttons are clickable elements you can include in your exercises to help learners navigate the learning environment. They are used to take learners the correct lab resource and interface where they need to complete the task.

   Use the following syntax in your Markdown file:

   ```md
   [Button Label]({{ .STRIGO_GOTO_LAB_0 }})
   [Button Label]({{ .STRIGO_GOTO_LAB_0_TERMINAL }})
   [Button Label]({{ .STRIGO_GOTO_LAB_0_EDITOR }})
   [Button Label]({{ .STRIGO_GOTO_LAB_0_INTERFACE_0 }})
   [Button Label]({{ .STRIGO_GOTO_EXERCISE_0 }})
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

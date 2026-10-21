# Strigo.io GitHub Managed Resources Repository

## Quick Start Guide

1. Fork this repository or create a new `.strigo/config.yml` file in your existing repository.
2. Customize the `.strigo/config.yml` file with the lab resources and exercise configurations that suit your training needs:

   ```yaml
   ---
   classes:
     - lab_resources:
         - display_name: "AWS EC2 Instance"
           image_platform: "linux"
           view_interface: "desktop"
           cloud_provider: "aws"
           aws_vm_definition:
             machine_size: "t3.medium"
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
   - **`base_folder`**: Path to a folder, relative to the `.strigo` directory, whose contents are uploaded to Strigo together with the exercises (optional, mandatory if any exercise uses `syntax: "html"`).
   - **`lab_resources`**: List of lab resources for the class (optional).
     - **`display_name`**: Name of the lab resource displayed to learners (mandatory). Display names must be unique within a class, and are what identifies a resource from one sync to the next - see **Stable Lab Resources Across Syncs** under [Core Concepts](#core-concepts).
     - Each lab resource must contain **exactly one** of the two definition fields below. Which one it is determines what kind of resource it is - you no longer declare that yourself:
       - **`aws_vm_definition`**: An AWS VM configured inline, in this file.
         - **`machine_size`**: The instance type for the AWS VM, e.g., `"t3.medium"` (mandatory).
         - **`ami_region_mapping`**: A map of AWS regions to AMI configurations (mandatory). Each entry contains:
           - **`image_id`**: The AMI ID for the region (mandatory).
         - **`custom_username`**: Custom username for the AWS VM (optional).
         - **`custom_password`**: Custom password for the AWS VM (optional).
       - **`lab_library_item_id`**: Reference to an item saved in your lab library - a pre-configured VM or a cloud account. The library item holds the configuration, so none of the inline fields below apply. See **Using Lab Library Items** under [Core Concepts](#core-concepts).
     - **`cloud_provider`**: Cloud provider name (mandatory for inline VMs, ignored for lab library items). Possible values:
       - `"aws"`
     - **`image_platform`**: Operating system platform (optional, ignored for lab library items). Possible values:
       - `"linux"`
       - `"windows"`
     - **`view_interface`**: Interface type (optional, ignored for lab library items). Possible values:
       - `"desktop"`
       - `"terminal"`
     - **`user_data`**: User data script for VM initialization (optional, inline VMs only).
     - **`post_launch_script`**: Script executed after the VM launch (optional, inline VMs only).
     - **`platform_type`**: Deprecated - the resource kind is now derived from the definition field above. Still accepted for existing configurations; see [Deprecated Fields](#deprecated-fields).
   - **`exercises`**: List of exercises for the class (optional).
     - **`file`**: Path to the exercise file, relative to `.strigo` directory (mandatory).
     - **`title`**: Title of the exercise (optional, defaults to `Exercise <n>`).
     - **`syntax`**: Syntax of the exercise file (optional, defaults to the file's extension). Possible values:
       - `"md"`
       - `"md-extended"`
       - `"rst"`
       - `"html"` (requires `base_folder` on the class)
     - **`exercise_type`**: The type of exercise. Possible values:
       - `"exercise"` (default)
       - `"lab-challenge"`
     - **`scripts`**: Scripts for exercise validation (required for `"lab-challenge"` exercise type). Each entry contains:
       - **`file`**: Path to the validation script file (mandatory).
       - **`lab_resource_index`**: Index of the lab resource to run the script on (starting from 0) (mandatory). The index is positional - it points at the order the resources appear in under `lab_resources`.

## Deprecated Fields

These fields are no longer needed. Existing configurations that still use them keep working, so there is nothing you have to change - but new configurations should leave them out.

1. **`platform_type`**

   A lab resource's kind used to be declared explicitly. It is now derived from the configuration itself: an entry with `aws_vm_definition` is an inline lab VM, and an entry with `lab_library_item_id` takes its kind from the library item it points at.

   `platform_type` is still accepted with the values it always allowed, `"lab"` and `"library-vm"`, as long as it agrees with what the configuration describes. A value that contradicts the configuration fails the sync.

   ```yaml
   # Still supported
   - display_name: "AWS EC2 Instance"
     platform_type: "lab"
     cloud_provider: "aws"
     aws_vm_definition:
       machine_size: "t3.medium"
       ami_region_mapping:
         eu-west-1:
           image_id: "ami-0b32f4a77e48fcb24"

   # Preferred
   - display_name: "AWS EC2 Instance"
     cloud_provider: "aws"
     aws_vm_definition:
       machine_size: "t3.medium"
       ami_region_mapping:
         eu-west-1:
           image_id: "ami-0b32f4a77e48fcb24"
   ```

   One case does require removing it: a **cloud account** referenced from the lab library. Its derived kind is `cloud-account`, which was never a valid `platform_type` value, so the field has to be omitted rather than updated.

1. **`exercise_type: "challenge"`**

   An older alias for `"lab-challenge"`, still honored. Use `"lab-challenge"` instead.

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
           image_platform: "linux"
           view_interface: "desktop"
           cloud_provider: "aws"
           aws_vm_definition:
             machine_size: "t3.medium"
             ami_region_mapping:
               eu-west-1:
                 image_id: "ami-0b32f4a77e48fcb24"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Hello!"
         - file: "../hello-world/world.md"
           title: "World!"
   ```

1. **Using Lab Library Items**

   Reference an item saved in your lab library instead of configuring it inline. The reference is just a display name and the library item's ID - the item itself holds the configuration, and the kind of resource is taken from it.

   A pre-configured **VM**:

   ```yaml
   ---
   classes:
     - lab_resources:
         - display_name: "Pre-configured Ubuntu VM"
           lab_library_item_id: "507f1f77bcf86cd799439011"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Hello!"
         - file: "../hello-world/world.md"
           title: "World!"
   ```

   A **cloud account** - a real cloud account handed to each learner for the duration of the class:

   ```yaml
   ---
   classes:
     - lab_resources:
         - display_name: "AWS Sandbox Account"
           lab_library_item_id: "507f1f77bcf86cd799439012"
       exercises:
         - file: "../hello-world/hello.md"
           title: "Hello!"
         - file: "../hello-world/world.md"
           title: "World!"
   ```

   The two look identical on purpose: everything specific to the resource lives on the library item, configured in Strigo rather than here. For a VM that is its cloud provider, image and machine size; for a cloud account it is the cloud provider and region, the permissions learners are granted in the account, and any CloudFormation or Terraform resources provisioned into it.

   A single class can mix library VMs, library cloud accounts and inline VMs in the same `lab_resources` list.

   > **Note**: Do not set `platform_type` on a lab library reference. It is derived from the library item, and a declared value that disagrees with the item fails the sync - for a cloud account there is no value you could declare. See [Deprecated Fields](#deprecated-fields).

1. **Stable Lab Resources Across Syncs**

   Every sync re-imports the lab resources from scratch and matches each one against the class's existing resource of the same `display_name`. That match is what preserves a resource's identity, and with it everything already attached to it: running instances, cloud accounts assigned to learners, and the lab challenge scripts bound to it.

   In practice:

   - Changing anything **other than** the display name updates the resource in place. A resource can even change kind - from an inline VM to a lab library item, for instance - and still be the same resource.
   - Changing the `display_name` is a **replacement**: the resource under the old name is dropped and a new one is created in its place. Avoid renaming resources of a class that has already started.
   - Display names must be unique within a class. A duplicate name fails the sync with a configuration error.
   - Reordering entries under `lab_resources` is safe for the resources themselves, but `lab_resource_index` in lab challenge scripts is positional, so update those indexes to match the new order.

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

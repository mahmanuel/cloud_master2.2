# Lab 0: Setting Up

This lab is intended to get you set up with the project's infrastructure. Please go through all the steps, make sure that each one works, that you have access to everything described here.

## Groups
The groups (4-5 members each) are now ready, and available on [Group Spreadsheet](https://docs.google.com/spreadsheets/d/13t3jHczDKj8iqPPlSoGburstmO8k4A8WeUYHTwfIiP8/edit?usp=share_link). Please take note of the group you are in, and the members of your group. Remember, this is what you provided and shall be working with for the rest of the semester. If you have any questions about your group membership, please contact me as soon as possible.

I have also created group emails for each group. The group emails take the following format: `
Group ID (name), csc26-<group_id>@cit.ac.ug`. For example, if you are in group DAA, your group email is `
csc26-daa@cit.ac.ug `. In order to test this, let a member in the group send an email to the group email address and see if all members receive it. If you have any issues with the group email, please contact me. Also note that the spreadsheet above that is populated with your group and email information was used to create the group emails.

For better collaboration in the team, I recommend you create your own private repository on GitHub and add all your team members as collaborators. You can then clone the repository to your local machine and push all important data there. This is also a good place to keep your notes and write up for the project. To access GitLab (https://gitlab.cranecloud.io/), you can use your class username and password with the LDAP option selected.

## Create a CloudLab Account ([Link](https://www.cloudlab.us/signup.php)) and join the Crane Cloud project 

The majority of the project runs on CloudLab, for which you need an account. To create an account, please use your Group Email and use the Group ID (such as csc26-daa, csc26-dab, etc.) as the username. Upload your SSH public key file as you use SSH to  access the nodes in CloudLab (For now, just have one key for a member of your group). Click on `Submit Request`. I will approve your request within 48 hours. 

Let me better break this down into the field required:

### Personal Information
Username: `Group ID (name), csc26<group_id>` (e.g., `csc26daa`)
Full Name: `Group ID (name), CSC 26 <group_id>` (e.g., `CSC 26 AZZ`)
Email: `Group Email, csc26-<group_id>@cit.ac.ug` (e.g., `csc26-azz@cit.ac.ug`)

Affiliation: `Makerere University Kampala`

Password: `Your choice of password`
Confirm Password: `Same choice of password above`


You can complete the rest of the fields with the necessary information.

### Project Information
Select the option: Join Existing Project
Project ID: `CraneCloud`

After, you can then click on `Submit Request`.

A user verification email will be sent to the email address you provided (All members of the team shall receive this verification code). Please enter this verification code in the next page and click on `Verify`. You should then see a message that says `Thank you! Stay tuned for email notifying you that your account has been activated. Please be sure to set your spam filter to allow all email from '@emulab.net' and '@flux.utah.edu'`.

I will approve accounts as soon as I can, but it may take up to 48 hours. Also, I will only approve accounts that have followed the registration instructions to the dot. Once your account is approved, you will receive an email from CloudLab. You can then log in to your account and start using CloudLab.

## Getting Started

- Check SSH Keys
   - Go to `UserName` -> `Manage SSH Keys`. See if your public SSH key is included, if not, please upload the public key file again. 

- Change the default shell
   - Go to `Manage Account` -> `Default Shell`. Change default shell to `bash` or `zsh`. We highly recommended `bash` since most of our script are bash script.

## Start an Experiment

To start a new experiment, follow the steps below. Please make sure that you **do not create more than one active experiment per group**. Have one team member create the experiment and the other team member(s) will have access.  

1. Select a profile: go to your CloudLab dashboard's [`Project
   Profile`](https://www.cloudlab.us/user-dashboard.php#projectprofiles)
   page. Go to `csc2202-cloud-project` profile and click `instantiate` button.
2. Parameterize: select the lab you are working on.
   Click on `Next` to move to the next page.

3. Finalize: Name your experiment, select your group name as the Group, for example `DAA` or `AZZ`, and  choose the cluster you want to start your experiment. If you are curious about the hardware CloudLab provides, you can refer to this [page](http://docs.cloudlab.us/hardware.html). In case your request cannot be fulfilled due to resources being unavailable, we recommend checking the [resource availability](https://www.cloudlab.us/resinfo.php) page to make sure you select a cluster with enough machines. Each lab automatically constrains the hardware choice to machines that have the features necessary to complete it, so you cannot make a wrong choice here. 
4. Schedule: Optionally, select when you would like to start this experiment. If you want to start your experiment immediately, skip this step and click `Finish`.

It may take a few mintues for the experiment to start. Once the experiment is created, you should be able to view the information under the [`Experiments`](https://www.cloudlab.us/user-dashboard.php#experiments) page.

Note: Each lab will create none or more client machines (named `client[0-9]`) and one or more server machines (named
`server[0-9]`). You will deploy the applications on server machines and run load generators on the client machines in later labs. The exact number of client and server machines will depend on the lab you are working on. You can refer to the profile description for more details.

## Log into Experiment Machines

Click `List View`, and you will find SSH commands to access each node. You can start logging in once all machines in the experiment are `ready` and their `Startup` column says `Finished`. On the same tab, you can also reboot/reload your nodes if something goes wrong. You can also `Terminate` the entire experiment and start over from scratch.

Note that experiments automatically terminate after 16 hours (unless you picked a different duration when you scheduled your experiment). When this happens, all the data stored on the experiment machines is deleted. To retain data across experiments and share it with your team mates, you can push all important data to your cloned repository.

### Setting up the SSH Authentication Agent

The following sections and labs will require you to run many scripts. The scripts will setup various software packages across the machines in your CloudLab experiment. To do so, they will log into each machine using SSH. For this to work seamlessly, you need to setup an SSH authentication agent on your local work computer and make sure it is forwarded to the CloudLab machine that you have logged into. Depending on which OS and SSH package you use, the process will
be different. We provide quick instructions for popular combinations in this section.

**Mac OS.** Follow steps in this [link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)

**Linux and OpenSSH.** If it's not already running, you can start an SSH authentication agent by typing `ssh-agent` into any terminal. This will output a few shell commands. For example:

```console
simon@bigbox:~$ ssh-agent
SSH_AUTH_SOCK=/tmp/ssh-3NZIVp0q7Itp/agent.875946; export SSH_AUTH_SOCK;
SSH_AGENT_PID=875947; export SSH_AGENT_PID;
echo Agent pid 875947;
```

You should copy&paste these commands and run them in your terminal. This ensures that future runs of SSH within the terminal are able to find it. There are more permanent ways to setup `ssh-agent` across all of your terminals. Please refer to your OS documentation on how to do that.

Once `ssh-agent` is set up, you should then run `ssh-add` to add your SSH keys to your agent. This might require you to enter a few passwords. Once done, you can then run `ssh -A` to login to any of the CloudLab hosts and `ssh` will forward the agent connection to those hosts. This means that you and the scripts you'll run can SSH into other CloudLab hosts without you needing to re-enter SSH key passwords.

## Policies on Using CloudLab Resources

1. Before you start your first experiment, please read this [page](https://cloudlab.us/aup.php). 

2. By default, each experiment will expire in 16 hours. This is enough   for most runs. If you run out of time, you can request an extension via the `Extend` button on your experiment's CloudLab profile page. To request an extension, you need to provide a reason. I recommend you save your data and create a new experiment whenever you can. If you do have a need to extend the nodes, do not extend them by more than one day. **I will terminate any cluster running for more than 48 hours**.

3. Please terminate your experiment as soon as you finish an assignment. This will free up resources for other CloudLab users.
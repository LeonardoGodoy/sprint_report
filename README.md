
This project intent is to create a short report of your current sprint on Jira board.
That's done using atlassian api.

## The report

The output format is optimized for slack mesasges as follows:
![report in slack image](example.png)

This script's output for generating the report shown above:
```
> My great epic
 _Backlog_
 - Task yet to be picked up for someone.
 - ...
 _In Development_
 - Task being developed
 - ...
 _Deployed_
 - Task ready and shipped
 - ...

> Another epic feature
 ...

> Others
 ...
```

This is the content structure:

```
> [Epic summary]
 _[State summary]_
 - [Task summary]
 - ...

> Others (Missing epic tasks)
 _[State summary]_
 - [Task summary]
 - ...

```

## Usage

First, access this project folder after cloning it.
Then run the following command replacing your board_id and your personal auth token.

```sh
ruby report.rb [BOARD_ID] [AUTH_TOKEN]
```

[Here is a good and short article](https://medium.com/@prateek.bvbcet/how-to-access-jira-cloud-api-39c1bfc774ed) that goes through all the required steps for generating your **auth token**.

*Recomended*: In case you don't want your credentials in your shell history you can add an alias as follows:

```sh
alias sprint_report='ruby [YOUR_PATH]/report.rb [BOARD_ID] [AUTH_TOKEN]'
```

The report will be generated once you run it and copied to your transfer area.
This will be outputed to your console:
```
Identifying current sprint...
Active sprint: YOUR SPRINT NAME X
Requesting current sprint issues...
Report copied to your transfer area. Press ctrl+v/cmd+v to paste the results
```

Then you just need to paste it on slack and press cmd+shift+f for using makdown interpreter.

Enjoy it!

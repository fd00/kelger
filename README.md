# Kelger

Generate [yacp](https://github.com/fd00/yacp) summary for [repology](https://repology.org/)

## Usage

```
$ cd /tmp
$ git clone https://github.com/fd00/yacp
$ git clone https://github.com/fd00/kelger
$ cd kelger
$ bundle install
$ ./exe/kelger -i /tmp/yacp -o /tmp/package.json
$ cat /tmp/package.json | jq . | head  
  {
    "repository_name": "YACP",
    "num_packages": 2759,
    "timestamp": 1604410195,
    "packages": [
      {
        "name": "ACE",
        "version": "1.01",
        "category": [
          "Science"
$ 
```

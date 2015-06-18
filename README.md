# JVM-CALC 

A simple ruby script which enables the quick calculation of the JVM configuration.

TODO:
* More comments, comments, comments
* Make Class, define functions
* Error handling
* Make it a gem?

## Installation

Dependences: 
* Filesize ruby gem
  $ gem install filesize

Get the repo:
  $ git clone https://github.com/praymann/jvm-calc.git

## Usage

```ruby
~> jvm-calc.rb -Xmx6g -Xms6g -XX:SurvivorRatio=3 -XX:NewSize=1g
EdenSize   : 614.40 MiB
MaxHeapSize   : 6.00 GiB
NewRatio   : 2
NewSize   : 1.00 GiB
OldSize   : 5.00 GiB
SurvivorRatio   : 3
To/FromSurvivorSpace   : 204.80 MiB
TotalSurvivorSpace   : 409.60 MiB
```

```ruby
~> jvm-calc.rb -Xmx6g -Xms6g -XX:SurvivorRatio=3
EdenSize   : 1.80 GiB
MaxHeapSize   : 6.00 GiB
NewRatio   : 2
NewSize   : 3.00 GiB
OldSize   : 3.00 GiB
SurvivorRatio   : 3
To/FromSurvivorSpace   : 614.40 MiB
TotalSurvivorSpace   : 1.20 GiB
```

## Contributing

1. Fork it ( https://github.com/praymann/jvm-calc/fork )
5. Create a new Pull Request

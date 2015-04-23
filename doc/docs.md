### basic

#### ReverseFollowedByEach

Don't use reverse followed by each; use reverse_each instead

For example, rather than doing this:

```ruby
[1,2,3].reverse.each {|x| x+1 }
```

Instead, consider doing this:

```ruby
[1,2,3].reverse_each {|x| x+1 }
```

#### SelectFollowedByAny

Don't use select followed by any?; use any? with a block instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.any?
```

Instead, consider doing this:

```ruby
[1,2,3].any? {|x| x > 1 }
```

#### SelectFollowedByEmpty

Don't use select followed by empty?; use none? instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.empty?
```

Instead, consider doing this:

```ruby
[1,2,3].none? {|x| x > 1 }
```

#### SelectFollowedByFirst

Don't use select followed by first; use detect instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.first
```

Instead, consider doing this:

```ruby
[1,2,3].detect {|x| x > 1 }
```

#### SelectFollowedByNone

Don't use select followed by none?; use none? with a block instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.none?
```

Instead, consider doing this:

```ruby
[1,2,3].none? {|x| x > 1 }
```

#### SelectFollowedBySelect

Don't use consecutive select blocks; use a single select instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.select {|x| x > 2 }
```

Instead, consider doing this:

```ruby
[1,2,3].select {|x| x > 2 }
```

#### SelectFollowedBySize

Don't use select followed by size; use count instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.size
```

Instead, consider doing this:

```ruby
[1,2,3].count {|x| x > 1 }
```
### buggy

#### AssertWithNil

Don't use assert_equal with nil as a first argument; use assert_nil instead

For example, rather than doing this:

```ruby
x = nil ; assert_equal(nil, x)
```

Instead, consider doing this:

```ruby
x = nil ; assert_nil(x)
```

#### MapFollowedByFlatten

Don't use map followed by flatten(1); use flat_map instead

For example, rather than doing this:

```ruby
[1,2,3].map {|x| [x,x+1] }.flatten(1)
```

Instead, consider doing this:

```ruby
[1,2,3].flat_map {|x| [x, x+1]}
```
### rails

#### StripFollowedByEmpty

Don't use String#strip followed by empty?; use String#blank? instead

For example, rather than doing this:

```ruby
'   '.strip.empty?
```

Instead, consider doing this:

```ruby
'   '.blank?
```

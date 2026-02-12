Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015CFEB48F0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 10:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CB76B0005; Thu, 12 Feb 2026 05:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2CF06B0089; Thu, 12 Feb 2026 05:16:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C186B008A; Thu, 12 Feb 2026 05:16:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE2156B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:16:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 701F813B941
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:16:14 +0000 (UTC)
X-FDA: 84435399468.20.FFFD44E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B0A7A40004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:16:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OIARi67/";
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770891372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ptr9YhyqieOFU07U0sFzsooEykeq9u9MdL4hRJMZeA=;
	b=uyPPeQqlJ4Hmgh1xVeZlBQXpIhZbcZu3b0cDOOHOOUx1+ws67Pmis0ZJC+89O3IcjAEwQn
	d7B1kbOfdNhssyrjW1LMOen1W8FR7u7jXbJyMy9tmqIoHzr5wH+3X5fxZguwMcVkCQ/TCN
	Vr3VYJ0//z8H99W3Vn8HBWZ9IhjkXqA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OIARi67/";
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770891372; a=rsa-sha256;
	cv=none;
	b=EbiLBaHDVLEK9RXQmshN0+J9OFkfP3Pyo+q78kuIWFtG/SzTPTLHIuCxeU+GaVEpY7yPgE
	rajYPeaoPJCBM9MvY3vd7ObV9tbsPLHElJEbRxs8NnDwVRhh+QGnJKuMtSiN5i2Y44L7oI
	VTwEN3TIyJZFCIJXQwD2z/dGEtyDuWk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D6EB40B19;
	Thu, 12 Feb 2026 10:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C959C19422;
	Thu, 12 Feb 2026 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770891371;
	bh=Anw/zAKs/yWaaKeJqaGci5bM5iIQjct6iTbsy5dXriU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OIARi67/5AMasX93xPnqxJLX/xDN5MF1nk6kUsZuNE3cv3DR79RkQkLsdFaDZxY0P
	 tbLZSxzUEATMlPDPNElgUgOMyBK3sYY+n0g68rBh+QF//5+Qw9xEDiMKK8ySFcLgJs
	 f9Age7rUiu18MWt0UmYoJb8HYb5+ijnpiA1Ti+Pc2JIwpqLhS1BtYH1SVwgS0UgEIo
	 MO2AOSzDqXWe+Q9lsolLCfJQJ5fb8vOuqenkrOEXXERMc5HguXWN3eLIF28OpiPYUd
	 OMlf6F7BVKrggzngoQCcseBuwRFnbfSh+5hD2KzZ6+RYcKWyEpO38D0lCzIW6Sa3hN
	 NVUAIOpdZcJhA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, Daniel
 Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
 <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
Date: Thu, 12 Feb 2026 11:15:58 +0100
Message-ID: <87y0kytggx.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: rgics7nqzhkba1kjrrpfpoietgqu6x1c
X-Rspamd-Queue-Id: B0A7A40004
X-Rspam-User: 
X-HE-Tag: 1770891372-933670
X-HE-Meta: U2FsdGVkX1/1qU2wElVrdlTgzjpNTPWF5argaqX037+VP2GGfC1YXV6No59p3gQCO1v9DabSZXjpFb5VwVhE+BtFTCS+IuK7tJDI+Vg4qp8akRAIRIGidMkN5IVLwJ2lqelfiFNqJTo/dKhi6P6C0cIcsFGOptJ4PgJVJNk5+kfdykzjCvyW5e1PJ4Lxh9WVILpWO5U2amqoiHTTv83i/JK4lRXEyw4Y1H0E6dw63f/2GyzI7X8BDyj/sf7tDA50oSvFBmvabNUnm1UB0u5eRYC9V1WXTLc7qXCkpqyNx9VB+uyaJjETXZl0TnZisDu3sIuCRh1LD93QvYySTYF92tARSKTyk2G8siF6QqBOugZUNwidCKbtI2t5P8AqW3iIYi00O7SkNaYolawVJKtQ36ApeXLfESYu3/HW3DdkOy3bLq3xF3ubJutG2sVdEYdARMpNmpL8q/c9eq++kDAJKvv1hc3J7RN0sHlETW/XLv0xzugpxR4qW+qmEc50PjFwximKmVgb68WVh2jl7t3hRq/faPUPK0MUQZdSzcZjtN3KG9MMfcQ9lrPPFSpaYOChsa7eJLMofa2xMssO17pQeE4m5SCrHMFxxzHm2p7WMmD4agtH9qEb/Wl/L8Jem6lkCXEBAaDpAYn3dmRrhzwrdbY+c8qMbzASLr44C7+bsdPrbbyWfPDzksbeW0xH6+d7BcFv0zjXUYotERuLz4m3sKByp/CnUUn4bEQ9FvlYoJ3zMg2Alwsc8JoEj25Kc9XVymDZwbS4Mr/RaSeQB0vZP7VHLqkufoELHYZZ4mobUAt1muPVyAMf4f4La+D7qt0cQXy4Cztvr1FGRHlTjfyL1/SCMoewiRD8LA7oLs8qcScJQPg7YkqcV/a91/qKzPpc6ZROV3m1j2O3EwikB5R9LXi4LhD1Mm0N435UpK2nlAtxViulnD6Z6uPw9znCS9cjhRPGeBCkDTjLOutJS+R
 elo0BstP
 GOnifYkgD2orEnHljAgGpj6M6GiWqNTDNKpda14enAofucXKdC2fXhhUfZnb8qdxGvuMT4tsk/V4thY+HgA06u0iVmXweWrQTkJO/MgSD0k9eE5MjSma5FNBOT+44mT1tjxx61aPGnBmgHP3m/01daXu4ECoG27ddorOtJR7JkuGSIV8HjYnpswa4SVPYlqS+p7640jGkUBNrdQ/4/PfuzvZ9cc8G9/zGrC8bdzeJke/7TjEDBxIAFL9ii3/Cxvu09so/6U4p1te4M9tpB/xnomdmHa5HWv/5+aKVHo44/aiGneSV5x24nm5sZpS0CDY1lLUomNqQVWIEhSnGcfyc2jPJkUinzGGAj1p0V3jOFlsPvcCTHbrugHuqMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Liam R. Howlett" <Liam.Howlett@oracle.com> writes:

> * Andreas Hindborg <a.hindborg@kernel.org> [260211 02:41]:
>> "Liam R. Howlett" <Liam.Howlett@oracle.com> writes:
>>
>> > * Andreas Hindborg <a.hindborg@kernel.org> [260209 14:38]:
>> >> Add a convenience method `contains_index` to check whether an element
>> >> exists at a given index in the XArray. This method provides a more
>> >> ergonomic API compared to calling `get` and checking for `Some`.
>> >
>> > I think this is going to result in less efficient code for most uses.
>> >
>> > Most users use the results returned, not just checking if there is or is
>> > not a value.  So if you find the value an xarray state and then just
>> > throw it away and find it again, it'll be less efficient.
>> >
>> > If there are users that do use the xarray to just check if something
>> > exists or not (which there probably are?), then it should be in a
>> > wrapper for that code and not the generic API.  Otherwise we will have
>> > users pop up to use this method when they should not.
>>
>> I agree in that I would prefer matching on the result of a lookup and
>> using that result. This is not always possible due to a limitation in
>> the current implementation of the borrow checker. Please see my response
>> to Tamir [1], it has all the pointers.
>>
>> Since we cannot use a match statement in certain situations, we have to
>> fall back to something that does not borrow from the collections, like
>> `array.get(index).is_some()`. I would argue that
>>
>>   if array.contains_index(foo) { ... }
>>
>> is easier to read than
>>
>>   if array.get(foo).is_some() { ... }
>>
>> And I don't think `array.contains()` is going to have worse codegen than
>> `array.get(index).is_some()`.
>
> This is probably my lack of rust knowledge...
>
>
> My concern is around API usage.  I am concerned people will use xas as a
> throw-away lookup with this API and cause more walks of the xarray to
> the same location.
>
> In the normal API, we have lookups like this; you take a lock, look
> something up, drop the lock and return it.  Since the life cycle of the
> stored information is outside the scope of the xarray, the user is
> dependent on the entry being stable by some other means after the xarray
> lock is dropped.

As discussed elsewhere, the current Rust XArray API only has fully
exclusive access, no reader/writer separation.

After a lookup the returned object is bound to the lifetime of lock. So
you cannot drop the lock while holding a mutable reference to something
in the collection, and the "other means" part of your paragraph is
automatically handled in Rust.

> In the advanced API, we do more within the locked area, usually.
>
> Usually, applications don't just print out there is a value, they do
> something with it.  So I would expect a real example to be something
> like (this horrible psudo-c/rust mangled mess):
>
> let entry = array.get_mut(foo);
>
> if (entry.is_some()) {
>         /* do something with entry */
>         send_to_party(entry);
> } else {
>         /* deal with it not existing */
> }
>
> What I don't want to do:
>
> if (array.contains_index(foo)) {
>         entry = array.get_mut(foo);
> } else {
>         ...
> }
>
> Where contains_index(foo) sets up an xas, walks to the location, returns
> the entry (or not) and then translates into a boolean.. then if it's
> true we set up another xas to walk to the same location.
>
> That is, the worst code gen would come from this:
> if (array.get(foo).is_some()) { array.get_mut(foo).. }

You are completely right, this causes two walks to the same location,
which is not great.

> From what you said here and the link, you are saying we need to do this
> in certain situations due to rust's borrow checker and the lifetime, but
> I cannot see why we would need to walk the xarray twice from the example
> provided.

Let me try to explain with an example using user space Rust. Consider a
situation where we have two two key-value mapping data structures. Since
we are in user space, I'll go with BTreeMap from the standard library,
but it could be XArray in the kernel.

If we want to implement a transaction across these two KV maps, we
probably need to take a lock to get mutable access to them. Let's
represent this with a `struct Maps` that has two fields `a` and `b` for
these two mutable references:


  use std::collections::{
      BTreeMap,
      btree_map::{Entry, OccupiedEntry},
  };

  type MapType = BTreeMap<u32, u32>;

  struct Maps<'a> {
      a: &'a mut MapType,
      b: &'a mut MapType,
  }

Now we have two locked data structures and we can implement our
transaction over them. Let's say the algorithm is the following:

 - Given a key, if that key exists in map A, return a mutable reference
   to the value for that key in map A.
 - Else, move the key and value for the lowest ordered key from map A to
   map B and return a mutable reference the that value in map B.

My first attempt at implementing this algorithm would be something like
this:

  fn transaction_impl1<'a>(maps: &'a mut Maps, key: u32) -> &'a mut u32 {
      if let Entry::Occupied(o) = maps.a.entry(key) {
          o.into_mut()
      } else {
          let value = maps.a.first_entry().expect("Not empty").remove();
          maps.b.entry(key).or_insert(value)
      }
  }

However, this does not compile.

  error[E0499]: cannot borrow `*maps.a` as mutable more than once at a time
    --> src/main.rs:51:21
     |
  47 |   fn transaction_impl1<'a>(maps: &'a mut Maps, key: u32) -> &'a mut u32 {
     |                        -- lifetime `'a` defined here
  48 |       if let Entry::Occupied(o) = maps.a.entry(key) {
     |       -                           ------ first mutable borrow occurs here
     |  _____|
     | |
  49 | |         o.into_mut()
  50 | |     } else {
  51 | |         let value = maps.a.first_entry().expect("Not empty").remove();
     | |                     ^^^^^^ second mutable borrow occurs here
  52 | |         maps.b.entry(key).or_insert(value)
  53 | |     }
     | |_____- returning this value requires that `*maps.a` is borrowed for `'a`



The `into_mut()` on line 49 captures the lifetime of `o`, and because the
value is returned from the function, it must live for `'a`, which is
till the end of the function.

As far as I understand, this is a borrow checker limitation. It is easy
for us to look at this code and decide that the borrow on line 51 will
never alias with the borrow on line 49.

If we change the code so that we do not capture the lifetime of the
returned object across the if/else, the code will compile:


  fn transaction_impl2<'a>(maps: &'a mut Maps, key: u32) -> &'a mut u32 {
      if maps.a.contains_key(&key) {
          maps.a.get_mut(&key).expect("Key is present")
      } else {
          let value = maps.a.first_entry().expect("Not empty").remove();
          maps.b.entry(key).or_insert(value)
      }
  }

But now we do two walks in `maps.a` in the taken path, which is not efficient.

>
> And making it easier to do this could result in a lot more users
> doubling xarray walks without realising that it's a bad idea (unless
> it's this special case).
>
> ...
>>
>> [1] https://lore.kernel.org/rust-for-linux/20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org/T/#m95fb90870c511491f4f487dbf852c689cd0733f4
>>
>
> I have trouble following 'the taken arm' in your link.  I think you mean
> one of the branches based on the existence of the entry, but I don't
> know which is the 'taken' and how 'self' is out of scope.
>
> Other links off the above link seem to indicate it is a problem with the
> rust borrow checking hitting a false positive.
>
> It seems we need to look up things twice to work around the false
> positive - or implement something like get_or_insert()?
>
> Or, wait for the new checker to be released - but that doesn't fix all
> the false positives, just this one?
>
> So, do all users of the xarray suffer from this false positive?

Not all users will suffer from this. The following code compiles fine:

  fn transaction_impl3<'a>(maps: &'a mut Maps, key: u32, value: u32) -> &'a mut u32 {
      if let Entry::Occupied(o) = maps.a.entry(key) {
          o.into_mut()
      } else {
          maps.b.entry(key).or_insert(value)
      }
  }

This is valid because the lifetime captured by `o.into_mut()` is not
used on the other match arm.

I hope this helps clarify the situation.


Best regards,
Andreas Hindborg




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE77CD8CA7
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DDA6B0088; Tue,  9 Jun 2026 04:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDE16B008A; Tue,  9 Jun 2026 04:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD626B008C; Tue,  9 Jun 2026 04:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C20B6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:38:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D196DC1A58
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:38:34 +0000 (UTC)
X-FDA: 84859722948.28.448E564
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3DBD18000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:38:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gvDMxOC8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQXVqtwbaiH3RdANsHmD5OpcmoL/HseiMLAA07zsWGo=;
	b=zAGYtWmpg6G1bafDQOzXu+zdA4YSOXYFOY5Iu2NuDp5lUHXQ0d+o5S0URgeLolQp9jSbiT
	iyPLd8P9CwBEbdC0TaJmRdyjzDUGKHGeNWqeL+aSZzZkgDvL/1ITPf0Js+v97Q5uB2DzAa
	3nNSXIau+CGWs3SQFbL0zUrvMM6Dmog=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gvDMxOC8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994313;
	b=1QVNDfx/NVxTdIMZzlwyDoC75mamkM9rnH+GHclWQ1af7uZdjvcry4XdxBlWr8DNe5hG5b
	JD9rCJ0p0/sOZuma2Ew+XuH0J7KWyQsExrLmElIdYjnlYomtHVHb9a2T1EAGtGrO6t6B3a
	Qa5C26WkqJKNpLCVCXScyliXo6S1GmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97EBC43CAA;
	Tue,  9 Jun 2026 08:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABACE1F00898;
	Tue,  9 Jun 2026 08:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780994312;
	bh=PQXVqtwbaiH3RdANsHmD5OpcmoL/HseiMLAA07zsWGo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gvDMxOC8kImibkCM1GWRK1A+k/GFOPcuZueCAaoaJBtkqW2kOAiEn1EJAenzt/4Gt
	 4W+lHKG9U7eoNfU9WWrHX8FJoR9tb40MGpxutjMpmtTKc9BPx/3CGvDmN3RozS51cW
	 QoCS9ZHdJMj+8X4pbfuDDI8iz/cuKJD5onBI45SY3xEA79Pk/GJV2QqXwk6KTGhoMR
	 ZGbJrNMlrEFj6oguklZQQqNBbf4cTZviIR2ybBK7caod/lSR5O1wMtjkwqfudX8ZyS
	 1XkFMXvFBorG8OIJyLzFqw8Pl931gCL6RQeklEprPKTd4LgpD+WSKBynFQ5tRu4fY3
	 Eg3HXaI2LdqBQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Tamir Duberstein <tamird@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Daniel Gomez
 <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 03/11] rust: xarray: add `XArrayState`
In-Reply-To: <178067251345.96312.12627213045914595867.b4-review@b4>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
 <178067251345.96312.12627213045914595867.b4-review@b4>
Date: Tue, 09 Jun 2026 10:38:13 +0200
Message-ID: <87ldcoglca.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zmnte3q9h6eng355io3xa1wszopeyejx
X-Rspamd-Queue-Id: 3DBD18000A
X-HE-Tag: 1780994313-50806
X-HE-Meta: U2FsdGVkX18idc2K+AvnflBs5jqJfWwJpGzBRZoTbsXoEFshkFM0ZxmAhU1kwBM4Lq17JYyTHpDXsIpjSvl54JPrB5LZwgZxtzoxmSDXu+69p09Nr7dWVtSnj2c3za+3m9jD20+7dBBKxzG9XkRajiZaWZSHEoQkqRJSz3RYA1r3wqpfPwYK3H6gAiddFDwf0063wcs3+DMrktl08e/GAZF9r5gJ8D4Ox6wC3pLnkuNnN2uEMUAcLha8QG2Ow1DBaNQ+/FOZpyObFmOcwQfdy3E/tBqIN6ntsPYkv6dmMPfJFGi12Moeu5qKjaWyTkqerwp0sphIEE9H2u/Fn4w3K+rPFTFZcOWPTwBWISQGwfMbmXYsw9eS+5shOn2Km/LJ5a3QDYCdHjP0eTTIUGi+NiJ1tfpu6BxpWR2zZy4lWMq6wqAJ7NSOic7vA8ljIiyN/AnPJhZubV6cpUPw6pF68Db5xu/363/LyxsVTC/c4KFDSC5Ec420YIAG0p4LG41cBylM+oARyE1QxENai1Ls+9QkwLAPZHQpCQbJc7V+yZx6+MJoaG25cbL0qAd6shKJ0p0fT7b+zldl5AOcKWnnbz6hYZ7aVeYw2o+sWjp+GNbbcDRjPJ3TcXZ96c42LOjC1t0gQ9CgLAWcL6nJEkAxbyBtI44Bg5n7a0JOtOlBCB85OBprTkQLIhigXtKdWGThh4FSOg7blA4KKjhZrkN0zpeWgevg1dUquTXwTqi5a52FOWQ6fMPbZDEzTEjAQvugWYAkU/o9nabLTsn4o5HA24PrE24EaS0UI6AQX+1Rg5RHZmkVHQx6d2xuD2JEKtTqtK9Nw+wA2LxYayRRpNEpMXY0fifJOgmNy572novkoLYJGA6N1hI3abnbKutjz0SlI6LS6VUyh9ku0+lAOO5KVFpp9rKpCAbYApXtrC0g+zP9nravlV19xiFbMwglK4PdJZTYnYHPmypREVvYc1f
 RcZ02//5
 LStf177Od3bgW/2TEy3CW1Z5Rlft072aVE3BWo00Ks5bZD/USqrsV6Db77waZkMCY3q4igcZIp2UTvuaidXrcxYMOx2sYzzQCzBSixQk2TOVFAyg0ncqjNlDEiUMPcAZ5losky+4GFL1SJeLYDjFhj7PyG6dxWLdYuuV6KziIA6eWWszj58cSzSFxFIS5puJp0gyxvhEvaozubBNpPA5FcM3CCYR1Hx0S6ZNiuNkS8q7bINjGTnbWXo/GR8K0U1uO+f/j9SDfAzmQpX1cc0Ntv5mKBSYhXCsPdicQ4uyr3wjMNhMPkKu+WS0MOj60tbdRh7MVn/SDh+mm/ana+ypfTS7NMBXzkQ01DEXA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@kernel.org> writes:

> On Thu, 04 Jun 2026 21:58:09 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
>> Add `XArrayState` as internal state for XArray iteration and entry
>> operations. This struct wraps the C `xa_state` structure and holds a
>> reference to a `Guard` to ensure exclusive access to the XArray for the
>> lifetime of the state object.
>> 
>> The `XAS_RESTART` constant is also exposed through the bindings helper
>> to properly initialize the `xa_node` field.
>> 
>> The struct and its constructor are marked with `#[expect(dead_code)]` as
>> there are no users yet. We will remove this annotation in a later patch.
>
> The review of this patch in v3 requested the next patch be absorbed into
> it.

I must have missed that.

>
>>
>>
>> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
>> index d54942aeb201..6d0d4905004a 100644
>> --- a/rust/kernel/xarray.rs
>> +++ b/rust/kernel/xarray.rs
>> @@ -299,6 +302,67 @@ pub fn store(
>> [ ... skip 17 lines ... ]
>> +impl<'a, T: ForeignOwnable> GuardRef for &mut Guard<'a, T> {
>> +    type Value = T;
>> +    fn xa_ptr(&self) -> *mut bindings::xarray {
>> +        self.xa.xa.get()
>> +    }
>> +}
>
> I'm having a hard time understanding the need for this trait, and it is
> not described in the commit message at all. How is this different than
> using Deref? `&mut T` has a blanket `Deref<Target = T>` impl.

I needed `XArrayState` to be generic over `&Guard<'a, T>` and `&mut
Guard<'a, T>` with ability to obtain the raw xarray pointer through the
guard, and ability to name `T`. I did not consider just using `Deref`,
but we can do that. The bounds on the impl block become a bit more
complicated, but I guess that is fine. Here is a diff (against head of series):

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index cbb16368c2ca..f5a499c23778 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -551,27 +551,6 @@ pub fn insert_entry<'b>(
     }
 }
 
-/// A reference to a [`Guard`], either shared or mutable, that exposes the
-/// underlying xarray pointer and the value type stored in the array.
-pub(crate) trait GuardRef {
-    type Value: ForeignOwnable;
-    fn xa_ptr(&self) -> *mut bindings::xarray;
-}
-
-impl<'a, T: ForeignOwnable> GuardRef for &Guard<'a, T> {
-    type Value = T;
-    fn xa_ptr(&self) -> *mut bindings::xarray {
-        self.xa.xa.get()
-    }
-}
-
-impl<'a, T: ForeignOwnable> GuardRef for &mut Guard<'a, T> {
-    type Value = T;
-    fn xa_ptr(&self) -> *mut bindings::xarray {
-        self.xa.xa.get()
-    }
-}
-
 /// Internal state for XArray iteration and entry operations.
 ///
 /// `R` is the borrow held on the guard: either `&Guard` for read-only callers
@@ -582,12 +561,12 @@ fn xa_ptr(&self) -> *mut bindings::xarray {
 ///
 /// - `state` is always a valid `bindings::xa_state`.
 /// - `state.xa` aliases the xarray reachable through `guard`.
-pub(crate) struct XArrayState<R: GuardRef> {
+pub(crate) struct XArrayState<R> {
     guard: R,
     state: bindings::xa_state,
 }
 
-impl<R: GuardRef> Drop for XArrayState<R> {
+impl<R> Drop for XArrayState<R> {
     fn drop(&mut self) {
         free_xa_alloc(&mut self.state);
     }
@@ -611,9 +590,13 @@ fn free_xa_alloc(state: &mut bindings::xa_state) {
     }
 }
 
-impl<R: GuardRef> XArrayState<R> {
+impl<'a, R, T> XArrayState<R>
+where
+    T: ForeignOwnable + 'a,
+    R: core::ops::Deref<Target = Guard<'a, T>>
+{
     fn new(guard: R, index: usize) -> Self {
-        let xa_ptr = guard.xa_ptr();
+        let xa_ptr = guard.xa.xa.get();
         // INVARIANT: `state` is initialized to a valid `xa_state` whose `xa` field aliases the
         // xarray reachable through `guard`.
         Self {
@@ -656,10 +639,10 @@ fn status(&self) -> Result {
 
     fn insert(
         &mut self,
-        value: R::Value,
+        value: T,
         mut preload: Option<&mut XArraySheaf<'_>>,
-    ) -> Result<*mut c_void, StoreError<R::Value>> {
-        let new = R::Value::into_foreign(value).cast();
+    ) -> Result<*mut c_void, StoreError<T>> {
+        let new = T::into_foreign(value).cast();
 
         loop {
             // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
@@ -686,7 +669,7 @@ fn insert(
         .map_err(|error| {
             // SAFETY: `new` came from `R::Value::into_foreign` and `xas_store` does not take
             // ownership of the value on error.
-            let value = unsafe { R::Value::from_foreign(new) };
+            let value = unsafe { T::from_foreign(new) };
             StoreError { value, error }
         })
     }
---


Best regards,
Andreas Hindborg




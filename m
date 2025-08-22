Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B51CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364178E00B1; Fri, 22 Aug 2025 10:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BE28E009D; Fri, 22 Aug 2025 10:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279388E00B1; Fri, 22 Aug 2025 10:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3EC8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:13:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA7801DA810
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:13:51 +0000 (UTC)
X-FDA: 83804587062.20.79FBAE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E761D8000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:13:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IpLlZ7W+;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755872030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMi7J1QR6W3/gcyM30+enHbGJh4rShyDF4HtA89El6s=;
	b=CHHrgk49kLRKhLe+pe2tOyvQNOI5Uf6/x8vFq4WIQSTkIV0l4MFE9QzhsF0ZyF2z0/Sxi2
	MTwtMOEPb9SWaDTxQk3ZnQR1W3lBFESBoDk2mXLxqbP5pvxI98tayiD3cnNPLip9h8anON
	4oTRf4sZWJn0dpOjl0WARKiqsALa0gw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IpLlZ7W+;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755872030; a=rsa-sha256;
	cv=none;
	b=MumMB1xPFAd+j/s/N9W8fphcueAMMyec2Rh7zsGpwuZ6b4J9HM0VJhaSdOfo7GmJIWx52z
	kZNXDvNiRaWZ49YQhT663QknqLRssiFb/cLNFQW5tYy7ygh4niY2pZr64oduL5H+WJgM3v
	mkanQitnGuhtHGlUbBiHRs4If5IYlnc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B0E744E89;
	Fri, 22 Aug 2025 14:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21D3C4CEED;
	Fri, 22 Aug 2025 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755872028;
	bh=gkGj9UWuXL3nI8EdViAz29uJOXaZrL/MrAfy4WjmCY0=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=IpLlZ7W+4YplB3G6RYJsjQrmGAPRW4BoWjqVQnLVt9SLvkUQIF/pdGgfpjiGHpoOM
	 Rdnt1feqFSB2rtl8OV5EWZGTwC4xWZZsjkS6Y/QiHDaGS0wubFduuk9Ws1HU9/slul
	 0ijRMtxTR+ufUZDtwrErlJ+Nv9MC6tawd/MYXVOgLnEvRBCKxjb8jiOHzQ64IbBRwJ
	 CY+MrI6afrAZV5LuFF8dpBQ0duWEHvS3LU1G4akTzBuI4PRBOdQf5gqwO0lEGMZJD0
	 jfGCg2A51/fJMCEs2Yt6owosiulzUFE2FIwdwDKNqJXuElWVptbFe52TuPo2wrRqCO
	 JSZ9H4H1Rz/JQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Aug 2025 16:13:43 +0200
Message-Id: <DC90ONOZLKAZ.35P6HOCCAIPW1@kernel.org>
Subject: Re: [PATCH v3] rust: zpool: add abstraction for zpool drivers
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor Gross"
 <tmgross@umich.edu>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry.ahmed@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 <linux-mm@kvack.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250822133935.674282-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250822133935.674282-1-vitaly.wool@konsulko.se>
X-Rspamd-Queue-Id: E761D8000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hn6jxke3n3o3fozibzkmqdbwiru9tcj1
X-HE-Tag: 1755872029-903808
X-HE-Meta: U2FsdGVkX1/L5iW9Ff8Xj16DbFr8eBPjH0ndaCf6t/dUDce45VHz/T2nPl7cBgjS3i4DXD1zrhn+el2lTyiZGvUCJHN3JwyfDIe/2aCIpTsaRxhtyp0dbDdUn15cGGoHxGloDmzpCGEJK5rrf6pb0U0VcCQGenZS8KzBzcOBOcTQX4q2AIBPp3r8M7V2F42gKHrt74sV17EC+uUqbBFo9cyFAZDnwy+YjrmLzB92Na2LxVn8DE4OnYBzWeEnbxk7r1Q25fBjO4KphBF3R7fDickSY+QL+2+ZVRFRuv278CyDzQtyaJ/uCIXnDdvKmYDaJJ+bEPtueYqv/VzXs5KYk3HjovlbFBcec4AasHnnE/eyPHHUluHLQTWtWpbGALbi8e3LhUs2EEMIu+6nVkN63VsIDL48+hIzHwAcAxyzkwW0nWaM5+56cTQkq5zJEMMT9aPv9axcorDgCzXZD1httbn5M9rX+MMAay/oJhueMtK3bbZrKCK7oG3LTolG7xprnj1xDs22uNHmyTkBd9sph3k2xLcUettvQXtkXoJo60SR4ItFnSa8LW8ve6xyiiDG7ou2cNQ/Tb0onnfFCn2JUY2w0uo6NMNVbRMf5bYMKRkD4eccjezsXiCNIqwYHtTVJkBL1dLbyZZhtLRY25+ZO0ld8doNCQLbFoMOhAiYbAHIfWNUnlJc5yx+Am7HZp5ol4MT+frf7ZhpOmPxeNjaEx9kbOjLNndN+fLxvRIZw0g/vRlmR4ol/nEJMA44yydsVAQL/afkN6RUT4iQMlfYXNjvX8PVLrDhGO/oZEJp+nmRIhR0oo+/tXq9gvuY1nXggSjI9j/3YO4JwSLXwICK7Zxp0Fjh02/hEJd3RHibrYdbYZBhed26AgUsfEBrxB+lX5iHJVcTdOqBF8si/V22aIDtlCwTkQHBGLt/ZhNeHbJttETSyACm2gUUJ7gsW6EhV6lnHWtjbuow52mhpQo
 3ITplVuf
 9jOcrdcDtuTTY8XnLV5VHe3IWOm/rnQznAkAJBe5RDRR8DnLG0hSCip/Yg03R8PIS6kJh4izLAgHcAOqaGffd0PNf6CNaMQNRKtoM3UyW3jRopbD87ZY9Ne0kEQvyi3wxaDBsg2G20X5ORQSQd4Wr57PXvYHUZmOEWtEn3bwQlV+tL3oYH1jLWhNkdFMmr/xgq+suGtmmXQbqk3dD5pnIxBL5jjvmd9npBTzEnXq8Sc9uMVx4ACuZkAZjG+xCu5HQjdh3t3O+rc0RdP67b4dSnV0a2GmffmBKrJDj19jfb1z+izvJLeyTxhLAqVTGyLwHTjUzl337D6K0gJ0hmdm7LqMhce84dOThaQaUYJoK6zEqVjkWRTWr/NG+ek5a6WLMkDgSIO59sV0HE0vws6KH0k9e2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 22, 2025 at 3:39 PM CEST, Vitaly Wool wrote:
> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
> index b39c279236f5..0fec5337908c 100644
> --- a/rust/kernel/alloc.rs
> +++ b/rust/kernel/alloc.rs
> @@ -41,6 +41,11 @@
>  pub struct Flags(u32);
> =20
>  impl Flags {
> +    /// Create from the raw representation
> +    pub fn new(f: u32) -> Self {
> +        Self(f)
> +    }

I didn't notice this change before.

This function should be crate private, called from_raw() and document that =
the
given value must be a valid combination of GFP flags.

Please also make the addition of alloc::Flags::from_raw() a separate patch.

> +/// # Example
> +///
> +/// A zpool driver implementation which does nothing but prints pool nam=
e on its creation and
> +/// destruction, and panics if zswap tries to actually read from a pool'=
s alleged object.
> +///
> +/// ```
> +/// use core::ptr::NonNull;
> +/// use kernel::alloc::{Flags, KBox, NumaNode};
> +/// use kernel::zpool::*;
> +///
> +/// struct MyZpool {
> +///     name: &'static CStr,
> +/// }
> +///
> +/// struct MyZpoolDriver;
> +///
> +/// impl ZpoolDriver for MyZpoolDriver {
> +///     type Pool =3D KBox<MyZpool>;
> +///
> +///     fn create(name: &'static CStr, gfp: Flags) -> Result<KBox<MyZpoo=
l>> {
> +///         let myPool =3D MyZpool { name };
> +///         let mut pool =3D KBox::new(myPool, gfp)?;

Why mutable?

> +///
> +///         pr_info!("Created pool {}\n", pool.name);

I think this print is unnecessary.

> +///         Ok(pool)
> +///     }

Please add empty lines between functions.

> +///     fn destroy(p: KBox<MyZpool>) {
> +///         let pool =3D KBox::into_inner(p);

Why the call to into_inner()? What do we get from moving the value?

> +///         pr_info!("Removed pool {}\n", pool.name);

Same as above, I think the print is unnecessary.

> +///     }
> +///     fn malloc(_pool: &mut MyZpool, _size: usize, _gfp: Flags, _nid: =
NumaNode) -> Result<usize> {
> +///         Ok(0) // TODO
> +///     }
> +///     unsafe fn free(_pool: &MyZpool, _handle: usize) {
> +///         // TODO

I'm not sure the TODO comments add any value.

> +///     }
> +///     unsafe fn read_begin(_pool: &MyZpool, _handle: usize) -> NonNull=
<u8> {
> +///         panic!("read_begin not implemented\n"); // TODO

Please don't use panic!() here, we only ever panic the kernel when there is=
 no
other way to prevent undefined bahvior, i.e. as a last resort.

I know it's just an example and it's not even run, but it might trick peopl=
e
into thinking that is is OK, given that it is an example.

> +///     }
> +///     unsafe fn read_end(_pool: &MyZpool, _handle: usize, _handle_mem:=
 NonNull<u8>) {}
> +///     unsafe fn write(_p: &MyZpool, _h: usize, _handle_mem: NonNull<u8=
>, _mem_len: usize) {}
> +///     fn total_pages(_pool: &MyZpool) -> u64 { 0 }
> +/// }

Overall, I feel like the example doesn't add much value as it is. I think i=
t
would be better to provide a real example that actually implements the
callbacks.

What about doing adding the most simple implementation using a plain VVec f=
or
backing the pool? This way we can even run the example. :)

> +/// ```
> +pub trait ZpoolDriver {
> +    /// Opaque Rust representation of `struct zpool`.
> +    type Pool: ForeignOwnable;
> +
> +    /// Create a pool.
> +    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
> +
> +    /// Destroy the pool.
> +    fn destroy(pool: Self::Pool);
> +
> +    /// Allocate an object of size `size` using GFP flags `gfp` from the=
 pool `pool`, with the

I think you can just write "Allocate an object of `size` bytes from `pool`"=
,
which should sound a bit more organic.

> +    /// preferred NUMA node `nid`. If the allocation is successful, an o=
paque handle is returned.
> +    fn malloc(
> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
> +        size: usize,
> +        gfp: Flags,
> +        nid: NumaNode,
> +    ) -> Result<usize>;
> +
> +    /// Free a previously allocated from the `pool` object, represented =
by `handle`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// - `handle` should be a valid handle previously returned by `mall=
oc`

"must be"; please also add a period at the end of a sentences (applies to t=
he
whole patch).

> +    unsafe fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, h=
andle: usize);
> +
> +    /// Make all the necessary preparations for the caller to be able to=
 read from the object
> +    /// represented by `handle` and return a valid pointer to the `handl=
e` memory to be read.
> +    ///
> +    /// # Safety
> +    ///
> +    /// - `handle` should be a valid handle previously returned by `mall=
oc`

A handle that has been given to free() already cannot be used here anymore.
However, as by your safety documentation this would be valid.

More generally, for the safety documentation I recommend having a look at t=
he
documentation of the Allocator trait [1].

[1] https://rust.docs.kernel.org/src/kernel/alloc.rs.html#139-216


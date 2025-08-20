Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E691DCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4028E004E; Wed, 20 Aug 2025 06:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BD98E0003; Wed, 20 Aug 2025 06:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C86E8E004E; Wed, 20 Aug 2025 06:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE9E8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:16:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D623C117A21
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:16:27 +0000 (UTC)
X-FDA: 83796731214.26.7A1A418
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4A876100006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:16:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DhaTPXI8;
	spf=pass (imf05.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755684986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6XpIDmRuqCNJaOVpSIBkkEEDY3NPmRbhE/AxafAF5M=;
	b=6yOg1kr5rPHi2H06PQWHNww8yAuanhrTm4TY32KG/RqcBL4ZzW1SU23V9bwISzi8CaQO+2
	ornet1bYz90gd321EgUqXEIaZnrvVkYjxw0pgnMxaa4ceWNjdmy1NqHpLQYHNVBQQV44vI
	kh+ExUa92LWKrrGcnh7VdBJLKuWM5Xw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DhaTPXI8;
	spf=pass (imf05.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755684986; a=rsa-sha256;
	cv=none;
	b=BgpAJoB2Ch+29yIPoXZwQFWarJRhr4t1ZCL/ub3Z3JohBBk0DxdWxajTV0xlbE1PG7VmXM
	A9Ycru4HrWTMabqBeLLYDy5/eqWfODC9dufcUUNDH1/wSKw6S0gYRp/aRD2KBspjo/2zPM
	9IhFL9D7NJqj81XULQ1WIj1i3U1YY+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F7E961415;
	Wed, 20 Aug 2025 10:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49561C4CEEB;
	Wed, 20 Aug 2025 10:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755684985;
	bh=XzpGJTqPVcOFUMqIMIlLu/4sIUSnKk+XD+8t8pnJ85U=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=DhaTPXI8AFgELTg78k1LUty/cXh66N97H/gR9L42Ak9QJ29mB3qnyWoZycO/twy4R
	 NcLenIqirpvssRdFKaoZRuQCjcr9HyPd206BovO//gZhThDSPgmoXlNAWN1OMhGAfE
	 utJK7wnAjwA3WPcx26TVP8ZcDJF3Nv4IBpfVeZ3j5mhOmBNAYkPD9wfSCs8R9VlHJJ
	 h+Fyjdwo6VYSRZZ0hhUaZGjWBguhA3nQjdeWV3B3+6HCTv29vKpxRX2DrvR6gddoC5
	 nllKvmYOeH1bvHZTL6kR2yJd6TpEY0Sxdhiuhp30QsrzvonqtBruOrJyYvsjxE8c7J
	 qrPR5q1lovOnw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Aug 2025 12:16:19 +0200
Message-Id: <DC76DSYUY978.3NR8S2K13I9RX@kernel.org>
Subject: Re: [PATCH] rust: zpool: add abstraction for zpool drivers
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
References: <20250820091543.4165305-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250820091543.4165305-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A876100006
X-Stat-Signature: a9ad3afoexenk991o1tknjouxgdkeyxw
X-Rspam-User: 
X-HE-Tag: 1755684986-681911
X-HE-Meta: U2FsdGVkX1/WpyD4mGSo3eyp3HwldftpPnfFINw6f8JwkMYgrwmUmfRcsvmnF7OIzHS59mjESy7++jvgOJ6KjHNr3P6KltZj57a6bYJVavjQUBrJOXSLz92lCll2NVMniOzWrjQosli/kXTRcj34TpnspM6UqMQrcmNkgiPQOe2kR8OdfVdHX3V/b7jGZnC/Qb8OaYkg5BlSBJY3vkLbPa/YgKKqhMMzlfFTOfWewkRuf7ugkJjY8m22GOiZmdZ678DM3f0CS7iKe1Ha9RAPujmMkrZdN6n62WexJGr4wODSUW9Pu1RAtvrGc8zzaoDNv/dDYNnEbsxk9LMwHV+NtyXX61v1Uw8Nw82QOu0ridlV4QBdbEIKh0+ndJMKztOA+jvGYLsGVnOwEn3V983KBY9tT1yX4Sdc2aUbUD3bPBB6VqHjtEI5/i03dzWadfkVkah+uYAxLmIflIaZYKHN79RhtYbJ5qN1GbEgAKOEX2Qn8Xtyx1QYXArvGpqk0Kf9xH+hXB/za7n3/Vc0xXtJcK1oHf4h/WArUZD2tV6boKGzXPQSyhhVVGvH4QTudicnFlzQwv4EsTKp13Dt9pFj1qFD2hXgbvPk87kB2YWnO7MEDcRme2+VJjdPR1vdOH/i9FIIUsxeszezILid6QTfriduqunluKxF85IPGNCO+Fk4LFhSP/oRG57KynPN1KacqwM1cYdacfLnqQg571PDuOqGr0S+PNc/5uaL7LS+jm7v9yaLpZqlt236QG8TieEqdYPxXBZZF/DwIxk1gOv7ceRANt7c7VEYldzI+h/o56FU1Y0AyKBWpH/53/R6EWK5XP53XrqRnpsecQ4BjRsL+uW9vUZzcgmMw0tSQohzlPZUnXHQyykznr0pP8owKf43IUZxBaqxO/fLdMKjFnQC41jfkBFLBurBHxRdxFXev0MKCMYZIxeJSZpwOMvQjbTUpwSxIAeWd4uEDczHmzL
 o1i87cSE
 S0Alg2sM4yNMpwY9pwcRLU9TeTAVJ/D9HplOdU5W7zppWC5wCnAT5TP+ZEZaZalZVjRyR3VbHBcmNsQ/zXaGykUIkyYw4mix++ACRMLQHOeb1d60Sy4JIp4X30XHjsVo5AErHv95NESwTnp/Nr1fNpYrhXj9Ft1nCEclrOiaaK4vG2f6apg0d7SOclu6e8xbqIlmLnKMVfw6C7zzM/a04UuO4heGKu9Nj0nNHz2ms83KDh+UhL1y8hKZQ4xeQwAPUJ0R7zXyLfLE98OD99Ym7DwQ52RIHl8iTOW14F6S3ZgubwCDLlivmhUaHu/Ur1wH/A7n5bdL1Qp11HYwnEIJvFSqB4VEYYV8CNYveuGKbP74JO9bTnfEJ4Uitfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 20, 2025 at 11:15 AM CEST, Vitaly Wool wrote:
> Zpool is a common frontend for memory storage pool implementations.
> These pools are typically used to store compressed memory objects,
> e. g. for Zswap, the lightweight compressed cache for swap pages.
>
> This patch provides the interface to use Zpool in Rust kernel code,
> thus enabling Rust implementations of Zpool allocators for Zswap.

Do you work on such a user? Do you have code using this API already?

More specifically, do you plan to re-implement Zswap in Rust?

> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

If Alice contributed to the patch you may want to add a Co-developed-by: ta=
g,
otherwise this doesn't need her SoB.

> +/// zpool API

It would be nice to have some more documentation on this trait, including a
doc-test illustrating some example usage.

> +pub trait Zpool {
> +    /// Opaque Rust representation of `struct zpool`.
> +    type Pool: ForeignOwnable;

Something that embedds a struct zpool, such as struct zswap_pool? If so, is=
n't
this type simply Self?

> +
> +    /// Create a pool.
> +    fn create(name: *const c_uchar, gfp: Flags) -> Result<Self::Pool>;

This shouldn't be a raw pointer, but rather &CStr.

> +
> +    /// Destroy the pool.
> +    fn destroy(pool: Self::Pool);
> +
> +    /// Allocate an object of size `size` using GFP flags `gfp` from the=
 pool `pool`, wuth the
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
> +    fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: =
usize);
> +
> +    /// Make all the necessary preparations for the caller to be able to=
 read from the object
> +    /// represented by `handle` and return a valid pointer to the `handl=
e` memory to be read.
> +    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, ha=
ndle: usize)
> +        -> *mut c_void;

Why does this return a raw pointer? I think this needs a proper type
representation.

> +
> +    /// Finish reading from a previously allocated `handle`. `handle_mem=
` must be the pointer
> +    /// previously returned by `read_begin`.
> +    fn read_end(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +        handle_mem: *mut c_void,
> +    );

Same here...

> +
> +    /// Write to the object represented by a previously allocated `handl=
e`. `handle_mem` points
> +    /// to the memory to copy data from, and `mem_len` defines the lengt=
h of the data block to
> +    /// be copied.
> +    fn write(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +        handle_mem: *mut c_void,

...and here.

> +        mem_len: usize,
> +    );
> +
> +    /// Get the number of pages used by the `pool`.
> +    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -=
> u64;
> +}
> +
> +/// Zpool driver registration trait.
> +pub trait Registration {

I think you should use the kernel::driver::Registration instead, it's
specifically for the purpose you defined this trait and ZpoolDriver for.

As for the C callbacks, they should go into the Adapter type (which impleme=
nts
kernel::driver::RegistrationOps) directly, they don't need to be in a trait=
.

This way a new Zpool Registration is created with:

	driver::Registration<zpool::Adapter>::new()

This also allows you to take advantage of the module_driver!() macro to pro=
vide
your own module_zpool_driver!() macro.

> +    /// Register a zpool driver.
> +    fn register(&self, name: &'static CStr, module: &'static ThisModule)=
 -> Result;
> +
> +    /// Pool creation callback.
> +    extern "C" fn _create(name: *const c_uchar, gfp: u32) -> *mut c_void=
;
> +
> +    /// Pool destruction callback.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool`.
> +    unsafe extern "C" fn _destroy(pool: *mut c_void);
> +
> +    /// Callback for object allocation in the pool.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool` and that `handle`
> +    /// is a valid pointer to usize.
> +    unsafe extern "C" fn _malloc(
> +        pool: *mut c_void,
> +        size: usize,
> +        gfp: u32,
> +        handle: *mut usize,
> +        nid: c_int,
> +    ) -> c_int;
> +
> +    /// Callback for object release.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool`.
> +    unsafe extern "C" fn _free(pool: *mut c_void, handle: usize);
> +
> +    /// Callback to prepare the object for reading.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool`.
> +    unsafe extern "C" fn _obj_read_begin(
> +        pool: *mut c_void,
> +        handle: usize,
> +        local_copy: *mut c_void,
> +    ) -> *mut c_void;
> +
> +    /// Callback to signal the end of reading from an object.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool`.
> +    unsafe extern "C" fn _obj_read_end(pool: *mut c_void, handle: usize,=
 handle_mem: *mut c_void);
> +
> +    /// Callback for writing to an object.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool`.
> +    unsafe extern "C" fn _obj_write(
> +        pool: *mut c_void,
> +        handle: usize,
> +        handle_mem: *mut c_void,
> +        mem_len: usize,
> +    );
> +
> +    /// Callback to return the number of pages in the pool.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct=
 zpool`.
> +    unsafe extern "C" fn _total_pages(pool: *mut c_void) -> u64;
> +}
> +
> +/// Zpool driver structure.
> +pub struct ZpoolDriver<T: Zpool> {
> +    inner: Opaque<bindings::zpool_driver>,

I think this needs pin-init, another reason to use kernel::driver::Registra=
tion
instead. :)

> +
> +    /// Zpool callback functions that a zpool driver must provide
> +    pub callbacks: T,
> +}
> +
> +impl<T: Zpool> Clone for ZpoolDriver<T> {
> +    fn clone(&self) -> Self {
> +        todo!()
> +    }
> +}

Cloning the driver structure? Why? Please also consider that struct zpool_d=
river
needs to be pinned.


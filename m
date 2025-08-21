Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB13CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A148E004F; Thu, 21 Aug 2025 08:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801D58E004B; Thu, 21 Aug 2025 08:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717AA8E004F; Thu, 21 Aug 2025 08:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D58F8E004B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:03:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25ABC117824
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:03:11 +0000 (UTC)
X-FDA: 83800628982.30.EAFCBE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 95C3D40007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:03:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhEkKVFb;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755777789; a=rsa-sha256;
	cv=none;
	b=PrRNyElUxkVOCc1vICaCzJ+EjHs7wp6ENl6WKbXLCtfXmPXkZNtSg7Y9HFD/JUWll8DvSv
	843u3SixcTdQImjB6B+q48pEbNPlj0LaYKF01ztfEKl0HH9YZLeaQwQ2Q4NibqeRw60+Yk
	Dm1ZhN8OHl+NozcjYNVeT370QmF460c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhEkKVFb;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755777789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xJv4XuDxPCPqywob5UmUTJcF6VVKgAMmJCawh67JV4=;
	b=FZe87cfRo905E0mtWmRAluj16XxAVTmAHpNPl7jsSNmYPktHeb68Sw0Scfp7Y/sXPdLVCb
	HlcayOFzeFUiUNw4410SLrFofmnDMoO6R7B6r/57ytH+uGEFfjEO1vFFhwygpkCSKSMEKN
	thnpRAiGByaFF2qcoF5I0WXiX+ZX43s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E940D60200;
	Thu, 21 Aug 2025 12:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACEFC4CEED;
	Thu, 21 Aug 2025 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755777788;
	bh=qdF3Pto+X4Hhldow3UAlSfqaqqGJrpaeFr7AsWRmtck=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=LhEkKVFbvIvIwX+gwWgsaV1Lf9L6vkIJ2AT5YymmlIIia5qYp/F3waMYz6zVEvcl/
	 aRc1ij0Zom5pY4fn0YU5pks9y/5EAutRuz4JeEElDE7Qn6dTHms27EQ9s7bql6SC7z
	 7fmTWlmio2CnQeMUZuJIKffZVDpNRBEGQmyAKA4+eWb8unyjB8su3P3pQv9CdQ4B9I
	 JE5CR9Xc3zem7upR5akDhSFGNTdqGEQW5xiawSSTVv7Fv+taulYKyzvEO7VVuZUXIH
	 0+2KHpaZxVabB3WIBWbhP6ICw1779/PAHKjCfgWAWW2i9iYGXd1MYk/F4b8cC92FiR
	 i1eG7mcn2JvkQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Aug 2025 14:03:03 +0200
Message-Id: <DC83A2M3G8EH.12FRM3C05ABCR@kernel.org>
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
Subject: Re: [PATCH v2] rust: zpool: add abstraction for zpool drivers
References: <20250821111718.512936-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250821111718.512936-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95C3D40007
X-Stat-Signature: wngqyz7uw8kh4nkn8idtmho6wy7skxhx
X-Rspam-User: 
X-HE-Tag: 1755777789-127754
X-HE-Meta: U2FsdGVkX1+6JEPZm9WImh57nBh6K2j+h49eubnGv97sfg6PJ4hKs7fnhpMwz/gZ8z9Kcw3tsbbWpF9Nyx0y1YKkIniaQTJLMlh4PAWpRtUU02g36SE6d6DnxdjPR1pKWwO/h4h4ZudATC5kL0kBubryu882TOaR4PFN4uoR5RxSjQqZDRt3od34A4raGazPJhnjt8W8CV6ju3RaOjtYMfiq6XErpvShATUZuCDS9fjjgP7yYkQe/tqyC0cmb7rQjlR6cacTlKVAJYaHvat12w6PT4P0+ie5KDa70wQrtOmL+x2dZzZvSWHv7P/hzca0XytG/axTFTSnixChUo15vvdlUGsZ5d9xDMmgbUUkgb1gOo2lwpsIp6Tj3xLVe34Ad++zTon6w+PJ/9DgCpX66DQ+v5FuokpMrd9uLsFKslgdd0fUV9CzcmJO+hr/EvlpDpqtudzIuq+vRgDhcLhBg4aiNmGuQPp4OqG7iE7l8X4RMxBtbizTCsJhrMdrRCR5qBwc71IE0m1yxqn1qx2oP39/lu6ZgAKQnu6Q6DvweIpTosL0oUdOqEJZefj3bJdwariZU6kP1djPvuuQ4Dk9cg6TgDtnSFfAUDKzRxjqTw3r0yqNtt9Y7+Rj1obTrd5sCcjiK5UeRuMflV7CBWViHR68+smfX/agxdlUQGeDsG3IHvx17IY3TFbRnzfnjqqdpJcnx7IL2sCs2KBMWlwGaY5F+7LTDmHMo59UZNkAhdc1iegDNWG72W/1KJA1SigDeFPoDttNskMk1S+cKxfxMC6QTBiGzsILgsgt2qpGBIKdRkU0uNkHBvw0daHVYUtRa3crEUWuj4ARy0jpbCGZXiRrggEB3IVf7+lizXGlSJIVElABkVqMG9VJWlrnQ4dziCZW+Yp4BAoCYvbVi8Lna0OY720YHYQv3HBcegLnkSkySURDAYirmGosHmp5b6qvWct9tNk26HXzhBWTskU
 PmWYgdNA
 LnpMByhCgZNYrVDllX+wlNbT7ztFtSSdstmM81sIhNszmOAVks6OlcFsVnjInBn3hfZRky1LTOT6UKJJoatlazO6VG1JemRP0E/tVpDaGao95hVBMaFkNtJG1Lb2d6tgEMdopgAxr4HVUNLEPosFjir4LTZAAZ7vTUQGrpK4RctrvDDZnr1t8vH5L39eLEX+y5vGVywORT30YSC/N++w2iRQNyzq9HnPXfy/SRXZPWFnge4boNOVImTv77u2PgNQ9L0fXCeirOeknDn4GmiKSqr4UdRr7riKPmaE8uTWXEhkde6ZV9yN3oNujOS+dGjhI92iFifn98AFXyYPRUB0OOy4RByjIP9wIQ/TeaRcS16VfwTHzQ4gs6rp8GQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 21, 2025 at 1:17 PM CEST, Vitaly Wool wrote:
> Zpool is a common frontend for memory storage pool implementations.
> These pools are typically used to store compressed memory objects,
> e. g. for Zswap, the lightweight compressed cache for swap pages.
>
> This patch provides the interface to use Zpool in Rust kernel code,
> thus enabling Rust implementations of Zpool allocators for Zswap.
>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>

If this is co-developed by Alice it also needs her SoB. It's either both or=
 none
of them in this case. :)

> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> +pub trait ZpoolDriver {
> +    /// Opaque Rust representation of `struct zpool`.
> +    type Pool: ForeignOwnable;
> +    /// Create a pool.
> +    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
> +
> +    /// Destroy the pool.
> +    fn destroy(pool: Self::Pool);
> +
> +    /// Allocate an object of size `size` using GFP flags `gfp` from the=
 pool `pool`, wuth the

typo: "with"

> +    /// preferred NUMA node `nid`. If the allocation is successful, an o=
paque handle is returned.
> +    fn malloc(
> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
> +        size: usize,
> +        gfp: Flags,
> +        nid: NumaNode,
> +    ) -> Result<usize>;

I still think we need a proper type representation of a zpool handle that
guarantees validity and manages its lifetime.

For instance, what prevents a caller from calling write() with a random han=
dle?

Looking at zsmalloc(), if I call write() with a random number, I will most
likely oops the kernel. This is not acceptable for safe APIs.

Alternatively, all those trait functions have to be unsafe, which would be =
very
unfortunate.

> +    /// Free a previously allocated from the `pool` object, represented =
by `handle`.
> +    fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: =
usize);

What happens if I forget to call free()?

> +    /// Make all the necessary preparations for the caller to be able to=
 read from the object
> +    /// represented by `handle` and return a valid pointer to the `handl=
e` memory to be read.
> +    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, ha=
ndle: usize)
> +        -> NonNull<u8>;

Same for this, making it a NonNull<u8> is better than a *mut c_void, but it=
's
still a raw pointer. Nothing prevents users from using this raw pointer aft=
er
read_end() has been called.

This needs a type representation that only lives until read_end().

In general, I think this design doesn't really work out well. I think the d=
esign
should be something along the lines of:

  (1) We should only provide alloc() on the Zpool itself and which returns =
a
      Zmem instance. A Zmem instance must not outlive the Zpool it was allo=
cated
      with.

  (2) Zmem should call free() when it is dropped. It should provide read_be=
gin()
      and write() methods.

  (3) Zmem::read_begin() should return a Zslice which must not outlive Zmem=
 and
      calls read_end() when dropped.

> +
> +    /// Finish reading from a previously allocated `handle`. `handle_mem=
` must be the pointer
> +    /// previously returned by `read_begin`.
> +    fn read_end(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +        handle_mem: NonNull<u8>,
> +    );
> +
> +    /// Write to the object represented by a previously allocated `handl=
e`. `handle_mem` points
> +    /// to the memory to copy data from, and `mem_len` defines the lengt=
h of the data block to
> +    /// be copied.
> +    fn write(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +        handle_mem: NonNull<u8>,
> +        mem_len: usize,
> +    );
> +
> +    /// Get the number of pages used by the `pool`.
> +    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -=
> u64;
> +}
> +
> +/// An "adapter" for the registration of zpool drivers.
> +pub struct Adapter<T: ZpoolDriver>(T);
> +
> +impl<T: ZpoolDriver> Adapter<T> {
> +    extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void=
 {
> +        // SAFETY: the memory pointed to by name is guaranteed by zpool =
to be a valid string
> +        let pool =3D unsafe { T::create(CStr::from_char_ptr(name), Flags=
::new(gfp)) };
> +        match pool {
> +            Err(_) =3D> null_mut(),
> +            Ok(p) =3D> T::Pool::into_foreign(p),
> +        }
> +    }
> +    extern "C" fn destroy_(pool: *mut c_void) {
> +        // SAFETY: The pointer originates from an `into_foreign` call.
> +        T::destroy(unsafe { T::Pool::from_foreign(pool) })
> +    }
> +    extern "C" fn malloc_(
> +        pool: *mut c_void,
> +        size: usize,
> +        gfp: u32,
> +        handle: *mut usize,
> +        nid: c_int,
> +    ) -> c_int {
> +        // SAFETY: The pointer originates from an `into_foreign` call. I=
f `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will no=
t be called during this
> +        // method.
> +        let pool =3D unsafe { T::Pool::borrow_mut(pool) };
> +        let real_nid =3D match nid {
> +            bindings::NUMA_NO_NODE =3D> Ok(NumaNode::NO_NODE),
> +            _ =3D> NumaNode::new(nid),
> +        };
> +        if real_nid.is_err() {
> +            return -(bindings::EINVAL as i32);
> +        }
> +
> +        let result =3D T::malloc(pool, size, Flags::new(gfp), real_nid.u=
nwrap());

Please don't use unwrap() it may panic() the whole kernel. It is equivalent=
 to

	if (ret)
		panic();
	else
		do_something();

in C.

Also, please use from_result() instead.

> +        match result {
> +            Err(_) =3D> -(bindings::ENOMEM as i32),
> +            Ok(h) =3D> {
> +                // SAFETY: handle is guaranteed to be a valid pointer by=
 zpool
> +                unsafe { *handle =3D h };
> +                0
> +            }
> +        }
> +    }

<snip>

> +/// Declares a kernel module that exposes a zpool driver (i. e. an imple=
mentation of the zpool API)
> +///
> +/// # Examples
> +///
> +///```ignore
> +/// kernel::module_zpool_driver! {
> +///     type: MyDriver,
> +///     name: "Module name",
> +///     authors: ["Author name"],
> +///     description: "Description",
> +///     license: "GPL",
> +/// }
> +///```
> +#[macro_export]
> +macro_rules! module_zpool_driver {
> +($($f:tt)*) =3D> {
> +    $crate::module_driver!(<T>, $crate::zpool::Adapter<T>, { $($f)* });
> +};
> +}

Thanks for sticking to the existing generic infrastructure, this looks much
better. :)


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D01CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9198E00CF; Tue, 26 Aug 2025 08:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363308E00A8; Tue, 26 Aug 2025 08:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22ADF8E00CF; Tue, 26 Aug 2025 08:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 786EB8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:20:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DF3FC078D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:20:23 +0000 (UTC)
X-FDA: 83818816326.15.6061274
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 535861C000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:20:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XlOXyKEv;
	spf=pass (imf18.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756210821; a=rsa-sha256;
	cv=none;
	b=UvXk2knE3BJCwaZ6xDGPpGuGUN0iQxO6U/Vbx67Z12j7J1YifvpHLniMaqBxsDI2kv1HM/
	3Qjm+O/WpJwweCrWDcu9u+ujWKugu5/WT6nPhTDX+gxe9t0TK4kDl75dP/wGtENw4auWTV
	sZbc1LJwr2WLnf9qbkklctrscaQf0ZE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XlOXyKEv;
	spf=pass (imf18.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756210821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5pgEHoLyIjtQKGuoK90Twn4lkvfS3fdRIX7qZcRhlI=;
	b=3R+0ElG6yBagsvjixagvW3YSKcZKlj4Ri0+yeUY0FzOdQLQQE3Pg23NMZlVhj+BoSwsPny
	Ssdam0uuB8iOaNxZFzMmhetWj615lkjgCodJG57w1f0iQg3RHfL9+3Kc5x0n+O4uuzv2QC
	aPCA0rbFeS/xuH4+npuhwnwm9cfUrJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 599455C4D82;
	Tue, 26 Aug 2025 12:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81482C4CEF4;
	Tue, 26 Aug 2025 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756210820;
	bh=qEjT78mgIQq7OSX5He9ED1JWcvsyTbb52dl5uA8a6Vg=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=XlOXyKEve4kWvmASe4UcwUnmjoqmjlj8bOBuSax2q6LEjrGiz8cfy6C8csI9QNZD+
	 YXN7X1aqAQlRNqdTli2pHO5F4fEjxOgvuobXO01ASaQMqfoQEQwJwuO+c7HGpWrel1
	 fB5UByB9WtaVsvfVeHqB7WJJRPFN4oAlNUVYcOrpUAjn88kCG5/87E74Bjl9zAaUd6
	 K9eaBi2FedFXc/abgP3hZ5n65ii/LUnEMkwwg/oRQ1H6jqXBJs5gTqUAgUcp8x4gdO
	 P1XVRvrOM2JQz0rza36sCMMkEdVyvbKN8D2IHnGkpuSim+1vkvXTE0WvY+4cqqAacY
	 4/5Xklgx3vxlg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Aug 2025 14:20:14 +0200
Message-Id: <DCCCRYEUVJWZ.2AUDA0DXK0XSF@kernel.org>
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
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
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250823130522.867263-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 535861C000D
X-Stat-Signature: kdc1eb9n9qdong6sqhdi1fbccnno7mct
X-Rspam-User: 
X-HE-Tag: 1756210821-619033
X-HE-Meta: U2FsdGVkX1+kH4vWSWMcPwugqoNX2Ftd4hsXdvQQwxI7lMhhT+7B2N0M8y6HrswRaLenbgLefjEPqbN64iNHIC59Akxst76GrFfnUSQ1yUJztb1gYYJd+GbwXkduy0UF9k48hCW2zg4KD/LukB0s+zN+ieRTP4QkB55SkT4YmS4fdRyNVTm73hIBrosyHnUBTfxRnSYv9T3B6VRXo23ngWBwvsOpBBwLGgYYIWtzE5L2hcbLH5BM9KeF4qZdijP9bP6N590jPFJH52E2yZTS77LKpBs8FzilduRtaoDkWdOCSvsOyMXkixkY7Paf8telNMPN1rj7tLog35O2MQVLLKQwEb3Jogxu3c90/UnfsaGHgCp0qO0LSEB24ZUoSb12AI6T0/isnJho9izO5D8uSIjG0x6W6IlasXPzOM09cIWfq+FoKF7WO2sTA17lgzhOACn4y3MjjYCOiM0/nANRLZ4etiXLr+bBx1Q39qK52GeruAvS9Umyi1rggSqI1Z19FmjWQDZUGmheOJQvMVxbWr856gVtR6HSNHb62qmaqJvTFYtu6LvhXcr+p5/lL/F5XJjO1Tj4TFCvFG298/52XN1jgccOJMw9AWzH/D1n5CCV2CvUSoQ9t1GGCaBavLWTc/VBoBlUUpdwxkd/gpF/yN1DkUkbub47AqQVEbe5fpt/hhmtnWtFBDBHIooyxteVHBzMByLbhyQcNTRfCQkjqum+/nN035UBEyAwR5Vo5gQTssART+JTxC5wRdUao/5PZpgUGEFdC6Fer6f81AMtUYDjHqtxJClVJYFqzx+gvKYMo/kVFTAbkg2P6KYBLfBFkQd6KGiemPLPiuiDadD2csWKLNNTL5QzILZJmOVX5W9NUtadGYz9/TowuvAxc0N/gGf+UBmmVw7k8Vp2bpzgaCCygEL/QWxlyuPKZ9zeTw3rB8ARI0SMTdkZayq74Jau9PTSn2imLzPz6Fhe0am
 sqlSxgs6
 cWWHeO27VhYEuT/Zjv+m5jtjH5ElRopBEo6S4pJgjGfq6KVnfojc/MfSiLup6dVFZqO60IWJtfTfTYCwTh6ioVZ3JD6alZNeBwZk+AePITWCbHOSdyk+eYMyQ1HmWd1ZxKbqa/oG1czphq2LdzzI6eWGRARsrxL2+kYSGLFfPLyCPzQsFGPNaEs2+kye12Eh+3s852e7YpiOvAqzp5+AoDlrqA0+VSTQ9teISRR1LAG5e74k/rGw6wGMInPIDRBLMACp91x5iG/r5Wua1Xbj2sZ/UDcjtqr+XlVGOdFFj3yf4sv1pob2Vc9qOJrEfNYfd/aaVjh8El390VxVWFIUkmzRxC3QKoOQ8H9LY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
> +/// Zpool API.
> +///
> +/// The [`ZpoolDriver`] trait serves as an interface for Zpool drivers i=
mplemented in Rust.
> +/// Such drivers implement memory storage pools in accordance with the z=
pool API.
> +///
> +/// # Example
> +///
> +/// A zpool driver implementation which uses KVec of 2**n sizes, n =3D 6=
, 7, ..., PAGE_SHIFT.
> +/// Every zpool object is packed into a KVec that is sufficiently large,=
 and n (the
> +/// denominator) is saved in the least significant bits of the handle, w=
hich is guaranteed
> +/// to be at least 2**6 aligned by kmalloc.
> +///
> +/// ```
> +/// use core::ptr::{NonNull, copy_nonoverlapping};
> +/// use core::sync::atomic::{AtomicU64, Ordering};
> +/// use kernel::alloc::{Flags, KBox, KVec, NumaNode};
> +/// use kernel::page::PAGE_SHIFT;
> +/// use kernel::prelude::EINVAL;
> +/// use kernel::zpool::*;
> +///
> +/// struct MyZpool {
> +///     name: &'static CStr,
> +///     bytes_used: AtomicU64,
> +/// }
> +///
> +/// struct MyZpoolDriver;
> +///
> +/// impl ZpoolDriver for MyZpoolDriver {
> +///     type Pool =3D KBox<MyZpool>;
> +///
> +///     fn create(name: &'static CStr, gfp: Flags) -> Result<KBox<MyZpoo=
l>> {
> +///         let my_pool =3D MyZpool { name, bytes_used: AtomicU64::new(0=
) };
> +///         let pool =3D KBox::new(my_pool, gfp)?;
> +///
> +///         Ok(pool)
> +///     }
> +///
> +///     fn destroy(p: KBox<MyZpool>) {
> +///         drop(p);
> +///     }
> +///
> +///     fn malloc(pool: &mut MyZpool, size: usize, gfp: Flags, _nid: Num=
aNode) -> Result<usize> {
> +///         let mut pow: usize =3D 0;
> +///         for n in 6..=3DPAGE_SHIFT {
> +///             if size <=3D 1 << n {
> +///                 pow =3D n;
> +///                 break;
> +///             }
> +///         }

Why not just use next_power_of_two()? I think the same logic could also be
achieved with

	size.next_power_of_two().trailing_zeros().max(6).min(PAGE_SHIFT)

> +///         match pow {
> +///             0 =3D> Err(EINVAL),
> +///             _ =3D> {
> +///                 let vec =3D KVec::<u64>::with_capacity(1 << (pow - 3=
), gfp)?;

Why use u64 and 1 << (pow - 3), rather than simply u8 and 1 << pow?

(Btw. you could also just use VBox<u8; PAGE_SIZE>::new_uninit() for all
allocations to keep the example simple.)

> +///                 let (ptr, _len, _cap) =3D vec.into_raw_parts();
> +///                 pool.bytes_used.fetch_add(1 << pow, Ordering::Relaxe=
d);
> +///                 Ok(ptr as usize | (pow - 6))
> +///             }
> +///         }
> +///     }
> +///
> +///     unsafe fn free(pool: &MyZpool, handle: usize) {
> +///         let n =3D (handle & 0x3F) + 3;
> +///         let uptr =3D handle & !0x3F;
> +///
> +///         // SAFETY:
> +///         // - uptr comes from handle which points to the KVec allocat=
ion from `alloc`.

That's not true, you modified the pointer you got from KVec. Please explain=
 why
it is always safe to use lower 6 bits for something else.

What does "`alloc`" refer to?

NIT: `uptr`, `KVec`

> +///         // - size =3D=3D capacity and is coming from the first 6 bit=
s of handle.
> +///         let vec =3D unsafe { KVec::<u64>::from_raw_parts(uptr as *mu=
t u64, 1 << n, 1 << n) };

Why do you set the length (not the capacity) of the Vector to 1 << n? I thi=
nk
technically it doesn't matter, but you should explain that in the safety
comment.

> +///         drop(vec);
> +///         pool.bytes_used.fetch_sub(1 << (n + 3), Ordering::Relaxed);
> +///     }
> +///
> +///     unsafe fn read_begin(_pool: &MyZpool, handle: usize) -> NonNull<=
u8> {
> +///         let uptr =3D handle & !0x3F;
> +///         // SAFETY: uptr points to a memory area allocated by KVec

Please use markdown and end sentences with a period. (Applies to the entire
file.)

> +///         unsafe { NonNull::new_unchecked(uptr as *mut u8) }
> +///     }
> +///
> +///     unsafe fn read_end(_pool: &MyZpool, _handle: usize, _handle_mem:=
 NonNull<u8>) {}
> +///
> +///     unsafe fn write(_p: &MyZpool, handle: usize, handle_mem: NonNull=
<u8>, mem_len: usize) {
> +///         let uptr =3D handle & !0x3F;
> +///         // SAFETY: handle_mem is a valid non-null pointer provided b=
y zpool, uptr points to
> +///         // a KVec allocated in `malloc` and is therefore also valid.
> +///         unsafe {
> +///             copy_nonoverlapping(handle_mem.as_ptr().cast(), uptr as =
*mut c_void, mem_len)
> +///         };
> +///     }
> +///
> +///     fn total_pages(pool: &MyZpool) -> u64 {
> +///         pool.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT

I'm not sure what the semantic of this function is; the documentation says
"Get the number of pages used by the `pool`".

However, given that you give out allocations from a kmalloc() bucket in
malloc(), this pool might be backed by more pages than what you calculate h=
ere.

So, what is done here is calculating the number of pages you could fill wit=
h
the memory that is kept around, but not the number of backing pages you con=
sume
memory from.

Using VBox<u8; PAGE_SIZE>::new_uninit() for all allocations might simplify =
this.

> +///     }
> +/// }
> +/// ```
> +///
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
> +    /// Allocate an object of size `size` bytes from `pool`, with the al=
location flags `gfp` and

"of `size` bytes"

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
> +    /// - `handle` must be a valid handle previously returned by `malloc=
`.
> +    /// - `handle` must not be used any more after the call to `free`.
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
> +    /// - `handle` must be a valid handle previously returned by `malloc=
`.
> +    /// - `read_end` with the same `handle` must be called for each `rea=
d_begin`.

What can potentially happen if we don't? I.e. how is this different from
malloc()?

> +    unsafe fn read_begin(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +    ) -> NonNull<u8>;
> +
> +    /// Finish reading from a previously allocated `handle`. `handle_mem=
` must be the pointer
> +    /// previously returned by `read_begin`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// - `handle` must be a valid handle previously returned by `malloc=
`.
> +    /// - `handle_mem` must be the pointer previously returned by `read_=
begin`.
> +    unsafe fn read_end(
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
> +    ///
> +    /// # Safety
> +    ///
> +    /// - `handle` must be a valid handle previously returned by `malloc=
`.
> +    /// - `handle_mem` must be a valid pointer to an allocated memory ar=
ea.

"must be a valid pointer into the allocated memory aread represented by
`handle`"

> +    /// - `handle_mem` + `mem_len` must not point outside the allocated =
memory area.
> +    unsafe fn write(
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

What about the lifetime of the string? In the abstraction you assume 'stati=
c,
how is this guaranteed?

> +        let pool =3D unsafe { T::create(CStr::from_char_ptr(name), Flags=
::from_raw(gfp)) };
> +        match pool {
> +            Err(_) =3D> null_mut(),
> +            Ok(p) =3D> T::Pool::into_foreign(p),
> +        }
> +    }

Please add an empty line in between function definitions.

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

Wait, can't this happen concurrently to all the other functions that borrow=
 the
pool? This would be undefined behavior, no?

> +        from_result(|| {
> +            let real_nid =3D match nid {
> +                bindings::NUMA_NO_NODE =3D> NumaNode::NO_NODE,
> +                _ =3D> NumaNode::new(nid)?,
> +            };
> +            let h =3D T::malloc(pool, size, Flags::from_raw(gfp), real_n=
id)?;
> +            // SAFETY: handle is guaranteed to be a valid pointer by zpo=
ol.
> +            unsafe { *handle =3D h };
> +            Ok(0)
> +        })
> +    }
> +    extern "C" fn free_(pool: *mut c_void, handle: usize) {
> +        // SAFETY: The pointer originates from an `into_foreign` call. I=
f `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will no=
t be called during this
> +        // method.
> +        let pool =3D unsafe { T::Pool::borrow(pool) };
> +
> +        // SAFETY: the caller (zswap) guarantees that `handle` is a vali=
d handle previously

Why does this mention zwap here and in the other functions below?

> +        // allocated by `malloc`.
> +        unsafe { T::free(pool, handle) }
> +    }


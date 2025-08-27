Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C72CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B2F6B0029; Wed, 27 Aug 2025 16:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBFD6B0032; Wed, 27 Aug 2025 16:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01AC6B0062; Wed, 27 Aug 2025 16:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9366B0029
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:43:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 278CF1A083C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:43:16 +0000 (UTC)
X-FDA: 83823712392.16.ED0E323
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61547120008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:43:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=TphgsXag;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=Wm1fK3fX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756327394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZedlH50mveQm2l1NixYwK48/IUW8iWvnLQXSAqCWOg=;
	b=q3ESdNvxxnoxDjYwRpvb6IJY8wspHBV6Z7QPflsc8m+cGlIn46bUNeKKBVrMpbiRd6xIqV
	QDhV/r6DRyDK9bstJy34ANKYlBqvXCi/cv8amhk0zSVHUYlcSIC3+Sxfb0cRTRSlDG+CAN
	7X0wxF2oy/KAMh3UcfOiYlq5zV3LLx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756327394; a=rsa-sha256;
	cv=none;
	b=r7jaBmpBdbifCxd49dmEPgQc5Gr2NIErcB4plzo00ayq2aVP3D7tI7tsHvzlDrDkKUVsMr
	cV4caIwWbcFcVaZkGzSdAaiNrbfDX6Tj+b15gbyrL5YaPXyw2mxZQC2/KuMyblDf6ioY7K
	8nMM/8m0OyG37qVYD2nMNWjCxso0YO0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=TphgsXag;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=Wm1fK3fX;
	spf=none (imf29.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756327390; x=1756932190;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=AZedlH50mveQm2l1NixYwK48/IUW8iWvnLQXSAqCWOg=;
	b=TphgsXagp7bCIZd+a5snmButOT3yQ+6eUJLXHxZqVi8DLmgofwRs8ISwr1NZIJgBYw06F6pOm+S0E
	 mJ0qDPiG4JM5tMXTkYGvwnGNsT55dLUGVHG8rqddcMPLSxdsLNopFm+YDic040yp7j7jkqkKxyTEza
	 o+OxM8lqQalVEiq8PHMqEP3cyETwi+vLkdN+Vzdolwhdi0NH0IScAGhHtY+v8edZOOWB6/OfdQ8b4V
	 CLuzIkynoVK+Sr1Jo0JNoqn8DVtkGytxVaZwafKSfYLGdGCOLPMW7hlqkp2o5oEeDbtVQnAzG0hm5k
	 dhoeSA+nDnpyNV4MmTNaZGNCtte1wKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756327390; x=1756932190;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=AZedlH50mveQm2l1NixYwK48/IUW8iWvnLQXSAqCWOg=;
	b=Wm1fK3fXzdlOu2kYnKQmwUzwQK82UNEkNswgPKQLzA8bS9slQQm19yNcCVdxG4mAGwdlu6d8Mah5H
	 lp+PFfRBQ==
X-HalOne-ID: 70387192-8386-11f0-bb7c-fb5fec76084d
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 70387192-8386-11f0-bb7c-fb5fec76084d;
	Wed, 27 Aug 2025 20:43:09 +0000 (UTC)
Message-ID: <b1509e7f-4817-4466-bd2b-c083f024c0d4@konsulko.se>
Date: Wed, 27 Aug 2025 22:43:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
To: Danilo Krummrich <dakr@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
 <DCCCRYEUVJWZ.2AUDA0DXK0XSF@kernel.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <DCCCRYEUVJWZ.2AUDA0DXK0XSF@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61547120008
X-Stat-Signature: 3kwq59e3u53s6j8ojybtxze7gi8eroza
X-HE-Tag: 1756327393-1519
X-HE-Meta: U2FsdGVkX1+6FexzJfQGog6O//VtU1XC9NvGCETGkjOTv1yi81jI1E20FunSV42PpLD4clsxLYcmijuQzocA2zJ+jKREn/jusBS9h1RTX6mIrmE2ONM/lxFlqBT56otaa6ahOWxqdU16rznQHTka5KWnFtAKxTQRHrKlporDIQfI9h+jqYmFi+2Fy8gSPaBIYIimWQ5YFBRAYuy6DvSC0PIX9bmvcdl++yqA9k9v2EG1y9lJ/rASefnJ2oFqtQbTSTwSQCHzEL2pufP7DL8cjksqlRG3jPZByN1pbsmc+47bFgnhiAGrof+0oBDdDBot3XKkFw3C8uNY3vw/TPi2RLVW1A9QA99c22ggBmfsCT59aVlqdtKfuD5RrHt6MPuq/QLBIpho3o1cTGXrW3SFh+F8b92IoULIhpgFCgxAplcXtbLrWFF0ghMzxxnEP/2dQ8EG/C063iJTC12GAnR3HJizYnsMGKAzzligHPzIKYR/P1XaV+5CTO0gx3Q5BVrZahDt5KS6dq8XrWmhB842NJxiZYHbEfwGHfBOwZePHMcUm1glWWXotakXTSaRLYFmqtU6fzwSFBF6iHgNSK96ARxxyv3pFC0k/VwLprvwyg2xGgaY86OM77K8YvJCk4Le2fwlt5l360CpjQohoj7wfwLzjKmFVZYvVABUEzla6s8vH7PBj5N/rKYRx+BM9g0sDVj812fMR2Gv17bbsHbm/KhueCH1WJK5fDo74ULBn9C7vN48DF07tKAErC4Qz20jBOrJd0C6fr48yQ55d59FSULyBRGz8hpPAwtxjTJbaGGjW4gU0dkMYRRiov0vkayIX1km2h7pgZIW03OYi+zZE4EnhAY6rw1lmNSf5HgWI58SxIR5cylP/kv7P/aAdHHb4iqCridqsD5v/HATA1+qZCx0NDKW7BS9SCG2SCHvv/nHcjTYvdMjDz3TmanOypWCEnx9fAFCR+DtNZmBOjC
 W4hRFlLO
 9bGQGrKJkQwMVCdpRv6P0wJphbIU35zHiGWQdoOFPNT4l68anhEA8O5Ab1jazVXKX3himf1Pm39NPo1FXALj5mgWzz8G3i/DBztMzvPOufKDPLzvGB0HLrbXdH2hT1PprYZ0K1CLj9nvD6qXh0RjPake7HHYqcE3E0PtI9o1OiUReAvW5NtyFIX+rpltAPc5JX/XryQ51TlLZTQt0cilu+GWTCShWzJNGlyC/uLZP9gSkdN5ryJGmk8bb8Nv85kYao25N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/25 14:20, Danilo Krummrich wrote:
> On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
>> +/// Zpool API.
>> +///
>> +/// The [`ZpoolDriver`] trait serves as an interface for Zpool drivers implemented in Rust.
>> +/// Such drivers implement memory storage pools in accordance with the zpool API.
>> +///
>> +/// # Example
>> +///
>> +/// A zpool driver implementation which uses KVec of 2**n sizes, n = 6, 7, ..., PAGE_SHIFT.
>> +/// Every zpool object is packed into a KVec that is sufficiently large, and n (the
>> +/// denominator) is saved in the least significant bits of the handle, which is guaranteed
>> +/// to be at least 2**6 aligned by kmalloc.
>> +///
>> +/// ```
>> +/// use core::ptr::{NonNull, copy_nonoverlapping};
>> +/// use core::sync::atomic::{AtomicU64, Ordering};
>> +/// use kernel::alloc::{Flags, KBox, KVec, NumaNode};
>> +/// use kernel::page::PAGE_SHIFT;
>> +/// use kernel::prelude::EINVAL;
>> +/// use kernel::zpool::*;
>> +///
>> +/// struct MyZpool {
>> +///     name: &'static CStr,
>> +///     bytes_used: AtomicU64,
>> +/// }
>> +///
>> +/// struct MyZpoolDriver;
>> +///
>> +/// impl ZpoolDriver for MyZpoolDriver {
>> +///     type Pool = KBox<MyZpool>;
>> +///
>> +///     fn create(name: &'static CStr, gfp: Flags) -> Result<KBox<MyZpool>> {
>> +///         let my_pool = MyZpool { name, bytes_used: AtomicU64::new(0) };
>> +///         let pool = KBox::new(my_pool, gfp)?;
>> +///
>> +///         Ok(pool)
>> +///     }
>> +///
>> +///     fn destroy(p: KBox<MyZpool>) {
>> +///         drop(p);
>> +///     }
>> +///
>> +///     fn malloc(pool: &mut MyZpool, size: usize, gfp: Flags, _nid: NumaNode) -> Result<usize> {
>> +///         let mut pow: usize = 0;
>> +///         for n in 6..=PAGE_SHIFT {
>> +///             if size <= 1 << n {
>> +///                 pow = n;
>> +///                 break;
>> +///             }
>> +///         }
> 
> Why not just use next_power_of_two()? I think the same logic could also be
> achieved with
> 
> 	size.next_power_of_two().trailing_zeros().max(6).min(PAGE_SHIFT)

It indeed can, thanks :)

>> +///         match pow {
>> +///             0 => Err(EINVAL),
>> +///             _ => {
>> +///                 let vec = KVec::<u64>::with_capacity(1 << (pow - 3), gfp)?;
> 
> Why use u64 and 1 << (pow - 3), rather than simply u8 and 1 << pow?
> 
> (Btw. you could also just use VBox<u8; PAGE_SIZE>::new_uninit() for all
> allocations to keep the example simple.)

Right, that fixation on u64 doesn't help at all here.

>> +///                 let (ptr, _len, _cap) = vec.into_raw_parts();
>> +///                 pool.bytes_used.fetch_add(1 << pow, Ordering::Relaxed);
>> +///                 Ok(ptr as usize | (pow - 6))
>> +///             }
>> +///         }
>> +///     }
>> +///
>> +///     unsafe fn free(pool: &MyZpool, handle: usize) {
>> +///         let n = (handle & 0x3F) + 3;
>> +///         let uptr = handle & !0x3F;
>> +///
>> +///         // SAFETY:
>> +///         // - uptr comes from handle which points to the KVec allocation from `alloc`.
> 
> That's not true, you modified the pointer you got from KVec. Please explain why
> it is always safe to use lower 6 bits for something else.
> 
> What does "`alloc`" refer to?

It refers to the alloc function we implement in this toy backend for 
ZpoolDriver trait.

> NIT: `uptr`, `KVec`
> 
>> +///         // - size == capacity and is coming from the first 6 bits of handle.
>> +///         let vec = unsafe { KVec::<u64>::from_raw_parts(uptr as *mut u64, 1 << n, 1 << n) };
> 
> Why do you set the length (not the capacity) of the Vector to 1 << n? I think
> technically it doesn't matter, but you should explain that in the safety
> comment.

Would the following work: "we know the capacity of this vector and it is 
1 << n, we set the length to the same value to be deterministic, but the 
actual length of vec doesn't matter because we're dropping it right here 
anyway"?

>> +///         drop(vec);
>> +///         pool.bytes_used.fetch_sub(1 << (n + 3), Ordering::Relaxed);
>> +///     }
>> +///
>> +///     unsafe fn read_begin(_pool: &MyZpool, handle: usize) -> NonNull<u8> {
>> +///         let uptr = handle & !0x3F;
>> +///         // SAFETY: uptr points to a memory area allocated by KVec
> 
> Please use markdown and end sentences with a period. (Applies to the entire
> file.)
> 
>> +///         unsafe { NonNull::new_unchecked(uptr as *mut u8) }
>> +///     }
>> +///
>> +///     unsafe fn read_end(_pool: &MyZpool, _handle: usize, _handle_mem: NonNull<u8>) {}
>> +///
>> +///     unsafe fn write(_p: &MyZpool, handle: usize, handle_mem: NonNull<u8>, mem_len: usize) {
>> +///         let uptr = handle & !0x3F;
>> +///         // SAFETY: handle_mem is a valid non-null pointer provided by zpool, uptr points to
>> +///         // a KVec allocated in `malloc` and is therefore also valid.
>> +///         unsafe {
>> +///             copy_nonoverlapping(handle_mem.as_ptr().cast(), uptr as *mut c_void, mem_len)
>> +///         };
>> +///     }
>> +///
>> +///     fn total_pages(pool: &MyZpool) -> u64 {
>> +///         pool.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
> 
> I'm not sure what the semantic of this function is; the documentation says
> "Get the number of pages used by the `pool`".
> 
> However, given that you give out allocations from a kmalloc() bucket in
> malloc(), this pool might be backed by more pages than what you calculate here.

Well, maybe I need to add an explicit comment about it here, but the 
idea is that with the SLUB allocator, you have kmalloc-64, kmalloc-128, 
kmalloc-256 etc. caches which will be used to manage requests for up to 
64, 128, 256, ... bytes respectively, and in that case the calculations 
are correct. FWIW I smoke tested this allocator and the actual numbers 
seem to be consistent with these calculations.

> So, what is done here is calculating the number of pages you could fill with
> the memory that is kept around, but not the number of backing pages you consume
> memory from.
> 
> Using VBox<u8; PAGE_SIZE>::new_uninit() for all allocations might simplify this.
> 
>> +///     }
>> +/// }
>> +/// ```
>> +///
>> +pub trait ZpoolDriver {
>> +    /// Opaque Rust representation of `struct zpool`.
>> +    type Pool: ForeignOwnable;
>> +
>> +    /// Create a pool.
>> +    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
>> +
>> +    /// Destroy the pool.
>> +    fn destroy(pool: Self::Pool);
>> +
>> +    /// Allocate an object of size `size` bytes from `pool`, with the allocation flags `gfp` and
> 
> "of `size` bytes"
> 
>> +    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
>> +    fn malloc(
>> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
>> +        size: usize,
>> +        gfp: Flags,
>> +        nid: NumaNode,
>> +    ) -> Result<usize>;
>> +
>> +    /// Free a previously allocated from the `pool` object, represented by `handle`.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// - `handle` must be a valid handle previously returned by `malloc`.
>> +    /// - `handle` must not be used any more after the call to `free`.
>> +    unsafe fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize);
>> +
>> +    /// Make all the necessary preparations for the caller to be able to read from the object
>> +    /// represented by `handle` and return a valid pointer to the `handle` memory to be read.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// - `handle` must be a valid handle previously returned by `malloc`.
>> +    /// - `read_end` with the same `handle` must be called for each `read_begin`.
> 
> What can potentially happen if we don't? I.e. how is this different from
> malloc()?

Here the idea is that if read_begin() has some sort of extra mapping 
involved (like, doing kmap_atomic() on some weird memory address) for 
the caller to be able to read directly from the returned pointer, 
read_end() must clean that mapping up.

>> +    unsafe fn read_begin(
>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>> +        handle: usize,
>> +    ) -> NonNull<u8>;
>> +
>> +    /// Finish reading from a previously allocated `handle`. `handle_mem` must be the pointer
>> +    /// previously returned by `read_begin`.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// - `handle` must be a valid handle previously returned by `malloc`.
>> +    /// - `handle_mem` must be the pointer previously returned by `read_begin`.
>> +    unsafe fn read_end(
>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>> +        handle: usize,
>> +        handle_mem: NonNull<u8>,
>> +    );
>> +
>> +    /// Write to the object represented by a previously allocated `handle`. `handle_mem` points
>> +    /// to the memory to copy data from, and `mem_len` defines the length of the data block to
>> +    /// be copied.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// - `handle` must be a valid handle previously returned by `malloc`.
>> +    /// - `handle_mem` must be a valid pointer to an allocated memory area.
> 
> "must be a valid pointer into the allocated memory aread represented by
> `handle`"
> 
>> +    /// - `handle_mem` + `mem_len` must not point outside the allocated memory area.
>> +    unsafe fn write(
>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>> +        handle: usize,
>> +        handle_mem: NonNull<u8>,
>> +        mem_len: usize,
>> +    );
>> +
>> +    /// Get the number of pages used by the `pool`.
>> +    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -> u64;
>> +}
>> +
>> +/// An "adapter" for the registration of zpool drivers.
>> +pub struct Adapter<T: ZpoolDriver>(T);
>> +
>> +impl<T: ZpoolDriver> Adapter<T> {
>> +    extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void {
>> +        // SAFETY: the memory pointed to by name is guaranteed by zpool to be a valid string
> 
> What about the lifetime of the string? In the abstraction you assume 'static,
> how is this guaranteed?

Actually it isn't, thanks for finding this.

>> +        let pool = unsafe { T::create(CStr::from_char_ptr(name), Flags::from_raw(gfp)) };
>> +        match pool {
>> +            Err(_) => null_mut(),
>> +            Ok(p) => T::Pool::into_foreign(p),
>> +        }
>> +    }
> 
> Please add an empty line in between function definitions.
> 
>> +    extern "C" fn destroy_(pool: *mut c_void) {
>> +        // SAFETY: The pointer originates from an `into_foreign` call.
>> +        T::destroy(unsafe { T::Pool::from_foreign(pool) })
>> +    }
>> +    extern "C" fn malloc_(
>> +        pool: *mut c_void,
>> +        size: usize,
>> +        gfp: u32,
>> +        handle: *mut usize,
>> +        nid: c_int,
>> +    ) -> c_int {
>> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
>> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
>> +        // method.
>> +        let pool = unsafe { T::Pool::borrow_mut(pool) };
> 
> Wait, can't this happen concurrently to all the other functions that borrow the
> pool? This would be undefined behavior, no?

Theoretically, yes, but since pool is actually Box<T>, it's only the 
inner T that is mutable.

Anyway, the only reason for malloc() to require a mutable reference is 
that the backend implementation *may* use RBTree::cursor_lower_bound() 
which requires a mutable reference of the tree.

Would it be okay if I
* change the Zpool API so that malloc takes an immutable reference
* extend the RBTree API with a cursor_lower_bound analog which doesn't 
require a mutable tree?

>> +        from_result(|| {
>> +            let real_nid = match nid {
>> +                bindings::NUMA_NO_NODE => NumaNode::NO_NODE,
>> +                _ => NumaNode::new(nid)?,
>> +            };
>> +            let h = T::malloc(pool, size, Flags::from_raw(gfp), real_nid)?;
>> +            // SAFETY: handle is guaranteed to be a valid pointer by zpool.
>> +            unsafe { *handle = h };
>> +            Ok(0)
>> +        })
>> +    }
>> +    extern "C" fn free_(pool: *mut c_void, handle: usize) {
>> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
>> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
>> +        // method.
>> +        let pool = unsafe { T::Pool::borrow(pool) };
>> +
>> +        // SAFETY: the caller (zswap) guarantees that `handle` is a valid handle previously
> 
> Why does this mention zwap here and in the other functions below?

Should have been "(e. g. zswap)".

>> +        // allocated by `malloc`.
>> +        unsafe { T::free(pool, handle) }
>> +    }
> 


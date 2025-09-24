Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE16FCAC5A7
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2AB8E0007; Wed, 24 Sep 2025 05:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D735F8E0001; Wed, 24 Sep 2025 05:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C621D8E0007; Wed, 24 Sep 2025 05:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A79968E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:23:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 295DF1A07A7
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:23:27 +0000 (UTC)
X-FDA: 83923605654.23.C8A0653
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C5FF1C000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:23:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=Rmw0qhTV;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=TIn9hZXS
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758705804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hQAmdgsj56lWZqQa4snfcTxmVBqhzBEMqIVUh7ap20=;
	b=SGItES4zwpbEKqRFocAE10CrYQix1t5wI+smOr0gVDPopnlv2NuNLnniDkhhe/OCewrYMZ
	0Nfr55c/fD6gNWZVwVNBEIn8F5rcW+2RJL4TNrQdmLPm8k6pK5NndJcBJHbFxBzrOb1EaB
	CIm/lgh/LYruka29jKD2FCvviBB8T4o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=Rmw0qhTV;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=TIn9hZXS;
	spf=none (imf20.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758705804; a=rsa-sha256;
	cv=none;
	b=kkjrEE+8HixsmIThqoDPCOPMHbfMIXhAbACRQbnB9xBytA/UPSDsLEHs0TlNGb7BSk9CmQ
	/oHYr/nwBIx2h0zVl2+f3EU31glZ30ZwdPmQ9VvgVZnhmQKQS4uUH/fS1f9DLS82ynZv+G
	n4JDTLEq9EIyuuDi+kNGqFk5lxvjee4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758705800; x=1759310600;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=8hQAmdgsj56lWZqQa4snfcTxmVBqhzBEMqIVUh7ap20=;
	b=Rmw0qhTV/Eia148x7JHjY9Fa6dUs1crqJwLdK1Y7ngO4RDOnV/nq+Uj+UMdGlnlOI7X4fhOKRW9ba
	 HZp6diEex6mrViqExA9m54tzS1HyoPgkox6LFRA3wHz/yOkd9jjG0VPwJ5jwziyU1D38XVJEb2Q9jM
	 w5KI+lyRqPcvOr6xalzL1dG1eu5v43WvGLX85oB4BgmWyif/vICQwgptthZnjX3HQJsesjXBbBj/zs
	 pE9XHfCoXme0YIQeqa+MyYs9orsdw+KoVk7q89XqM64aqSIZW40ORMJuJR+2cY8RA/HklvOoSjWVX2
	 7lqH6l80I73bTvJ83K2kL1AGUb/Ukwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758705800; x=1759310600;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=8hQAmdgsj56lWZqQa4snfcTxmVBqhzBEMqIVUh7ap20=;
	b=TIn9hZXS9Ua9ogFH9ICjrfAm3/5xFx+rhcRvnC+8q529qtc4M1wVP6OhVis1ytn80CJ9yFZYT0Q4V
	 QMIyT6FAQ==
X-HalOne-ID: 19dcd115-9928-11f0-bdd8-e90f2b8e16ca
Received: from [192.168.10.245] (host-90-233-199-55.mobileonline.telia.com [90.233.199.55])
	by mailrelay2.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 19dcd115-9928-11f0-bdd8-e90f2b8e16ca;
	Wed, 24 Sep 2025 09:23:18 +0000 (UTC)
Message-ID: <d01074e3-600c-4ceb-95b6-d10fd9c253a4@konsulko.se>
Date: Wed, 24 Sep 2025 11:23:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
To: Benno Lossin <lossin@kernel.org>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <20250923102702.2552392-1-vitaly.wool@konsulko.se>
 <DD0IEU4DSZVI.32SU7U5B4AOGE@kernel.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <DD0IEU4DSZVI.32SU7U5B4AOGE@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C5FF1C000B
X-Stat-Signature: za3k8es5etiouchcq8zscyo5dxyw6h39
X-HE-Tag: 1758705802-307510
X-HE-Meta: U2FsdGVkX1/mbz3FKFKqhae3Ytn5hfu4OuCFEvMGa4AN0rTFFzYSf+6RD7JlIYAZyrUUif1ChIH63P5ZPdWRaSrrMklEqH7vWumd8zGjOxQHmRGLN0mdw913A7xWjl8uDQN83pVE/wMGZ0L/gN0vv67KeXT2dazC5WTTml3xWLHNKQUyRTgi451dW1BwW/tVNyAuH6Xu4zanwPvi9XzvYoWMKRP1NbCBckiOOTT2SCXIHe3hJnu3WDlKyyWVKMxPTm1BV+40s8E+a2R/FFaiZ+WivToNG1kYgyhpuRBUDBVttyJarKVWXsN9NS1KIZgIeRf0xHpWF2VlT9ZGa+1Jz1rcEHhXeyclM5+EMF+kpickR184iAYg2tt0xX6QgZPdF1sR7NRauz/4OvUzA4WF5eBwi9PI83ypUQdW3d3k1TFbcgM1HJ6Z0yZk2dlq4Lmc35zQq5FcLlgDYr6YO61lmBCcYaj44fro731xEENONcSaCtBQ9atJlhosF33fyBZqdZa6kOWjIrMAo7UnRX9obgDKg5m9FuD5nqpNP3C3Le8daTocXFFEaQCzGX8YLGftUDd56b8ftfHzgU9YL4/wwE36K4O7/BLa5Tf+cJ7XQ8tyJTBOTLYyJWw8mQvTvH6un+3sZnkxprLEb+otvowDD3sQ64zw76wCEkh+tS12it+kXbqF7ApxgA2X4pmsYlyVHkWuGA3ICAlfWSxyxfjRnqkNVqyTleCxVKutO9eFNc3T45CAWoRddW6CZwJJN6bMw06Stc7uBEenU1cXNBNX4ip38is18WM0SpifErPpEmTg6nnZj0a7QZt74PWwOmSimCJ48hvd8iEDh3deFFQOFWx+U05WoR1cXysM5ZKNzUo0UOm39aLFM8W8U7RBOOZWChkmPOfOt5lGBc9KX+GTvIT2b/B9yKWMmzlrGzPq1s7E1FXwMbO0qJ0TmQKc4zd49CQ9L6ZCV16SbHDkceT
 qCZJlyWc
 jZk8hHyiknRRnvZHqa3tjU7ssJllZfLFVDQLZrwxu5EhElQ6+Tnlverg0pznkEKtUXN+0QSzoDK/2tkudKhhSW9h0X9TavnacxM/5BLtxqlp18k9UqS7ASm9Je3B6qWwl5A5eTfHDxfBwC/ClZrQuDDMZFmR6FFUfCl8DLvNNUhiIzIVOW/DLnFrq9TsIN/aDfcVE1TGnU4ySE1riYZM+hThW1zfWFTgQ653XcGDpK8PEiWNQUR9l81Rh38nJi5JSrufU/64ablpxFv9xpwFnmOOVzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/23/25 23:49, Benno Lossin wrote:
> On Tue Sep 23, 2025 at 12:27 PM CEST, Vitaly Wool wrote:
>> diff --git a/rust/kernel/zpool.rs b/rust/kernel/zpool.rs
>> new file mode 100644
>> index 000000000000..53a0dc0607e6
>> --- /dev/null
>> +++ b/rust/kernel/zpool.rs
>> @@ -0,0 +1,366 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Implementation of Rust interface towards zpool API.
>> +
>> +use crate::{error::Result, kernel::alloc::Flags, str::CString, types::ForeignOwnable};
>> +use core::ptr::NonNull;
>> +use kernel::alloc::NumaNode;
>> +
>> +/// The Rust representation of zpool handle.
> 
> Would be great to explain what this means, what's the handle used for?

Sorry, do you mean explaining it here or in the code?

>> +pub struct ZpoolHandle(usize);
>> +
>> +impl ZpoolHandle {
>> +    /// Create `ZpoolHandle` from the raw representation.
>> +    pub fn from_raw(h: usize) -> Self {
>> +        Self(h)
>> +    }
>> +
>> +    /// Get the raw representation of the handle.
>> +    pub fn as_raw(self) -> usize {
>> +        self.0
>> +    }
> 
> Hmm this seems a bit weird, because now users of Zpools can manufacture
> their own handles? Not sure as to how we could still allow Zpool
> implementers to create these while preventing other users from doing
> creating them though...

This is a good question indeed. The thing is, an allocation backend 
(these implementing zpool api) is to provide an opaque handle which is 
usize, and since it has the best knowledge how to compose it, we need to 
let it do that. OTOH I am not too happy with this straightforward 
approach (from_raw()/as_raw()) either.

Would making ZpoolHandle opaque here and defining a trait that a backend 
must implement for ZpoolHandle work better? The example backend would 
then do something like

struct MyZpoolHandle {
     ptr: *mut u8,
     pow: usize,
}
type ZpoolHandle = MyZpoolHandle;

trait AsRawHandle {
     fn as_raw_handle(&self) -> usize;
}

impl AsRawHandle for ZpoolHandle {
     fn as_raw_handle(&self) -> usize {
         (self.ptr as usize) | self.pow
     }
}

Would that make sense?

>> +
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
>> +/// use kernel::alloc::{Flags, flags, KBox, KVec, NumaNode};
>> +/// use kernel::page::PAGE_SHIFT;
>> +/// use kernel::prelude::EINVAL;
>> +/// use kernel::str::CString;
>> +/// use kernel::zpool::*;
>> +///
>> +/// struct MyZpool {
>> +///     name: CString,
>> +///     bytes_used: AtomicU64,
>> +/// }
>> +///
>> +/// struct MyZpoolDriver;
>> +///
>> +/// impl ZpoolDriver for MyZpoolDriver {
>> +///     type Pool = KBox<MyZpool>;
>> +///
>> +///     fn create(name: CString, gfp: Flags) -> Result<KBox<MyZpool>> {
>> +///         let my_pool = MyZpool { name, bytes_used: AtomicU64::new(0) };
>> +///         let pool = KBox::new(my_pool, gfp)?;
>> +///
>> +///         pr_debug!("Pool {:?} created\n", pool.name);
>> +///         Ok(pool)
>> +///     }
>> +///
>> +///     fn malloc(pool: &MyZpool, size: usize, _gfp: Flags, _nid: NumaNode) -> Result<ZpoolHandle> {
>> +///         let pow = size.next_power_of_two().trailing_zeros().max(6);
>> +///         match pow {
>> +///             0 => Err(EINVAL),
>> +///             m if m > PAGE_SHIFT as u32 => Err(ENOSPC),
>> +///             _ => {
>> +///                 let vec = KVec::<u8>::with_capacity(1 << pow, GFP_KERNEL)?;
>> +///                 let (ptr, _len, _cap) = vec.into_raw_parts();
>> +///
>> +///                 // We assume that kmalloc-64, kmalloc-128 etc. kmem caches will be used for
>> +///                 // our allocations, so it's actually `1 << pow` bytes that we have consumed.
>> +///                 pool.bytes_used.fetch_add(1 << pow, Ordering::Relaxed);
>> +///
>> +///                 // `kmalloc` guarantees that an allocation of size x*2^n is 2^n aligned.
>> +///                 // Therefore the 6 lower bits are zeros and we can use these to store `pow`.
>> +///                 Ok(ZpoolHandle::from_raw(ptr as usize | (pow as usize - 6)))
>> +///             }
>> +///         }
>> +///     }
>> +///
>> +///     unsafe fn free(pool: &MyZpool, handle: ZpoolHandle) {
>> +///         let h = handle.as_raw();
>> +///         let n = (h & 0x3F) + 6;
>> +///         let uptr = h & !0x3F;
>> +///
>> +///         // SAFETY:
>> +///         // - we derive `uptr` from handle by zeroing 6 lower bits where we store the power
>> +///         //   denominator for the vector capacity. As noted above, the result will be exactly the
>> +///         //   pointer to the area allocated by `KVec`. Thus, uptr is a valid pointer pointing to
>> +///         //   the vector allocated by `alloc` function above.
>> +///         // - 1 << n == capacity and is coming from the first 6 bits of handle.
>> +///         let vec = unsafe { KVec::<u8>::from_raw_parts(uptr as *mut u8, 0, 1 << n) };
>> +///         drop(vec);
>> +///         pool.bytes_used.fetch_sub(1 << n, Ordering::Relaxed);
>> +///     }
>> +///
>> +///     unsafe fn read_begin(_pool: &MyZpool, handle: ZpoolHandle) -> NonNull<u8> {
>> +///         let uptr = handle.as_raw() & !0x3F;
>> +///         // SAFETY:
>> +///         // - we derive `uptr` from handle by zeroing 6 lower bits where we store the power
>> +///         //   denominator for the vector capacity. As noted above, the result will be exactly the
>> +///         //   pointer to the area allocated by `KVec`. Thus, uptr is a valid pointer pointing to
>> +///         //   the vector allocated by `alloc` function above.
>> +///         unsafe { NonNull::new_unchecked(uptr as *mut u8) }
>> +///     }
>> +///
>> +///     unsafe fn read_end(_pool: &MyZpool, _handle: ZpoolHandle, _handle_mem: NonNull<u8>) {}
>> +///
>> +///     unsafe fn write(_p: &MyZpool, handle: ZpoolHandle, h_mem: NonNull<u8>, mem_len: usize) {
>> +///         let uptr = handle.as_raw() & !0x3F;
>> +///         // SAFETY:
>> +///         // - `h_mem` is a valid non-null pointer provided by zswap.
>> +///         // - `uptr` is derived from handle by zeroing 6 lower bits where we store the power
>> +///         //   denominator for the vector capacity. As noted above, the result will be exactly the
>> +///         //   pointer to the area allocated by `KVec`. Thus, uptr is a valid pointer pointing to
>> +///         //   the vector allocated by `alloc` function above.
>> +///         unsafe {
>> +///             copy_nonoverlapping(h_mem.as_ptr().cast(), uptr as *mut c_void, mem_len)
>> +///         };
>> +///     }
>> +///
>> +///     fn total_pages(pool: &MyZpool) -> u64 {
>> +///         pool.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
>> +///     }
>> +/// }
>> +///
>> +/// // Uncomment this for compile time registration (disabled to avoid build error when KUNIT
>> +/// // tests and zsmalloc are enabled):
>> +/// // kernel::DECLARE_ZPOOL!(MyZpoolDriver);
>> +/// ```
>> +///
>> +pub trait ZpoolDriver {
>> +    /// Opaque Rust representation of `struct zpool`.
>> +    type Pool: ForeignOwnable;
> 
> Also what happened to my comment on v4 of this patchset?
> 
> https://lore.kernel.org/all/DCLK1YG1L5TZ.1VMGX131LII9V@kernel.org:
> 
>>> It can indeed but then the ZpoolDriver trait will have to be extended
>>> with functions like into_raw() and from_raw(), because zpool expects
>>> *mut c_void, so on the Adapter side it will look like
>>>
>>>       extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void {
>>>           // SAFETY: the memory pointed to by name is guaranteed by zpool
>>> to be a valid string
>>>           let pool = unsafe { T::create(CStr::from_char_ptr(name),
>>> Flags::from_raw(gfp)) };
>>>           match pool {
>>>               Err(_) => null_mut(),
>>>               Ok(p) => T::into_raw(p).cast(),
>>>           }
>>>       }
>>>
>>> The question is, why does this make it better?
>>
>> No, thanks for sharing that function. Then the question becomes, do you
>> really need `ForeignOwnable`? Or is `KBox` enough? Do you really want
>> people to use `Arc<MyZPool>`? Because `BorrowedMut` of `Arc` is the same
>> as it's `Borrowed` variant (it's read-only after all).
>>
>> If you can get away with just `Box` (you might want people to choose
>> their allocator, which is fine IMO), then I'd do so.
> 
> I still think that if you can use `Box<Self>` the trait is going to be
> much easier to understand.

Okay, thanks, I'll work on that.

>> +
>> +    /// Create a pool.
>> +    fn create(name: CString, gfp: Flags) -> Result<Self::Pool>;
>> +
>> +    /// Allocate an object of `size` bytes from `pool`, with the allocation flags `gfp` and
>> +    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
>> +    fn malloc(
>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>> +        size: usize,
>> +        gfp: Flags,
>> +        nid: NumaNode,
>> +    ) -> Result<ZpoolHandle>;
>> +
>> +    /// Free an object previously allocated from the `pool`, represented by `handle`.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// - `handle` must be a valid handle previously returned by `malloc`.
>> +    /// - `handle` must not be used any more after the call to `free`.
>> +    unsafe fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: ZpoolHandle);
>> +
>> +    /// Make all the necessary preparations for the caller to be able to read from the object
>> +    /// represented by `handle` and return a valid pointer to that object's memory to be read.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// - `handle` must be a valid handle previously returned by `malloc`.
>> +    /// - `read_end` with the same `handle` must be called for each `read_begin`.
>> +    unsafe fn read_begin(
>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>> +        handle: ZpoolHandle,
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
>> +        handle: ZpoolHandle,
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
>> +    /// - `handle_mem` must be a valid pointer into the allocated memory aread represented by
>> +    ///   `handle`.
>> +    /// - `handle_mem + mem_len - 1` must not point outside the allocated memory area.
>> +    unsafe fn write(
>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>> +        handle: ZpoolHandle,
>> +        handle_mem: NonNull<u8>,
>> +        mem_len: usize,
>> +    );
>> +
>> +    /// Get the number of pages used by the `pool`.
>> +    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -> u64;
>> +}
>> +
>> +/// Provide a zpool allocator to zswap
>> +#[macro_export]
>> +macro_rules! DECLARE_ZPOOL {
> 
> Why all caps and not snake case?

C style, sorry :) Will fix.

>> +    ($t: ident) => {
>> +        use core::ptr::null_mut;
>> +        use kernel::error::from_result;
>> +        use kernel::types::ForeignOwnable;
> 
> Macros shouldn't have `use` statements in a non-local area (so inside
> `const` bodies and modules is fine).
> 
>> +
>> +        const __LOG_PREFIX: &[u8] = b"zpool_rust\0";
> 
> This seems wrong. Why do you need to generate this? Shouldn't the user
> still invoke `module!` or a similar macro?

Unfortunately not. As we have discussed at Kangrejos, the zpool 
implementation as a driver is on its way out [1] and there has to be 
more voices against that for it to be stopped. If we now are dealing 
with the build time API (i. e. a wrapper over zsmalloc functions) then 
we have to define a build time macro, be that DECLARE_ZPOOL or 
DeclareZpool :)

>> +
>> +        fn handle_from_result<T, F>(f: F) -> T
>> +        where
>> +            T: From<usize>,
>> +            F: FnOnce() -> Result<T>,
>> +        {
>> +            match f() {
>> +                Ok(v) => v,
>> +                Err(e) => T::from(0),
>> +            }
>> +        }
> 
> Why is this function inside the macro?

Doesn't seem to be needed elsewhere. I could put it in a separate patch 
for error.rs as a complement to from_result() but I thought no one was 
interested in this case.

>> +
>> +        /// Create a pool.
>> +        #[no_mangle]
>> +        pub unsafe extern "C" fn zpool_create_pool(name: *const c_uchar) -> *mut c_void {
> 
> Missing safety docs.
> 
>> +            match (|| -> Result<<$t as ZpoolDriver>::Pool> {
>> +                // SAFETY: the memory pointed to by name is guaranteed by `zpool` to be a valid
>> +                // string.
>> +                let name_r = unsafe { CStr::from_char_ptr(name).to_cstring() }?;
>> +                $t::create(name_r, flags::GFP_KERNEL)
>> +            })() {
>> +                Err(_) => null_mut(),
>> +                Ok(pool) => <$t as ZpoolDriver>::Pool::into_foreign(pool),
>> +            }
>> +        }
>> +
>> +        /// Destroy the pool.
>> +        #[no_mangle]
>> +        pub unsafe extern "C" fn zpool_destroy_pool(pool: *mut c_void) {
>> +            // SAFETY: The pointer originates from an `into_foreign` call.
>> +            drop(unsafe { <$t as ZpoolDriver>::Pool::from_foreign(pool) })
>> +        }
> 
> Have you tried to use the same pattern that we use for the many
> different `Registration` types in the kernel? For example take a look at
> `Adapter<T>` from `rust/kernel/net/phy.rs`. That way you don't need a
> macro and can make the registration a function that takes a generic `T:
> ZpoolDriver`.

That's what was in the previous version. Unfortunately it won't work any 
more for the reason described above, see also [1].

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/mm?h=mm-stable&id=2ccd9fecd9163f168761d4398564c81554f636ef


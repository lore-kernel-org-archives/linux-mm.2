Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A6ECA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 21:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7378E001C; Wed, 20 Aug 2025 17:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858428E0010; Wed, 20 Aug 2025 17:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E3A8E001C; Wed, 20 Aug 2025 17:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6713F8E0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:23:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA3D61A016A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:23:42 +0000 (UTC)
X-FDA: 83798412684.17.D82C6C0
Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 79B651C0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:23:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=weathered-steel.dev header.s=protonmail3 header.b="mf/R3nKQ";
	dmarc=pass (policy=quarantine) header.from=weathered-steel.dev;
	spf=pass (imf18.hostedemail.com: domain of elle@weathered-steel.dev designates 185.70.43.172 as permitted sender) smtp.mailfrom=elle@weathered-steel.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755725021; a=rsa-sha256;
	cv=none;
	b=EeDbbZXh+kQpdc1p4f1SqX6E6gj4kaxC3npyNTEOtocMqCQwty9IopVextROdqubZQvCxx
	g3BiPy+g/kEI3kmpWD6htwArAOCuTugeVFhlzVM0Qevw61kcU0NcKW4HYKbYlzvLN6y5rx
	JBOwAqag6+YKcTWT6jUb4yYD2L6Q3hY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=weathered-steel.dev header.s=protonmail3 header.b="mf/R3nKQ";
	dmarc=pass (policy=quarantine) header.from=weathered-steel.dev;
	spf=pass (imf18.hostedemail.com: domain of elle@weathered-steel.dev designates 185.70.43.172 as permitted sender) smtp.mailfrom=elle@weathered-steel.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755725021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2lmMiCxz3z9eulaWrPb4mQAD1x3ljhwt9NkaF9b+Ms=;
	b=mTSKE5a/BDXvDzoaQ77y8huTFRB1OWAUx5O+S7CMne+fnQTFHldkgoAhPrtLREVb4QWM/d
	Egp6cAg0SNMSBWeM9ykf0kFRzt6loiMLgQ5I9UaBx5AJqx54T0NrWvXwTZOzFrPffc9E0a
	1ry+AKS6kr9iJ6uhI1NW3GiTW918DaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=weathered-steel.dev;
	s=protonmail3; t=1755725016; x=1755984216;
	bh=L2lmMiCxz3z9eulaWrPb4mQAD1x3ljhwt9NkaF9b+Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:In-Reply-To:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=mf/R3nKQZI2mPzyjYexMBO1WjpPYu8Ev1dvQvwEeIYNHO6zGIDnwxtUNaEdIzTK24
	 hL0/FCXiJoyJIA/rjysJji75pmFjWcrQ4ESMvjo1ICGI1J6qhknFLq7UU//ANbohrM
	 fh34H/E8GvHijMXhNR6gQThWIFz4mVYrmX5XSv+xYy5tbe4KQnJoS66scV7Wsm+a9S
	 AHGR/hg6ob3dARXKjKl26pxmizmUrhQTfK8rZgCOKz+SPL8miBvcyOOyxb4OEtxULz
	 cFGXyERFZtfo1LuFyFwVhFxrmqe4LtfhwJnm/fdPsV+fEWz1TX6Sva9TVedsu8GQdA
	 i1X7tqtGJtXMA==
X-Pm-Submission-Id: 4c6fZY6bN4z1DDrn
Date: Wed, 20 Aug 2025 21:23:30 +0000
From: Elle Rhumsaa <elle@weathered-steel.dev>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH] rust: zpool: add abstraction for zpool drivers
Message-ID: <aKY80tcyQ8WHog1q@archiso>
References: <20250820091543.4165305-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820091543.4165305-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 79B651C0003
X-Stat-Signature: ijnt6zf85g8eqtgqq9g8c3e344nd16rs
X-HE-Tag: 1755725020-794003
X-HE-Meta: U2FsdGVkX1/APhz9NMBD++jYzP6A+5CZcdkBHDm2Qu6zTyt8MFOXDBKH4yCPJSkPIRs4o7qLPKeyAtQZk7c1TbVHYEWn9nhBfcu53tUmOplgmQI0En2LdL2yKsJ3zfmbh/CERlV0wiSMDNRNoUkvuHC323SG6jPt/t8rKZyuWXHPthDXog2SB8yx1NV4rWdzgZyCw2W/Pz+s3+l5v0W2wdVVU5gIOPJYL4MCbM7FRlWgwkag6jpHYp34fsopeudtEWj0THkvj5pnN6LPxjBMTfE/agFRq52qHHE5PmNtTW2JnF7HSGLSjeE5w1kUJsOQrIpVwm162odVLdXjxoMKfzX6spYx1lPL3A87y2RRCIyS3FW+b9VYoTGjm3v6UNiy7enaHrCnkzzfqBTYy5o/mKzoMYLdt1EemqgqlU9D9LCbkVOQe6/lVHQXkUwOHHbEULjOFrDNTvnd1BAr4jbIZfkOauzQ2Eh4rQf3Cja3BazFYeaP3EfJ5ZGGuVweWqMnJ26yZmSed3DXcQUQt3drgzUskSYIynd8kxvcnFAqJJVO30dJuFcKtK7ZfS0FpcBQJ/QNcTBMbATPZZMutvkHtXVDDsH3VYEkJxIkTytASpKLK48lJo71Zw7+e7JwtunpuEttZdB/95FSPfsMMDIGXcMSO5ZddcxHqH0l/ceR4BODD/GH4yhpleCGUmKXbli4gIX6+CYrnXSX5k2p7OItzfJ4KRE2mvIvyrJkOi/9n081bYScmIesBjrJS1ZINcjCoOHoFBG0N6F9amz9Txnwkv+/W5eF23eOjdfBwpYBW08uaj41QRstlsxmv7ytmULedmtWTycs3JDT7Zkd4jSzFs9Q1C1j/quF6FfuFdyNvZMMn0Au09YK+RUtZo7G00m7BlRt37QUFxNKSUX/aUKPLsYRlUaTS1QoTnVTtheqvxIB7voCdBoGsJipnLISWF9iavOFMSRf6nKc9mrsrOC
 KmKDW/cI
 4p6AK0tpUq1YZh2xljZKm3ejWcPWCYcSWJ72aytasOiyKRf/t2t48V0eUUhm526PZyGNu3aH8LsiNg0swj7nfDvIaZlCs4lExXyoBDCbf62F954LasHxtf4VB5uh0mLEBVRmqTRQrLEt8O03olChqamT3L7SuNS6cPU6l3S698zhqsFbRn4CknFOqFuRecxiEJPeky3KHpZCLLJQgOEkYz0arPqCpxAgWkEF7IRYXRHo+c2ZFIteaO0nMtocPqXVj9DkLdw+3uGeSLUNctqn3h7UpIbQ6ZSwfLGLd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 11:15:43AM +0200, Vitaly Wool wrote:
> Zpool is a common frontend for memory storage pool implementations.
> These pools are typically used to store compressed memory objects,
> e. g. for Zswap, the lightweight compressed cache for swap pages.
> 
> This patch provides the interface to use Zpool in Rust kernel code,
> thus enabling Rust implementations of Zpool allocators for Zswap.
> 
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers/helpers.c          |   1 +
>  rust/helpers/zpool.c            |   6 +
>  rust/kernel/alloc.rs            |   5 +
>  rust/kernel/lib.rs              |   2 +
>  rust/kernel/zpool.rs            | 269 ++++++++++++++++++++++++++++++++
>  6 files changed, 284 insertions(+)
>  create mode 100644 rust/helpers/zpool.c
>  create mode 100644 rust/kernel/zpool.rs
> 
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 84d60635e8a9..f0c4c454882b 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -75,6 +75,7 @@
>  #include <linux/wait.h>
>  #include <linux/workqueue.h>
>  #include <linux/xarray.h>
> +#include <linux/zpool.h>
>  #include <trace/events/rust_sample.h>
>  
>  #if defined(CONFIG_DRM_PANIC_SCREEN_QR_CODE)
> diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
> index 7cf7fe95e41d..e1a7556cc700 100644
> --- a/rust/helpers/helpers.c
> +++ b/rust/helpers/helpers.c
> @@ -51,3 +51,4 @@
>  #include "wait.c"
>  #include "workqueue.c"
>  #include "xarray.c"
> +#include "zpool.c"
> diff --git a/rust/helpers/zpool.c b/rust/helpers/zpool.c
> new file mode 100644
> index 000000000000..71ba173f917a
> --- /dev/null
> +++ b/rust/helpers/zpool.c
> @@ -0,0 +1,6 @@
> +#include <linux/zpool.h>
> +
> +void rust_helper_zpool_register_driver(struct zpool_driver *driver)
> +{
> +	zpool_register_driver(driver);
> +}
> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
> index b39c279236f5..0fec5337908c 100644
> --- a/rust/kernel/alloc.rs
> +++ b/rust/kernel/alloc.rs
> @@ -41,6 +41,11 @@
>  pub struct Flags(u32);
>  
>  impl Flags {
> +    /// Create from the raw representation
> +    pub fn new(f: u32) -> Self {
> +        Self(f)
> +    }
> +
>      /// Get the raw representation of this flag.
>      pub(crate) fn as_raw(self) -> u32 {
>          self.0
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index ed53169e795c..165d52feeea4 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -129,6 +129,8 @@
>  pub mod uaccess;
>  pub mod workqueue;
>  pub mod xarray;
> +#[cfg(CONFIG_ZPOOL)]
> +pub mod zpool;
>  
>  #[doc(hidden)]
>  pub use bindings;
> diff --git a/rust/kernel/zpool.rs b/rust/kernel/zpool.rs
> new file mode 100644
> index 000000000000..91926c2e99e8
> --- /dev/null
> +++ b/rust/kernel/zpool.rs
> @@ -0,0 +1,269 @@
> +use crate::{
> +    bindings,
> +    error::Result,
> +    kernel::alloc::Flags,
> +    str::CStr,
> +    types::{ForeignOwnable, Opaque},
> +};
> +use core::ffi::{c_int, c_uchar, c_void};
> +use core::ptr::null_mut;
> +use kernel::alloc::NumaNode;
> +use kernel::ThisModule;
> +
> +/// zpool API
> +pub trait Zpool {
> +    /// Opaque Rust representation of `struct zpool`.
> +    type Pool: ForeignOwnable;
> +
> +    /// Create a pool.
> +    fn create(name: *const c_uchar, gfp: Flags) -> Result<Self::Pool>;
> +
> +    /// Destroy the pool.
> +    fn destroy(pool: Self::Pool);
> +
> +    /// Allocate an object of size `size` using GFP flags `gfp` from the pool `pool`, wuth the
> +    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
> +    fn malloc(
> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
> +        size: usize,
> +        gfp: Flags,
> +        nid: NumaNode,
> +    ) -> Result<usize>;
> +
> +    /// Free a previously allocated from the `pool` object, represented by `handle`.
> +    fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize);
> +
> +    /// Make all the necessary preparations for the caller to be able to read from the object
> +    /// represented by `handle` and return a valid pointer to the `handle` memory to be read.
> +    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize)
> +        -> *mut c_void;
> +
> +    /// Finish reading from a previously allocated `handle`. `handle_mem` must be the pointer
> +    /// previously returned by `read_begin`.
> +    fn read_end(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +        handle_mem: *mut c_void,
> +    );
> +
> +    /// Write to the object represented by a previously allocated `handle`. `handle_mem` points
> +    /// to the memory to copy data from, and `mem_len` defines the length of the data block to
> +    /// be copied.
> +    fn write(
> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
> +        handle: usize,
> +        handle_mem: *mut c_void,
> +        mem_len: usize,
> +    );
> +
> +    /// Get the number of pages used by the `pool`.
> +    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -> u64;
> +}
> +
> +/// Zpool driver registration trait.
> +pub trait Registration {
> +    /// Register a zpool driver.
> +    fn register(&self, name: &'static CStr, module: &'static ThisModule) -> Result;
> +
> +    /// Pool creation callback.
> +    extern "C" fn _create(name: *const c_uchar, gfp: u32) -> *mut c_void;
> +
> +    /// Pool destruction callback.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
> +    unsafe extern "C" fn _destroy(pool: *mut c_void);
> +
> +    /// Callback for object allocation in the pool.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool` and that `handle`
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
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
> +    unsafe extern "C" fn _free(pool: *mut c_void, handle: usize);
> +
> +    /// Callback to prepare the object for reading.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
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
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
> +    unsafe extern "C" fn _obj_read_end(pool: *mut c_void, handle: usize, handle_mem: *mut c_void);
> +
> +    /// Callback for writing to an object.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
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
> +    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
> +    unsafe extern "C" fn _total_pages(pool: *mut c_void) -> u64;
> +}
> +
> +/// Zpool driver structure.
> +pub struct ZpoolDriver<T: Zpool> {
> +    inner: Opaque<bindings::zpool_driver>,
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
> +
> +// SAFETY: zpool driver must ensure that ZpoolDriver's `callbacks` are thread safe
> +unsafe impl<T: Zpool> Sync for ZpoolDriver<T> {}
> +
> +impl<T: Zpool> ZpoolDriver<T> {
> +    /// create an instance of a zpool driver
> +    pub const fn new(t: T) -> Self {
> +        Self {
> +            inner: Opaque::uninit(),
> +            callbacks: t,
> +        }
> +    }
> +}
> +
> +impl<T: Zpool> Registration for ZpoolDriver<T> {
> +    extern "C" fn _create(name: *const c_uchar, gfp: u32) -> *mut c_void {
> +        let pool = T::create(name, Flags::new(gfp));
> +        match pool {
> +            Err(_) => null_mut(),
> +            Ok(p) => T::Pool::into_foreign(p),
> +        }
> +    }
> +    unsafe extern "C" fn _destroy(pool: *mut c_void) {
> +        // SAFETY: The pointer originates from an `into_foreign` call.
> +        T::destroy(unsafe { T::Pool::from_foreign(pool) })
> +    }
> +    unsafe extern "C" fn _malloc(
> +        pool: *mut c_void,
> +        size: usize,
> +        gfp: u32,
> +        handle: *mut usize,
> +        nid: c_int,
> +    ) -> c_int {
> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
> +        // method.
> +        let pool = unsafe { T::Pool::borrow_mut(pool) };
> +        let real_nid = match nid {
> +            bindings::NUMA_NO_NODE => Ok(NumaNode::NO_NODE),
> +            _ => NumaNode::new(nid),
> +        };
> +        if real_nid.is_err() {
> +            return -(bindings::EINVAL as i32);
> +        }
> +
> +        let result = T::malloc(pool, size, Flags::new(gfp), real_nid.unwrap());
> +        match result {
> +            Err(_) => -(bindings::ENOMEM as i32),
> +            Ok(h) => {
> +                // SAFETY: handle is guaranteed to be a valid pointer by zpool
> +                unsafe { *handle = h };
> +                0
> +            }
> +        }
> +    }
> +    unsafe extern "C" fn _free(pool: *mut c_void, handle: usize) {
> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
> +        // method.
> +        let pool = unsafe { T::Pool::borrow(pool) };
> +        T::free(pool, handle)
> +    }
> +    unsafe extern "C" fn _obj_read_begin(
> +        pool: *mut c_void,
> +        handle: usize,
> +        _local_copy: *mut c_void,
> +    ) -> *mut c_void {
> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
> +        // method.
> +        let pool = unsafe { T::Pool::borrow(pool) };
> +        T::read_begin(pool, handle)
> +    }
> +    unsafe extern "C" fn _obj_read_end(pool: *mut c_void, handle: usize, handle_mem: *mut c_void) {
> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
> +        // method.
> +        let pool = unsafe { T::Pool::borrow(pool) };
> +        T::read_end(pool, handle, handle_mem)
> +    }
> +    unsafe extern "C" fn _obj_write(
> +        pool: *mut c_void,
> +        handle: usize,
> +        handle_mem: *mut c_void,
> +        mem_len: usize,
> +    ) {
> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
> +        // method.
> +        let pool = unsafe { T::Pool::borrow(pool) };
> +        T::write(pool, handle, handle_mem, mem_len);
> +    }
> +    unsafe extern "C" fn _total_pages(pool: *mut c_void) -> u64 {
> +        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
> +        // `from_foreign`, then that happens in `_destroy` which will not be called during this
> +        // method.
> +        let pool = unsafe { T::Pool::borrow(pool) };
> +        T::total_pages(pool)
> +    }
> +
> +    fn register(&self, name: &'static CStr, module: &'static ThisModule) -> Result {
> +        // SAFETY: `ZpoolDriver::new()` ensures that `self.inner` is a valid pointer
> +        unsafe {
> +            (*(self.inner.get())).create = Some(Self::_create);
> +            (*(self.inner.get())).destroy = Some(Self::_destroy);
> +            (*(self.inner.get())).malloc = Some(Self::_malloc);
> +            (*(self.inner.get())).free = Some(Self::_free);
> +            (*(self.inner.get())).obj_read_begin = Some(Self::_obj_read_begin);
> +            (*(self.inner.get())).obj_read_end = Some(Self::_obj_read_end);
> +            (*(self.inner.get())).obj_write = Some(Self::_obj_write);
> +            (*(self.inner.get())).total_pages = Some(Self::_total_pages);
> +
> +            (*(self.inner.get())).owner = module.0;
> +            (*(self.inner.get())).type_ = name.as_char_ptr().cast_mut();
> +
> +            bindings::zpool_register_driver(self.inner.get());
> +        }
> +        Ok(())
> +    }
> +}
> -- 
> 2.39.2

Reviewed-by: Elle Rhumsaa <elle@weathered-steel.dev>


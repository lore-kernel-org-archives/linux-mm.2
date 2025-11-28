Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4F1D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2B56B002A; Fri, 28 Nov 2025 06:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA466B002B; Fri, 28 Nov 2025 06:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6AA6B002C; Fri, 28 Nov 2025 06:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C816A6B002A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:56:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8554A1318DC
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:56:37 +0000 (UTC)
X-FDA: 84159863634.11.B8A8735
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 71D2E40004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:56:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764330995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BzMvn6rVOglIVGHJ+6/DY1HUPbB7xhIlrjwkhvdRoxI=;
	b=4Ip0UbLKL3g3jaoWTzV9cPAi63RdWomTXo80iv/gZcLXJtAfLcpiDBmyVApAMuXC5WY/lm
	rfATEY8NdkkHEXna4IiEcMUB5pBYQm5RvcZnYCHQyFjtpGe703D7OWxcUa9Sa+3x/9QOwG
	uENxVNxJJ0NnC7M1vTmGbCNAQmYrbGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764330995; a=rsa-sha256;
	cv=none;
	b=KO4KEkvdAj9CRw1X1SaDqWTA7bG3royzaUCWsxcqX34q6iFdMrxtvs4jHvioP9C7lyg+ov
	dfDk3mdneEIDWpeM0AvqFx0DPJh5WsD2ssB1pIMSSXeWATKzAXybM0hDud/pTg8ufdFXnP
	YMkevI7rki9zRAWyZbB8Xg8uQTATBOA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7E11175A;
	Fri, 28 Nov 2025 03:56:26 -0800 (PST)
Received: from [10.57.89.189] (unknown [10.57.89.189])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EE653F73B;
	Fri, 28 Nov 2025 03:56:30 -0800 (PST)
Message-ID: <12d99a54-e111-4877-b8cd-cb1e58cd6d30@arm.com>
Date: Fri, 28 Nov 2025 11:56:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Will Deacon <will@kernel.org>, Daniel Almeida
 <daniel.almeida@collabora.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71D2E40004
X-Stat-Signature: 4i7eggfyyagobaf3gtfegjcb4ge5hhfa
X-Rspam-User: 
X-HE-Tag: 1764330995-655128
X-HE-Meta: U2FsdGVkX1+qN2hz9j+wICaXIiMma6bu75GNVd7jty2H97AEN8NI6kv59EZiR0sN16CV0tWnKgq0va9anH151ez7GObuNeqIMKM2XvbzCiKFgLgz1UPVxlhnmwiS5SEQuJGg/8W8dNbneOBvECSB/J3sdYKYXru9Ar5UUmQYkW4Io1zAcBvPsOyIlZ9x3Z65GAvQhjT/JSYHDGhirZ1SEOb7SIiJgai7d13e0r/xvIXTuDKgIDHZ7xCqqnVCcJu2CsHBLP5dMC918aSclJUU95uDagD3xgn/ObE4FuXKwYiNwK5nolkELf+pD/xwGA56fl2hN9kKGo3KbBqY4VjrG1dN9Mb2cD8eUWIkwM5iuqxfs5AnorioTxgC0e6XBjqfcjhM0r3SkSQtarXS0Se8Vz8XdzzGwXx/JKx2FXJuSV25iT+QROF5NI1e+rh86tDHwWNfSWnRL79UgHjOcNFU/qSMO1yihmoso5cItRdWLnH530/+jAoBEiL5e9vA4iLsHCGDQWp5qkoeh/WkwTDlBaUrItOjx82fE8qi2GGQILL+ZALkrxdT0sYDnLJyUdo3CttsPXl+B119jSKyvWxekYbxIX+e90HVzFm29V+1IELHhOz8Wy84AgGz65Vq1psq+tbBwQZewF0B4TbTis5+20yEVIRAX9AA15PRphNRxus451NS58U6afaeE7lvuv60+nvHv5bBmSZF7sdRipBGwQ7DCNUe415/vF3vnSTcObxWjztGc6XttacmYlG0WTlEkYZkifdkijtzPuuiV4Lnp7dDONL37txjPhccpBlHJ0Ekk77vkmF/l+qygiRvZHQAGY2DgLbB0cxsmPR6QiQ69/V0NyJnjFpVLPRITXeZ9SMazh9FgDR+h5gqJqbwhco05P6YX5fwwJaE8UfEycX2jKWFlFgsg0O5PGomcEsmCFryYHvmh+DkjpdE6yvZH+WgUwxJ2Xw/I0TphpXtJMe
 Wh1Dnjay
 H9LOEjrr3d+Ws5G/LR/YK/m+HAuxCV8Gky4ZsKOvZ8AW8RH4YrIPFErQxZO9G1nK0rIUFC5RD5cSk3psnp9Bc+AfL1q8oMAJVTHmBvTDZ+BB7c9W8YACXv2NAeEeY1uMWfv1OGE7Z74mh4i8DESpFj2yPIpZH6ycfqgoalZVvbqFOsf9q24LbPI7Qo1K+tzGLF+z+JyRkUL3As+iSEzzEIC4LBVSywz1Jngfa18Gt9zLeMPEb0l97Av3laVyzC0FCzlcPep+RgkavwvcXYplHARXJgKjmgkIvRPjugTZVreJMgPISq1pcl78hMfKG1+WScwzt+6UYBAiALXdeGeaY1LYiWLlLFSkgTbu2qNUZY95d4I9t4A7sJFoiShEugZa33wEaeMEup+jqoUE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-12 10:15 am, Alice Ryhl wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
> 
> This will be used by the Tyr driver to create and modify the page table
> of each address space on the GPU. Each time a mapping gets created or
> removed by userspace, Tyr will call into GPUVM, which will figure out
> which calls to map_pages and unmap_pages are required to map the data in
> question in the page table so that the GPU may access those pages when
> using that address space.
> 
> The Rust type wraps the struct using a raw pointer rather than the usual
> Opaque+ARef approach because Opaque+ARef requires the target type to be
> refcounted.
> 
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> This patch is based on [1] but I have rewritten and simplified large
> parts of it. The Asahi driver no longer uses the io-pgtable abstraction,
> and Nova never planned to (since NVIDIA has its own separate memory).
> Therefore, I have simplified these abstractions to fit the needs of the
> Tyr GPU driver.
> 
> This series depends on the PhysAddr typedef [2].
> 
> [1]: https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72daac75f1@collabora.com/
> [2]: https://lore.kernel.org/all/20251112-resource-phys-typedefs-v2-0-538307384f82@google.com/
> ---
>   rust/bindings/bindings_helper.h |   3 +-
>   rust/kernel/io.rs               |   1 +
>   rust/kernel/io/pgtable.rs       | 254 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 257 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 2e43c66635a2c9f31bd99b9817bd2d6ab89fbcf2..faab6bc9463321c092a8bbcb6281175e490caccd 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -56,8 +56,9 @@
>   #include <linux/fdtable.h>
>   #include <linux/file.h>
>   #include <linux/firmware.h>
> -#include <linux/interrupt.h>
>   #include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/io-pgtable.h>
>   #include <linux/ioport.h>
>   #include <linux/jiffies.h>
>   #include <linux/jump_label.h>
> diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
> index 56a435eb14e3a1ce72dd58b88cbf296041f1703e..5913e240d5a9814ceed52c6dc1a798e64158d567 100644
> --- a/rust/kernel/io.rs
> +++ b/rust/kernel/io.rs
> @@ -8,6 +8,7 @@
>   use crate::{bindings, build_assert, ffi::c_void};
>   
>   pub mod mem;
> +pub mod pgtable;
>   pub mod poll;
>   pub mod resource;
>   
> diff --git a/rust/kernel/io/pgtable.rs b/rust/kernel/io/pgtable.rs
> new file mode 100644
> index 0000000000000000000000000000000000000000..fe05bc1673f9a7741a887a3c9bbad866dd17a2b5
> --- /dev/null
> +++ b/rust/kernel/io/pgtable.rs
> @@ -0,0 +1,254 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! IOMMU page table management.
> +//!
> +//! C header: [`include/io-pgtable.h`](srctree/include/io-pgtable.h)
> +
> +use core::{
> +    marker::PhantomData,
> +    ptr::NonNull, //
> +};
> +
> +use crate::{
> +    alloc,
> +    bindings,
> +    device::{Bound, Device},
> +    devres::Devres,
> +    error::to_result,
> +    io::PhysAddr,
> +    prelude::*, //
> +};
> +
> +use bindings::io_pgtable_fmt;
> +
> +/// Protection flags used with IOMMU mappings.
> +pub mod prot {
> +    /// Read access.
> +    pub const READ: u32 = bindings::IOMMU_READ;
> +    /// Write access.
> +    pub const WRITE: u32 = bindings::IOMMU_WRITE;
> +    /// Request cache coherency.
> +    pub const CACHE: u32 = bindings::IOMMU_CACHE;
> +    /// Request no-execute permission.
> +    pub const NOEXEC: u32 = bindings::IOMMU_NOEXEC;
> +    /// MMIO peripheral mapping.
> +    pub const MMIO: u32 = bindings::IOMMU_MMIO;
> +    /// Privileged mapping.
> +    pub const PRIV: u32 = bindings::IOMMU_PRIV;

Nit: probably best to call this PRIVILEGED from day 1 for clarity - some 
day we may eventually get round to renaming the C symbol too, especially 
if we revisit the notion of "private" mappings (that's still on my ideas 
list...)

> +}
> +
> +/// Represents a requested `io_pgtable` configuration.
> +pub struct Config {
> +    /// Quirk bitmask (type-specific).
> +    pub quirks: usize,
> +    /// Valid page sizes, as a bitmask of powers of two.
> +    pub pgsize_bitmap: usize,
> +    /// Input address space size in bits.
> +    pub ias: u32,
> +    /// Output address space size in bits.
> +    pub oas: u32,
> +    /// IOMMU uses coherent accesses for page table walks.
> +    pub coherent_walk: bool,
> +}
> +
> +/// An io page table using a specific format.
> +///
> +/// # Invariants
> +///
> +/// The pointer references a valid io page table.
> +pub struct IoPageTable<F> {
> +    ptr: NonNull<bindings::io_pgtable_ops>,
> +    _marker: PhantomData<F>,
> +}
> +
> +// SAFETY: `struct io_pgtable_ops` is not restricted to a single thread.
> +unsafe impl<F> Send for IoPageTable<F> {}
> +// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
> +unsafe impl<F> Sync for IoPageTable<F> {}
> +
> +/// The format used by this page table.
> +pub trait IoPageTableFmt: 'static {
> +    /// The value representing this format.
> +    const FORMAT: io_pgtable_fmt;
> +}
> +
> +impl<F: IoPageTableFmt> IoPageTable<F> {
> +    /// Create a new `IoPageTable` as a device resource.
> +    #[inline]
> +    pub fn new(
> +        dev: &Device<Bound>,
> +        config: Config,
> +    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
> +        // SAFETY: Devres ensures that the value is dropped during device unbind.
> +        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
> +    }
> +
> +    /// Create a new `IoPageTable`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// If successful, then the returned value must be dropped before the device is unbound.
> +    #[inline]
> +    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> Result<IoPageTable<F>> {
> +        let mut raw_cfg = bindings::io_pgtable_cfg {
> +            quirks: config.quirks,
> +            pgsize_bitmap: config.pgsize_bitmap,
> +            ias: config.ias,
> +            oas: config.oas,
> +            coherent_walk: config.coherent_walk,
> +            tlb: &raw const NOOP_FLUSH_OPS,
> +            iommu_dev: dev.as_raw(),
> +            // SAFETY: All zeroes is a valid value for `struct io_pgtable_cfg`.
> +            ..unsafe { core::mem::zeroed() }
> +        };
> +
> +        // SAFETY:
> +        // * The raw_cfg pointer is valid for the duration of this call.
> +        // * The provided `FLUSH_OPS` contains valid function pointers that accept a null pointer
> +        //   as cookie.
> +        // * The caller ensures that the io pgtable does not outlive the device.
> +        let ops = unsafe {
> +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, core::ptr::null_mut())
> +        };
> +        // INVARIANT: We successfully created a valid page table.
> +        Ok(IoPageTable {
> +            ptr: NonNull::new(ops).ok_or(ENOMEM)?,
> +            _marker: PhantomData,
> +        })
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable_ops`.
> +    #[inline]
> +    pub fn raw_ops(&self) -> *mut bindings::io_pgtable_ops {
> +        self.ptr.as_ptr()
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable`.
> +    #[inline]
> +    pub fn raw_pgtable(&self) -> *mut bindings::io_pgtable {
> +        // SAFETY: The io_pgtable_ops of an io-pgtable is always the ops field of a io_pgtable.
> +        unsafe { kernel::container_of!(self.raw_ops(), bindings::io_pgtable, ops) }
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable_cfg`.
> +    #[inline]
> +    pub fn raw_cfg(&self) -> *mut bindings::io_pgtable_cfg {
> +        // SAFETY: The `raw_pgtable()` method returns a valid pointer.
> +        unsafe { &raw mut (*self.raw_pgtable()).cfg }
> +    }
> +
> +    /// Map a physically contiguous range of pages of the same size.
> +    ///
> +    /// # Safety
> +    ///
> +    /// * This page table must not contain any mapping that overlaps with the mapping created by
> +    ///   this call.

As mentioned this isn't necessarily true of io-pgtable itself, but since 
you've not included QUIRK_NO_WARN in the abstraction then it's fair if 
this layer wants to be a little stricter toward Rust users.

> +    /// * If this page table is live, then the caller must ensure that it's okay to access the
> +    ///   physical address being mapped for the duration in which it is mapped.
> +    #[inline]
> +    pub unsafe fn map_pages(
> +        &self,
> +        iova: usize,
> +        paddr: PhysAddr,
> +        pgsize: usize,
> +        pgcount: usize,
> +        prot: u32,
> +        flags: alloc::Flags,
> +    ) -> Result<usize> {
> +        let mut mapped: usize = 0;
> +
> +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
> +        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
> +
> +        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
> +        to_result(unsafe {
> +            (map_pages)(
> +                self.raw_ops(),
> +                iova,
> +                paddr,
> +                pgsize,
> +                pgcount,
> +                prot as i32,
> +                flags.as_raw(),
> +                &mut mapped,
> +            )
> +        })?;
> +
> +        Ok(mapped)

Just to double-check since I'm a bit unclear on the Rust semantics, this 
can correctly reflect all 4 outcomes back to the caller, right? I.e.:

- no error, mapped == pgcount * pgsize (success)
- no error, mapped < pgcount * pgsize (call again with the remainder)
- error, mapped > 0 (probably unmap that bit, unless clever trickery 
where an error was expected)
- error, mapped == 0 (nothing was done, straightforward failure)

(the only case not permitted is "no error, mapped == 0" - failure to 
make any progress must always be an error)

Alternatively you might want to consider encapsulating the 
partial-mapping handling in this layer as well - in the C code that's 
done at the level of the IOMMU API calls that io-pgtable-using IOMMU 
drivers are merely passing through, hence why panfrost/panthor have to 
open-code their own equivalents, but there's no particular reason to 
follow the *exact* same pattern here.

> +    }
> +
> +    /// Unmap a range of virtually contiguous pages of the same size.
> +    ///
> +    /// # Safety
> +    ///
> +    /// This page table must contain a mapping at `iova` that consists of exactly `pgcount` pages
> +    /// of size `pgsize`.

Again, the underlying requirement here is only that pgsize * pgcount 
represents the IOVA range of one or more consecutive ranges previously 
mapped, i.e.:

map(0, 4KB * 256);
map(1MB, 4KB * 256);
unmap(0, 2MB * 1);

is legal, since it's generally impractical for callers to know and keep 
track of the *exact* structure of a given pagetable. In this case there 
isn't really any good reason to try to be stricter.

Thanks,
Robin.

> +    #[inline]
> +    pub unsafe fn unmap_pages(&self, iova: usize, pgsize: usize, pgcount: usize) -> usize {
> +        // SAFETY: The `unmap_pages` function in `io_pgtable_ops` is never null.
> +        let unmap_pages = unsafe { (*self.raw_ops()).unmap_pages.unwrap_unchecked() };
> +
> +        // SAFETY: The safety requirements of this method are sufficient to call `unmap_pages`.
> +        unsafe { (unmap_pages)(self.raw_ops(), iova, pgsize, pgcount, core::ptr::null_mut()) }
> +    }
> +}
> +
> +// These bindings are currently designed for use by GPU drivers, which use this page table together
> +// with GPUVM. When using GPUVM, a single mapping operation may be translated into many operations
> +// on the page table, and in that case you generally want to flush the TLB only once per GPUVM
> +// operation. Thus, do not use these callbacks as they would flush more often than needed.
> +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops = bindings::iommu_flush_ops {
> +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> +    tlb_add_page: None,
> +};
> +
> +#[no_mangle]
> +extern "C" fn rust_tlb_flush_all_noop(_cookie: *mut core::ffi::c_void) {}
> +
> +#[no_mangle]
> +extern "C" fn rust_tlb_flush_walk_noop(
> +    _iova: usize,
> +    _size: usize,
> +    _granule: usize,
> +    _cookie: *mut core::ffi::c_void,
> +) {
> +}
> +
> +impl<F> Drop for IoPageTable<F> {
> +    fn drop(&mut self) {
> +        // SAFETY: The caller of `ttbr` promised that the page table is not live when this
> +        // destructor runs.
> +        unsafe { bindings::free_io_pgtable_ops(self.0.ops) };
> +    }
> +}
> +
> +/// The `ARM_64_LPAE_S1` page table format.
> +pub enum ARM64LPAES1 {}
> +
> +impl IoPageTableFmt for ARM64LPAES1 {
> +    const FORMAT: io_pgtable_fmt = bindings::io_pgtable_fmt_ARM_64_LPAE_S1 as io_pgtable_fmt;
> +}
> +
> +impl IoPageTable<ARM64LPAES1> {
> +    /// Access the `ttbr` field of the configuration.
> +    ///
> +    /// This is the physical address of the page table, which may be passed to the device that
> +    /// needs to use it.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that the device stops using the page table before dropping it.
> +    #[inline]
> +    pub unsafe fn ttbr(&self) -> u64 {
> +        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPAES1`.
> +        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.ttbr }
> +    }
> +
> +    /// Access the `mair` field of the configuration.
> +    #[inline]
> +    pub fn mair(&self) -> u64 {
> +        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPAES1`.
> +        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.mair }
> +    }
> +}
> 
> ---
> base-commit: ffee675aceb9f44b0502a8bec912abb0c4f4af62
> change-id: 20251111-io-pgtable-fe0822b4ebdd
> prerequisite-change-id: 20251106-resource-phys-typedefs-6db37927d159:v2
> prerequisite-patch-id: 350421d8dbaf3db51b1243d82077c5eb88f54db5
> prerequisite-patch-id: ac0166fb3cd235de76841789173051191a4d2434
> prerequisite-patch-id: f4bca02c77c40093690b66cdf477f928784bdbf4
> prerequisite-patch-id: 083d1c22b1a7eb0dcae37052b926362543c68e8a
> 
> Best regards,


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D36CF3195
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FDE6B00AD; Wed, 19 Nov 2025 05:56:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0086B00AE; Wed, 19 Nov 2025 05:56:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9A36B00AF; Wed, 19 Nov 2025 05:56:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41DD6B00AD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:56:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D33D858EB8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:56:39 +0000 (UTC)
X-FDA: 84127053318.21.F7B1D6D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id DDFF34000D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:56:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="bXD/sUd2";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763549798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RVv1iPEcmFLU2ntisOTedGzl7jMKrxpYuRYntBL9As=;
	b=GJYngxbX+g5ytwArP8GOOZ29SvxYKQNG1OPl9Jun/At2Pu/RGmlRnqQnYBedc+rqDGBDPs
	tsCFYNt2ZGphMnFPcuPi7Q7xVtsuFwtGVvDi1l4Htzg5UfLvf7+ZvHiIGoMVOJKVYUb2v8
	QHjVNK8YKOeuiqAMiTv3YAn3y5DPzSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763549798; a=rsa-sha256;
	cv=none;
	b=izL1Q4UCq+BGYTm1lOqGQ6m4j1+hel1UKsmaWSgPvG+owf7nr8CPBs+qQWGjQHCRw/JcM1
	3ffvax4mIPXa6aMX2PXL1FM0pjkp/a6xtcYh3BN/wsiW4AvwYCFAk+aLjOvR+g4f4LphHt
	AY2LP5iulkQ02kzQ9z7ph3LuCBRS79w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="bXD/sUd2";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763549795;
	bh=+REcE4wyY/nt3iCUtDWr3UUTUBjzFapAYIMZzv1QWV0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bXD/sUd2AuPWRopSVzFqV9kBBVyAbj4zoUX0hhmwl2yweVcFsFtRHQiOGUMgfuHV5
	 VJbF1ndcZ24CXMlLC2wvrmx7xQaD7+Ae3z0pWpPN7Sa25gbi91tV7RLUbgGl3TksF2
	 AVxNlZ4Fuv+Am2M1mXHRfVx4nzcbJxjlWWLqb/NIP5nC3qxn66DxgL0K8dSfR+9tA1
	 /eiE4khpD7i93VhC9/cUxXYmc0fYfNqET+fCB/koi1gpyUOER3a/4Gmb/iPqayrIkw
	 hhDRzQZoMuqM1EoxIgGlmsp/goZSufhVmzsubpg6FQzNQhuye17eZY+GgaMxNApqXt
	 TrM2Spivs/I6Q==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5E4FD17E12E5;
	Wed, 19 Nov 2025 11:56:34 +0100 (CET)
Date: Wed, 19 Nov 2025 11:56:30 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, Daniel
 Almeida <daniel.almeida@collabora.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, "=?UTF-8?B?QmrDtnJu?= Roy Baron"
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
 <robin.murphy@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Asahi Lina
 <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <20251119115630.708a124c@fedora>
In-Reply-To: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c9tr6qrrtgmzuburyqf46oumzx88d4xg
X-Rspam-User: 
X-Rspamd-Queue-Id: DDFF34000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763549797-990280
X-HE-Meta: U2FsdGVkX1+UstHuOtTl0L3uH3HJ8L8SipW0wEfcbkyg8Br3rU68VCA/bhXO7ygsg8zWpcXhGOK2NpyxQVzHaMmTkRbOE3VHL61sJSroD4gedYA2XpioSJnGOoVGL2oRmgYXkUAKZmP7im1Co7CTVpH2kh5CG4FPKeyhJ8wooQTcd2le5p9AQIkH6F6Y52q16sFzHVBtYjb64LvrJvcqwwew0qWvQig9UXHg9bktkPk8MlURqotP0Xkuzqn5TnaWkpl65O6oz3m1mTDDebC/5Od49XbinE2u4k4GiSF1FI6jKzoAIl/s+0WATbltcgVZe/DEHSd/yDVIuB2KfkU4VyCjCYKYReWYLj01We88yiuN1dURv+3gJfTZI2ZtWlkSHfQwx8sYBpmTASPFqVwjInYkiHTyOZL9ncZDBY/kOQJUDsNu/JiPXzVbTCmdUP5ogmBsGwh5G8TW3uOn7s+WhwpymV9G3Pt1bOLokXsLidkQklOYC/zWNZIknYNE2Lko9qBIlhUJsKKxDVkP47OivKHaZWv327DjPfVTeg37lUlCv2nbP7z7owat62CE5DjgsilZW7//HFGvp1GNI1JYIWwRK/Cr2JPC8H6IWsq3eoJ0GPMj7GUv1Eh7i5sSgM0yfng6+dpwm7OH3g+4Zze/Nlk9NBLdAdgPfsvAPyL1j842QPobz2TCa1rzO9oyPQgUFPTOwlwBhD37FGuH9lFXLU0tEa+HiEh06KtMwwFYLSYE1MDw9VxT2PsYs+EicAtNqIrpKTwDHoMGawWGqWO5YBEiI9P6scA5P3GyQiJS0KZcTXD5XEAmvUKVsLSGL3JQicy5neXEZJ17uzbESlhWPlj2999ilao/a/TQ+/YTFIWmVtpgPsKvEKeEKYiZgoG4FqfVTo0cA0OoWNxF3o6Oi/izOL+VWersxqwHAuwE5mOg1oO4KLL28DPZxncL0gEG3PlGV8G1vaYls8ZyAZF
 K+aJ2j5V
 mupxeqDVQdptzYoibZeb0yH8ByXRAAXGm1ZtKfisa+OHtLQY8mToAfHj3aKzI/raB4sOLlKL6oKcT2S9JsqqC1e9uTdZvQ5GnY9mGtPJyp6k7rjKAyFokwHhb34ntKaeJBz0wH1G3nvJCtddqNzduaCCgpuse0unGBa073Bu2HEM6cxCObMRZe2h3x2hKeFOES5BWU/aKY9Y3SXujM/xslvwS2F8vjFg+4wc8g3cS22Wl8IGxSb0E4EpZP4osvWSKwIUukMxlG2opi2jIuninVTAr/bjiqWHbQR37V5Zt72JcJ/Nj8Jmnbh2z8EoJEyj+RoTcfR4xXQVTj5H1n0w35cp2X4gEi3xqCwZIJiSUl/2S3mi9nzQ2m7DIMOEVBW+HPG7GQASmHdrPgwr3mjds1ppXb+Rg5YmWhXIdYV3B8UY+YrBdiAY4+SA9GUKib15CfowrW4ZoHVyiPH6a6FdAz1qpoB5QvaDtA9brD7MRkgmpy/gxfAtQWsCPyWqOsq9ChUfM4Kr8jCOCTQK+zGSjrR5Ajp9tLikPiVwkQyEhzrdfnPlpOCIikm598Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 10:15:00 +0000
Alice Ryhl <aliceryhl@google.com> wrote:

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

This seems to be enough for what we need in Tyr (which is what we
basically have in Panthor, but translated to rust)

I'm no rust expert and I'm not an iommu maintainer either, so I'm not
sure how useful that is, but this is

Acked-by: Boris Brezillon <boris.brezillon@collabora.com>

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
>  rust/bindings/bindings_helper.h |   3 +-
>  rust/kernel/io.rs               |   1 +
>  rust/kernel/io/pgtable.rs       | 254 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 2e43c66635a2c9f31bd99b9817bd2d6ab89fbcf2..faab6bc9463321c092a8bbcb6281175e490caccd 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -56,8 +56,9 @@
>  #include <linux/fdtable.h>
>  #include <linux/file.h>
>  #include <linux/firmware.h>
> -#include <linux/interrupt.h>
>  #include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/io-pgtable.h>
>  #include <linux/ioport.h>
>  #include <linux/jiffies.h>
>  #include <linux/jump_label.h>
> diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
> index 56a435eb14e3a1ce72dd58b88cbf296041f1703e..5913e240d5a9814ceed52c6dc1a798e64158d567 100644
> --- a/rust/kernel/io.rs
> +++ b/rust/kernel/io.rs
> @@ -8,6 +8,7 @@
>  use crate::{bindings, build_assert, ffi::c_void};
>  
>  pub mod mem;
> +pub mod pgtable;
>  pub mod poll;
>  pub mod resource;
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
> +    }
> +
> +    /// Unmap a range of virtually contiguous pages of the same size.
> +    ///
> +    /// # Safety
> +    ///
> +    /// This page table must contain a mapping at `iova` that consists of exactly `pgcount` pages
> +    /// of size `pgsize`.
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



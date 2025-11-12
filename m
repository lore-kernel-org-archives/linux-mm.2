Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A21CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 12:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B468E0009; Wed, 12 Nov 2025 07:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4878E0003; Wed, 12 Nov 2025 07:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446308E0009; Wed, 12 Nov 2025 07:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 293798E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:57:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD29BB9ACE
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:57:37 +0000 (UTC)
X-FDA: 84101956554.06.B30AD60
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id AB9E2A0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:57:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Ci94QM90;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf15.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762952256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lasbNH8TFs9tBmW5oYJnfXJbOCbLUtFN2LPxxb7aoxY=;
	b=2CB8kkW60h3rHwWcv9U6Gj2XfAtcUa0pxoUL8KFkIXIGTl5hqOb2IvjRRHEZ/aoDYXACsP
	JFcCEaEOEKgdVD3HyC+28tbQfR4kHIdvo2MN5oA1vqZ36U3s5aIYMQD6dM0h6nJm63mzkO
	cjOzGQt37L5yxLcnwKbhumhCpdSriHM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762952256; a=rsa-sha256;
	cv=pass;
	b=UAYgOyO2Mxr7WJOKnfpTYCX0UgHrUNsRK+/FXqcjm3ypDlOqU7Gwc65T0DKaOiLZbqdbQz
	dzy7/xeNtXLNKFHC8kYLHQ7Re/0XQj78S5IH3eGYTcUVNgzVDTyiQURqffDg6T2Un53SBx
	psYzZGDSlq12W3IF7rgXMDXyjG5w7AE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Ci94QM90;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf15.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1762952251; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HNxVywEwIxfryAuD5zzBYhvkZC8198SP2RK6ZvKxet5z0bGYTqWkIxOxIQibJ+Ukz1YFM12TUMOjcTcAla3bzEfQJpAfOPRZaD5bG9FkwhvqxsnlGNItSD3lQa28gLV78pwMO0t8Lae2BvqCxgGQMr7dcwvJzwsMfGI8d6EBG7A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762952251; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lasbNH8TFs9tBmW5oYJnfXJbOCbLUtFN2LPxxb7aoxY=; 
	b=RqvRMYn00Dpqc00LRjIeYBstNocwYYrxaD7eB5TsLmb0rm6MUKzpyb69SMl1yy4J6wNZp0+ztpM27BijDkmBv5/cMy1JU6ahbv2y87PEp4R7d41U04kRtVN/FBOnCmOFdSLsiewKfN6Be3jbi6EHzwOZcV8elByutEn0JHWYm94=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762952251;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=lasbNH8TFs9tBmW5oYJnfXJbOCbLUtFN2LPxxb7aoxY=;
	b=Ci94QM905kNJ+PitS0LYcmnnz4ycpBfxUXsZkHrpvQLVC8WkX9ft/6VbCL0AuQmZ
	mFfWyhITrj3SV2yZ4Us49BCDBxG2KjaO3Wu0mI+67fxGo55Fwa0sithHJ7E5q2986Yj
	8bdlxynaZGtK2IPJD3Pxuae909V1tjQ9lixMFork=
Received: by mx.zohomail.com with SMTPS id 1762952249485202.59169507502338;
	Wed, 12 Nov 2025 04:57:29 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
Date: Wed, 12 Nov 2025 09:57:09 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Will Deacon <will@kernel.org>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>,
 linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org,
 iommu@lists.linux.dev,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A5C6836-992B-477A-A77C-EE0736166552@collabora.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: hj6nbd539mc4bdezo9phrym51id48drx
X-Rspam-User: 
X-Rspamd-Queue-Id: AB9E2A0012
X-Rspamd-Server: rspam10
X-HE-Tag: 1762952255-363415
X-HE-Meta: U2FsdGVkX19qpCQ6F3CnLBrZLpL/dJmBluLsnpUf1lW3/7/ngP1sCOlYqCASkiU6HnsPAsNjgSSdmoAawBXjA5wsjSGwpq765bkn/XFMEUHSZhpYRWGTtgwyW8B/ZEgfNBJwDHlrl2b+LAPnsxrzKuc/hFvTxQ7tTRkpi6cEkCvkCFKvNEWlewOx07nwgLsbTRdrOmhD7W34VLFiGULLBl8MOv+d0CSPwK/8SBkFLWoy6f49BePL+/hSOGUvk5k/tsQS15RYaLPMBS3clOPG3vrIJpyH/kssadONue7mB+tMLMY/aJAI2nkjvWZxEsFqzN9BNpEZOvtwCCDZkIg2NZop5BeLXBtJVJeb6TaNaegKMdchGOwAa5s0g4KK4ja54OOw+2FcIBqQoH6gZwj/oxAtNfwuEX17KtkFd756e7WgGTLlMqaXkAgDdf2ZomFWQMx+UDRSvwIGHRJ61NozhtrrAkMVo14cigyxGQbfKwx5QFvgN10KIHgQfb63k2nI4pr5x6PdtPGWH39vWgnw58Q9SiEcdjHqA225w+RGQIAdp16ZoY3q8pkT6abUgak3uQAKIB+CdnG/qxi517r4+5tY8ihK1EC0XLChRBKqgpGe2CYL61AWRAfIfZLiNiPiVO97f8s8i65IgDZkvjTz+2emNypraYnUStbQxHf95ehbbP5xE3dsPd64rvzusCtJz41DhIF1DNdCGszCdu8bu2ImPTXdYye0W1QL2siAJUHUAlf323vwa15voyzlyACP1V31/BkxvZ9WXYayACKXhgZpWVGde6TPQxnfF9giMxWd40s/O2yeC5uECUajsG8H/xGCjqMMil7+avxQflvrKqWbrO/BMga3xO6mNXgwMtzrXRr9XqTbmE4REbzP2FJTqd/o8j5/vYl9VcUrCgummuHbCPjK3ygZSmSV+bOU80xngvg3gm6vJUeoYLIDOVSidQsuzStFDF7qGVIQ6Bp
 Lxbdg/jU
 S+1KDjwwmgmg0Jyks7qsgpb1c2maVBli6As9PEdB4jZMV8lDmjqutbRh4/uNUhYSdPMPXiW4jlePCuLUIwKbFHwbcX50d1MA2vbpDJGHlVL1WooHFJE6koG1JC+3C5SWr+uHEmehKPiNuZMZ/ygs9yOJzE96UzJjtJeVFNEGb0d0bqcpYxwhtEhq5WufCJHZUwyQCEnUYMSkrCOtw6GO+IK/D+djX4JZ/LK0G0sL3GNNczj7o4ehAFFzQbSTvcFCia21XN1uXxzn3I16NA7Cy/e/ar3hLqyFurp9tyrEcKdqbt3gEqtXodW5WJP3m3WKU6FruwJFhE17kx/dPKd9YLpv9nb4JUBYasEWDB+OX090raeo++ZUIl1abLFI8YUu2OvzinVItrANQXchXVSw1zYqCeGZzyjnhXXjO7Ik8L1gsHSN2RbPqxZwcQ6ik+sr9dIe2gxEsaZILwF/ylRrdi3w0RPN3WY1VEo5aixeNIeuAdhtoMrzQi5kJGzAuEUbJJcJIXKdqLJkeOWzP2XdsaO4Y2lNfUFQRYhY9a/NEaoyTiFfwma80yKCQ6EioEaFTGqA4O5sA8FIrS6gd+QtAMH446vRc91kvx5RQyGrzSU9wdR54r6gfFuPscw15CIj7mAtr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

> On 12 Nov 2025, at 07:15, Alice Ryhl <aliceryhl@google.com> wrote:
>=20
> From: Asahi Lina <lina+kernel@asahilina.net>
>=20
> This will be used by the Tyr driver to create and modify the page =
table
> of each address space on the GPU. Each time a mapping gets created or
> removed by userspace, Tyr will call into GPUVM, which will figure out
> which calls to map_pages and unmap_pages are required to map the data =
in
> question in the page table so that the GPU may access those pages when
> using that address space.
>=20
> The Rust type wraps the struct using a raw pointer rather than the =
usual
> Opaque+ARef approach because Opaque+ARef requires the target type to =
be
> refcounted.
>=20
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> This patch is based on [1] but I have rewritten and simplified large
> parts of it. The Asahi driver no longer uses the io-pgtable =
abstraction,
> and Nova never planned to (since NVIDIA has its own separate memory).
> Therefore, I have simplified these abstractions to fit the needs of =
the
> Tyr GPU driver.
>=20
> This series depends on the PhysAddr typedef [2].
>=20
> [1]: =
https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72daac75f1@collabor=
a.com/
> [2]: =
https://lore.kernel.org/all/20251112-resource-phys-typedefs-v2-0-538307384=
f82@google.com/
> ---
> rust/bindings/bindings_helper.h |   3 +-
> rust/kernel/io.rs               |   1 +
> rust/kernel/io/pgtable.rs       | 254 =
++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 257 insertions(+), 1 deletion(-)
>=20
> diff --git a/rust/bindings/bindings_helper.h =
b/rust/bindings/bindings_helper.h
> index =
2e43c66635a2c9f31bd99b9817bd2d6ab89fbcf2..faab6bc9463321c092a8bbcb6281175e=
490caccd 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -56,8 +56,9 @@
> #include <linux/fdtable.h>
> #include <linux/file.h>
> #include <linux/firmware.h>
> -#include <linux/interrupt.h>
> #include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/io-pgtable.h>
> #include <linux/ioport.h>
> #include <linux/jiffies.h>
> #include <linux/jump_label.h>
> diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
> index =
56a435eb14e3a1ce72dd58b88cbf296041f1703e..5913e240d5a9814ceed52c6dc1a798e6=
4158d567 100644
> --- a/rust/kernel/io.rs
> +++ b/rust/kernel/io.rs
> @@ -8,6 +8,7 @@
> use crate::{bindings, build_assert, ffi::c_void};
>=20
> pub mod mem;
> +pub mod pgtable;
> pub mod poll;
> pub mod resource;
>=20
> diff --git a/rust/kernel/io/pgtable.rs b/rust/kernel/io/pgtable.rs
> new file mode 100644
> index =
0000000000000000000000000000000000000000..fe05bc1673f9a7741a887a3c9bbad866=
dd17a2b5
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
> +    pub const READ: u32 =3D bindings::IOMMU_READ;
> +    /// Write access.
> +    pub const WRITE: u32 =3D bindings::IOMMU_WRITE;
> +    /// Request cache coherency.
> +    pub const CACHE: u32 =3D bindings::IOMMU_CACHE;
> +    /// Request no-execute permission.
> +    pub const NOEXEC: u32 =3D bindings::IOMMU_NOEXEC;
> +    /// MMIO peripheral mapping.
> +    pub const MMIO: u32 =3D bindings::IOMMU_MMIO;
> +    /// Privileged mapping.
> +    pub const PRIV: u32 =3D bindings::IOMMU_PRIV;
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
> +// SAFETY: `struct io_pgtable_ops` is not restricted to a single =
thread.
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
> +        // SAFETY: Devres ensures that the value is dropped during =
device unbind.
> +        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
> +    }
> +
> +    /// Create a new `IoPageTable`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// If successful, then the returned value must be dropped before =
the device is unbound.
> +    #[inline]
> +    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> =
Result<IoPageTable<F>> {
> +        let mut raw_cfg =3D bindings::io_pgtable_cfg {
> +            quirks: config.quirks,
> +            pgsize_bitmap: config.pgsize_bitmap,
> +            ias: config.ias,
> +            oas: config.oas,
> +            coherent_walk: config.coherent_walk,
> +            tlb: &raw const NOOP_FLUSH_OPS,
> +            iommu_dev: dev.as_raw(),
> +            // SAFETY: All zeroes is a valid value for `struct =
io_pgtable_cfg`.
> +            ..unsafe { core::mem::zeroed() }
> +        };
> +
> +        // SAFETY:
> +        // * The raw_cfg pointer is valid for the duration of this =
call.
> +        // * The provided `FLUSH_OPS` contains valid function =
pointers that accept a null pointer
> +        //   as cookie.
> +        // * The caller ensures that the io pgtable does not outlive =
the device.
> +        let ops =3D unsafe {
> +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, =
core::ptr::null_mut())
> +        };
> +        // INVARIANT: We successfully created a valid page table.
> +        Ok(IoPageTable {
> +            ptr: NonNull::new(ops).ok_or(ENOMEM)?,
> +            _marker: PhantomData,
> +        })
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct =
io_pgtable_ops`.
> +    #[inline]
> +    pub fn raw_ops(&self) -> *mut bindings::io_pgtable_ops {
> +        self.ptr.as_ptr()
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable`.
> +    #[inline]
> +    pub fn raw_pgtable(&self) -> *mut bindings::io_pgtable {
> +        // SAFETY: The io_pgtable_ops of an io-pgtable is always the =
ops field of a io_pgtable.
> +        unsafe { kernel::container_of!(self.raw_ops(), =
bindings::io_pgtable, ops) }
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct =
io_pgtable_cfg`.
> +    #[inline]
> +    pub fn raw_cfg(&self) -> *mut bindings::io_pgtable_cfg {
> +        // SAFETY: The `raw_pgtable()` method returns a valid =
pointer.
> +        unsafe { &raw mut (*self.raw_pgtable()).cfg }
> +    }
> +

I don=E2=80=99t think that drivers need these three accessors above to =
be pub.

> +    /// Map a physically contiguous range of pages of the same size.
> +    ///
> +    /// # Safety
> +    ///
> +    /// * This page table must not contain any mapping that overlaps =
with the mapping created by
> +    ///   this call.

I don't think there is a restriction that forbids you from mapping a =
region that has already been mapped.

If A->B->C are adjacent regions, and you try to map A -> C when B->C is =
already mapped, I think this
call will simply return length(A->B).

> +    /// * If this page table is live, then the caller must ensure =
that it's okay to access the
> +    ///   physical address being mapped for the duration in which it =
is mapped.
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
> +        let mut mapped: usize =3D 0;
> +
> +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is =
never null.
> +        let map_pages =3D unsafe { =
(*self.raw_ops()).map_pages.unwrap_unchecked() };
> +
> +        // SAFETY: The safety requirements of this method are =
sufficient to call `map_pages`.
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
> +    /// This page table must contain a mapping at `iova` that =
consists of exactly `pgcount` pages
> +    /// of size `pgsize`.

Same here. I don=E2=80=99t think the above is necessarily a requirement.

> +    #[inline]
> +    pub unsafe fn unmap_pages(&self, iova: usize, pgsize: usize, =
pgcount: usize) -> usize {
> +        // SAFETY: The `unmap_pages` function in `io_pgtable_ops` is =
never null.
> +        let unmap_pages =3D unsafe { =
(*self.raw_ops()).unmap_pages.unwrap_unchecked() };
> +
> +        // SAFETY: The safety requirements of this method are =
sufficient to call `unmap_pages`.
> +        unsafe { (unmap_pages)(self.raw_ops(), iova, pgsize, pgcount, =
core::ptr::null_mut()) }
> +    }
> +}
> +
> +// These bindings are currently designed for use by GPU drivers, =
which use this page table together
> +// with GPUVM. When using GPUVM, a single mapping operation may be =
translated into many operations
> +// on the page table, and in that case you generally want to flush =
the TLB only once per GPUVM
> +// operation. Thus, do not use these callbacks as they would flush =
more often than needed.
> +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops =3D =
bindings::iommu_flush_ops {
> +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> +    tlb_add_page: None,
> +};
> +
> +#[no_mangle]
> +extern "C" fn rust_tlb_flush_all_noop(_cookie: *mut =
core::ffi::c_void) {}
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
> +        // SAFETY: The caller of `ttbr` promised that the page table =
is not live when this
> +        // destructor runs.
> +        unsafe { bindings::free_io_pgtable_ops(self.0.ops) };
> +    }
> +}
> +
> +/// The `ARM_64_LPAE_S1` page table format.
> +pub enum ARM64LPAES1 {}
> +
> +impl IoPageTableFmt for ARM64LPAES1 {
> +    const FORMAT: io_pgtable_fmt =3D =
bindings::io_pgtable_fmt_ARM_64_LPAE_S1 as io_pgtable_fmt;
> +}
> +
> +impl IoPageTable<ARM64LPAES1> {
> +    /// Access the `ttbr` field of the configuration.
> +    ///
> +    /// This is the physical address of the page table, which may be =
passed to the device that
> +    /// needs to use it.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that the device stops using the page =
table before dropping it.
> +    #[inline]
> +    pub unsafe fn ttbr(&self) -> u64 {
> +        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for =
`ARM64LPAES1`.
> +        unsafe { =
(*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.ttbr }
> +    }
> +
> +    /// Access the `mair` field of the configuration.
> +    #[inline]
> +    pub fn mair(&self) -> u64 {
> +        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for =
`ARM64LPAES1`.
> +        unsafe { =
(*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.mair }
> +    }

The two above will indeed be used by drivers, so it makes sense for them =
to be pub.

> +}
>=20
> ---
> base-commit: ffee675aceb9f44b0502a8bec912abb0c4f4af62
> change-id: 20251111-io-pgtable-fe0822b4ebdd
> prerequisite-change-id: =
20251106-resource-phys-typedefs-6db37927d159:v2
> prerequisite-patch-id: 350421d8dbaf3db51b1243d82077c5eb88f54db5
> prerequisite-patch-id: ac0166fb3cd235de76841789173051191a4d2434
> prerequisite-patch-id: f4bca02c77c40093690b66cdf477f928784bdbf4
> prerequisite-patch-id: 083d1c22b1a7eb0dcae37052b926362543c68e8a
>=20
> Best regards,
> --=20
> Alice Ryhl <aliceryhl@google.com>
>=20
>=20

This overall looks ok to me, and I quite like how much cleaner it is =
now.

However, I think a discussion will naturally emerge from making
map/unmap_pages unsafe functions, and it seems like the safety =
requirements
do not apply.

=E2=80=94 Daniel=


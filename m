Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C06CD767D4
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807936B0088; Fri, 19 Dec 2025 06:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1DA6B0089; Fri, 19 Dec 2025 06:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B46D6B008A; Fri, 19 Dec 2025 06:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 525B06B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:04:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D90C014052F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:04:48 +0000 (UTC)
X-FDA: 84235937856.15.AD82AD4
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf30.hostedemail.com (Postfix) with ESMTP id B7DD68001C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:04:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=lZjo4bWD;
	spf=pass (imf30.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766142287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv71NRDHP4NwL1A7ty5Xg2gOmk434WqlFyJQAH8wse8=;
	b=VtgMEaAI7Jzk4/CuMxEa1EKqXYMj0pTZgYoVpw9u6+0cBEWtK4G5gw/VQTYQku3pAIUFTn
	RKcu8fnI+5J+++o/9i1OKfwS1l/uDVq1UeptaQyR1r7dyMIKfxbqL5ZNp7Y16j0jQQUnjQ
	JA20D1K981gGlm1UNXQdDzFRlescKl0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=lZjo4bWD;
	spf=pass (imf30.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766142287; a=rsa-sha256;
	cv=pass;
	b=stgeEU750Z3gQGyBCapkmnXALO7m1C2DQO5JuHNOAI9BXlx2a8GYD+PdDCoX+j+CiR7s1u
	0/CCswoq6NgPtRx0zEfqcexAoXZKO0iEOEUGBIf9qdFlBRsnc4LvYDaUlmn/r08eWl/9q1
	HdnPRhdazUr7cZHKaeBfoDTEoDXP12w=
ARC-Seal: i=1; a=rsa-sha256; t=1766142279; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZSlsFDFFsJvPLLnQQCHxF8tfZfCR4g+3cNEvbxWarDPFRI8R64eaOYpfpfUgmIUIbxQ2aJbBa7w/YCTyBJMsEmoV3x4oMNiB/ldL/BR7vtM0BSZ2+VSwJ3Ua/E3GQJlR2blUDWBPunrSknCpc/tHwo9wGWMCVntgRiPNkdDnjbE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766142279; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Gv71NRDHP4NwL1A7ty5Xg2gOmk434WqlFyJQAH8wse8=; 
	b=EmMZvdNwn82rr1S3D+HJcHDxRhDd+12541oSC7jghDQONM9wyA+fot4pRY86XQ99YVWtNXJw53NHQd9hIIMivrgf37WYYdx9nMkV84/9WAvChcgrHX04GJJhanaqkrJ9v4i7hkxsWAdGkfVBVG2iSxS50V9jj+BE1PfzmM0yWco=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766142279;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=Gv71NRDHP4NwL1A7ty5Xg2gOmk434WqlFyJQAH8wse8=;
	b=lZjo4bWDDFzAxA7WEmBQvGieBo05qkO6MuunLyJQNkdMT32zfCEUfsL9OfUsiH6r
	1De+vonQHwtyryg6eylAbe+OdqxBGUGGtXMHJZxL2ov1ourY5HUvrmB8eZOKRP6GPKy
	kKABT/CKcZB6tqheCsojIwhALyqVxUAsPq5cJvBw=
Received: by mx.zohomail.com with SMTPS id 1766142276713127.65339699310107;
	Fri, 19 Dec 2025 03:04:36 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
Date: Fri, 19 Dec 2025 08:04:17 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Will Deacon <will@kernel.org>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Joerg Roedel <joro@8bytes.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>,
 linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org,
 iommu@lists.linux.dev,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <63063977-BA16-4F00-AFBA-8DD6409902E1@collabora.com>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam02
X-Stat-Signature: mt3rxrbmu6hids916bpg36fmnihc1wdm
X-Rspam-User: 
X-Rspamd-Queue-Id: B7DD68001C
X-HE-Tag: 1766142285-757346
X-HE-Meta: U2FsdGVkX19L4O5SdukDO4fUwuXRs16aq/O0W/5/fdZ4BL3fo1UUnuINlTG75gTS7I4ZsqjgNRm1Q7oh6nvvXpeu12UoRz0Ve0HisifIP0hgKtOkvNLNQ7LJIsoT7nHnf4cPLcaXJPHCHAjxcR8ktUesAik9q2h74xlCktVF2zv6nDUon5RyGmEG02XXBUMCVti1ImPJebFFpMOkz1DImVOIlZiyV8LxeX6Fx1C0eu5svYuWPLhBCrq537Mgq8UCE28iCEkv/GPgfZe/fblmaFIa/a2T6kvCF848bIJlm2wO+XyBCgtDs4N19e20rfDYZiG/UEFyEF6fwFlTMoXUciKsPf8zAzTd9y5o7QFTtMKnK9XNLejMTuxarRAuNS83rmyzb6vZSkLv2e86YRWLyQsEFs4ZCY+AmBTeT9V748XSasMIhHHUtfYbMcXBml+n/QzmfIzB/dF3+R4lnUykok9SyO/Ir1xMGxBo5TqEbDGmf/zVQUGPxcfO+JdTa8ypnaz1fcsTr6FoUNR9+vUvsdYb1CscNBrZI/bcqzM25EfnA37QbigJYIC2KimMs4sJEP/iYGr3Iz7cYDkImDC6Zi8GD3qpVeh9F7GugTY7KUyonVFV+NBprvNyzBnSJfFTGw/xN9AcQpv0im4FqiaFhC/Dr5+nLiy28bR003GvDbu1NVkXzTOcUAGB74pKaUnUQ3F9afRVNPePv/Fsepq55rGMqaO3almKSl+jdlYyQ9zIvk+EyVya1baely4BTSM/iVfBpkzGnFBSZWdAcT1w41v66d0RDV2VBA/hECbhmxs7iJ18oxnmjE4HN5+XC5sEY7uXS8CNG92r8HeGb1OsTwnIZwn6oAjDZV4vCS8+E7wOdwTwuvIcedWSLRlWGZQSgp/2JbAhV1AfmPrA3p/eIlCkTQDFsU8L0r3fFJMKfFkRXIqyQiiAprb91VrTjS6Hy/Znb+V0hqVa613stex
 I1K6jnhu
 64Ku7ZTuoLhIbrND21x9Wy7EClyy44TnSxTsAE9xK57b+xw87PK+JtHn/QEP9HhJ6f1hRSzfNuVDM8r+xSItr5gDOFxxcJolx49yiRq44EmLAQUKIzsMfOX2EGaAPM+VsOuF8JflkTlcaKueKJEC24MDrucAwgxTuwYEM04y/kmMn6MMvJ372GUFfbDnWDHmDzvUAygYFkZkju5haIvTvuZ5XS7Zkw2Mx5oaJ44ujXIylyi/+c6T2iPeBXvoCEaIHmaNf4Ttsxk6N9+ASpoHLHjRy96kmAJjMyCVkOGTWvIgJyM6r9PcFm2SdPj3WZNhxiC3jCSw3/AW+k3K6E+dHj4TrqWAvG3anmenhMVUYhEkytei8UkYULLcia/bxrTfiGihQddZSy+PzB8k1hymm+d6YEW1mssSvkSGNn98QXrARK034QMf7KBrbRyYZL76VX2e5X6/a8XjCqqBjXs6YhKaae/Th+VD/K/5GJ4+8HVBSlUDTqOoa5xef76m/vbBgNtv1n/Cxghuvz0FZYPuPsRwVzs6Go4ULluSJvVGksIU5Ndw6Ff2KfLRA7bxHDWo/z4+1VpspB5UJQdMtokM1Q14PY6e/CNgzAgU5aS5dr+gyLzobWZmPDgg4BkvDPX0MUdVV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

> On 19 Dec 2025, at 07:50, Alice Ryhl <aliceryhl@google.com> wrote:
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
> Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Changes in v4:
> - Rename prot::PRIV to prot::PRIVILEGED
> - Adjust map_pages to return the length even on error.
> - Explain return value in docs of map_pages and unmap_pages.
> - Explain in map_pages that the caller must explicitly flush the TLB
>  before accessing the resulting mapping.
> - Add a safety requirement that access to a given range is required to
>  be exclusive.
> - Reword comment on NOOP_FLUSH_OPS.
> - Rebase on v6.19-rc1 and pick up tags.
> - Link to v3: =
https://lore.kernel.org/r/20251112-io-pgtable-v3-1-b00c2e6b951a@google.com=

>=20
> Changes in v3:
> - Almost entirely rewritten from scratch.
> - Link to v2: =
https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72daac75f1@collabor=
a.com/
> ---
> rust/bindings/bindings_helper.h |   3 +-
> rust/kernel/io.rs               |   1 +
> rust/kernel/io/pgtable.rs       | 278 =
++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 281 insertions(+), 1 deletion(-)
>=20
> diff --git a/rust/bindings/bindings_helper.h =
b/rust/bindings/bindings_helper.h
> index =
a067038b4b422b4256f4a2b75fe644d47e6e82c8..1b05a5e4cfb4780fdc27813d708a8f1a=
6a2d9913 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -56,9 +56,10 @@
> #include <linux/fdtable.h>
> #include <linux/file.h>
> #include <linux/firmware.h>
> -#include <linux/interrupt.h>
> #include <linux/fs.h>
> #include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/io-pgtable.h>
> #include <linux/ioport.h>
> #include <linux/jiffies.h>
> #include <linux/jump_label.h>
> diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
> index =
98e8b84e68d11ef74b2026d8c3d847a127f4672d..88253158448cbf493ca200a87ef9ba95=
8255e761 100644
> --- a/rust/kernel/io.rs
> +++ b/rust/kernel/io.rs
> @@ -10,6 +10,7 @@
> };
>=20
> pub mod mem;
> +pub mod pgtable;
> pub mod poll;
> pub mod resource;
>=20
> diff --git a/rust/kernel/io/pgtable.rs b/rust/kernel/io/pgtable.rs
> new file mode 100644
> index =
0000000000000000000000000000000000000000..11096acfa41d45125e866876e41459a3=
47e9afe6
> --- /dev/null
> +++ b/rust/kernel/io/pgtable.rs
> @@ -0,0 +1,278 @@
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
> +    pub const PRIVILEGED: u32 =3D bindings::IOMMU_PRIV;
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
> +pub struct IoPageTable<F: IoPageTableFmt> {
> +    ptr: NonNull<bindings::io_pgtable_ops>,
> +    _marker: PhantomData<F>,
> +}
> +
> +// SAFETY: `struct io_pgtable_ops` is not restricted to a single =
thread.
> +unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
> +// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
> +unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
> +
> +/// The format used by this page table.
> +pub trait IoPageTableFmt: 'static {
> +    /// The value representing this format.
> +    const FORMAT: io_pgtable_fmt;
> +}
> +
> +impl<F: IoPageTableFmt> IoPageTable<F> {

I don=E2=80=99t see a reason to keep struct Foo and impl Foo separate.

IMHO, these should always be together, as the first thing one wants
to read after a type declaration is its implementation.

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

We should probably tailor the sentence above for Devres?

> +        let ops =3D unsafe {
> +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, =
core::ptr::null_mut())
> +        };

I=E2=80=99d add a blank here.

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
> +    /// Map a physically contiguous range of pages of the same size.
> +    ///
> +    /// Even if successful, this operation may not map the entire =
range. In that case, only a
> +    /// prefix of the range is mapped, and the returned integer =
indicates its length in bytes. In
> +    /// this case, the caller will usually call `map_pages` again for =
the remaining range.
> +    ///
> +    /// The returned [`Result`] indicates whether an error was =
encountered while mapping pages.
> +    /// Note that this may return a non-zero length even if an error =
was encountered. The caller
> +    /// will usually [unmap the relevant pages](Self::unmap_pages) on =
error.
> +    ///
> +    /// The caller must flush the TLB before using the pgtable to =
access the newly created mapping.
> +    ///
> +    /// # Safety
> +    ///
> +    /// * No other io-pgtable operation may access the range `iova .. =
iova+pgsize*pgcount` while
> +    ///   this `map_pages` operation executes.
> +    /// * This page table must not contain any mapping that overlaps =
with the mapping created by
> +    ///   this call.
> +    /// * If this page table is live, then the caller must ensure =
that it's okay to access the
> +    ///   physical address being mapped for the duration in which it =
is mapped.
> +    #[inline]
> +    #[must_use]
> +    pub unsafe fn map_pages(
> +        &self,
> +        iova: usize,
> +        paddr: PhysAddr,
> +        pgsize: usize,
> +        pgcount: usize,
> +        prot: u32,
> +        flags: alloc::Flags,
> +    ) -> (usize, Result) {
> +        let mut mapped: usize =3D 0;
> +
> +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is =
never null.
> +        let map_pages =3D unsafe { =
(*self.raw_ops()).map_pages.unwrap_unchecked() };
> +
> +        // SAFETY: The safety requirements of this method are =
sufficient to call `map_pages`.
> +        let ret =3D to_result(unsafe {
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
> +        });
> +
> +        (mapped, ret)
> +    }
> +
> +    /// Unmap a range of virtually contiguous pages of the same size.
> +    ///
> +    /// This may not unmap the entire range, and returns the length =
of the unmapped prefix in
> +    /// bytes.
> +    ///
> +    /// # Safety
> +    ///
> +    /// * No other io-pgtable operation may access the range `iova .. =
iova+pgsize*pgcount` while
> +    ///   this `unmap_pages` operation executes.
> +    /// * This page table must contain one or more consecutive =
mappings starting at `iova` whose
> +    ///   total size is `pgcount * pgsize`.
> +    #[inline]
> +    #[must_use]
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
> +// For now, we do not provide the ability to flush the TLB via the =
built-in callback mechanism.
> +// Instead, the `map_pages` function requires the caller to =
explicitly flush the TLB before the
> +// pgtable is used to access the newly created range.
> +//
> +// This is done because the initial user of this abstraction may =
perform many calls to `map_pages`
> +// in a single batched operation, and wishes to only flush the TLB =
once after performing the entire
> +// batch of mappings. These callbacks would flush too often for that =
use-case.
> +//
> +// Support for flushing the TLB in these callbacks may be added in =
the future.
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
> +impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
> +    fn drop(&mut self) {
> +        // SAFETY: The caller of `ttbr` promised that the page table =
is not live when this
> +        // destructor runs.


Not sure I understand this sentence. Perhaps we should remove the word =
=E2=80=9Cttbr=E2=80=9D from here? ttbr is a register.


> +        unsafe { bindings::free_io_pgtable_ops(self.raw_ops()) };
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
> +}
>=20
> ---
> base-commit: 3e7f562e20ee87a25e104ef4fce557d39d62fa85
> change-id: 20251111-io-pgtable-fe0822b4ebdd
>=20
> Best regards,
> --=20
> Alice Ryhl <aliceryhl@google.com>
>=20

Looks good to me. Please wait for Deborah Brouwer=E2=80=99s Tested-By =
tag if
there=E2=80=99s no further comments from others.

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>



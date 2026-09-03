Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA17C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF946B008A; Thu,  3 Sep 2026 14:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80BC6B008C; Thu,  3 Sep 2026 14:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6ED66B0092; Thu,  3 Sep 2026 14:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 821426B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:10:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19658805CB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:10:39 +0000 (UTC)
X-FDA: 85173241398.10.B018F71
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9EAEA000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:10:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=cFo6arYK;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788459037;
	b=S1OZVZVRYT7j9Ht/b0DNQjtJvG6Stnjfz2vtfaq6pvYP6NR7YIA3tSJE1gWKiEw9PF96y8
	6p+4ddh/R/x5v3vEhjdiLPksE9oe8bbsl/kJpdfGzUm/FbF7/o4+L04gMpUAG3ak/0OxUP
	3JUM6CG7I8tIpL3WA+XMo4qT6cdcHtg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=cFo6arYK;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788459037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvOUkOdgY7w3bkmqjiShZYzv6GBc2rD4vaEVe45u4tw=;
	b=MwCBQCdV9xfZYkz80L1aEYL7Hr5lz92pWksOzTND2Yy4zjkkZcPeGcEB7dIZ+nLkjPfmQU
	9Vc6qsSgYCkoAls7yKztEsqiuVdAEY9yqLUG5CSfIMsvj0GGWhkv/fA6BGVruubTiHTvFu
	8dXonupwIB7rP5QBRQochthKWjknJ/k=
ARC-Seal: i=1; a=rsa-sha256; t=1788459027; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cOgwtytGd1XzOfRnXTfNjcjFEXlbePD/AKJ+OFDjIaoTJB70nkNTK32ZbnVYutR69GdgqSfqnTOBG2hDsJYlLzKZ/HjEzgGJDprEj9cylOxrv/sWyeJTNRwqILo4F+Nc8UckWDZFFjwIa5UfxKw+VLd7eyIn2/8+RSQ1ioPCdng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788459027; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pvOUkOdgY7w3bkmqjiShZYzv6GBc2rD4vaEVe45u4tw=; 
	b=VcdaH0Ty29NiV3AeZYo8mqxCpaD0W9/XEBuAVi6cuT6Rx2PTwqgev5lCNyosgkX7ulUrA7F+CJumklgkqAJt94emM5J4G3E4Q7X89OE0cammpxy1/JrYurRBbQHw+fecWA+R/Twi0D1jE4cSSnuvTwkvfJ6qmFvrVmzJFihkBVI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788459027;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=pvOUkOdgY7w3bkmqjiShZYzv6GBc2rD4vaEVe45u4tw=;
	b=cFo6arYKYYTXte3a2XxW+FnKMSe2z+RllOUGIkbZu8D4TvJoAcWamHoDFtfZpmxt
	UweP6RhyLnPnyHxhq2vhJYq6QxmkVGFDdIhoy5cJQLzr8ggeFrfVtZWG1U438Lvkb9t
	mpuGTmPSq5+8XhTP+V3nqzKt2SAZ8vP5lRv1RTyw=
Received: by mx.zohomail.com with SMTPS id 1788459026284879.4234458102947;
	Thu, 3 Sep 2026 11:10:26 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 5/9] drm/tyr: add user and MCU VM specifications
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-5-e0fdbf8bd108@kylinos.cn>
Date: Thu, 3 Sep 2026 15:10:05 -0300
Cc: rust-for-linux@vger.kernel.org,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6112DB77-73A9-444F-B98B-4EEE9B69E393@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-5-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E9EAEA000C
X-Stat-Signature: toy3tpkpk7f6ptzuuzd884o6wef34anm
X-Rspam-User: 
X-HE-Tag: 1788459036-324604
X-HE-Meta: U2FsdGVkX1/fzcux6tCHKCADH+UBylfzmXEu73KwOryE2yxCCULnv89XtSqNJsk7XahkKCaRnI0okzFYcX4SnrZdDMRZgL0EZmuAD4d7xRwsL9zxlbugCqZcEWoxqiYDRS7wEJnkg40JdH0ha3jz9FaOWazZYEdcjQsyiX18m73Cdq6aJmQqWyRoTtzy0dui00Ght7A+KKq+pb0YTPjEaoDdS9nD+rMxzUv6eGs7VhpsQBx34LDtpEl/n7ExN25YQMO5WHYR4uoYqoID/T0AyFUhkJrMM9WyjruQcUQjGIq2tGGV738ZNqbdWziQxJiyPVIRigMOX+hlZdblApaoh3+JCJ6CHVAY2ho/nXo6ZkuWW4bRnmFVGgzGKI+6VVoKoCsdjXtDlxb2BSxDzO8qtNy8E843JziePO9gry5BDn5EXURoLNeOmK9WxYlWydVUK6diF69/DxYOFAR920USowEkxWurUJFE1FwiAYmy4qM/z7TBlGjrsDaFO/lTW1cMrCoJsAaVtQPOojCRStVyN0ZnEKSJFa4u7pnjs0sUpDZs9k14cMLFaTzENO3AqUeO6EPnj4qR/kUmjSnBDX1WDUw4UxVppu5YFWNHIX6l9fNi5BmFHCL/y4EjK2E5fKDpDcnu0iWeS47RA02aHAUU241/qs/CTfJBV0qflib+SLgR5/5VCYGRA4ulEsp9xS1kD9EA+Wn0x/SGfkKYWxRNm/VONo+Wum4R+fZ6SS/m3qIr9XprqppAdRl1Qtim/zjaPq2qx1yK/k0k7NqWFPEYD25FTFXuzIjMeYYHaO4+p4mdLGh3hJ/Os45aOvRRe8tiZA+EXSIuTLMv8i4Q+5snEBHTq73zsC7x4P7xICnl9JATWvhqTUEWrNUggbW6R2nD3jLUpsnIDN4pgzvE+kdhyj5oQMjRqnMGvHShEPAqL5IvFf48v160Efx+q3BITx62HOu5/auNI3uEudm6TJZ
 v6VSLbLE
 joH1pVpZ98Sc6p0t0tntuUUafgdpLbbZwzRqcVAUm67fvc0YTa6vUOOHrL8wwfscCOAAVppNoLJM6Urp+Yo0/PpA8UZWMCCO323L7sUEiMQbyGJtVem8aTDhfHVauwgq5tTfEPTiDV1ir/7xCVyhkYl7OKThn37RjmO6HmFfTGVo0aNrs196B6bBxV/in2jEkFI+gnjT7XWm4V5aq940VonmBVXBG5fVp4s2cj16Z/LkN/WeGtp75qFSJ7dFZvAVLpRTp9BagKuEWsdPyoD/6xRhkSHacIHC/egUT8eGUUkJq/7ctCv9UpMB+Nz0oqQr2GmCkcJsl5GZ94wuGhm+1HNwYOLUmCDTie1x8RUCTWpEA3uL6A+pXIo9434rTz4+mhM1pbP0lVVvFtekln79XcLO01w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 1 Sep 2026, at 13:09, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Distinguish MCU VMs from user VMs, and compute the user/kernel
> GPU VA split for user VMs.

Same comment as the previous commit: please write a few
more words here if possible :)

>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/fw.rs |   8 +--
> drivers/gpu/drm/tyr/vm.rs | 134 =
+++++++++++++++++++++++++++++++++++++++++++---
> 2 files changed, 131 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/fw.rs b/drivers/gpu/drm/tyr/fw.rs
> index 47d25c901bd01..9b4b488521b85 100644
> --- a/drivers/gpu/drm/tyr/fw.rs
> +++ b/drivers/gpu/drm/tyr/fw.rs
> @@ -51,7 +51,6 @@
>         KernelBoVaAlloc, //
>     },
>     gpu::GpuInfo,
> -
>     mmu::Mmu,
>     regs::{
>         gpu_control::{
> @@ -66,7 +65,10 @@
>             JOB_IRQ_RAWSTAT, //
>         }, //
>     },
> -    vm::Vm, //
> +    vm::{
> +        Vm,
> +        VmSpec, //
> +    }, //
> };
>=20
> mod parser;
> @@ -220,7 +222,7 @@ pub(crate) fn new(
>         mmu: ArcBorrow<'_, Mmu<'drm>>,
>         gpu_info: &GpuInfo,
>     ) -> Result<Firmware<'drm>> {
> -        let vm =3D Vm::new(dev, ddev, mmu, gpu_info)?;
> +        let vm =3D Vm::new(dev, ddev, mmu, gpu_info, VmSpec::Mcu)?;
>         vm.activate()?;
>=20
>         let result =3D (|| {
> diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
> index c5e307b1e2416..76c3d60bb2fe2 100644
> --- a/drivers/gpu/drm/tyr/vm.rs
> +++ b/drivers/gpu/drm/tyr/vm.rs
> @@ -8,6 +8,7 @@
> //! mapped into hardware address space (AS) slots for GPU execution.
>=20
> use core::marker::PhantomData;
> +use core::num::NonZeroU64;
> use core::ops::Range;
>=20
> use kernel::{
> @@ -43,6 +44,8 @@
>     new_mutex,
>     prelude::*,
>     sizes::{
> +        LargeSizeConstants,
> +        SizeConstants,
>         SZ_1G,
>         SZ_2M,
>         SZ_4K, //
> @@ -154,6 +157,109 @@ fn try_from(value: u32) -> Result<Self, =
Self::Error> {
>     }
> }
>=20
> +/// User VA size request for a user VM.
> +pub(crate) enum UserVaRequest {
> +    /// Split based on `task_size()` and the GPU VA range.
> +    Auto,
> +    /// Caller-specified size; construction guarantees `> 0`.
> +    Fixed(NonZeroU64),
> +}
> +
> +impl UserVaRequest {
> +    /// UAPI boundary normalization: `0` -> [`Auto`](Self::Auto).
> +    pub(crate) fn from_uapi(v: u64) -> Self {
> +        match NonZeroU64::new(v) {
> +            Some(size) =3D> Self::Fixed(size),
> +            None =3D> Self::Auto,
> +        }
> +    }
> +}
> +
> +pub(crate) enum VmSpec {

Instead of having an enum, I think we could go with the current
tyr-dev design, i.e.:

- new_fw() (or, perhaps even better, new_for_fw())
- new_for_user()

> +    /// MCU/firmware VM, entirely kernel-managed.
> +    Mcu,
> +    /// User VM: full GPU VA range, split into user/kernel per =
`user_va`.
> +    User { user_va: UserVaRequest },
> +}
> +
> +/// Final user/kernel VA layout for a VM.
> +pub(crate) struct VmLayout {
> +    /// Full GPU VA range covered by this VM.
> +    pub(crate) full: Range<u64>,
> +    /// User-accessible VA range. Empty for MCU VMs.
> +    pub(crate) user: Range<u64>,
> +}
> +
> +impl VmLayout {
> +    /// Kernel VA range, reserved for future kernel object =
allocation.
> +    #[expect(dead_code)]
> +    pub(crate) fn kernel(&self) -> Range<u64> {
> +        self.user.end..self.full.end
> +    }
> +
> +    /// Compute a user/kernel split for a user VM from the full GPU =
VA range and
> +    /// a user request.
> +    pub(crate) fn compute(full: Range<u64>, req: UserVaRequest) -> =
Result<Self> {
> +        /// Minimum VA space reserved for kernel objects (heaps, ring =
buffers, ...).
> +        const MIN_KERNEL_VA: u64 =3D u64::SZ_256M;
> +
> +        if full.end <=3D MIN_KERNEL_VA {
> +            pr_err!(
> +                "Invalid VA range {:#x}..{:#x}, kernel VA min =
required: >{:#x}\n",
> +                full.start,
> +                full.end,
> +                MIN_KERNEL_VA
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        let user_max =3D full.end - MIN_KERNEL_VA;
> +
> +        let user_end =3D match req {
> +            UserVaRequest::Fixed(v) =3D> {
> +                let user_size =3D v.get();
> +                if user_size > user_max {
> +                    pr_err!(
> +                        "Requested user VA range {:#x} exceeds =
maximum {:#x}\n",
> +                        user_size,
> +                        user_max
> +                    );
> +                    return Err(EINVAL);
> +                }
> +                user_size
> +            }
> +            UserVaRequest::Auto =3D> {
> +                let task_size =3D current!().mm().map(|mm| =
mm.task_size());
> +                let candidate =3D match task_size {
> +                    // `task_size()` returns usize; widen to u64 for =
the comparison.
> +                    Some(t) if (t as u64) < full.end =3D> t as u64,
> +                    None | Some(_) =3D> {
> +                        // If the range exceeds 4G, split it in two =
so CPU and
> +                        // GPU share the same addresses (SVM).
> +                        if full.end > u64::SZ_4G {
> +                            full.end / 2
> +                        } else {
> +                            user_max
> +                        }
> +                    }
> +                };
> +                candidate.min(user_max)
> +            }
> +        };
> +
> +        let delta =3D full.end - user_end;
> +        // Pick a kernel VA range that's a power of two, to have a =
clear split.
> +        let kernel_va_range =3D 1u64 << delta.ilog2();
> +        let kernel_va_start =3D full.end - kernel_va_range;
> +        let full_start =3D full.start;
> +
> +        Ok(Self {
> +            full,
> +            user: full_start..kernel_va_start,
> +        })
> +    }
> +}
> +
> /// Arguments for a virtual memory map operation.
> struct VmMapArgs<'drm> {
>     /// Access permissions and caching behavior for the mapping.
> @@ -329,8 +435,8 @@ pub(crate) struct Vm<'drm> {
>     /// Non-core part of the GPUVM. Can be used for stuff that doesn't =
modify the
>     /// internal mapping tree, like GpuVm::obtain()
>     gpuvm: ARef<GpuVm<GpuVmData<'drm>>>,
> -    /// VA range for this VM.
> -    va_range: Range<u64>,
> +    /// VA layout for this VM.
> +    pub(crate) layout: VmLayout,
> }
>=20
> impl<'drm> Vm<'drm> {
> @@ -343,6 +449,7 @@ pub(crate) fn new(
>         ddev: &TyrDrmDevice,
>         mmu: ArcBorrow<'_, Mmu<'drm>>,
>         gpu_info: &GpuInfo,
> +        spec: VmSpec,
>     ) -> Result<Arc<Vm<'drm>>> {
>         let mmu_features =3D =
MMU_FEATURES::from_raw(gpu_info.mmu_features);
>         let va_bits =3D mmu_features.va_bits().get();
> @@ -351,6 +458,14 @@ pub(crate) fn new(
>         let range =3D 0..(1u64 << va_bits);
>         let reserve_range =3D 0..0u64;
>=20
> +        let layout =3D match spec {
> +            VmSpec::Mcu =3D> VmLayout {
> +                full: range.clone(),
> +                user: 0..0u64,
> +            },
> +            VmSpec::User { user_va } =3D> =
VmLayout::compute(range.clone(), user_va)?,
> +        };
> +
>         // dummy_obj is used to initialize the GPUVM tree.
>         let dummy_obj =3D gem::new_dummy_object(ddev).inspect_err(|e| =
{
>             dev_err!(dev, "Failed to create dummy GEM object: {:?}", =
e);
> @@ -380,7 +495,7 @@ pub(crate) fn new(
>                 mmu: mmu.into(),
>                 gpuvm,
>                 gpuvm_unique <- new_mutex!(gpuvm_unique),
> -                va_range: range,
> +                layout,
>             }),
>             GFP_KERNEL,
>         )?;
> @@ -414,7 +529,10 @@ pub(crate) fn kill(&self) {
>         // TODO: Turn the VM into a state where it can't be used.
>         let _ =3D self.deactivate();
>         let _ =3D self
> -            .unmap_range(self.va_range.start, self.va_range.end - =
self.va_range.start)
> +            .unmap_range(
> +                self.layout.full.start,
> +                self.layout.full.end - self.layout.full.start,
> +            )
>             .inspect_err(|e| {
>                 dev_err!(self.dev, "Failed to unmap range during =
deactivate: {:?}", e);
>             });
> @@ -551,14 +669,14 @@ pub(crate) fn unmap_range(&self, va: u64, size: =
u64) -> Result {
>=20
>         let end =3D va.checked_add(size).ok_or(EINVAL)?;
>=20
> -        if va < self.va_range.start || end > self.va_range.end {
> +        if va < self.layout.full.start || end > self.layout.full.end =
{
>             dev_err!(
>                 self.dev,
>                 "Unmap range {:#x}..{:#x} exceeds VM range =
{:#x}..{:#x}",
>                 va,
>                 end,
> -                self.va_range.start,
> -                self.va_range.end
> +                self.layout.full.start,
> +                self.layout.full.end
>             );
>             return Err(EINVAL);
>         }
> @@ -568,7 +686,7 @@ pub(crate) fn unmap_range(&self, va: u64, size: =
u64) -> Result {
>             region: va..end,
>         };
>=20
> -        let full_vm =3D va =3D=3D self.va_range.start && end =3D=3D =
self.va_range.end;
> +        let full_vm =3D va =3D=3D self.layout.full.start && end =3D=3D =
self.layout.full.end;
>=20
>         let mut resources =3D VmOpResources {
>             preallocated_gpuvas: if full_vm {
>=20
> --=20
> 2.43.0
>=20
>=20



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC6D0CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE5B6B0092; Fri,  9 Oct 2026 10:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B963C6B009F; Fri,  9 Oct 2026 10:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8B416B0092; Fri,  9 Oct 2026 10:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8259E6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:26:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 978F81203E8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:26:46 +0000 (UTC)
X-FDA: 85303314012.10.C5C272A
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3D59C0009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:26:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=YcE87iNS;
	spf=pass (imf28.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791556004;
	b=6Vp2DvrsznpnhTRGeGxmdmkpYk4bn6N/zaeG/Bu+RNSDSX+izosXzouWudL71PZbnnkLTW
	J6XYmIN65wbRMb/3/ABQFt3ZU1CD+xiP92CECQKjG8t0o5B4ZqoYEu6mnfwzcu50JA02G/
	WDjJHisePv5Ki/LNMV6e7fyLaKdiyu8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=YcE87iNS;
	spf=pass (imf28.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791556004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxWCSlibUcjBFAFiXJUyGxqXSZ9QJBB0cw/YBhKRUoA=;
	b=x+67ym7jvDxkTEK8g2aL7b2spUE2VZ4Ag7ZzkzSwz4bNBE+er0y5kxE9UOyAYilsSMmt8x
	hGEX0600rlK02+pzsAOejz44kMkICSEYSYHw7E+U6+LFWVskGpTfdhdCw2J2uOJpbb+ak8
	0i6ophDZZwwmIa0lJcrsoGlgpK1K5QU=
ARC-Seal: i=1; a=rsa-sha256; t=1791555993; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dBZkp5Twe6upjrDeahwfmMMf6SZsdkvvuBGuZc/tJAxKlYvl+hFf8X/3qeSzkHQ2c5V0SvxZasCUQzsihzbOaxGbfpqYxgUyiEB150jfccDhvmq1txyfWPSVTaUwW8SizmbNROo1IcNilN528uV4DUGueX/1PhTUGRpum91YYEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791555993; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=gxWCSlibUcjBFAFiXJUyGxqXSZ9QJBB0cw/YBhKRUoA=; 
	b=Qd+lCKrL3H7XcXSK9bG1COVJCnfrQN4nu20agVINopo5rdfaTUV3WlVO4CN/MldMvwpnWDg90P52kI2eu0CdR0Fvy72PD55CC5pLp8M7AYV2Uiluxcmx3K89iZqzE3Qgs8w69gc/5CNbZ0SSAU7INBXZ9Or4ACdvRLTSATXvT58=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791555993;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=gxWCSlibUcjBFAFiXJUyGxqXSZ9QJBB0cw/YBhKRUoA=;
	b=YcE87iNSJx7kkyAUaSZ3oWYWkBXicUCZhb6cgpKGTc/+5rONc/ZUbDhdKdlATZu5
	YHlnuhBzVFSn1s4SsGntDngeKi8zf833GfbG+LPfSBEfY9O4nNp1f0QkXBf8mHI2xMO
	b4JgVsxH0c2xCV6Hc90bu0gVzPTtCKATJz3SzrK8=
Received: by smtp.zohomail.com with SMTPS id 1791555990345422.0007315319667;
	Fri, 9 Oct 2026 07:26:30 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 05/11] drm/tyr: add user and MCU VM specifications
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260929-tyr-ioctls-v3-5-26955fb111d5@kylinos.cn>
Date: Fri, 9 Oct 2026 11:26:10 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 driver-core@lists.linux.dev,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DCB87F1B-30EC-4EE8-A8AA-32D3DA978833@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-5-26955fb111d5@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Stat-Signature: 3p6zw37rcefh89idquz68fz4rzgbaf4w
X-Rspamd-Queue-Id: A3D59C0009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791556004-78663
X-HE-Meta: U2FsdGVkX1/GGr3Ze4uYOZXtX4w8fHVgSmyUOqhJJsk0dkd5KJe6WYPxNF876lj6Oz6CMgk3xkAYZzIz2JOE8pyWkbeyQnsAgKBCy7378YgfpGuDM9FV2xMoR9VFXbbULnuZMIdBK6c6IFEq9N06CU6dRucKIO+BUdP05Ii/wX8CWXiNqujWZ8cQ8YqgXJcr2XaCCtUUJJRT7JNwEJoM6fVL8vtudzT6pjdAxVT5g3fRxd5yQD+GLuun6ol1MvqMGrqrUxW6+6ltANvbHOIHambrKB/gO9XQBjACsFRPqi+Md1R1sGlKMaDa9hTy+GLYKo/+o30XytscZ7H1OKvFRpAXNvBSwq6EYE+TZljzhEjxaww44GuN/gqzqSEdjdCciG1TpL4Z+i59uMtDwokVb4ZpxrJxUtRImNjz9XaISx3fDDNpKyRgBD1xDIAm63DffE2BFGVoB5dYczAoYvwkYvJYpuRf55z37mCwm8Y+rOadRI4iM4kzw0ytDeBQh/FTQVaOUUJlq+pCFv1bXoDvMoqcJpfs/dI449bg528/mfsqrUosnlvWIypfRvoUS58XAmou/uO8XvZ5p3cwxY//ruD+LOhVNYVPsUW5qujQSj5h0oDt6RG/p6XGdCiXwlXTLrxWlXRKTUAVNExEZ/dCuEubxwHV4YeVajBjITpGjBXuBYWPQRIlPjUA3venuZAFSko8wHr+Geht+VsjOL+6LIDwaiF7H3UBvM/4HCtSMdQwGvvLwfTV09AGmvxeTmNHmPVc5oacWSxqMyF6QCKqqa8qWUh0PXpYsyjoGPwn+O9VFO4t8ZJB3Xs6LKF5L4r6pX+vAwJ8nhThg0HZ0uE4gU2xp0OzlZjMmayNPd04bSAe8rioWcd3+bFnaDjq2Hm+trsC7eWxhqzF7lWsM8zMyDM4RI/tTcZb/QPo62PvD1kF4nf1luXj+oMiPn5z/+BWZdlaet6VwOuP4aRvJQd
 tI25fIBv
 Nku4D1VloiVGK2oxx0S225tK2qpnNOqXakCihqCxoetuk14rDPen7j7mnZoIa3tL9yQPiHM7WSir7j/FVGhk883pj3BcEwiEebzQ8UnsjDJdrPyx/8cHrbyngOA1wdzt07B7fXIS5a2auuZGQvewxZtwdWARcbZksOfiNY47KDuXMulXOF8UQ+ntEkaNrr9Wp5UzQuIyshj331w5VuYY8Mq1jZDnolaS/VLNJyc6GJ3cYNojQ2T4rCqUYNMmhUikk52AvnE7CBRt/o8phtyxQ7uX3CcReqUWk1Ksdc+a1Brh9RbJLNdXBMAkunhU5w17Ehwmqci9NnVdQ2WFcgWx2YA8nRKy97bO8/ZdDUs9qUV19plYU7fCd7wCSsgU6t9e95VVVVmeSGOQRr6viSszvOQvxvvzPcCV9SzfZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 28 Sep 2026, at 23:15, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> The MCU and user VMs need different VA layouts. Give each a dedicated
> constructor: new_for_fw() builds the kernel-only 4G layout, while
> new_for_user() splits the address space by task_size or a =
user-provided
> size, rejecting oversized requests rather than clamping. The resulting
> user range is what VM_CREATE reports back as user_va_range.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/fw.rs |  19 +++---
> drivers/gpu/drm/tyr/vm.rs | 170 =
++++++++++++++++++++++++++++++++++++++++++----
> 2 files changed, 164 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/fw.rs b/drivers/gpu/drm/tyr/fw.rs
> index 7edb5eff17077..d790b54e373e6 100644
> --- a/drivers/gpu/drm/tyr/fw.rs
> +++ b/drivers/gpu/drm/tyr/fw.rs
> @@ -52,7 +52,6 @@
>         KernelBoVaAlloc, //
>     },
>     gpu::GpuInfo,
> -
>     mmu::Mmu,
>     regs::{
>         gpu_control::{
> @@ -223,10 +222,10 @@ pub(crate) fn new(
>         mmu: ArcBorrow<'_, Mmu<'drm>>,
>         gpu_info: &GpuInfo,
>     ) -> Result<Firmware<'drm>> {
> -        let vm =3D Vm::new(dev, ddev, mmu, gpu_info)?;
> +        let vm =3D Vm::new_for_fw(dev, ddev, mmu, gpu_info)?;
>         vm.activate()?;
>=20
> -        let result =3D (|| {
> +        let sections =3D (|| -> Result<KVec<Section<'drm>>> {
>             let (fw, parsed_sections) =3D Self::load(dev, ddev, =
gpu_info)?;
>             let mut sections =3D KVec::new();
>             for parsed in parsed_sections {
> @@ -256,18 +255,18 @@ pub(crate) fn new(
>                 sections.push(Section { data, mem }, GFP_KERNEL)?;
>             }
>=20
> -            Ok(Firmware {
> -                iomem,
> -                vm: vm.clone(),
> -                sections,
> -            })
> +            Ok(sections)
>         })();
>=20
> -        if result.is_err() {
> +        if sections.is_err() {
>             vm.kill();
>         }
>=20
> -        result
> +        Ok(Firmware {
> +            iomem,
> +            vm,
> +            sections: sections?,
> +        })
>     }
>=20
>     pub(crate) fn boot(&self) -> Result {
> diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
> index a2857820570cf..625ec7e95790f 100644
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
> @@ -44,6 +45,8 @@
>     new_mutex,
>     prelude::*,
>     sizes::{
> +        LargeSizeConstants,
> +        SizeConstants,
>         SZ_1G,
>         SZ_2M,
>         SZ_4K, //
> @@ -159,6 +162,103 @@ fn try_from(value: u32) -> Result<Self, =
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
> +    #[expect(dead_code)]
> +    pub(crate) fn from_uapi(v: u64) -> Self {
> +        match NonZeroU64::new(v) {
> +            Some(size) =3D> Self::Fixed(size),
> +            None =3D> Self::Auto,
> +        }
> +    }
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
> +        // Minimum VA space reserved for kernel objects (heaps, ring =
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

This pr_err seems to be removed in patch 7.

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

Same here. In this case, just don=E2=80=99t add them in this patch to =
begin with.

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


With the changes above,

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>



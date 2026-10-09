Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEE8CA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF456B008A; Fri,  9 Oct 2026 10:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539436B008C; Fri,  9 Oct 2026 10:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC846B0092; Fri,  9 Oct 2026 10:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF7F6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:52:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8727516043C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:52:43 +0000 (UTC)
X-FDA: 85303379406.07.6529979
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89956140007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:52:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DXubZqbr;
	spf=pass (imf09.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791557561;
	b=UfXYq4ttJ6AJikkTb7YxGFYmwflhqr+A5Vme7y1Q6qpbXV4sI9TOpbZuyCfUVJ1EGYnqH8
	XC7PrqvD88gUC7Wxn4Ykd1uClvbJqVVxATweRBWec1J/tfT8YV6cjAt39AToqCKEQTbbbA
	+y0Xp5VQB0qEcMygj25ac9pXT75k/sE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DXubZqbr;
	spf=pass (imf09.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791557561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EiLsH5UA/UAiT8EVhaZCRrPJfE6J/JG41Rfbvq9F6Jk=;
	b=36YhG8Ovi6GVlp0ouJ7Y5BLZAxYw/EvM+RUODpqMecKSYtJa590qgDeoTQzKEhIGrh1P9R
	VQSvtzMeSKZf8Dj0SAtm8sRvTItM9PxtM6rcYC45A+GukWtjMTb5EilbzSYLwFDhNqM/6p
	OMwmglm0HcmylZkk9nCp3oASndAG/VA=
ARC-Seal: i=1; a=rsa-sha256; t=1791557553; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Z+z6z0ksLMfonBhun8oeR7/DSVjnafMXHhyl6IGgTwbRwCHnhp4BxXnVi0JOquxAiGVhvgSetsOJfNXjSOGyxQxsJ1l7YmzXWPSjANhra8npyQu/nDGCS69CQxB63sDlvdzUpatOQvOTnzVtZa3yy6ZVBGGMGgeKbD8SH5s2QY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791557553; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EiLsH5UA/UAiT8EVhaZCRrPJfE6J/JG41Rfbvq9F6Jk=; 
	b=dVa8fOIknUAnhPupZPxBXcpw5NN+mrT2WN9dy/0/Pq7lV7P2TdSl7GEv4K0QXIgk8szcH/LHspkdsvFugW//uRfkatqjxx2IEYG+QEOB9HVsMT/mkPldckPULk3kYovkyFcwbq6xhw6GP71fr5DWIlecO0yilkgEV2/kDnbBrkE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791557553;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=EiLsH5UA/UAiT8EVhaZCRrPJfE6J/JG41Rfbvq9F6Jk=;
	b=DXubZqbrnPnNjo75oU8CUkmCxU5WEW7U137kdql6G/TvUin3a9mIBQ01dcF3Jyvw
	zXysVlnWfi8tPmxV4UWfqAX/MVUX5EZDadwk0cr8eOCfVfNdEDysgtm0r1IimXErtue
	NKF66Fi2yzMoVjB3dE+xlGimuCzQ1UfNdYeaXsPI=
Received: by smtp.zohomail.com with SMTPS id 1791557552056367.49141307442665;
	Fri, 9 Oct 2026 07:52:32 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 08/11] drm/tyr: add BO-related ioctls
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260929-tyr-ioctls-v3-8-26955fb111d5@kylinos.cn>
Date: Fri, 9 Oct 2026 11:52:12 -0300
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
Message-Id: <419B635B-1C89-4004-98CB-9127875CA043@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-8-26955fb111d5@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Stat-Signature: 7i85y9b8q18moyfmfndmzgu9ensox9e8
X-Rspamd-Queue-Id: 89956140007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791557561-823354
X-HE-Meta: U2FsdGVkX1/sL1BDkEyalKNPV+w4FlwqqtCdqo/Pdndrb75UbLqLgdjBl+bqUi86P9pXS/5g6xv9VNAX16ZHMwyOnf1wuwv/O2YthASjb/xk9G5wQVrv51pjjyagkWbYDtEJuRDVRkKAcjgcqqG46fvqMWYb//+dUWGy9KYLi88+VFozLU0XRj8M2WYp60zXtgtmRzxEuqd/irFsheaiEd3yu2ok2bySURTNnE46JdaRSk9ZymsYRyFPbaedxOR0QYxdLeZLZ97ZPxSLS1uRslPqosjDoCGpDnQDVvf2aZ/xWOiDqrbvaXOtquB2Eg+ajxf6OkQGDuBo64Fa6pNJSGvtaCVGa+oH9oC2Fpwcg/kiopkEyXtMOjhff6ByL3qTYfBHewjYyP3YIMyO0PQLoBkosEqDuQ+nwG77h+ndRTIvT9RiqVW1pYRc5HawG6YIYxDmJO/Tbw3hbk2s2Sb0aaPxMJX58cPgm9DEEEM/ta/Q1NZjaTB1AVT1wjRU2f5OfgqFR9esQyRCOsPLqi8sP9jysakUBe83Pt98fqpAdo4veAYAhA450+ME8amfPZfGFWYmtfsUoZkLgk1hTAyWoe88aARusdOs50QPXixmniYpqspvfh+Jn9clEvpKpicrNyVnu0gXucEKCvLArOhvmYTrxfEha5EKOeGsK5ODWKknKAK1ibzrawHIIVPQEM+rOqj9xEfeUqsa42TagonH/tOAeu69RvAASXEld/xAOdshpErka1oVX9JVdzq/TRUxgJx5U4+BZQXHhN6Wb4bjiFoaMSiLXpQ7dTFA1Y5m01bqGM6IA8Ctt2qLkLAmLk7BAgiPn3lMPpUW5xAxKqKGdR4VC1KGJ5DTs18Xd0fI7pfIcAzZHMu5XyrVdFgl+1jiQH62n82Zjc08tG34TXDNzeJpr5DeCtbkklGCIn/3kyFJn2KllyLuXzmWimlDNxGzbUTcAblUSfXdwIG3gFI
 VK5JFpDU
 bSW1AYZ4C444pM980QCpe6atX5M2lSAO1IYtX/lyRKgKc1G6nBatCYlKhU5bZwcEzp1JCWutbpbn43DqEh0OvUSPTEN+M3NqSvJZq3oHs3Yl5xcxofoUu9p5KWcOpRBfKb6XbE3FgLzS2NwQpIOTE3Y/KuI7CB8lr1WIoGroDTKOJ2QpZWhpxa6UEjblSi7wu3wGXL+qINU1mlWcFFjdT24X/wAImo+gkEL5nl/4+2Aj1pBSLA+S2d5eOiibplvkBlNx+iR2EVQp4pUYRfL1IuWgAz/l0K2HMjT8uCilHf5AZY7s9Gb2xbHsPCPd9nthlV+vvuz5mwiwFvIM4KoAreBpP+QlIs6Dcn7I23SUkHPgKAdiIMzrseP6vW9Xly4HzhhVCeUYG6FFsNy5cJqcLrCv622KIAfoa9/sU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alvin,

Same comment about dev_err vs dev_dbg.

> On 28 Sep 2026, at 23:15, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Implement BO_CREATE and BO_MMAP_OFFSET so userspace can allocate GPU
> buffers and obtain a DRM mmap offset for the generic mmap path.
> BO_CREATE page-aligns the requested size; BO_MMAP_OFFSET rejects
> NO_MMAP objects, which must never be CPU-mapped.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/driver.rs |  2 ++
> drivers/gpu/drm/tyr/file.rs   | 73 =
+++++++++++++++++++++++++++++++++++++++++++
> drivers/gpu/drm/tyr/gem.rs    |  8 ++++-
> 3 files changed, 82 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/driver.rs =
b/drivers/gpu/drm/tyr/driver.rs
> index 9a7f147935e29..8baf88aee96ad 100644
> --- a/drivers/gpu/drm/tyr/driver.rs
> +++ b/drivers/gpu/drm/tyr/driver.rs
> @@ -224,6 +224,8 @@ impl drm::Driver for TyrDrmDriver {
>         (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, =
ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
>         (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, =
TyrDrmFileData::vm_bind),
>         (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, =
ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
> +        (PANTHOR_BO_CREATE, drm_panthor_bo_create, =
ioctl::RENDER_ALLOW, TyrDrmFileData::bo_create),
> +        (PANTHOR_BO_MMAP_OFFSET, drm_panthor_bo_mmap_offset, =
ioctl::RENDER_ALLOW, TyrDrmFileData::bo_mmap_offset),
>     }
> }
>=20
> diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
> index 2c037b136406c..e98eb0a46877f 100644
> --- a/drivers/gpu/drm/tyr/file.rs
> +++ b/drivers/gpu/drm/tyr/file.rs
> @@ -248,6 +248,79 @@ pub(crate) fn vm_get_state(
>             Ok(0)
>         })
>     }
> +
> +    pub(crate) fn bo_create(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        bocreate: &mut uapi::drm_panthor_bo_create,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        if bocreate.size =3D=3D 0
> +            || bocreate.pad !=3D 0
> +            || bocreate.flags & =
!uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP !=3D 0
> +        {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid BO_CREATE params: size=3D{}, pad=3D{}, =
flags=3D{:#x}\n",
> +                bocreate.size,
> +                bocreate.pad,
> +                bocreate.flags
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        if bocreate.exclusive_vm_id !=3D 0 {
> +            dev_err!(ddev.as_ref(), "BO_CREATE: exclusive_vm_id not =
supported\n");
> +            return Err(EINVAL);
> +        }
> +
> +        let size =3D usize::try_from(bocreate.size).map_err(|_| {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "BO_CREATE size {:#x} too large\n",
> +                bocreate.size
> +            );
> +            EINVAL
> +        })?;
> +        let bo =3D crate::gem::new_object(ddev, size, =
bocreate.flags)?;
> +        bocreate.handle =3D bo.create_handle(file)?;
> +        bocreate.size =3D bo.size() as u64;

Why is the sg_table() call only added later? As it stands, this patch
introduces a silent (and extremely confusing) issue.

I=E2=80=99d prefer if the call were to be here instead. You can just =
call it
unconditionally for now. IIUC it is harmless for coherent systems
and in any case, we only support non-coherent systems atm.



With the changes above:

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

=E2=80=94 Daniel




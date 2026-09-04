Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3048CC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 20:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB276B0088; Fri,  4 Sep 2026 16:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A9D6B008A; Fri,  4 Sep 2026 16:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3482C6B008C; Fri,  4 Sep 2026 16:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB66F6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:35:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D73CE16014E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:35:50 +0000 (UTC)
X-FDA: 85177236060.03.C43FC7A
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9F1C40006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:35:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="AH0QIu/1";
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf17.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788554149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0k6Kz+SdWEmoW6Od/eEawvKt15zwDmptkDj5bWnB04=;
	b=fSBzYHl0p7PiRJuYCbz4lknNnY1ZABvJ0trfVFC92TeQDOgVmCUd/e4K/m/3HnmQ+4ViPS
	e3r1/MUu+Qf4vV2AawUVtFIe2BLjnSIr3q6VgpEKUcS3Cm4JcOWZFSZaAnJZFTBsgOBaiP
	afIeqxIkQWFqNHtRl8Xc4N9PLZRYPtk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="AH0QIu/1";
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf17.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788554149;
	b=8UKJ+crgik1AjceowTthJMGXtSaxaYnmtRVI6WY/yV0/PGHmK1gaReE4lXpnisjtOhYXwn
	ooTdK+PseHwAs+Wxqio7F08QxHqZoxoilRtdjuPWOOIIyqOZKqDj93ggFlb14Fq1Gg5wMv
	kfVTfsFiBfmrLDp1ZXX12BYcvQr2K8I=
ARC-Seal: i=1; a=rsa-sha256; t=1788554138; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Q+Tl8OjiLNj2TOW2Ca6y3oZuXXVaOox6E2aQEMQ1K7y7cw74k8SXkDyq5Pt+sN2spNCvnD0zAgWzSUYkAovbvGfz1+Nxw3/xHt6F8SVn1AtVa4chNQHKHKk6PcX5a5RjDjCXZXTWAneIURl8ix2O8eCUxs1ucTYStEhoUY0dZ68=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788554138; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=I0k6Kz+SdWEmoW6Od/eEawvKt15zwDmptkDj5bWnB04=; 
	b=CDWqeX5iKsGcCfsVo7Pf3drLz6TbWQFUtzIRXzLyFBYpMCWnGX2EMbJW0G8C7E2KANShckrKKsxHh0ZmVxlYSpz/ggWGJqpkZiust0xZGTbuabNPNLK0j5mE9d1cFQnPY9gsnS293a+Hz19vI2CVYhy9HsUPSyrqelDlHxs7GL4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788554138;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=I0k6Kz+SdWEmoW6Od/eEawvKt15zwDmptkDj5bWnB04=;
	b=AH0QIu/1ROj5KivqKZVlwT/Pt2CtnypTOH5IjKniTcu3h5r8w01eUCoYvhYWBOm+
	ucs79wglBotCytiwi1iYfe0ipANZ3z0kmh/lJPoSwMlyOKT5PvFftvWVmTm8HkNkUXU
	XcnLeNrbeCTFDoUyws4j5CiyjQOV+v5DvXHFRLoY=
Received: by mx.zohomail.com with SMTPS id 1788554135928568.4108043928953;
	Fri, 4 Sep 2026 13:35:35 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 9/9] drm/tyr: add BO-related ioctls
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-9-e0fdbf8bd108@kylinos.cn>
Date: Fri, 4 Sep 2026 17:35:16 -0300
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
Message-Id: <FDEDAB25-FBF2-438C-9C1C-F72DC851E88C@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-9-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: butnpqsgts96u4893crqg3ryhj8n9wri
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9F1C40006
X-Rspam-User: 
X-HE-Tag: 1788554148-801965
X-HE-Meta: U2FsdGVkX19PtSxoYam0aHDmX2K2k9681ct+OzY82W9WJgZyYZtqtSNFgbEOtqBMynav9Y4P8/JFud50ICJgHy836wgG7XnGCHozyvdsMLWfWg+B2p4+T17/rzkxGk1PoT6xfkQVhLVTTsf8a9WOgsjFJwN3kG93ZXUYd3cuTwcmUekZaveUg4yS7dTACLcqjGAaBqyGKPn061Wx82h9YI2M6HVW0NF2/QPlECTgfSBNvPEWWLUxaPURmcn7vM3dAURPRw0XCilvv0iLW2CwQO2/j03d/Gsp2F+8ySHO9KDsfnzHtZGgxMUXNnMllHSXtQrsiIIrIQEfSpHCbb4VK2XwqNVw27wQzcSTVZTbLDafoFc02SJ4ZJCeawm8nlHYTzGwtqf9yKxohR6/bBPCLVQam9u0IlIj3omCka/4Qf0J+p227G6r50PC+Jpk1I/XlDU+Px2mpJ6AKEk8fw7vWXY6ukwFVesMYg7Nc7GBJntiZDiIW1djQB95s3eD27rhJfX2P199PEGl3nhNZoFMIJoSf1fWPvcNe+ZJ58Ef8fmJCcVO8Z6G+bDDoq+hQupPYti1BSSx2I9wHFqltgqs6tmr1uoMaeWYKfIu0KV3kSG3vt1ybo1/f2DybZzBhK+lLnqOtH/BqsueWrHaLofvi+8vuvObBbpo4W8eUhm205oZ1WIiVy33ZHj8O78FAHlj0XoWOSuB3+saiOANnCmLHyHNNV0wVbOWJ1+dRLAcp1Whg8QLXEAzVbRkFP1Ro0bIP/QdiHbADGUUf9ZtOVQa2XicIHhp0MGJ8lxrX+BF1hyMoeCrgTzMmZcHGJhgkGLpMOmEeHwf3p10JnreA5XHx2Fzkn4uro/vMnd2QdlbxsEJBVHI0jHdGA/UeNshLAdBKyWInWbwUWgP58uHBI6y6VVygKI78fBR7oQ7L1CndVopwNz0FbjERDgnPq6LiDg1lfPFfkoZKlgGZ5OKYnX
 oS+p+5r+
 WzEiOKowYQJgi3zKr8wDsXVom7xEG9+J86B04DqLpUnjE41IsEh+1DkJhNkC+0Q4Ahvb5rKdi6H2LFW8bjVgQKp+jQC6FLUs0rMrPW7FBKFuCmHWWM9EVsn3m5B/BfLEaOpsPpaDEpJe2y1e9cm9Lv5jG8/QSDTT3f9BegzOhtN13cuvAlciKsEtb1dR1mz3jxx46GDUz8qSuqE909jxAcOhAnJRyY4bNMfTP9idNtw/MJ1lkvUK7ZsreTOuoGQtuO0N2MMXzQHblu4YNOxFAZMOiG9IZGFqJZgbrtsUNnK51Y2MOgkp+zRb+zDB7Prt1OyEgPkf0EGybWeEqsbnOkTrUH1VVRaat71LDzp9nH4fksm+e6o7DrJw1HxVqK5Mlja+tXP6tyaltpN3zCBfzu+868sphcBtoW16sQDKr8kIbvZI=
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
> Expose buffer creation and BO mmap offset retrieval.
>=20
> - BO_CREATE page-aligns the size and returns a handle with
>  write-combined mapping.
> - BO_MMAP_OFFSET provides the offset for the DRM generic mmap
>  path, rejecting NO_MMAP objects and non-zero pad.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>

Same comment as the previous patches, please write a few
more things here about why the changes are needed.

With that addressed,=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

> ---
> drivers/gpu/drm/tyr/driver.rs |  2 ++
> drivers/gpu/drm/tyr/file.rs   | 70 =
+++++++++++++++++++++++++++++++++++++++++++
> drivers/gpu/drm/tyr/gem.rs    |  7 +++++
> 3 files changed, 79 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/tyr/driver.rs =
b/drivers/gpu/drm/tyr/driver.rs
> index b3145526ada06..fc8d11c9ba1ca 100644
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
> index 157bc40e1cac4..16abf2968299c 100644
> --- a/drivers/gpu/drm/tyr/file.rs
> +++ b/drivers/gpu/drm/tyr/file.rs
> @@ -252,6 +252,76 @@ pub(crate) fn vm_get_state(
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
> +            || bocreate.exclusive_vm_id !=3D 0
> +        {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid BO_CREATE params: size=3D{}, pad=3D{}, =
flags=3D{:#x}, exclusive_vm_id=3D{}\n",
> +                bocreate.size,
> +                bocreate.pad,
> +                bocreate.flags,
> +                bocreate.exclusive_vm_id
> +            );
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
> +
> +        Ok(0)
> +    }
> +
> +    pub(crate) fn bo_mmap_offset(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        bommap: &mut uapi::drm_panthor_bo_mmap_offset,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        if bommap.pad !=3D 0 {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "BO mmap offset pad not zero: {}\n",
> +                bommap.pad
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        let bo =3D crate::gem::lookup_handle(file, =
bommap.handle).inspect_err(|_| {
> +            dev_err!(ddev.as_ref(), "Invalid BO mmap handle: {}\n", =
bommap.handle);
> +        })?;
> +        if bo.create_flags() & =
uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP !=3D 0 {
> +            dev_err!(ddev.as_ref(), "BO mmap offset on NO_MMAP =
object\n");
> +            return Err(EPERM);
> +        }
> +        bommap.offset =3D bo.create_mmap_offset().inspect_err(|_| {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Failed to create mmap offset for handle {}\n",
> +                bommap.handle
> +            );
> +        })?;
> +
> +        Ok(0)
> +    }
> }
>=20
> fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> =
Result {
> diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
> index d9ddcb287f52b..f404139f54f32 100644
> --- a/drivers/gpu/drm/tyr/gem.rs
> +++ b/drivers/gpu/drm/tyr/gem.rs
> @@ -38,6 +38,13 @@ pub(crate) struct BoData {
>     flags: u32,
> }
>=20
> +impl BoData {
> +    /// Returns the flags the BO was created with.
> +    pub(crate) fn create_flags(&self) -> u32 {

I would prefer flags() instead of create_flags(), which reads a bit more =
like a constructor.

> +        self.flags
> +    }
> +}
> +
> /// Provides a way to pass arguments when creating BoData
> /// as required by the gem::DriverObject trait.
> pub(crate) struct BoCreateArgs {
>=20
> --=20
> 2.43.0
>=20
>=20
>=20



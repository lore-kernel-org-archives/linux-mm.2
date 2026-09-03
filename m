Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41ED5C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 22:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486346B0088; Thu,  3 Sep 2026 18:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4374C6B008A; Thu,  3 Sep 2026 18:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3266E6B008C; Thu,  3 Sep 2026 18:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCD46B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:07:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70419120672
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:07:03 +0000 (UTC)
X-FDA: 85173837126.19.996D891
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71D27A0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:07:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=C8AufTuH;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788473221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afA3ax7f9QXcCedQi5bAM/QoI2EIiapIQDf4xdId4Ug=;
	b=MsTjWai6a/AToNNmqpdosLcSRSo+fYhJGvqOzj1GVwKsDFqAtW52cP4INkvO1GXfs1YWOX
	AKdtRWvJ0HVW86iMQu5QX5b20HDgYoXOTrtyTnlqXRnci0N5gUq5zCbDKSKuybGHGHwVSM
	FwsPZNDttarrRlnB/4zZrAdDhU8NG5k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=C8AufTuH;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788473221;
	b=0f36+gF+KS+b7tzvPVPCSHsk4bzKb9P3dKj7ukDshJXvT9o3tXrZHj6USfhddjA89WBrLl
	EccHe1s0AG/RmsWmpVWelTYMcpwiw6J6k/vwzU+17uc5ARbfatPpi06dpTug7EXv90AxTM
	7BWXsj2Jqe9uJm/iUKocttFJ4PDg4SE=
ARC-Seal: i=1; a=rsa-sha256; t=1788473213; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=R6bG7hdiDiKlEIgrX3xMgWzJwRMGsftITsN+MI8KcXwvHksT/f6eZ+8jr2s7TAvHdrVVzR4+Urpo34vxL5TpFw24bUjI2Fnb73NQkOZW1mJFCkfeR1DZlR56k0zx81GJLzDmeIEyhFUMgqTY/n6v2cJhMphmq8IsVeDuKiywRKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788473213; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=afA3ax7f9QXcCedQi5bAM/QoI2EIiapIQDf4xdId4Ug=; 
	b=e03QYNDF1BzCbkp3Z6v8qmmYuONMENPFbUos06vuaYO4Cp8ZtKipFRSSeig4Xav2jk55S4104gDYbDjWBGOB09QyaFmGQT4pEEIuhqqXjHSQKLM9aVNqgvFuMffT7PR1hHX9djHM6jN+3njkRLqsNklXYmGBMTQRfqjNL8ZJqwc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788473213;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=afA3ax7f9QXcCedQi5bAM/QoI2EIiapIQDf4xdId4Ug=;
	b=C8AufTuHLPwUljbA54/aDdNTZQpkZb0OFLwnFnvPnt6ZW8E2u8au1DNCLZpbqCnD
	Mvh34mx5FVS9mgjYUsToU957PGF05WKA5kM6/zX5+Vrwtz8W1xjBVTxT3dBIF8ukHy/
	sthFIRJyiU6knD+o6DPFAt+UbTn/LzVzeHZlJKMQ=
Received: by mx.zohomail.com with SMTPS id 1788473212203626.0025116376753;
	Thu, 3 Sep 2026 15:06:52 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 6/9] drm/tyr: add BO creation and lookup helpers
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-6-e0fdbf8bd108@kylinos.cn>
Date: Thu, 3 Sep 2026 19:06:31 -0300
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
Message-Id: <B6966555-4532-4369-B519-56AD72307553@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-6-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ahqhdsenot9byjggn1perzu4qy5uaq4h
X-Rspamd-Queue-Id: 71D27A0007
X-HE-Tag: 1788473221-366950
X-HE-Meta: U2FsdGVkX18gj/zNz/xaEC61ZU4Akt7Tu2onyaXc0X0xyrOe98imgiBC9fkdHu8IXxPLPWXwvZ0oNkDSKgSsdZMOGEFjWEBNwx2M/qIqg7gQBx+9L6asSSDcG+iBXEjKedWfJ1BwDkOi06bP9IssGVA2EchVA9eJSmPJ1UszUTgJdTvVNNjePxOrZe2QBALlHkR+5fpj2F63HbbvHid+qtlAeqjPGAoCy+sTP7PvQXTkc1bujB8nPxM52DK2WV7J3MgclTm+6hy93ZklaJw+3oSMtFelkLRcmlyCLUlTwIRmKJHce3w6ntGcuk0qLsFfivfagGM+V2sGovPvVfcnYlXOmCA5Z8ShyiAw5PcS0TNP2AukyaOQueSUwxOmFrnP3yUHsy8hFyGv/vSXw87gqOSgR0A4cpzm6HrhtudV+8ij48FDSMXlnkWxd55xzKAhA4jeBX1RMjUIWIdg1v/iScozyWj9sQGJM9HlUHubFXZiuSYkzTEwewrv/nbGeGtcItn/uvqJmrV3MiC8lF+N4GpZlzfLSy2hOuZbFbgWwR64v92rYHHOAu0aOZN3Kroos0sFc+CRIeiDEKRUOn2L+pei5lve2HLoSCwSPxvUuUhhYIjhYAFlmlUeG7wYE9mocwa+FKxiKnVp+n2dA3SJGiH04cz6NFpHmEHR0cG/NAqjcQ6PVmrF04tQhhwI74SDGlfcDX9foVybM3PuqCCv5BoJK2Rfggq3b0QYqYNWiasg7gI5rksT49y9e6VRAcNzARfBgYtELQH/flWrIT6KxJLtl/nCqotcxmF4Oi98vwq1YSZHRngKhoIAJiXksfvNFZPUCNghYBX1LUszFxQh6fn6HUKjv1rrlf+hMW1VeCbL9kT/tdKSvLBQNWRfyZQNGVjWpikKX5TIYpjrT79Yp0yLo0aKvgjVGF6uXgjPiKZoN9hL70XHthlmS3izRi6LTZ28ES4p9aSCAxv5IhO
 gq4Dl1Y9
 4qlfnODG6UxOSwQGreo/HCXozd3Ln6kFxDIoiF6K41kU2LikBbv6FrncUipBfYsxYm8LLuMOfuwnUz616btWGNUW8JK6TviM3mkJkZnb/0ACfeNef1TtAPmGAi9Z1uaY0mGqBXb8XgOK8Q0Gmkwi9Uo/BjHkkUkmHM0xWQt7amH0/6F6HYNTwNv9f0xxrAsLOvJkD+M34UUu9l+Qts2TixZZWCehHlNHyekIAXv3cC9Y83X6GaglMehurtNaNuTSZdZNFUXOLvIBULsuq9hVcK8WNyWNKIhcJ8ehkfFbVnVzpKCH934pbibnkPXHeemAyG+QWO7oudjU6YsWcO6SmxHliitXTJG7ayHdRJGG9qMm6+ekPRFjrblUP2mkcCKA2LsL2+yZ2Rh8ZiGpfHqTN8d0/UQ==
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
> Add the new_object() and lookup_handle() helpers.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/gem.rs | 29 ++++++++++++++++++++++++++++-
> 1 file changed, 28 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
> index 3bf3787f5c3fd..be1affe80db1a 100644
> --- a/drivers/gpu/drm/tyr/gem.rs
> +++ b/drivers/gpu/drm/tyr/gem.rs
> @@ -9,9 +9,11 @@
> use kernel::{
>     drm::gem::{
>         self,
> -        shmem, //
> +        shmem,
> +        BaseObject, //
>     },
>     prelude::*,
> +    sizes::SZ_4K,
>     sync::{
>         aref::ARef,
>         Arc, //
> @@ -23,6 +25,7 @@
>         TyrDrmDevice,
>         TyrDrmDriver, //
>     },
> +    file::TyrDrmFile,
>     vm::{
>         Vm,
>         VmMapFlags, //
> @@ -53,6 +56,30 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: =
BoCreateArgs) -> impl PinInit<Se
> /// Type alias for Tyr GEM buffer objects.
> pub(crate) type Bo =3D gem::shmem::Object<BoData>;
>=20
> +/// Create a new GEM buffer object.
> +pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: =
u32) -> Result<ARef<Bo>> {
> +    if size =3D=3D 0 {
> +        return Err(EINVAL);
> +    }
> +
> +    let aligned_size =3D =
size.checked_next_multiple_of(SZ_4K).ok_or(EINVAL)?;

I think this needs to be PAGE_SIZE instead of SZ_4K.

> +
> +    Bo::new(
> +        ddev,
> +        aligned_size,
> +        shmem::ObjectConfig {
> +            map_wc: true,
> +            parent_resv_obj: None,
> +        },
> +        BoCreateArgs { flags },
> +    )
> +}
> +
> +/// Look up a GEM object by handle for a DRM file.
> +pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> =
Result<ARef<Bo>> {
> +    Bo::lookup_handle(file, handle)
> +}
> +
> /// Creates a dummy GEM object to serve as the root of a GPUVM.
> pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> =
Result<ARef<Bo>> {
>     let bo =3D Bo::new(
>=20
> --=20
> 2.43.0
>=20
>=20



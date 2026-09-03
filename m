Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E36C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 22:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2D06B0088; Thu,  3 Sep 2026 18:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A639E6B008A; Thu,  3 Sep 2026 18:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9793E6B008C; Thu,  3 Sep 2026 18:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5AA6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:16:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00ECA40575
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:16:44 +0000 (UTC)
X-FDA: 85173861528.03.CD63354
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03E22120010
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:16:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Gnepje8Y;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf29.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788473803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWOu6GJfHwlVwN5aizsAATz9AbxY/g0p76dvf7h/0WM=;
	b=wATqXmje1NfipxpvQvF/VlNRBC9lsNGEpsxoKM3yGTKRQPHb2v0NHhV3/m8fqMOU0yU8pC
	cnCEhNOVkIO9db9pcLYcvGeWKt1JfdWKXe0ps1Z9YC35kbTxDAL06jJwDLKzrZOaXzs3vg
	V4BJM50dSi51/soXeny4vH1LLPhspZI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Gnepje8Y;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf29.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788473803;
	b=zOpNghxxTa6i3MpXFtwDaqTvaIZ6KQexgLbuFRDSzYwgbjDeCvLqm11omjpjwXP2BNobjz
	3IF4WFGh5kyCWEEHaycz1060LugAv2srY3asjm1VoL3v/geR41O9LtMS5hvkKTPRM4k3l5
	MA5pXJK9B4mwhPZhhbEeEJLHGaXOTOE=
ARC-Seal: i=1; a=rsa-sha256; t=1788473791; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JKScbrY8mJKFBOk4gWjHsQ2eUiuL+OzJxuFYDly+hE86c+necr/CDKVWJ+uz/q7FBweNJsYrBzjIJHUiBlmi832Xb+qX2GHyePbp7dCvuEZmrkd6OI3vkcIwqFL3RRFd193tKr60GiTvXx3q9O3TS+LAjlBYbwKMITbmNVLYQzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788473791; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=RWOu6GJfHwlVwN5aizsAATz9AbxY/g0p76dvf7h/0WM=; 
	b=QFt+zF66oIB+oaebcKpgUyaDst/ujMpTCCIfaVnfuv/ualsr7Kx5POjZVndqNr7Iz3fgNzjo6CSmDpFYYWjF6usfkxB1JAwFs9YdB+z2KHm8vmTuyOV+7L3l5SO6D+fNbwrG/EVPtw56k44HKva5huU00puWRJWXHwD9U3hLckw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788473791;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=RWOu6GJfHwlVwN5aizsAATz9AbxY/g0p76dvf7h/0WM=;
	b=Gnepje8YnI0WypZChVR+bwIMVMs9Q4fMv5KTsV0j22N671f3pwyPR0ipgke5NPF6
	nqlhMB06Os1SP10rAUCS2wAEe4hFCrb0Y/wzo4WXdW96RKQv43BofKpG1rPtYuhFled
	1KyYc0rqrhQoMm4V7ZAQfBbiKOV2Gx3qPI/UoOdE=
Received: by mx.zohomail.com with SMTPS id 1788473791201272.4860508436931;
	Thu, 3 Sep 2026 15:16:31 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 7/9] drm/tyr: refactor new_dummy_object to use new_object
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-7-e0fdbf8bd108@kylinos.cn>
Date: Thu, 3 Sep 2026 19:16:12 -0300
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
Message-Id: <260753A3-F6C0-426F-B640-C397BC4EA3D7@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-7-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4aptcthrcg8e1zd9q8859qxd3hao7aum
X-Rspamd-Queue-Id: 03E22120010
X-HE-Tag: 1788473802-559961
X-HE-Meta: U2FsdGVkX18F0Pvr0DU6p9Qz0Ar+yo6hCfOq8pL22zC9+16ItO3v9QYPOsgnYU1KNVYowHEtBatRw3neM0q6DdUXhKzs8raYxs68bX3DD0qSlypfjMx+A0OP2VYa3pCk7Jt80aKzRzXmBbDX1fq8x59iO3UNEx6oxA4uq45zlinALlYv2Rr/ukXvP08NRBmq14ArEZ7fur9mTx7vAlCS06UNXmGR3dQWPEbomuccA7s66eGj/y6cfmeCmwDVVcRCpcQlyZp/gw52AK0sbIO+LERCtD8ekdDVhQKXRDAmdpEIBqfrK7MGjo1x2yEahysiCyFnThxzqc1bNgwWVTsGa0V8cF43UQj6SJTeUT3U0H9CSGc6SbZ3Zhvx5GCC724t5+zDMbyLiIYiXin+qFY4dHt9meAiZtxy13LBLmzvhRzUb+mLCVL1GZvtZQB3kV9owoSAAnG2fkW3xqYFUFphX+U/JqOBSA4fuEuJa5P6QJBR5gCacGSjC3i78CNEow+SG/MqOuanZWtb0B6xnbhyOeZT2K2/lmHm3ODaAgEQS9gPJY5rrTPP4AtE8f13hviRbNcfSUHycykiiRgoAGZKCNWZ4eh8TsMfmCZ1rh1K+mUcmIKcfIuReZR0MTKgRfxAG2+kV9MjVY0wESnmOeUHGO8BYRRxnWzH0V6SaiNfsaX4VMOF9sFNVluXHRvjdLLdAszwkXs0SquFqqGC80GLS4rQPvqgzPVT57gSarKV3cVVRvriPitdU9vvJk/FRQA6jWk5dyCzqjaa7LioH+73Bg2Bk0m1FFaThDBav/zyDr312cA25tL/2QaZ5gNO+1e8aezMdO5Q8MkKxfJ7n9wRG7z2i+G5dvxhRD+qg7QiI2Fu/KgRbnVlcZ8OHzmWcvNchIv79dVZQ7lO744SEhM+VDYsG+x8RtAk9rCeXWGFa+GBVJNj+P+hBqdAWr/2xcaNhotD6nUvouuOfXXA3+g
 m1rj20w+
 FrVkZiTT0WITlbfNLtvrstoCvw28I3vAAZtYyCZfIxFKDXimKpIHZ1Cjakr04l4ZCkERL9PB3U7vn6n+z+U/pfCc6rQ94F260b05wduUrX/iFmRClZmQUCD9zkQ2ECYOi3h9oI3f/FuUC5Nham/12HdwsmiX8v3ZMhThQeWLOnJG7AeieB4I50oDfUj2Y27nivxUUMZei8/MoGBRYLYvC25WOWUl5cD80eZD+zyFZu2zShV0H5C8rXbI9rothF04u+Gv9Xg1V7gkZs1tdJeOrxVhXv/Jlyr5CWhMHHyoTx5l4dxYyD9m1+E+BTrjsqwsulYqCmIYWXyiCJVq2sVnN3HnWjrakR/WfWr/TFYamLTvtGnP8oaAZsXvfsQRsGZRcPVi48y3OyMUOxp2qRfu9uajUSxuhEX5OqZ9La07yU1q7AWq4ZCCgp/wiPxm/NmNrjjNZutpdrf6wL82/7uqlzwRvt6DFgAzfXBzi
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
> new_dummy_object() duplicated the BO creation code that new_object()
> now provides; call new_object() instead.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/gem.rs | 13 ++-----------
> 1 file changed, 2 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
> index be1affe80db1a..d9ddcb287f52b 100644
> --- a/drivers/gpu/drm/tyr/gem.rs
> +++ b/drivers/gpu/drm/tyr/gem.rs
> @@ -82,17 +82,8 @@ pub(crate) fn lookup_handle(file: &TyrDrmFile, =
handle: u32) -> Result<ARef<Bo>>
>=20
> /// Creates a dummy GEM object to serve as the root of a GPUVM.
> pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> =
Result<ARef<Bo>> {
> -    let bo =3D Bo::new(
> -        ddev,
> -        4096,
> -        shmem::ObjectConfig {
> -            map_wc: true,
> -            parent_resv_obj: None,
> -        },
> -        BoCreateArgs { flags: 0 },
> -    )?;
> -
> -    Ok(bo)
> +    // FIXME: use a Rust resv-object abstraction once available, =
rather than a real BO.
> +    new_object(ddev, 4096, 0)

For the same reason as the previous patch, I think this needs to be =
PAGE_SIZE too.

Feel free to work on the FIXME itself separately, if you want.

> }
>=20
> /// Specifies how to choose a GPU virtual address for a [`KernelBo`].
>=20
> --=20
> 2.43.0
>=20
>=20
>=20

With the change above,

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>



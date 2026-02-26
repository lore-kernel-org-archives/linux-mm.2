Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE0FFC591F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140566B0088; Thu, 26 Feb 2026 05:18:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE9D6B0089; Thu, 26 Feb 2026 05:18:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32E96B008A; Thu, 26 Feb 2026 05:18:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E217E6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:18:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 895B05C4E2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:18:14 +0000 (UTC)
X-FDA: 84486207708.11.1E63E14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E6A5740006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:18:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YA05vn+G;
	spf=pass (imf04.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772101092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hc5A+YIPbUvWP9bq3ZFhjfnOvO5fP7HctYmrbEaLvk=;
	b=pP//uWrmfBX12SM2njbpwy6fg7aDhx0dhTgSDduv35gU8/If0ntbd45MqHVGfVp9re/jXO
	o/NVxLwoI+k7glewyHU7M6tTs8Se9OTaUtmkRc3n+JUlpTWJTYF6Bm6VwJxiYNTxe5iXgZ
	yluFPoJ93QJUCaa4d1BLRBjcnmkHQVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772101092; a=rsa-sha256;
	cv=none;
	b=BcSSELLf8gTLm6E6Bx0ZwhQc7qC3JWyEblFVMdd0aVTu2jUFPxZ09Rtcsjzptnrn2XcDfO
	qTGuOWqEQkxbPGwp961arQCtwdz/vwfrT0GZdkba/rqn4z6o4lowLCh0CPBh/2wxPfDOTZ
	rYaYV0mfni+yIDlyIBsuttS7mjdzBo8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YA05vn+G;
	spf=pass (imf04.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54F0F60097;
	Thu, 26 Feb 2026 10:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653B0C19423;
	Thu, 26 Feb 2026 10:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772101092;
	bh=tJEgWGAKGq9f+lDM1K325bKAQQGVyuPowxRSNNeauh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YA05vn+GecAOHOV0bBkerBcyLQZtuSeUa6UQ7vgNRSwpIOnk1+Xg6+oT0x9IHtTrl
	 onYSZPAZMTe0F6nGswJKHdgRDg7XQpXjYPnevq2aP5CjzYYkfR/90mmCWiRXuQKXgO
	 +H6Xg/Rhq5agCeF2gZr/HUOYNb17ra9+vda9r0ixBAHkwbHtqrU3kZA80oQM3Md0VV
	 3oG+afWszq4v8KgLw8YU0gigEQkK/ASy2JB3YMNHuc2rU2TRc0G1OCIOlc/+VT9/An
	 WWug7j7lR9Tts668IPaefBI8ZdIfDjIeHH8rA4GmNx2mGPbyBeq/94vk28A4Nl//XZ
	 CkRcRNPs8Ilvw==
Date: Thu, 26 Feb 2026 11:18:08 +0100
From: Maxime Ripard <mripard@kernel.org>
To: John Stultz <jstultz@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
Message-ID: <20260226-adaptable-vermilion-nautilus-0aa6f0@penduick>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <CANDhNCqk9Uk4aXHhUsL4hR1GHNmWZnH3C9Np-A02wdi+J3D7tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="sxksscuwilvy7rfq"
Content-Disposition: inline
In-Reply-To: <CANDhNCqk9Uk4aXHhUsL4hR1GHNmWZnH3C9Np-A02wdi+J3D7tA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: o9qp3wisxfdbgxryqo9sdx5479timr4s
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6A5740006
X-HE-Tag: 1772101092-428277
X-HE-Meta: U2FsdGVkX1+of0/XPvEATZ7iGQF71bJbuWqnzG1/MDq9Kz5g21m1y3BUTxnNdD7DShoY4LmY8tys4SIHbo4TAbtJXAKGxG2OvMsLRxHVzzFS0xwZSfEzfNZ6Gt+jEZFfGuu6juKdoNLlBa6QXZgD8JuWgvghM78HPGNQqKKuF7GqJ8k2pSb+VHNS6CTugB/QjCtZjttmkXOAwjA1z3bD8Zk17r+HJmNLypHwL/tkogvCLZtvKiE85NwXnzWjMAZo570bln7CP734iHKZvMzF5Mivl+R/aGkxWPbhBZJLn5N/f1DyiaSjRsM5VzZXwB0jt/yyOeWXrAT9jQhA/u4ZkMePybXj+c+6YVUusYZuwNRbNgMj2ErORLv+oOt9sTHROyLS3zfQRdWVsT09MjDrAaHg/5zyx9X9R7MLm/mvf52gpyTjmqVGuTabLHlGG+Mx6uio4sB386l6kQtbtZCgCFS0kxi+CNIaVzkIDYa/awCjUp24F2bJa5jnBVcrovrJix/vUqM/tkI23oJYLRZ2q1I9FilUfSp68oL6tv2JFD4qdZCnlj0E5d2LmN+GjCLMhUemEjxjpFXqGK1xaSf/ppCZhADhWSuDlRFiM3otTm30+Hs7tIql2YWn9BykK8DlbNCelneShyfOnzAJ3VXlz9h7XsNteOgvevqLuT7rC2rlot0UwlKo0A16b8iuK8qldJx/js0BDpC2d8K+SEtBsCL4AgxMVonI1HceEWuHPNZ4Bi+foynmLKqVqhELxR0+bPsT8B/EF/wuk6Emsfh9OZYKKd0HiieVuaqpOwpYAcOyOc2GDsJnXDuaE8IkFb9w3sOTF91mojYkZnqnf9nodUirXT+53kDeaVI2bzYJV8BzjYiPSCW3k6g1wk/WtXDWcEib2WHEmh/DLtME5xKdO4wMzPPyBGKLrnm0iEAxWbJt9vWdlcETW0DzmtcjRtRQyHK4oTKBoTgH/W0eRcJ
 k2jYD63V
 WXBULoJ46rxaeikf//eMxbnob85y9i1H5YL0+XXpKzDwSHoh7RWS0Enz7gwppevAX2/jDrS7MATifk0PdKkdwgQzOY977e4X5R/SVNnvF8nEQ6fUdbervN4ABNTLC7GI+YIVwhDfDC0QRKyFBzwhsvsQIRtBG041wg8J+lm2rE74J0zZlQ80aIlV3u+IR5/DWiTDpbbeSbz+v9Bo2To2WnWUINkIfwaxJ+WmixG74Lq1HHiVVDV+zZP0CVozLl2Dj/dVSxekav6CEhYsaLgo+U4QQnt9plFrWEpP0ZDcBQQe/VpnTDp8yAVs4ADP9Rng7MANxUUV4Pg9sHBx8Ts/kj1zensH1a7CGr041xiN+DdwFN4aJQcww8ElWvjWYa1LO5h1Ve6vt+a+5mrc4AKbuJaMZFj+T9D6g7ug4WiSUUD4rnMFURIlvLZH4tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--sxksscuwilvy7rfq
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
MIME-Version: 1.0

Hi John,

Thanks for the review

On Wed, Feb 25, 2026 at 10:51:30AM -0800, John Stultz wrote:
> On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org=
> wrote:
> >
> > The recent introduction of heaps in the optee driver [1] made possible
> > the creation of heaps as modules.
> >
> > It's generally a good idea if possible, including for the already
> > existing system and CMA heaps.
> >
> > The system one is pretty trivial, the CMA one is a bit more involved,
> > especially since we have a call from kernel/dma/contiguous.c to the CMA
> > heap code. This was solved by turning the logic around and making the
> > CMA heap call into the contiguous DMA code.
> >
>=20
> So heaps-as-modules is common in the Android kernels, and was
> attempted to be upstreamed long ago:
>   https://lore.kernel.org/lkml/20191025234834.28214-1-john.stultz@linaro.=
org/
>=20
> And it got a fairly chilly reception, but maybe having the additional
> optee heap (as well as other proposed heaps) might sway folks on this
> now.

I didn't know that Android was using heap as modules only, but I'd say
that it's even more of a reason to upstream it then.

> There is also the kref bits you might need (which Android still carries):
>   https://lore.kernel.org/lkml/20200725032633.125006-1-john.stultz@linaro=
=2Eorg/

I'm curious about this one though. It looks like you add refcounting,
but never really get the references anywhere. What was your intent, that
on every allocation the buffer would get a reference to the heap so we
avoid removing a heap with allocated buffers?

Maxime

--sxksscuwilvy7rfq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaaAd3wAKCRAnX84Zoj2+
dircAYDWmwkdH/3AAjuPp85DnYNPbSGFdhX/eyVBlLKWPqfln+xq2+gc6gDrOAAL
OyDKUToBf19j250y3Z4PQ7QYr1AXEq1bAKHYLpYrTQLrYCtOtKbL3L1J1eqyj4Jl
H3gZy48H7w==
=URjd
-----END PGP SIGNATURE-----

--sxksscuwilvy7rfq--


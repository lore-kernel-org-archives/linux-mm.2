Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E8D1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052C16B0088; Fri, 20 Mar 2026 09:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003506B0089; Fri, 20 Mar 2026 09:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BE46B008A; Fri, 20 Mar 2026 09:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4D116B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:09:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E67414024E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:09:54 +0000 (UTC)
X-FDA: 84566473908.23.044ADE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC6E5C0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:09:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhusO7Ir;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774012192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtyqkgdW2N+tGuiRRGwfaJSw9/wwP3BDlPbzeD6Tf8s=;
	b=gmtJbrmC+s3hihdpmwwGZMTL7fiOkU7gWCl4WB0UpLU9Iy9UiXXHiLtqDOnigmh+L7/Caz
	Suu4p1Q0Cpw1AOxOoehrBHijROau64Q/QTxg/P4iSieSfFz18hYCkMbTCsSMvrNZWsqN7f
	qtZzG0q2A7/Z3HdY7POwNkrfbnCV950=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774012192; a=rsa-sha256;
	cv=none;
	b=OfMCF9fAhNPH4vOeLskRisoe/pRTWnYG452uui5kQBQC8ZfOKd6+LRqf5L+aYqxUkmJV8Q
	1Ru1sx/Y54A2aZGer/kUwUqCQNz2bLPH6+TWEYH27UjNwvfGvyKDLK2Wnc3T9ZPsabb087
	4f0aK2iGU+KpcaMtoeC51P2xyCAq8Q4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhusO7Ir;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A84E8443E5;
	Fri, 20 Mar 2026 13:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3263CC4CEF7;
	Fri, 20 Mar 2026 13:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774012191;
	bh=KtyqkgdW2N+tGuiRRGwfaJSw9/wwP3BDlPbzeD6Tf8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UhusO7Ir2EBydsGHlZyj5vew5uqx3LL62vko5Nvx7uYqnN8LXpvVu0HBg4Jb3rN11
	 6S73M9ojHqYjBNhrbqF5Hh7jyCfzHErGHu3L1R6mUu7iSqAUdNpYycA6t0Y2JGCu7I
	 azCPpzorM0ShT1moymtT/RU9iLPZHEFywsckNnX3po4/g+RkOux39sHfuVFqfrhI0x
	 6K5iBG0kBNAiB0VJi3u6qKegr8Nd04DhRa7oBU/Df5hCAnlurweBz5L4KTZSQstN+h
	 7+aKbBVLQnUQbRckkQHUOiKXHr8jcSwXklaf2DF4sTPlOxHzV7mqlaSl370vp3i1VV
	 OQBJzASK6ggNg==
Date: Fri, 20 Mar 2026 14:09:48 +0100
From: Maxime Ripard <mripard@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/8] dma-buf: heaps: Turn heaps into modules
Message-ID: <20260320-cryptic-industrious-otter-5b696a@houat>
References: <CGME20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555@eucas1p2.samsung.com>
 <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
 <c60a3f30-6fc3-41ab-835a-2fdd887e18fd@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="zs66qpw74bbg7irl"
Content-Disposition: inline
In-Reply-To: <c60a3f30-6fc3-41ab-835a-2fdd887e18fd@samsung.com>
X-Stat-Signature: t4oghc6rf4y8hkf3x6pihp7773z8irxg
X-Rspam-User: 
X-Rspamd-Queue-Id: AC6E5C0010
X-Rspamd-Server: rspam12
X-HE-Tag: 1774012192-138716
X-HE-Meta: U2FsdGVkX1/uy/Cc7QVHxL3PLD8U1TZBwGOo7BZKG/IZO3PCADEZ0cDidukyS0r4Ua0Zh1oxpsT5q0sF4XAQ3KQeRy+qmMHqNLrwCOo4bBUJ/X7pbUd4q4cx8wHBcfEYoujFI5chQNjD2tZ57J2u3+eO8690GWJHKE1Q5I592mTLDo2UXkVeU+SYcK3jKlZFG/u2w+WOvzX0N92QjFpbB75scLw3Kaz6DyTscaut5wgHVIxKXbY+qrLAHDI3b2cdX8we75OUat0zUKwIMtFEwAR/m7SAfjvFQpkGb16dxt6ar5NhF+Jrn+knOPci2L+y6QM6djthixCZb7O9htoXb1+zRi4GTaMWw40tQWypREsln7ZW61Z0SmngIuK4B2lc/uI4jFHqreRR6pnR0PFYvYwAWw9sQK0SrMy2aCfIWX/6ZltqhqzkCobXtfe/ZKQHi4lu3RjJhrkK7mB26aWhk96NZiHk1IHHmMR4xQ1iYIb0xV/qHqXPmcOkDkDUWFJ8jJCXms2F8rD3jMJsXCNQHiMEBx+XeahezMnVY7JkY0INZWGgpuM260VQh39x/duWwYiZLljCpC8QSFRt+435SGzwNo0hIH/ymCuMvqtFa5G6M8Puo1bDa+Z/hYNh23QzeWeHVPkUt5OYsYUNEP6R7nVEw1fOHhsV83GmdtmBMUSZbDZl7enrv/mOmuNwHHcj0fqe1UghBKams764VRyb1xZXBvYnTxNr9dYMhcSo8fGjOvYij7aZt/4MLjeWrR6i2N453dYzZCYaX2dg74DsOVKZBJz/jDWUbz82agEmtfPiITWp1qxRZpzrbWUKknKc4S4GPbtRDRRYiejShb+45XX+59QBDFpmiDLA9rqBccp77ZFs6UdIKhhdHE1LGixbi/INBuhl6xw9pwNUopSrAx7XkeSlMUFK2qztiasbz0EuoRRXo0lt1Y1y5KGA80Besb1L3cLahup2oJogdKe
 rAiPbkgM
 LBovVj1sg9P/oMQ6dVWd3tKI4U2Evc03F0/cLd5EofGwSQ6aFZeYqJmvh9FlFyWqlB2gvbp5kpYGwDmjk5NYh5k75pNI9WkZ54Qw8g462NwMDE91ekfC6ulM58o0sx9LLHC5wXm9XY+NfLWiDAAgUZa/o4lCPu2T3tF3Tm2w/zUzs81GMNg6q/1Y4x8h+EK6P3ZmEt3X1pnXaznC0aokU7ZKqaXjSNqHPheC4O3jHyBNOZQCT3s87xW4NmtFAqhoy/FnXOKKvfk/lKyZexbJH97gui8oll7dHonWYQH9mEh/ioxzVnsQdtet529mSVmKndVEbslsMcI7Mk7I8dLT9UwNPTsnO2hZSWXPt/5vNZYIqAQvLS3wYFqhwl/E0XKn3XBsoLsC17W4XlphzW15DNM3YZeZN9nCwGCuQBP049iKmlMY0rmeLp6zbEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--zs66qpw74bbg7irl
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 0/8] dma-buf: heaps: Turn heaps into modules
MIME-Version: 1.0

Hi Marek,

On Fri, Mar 20, 2026 at 01:24:18PM +0100, Marek Szyprowski wrote:
> On 03.03.2026 11:13, Maxime Ripard wrote:
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
> > Let me know what you think,
> > Maxime
> >
> > 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wikl=
ander@linaro.org/
> >
> > Signed-off-by: Maxime Ripard <mripard@kernel.org>
>=20
> I'm okay with the kernel/dma/contiguous.c changes. I only wonder how to=
=20
> properly merge them. There are other pending changes to=20
> kernel/dma/contiguous.c file [1] and if they finally get reviewed, I=20
> would like to merge=A0both via dma-mapping-for-next tree. Then I can=20
> provide a stable branch for merging the remaining dma-buf pathes. Is it=
=20
> okay for You?

That sounds reasonable to media
Thanks!
Maxime

--zs66qpw74bbg7irl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCab1HHAAKCRAnX84Zoj2+
dtHjAYCni65LYJfONrHzX1+dmTg8jR62Up22RXPxSlYyod1hB1tdIw9izCD0G6Yd
tTFaIwEBgJvjLz3SwBA1sbRbznr8PQjslZc5ZJNJzdGupJIT8b7KJryJWaeGjrY9
oc+2U5qZsA==
=0xTf
-----END PGP SIGNATURE-----

--zs66qpw74bbg7irl--


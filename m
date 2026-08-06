Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0699C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05ADD6B009D; Thu,  6 Aug 2026 12:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034706B009E; Thu,  6 Aug 2026 12:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63786B009F; Thu,  6 Aug 2026 12:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFF7B6B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 257CA8014F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:49 +0000 (UTC)
X-FDA: 85071360738.10.AFD1F41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 679561C000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aalAEn7r;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OQRYxnEbL1vlfwxgT977i1AfPRqWf0vi68WNMX/Mqo=;
	b=lkyBr/auFaFR21QCCU/7bzu9/ZYLID/A21TgBmrJNXq8mthdzQ/craZNKmbOcwu7CIxVr0
	NetHygK6EJEs+wZuWschhaykYQhv5iek2PAqrPfLNByazFbY/3kndjcdC/GuRNSoB5oBaJ
	IASCWMp/VqkTz2yHrtMaexse8uriYAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033307;
	b=0FkhG8ko38UMCV5kfDgK0Rz98Sy9MO3cpBDvRBkG6Ew62Q+QaqOIjCkY7Wxo0ySoQVI9VF
	ncbpxrsnof2akiVRrN8JhSwSpy+gL9Bz/QemB7GyvD8Mhivtq11F+4GEutqMzH9PDPudOW
	085g8f+9xEyfQViDXBT+5ErCfdvr2qE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aalAEn7r;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AC0A4166E;
	Thu,  6 Aug 2026 16:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3844E1F00A3A;
	Thu,  6 Aug 2026 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786033305;
	bh=9OQRYxnEbL1vlfwxgT977i1AfPRqWf0vi68WNMX/Mqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aalAEn7rNUlyRJPV20BjL3yI3iPPN+js6kl4wiCICluf+ZHpYklDJI/OsH7/3ARg6
	 6B8o11hfV2IPUN3Qq6QJmnNjXQC+59EpEP5WYdtoDSed9abq3u+doW4SPm6/oDr3T7
	 WWaEaKql5HntTfMkY72NHSwnnY6fX/u97XSO3ci0teM4TfzFOTv5O8ebSGlHprBcY8
	 llw1LEhloYGFMqTMz6BQvN3SKr+VR2DwYRLKw1W8OM9fFn1tKTbaycRrBHNmPXt+oU
	 fLBXBy6hbmtPaffVx6Jj94F/NzDmzVT6Qs46zlC7UEKdcgz0I0lIyGDW38wbRt4aCm
	 UPYrrB9vJfAAQ==
Date: Thu, 6 Aug 2026 18:21:43 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
Message-ID: <anSyU_-zArFch-an@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
 <CABdmKX2i_vxs3EgJgydEbXoTxqWe9g9pj=hqPKuwf0ge0SjZuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4gmnekg7ar3gl7m6"
Content-Disposition: inline
In-Reply-To: <CABdmKX2i_vxs3EgJgydEbXoTxqWe9g9pj=hqPKuwf0ge0SjZuQ@mail.gmail.com>
X-Rspamd-Queue-Id: 679561C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4hmxhhjbtun1gsuem6fzjd85c1zpcrzq
X-HE-Tag: 1786033307-510478
X-HE-Meta: U2FsdGVkX195k/TLehlhJf98FrTTgN0oB10txv6Xfu8Ig8r/dlsZrwN73Ip90eYVNXExn34CtvNi/hWIIGOll8jAfnMTw7jZ0WO9gAjCFnwZmiEqsPMua64/EWuC+ToyQD3tBpL4DNt0ohZ+thzVJyMFZz3NFPp+9k90BCj5VjL+9Q+kq+2qL3mGjMwgqFSmkofvkzvoJqDrQ9tYt+C9UdH+cBhZ7fHzS1zBntXMcBTaWKCMOvqutNyb/FyxpRbd3vu70Pic81GHFVWj8mgEFrP6Jc7oEfFkuyb5qYkkEze2WWyrJG7FORA3yONkHa/2mSKj7e3XrkyukyZmsiuoyuegjnKvkSQ54FuSYRfhOQHDVrCMij7swf5kBg9x0oOYy8M/5+wV7Tbzh5kQvrwYRdGbIAocfIj9wAyE1lR6aF7H8xgISF7BHIiYjoe/WE/P0WvopgbLM5oRi9SMHSrhmv1r8Ck9m2PDLnUxCqcj1jTKvnzGa3IzPSxCnP+nAnJL3zqcvnBb2iq6/uzUCp5YTkI8OjPbg+8feVOWZIY1lNLqu/+Xbv7TbRhaEuAxh6KsfPAcfzOLEvRNMeG8yOZ7dpfWUiNPhbP/my4zjyn5DJsWoiEL0k+3uv6dNi2+mImLJXMn5oXA6Ef3w9OyTk8EGjOnWHlX43eaKtu60b1F7S6eC+dQ+14GhSfzvebw8l+bqxsBrqDwuSCQ8DC3exFJ4dyBmJq/B3Gl641oKJ8/lANm+26fnoCsIfUXVTgmwiS1GaS8uF+D9sp4JaM0ey6IEiwlZc8PNimb8npYffKAOR1w5Z5MDEuGiwJ+w7k4RNrc8pjyY3L8KCY76HhtUkfL9CqGN/9hTI2zB4lp56lLImStUtSId91ceyIy5GueYw9oIUenwRcR0ni65gwbBpDIVn9ZCPZZpz67jTpApA4i054o66odxxHGi1zH0PCB5sa7yl+ebFigjL7CWTQJwzm
 CeGG1BXJ
 uThst3RbIlcsFOVwmdKCIkuApGFe0lllsfxgV4unWAMzoqWJF0e22XF9e7DkKLAGijlljn6GELT2Ca5e41mFlyeK1oZBk5mt3ZVLWpDca6kqUGLhg5ZwB9QsVJBYmVEqMzUFt+9obgHabo+vkgUDFhbbotKRQ93aDjel/0RsNS3MPhTQr4pvpjg+8dQuRXU3T7YSigDCSMgYHfMF3C/KqSmE97CtfYytd4N4XPGxisn9txvyHulWKVSm1kWh9FsS/+VHqd8h6qw3IftUHrRXEPvCKCrA22qeAz7ABlJnUsLIVMXbSpjzCh8AXTwxqaqOQiwKMDMk5WY8IvLdb+PvhCJmLmnL/I4gQYHlJDKTlTXVGJqDz82LT3yyMJaKSdbdKsFnwjdWmfyqfEHBYOMj0r1EH7nBwnR3cpJxdV/TbcXChH6QNjw8/XndUjlJ8u22CG3BWJOHsD/Qo2HSC8QtTIBuWWU+cz6GGo/Wh+qT2vWqeHQoM0bYlPi0ImmmvAzzzuw+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4gmnekg7ar3gl7m6
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Wed, Jul 08, 2026 at 04:49:31PM -0700, T.J. Mercier wrote:
> On Wed, Jul 1, 2026 at 9:09=E2=80=AFAM Thierry Reding <thierry.reding@ker=
nel.org> wrote:
> >
> > From: Thierry Reding <treding@nvidia.com>
> >
> > There is no technical reason why there should be a limited number of CMA
> > regions, so extract some code into helpers and use them to create extra
> > functions (cma_create() and cma_free()) that allow creating and freeing,
> > respectively, CMA regions dynamically at runtime.
> >
> > The static array of CMA areas cannot be replaced by dynamically created
> > areas because for many of them, allocation must not fail and some cases
> > may need to initialize them before the slab allocator is even available.
> > To account for this, keep these "early" areas in a separate list and
> > track the dynamic areas in a separate list.

Huh... going over this thread again I could've sworn that I had replied
to this before, but I can't find any evidence of any reply.

> Hi, It looks like you'll also need to update the CMA dma-buf heap's
> add_cma_heaps init function so that it adds all the CMA areas, not
> just the early ones.

I would actually rather not do that. The case that we need this for is
creating a special purpose dma-buf heap that's composed of multiple CMA
areas. These areas must not be used by anyone else. Exposing these to
the CMA dma-buf heap would allow anyone to allocate from individual
chunks and throw off the accounting that we need to do in order to keep
the protected memory from working correctly.

Besides, given the dynamic nature of this means that the CMA dma-buf
heap might already have probed when these dynamic CMA areas are added.
So we would either need to have some way of notifying the CMA dma-buf
heap of newly created areas or we might end up with an incomplete set
of registered heaps.

If you really insist, I could look into this, but I think it's actually
a nice feature that the CMA dma-buf heap only registers these "early"
areas and exposes them.

Thierry

--4gmnekg7ar3gl7m6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmp0tJQACgkQ3SOs138+
s6Hx2A/+LyXBkYE0i4vOlsqA/Ydjj8c8/300xmhsRpFbwbpF3gTAquepUhv4ccLk
pn6s3oOPckjHUjgqi17LCjM+dbGIQRiXZ5sHHuq69DOmSq6K43pvPWC9DQE3kICK
i05UEwUTy2GyHSp229X6bMmMKYyl4WW9pde+bHXFO3IBdszOFd76qxdMqtl3agOv
kfgnaTJezzmgsC1qP4etPKCdwHkxCcCO+r/IUp5vm8tuot9r3ZmBeyeLcSaboN0D
RP21XS13WS+QLN/rZAXyBAVhrpNrTBOcQcI5CYrTXnDFkJYeQJEkd5ugPi/q2wr4
KM8oHddCYYYHQyIEOG7pFcNGhonqPopbSVLN/BwII0fbmJXppQrdPyR4B3ZzsZzI
51eP67NZSMCtnEqOeaqKYc629FRTyBsrMWfEhmHu19hAJb/p9PvkqxCIR+TlebSt
HbuYY8JUEbz4Ck0Cb9FHGHsuYwsYkSKVpy0CpXnqkYEayTLU7dEHHpoKyTtS5Wvz
w8fNZPuvXMWffnb1L+4nblBj2VNkJCSUvr3ZcgU0H6PlqcES02A5W6ectwCN/2R2
STUcZd3vK2dFxCKRPHOx5+YyienQ9dBUapH7HwK01V0SFwh9m58TpMKmacD+y7vU
Ns4RBrD6r3h3Ua+YybzB1+b9dqB8U4mzDp9x92jAksifc9ZHH5Y=
=/fYh
-----END PGP SIGNATURE-----

--4gmnekg7ar3gl7m6--


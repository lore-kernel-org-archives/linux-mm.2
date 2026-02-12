Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC594EE3693
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356476B0005; Thu, 12 Feb 2026 09:44:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC836B008A; Thu, 12 Feb 2026 09:44:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200C16B008C; Thu, 12 Feb 2026 09:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC566B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:44:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A499E1601C8
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:44:16 +0000 (UTC)
X-FDA: 84436074912.25.BB6F3CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 045AF180014
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:44:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkxyqDfd;
	spf=pass (imf06.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsRfq4JQHV9EhUjp6BlIKRlXnA1FZ0qmUD3BISX7I1E=;
	b=26kQ8IoFRj4B2saNbx58Xx4TxahAFoZDweDDiK1YaL8krwhGqtiz5/2ajfAFvSsWiE2Pv9
	XH7ntxtKh/rU0hfop2F4r1+cz1lpcXeF38QwZFdzKR7Uo6HSZsEB8zM7OVRzcEYsayc96X
	0WZu0cQbpBpRWkJQ5cJSQZHho2Fw68o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkxyqDfd;
	spf=pass (imf06.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907455; a=rsa-sha256;
	cv=none;
	b=5pMAvkBPf8k/tiLwi5IN7qzae/DplnXzfoCcSp0eft9bBQ855RfLYd+M6P3+jyJJwnPH/h
	Wki1gRSEnFyxeKBCz/H/ef8c6MrtBOJZ4QpE2oSAiHzRFqczE5fMHhAFI6kSuj5wafSJXZ
	oojJkMExFdleCpSd/c9qSix9yhbYP7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6209A6001A;
	Thu, 12 Feb 2026 14:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E5AC4CEF7;
	Thu, 12 Feb 2026 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770907454;
	bh=wsRfq4JQHV9EhUjp6BlIKRlXnA1FZ0qmUD3BISX7I1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XkxyqDfdIbc2bvCV2VBTnKQn9x0JFcTOZBtBFX9PB8A/2SpUcIM1nvBYIKLVp7Lmm
	 lQadF0urGbstpA3g9OASJ+foqHw327u6Sa3rSgYzmtxZDbIqF8POCkoZL6HQ0uzA2n
	 euVz7mNjkB/EnKj7QbbU4yEvU27No5zuj7siNzFWGIA4qqv9MeuF4DWoOhsyqGj+nQ
	 YedwoFYYkkwAZIeXxE7U+M5M9UiuoXGQY1TTFXZs0kXeg0mCoNz2Ssbs09aLyqB1I6
	 cG5j7sYjeMmNkVYyk0RePGcka/JK5TRHwlAEYq3Nqj2STN4KtIFqQSP7/eQ+SwpDmV
	 N3yMaDkmI1QQQ==
Date: Thu, 12 Feb 2026 15:44:11 +0100
From: Thierry Reding <thierry.reding@kernel.org>
To: Maxime Ripard <mripard@redhat.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
Message-ID: <aY3j57xvdOY09EwQ@orome>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-5-thierry.reding@kernel.org>
 <20260123-active-witty-rabbit-0fc5b9@houat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="glr5iu7kbaysq2rw"
Content-Disposition: inline
In-Reply-To: <20260123-active-witty-rabbit-0fc5b9@houat>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 045AF180014
X-Stat-Signature: zgyiuq357nqbzw4mp69dityitieef5g9
X-Rspam-User: 
X-HE-Tag: 1770907454-857219
X-HE-Meta: U2FsdGVkX1+6CkVUcKyYdD3JlpN/TQvD1gKxZc4k91b8M+NIfR1yDfPWultxQg5cFg9umDoxiE0mUwW3ckaQPhurh3iK5dEQBJu9bGiB4n50xY6s0OsGpEB8SB74dJul8+gmCM2MH+IwITgH2j/OTo6HevaB2lc+TQC73OG9h47HQaxH0x6tbQzhr2j8AVF3gfgBphxZJ1RKb8WJRHvJpnH0nbZutLt3jexlp18HSMvmAILGLUWB3YZAmc3ziP4p32TWWq+Lp3SppLtL0QfcDJj6vxMZ1N4Fj2N7BirdVZxPh9wdOD3BKS5OM4oL6tCvbl69Felv8RhPQTo7h5Osk2BClBg2Q2O1Emrsaivfxs3G336QF6h5iq9WE32zdpC4RIFuLGKMAbGbqW8dCWwCwF5yGMeYVEqAg+bZM7GAz9MwAszAu9ca5XT4/VPujUMypoMurlbkBfHmqmfoRQ1xJF8a7xMxTnL8u3KRU17akDAmso7p7ybkjIrhWwoFVlYI4YdqLjdVsGP7ElxqyGFsIE5tC9DT+8r4Jz0icEkGvCO48Dx+OKBjmigu3pbgXHvK2+BM6wyUYc/subykBz3/y1JTCLR5104dcTv92pEjnh/3JtE1GfclHrrusU5n2uG7EPadnfckqLg2DewAp4aaf5SzF6xD5RjpDDq+X9rG3UrzUtbMy+SYfmjzgbp/ZZ2/1HxOIT6ooQm1Hig3ybkkwbMJNUeqVpCOIFgUNyY5XQsurCuADkW+wnrOziMx6yvOZhxjFiMCztiWPeBK+71QTqkkjCEDc6/MWil5k7uYH1z8BE6p8WL/i/Y3z9aHyFivMdxz2L9QhLDYe/PwsG+BCFPToEuKTMyzRcPUewY69nH+zk/nLtDtxer+1ijmSYXclwMPCR+QBKPPKUwct7kUQoiw/dwEb2BY72ElbscAu8sG7heeR0A/6XlCni/mhT/dCCznC2WYKwoqEPvJaUk
 Nt6pVtyD
 wkpMr7cKd9knHK9wS9/IzRBSw1THaI+7Jo0mpWbSVdg9YKSyncdWK0Ba752OXC1m1q5sUm/Lk9v4GHGFfVUWriEa/8eSGie/WtQeWu7tMW23UAzpVlLvLx8ibDA2u4ck5b0Sz8JhU5PV6E2MdGLZJH8iYNlexoasaHpTFdJpqLyvuaHXJuF7iWG+WkYXCHRNAOL+xxxYaEBkEPVqi7qoYaM0B0vH9iEVOHTR9RG4VkRqah23wMEEk75v1nYBYu5nSadaUL4Us6IwEaTr30pMxByyL+zfgUABUfXU7Opado32zvNxev1yRBCWUFdvDfxS2Z0UFuJjA+efH/x+s+FtagrKCD943zGiXSRVOL7NpGHOZgJ1oNc70ftiAoYnrxu3dF9Emt+wn4IXMTQ+pTkQ08b+h1t0mqeAOAfmchkpEl1SanbTcJ+SHn43nmQ4GjHDDNQZs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--glr5iu7kbaysq2rw
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Fri, Jan 23, 2026 at 02:25:16PM +0100, Maxime Ripard wrote:
> On Thu, Jan 22, 2026 at 05:10:03PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > There is no technical reason why there should be a limited number of CMA
> > regions, so extract some code into helpers and use them to create extra
> > functions (cma_create() and cma_free()) that allow creating and freeing,
> > respectively, CMA regions dynamically at runtime.
> >=20
> > The static array of CMA areas cannot be replaced by dynamically created
> > areas because for many of them, allocation must not fail and some cases
> > may need to initialize them before the slab allocator is even available.
> > To account for this, keep these "early" areas in a separate list and
> > track the dynamic areas in a separate list.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> AFAIU, this won't create a new cma heap when registering. This goes
> against the recent work we did to create one for every cma region.
>=20
> I guess, since you have a driver that would explicitly handle that
> region, we should create some kind of opt-out mechanism, but by default,
> we should still create such a heap.

It sounds like there's a bit of a conflict between what you want to
achieve and what this series attempts to do.

The way I see it, the CMA code is more of a helper that gives you a
specific functionality set. Exposing each CMA area as a heap that
userspace can allocate from seems like a bad idea to me.

Without knowing anything specific about a CMA area you don't know if it
makes sense to expose it as a heap. Given that there is very little
information associated with a CMA area there's only so much guessing
that you can do. I think it'd be more sensible to make CMA areas opt-in
to have a heap created for them rather than requiring opt-out. Exposing
a heap publicly applies only to a (potentially) small subset of all CMA
areas, albeit at the moment it may seem that that is what it's primarily
used for.

In fact, for this particular driver nobody must allocate from any of the
CMA regions associated with the heap driver outside of that heap driver,
simply because the heap driver maintains meta data about these CMA
regions for things to work. If we allow access to it from anywhere,
things are eventually going to explode.

> That being said, it's not clear to me why the heap driver uses CMA in
> the first place.

We use CMA as a way of reclaiming memory if needed. The heap that we
create is meant to be resizable, so that when nothing uses the heap, the
memory can be reused for other purposes. However, when memory is
allocated from the heap, we need to reclaim that memory for the heap and
relocate any buffers allocated from the region somewhere else. CMA does
all of that for us, so it seemed like the logical choice for this.

Thierry

--glr5iu7kbaysq2rw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmmN5zgACgkQ3SOs138+
s6FSqRAAwWGzG1UjDgVwyR+isYP6DrFMGbojEtczHFxgKElBKoFjjqtdmpN97XRD
7MIc1C6LGCLoJa++YXy7ZlL24CTzYRohVBnmy/Hygdz2uoaeW7GdR0M31slI/lG4
TpliCL/GXNi1ZhmE8BjykmsEqgjHG+PH9Vd1/VEgo/5DoaX3uc+8TndO9hqh/Jgh
gFScFbr/VRKDx8wdWyhOsWN4Nm52uJBCPbhJ8dGv4iabMopEwOlLpcm32aFNWMHv
El8zIIeGzfw9lfWm2WZvtO8heFn3R0kT5yw4opDc7STvO7k6fC/ZQWbg86FR71/e
DtrHMcjjg+75TIZemvKQwPrshL7CAdwcaNnT+QxVKE0oqHxjoIonRsUkEaTrFKyE
6n6eqR8+enCtH3hamWE6rFocZQzL5zXxqILwbzeAR/4CBtXBh3pZL4SH6V0cye9h
jci5Lfjh2SiLSggSKXsTBgrCLCvz8DuapM8GEtfkRS1YoKrix+uGe0nj+J3uAx+U
SyvOCMoTb+WWQNOyNBMpS2Wk3KcNDMuadOtuxbZa1BInxUBOktPn/km1vJgiO0au
5sWtH6xSgLF50qbTEFRVg+Pz31LIT+TZSA6L2gj5EmD1gKZeefPCtkiBgDZdsvwk
KAejAHsfMS0kibucCHIgTg6cjifaVKfFVtiBh3BX8ZuSmmlqnOM=
=TTIe
-----END PGP SIGNATURE-----

--glr5iu7kbaysq2rw--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07E3C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA86F6B009D; Tue, 22 Sep 2026 06:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35776B009E; Tue, 22 Sep 2026 06:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972EC6B009F; Tue, 22 Sep 2026 06:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71B826B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:57:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2DAC8042A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:57:13 +0000 (UTC)
X-FDA: 85241096346.15.736349F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5758B4000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:57:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rq2lHonw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790074632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UB96pS2lXgKbRferXQ6MVjY4lTebWD1sRvTJ4mcNWqk=;
	b=2+cU87nK/HK5nhF8MwI7wtwuRuEig2PFSovEwffxiLPICEG2UVSKnQ8UL8fQsXhEquGjRq
	oaxV8/Vd7eAh2j7dY3YC4p+FShSRQrsw2lP+vB07cy2qcD/d+66zvEVvqVFnZGXfRZyHU5
	q4SEt1x680rX4X8NpgfHT636wYEz//s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rq2lHonw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790074632;
	b=Z0VcGWgRUt2NJ6wMaHYoCMxpcYtKd4kdAWV6eL7nvzX3xi2zudF54jnXFjIxnWiyqASobB
	CxXsHqSdHAVevS7y5eKfzYhIDlg7y5Koqt9MKWViD+UeHKZyeEthUe3aaxhQzMUMk+JtYp
	l9mWLGOKf2cu0DIF3i2nIzzXBQyWi1I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AC4B601F7;
	Tue, 22 Sep 2026 10:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502211F000FF;
	Tue, 22 Sep 2026 10:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790074630;
	bh=UB96pS2lXgKbRferXQ6MVjY4lTebWD1sRvTJ4mcNWqk=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=Rq2lHonwYPyCf0LLYZb2zrrKIpjLsvWXDigwiH5+Vfw1oOnTbWsoaDFGlnn8yAkKl
	 YBtUcTcqQ6S8bDc3xrwMdxRk7g9MqnsSrnTti5Dv9matZxJl+3v37KxReqYELKuHDT
	 A1MxyhZaHxRuSiSDIeTSL1yOggks0CmlBEhGuKS4phKSLfzIhy3hGLXx6xuX+3To7F
	 T9x32aqA7aV1zpniyrAHl0cauBnGJ/2lkq80honi2zzl31bFmeIdOGlZPLa6tk45uH
	 Jpok/CVRDPvfYy5nB+eP3YDsKHSCeV01tKRv2gnUbIm2pKCzR/BdcVSsa6x9ymPLQd
	 cuJMpvaYGHv/g==
Date: Tue, 22 Sep 2026 12:57:08 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com, 
	will@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, 
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com, 
	ardb@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <arJcN60nagFKXj2Q@orome>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d2bniudpfuafwp74"
Content-Disposition: inline
In-Reply-To: <arIYtjmSKCs14SqO@sumit-xelite>
X-Stat-Signature: 6x59jcrdiwxq6k8jthwfrxh5c9383f6n
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5758B4000C
X-HE-Tag: 1790074632-129325
X-HE-Meta: U2FsdGVkX1+1ViFXpbQodqNBKWFAbCHCAKfFG4FmPOMUlHusKLzQk4yZd0Lp9QgdayKNWJ2rnFEgh2VvFZ5/3G254mToeTU5GQ/QtBiz8lneJKg4jWqfk0BkgbOkZlMsPBvMQyDxz94URpaBvpwkK19XDfEf6jEB8Zbdo1pjsEWPYsm8d1mC/pCQvMMMu77nhK9lSymmd+bBZOC16lJMPMqefTlQhZ3F6tGXxIoGP/ga1hGg0B+6UeOOxIPwbE0A544HBLk3WLK2h1vpoj21FCGKdml+fbgf4ADP9KtjN4Nqib8v+33LPqKpFHINE1U1QLBgsWv6ctT1C+zxAJyf6eLRQKU8nXdSC/z28dqwFgK/5yTS4VNkmfwnxcKDNBLZ5VFkGBMjymx4q5vZFOPPrVLFeLPl1iE0/F8gQoMUqhIn7p8wz1epnEvx5DGZnAE0wG4SFPgoWsjSvIjIYFGJcsc8yHjcm0i2qE1qGc8RgL+78TBGOpbtYkAuV6gNPit4Y0l/ki1UA3sUcJyGgXP7ihPx4M/0KZvbZAT3iUV+ijYmU9Ojvlh/FlvXV8ddN2zUs4yh7BBkXyBid5VOx3A07Icy4uE2J9AIOQP4ei1W0jzl8o4uAVL1OSNXTkWKOdG9nKd49zyhN6FSQR/PWbWkJBaZAUU6vJ8Jzx9hJyTvUN2AKJk7ltArThUQxMWWnE1K69my7gRcnosXqbOcvvXlENLLKslcJyMAj64E6nXRi6+YMXYGfyMyuD/5AOkKJVQ17hLja0Dh5xwdZrYEzMIeo3uidP3DpkSdvEGFRdtQ83XN4lejHrXTGN3rIYoIAN3T8VQ/di/DFuYluwJTppl3C54ah2luy/VNJD32KMV7WwNQtHDbXHHCALpTzHGGfJclwEGAUGWGuSKfEULlu3O2Z8Hs/Y02mGwsIQ4hFJk/rVoRkErbnON4qsHE6neGuGkJ2nlHQYSBsGVuC2aIEu3
 AKFy15YW
 mtYd2+jCN3vGG+GpwaKl41oeeq7sTTe2xzMy3zJXwpMryskX30G4Y7/jb905Ia9YbeeZL24cseWzd3mwlO7OjUSePksbWzjc9KB+h9D4019CsjYAo0JF1ZBOCPLhXsOVPW5JXZLCm0ODNthoar/ZWrpXzmuQekl17bGvxNZKo8SkV9+QfN+k7PmqENU3hiIV+QvcKbkHJSsv5wRYrSk8K5FyVFmVEZCUyDEDCJ0CYL+FiGG3/u8zc7mvJ9PHbuGZEPnF6E9IJ0i+x8Oc3EDeugwwfoc2zmEqKDYi9FAYG00X1/v/X8z7NVFco0lT3d/seRdn51csK1Gdy40m4PgqwqOHwrL5ovbJTe+dxcVxeiTk23bov/073aSb6p3oRyF+EPNT4WNQVgTMh+8n7wCSrOud9UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--d2bniudpfuafwp74
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
MIME-Version: 1.0

On Tue, Sep 22, 2026 at 11:27:10AM +0530, Sumit Garg wrote:
> Hi Vincent,
>=20
> On Mon, 21 Sep 2026 at 12:00:42 +0100, Vincent Donnefort wrote:
> > This series is a follow-up to the discussion that has started here [1].
> >=20
> > When memory is lent to the Secure world via FF-A, CPU speculative
> > accesses from NS to the lent pages can still occur as long as it retains
> > a cacheable mapping to it.
> >=20
> > Ideally, lent memory would be "no-map" but that would mean giving up
> > MiBs of useful memory, so let's try to do better with the help of a CMA
> > pool.
> >=20
> > On arm64, modifying the direct map at runtime is generally restricted
> > because the linear map defaults to block mapping and splitting blocks at
> > runtime may trigger fatal page fault, unless the CPU implements BBML3
> > or the entire direct map was mapped at page granularity from boot.
> > Forcing last-level mappings system-wide incurs a severe penalty we want
> > to avoid. Instead, this series introduces targeted last-level mappings
> > for designated memory regions, along with the "arm,ffa-lend-pool" CMA
> > driver to manage unmapping and remapping on lend/reclaim transitions:
> >=20
> > 1. memblock:
> >   - Introduce MEMBLOCK_PTEMAP to force PTE mappings only for a specific=
 region.
> >=20
> > 2. set_memory infrastructure:
> >   - Introduce can_set_direct_map_range() to check if a specific address
> >     range is mapped with last-level entries and can be modified safely.
> >   - Introduce __set_direct_map_*() variants that bypass redundant checks
> >     when the caller has already validated the range.
> >=20
> > 3. "arm,ffa-lend-pool" driver
> >   - Introduce the "arm,ffa-lend-pool" CMA reserved-memory driver, which
> >     unmaps pages prior to lending (ffa_prepare_lend()) and restores them
> >     when reclaimed (ffa_lend_reclaimed()).
> >=20
> > 4. Optee support
> >   - Hook OP-TEE dynamic protected memory pools to "arm,ffa-lend-pool" f=
or
> >     both SMC (via DT memory-region phandle) and FF-A (via
> >     ffa_lend_pool_attach()) transports.
>=20
>=20
> Thanks for your proposal in trying to solve this hard problem of
> unmapping pages from kernel linear map. I remember discussing this
> problem last year at LPC too.
>=20
> Have you had a chance to look at a more generic MM proposal around this
> issue here [1]?
>=20
> One of the major concern for me with your proposal is tying the
> protected memory allocation to fixed sized platform specific pool size
> based on DT. Then the cost of granular mappings/unmapping if the
> platforms choose to enlarge these pools.
>=20
> As you maybe aware one of the major use-cases here for protected DMAbufs
> is the secure media pipeline use-case which is memory intensive
> workload. IMO, the solution proposed at [1] seems to address it although
> people have flagged rough edges there but should be addressable.
>=20
> Can you try a port of [1] for arm64 since the author did all the work
> with x86 as reference?
>=20
> [1] https://lore.kernel.org/all/20260726-page_alloc-unmapped-v3-0-6f5729a=
a9832@google.com/

There's a lot to unpack and I'm not sure I fully understand all of it,
but from reading through that series it seems like the primary use-case
is to allow things like alloc_pages() to unmap pages from the kernel's
linear map. However what Vincent is trying to solve (and there's some
overlap with the VPR work on Tegra) is how to remove pages from the
linear map that are part of a fixed carveout region.

I suspect there's some overlap, and we might be able to reuse things
like the folio_{zap,restore}_direct_map(), but given that we already
have a set of struct page objects, the two approaches seem to be fairly
orthogonal at a higher level.

Thierry

--d2bniudpfuafwp74
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqyXwEACgkQ3SOs138+
s6Fsgw//dlQUJrbDWiXuqxe3GRzKuh4gFS8vuMFfMkbYyeXhcsFi2RHH2NVZ4O/0
7E51l7U9VQKmCvcjTzd4+9m47q3h2TskmNQsMA1vWWQDFKOWrbDw2yL11vSqZ90D
hcquJSGds+Gu8eaJFKONeIxfUmuGawtaqTl1JtehYNaN6wur68zTbhS/dkDD4OrZ
9MCyUlhaLPSfadqpBQSLucmYM5GhSQikGcqIJMIYkP7kd3HgWfr0XlqW1+tN3PjO
MzP9sBX/LMW6HrsGa1CJNMRSaEhldJ9JFoNaIFyIBiN0+L7UBUyFlByNoFuatUqn
NAQsB90d2EuSmo5zz5zmeuoNGhc4k0jO6i8YS3zVmeL/eIWg1ZbifIm7FTaNB8iX
DMs9aq3ovYnbfGOpOOni1Z5BWz6LD4+2WG7bnOVXhKIWE6wOLG8cW/nTEt6hZ/xA
6wY+TFrZMoIRCOREqxTbz+TImFkTuF8OS4ZIo812FNBgUcGQu9nfbTzrebUs9pGY
bjieIqRLmuyXIXHDayd1NcnmuIxN1OgwzIJO5CQvG6yCJ1sk6DVrgODmKed2Nxoh
vRm9IRG6yWGxpf3DeQmUvHd4ZRogSpRfQ3713PrxjnIj9WUO7fs8yGq6F5xHrmMb
FlXPgJng4yDFZ0eb9bKte5N6yvKoTI8e4jsUD1NL7y/YNh6lWy4=
=42dx
-----END PGP SIGNATURE-----

--d2bniudpfuafwp74--


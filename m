Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747A6C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DC46B0093; Tue,  8 Sep 2026 05:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835B06B0096; Tue,  8 Sep 2026 05:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773906B0098; Tue,  8 Sep 2026 05:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59D1A6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:19:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED1EB1C23E8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:19:02 +0000 (UTC)
X-FDA: 85190045724.13.BE5B568
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C4001C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:19:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jC952bHmiBBRZiJqd17i/7x1m+YVL1dngpkL95OZce4=;
	b=t2TqT4pU3jsjxebk8Fzh85dUKii3UQgWENKOwbzMINef7jViPOsiP6Zc0FOc3bXU8pFezJ
	RNsYour6HDzPvvd6IKdJulfq5MZ08w4GhZirRCTDHmDTSjtQ2SjsJuI1L4Yg/DUOj5TuEX
	OBrmpRGScVPSg2NLMFw6uO9GW4bVF+o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859141;
	b=fpEpYkwqTHD60bSoiJtIcQ/mVUPJZrLD9/2aA22L76fvEYwjlROkm3bkhEZl00vC0jiuZ6
	F4zNyvO51oPngE0RlvP4lpZAUZXHDfeBLnqqCwn84F0tukUNpUKiaJSr6ehTKVvgMQ987l
	tMNYP/Rrt1RuY7URzOaO4vGdqMd1OzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9982D43A93;
	Tue,  8 Sep 2026 09:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB201F00A3D;
	Tue,  8 Sep 2026 09:18:59 +0000 (UTC)
Date: Tue, 8 Sep 2026 11:18:53 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, sudeep.holla@kernel.org, 
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org, 
	ardb@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
Message-ID: <ap_RRSM7RBONvHaR@orome>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-2-vdonnefort@google.com>
 <ap2_926WXr7uAYVX@kernel.org>
 <ap6I1FN_2ylRzFXH@google.com>
 <ap-74AkHSGXbFCF_@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ajtkrsfbue5mdrla"
Content-Disposition: inline
In-Reply-To: <ap-74AkHSGXbFCF_@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hbf118r8y3dbcxmgu7aif64ydfown5a3
X-Rspamd-Queue-Id: 6C4001C0003
X-HE-Tag: 1788859141-849866
X-HE-Meta: U2FsdGVkX191PpFvbMaRW5scQLiHOWlq9+1rLXRoL4ybgurjCjwydDYKxEDQUCYVUCh0tZxWQ6goSwwAEdcOC4mcgaSoNjoSXdVmY0NS1ei/84NQuvzAH//oimgVbTDmWBoefPvCmGZ6ysYZ57VWXTwJgtSW4jZOlPpQbDBNaN2IsKSYubZAjgxB7oU3oA3Nr+mQ2ptHjtaJLR4PST3lbJkNAfSwHte91xpA+eOij18Ey/uAhPr7DylY6mUZCq+nBqfvdfu4d3QCEv+7JemwXwFIcs0wxsZwnoRpySpCMBbrVR1xDbIQfh06ZZzEaOLNBN3iu912k3MgPlEH3rFxPECu3ou4TFfEDwWt0Jd64UMFfBaWCnoW32L4VtuQsWBeiWmtGWB9rWIK60v3dyFwBzzq0w4kXvkPUo9ocN7jLKyHbfdIMQgYOQP51ZzjVZail/q704G09Wt9hQtn1M9MxO7DGnocYv7f0Nk+Ejxxbf70DbZYa0NuSZa4vN/jeGat6BN7v0bAd3UxoPl/lJnA3kwuWzOFZrAc5uQLUt++cjf68BDy0qP6Ps2c+5IsxyIuZvOa005dn5/BUeHQXojIvdAQbEBzeu0DaqDcLfo97Q8mLeYF02GeslXch9XzwUdORGHshRvWt9FnYhyQep2VZBLngZi7dZ4DrxNlCqYTKqVflKdJc1KxQx57zjkfSoHj0j/2UnJze4d8x39E+HF5akoQHj70aVAX8U7mJMfliqohZ+oT16TQMLjB+vjefsB5rZ6oyyBJ61838Ud8UXibOlhprkHE2Uvhm5L4ENeWWfrF+OtmrodN671RbIzH661OscZceh+CEojUrmhQ/gLL6I+D2UPiDFYFZTqfJ8Zo0CH7UjjTFxbbIJ5wcZx/PUsKhb1pSo3PeesMQEyPpCIm5AH3Mic5F5COo3NakWoXVcyu73BOVUY6p1FFKb/m5+YfMEf2n42EN0WC1p0+9l8
 ajS0N1M9
 +BdTZn7j/zDSnpbhS1YE0h0AZ6N/TtUoqUt8Y07TuD9ECLO1c2RFIWYkvEsEMNf45xzQTEcFwJTlDpEZ+bkpQuylHI7CBEinXK+RJOSQ2Zp5RX8cIuyiDNJIE1RrvbLUfs58/fv3rmEFB16GDT8IsH7ZRa63TAwFibHi+o6ja1VBMQqtePuH1NLTm0oi/lq24j+mlbvaGq/lmo7TRor9ZWdWHHWgdv4dRa0TQadJolDpYXEXan7HbMoIkeNHtFF0pnPo7KqnmQHDN/fSa1E9uIv7frLbch31YnwvqNs+yanJaWQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ajtkrsfbue5mdrla
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
MIME-Version: 1.0

On Tue, Sep 08, 2026 at 10:40:16AM +0300, Mike Rapoport wrote:
> On Mon, Sep 07, 2026 at 10:50:12AM +0100, Vincent Donnefort wrote:
> > On Sun, Sep 06, 2026 at 10:33:11PM +0300, Mike Rapoport wrote:
> > > On Wed, Sep 02, 2026 at 11:47:03AM +0100, Vincent Donnefort wrote:
> > > > Keeping last-level mappings is interesting on some architectures as=
 it
> > > > allows mapping/unmapping pages from the kernel direct map without t=
he
> > > > risk of splitting blocks which, under the break-before-make rule, m=
ay
> > > > trigger page-faults the kernel can't handle.
> > > >=20
> > > > However, mapping the entire direct map at PTE-level is costly. So
> > > > instead, create a new memblock flag MEMBLOCK_LLMAP to enable the sy=
stem
> > >=20
> > > I believe MEMBLOCK_PTE_MAP sounds more descriptive.
> >=20
> > The idea was to have something close from NOMAP, to emphasis it is one =
or the
> > other. But PTE_MAP sounds good too.
>=20
> Could be PTEMAP if you prefer.
> My point was that unlike PTE, "LL" is not perceived as last-level, it
> should be looked up.

We were discussing the concept of enabling entire block mappings to be
removed at once from the linear map, so at that point "PTE"MAP may no
longer be accurate.

I imagine that in some scenarios we might be able to go to PUD mappings
for something like VPR (say systems with a fair amount of system memory
and we want to carve out 4 GiB for VPR, split into four 1 GiB chunks).

Thierry

--ajtkrsfbue5mdrla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqf0voACgkQ3SOs138+
s6EFrw//chVhQxMWtCxc+JK5ON8AveSiC1Dhl62Q8IhDi1Pr5AWMxC7K8li30qSy
0r+vt3im7cyLAkLE4+kAZXtHcCV1288tZZErEnuotKkDkGDaDExBqr5yHlPseVq0
2ekvvxz7mSRh5Wfxn5Tq+MYQcwUYACknVRhGjuplsa05oSZA7GWbViEHFVP25/Pq
14BkCYqXXj/NfSceq84ukKSePfpEG9Jrmnl7Ey73eyGHNeRvziLQC7qd9MuHwiqp
Jn9Geb830b3ufqnZK23k5BuEp/+lAGTkflZGTlEM5A6yTIEnvfVtpimFwGtHret9
L0HZ/xg087+Wj7Kdgu/VjdftAzj81qqnKT8dpnGWH4SwsTLtcRDqxpNZatKlVJsF
NJG1Q8yBEtB+KIIiSK/00K2im6bSroJoGbTljdLQVi/hjBkQuDHtugvyyycXYc5y
cLPWS6i+0eG+IWvM+wGH7zWT9kvJeyYWh8jH4qk/J0sTkVlz5IY25AOerpGGdx4S
slR0PSPzLmGm/uHHm6PpuJK8vjqKJkGmsLiXQ5XkrUgmOG8EkWHG9Uzx358zDsQg
AYe3yJ0IiuCS2fketV+KzHy7VqFU3tC9kgkyrIO3PJSJLSVSeTVFNJ3WTUJTEBBb
ztr3XvA0Jm7feoWXZzfW9fwBYnq+5ey+M+KDQ6qsCZGpgY7FCeo=
=5bgM
-----END PGP SIGNATURE-----

--ajtkrsfbue5mdrla--


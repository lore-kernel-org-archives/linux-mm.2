Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8713C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DAA6B0099; Tue,  8 Sep 2026 05:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EA86B009D; Tue,  8 Sep 2026 05:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45986B009F; Tue,  8 Sep 2026 05:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72C0D6B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:08:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D8971C23C1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:08:32 +0000 (UTC)
X-FDA: 85190019264.15.CA62FBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9DA5510000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:08:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRGJOVAl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnL+5+jjY/sqS7l0W4fKVbPZaIsWjtGfLtzgW1IG+uM=;
	b=KHZQuTFRq4bHDn6rlqprTRAwKoFeK7TFdfUWN51j5+7o6L5QXMo9bvEhlH/31BgDQgjGLm
	syzrdbPCZb1d5maVqFZguPwrI2w7/3Hgy0BmrNdDA3922fzN2zduybu1bz8a+HkAVGFRNW
	vk4pqOy/ZN1n8uhGcooqF0mIlGTT6OY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRGJOVAl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858510;
	b=3YwMIS8WLWzKkEaco1ePtzpranxwQUCTlCdAbjXnh/BPQc2nIzpJpnFQ4WDGMzd1GXGlf5
	nzsZ0qI+K63A7Gvjgr0Gr8fOe8GugdwiZRhl2tflpgpJVFKAh8Aq05aG0kRqT2D9WMgy3G
	l/M07EraEVHMdtzkHeG6WZqCVMs33Ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 724FD4040A;
	Tue,  8 Sep 2026 09:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA1B1F00A3A;
	Tue,  8 Sep 2026 09:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858509;
	bh=YnL+5+jjY/sqS7l0W4fKVbPZaIsWjtGfLtzgW1IG+uM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JRGJOVAlCz0spfZIa/FLR4lJ0fF7DswkvbGxUsbqrHQ+L9iB9cNZPNPtk7G1HFwKr
	 qOFCY+58wwnPlxiXFSJ8i6NVInfJP7/OLtLOC1t5d5tnQVjVQ27qDM6KWvzCGAZtNJ
	 wy0PnwgtZxyDnGaMQ5mxO/8xZg5T0gnlhcB7msXzSmyJ9M0br5AkEKS8wUkEcgy088
	 QQdC9QqZv1kQphTtxfCosDJPMiFKKvC2bv4JpvFROc5Byn41q0XvO9HZN62QR74ynj
	 MGkwgnlgTXHI06uoJPk2CS49Typhka8ShzwrDwGxg92WRB0XarGVJkSS8wTxoX8wmB
	 H6KlRUDkdO+7A==
Date: Tue, 8 Sep 2026 11:08:26 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Will Deacon <will@kernel.org>, Rob Herring <robh@kernel.org>, 
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
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
	Saravana Kannan <saravanak@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <ap_QJG8EevX98SXa@orome>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <apquUWgrD9C2jWQ0@willie-the-truck>
 <ap_HzwVp-6aOKEbJ@orome>
 <ap_OFQepcu26g88u@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2wjx7nhywlavorzj"
Content-Disposition: inline
In-Reply-To: <ap_OFQepcu26g88u@google.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6tdmte9rqffhgj7dmq5ajr3hy3ek1b6u
X-Rspamd-Queue-Id: 9DA5510000B
X-HE-Tag: 1788858510-140840
X-HE-Meta: U2FsdGVkX18mDARTZmi9nibRX2f6tr9p/fm7zK7w+8pt3MwG8l99j4jVZn2GgAtxxI+jJkfBA5C+TMjbgiKIlmkSsC7DGTqJmghiReYr/VJh6W23B47VCTHt6hH6we7pffocy+xhg/Egv1mThcyaA9uLZHSP+04mmAFgG6/Kda/PDUUARjFTe+x1hoZAni5r7oDSVfAAI5ShXDflqMk0i30z8rTbzD7Ci4iGz5QU9I5E+pKrz5RHoZhlIIbHr7SYVHIfBUyZpw6Q8snzors1pkrViqiuIo2L3S5tE+AqBWqDwxm4gmYVi/bNHziL98NpHXYRDgx9bzq9omcUVwZr8MfmLXW7qSKjG9SPMQ5m6VGDxYYcuFCtD2HK1+HU2K0KXPThJJZAvlIBQPWIux0xKjJ1oRxJLjxYwZCOLtZYvQqwwK9XaP6iEONKjn++wkk6Yq13T+8epckR0b7tF1P5I+Zm0J/8oe7AWSNJ+WDKzUvO0x5d4HVcyJCgaFFMTYaQ02QzhEjUThFxTH+F/c7PSqpsteBMJLAFf08wtJEii44XS4lDaRt34qQeL/EAGk4RKHYOGge73jbRp8HHlkjoMgASdXr066Jh5WOTp3MKEhjOMfaKRL+ET1/cfR+NH7PNAdU+OtibgTCBxCB1zVAfLR84O3NhJlneCGYHfpdUhF1RFG7h4Aaq5ZjPPVFDOIHGsIFwtoAzUuwKDNkmOCP15oboV9MXmFVYE4WBEPocG/e8EMBQ00V1YhYTwj/axqgUzbF6hsxJMuEJI+oL1RiTeUhT6nz0aLtftBPSkYqtnd5Q7oeaf9sj0DfNNl4Y+ZQB5OJTKV1ZkHrcPjLITrKES+CwNABzqjjogb4aWVb1dJhzpstCd7tC+gRT7sR+xqQKikBSKP1cIGnhcrnUMOakoKGLEAXZdNObAAVISkd41VbR5Ad+2KjrWZqRETb72p/mFm7DtxzBZsRQZvdcAq/
 SgmetMuH
 T0Q2kHDt+FvQKn+0bJbIhI7NVZ7jw0JMcVD5QcsSD6YuYy4OPPVKkfBAeoR4TSMJqbLMbFfBUktJty4sgcHlhAKFhh+oDnf1C8u+92PHhkXo0dDm7EVsPAFT4kJm7+uv+y1PuY/t+XX/pRUTf4VXKpu9FdsCKoqkbIDWEALszSKIDTPCM0/1r5ap2cJ64gc/SSHivVVFjFYybDd+TAD55CX9HOtUfZUtztT9DE1q81oDLifw1gKrVsUPzjXWr5XUvmOhZiR8WXHGbVJHhouk7mKBg5a7ha7X5SnHo4ymcSVfk7yNHx8gbrkVJ1lzLusot7Yp0NY+ILWf1ACW4kbUeTL2wATpJ0ymPliqbJUTmhoX6CgPxsZPASrHgvfkaIoA6pAsleoUDCa4HP3bCh8rJaJwO196RxtA7OpXF3RoNcYm/b6g8eADXBRqQ3C7dDdz3p1PGGt44zyiYJ6E/IDFJU3zBm/hnfaEnlYYK61EqlHWh2TGGohffmP0o8D7ze4cq5I3W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2wjx7nhywlavorzj
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Tue, Sep 08, 2026 at 09:57:57AM +0100, Vincent Donnefort wrote:
> On Tue, Sep 08, 2026 at 10:39:17AM +0200, Thierry Reding wrote:
> > On Fri, Sep 04, 2026 at 12:41:05PM +0100, Will Deacon wrote:
> > > Hi Thierry,
> > >=20
> > > On Fri, Sep 04, 2026 at 12:44:51PM +0200, Thierry Reding wrote:
> > > > This series adds support for the video protection region (VPR) used=
 on
> > > > Tegra SoC devices. It's a special region of memory that is protected
> > > > from accesses by the CPU and used to store DRM protected content (b=
oth
> > > > decrypted stream data as well as decoded video frames).
> > > >=20
> > > > Patches 1 through 3 add DT binding documentation for the VPR and ad=
d the
> > > > VPR to the list of memory-region items for display, host1x and NVDE=
C.
> > > >=20
> > > > The set_direct_map_*_noflush() functions that will be used later in=
 this
> > > > series are exported in patch 4 so that the drivers that use them ca=
n be
> > > > built as a module.
> > > >=20
> > > > Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_regio=
n()
> > > > but works on sizes that are not a power of two.
> > > >=20
> > > > The of_node_to_nid() function is exported in patch 6 because it is =
used
> > > > in a later patch adding a driver that can be built as a module.
> > > >=20
> > > > Patch 7 introduces new APIs needed by the Tegra VPR implementation =
that
> > > > allow memory to be allocated at a fixed offset within a CMA area. T=
egra
> > > > VPR needs this in order to implement its own allocator on top of CM=
A to
> > > > meet the strict hardware requirements. This replaces the dynamic CMA
> > > > area creation patch from earlier versions.
> > >=20
> > > Did you get a chance to see how this could work with Vincent's series:
> > >=20
> > > https://lore.kernel.org/r/20260902104712.2399797-1-vdonnefort@google.=
com
> > >=20
> > > ? I think that should remove your reliance on can_set_direct_map() and
> > > mean that you can retain block mappings for most of the linear mappin=
g.
> >=20
> > I'm not sure if it would help all that much. Yes, if we mark the VPR
> > region as LLMAP (or PTE_MAP, whichever it ends up being), it should make
> > the checks for can_set_direct_map() redundant. However, from what I can
> > tell, Vincent's series still forces page-granularity on these regions,
> > so it won't retain block mappings at all for them.
> >=20
> > The block mappings can be retained for the non-VPR memory, so that's
> > nice. It also reduces the amount of external prerequisites, but I had
> > kind of hoped that we could go one step further and keep block mappings
> > even for the VPR memory if the region happened to be a multiple of the
> > block size.
> >=20
> > The recent addition of page count to the set_direct_map_*() functions
> > helps reduce the amount of checks that need to be run, so maybe there's
> > not too much to be gained from removing whole block mappings at once
> > from the linear map.
> >=20
> > Thierry
>=20
> I should be able to add PMD_SIZE mapping support to the series. That was
> actually my original idea as we can easily force the CMA allocation granu=
le to
> be PMD_SIZE too.
>=20
> I didn't implement it as I thought there were not much interest in the en=
d (and
> also as contiguous.c is always using PAGE_SIZE granularity).
>=20
> But now as I have implemented a specific pool (and do not use contiguous.=
c as
> originally planned), if you believe it is important for the VPR driver, l=
et me
> see if I can extend the support in a V2.

I don't think it needs to be part of a v2 and can be a follow-up. It
should be transparent from an API point of view and merely be an
optimisation for that specific case.

Eventually it'd be nice to have, though it might also be worth checking
what the actually gains are.

Thierry

--2wjx7nhywlavorzj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqf0IoACgkQ3SOs138+
s6FzZg/8CRaK7s6wzryx6ugtk3NLfiNV3oIjP6eXCrqWs4+dDSJ+em9X2MZpglTt
8d7OMtEQVRUCKHW9Tf2fZKzqOYsmHzUi6kmnYAB1HB6kPDVl/0PyGbJsashsANGr
WwElHEpCNRzyRLWSlx0Rtidf5pKqE0t2ukNMrye98cCHylazGo/2dNq5eUZiY0BG
+K3Qjj9AWuwmDlL9nqXeABM9sChrIGXf9wDxQWazhynwKGybLvgGW0AGjvsvnj+f
QUygrWY8D+op3RSBe4mDbt04WTak3A69NyLRc1OJ1GBqXk9OUO2Zj45Bf0sDBiZJ
LyEOE7tm89kbZ8Pab12MkHhMcJDhqtAh110WyvHQTiiJc/CDuEHWH0u6ZffApO2h
5W6gRmwNWU47ZpaOW6zVimH17m/EPfokHg1RWeyBZnsjkkdNyUp996slMCdTQe2X
Y37UdVaypUvzdNH7Xl1yYwsR+XIHfD69y6PZCeXZ0xVKEAgLTIyLDAXgfGZNdd/c
ZgyweB3MFKGMZJxgssr0Yg5CQUHC81SbGPoQv/AadQ7P395kJ6B5bdbyMocaOjuO
11VeRD6K//LwRhYuMMpauRgJAqSwVNxXxC1t9xZoPPAqxTb57s5IC7X5B6akq+Dh
env+3Gvg9+blLrpxgLpmJQlOOxKkfrM/yrV8JI1mly57R+g1d0g=
=HSA0
-----END PGP SIGNATURE-----

--2wjx7nhywlavorzj--


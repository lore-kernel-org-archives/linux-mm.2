Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84340C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF446B007B; Thu,  6 Aug 2026 12:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48F16B0088; Thu,  6 Aug 2026 12:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10D96B008A; Thu,  6 Aug 2026 12:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9805C6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:09:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 206FC8014F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:09:14 +0000 (UTC)
X-FDA: 85071329028.12.85B7170
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 671B7A000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:09:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKNEIVai;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786032552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1mmhRLKDxaELj7616F3jLYF/axUtWF1l/JEzzjmppo=;
	b=IyKyI1rCXIW6vMkUeGn3m6N2Kdf+2px/juirCPAXhE+96IXLAmpGGSQRe2Z04/aYpKwqh/
	kwsfJo2kakfQ+ErFpdtliN18U7xN6YHAOW7OiQJ8rSaRIateZFAamT2ARObc+DMpg3IKAH
	ql/WSKrikBrkFFsBTf32ANNJQhES2BQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786032552;
	b=v9QaUMyRDGxZ6Dc66BMJmq2ep36+fjvD/Qn3W1lP11pR/8PzmvN58OceK0NSOia+8lrZj2
	wL99ovFjXZauHLxbJJ3ib8ffFmZDUDRiAhL9OGOREifuYXWDh1TMX3OEkhv7HS9UgAo+a6
	dc8L+AgViOOo8AcBkP0hhX21kgT97V8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKNEIVai;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40C4C43911;
	Thu,  6 Aug 2026 16:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4651F00A3E;
	Thu,  6 Aug 2026 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786032551;
	bh=J1mmhRLKDxaELj7616F3jLYF/axUtWF1l/JEzzjmppo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kKNEIVaiVH4wrn5oHK5ajPxUnFHB9+4/A/1LvM/uKTkDc0Tv9t57ZG0ITr9wXU8Xp
	 dM7Cy6hGgHbZ/yeYTfWQ71Y57HgqRdmv1eKN2HCcuSEE4ilC3CtyGNaMO6veI78U67
	 YcMqItiqFW5t/eUfTLQayfOrEOELuT08s9jUqHMsWIlKuGRS7h4T2GXPWrf4X6w2Zv
	 tNNgofe3iP7rxX22Z7nlivDoSEEfrD+/jWedR6As/aEKkVkXWpqV8mSDDYNCbarkZ1
	 SVWiBIPcCxOreaWD7DyyAbxr2eCgQZMraKPZN7mkuyWcqW1KUCi9T1+4s4zx6S89Zo
	 2vOjrgZWIe6og==
Date: Thu, 6 Aug 2026 18:09:08 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
Message-ID: <anSuYvj1JU5K8xUO@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
 <3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
 <e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
 <83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com>
 <ak_E4UxfnFJywJa7@orome>
 <1eec88e6-1ea8-4525-bb17-e41444d715dc@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="awe2ln3pvo2iqnm5"
Content-Disposition: inline
In-Reply-To: <1eec88e6-1ea8-4525-bb17-e41444d715dc@samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 671B7A000F
X-Stat-Signature: naqw94cc73nou85qn8h1hs7fsxqaicnx
X-HE-Tag: 1786032552-783952
X-HE-Meta: U2FsdGVkX19LCzB7JlJG5QCLpHwRsXCd8x8fjCUm+hXhaQR5rj0eMfuIXcSuBPzPY39sq+ASMg/I+rWkXfrqvLoxz7H3bzQneiFW3hhZAziwkCRdhfqg2h+x0aw+EvdZ0oL0gVipyRcnyxM8B0f4GRyCW76JSoatfi7nif66lOagfzdmiG0QvbzQulasx8Z+mgTIoTAJ3G8mvN7DRbP/m7IxPE6lu+/KB66t1HJ4netZeWty5QKWH9lsKklO8HR5J4SVd5IpnmPo2rVjVDTwu6fc8CbXNhp3LM4fUv3cmUUv3BiH9GnDjrVUdNuGc+Bi3fidlC8oA0UU2I27f+KWrHa9ggpCxf6sRxSE6namdDd4MKTn6AjHDLShOoCgKtJ5NDuLhLwitJYSaO9BAyF+8CisrXiaQp4q3G/H2f7yVVflAGiWGOqJFXYGDMb1ZIfRAE5J6d54beI56HBgUBLG13ztaWVp3VDSn5CzkAZnUVnmzXvSYh7mxCUoTPDMM0DLkJD7S+v9bYNe8lgm4COfMY7cDW4RUDLMfjDpQt3TRM+uo4cINu3D8q/4cXuCzM4e9ZYUwgHOcgrHBrr+jWo2ytf/5ZmgfK4f24TK5YIXS8TdV0nlwZYnCtDwoOaWq9I8+XMQijinD4hh+6ylJG4zHfxiVwW7k/C/ZXBZmyPcdNKcVxv3j3gg8d+n3ehCGg0P1t7ILrGQWa8CVEIeLag4cAxwGdIiLtpNDp2e8ZokU5fgvggP69aKFnSlMAjg05fpAwNs/hoEpXrGCQJKdXG8hb7oU/gczhcDJ/6EQ3DQe6qUTvHQI42o8uP66qBjFKu3nQZy3blS/qS8zxTL/NPRxD/fohdesXOTlw32PMxXG8XfVRYhW+ZDEtgzLX7QCa3ojApQDg6p0xmYrxcnGJJhFSPEbTP81hZ3SdnMBQk4/d6vv8gvFMhQMvlRwvqfep23I+lI64BoKDsqteWRXzA
 nglTgasd
 ucpjB9E6MXdPa3n+xRd+lRXtKMPNbLJxnuL9FvliCoABuBEAW6x2KYLXu94ypQXwpNBtlLiHfoczUGSyZ2TiSODOBuI+mEQ2tJW9g5/jmWILMn52tEEKt6v50q1tRmUhyL+yYeoTZhWJYbP1HM61vr3lo4axFdn7x9Hx39zzWRpvQaDSIfjFPiE4AUR3ISbCzn9CcQc69bsUfZqUUpDPrsqA/Juo1XgR7zBVJQkuMAs9EmFFFa14E5PQbujdm/fSC3qoRP0fvQwKLfmdfsne8QWFI+VpB7zkLqHNalGZ/Ndgx0ZTEbRrTn4GjyH4OCAW+bXQ7hrWbvbv+3U6thvkyWxx8CCkSS1HWCMBTcoZsAUgPzdE1oiv+tyGd7gN8TR8M05LJf+xlDljESz0166y49HNncZpF4aTPfg47UCEuMEs0xMBU9TVV40YtttV4laUJBHImUVxBS93tZ7Ppl/eChThmf+zabsvhCBPOnd9Gm79Qdoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--awe2ln3pvo2iqnm5
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Thu, Jul 16, 2026 at 12:43:56PM +0200, Marek Szyprowski wrote:
> On 09.07.2026 17:59, Thierry Reding wrote:
> > On Thu, Jul 09, 2026 at 07:56:45AM +0200, Marek Szyprowski wrote:
> >> On 08.07.2026 10:35, David Hildenbrand (Arm) wrote:
> >>> On 7/7/26 12:02, Marek Szyprowski wrote:
> >>>> On 01.07.2026 18:08, Thierry Reding wrote:
> >>>>> From: Thierry Reding <treding@nvidia.com>
> >>>>>
> >>>>> There is no technical reason why there should be a limited number o=
f CMA
> >>>>> regions, so extract some code into helpers and use them to create e=
xtra
> >>>>> functions (cma_create() and cma_free()) that allow creating and fre=
eing,
> >>>>> respectively, CMA regions dynamically at runtime.
> >>>> Well, the technical reason for not creating cma regions dynamically =
at
> >>>> runtime is that on some architectures (like 32bit ARM) the early fix=
up
> >>>> for the region is needed to make it functional for DMA.
> >>> Can you point me at the code that does that? Thanks!
> >> Check dma_contiguous_early_fixup() and dma_contiguous_remap() in=C2=A0
> >> arch/arm/mm/dma-mapping.c. Those functions ensures that the CPU mappin=
gs for
> >> the CMA reserved region in linear map are remapped with 4k pages inste=
ad
> >> of the 1M sections, so later, it will be=C2=A0possible to alter the ma=
ppings and
> >> change them to coherent when needed (altering 1M sections is not possi=
ble,
> >> because each process has it's own level-1 array even for the kernel li=
near
> >> mapping).
> >>
> >>
> >>
> >> However, in the use case in this patchset the reserved region is only =
shared
> >> with buddy allocator by using the CMA infrastructure, not registered t=
o the
> >> regular DMA-mapping API, so it would work fine. I'm not convinced that=
 this
> >> is the right API to use for this though.
> > Are you saying you're not convinced that CMA is the right API to use for
> > this? Or something else?
> I read this again and indeed CMA seems to be right solution. I only wonder
> why do You want to create the CMA areas dynamically? Imho it would work=
=C2=A0if
> You just create large enough CMA area on boot, what would automatically
> share the memory with buddy allocator and then allocate dynamic VPR regio=
ns
> with cma_alloc(), potentially unmapping or marking the allocated region as
> reserved in linear kernel mapping to avoid any potential speculative acce=
ss
> to the protected memory.

Hi Marek,

sorry for missing your reply earlier.

The reason why we want to create the CMA areas dynamically is because we
want to split the secure memory into multiple areas. And the size and
number of these areas may need to vary, so I didn't want to have to rely
on rebuilding kernels with different numbers of maximum CMA areas
depending on the chunk size that we choose.

The reason why we need to split up the protected memory into multiple
CMA areas is that allocation patterns can create holes within a CMA
area. For the VPR memory, however, we must ensure that there aren't any
holes within the protected region because it is specified using a single
base address and a size. So there is one contiguous region that can be
marked protected.

If we were to use a single CMA area, we could get holes within an area
that is marked protected and once the pages are returned to the buddy
allocator with cma_release(), something else could be attempting to
access it and cause an error because it is still protected.

The only way to make sure we get a single, resizable and contiguous
region is by using multiple CMA areas and allocating the entire area
once our allocations need to expand into that new area. So we're not in
fact using much of the CMA infrastructure and actually need to duplicate
some of it. We primarily need it for the page migration and reclaim
functionality.

> In both cases You will probably won't need the DMA-mapping API on top of
> it, although it might be even possible to partially use with by
> registering custom dma_ops for the devices using the protected region
> (assuming that it would support only DMA_ATTR_NO_KERNEL_MAPPING
> allocations).

Yeah, I don't think we want the DMA API on top at all. The allocator has
special needs, like clustered allocations to minimize fragmentation and
keeping as few chunks activated as possible. We also want to avoid
resize operations because they can be quite heavy depending on system
load.

Thierry

--awe2ln3pvo2iqnm5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmp0saEACgkQ3SOs138+
s6HmUQ//RyPTgx2QiCZkziDzWhQ8YjQ9J8KlwiQnyLspOz+Na5x6bslbOl/AuuBd
DCTC8+y/ax94aG30aB0SctUZLtHriGHwevA3J9hm/CfR1K72DsjLSDnkqujE5h7B
QxLJyl9wyqStgOfJEl6PwA8H9VbDkdJNHJlmpFzeki7a5QHQR28b+FyoWOZGGutC
YKiDlqpqQk1rs9d8WQ4M5w6JiRmImAI9YcoFP36b36oPf6/DziGOYjqCO6k9o1GI
pKj8EV6as2MTKoCdsuwHiQo/f2gQfyquJF+yK6m62NZy6wyr1ceed6jmCoIcuuh6
NKDs1AUWYdLhOVod22LHwn8GCjaDRkYHuUNgRtVrz5BgUuVUW/EmVieF/7BeRpna
HZ+uWPa09LwQq0ma8cRTNEQykq4zhVKxshPlVGeFuRJqIQ7C3ba/4UCWEDtT4Dlj
udGkgC059nR72DiCjPnQ40LV5naHw+dIkTt7uS2rh/xRih0ZW5bTc1ex3KvVq2H+
wtjVSehARwHbIzU3ijuk3iNDaGRYZS99YYB5NjULlXGFeldz0M4qj8L/Gu684Kt0
c0DFGObvF6isiTZgfuIwCNEEURIKdOut/DpqvFXcAmaAYvwvko7EPo4xwigfSapd
63yY0m3zfV1lefYdShI86wkQ8t4KSbU6Vhoh/A0AUNc1mcNqir8=
=PD/g
-----END PGP SIGNATURE-----

--awe2ln3pvo2iqnm5--


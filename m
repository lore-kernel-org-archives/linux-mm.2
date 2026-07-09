Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E95DC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 19:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2444D6B0005; Thu,  9 Jul 2026 15:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4C96B0088; Thu,  9 Jul 2026 15:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BB06B008A; Thu,  9 Jul 2026 15:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DABF96B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:58:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 652138CEEF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:58:07 +0000 (UTC)
X-FDA: 84970299414.18.63FF18E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7EB810000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:58:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUZ0FPy6;
	spf=pass (imf14.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783627085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nASUEopdTVpbiOlaqA3bl70JASaPDBXc6RrPfU8TUhM=;
	b=VXh7Dx/AvPhvvXkEklznN/ZbUUgdjwbtlNDhTiNI0VP4ix01vorvaW8yOWclOZwL2KT4gx
	xhqhHYO7WWYjpsh3PuiEtp9OpkSad9KN5LZb2VJaJ03o3YmLPI5ots5oQn7i85cdmHr5EU
	u1cxI1xhepMxNpnLIiUxFS3S4M43BQE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUZ0FPy6;
	spf=pass (imf14.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783627085;
	b=NcR9mjpqnYXBjDl14OJKEcuB+htuOx0nlCeRqGRQny4wCJt5mnHOYcjQIGYs1WD4F4TNdV
	wdCob0Quhsa+J8ZKgMLHsmQ8AQyuZvVzlbzABvortaKTQtx+5QeyXQlrrFbkG8KXG+dT6J
	p3fyjULrA8jo595ExTVYj0hLkKl6F1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78EA143440;
	Thu,  9 Jul 2026 19:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69C51F000E9;
	Thu,  9 Jul 2026 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783627084;
	bh=nASUEopdTVpbiOlaqA3bl70JASaPDBXc6RrPfU8TUhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HUZ0FPy6tJ5k2FpZZk4TmtW8oNPYG0UCTaswg34FnSsVTMZ+nc6abBzQoGLAe7QpZ
	 4839oR2E7eU5H+0VQhcuYDxXFXmLbqe785v0OtfK8pZM64xT/vjBbY8gU6OQqxdQko
	 2bj2K0aisc+j7i5kyFSxJBzHYPyWTVbTuJKmXAkqp+WJvRZsZfqnl91bOFM7185CBN
	 pNNt3ie4Xo7ripQOTTqoaN5lwefEhmBf7ncJ41sgP4urIb+UmKalmTY+FHBAjFjAbH
	 sZHtyFtM9TSgQQsGPMBhSwsdDCYRoGd5HD7SutnqDROuHsn6T0qtpDhVLf9Zj3BAl/
	 ejFRs0GNI3+Yw==
Date: Thu, 9 Jul 2026 21:58:01 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Will Deacon <will@kernel.org>
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
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <ak_8Po3NxgAU7k0T@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
 <akzikTrmhMsvkNVY@willie-the-truck>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rvxsrpqt5djhs2ak"
Content-Disposition: inline
In-Reply-To: <akzikTrmhMsvkNVY@willie-the-truck>
X-Stat-Signature: asphjoxndffa1fexp4h3h3mzosbcdyrh
X-Rspamd-Queue-Id: B7EB810000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783627085-505641
X-HE-Meta: U2FsdGVkX19HJXdR12rewXKFLc5fDNHOtA6IVYD1w9AI0DKt+NDghiLkHMTD+1N9Lsrf6ErR5MsBK85lvVuYQzBQYkzm5Y1x9jW6s5dbGWkhFR62qLNaGhsbQWjPv1WU7OOm2Y6kxzJ7alRJwEguTDsX+mH8DkTpfuiwHBhBhRA/YL79YZt9HlvUjtGzp5YC+CS1UTjUWELi1p0zbRjGH1z8y5r52VBIYrzyP3VRy8T7IbnsYvFi72L0aooKOg7WBu8tTbRImBNsQNU08+O+Zx0JKo9mqsiyCOP8dLFAeYnb2fG76oj/IQVso5FkblY8IsnqIgVD+43y5OD8VyPAG5sJgDwRI3laOomIibMngL0TF7pn9NQdre0fXFWi4Iv7B58j2VjhiaM2aX2mexoMVuPrIQ5Ay5liT8IjrtLnLovb9CznmwRipULvB1nCBxFhu+5JjpDcv6ZDwttWJwsL3fZtIjmVUrFsD/5BHaBXRcp0do6Ry6CzQtUpYuQMBhWDFGmP0mEHD0P8ZF8ZcPjL9k6hDKr2wFHpcgSJC9lidvioDrVYWc8wWPU5QLv9hrynCTRQqJ2ca/aO/DuQWgluB5BJQhni7NCWPPNEh/TMOS1SuXfQ++06A7QLc7dpPaI3Re1Retqn++KgEgVayP4izriG5T19x1rk5XTgB/OfKsSBkMx0cMSy4yRn3a2IvW6S+Gi6TafnWyevPCz+dzyJd0RA+U7W1GUHQq67B8BK/CjZCxMA3CkOJNq6uOJAOO8VS6IYo73Q4wcYjM/3mnuoApUn0j7dCZhuG390txfhj/vGM0WvBD9YSE5UxsQ7AU8uRKwUNxgMT5/rWNiZNZYVqn7TM5IM3I3XhCgAAiWsc+uE4dl2SoZgxxQDTNjmoq3kDHsTdtYm8X7+m6T62oP1tDpFliWbkW+nUTONFtN2lFRg8jmNXQm52N+qulmXAEOA/aKrXhsWlQYgwGNJGfd
 ZI2a9+x9
 +hPo3i4fEtwHFNNxZ2bPGB3f+hUohtXSRfJE8w7u0nJXGBYtMA0Ob9tum4PpKAbj4wYFKPf8rnB40npb+xSmcvrxPP04sSc8mpY6MlZk0ozxgixTR4RSHp03FpK/RPUN2NserrLnCKQz4U3ZDOOPg7qTHrieQGzEFSHW8udF01XWnv75GsWJmE0X9E2zA6KP+PpoQAWiVSH9YPS1XXWgojwfDtilNWGYCDbHijpCQGrUogCXaC9UmX/j1a5ke61ACVnb7w/yDrbskmbs2GVHqz5x5eKzTNolLkRBEovEvoiUMfsY2P2mDev+eJyBCxJ/3TL/SU46o8+QqQMiwZCoUQ3Mh2OZ325am6JNI9zXtMO3g307CFO1tdqu1j+ly0oZfoFsfTWHC4jz4wkqCVdd5/r/LMdKv/VFbbg13Ay8vPLA/RtqH2OzUsOmAdv/b6c/troAEOLzmC1a4qaDZ3mrdzBOFuTT6ufuKgusWFxuByb4mOjbSgwC3HF+EVDTpORnV2EtPBErmHi2PX3iKK3d8dHDcZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rvxsrpqt5djhs2ak
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
MIME-Version: 1.0

On Tue, Jul 07, 2026 at 12:27:13PM +0100, Will Deacon wrote:
> On Mon, Jul 06, 2026 at 03:49:24PM +0200, Thierry Reding wrote:
> > On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> > > On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> > > > On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > > > > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > > > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > > > > > From: Chun Ng <chunn@nvidia.com>
> > > > > > >=20
> > > > > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protec=
tion bits
> > > > > > > on a kernel-linear-map range.
> > > > > >=20
> > > > > > That sounds like a really terrible idea. Why is this necessary =
and how
> > > > > > does it interact with things like load_unaligned_zeropad()?
> > > > >=20
> > > > > This is necessary because once the memory controller has walled o=
ff the
> > > > > new memory region the CPU must not access it under any circumstan=
ces or
> > > > > it'll cause the CPU to lock up (I think technically it'll hit an =
SError
> > > > > but in practice that just means it'll freeze, as far as I can tel=
l).
> > > > >=20
> > > > > Probably doesn't interact well at all with load_unaligned_zeropad=
().
> > > > >=20
> > > > > > I think you should unmap the memory from the linear map and mem=
remap()
> > > > > > it instead.
> > > > >=20
> > > > > Given that the memory can never be accessed by the CPU after the =
memory
> > > > > controller locks it down, I don't think we'll even need memremap(=
). The
> > > > > only thing we really need is the sg_table we hand out via the DMA=
 BUFs
> > > > > so that they can be used by device drivers to program their DMA e=
ngines
> > > > > internally.
> > > > >=20
> > > > > Looking through some of the architecture code around this, should=
n't we
> > > > > simply be using set_memory_encrypted() and set_memory_decrypted()=
 for
> > > > > this? While they might've been created for slightly other use-cas=
es,
> > > > > they seem to be doing exactly what we want (i.e. remove the page =
range
> > > > > from the linear mapping and flushing it, or restoring the valid b=
it and
> > > > > standard permissions, respectively).
> > > >=20
> > > > Ah... I guess we can't do it because we're not in a realm world and=
 so
> > > > the early checks in __set_memory_enc_dec() would return early and t=
urn
> > > > it into a no-op.
> > > >=20
> > > > How about if I extract a common helper and provide set_memory_p() a=
nd
> > > > set_memory_np() in terms of those. Those are available on x86 and
> > > > PowerPC as well, so fairly standard. I suppose at that point we're
> > > > closer to set_memory_valid().
> > >=20
> > > Why not just call set_direct_map_invalid_noflush() +
> > > flush_tlb_kernel_range() for each page? We already have APIs for this.
> >=20
> > Having a "standard" helper with a fixed and documented purposed seemed
> > like a preferable approach for this particular case. We also may want to
> > make the driver that uses this buildable as a module, in which case we'd
> > need to export these rather low-level APIs. And then there's also the
> > fact that we typically call this on a rather large region of memory
> > (usually something like 512 MiB), so doing it page-by-page is rather
> > suboptimal.
> >=20
> > > The big challenge I see with any linear map manipulation, however, is
> > > that it will rely on can_set_direct_map() which likely means you need=
 to
> > > give up some performance and/or security to make this work. Does memo=
ry
> > > become inaccesible dynamically at runtime? If not, the best bet would
> > > be to describe it as a carveout in the DT and mark it as "no-map" so
> > > we avoid mapping it in the first place.
> >=20
> > VPR exists in two modes: static and resizable. For static VPR we do
> > exactly that: describe it as carveout in DT with no-map and deal with it
> > accordingly in the driver. Resizable VPR is for device that have small
> > amounts of RAM. Content-protected video playback will in the worst case
> > consume around 1.8 GiB of RAM, so we want to be able to reuse for other
> > purposes when VPR is unused on those devices. In that case, the memory
> > is also described as a reserved-memory region in DT, but it is marked as
> > reusable so that it can be managed by CMA.
> >=20
> > The resize operation is fairly slow to begin with because we need to
> > stall the GPU and put it into reset before the operation, then take it
> > out of reset and resume it afterwards.
> >=20
> > What kind of performance impact do you expect?
>=20
> You'll need to measure it, but we've seen reports of double-digit
> percentage regressions in performance and power. As I said, the problem
> is that you need to split the linear map to 4k page at runtime to unmap
> the dynamic carveout, but that isn't something that can be done on most
> CPUs. Therefore you end up having to use page-granular mappings for the
> entire thing, similarly to how 'rodata_full' drives can_set_direct_map()
> and the perf/power hit affects everything.

The VPR has fairly large alignment restrictions (1 MiB) and we do unmap
in fairly large chunks (512 MiB currently, but we can change that if it
is helpful) because we really want to avoid resizing operations, so the
tradeoff is between frequency of resize vs. potential memory wasted.

Does that change anything with regards to performance?

Thierry

--rvxsrpqt5djhs2ak
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmpP/UkACgkQ3SOs138+
s6GFqBAAsfNpGtxzDc/1UKAc4Vjp9eilQE6L3ZzhQhn1d3Crc+ym9vGZzyfe4lTR
di2aYaWn+6XslOczfKwW58jo+D8/fP64sFF9UY3mR7U+MzuIGEF61RVgF0fFH4Vb
wo6H5bLYvA2J1VhXyIv08l/Oxb+GGHMa2gRVdTbFux+csAi4ahPJVT0oS9S0sJht
cmPEaDkjN8StPrx4IN3oTcj7g3LW3aDuShMtgqRrceSaIw2xvtb+rvWLvGJac/HH
kNrn5Vc+pAJJigN3NZqMgpjeD3gHZDZYaKUToPXJuIOlZILR0VzdDAHxD9U+lmyD
YVPGNnPi13QmxTk9KHR+Tm2aL7AxXx8TK0jIOUFuaySrgD16Oo9CTxOvsxewNGpg
lGDhuvag7BCxZqQzlxbhAuGtHZS+s6OWCXleWAsKpVs4Ga/FDaAvZYCHugxIur84
mexc1/5CBcjohTAfvTLpAZGUxDXslKopeYaBZGgRJXz+iwulrGeeDpEvDH1VNo1r
SkCIXoLOlq4bEKwejuGzuVzc47hLYGL+c09cCOwa73rhvVARke2v05fRowwN29Iv
1OVDKNQTsHbBZ8PNTsoaEApLvif8crc38kborIPtiuaGz4WDg7q90ogJoIhqEK2L
z8Lt64Ul985C2ht8PNWLbWeUKGNX54YFmnBCCP+lgBzDRu2sc4g=
=Axxn
-----END PGP SIGNATURE-----

--rvxsrpqt5djhs2ak--


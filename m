Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E39DC5DF88
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 10:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2B56B0095; Thu, 20 Aug 2026 06:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A35A6B009D; Thu, 20 Aug 2026 06:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3D16B009F; Thu, 20 Aug 2026 06:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7BEC6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:16:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3836E12073B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:16:57 +0000 (UTC)
X-FDA: 85121244474.06.71D974F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A1DDE40002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:16:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMhGYcxN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787221015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Prgge7OpuMZ/HlcX8eJ0GJRbHnBVkzQIseKBREaIjlE=;
	b=d1dFM6y28JczwJamGvf9l4lrxMkr7nXDguDCvD+llR3ov1rDBD9IPQwOKDtN6Qz6fcL7/o
	x72tewnqOoXmo4xjW5+JusvO2JvlS9q+QiVbS/wxbYlduMluEuKA3Uc3yD4TT7puB6xrqE
	KFZvg60SE08lu6aRzu1ec5ynXShO0H8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMhGYcxN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787221015;
	b=bAFFRm7PHZsNDSPggibskVXeU+Xrp7LDxLXkl9aDr1oqEMf7keHhOaCRPP+T5pg3DIlwHd
	PbXVr3nEazGZJG6zS5m8Qasz2MTdXu+PlsdawzBYgNr3Jg8xN6PT+JnZUAvolPTCUHKLiZ
	XfOCrF7Mo5VeIlj40epgsYlE5Iu2Bkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDBAF60A5C;
	Thu, 20 Aug 2026 10:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5A91F00A3D;
	Thu, 20 Aug 2026 10:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787221014;
	bh=Prgge7OpuMZ/HlcX8eJ0GJRbHnBVkzQIseKBREaIjlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eMhGYcxNKDh4NXZyBubRgnxdtCcRUowO/4SMoTPHcajD0tk+vx1zx6kNjoNl7/b8u
	 VbBmk5l0fpiy5ICmvJea6TNkuh71IIW6g4sxImhfzhNHSfOF1Pnm7qNJK8iUwqhxgH
	 CPiDRqe0w6efLy4yZBdv4ES/dp0n601Rxz4fye4gd5ggTA2TLZcJcqAkS7jkSIrrGw
	 KwwAacAdrYwOa6EuWzgfIQ5XSIavHrqs5msiFf1mrjgvBsX4gEBSwt+mn58su9t3xA
	 JczaSgDsCUsUtMas4k+rIohgdfMmYCgNhhIjTpgq3MYQQZsZYiph1X6iRlWfpNOzbs
	 kmFXzd6snLZ7g==
Date: Thu, 20 Aug 2026 12:16:51 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
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
	Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, 
	pavan.kondeti@oss.qualcomm.com
Subject: Re: [PATCH v4 07/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <aobOs0ZidWzgoHut@orome>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-7-5510d16af89e@nvidia.com>
 <an4MEI7lkc2p3nKI@google.com>
 <an8K2gb1pIqbDj6-@orome>
 <aoNDRTKCUkzd2n5G@google.com>
 <aoQ1lhZojzsSkWHQ@orome>
 <aoVy8dj8f3ll5-M4@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lgqipk6jwvqdiaex"
Content-Disposition: inline
In-Reply-To: <aoVy8dj8f3ll5-M4@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A1DDE40002
X-Rspamd-Server: rspam07
X-Stat-Signature: ysqieutw111yjc4dc8a31jgbucgotbei
X-HE-Tag: 1787221015-508511
X-HE-Meta: U2FsdGVkX1/RixrUH04N7BpfAvlb9lC30wseOwAzdQWNCa+wQfCiQBOEZMXFq9aT5uOGaUE/rWUkYyN7uyHPeMnULRDmEsSE6NRVTi4pNorA0uAG/4QEobzRjjWSPIPBilYiXxj3XBWJ8qBQvxB1YF7Sx52vd//tScO55cXp16ioIJHZ1WEu8snrMi1K4LA7oOXLVy6lc4hM0OyzQQh2dwCQ5bKnd+amLR0q0b/J9s2eUm0Rwn3xoVhhd7UaFUvsC1rM6tA5uX/LU7Lp23hOIrdet9BqJVCIKQ93Soxni9Yw4y6Mf9y40Ki4CP395pKxaDeJ82HsiTV73Niay90ueE6eirXF+ZbloC5LRoHnmQIVqaXbMUFUoMduPlvDpI3OzxrV9EnPdW6aaamJl4npLhqXVAxmY5x3/UrcZYm21EcquZOuYpP/+qGqGmRMNy0YvndA/JZCdDEDmxvLzsD0BNC9Sy4gLxb63Y7ONyX04lAE4Z2Zn5LUkJalmlYyOLtXNIH8XNl/4XCyjZ9VoAH43nASu1cCdeAPazDXzM/QLyjEi11MbsZPAZvx7NF0i8G8NCpNA5DtoleuCGXyq8im/XYuCgZXeOVM0sO7FJLgwEarOKi0tyUdW/vlt9spAcUyp5+D47qSlDIFb6TPc0iaBLZdGhpTn2IilsDsGYE6qs65ufoKjiF1Hk9qH+CTmsO3UWs8akf+hJOkXXOAgKFCrWvjn1YN1WQvI22jG3vZ2ftOG5cUv0j/l+4PR3AYGxiKHKClYv0LA9K9A2vGIiIMNh78NPvc/IfjokAfxmcLwK8tciLROA3fT7MycP43W6kLp0EHycgNfa3BjRET215vGrI47kE7jM6dAXGiqXlzQLWtvhv7aFY0nvEX0Vt34Z35hTbwvVaYkyqEZfFDMgHiqyVmRfb1HHsmbgjWBUy+CehZygwFxBtVlpqA0NriA8HSe2corSjdGl4m7NJjBic
 AU2Nlaro
 271g/I4khJei/xJUFiTJPl5LoWvXKCQHlbr3v5h/55evDUddrITIWawS+rbXoIUmAjGbRLJ+qcaolCTAHrbYlDkz91kVyoiLnIlsXw3H0prT8NJ/qAJjrJChDFtPDRgktq+xIycndav/Ij/ud+5TvfuJeHwXOgbBOXJdI2biww0OM0b8Bptf4+HAj16rJXAvAtg+/G5t5HSV8lqDqRFVCUjaiK0705RJiDBmWKOibO7vJFzwj5V0T1j5ELJCFNhwNee2OaUCLJxLxra/TN4GjVWpe3MlMTMfRTAsdIBzmFrXh3R8kW0zcLD27/4rGlrFC0YclEC+W/vkbYirihjxw+xF9WtVisGe7AHk3pdt51k761dnPC1RzoBFmO+Hl1ZVT6KbP0qQwQzEWwD1cIW4V4rRwBLfQi5IA3Dn5IRc6Y4Sa5UR7b5TzFdw+XM5GSPQ6I1yzM/aG769/M76+Rv4wyRJkjfGQs2Wmz05ooygZMdk3dHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--lgqipk6jwvqdiaex
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v4 07/10] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Wed, Aug 19, 2026 at 10:10:09AM +0100, Vincent Donnefort wrote:
> On Tue, Aug 18, 2026 at 12:48:09PM +0200, Thierry Reding wrote:
> > On Mon, Aug 17, 2026 at 06:22:13PM +0100, Vincent Donnefort wrote:
> > > On Fri, Aug 14, 2026 at 02:56:05PM +0200, Thierry Reding wrote:
> > > > On Thu, Aug 13, 2026 at 07:25:20PM +0100, Vincent Donnefort wrote:
> > > > > On Fri, Aug 07, 2026 at 05:54:27PM +0200, Thierry Reding wrote:
> > > > > > From: Thierry Reding <treding@nvidia.com>
> > > > > >=20
> > > > > > NVIDIA Tegra SoCs commonly define a Video-Protection-Region, wh=
ich is a
> > > > > > region of memory dedicated to content-protected video decode and
> > > > > > playback. This memory cannot be accessed by the CPU and only ce=
rtain
> > > > > > hardware devices have access to it.
> > > > > >=20
> > > > > > Expose the VPR as a DMA heap so that applications and drivers c=
an
> > > > > > allocate buffers from this region for use-cases that require th=
is kind
> > > > > > of protected memory.
> > > > > >=20
> > > > > > VPR has a few very critical peculiarities. First, it must be a =
single
> > > > > > contiguous region of memory (there is a single pair of register=
s that
> > > > > > set the base address and size of the region), which is configur=
ed by
> > > > > > calling back into the secure monitor. The memory region also ne=
eds to
> > > > > > quite large for some use-cases because it needs to fit multiple=
 video
> > > > > > frames (8K video should be supported), so VPR sizes of ~2 GiB a=
re
> > > > > > expected. However, some devices cannot afford to reserve this a=
mount
> > > > > > of memory for a particular use-case, and therefore the VPR must=
 be
> > > > > > resizable.
> > > > > >=20
> > > > > > Unfortunately, resizing the VPR is slightly tricky because the =
GPU found
> > > > > > on Tegra SoCs must be in reset during the VPR resize operation.=
 This is
> > > > > > currently implemented by freezing all userspace processes and c=
alling
> > > > > > invoking the GPU's freeze() implementation, resizing and the th=
awing the
> > > > > > GPU and userspace processes. This is quite heavy-handed, so eve=
ntually
> > > > > > it might be better to implement thawing/freezing in the GPU dri=
ver in
> > > > > > such a way that they block accesses to the GPU so that the VPR =
resize
> > > > > > operation can happen without suspending all userspace.
> > > > > >=20
> > > > > > In order to balance the memory usage versus the amount of resiz=
ing that
> > > > > > needs to happen, the VPR is divided into multiple chunks. Each =
chunk is
> > > > > > implemented as a CMA area that is completely allocated on first=
 use to
> > > > > > guarantee the contiguity of the VPR. Once all buffers from a ch=
unk have
> > > > > > been freed, the CMA area is deallocated and the memory returned=
 to the
> > > > > > system.
> > > > >=20
> > > > > Hi,
> > > > >=20
> > > > > I believe we (the Android team) are trying to solve similar issue=
 to yours: Arm
> > > > > CPUs can still speculatively read memory after it has been transi=
tioned to the
> > > > > Secure state, as long as they retain a cacheable mapping to it.
> > > > >=20
> > > > > As modifying the direct mapping is difficult, the workaround ende=
d up in the
> > > > > hypervisor which unmaps the pages from the host stage-2 on interc=
epted FF-A Lend
> > > > > invocations.
> > > > >=20
> > > > > If convenient, this is nonetheless the wrong place to do it. Scat=
tering the host
> > > > > stage-2 is really terrible for performance and we would like to m=
ove it where it
> > > > > should be, directly into the kernel...
> > > > >=20
> > > > > This is what I thought was the attempt in v3, but I am now a bit =
confused
> > > > > because I see you are using set_direct_map_invalid_noflush()
> > > > > set_direct_map_default_noflush(), but I am not sure that works if=
 rodata=3Dfull is
> > > > > not set? So does the memory for the NVIDIA IP still need to be un=
mapped?
> > > >=20
> > > > Yeah, this currently relies on the circumstances being such that
> > > > can_set_direct_map() returns true, and in the case where we want to=
 use
> > > > the resizable VPR functionality, we're going to have page-granular
> > > > mappings anyway.
> > > >=20
> > > > > If so, how about having an option where the CMA allocation is bac=
ked by a direct
> > > > > map with the same page granularity, or at least a smaller and ali=
gned granule?
> > > > >=20
> > > > > With that, we know that for whatever CMA allocation we do, we can=
 safely unmap
> > > > > from the direct map without risking splitting blocks. On CMA free=
, we can safely
> > > > > remap into the direct map as I do not believe we coalesce yet.
> > > >=20
> > > > This sounds intriguing. For VPR we could possibly make the size a
> > > > multiple of the memblock size (or whatever might be appropriate). I=
f we
> > > > can create a page-granular linear mapping specifically for that reg=
ion,
> > > > that'd be ideal. I don't know if the linear mapping can be subdivid=
ed in
> > > > this fashion, though.
> > >=20
> > > Actually I don't think modifying the memblock is necessary at all!
> > >=20
> > > Here's what I have so far:
> > >=20
> > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > index d4de88770ecf..a9f81413b70d 100644
> > > --- a/arch/arm64/mm/mmu.c
> > > +++ b/arch/arm64/mm/mmu.c
> > > @@ -22,6 +22,7 @@
> > >  #include <linux/fs.h>
> > >  #include <linux/io.h>
> > >  #include <linux/mm.h>
> > > +#include <linux/of_fdt.h>
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/set_memory.h>
> > >  #include <linux/kfence.h>
> > > @@ -1138,6 +1139,27 @@ static inline void arm64_kfence_map_pool(void)=
 { }
> > > =20
> > >  #endif /* CONFIG_KFENCE */
> > > =20
> > > +#define MAX_FORCE_PTE_REGIONS 64 /* Greater or equal to MAX_RESERVED=
_REGIONS */
> > > +
> > > +static struct {
> > > +       phys_addr_t start;
> > > +       phys_addr_t end;
> > > +} force_pte_regions[MAX_FORCE_PTE_REGIONS] __initdata;
> > > +
> > > +void __init early_init_dt_force_pte_arch(phys_addr_t start, phys_add=
r_t end)
> > > +{
> > > +       static int count;
> > > +
> > > +       if (force_pte_mapping())
> > > +               return;
> > > +
> > > +       if (count >=3D MAX_FORCE_PTE_REGIONS)
> > > +               return;
> > > +
> > > +       force_pte_regions[count].start =3D start;
> > > +       force_pte_regions[count++].end =3D end;
> > > +}
> > > +
> > >  static void __init map_mem(void)
> > >  {
> > >         static const u64 direct_map_end =3D _PAGE_END(VA_BITS_MIN);
> > > @@ -1186,6 +1208,15 @@ static void __init map_mem(void)
> > >         __map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNE=
L),
> > >                        flags);
> > > =20
> > > +       for (i =3D 0; i < ARRAY_SIZE(force_pte_regions); i++) {
> > > +               if (!force_pte_regions[i].end)
> > > +                       break;
> > > +
> > > +               __map_memblock(force_pte_regions[i].start, force_pte_=
regions[i].end,
> > > +                              pgprot_tagged(PAGE_KERNEL),
> > > +                              flags | NO_BLOCK_MAPPINGS | NO_CONT_MA=
PPINGS);
> > > +       }
> >=20
> > Interesting. I had been thinking more along the lines of adding this
> > directly into memblock using a new entry in enum memblock_flags. None of
> > the existing ones seem to do what we need here, though some are closely
> > related. MEMBLOCK_SECURE or MEMBLOCK_PROTECTED are quite specific and
> > don't necessarily mean that we need the mapping to be page-granular, so
> > MEMBLOCK_PAGE_GRANULAR is perhaps clearer.
>=20
> I thought it would be interesting to not have to modify memblock since it=
 is
> used for all architectures, while the DT is at least slightly less widesp=
read.

This isn't something that is DT specific. On the Tegra side, I suspect
we might need this on ACPI platforms eventually, too. And it's not an
ARM specific feature either. Other platforms could use shared carveouts,
too.

> Also, cma_init_reserved_mem() could use an order 9. In that case PTE-leve=
l isn't
> necessary and we could just use PMD-level. Extending that support would b=
e more
> cumbersome with a memblock flag than with a callback.
>=20
> rmem_cma_setup() hardcoding an order 0, perhaps this isn't really a probl=
em at
> the moment?

How so? memblock is really just used as a way of backing the CMA. How
CMA subdivides it doesn't really matter, right?

Or are you suggesting that if we use an entire PMD as granularity, we
could equally well remove the entire PMD from the linear mapping instead
of doing it page-by-page? I think that'd work really well for at least
VPR, since it is 1 MiB aligned anyway. Using a granularity of 2 MiB is
easily doable.

For anything that doesn't require a single contiguous area to be
protected this might be a bit more challenging since it potentially
wastes a lot of memory. On the other hand, a lot of this is heavily
custom code anyway, so the entire stack could be modified to make
efficient use of this (i.e. userspace could allocate a larger chunk
for a pool of buffers, etc.).

> But yeah, the alternative is to create a "memblock_mark_forcepte" (it see=
ms
> memblock_setclr_flag does split memblocks) and let of_reserved_mem call t=
hat
> function. Finally the arm64 mmu code can simply check for the flag before
> calling __map_memblock. Perhaps it isn't that bad in the end?

It sounds like the right level of abstraction to me. But I'm not too
familiar with this code, so it'd be good to hear from the MM and/or ARM
maintainers what they think about this.

[...]
> I had in mind to extend "shared-dma-pool" to handle
> set_direct_map_invalid_noflush()/set_direct_map_default_noflush() based o=
n an
> option. But perhaps it is better to create another separate driver. And V=
PR
> needing a specific dma-heap driver anyway, it could call the direct-map
> functions there too without relying on CMA to do anything?

I think it'd be nice to have separate APIs for this case where we know
the memory region is already page-granular (or, I suppose, PMD granular)
and removing from (or adding back to) the linear mapping is safe. That
way we could avoid the checks for can_set_direct_map() for each page.

It'd also be nice to have a version that can update the protection bits
for a range of pages (would map directly to update_range_prot()) instead
of having to manually iterate over each page in a range.

A good middle-ground might be to have helpers that do the grunt work and
they can then be called from VPR and the shared-dma-pool drivers to have
pages removed from the linear mapping. VPR and similar can then perform
the hardware protection bits on top of that.

Thierry

--lgqipk6jwvqdiaex
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqG1BEACgkQ3SOs138+
s6F7lRAArYkFeTZCiaSW0m7zGIomMdDlHXmGBzYfHl2VZ3wH70nxODs/qRyHRCHr
su7floNIfcai3gyX/2hLu4adl8wuzA2Ox+wW/NBcLKD8OVJMALcEiZ92SaT5Ikpp
O4syeCwLYOi9xTZSehRv/IoUWU/XNULjb2PjZ81mwbrSxhXiCueG2zy+kiGIp0bU
1why7rYrqly8Ox8d7IK89VJSSKWIwo7bdRNlVmk/L+jubLG+rNkSQtXRoXU7qSeq
s/vBkD1mhT7aDp0/5KTcNYMeMCExTOX2BkeJ4WrbjafpecrIkUnQdCv9XKnX4QG5
pULUocNnFhC5IHpEm0xVO/g8ZdY3nf9S1VMWLpPzh3bQzZ5gRGwRd7JYGM76oSsu
UsFmhETy2x7d8/jJKwI0iFfJDxQC9/aC1iKMw9ZZvA4W9RghorKcbl+Q/ondTY9V
zHBUifqZUrzxOAg7Zcpi9OLOm13jP9Ug1lRW9DmSXhg/wuO6uKjui2CuQH3jYfB8
aivJZLZZAUsrw5R6OlHutKG5iPJqfteqPa89Ru0E8ZGEjkfr9Ewm9UeIwZaB7FUx
1w3QikuV5XNxbsXvEBfouNq8u/ruFlQ0gehgx2xHOyU8npifFHGD3xIJ9+S6A8vi
RDQYAtF3eexkxSEhmaqou1/Y/HPJi5zwvITM9iU0n79Af7/eXJE=
=1zoM
-----END PGP SIGNATURE-----

--lgqipk6jwvqdiaex--


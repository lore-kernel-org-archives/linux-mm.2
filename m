Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1EA0C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04706B00B7; Fri,  3 Jul 2026 13:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3D06B00BA; Fri,  3 Jul 2026 13:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A36D6B00BB; Fri,  3 Jul 2026 13:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59EF16B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:13:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3B7B401C0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:13:46 +0000 (UTC)
X-FDA: 84948112452.19.A1DEB91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D63212000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:13:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g4enwm4s;
	spf=pass (imf29.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783098825;
	b=ilMXYV2F9uxRlbsiCt7PZAYvsN2x3J8cjgOCFMkzPfKxbeuu9jsObagSw0V2+FBSI0oH7n
	hFK29/RHF1bt5X1oYn4rqo5EIwERWs6c5DSvnG7a97BeU9i9rqPuSUsC5jPMyn4eUBIkb5
	OGTntqrZhC/ViVMuHg6c8R4uUsx4Vio=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783098825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q23BIidiZ017iKhXJsbogBQ9PJP1zUIVfxmZpJ2jL8Y=;
	b=2OhFZcTql/vYmVo+WgTD9aiePlKg1E4jIIdAPwC0DIkB6384M2PAGpxWYetpxpGRl479DI
	B4UpmHLt3eSBkIJZAqgjP//JS5Vq0uUNjsLk7jgJ6QD5SRgUaaREFnorFZ+QIet7WA2duy
	y/WJ27TGQcdMbwNb3a3+CVQ0tkjLims=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g4enwm4s;
	spf=pass (imf29.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D0D3600AF;
	Fri,  3 Jul 2026 17:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB2F1F000E9;
	Fri,  3 Jul 2026 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783098824;
	bh=q23BIidiZ017iKhXJsbogBQ9PJP1zUIVfxmZpJ2jL8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g4enwm4svtwtT15ZA13jyA9qwc9lTppZoLAqvOXFJBuu8Kf5+n3us4YU1h9YquIQ5
	 ZJzaMwvXvLV4y1YTzZTccXJTXIqFY7kVs1R7t1Xlwnq201NEMIOKid+EEmnkxiSMSi
	 GNi/uX7pe9g5oOTx6OwStKk2v/qCkvdBHEwH1xGl+ZPu9h6p/ywnZRCLOOmca4YyDa
	 svZYQ2arPoNcRi94A2S6PIqz9+mr1jy1vobmXh+nOQmN5VkPCJckI573GfqHv+OilP
	 Bm5MnNHsTToXJBO1LQvI4FYubASQDDOLIaRxh4CJS3U0VT2ZmBr02kU8SnnEr3qzmp
	 fkqPwnkZrA6Ww==
Date: Fri, 3 Jul 2026 18:13:31 +0100
From: Will Deacon <will@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <akftuw9NyRy36fXA@willie-the-truck>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akaSJ5D98w2cHqb6@orome>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D63212000F
X-Stat-Signature: 37fgmywk7yy6q7s4r3axttxgyeznica4
X-Rspam-User: 
X-HE-Tag: 1783098824-492386
X-HE-Meta: U2FsdGVkX18x6GE5pZ2EQRXlMPsNoCla2QUT6bd0FGzuAf9HGZkHyn/JSOLTFwNGO7TwAFyNhAacpDtYIsnU+YAcgwjfHIx9BWmyfneqil5WojjCTt4IF4508x3kfaRhSRgyKGZRHViD/BGmdoc/qgB9v65k7x+KaCFRcalXwr6PpDIzoWVMmeKMq2V4IjbTCMRU83jtJaG4NcWQYDTiMbRmz3I3aJL3r/RWDC6ME7uovd2mKNZyiRqhGv101MEXTdDeU9a8OVqwHQgkFz2ChGmoyesO9+ChRlkqR5FTavyt/6gf6RGVseEQLD5pILaepsn+MnYjBdfoot+qaAtURi6fWXP1mzTDxHGKjTy/uJQXqv+AuEGZOa/g2Zob6t/jj+gvlQfR0+7lQhHlum30rE/+jD2Ec5reuq4vsBvw+jkeFbdufbPVtYytsmc5uvf+mTwM5f3aIbAFf6X7ScgzgQ4uEsHIB8+Wiixu2PTicT5Y1rB02CwX0X0nAJiwQMFg9gfqmx4jVpcD/G/xsFyYfGbJ+NcdRQltIatVMaSZW0R2EeoDH3k9V+Mxrm5E3w0pkWdIaZBbX+lGVU1srt3i+4E7UQUkz+aukKSAbmSqPUlJq74IXgueVeaStZLDy0JDsTxJlPiqjleM2v9Hb4tYCl8DL6jIimiXN3L0M+ktFbUS6Ieoz8PUzP5l6VMq8jEUcbs+eg8b/0dzL41pOwmU9OEkMF4YfTq2OeVMzx4MUazEeoC1kXftpc/QDALAdn6B5yyipYR/BwtISrFF4Hsq2vonTXwqZ+O4nnzoCr4qC6Nj2vn6PgpZkQ/QZEWN2GnzYd2Yw35fOOGqg9G6kROyTtvW8vvnfoq8JxE1ycOkI6BzLpqszwekNu2TELn1z2npUf9XvWGUbogwqQm1hrOCqbLsF31gIzG8sO7Fr/MOo/+j/YZoEkMzBvdJrnAAmj+Rkjbzll6F5vF2nzqxJHU
 m35hXSEs
 udlC6T5xiihmRYhggYFJgG00e+3HUkvudXJ3NGrGzbt+yUdrATegs9NsCOt9fx4x6V1H+E4otCpnFUMK1L8HUc6YwGRZvr9heDxEOYhHupcv3FvUJ2KrHQ7ZgFGo26hLnxtxdiCUFJ4xBX4r4TQE0orMmZfNuc1pAOSRuriRQfMZo76WSE38YDeVuGredrEy6o+CrplhT+X/k3ocH4T8Fsznexp3S71NlDtGfAm3MDz5uvhHsHI0T9uAC7jFww0ujmYt4e7Drksn7GS3ygHBUOrXP9hc+6c2/6qS3Bd0BEUHt0j5jvhR8rGA8YSQ+X3KiKh4MeyovlrJm4wVYmJZg5GUfv3L0rE2BHMGzbqxaJrXprV4Vod5334KyJ6tHX3/U0mPUcNwrF1cQVXIv+gduMvTG5c7rvunwRBJVC3dSeXR8mkDIJuPh3kgBYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > > From: Chun Ng <chunn@nvidia.com>
> > > > 
> > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
> > > > on a kernel-linear-map range.
> > > 
> > > That sounds like a really terrible idea. Why is this necessary and how
> > > does it interact with things like load_unaligned_zeropad()?
> > 
> > This is necessary because once the memory controller has walled off the
> > new memory region the CPU must not access it under any circumstances or
> > it'll cause the CPU to lock up (I think technically it'll hit an SError
> > but in practice that just means it'll freeze, as far as I can tell).
> > 
> > Probably doesn't interact well at all with load_unaligned_zeropad().
> > 
> > > I think you should unmap the memory from the linear map and memremap()
> > > it instead.
> > 
> > Given that the memory can never be accessed by the CPU after the memory
> > controller locks it down, I don't think we'll even need memremap(). The
> > only thing we really need is the sg_table we hand out via the DMA BUFs
> > so that they can be used by device drivers to program their DMA engines
> > internally.
> > 
> > Looking through some of the architecture code around this, shouldn't we
> > simply be using set_memory_encrypted() and set_memory_decrypted() for
> > this? While they might've been created for slightly other use-cases,
> > they seem to be doing exactly what we want (i.e. remove the page range
> > from the linear mapping and flushing it, or restoring the valid bit and
> > standard permissions, respectively).
> 
> Ah... I guess we can't do it because we're not in a realm world and so
> the early checks in __set_memory_enc_dec() would return early and turn
> it into a no-op.
> 
> How about if I extract a common helper and provide set_memory_p() and
> set_memory_np() in terms of those. Those are available on x86 and
> PowerPC as well, so fairly standard. I suppose at that point we're
> closer to set_memory_valid().

Why not just call set_direct_map_invalid_noflush() +
flush_tlb_kernel_range() for each page? We already have APIs for this.

The big challenge I see with any linear map manipulation, however, is
that it will rely on can_set_direct_map() which likely means you need to
give up some performance and/or security to make this work. Does memory
become inaccesible dynamically at runtime? If not, the best bet would
be to describe it as a carveout in the DT and mark it as "no-map" so
we avoid mapping it in the first place.

Will


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA82CC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642EA6B008C; Wed, 30 Jul 2025 09:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F38D6B0092; Wed, 30 Jul 2025 09:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2576B0095; Wed, 30 Jul 2025 09:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E09D6B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:40:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFCD0C044F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:40:35 +0000 (UTC)
X-FDA: 83721040830.02.810E409
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf19.hostedemail.com (Postfix) with ESMTP id 33D1F1A0011
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:40:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8TgLaML;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753882834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwI8HW24x7jyl46fjynmA/WxmX0LnPGEQIHuMkllTKQ=;
	b=oSg7+TWmALJ2tz1k/X84sO5/woqvL03RpAd2BKIZ2Csy+ik6qXV2voe3CGEDpUHl+7yWxY
	uj1v2H057XUbKM8F+tZ9J7/Ko+c0KlzVNnXegHjjrp1nVX+LyYVAyHz1P/AMhFHx26vp0r
	XxwQu5Iq7mLPJ51HVH0ALFfyJEozx8A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8TgLaML;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753882834; a=rsa-sha256;
	cv=none;
	b=Ub9nOyq0E9AefD8O8tT1H+Oen0OMLL9BMijivGCNGf1iVRfgSnnMlFNzDiqJC+qDiKTYXe
	EGMN3eheYShzcwEX3N7PrDNB4ZdIzi+Z9RbnYGmoO2C2wp24EhP9fVA+i857dEKMPO+BuF
	Qdaa3WJH0HtJoN48m71Ak0XcM5mbVGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 67A16A5525C;
	Wed, 30 Jul 2025 13:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640CCC4CEE7;
	Wed, 30 Jul 2025 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753882833;
	bh=r3n99v7PlKiifLXLh9htJtFm2A7cf2OiYGh/qh9Hb1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m8TgLaMLadOIyx04mZ9ZYnn4myaayZRK7kgYZVWg3h0VvggYJqipkE7m8kihbxwWL
	 9jKp14tTw38zaqtxLOs4+wPXQpdk5H5YuytkfRtotal19ho19vtLcN8uhZvhuvLRPX
	 42c7rY/aM1/egztvkzXplhf+9bGFcggtgtx61kTgzCaXar98rSFW3YWyXa/FQaWlYW
	 McArBA1HJxfYyEE59+8qhXBclPjUsdyQKbgOD5cwFnbRV+ycZ6W1VlL0iyN2sxk4Qa
	 lAa5NhJYsRATLyxRQb00fyrj5qoDoGRC6J9qWpf+W0rI4zJpZixNNNgOGnHgjjxYGp
	 gwqKIvjy1EGBw==
Date: Wed, 30 Jul 2025 16:40:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <20250730134026.GQ402218@unreal>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 33D1F1A0011
X-Rspamd-Server: rspam06
X-Stat-Signature: 9noo4ijuqqzia6edfpakm94cn7woaj64
X-HE-Tag: 1753882833-953370
X-HE-Meta: U2FsdGVkX18UyO4Xmw+LbyE/B9iCiq1OkeiSOo1zfIHeN8EV/AE5ezAgXCWXUIJdiqRWPi+u2mvbOFLZXRH7ZyNxsA0SpYlRgR3bqkoDYvx1XgOD9wba2OFxihB0JXE8wz8JLJLZyDpZUR/LOnHLTBtFFd2FyRY9nlS/DXPX6aS1t4K99PeizY2BeJXSeefPxZHrgoHReVVOjbHoYup7vTeOOY7S02cX42vUWeDZSYaWcQVs1S8rcV2ohbhjFdPnXV2u3rYfRo/08G2azgA0qBiV1z3ECaVIWethUqEL43VDBinS9MtDULHjxa2m3Ig2Ym26vp53ThrADeMUGAGyYxZsLLSltk/2nhSCrZO0iXN/6yqK47mUtEQSyn7nt6EQGnLIPtHwkrn+Dx3bDsG4kxwNR5vx41xkeFpQn5aC+AiXs8/Ex8Up+Z50Ni7eF9nu6SFaW8sqF8QlpaXmUMKSx4ZYTGkUgA0Hdtm0JRiVLwVgOfz+fKI4eFSpUvFXwI3XF7UzKcgjw2Y+bhGzPlh4r+QRN6XxSd8UifusNVFD+xli5xkKZL8N5mvFKknSGq7T4EsW9NBVyk8MkT68T41aNRno6ntgeI/lS0Pr+4J1mOosLNCTmnrw5GPErEKCLR6dSP0WHAA0Y/fma/oOKTj/qyhx0oOAPBSubAtVH2WIBI4x1E/CH4dYcaD42WRubu54rBO2tFSj3p3400tKM9zjDw53kGOG6cRvIE+05e68D+spUJi/2R+ANTe1N6Cztt4oyWeanb84Egbx+Lm8T/Zr5ayS+BaP3/dUxoMwRHA5dowIGbKyxHvOUjJH7Bk+cZHXu6/hfZRWeZVI05DubxARwbNhj6dpR1K2Cfd2axqEwt8TdXxrewd63h9IoD7y/feXjkP39WZRB+FuFo6TlPZgIW683iFQNnYUbCXQcEqOxj43M2TEMaZLaBVtQk4ZoTfWBcqJNt0hBtON1N5Huzh
 JdEU8etR
 dPhe2NbvoAy6qnhifJN7spF63X5O6svbUyzTqXbR2ovm2UtuxlTT5gFqMhihGAmGZQmhbwI/pbMMCqCBm1dqQQ5FC5YocfIGk5+CJdufTyWKuX5qQtV8lJvYdlKjaFi3jn715MSw6fdae69VgyXwaVQtyhhxO/Q+S86EqTN8AQ6Bk82TtxKPM42pT2G+qW7S27kFUStAHIUCEpEbpg4SSow1lY+UWU3vUIfPyFbr7HFDLsldTjclyXnPEFM3EuTK2NgUZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 12:11:32PM +0100, Robin Murphy wrote:
> On 2025-07-08 11:27 am, Marek Szyprowski wrote:
> > On 30.06.2025 15:38, Christoph Hellwig wrote:
> > > On Fri, Jun 27, 2025 at 08:02:13PM +0300, Leon Romanovsky wrote:
> > > > > Thanks for this rework! I assume that the next step is to add map_phys
> > > > > callback also to the dma_map_ops and teach various dma-mapping providers
> > > > > to use it to avoid more phys-to-page-to-phys conversions.
> > > > Probably Christoph will say yes, however I personally don't see any
> > > > benefit in this. Maybe I wrong here, but all existing .map_page()
> > > > implementation platforms don't support p2p anyway. They won't benefit
> > > > from this such conversion.
> > > I think that conversion should eventually happen, and rather sooner than
> > > later.
> > 
> > Agreed.
> > 
> > Applied patches 1-7 to my dma-mapping-next branch. Let me know if one
> > needs a stable branch with it.
> 
> As the maintainer of iommu-dma, please drop the iommu-dma patch because it
> is broken. It does not in any way remove the struct page dependency from
> iommu-dma, it merely hides it so things can crash more easily in
> circumstances that clearly nobody's bothered to test.
> 
> > Leon, it would be great if You could also prepare an incremental patch
> > adding map_phys callback to the dma_maps_ops, so the individual
> > arch-specific dma-mapping providers can be then converted (or simplified
> > in many cases) too.
> 
> Marek, I'm surprised that even you aren't seeing why that would at best be
> pointless churn. The fundamental design of dma_map_page() operating on
> struct page is that it sits in between alloc_pages() at the caller and
> kmap_atomic() deep down in the DMA API implementation (which also subsumes
> any dependencies on having a kernel virtual address at the implementation
> end). The natural working unit for whatever replaces dma_map_page() will be
> whatever the replacement for alloc_pages() returns, and the replacement for
> kmap_atomic() operates on. Until that exists (and I simply cannot believe it
> would be an unadorned physical address) there cannot be any *meaningful*
> progress made towards removing the struct page dependency from the DMA API.
> If there is also a goal to kill off highmem before then, then logically we
> should just wait for that to land, then revert back to dma_map_single()
> being the first-class interface, and dma_map_page() can turn into a trivial
> page_to_virt() wrapper for the long tail of caller conversions.
> 
> Simply obfuscating the struct page dependency today by dressing it up as a
> phys_addr_t with implicit baggage is not not in any way helpful. It only
> makes the code harder to understand and more bug-prone. Despite the
> disingenuous claims, it is quite blatantly the opposite of "efficient" for
> callers to do extra work to throw away useful information with
> page_to_phys(), and the implementation then have to re-derive that
> information with pfn_valid()/phys_to_page().
> 
> And by "bug-prone" I also include greater distractions like this misguided
> idea that the same API could somehow work for non-memory addresses too, so
> then everyone can move on bikeshedding VFIO while overlooking the
> fundamental flaws in the whole premise. I mean, besides all the issues I've
> already pointed out in that regard, not least the glaring fact that it's
> literally just a worse version of *an API we already have*, as DMA API
> maintainer do you *really* approve of a design that depends on callers
> abusing DMA_ATTR_SKIP_CPU_SYNC, yet will still readily blow up if they did
> then call a dma_sync op?

Robin, Marek

I would like to ask you to do not drop this series and allow me to
gradually change the code during my VFIO DMABUF adventure.

The most reasonable way to prevent DMA_ATTR_SKIP_CPU_SYNC leakage is to
introduce new DMA attribute (let's call it DMA_ATTR_MMIO for now) and
pass it to both dma_map_phys() and dma_iova_link(). This flag will
indicate that p2p type is PCI_P2PDMA_MAP_THRU_HOST_BRIDGE and call to
right callbacks which will set IOMMU_MMIO flag and skip CPU sync,

dma_map_phys() isn't entirely wrong, it just needs an extra tweaks.

Thanks

> 
> Thanks,
> Robin.
> 


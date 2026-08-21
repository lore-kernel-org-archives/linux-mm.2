Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7227AC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B486B009D; Fri, 21 Aug 2026 16:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CC76B009F; Fri, 21 Aug 2026 16:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3C36B00A0; Fri, 21 Aug 2026 16:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1351D6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:44:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9697EA024B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:44:57 +0000 (UTC)
X-FDA: 85126455834.20.CB35B43
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id CF60440007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:44:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uX9rWk5d;
	spf=pass (imf11.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787345095;
	b=Fr8GRDch9jCcjSsYaE46OzQgRlwStBx0rl0ho0zzuOROTcYL/+QxX+nUZaoqba2rSVbByy
	eMMWcoZOm3Co3sSZ+MWFGAXnkYEpkPVXtT9VMPLfvrS+kNgQ6bq3pftRVmAa1s5u1T2hNW
	PUPv+z5AeKuy2DRDxoFkXyUkZ6nzvJA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uX9rWk5d;
	spf=pass (imf11.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787345095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzsO6bXfVkXRG/aUxfAmIkKsE+Fa964GVFQS62WZABw=;
	b=A+JTIF/+hA6eyFFqlUiuMI2vQQnqCDOY2IRZBB6yP0oCEp8phuiveAh/yq+7+iZJHzRkF8
	GFrtbyoD7VmjpcGqX5MSPYDKrbzDF85T4py5BissOfSzzo4Sdgm50CuxwLWLullx5J45oC
	fkQIGxrx691GLIViZ6tvb9jGEnXWrT0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b966dd74so6856785e9.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787345094; x=1787949894; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QzsO6bXfVkXRG/aUxfAmIkKsE+Fa964GVFQS62WZABw=;
        b=uX9rWk5dY4vpA3/XZWzuf4jfF5TmhuzyG2gNXSVNhucNYV7d7LkKuzZtJhdqkRaeLH
         4jgdPRXmhNMp4L9FEr1ZBffX306lDzMhXu2Ei5zYGbsvDM72dHA6BciHMr8KPfIIGLuY
         DYIMfCBCfv2OFmVRrQbpvK896dvoO7UvAzUb5r/eselG6E55N2VajHFCkcfrX888HRY2
         0+8Ta7Za5G0GHlP2FNgPspsT1thE+X7+gpUilPLS9/hzUQqaXovCpaICBlf6toQptWTb
         sTPaF6Xq+CfSZ2N87ueN4Rf/+fxMXR4JB/I1LP7Ad97g7pZMex5VhlVzZnzW+1ODfTzj
         mt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787345094; x=1787949894;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QzsO6bXfVkXRG/aUxfAmIkKsE+Fa964GVFQS62WZABw=;
        b=N/sOMkTPDSm1mH69zhiZP3UUoOON7EjEaWZUDWDRk0210H7ZCX9BOMteke4kVdsdKY
         EaapvxAx56H9qqhO59RbPcFp4Kxos2QEHHk9mrvooEbqndlxwWv8WViQRT5iKJREa2Xk
         Hy2HvFcZnOOK582QrlQMIIXxLfe49vIeYPU2tN4wbm+Qn4t75rIBzm4y66ixampNtwtu
         /DdpmJwmn9MztiL97Xw1qCQ0Ul7fvkKNCwyEKhIkFiT+R1CBfsF0nFykAhSSYR5ApMRG
         8wrqswvo/zaUHm4w+NJ5VsAJWse91z9uc4lWVRkDt5RABotopHDmmLHpxQXLha2g6+2H
         TnCA==
X-Forwarded-Encrypted: i=1; AHgh+RqNmlCVNgXb+8BvTUotlpemJ1jMh/t66MzzcPnRYgb+Na0QqitZGGNjCHRg1zojCKxMKxJ1VUfxzQ==@kvack.org
X-Gm-Message-State: AFuF++lG/OOppvY+FZeAWi3XGtr3bcBXBRx5OyfHmm2x8l9jEeJkGof/
	keiYIJ7g7b6czORmYqODerYWrFFvBNMvFYqB0/cTPHsb4iQ4UHlnj833hkCP1qchzQ==
X-Gm-Gg: AR+sD12e0rn4zE7pa1rjn3nXTpUaGn+DqHAU+cU3Spcp5fc7Hg7GThENllWMKr9EBsG
	sOPiMXntN9e9GbBZmsrT8af2CEUJRJlC2rX6m5K8a/nYFyDCX6KIO+w+MZr6UDNytY3Hj6pp9PP
	Svm+tB0ktdj2Xc2jav4urIZvl84U1LwF1GrKYMdG5DWTFcYrM/OecXL5Urz1s7zLBN8mLn7uu5d
	HwF+7xfg5cwqdfUdDEFQcdpRSvHu/caBMZ5HM41Pgh3YKqpnGDJn/RipE1A2u34DjXcth56S+c8
	SlwCZ3oySgIwUIbQq/o8M52KLPAR5BmKKzLbSAWoys+p6QC+HuLealOA4DyVJz3tEFqcyoU0uFy
	+8kz/DrqfAEl2DsNJ37rBAH6yXyuxy9E9bIaw+FhBIn8aHMcKa11lmBgTqQ0RGo/SePL0gucdSP
	ABLzJRiaSUjRc4dn/FbzL1Zks2Vtr6//5aqIvOb4oMX8LX6avPWwBN0V/RMEs+w92YrnXEFWyp5
	Yq9V9AyeASRJRqo95ptqWIj4IYwIgqI
X-Received: by 2002:a05:600c:548c:b0:499:8aff:59b6 with SMTP id 5b1f17b1804b1-499c19f514emr11324295e9.14.1787345093778;
        Fri, 21 Aug 2026 13:44:53 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b911584bsm40454845e9.14.2026.08.21.13.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 13:44:52 -0700 (PDT)
Date: Fri, 21 Aug 2026 21:44:49 +0100
From: Vincent Donnefort <vdonnefort@google.com>
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
	Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, pavan.kondeti@oss.qualcomm.com
Subject: Re: [PATCH v4 07/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <aoi4wZJIutMWu9Ux@google.com>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-7-5510d16af89e@nvidia.com>
 <an4MEI7lkc2p3nKI@google.com>
 <an8K2gb1pIqbDj6-@orome>
 <aoNDRTKCUkzd2n5G@google.com>
 <aoQ1lhZojzsSkWHQ@orome>
 <aoVy8dj8f3ll5-M4@google.com>
 <aobOs0ZidWzgoHut@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aobOs0ZidWzgoHut@orome>
X-Rspamd-Queue-Id: CF60440007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: n5pxkyi1aqz7ekxw9oxe3udxneuouar9
X-HE-Tag: 1787345095-182076
X-HE-Meta: U2FsdGVkX1+7Or+m+hkJ/yXTook01yhNiw/5nG5cPXCfLzZz2VW0PT+NwvdINsT1tmqQPP8NKotK2TUQ7Sy9IdtClYWXYZGPkwKBGq5ZGYNHqZhxwnj9FjR3tNvqJ9Ucy1W1ojxiOZMQrJ+QIvYwV6kuz5D6MR6QCLMQl8vv6bhRCvLFFiB1VzPpH3JDaFaPkVUu9Rz8tr7E3blgJzek9XEzR2FHfWBzvhHUOxPZtXRimcCxIMJvjEkg3HK2hi0F1HPUJaPmMrGQDONmWdwAh+U/EjvfKjcS1iyKtK2d0o0+WZK6av6z3uM+mEJq5f53zKXNzq+6CvCZ9zz99FieARWCKfWU7J66B6bardFnlYDQHynC4otkS2YcBor+OY6P1fOkCU9G6WgO1rzIekjxGvVqIQ9ZXu5flYpRKasoYzSYO8gr+6KDqj0g7hDf0UOuVTzk/qEf/0YyRRH0k5/Ij5B6h4N3YrU7MdyLtH1hj63A3E9zYJ5tE8kX1A5g1Ve8qhmhkJFsYSWveI6KASejjdgN7HiymC8ShjtFNgKjsl7Ylcz9wOfe9xmoTHpTdrTOwWi9zFtId+06UZP4bvIlEUww6KxkjZqxXpgQc/IQOo51YPt8VOV+acs+b0uYSkfnIp+xXYqW2YX4gDAT16ZzcajsjViNe3H/p6nBbOyePV6TBmBSbNIpCV/q7HNFVWo/a4o+WZQYDgS9pVnsFZGO7nUYDG2pQ7c2Z9YP0GGasO9h9G2DsdzpFjwRZOEX9nti5wyLVTmUVH9dG8tNNFmhvUDILChdMK32F+SGq2tE9d3hpw2ev6tQDP+XOM5H/s8hcO17I4X0HVhNmyChm9M8cyA6Y7wek+HAkr1kYWFvSqKlQDqPJeoGjPRowx4befpCzKAlzZMI3nYEWCERufaggM/wIReKuqQZGgZ8XaZ5yC1XvE0e9d0UNBX4C90XsNfO51Mhcw2LqHfoLQxnRah
 kthDGIuC
 6vKaEj32qcHTUTRLuRiRj+Sy80Jl2FQAgn2/L/QoNsZ1RcOHk1RcDFp31OCl8hOOk69ELpHkFEioxmBHu9Qa3FiGOD/hg7lMwRQc211IfrBhbuosBsyho++PiGqc4M/Y5/ab4O2id35T1TzwnLHZEMBxU8HN4GpBbKL+fei0MvrHEx95DTxzraO/xDhbCXZCPPmlbuAjFxu+aiM+N8KfASknoFSl0CVwVBNVaq0wiYT9f76lMo2tJxy6+eBrhMgvBOoNkm5UchSJsUX6bEsGdaqBy/KUEEkBdTmE1xBAL6qGm0htp8sexm9qnU6yqB55B5vTDR4sJa4vVLYezKkI+rR3oIHr6Ef3w6lEkFgjEvJwiohLMieCC52JcvGRzPwDqpTz726C92QV3Fqo0/lCwxqMIELbyeQSIWNjUqEch0XkLxgtCJJq5y12R4HyiMqX2KTVLE9Mh7zua/ESUTU6C5sHmVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> > > Interesting. I had been thinking more along the lines of adding this
> > > directly into memblock using a new entry in enum memblock_flags. None of
> > > the existing ones seem to do what we need here, though some are closely
> > > related. MEMBLOCK_SECURE or MEMBLOCK_PROTECTED are quite specific and
> > > don't necessarily mean that we need the mapping to be page-granular, so
> > > MEMBLOCK_PAGE_GRANULAR is perhaps clearer.
> > 
> > I thought it would be interesting to not have to modify memblock since it is
> > used for all architectures, while the DT is at least slightly less widespread.
> 
> This isn't something that is DT specific. On the Tegra side, I suspect
> we might need this on ACPI platforms eventually, too. And it's not an
> ARM specific feature either. Other platforms could use shared carveouts,
> too.

Agreed, and actually I have tried the memblock version and it looks quite neat!

I will share what I have after the merge-window.

> 
> > Also, cma_init_reserved_mem() could use an order 9. In that case PTE-level isn't
> > necessary and we could just use PMD-level. Extending that support would be more
> > cumbersome with a memblock flag than with a callback.
> > 
> > rmem_cma_setup() hardcoding an order 0, perhaps this isn't really a problem at
> > the moment?
> 
> How so? memblock is really just used as a way of backing the CMA. How
> CMA subdivides it doesn't really matter, right?
> 
> Or are you suggesting that if we use an entire PMD as granularity, we
> could equally well remove the entire PMD from the linear mapping instead
> of doing it page-by-page? I think that'd work really well for at least
> VPR, since it is 1 MiB aligned anyway. Using a granularity of 2 MiB is
> easily doable.

Yes, that is what I meant. We could easily force a PMD-level mapping instead of
PTE-level one. But then that means declaring another memblock flag. 

> 
> For anything that doesn't require a single contiguous area to be
> protected this might be a bit more challenging since it potentially
> wastes a lot of memory. On the other hand, a lot of this is heavily
> custom code anyway, so the entire stack could be modified to make
> efficient use of this (i.e. userspace could allocate a larger chunk
> for a pool of buffers, etc.).
> 
> > But yeah, the alternative is to create a "memblock_mark_forcepte" (it seems
> > memblock_setclr_flag does split memblocks) and let of_reserved_mem call that
> > function. Finally the arm64 mmu code can simply check for the flag before
> > calling __map_memblock. Perhaps it isn't that bad in the end?
> 
> It sounds like the right level of abstraction to me. But I'm not too
> familiar with this code, so it'd be good to hear from the MM and/or ARM
> maintainers what they think about this.
> 
> [...]
> > I had in mind to extend "shared-dma-pool" to handle
> > set_direct_map_invalid_noflush()/set_direct_map_default_noflush() based on an
> > option. But perhaps it is better to create another separate driver. And VPR
> > needing a specific dma-heap driver anyway, it could call the direct-map
> > functions there too without relying on CMA to do anything?
> 
> I think it'd be nice to have separate APIs for this case where we know
> the memory region is already page-granular (or, I suppose, PMD granular)
> and removing from (or adding back to) the linear mapping is safe. That
> way we could avoid the checks for can_set_direct_map() for each page.
> 
> It'd also be nice to have a version that can update the protection bits
> for a range of pages (would map directly to update_range_prot()) instead
> of having to manually iterate over each page in a range.
>

How about?

  /* True if can_set_direct_map() or [start, end) is mapped at PTE-level */
  can_set_direct_map_range(phys_addr_t start, phys_addr_t end); 

  /* Must check can_set_direct_map() or can_set_direct_map_range() first */
  __set_direct_map_invalid_noflush(phys_addr_t start, phys_addr_t end)
  __set_direct_map_default_noflush(phys_addr_t start, phys_addr_t end)

> A good middle-ground might be to have helpers that do the grunt work and
> they can then be called from VPR and the shared-dma-pool drivers to have
> pages removed from the linear mapping. VPR and similar can then perform
> the hardware protection bits on top of that.

I believe between the reserved-memory attribute to force the last-level mappings
and the direct map functions above, there's enough for the VPR driver?

-- 
Vincent

> 
> Thierry


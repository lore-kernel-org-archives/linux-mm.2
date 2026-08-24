Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911FEC61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01286B0096; Mon, 24 Aug 2026 09:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B17D6B0099; Mon, 24 Aug 2026 09:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C9B6B009B; Mon, 24 Aug 2026 09:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAED6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:07:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87B1DA1E5A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:07:32 +0000 (UTC)
X-FDA: 85136189544.24.C7F8C04
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id B018B40006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:07:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QPp2gxrz;
	spf=pass (imf27.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787576850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=II0EHdpiWVifHn+uIz31c6Jp5mdC3hunRFCnEAwNy/g=;
	b=Dib11GR4yl3TLTx8bcn/nhNNFRCPN21I5K/bOc5qYM2gEn4r8wg/NidZR7pOj/Ru5vQ1tB
	zesOm1r6rup0i/nx+NNuTCKvsg0PaZc9NEoqfQc3X+PRrNdcxARumEzn6bWXuyHM1Jl5yS
	cDdMsqC5P+VwUgAHppoV5hn9iZWw5tU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QPp2gxrz;
	spf=pass (imf27.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787576850;
	b=LYrUeH7P8XemChqq8EYNkT9GsfHQHLWWf5b7zj3lVjqlUcI5q+iJJ1NdTPvdfgImK3CghC
	8YXM8+ft4howegoVTPUSafsa2z/nLJ+L3NlJPrJhTNyIpVLije7AILIfrDApDqaWtEhkVH
	mjm8gYoP6Ol//ZnQPYiIaVHzYe5qbgc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso21663925e9.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787576849; x=1788181649; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=II0EHdpiWVifHn+uIz31c6Jp5mdC3hunRFCnEAwNy/g=;
        b=QPp2gxrz8PHSX7P4XglQN+0eKrU0YieyNYH4Nam7EbSv30DyPHRQgPzoDVGXaNkB3d
         kUeIsZGjSC8AHcJuHVLtlcgImabZH6Aje+w3Z2rGdPQchXizr6Q2CbRAdiTAboXk/tTB
         C40Z2gXd+nir7Gg+MGTDfljwpi1rrtHvYGffbHQD6vsB7Je2b6D2buZ3bU7FtUlTMCI6
         EYsABhQc5nu0nBwwIbj4lxq7fJSFPqFZbkfbdX7OQiEUV0rKUVh4lHwFdgy93QhUs/b4
         Kx6YW+7rYdE4mL7zOLxLCealbuMKTxyB9ZBPsl5P1WUAPftA/rbnfkRb0xckMBc3S+rn
         3UiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787576849; x=1788181649;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=II0EHdpiWVifHn+uIz31c6Jp5mdC3hunRFCnEAwNy/g=;
        b=bPkW/b3qTqJvuR8dQKCF5FQvaCg9Ndc17lXBPiA6BA7Bog6+YSAFhBDq6UbVpJpETW
         Lg9C6WP4QviSiF0K4suxTLSak7PWWrEWjj84aGNFTJXAgzQPECMJJqowMB9LDM5zscGG
         5CvhpnUNXNHI5Q9eAWCAZBjq+em+MPOgJdB9jwUiaYf5lpTtCVREFcJmgCZ/wS4TtI3N
         0tUeRW0Ayzc03SEMiU9Yxd+x7rmCiufUPaTXGeonVwajqUdabHdTMHKtqzLO1lYvKokZ
         UiumbjkSGAsM31iDODfkteexl4F6z8Mzl/fCpQvwmKXMoKbBIGWceMLplkfYyklBWHX+
         NrGA==
X-Forwarded-Encrypted: i=1; AHgh+RqNEWQoYIqQ6q4bK71lH21uhuIf2FY3G6iHqSAMnEoSVps4LmyrzK2OZCyt6VOPesbqFymv72Fstg==@kvack.org
X-Gm-Message-State: AFuF++k8SSh5TGL+A0Lcg5Uewe2VKrukdqTmK+w1rFCb88wvU5373sSs
	aufiHdDWG8ihFixF5NoGlL1a9bEIMCzmvFIc90oR9k+LtQpwuWncroUNDDcDV2P+HA==
X-Gm-Gg: AR+sD13zBp4HzRjVepCE2ihhXb6CuAPeAD0gVOm3ZDH/VkJizH9JcIX2AQb1wf+Y1nb
	E67j9cfeAjebIc7Sa8WXJ+9OZhvcVYOCEPbi+yDVzDhxvD0CfeoLcpkPCuLkP4Dh8hycn3E8BgY
	fjHeOyPcqrgghu7QT01NkvcB3eyAS1m1a9cIruJPdy492fYTT5BDhF1qEtOEfTsUJLgdqMywsai
	nKQip3z9RBCdmOuu5RBZMkIVzAYx/7v+jtJnqWAX+KLf2XAPy4PqO/dT+J5og7bSCQGOBvb6bEl
	g/c3oZFqnI+jKg767EXYhdLgkgtey7cidyyYQvmUdM3E+twak+YINaJk9O7EbU07p7cGgCmL12p
	jAwWH+O/i62ZqVDErkJVdcndgt21dTQzD4xY/BGulBaHPm2uTyJ7dpOKyS9oL10LDTDcc6UnQ6u
	pX0yxrf34ZGmLyodo4ZOux+7KTVgp1II5mOJlrIpcJ7NNd4Sr7xGbhpkNBpT5u/Debdiir06fhD
	sdWqShTziIZvGrGMC/ZnHWAwI7q07An
X-Received: by 2002:a05:600c:8b76:b0:499:8c68:a3aa with SMTP id 5b1f17b1804b1-499b8475133mr350361245e9.13.1787576848494;
        Mon, 24 Aug 2026 06:07:28 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499c355e1ddsm85389525e9.5.2026.08.24.06.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:07:27 -0700 (PDT)
Date: Mon, 24 Aug 2026 14:07:23 +0100
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
Message-ID: <aoxCC1yPFdutU5vB@google.com>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-7-5510d16af89e@nvidia.com>
 <an4MEI7lkc2p3nKI@google.com>
 <an8K2gb1pIqbDj6-@orome>
 <aoNDRTKCUkzd2n5G@google.com>
 <aoQ1lhZojzsSkWHQ@orome>
 <aoVy8dj8f3ll5-M4@google.com>
 <aobOs0ZidWzgoHut@orome>
 <aoi4wZJIutMWu9Ux@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoi4wZJIutMWu9Ux@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B018B40006
X-Stat-Signature: td1sog6z6hx1jnfekc468aa397znn9e7
X-Rspam-User: 
X-HE-Tag: 1787576850-615556
X-HE-Meta: U2FsdGVkX18MEajD2iQgyaELR/lDgcXwuLXJ2GPybcVzC2Urt7UoXnztoXeYsqNgMxYh8U/nqaJK0c8tRtJ7bUhFm15zoUx9l0KkmTd+YlBwV36RKtBmrWtuoVYnTopSpFsC7E5lewyJ5ke+UUz7Fcgcl7LuRGr5qdcFVWuKjnNwmnu/Dz4S6EdYERd4LG6MC+pufrs28PZqqMOt2QH/4wuIticg2QbgTsC4Oya7MuxvF+oqCToSXkhaLBTXLcVe8ZYJxPMEXHIKSW/+KZ58jJat4bPRvJcTfv7CtgOn+g04D/VyEgA48aOAQ6ByHpbYpoENHpZHHgq6yzsXZxBRoCG9/zEgcnU+htatqesJm/wiU7C0bq3uJaoXWxDALuTYsEGFeX3QXtY0zQ14F3iEaJKweKAaTD/dJuoB68xG9IqnUCMdgI7XeQTbLkWyMfVWCGoWvm2feBAxMmgMi+mEN+mYM/iPPl5aMXLAbD9OSbSGrOricH8WuCv6sPxpbgKsNFgZgXeSGD+oofYeSjOUUrHNJJJQRKiJl6vgYB/6P9xYKYQ8/5Ve/1BDbJpBp7sNvt4K+Kn9ZDNl1qow8m0HY5H9MOY3Lz5JAh8AJ8cLzG2gO3YdWlEi8fAewAY8jKhF9nVxk//UeiEUw7p+6ntASAhtCiZ1E9T3/J4Zfzy3QhdD5T3DyL0mW+xjqrsq9B7u465QmaJrSYBeeWAbyPqBrkHHYNpBB3bw42CijukkRugiINYT/ODJJtXxb+2Ar9/TgPpC5XxO7sEQjcqu6r2UQxcxCIq8E5SYHskA9UL3e6JNTheKgWGm0yuFxxi0XnYuf01XTEiUm+D3wyHv4BOfzkrXD24gqsp5NIaRLQ5+wrob4Ab5hCfL6bXxcILYWZgT8LlaerzPFrFtgeqCS4NXiuPrfQHF9/6SGn79cPo9hx3C9NXVvQK0Y4GJPkVovapC4y/1+iRkqOWEksE/xGd
 TLzy/qiE
 QsBBijdYBwYbjS4UK5XiUav3WwcuwfRMsw2uNUc+GAGTEw2TMbDgQRsDEA5UgqaTAmzGdvn6XfC6Cl6VhDQzNYHbZND9BH9dWR6u+jXezj6FpRHslUT7hg/zmbeoE3/wtx9Rq9WAjhdy9fAzxyDWdrwlyhN3ETOQql6nJLcKKlyjM+OuuAPIhwDR10TgHxlLrPANHC/B+8/hL9GYaJFgnI6AoYslXyMu3B5O7Ibz+0Md3t2xri5sFv5c6AYHitrUyA6Z/5Hp+dUaps5kHQofzDWqMFE4jO3+SrnCYv3juBixQhmglRtYsU/iXUwE++3AdKBoVQrtLk/hM+DzxX1x8qSGGlkr2kAEJ8o+lhAd2o6jDkU0VANmnv9hShoxwCzMwDUZyv420oI+1IUNBc2yMj/jv2AS7kwXP+1XCxV4fOI9mCrAoHd1ZRhYJ01EmTT77HnAjdf5R8xlrPOR2DURxB5jS3f7NrJYITZTsvR+zEV5ZQm4XNpD0uWJTXYigAQSF3ltScgP8U0itxBTYlWeur+ntCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:44:49PM +0100, Vincent Donnefort wrote:
> [...]
> 
> > > > Interesting. I had been thinking more along the lines of adding this
> > > > directly into memblock using a new entry in enum memblock_flags. None of
> > > > the existing ones seem to do what we need here, though some are closely
> > > > related. MEMBLOCK_SECURE or MEMBLOCK_PROTECTED are quite specific and
> > > > don't necessarily mean that we need the mapping to be page-granular, so
> > > > MEMBLOCK_PAGE_GRANULAR is perhaps clearer.
> > > 
> > > I thought it would be interesting to not have to modify memblock since it is
> > > used for all architectures, while the DT is at least slightly less widespread.
> > 
> > This isn't something that is DT specific. On the Tegra side, I suspect
> > we might need this on ACPI platforms eventually, too. And it's not an
> > ARM specific feature either. Other platforms could use shared carveouts,
> > too.
> 
> Agreed, and actually I have tried the memblock version and it looks quite neat!
> 
> I will share what I have after the merge-window.
> 
> > 
> > > Also, cma_init_reserved_mem() could use an order 9. In that case PTE-level isn't
> > > necessary and we could just use PMD-level. Extending that support would be more
> > > cumbersome with a memblock flag than with a callback.
> > > 
> > > rmem_cma_setup() hardcoding an order 0, perhaps this isn't really a problem at
> > > the moment?
> > 
> > How so? memblock is really just used as a way of backing the CMA. How
> > CMA subdivides it doesn't really matter, right?
> > 
> > Or are you suggesting that if we use an entire PMD as granularity, we
> > could equally well remove the entire PMD from the linear mapping instead
> > of doing it page-by-page? I think that'd work really well for at least
> > VPR, since it is 1 MiB aligned anyway. Using a granularity of 2 MiB is
> > easily doable.
> 
> Yes, that is what I meant. We could easily force a PMD-level mapping instead of
> PTE-level one. But then that means declaring another memblock flag. 
> 
> > 
> > For anything that doesn't require a single contiguous area to be
> > protected this might be a bit more challenging since it potentially
> > wastes a lot of memory. On the other hand, a lot of this is heavily
> > custom code anyway, so the entire stack could be modified to make
> > efficient use of this (i.e. userspace could allocate a larger chunk
> > for a pool of buffers, etc.).
> > 
> > > But yeah, the alternative is to create a "memblock_mark_forcepte" (it seems
> > > memblock_setclr_flag does split memblocks) and let of_reserved_mem call that
> > > function. Finally the arm64 mmu code can simply check for the flag before
> > > calling __map_memblock. Perhaps it isn't that bad in the end?
> > 
> > It sounds like the right level of abstraction to me. But I'm not too
> > familiar with this code, so it'd be good to hear from the MM and/or ARM
> > maintainers what they think about this.
> > 
> > [...]
> > > I had in mind to extend "shared-dma-pool" to handle
> > > set_direct_map_invalid_noflush()/set_direct_map_default_noflush() based on an
> > > option. But perhaps it is better to create another separate driver. And VPR
> > > needing a specific dma-heap driver anyway, it could call the direct-map
> > > functions there too without relying on CMA to do anything?
> > 
> > I think it'd be nice to have separate APIs for this case where we know
> > the memory region is already page-granular (or, I suppose, PMD granular)
> > and removing from (or adding back to) the linear mapping is safe. That
> > way we could avoid the checks for can_set_direct_map() for each page.
> > 
> > It'd also be nice to have a version that can update the protection bits
> > for a range of pages (would map directly to update_range_prot()) instead
> > of having to manually iterate over each page in a range.
> >
> 
> How about?
> 
>   /* True if can_set_direct_map() or [start, end) is mapped at PTE-level */
>   can_set_direct_map_range(phys_addr_t start, phys_addr_t end); 
> 
>   /* Must check can_set_direct_map() or can_set_direct_map_range() first */
>   __set_direct_map_invalid_noflush(phys_addr_t start, phys_addr_t end)
>   __set_direct_map_default_noflush(phys_addr_t start, phys_addr_t end)
> 
> > A good middle-ground might be to have helpers that do the grunt work and
> > they can then be called from VPR and the shared-dma-pool drivers to have
> > pages removed from the linear mapping. VPR and similar can then perform
> > the hardware protection bits on top of that.
> 
> I believe between the reserved-memory attribute to force the last-level mappings
> and the direct map functions above, there's enough for the VPR driver?
> 
> -- 
> Vincent
> 
> > 
> > Thierry

I have pushed a first version here [1]. I am waiting for the merge window to end
before posting anything on the list, but let me know if you have any comment.

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/vdonnefort/ffa-lend-pool

-- 
Vincent


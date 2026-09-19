Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D30C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB3F6B0099; Sat, 19 Sep 2026 03:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354E56B009D; Sat, 19 Sep 2026 03:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F986B009F; Sat, 19 Sep 2026 03:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7C8A6B0099
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:11:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 338A2140193
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:11:38 +0000 (UTC)
X-FDA: 85229641476.04.449EA04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84FF5C0005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:11:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4W1bQei;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789801896;
	b=fOzNCUIJ4Nb8+vSrcnXR+EyKNaENmZwGl9UL1WZaJBsJ5cTQx64ruiJUW2amWPHsY8Iyeg
	lPlmBE0A7Ftfjextv0WgAJScFGfvtGMljICxcz2sVk/0IVPSkRPqI00fp0gWCXcHrWAdOr
	O/bq+17KOHZuAt5mFYXmVO1MIqFke6M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4W1bQei;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789801896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEP94n9v3wLAo85N51UgdrheAoXFz2CprleV4BZJMM8=;
	b=wkTZ/Q9OFUWbO+cZYc8S6k5U7denSWdiF+rJIG7gT9oamgI2WtU1J47kBt/CZMs4CTOGbt
	ho7eBJ49hEtAoB/Pj5qtqsx6k+1KlmBa+el3sPMc8aQHkkXKJWbd2tMv41SrANG4dHEKlN
	4v5wWFv4RSKirXgckq/uXFpMG+KsqbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD9CD402DD;
	Sat, 19 Sep 2026 07:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3261F000FF;
	Sat, 19 Sep 2026 07:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789801895;
	bh=bEP94n9v3wLAo85N51UgdrheAoXFz2CprleV4BZJMM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F4W1bQei0WbJqW4r8EVplbGGhiwx7NXzD9fjTAJz1nnroqL5YVOgqQUiArkdtmHyr
	 W9CUxLppulp2QWgWTUWbd/dAehRrSW/lkzZ8oqUe3f2GoaBZ9mxErL6fLMqXM7hUoW
	 pflbnHmqkcZuRmlsQGGEHcLyopvAXc13ZfvUKI6JKD4iUk+a26j861qNbyRs7NwWAe
	 5rxSiPFeIPanXD5TpncL4/J1QB4XlrZSZXGeFurkupyx3dvKksXmU0uWgTWfiWByEt
	 kIY5KOkGCC+OaHU6gMgpAmJdMdOpQb8sI62v9yK0E5VZLKYJBnSZK7nFcRXx41rwCe
	 CYxurd2l460hw==
Date: Sat, 19 Sep 2026 10:11:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Wandun Chen <chenwandun1@gmail.com>, catalin.marinas@arm.com,
	will@kernel.org, chenhuacai@kernel.org, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, robh@kernel.org, saravanak@kernel.org,
	akpm@linux-foundation.org, pasha.tatashin@soleen.com,
	pratyush@kernel.org, m.szyprowski@samsung.com, mark.rutland@arm.com,
	kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
Message-ID: <aq41nFRPtRWTQ7cK@kernel.org>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-7-chenwandun1@gmail.com>
 <aqzxavL91icLw-Xv@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqzxavL91icLw-Xv@fedora>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84FF5C0005
X-Rspam-User: 
X-Stat-Signature: kdir7mmksuuiudpssedjpuj4y5fhy9hc
X-HE-Tag: 1789801896-649572
X-HE-Meta: U2FsdGVkX1/enafsilKgVk1uyD+lXVK3bLTbCBzM3uBWvH9KbwDtegSnb1V6CzTlLzOljrI7SYb4MUG4osf3SznZ3l2N+ZA67qv7yJH0qN51DnnITOLgfeTclXbRIHDX5eJHsrZbS7cki6S8WIuZGw1KUzV3WGzmHvs5GJ3vRYHwCwqNW+fXTibw8DAWQmIfc4WRk/8qJTMiPnjrHcwMN7J5nFicsp58RmnyoTgXVQx6tPX+EJvipAjwSuNmo9HsQon2MG+bUhgeVIX5bxV6O/K/BgBoWsUYdA0FhKBTejgGAQKnDOw+u0OmOdNCxyDXLMvbrOYm7Iwa18uKibHkRnfh3sUkZkXX+I4iYOwXVUTrmCwyELaMdGPRIB85lxXWOOo+7q0CbiOABykuxsvoIP+9TMBWHkeWBpF5g2GxpuOuFLNz4O86W44fUu3xBv+zhygLUjGFR7i8YNUl2kLMtjP7FkpT4JT0jwMhaPrRSQEFy/UoBUZucgrRWhrjJq4MJVE1+aCE8Lp9EISKiCqQEKx8x3DxA6ENqHSa9Q5T3Go9dEfyBkKeps1d6cw33cCPQ9BRvC2S60x2rKpdiR7L/bvhhwevbmYoA8AJigRziR2zWYUtLWCCbEcJvGVHBY9fQC2GDsNew5pBQo+ZMnFeFP+z4GsLnqGoivPVR1jytfbzZjITdEvjWy6ONIIXF5jVwcbZKR/kiS3UMUIFiMx+/CI0d9C7IB3uGZDvqPlsj4sdEWjpGdu1Bg1OwnaWuyJSMCAiwYzU1AplDkH4RDH6RfH9juu5HQjoEr8dlyUZZ5L0TeV0vOj5E5fp8DCquQb5BFzGwiLFoYHdcKrybOAEuSn40WlN7KmL6ylfcqPezQmrunUzkVl6YUs14oJwymeG/IvdBzIe65491TbOlA5rGds5390/YnERnQkWTyx4xGbW44IkhFwt6moQDH9DWmi7fkzbgHf8c/fFi5+ecfH
 sbB3PU8N
 rARqYYWDXxTE460FvZKawY3hQixCjTYIXelYlTVGgfp3uZf8Gb94E6yNZxNnpemKpDYEfcDRxaEyOejAFENkSoNvm0kR02pagv85eUtFt+4SfOXSD4ccul/F7ko5JKePjcTnEKiIjPf/nhIsXGNjq5pVPuvrBBvGht0M5u0zIuZ7igbl5s70chSQnHmg4bA8+/ieQ7izBCq/XFlgd6ykqLVidovWt8qrc5aqnFww5Mlb/pBPt1AIvxklpSoEsIxgnwADICrUVUIoV5BLqyPoELhWBsREnysmNiCJaDP4EauQhtkoSwcN915E/4/GTh/jUrcvShfAoNKYhBpHRJnZpjfoJcFXAGx3NJ7lgUpyTBg6uAWMhQF0gyOf3D9T1zD5iTPMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 04:08:10PM +0800, Baoquan He wrote:
> On 09/02/26 at 03:31pm, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> > 
> > Add MEMBLOCK_NODUMP to mark regions that should be excluded from
> > kdump vmcores.
> > 
> > The flag is meant for reserved memory that carries no data useful for
> > crash analysis. Reusable reserved regions such as CMA may hold useful
> > data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
> > patches wire this up for /reserved-memory and /memreserve/ entries.
> > 
> > Suggested-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> > Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> > ---
> >  include/linux/memblock.h |  9 +++++++++
> >  mm/memblock.c            | 16 ++++++++++++++++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index d62db9e776cf..b2fcf11fba2b 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
> >   * kernel that we know is good to use. It is the only memory that
> >   * allocations may happen from in this phase.
> >   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
> > + * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
> > + * for crash analysis (e.g. firmware carveouts).
> >   */
> >  enum memblock_flags {
> >  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> > @@ -63,6 +65,7 @@ enum memblock_flags {
> >  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
> >  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
> >  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
> > +	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
> >  };
> >  
> >  /**
> > @@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
> >  int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
> >  int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
> >  int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
> > +int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
> >  
> >  void memblock_free(void *ptr, size_t size);
> >  void reset_all_zones_managed_pages(void);
> > @@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
> >  	return m->flags & MEMBLOCK_KHO_SCRATCH;
> >  }
> >  
> > +static inline bool memblock_is_nodump(struct memblock_region *m)
> > +{
> > +	return m->flags & MEMBLOCK_NODUMP;
> > +}
> > +
> >  int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
> >  			    unsigned long  *end_pfn);
> >  void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index f2952d725c10..2e87f39826dd 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
> >  				    MEMBLOCK_KHO_SCRATCH);
> >  }
> >  
> > +/**
> > + * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
> > + * @base: the base phys addr of the region
> > + * @size: the size of the region
> > + *
> > + * Mark the region as not to be included in crash dumps.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
>       ~~~~~~~~~~~~~~^
> Is it impossible to use at runtime even thought it claims to be generic?

This should only happen at boot.

Allowing modifications of memblock properties in runtime is a can of worms
I don't want to open.
 
> > +{
> > +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> > +				    MEMBLOCK_NODUMP);
> > +}
> > +
> >  static bool should_skip_region(struct memblock_type *type,
> >  			       struct memblock_region *m,
> >  			       int nid, int flags)
> > @@ -2887,6 +2902,7 @@ static const char * const flagname[] = {
> >  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
> >  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> >  	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
> > +	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
> >  };
> >  
> >  static int memblock_debug_show(struct seq_file *m, void *private)
> > -- 
> > 2.43.0
> > 

-- 
Sincerely yours,
Mike.


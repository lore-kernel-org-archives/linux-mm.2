Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D06DCA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 12:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2848E0005; Sun, 31 Aug 2025 08:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6532C8E0001; Sun, 31 Aug 2025 08:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590418E0005; Sun, 31 Aug 2025 08:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 482B98E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 08:12:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C05C485567
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 12:12:29 +0000 (UTC)
X-FDA: 83836940418.26.9D430D2
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCA0B20007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 12:12:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NFKVPkCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756642347; a=rsa-sha256;
	cv=none;
	b=aYBibwxo3nvnxhu0unuD47uIACGwijaSUinL94dRigFYvCD4cqvZrhv0TpN+rsFep7swrO
	6J2dLvJptO/+qpKdlJjaDY12Q8ZC8h+p5VUXIeAUTgVTkBmhBI0Ezs4DIEIkVW7g6hI3no
	gfcBNmb1AApsnBxUYeIZkIrllGD2dR0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NFKVPkCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756642347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/dhVZcd5Nyq2shVbKIb+s/eIzus38d+RCiUMAwTO2M=;
	b=7G9qTjUfTZ8WEuQZohOtbt4/Jv3cz11I1KFXrzxXdRJFDEB9tqrDYv/YOmfhSKQXABbbJC
	wrVZH7TByHYBIBhepi+BakZaXhj8y6K+w4Krxgp7L0D8hzKPJ5Sbt8kjJ3MM8DKa7RPVPu
	eTtdt/4z/r2lQo8cWax/SkuLzNR6JxM=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55f72452a8eso985656e87.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756642346; x=1757247146; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u/dhVZcd5Nyq2shVbKIb+s/eIzus38d+RCiUMAwTO2M=;
        b=NFKVPkCvNG4r6sszL2Cgx+DUrddypsyXHoCll07aj4E+4ztxY2uOiyh09lT7IIFZ4t
         tDGWV2rrTUZ1+RIe+udllV77Ud6FWy61llDh7u24dazl9q45wllFbzOlAIsJbvXYvdF6
         z28jbLDyCI6OB2kMWPjR8AaB5BbUvVHrEC6eQql7ahg71SAcjfq2u8PX09HKkcH5fDgs
         vdxkMd8+Q7NsfE7ZupAuUHigQ8tPguUpDiVpu7O0n2KW3eHnu3UGUJmBd4QD/b2eChsM
         WlebtZHqZW04kNIKPxBbCHH4UuXVD11eEPCBo6pHv+ccntZRPqvfHTWAcAK3KrH4uB/s
         wjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756642346; x=1757247146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/dhVZcd5Nyq2shVbKIb+s/eIzus38d+RCiUMAwTO2M=;
        b=oGzaPtFJA7xPFoKU48xytVQ7mt8jA8+RHRsAv3pw6qii96j6XWyHoOCfF9uBLHiVG5
         74RMfOswaqol4yn1zdj1y9gFAY09VYkguib2+pURJufgrcciWCurzv5tokf/VfR9VXpT
         9zAiuVxxgYiszfg3VAk69lROBqztLXZWUUnZ9sT1kQQg1DLd+0wQ9/FMDIEj0cqlckWh
         De3KT/T0tistnPzsrWAidY/BXBOjmAq8rSG6oHXZ8tKlWkYpmPlAbJ7H+RMKim1kDovO
         EdJIz56YaKWehfk6+fp2fYwtBgx54s/MzzD722c/8t94cowk6kKF79ybJL3DGhAeiPvo
         FwWg==
X-Gm-Message-State: AOJu0Yy6+HSWwSf51k8ltalM3RYP9QDydZvCEUdQMb0zID//tSxk2qz9
	HfiDRAMfyzX/6t5NVaXT6NRFGwpDsXp/BMjMi/kAhjpIenT2MXG33goC
X-Gm-Gg: ASbGncv0A+sfxqKX6zgK2Mr6jCkNADi/2cQcA4D/nXlt2K1k/FXVFJ30WzuB6wt6O8V
	74Wd69JiIDeV4hbxr+z/xK1WA85Xn4yfq2qdQdMFpwQKuaWDwt1Vka2VDGCP/Ax9tfvtIa/2IXF
	PveED3KDAaWldk7o9DFPLK/ysog9GYeoDzU6vBjk13YLbHLV9MkkNwd/5GtUn4IPUdGsStOJvv6
	htL35JAWp9vB8JeyEe+j+8VPn1twMRuE5bbaXM106M1fOXNu6GdT1mMJGzWwRJmOLO0G/tJN3yB
	a1mDDSbXBxzuTmcfGga7c0L5nsyLm3hykpjkEYCAesJgp0F8GVZpLglG2OixqrwKMVim94da+f0
	=
X-Google-Smtp-Source: AGHT+IFOytm83B/8ww/DzxvWe7BVJbvgNih+SZzMyJNZPQenqFi+Eh46FMc/u1wMcgfRczNvRPmZsA==
X-Received: by 2002:a05:6512:6512:b0:55f:6aa7:c09 with SMTP id 2adb3069b0e04-55f7095524cmr870310e87.44.1756642345779;
        Sun, 31 Aug 2025 05:12:25 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f676dc1d4sm2174032e87.22.2025.08.31.05.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 05:12:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sun, 31 Aug 2025 14:12:23 +0200
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
Message-ID: <aLQ8J2vuYi2POPsE@pc636>
References: <20250831121058.92971-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831121058.92971-1-urezki@gmail.com>
X-Rspamd-Queue-Id: CCA0B20007
X-Stat-Signature: ao3ng9p8ge5sjucyh18hqxcemeiobp5a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756642347-436874
X-HE-Meta: U2FsdGVkX19qIStk4nnOyoQQNo190w8yO7hQnVSYYQsvDXrrID6Vd4AInRxDQsAxPc4EBLj4n1c5QsPFs2ckXSCyiC2dGY1GZCA//U2PfYEagNSvmNXtLPQ5x6+mYdxpiK9dr4JoINwuY69ijmUzRPtI4yDL+rZEgM9WTbwdVcgOjVR3kb90lir36msvtoUCMKdcDIpUpq/RcKHpwxsbyg9du4bChzTvfF9BZWIJaPiyMk2BGc2CxpCpwksDwPQCMW2vz1hPbPIg1YQCVpLAk6cR9UycjPJG+1dShmBrbIPf999LjPahTTYk5pMn5dBJXv31B1Yckl8kvsWkfZbiN4dHkoChu9174Hl+GphXkpOm6/Q+M9AAjLKxG45oZj0Ps0vewRSPhyaXDUjlbDbWUXe9qFjBcc9FT5aSNCuMpQ78yjAfl/oyjLN5iO9QSm7NKNpICpi0MCRW8UdRL5Zm28EHzDHWCIUq+vTDavrYVxXZgjgH6r5ob5I0UH4sVuluADgjVFAVuJCEzs3YJBRpeSYmvIcXYbIqyHM0rYDPYL0lIDxU4Yo2Ml2RU5qy36zuc+MP1eSuXOXqtsohImiczPfNODZpT2w8TSOgTKZ5SDKkiL9tVed5qt1XtrB2MbPSiV3qW2zW4RCnThn1eu6tDHSWFBFmLD3hq+7FDX6+YsfEvTtzG3FNoZVQkBv11JsYgFME3PwROg5EDVMlhyMzfWAVCq3nugy9HKVTDmEzctDL/aRlePFj3Mk/k8zMMjrMbdG9SszS0uscavW3qMYY1TmNcSi9VSvcnivNXKq0NOEbHCcGt+aEfcW/s8rxcP1hIk8L+0xy79QkyXcTsC4YClCqaWXJ8F/Elq0P/OVOqN+/0JTQCM5XLRZvSCIHEY/UT6zqc13dSEF59EyL1Zrm1pSM2OO2BE69Lr61B7j28qx6J2R+/a2pzlCUHhfZtadaV6msNj7mEOsr21QlbnR
 vs6zvUQF
 34YYuCPSSkDmNZ148BT+irfr+yj5Vt52GUZnDr9FeEesSBgokWbnOPBQvJVVWU9gLfjXmtu7e8VGu3Fk0rKeuLv85IZH6dexqhrFWjVMi4lcwkpaFnYaN6TCTcbBXkmTtbcx7WuMdL5jUS7vvtjN84Pl4jCZjpRtxC2Gcmt6i2lotR6nxUnUysJoVlhETfCNk50xz6ELnelfUHW9w0vprteabugVagyCeTajzO4eZczTTrnGxPuY3wU4yyJIFmpAPjJGmOpuaMlQFoDmXlle10a1T91AoxBVwlogwA7cipOG4mc4F5RUs8FnudRfEgslIMZNbkXjgBBvuHWsA77VaJVUz8q0V8epb8hMjrImShSfL+dMX5Ib3/fHC5cGBois8CQeEFZoOI3xbqpYh2zHIfyyp/nejN2USXLQL2mJU1wS4S2wbY9jgonQy2qLl97kfdsV8FRjhSj1ZalyQDB6gVigi9RR1WdJRLBl6imllBbIiSXLAFvVIaw8PLvN/T/A0E0NSTWKAHJ+HVk44XBkPjGHIzChnC97U40XDWNirgyADki/IDO2UJK893nWyN5jAzGntaRan9aH+AgR5XcgmdqlHEl2BQZMl+hlY2bYB15Gp3r1PiZGZxOhoJiv68YUKdZg5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 02:10:58PM +0200, Uladzislau Rezki (Sony) wrote:
> kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> and always allocate memory using the hardcoded GFP_KERNEL flag. This
> makes them inconsistent with vmalloc(), which was recently extended to
> support GFP_NOFS and GFP_NOIO allocations.
> 
> Page table allocations performed during shadow population also ignore
> the external gfp_mask. To preserve the intended semantics of GFP_NOFS
> and GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
> memalloc scope.
> 
> This patch:
>  - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
>  - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
>  - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
>    around apply_to_page_range();
>  - Updates vmalloc.c and percpu allocator call sites accordingly.
> 
> To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  include/linux/kasan.h |  6 +++---
>  mm/kasan/shadow.c     | 31 ++++++++++++++++++++++++-------
>  mm/vmalloc.c          |  8 ++++----
>  3 files changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..fe5ce9215821 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -562,7 +562,7 @@ static inline void kasan_init_hw_tags(void) { }
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  
>  void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
> -int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
> +int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
>  void kasan_release_vmalloc(unsigned long start, unsigned long end,
>  			   unsigned long free_region_start,
>  			   unsigned long free_region_end,
> @@ -574,7 +574,7 @@ static inline void kasan_populate_early_vm_area_shadow(void *start,
>  						       unsigned long size)
>  { }
>  static inline int kasan_populate_vmalloc(unsigned long start,
> -					unsigned long size)
> +					unsigned long size, gfp_t gfp_mask)
>  {
>  	return 0;
>  }
> @@ -610,7 +610,7 @@ static __always_inline void kasan_poison_vmalloc(const void *start,
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
>  						       unsigned long size) { }
>  static inline int kasan_populate_vmalloc(unsigned long start,
> -					unsigned long size)
> +					unsigned long size, gfp_t gfp_mask)
>  {
>  	return 0;
>  }
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index d2c70cd2afb1..c7c0be119173 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -335,13 +335,13 @@ static void ___free_pages_bulk(struct page **pages, int nr_pages)
>  	}
>  }
>  
> -static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
> +static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
>  {
>  	unsigned long nr_populated, nr_total = nr_pages;
>  	struct page **page_array = pages;
>  
>  	while (nr_pages) {
> -		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
> +		nr_populated = alloc_pages_bulk(gfp_mask, nr_pages, pages);
>  		if (!nr_populated) {
>  			___free_pages_bulk(page_array, nr_total - nr_pages);
>  			return -ENOMEM;
> @@ -353,25 +353,42 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
>  	return 0;
>  }
>  
> -static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
> +static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
>  {
>  	unsigned long nr_pages, nr_total = PFN_UP(end - start);
>  	struct vmalloc_populate_data data;
> +	unsigned int flags;
>  	int ret = 0;
>  
> -	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> +	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
>  	if (!data.pages)
>  		return -ENOMEM;
>  
>  	while (nr_total) {
>  		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
> -		ret = ___alloc_pages_bulk(data.pages, nr_pages);
> +		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
>  		if (ret)
>  			break;
>  
>  		data.start = start;
> +
> +		/*
> +		 * page tables allocations ignore external gfp mask, enforce it
> +		 * by the scope API
> +		 */
> +		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> +			flags = memalloc_nofs_save();
> +		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> +			flags = memalloc_noio_save();
> +
>  		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
>  					  kasan_populate_vmalloc_pte, &data);
> +
> +		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> +			memalloc_nofs_restore(flags);
> +		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> +			memalloc_noio_restore(flags);
> +
>  		___free_pages_bulk(data.pages, nr_pages);
>  		if (ret)
>  			break;
> @@ -385,7 +402,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
>  	return ret;
>  }
>  
> -int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
> +int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
>  {
>  	unsigned long shadow_start, shadow_end;
>  	int ret;
> @@ -414,7 +431,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
>  	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
>  	shadow_end = PAGE_ALIGN(shadow_end);
>  
> -	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
> +	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
>  	if (ret)
>  		return ret;
>  
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6dbcdceecae1..5edd536ba9d2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2026,6 +2026,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	if (unlikely(!vmap_initialized))
>  		return ERR_PTR(-EBUSY);
>  
> +	/* Only reclaim behaviour flags are relevant. */
> +	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
>  	might_sleep();
>  
>  	/*
> @@ -2038,8 +2040,6 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	 */
>  	va = node_alloc(size, align, vstart, vend, &addr, &vn_id);
>  	if (!va) {
> -		gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
> -
>  		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
>  		if (unlikely(!va))
>  			return ERR_PTR(-ENOMEM);
> @@ -2089,7 +2089,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	BUG_ON(va->va_start < vstart);
>  	BUG_ON(va->va_end > vend);
>  
> -	ret = kasan_populate_vmalloc(addr, size);
> +	ret = kasan_populate_vmalloc(addr, size, gfp_mask);
>  	if (ret) {
>  		free_vmap_area(va);
>  		return ERR_PTR(ret);
> @@ -4826,7 +4826,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  
>  	/* populate the kasan shadow space */
>  	for (area = 0; area < nr_vms; area++) {
> -		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area]))
> +		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
>  			goto err_free_shadow;
>  	}
>  
> -- 
> 2.47.2
> 
+ Andrey Ryabinin <ryabinin.a.a@gmail.com>

--
Uladzislau Rezki


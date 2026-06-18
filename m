Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BEECD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E811C6B0093; Thu, 18 Jun 2026 13:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57FD6B0095; Thu, 18 Jun 2026 13:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E556B0099; Thu, 18 Jun 2026 13:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98C436B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:11:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4143C0A7E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:11:45 +0000 (UTC)
X-FDA: 84893675370.24.907E316
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id D0E6240007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=B13nrhzT;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781802704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDK5L98Pl00zZKxGb19xeAnhkIpTd5oohYUbmAno6OU=;
	b=g7zI6mcmdvrBqu+jhQT5EhIS9H/6BmOTSmtON9FGQ+solYr1uSFxFHkPng6A1KQK2HtiLe
	yVMcGLRXzE66/N318LKG2BXdxisMGxWdo4zkCm8gDk4BSXtOUsyOPc8hfBU2gWdO5eETqw
	VTBEqC6nim21KzWWSUj/BOZLpUzSQig=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=B13nrhzT;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781802704;
	b=YXNuPkLZ4UD+a1mTPzu7jb1fy+YCv7d9nQi1ytgsTfYVSa2lKCd8LIc+3RF9Q0WXRTqdel
	ko4uWICRzDUk3XvgXjwTZ7v7Om1nfQ/xArtn1qTeKpQw5RYouKvmg4iEefu9AVipIR8T59
	N6ecRdX+iA0J1kSAJqg2tvTq1fFJNho=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4629051c946so1026364f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781802702; x=1782407502; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDK5L98Pl00zZKxGb19xeAnhkIpTd5oohYUbmAno6OU=;
        b=B13nrhzTaoOj1BuI4m+B/KjTTZm/0dt20zrH+9DzY95HqQbNamLv+vs0tcudn2Fdw6
         LwcvyBjmIw4K9XirdfD2GDQzW5XexaGyUgo41YbQ2MgzGpLPicPsEP3lRhOY49P4i83H
         i+cskQ7ewvHNbsj4L4iimIAqobBSvH4EZtukJi67Eisy4wbbYKY+VfLlwuy3aCYjn4Qk
         v7MkagzwpZCdr64T1AEa1LDnPAI9VVsvSOB9GnBT+TvLT6LculWZEVOoHziZ7X8ZP9n3
         SHrdhhZTxXif3/P3I/baKP80yO92zTv5ETyQuAHreBpkQuOd3T8yxmlUezGEuBGJg/fc
         qcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781802702; x=1782407502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDK5L98Pl00zZKxGb19xeAnhkIpTd5oohYUbmAno6OU=;
        b=lEPfFmz8toCxvidcW0lqAG9CBj0Ln1oSgYSZQw7L/03+38syyXuy8gfTEtZubGLDRI
         qbgKH7NYFdY/wIOR8Z4zbzn7nW8IYVfwkb4mXmFpiUazKF9TJTCAcy2F1If8rgM8wqCn
         MGLtC08HCzkza/yJHvIzwWm7o8PP79H35NtpYMsjWQtwZSAT6SsZQYnKyQ9nBndaaKAd
         LkpHSrSReQmBOVDGqLokqxJr0xMFvnuhgNE2vwi0gFWnUYhUjEzMROH2A8EsI2JsN/dO
         hsmqEe0O0bF7EdyUMpToab9PnoUuu0fXFd7GI738e/OO88oZOO+F8F7fpCf9Sie1ITcI
         qGYg==
X-Forwarded-Encrypted: i=1; AFNElJ9U2lKJszJEASmA+gqdZUwAbp7o9g0VwrjVo8//xsZ7tsFmADS+4D4W+C+fScNEYNPSo6eTAWqtGA==@kvack.org
X-Gm-Message-State: AOJu0YyizgsXJMb2FWpH13VVzK/9JB3kdc4fYuRsv0ACEREnhoOyAr9W
	5Xdp84xtGic0h6lSEMFKPxj9R966F44558u/TPTRx4wK+RwkuWCylRwlD8c4ac13H/E=
X-Gm-Gg: AfdE7cnPQM4BHseWi1/inJ3q7owBjdYbkH8cV80c+ItEzBQGhlBSVOhoESXqIIgxeRn
	TgGNQ1UaY6SJZbjYVxJ+ABdSxP0LPizEiIIAxT2S/k4cl0KgKwDlr+6PmI+A2L2E/YMuWr1x+ss
	1LHtJg9Tcila6aeZUy2LuNKrQws5juee3jfmVmF5Pvpz6plAGFKa5u7mnIJXncWJn9sc+jsuPIx
	5JvZtvRZK+QVKpE7vhiQEu0MJBndImCq2XZHduxeUQ8obWkUG89U0W07eEKU4KKruZOWVZKivqC
	jEt87c3MCgcisanNXkFTXXK4siurQ3iqjt4ykxguc+KibRL8qE0IDP7s7ecHIGHU8ib+D2sVhUU
	momnpTHWob5aPaqVU5d7MufXYvAf6gS9Wuv7le4CQGSsdKYUVVk7KNInnnQ7FwdiJEzwfY+ImJV
	yuAI6Yv+ac2WxUi3I92DlXyMTsYA==
X-Received: by 2002:a05:6000:d05:b0:45a:5392:3a19 with SMTP id ffacd0b85a97d-4639834c628mr5752222f8f.16.1781802702126;
        Thu, 18 Jun 2026 10:11:42 -0700 (PDT)
Received: from localhost (109-81-26-193.rct.o2.cz. [109.81.26.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650bc429adsm265230f8f.32.2026.06.18.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 10:11:41 -0700 (PDT)
Date: Thu, 18 Jun 2026 19:11:40 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v4 2/4] mm/percpu: honor GFP constraints when populating
 chunks
Message-ID: <ajQmzKVv4h39HJ7Q@tiehlicka>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
 <20260618130414.96383-3-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618130414.96383-3-kaitao.cheng@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0E6240007
X-Rspam-User: 
X-Stat-Signature: pjiiw7oj1g8b9sakbsp3m5qhs8soy184
X-HE-Tag: 1781802703-712844
X-HE-Meta: U2FsdGVkX1+/c6tDfwwRFv7swiMgX3H/NzlMsSB8MAiND9Z/370Chz11OdAJkxebDEqioMI2QcxFuRg8Ybz3kjHvzQCRtEO+eCmxVLeIiVnWk7OCqJnnWUf553ojDVSMpTJ6J7//FCNKa+h8mIibaG1bHsETjepBLuEPDD9xiiFhuMlMEy0XazOJ9SIZqmv8gKpCIv4KmBob8L0VdgzDjbrepkiposYGsVWWucnlmusUFc6qXAK4DxCLkMDcKlFjo6m4pNE4lh7IOxmCm+HfSLxLNimv4y/RhZtznCsuFRNOwPe7/ogrIPTOd0s8MmsVnKOMPtR6NeOwCO/wR2kKwoeFu5j3Uss1S4ZWK2gjQqTP9MbZtfS/GQ+D+rBm/LiFtaKcZMfE+cxWLveWLpxEYoasOm0Db3Lq2vUkL2qwlS9+QF4e5V+/KTFeakNbKE1ysfIg8QLA68NF7Ltj+HBG5xkp0V4N+ZSFOA67brjj95MMVnfduR0gDcYhdwGjR8tNsl9D2rjdH+mTjv7/6CQIwV8Q7cg/hDY3YI8c9GE//oZVcMVS4WZIErwzoxv9P4p/Atgs5VGS4dsldj3LPTTH5IAPCdlvXn5kvwyvQfkt9kd9bkuM7ZDiuttqUGjQdBuKuMjh0ieeexdjm5MkP2cqFgtCaFTZ6gHX8iIJTyaKG5yaEcRcKj0K5bjCVk2pvH/aayD/gB0kRAKp8jig2//0mBvwA9xIGpMYSm9drygqAVBj111mUpKqDqQs6nNBBCF49O88gLTQV5g/VLNBmtzvUX4dyD/7i7kwIvWq6p/juOaZOAhHu9hU8zK7ST+Zt5HwjfCb41KSbi8AhycMu0PP2LKKQ9eF1kO+LmqdGQLIs41UEG2wcp00bu8KxMmq6+gePhKddNwqN8CxJLWQOPDmwhTOFps4NV7IUr+OGAoCN0n/0Rp9ijW49LBiIeS5QRJB9LyjyfrUMs7cie6qeBC
 DwLY0h1/
 rjZkAYoGF+NsDsFH2E7XWAyjie4knO6Z6xUPsUJrAIFu6uwFuNrT/GADYVK4y2dz3BwzN1iqiVXJHr/4H2Jaep/OoShmXYmrwrdc8LLMUDevvbWLcRl6L+fwdN6RUhtA2NWOjBm6ATpZzMVSQiUkoM53biCZYX6QNqca5/0ml46EXPfA6xGXpkry3uv2fHgvItiYxD4bHzsRlqdclNLSyfvva68yRsBu3RMMAkHNl7wauCQxOrcaq/5HL/uq5T3HgjlyexHmn+hQ4xF/98J6zU+IkiYmVtEJKLEo+uys3DERFUwGpomx2Cqz4JjBhyyUgVSkhky3JxfIBR/schJRF2MPLijrHTiL376Piwp5Uy1sbJGIAA/SwdLIQFrmWHbKgDTu0Ah0o0f9f0CSPl1ZoqpGj+uWUkPqAtOsGkmGMBMv83l6AqZQzrSG63wLa51rmAdKf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-06-26 21:04:12, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
> passes it down to pcpu_populate_chunk().  pcpu_alloc_pages() already uses
> that mask for backing page allocation.
> 
> However, the populate slow path still has internal allocations and page
> table allocations which can lose the caller's allocation context.  The
> temporary pages array is allocated by pcpu_get_pages() with GFP_KERNEL,
> and pcpu_map_pages() maps the backing pages through
> vmap_pages_range_noflush() using GFP_KERNEL.  The latter can allocate
> vmalloc page tables implicitly, so a caller which deliberately uses
> GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while populating
> a percpu chunk.
> 
> This has the same concern as chunk creation: callers such as blk-cgroup
> may use GFP_NOIO because they hold locks which can be involved in queue
> freeze or IO reclaim dependencies.  If an allocation reaches the percpu
> slow path and needs to populate previously unbacked pages, the internal
> GFP_KERNEL allocations can defeat that context.
> 
> One possible case is blk-cgroup after commit 5d726c4dbeed
> ("blk-cgroup: fix possible deadlock while configuring policy").
> blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
> q->blkcg_mutex, and blkg_alloc() was changed to GFP_NOIO for that reason:
> 
>   CPU0: blkg_conf_prep()
>     mutex_lock(q->blkcg_mutex)
>     blkg_alloc(..., GFP_NOIO)
>       alloc_percpu_gfp(..., GFP_NOIO)
>         pcpu_alloc_noprof(..., GFP_NOIO)
>           pcpu_populate_chunk(GFP_NOIO)
>             pcpu_get_pages()
> 	    pcpu_map_pages()
>               -> if the selected percpu chunk has unpopulated pages,
> 	         chunk population may do internal GFP_KERNEL allocations
>               -> direct reclaim / writeback can issue IO to this queue
>               -> IO waits because the queue is frozen
> 
>   CPU1: blkcg_deactivate_policy()
>     blk_mq_freeze_queue(q)
>     mutex_lock(q->blkcg_mutex)
>       -> waits for CPU0
>     ... unfreeze only happens after q->blkcg_mutex is acquired/released
> 
> So the concern is that the caller deliberately uses GFP_NOIO because it
> may hold a lock which can be acquired after queue freeze, but the percpu
> slow path can temporarily lose that allocation context.
> 
> Pass pcpu_gfp through pcpu_get_pages(), pcpu_map_pages() and
> __pcpu_map_pages().  Apply the corresponding memalloc scope around
> vmap_pages_range_noflush(), because vmalloc page table allocation does not
> pass the GFP mask down explicitly.  Keep the first chunk setup path using
> GFP_KERNEL, matching the previous early-init behavior.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Acked-by: Dennis Zhou <dennis@kernel.org>

OK, seems sensible.
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/percpu-vm.c | 38 ++++++++++++++++++++++++++------------
>  mm/percpu.c    |  2 +-
>  2 files changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 69b00741dc68..ccd03cc152d4 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -21,6 +21,7 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
>  
>  /**
>   * pcpu_get_pages - get temp pages array
> + * @gfp: allocation flags passed to the underlying allocator
>   *
>   * Returns pointer to array of pointers to struct page which can be indexed
>   * with pcpu_page_idx().  Note that there is only one array and accesses
> @@ -29,7 +30,7 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
>   * RETURNS:
>   * Pointer to temp pages array on success.
>   */
> -static struct page **pcpu_get_pages(void)
> +static struct page **pcpu_get_pages(gfp_t gfp)
>  {
>  	static struct page **pages;
>  	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
> @@ -37,7 +38,7 @@ static struct page **pcpu_get_pages(void)
>  	lockdep_assert_held(&pcpu_alloc_mutex);
>  
>  	if (!pages)
> -		pages = pcpu_mem_zalloc(pages_size, GFP_KERNEL);
> +		pages = pcpu_mem_zalloc(pages_size, gfp);
>  	return pages;
>  }
>  
> @@ -191,10 +192,22 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
>  }
>  
>  static int __pcpu_map_pages(unsigned long addr, struct page **pages,
> -			    int nr_pages)
> +			    int nr_pages, gfp_t gfp)
>  {
> -	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
> -			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
> +	unsigned int flags;
> +	int ret;
> +
> +	/*
> +	 * The vmalloc page table allocation path does not pass @gfp down
> +	 * explicitly.  Apply the corresponding memalloc scope so implicit
> +	 * page table allocations preserve NOFS/NOIO constraints.
> +	 */
> +	flags = memalloc_apply_gfp_scope(gfp);
> +	ret = vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
> +				       PAGE_KERNEL, pages, PAGE_SHIFT, gfp);
> +	memalloc_restore_scope(flags);
> +
> +	return ret;
>  }
>  
>  /**
> @@ -203,6 +216,7 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
>   * @pages: pages array containing pages to be mapped
>   * @page_start: page index of the first page to map
>   * @page_end: page index of the last page to map + 1
> + * @gfp: allocation flags passed to the underlying allocator
>   *
>   * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
>   * caller is responsible for calling pcpu_post_map_flush() after all
> @@ -211,8 +225,8 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
>   * This function is responsible for setting up whatever is necessary for
>   * reverse lookup (addr -> chunk).
>   */
> -static int pcpu_map_pages(struct pcpu_chunk *chunk,
> -			  struct page **pages, int page_start, int page_end)
> +static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
> +			  int page_start, int page_end, gfp_t gfp)
>  {
>  	unsigned int cpu, tcpu;
>  	int i, err;
> @@ -220,7 +234,7 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
>  	for_each_possible_cpu(cpu) {
>  		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
>  				       &pages[pcpu_page_idx(cpu, page_start)],
> -				       page_end - page_start);
> +				       page_end - page_start, gfp);
>  		if (err < 0)
>  			goto err;
>  
> @@ -271,21 +285,21 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
>   * @chunk.
>   *
>   * CONTEXT:
> - * pcpu_alloc_mutex, does GFP_KERNEL allocation.
> + * pcpu_alloc_mutex, does @gfp allocation.
>   */
>  static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
>  			       int page_start, int page_end, gfp_t gfp)
>  {
>  	struct page **pages;
>  
> -	pages = pcpu_get_pages();
> +	pages = pcpu_get_pages(gfp);
>  	if (!pages)
>  		return -ENOMEM;
>  
>  	if (pcpu_alloc_pages(chunk, pages, page_start, page_end, gfp))
>  		return -ENOMEM;
>  
> -	if (pcpu_map_pages(chunk, pages, page_start, page_end)) {
> +	if (pcpu_map_pages(chunk, pages, page_start, page_end, gfp)) {
>  		pcpu_free_pages(chunk, pages, page_start, page_end);
>  		return -ENOMEM;
>  	}
> @@ -319,7 +333,7 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
>  	 * successful population attempt so the temp pages array must
>  	 * be available now.
>  	 */
> -	pages = pcpu_get_pages();
> +	pages = pcpu_get_pages(GFP_KERNEL);
>  	BUG_ON(!pages);
>  
>  	/* unmap and free */
> diff --git a/mm/percpu.c b/mm/percpu.c
> index b0676b8054ed..4d89965cba16 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -3256,7 +3256,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
>  
>  		/* pte already populated, the following shouldn't fail */
>  		rc = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
> -				      unit_pages);
> +				      unit_pages, GFP_KERNEL);
>  		if (rc < 0)
>  			panic("failed to map percpu area, err=%d\n", rc);
>  
> -- 
> 2.50.1 (Apple Git-155)

-- 
Michal Hocko
SUSE Labs


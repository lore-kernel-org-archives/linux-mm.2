Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E01FC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23EB6B0089; Thu, 26 Feb 2026 04:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD21A6B008A; Thu, 26 Feb 2026 04:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3136B008C; Thu, 26 Feb 2026 04:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5D9B6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:58:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51E16BC9D6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:58:06 +0000 (UTC)
X-FDA: 84486156972.24.B345B96
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 77DB31C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:58:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=emnKTryW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772099884; a=rsa-sha256;
	cv=none;
	b=Bu/ePA2jHQ8IwATi7aGzUYPQlWTNyiTPvIM2d5vlSYGDBuzgsWZX0lRYr4ZzH2qLIsHmZj
	icWibopQQSP8VGZyf8rR97OExFvW6FTC0hbhoDSrIaL1Hk7UfNMpYvEYsyVlPjFwOUmmN8
	9qKRwyWWRggPwttfp33yEVqCTE281hk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=emnKTryW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772099884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23/t8wTYRID9qPCAnpeEZAiV1ILTIxUka8dj1HYCRwo=;
	b=4ijJtWqO8Iji6N8U/JmXRT75CUBV+PB0idGqyyG2Zp9wLOHUUMJvTrZU3IsEYSw0cL0VdK
	FLIlythPnG+I3T2DMTP5eQPUxLiZA28iehBdElfGFU03iGO3SIMBa7wl7A0f4TxJQynMca
	bVUSNTPAzabnX0DyLM/6vYHpPe740yc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ade574f05eso4288975ad.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772099883; x=1772704683; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=23/t8wTYRID9qPCAnpeEZAiV1ILTIxUka8dj1HYCRwo=;
        b=emnKTryW4HzqomZ0nIV1cpuSaptYM7w/BiICBTn1hJFabs4goK63SLmOEmlpJln2Ze
         TJLJdFHXYUn1g3ZIUtMgMQ+idZg3RSWmmYrxm34/iftwUcEdx9qYJPkVKP7+htmpnF6D
         ISeSyVHOQiS/dxYXVaqqVl9qyYj/zV6NYebnpB+QaP116UIP1hBgNfL8eo2uh4WsJJJH
         1OBx6D3BddRQu0i61Fp2I9egIlAvocQaUA3Cf7frmChutGT8ACCW6IkPLKrXXXut5KWt
         wdttbHx5CULccBRT8HBGougFAFO7HBr28W3AzwvK9HpszBlYTiIxwYTZQIvzjdQZeK1l
         rBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772099883; x=1772704683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=23/t8wTYRID9qPCAnpeEZAiV1ILTIxUka8dj1HYCRwo=;
        b=dl4rAMBP8jnd++emV5DUNEfHBVxA45G6D8p4eDtaOPMLrrEHjRRu+f08QJxmZgDQtW
         tDzPccpDYC8SN4Ol9oK7DaXjK3D9sWUV/3qKknGBp7d0ZuQTka6H1A3DAgCXgGB/o6Ty
         u5/a+3bZaTZWePQvptEy4o65/b37KqLdfmnJP/NBzDGAAAvfT0Dz5NAJMxSn5/Y+C70g
         KIzLyKwXAFZ3jX5olKcWwJp0uoVHKHw3JPzcoG6tK+uwkgDUlyg28SdUGBw04aUJKI0N
         Rz2wDKLi03OSv5HPFDLhn66L9GU8UBdyXsoRLMS1al7N8D4A5jCsCMmhxzCPFVyfUxFh
         B5EA==
X-Forwarded-Encrypted: i=1; AJvYcCUq/in25kr0BrUIS9vVhm+AMLu67BsrtZkZnRUzoKYKu8eLvsm5bi9SHqYdLe8ym88wSms3NLvx+w==@kvack.org
X-Gm-Message-State: AOJu0YwQMu9dnlNUxsxHQuEoyvNUnJbgoV/d5FLTjoQvfhEHerFVIvwc
	XuOJzqsCqt6FVEgCI2lQAP+wdIBOq6B+dIt2xhqJZ5oJd7erDQTDmnjN
X-Gm-Gg: ATEYQzwM9FHJImB6eafafEKPm1tkWvqo+A1B7S7Er+YsLCdFQFpbMdwmekWwiT12aVC
	B6msoEkR0EYYthuFpyFy7uBEDQ4yvNnS4zd17122fWHmsx9p5TRas5zqv7SpE1LFk/HxV97YtQo
	gief4T61Wyn2CYKt8JcAqfYVbUt4rgZoZHUgqndSmo/MfCGSQm6QXj9zu3SMSme7GVE1OQMffZQ
	gXZwZdqmctBomU8ye5RaVGxb5GQ858QjKy6xZ/eG6gJU+x+Uk4YLlStysPoAJnvB5AP9ABP+U9H
	nRq2z/xnAhHRvAWkXvAHxNvrUlTxGTtkjc8ki1uVtlHssKiFLvqzN+vIXO9FxMUj1j+6BY4RUB4
	sjGxJQ4K+QM/XslCmnkN5gQ7ME+SVOsstmyEiLf+fIQ0xHfcRPfiSKmfDDSc4E0SpS9xYitQriR
	+lk2mvmnRLi2e2gXb9A7XcZRh4JfzO2VqHJzStsqHu6eeEXCyMAVWngTIu7+vAIIzvpg7OcL7nk
	3KGWg==
X-Received: by 2002:a17:903:2f46:b0:2a9:451b:422 with SMTP id d9443c01a7336-2ae02e4a546mr16549075ad.14.1772099883212;
        Thu, 26 Feb 2026 01:58:03 -0800 (PST)
Received: from localhost.localdomain (n058152022206.netvigator.com. [58.152.22.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5dbac7sm29218235ad.37.2026.02.26.01.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 01:58:02 -0800 (PST)
Date: Thu, 26 Feb 2026 17:57:56 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH] mm: khugepaged: simplify scanning progress in pmd
Message-ID: <zdvzmoop5xswqcyiwmvvrdfianm4ccs3gryfecwbm4bhuh7ebo@7an4huwgbuwo>
References: <20260226081313.53518-1-vernon2gm@gmail.com>
 <06ff4738-e81a-49ab-9204-74a6829d8d8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06ff4738-e81a-49ab-9204-74a6829d8d8b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77DB31C000A
X-Stat-Signature: z5rt17tkxmhw4pnhqrcmq57jrx9hjbis
X-HE-Tag: 1772099884-684617
X-HE-Meta: U2FsdGVkX1+zfeqPP52ax+U3rLT56OLrzZ2wJZ+2s5ELSK/Mz1LuRsCZMOf7W59DaPw52g4+SFldhaFOdjT5buUIIfptQstM5Wmwj6X0v4W/9mSFVCqNUBy4OCYpju2zSqW0bnTDqRsUptTH8U6jlDRRf/DBaLvp8H9zWlRD4lZOYSUtgPg7B9ovnudTNg3ygY+Px7psR4URNTuIjOeOP0NsEdKnVqCe6XPZuYV4k0ysJFuFmzmDXWYj+2h7MO12Yw9NRz1XZVXbaxifJ0MYAlIiQ6gs1KqDrW3ZdLMV1MbxOrW6PyzttRt/dycjep60p15WQuChFVSKpvjgnhHhDroOVlNpTzXL4mP3oP75KWKtZjUduEz6gOmuGcl/4J6cLnJJRnzzJM3Lf1yZuOs2lGsRcKmXLJqGNc7ZBsR2LYkScG/VPAXkvQSA76OJ4FaWVunIJyzenawVw9HOMlW/aY7r0lWuotxCWGkz/XFZxHlMATGQz7hvg10zt5ogXg1s6Jw+uqdN8qm6gmb0o9JvMRC3h4Q+EGCh5/wBH6D/bn2tyBw/08GJ7kUdccHbpNye0fLLz/M1u0S7orL7IlJvS5tIxgxCYMQ9mavQ6nUz3ZIT5lJyZpPW7VxWaE5pJaUJdrt2UtDqeBcPs7Jfagzctdv0SF+xQO8ifNVS5Cd62EVdVP83/L06moPyZJWB0km6Qyt3fWTHKdH6xr8YQGxUMzfTxE3ztbVF6weHo3MLBjAfoI3tIVivuYd6X5CpB7ZGpmY6s5XqqzEafMplYdp4ph4qolv0xk7h2mCQL4sRw5v6RKgyYbXYmOQVGzGdzW+RD5Ixl5e0fGbsWEkZUL/o4aw8aUU7LTkhOMBPwU/3aRyMPnvxBrJWMw4m2blkaMsk7PRMKKgzTNk+6yYYhIUnSr9xKZe4OWMcmbcjE3JLsSLOdDoVznL93uby32AddG+rNqs9lwdK5ZJvig7XWVF
 qaSvpCuC
 3ay4ER1axpoObBsdnfb6eewQ8Gjt4ACvsOsapamwkwKZ1ww4+j4vbTU4YwB/PWuwFcOZ9GVjATFeLamE39WMbsVHwQNYkoW1RbA9k4GwzSRUJ4wuq+AYTGLj/FszYMHt0eTutmQKJQMR71Fa7TUjEns6CDOo5ApmFdeTVfeRjnsvgOVzbAcR9zK/qtjSBtBHiv9CiQ46qjcvzDjVpRSz3fcNCKT7xpkr2SPjf8jBa5CCK8gGw0/a3GA73PWJEXj/+ZQKNZudo8Tqilf75Fkd2NSX/zUuTu4+pdhdMYqUxkTPG7LOsJwi0ruMaxpdM7Wg+eXnP7NS3O1oXveT3wWY+jQOwbQJrdyNNg3W4X+kwtcVY4cXNfjf0AGM6KMYTIyUn/+3i3jZqu0vwRnuIVE3PgLD8erIyEtLiQFSkxIMac+ksO1APycne8Huw7XV5ip0bUf1/wH9lUQlK/JjfBaUZotS8bxN49R3AP61pcWEw0wmwYCsklP1yw5wk+Yk6LJFCkkQ1R63Hn4/8/Zz7i9IFY6FQzm8gEhn6hjlzl7Ulv4FHamGadyEUPNXD+FczuEkpbz5dLN5lBf5XPWICa7COXZ66Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 09:42:41AM +0100, David Hildenbrand (Arm) wrote:
> On 2/26/26 09:13, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > Placing "cur_progress" inside "struct collapse_control" makes the
> > overall code simpler, there also coincidentally has a 4-bytes hole,
> > as shown below:
> >
> > struct collapse_control {
> >         bool                       is_khugepaged;        /*     0     1 */
> >         /* XXX 3 bytes hole, try to pack */
> >         u32                        node_load[64];        /*     4   256 */
> >         /* XXX 4 bytes hole, try to pack */
> >         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> >         nodemask_t                 alloc_nmask;          /*   264     8 */
> >
> >         /* size: 272, cachelines: 5, members: 3 */
> >         /* sum members: 265, holes: 2, sum holes: 7 */
> >         /* last cacheline: 16 bytes */
> > };
> >
> > Also rename "cur_progress" to "progress_in_pmd", make it clearer.
> >
> > No function changes.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
>
> We should really squash that into the original patch and revisit it.

Yes, squashing this patch into the original patch makes the git commit
log clearer.

> Because I think we might be able to do even better.
>
> Could we just switch to "cc->progress" like so (modified original patch):
>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4d7baf220ad9..5d67e5e60ece 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -68,7 +68,10 @@ enum scan_result {
>  static struct task_struct *khugepaged_thread __read_mostly;
>  static DEFINE_MUTEX(khugepaged_mutex);
>
> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> +/*
> + * default scan 8*HPAGE_PMD_NR ptes, pte_mapped_hugepage, pmd_mapped,
> + * no_pte_table or vmas every 10 second.
> + */
>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>  static unsigned int khugepaged_pages_collapsed;
>  static unsigned int khugepaged_full_scans;
> @@ -100,6 +103,9 @@ struct collapse_control {
>  	/* Num pages scanned per node */
>  	u32 node_load[MAX_NUMNODES];
>
> +	/* Num pages scanned (see khugepaged_pages_to_scan).  */
> +	unsigned int progress;
> +
>  	/* nodemask for allocation fallback */
>  	nodemask_t alloc_nmask;
>  };
> @@ -1247,19 +1253,24 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> -	if (result != SCAN_SUCCEED)
> +	if (result != SCAN_SUCCEED) {
> +		cc->progress++;
>  		goto out;
> +	}
>
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
> +		cc->progress++;
>  		result = SCAN_NO_PTE_TABLE;
>  		goto out;
>  	}
>
>  	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
> +		cc->progress++;
> +
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
> @@ -2370,6 +2381,10 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  		}
>  	}
>  	rcu_read_unlock();
> +	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
> +		cc->progress++;
> +	else
> +		cc->progress += HPAGE_PMD_NR;
>
>  	if (result == SCAN_SUCCEED) {
>  		if (cc->is_khugepaged &&
> @@ -2385,8 +2400,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  	return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
> -					    struct collapse_control *cc)
> +static void khugepaged_scan_mm_slot(unsigned int progress_max,
> +		enum scan_result *result, struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
>  {
> @@ -2394,9 +2409,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  	struct mm_slot *slot;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	int progress = 0;
>
> -	VM_BUG_ON(!pages);
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  	*result = SCAN_FAIL;
>
> @@ -2419,7 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  	if (unlikely(!mmap_read_trylock(mm)))
>  		goto breakouterloop_mmap_lock;
>
> -	progress++;
> +	cc->progress++;
>  	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>  		goto breakouterloop;
>
> @@ -2429,17 +2442,17 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>
>  		cond_resched();
>  		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> -			progress++;
> +			cc->progress++;
>  			break;
>  		}
>  		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> -			progress++;
> +			cc->progress++;
>  			continue;
>  		}
>  		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>  		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>  		if (khugepaged_scan.address > hend) {
> -			progress++;
> +			cc->progress++;
>  			continue;
>  		}
>  		if (khugepaged_scan.address < hstart)
> @@ -2486,7 +2499,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> -			progress += HPAGE_PMD_NR;
>  			if (!mmap_locked)
>  				/*
>  				 * We released mmap_lock so break loop.  Note
> @@ -2496,7 +2508,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  				 * correct result back to caller.
>  				 */
>  				goto breakouterloop_mmap_lock;
> -			if (progress >= pages)
> +			if (cc->progress >= progress_max)
>  				goto breakouterloop;
>  		}
>  	}
> @@ -2527,9 +2539,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  		collect_mm_slot(slot);
>  	}
>
> -	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> -
> -	return progress;
> +	trace_mm_khugepaged_scan(mm, cc->progress, khugepaged_scan.mm_slot == NULL);
>  }
>
>  static int khugepaged_has_work(void)
> @@ -2545,13 +2555,14 @@ static int khugepaged_wait_event(void)
>
>  static void khugepaged_do_scan(struct collapse_control *cc)
>  {
> -	unsigned int progress = 0, pass_through_head = 0;
> -	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
> +	const unsigned int progress_max = READ_ONCE(khugepaged_pages_to_scan);
> +	unsigned int pass_through_head = 0;
>  	bool wait = true;
>  	enum scan_result result = SCAN_SUCCEED;
>
>  	lru_add_drain_all();
>
> +	cc->progress = 0;

madvise(MADV_COLLAPSE) is missing the initialization of "cc->progress"
because "cc = kmalloc_obj(*cc)". We need to manually initialize it in
madvise_collapse().

LGTM, I will submit v2 with this patch and squashed into the original
patch.

--
Cheers,
Vernon


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D977C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7388E0002; Thu,  7 Aug 2025 07:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097BF8E0001; Thu,  7 Aug 2025 07:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16518E0002; Thu,  7 Aug 2025 07:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E114F8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:54:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D0B881DB2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:54:26 +0000 (UTC)
X-FDA: 83749803732.27.7F123CD
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D599A0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:54:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gupdBtwB;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754567664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BT4qexqfy5mbsc9gPProX37TwyBOeM3+/8lACE/SCU=;
	b=VNkcR2bUKYZddsBriYlhJDMqpJygB37GC9+VJJpBzAgauRAEDGnYEEgr875vSU0yV/lBYW
	H39P5fDeAjeYSYUAiXRRGWYOnwSEITE81/ZBzKHs7EgsZ/yXr0uFWgwLE2tVoN9qXUmMPP
	FUuOGI4aJv7qbGoHAcbERzKl3ragbrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754567664; a=rsa-sha256;
	cv=none;
	b=HxSDnBhzbPnuCm3ZMKUSBP/cpTI7+1TMnv0lJLQgSIuus/RvnPqXGFctWiZTaDiEpaYxoJ
	v+kpY2WAUFQIaPeZoKJ44LS4drHxsPBo+dxaadd2IoSleXB2ytFHBjisZFzhAdZkJVsaGR
	RJ10Mvnk1MSPGaxJe09jGHL4IOVencs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gupdBtwB;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b8d0f1fb49so478539f8f.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 04:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754567663; x=1755172463; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2BT4qexqfy5mbsc9gPProX37TwyBOeM3+/8lACE/SCU=;
        b=gupdBtwB/TT+nJY4ad2iGhtaS1nkPWbispqjoKOT3yoz8sPxZPI6+X8zPWXXirMRh+
         v3orClXswJncObbTObXdgfI4O2kK8DC8lLAl/2Tu6CjtRfudJxYVZSqef63if8ssO5Ax
         5wZsfaTL8y3hSJ2lv9JES5fG17vWgS+MPvkG6Garq44822nHU4CxmV+3Pa8d37DVeQIh
         AfSrJHrdabnRCNRWHqS4okx3fJcDhE1RogegB6CVOWqG9Ih8yds7HXxLhxsF5GTDLvmN
         USeTvo0eswGfmPbtsIlG6paO4bYK0jZ7Tx4gnJlky63MrwxR+RKn5eqSejYhDz2qRWV/
         g/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754567663; x=1755172463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BT4qexqfy5mbsc9gPProX37TwyBOeM3+/8lACE/SCU=;
        b=xSnKe9CVEHuri9xGvWs5pSZKuMq1PwwUxftaVQYpYrZ9LrWEsdsUwN8reioQrf68lu
         aa21VMRQI8PqPNtNp+WO2tW9EpoHun/wlwvjUu/B/p536dD+WnKyufiszlowhy8ZdGSt
         F1TKOEpEhDz9s8Nrt3KucHIGqf88ysqC+wX+Eyf+D0fw+zFRoJXSZlLEQvjgKSB/RTRW
         BpCDEvzgbmlF4XWcdO9Fz90Yd3nIdFWXtGXy7zceFC9WSdRsfRjfFn0VxF4S/Dhf1JvF
         XwolXXRDY6r9RN+1YLBWNgExyoH6U01c9fqro2LpVr/oc3HyOvt1ATu31dUf2QjTWKH0
         rzsw==
X-Gm-Message-State: AOJu0YynrfwAvF1MgJcnKIM58WGPxyLv4yBAPqCy/sJ4BP5hLVG3xQGn
	J5Zb4Z6VVbJBwjUobpZAu9guX6xm2gnUa6I5a390w4bOlSVY8Pn+eKbxfkQJrFmdbyU=
X-Gm-Gg: ASbGncs06ou1DRuYHrBl5amyB/lzGi9qQOlKYPtSsOjWlRwmRdHmfBwHoMylgH4YgpS
	nAsTldkikkgEG9KeoP9Kmer7jU3EK/oWa7YAKACFWD+O0Lmd0XhFaTSWkZVqDeybGgQNVjKFEZj
	r/xuYnX+FHlC0ZsT/r8IKZtCXrnIdPhePCh/pl7gdw+0DVGek5HEutxm7947Nvai6sxAxyvwBa3
	VLSk8HBqX/acr+g8XE0tJk9Z8elxUlSqk68vmeyBV3JqkP9VTtKqaND0xnqoh8ciEd1lMHyLCPm
	EmstkcNBFRGhhZ+ixVLj/PiCO+sakbUuEh22876BiR+AYBsamq9e9UGENteBqWf9SSQ1hSQY/nk
	ZswAn2yF1OvYjScOV38Lr1QvUlTTzvIhH5NU=
X-Google-Smtp-Source: AGHT+IELrwTrwViTNH3wEHxa9qVS2wjKSCcwBwiZ3gAW+4RTsHzlU0KgD+y4N/Jqi/C13eHcngcTqg==
X-Received: by 2002:a05:6000:3108:b0:3b8:d360:337f with SMTP id ffacd0b85a97d-3b8f420ec47mr5979837f8f.51.1754567662688;
        Thu, 07 Aug 2025 04:54:22 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459c58ed07fsm186745745e9.22.2025.08.07.04.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 04:54:22 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:54:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] mm/vmalloc: Support non-blocking GFP flags in
 __vmalloc_area_node()
Message-ID: <aJST7TnermwROX41@tiehlicka>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-8-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-8-urezki@gmail.com>
X-Stat-Signature: cizb64sdf9nby8rysznhg55i3fu6xwoa
X-Rspamd-Queue-Id: 6D599A0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754567664-463532
X-HE-Meta: U2FsdGVkX189EazHUr1Vf1bO94xYH4t1h30P+/e8FvdEFfdWNmqp9GsVg0T95p/x9QyGqLWeJ431NJdkcqI62I3d1FnT74fuWnGomq1aaYxzYwCotHkem3KM/RfzaBcXu2KGttOb4uhHLj0wgGeRIlvkXraVIgeYsZ05I16OI3KQAPwotjlN8mQfh/JEtLDWNs4WLOxGUc0K026Jl+pJNu1KD+Y9RZ5IpPi2k9jAT7X7q/Tg1DEvp8vYzVATBraun8BYoZ8GwjYE5o9truwZYhqB7rROLwsCeErZgC6DgLUmkv4qziKgoK/fJdfPcFiaKWvOcHwNqgl45F+cqMtt15Wp8VjYZ6jN0JUmAUeDpxUSc4XBNV3M967WqOYdhKf9njUKnJDQMnnkF866PTqd1lmt5+lLop8QfaxLcEXn5UntDV4V0CP0kWYB84xdXr8dhNuQgFgqvJ5Gria9HtYTZ2Ab0OdMb3tYaHVfLMYsYnSvMMwRtjuqkc2gasa9uUCtr1GKZRykGhRLzxvLJBdMhQ0UqlWnUPpIR+YSZuKQ4z1s9lne7oI8AZCvAtJiJHIOgVgMI4lnAcbPXUZavjYo3S8sEXi2a/RjXrhPTRVeQsT3fLGCvWuScBzrH7rVrauQXMuXRn+cGHmk3Jt6GQzth8ykPzj1HoztNTObEiNDKsJDIu18WFefVZf2ORjd9XHK2xbsc5/Q4EUFA2xKH64Lxo4TuNfxBx+KdgVlp7kfKjM1gEr5gAc1cXDsvVGGBZITWjWRJJyoJ1Yset4kLZJ0ntX5wPhpYRLMMb7RBCRN9OUtMw7TE1L+KeL4F/pTubSq/dVVsKfzULB8qXUl3byWuPxFFbew2AeRHsQSckc7Z85zX+081PXwuf9jSMV0DWfFi/ryQJGXqaAkf+gCk5ZNefLcbVQ82jLWQGA+P7YkM24TPIldx60ty1qfBndklbMoD4Nr1R9g2w8EwNNxTUh
 Qnk6WGzp
 +FKMbZjz3OG3AdvqkdHll4qIOrVNm7gSRL/lbeWnSUGtrwgSM7LhYy/EAJ16He7fCze5H1HjYH8QqCnSuMcZJZuW4TmEbP/wANH2+p15F+r2g7g8MfOdum1K6Ks9xZjULNEOyxAI6Ap/pbRK3G5KJ917rh3DZxufbnwRJ6/EDjdM1RwWastTtFLD1hXwDs7k6tk5qt5rtoePCL1/IryRDATVGoxvxi4sW/3mKFZhxTYMC81hyqvIcYTLnHpdio7ewCemHn8lBS6GKQWLhnvtgWwn4zwpewsOviwSWjliUohvpnwfFRaaCeXQkWTGkzxj3AfWi57OtsWhR36p6Hcut7m6p/rg4ug4V3eLDHUxca1J8SQ5DCsaYcvgGBngCyOeGhA3NLWi8P0o8n1BlXGJ+94mxtOVPNc2BaBPDMf+zqnd6ORaBXYyIskiSDrLsS39VoTTT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 07-08-25 09:58:09, Uladzislau Rezki wrote:
> This patch makes __vmalloc_area_node() to correctly handle non-blocking
> allocation requests, such as GFP_ATOMIC and GFP_NOWAIT. Main changes:
> 
> - Add a __GFP_HIGHMEM to gfp_mask only for blocking requests
>   if there are no DMA constraints.

This begs for a more explanation. Why does __GFP_HIGHMEM matters? I
suspect this is due to kmapping of those pages but that could be done in
an atomic way. But in practice I do not think we really care about
highmem all that much for vmalloc. The vmalloc space is really tiny for
32b systems where highmem matters and failing vmalloc allocations due to
lack is of __GFP_HIGHMEM is hard to consider important if relevant at
all.

> - vmap_page_range() is wrapped by memalloc_noreclaim_save/restore()
>   to avoid memory reclaim related operations that could sleep during
>   page table setup or mapping pages.
> 
> This is particularly important for page table allocations that
> internally use GFP_PGTABLE_KERNEL, which may sleep unless such
> scope restrictions are applied. For example:
> 
> <snip>
> __pte_alloc_kernel()
>     pte_alloc_one_kernel(&init_mm);
>         pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
> <snip>

As I've said in several occations, I am not entirely happy about this
approach because it doesn't really guarantee atomicty. If any
architecture decides to use some sleeping locking down that path then
the whole thing just blows up. On the other hand this is mostly a
theoretical concern at this stage and this is a feature people have
been asking for a long time (especially from kvmalloc side) so better
good than perfect that his.

That being said, you are missing __kvmalloc_node_noprof,
__vmalloc_node_range_noprof (and maybe some more places) documentation
update.

> Note: in most cases, PTE entries are established only up to the level
> required by current vmap space usage, meaning the page tables are typically
> fully populated during the mapping process.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

With the doc part fixed
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/vmalloc.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2424f80d524a..8a7eab810561 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3721,12 +3721,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	unsigned int nr_small_pages = size >> PAGE_SHIFT;
>  	unsigned int page_order;
>  	unsigned int flags;
> +	bool noblock;
>  	int ret;
>  
>  	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
> +	noblock = !gfpflags_allow_blocking(gfp_mask);
>  
> -	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> -		gfp_mask |= __GFP_HIGHMEM;
> +	if (noblock) {
> +		/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
> +		nofail = false;
> +	} else {
> +		/* Allow highmem allocations if there are no DMA constraints. */
> +		if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> +			gfp_mask |= __GFP_HIGHMEM;
> +	}
>  
>  	/* Please note that the recursion is strictly bounded. */
>  	if (array_size > PAGE_SIZE) {
> @@ -3790,7 +3798,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	 * page tables allocations ignore external gfp mask, enforce it
>  	 * by the scope API
>  	 */
> -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> +	if (noblock)
> +		flags = memalloc_noreclaim_save();
> +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		flags = memalloc_nofs_save();
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
>  		flags = memalloc_noio_save();
> @@ -3802,7 +3812,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  			schedule_timeout_uninterruptible(1);
>  	} while (nofail && (ret < 0));
>  
> -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> +	if (noblock)
> +		memalloc_noreclaim_restore(flags);
> +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		memalloc_nofs_restore(flags);
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
>  		memalloc_noio_restore(flags);
> -- 
> 2.39.5
> 

-- 
Michal Hocko
SUSE Labs


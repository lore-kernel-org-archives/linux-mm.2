Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6D9CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DB18E00DA; Tue, 14 Oct 2025 05:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F68C8E000D; Tue, 14 Oct 2025 05:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00B08E00DA; Tue, 14 Oct 2025 05:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6CB48E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:41:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FB7513BBF0
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:41:32 +0000 (UTC)
X-FDA: 83996227224.24.1439CAD
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91D5C1C000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:41:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=atbouwfG;
	spf=pass (imf18.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCJev5YRwu/rqGnN8n/PTfia02gLpLN0twmsZsqNANU=;
	b=z4ieniGbHd4Cwjl9xkpEveUXfzBaqdM9CZiZt1PNWzvs/aixbgG5Jc8c2TSSRVFSYbR2dS
	wwftC+Oe2WXyEQbUJp0b+DV29Fbm6x+QZNcJ8TdDjrPDADi3OceYNAchPBd80P5mwMjYiP
	SBu0xgFhEaAVHY9to+I7ofqpbgzynNc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=atbouwfG;
	spf=pass (imf18.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434890; a=rsa-sha256;
	cv=none;
	b=6uIe1RC5izieVqzPqcOBXC3q8TYOaQX1B+eke0bNvMv49Ipk0llHG5fkmOMEuSYIsz1YeJ
	vnmEkEFPnpVvLvKdpzHpSH8Esk1wa06uA4ZBNBchK7oZVEIxWlErakBPZMcI6cO12hGj4P
	uOkqmZXefY22N0Y6N4GwO0UMAqeVHsM=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b3c76f3703cso71128166b.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760434889; x=1761039689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCJev5YRwu/rqGnN8n/PTfia02gLpLN0twmsZsqNANU=;
        b=atbouwfGIiG1b4EgQNFgrOW02VDzIFkeN6dCJfZLp90zkalAyjAYbvanjxKJlQ2o9Q
         CbuO7FTEPleHnsLdvheswoD1FxsJNm9cYP+NECfRmy0cCIlWeFnQK9dhhan6+4Evm+nw
         PYrpF3ynNDUK3PsvU6Jc8gfGrJuQD59GycMI2Zi58jmB5pVL5y9Ye3lO16gLcmtayZYa
         4dVrjGucbk4kVnci/bPakXBVpriUvI9rx4cF1nE6sqkud9iM18163leBOmOIbCgA9g1A
         vNqqYAEc3khOn4DEhM9fBZ489LFSw4kZTuttv64YBvBFSz/n6jGBs4pM/fqIH4ixR39d
         mfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760434889; x=1761039689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wCJev5YRwu/rqGnN8n/PTfia02gLpLN0twmsZsqNANU=;
        b=uK74r7wmk9KNBw0MJujF9/Qd2C2rAuuSXPZ1QD93zZ0p9GeULZuufUdUDo7MhuqlII
         SR7UFBbh7Xo/Du4wcQ1gBvc6QQxH0QPVcLTe1o5jVKCTafYYGPKcW51t6S7mbWOMAv+W
         IWjG9u73xTLjwhvTdV+YjiigWjNWZV3I/llFPXMVnwhAC1emcJiy/03QuNdgVfqJdi1F
         v/EnXs0vD9er/QFk5V7HlHY3prWCl+qjkh1C0XrZCZMUJgtOWUEDgsDhBOWpMW54YnOA
         hgHbvCa/ACmZLAIoQI5cRiaC+CcUmAt8iWKIVT2BOME9SjVqZjnEXDQr8++pwJdQUo3+
         B54w==
X-Forwarded-Encrypted: i=1; AJvYcCXIPj4FC2IZVzZYxWsKtquZXoCIxxB9cY4NFGmiNgQYY++lwzYbc36TZ+SGJmXyf+a1cBxAb3cv+A==@kvack.org
X-Gm-Message-State: AOJu0YzOsQn8CZBs/1koQIc38Hf+yX4Al094U9QMMvjN3FNd6GuZzJ0I
	t7vBRWUCoqFTlzIbxxDY9UiIGO/EVPU1quokhNOP4q9RJ/dh+2a/YgDUuYfphe3Jee0=
X-Gm-Gg: ASbGncuxwIf//KZlzHezHWs+MkHoowwQfYNYFS/VCdhbteOn0hGbojAf6YWwKkckIUW
	xIkJ6+j+votxtcAsEh+2GiVR+qTUWfgxqS0GNyZgAi1pfjg5g5yDQmKYYfBDfHu3qRHBG+Mu1ZX
	gu6mzAvUYoJxVdQ2NEsBhym8MpRa9KXwGzIdQCEjI1x24UON3yeGJczcnRygSzzkuEouonM0Wnl
	iIFBM2K9zxBOUeaZoECVjZcQqQ08Y2AtAwEKayiqmi8N+0ytbjYaEsJW/0ZYOKulFYOtbDI6yfk
	OwfVvaDhI10JL1xo2QyBZp4ed7UeKDeAoRiYOfEBCYjcz9RAfEs9RvygigHcWX/BoNGo+z/IosG
	Z7mcUPqtVKMAcTWKBRI13krqIpW9w7JZH/9vYgnnU897NGqGxxlm1QD0tMF6t1LAADzoCtYR1IL
	t/VA==
X-Google-Smtp-Source: AGHT+IEj7EXmKeGMkIHLFt6v1ZPE2GXmgL8mw1Xbm5Nig8QsEJKwgtZKXB33yqabFn/nHPojvmOTxA==
X-Received: by 2002:a17:907:3e8c:b0:b57:1fd6:5528 with SMTP id a640c23a62f3a-b571fd65e5fmr757770266b.10.1760434888791;
        Tue, 14 Oct 2025 02:41:28 -0700 (PDT)
Received: from mordecai.tesarici.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d5cad938sm1124395066b.2.2025.10.14.02.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 02:41:28 -0700 (PDT)
Date: Tue, 14 Oct 2025 11:41:24 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Mel Gorman
 <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, Sumit
 Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard
 <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
 John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Zhaoyang Huang <huangzhaoyang@gmail.com>,
 <steve.kang@unisoc.com>
Subject: Re: [PATCH 1/2] mm: call back alloc_pages_bulk_list since it is
 useful
Message-ID: <20251014114124.145165bc@mordecai.tesarici.cz>
In-Reply-To: <20251014083230.1181072-2-zhaoyang.huang@unisoc.com>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
	<20251014083230.1181072-2-zhaoyang.huang@unisoc.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fm6ap9kc8xard3p18ocgiemdn4i5jqqd
X-Rspamd-Queue-Id: 91D5C1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760434890-117683
X-HE-Meta: U2FsdGVkX18Mq0+wW0ODfvHQBbUq8LRRRum7ieyY022fXHWhBvwhNP9a3wRlYAK59Ps2Jf/QoSD1HHO0VfM8x9lWBysbQhKc9k71dNy0ePXx2+BbN11iC/7lLv4K80hrJ5LbEvES15Fkf/o8YbMqQMz9cpDuwEeHyNWwNAXOrRFrrSZXS3oRXAWZ3i8nKePEKFQ/qekYejphnLCy16OD3TfQo1ZkrIUXuLGaMdSKGjnFEIMa+lGNvpiG0F2QsICxE+my9yBy2b5G960q2o3Dc1FTOjMRA5LlRzVtlEUES6Pjq8I+cSUdqNlcLss2gUf3UqVF3Hf1cQ5jONj8SWLt53gcGm00gmrv7fwiEse4LA1t44J6J/yitskDUIVZilydAR/DNURagb1+DmjD4bGijeGuudIJH97NkbB+Ou+LWQ0ZCxZZLCnvoiVVc06GZ5bQZCoR8G+xKR6F9f/mTGJqjcsADlH68nQT7kYGgDhhySuwBLUHaTfd8m8gWAEf4CjXfCtYCE1A52JL/Hm7xJ1F7taJmCCLcW8shBk6QqEy+46U66+yIosgvuSPn40Do3iJ/E4MTF0du3wop78sFv1qZEKdGeWKujp9z23Rk9XcEbJDre4H0BprhpykkZZ8Fg4T21o8yq1iI6R8PXvZOkPzETUse33cMoTuYHFlWs7Ystn91h5twFDGMfa/pRUtkD8zvkwndVtOSqDnZpP5kIMlQnzIaIilw/Sh+tmh84D4MQ4YSWfylo1UJZvXyNxMwsV501H4Oa2MYfiWIlVul0O1unb6OpaN6WHtc+UeCwO/43RB6NTF+FKUmB3gA5ByJhQEfeAGGSLZv+K6gkbM2tPD6j1VFEmz/4x8XtkTjGR4tmMAcZHDSWznMBvUO5pu0R0l/UStzfSmKDA1Wo5v/icQBrVyN6yRtEpKXwggcteGAR4FIe88P5G4YlI4yo8o+BI6jp77WmlsuoFurzqW7KH
 IPoglodh
 L8mSZTXUX18VrcVpaPs6wKOHUnMoFBXzyhM04jx3b3AbGsA8XvkP5LvP0BMRGefoMGTn94pWq0Z8AtuyzecTDAD+JEiBvEwa/ALXpw+fv3jWssuE+otdpAqfZUbN9GCqQFGnfRJckuMHf4ngE8VU5uad3lG9iShjguSIxSqTZPeQNaJ9VSHLyRiwbueSgjTzQmu9ubZx8zUGemyr9/u3I7keh9jt56IfLGCFzN4BQpPqwj0dYeZh3swLBH2Hghsy0PKxsCBX+L7lIGOPf3cUKzb3j/EQe7UrQKDCMTEmQyqWMF/eG+AiKL6hLmRafphOA+pMdICnl1SwSti0QI1tT+yv8vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 16:32:29 +0800
"zhaoyang.huang" <zhaoyang.huang@unisoc.com> wrote:

> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> commit c8b979530f27 ("mm: alloc_pages_bulk_noprof: drop page_list
> argument") drops alloc_pages_bulk_list. This commit would like to call back
> it since it is proved to be helpful to the drivers which allocate a bulk of
> pages(see patch of 2 in this series ).
> I do notice that Matthew's comment of the time cost of iterating a list.
> However, I also observed in our test that the extra page_array's allocation
> could be more expensive than cpu iteration when direct reclaiming happens
> when ram is low[1]. IMHO, could we leave the API here to have the users
> choose between the array or list according to their scenarios.

OK, so this is more or less a revert of commit c8b979530f27 ("mm:
alloc_pages_bulk_noprof: drop page_list argument")...

I cannot comment on the performance gains, but I dislike the fact that
the patch re-introduces alloc_pages_bulk_noprof() as a function with two
signatures (either page_list is used, or page_array is used).

If we can agree that allocations onto a linked list are useful, then I
suggest to split the existing function so that the common bits end up
in helper functions, called by both variants (one function using a
list, one using an array).

Petr T

> [1]
> android.hardwar-728     [002] .....   334.573875: system_heap_do_allocate: Execution time: order 0 1 us
> android.hardwar-728     [002] .....   334.573879: system_heap_do_allocate: Execution time: order 0 2 us
> android.hardwar-728     [002] .....   334.574239: system_heap_do_allocate: Execution time: order 0 354 us
> android.hardwar-728     [002] .....   334.574247: system_heap_do_allocate: Execution time: order 0 4 us
> android.hardwar-728     [002] .....   334.574250: system_heap_do_allocate: Execution time: order 0 2 us
> 
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  include/linux/gfp.h |  9 +++++++--
>  mm/mempolicy.c      | 14 +++++++-------
>  mm/page_alloc.c     | 39 +++++++++++++++++++++++++++------------
>  3 files changed, 41 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 5ebf26fcdcfa..f1540c9fcd87 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -231,6 +231,7 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>  
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  				nodemask_t *nodemask, int nr_pages,
> +				struct list_head *page_list,
>  				struct page **page_array);
>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>  
> @@ -242,7 +243,11 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>  
>  /* Bulk allocate order-0 pages */
>  #define alloc_pages_bulk(_gfp, _nr_pages, _page_array)		\
> -	__alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, _page_array)
> +	__alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, NULL, _page_array)
> +
> +#define alloc_pages_bulk_list(_gfp, _nr_pages, _list)			\
> +	__alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, _list, NULL)
> +
>  
>  static inline unsigned long
>  alloc_pages_bulk_node_noprof(gfp_t gfp, int nid, unsigned long nr_pages,
> @@ -251,7 +256,7 @@ alloc_pages_bulk_node_noprof(gfp_t gfp, int nid, unsigned long nr_pages,
>  	if (nid == NUMA_NO_NODE)
>  		nid = numa_mem_id();
>  
> -	return alloc_pages_bulk_noprof(gfp, nid, NULL, nr_pages, page_array);
> +	return alloc_pages_bulk_noprof(gfp, nid, NULL, nr_pages, NULL, page_array);
>  }
>  
>  #define alloc_pages_bulk_node(...)				\
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eb83cff7db8c..26274302ee01 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2537,13 +2537,13 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
>  		if (delta) {
>  			nr_allocated = alloc_pages_bulk_noprof(gfp,
>  					interleave_nodes(pol), NULL,
> -					nr_pages_per_node + 1,
> +					nr_pages_per_node + 1, NULL,
>  					page_array);
>  			delta--;
>  		} else {
>  			nr_allocated = alloc_pages_bulk_noprof(gfp,
>  					interleave_nodes(pol), NULL,
> -					nr_pages_per_node, page_array);
> +					nr_pages_per_node, NULL, page_array);
>  		}
>  
>  		page_array += nr_allocated;
> @@ -2593,7 +2593,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  	if (weight && node_isset(node, nodes)) {
>  		node_pages = min(rem_pages, weight);
>  		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
> -						  page_array);
> +						  NULL, page_array);
>  		page_array += nr_allocated;
>  		total_allocated += nr_allocated;
>  		/* if that's all the pages, no need to interleave */
> @@ -2658,7 +2658,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  		if (!node_pages)
>  			break;
>  		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
> -						  page_array);
> +						  NULL, page_array);
>  		page_array += nr_allocated;
>  		total_allocated += nr_allocated;
>  		if (total_allocated == nr_pages)
> @@ -2682,11 +2682,11 @@ static unsigned long alloc_pages_bulk_preferred_many(gfp_t gfp, int nid,
>  	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>  
>  	nr_allocated  = alloc_pages_bulk_noprof(preferred_gfp, nid, &pol->nodes,
> -					   nr_pages, page_array);
> +					   nr_pages, NULL, page_array);
>  
>  	if (nr_allocated < nr_pages)
>  		nr_allocated += alloc_pages_bulk_noprof(gfp, numa_node_id(), NULL,
> -				nr_pages - nr_allocated,
> +				nr_pages - nr_allocated, NULL,
>  				page_array + nr_allocated);
>  	return nr_allocated;
>  }
> @@ -2722,7 +2722,7 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>  	nid = numa_node_id();
>  	nodemask = policy_nodemask(gfp, pol, NO_INTERLEAVE_INDEX, &nid);
>  	return alloc_pages_bulk_noprof(gfp, nid, nodemask,
> -				       nr_pages, page_array);
> +				       nr_pages, NULL, page_array);
>  }
>  
>  int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..a95bdd8cbf5b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4940,23 +4940,28 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  }
>  
>  /*
> - * __alloc_pages_bulk - Allocate a number of order-0 pages to an array
> + * __alloc_pages_bulk - Allocate a number of order-0 pages to a list or array
>   * @gfp: GFP flags for the allocation
>   * @preferred_nid: The preferred NUMA node ID to allocate from
>   * @nodemask: Set of nodes to allocate from, may be NULL
> - * @nr_pages: The number of pages desired in the array
> - * @page_array: Array to store the pages
> + * @nr_pages: The number of pages desired on the list or array
> + * @page_list: Optional list to store the allocated pages
> + * @page_array: Optional array to store the pages
>   *
>   * This is a batched version of the page allocator that attempts to
> - * allocate nr_pages quickly. Pages are added to the page_array.
> + * allocate nr_pages quickly. Pages are added to page_list if page_list
> + * is not NULL, otherwise it is assumed that the page_array is valid.
>   *
> - * Note that only NULL elements are populated with pages and nr_pages
> + * For lists, nr_pages is the number of pages that should be allocated.
> + *
> + * For arrays, only NULL elements are populated with pages and nr_pages
>   * is the maximum number of pages that will be stored in the array.
>   *
> - * Returns the number of pages in the array.
> + * Returns the number of pages on the list or array.
>   */
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  			nodemask_t *nodemask, int nr_pages,
> +			struct list_head *page_list,
>  			struct page **page_array)
>  {
>  	struct page *page;
> @@ -4974,7 +4979,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	 * Skip populated array elements to determine if any pages need
>  	 * to be allocated before disabling IRQs.
>  	 */
> -	while (nr_populated < nr_pages && page_array[nr_populated])
> +	while (page_array && nr_populated < nr_pages && page_array[nr_populated])
>  		nr_populated++;
>  
>  	/* No pages requested? */
> @@ -4982,7 +4987,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  		goto out;
>  
>  	/* Already populated array? */
> -	if (unlikely(nr_pages - nr_populated == 0))
> +	if (unlikely(page_array && nr_pages - nr_populated == 0))
>  		goto out;
>  
>  	/* Bulk allocator does not support memcg accounting. */
> @@ -5064,7 +5069,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	while (nr_populated < nr_pages) {
>  
>  		/* Skip existing pages */
> -		if (page_array[nr_populated]) {
> +		if (page_array && page_array[nr_populated]) {
>  			nr_populated++;
>  			continue;
>  		}
> @@ -5083,7 +5088,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		set_page_refcounted(page);
> -		page_array[nr_populated++] = page;
> +		if (page_list)
> +			list_add(&page->lru, page_list);
> +		else
> +			page_array[nr_populated] = page;
> +		nr_populated++;
>  	}
>  
>  	pcp_spin_unlock(pcp);
> @@ -5100,8 +5109,14 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  failed:
>  	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
> -	if (page)
> -		page_array[nr_populated++] = page;
> +	if (page) {
> +		if (page_list)
> +			list_add(&page->lru, page_list);
> +		else
> +			page_array[nr_populated] = page;
> +		nr_populated++;
> +	}
> +
>  	goto out;
>  }
>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);



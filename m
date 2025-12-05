Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9755FD374A6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5666B02FE; Fri,  5 Dec 2025 16:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F456B02FF; Fri,  5 Dec 2025 16:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6A56B0300; Fri,  5 Dec 2025 16:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A84606B02FE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:49:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47EB313A95E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:49:41 +0000 (UTC)
X-FDA: 84186759762.08.3CEDAA9
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4467A40010
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:49:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JMQ6nryr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764971379; a=rsa-sha256;
	cv=none;
	b=bwkVumP+SuaS9oIVmacU4f5B8QqbRYomI5Jdm1ThJNeoWjUCzLUXU5UrXxIykmX0Jc0G7c
	st0MzLBm5PEv0v3eW6FDjvC55aHMMC5aeyPEv5czwYxjuJUoLRboflBMaXRxhaw1zePDxY
	NpijhGzJY8ddvE6ewCWeL+tJPklHUig=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JMQ6nryr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764971379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbYHxiv2k68IUzFKcDelHcanl/w9WtEHhqSwTcDSWB4=;
	b=7VbqGAF6kwPpUPvoMBN/YVn0YmZ3E5qIta3ClSYwfV9kF6GZJE9SeNH/Z4PQbD8LccXRCT
	dg/ciWjNITe3uVbCoG/ushv+Ddvzb8eOScvNQtkgojJHoXb3WAQYLUFBEoSz0cTh/Cxev6
	APln7C/bRs0dMPtguRlXYo30Zn9EHJA=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so21344605e9.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 13:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764971378; x=1765576178; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vbYHxiv2k68IUzFKcDelHcanl/w9WtEHhqSwTcDSWB4=;
        b=JMQ6nryrHskaGoU28lr++NLO6urQ1911v1JMqxZ4/bK2W8G6TgBbCFO08EMhZX7V4A
         8oUsQVYeWoDRSDKsjBLaPiTCVx6oHXQvb624JQOYpmmtiB5taW+6kJg6rbvCAcvjfjGg
         r8b4fqihLEczeKZRvO1YW9VSJhPVAbAYYEjFDlIfm0fpMX2luH9cYQnWo2mCatf213ox
         m9exemtyCOCIvaJH1yAgpVeS2yzFhmtpK7anKjaakXdzHt2GyIiTeLqzXzjJvzZYmATy
         ujCONWZlihVUhPacfgjRACrc5oXdTlEbHxuY5kwZx7bjkRtOIi+5I9QiL7FbbK8P14pm
         TaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764971378; x=1765576178;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vbYHxiv2k68IUzFKcDelHcanl/w9WtEHhqSwTcDSWB4=;
        b=npTt42ZzG6qJAswhLa/11dHMHQNhetnigziX7OKTt1ORRMpzznZWFZdMUCDKrpsYVO
         uAT7Z5FeTYwdURfJAXY2ui5q133dxumoXU9VSnkstJTUZo8n7oYtaVg3kL73NnW+E2T9
         S8h+//W/PxPgeJniMmfTwHlKkntdRTP63dlJZarUw4vkoM05m5OUu5L2MhckfVoKu1yk
         WhIzT/EqTkOe3iLrBaTCzuuTrNURjSkeJpb5kYJLSon6pscZ9JDfuUrTw9UIajrZSF+5
         K/nO8rL4Aa85IKgmVNRel4/bfOKqyHlxwb77exjFmMJrX864b+/YlXK6Sb0TcF4+N9UO
         vIFA==
X-Forwarded-Encrypted: i=1; AJvYcCXC3btYfsD3+ipJ9yow9IeypZwrEFhdzdjKnruNg5rFunSXrhogLejtDa8aA1iZdMWMA/o/Xa/G1w==@kvack.org
X-Gm-Message-State: AOJu0YyQT4rYDzGpysRVBjjXM8Shriy9oY/ruBJse2JjgwlAwdnt7GYu
	QBUhp2p94r+ALjKizLp4OlxsEQWD/q7PStXP3WJ67I7hzw5jTFHdrzjh
X-Gm-Gg: ASbGncuiLijfY6O2Si78+HP/Nsw11zCaqiHzQ8G6YRqbrM2V+X/5Oj+G+OCvRylqNZy
	ppq8JZ00fvknkF2GR65vASP1HJ3kELq35kkUNvhQtJ2uQqATr7UDoLBuWGVlF76eKtxCCJKcV0+
	XAWuLSqnpYLzZ3mc9vpkoRxWiTSCWlOjV7bFH+L1hzodfD8gIAoQl2kFqeZNhhx0iQh5PMawCON
	1ulmfFHKTu1chVBpEFkzSWFrm2XlWgFxCw5992DrU5M0qp4kxJm57aZ9a8oaH70K7tE8vimIcWC
	WAH36HikI+BlWkreue7qePGZttuG+qV9F4V4GKZux5lHB2W5IJLjKkbIXPr7lBKLu9MByXR80eR
	jk+ZiLYM/JvOo6cDyP9V8RVT4Ub5+N/v+h1s7tgq9+6LT+JiEj0K5eq4fYfboIB2+B24uxtt6Ay
	qyiuKlKearYLnGnN4ZRjZPa9kg76U8Ke8PdBfJD97ZedkM6giCNAmhqFOb8Js4qlH4ksHQ+aaN2
	02KRdACkRp/
X-Google-Smtp-Source: AGHT+IEAmF5Xs4UUd6p05OhlkXAzodVRvjjJJ8btSF2zz1UqgDaB1gM22axrMV2Vi20ZCyiSptlI5g==
X-Received: by 2002:a05:600c:500d:b0:475:daba:d03c with SMTP id 5b1f17b1804b1-47939df5414mr7057155e9.13.1764971377503;
        Fri, 05 Dec 2025 13:49:37 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b152a68sm65715995e9.15.2025.12.05.13.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 13:49:36 -0800 (PST)
Message-ID: <77d1911d-7b67-41c0-933e-b2a0810cf3b4@gmail.com>
Date: Fri, 5 Dec 2025 21:49:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] mm: Change the interface of prep_compound_tail()
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-2-kas@kernel.org>
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251205194351.1646318-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4467A40010
X-Stat-Signature: 3j7wuw9qcftk6a911nwyzxwttngpg3xj
X-Rspam-User: 
X-HE-Tag: 1764971379-829772
X-HE-Meta: U2FsdGVkX1/z5q1q1UNEP+lkwxEQS3LwioqF41TxQiD9VO91rygn6m3r4kGe7IZmNGgS97yZZw4l1qMaFOHMRGmEg3UgWZ3yUgO1hr4FEmPr/v21iqsWaUFBQpy74v24RFx09oUl6370OWtVehAfo3STXtbajFRqmcwuukrPBeg9OSwm3rMIEoinbnUrWHmbBZ0s2zDhm7KcLpaZ4rykgXvkY2T424DWNuLPsudEU7P/oawsg8heSyesCuNyL9F+EkeScfPDsg8c5u/GWF2OTnFxKxGwRfRMKUJmI2ffYTG0KQ8nWfTWiqLlGAl78+ZbNVurLP6qVqpMz/gLNxEPLjzFM93OBXMFohuL9fmPYa4a8lIMAZw5E5pbyaBRypVCKiMNBA6j1ycDnKzNxHJGetM0geMCKPNv1vV2s3lVKmr5FTY6Bm8N4gJE2jNoLICRoNQ6nBIjdI3wGnYZ8vgB+n7xx6iR5atTSPPBYvLcJ4uHrhG/LH/sTAFM37QINBSy4f2Cy3+4BK2/5hAi/D37RmMbwtzJHq1K2aLL3JoV6TwV/ErbCpuP0OFzwg7PPnAVt5by6CTyAhN13BMWsnltQyFCHfBGILMIYMWBatt3/avKHnTW+rUZo51uK8mn6Fgez6y1uQpb9ewgSk5xjf5e1yj7pCP4MaRAgMJbQBFN9DPOcBvwPVErWkAc+LVmJtP0coOaDSE4ImTLJOlDiWNdYtnDby/zEwSQgHnI2/D1zSdY+oN3wQGl4+ORWYEV3yFIK3tPJrjzTKHryiMMqbS/LL0dph5ajXcVob7hH0A8xxZSn3KCzKyM6Tf1Zt68l/pINlHYQTc0rtx54ZYlpyu0r99+N4qMsKl2VoZt8csG43RwG5g8wZRqNBUnyU08+O8JFq0wMNk7pqbtHef/PEJ+NRyzWS+zIXIjP/dYKrxUiU4pBvnA/JweDOA4X/w2H4dpKL9ELe6E3S01JNaV79u
 q+HDQukp
 HgPfnfrrfVjAO5OqQ5d3LCguG3snk824gWOzR3XL2Ez8Pla3S2zInqG5g6dc+Lo2uNDtoDND6IQrygWs7O+/DuEvAeHD92mcSZBvZQE5kCHHGmRgfllG+3FAJpviVH7px+lWY5X4xJsa9uJXWsrmjgDDPwaPWBN7Vk+I9ZucZj0gpchruADMiADRUCZA+2m0s1LwLKg4ahvD4hNsHACz4GrqoP2tp3k1GylgCmdaEaSvlgjgf0rksPjpbIond/NxpFdBSwEFN4lceKcNztryDlUPRNONMRjB2LtcREMjAPydGPX4gYSqeGF/QP4gloBP4Lc1Y0R2Iet7L5W/FAfzqAf91ncSs+bZY0Xa03Jb938duW9a3g6a9rJj85zM2E3nw+RmxBKJ+kLnhKH8axonkLD1oElqk8b88aLPUmK337j7+FmToF/goYAPN1ySM3+vHGfKAgEDtXP7MgZk2ehCG9oB2Bulqe3gCKZhWBagRKrxJj7pP48aNBraMZt/0gmkXC/4vhXWZ2eUbcd0ZLiVPd2UTCtqmAkNkhN4EXq/4ZNKEq7ExcDRfbMYh4/40RFIUoFuebSXbmgeZ5lM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 19:43, Kiryl Shutsemau wrote:
> Instead of passing down the head page and tail page index, pass the tail
> and head pages directly, as well as the order of the compound page.
> 
> This is a preparation for changing how the head position is encoded in
> the tail page.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  include/linux/page-flags.h |  4 +++-
>  mm/hugetlb.c               |  8 +++++---
>  mm/internal.h              | 11 +++++------
>  mm/mm_init.c               |  2 +-
>  mm/page_alloc.c            |  2 +-
>  5 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0091ad1986bf..2c1153dd7e0e 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
>  	return folio_test_head(folio);
>  }
>  
> -static __always_inline void set_compound_head(struct page *page, struct page *head)
> +static __always_inline void set_compound_head(struct page *page,
> +					      struct page *head,
> +					      unsigned int order)

I can see that order is used later, I think patch 4, but probably this patch might cause a
build warning as order is unused? Might be good to integrate that into the later patch?

Other nit is, do we want const for head here? (Its not there before, but might be good to add).

>  {
>  	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
>  }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 0455119716ec..a55d638975bd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3212,6 +3212,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
>  
>  /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
>  static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> +					struct hstate *h,
>  					unsigned long start_page_number,
>  					unsigned long end_page_number)
>  {
> @@ -3220,6 +3221,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	struct page *page = folio_page(folio, start_page_number);
>  	unsigned long head_pfn = folio_pfn(folio);
>  	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> +	unsigned int order = huge_page_order(h);
>  
>  	/*
>  	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
> @@ -3227,7 +3229,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	 */
>  	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>  		__init_single_page(page, pfn, zone, nid);
> -		prep_compound_tail((struct page *)folio, pfn - head_pfn);
> +		prep_compound_tail(page, &folio->page, order);
>  		set_page_count(page, 0);
>  	}
>  }
> @@ -3247,7 +3249,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>  	__folio_set_head(folio);
>  	ret = folio_ref_freeze(folio, 1);
>  	VM_BUG_ON(!ret);
> -	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
> +	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
>  	prep_compound_head((struct page *)folio, huge_page_order(h));
>  }
>  
> @@ -3304,7 +3306,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
>  			 * time as this is early in boot and there should
>  			 * be no contention.
>  			 */
> -			hugetlb_folio_init_tail_vmemmap(folio,
> +			hugetlb_folio_init_tail_vmemmap(folio, h,
>  					HUGETLB_VMEMMAP_RESERVE_PAGES,
>  					pages_per_huge_page(h));
>  		}
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..0355da7cb6df 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -810,13 +810,12 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
>  		INIT_LIST_HEAD(&folio->_deferred_list);
>  }
>  
> -static inline void prep_compound_tail(struct page *head, int tail_idx)
> +static inline void prep_compound_tail(struct page *tail,
> +				      struct page *head, unsigned int order)
>  {
> -	struct page *p = head + tail_idx;
> -
> -	p->mapping = TAIL_MAPPING;
> -	set_compound_head(p, head);
> -	set_page_private(p, 0);
> +	tail->mapping = TAIL_MAPPING;
> +	set_compound_head(tail, head, order);
> +	set_page_private(tail, 0);
>  }
>  
>  void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7712d887b696..87d1e0277318 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1102,7 +1102,7 @@ static void __ref memmap_init_compound(struct page *head,
>  		struct page *page = pfn_to_page(pfn);
>  
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> -		prep_compound_tail(head, pfn - head_pfn);
> +		prep_compound_tail(page, head, order);
>  		set_page_count(page, 0);
>  	}
>  	prep_compound_head(head, order);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ed82ee55e66a..fe77c00c99df 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -717,7 +717,7 @@ void prep_compound_page(struct page *page, unsigned int order)
>  
>  	__SetPageHead(page);
>  	for (i = 1; i < nr_pages; i++)
> -		prep_compound_tail(page, i);
> +		prep_compound_tail(page + i, page, order);
>  
>  	prep_compound_head(page, order);
>  }



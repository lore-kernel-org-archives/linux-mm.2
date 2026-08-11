Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D187FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971F06B0095; Mon, 10 Aug 2026 23:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949366B0096; Mon, 10 Aug 2026 23:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860146B0098; Mon, 10 Aug 2026 23:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 572B76B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:46:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB9E0A23BF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:46:05 +0000 (UTC)
X-FDA: 85087600290.13.52EC6D9
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC13F1A0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:46:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M7pn/2zP";
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786419964;
	b=PDW/vAcbvtMkrjv9ZgoA7X+pfCCmxBsQPs4g/qYjuaCQGSBNw+uZFrXcMUzAC35w/lh+j8
	0zEPj4jH7JQ7gkmMYjh644adulkKL7jU9vq6q51yGe491aKDsRu6flKIVPSzpTUiwW8wOw
	90pxIHDK3rUfg5LEFxm5KVHcP1DdLVI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M7pn/2zP";
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786419964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vf2wIzPBqAGNqktfjw6b1H1DhKoJGLNVcDHT9vkPtn8=;
	b=wUih3ISpg7oHaygSyaXozZgxmigybx84rjT6v/6Preow6bSknCCCFGTVaalUPeD70Cosnz
	2XOuQHM/pBIOCKQdK8XEtTFB4ZO8xwlX/TujmQ4Od5Gakf1lkA5lCkks9uiuS12fZ7gZnF
	o9hxCx/MpCSY3U6JgCPRfhp1jCa544U=
Message-ID: <6069cc82-d215-476c-a02f-52e0ae181ea9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786419959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vf2wIzPBqAGNqktfjw6b1H1DhKoJGLNVcDHT9vkPtn8=;
	b=M7pn/2zP9FBtQrZbmPM8eY7ue4Je3wynbTkJc3I95bes1QEJMlohiT881QizgnubsigJ+X
	pKC3WND8cibDE6KCchW5Khj84HoEk60eRYKN/KfdRhkyCNhw8POjGTrlVUzyP0dx8iO+jX
	yORIzWl0+o7KpEFdCPS2pG0dsB967wo=
Date: Tue, 11 Aug 2026 11:45:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 05/17] mm/sparse-vmemmap: support section-based vmemmap
 accounting
To: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
 <20260804035535.2846016-6-songmuchun@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260804035535.2846016-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EC13F1A0003
X-Stat-Signature: w3p9561ebccycfznw3tr1z1om6mu453k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786419963-305248
X-HE-Meta: U2FsdGVkX1/b8PwKeyHQAeYXjeA/xQdrVC13yVU/I68EKBjF9Goq56VoRuvPemiNXZsiZ445TfyyaEbkdkVX8afhqLMnOW0IFTvzhHtB1gHjsM4g1MXVbe78FUljDQt7SldvLruGLavOImcLfTMhazWcHxZDwcICLV3WrPEdWlgX09ysixYp++ztOKlMgIUHmURPwClnrPX10W64ORgwo/R06sCmsURH8TQNKrcftuWAhMeqOMyCWg4yZOsnHzqwhF2am1GskRlXOVxdpzp9rooM3TSpIggvnPtXgJTO3xwNhrLKoPPIH4X0v0vVwVaqUQwDLgZnih8Cxcd8c4pF3osJz+tTLgpw+XFTWfoHy73WcartdQwxFN07W3uwoBreE8L3WHs/bi1NbmMOxuj1Sof8cghTs4UG9UtHb+aPZNH95ZS2UCJlxrmpdIsoqGfpLfO5s7Jm4NlReY1hkVfh6giZeCqoQpzBzCWfaOTjqj+KTmV3jFYL+N4CC3l4tvDneVjlzjNhEN2lINfFmi+6RwrRY2e6qhqf44gbq/IWSYFKGacWcHHfF+JW6mF+bdwbwcoX9/pwadO1XXFNJgsgudBZKE7cxauGonyNM0lJftXaKywTcTogV6GT9tj51u57Htm6WuDY92jv0h2Q8UCGm9zqVfv2BxztfuLyKdtwPbBu2vRROKdSfMkKEWd+qxuB62TGLV7YFQgNrblrSnTQCw7t9AgUmh4GW5BXifyfyeJKkptj4lvkxh7/T1OALT7h1Ugi6W/J5jRErXk16zhwjHGs08CHrMerZzT1gaH5UWeP474BopIbRltLJRYgdUj4Ofgqk5pjhGDKRjsc2eoLzFO9Sm4C9cYMMGqkInV7lqAQ9XMMYiMwDoOCKYYMKdlyHvKBnPrACt5BoQQc0K21h3cQ6bTm/dt+GbM3itCk8GinP6o020xi8BGxd8qOueBJt0sxBMdgEZdEbXPYx3l
 x0nHbDw1
 +xF9jFq6zbLL9L0r8btmOT96fNDIWAB0R7PYK8yhjcKtYPc60Xc1OhG5xI9hVupB/rnjqun6BkFHFUsP0CtfwEjym7/JJ7YKWmsHDwmX6rz3oL3alJPjzdenWO2PeBqfRf5NlrZUGdPwWcoy86rFM/rO/U4ohk6LY/FG0JdE9kfyLMa6Ovrv0opofdY6jhDoAGwdUHKrMDAxm++3aQxB5L98yTl+zWvPLEkUMYzWB6140LWvJWUa5GjeXq800SILhU3TtNljRQKACiwWHq8WslXbiL5I2I8Z0JsKeXghkjwoiGM+8TTe2Af1UZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/4 11:55, Muchun Song wrote:
> section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
> but section-based vmemmap optimization keeps its compound order in struct
> mem_section and retains a different number of vmemmap pages.
>
> Teach section_nr_vmemmap_pages() to recognize section-based optimized
> sections and calculate their vmemmap page count from the section order
> and the HVO retained page count.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v3:
> - Add vmemmap_optimizable_order() for order-based optimization checks
>
> v2:
> - Remove an unnecessary vmemmap_can_optimize() call to simplify the code
>    (suggested by Mike Rapoport).
> - Rewrite the commit message for better understanding.
> ---
>   include/linux/mmzone.h |  6 ++++--
>   mm/sparse-vmemmap.c    | 10 ++++++----
>   mm/sparse.h            | 16 ++++++++++++++++
>   3 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 81e16d71e1f0..663726dd6463 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -107,8 +107,10 @@
>   	 is_power_of_2(sizeof(struct page)) ? \
>   	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
>   
> -/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
> -#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
> +/* The number of retained vmemmap pages with HVO enabled. */
> +#define VMEMMAP_OPTIMIZATION_PAGES		1
> +#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
> +	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
>   #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
>   
>   #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 107215cf8488..b7abc5494bb9 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -649,24 +649,26 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>   static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
>   		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>   {
> -	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	const struct mem_section *ms = __pfn_to_section(pfn);
> +	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
> +	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
>   	const unsigned long pages_per_compound = 1UL << order;
>   
>   	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
>   	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>   
> -	if (!vmemmap_can_optimize(altmap, pgmap))
> +	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
>   		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);

Sashiko said this conditional logic mix DAX and HVO optimization checks in
a way that severely corrupts vmemmap accounting for nr_memmap_pages.

This is a false positive because its premise is based on memory hotplug
support for HVO. However, HVO cannot be enabled through memory hotplug at
this time.

Muchun,
Thanks.
>   
>   	if (order < PFN_SECTION_SHIFT) {
>   		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
> -		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
> +		return vmemmap_pages * nr_pages / pages_per_compound;
>   	}
>   
>   	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>   
>   	if (IS_ALIGNED(pfn, pages_per_compound))
> -		return VMEMMAP_RESERVE_NR;
> +		return vmemmap_pages;
>   
>   	return 0;
>   }
> diff --git a/mm/sparse.h b/mm/sparse.h
> index b9b6b47e85ce..6ad190ec48cf 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -43,6 +43,17 @@ static inline bool pfn_vmemmap_optimizable(unsigned long pfn)
>   	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
>   }
>   
> +static inline bool vmemmap_optimizable_order(unsigned int order)
> +{
> +	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
> +		return false;
> +
> +	if (!is_power_of_2(sizeof(struct page)))
> +		return false;
> +
> +	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
> +}
> +
>   /*
>    * mm/sparse.c
>    */
> @@ -80,6 +91,11 @@ static inline void __section_mark_present(struct mem_section *ms,
>   
>   	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>   }
> +
> +static inline bool section_vmemmap_optimizable(const struct mem_section *section)
> +{
> +	return vmemmap_optimizable_order(section_order(section));
> +}
>   #else
>   static inline void sparse_init(void) {}
>   #endif /* CONFIG_SPARSEMEM */



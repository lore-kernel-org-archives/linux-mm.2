Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEE4F43854
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 17:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351606B0005; Wed, 15 Apr 2026 13:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3024B6B0088; Wed, 15 Apr 2026 13:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2182E6B0089; Wed, 15 Apr 2026 13:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 105716B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:03:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B71F01A0586
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:03:17 +0000 (UTC)
X-FDA: 84661410834.17.5BE3806
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F00F4A000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:03:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L06wAtHS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776272596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BeK4x1dxgJguKDNqttCCDO06v9f5N1pztpozpFeGrH0=;
	b=svwB7vuW5cGqOUJy0gmvigtkevs/w22tY4527Y751paCkRJHdiOxnpX7UVnegB0q+wzCnw
	Y8I3BnGiXY7p1mB/3t0xCEF7ipPa6Zhk/DOkaPBONcU8YBQa5I+1NC2NF4+pgyayK1j7a0
	AtSaje1IfJXThSLRjAG65u5yiK9tJnk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L06wAtHS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776272596; a=rsa-sha256;
	cv=none;
	b=R/BuJ+zDV7igN0zHIdzWND99uceCx/vwjm1gJ7Zm8KpAPtv97JRCsvgHF3VIIpEP2nJ4+d
	FyOE3uIKWGLDQvPXz6KdEqgC6lNrjLQ3pTAnPm6JPvQX7QKsYfsF1J4ZChrVPA+mYgQtQY
	/jXAmSW/BQLqOEikabDL3degKUtmNtU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21284600AD;
	Wed, 15 Apr 2026 17:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83C4C19424;
	Wed, 15 Apr 2026 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776272594;
	bh=mTAGT4DOoB+Ql7bFiOXRTX+ODnCO2UkCTVqe5r/JaGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L06wAtHSsRMa8OvFoMaXwNH+1eYa2W/v97alLbMISAOhCVynQoCeVmWJ5ZTbJM2MU
	 QP7uytxhoWHErO3ob8f61vSccJltnPjAWtlZt4lsROLQKwiy6NhoQ5oVgulzUN2XE7
	 Uo3FI5DmnXnfiqIlq8mgXKJj1rnTTcT/r34LozkpmiTLGt7Qjx1MyAk6v8ee1n+Rpk
	 74o3/NiC27Orm8AO8F1joPLIciZG77gcb4LXn7GyeQNAW8nrMjUVV+grPXZ+Huzp/Z
	 RmjoqCkMBFE6XBtZkfqKwxw5eGbivNgTzlGo0+AdBKR6c4ga/EKSAl1llk+H4Pev8Q
	 9k3GwIuIRnuKA==
Date: Wed, 15 Apr 2026 20:03:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
Message-ID: <ad_EygHWDi19SS9y@kernel.org>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415111412.1003526-7-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F00F4A000A
X-Stat-Signature: oegec3kxbwikyatrk8phhxs1jzaqg5m3
X-HE-Tag: 1776272595-177797
X-HE-Meta: U2FsdGVkX19qj80ad2oeID5rKim1tJgERsMlINAdALq6CqsPI1fYOTuJJyAcXqyXfjppzAHHsbthIb4Pd1eIap4vYF7TEWEzup50ABs1FAizEHav69LHwg/LfECMsQ6aTbNpy/mNiQp48M8Hx3OYcQso3fUWpVXpXeovcfawVfxAoNTcAXJDdE42icrzqzDim0U6LsuCJo+vNXKDXXQfREoIZNI9mtxWUZS7Rk769wi5lJ7g8Fmx43KsHBCSZkIcxIXZrqBNnoCbgnIkdx4jWuV0/gGjnfHe+Aw/lPwUXhqqJmq8p4YhzeuhZwdPHBB2dRdyb3T9RREZD301FYuFe5aDUVLXF7+MkgWbeG5VtM5xQDV70fdlzkqNXSVMh3X7xSMxXZbZFEZZ/u5BDa1x7g2n1tdhU2TZQwF/30eUBXezpJGHAmTMfuyuwPpQ9rEkpq4iimxM5k4+MMfJ5Rge1rlBf6tMYGDYjHSDm1WFb0bwegQtZ/anaXIRAdxXeYGfBasR3ua7g9ZU6wLRL1YhDLU0q2M8CNX06A/Sj5bW8t2NjBmuabk66WuCg5zf6nuM9atVsnTx1hpuZnCJRCcbptvY+fgodsjaKaRNUTPnTfLRD2lRfCfrjiCLI0259I8rzFzJRjkIyoNsk+sHROL3EWDga0Djw723jeyjFsgD6vwmi57vpe+pF0ewPVdeb7FlnpvDHXun8+9kZuQpoJXZgfd9RtvhhrsTm8hVEspckWdo8V1LLWy1d9jurNAdZjHt7s14JuTwJqrogf9EKRs5pBHnpCd2eo9KHBHvW4SNHRiPK7QrbUS+FN51nvsch6DwH5NuCZFbiVB7ZiFRTYDiBvwTwiipW8NMgiIAWBpGEj1LR9cPcp/5qw3XuGzfTL3O5zB/mFK3+1B+a+NZPJdWsAgdhgg5678sEmBMsssAztLvl1X/1sEipnwEwY93AuhY3USuNdurEoLaSzD37cN
 FjklkQ3X
 Fb2o77jkRU54xNhgFmfU7cj3OGSIY11GYG61qAaClhEWm9p34k5CHVjpTWyf326xnNXwAUxQS6+LoS4Gqav2OOV3mP0t0qBMgoGzJgkVsOV2wGvf844AZmNN7l0P0vNY0TRa1BG5yVYXqRal/7/XMSOQOua9AicLXYpQDglBEv0163rsl8a2sEQQHojEu3nDGHdSa35N3Yyn2MkOEDyQaSnqmYHTt/o37vUQjttDwWCTYlfYq9excJM3OdgtUlwj6avp6NI10cmEvgb9EtpxE/4ElsTK8AFA73nojn9BzO+n4sBb4R9xEu34na/ZMuWR+BYgcNXaSrNR4KTziBSSdmIdL3YPNc+H+0mdb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On Wed, Apr 15, 2026 at 07:14:12PM +0800, Muchun Song wrote:
> The memmap_init_zone_device() function only initializes the migratetype
> of the first pageblock of a compound page. If the compound page size
> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> subsequent pageblocks in the compound page remain uninitialized.
> 
> Move the migratetype initialization out of __init_zone_device_page()
> and into a separate pageblock_migratetype_init_range() function. This
> iterates over the entire PFN range of the memory, ensuring that all
> pageblocks are correctly initialized.
> 
> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/mm_init.c | 42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..30528c4206c1 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -674,6 +674,19 @@ static inline void fixup_hashdist(void)
>  static inline void fixup_hashdist(void) {}
>  #endif /* CONFIG_NUMA */
>  
> +static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> +						       unsigned long nr_pages,
> +						       int migratetype)
> +{
> +	unsigned long end = pfn + nr_pages;
> +
> +	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
> +		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
> +		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
> +			cond_resched();
> +	}
> +}
> +
>  /*
>   * Initialize a reserved page unconditionally, finding its zone first.
>   */
> @@ -1011,21 +1024,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	page_folio(page)->pgmap = pgmap;
>  	page->zone_device_data = NULL;
>  
> -	/*
> -	 * Mark the block movable so that blocks are reserved for
> -	 * movable at startup. This will force kernel allocations
> -	 * to reserve their blocks rather than leaking throughout
> -	 * the address space during boot when many long-lived
> -	 * kernel allocations are made.
> -	 *
> -	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
> -	 * because this is done early in section_activate()
> -	 */
> -	if (pageblock_aligned(pfn)) {
> -		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
> -		cond_resched();
> -	}
> -
>  	/*
>  	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
>  	 * directly to the driver page allocator which will set the page count
> @@ -1122,6 +1120,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  
> +		cond_resched();
> +

I don't think we want cond_resched() for every page here too, even it's a
compound page :)

Otherwise

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  		if (pfns_per_compound == 1)
>  			continue;
>  
> @@ -1129,6 +1129,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  				     compound_nr_pages(altmap, pgmap));
>  	}
>  
> +	/*
> +	 * Mark the block movable so that blocks are reserved for
> +	 * movable at startup. This will force kernel allocations
> +	 * to reserve their blocks rather than leaking throughout
> +	 * the address space during boot when many long-lived
> +	 * kernel allocations are made.
> +	 *
> +	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
> +	 * because this is done early in section_activate()
> +	 */
> +	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
> +
>  	pr_debug("%s initialised %lu pages in %ums\n", __func__,
>  		nr_pages, jiffies_to_msecs(jiffies - start));
>  }
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.


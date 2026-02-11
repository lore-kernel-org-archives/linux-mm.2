Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45402E9E2FB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 12:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82FE6B0005; Wed, 11 Feb 2026 07:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A0D6B0089; Wed, 11 Feb 2026 07:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66AF6B008A; Wed, 11 Feb 2026 07:20:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3E406B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:20:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 627BC587E5
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:20:06 +0000 (UTC)
X-FDA: 84432082812.23.820B9FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DE5FC0002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:20:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sNCh/avq";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770812404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2hIFjYsQI2GnMObTcERJ/YRV9vM7bvKvK4r3ncEMVQ=;
	b=wI5/bizon995Vq8a6BCGNUT1+WvRP+2mCCnkhChH6T9Gs38gNwifzOVN0UkFxItyEQivIp
	W/QTmx1i53yOVk7OtV5d3S/OB0JLCuUXeypaqwdtI7MHpG4IgERmkC84fylk8JIqjWLLDG
	LNoDrvVyOXuNaZ3Gwo5TtfkQ5GQ7LhE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sNCh/avq";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770812404; a=rsa-sha256;
	cv=none;
	b=kVBdEQoddZYAQ8M3YEOJ9lQYHxoVipFXZ/2/IcHj644cYhaSukMo+2eo824rK13MFD2CNH
	8aqQHA0tiUzPVP/kP5bomCbXMrYqgpyJ1E6rFLDbfe1Dp37ScCAy+v81NDVbP1vrOVi1E6
	dBC4fvUnEHoDorg6pttgsElRkGpzJ0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 265FB40A1B;
	Wed, 11 Feb 2026 12:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97C7C4CEF7;
	Wed, 11 Feb 2026 12:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770812403;
	bh=dsvzDwpDOus5dXhcv7H1k3fAhhEjVCIxilGm5cHSLZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sNCh/avq38s9mpDTbtwAbgdBUVxVDhuUYmF2aU6uuSac7QKeyiawqqw/nbp2DRGqq
	 bi2b8y0tV8OuCTOhKL9hSm3PEBffS9t65NC2PI+SdL9TId8ehOvZuI1lGQaDCYdhAA
	 fG3kFw6h5pAzQZir5T2L5W635Hdu19TiRKcps5Y9UCQQyXtaHYgqK2a+PBV0phO6sb
	 BNkEUjriaGtx0kyI9pr1S1wNy6dpmdZ/PcWXFnuag5nxrOdoxfGcnLucXd6eY9Nj4k
	 YH3+0tQt5+i84QmbsMwpqqaxasWVvoDis6ZdywuSHp/5gdSdhqpq25CLXi9UDUfZzK
	 2bih37jhK/Ekw==
Message-ID: <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
Date: Wed, 11 Feb 2026 13:19:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Mike Rapoport <rppt@kernel.org>
Cc: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYsaBkMecDG595Xg@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DE5FC0002
X-Rspamd-Server: rspam07
X-Stat-Signature: bnozceqtkd8dquezb3xgfct56s5i7u9c
X-HE-Tag: 1770812404-963475
X-HE-Meta: U2FsdGVkX1/tmD85SG6Mx1PXnzVSSE49M6UGKJYT5GmiJR3MnnJteyxVZel90SkJCzN1dLJcyRNyPaGOk9Q1sewL8aggZ4nHkg8Wh7ivHCT8S0+4s/ZFWQKlNa69ivC8IB2SdqCpZMoQLUwD9itPkCeK1mYYpDRuTxW4Vc3kKEilc1nk5Wxg5MDjEdIiyTxXyfVZjoWwyB3eYjJb5zVtv1n5kXrSPciHTChRVJKJXcymvj8Y8vGo1EEIM2b3ytY50gusi2SJIzixtqWDcmOrwKtIqVzgKScFLIAYMHyqQqqATZB3FxnODY62MCQ6hswb7jtlinZNt3q2LtWsVZ7t932yrE9Wc3HDl5gMoWwcX4TrqwrD8q05IHDxnkcdbskTeyhPJxQ6l8YQXbzPOS854Pi+AsyCdPffWM5ib+VeVmPYlKzFZHnO90ThoPVXCepTaYqSoiW8SqkYhxyp3pMmQpv0mVxBTZSu0Z6COtdqw1oq8CWaUKuFgYUZnOvwSYIfIofCcahi5ZgF1of2d7zsLC0FnuqlZmdI92hQ5zbQfDvpHYhHyzPSr18O0T/hFYyDY3SkiceraunB64BGhtc1s2T4C6XECGJAecLQP9gnrMCYM5D5Jk7eODTJME1Wyxxol2FKYhBDOfrqN7kydGulgF8qgSJZ+KtMYCrdlM3QV4gE1QKUTkoZYn/Cx4Y//W3zNS5drN9eAwKgBIgl5v6vmc4sB/63bUYk01XmC9o/CIIkmIs6P45cQj6e2cItkt4/slR1H+tRgyvqF/2nruNnCl64ZRa6u0Dfx4k/XhjcLE3U1VB0sLG+0YniCk2xAvFoT0SJFqZsFDWLAW3dMwOMbcpn3npyyfFHW5BK0d1HHGTWxToVkEWqXHKNoFjq5ZIQhBOyM2o+p38RtApBzG/wSZfDWDpOmKwJPHfgKc1eWIN2HD7YMgdMKGdhovNWrmjhwhzsvpRZA7hy3PG03+a
 XneXu9to
 h7TEOdVxQY89vqAAktg+bAnoerqFlBZRDq75caMzwh65BuupLp1EOdcyfKoF7Qk8I7LuuL4Zh6sBu2eX62luReznMf/iwFqha9DGuYvSq1+3OpNbEX7nZWgqtayQO1azoXbv8m6QIZJ5xRb4Hk6kCwkMXS8x+xOemAA+oC6l/vyeJ3sIezq674vnfJ4ev3XUbj/2UoFfSenBIOvlx5dvFg+M88MFhgqXvh8g+8su6yBd/HR6QH4B+vI7BfF4nqnAfQbGAEGUTtuw3dy5b1fjaluF2peQLtDl9ilNk1Y2dRtSGYQRExdHHTkBgWcmjIjMHBbgnPg2RGngzJFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>   	 *
>> +	 * online_pages is pages within the zone that have an online memmap.
>> +	 * online_pages include present pages and memory holes that have a
>> +	 * memmap. When spanned_pages == online_pages, pfn_to_page() can be
>> +	 * performed without further checks on any pfn within the zone span.
> 
> Maybe pages_with_memmap? It would stand off from managed, spanned and
> present, but it's clearer than online IMHO.

offline pages also have a memmap, but that should not be touched as it 
might contain garbage. So it's a bit more tricky :)

> 
>> +	 *
>>   	 * So present_pages may be used by memory hotplug or memory power
>>   	 * management logic to figure out unmanaged pages by checking
>>   	 * (present_pages - managed_pages). And managed_pages should be used
>> @@ -967,6 +972,7 @@ struct zone {
>>   	atomic_long_t		managed_pages;
>>   	unsigned long		spanned_pages;
>>   	unsigned long		present_pages;
>> +	unsigned long		online_pages;
>>   #if defined(CONFIG_MEMORY_HOTPLUG)
>>   	unsigned long		present_early_pages;
>>   #endif
>> @@ -1051,8 +1057,6 @@ struct zone {
>>   	bool			compact_blockskip_flush;
>>   #endif
>> -	bool			contiguous;
>> -
>>   	CACHELINE_PADDING(_pad3_);
>>   	/* Zone statistics */
>>   	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>> @@ -1124,6 +1128,23 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
>>   	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>>   }
>> +/**
>> + * zone_is_contiguous - test whether a zone is contiguous
>> + * @zone: the zone to test.
>> + *
>> + * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
>> + * spanned zone without requiting pfn_valid() or pfn_to_online_page() checks.
>> + *
>> + * Returns: true if contiguous, otherwise false.
>> + */
>> +static inline bool zone_is_contiguous(const struct zone *zone)
>> +{
>> +	return READ_ONCE(zone->spanned_pages) == READ_ONCE(zone->online_pages);
>> +}
>> +
>>   static inline bool zone_is_initialized(const struct zone *zone)
>>   {
>>   	return zone->initialized;
>> diff --git a/mm/internal.h b/mm/internal.h
>> index f35dbcf99a86..6062f9b8ee62 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -716,21 +716,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>>   static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>>   				unsigned long end_pfn, struct zone *zone)
>>   {
>> -	if (zone->contiguous)
>> +	if (zone_is_contiguous(zone))
>>   		return pfn_to_page(start_pfn);
>>   	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>   }
>> -void set_zone_contiguous(struct zone *zone);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>   			   unsigned long nr_pages);
>> -static inline void clear_zone_contiguous(struct zone *zone)
>> -{
>> -	zone->contiguous = false;
>> -}
>> -
>>   extern int __isolate_free_page(struct page *page, unsigned int order);
>>   extern void __putback_isolated_page(struct page *page, unsigned int order,
>>   				    int mt);
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a63ec679d861..76496c1039a9 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>   		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>>   						zone_end_pfn(zone));
>>   		if (pfn) {
>> -			zone->spanned_pages = zone_end_pfn(zone) - pfn;
>> +			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
>>   			zone->zone_start_pfn = pfn;
>>   		} else {
>>   			zone->zone_start_pfn = 0;
>> -			zone->spanned_pages = 0;
>> +			WRITE_ONCE(zone->spanned_pages, 0);
>>   		}
>>   	} else if (zone_end_pfn(zone) == end_pfn) {
>>   		/*
>> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>   		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
>>   					       start_pfn);
>>   		if (pfn)
>> -			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
>> +			WRITE_ONCE(zone->spanned_pages, pfn - zone->zone_start_pfn + 1);
>>   		else {
>>   			zone->zone_start_pfn = 0;
>> -			zone->spanned_pages = 0;
>> +			WRITE_ONCE(zone->spanned_pages, 0);
>>   		}
>>   	}
>>   }
>> @@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>   	/*
>>   	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>> -	 * we will not try to shrink the zones - which is okay as
>> -	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>> +	 * we will not try to shrink the zones.
>>   	 */
>>   	if (zone_is_zone_device(zone))
>>   		return;
>> -	clear_zone_contiguous(zone);
>> -
>>   	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>   	update_pgdat_span(pgdat);
>> -
>> -	set_zone_contiguous(zone);
>>   }
>>   /**
>> @@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	int nid = pgdat->node_id;
>> -	clear_zone_contiguous(zone);
>> -
>>   	if (zone_is_empty(zone))
>>   		init_currently_empty_zone(zone, start_pfn, nr_pages);
>>   	resize_zone_range(zone, start_pfn, nr_pages);
>> @@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>> -
>> -	set_zone_contiguous(zone);
>>   }
>>   struct auto_movable_stats {
>> @@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
>>   	if (early_section(__pfn_to_section(page_to_pfn(page))))
>>   		zone->present_early_pages += nr_pages;
>>   	zone->present_pages += nr_pages;
>> +	WRITE_ONCE(zone->online_pages,  zone->online_pages + nr_pages);
>>   	zone->zone_pgdat->node_present_pages += nr_pages;
>>   	if (group && movable)
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 2a809cd8e7fa..e33caa6fb6fc 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2263,9 +2263,10 @@ void __init init_cma_pageblock(struct page *page)
>>   }
>>   #endif
>> -void set_zone_contiguous(struct zone *zone)
>> +static void calc_online_pages(struct zone *zone)
>>   {
>>   	unsigned long block_start_pfn = zone->zone_start_pfn;
>> +	unsigned long online_pages = 0;
>>   	unsigned long block_end_pfn;
>>   	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>> @@ -2277,12 +2278,11 @@ void set_zone_contiguous(struct zone *zone)
>>   		if (!__pageblock_pfn_to_page(block_start_pfn,
>>   					     block_end_pfn, zone))
>> -			return;
>> +			continue;
>>   		cond_resched();
>> +		online_pages += block_end_pfn - block_start_pfn;
> 
> I think we can completely get rid of this with something like this untested
> patch to calculate zone->online_pages for coldplug:
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index e33caa6fb6fc..ff2f75e7b49f 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -845,9 +845,9 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>    *   zone/node above the hole except for the trailing pages in the last
>    *   section that will be appended to the zone/node below.
>    */
> -static void __init init_unavailable_range(unsigned long spfn,
> -					  unsigned long epfn,
> -					  int zone, int node)
> +static u64 __init init_unavailable_range(unsigned long spfn,
> +					 unsigned long epfn,
> +					 int zone, int node)
>   {
>   	unsigned long pfn;
>   	u64 pgcnt = 0;
> @@ -861,6 +861,8 @@ static void __init init_unavailable_range(unsigned long spfn,
>   	if (pgcnt)
>   		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
>   			node, zone_names[zone], pgcnt);
> +
> +	return pgcnt;
>   }
>   
>   /*
> @@ -959,9 +961,10 @@ static void __init memmap_init_zone_range(struct zone *zone,
>   	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>   			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>   			  false);
> +	zone->online_pages += (end_pfn - start_pfn);
>   
>   	if (*hole_pfn < start_pfn)
> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		zone->online_pages += init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>   
>   	*hole_pfn = end_pfn;
>   }
> 

Looking at set_zone_contiguous(), __pageblock_pfn_to_page() takes care 
of a weird case where the end of a zone falls into the middle of a 
pageblock.

I am not even sure if that is possible, but we could handle that easily 
in pageblock_pfn_to_page() by checking the requested range against the 
zone spanned range.

Then the semantics "zone->online_pages" would be less weird and more 
closely resemble "pages with online memmap".

init_unavailable_range() might indeed do the trick!

@Tianyou, can you explore that direction? I know, your PTO is coming up.

-- 
Cheers,

David


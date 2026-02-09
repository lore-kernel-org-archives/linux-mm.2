Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB17EE81BAF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 12:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182B36B0005; Mon,  9 Feb 2026 07:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1312D6B0088; Mon,  9 Feb 2026 07:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008706B0089; Mon,  9 Feb 2026 07:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E379B6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:44:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 740BBC029F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:44:55 +0000 (UTC)
X-FDA: 84424887750.17.631CC3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CEEA940002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:44:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gRFOA375;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770641094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQheDunW5zA4NksP28zM3dZYwC3Z3xP31iICASMbDzQ=;
	b=BIkEhUwVflangh4yOvC9SwSEkWeRDurzi7V8CDcPlueuhQnSOjtlSq9VHat396v5CiLtuz
	gyrFKwrYiYpHxRnA5+FA5zQaW3Sy05LJxhJ2jNyI5SmhPVzOdcKo5BoFvq4dtPqpf+fdcw
	FxmN4GOZHKqiCzxfZL4nulQgyP41r4c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gRFOA375;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770641094; a=rsa-sha256;
	cv=none;
	b=uPELz+kXvG4HwygtpIR4SSJ6iVVaLpoDJIy+K3Zj1lFm87ztjCa3DAko1UVM3vzfHwpPza
	q3LmFVtNtVkf+u1wR8dNbx1w81RGfGAAJJhQfk5cwpEKSloT5jHBe5A8y3sIbf+om8mU82
	POHyrE3Pd51dn/1ZF8Rj/DG/c+bJjrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B14734071E;
	Mon,  9 Feb 2026 12:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA5BC16AAE;
	Mon,  9 Feb 2026 12:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770641092;
	bh=G/QXBcfFxtmQ5ukOzTzzyHmFNZaf39JAggsfb/kCTnA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=gRFOA375/sp3no/G6bNeU7wSkj1+o0ceq8erg8RR2B2t0nUUfsPEHnV9KOG87hvAe
	 G/gwYRoJcbHIfrKvm3J4iwwCXN9JL2Z8lV6LhoUFR3EIk8dfFJMzhhPJwT98vAVyiZ
	 UAnlnq7qbR8oYNw8u+gtrPnZriUtLoAEdiw7AW3jbTvLmDhha08MZdS9y0+AeFKzUl
	 1iOuBaKaM5pPjZ/M0LzgkguC/qvqy47YMvL8VFX0zfgWQwCMQEdjGZPjXvw9uD3Ak1
	 HAVBH16kJVDMCb7ATYOqBp1FhQWd6HiTIgAAl92P1iZnQThpxJkFJzSm3xJSZsbIKZ
	 ajkzIXUd0RLdA==
Message-ID: <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
Date: Mon, 9 Feb 2026 13:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CEEA940002
X-Rspamd-Server: rspam07
X-Stat-Signature: it5wfm8u5d8bop68n7amry6nkfxmdg7p
X-HE-Tag: 1770641093-910600
X-HE-Meta: U2FsdGVkX195rUwAdIvW30ddFzIaFvO/cOqwHFDMu2xwKttCod43KJM3szX7lyNk3sG9KfEnYyhw+bzVg+VILFJlQ8FS9mkS6RfMbr11xO8Kl/EZTUUVGeCScA6pTWpxojUW0efKU1ntawDrco0YSfeNuAzJ+bHg2zXmIkJofj+M0JjBDNy2cNhd2zxwpCdWV59zkB3+cHQzHeSdVFonBWKWy4klJE+O90jM0otSLml9DoRq1oYcQ91VQ6xIwcuxmLrx3YHDQwHeGWBsbmx6TF8y/r45Gwz4+Mz53OtNhnplNF/XzWGyFmJ6bRkvkejq/Pulyk1IV/U8/b496tsgULA73ZcrfMs5czLa/Yg2W+mo1oT4nUIXn06xdJfNRGxwXzQrP27bUKSufAbhDRzFeN6d/ojB/Ly/09OZB5x7+5PEC2UQ5adyUD789lMq8j2h+qJ/Jd0JAbGlf8lXZvJOVu5a5fHkL+xntVxcitHffQZSfvwxQteFnBCeQ5mKwGPcBEMwQYErvOyrrwHRFxFGoCu+pk7rx61hRl5L0lI5SUSbkJfg62DxP5rXuhPLW9gCjQ6yqSI9pM3/ku7GApaJ92RZNy1npQh+PYwekkCH+i5i2O5QNOHGhRJ51BHjKA4nvvPN5/L6APBsppRWcQvd9zXDIVLM6DGCLQIoYmfqbw+3UejLl7M8o373XR8tSNGD6AhXcUSXkxk5GkVuFEvq776k/gaXTI6mrhjmOuDkT4BMsHvDWn6VPhv9N/SbYHN773MmOMG1OAhGbZzbY1s0KYoIqEnlJTojaDXGFUGEryyKCELO8jzQsFf5wl2ctOBQc1QvA1HBhhYvh8EBVmsap2CvaPcdWZzTOFvLNGMySzaVi0t4wCcpX9DuvQoSseqtvOnstxGUq2VK6/2mX1XX465Tjcw73My2Ny6Q82aviSM3RdYrLEyW8S9UIDuQQCKLd8n0QjG1I3NvfLXlO1J
 qZDECSMa
 RhrWP+lypdZCit5PTNcqT6HZ9iAHfvXaKxLTf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 11:52, David Hildenbrand (Arm) wrote:
> On 2/8/26 20:39, Mike Rapoport wrote:
>> On Sat, Feb 07, 2026 at 12:00:09PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Thanks for all your work on this and sorry for being slower with
>>> review the last month.
>>>
>>> While I was in the shower I was thinking about how much I hate
>>> zone->contiguous + the pageblock walking, and how we could just get
>>> rid of it.
>>>
>>> You know, just what you do while having a relaxing shower.
>>>
>>>
>>> And I was wondering:
>>>
>>> (a) in which case would we have zone_spanned_pages == zone_present_pages
>>> and the zone *not* being contiguous? I assume this just cannot happen,
>>> otherwise BUG.
>>>
>>> (b) in which case would we have zone_spanned_pages != zone_present_pages
>>> and the zone *being* contiguous? I assume in some cases where we have 
>>> small
>>> holes within a pageblock?
>>>
>>> Reading the doc of __pageblock_pfn_to_page(), there are some weird
>>> scenarios with holes in pageblocks.
>> It seems that "zone->contigous" is really bad name for what this thing
>> represents.
>>
>> tl;dr I don't think zone_spanned_pages == zone_present_pages is 
>> related to
>> zone->contigous at all :)
> 
> My point in (a) was that with "zone_spanned_pages == zone_present_pages" 
> there are no holes so -> contiguous.
> 
> (b), and what I said further below, is exactly about memory holes where 
> we have a memmap, but it's not present memory.
> 
>>
>> If you look at pageblock_pfn_to_page() and __pageblock_pfn_to_page(), the
>> check for zone->contigous should guarantee that the entire pageblock 
>> has a
>> valid memory map and that the entire pageblock fits a zone and does not
>> cross zone/node boundaries.
> 
> Right. But that must hold for each and ever pageblock in the spanned 
> zone range for it to be contiguous.
> 
> zone->contigous tells you "pfn_to_page()" is valid on the complete zone 
> range"
> 
> That's why set_zone_contiguous() probes __pageblock_pfn_to_page() on ech 
> and ever pageblock.
> 
>>
>> For coldplug memory the memory map is valid for every section that has
>> present memory, i.e. even it there is a hole in a section, it's memory 
>> map
>> will be populated and will have struct pages.
> 
> There is this sub-section thing, and holes larger than a section might 
> not have a memmap (unless reserved I guess).
> 
>>
>> When zone->contigous is false, the slow path in __pageblock_pfn_to_page()
>> essentially checks if the first page in a pageblock is online and if 
>> first
>> and last pages are in the zone being compacted.
>> AFAIU, in the hotplug case an entire pageblock is always onlined to the
>> same zone, so zone->contigous won't change after the hotplug is complete.
> 
> I think you are missing a point: hotp(un)plug might create holes in the 
> zone span. Then, pfn_to_page() is no longer valid to be called on 
> arbitrary pageblocks within the zone.
> 
>>
>> We might set it to false in the beginning of the hotplug to avoid 
>> scanning
>> offline pages, although I'm not sure if it's possible.
>>
>> But in the end of hotplug we can simply restore the old value and move 
>> on.
> 
> No, you might create holes.
> 
>>
>> For the coldplug case I'm also not sure it's worth the hassle, we could
>> just let compaction scan a few more pfns for those rare weird pageblocks
>> and bail out on wrong page conditions.
> 
> To recap:
> 
> My idea is that "zone_spanned_pages == zone_present_pages" tells you 
> that the zone is contiguous because there are no holes.
> 
> To handle "non-memory with a struct page", you'd have to check
> 
>      "zone_spanned_pages == zone_present_pages +
>           zone_non_present_memmap_pages"
> 
> Or shorter
> 
>      "zone_spanned_pages == zone_pages_with_memmap"
> 
> Then, pfn_to_page() is valid within the complete zone.
> 
> The question is how to best calculate the "zone_pages_with_memmap" 
> during boot.
> 
> During hot(un)plug we only add/remove zone_present_pages. The 
> zone_non_present_memmap_pages will not change due to hot(un)plug later.
> 

The following hack does the trick. But

(a) I wish we could get rid of the pageblock walking in calc_online_pages().
(b) "online_pages" has weird semantics due to the pageblock handling.
     "online_pageblock_pages"? not sure.
(c) Calculating "online_pages" when we know there is a hole does not make sense,
     as we could just keep it 0 if there are holes and simply set it to
     zone->online_pageblock_pages->zone->spanned_pages in case all are online.


 From d4cb825e91a6363afc68fb994c5d9b29c38c5f42 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 9 Feb 2026 13:40:24 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
  include/linux/mmzone.h | 25 +++++++++++++++++++++++--
  mm/internal.h          |  8 +-------
  mm/memory_hotplug.c    | 20 ++++++--------------
  mm/mm_init.c           | 12 ++++++------
  4 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fc5d6c88d2f0..3f7d8d88c597 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -943,6 +943,11 @@ struct zone {
  	 * cma pages is present pages that are assigned for CMA use
  	 * (MIGRATE_CMA).
  	 *
+	 * online_pages is pages within the zone that have an online memmap.
+	 * online_pages include present pages and memory holes that have a
+	 * memmap. When spanned_pages == online_pages, pfn_to_page() can be
+	 * performed without further checks on any pfn within the zone span.
+	 *
  	 * So present_pages may be used by memory hotplug or memory power
  	 * management logic to figure out unmanaged pages by checking
  	 * (present_pages - managed_pages). And managed_pages should be used
@@ -967,6 +972,7 @@ struct zone {
  	atomic_long_t		managed_pages;
  	unsigned long		spanned_pages;
  	unsigned long		present_pages;
+	unsigned long		online_pages;
  #if defined(CONFIG_MEMORY_HOTPLUG)
  	unsigned long		present_early_pages;
  #endif
@@ -1051,8 +1057,6 @@ struct zone {
  	bool			compact_blockskip_flush;
  #endif
  
-	bool			contiguous;
-
  	CACHELINE_PADDING(_pad3_);
  	/* Zone statistics */
  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
@@ -1124,6 +1128,23 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
  	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
  }
  
+/**
+ * zone_is_contiguous - test whether a zone is contiguous
+ * @zone: the zone to test.
+ *
+ * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
+ * spanned zone without requiting pfn_valid() or pfn_to_online_page() checks.
+ *
+ * Returns: true if contiguous, otherwise false.
+ */
+static inline bool zone_is_contiguous(const struct zone *zone)
+{
+	return READ_ONCE(zone->spanned_pages) == READ_ONCE(zone->online_pages);
+}
+
  static inline bool zone_is_initialized(const struct zone *zone)
  {
  	return zone->initialized;
diff --git a/mm/internal.h b/mm/internal.h
index f35dbcf99a86..6062f9b8ee62 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -716,21 +716,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
  				unsigned long end_pfn, struct zone *zone)
  {
-	if (zone->contiguous)
+	if (zone_is_contiguous(zone))
  		return pfn_to_page(start_pfn);
  
  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
  }
  
-void set_zone_contiguous(struct zone *zone);
  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
  			   unsigned long nr_pages);
  
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
  extern int __isolate_free_page(struct page *page, unsigned int order);
  extern void __putback_isolated_page(struct page *page, unsigned int order,
  				    int mt);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..76496c1039a9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
  		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
  						zone_end_pfn(zone));
  		if (pfn) {
-			zone->spanned_pages = zone_end_pfn(zone) - pfn;
+			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
  			zone->zone_start_pfn = pfn;
  		} else {
  			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
+			WRITE_ONCE(zone->spanned_pages, 0);
  		}
  	} else if (zone_end_pfn(zone) == end_pfn) {
  		/*
@@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
  		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
  					       start_pfn);
  		if (pfn)
-			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
+			WRITE_ONCE(zone->spanned_pages, pfn - zone->zone_start_pfn + 1);
  		else {
  			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
+			WRITE_ONCE(zone->spanned_pages, 0);
  		}
  	}
  }
@@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
  
  	/*
  	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
-	 * we will not try to shrink the zones - which is okay as
-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 * we will not try to shrink the zones.
  	 */
  	if (zone_is_zone_device(zone))
  		return;
  
-	clear_zone_contiguous(zone);
-
  	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
  	update_pgdat_span(pgdat);
-
-	set_zone_contiguous(zone);
  }
  
  /**
@@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
  	struct pglist_data *pgdat = zone->zone_pgdat;
  	int nid = pgdat->node_id;
  
-	clear_zone_contiguous(zone);
-
  	if (zone_is_empty(zone))
  		init_currently_empty_zone(zone, start_pfn, nr_pages);
  	resize_zone_range(zone, start_pfn, nr_pages);
@@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
  			 MEMINIT_HOTPLUG, altmap, migratetype,
  			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
  }
  
  struct auto_movable_stats {
@@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
  	if (early_section(__pfn_to_section(page_to_pfn(page))))
  		zone->present_early_pages += nr_pages;
  	zone->present_pages += nr_pages;
+	WRITE_ONCE(zone->online_pages,  zone->online_pages + nr_pages);
  	zone->zone_pgdat->node_present_pages += nr_pages;
  
  	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2a809cd8e7fa..e33caa6fb6fc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2263,9 +2263,10 @@ void __init init_cma_pageblock(struct page *page)
  }
  #endif
  
-void set_zone_contiguous(struct zone *zone)
+static void calc_online_pages(struct zone *zone)
  {
  	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long online_pages = 0;
  	unsigned long block_end_pfn;
  
  	block_end_pfn = pageblock_end_pfn(block_start_pfn);
@@ -2277,12 +2278,11 @@ void set_zone_contiguous(struct zone *zone)
  
  		if (!__pageblock_pfn_to_page(block_start_pfn,
  					     block_end_pfn, zone))
-			return;
+			continue;
  		cond_resched();
+		online_pages += block_end_pfn - block_start_pfn;
  	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
+	zone->online_pages = online_pages;
  }
  
  /*
@@ -2348,7 +2348,7 @@ void __init page_alloc_init_late(void)
  		shuffle_free_memory(NODE_DATA(nid));
  
  	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
+		calc_online_pages(zone);
  
  	/* Initialize page ext after all struct pages are initialized. */
  	if (deferred_struct_pages)
-- 
2.43.0


-- 
Cheers,

David


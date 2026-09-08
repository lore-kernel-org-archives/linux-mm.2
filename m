Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26AE5C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 04:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161936B008A; Tue,  8 Sep 2026 00:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B656B008C; Tue,  8 Sep 2026 00:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0208F6B0092; Tue,  8 Sep 2026 00:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF0FA6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:09:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68F5B403A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:09:38 +0000 (UTC)
X-FDA: 85189266036.12.645123C
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4BEA420008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:09:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jDgC7zY/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788840576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETu/+IdC6wkVcR7kfefhUdeU0dpDBUqiUlZER/ibfSw=;
	b=AIYfJyJ7M/ptSiP2dGSCjTlS0WrN4/jt4p0RAbr4LD4QOc6AtAKUhovnVE1MyoslrPKGYR
	ZDAI6BLa4HLgEclVKCOnGgCCPOzIfjvxdOpweBl6ZsbOwvj4TKf4FKGupCPkvvjQSrNOE3
	T6tRtwqpr+ogr/deT915VZrZ/CGVVn4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jDgC7zY/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788840576;
	b=Lg0eo/2DyreKIpxkWG9ckbS+RUqJo6DTE8fXz36rqSRZXkDJ/o7tyfzuw9J9z4m23rmglV
	5IVm4MzexUb9QfgQbuytc2Lrw8Fi4QXm1dsPwG4CMqnqcUNlohhziKPsVXCNo8QLZiwvcD
	B/T8mli+gw4R+ukdoLXqYzonQ0UI7ko=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x0VZgiJePeWqh4cLtuV0TthQ7an0Lkb4/kBk4eS0cSE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788840574; v=1; x=1789445374;
 b=jDgC7zY/V8BLQEIKy7tVWfyP1jb6jwZKpSpVTU1oDt517zH1yH4hWw4bvBBkqoF0UzFDXJ1n
 73mC2oiYNg27wKdSWPan61KUYJra/CdLbsMz6stVUtOoKVDQeNDwGDcK+x5LDNb0AEN/2DnDGhU
 skM3qTLJpQoRHK9T3zt7N668=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aa67825df359c637;
	Tue, 08 Sep 2026 04:09:34 +0000
X-Mizu-Trace-ID: aa67825df359c637
X-Migadu-Flow: FLOW_OUT
Message-ID: <3856ab3a-5bc6-4483-a116-601ae431b2c1@linux.dev>
Date: Tue, 8 Sep 2026 12:09:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] mm/sparse-vmemmap: switch device DAX to shared
 tail vmemmap pages
To: Muchun Song <songmuchun@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-7-songmuchun@bytedance.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260908030335.96549-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6uc339uif3emzeqkyg9d9aronfwqkmp4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BEA420008
X-Rspam-User: 
X-HE-Tag: 1788840576-947436
X-HE-Meta: U2FsdGVkX1/DdtUndQN7mNV+6I5ezbvPax6t3ChXmQDqFWtmaZ0C5l9UAvkrR3F1Jpnvd4sxZhLaHPW1BuY7EL/iK+q0MJA/U8ESNmoQh7YS4nscVdLRs00TqDcXPEit6zu2tKl1IXDMjFQrwjJvm8iBuxZhscBAIyW3CdFxkf/sPtkT+QAQNrPaCv7D/eIx8mr60/NPhLWFv17XNP1c3VBlnscY7p3Ufj2ia2EuhsLAW45MHA9NLZoZ+nZGGpBLc+/E273hyWUX06GA6DznbDsGjIh4DOB0+htCAox+EhqaIeLODqK78hLt3jHTz7CRdTk0DLbKL4Mr20YfWNjgvX2eviwjUvAEPALbq4I+dPmGOt70r3W+4x95fHBuKrJ9YL1YeJS4WoJgvyi2Az6ujcMTHfah8TyXy7D38qZNw4XjzeIFDNLNi7pZxEL/0eU6jcTe21BtKpIaIr+apNxhUIeOBmYetTmXpYNvITxRtYoQ0A0ay3E2LVN6/+FbKe1aq4IL3DPXd8peK6sifphujcn+ewEWaXxan1r4XUELckKclOvGR9xy9iytIgOauiCgSbC5+VKZkvEe+PvpY3RnEN470Fnnhqin5lNoQoqf7gdgO3e0lun0Jd/48+X0waRxd0bnMaJxAbUjD7vZ/g7MR5DwN+Nek39bggwDX3sLu9ncMaFJgfH231zVTBNhAWCVFXQcAs9DJphG1IcDroo1EBoIUC5yKN2RECiCr7UL2os3lG/GLgBbLsrpR+hB3CaphCPGyjKE0lRi6H0GsVZJ6BGdNTKDW9oaTY2lBkvjPvHgG4Mv02OtRGX2b5dxsefj5BkuN1LRkQuyS0S8FCFcY8tRh26gksvem674tP4xWmhhEcW8hrKKTvMHw42GrMRC+LPmjMT6TIKtLzEZ0tOKt1ggKNkIBDTJC4bsMFX8KjB0WJ0fVMaC8iiujy3beW1GD7Hweo5Fku03nQ8qrNB
 LJ9SYM0y
 Guz1evmKUaFXjN9Q0QqhW/BuyxDFUc+M4JfUqFM3656BxG5PHVRYSvg5D59S/IDSt5ecWYpGw5yt7fRg1cmFtaAmDljDSmbxGaTccXjEx61Fhc4AKtUaXJ8MPJOVjY/S3ro4vNHZqA+J/jm5GzZuS2z6nWpJmO5Kc3lvPo2IEFIe5CtG3ehQWsTs2K5DURHNBKP+WAqm9BQy3/8bYjlfsriFwVvos0K4lVkmXtccnlXNok+YAsf2DDVRhyffHgFADmGClJAE7k+bL92ZEblIa0LaYVwIZtYXyEmdsH4pMjcwaDcHqQ1iKtlZjDZU5TeggSBY8NoprF+PVOHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/8 11:03, Muchun Song wrote:
> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
> Device DAX has not been switched to that mechanism yet.
>
> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
> with HugeTLB by using the common per-zone shared tail vmemmap page.
>
> The optimization is enabled only for DEV-DAX through pgmap->vmemmap_shift,
> which is assigned when a DEV-DAX device is initialized. Unlike FS-DAX,
> DEV-DAX does not modify tail struct pages, so sharing them is safe.
>
> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
> initialize its entries with PG_reserved for device zones. Also skip
> poisoning vmemmap-optimizable sections while their struct pages may be
> shared.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Explain why sharing tail vmemmap pages is safe for DEV-DAX
>    (suggested by Qi Zheng)
> ---
>   include/linux/mmzone.h | 10 +++++++++
>   mm/memory_hotplug.c    |  5 +++--
>   mm/sparse-vmemmap.c    | 47 ++++++++++++++----------------------------
>   3 files changed, 28 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index d3778ba976a5..03ed9232f186 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1686,11 +1686,21 @@ static inline bool zone_is_zone_device(const struct zone *zone)
>   {
>   	return zone_idx(zone) == ZONE_DEVICE;
>   }
> +
> +static inline struct zone *device_zone(int nid)
> +{
> +	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
> +}
>   #else
>   static inline bool zone_is_zone_device(const struct zone *zone)
>   {
>   	return false;
>   }
> +
> +static inline struct zone *device_zone(int nid)
> +{
> +	return NULL;
> +}
>   #endif
>   
>   /*
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index b428da66d279..0db0379826df 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -554,8 +554,9 @@ void remove_pfn_range_from_zone(struct zone *zone,
>   		/* Select all remaining pages up to the next section boundary */
>   		cur_nr_pages =
>   			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
> -		page_init_poison(pfn_to_page(pfn),
> -				 sizeof(struct page) * cur_nr_pages);
> +		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
> +			page_init_poison(pfn_to_page(pfn),
> +					 sizeof(struct page) * cur_nr_pages);
>   	}
>   
>   	/*
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index aed1e7429daa..0201877a7f80 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -193,6 +193,8 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
>   		set_page_node(page, zone_to_nid(zone));
>   		set_page_zone(page, zone_idx(zone));
>   		prep_compound_tail(page, NULL, order);
> +		if (zone_is_zone_device(zone))
> +			__SetPageReserved(page);

Sashiko said: "
   Could setting PG_reserved here cause a use-after-free
   during device hot-remove?

   When a DEV-DAX device is removed and vmemmap_free is called,
   remove_pte_table calls free_vmemmap_pages. In free_vmemmap_pages,
   the PG_reserved flag redirects execution:

   arch/x86/mm/init_64.c:free_vmemmap_pages() {
       ...
       else if (PageReserved(page))
           free_reserved_pages(page, order);
   }

   Does this forcefully drop the refcount and free the shared
   page to the buddy allocator, leaving a dangling pointer in
   zone->vmemmap_tails[idx] that breaks other DAX devices
   sharing this page?
"

It is a false positive.

The struct page marked reserved here is an entry stored
inside the shared vmemmap backing page; after mapping, it
represents a Device DAX tail page. It is not the struct
page describing the backing page itself.

remove_pte_table() passes pte_page(*pte) to free_vmemmap_pages(),
which is the latter. The runtime-allocated backing page is
not reserved, so removal takes the __free_pages() path. Each
reused PTE takes a reference via get_page(), and removal
drops one such reference, while the allocation reference
retained by zone->vmemmap_tails[] remains. Therefore removing
one DAX device does not free the shared backing page or leave
a dangling pointer.

>   	}
>   
>   	page = virt_to_page(addr);
> @@ -490,23 +492,6 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
>   	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
>   }
>   
> -static pte_t * __meminit compound_section_tail_page(unsigned long addr)
> -{
> -	pte_t *pte;
> -
> -	addr -= PAGE_SIZE;
> -
> -	/*
> -	 * Assuming sections are populated sequentially, the previous section's
> -	 * page data can be reused.
> -	 */
> -	pte = pte_offset_kernel(pmd_off_k(addr), addr);
> -	if (!pte)
> -		return NULL;
> -
> -	return pte;
> -}
> -
>   static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   						     unsigned long start,
>   						     unsigned long end, int node,
> @@ -516,21 +501,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   	pte_t *pte;
>   	int rc;
>   	unsigned long flags = VMEMMAP_POPULATE_DAX;
> +	struct page *page;
> +	unsigned int order = pfn_to_section_order(start_pfn);
>   
> -	if (reuse_compound_section(start_pfn, pgmap)) {
> -		pte = compound_section_tail_page(start);
> -		if (!pte)
> -			return -ENOMEM;
> +	page = vmemmap_shared_tail_page(order, device_zone(node));
> +	if (!page)
> +		return -ENOMEM;
>   
> -		/*
> -		 * Reuse the page that was populated in the prior iteration
> -		 * with just tail struct pages.
> -		 */
> +	if (reuse_compound_section(start_pfn, pgmap))
>   		return vmemmap_populate_range(start, end, node, NULL,
> -					      pte_pfn(ptep_get(pte)), flags);
> -	}
> +					      page_to_pfn(page), flags);
>   
> -	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
> +	size = min(end - start, (1UL << order) * sizeof(struct page));
>   	for (addr = start; addr < end; addr += size) {
>   		unsigned long next, last = addr + size;
>   
> @@ -546,12 +528,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>   			return -ENOMEM;
>   
>   		/*
> -		 * Reuse the previous page for the rest of tail pages
> +		 * Reuse the shared page for the rest of tail pages
>   		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
>   		 */
>   		next += PAGE_SIZE;
>   		rc = vmemmap_populate_range(next, last, node, NULL,
> -					    pte_pfn(ptep_get(pte)), flags);
> +					    page_to_pfn(page), flags);

Another report is like:

"
   When this shared tail page is used to back the
   DEV-DAX tail pages, could concurrent initialization
   corrupt the compound_head pointer for the entire
   node?

   Looking at memmap_init_zone_device which calls
   memmap_init_compound, the head page template is copied
   unconditionally into the tail pages:

   mm/mm_init.c:memmap_init_compound() {
       for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
           zone_device_page_init_from_template(pfn_to_page(pfn), pfn, 
&template);
   }

   Since page_to_pfn(page) here points to a node-wide
   shared physical page, would this template copy overwrite
   the compound_head for all DEV-DAX tail pages on the node
   to point to the latest initialized PMD's head page?
"

This is also a false positive.

memmap_init_compound() does not initialize the full
compound range when the section uses vmemmap optimization.
compound_nr_pages() limits it to:

   2 * PAGE_SIZE / sizeof(struct page)

i.e. exactly the entries in the retained vmemmap page.
The shared mappings start at addr + PAGE_SIZE, so the
template-copy loop stops before reaching them.

Thanks
Muchun

>   		if (rc)
>   			return -ENOMEM;
>   	}
> @@ -883,13 +865,14 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>   	if (IS_ERR(memmap))
>   		return PTR_ERR(memmap);
>   
> +	ms = __nr_to_section(section_nr);
>   	/*
>   	 * Poison uninitialized struct pages in order to catch invalid flags
>   	 * combinations.
>   	 */
> -	page_init_poison(memmap, sizeof(struct page) * nr_pages);
> +	if (!section_vmemmap_optimizable(ms))
> +		page_init_poison(memmap, sizeof(struct page) * nr_pages);
>   
> -	ms = __nr_to_section(section_nr);
>   	__section_mark_present(ms, section_nr);
>   
>   	/* Align memmap to section boundary in the subsection case */



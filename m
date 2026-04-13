Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CE2EBFD20
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0214B6B0089; Mon, 13 Apr 2026 05:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14CD6B008A; Mon, 13 Apr 2026 05:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A346B0092; Mon, 13 Apr 2026 05:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D50A86B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:32:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6993513C22B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:32:40 +0000 (UTC)
X-FDA: 84653017680.02.CBCE0EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CFB3010000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:32:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNn9OWyN;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776072758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KMOAZ7SVr6g5vUKFGrCwww5uVj/ZVa5plkq1tQ6p9A=;
	b=G+KI+il4X3DVkewOL7UHntoXSR3Yg3og0hUy5v2QvWbMdUiGqssJHtz7J3ZbtBGJjieMsM
	zYmi8+hyolI0MkMAM2wNOzok8FxBJXJfzSj1fSVWF/c4wez57mN17fIsZPb6ti8yO0+nmy
	+zaf9pzGoz886IGeRS/EsT3qX8t6FJI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNn9OWyN;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776072758; a=rsa-sha256;
	cv=none;
	b=unWMCZwmOKYhtpBzY2al8wvmv4ZeKHrwdJ5Gfp3DsC2bt4QQcb5CpE1iCtj0ZDH/0I4qj6
	IP91TSonYP1njCzt1Et9i8YHeOFcUi2NjsreIZkf3VMJb2qHoYsrLBKwQgBxhY01yhjYED
	yyuDSG/Hpd12wNAtFZ/Z0xuuZ765LJo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A71060172;
	Mon, 13 Apr 2026 09:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6FAC116C6;
	Mon, 13 Apr 2026 09:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776072758;
	bh=JRZWemltksdWoEBhaBDF2gLrvxOl6lymdz6gK0hrGbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tNn9OWyN2iOjVuYi6CPt63fahnmPUSEpc9OBeODdPvpBmVWVqEJ9VkP/s3F3/LkWc
	 M3D6XOlui3DwCNa/oRFVZYcFelpdBxw1uzz2hyPoj9IeevEzAwY4gfIg9vLVwkRUjN
	 1o9lyi5gDuYluIyQ7YS3c+gqJMTJElNAfV2DFF6S5DMap2bmm50mlJdjs1nzl61nrp
	 GCd9cHivlBrgRl4bJ/YXyhK06h7Zhzwg0lrqFtnA8fQqNdMFgrcUPHOa8To2zbUdwo
	 HylUc08gkSGh8JQFkgI56dvl+nF8OSz4o1mp/5aTj4GMZWDP20ZX+UrfAB1EBa7Caq
	 U0B3CRA5lKHxQ==
Date: Mon, 13 Apr 2026 12:32:28 +0300
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
Subject: Re: [PATCH 06/49] mm/mm_init: fix uninitialized pageblock
 migratetype for ZONE_DEVICE compound pages
Message-ID: <ady4LBppz-na5lM5@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-7-songmuchun@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFB3010000B
X-Stat-Signature: 3timajj4rq115scq1robgc149nuin1cr
X-Rspam-User: 
X-HE-Tag: 1776072758-115749
X-HE-Meta: U2FsdGVkX1/Vbw1t3/tcB6WHjkBXYTyJdaVnmClC3FiLduH66Wf039yNrAPyAPNBaj7HvPiiNLihlGScBYpwar1A2JFw/yIXT9qn9BrxGn8NzC1ELx8Jlag9Zmv76Cx5PnvQfoPgDcqeDgKV7Tkjnmo24kOZCXchhwsxx0Ko8czOWVY7KsoGo9ExZMFTr8aK6it6ud+JridKrErmWbp4aoz0uXSbJdbE+sVnRTFPUeRZsDq9eRd3KucKKOWUu19kbI7v0A6yJ5tWWLeKR6IA4qSRftZFm/OY14B5lqGcI4q2VU6B8qm0zpAm3NPyv6/5YlK3oEQTidwLDrBBknm6jKRafxXSFhEvQHyJObcYDJP60UfMhrjEDXRLAy1CgZYLT1Lc44cUTh9YT0Kz1jq5iAj3IyarCZ5NHS4DaWRKYZmmflEixzLvvdzcKfYwpugjb8mnMw0nPkB3RvvkK1Xwc+tujeGSBL0lPkDBt2EbVURv5z2V0GrAZIO3C+Xa2s3QzDQk9f9Ciace/areGEOO6Npi/I50meAKlg8Z+ZIrM4z7/PhStFPhieV9ZQfv+NllIrb7aGy9KLh5NRHcMn7NTFY0CDSMj+3GJlA1ixAVQqQt8TEjPQ4ImBt94qaU2yjZ7Ka+aQUAizDz/e1CbuZFdlETzlVA7m5/kdiNpO2mEmMDOu0Jy+AsXV7QTXNytE5ufaAFrMCEyDwGsS4z6W5igXoAcGKfSQevzRFz/dhKkk2GhwEpaB3kVaXAIA6LBAt9xnbFdv4S1vszBDL+rJ1EfaV5aTETb/oF+ip+A22wEPrzmxOFdqfPxtJZzVSpu8eCV0Giu6cHqInNENOx5VIPkyE1bvb239/AGXXJCmuntXS5zY8eUqRn6h+FZ7CaoSvEi7LDwnWEReQM01avIDIpz2NbqvI8ZKxWeBhHR7XBBtHIGBBkUSp9iX2hLq6yU5vRi2w94wCqwUYP93unewX
 Hj91AWuM
 xC6QqCWmqwxr0nu4ajuYoH74LRg276clVhzgt/nEohVgbPRZS4tmoWB8dEr6JZOuO2A3oYQgM9X2cc64QtUJQzqT9tAK5ObQ2gJFLWQ1VsKMzGyF7tlJl0/AZEPkjw6rctyCVcvWHqLrFuviBGzCxG2CljQV7QxI5k8LtbpHphyyau4aEKIlog8+QxhkuK3fwpktyYTVsCTfIRYhvPjRM0P6jhdorlmAAsCxaDvxU09Q5hoB/nd+lkLOQSP7OUijhHTT4mH2/oN6VClhw1gYiEzqRo8S69kDFmGJk5pB9cPy0YGM2yqzXsbOwWB1vdRLN0IY1RLeEXaykttc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:51:57PM +0800, Muchun Song wrote:
> Previously, memmap_init_zone_device() only initialized the migratetype
> of the first pageblock of a compound page. If the compound page size
> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> subsequent pageblocks in the compound page would remain uninitialized.
> 
> This patch moves the migratetype initialization out of
> __init_zone_device_page() and into a separate function
> pageblock_migratetype_init_range(). This function iterates over the
> entire PFN range of the memory, ensuring that all pageblocks are correctly
> initialized.
> 
> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/mm_init.c | 41 ++++++++++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 9a44e8458fed..4936ca78966c 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -674,6 +674,18 @@ static inline void fixup_hashdist(void)
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
> +		cond_resched();

Do we need to call cond_resched() every iteration here?

> +	}
> +}
> +
>  /*
>   * Initialize a reserved page unconditionally, finding its zone first.
>   */
> @@ -1011,21 +1023,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
> @@ -1122,6 +1119,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  
> +		cond_resched();

Originally we called cond_resched() once per pageblock, now it's called
once per page plus for every pageblock in the tight loop that sets the
migrate type. Isn't it too much?

> +
>  		if (pfns_per_compound == 1)
>  			continue;
>  
> @@ -1129,6 +1128,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
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


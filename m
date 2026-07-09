Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467C9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0798E6B008C; Thu,  9 Jul 2026 06:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E626B0092; Thu,  9 Jul 2026 06:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE94E6B0093; Thu,  9 Jul 2026 06:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4A186B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:45:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37B808E184
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:45:45 +0000 (UTC)
X-FDA: 84968907450.15.E32FDF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A327E40006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:45:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGulu5Zy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783593943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOpYD6ZRcmuhibOLDuRYZLKQNBiTJQnRVmlbmamWuH0=;
	b=Z1Ml6+VffbkCpA11o5XU83/1JyKgr+Fb7cG732TncyPGLvdYwqRTU8tVYv4A0tNZklziYg
	ozqFJb51TpETQUKb/AGDr35nrPkqAlENPS77UVompm0OHIbeI63HKmh+Sz+k/ErdEiK91Y
	eFhr+qLhjxttK78r6zjsEkupI+tG2wA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGulu5Zy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783593943;
	b=x6Q3paRaM1smSZ7JaKJfnJ3E/bAIOAil3GrCCnQp5Qujbwq43jm3Gd6qDaLz/uOcsTnWUu
	2F7Z57reS9hvJryWqmGAzeABTvArms8vF8++cF+wYuaJ4EAiVnkgRHwVvdLHGIv9V+dVz6
	ro7/CLCx3UCZrNBKLoveEiAyfXYc3aA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 139C1600C3;
	Thu,  9 Jul 2026 10:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5483A1F000E9;
	Thu,  9 Jul 2026 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783593942;
	bh=UOpYD6ZRcmuhibOLDuRYZLKQNBiTJQnRVmlbmamWuH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EGulu5ZyFyUvVdMAfBtWjFgP8rSSL0HpiletGPpKEn0Zuh8N4ftMXXFQ4mqZZiD5J
	 IVJycgTh1khV6E9wsVdMvWeB95R18aEUav5FpKBGMmjbHkfGt3m6w9cKVbPk5blw44
	 UKYj8ghbMdkBaegXU4VhgUbin+dNH1COOq1cT+6C4JQuZfL1xER+hpAA7sc4pJqRIN
	 kcb/Jlmaz9v+dQN+teZ6dvEKEkuIBU1V3nahtuELsHI15aHITRbAERcvVIPY4EoE3C
	 SKkxZRXF5PJRba37woZvUK9GfmIvY2gnJe3DyjTQ9FtBKHY2sa96iT4GJ1dUhmH+0Q
	 6/A5Jt7Wz+org==
Date: Thu, 9 Jul 2026 13:45:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH 04/17] mm/mm_init: skip initializing shared vmemmap tail
 pages
Message-ID: <ak97z4tryYAGJgb_@kernel.org>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-5-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702093821.2740183-5-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A327E40006
X-Stat-Signature: 7u7yqt7xw4o33mcpeuqn4r4s4pck4kmn
X-HE-Tag: 1783593943-195135
X-HE-Meta: U2FsdGVkX19xl2c7NU5wFj//8IB3gpGJaiF8100pLAJ+fthwAZu8GqxU1O2uZlPqafnE0Ut0yzPOy8+jJywLouF0GgGzxJBJXH4kJDyLU+cr3Y6ILS8H2tVo2GdMmXUOMljrMiiXqxtrbR7YSqZQrYqMV6iSbqMONLbwK8INmJ3cyYl7j2jb7DKbi0PJ7XmfiAEBnpHxffFDZEbGjRTHjbPjQmS2XJ1kqQ1ArSGhERJyAtce1ZRgFPgzrN7AWRA0tVzxkHxVBLWKE7fJu1NbfZRThogd/0TGPrr7SCkey69deczWO2M8anebdVIlDTSpVZ0yI89q1nmsVyI8xXa5Isgw6F7G1fhVqQyIwAl+ovux3/vqeKlDkPqdRAhElL+HH5O/LXkuA18AxhGhfgIuFRjSAX3Ytsh6kRaI8ypK2u6JkfMI3RIwc5u9X1vnrhGFGhiqFxWn7hFzd6gWFJMsAtEPk8t0BQ+lrVVfcfk9c3LKGQ0Plwp2W9jvVGJeFiLvllX39QGES5Zu33B61pW6PXFgL9yNubjgOlqDzSu8+nKnYny0VuuAmjDBYoY921bFNXHKHwYxnqCrSCAMurgXy4bXtTvvxYJY1Mi7EoZe2Q+LGJp4Cqf721bvL587HfNZi1qjpP6WQFg+0HysbgKBYeXtM4rz+lwhZygtS6bQVOH2PBib4J+ILUONnxEo01xw+neyMoxle8hWut1FPqW4LTBdthWXUnjCNQ/GhfAPnnotLJkmD298ZW5ZtQCQDePMUGiSnCs+lXuqAFQn2WrzLq+ew6StMIwOLfBlUt+7TUWX+3g4syuxLPgwSvMPkZZ9Jez9P1AeK+8ic+7KtU2wtX0N4rSCQiXCadj6vOzSxW2KZUmh44//a9+PoaaQAfKotRN05+oU3dfAE1ztI5Cc7VXq9pqwNGaWyVzV/axqJli0uFiiNriwMtgTfN/qU82F1RlneY+RRtWi5DFCsGJ
 VSvl3upQ
 VKZ9EceOFGh1dsfR3U7cIeZk4x3hfHR7rQvjD9omu4rPdt1dZKq3Jkgvy5gtdF7IpI4uuHB3uTLVRXrQ99HyV+qY4+DYZo7YMOCTYBsD5axLJPESoIi7Pgh8UwYx2ZXylIsRYjgvGMbWOYeA3sOTV4Bm3o2uJeGJ4kfpxkn+G+eVqaL6DUuPdT4dcmvG9mYBn2Fc6r49QEEQDfXXBhFUMo7wf6RP8HD7TXjEwcH8r1N+qpG8kDIksuPGUWTLifEOOlov5h54v5GasfFO85XO2BHDF4XQaLMrgx6u7gNHV1xLFM1vbrxxxCPdJ+LlQAfnjExAW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

Below are some preliminary comments, I'm planning to spend more time on
review next week.

On Thu, Jul 02, 2026 at 05:38:08PM +0800, Muchun Song wrote:
> memmap_init_range() initializes every struct page in the target range.
> For compound pages with vmemmap optimization, the tail struct pages are
> backed by a shared vmemmap page.
> 
> Initializing those tail struct pages would overwrite the shared
> vmemmap page contents, so users such as HugeTLB have to open-code
> follow-up handling to restore the metadata afterwards.
> 
> Use the section's compound page order to detect struct pages that fall
> into the shared tail vmemmap range and skip their initialization in
> memmap_init_range().  Still initialize the pageblock migratetypes for
> the skipped range so the surrounding setup remains intact.
> 
> This is a preparatory change for consolidating handling across users of
> vmemmap optimization, and it also avoids redundant initialization of
> shared tail vmemmap pages during early boot.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/mmzone.h |  4 ++++
>  mm/internal.h          | 16 ++++++++++++++++
>  mm/mm_init.c           | 25 +++++++++++++++++++------
>  3 files changed, 39 insertions(+), 6 deletions(-)
> 
> @@ -673,19 +673,21 @@ static inline void fixup_hashdist(void)
>  static inline void fixup_hashdist(void) {}
>  #endif /* CONFIG_NUMA */
>  
> -#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
>  static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> -		unsigned long nr_pages, int migratetype, bool atomic)
> +		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)

What is isolate parameter for?

>  {
>  	const unsigned long end = pfn + nr_pages;
>  
>  	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
> -		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
> +		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, isolate);
> +#ifdef CONFIG_SPARSEMEM
>  		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
> +#else
> +		if (!atomic && IS_ALIGNED(pfn, MAX_FOLIO_NR_PAGES))
> +#endif

Let's trigger cond_resched() on some defined number of iterations or some
memory size chunk, e.g PAGES_PER_128M or even PAGES_PER_1G.

>  			cond_resched();
>  	}
>  }

-- 
Sincerely yours,
Mike.


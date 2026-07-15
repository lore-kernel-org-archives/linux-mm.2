Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A99C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2B16B0098; Wed, 15 Jul 2026 01:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A39D6B0099; Wed, 15 Jul 2026 01:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492EF6B009B; Wed, 15 Jul 2026 01:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E96B66B0098
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:09:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27A7D1A05DF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:09:01 +0000 (UTC)
X-FDA: 84989831682.17.24B1295
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7551F40004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lto60TWu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784092139;
	b=xEgaNhAiiENRPQZyqoVjCBHrPjXRHJ0VRekv5yFcIpg1wiko2zj14rWdTY/6wdg84FsTTn
	X1N3DLOPH6oKYc3/LStjIEx/y1Wi4LkYriIQlDjr2tsBma8he6txFNUaYWaWv6vAmymBV2
	cdL6bLHYjVoKkDybjgsGnsR3Bp3aeOE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lto60TWu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784092139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rA9pFIjk00OodTISyzYpmBq1o7gBdHIMVxiL4aSFVI0=;
	b=DUomDS9MKIR2OVYDF8QC8XPYfami9iBgjokInvctMIgKcCd5xPktnvTjVKC8nQl9wJiRT6
	XwumWewe0ydjiWsLvyFx8uHZRF00LMqzD5eTzkULm0FEA+ZRA0FiIgw63+UwnEFwl0gSUp
	/HWIrCygfIBm0OVlvveR0mPlCU9zzZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3F8F40C11;
	Wed, 15 Jul 2026 05:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216E81F00A3A;
	Wed, 15 Jul 2026 05:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784092138;
	bh=rA9pFIjk00OodTISyzYpmBq1o7gBdHIMVxiL4aSFVI0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=lto60TWuo9gqyLm2lCMON5OS83qYjWUMiqKTEtPmgb/mHNrKLWba+LJHPp6kLSOMu
	 Dkyojun0JEirV6oiVN9OUm15yWYd2fnYMmudsYU0b0u2dB+nnJa6im/9w5K73fMhur
	 jIw91FPK92SybnK4hvbCu4sayNm76NXXAXFc94adF+0e36e6LX2uSyftKpeNbwFvvs
	 lTMAG3dGQnIPvjZv9Ine5SMTSPLAyEw4fQ2E/mJq3PMG81LoE3dVF5z/EmU3FXmCaP
	 xaZu3SARc6Y+fQGrpsswAslRV0qTEiYwUJbo26KUKxJ1s/UijNPK6AkafvJVZp2JMi
	 N6rFT5t+7nz4w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
 muchun.song@linux.dev
In-Reply-To: <20260702093821.2740183-5-songmuchun@bytedance.com>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-5-songmuchun@bytedance.com>
Date: Wed, 15 Jul 2026 08:08:42 +0300
Message-Id: <178409212283.638342.13179685803375053525.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 7551F40004
X-Rspam-User: 
X-Stat-Signature: g89u88ga55wuqffih6q5quiz3frkdiu7
X-Rspamd-Server: rspam03
X-HE-Tag: 1784092139-154127
X-HE-Meta: U2FsdGVkX1+frDNVv3cYADeTsufysNWr7av9SVd09QgOYIoUfpyWeRZocnloc7wDiJPMurWgxv8zFCOTCY3jczJzhGLF5tQ9WWiftYNlx9vaoPmrfI+G2d9sdvbdXsLSqe4YGz8qsfq6U6HBI/ynNrkURiOW7BdJw+Qu/ssJ20kNBzZtkKCjhWG86WgaOxY/7Di4s6P4cx6u2hFb8XDvlEcbkg4yTRyDkvgdiig+Z1YkDjCnuJpgbL0ND7UVfTfPjMeTG4YokVhzphf98Ctj12i6cnn8mcRm6xye/eqG93VDT/e01+4jgk2bykY8P+3Wxk3h7CbSDGMRp5tyT3eLedXlCJNF6+GlHDj8mtEN9jF5ABhjTVw2bPg4jjAEG9khzVlPLj8Q4KsTGLaCeolZVzJZ+X9aFvHHgYFbiSXADxmi8zYBtlz7h88HltEK3gv1ew0ZWUzAkaR47ch3wXBOByyf+WVcbFWgGvIyJqyo2pmAfmG/pcN0JpofjNFq4cPQecUX4Awlq8rCeKrshHYjsxRtD4p+o5VCtj0mQXZx5lF1CxrTH3bk4e7VIxUDpr4b+o0w1vlZ/KgVdzlRka8yz7eSoWeu9HdP78lOsBZjnVhlUSu2IkuBpyl8J00NiOvXno4C8yV13O+abmUo2Y+lpOF5HL3xEs2SydLt1xI2H/M5l8DF0MDU2ZSvgds44cPsXoB5GK6vKaMT8MSN3Ez7n22ifim7+aTVr7ob4BD5abFNMPCK25DyJ8vYqCPBNGuG9wizvM6Ajwx1doM/hdmtVibNAYyVCCzDFYZFKJmTkW+WdPF/dEepB3/KfYIifCgpKZhS6LqmGRMLTdhrFtrIbdl1y4Mk6exH6m52KsEM87RPVoNBr/qnltOyNQRANMPevwp9D8muhz8IXmCWJ01EfyYHdAKKn3isLHu++58TVIwcsoNh1KmIen0S9NED6D+QXgsmWZdZAKBQeZgaBVP
 nsekfNxy
 JJke+KFoBNm5mlHJoz2iuGzWZOVNJ7vsZJhc/7f6cQ4dCGJeBizou1b2eWQFrLKbf8YIO+oph/vKW1kjhap3Ibfu8Pv9fanAzzrtwZZU2/fFS/frq35R1wRwbuB1Nrvs+2zgjsimgc6q97608ArH9wTkKShOuv/rIdCVhJ+CFpHCJH0ly3VY+BiyfMkcGsCDoW8M5HjLs8KqRwMw/1OOEfyHIvO20rQMphC7xzETtdbCyiBivSRd90WTaxGccreUIE/pBC7EUjmw1nTWYN7up1GhqHALjP9PjHZsK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ea884245f499..6fa6e7f0abf9 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2375,6 +2375,10 @@ struct mem_section;
>  
>  #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>  #define pfn_in_present_section pfn_valid
> +static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> +{
> +	return NULL;
> +}

Changelog should mention why this is a part of the patch, it's really
not obvious.

>  #endif /* CONFIG_SPARSEMEM */
>  
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> diff --git a/mm/internal.h b/mm/internal.h
> index 430aa72a4575..ebbab7421633 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1002,10 +1002,26 @@ static inline void sparse_init(void) {}
>   */
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>  void sparse_init_subsection_map(void);
> +
> +static inline bool page_vmemmap_optimizable(const struct page *page, unsigned int order)
> +{
> +	const unsigned long pfn = page_to_pfn(page);
> +	const unsigned long nr_pages = 1UL << order;
> +

Don't you want to gate it on HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON?

Even if it's false for sections without order explicitly set (which is
btw not very obvious), this adds checks for every struct page that we
initialize.

We can revisit this later when the optimization would be relevant for
memory hotplug.

> +	if (!is_power_of_2(sizeof(struct page)))
> +		return false;
> +
> +	return (pfn & (nr_pages - 1)) >= OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES;
> +}
>  #else
>  static inline void sparse_init_subsection_map(void)
>  {
>  }
> +
> +static inline bool page_vmemmap_optimizable(const struct page *page, unsigned int order)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>  
>  #if defined CONFIG_COMPACTION || defined CONFIG_CMA
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 4026b084bd4b..7ef1ac105058 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -674,19 +674,21 @@ static inline void fixup_hashdist(void)
>  static inline void fixup_hashdist(void) {}
>  #endif /* CONFIG_NUMA */
>  
> -#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
>  static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> -		unsigned long nr_pages, int migratetype, bool atomic)
> +		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
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
>  			cond_resched();
>  	}
>  }
> -#endif
>  
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
> @@ -892,6 +894,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>  #endif
>  
>  	for (pfn = start_pfn; pfn < end_pfn; ) {
> +		unsigned int order = section_order(__pfn_to_section(pfn));
> +

I'd move this into page_vmemmap_optimizable(). This way it would be
clearer that a section must have non 0 order for optimization to catch.

>  		/*
>  		 * There can be holes in boot-time mem_map[]s handed to this
>  		 * function.  They do not exist on hotplugged memory.
> @@ -906,6 +910,15 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>  		}
>  
>  		page = pfn_to_page(pfn);
> +		if (page_vmemmap_optimizable(page, order)) {

You can pass pfn instead of page to page_vmemmap_optimizable(), will
save a conversion there.

> +			const unsigned long start = pfn;
> +
> +			pfn = min(ALIGN(start, 1UL << order), end_pfn);
> +			pageblock_migratetype_init_range(start, pfn - start, migratetype,
> +							 isolate_pageblock, false);

I wonder if we'll see any measurable difference in the memmap initialization
if we pull pageblock initialization out unconditionally.

If we don't we can just call pageblock_migratetype_init_range() for the
entire range and kill that

		if (pageblock_aligned(pfn)) {
			init_pageblock_migratetype(page, migratetype,
					isolate_pageblock);
			cond_resched();
		}

-- 
Sincerely yours,
Mike.



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C800BC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AB56B0092; Mon, 24 Aug 2026 04:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22216B0095; Mon, 24 Aug 2026 04:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63156B0096; Mon, 24 Aug 2026 04:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7922E6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:59:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE363C0460
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:36 +0000 (UTC)
X-FDA: 85135564752.26.F5A81CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BDB71C0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu4Yar+C;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WbY8wo3lHkkyyJ/FFwEjsKvjVmDNOmBD41jPCjvTgY=;
	b=uTLcWQ//bz4gbVZljzbQA4PqjZIIs9Lom8BIp/GsSA+u17rs4t14diaZpbMevA5/kA7ynt
	t2Quz4EDVet58lNWfo2kPfrQU3HmuVQGrVy/qgPGjvuB6zJGofi0IFQt1NN4FqYQsO7NG9
	LruVD3Uan9miTmtFSJ2cTj/8Ywxs/5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787561975;
	b=rq0AvlDsxPBsd8cAIzbnvF6YdqFY0GGblj0eUnjYrnclt5ccowdqr6Mb4Gr7p1LTUHXHG5
	DjZKzamSDpqlQ6w8xQd84ktpDovuQDACVoTlK7y0GGx0OsArf1cvzHWrgtx4/TNlRc5djs
	GaXpH2ZCVRN64kPYNf55H+jHpSR7h4k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu4Yar+C;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B609E600E2;
	Mon, 24 Aug 2026 08:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BC81F00A3A;
	Mon, 24 Aug 2026 08:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787561974;
	bh=5WbY8wo3lHkkyyJ/FFwEjsKvjVmDNOmBD41jPCjvTgY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Cu4Yar+CeuIf8CcvteZRMDGidvWydL1e8eTRqWDsH3UWSvoXmMxdxYC9BkJeKOotm
	 n1ukQLeOnnnb1PEp0WThYbIHGdJnZaDu+bgfmMCfD2o2CJVsBsX2UezG5AnIIWSKNt
	 JB5gk818no84fvlGpISG+A9TttRWpd0B5NddPQXzOeHCO+bdlw9NfjPbs+y97WuEjC
	 gSxCdi+U11BDL7MMI0MhSeMQNnlOKSlC4KP3X3J0EmWxeDwvMTY63ozw3mWb1dhPZb
	 CsZobloUEvOVDXus0KKmApJGuPspdSblpk6KYDUKJ2y7Q2IzX+DHvxwZrP6IFUijPW
	 IY0PrUwSDyW2g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260819095140.17252-4-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-4-songmuchun@bytedance.com>
Date: Mon, 24 Aug 2026 11:59:27 +0300
Message-Id: <178756196748.3606540.14377746709923091802.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: n7sjagjtahz47c9jdtdspa11hxyixdih
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4BDB71C0004
X-HE-Tag: 1787561975-6168
X-HE-Meta: U2FsdGVkX1+XlyrFaZxj4Si6LlLjKHSq9rA70pU6K2CWHREf2LIFNpujXK+WTwMgTDLsD1MwBAwmTy3Ne3hQPX2guEgtq1FuOKBm8BUlDNe7oODTYsbD44o/JQ6VeJONLjJFn2GnApTA//XkdrmXUnSDxm62RkzBZSBj8ksN1SqzTTGd+n0APPbHseZPvR3+ZgrUbyngyejDbD5HPqrtQpejWVFCazazaZqM+jRCKpxWkZhdG/j0WzoukfwahjV1nl/wwaBPa/GqHjmy7f+jdEwOFsAPp5H0S1+X8dd7iEpwu5HtFl1EDqhmxmjrDglMdGtBUiWinqqRSAk+AHCmUUqgUzeqTRxNQapBSf62eLuYmzbRhusXW0TB/EJwN2dyj2vDSi4tprlOen2D2tcCQX8EA4AKnHj1SZok7Tn/EpvBrJG1v0DnSSrGWuXkJrpAqHXF+XBKkpSgpWmz4ibbqVKicxCrk4t7ARDzdIKPcQZ9nJsZRfewEy6opvGqjhQZ/HWGU5Azmx2WbKNpHVpNaDLvZp7ftyQq4+cMO/QxVP64Qc9cdp/gkR32Mv57Fw31ZcAGK0u3NC+nVyzYmUeV4D33bHqae/l6F3mYlCHyC/DSwrPVUAzQFM49naPbdocRSdaTJykpb4GTO/ilRpN+wO0ttyDo7uWlYho6Fh24Jd5aMJNt4r5AG4VnbXinRiPUHkog5Xi70hV2uvQHFdyrbVQHu6/7Eyda2UpoxFUKFb4pNqbEdhc+vCfavJMS5qjyY9s6qgHi2t8Y2TPrxHzDXXPImm29CphkJEkjcYm/Z6ROoecDwws8Us3u7BnFmIHTjKIlsf7j+R7hVkTt+JJpBj6xfD+HrPBJflF4AABPbv1L7L/ByWX/EW8zooIciq1WAqMozYpLgmZrMEz1P/czYQB0s2BFmIBGWKmD3QQOWNE1l+/LU59T4oWtBzFt30cEy6H1/vL9wvLs3bQpWOB
 y+okpiu1
 1Dag4PN5ftrrbIrRApLHFc3HnaWBTQh+bKQnySWTa9J/xu6Iv+dsqrbd4iUX40adbPoZ5Om6aFnXOYeMVVvugVW5jdhyAIvGiyCiE7Y/rZJTZCNyLp584nXwsy4y5lhAWZ0ZMFDJo4XnbpKghXV2oq2JsoNfJUNKDTDwLEzEQ1zq9Q5g3sY+vnjR+IShPaq+h2s69gjNB9u8N0mwbHK/KKhmWy933+KB8IV3JMh/lJXnOycF85/Q7AbiHTIPG1Mk+JYFnFFkCrIWHNjwvFXtGQrZq4c7pLf4zfiftcZRbs0Y/pSlU11YI7ir20k+Z9G1TWGts4luyNN2dQm0nsAT1dd6aIwFatMTRMo6IcDOXsug7BXx37Tfh4PTpGTdTAn2FuOwfODUpFsVVppESizHIhRaUVQ==
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
> vmemmap page contents, requiring users such as HugeTLB to restore the
> metadata afterwards.
> 
> Track the compound order for HVO-backed sections and use that metadata
> to detect struct pages that fall into the shared tail vmemmap range.
> Skip those shared tail pages in memmap_init_range(), then initialize
> pageblock migratetypes for the processed range with a helper after the
> per-page initialization loop.
> 
> Keep direct mem_section access inside sparse helpers by exposing
> pfn_to_section_order() to users that only need the order associated with
> a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
> without exposing __pfn_to_section() to !SPARSEMEM builds.
> 
> This is a preparatory change for consolidating handling across users of
> vmemmap optimization, and it also avoids redundant initialization of
> shared tail vmemmap pages during early boot.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 5fb9b37819d5..df31cac12311 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2022,6 +2022,14 @@ struct mem_section {
>  	unsigned long section_mem_map;
>  
>  	struct mem_section_usage *usage;
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +	/*
> +	 * Normally, sections hold regular (order-0) pages. However, for
> +	 * sections with HVO enabled, this tracks the compound page order
> +	 * to enable deduplication of redundant vmemmap pages.
> +	 */
> +	unsigned int order;
> +#endif
>  #ifdef CONFIG_PAGE_EXTENSION
>  	/*
>  	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1533aebafb68..05c09e755e0b 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -29,6 +29,7 @@
>  #include <linux/cma.h>
>  #include <linux/crash_dump.h>
>  #include <linux/execmem.h>
> +#include <linux/sizes.h>
>  #include <linux/vmstat.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/hugetlb.h>
> @@ -677,21 +678,19 @@ static inline void fixup_hashdist(void)
>  static inline void fixup_hashdist(void) {}
>  #endif /* CONFIG_NUMA */
>  
> -#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
>  static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> -		unsigned long nr_pages, int migratetype, bool atomic)
> +		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)

Growing boolean flags makes the callsites harder to read.
One way to deal with it is to add comments to the callers saying what
each true and false mean.

>  {
>  	const unsigned long end = pfn + nr_pages;
>  
>  	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
>  		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
>  
> -		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
> -		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
> +		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
> +		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
>  			cond_resched();
>  	}
>  }
> -#endif
>  
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
> @@ -886,6 +885,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>  			}
>  		}
>  
> +		if (vmemmap_optimizable_pfn(pfn)) {

A short comment above would be nice :)

-- 
Sincerely yours,
Mike.



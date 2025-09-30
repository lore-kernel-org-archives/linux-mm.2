Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E8BCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BD18E0012; Tue, 30 Sep 2025 03:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CDB8E0002; Tue, 30 Sep 2025 03:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBA58E0012; Tue, 30 Sep 2025 03:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F06E98E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:30:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A31DBA73D
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:30:12 +0000 (UTC)
X-FDA: 83945093064.20.C4C9125
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E6C4180017
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:30:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RkvVAe6F;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759217411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRSruWvb4rbc+Pa1Ie+z5dnZdtYXYh6A7V3IBXQrpoA=;
	b=gQKgKPERo3Ml1MPTlcmaGgMxOpASO/ActkwaZcwUB5Xfw6t+pPAHQ2q+v/XAVsmzxHWMkg
	wBN9ec4+uTUXGUI9zqdEoPkN77quQ85+RkxRJbrTht2YDFjODOqKy08UxW/6pNTnYue0id
	tADPWqw7lDVza1ZsNgYGTlNWqKhlkhQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RkvVAe6F;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759217411; a=rsa-sha256;
	cv=none;
	b=vEdEoRF3qQss/+FWW+GSR1v8gwHUxR2kp1jRIEan/DJ0ijY7FEnr/XcQ3aBmcAJLmubtpE
	tdG/bZGoJi1ipvp1sMbl12IUjnotCj5fOB5jFwLI1+6Zz/itZhRcxW2TyJe9PCKJ1nqT/I
	bEt3FY2vj9OH73/OHYRjNjGANIKlLeQ=
Message-ID: <2d21c9bc-e299-4ca6-85ba-b01a1f346d9d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759217406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRSruWvb4rbc+Pa1Ie+z5dnZdtYXYh6A7V3IBXQrpoA=;
	b=RkvVAe6Fg24cbCSqPBQFHG71Zj73toGRbXfs5rz4SjtNxcJzhYsYly6d9QQbJfmc/J/b+k
	mcM2H8mA80qITCJlV1SDsAczLyAMwm0rLZsumKTVuZRwknHbnD/ITho/VI2ndFsJGoawOO
	k9nrqCuoPY9e4SNr8gdZX+r3sOHrccY=
Date: Tue, 30 Sep 2025 15:29:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: david@redhat.com, dev.jain@arm.com
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, npache@redhat.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 usamaarif642@gmail.com, yuzhao@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org,
 lorenzo.stoakes@oracle.com, akpm@linux-foundation.org
References: <20250930071053.36158-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250930071053.36158-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8E6C4180017
X-Stat-Signature: zimpaqjjex84jkbyh8ths5tn859iwuae
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759217410-896254
X-HE-Meta: U2FsdGVkX18nIN9k6W7bCD0v4Ghiq/eMprj0+wxKgx5joBoP9ZvXQlgdSwVmlVpdFROIkyPoCtPNV2se2CKmtyMNqL9Y2oXFh8cFhjW0CaEuUjCFcqIhoKo2LZGHNUU6UJM/wA3mQ248hRBY/bnz7OphCKJ0qx+7pfRGd3Vl4cxf+756fRL+v7hu1FGW5loyP/n0xvI3jJspaoRyK1+uLgGtbAVF+uHMDvYN2TKFn3f9GFXV3sgSzqv8H++70/UmLh+UFBli6v5rcatFcgijEbSFbzm2H9vRCz7a9piCwMQjFjhotl4mgs+S2EydM0t4XoT0gqD17sx1ojJK+IceCRuKSd+M9BLMfbYbV6Ne4g3c0+oflbcBZUpeDswvVZ9Y6CxeflOJQu60FAXZrd9Z88jQ1CAFD1eWHc2rqVtNmXkOVc8qTJRAVAG+lJaff0BhJ5k4xjG1Dy8gti2YCL9eOymSoTgJ4R15Ni4GMtKklCYjaG096P88wB1bMRLc6AGWAGtINdRLw9Ip9IDcsYMWwN2P8FjvrFGtD5VylN04tE9nbMQyAYCC/VS+woczKzceuzlkPfRe+LK+RIMcRhHwRdknR0tjTxNcJhHpmlDWStZ8tCUPWDndLO2hKYvIkgXWBBLZox+SjJl17KI8wtseaU6nDPaxEDHS+FVeAXr7rS6j0iyrZEg2tV3gsEANQpRA44jZ+WKECEMAH9Y6M217qlP68ppN0CBekA0xz/6hbZxGjzDvi5Id6CRtI8UrCpNsWXjh6l5+wKEjHEmJNahktU3qVEZTIUmajTML8BZ6Pqmvqw4w3srFB5rxuVZIZU/810OuDZKCro5CbLs6MPtEFRYwDlbpLNJdnvdVkBvaBxYziDdyxZJcsXMkCKYsx4nTOy12Drpwg19oz1qrEEPgdWFXK8WA4pXhmhBpIfPEiMhmxm32h/qlWAzgpBJAvUaN/Yw+q9sLaIM2tGKbw+S
 dyyLRWRh
 +oJkPpZQTq0MYbJkFo2j/QPcgfcyG2hvV/nKSeapbfYH5WCQLwDNxMy2YqKmejCJe6ftm+iVfQzbv+ERXsA0l3wF8lDnI0FUwiaEHBuJWlmwVXT6T1KgVT/iRtLPvwny625vEOpTmRQW2xoVCfWoeuzcpFtEypwoOYFMJY/xwRk1Ly9bN0m5mzKhdmMJyxl98Ej8gCughW0duHqXuhBqtpf48ETRGVZvPzNmdzz6dcJklFxflvrmviHdVUulmJqvoSpcgaJ56mqNe10kE7HQwm8Lq1ErGURG6WTbXtNoXpVY3OCTh/LqIsOGGG2EdmDsoDn5dyJkA42bntSLlM8p+ZyHOHvwHiGpN5PwITzwyGQvgHvGkJ/2nygTIrrSHRbRinCGj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 15:10, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops several important
> PTE bits.
> 
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing the soft-dirty bit means modified pages are
> missed, leading to inconsistent memory state after restore.
> 
> As pointed out by David, the more critical uffd-wp bit is also dropped.
> This breaks the userfaultfd write-protection mechanism, causing writes
> to be silently missed by monitoring applications, which can lead to data
> corruption.
> 
> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
> creating the new zeropage mapping to ensure they are correctly tracked.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v3 -> v4:
>   - Minor formatting tweak in try_to_map_unused_to_zeropage() function
>     signature (per David and Dev)
>   - Collect Reviewed-by from Dev - thanks!
>   - https://lore.kernel.org/linux-mm/20250930060557.85133-1-lance.yang@linux.dev/
> 
> v2 -> v3:
>   - ptep_get() gets called only once per iteration (per Dev)
>   - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/
> 
> v1 -> v2:
>   - Avoid calling ptep_get() multiple times (per Dev)
>   - Double-check the uffd-wp bit (per David)
>   - Collect Acked-by from David - thanks!
>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/
> 
>   mm/migrate.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..21a2a1bf89f7 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -296,8 +296,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
>   }
>   
>   static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
> -					  struct folio *folio,
> -					  unsigned long idx)
> +		struct folio *folio, pte_t old_pte, unsigned long idx)
>   {
>   	struct page *page = folio_page(folio, idx);
>   	pte_t newpte;
> @@ -306,7 +305,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   		return false;
>   	VM_BUG_ON_PAGE(!PageAnon(page), page);
>   	VM_BUG_ON_PAGE(!PageLocked(page), page);
> -	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> +	VM_BUG_ON_PAGE(pte_present(old_pte), page);
>   
>   	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
>   	    mm_forbids_zeropage(pvmw->vma->vm_mm))
> @@ -322,6 +321,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   
>   	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>   					pvmw->vma->vm_page_prot));
> +
> +	if (pte_swp_soft_dirty(old_pte))
> +		newpte = pte_mksoft_dirty(newpte);
> +	if (pte_swp_uffd_wp(old_pte))
> +		newpte = pte_mkuffd_wp(newpte);
> +
>   	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>   
>   	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
> @@ -344,7 +349,7 @@ static bool remove_migration_pte(struct folio *folio,
>   
>   	while (page_vma_mapped_walk(&pvmw)) {
>   		rmap_t rmap_flags = RMAP_NONE;
> -		pte_t old_pte;
> +		pte_t old_pte = ptep_get(pvmw.pte);

Oops, I just found a NULL pointer dereference bug in my changes to
remove_migration_pte() when we encounter a PMD-mapped THP migration
entry.

#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
		/* PMD-mapped THP migration entry */
		if (!pvmw.pte) {
			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
					!folio_test_pmd_mappable(folio), folio);
			remove_migration_pmd(&pvmw, new);
			continue;
		}
#endif

ptep_get() is called too early... before the !pvmw.pte check for
PMD-mapped entries.

The initialization of old_pte must be moved to after that if block.

Sorry for the churn :(
Lance

>   		pte_t pte;
>   		swp_entry_t entry;
>   		struct page *new;
> @@ -365,12 +370,11 @@ static bool remove_migration_pte(struct folio *folio,
>   		}
>   #endif
>   		if (rmap_walk_arg->map_unused_to_zeropage &&
> -		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
> +		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
>   			continue;
>   
>   		folio_get(folio);
>   		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> -		old_pte = ptep_get(pvmw.pte);
>   
>   		entry = pte_to_swp_entry(old_pte);
>   		if (!is_migration_entry_young(entry))



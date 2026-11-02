Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590B9606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEJHsAW1
Received: by kanga.kvack.org (Postfix)
	id 738FA6B05B5; Mon,  2 Nov 2026 07:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA796B05B6; Mon,  2 Nov 2026 07:18:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8EE6B05B7; Mon,  2 Nov 2026 07:18:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36EBE6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:18:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C59D140CC9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:18:13 +0000 (UTC)
X-FDA: 85390081266.19.64379F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E7AF340008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:18:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XEJHsAW1;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793621892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PzZZAWMkHLIiI0SGi4R95lv/0ZHkf1CuWgcaAhKuFA=;
	b=M157LFS/ifPWEgzpl3UN1mgTwMH3frEm8RUCWW+t5MnEfZy9GijFiBf+ooqGFkvqDF3l2I
	zxPAIsHCiJoP2V2YrQdFdXNCbOyAefzH84LLCoxTpdfNpQNfCvuwW4Y9BGj9fnToMuSokc
	M4e4I8q2efh5vJskBTC9iqRi4ODUk/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XEJHsAW1;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793621892;
	b=bk8zCiA7gz/ARbXOrYDJMG8X3OvfFTpHSSjo299xl7ef4DTV8bY3/DOmnFnNwXYTO0dPf2
	Nuc12OCle3RQl26Ldr1oPIVVfZQbIiMv3AyjT4Rm9tbx7n7Z+xGy1ZUylFcYgI/YtSg5yD
	Unizt+E3079WY19C3rubrHjjEe3FPQ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2595C41A25;
	Mon,  2 Nov 2026 12:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312C51F00A18;
	Mon,  2 Nov 2026 12:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793621891;
	bh=4PzZZAWMkHLIiI0SGi4R95lv/0ZHkf1CuWgcaAhKuFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XEJHsAW1xpBykSI0RPL3s9XyHVb0H5VsOHu/pA4sj6i5fJX/eDJWXfOMeFVuzMoxm
	 e6cZnyTkCI5eySacLKDSXsP7xdfrNIfw8CnjxwKd/MiUhMg4qlqXjZfalJM0nFyh53
	 XK8XMVX25H7E7QA62r9/OFURzkKRulUqRdl2HXK0622lT8ox4Q8QOPQcMAxVlbL6JK
	 qRrt9minS3iWUYi7KOfMXV/I2L1G4ZrNi+0ygGT1c/9IvEyCPGc7uwKE8UNocxksda
	 SDvlYXK/OSMiFAf1BrOnAE3ijyx+uMz292+yLAgbIUOFYwtQL+QhucNrjaw0Eh2SFs
	 CwZ2HQ+PTuFMg==
Message-ID: <5feb82ef-a9bc-4ef3-b056-9732563e6225@kernel.org>
Date: Mon, 2 Nov 2026 13:18:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: gup: introduce gup_unshared_pages()
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-1-bc1ac018c834@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102-refactor_gup_fast-v2-1-bc1ac018c834@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7AF340008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 1das6u7zqt97g5x5wfkqrze4b3e93odo
X-HE-Tag: 1793621891-712671
X-HE-Meta: U2FsdGVkX18DJYN+ONShsKqhri6PM+Oa1bavgs3BQseBm+DipIYnC32NqEMsdmZN2tKnGkk3yRe/h/bDkN6tUmw+E1Lfw0iFZkHXt1M8HjaJMpnEq//EjslRV9A90SB8VT/IDSkZ1HugC49+R5EPX+wKbdKs44E2gMR00u/czb9df5+Kq7I8BXUYgpI5X7Znqia/fYZNO80Pz08lEvUT+i9zfPdFmHMZXgNeQ7lAWs5M0zs/auAtLzHoyLu296kAsCupPkctI3nCEU7rwFVnXZ4itjc2P8iIJQ6Cm5NwdWVjBBWVIKBk0Q2pxSM/S/f/wza9Yp0nl0m0eFoFHDU9ATgnJf+XTDJHrf/HHyHdg5PfBiGPxNG2cAHR+Rm6QzS0dV41m1+hjLgbPgjunrkd7uCcSgz0jZSixEzaZtP3bpfj3wl9/CEwDUzkg9fp5jLiMcMwK04qWu/u0EchLy5tDPgcmJuI/E7TQ/tk96kMpJvcJXxaC4oSwdrMxR2xdJTb0rrYfNqZl11hbr6g65yRakDdxngMohDgzCyB0lXaPFSQebFGdHVFTmlmcl6UD+QbS1+3Uja9qvp/QycWOnBDElBgzWBx5VAR+qIGueNECHd5KqUx01vDQRv1kc8GHzEA3qiYK5c8cqHZZwmoq8ufx/FeUGmYd2SQIAwltPdAkh7XkEiqglgMIX8wy1z12zAfm9B9saCN8IiVQ7HC9Qth9mXPTlMEa1xsXwn9Rljgi72hNojCw5olGNizHFiYQT8/P2V63Segq62Oc8xrj8RUhnLzjI4uWrUZ4Jb4ICg67R//Ns5JLka+WvQ2aKzOGDlVHFBEPTSalFKEC1VXdTpv0w9KfG+iiBWJu3cU8XvXzzyO+sK5aLmBT1BPz4aqPkwlWy9QXEmCH4pUR3ek4UdzEDV1X2Ib7YQDo5KaKQY1aaqsVuXlMPTvSjEY8+lMWTjL2z+iETAqtzVTkahxWh7
 RALWqpIt
 RXA3/WN2Ir0Li76QecfVFTSXFIUE6tpguCtjlPd6AKUa4Lm0wRN0dZddzwefGV2+Lp+YYW6gJzEiao9bjIpEFQOtNUli5WdFCziqKqFkUj5nfXid1bRMZJu0vNt6i+jxqcdv4xX+WJ2SyLcmnXRyMNIItFsdj86EyW9AZWe3dN8JwacG8PBw0s5yriRm1oOSkrBAgMpOd7Vc35fTvNMR8AkHNf8IxkNfguXFI2mmH/lMKhjV+MSNtkzL9UK051HDpwWBK47NxzBeFam0cH2xqXkYrTSDlhbpnw3aU/YdxuOwSzfaIlRU8J488dIDaRmx1hF5DzFsXd3YxiucXQuWchlhWNuy6Fjrldde2zIssUwacsZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 12:30, Yeoreum Yun wrote:
> This is preparatory patch to make gup_fast_pte_range() batchable.
> 
> Introduce gup_unshared_pages() to count consecutive pages within a folio
> that do not require unsharing, and use it to implement gup_must_unshare().
> 
> Also add a folio argument to gup_must_unshare() so callers can reuse an
> existing folio and avoid the compound_head() call implicit in PageAnon().
> 
> There is no functional change.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/gup.c      | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  mm/internal.h | 49 ++++++------------------------------------
>  2 files changed, 70 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 7d43ce717b246..49681f63950ec 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -633,6 +633,59 @@ static struct page *no_page_table(struct vm_area_struct *vma,
>  	return NULL;
>  }
>  
> +unsigned long gup_unshared_pages(struct vm_area_struct *vma, unsigned int flags,
> +				 struct folio *folio, struct page *page,
> +				 unsigned long nr_pages)

Two tab indent.


This function should be static.

As a prerequisite patch you should move gup_unshared_pages() into this file.

$ git grep gup_must_unshare
include/linux/rmap.h:    * gup_must_unshare().
include/linux/rmap.h:    * gup_must_unshare().
mm/gup.c:       if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
mm/gup.c:       if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
mm/gup.c:       if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
mm/gup.c:               if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
mm/gup.c:       if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
mm/gup.c:       if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
mm/internal.h:static inline bool gup_must_unshare(struct vm_area_struct *vma,


I'm not 100% happy about the function name due to the !folio_test_anon()+!FOLL_LONGTERM
path, but cannot think of something better.

> +{
> +	unsigned int i;
> +
> +	/*
> +	 * FOLL_WRITE is implicitly handled correctly as the page table entry
> +	 * has to be writable -- and if it references (part of) an anonymous
> +	 * folio, that part is required to be marked exclusive.
> +	 */
> +	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
> +		return nr_pages;
> +	/*
> +	 * Note: PageAnon(page) is stable until the page is actually getting

You are not calling PageAnon() anymore.

/* folio_test_anon(folio) is stable until folio gets freed. */

> +	 * freed.
> +	 */
> +	if (!folio_test_anon(folio)) {
> +		/*
> +		 * We only care about R/O long-term pining: R/O short-term
> +		 * pinning does not have the semantics to observe successive
> +		 * changes through the process page tables.
> +		 */
> +		if (!(flags & FOLL_LONGTERM))
> +			return nr_pages;
> +
> +		/* We really need the vma ... */
> +		if (!vma || vma_is_cow_mapping(vma))
> +			return 0;
> +
> +		/*
> +		 * ... because we only care about writable private ("COW")
> +		 * mappings where we have to break COW early.
> +		 */
> +		return nr_pages;
> +	}
> +
> +	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
> +	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
> +		smp_rmb();
> +
> +	/*
> +	 * Note that KSM pages cannot be exclusive, and consequently,
> +	 * cannot get pinned.
> +	 */
> +	for (i = 0; i < nr_pages; i++) {
> +		if (!PageAnonExclusive(page + i))
> +			return i;
> +	}
> +
> +	return nr_pages;
> +}
> +
>  #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
>  /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
>  static inline bool can_follow_write_pud(pud_t pud, struct page *page,
> @@ -668,7 +721,8 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
>  	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
>  	page = pfn_to_page(pfn);
>  
> -	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
> +	if (!pud_write(pud) &&
> +	    gup_must_unshare(vma, flags, page_folio(page), page))
>  		return ERR_PTR(-EMLINK);

There is already another instance of page_folio(page) int his file. Use a local
variable and have one folio lookup. (that's the whole reason for passing a folio)

>  
>  	ret = try_grab_folio(page_folio(page), 1, flags);
> @@ -722,7 +776,8 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
>  	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
>  		return NULL;
>  
> -	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
> +	if (!pmd_write(pmdval) &&
> +	    gup_must_unshare(vma, flags, page_folio(page), page))
>  		return ERR_PTR(-EMLINK);

Dito.

>  
>  	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
> @@ -846,7 +901,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  	}
>  	folio = page_folio(page);
>  
> -	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
> +	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
>  		page = ERR_PTR(-EMLINK);
>  		goto out;
>  	}
> @@ -2892,7 +2947,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
>  			goto pte_unmap;
>  		}
>  
> -		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
> +		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
>  		}
> @@ -2969,7 +3024,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
>  		gup_put_folio(folio, nr_pages, flags);
>  		return 0;
>  	}
> -	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> +	if (!pmd_write(orig) &&
> +	    gup_must_unshare(NULL, flags, folio, &folio->page)) {


This only works because we don't have PMD mappings of things that are larger than PMDs.

While at it, pass the proper page.

>  		gup_put_folio(folio, nr_pages, flags);
>  		return 0;
>  	}
> @@ -3011,7 +3067,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
>  		return 0;
>  	}
>  
> -	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> +	if (!pud_write(orig) &&
> +	    gup_must_unshare(NULL, flags, folio, &folio->page)) {

Dito.

>  		gup_put_folio(folio, nr_pages, flags);
>  		return 0;
>  	}
> diff --git a/mm/internal.h b/mm/internal.h
> index c53c369bf8b5d..35016b1afc8bf 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1282,6 +1282,10 @@ int migrate_device_coherent_folio(struct folio *folio);
>  int __must_check try_grab_folio(struct folio *folio, int refs,
>  				unsigned int flags);
>  
> +unsigned long gup_unshared_pages(struct vm_area_struct *vma, unsigned int flags,
> +				 struct folio *folio, struct page *page,
> +				 unsigned long nr_pages);
> +
>  /*
>   * mm/huge_memory.c
>   */
> @@ -1354,51 +1358,12 @@ enum {
>   * to fallback to the slow path just to lookup the vma.
>   */
>  static inline bool gup_must_unshare(struct vm_area_struct *vma,
> -				    unsigned int flags, struct page *page)
> +				    unsigned int flags,
> +				    struct folio *folio, struct page *page)

Whatever you touch, please also convert to two-tab indent.

-- 
Cheers,

David


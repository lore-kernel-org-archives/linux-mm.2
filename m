Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35EAFE9B34D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991E16B0089; Mon,  2 Mar 2026 04:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952576B008A; Mon,  2 Mar 2026 04:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8757B6B008C; Mon,  2 Mar 2026 04:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78C046B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:57:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 115F01A0B0A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:57:15 +0000 (UTC)
X-FDA: 84500670030.02.20ADB30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D351180004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:57:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHLD6xmr;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pqs4gnoGZFVOjifHaE70AxG/2XP9Uaz1sfKn/1Mn+kc=;
	b=amDaCTsaNej8Oss+jNFjAeTzQLQHGQiCsT2stncg4waKW+yq3sR06FNtHPjSSMqBgpjRXW
	oRVj6LSWgh1SVEix9iNBPOq9kUzvMUGlRLrwJ4rbwsdtgtkou2OH/8WN/KuGAdiQwmXqD7
	05Bes0AQ1rfkYRGRALaNUQ3bvgpSllI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHLD6xmr;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445433; a=rsa-sha256;
	cv=none;
	b=bUklZo3Bb/faBB2Ox/V5PBZIVtOnIH+njdJYnvKsZosfBraMABkxt01DRtxaHIAKAVObio
	bnI5eXwavLKRS4snXIdDRXp93apwV42ZPrWjVbF8Vq73EJiJFh/q1dF8rI4UvyWpco/9CW
	jZsAGiGiIfNCV+YwiZ+38QrPSKAEN84=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48CC14385D;
	Mon,  2 Mar 2026 09:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490DDC19423;
	Mon,  2 Mar 2026 09:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772445432;
	bh=KJ7ZX6odt8qAtq2MrpyupKS6itvmSV0FTiZR897rv3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vHLD6xmrK7HIH11cWo9h6oeGlPhz5nezys5omuviIDT5iO/lFUTb5idAvLKCbUbT3
	 pNOa490Zydgvy5YH4r+r5AHGNDJqo7LaeNkatE/z+wIbGVc3YgLbk31om/AJ4tkrF0
	 364aAiuGRW3PQZRInDjPtVotdRpsYYj9HHFDIRIl7E1Y/jw6VNBIpKvEC0oKfj88/k
	 3oBWPfndqWWLQLpYaWU35+DRy1a7/w1MLC/wMl9gjk9K02kegOkB4ps3oAQH8GMVMx
	 kACJd68an+796DmGlA0XKGreIYmgU6EEe/tg1MoVgJJzzjEaDP4hUrIfqP8z3YlBLX
	 HMhdk9fx2B9ig==
Message-ID: <7f2973f0-0a34-4e4f-8ed6-13c531f77453@kernel.org>
Date: Mon, 2 Mar 2026 10:57:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm: support batched checking of the young flag for
 MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <f84233f95f209d59c3bc9c72a757af09337f0d40.1772185080.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f84233f95f209d59c3bc9c72a757af09337f0d40.1772185080.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D351180004
X-Stat-Signature: cacqizhqi75na5fxhm9xo8n93rhs68hr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772445432-46576
X-HE-Meta: U2FsdGVkX18SWRICWDBj0uupfl4H8XJtRpNhY4duzvOa4B0f1L8aa9eXQFcNKTpt9xqWCvrxYtmIyVPgDw/UQSlqItgrM2iWTeJ3wWAiUkKscCz4FyNz5JwI4NTPwuTNurGIrfzIM55yJ4EMh9To/FGYfIfcALwZBobHIiTWYyv5LnyJbWbTlJAl3RZ2yF6VM8oMkvCryt5jWGArWmE7s+pUA9pgKd8vekC0e+pbnc9yJx5zjIhsNtSeSTpqm7tG/Wi2qU2w86dBZKYIIWl8ScYx7gxLFO8qR/AecqGxEcxKaZwgM29TLqBBCN5gX0n4eKIpehFoWKXQFvjUmX8/+iSUN/8sK7NKRo126oV7TQqlYcP2qF1syr7vmX2m603BbqMFOpgT4l1Mq9Nf0owTio0TyYRgNeI+hyg9HE9xaiq1mvK77rpifjmJ8/v8BC8o6+0XpP4YfJwmCwiuiDeVzG5fn/MQ5b30FZxXcoEhpvKya/Iw6mZbWhZ6xTBNmYqpCbHaVITAwUyaOrYtrStG7uLdJtos5QCXY9ePyftVwwGlegWkMXZtR7gK+RCYkEze4CWSf5YMNh8kZ0g7tr83Rc5iljDNL5Rq6nL/pm86EBfbikXJz+8NJzEP2faXJ//sPnR1OvD6sNwg2t9B+2rZiy9kcjqLCODLaN7692XsuqBCGz5BDxOiwzHeB/kzHZP1zMwBlH+DIQA3IQotdVG+AkUNLTjibZi3aaTTuIcREUCi/NDc66ft9US9hcy7U4I9+Em6REt1+8XNsaQmeyHGBDwrcA1tnVKsCZhB4OEJjQGL5D73ZQSsoGcOHNymmbOqldAFj6c4V7m9eHCxN+zM8Ecjep4KlFWlCaj4X6vo9I76gauij1GqI0UmbNe/Lt4xBJdsPL5Wa8dL34zjYKS+ep5uT/6J4oDViGm1ihvu4MNPoPnM1y/ucDh96GbeCdOOhDPk6UgUPGvkc3Bdga0
 DqUf9rDC
 S5mqmLULVHis52/yo3z1zwbnG75mPShLTHqTi91DcFuPK/IsGpVEqvWOehkn5BUHBXjhuZAVKb5VhIWYmycqPQEcKtpcWauSh6iHyY5a27I2131CKH8tN9yLvJW1ASNsJbdOoub4WJsno63pZF3mHDRzSFq99QqwV/g3lODWcbA7rwXhcGyrwhm9QE0tEi+jHETR4WsNgOpetJ1xVc2Evld6UP/qIqGzhISVzuR4gP/8qkvt7YlAWJKyp3bIBj7my8DwYGpYV7KS/NQd/ljMnK6Xzen0YVTjtIVg/WkqPzO69YpfGoMldoWSxHZvBuTFgcnDXIkW0YUo3jMk8wdUK3gNLf+MOPcVXY2ZrN6+8m7Nva9yvSHiS2hiWLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 10:44, Baolin Wang wrote:
> Use the batched helper test_and_clear_young_ptes_notify() to check and clear
> the young flag to improve the performance during large folio reclamation when
> MGLRU is enabled.
> 
> Meanwhile, we can also support batched checking the young and dirty flag
> when MGLRU walks the mm's pagetable to update the folios' generation
> counter. Since MGLRU also checks the PTE dirty bit, use folio_pte_batch_flags()
> with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large folio.
> 
> Then we can remove the ptep_test_and_clear_young_notify() since it has
> no users now.
> 
> Note that we also update the 'young' counter and 'mm_stats[MM_LEAF_YOUNG]' counter
> with the batched count in the lru_gen_look_around() and walk_pte_range(). However,
> the batched operations may inflate these two counters, because in a large folio not
> all PTEs may have been accessed. (Additionally, tracking how many PTEs have been
> accessed within a large folio is not very meaningful, since the mm core actually
> tracks access/dirty on a per-folio basis, not per page). The impact analysis is as
> follows:
> 
> 1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is mainly for
> debugging.
> 
> 2. The 'young' counter is used to decide whether to place the current PMD entry into the
> bloom filters by suitable_to_scan() (so that next time we can check whether it has been
> accessed again), which may set the hash bit in the bloom filters for a PMD entry that
> hasn’t seen much access. However, bloom filters inherently allow some error, so this
> effect appears negligible.


Doesn't checkpatch complain about long lines in the patch description?

> 
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

...

> index a5f0a264ad56..a1b3967afe41 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1843,10 +1843,4 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
>  
>  #endif /* CONFIG_MMU_NOTIFIER */
>  
> -static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
> -		unsigned long addr, pte_t *ptep)
> -{
> -	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
> -}
> -
>  #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 11cc6171344f..beb423f3e8ec 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -958,25 +958,21 @@ static bool folio_referenced_one(struct folio *folio,
>  			return false;
>  		}
>  
> +		if (pvmw.pte && folio_test_large(folio)) {
> +			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
> +			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> +			pte_t pteval = ptep_get(pvmw.pte);
> +
> +			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
> +			ptes += nr;

Could we move that "ptes += nr;" just before the "pra->mapcount -= nr;"?

Would make the whole thing look less weird (only incrementing "ptes" with large folios).

> +		}
> +
>  		if (lru_gen_enabled() && pvmw.pte) {
> -			if (lru_gen_look_around(&pvmw))
> +			if (lru_gen_look_around(&pvmw, nr))
>  				referenced++;
>  		} else if (pvmw.pte) {
> -			if (folio_test_large(folio)) {
> -				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
> -				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> -				pte_t pteval = ptep_get(pvmw.pte);
> -
> -				nr = folio_pte_batch(folio, pvmw.pte,
> -						     pteval, max_nr);
> -			}
> -
> -			ptes += nr;
>  			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
>  				referenced++;
> -			/* Skip the batched PTEs */
> -			pvmw.pte += nr - 1;
> -			pvmw.address += (nr - 1) * PAGE_SIZE;
>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
>  						pvmw.pmd))
> @@ -995,6 +991,10 @@ static bool folio_referenced_one(struct folio *folio,
>  			page_vma_mapped_walk_done(&pvmw);
>  			break;
>  		}
> +
> +		/* Skip the batched PTEs */
> +		pvmw.pte += nr - 1;
> +		pvmw.address += (nr - 1) * PAGE_SIZE;
>  	}
>  
>  	if (referenced)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0a5622420987..7457b3c06fa3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3474,6 +3474,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
>  	DEFINE_MAX_SEQ(walk->lruvec);
>  	int gen = lru_gen_from_seq(max_seq);
> +	unsigned int nr;
>  	pmd_t pmdval;
>  
>  	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
> @@ -3492,11 +3493,13 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  
>  	lazy_mmu_mode_enable();
>  restart:
> -	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
> +	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
>  		unsigned long pfn;
>  		struct folio *folio;
> -		pte_t ptent = ptep_get(pte + i);
> +		pte_t *cur_pte = pte + i;
> +		pte_t ptent = ptep_get(cur_pte);
>  
> +		nr = 1;


Looking at this again, we should get rid of "i" completely and instead
* rename pte to start_pte
* Add a new pte, which we increment in the loop

So we end up with something like

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 54cf4924d223..150cbb2253b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3486,9 +3486,8 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
                           struct mm_walk *args)
 {
-       int i;
        bool dirty;
-       pte_t *pte;
+       pte_t *start_pte, pte;
        spinlock_t *ptl;
        unsigned long addr;
        int total = 0;
@@ -3499,29 +3498,31 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
        struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
        DEFINE_MAX_SEQ(walk->lruvec);
        int gen = lru_gen_from_seq(max_seq);
+       unsigned int nr;
        pmd_t pmdval;
 
-       pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
-       if (!pte)
+       start_pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
+       if (!start_pte)
                return false;
 
        if (!spin_trylock(ptl)) {
-               pte_unmap(pte);
+               pte_unmap(start_pte);
                return true;
        }
 
        if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
-               pte_unmap_unlock(pte, ptl);
+               pte_unmap_unlock(start_pte, ptl);
                return false;
        }
 
        lazy_mmu_mode_enable();
 restart:
-       for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
+       for (addr = start, pte = start_pte; addr != end; addr += nr * PAGE_SIZE, pte += nr) {
                unsigned long pfn;
                struct folio *folio;
-               pte_t ptent = ptep_get(pte + i);
+               pte_t ptent = ptep_get(pte);
 
+               nr = 1;
                total++;
                walk->mm_stats[MM_LEAF_TOTAL]++;
 
@@ -3533,7 +3534,16 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
                if (!folio)
                        continue;


...


>  	walk_update_folio(walk, last, gen, dirty);
> @@ -4166,7 +4178,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
>   * the PTE table to the Bloom filter. This forms a feedback loop between the
>   * eviction and the aging.
>   */
> -bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
> +bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  {
>  	int i;
>  	bool dirty;
> @@ -4184,12 +4196,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  	struct lruvec *lruvec;
>  	struct lru_gen_mm_state *mm_state;
>  	unsigned long max_seq;
> +	pte_t *cur_pte;
>  	int gen;
>  
>  	lockdep_assert_held(pvmw->ptl);
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
>  
> -	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
> +	if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
>  		return false;
>  
>  	if (spin_is_contended(pvmw->ptl))
> @@ -4229,10 +4242,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  
>  	pte -= (addr - start) / PAGE_SIZE;
>  
> -	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
> +	for (i = 0, addr = start, cur_pte = pte; addr != end;
> +	     i += nr, cur_pte += nr, addr += nr * PAGE_SIZE) {
>  		unsigned long pfn;
> -		pte_t ptent = ptep_get(pte + i);
> +		pte_t ptent = ptep_get(cur_pte);
>  
> +		nr = 1;

Can't you just use pte and increment that, right?

"pte" is not used afterwards.

-- 
Cheers,

David


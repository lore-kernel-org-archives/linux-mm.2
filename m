Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D46360A260D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mNz3J1C8
Received: by kanga.kvack.org (Postfix)
	id 18CE86B0666; Thu, 19 Nov 2026 12:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164FF6B06CD; Thu, 19 Nov 2026 12:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B066B06CE; Thu, 19 Nov 2026 12:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D29D06B0666
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:21:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BF08A8827
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:21:15 +0000 (UTC)
X-FDA: 85452534510.22.341AD32
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	by imf29.hostedemail.com (Postfix) with ESMTP id D53B9120010
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:21:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mNz3J1C8;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795108873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdED9eR4y5ifUgKd7CctMUIndCPjoT0qvFTq9/Do+VQ=;
	b=8VwchMmOdkRN9bgXLWQPWyWf3LUh4xmwD/V4nJ8XbrR41Zr7WnBQpcFdpfbIGSPtJtxeLr
	lBXxBFavRXStfW1iUblas9s6OyBn1smaJQgwZYcdc4VUJfuCBKc1ZWuD3pPb+JuCXkvqlp
	Oqjank0Ker8ZYsMnwaatEeyHIhHg8bA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795108873;
	b=TURg9tTqzwMOCjRlRwhvBJ5DxoWz90ta7BB8WABOqhLiEuZT/QZK5Xbb1sHY8VcK2obPgr
	91eVBDDLGuTVCIaxfynSUruPftuRUDx3d60n312kt/e97yh0SpkP/9JACN90fRHN4n77Xt
	Rbhkvf6CQN77FQHpIY2urKp65aqZJ6k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mNz3J1C8;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sOswK0QnaKHmU3QatFBxqViiRvCRLsYYOvUns0Kes0k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795108871; v=1; x=1795713671;
 b=mNz3J1C8srKM79V3RO/Lli7dLeXuiEJ5akyDkZGo0pyS8CYc0pzsRNR5t36BRj8fnj1xZmhn
 rJ10q2nmgXkggzoFwWZUTcxRnzA6mptrgHzXKP5Oj8+5qxEnSHkpUTh1kGpYKig8aPF3JJo5to6
 4L50yE0wNG6Ot4UXZ3x8jBOU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a14ab644d5b40bce;
	Thu, 19 Nov 2026 17:21:10 +0000
X-Mizu-Trace-ID: a14ab644d5b40bce
X-Migadu-Flow: FLOW_OUT
Message-ID: <299b3f93-f7dd-490a-8a6b-68afe4b0e473@linux.dev>
Date: Thu, 19 Nov 2026 09:21:04 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: fix MADV_FREE handling for PMD-mapped THPs
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Ying Huang <huang.ying.caritas@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>
References: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D53B9120010
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: wsuo96tjgdmqmxfw77j3tbrwzja3q3r6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1795108872-326807
X-HE-Meta: U2FsdGVkX1/oXYBCTig8Z2MeDWc7fyML6OWmkedhunclBtDsDEtAVC0ZHtdw3476VqSPEfc0NzBsv37CpLCMndK9sAQ8s/1Cn4qIUZ1qfuZtkyRLu6s8v2U6aH89T+5sx3IxsG5UzsG4JrQXrbbbuuN6cGY1KSaEKfouc2iirixlsoArvBxxZIgFWZ0wLpJxwL0gsFlQ2SL0DwQdoTxV+RfVwQYvEtSHcBC86xDjE/dR+rTFK9TAd376+qwbhoWiLeGEBIPTp1zau5Hg2ytBKCQieJUU9IDQAgraqq4gQ/vEIezyNGSKwPp8Dhjv69UUK05ymC6UlzMHL3ByGXR0WTAHJP+c5SfMl2GjK/fYI9y7A43MECB0VzJ/pSK/3eOnPwfEbDXLmwYDjbi17li1W8Uhk+tayjprLhQTqXulR/FPxqBLZ7gZS3AAEP5V2+bW0SrJwR8lSudhyh+IBxih5fVCArsSeZvr5wPwiQa7Hb7PWrhhAlLrrAO6WYDvqBRejM9tgRfLKVq4zhz0CxU/jDBulNClmb+AmEUvyWJPHrERmgXbZhOVSoc3Ze2s9VJDKQ9ISCVRi9lmYZnBIfX6yX7jJClwxWdNRaU3QpTalRwZSmSCNC8aGpJ+Ro35w+7FK0AU+p32OAGWPDUCtVvpm98IfDK7kONPq+oEUMLQ8+Aynlk7KighuZDHX2YoQA6ilIHVpIAdiFNfnaOgcx6wRrPsvLPNXjrhEa/lNici9IT5gJa9VgtQg8EB4U2DzPfbCMy9Pa3S2qh1TkvKZOnACKApBheE1ra1JzNdWGcF+XYXthULt7CqsCgDgA4DySM3peeEAylqs62qzuAvRiI7YCYse1ialBvqsYR+2j58/96RzH4HNZDYQzzpPpOkFUjFNIkiisxhODkd6PYByeUrEc+7X1vPKAKxlbSXIr91fQOboWIsG7dmJ8fm0rkZizfqPiLgoo+2NKCGROjhr0D
 QfM3uitd
 RS4J4AwRlvkTK6zjYMYL0/nsaQUotlbwhIg/xaeVWUlVBwQLMMXQkVBGIFlBEJMmcXfkWtOHq+EMek/2mdscTwaUKY8zEHlHXcg3Sx2/NaCifN6paaXhZSvtp44kxwPxjZ8sPiMSNsru/ApyCrNb4jBgmziUBSoNc1H87yNqHzudtFinXmz5XHMMNqOOlFUiMnU3dE15h/N3t+rukAxfmot7BaxcPZCaTn8c/le1dC0UECdRNBjxP8PIuD0oKAekwqV5z20kRmm9ZF/K4nSbrW5Q7i+9AQ6j95VTHw+Rm+kl2nytZ6+9DSNzd1eNRRJ5MhLU1iXyL8/oKxxacqSV+m7nPrR8Law1YnFRrtFz3vBoVeOJDnv1bpni/p/w5D7Jn+9RR+JEghfNqaOETgLOVnTj8Ukde8tBV3QDaSdp0SD+W+gE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/11/2026 08:04, David Hildenbrand (Arm) wrote:
> After MADV_FREE cleared the dirty flag of an anonymous folio, reclaim will
> later free the folio without writing it back if no mappings are dirty.
> 
> If our folio is still in the swap cache, the swap entries then point at
> swap slots that were never written, exposing stale content of the swap
> device. Bad.
> 
> madvise_free_pte_range() therefore frees the swap slots first, and skips
> the folio if that is impossible. madvise_free_huge_pmd() does not, and a
> PMD-mapped THP can be in the swap cache if try_to_unmap() failed during
> reclaim, for example due to a racing mlock().
> 
> Further, madvise_free_huge_pmd() checks whether the THP is mapped by
> other processes before taking the folio lock. Another process that still
> has swap entries for the THP can concurrently map it from the swap cache,
> and we might end up clearing the dirty flag of a shared folio.
> 
> Fix it by factoring out the folio handling of madvise_free_pte_range()
> into madvise_free_try_prepare_folio(), and using it for PMD-mapped THPs
> as well. Hopefully this prevents further bugs.
> 
> For PMD-mapped THPs, this change implies:
> 
> 1. We free the swap slots of a THP in the swap cache, and skip the THP if
>    that is impossible.
> 2. We check the mapcount under the folio lock.
> 3. We no longer lock and check THPs that are neither dirty nor in the
>    swap cache, just like for PTE-mapped folios.
> 
> For PTE-mapped folios, this means:
> 
> 4. We check the mapcount once before taking the folio lock, to not lock
>    folios that are mapped by other processes.
> 
> Only compile madvise_free_huge_pmd() with CONFIG_ADVISE_SYSCALLS to keep
> !CONFIG_ADVISE_SYSCALLS builds working.
> 
> Chris and Sashiko reported the missing swap cache handling for PMD-mapped
> THPs, the other issue was found by code inspection.
> 
> This has medium urgency.
> 
> Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-202086@kernel.org/
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> I would queue this fairly soon on mm-core/for-next-fixes
> ---
>  mm/huge_memory.c | 19 ++++++-----------
>  mm/internal.h    |  1 +
>  mm/madvise.c     | 65 +++++++++++++++++++++++++++++---------------------------
>  3 files changed, 41 insertions(+), 44 deletions(-)
> 

Yeah looking at pmd swap, I imagine there might be more cases
which are correctly handled by pte path but not pmd.

Acked-by: Usama Arif <usama.arif@linux.dev>

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 79d400ea9553d..e22daf846dbe3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2421,6 +2421,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_ADVISE_SYSCALLS
>  /*
>   * Return true if we do MADV_FREE successfully on entire pmd page.
>   * Otherwise, return false.
> @@ -2455,21 +2456,13 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	if (folio_is_zone_device(folio))
>  		goto out;
>  
> -	/*
> -	 * If other processes are mapping this folio, we couldn't discard
> -	 * the folio unless they all do MADV_FREE so let's skip the folio.
> -	 */
> -	if (folio_maybe_mapped_shared(folio))
> -		goto out;
> -
> -	if (!folio_trylock(folio))
> -		goto out;
> -
>  	/*
>  	 * If user want to discard part-pages of THP, split it so MADV_FREE
>  	 * will deactivate only them.
>  	 */
>  	if (next - addr != HPAGE_PMD_SIZE) {
> +		if (folio_maybe_mapped_shared(folio) || !folio_trylock(folio))
> +			goto out;
>  		folio_get(folio);
>  		spin_unlock(ptl);
>  		split_folio(folio);
> @@ -2478,9 +2471,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		goto out_unlocked;
>  	}
>  
> -	if (folio_test_dirty(folio))
> -		folio_clear_dirty(folio);
> -	folio_unlock(folio);
> +	if (!madvise_free_try_prepare_folio(folio, 1))
> +		goto out;
>  
>  	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
>  		pmdp_invalidate(vma, addr, pmd);
> @@ -2498,6 +2490,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  out_unlocked:
>  	return ret;
>  }
> +#endif /* CONFIG_ADVISE_SYSCALLS */
>  
>  static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>  {
> diff --git a/mm/internal.h b/mm/internal.h
> index 85cf7becf8588..96cb55d7816b1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -61,6 +61,7 @@ void lru_add_drain_cpu(int cpu);
>  void lru_add_drain_cpu_zone(struct zone *zone);
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
> +bool madvise_free_try_prepare_folio(struct folio *folio, int nr_mappings);
>  
>  /* mm/vmscan.c */
>  unsigned long zone_reclaimable_pages(struct zone *zone);
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014f..ebb4ce7daf6cb 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -661,6 +661,38 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
>  	return 0;
>  }
>  
> +bool madvise_free_try_prepare_folio(struct folio *folio, int nr_mappings)
> +{
> +	if (!folio_test_swapcache(folio) && !folio_test_dirty(folio))
> +		return true;
> +
> +	if (folio_mapcount(folio) != nr_mappings || !folio_trylock(folio))
> +		return false;
> +
> +	/*
> +	 * KSM folios can gain new mappings at any time, so we must
> +	 * not clear their dirty flag.
> +	 */
> +	if (folio_test_ksm(folio))
> +		goto unlock;
> +
> +	/*
> +	 * Check under the folio lock that the folio is exclusive: we own all
> +	 * mappings, and there are no references from swap entries.
> +	 */
> +	if (folio_mapcount(folio) != nr_mappings)
> +		goto unlock;
> +	if (folio_test_swapcache(folio) && !folio_free_swap(folio))
> +		goto unlock;
> +
> +	folio_clear_dirty(folio);
> +	folio_unlock(folio);
> +	return true;
> +unlock:
> +	folio_unlock(folio);
> +	return false;
> +}
> +
>  static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  				unsigned long end, struct mm_walk *walk)
>  
> @@ -753,37 +785,8 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  			}
>  		}
>  
> -		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
> -			if (!folio_trylock(folio))
> -				continue;
> -			/*
> -			 * KSM folios can gain new mappings at any time, so we must
> -			 * not clear their dirty flag.
> -			 */
> -			if (folio_test_ksm(folio)) {
> -				folio_unlock(folio);
> -				continue;
> -			}
> -
> -			/*
> -			 * If we have a large folio at this point, we know it is
> -			 * fully mapped so if its mapcount is the same as its
> -			 * number of pages, it must be exclusive.
> -			 */
> -			if (folio_mapcount(folio) != folio_nr_pages(folio)) {
> -				folio_unlock(folio);
> -				continue;
> -			}
> -
> -			if (folio_test_swapcache(folio) &&
> -			    !folio_free_swap(folio)) {
> -				folio_unlock(folio);
> -				continue;
> -			}
> -
> -			folio_clear_dirty(folio);
> -			folio_unlock(folio);
> -		}
> +		if (!madvise_free_try_prepare_folio(folio, folio_nr_pages(folio)))
> +			continue;
>  
>  		if (pte_young(ptent) || pte_dirty(ptent)) {
>  			clear_young_dirty_ptes(vma, addr, pte, nr, cydp_flags);
> 
> ---
> base-commit: 5e600d79135124a4eb8e9db30ad524224c267c07
> change-id: 20261119-madv_free_thp-3c2a9887a722
> 
> Best regards,
> --  
> David Hildenbrand (Arm) <david@kernel.org>



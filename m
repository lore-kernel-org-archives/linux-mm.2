Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9B2C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 16:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1BB6B0088; Sun, 30 Aug 2026 12:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6723E6B008A; Sun, 30 Aug 2026 12:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5889C6B008C; Sun, 30 Aug 2026 12:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBD86B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:48:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C45C31A035A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:48:51 +0000 (UTC)
X-FDA: 85158520062.27.2A091F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1BDD140008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:48:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="alleFJ3/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788108530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzu+ACkuwUxOrchSybuObnY6MIz1l+8zvuyyHN0CqRg=;
	b=5+KLJfjqIh9OcMM+ez+2t3QgTVJQc1+CGlEV5bxU0SwOEZS4anaBfbCjBFvO4OvbX9sB8w
	pMA7ROlccvkuURKVUEvvFAF83lpQmMXLga+GAdnwZcyTMxuOnQUnS7jsIaeASGZeu5dEu6
	pWPCGIPnElU3OMROThEh+NpPstWNrtE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="alleFJ3/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788108530;
	b=PMGVnxLTkWh78nAbXXmezKHgvEzbcd5DfRb65+FvycJiYKfxu/PsOi1fm7YoGDZdcQhzAd
	5WSzbu6r908fYH/pSXM02+FYhu6X4dWJHrdLfUwKfjdHyTfMoR5K2oFWpKT4sgzVrhSqJm
	EXDUgnazFZFMsVq9/Kpy3kE9/jKCNxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 560CB40BC1;
	Sun, 30 Aug 2026 16:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E621F000E9;
	Sun, 30 Aug 2026 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788108528;
	bh=pzu+ACkuwUxOrchSybuObnY6MIz1l+8zvuyyHN0CqRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alleFJ3/WMBQoZD+8zwyyiLEGd0cTl0GKTN52DYrQFDRvVW6EgqTuD/QRRKxP6+Gk
	 0QgsFSBBursCxqkLwNJz8fg+fxD6m4NX+SwLgEKdbx9rb1lKxAZms1FQgwZrkeON3I
	 9YdDua1nep0yilZ/Yx1SxJQf7fvjJIzEXVJgaYgCJjTCN6FjmHT2xQeTsP/h7KHQP/
	 qQmNx5Y1qL+EkvykG0VC4x8aELSYYcuBmaiP1gCYOEi/IzX/DDNwcXjdHi5DUhG2Kg
	 EPWshzwU/2iNxo+18UbI/EQuYqoK3dGgHnWlPqGPwy65iwYI1w5169mF8y+ZKIP/aW
	 4sOQErbfdq9Ag==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
Date: Sun, 30 Aug 2026 09:48:40 -0700
Message-ID: <20260830164841.103180-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830051407.50008-3-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iggq576pad8uj34kesesg4kkjphowrga
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BDD140008
X-Rspam-User: 
X-HE-Tag: 1788108529-311061
X-HE-Meta: U2FsdGVkX1+JTW/38FRFqgz0WB0wCdzX1UcQKrGw5JyaihGUp8O9J8lM+P4k9UVTmnQijzEq5J/pzHiO8rTGOPuXOu93ULA2Y3//JRGxviYtd7onaruuaj3j+COjBC+pIdxBgMtA0ymUNOcULKoYbpSYnbiOsF8TyU1DDx/VJhanvHE97VQjKatcBPE0/VnOO/6B+HAC+0oXV3PSGwqp/yZkkyiBqrKWOxGKxzG0CPltjVXMLGN/8O4e8NjErw6vW2mO8SJfBEawP9eySV33A50oOtD0crxju14Q0+RWr0F478cZrYagXxeFnXKAWFvEk7t9HlwdNvnJoyS+3NZIL/m/ea7iF9+gphUg8QJ3aaFGsZPpyOt+9Y2WedBdO5AtQ7QcyJPHEVmQ37RtiGAE0ndZFM7dXklOu1eB/V9BDqYThcu8ioGziprxeLOVmWr2CapzhcKKqxkhD6yvczliLXXPVbVAYWGVELDZvMRs9mFAXJJOck4vFsX4+BssKXsUsPugs8Dhse/PY7nDuiRiWE7847XksM1bcG3y/wpj+xKk87ids5g6GFEvH8QvWBTykbLE/b/3ADak00y6YE291zwN5/5DkjquaBABchYAnm0uxGbub4j5fGNoqY4eSVQWCWRXgmzbsfpSW4jSvJ6HccgFU8J5MtRKc1sjRiGcaaX4qAAAQ0UzljT1yOfsh4UYLZY2ViCK15E/zGFGIVoXlgR+asUNZpED3DU0Af4nk7PpV9O8P6/4goZ8xJavQvVa3daw0L6n0oiVGNzZX8mJDDJy4gUe3fUP8WW5xydSwyh/LOIQK8YCwoyB8jFI3fN5vKq00UsliEDdMSYfytjWjH5guXZ9RvIvHKa6fGWrEnjmqkezG7O5hWwqrAJc7WDAYQ8yIhj17NlvnCcs++3QHkKy07apT1AZ01mV+AlwkcOAtFVDeR1tiYQ9gHl0mo6p9FlTVNHv0tKLnrD1w7L
 rczxWytX
 /ohtGYPloEAkazVOYMbOxBgCdWZ//5T6351wHcNsivr8wdT1vGy/XoAjufxkqjzoT62XEMEsli34CciAinE16/YgheW8vMmVpAyuUkZTDvHVBdKWutHfG9R8x/W0cC4Sj+FE3LTMXG0QdRokiDNwbcvJwXreOkopu3Nvo8YgGWUnLE688ddhjTSZRZIZ6U0yhgfAJK2i4BSajjPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 22:14:03 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

> damon_folio_mkold_one() and damon_folio_young_one() assume the folios
> they walk are mapped by normal PTEs or THP PMDs.  When the folio is a
> hugetlb folio, page_vma_mapped_walk() returns the huge PTE in pvmw.pte
> with its page table lock held, but the walkers treat it as a normal
> PTE: they read and age it with PAGE_SIZE-granularity helpers, which is
> wrong for huge PTEs (up to PUD level), and notify secondary MMUs for
> only PAGE_SIZE of the mapping.
> 
> Add hugetlb branches to both walkers.  The mkold walker reuses
> damon_hugetlb_mkold(), which the virtual address space operations set
> has been using for hugetlb aging: it clears the young bit of the huge
> PTE via set_huge_pte_at() and calls mmu_notifier_clear_young() spanning
> the whole huge page size.  The young walker gets an equivalent new
> helper, damon_hugetlb_young(), which reads the huge PTE with
> huge_ptep_get() and consults the page idle flag and
> mmu_notifier_test_young() like the existing PTE branch.
> 
> Locking mirrors what page_vma_mapped_walk() provides: the huge PTE's
> page table lock is held inside the walk, and for shared hugetlb
> mappings (the only ones subject to huge PMD sharing), rmap_walk_file()
> already holds i_mmap_rwsem, satisfying hugetlb_walk()'s locking
> requirements.
> 
> This is currently dead code: both rmap walkers are only reachable
> through damon_get_folio(), which rejects hugetlb folios since they are
> not on the LRU lists.  A following commit will let the physical address
> space monitoring primitives opt in to hugetlb folios.
> 
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
> ---
>  mm/damon/ops-common.c | 63 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index f5fe92b825bb..62004206ca31 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -193,10 +193,20 @@ static bool damon_folio_mkold_one(struct folio *folio,
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		addr = pvmw.address;
> -		if (pvmw.pte)
> -			damon_ptep_mkold(pvmw.pte, vma, addr);
> -		else
> +		if (pvmw.pte) {
> +			/*
> +			 * For hugetlb folios, page_vma_mapped_walk() sets
> +			 * pvmw.pte to the huge PTE with its page table lock
> +			 * held.
> +			 */

This comment looks too verbose.  Let's drop.

> +			if (folio_test_hugetlb(folio))
> +				damon_hugetlb_mkold(pvmw.pte, vma->vm_mm, vma,
> +						addr);
> +			else
> +				damon_ptep_mkold(pvmw.pte, vma, addr);
> +		} else {
>  			damon_pmdp_mkold(pvmw.pmd, vma, addr);
> +		}
>  	}
>  	return true;
>  }
> @@ -221,6 +231,24 @@ void damon_folio_mkold(struct folio *folio)
>  
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
> +		unsigned long addr, struct folio *folio)
> +{
> +	pte_t entry = huge_ptep_get(vma->vm_mm, addr, pte);
> +
> +	return (pte_present(entry) && pte_young(entry)) ||
> +		!folio_test_idle(folio) ||
> +		mmu_notifier_test_young(vma->vm_mm, addr);
> +}
> +#else
> +static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
> +		unsigned long addr, struct folio *folio)
> +{
> +	return false;
> +}
> +#endif	/* CONFIG_HUGETLB_PAGE */
> +
>  static bool damon_folio_young_one(struct folio *folio,
>  		struct vm_area_struct *vma, unsigned long addr, void *arg)
>  {
> @@ -232,16 +260,29 @@ static bool damon_folio_young_one(struct folio *folio,
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		addr = pvmw.address;
>  		if (pvmw.pte) {
> -			pte = ptep_get(pvmw.pte);
> -
>  			/*
> -			 * PFN swap PTEs, such as device-exclusive ones, that
> -			 * actually map pages are "old" from a CPU perspective.
> -			 * The MMU notifier takes care of any device aspects.
> +			 * For hugetlb folios, page_vma_mapped_walk() sets
> +			 * pvmw.pte to the huge PTE with its page table lock
> +			 * held.
>  			 */

Again, this new comment looks unnecessary.  Let's drop.

> -			*accessed = (pte_present(pte) && pte_young(pte)) ||
> -				!folio_test_idle(folio) ||
> -				mmu_notifier_test_young(vma->vm_mm, addr);
> +			if (folio_test_hugetlb(folio)) {
> +				*accessed = damon_hugetlb_young(pvmw.pte, vma,
> +						addr, folio);
> +			} else {
> +				pte = ptep_get(pvmw.pte);
> +
> +				/*
> +				 * PFN swap PTEs, such as device-exclusive
> +				 * ones, that actually map pages are "old"
> +				 * from a CPU perspective. The MMU notifier
> +				 * takes care of any device aspects.
> +				 */
> +				*accessed = (pte_present(pte) &&
> +						pte_young(pte)) ||
> +					!folio_test_idle(folio) ||
> +					mmu_notifier_test_young(vma->vm_mm,
> +							addr);
> +			}

I feel like the indentation becomes too deep.  Could we split out this into
another static function, say, damon_pte_young()?

>  		} else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  			pmd_t pmd = pmdp_get(pvmw.pmd);
> -- 
> 2.54.0

Other than the above two simple things, this patch looks good to me.


Thanks,
SJ


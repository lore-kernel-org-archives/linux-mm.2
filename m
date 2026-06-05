Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F725CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98536B00B5; Fri,  5 Jun 2026 14:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A496A6B00B6; Fri,  5 Jun 2026 14:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9376C6B00B8; Fri,  5 Jun 2026 14:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F86F6B00B5
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:38:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50A18163323
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:38:29 +0000 (UTC)
X-FDA: 84846719538.17.F290B16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5A42C0003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:38:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQ+3aE2i;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAe3HmiXA/hdKU1f7lg2NeQWDCQZkJSm1g2M9eRg/Sw=;
	b=vytndFR6rIN8/s0+dH1aYaoUd3nOX/aHL1rQu1sy8LasG8mzjU/hPtYq1NuNaxTauiN0nE
	xf57oWD81lxM7TdEzmBDzqWoIwVv2tSok0obXTjRe/Zrb1cwt3ccP4sFACi41ijei2TtAz
	y8TIZE/XpdFD35uyJhHlMN6Hr7dbltQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684707;
	b=o+bgaxUZ6j2JR2j31ocmrOl2qSZX+d7yiDDztaCf5PDTJtuUHmB4eFJsIoliD1HyE8tiXl
	FeiqsDEAhx+8eNlpfQKSZjtAFQ1IXIDtyuFGHYonhzM0pb6MCoNnc5vmYrKmVJWiv9z2Ay
	oNf2N+BK6IKNHqWYxxUvqI3Q41ECDe4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQ+3aE2i;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FA6A600AE;
	Fri,  5 Jun 2026 18:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9858F1F00893;
	Fri,  5 Jun 2026 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684706;
	bh=rAe3HmiXA/hdKU1f7lg2NeQWDCQZkJSm1g2M9eRg/Sw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GQ+3aE2iJ4JMf1bd6InwfKtZ9kIzYNrXuZjdgJdWMf4jKvcLmpGdmuPLr47M4tGgu
	 npOSj5zIebu0EkZZJp6qvv5e6O7VpbdAuVZ2vsbxNTb8RPcrj6Eh5WAl0xcrd4CTRm
	 q9H4FfGkkvgElJ+54I861qF4EPHa+oTyeCxGH5J6pE+WJgd7iLjSfTdiJRXlMBl/U8
	 aD+5fOAThesf1sUYwPawAar3drJa7+Ams1RNLSC69gqjpLPjiYH0o8r7ykSl4Xb5kl
	 YUpuHZSWABU3nuvtycXs/6nU9Mis8N8AdU3Odqffu2R/nHOi0/CYDHyKEaLtT2S9sv
	 jV9RiXvpiz+zw==
Date: Fri, 5 Jun 2026 19:38:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <aiMTuXKQ5qxKYo60@lucifer>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-12-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605161422.213817-12-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5A42C0003
X-Stat-Signature: mkobsbhopmwe7caximzdzpyx397ndfr1
X-HE-Tag: 1780684707-521746
X-HE-Meta: U2FsdGVkX1/J6urWlq8kLTk1DSbfY/45ajp+d4lRyCVMQJGAg2ofAN9RpSLB7qs5QuIsTTpfzxDj8J0RgCVDifjroqWKhmjlHr39cU7dAiF/4HG4d1r4i54hZ9M0XA9NKpKoVdZ/okF5Gg6XOu0yZkULqjd9cTK2+ez7XI0NMYsxwmTUbd1w+r2/Hbj4GM6BcAuLzU2bFL+vH0u3Sr35v82yjNjm1W0Kd20hNzSS2PARVwucZBop7fWcAvJpai6h0GjgN6TDbCf6r+dZc1tfa23KuqRcIrkUTSoEakTfFSnBufKOfQ8DzVqG3vJrPXxSVt+6YN5XgU0ix8YEBep0yzWS5qrPpoh/JzlCtLlIKqmu1oWaTDPo3DmBulAVOcvtpzrFs/gFHz2yVUrH0G4pQSzuec1LzbWF4vy2q70EBaIQoyBLz+khPJtXO+5YySfytUsST2pvdxMRUF+us3mEW6+RKHrDGCfMeakaXaI6H1MvR7bod4M6lcUHv3TKiCGjcWq3ipYYs7i8e7brcNqCebe1CEdMqAGKLz9Z9AXd24v2onI4aoTzATtYl96Wk5vsIgqybuP4De4QLGTLfsJpSCFYjt+w6vavmf0jOjTgjoMeFFBRu+/I6neHA/tfbRyAx5St1/XJ9e5okAT2QwiqhJEinn1jSFQINESpOBJv1RHK3jA/5X/9DFv4xL2zbcLkzCPy9vU9le33WgcOOYWRKesMQL3SwZ7Ek5QEyL2Cq+NcVprNlgOEN2HswURtaziSx0jCqwmX3Xh2XErErrbTz3RPd4XbcdUCxEd51aBIxhjogIOM626qI3V8B818Bo9MJV0Rz62s+rxhdEJc6OhFOj0hCT/gnavzV+1EdvqQNyXRBTx4koscLvK9xsdrQbMc5+S3Pq6aWdKuIjBHSMK/wBjYyIqJywjNyL28H+mNG4mneVxbLxnU1izpjaJbYoCsWb6uU2Cg9TQRzWaACiI
 ZgqQKHMp
 8mzUJ4DVEBchycdIXsI9OCuDVfzWGM8HnJrpFGRUadbGznFsoO9llM5+V930LIL2yBi77QKbp5Gn9RVUeTWWud38+GohPj8YPtt+e+qZiiMcv06zW7SzOy2FR6cbH84bdV3FLi0yvt9ej906bVkoUZOybbpXOUpe7osBCp3J+yFcUvbiJ1Oti5PojfXx5B5Amv4lVOg0lf1oPwVNUELFow5eJ9bZksQCdTW/SdTPJkA+QuRYkmfhs6xixicMCmfXA7t/VVLJDlOmhsg/Wy+FI3Jw1uBm9YU25gKhFWfEJXzkx8I5LU2HaCKtbyrt/USQi4S6uvFeIiodR+uhMZCZvM97u7QbfP6JMjhq3DmHyhQTuqMEr2mQsbqn9ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 10:14:18AM -0600, Nico Pache wrote:
> Enable khugepaged to collapse to mTHP orders. This patch implements the
> main scanning logic using a bitmap to track occupied pages and the
> algorithm to find optimal collapse sizes.
>
> Previous to this patch, PMD collapse had 3 main phases, a light weight
> scanning phase (mmap_read_lock) that determines a potential PMD
> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> phase (mmap_write_lock).
>
> To enabled mTHP collapse we make the following changes:
>
> During PMD scan phase, track occupied pages in a bitmap. When mTHP
> orders are enabled, we remove the restriction of max_ptes_none during the
> scan phase to avoid missing potential mTHP collapse candidates. Once we
> have scanned the full PMD range and updated the bitmap to track occupied
> pages, we use the bitmap to find the optimal mTHP size.
>
> Implement mthp_collapse() to walk forward through the bitmap and
> determine the best eligible order for each naturally-aligned region. The
> algorithm starts at the beginning of the PMD range and, for each offset,
> tries the highest order that fits the alignment. If the number of
> occupied PTEs in that region satisfies the max_ptes_none threshold for
> that order, a collapse is attempted. On failure, the order is
> decremented and the same offset is retried at the next smaller size. Once
> the smallest enabled order is exhausted (or a collapse succeeds), the
> offset advances past the region just processed, and the next attempt
> starts at the highest order permitted by the new offset's natural
> alignment.

I think still it might have been nice to discuss why we are not
e.g. greedily trying to find the biggest possible mTHP size (if we did, we
would try the highest offset first), but we can save that for adding some
documentation somewhere later tbh.

This commit message is long enough as it is :>)

>
> The algorithm works as follows:
>     1) set offset=0 and order=HPAGE_PMD_ORDER
>     2) if the order is not enabled, go to step (5)
>     3) count occupied PTEs in the (offset, order) range using
>        bitmap_weight_from()
>     4) if the count satisfies the max_ptes_none threshold, attempt
>        collapse; on success, advance to step (6)
>     5) if a smaller enabled order exists, decrement order and retry
>        from step (2) at the same offset
>     6) advance offset past the current region and compute the next
>        order from the new offset's natural alignment via __ffs(offset),
>        capped at HPAGE_PMD_ORDER
>     7) repeat from step (2) until the full PMD range is covered
>
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order mTHP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will
> satisfy the promotion condition once again. This issue is prevented via
> the collapse_max_ptes_none() function which imposes the max_ptes_none
> restrictions above.
>
> We currently only support mTHP collapse for max_ptes_none values of 0
> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>
>     - max_ptes_none=0: Never introduce new empty pages during collapse
>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>       available mTHP order
>
> Any other max_ptes_none value will emit a warning and default mTHP
> collapse to max_ptes_none=0. There should be no behavior change for PMD
> collapse.
>
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.
>
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.

It'd be nice to have kept the ASCII diagram here too :'( but this is fine,

>
> Signed-off-by: Nico Pache <npache@redhat.com>

This all LGTM, and we can fix up any issues that arise later if anything
does break. So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 146 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 138 insertions(+), 8 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index ec886a031952..430047316f43 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -99,6 +99,8 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> +
>  struct collapse_control {
>  	bool is_khugepaged;
>
> @@ -110,6 +112,9 @@ struct collapse_control {
>
>  	/* nodemask for allocation fallback */
>  	nodemask_t alloc_nmask;
> +
> +	/* Each bit represents a single occupied (!none/zero) page. */
> +	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>  };
>
>  /**
> @@ -1440,20 +1445,130 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	return result;
>  }
>
> +/* Return the highest naturally aligned order that fits at @offset within a PMD. */
> +static unsigned int max_order_from_offset(unsigned int offset)
> +{
> +	if (offset == 0)
> +		return HPAGE_PMD_ORDER;
> +
> +	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
> +}

Thanks this is better! I wonder if we can ever actually see an
__ffs(offset) that's > HPAGE_PMD_ORDER but probably better safe than sorry
here with the min_t.

> +
> +/*
> + * mthp_collapse() consumes the bitmap that is generated during
> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> + *
> + * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
> + * page. We start at the PMD order and check if it is eligible for collapse;
> + * if not, we check the left and right halves of the PTE page table we are
> + * examining at a lower order.
> + *
> + * For each of these, we determine how many PTE entries are occupied in the
> + * range of PTE entries we propose to collapse, then we compare this to a
> + * threshold number of PTE entries which would need to be occupied for a
> + * collapse to be permitted at that order (accounting for max_ptes_none).
> + *
> + * If a collapse is permitted, we attempt to collapse the PTE range into a
> + * mTHP.
> + */
> +static enum scan_result mthp_collapse(struct mm_struct *mm,
> +		unsigned long address, int referenced, int unmapped,
> +		struct collapse_control *cc, unsigned long enabled_orders)
> +{
> +	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> +	enum scan_result last_result = SCAN_FAIL;
> +	int collapsed = 0;
> +	bool alloc_failed = false;
> +	unsigned long collapse_address;
> +	unsigned int offset = 0;
> +	unsigned int order = HPAGE_PMD_ORDER;
> +
> +	while (offset < HPAGE_PMD_NR) {
> +		nr_ptes = 1UL << order;
> +
> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
> +		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
> +						      offset + nr_ptes);
> +
> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> +			enum scan_result ret;
> +
> +			collapse_address = address + offset * PAGE_SIZE;
> +			ret = collapse_huge_page(mm, collapse_address, referenced,
> +						 unmapped, cc, order);
> +			switch (ret) {
> +			/* Cases where we continue to next collapse candidate */
> +			case SCAN_SUCCEED:
> +				collapsed += nr_ptes;
> +				fallthrough;
> +			case SCAN_PTE_MAPPED_HUGEPAGE:
> +				goto next_offset;
> +			/* Cases where lower orders might still succeed */
> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> +				alloc_failed = true;
> +				last_result = ret;
> +				goto next_order;
> +			/* Cases where no further collapse is possible */
> +			case SCAN_PMD_MAPPED:
> +				fallthrough;
> +			default:
> +				last_result = ret;
> +				goto done;
> +			}
> +		}
> +
> +next_order:
> +		/*
> +		 * Continue with the next smaller order if there is still
> +		 * any smaller order enabled. When at the smallest order
> +		 * we must always move to the next offset.
> +		 */
> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
> +			(enabled_orders & GENMASK(order - 1, 0))) {

Honestly wasn't aware of GENMASK() before :)

> +			order--;
> +			continue;
> +		}
> +next_offset:
> +		/*
> +		 * Advance past the region we just processed and determine the
> +		 * highest order we can attempt next. Since huge pages must be
> +		 * naturally aligned, the max order we can attempt next is
> +		 * limited by the alignment of the new offset.
> +		 * E.g. if we collapsed a order-2 mTHP at offset 0, offset
> +		 * becomes 4 and __ffs(4) == 2, so the next attempt starts at
> +		 * order 2.
> +		 */

Great comment thanks!

> +		offset += nr_ptes;
> +		order = max_order_from_offset(offset);
> +	}
> +done:
> +	if (collapsed)
> +		return SCAN_SUCCEED;
> +	if (alloc_failed)
> +		return SCAN_ALLOC_HUGE_PAGE_FAIL;
> +	return last_result;
> +}
> +
>  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr,
>  		bool *lock_dropped, struct collapse_control *cc)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>  	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
>  	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
> +	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> +	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>  	pmd_t *pmd;
> -	pte_t *pte, *_pte;
> +	pte_t *pte, *_pte, pteval;
> +	int i;
>  	int none_or_zero = 0, shared = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr;
> +	unsigned long enabled_orders;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
>
> @@ -1465,8 +1580,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> +	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */
> +	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
> +		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
> +
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
>  		cc->progress++;
> @@ -1474,11 +1600,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> -	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, addr += PAGE_SIZE) {
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		_pte = pte + i;
> +		addr = start_addr + i * PAGE_SIZE;
> +		pteval = ptep_get(_pte);
> +
>  		cc->progress++;
>
> -		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -1558,6 +1686,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			}
>  		}
>
> +		/* Set bit for occupied pages */
> +		__set_bit(i, cc->mthp_present_ptes);
>  		/*
>  		 * Record which node the original page is from and save this
>  		 * information to cc->node_load[].
> @@ -1616,9 +1746,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	if (result == SCAN_SUCCEED) {
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
> -		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc, HPAGE_PMD_ORDER);
> -		/* collapse_huge_page will return with the mmap_lock released */
> +		result = mthp_collapse(mm, start_addr, referenced,
> +				       unmapped, cc, enabled_orders);
> +		/* mmap_lock was released above, set lock_dropped */
>  		*lock_dropped = true;
>  	}
>  out:
> --
> 2.54.0
>

Cheers, Lorenzo


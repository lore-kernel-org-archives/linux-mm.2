Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A811606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OqgwGvpf
Received: by kanga.kvack.org (Postfix)
	id 44C8D6B05B8; Thu, 26 Nov 2026 07:21:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE3B6B05B9; Thu, 26 Nov 2026 07:21:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC306B05BA; Thu, 26 Nov 2026 07:21:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08AFD6B05B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:21:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BB691C3F55
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:21:05 +0000 (UTC)
X-FDA: 85477179690.18.DC4DB96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9A1914000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:21:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqgwGvpf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795695663;
	b=3v4+S8WObkjZ98ZUE23Wr8g0w//8goshLR+qHbTSY5q71AtjxqW8E0Mbvn/Zi/a6CEVUFL
	XtRKN11oG5F/Oxom9UhYOiJuXqhxP9jXbCa6d7tIlntDoKTBfxmRtrDzBDJdGBigyGwtz9
	fXpGiekKMhRKnH1Ikg4rEP14lrJzTZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oegbwHVTV6xxKcj4J+MrGxr90gOfvAmQaDvx2k/ic4I=;
	b=Ql+BLv5GfB7ioMaQuI9uO9g0uyKTrJYqPwyQKySjpR1520V/qIsjhgkxWC/2xHgi7Ys/Vp
	mWm/Kmc39ZzSL3+QI7eI+BGTc1bhnwHCwp0vb0MKCdHJgmPaetJnQyLW46XBLXVGJbjJTH
	smbWhb33MMAqH1T6woEUCdc8UB7gyiA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqgwGvpf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9623621B9;
	Thu, 26 Nov 2026 12:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D174D1F000C4;
	Thu, 26 Nov 2026 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695662;
	bh=oegbwHVTV6xxKcj4J+MrGxr90gOfvAmQaDvx2k/ic4I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OqgwGvpfqlGSxlwH30/+CQXxcmpmUVgRnZ6zzmKeiqON1QGrqzTAvmbFdFCzZ3IKA
	 4Aw1KU8AA6olIznEWGZP+LU6QLrpoUDg8AZU8OgecylZ5kW7uTQiMCVT/xQnh1ldE8
	 otqqosYch4GkWPl0pjSxcY/p1UhfQTpBCj1/vg8a9tL/eZ8PaVDnda3O/6PqsQunHl
	 v+N2xYum8R1s00Z4QaYMkNBPyKTE6I6ywy3fgDBiV88v3N/rsi7HNIO4Jaysg21CcJ
	 w2vbzoU0NntPtvyaAr6yr1GarxWpVAqlGBN1QU0Orrr0F9lAZ7yk5GWHq59wfaq4gg
	 mca/rFs7L67dA==
Message-ID: <e43ec92b-1759-494b-ae08-257e29d6999f@kernel.org>
Date: Thu, 26 Nov 2026 13:20:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/8] mm/rmap: batch unmap anonymous swap-backed large
 folios
To: Dev Jain <dev.jain@arm.com>, ljs@kernel.org, akpm@linux-foundation.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261123053543.295467-9-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123053543.295467-9-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: akckr91suzkpfoswi9iju3pqod35ungi
X-Rspamd-Queue-Id: B9A1914000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795695663-542494
X-HE-Meta: U2FsdGVkX1+ThmKD8JN8JFVYLWmqBikXSGaPbff9J7oZ9AItSXBDQN0WmYWsa5Mmy8KIO10lPOHQXf9qcZXGYjSoZ3XRX53TCUzHU73PaxAHBrd74AqOrzeCqL+nKgr0/EYNTsBzvnQunZYMerlQxkTqeueMvQ8qqD4qWI2DAvPer339PKS3zoJccC2/R7+sND/r1bINl350lOUR5wd2y9Dvax8JDnjaoQ5EYC3RJdo8xs20DQevtJOn8tQsmF10bnpjwu6qicoAX8gr2W+U10kAR/VacMOsqpChdXDrqlmYtTp+K8R7Xh7oM257iENQ4rMjTrfyP/lKl/UK0bVQAsgfGKuQn56MkUkHKp3KToJYXsU6z7fyxfNkV4F3Rsf6I25NUN2Xc7rSx0BSU0rpZ0T+vptl/W426mA2s3QTvWljW3JJYzYkcfgv+mEAlHYiaM6PvKRv0s6N+I8GDBTt/lKMMYKo9WPn2CYzbyCU8Qt96AXRguIcMsEUNQBO+Mx9foh0MGfsggWOCgcg6FJKXIB4e+kf1mSgkJm7ZCx8erUAeP6XX8eqxhRogVd6kALo5vwObCTTedo7t3N0ES/Qr+a1+MA4t+Ln+g20pOiYVPa9ydfIkXwi9il6V08cEjqGL2z5dXOR8ZK3xG6z4tFW+5yq+16HHXKZ5YafEgHmktBO1vp/07oa5agJPF8ZdhcFmfktmyqcKEeHjEGceJaJTCKPTVKdY5DhBu4aikeoFJSGXa38OgvABClwMHcV7m/4+bVyHoTn1tGagWCqOwM2J+jNJQ9jOEZSU1DaetmM46JJaiNJLnRd1UuObghrVbLXvAZ3yDvrmU3Jhw1YhaZ+AB5jMSNsqhiQFX9XE4oGrDUS0R6IqGI6HW7SqP1hq4GllK1jrIM+vy9bE/rZNbvPhPyFtmWnLz5Dqbx5SM7UjjB/ws/afBJoGlRT9Y2bypgXSqXmf1rPFkHB56lmSpX
 TLvz6cP/
 KjIq7l2XZJa8GaYWn5n7FU38tdlqT55GRIjZMzx7PyL/kDrAoYLPgsKiH8szCRWSojb8Ak+Jbc9GBRBc1JybNigh+J4LfetRu2vMbBQByUa32WBwxX4pjYr/zkwWinqsqJEN2dItlBf1it9dkP27XB5/fqk069RsPGgWYGgOPyBg7Mn1pK8e4MPLJLDVQl087noUPemafBQlfzQtEcVtiV/gh9f4fcMBtW/fSQk1rLttxrstiRyZtrFzcrP8aeYYaDyTm6SJuHgfTJvMfDgYNqKscj+0F51YaDHegAJ2n6FOjW6Eyb6nEWxDBFYs6V1JGvxjRobV51LIAfQDlYRx3Ljq4oOuny4TleTpI2Py8sZMYmB4DmQoi2hHI2xy5SI9X3Jmd6BjcuarQTNhZKGIPYLSmBF+QGxED35xC20E8KudjEy7/COWWNi2GYij1X7QYM0eF/Cyl1qwui+mOGydgOuWovxGuMw6mM4XlUBjnHzHxkEztdwNVw29oVECG4934UzvEHWfAi1R1jVKehOXc9478qu97RnO/axNA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:35, Dev Jain wrote:
> Enable batch clearing of PTEs and batch swap setting of PTEs for anon
> swap-backed folio unmapping.
> 
> Processing all PTEs of a large folio in one go helps us batch across
> atomics (add_mm_counter() etc), barriers in __folio_try_share_anon_rmap(),
> and repeated calls to page_vma_mapped_walk(). In general, batching helps
> execute similar code together, making the path more memory and CPU
> friendly.
> 
> On arm64-contpte, batching also helps avoid redundant ptep_get() calls
> and TLB flushes while breaking the contpte mapping.
> 
> The handling of anon-exclusivity is very similar to commit cac1db8c3aad
> ("mm: optimize mprotect() by PTE batching"). Since
> folio_unmap_pte_batch() does not look at the bits of the underlying page,
> process sub-batches of PTEs pointing to pages with the same exclusivity
> state, and batch set only those PTEs to swap PTEs in one go.
> 
> Disable batching for sparc (because of arch_unmap_one), we will batch this
> later.
> 
> Rmap accounting and reference accounting must happen when anon folio unmap
> succeeds. If a large folio is only partially batched or a later sub-batch
> fails, account only the pages that were actually unmapped.
> 
> If the batch length is less than the number of pages in the folio, skip
> over this batch. page_vma_mapped_walk() handles this: check_pte() returns
> true only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the
> PTE. Swap PTEs have no underlying PFN, so check_pte() returns false until
> the walk reaches the next present PTE to unmap.
> 
> Remove the finish_unmap label since no goto callers are left now.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 118 +++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 86 insertions(+), 32 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 98690947ef19..818aecfa820b 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1982,12 +1982,13 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	end_addr = pte_table_clamped_end(addr, vma->vm_end);
>  	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>  
> -	/* We only support lazyfree or file folios batching for now ... */
> -	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> +	if (pte_unused(pte))
>  		return 1;
>  
> -	if (pte_unused(pte))
> +#ifdef __HAVE_ARCH_UNMAP_ONE
> +	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>  		return 1;
> +#endif

Oh no, what about performance on sparc64 ;)

>  
>  	/*
>  	 * If unmap fails, we need to restore the ptes. To avoid accidentally
> @@ -2158,16 +2159,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
>  	return swp_pte;
>  }
>  
> -static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
> +static void finish_folio_unmap_batch(struct vm_area_struct *vma,
> +		struct folio *folio, struct page *page, unsigned long nr_pages)
> +{
> +	folio_remove_rmap_ptes(folio, page, nr_pages, vma);
> +	if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
> +		mlock_drain_local();
> +	folio_put_refs(folio, nr_pages);
> +}

I think this cleanup can go into a separate cleanup patch to reduce the churn in
this patch.

> +
> +static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>  		struct folio *folio, struct page *page, unsigned long address,
> -		pte_t *ptep, pte_t pteval)
> +		pte_t *ptep, pte_t pteval, unsigned long nr_pages,
> +		bool anon_exclusive)
>  {
> -	const bool anon_exclusive = folio_test_anon(folio) &&
> -				    PageAnonExclusive(page);
>  	swp_entry_t entry = folio_page_swap_entry(folio, page);
>  	struct mm_struct *mm = vma->vm_mm;
> +	pte_t swp_pte;
>  
> -	if (folio_dup_swap_pages(folio, page, 1) < 0)
> +	if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
>  		return false;
>  
>  	/*
> @@ -2176,25 +2186,61 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>  	 * so we'll not check/care.
>  	 */
>  	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
> -		folio_put_swap_pages(folio, page, 1);
> +		VM_WARN_ON(nr_pages != 1);
> +		folio_put_swap_pages(folio, page, nr_pages);
>  		return false;
>  	}
>  
>  	/* See folio_try_share_anon_rmap(): clear PTE first. */
> -	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
> -		folio_put_swap_pages(folio, page, 1);
> +	if (anon_exclusive &&
> +	    folio_try_share_anon_rmap_ptes(folio, page, nr_pages)) {
> +		folio_put_swap_pages(folio, page, nr_pages);
>  		return false;
>  	}
>  
>  	mm_prepare_for_swap_entries(mm);
> -	dec_mm_counter(mm, MM_ANONPAGES);
> -	inc_mm_counter(mm, MM_SWAPENTS);
> -	set_pte_at(mm, address, ptep,
> -		   swp_pte_prepare(entry, pteval, anon_exclusive));
> +	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> +	add_mm_counter(mm, MM_SWAPENTS, nr_pages);
> +	swp_pte = swp_pte_prepare(entry, pteval, anon_exclusive);
> +	set_softleaf_ptes(mm, address, ptep, swp_pte, nr_pages);
>  	return true;
>  }

I think this change (make it consume nr_pages and anon_exclusive) can also go
into an earlier cleanup patch to make this patch easier to consume.

>  
> -static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
> +static unsigned long ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
> +		struct folio *folio, struct page *first_page,
> +		unsigned long address, pte_t *ptep, pte_t pteval,
> +		unsigned long nr_pages)
> +{
> +	unsigned long batch_idx = 0;
> +	unsigned long nr_to_unmap = nr_pages;
> +
> +	while (nr_pages) {
> +		bool exclusive;
> +		unsigned long len = page_anon_exclusive_batch(batch_idx,
> +				nr_pages, first_page, &exclusive);

See below. This style of indenting creates an unreadable blob.

> +
> +		if (!__ttu_anon_swapbacked_folio(vma, folio,
> +				first_page + batch_idx, address, ptep, pteval,
> +				len, exclusive)) {

Same here. Not pleasing to the eye.

> +			/* Restore the remaining PTEs that were cleared. */
> +			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
> +			return nr_to_unmap - nr_pages;
> +		}
> +
> +		nr_pages -= len;
> +		if (!nr_pages)
> +			break;
> +
> +		pteval = pte_advance_pfn(pteval, len);
> +		address += len * PAGE_SIZE;
> +		batch_idx += len;
> +		ptep += len;
> +	}
> +
> +	return nr_to_unmap;
> +}
> +
> +static unsigned long ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>  		struct page *page, unsigned long address, pte_t *ptep,
>  		pte_t pteval, unsigned long nr_pages)
>  {
> @@ -2203,15 +2249,21 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>  	 * See handle_pte_fault() ...
>  	 */
>  	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
> -			 folio_test_swapcache(folio)))
> -		return false;
> +			 folio_test_swapcache(folio))) {
> +		set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
> +		return 0;
> +	}
>  
> -	if (!folio_test_swapbacked(folio))
> -		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
> +	if (!folio_test_swapbacked(folio)) {
> +		if (!ttu_anon_lazyfree_folio(vma, folio, nr_pages)) {
> +			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
> +			return 0;
> +		}
> +		return nr_pages;
> +	}
>  
> -	/* nr_pages > 1 not supported yet */
>  	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
> -					 pteval);
> +					 pteval, nr_pages);
>  }
>  
>  /*
> @@ -2380,13 +2432,18 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			 */
>  			dec_mm_counter(mm, mm_counter(folio));
>  		} else if (folio_test_anon(folio)) {
> -			if (!ttu_anon_folio(vma, folio, page, address,
> -					    pvmw.pte, pteval, nr_pages)) {
> -				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> +			unsigned long nr_unmapped = ttu_anon_folio(vma, folio,
> +						    page, address, pvmw.pte,
> +						    pteval, nr_pages);

unreadable. Feel free to use > 80c and properly indent.

Maybe you can split this patch reasonable up further, there is jsut too much
happening at once.

-- 
Cheers,

David


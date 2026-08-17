Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EACDC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BF16B0164; Mon, 17 Aug 2026 07:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC796B0165; Mon, 17 Aug 2026 07:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6276B0167; Mon, 17 Aug 2026 07:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5B6D6B0164
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:37:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64C4414077F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:37:50 +0000 (UTC)
X-FDA: 85110561900.20.828DF10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D3CFA20009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:37:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A82khPjI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbSm7b5FCzZr7Y2/Maa9jFE0muBDPk7Odg1HUs0TTqk=;
	b=jzitaRfPvj0GfQ0hFuLZCWts08BtX9CdHNKA022fnkty2nd8YE6DDjQLGKwjjZ7x6fmHSA
	SLwqlzdYK2eI6fyusnS0Dqb5c9sKS/VqFgcHu0YRkzqOjenUjz49xYVi3iAox4Az7N72DI
	GrMVBUGmIp9IBsEOojdEUy+1D4sfJ/s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A82khPjI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966667;
	b=1J4jBLRVMAqBHCePcbzmjw0OKmo3JLa6a1fJQ9FmBTvIJQEEJV7IiObcga+XlKV1FLFq6s
	VEt17JXG2bLBYii3msZYgqm4SEuHjY+s2w9fDtnEghO+Y3GwuNSentgyEtkfvx0gcGCXAV
	zfoYRHzqeRJdIaurf5IKU+o/ALYN8Ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C99960A58;
	Mon, 17 Aug 2026 11:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7A11F00A3D;
	Mon, 17 Aug 2026 11:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786966667;
	bh=dbSm7b5FCzZr7Y2/Maa9jFE0muBDPk7Odg1HUs0TTqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A82khPjIfMjsPz4xnic/kCcq5dHmdnA/g7k14UxIjimMII9WqATs/aTgobYAVdhAi
	 wSQVaalA4cS7o2CPnNB1U6oAl/QJScWOE3Mo4yDVUOfaw5beIswzgqw6KhRuWEENmq
	 DsmiitAht7VY+wq5V5Jpq1PzZxigGiiwlZHnn48p+qx7f8xScbxUX7Yvb5vcDX0F14
	 4/zdpRSMUKPcx6tfqAQWVnZ3xTGzx2//UGgHR/PjTTvgIz3z88lcvPTXkox2o7FO5k
	 SIR0Hg5C0GNG7VSXsUENI8dCb8KTH84UepL4edunSRMECxhYXRWOlLUYh1xqJ74+bl
	 TK8DrfLy3nzgQ==
Date: Mon, 17 Aug 2026 12:37:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 4/7] mm/khugepaged: fix outdated comments
Message-ID: <aoLx6f5pa0yxgBl0@lucifer>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
X-Rspamd-Queue-Id: D3CFA20009
X-Stat-Signature: ahhdkzzo9tjn6qrbkwkm9rbn5egypc88
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786966667-174693
X-HE-Meta: U2FsdGVkX18kl2SNC+jYYMOgcFG2MZRqmE7AVBZx2PKCwGSDzicAJzh8FwwZ65kBQh/1uqLRVs2OMeaJXbhklC3+lulobPLOHri9K1Eb17lH8w/Rpp6u7/vDU/wQG9qn5O1SLsJjCBeMmvaujj+GMsf5ggRUT/vUVvAG2mBD6ATZM5wIwWSKl5I/uXOeuMhbJeAiYYEb/h75LkPsuOt10o8P7MffK4VSlrQD7/99jd0EEgh8m3YUmX16yWdF8IuALUGPxTjlJRi4WOHob3zZqVsy9GeJNRpehUnH9kfTPouiYJaAUXR7wiJwc9APdCW2hQvSWZeveaTpB0+fVZKEe8CsYRkKx0OX0Ngl87h0z8mlGooXV9yA6f8zaFCPpN4wDWiFBaztyqSx8aMBIpIOxaJgOiNTA0FWJmpzYZ6Q36F5ajuTNwqJ2cgCIIosPpuqAfztogXvGz7BdZzX4/mpFv6uIcZzJNCyfyACtbeGOBPZCTbPsIlLw9A+fkerP/ludbaIattQHIdAWLZBgjcXPT9j9n5D7Bp123hh21TkD4CWB9uAy1wOSelwhwGyVZcoiPyzgaIOYlxlWyg2TxM+L+OjTWXime+SJWGjZSJx5ZwgogqRyTQ3B3UAoCvaet4GlGXgRV7x75f7/Ske/ure7KZvCij1NMYpPlpexzmSyZ80Gmcbg8pT9CsYrw+DoQiVn4L8xi2Ei/gzwTz3KB/J/i8/Zk0OmSb4WGOKVRNZlz9hfTl0e+62oglQoP6WheFV5+fuzsLjg2KSBncsKoehmKf3Y4U3wD4nYBe4UhNNf3tjB4ggXFyCryls5G2/GaN2FfPYkpq7KCbtzhXJMu6q5NXsem8AJodiN5qkgzNhyyxXdmHkgzOP9b6wwtQCr4T1dwQQnapjl6alUM35n7bd89lbD542N/xYJyurwf1433USQMOzVJe7e5UAeOmk+EC4V6v1nojJs99flhdsb3r
 ACEJ3z/B
 tHb0P8nzZvBv6a1MSrJmcS67KWm3RaD1uxzw5ynJpDzrBiYqWKAew4qmyMkeufJ2/opR8g8465ojcpbDgIat0Dq+MuMXyn/6Sqbs6K8ZT0epYAZO7WYncbExZ7lNXFGA84nIMH7aYX47NhG0wh3hRrpih3HjmCAX3ZhYqpfD2AsvP3N48LbJc35kUbjtjIeL1srHpqRKOblXT1WFCfqhzRStHzyvMSWocdvZerALJk69PXNV7l8AUY3YdYguDKjt+MdSbo3F+9MZhhu3JKDZ3vLE9gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:36AM -0600, Nico Pache (Red Hat) wrote:
> Fix comment in collapse_scan_pmd() that still described the old
> folio_mapcount() > folio_ref_count() check and a "512" false-positive
> scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
> which doesn't suffer from the same limitation.
>
> Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
> when the code actually uses pmdp_collapse_flush.
>
> Fix comment in __collapse_huge_page_swapin() that referenced the old
> function name khugepaged_scan_pmd, now collapse_scan_pmd.
>
> Also clean up some simple typos and stale terminology (mmap_sem ->
> mmap_lock, PG_lock -> folio lock, page -> folio, grammar).
>
> We also clarify a comment regarding where the max_ptes_none check is
> deferred to in mthp_collapse() from the original collapse_scan_pmd check.
>
> Update all comments that references a function to include parentheses.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Assisted-by: Cursor(claude-sonnet-4):4.6
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Thanks, some nits below, but this is some good bit rot fixing here :)

So:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 44 +++++++++++++++++++++-----------------------
>  1 file changed, 21 insertions(+), 23 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index cae510aa2914..90d6e595d282 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -620,7 +620,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  		/*
>  		 * This is required to serialize against
>  		 * collapse_test_exit() (which is guaranteed to run
> -		 * under mmap sem read mode). Stop here (after we return all
> +		 * under mmap_lock read mode). Stop here (after we return all

Ah yeah I think there are still quite a few mmap sem's around and people often
refer to it as that almost with nostalgia :)

>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
>  		 */
> @@ -788,8 +788,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>
>  		/*
>  		 * We can do it before folio_isolate_lru because the
> -		 * folio can't be freed from under us. NOTE: PG_lock
> -		 * is needed to serialize against split_huge_page
> +		 * folio can't be freed from under us. NOTE: folio lock
> +		 * is needed to serialize against split_huge_page()
>  		 * when invoked from the VM.
>  		 */
>  		if (!folio_trylock(folio)) {
> @@ -815,7 +815,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		}
>
>  		/*
> -		 * Isolate the page to avoid collapsing an hugepage
> +		 * Isolate the folio to avoid collapsing a hugepage
>  		 * currently in use by the VM.
>  		 */
>  		if (!folio_isolate_lru(folio)) {
> @@ -927,7 +927,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  	 * Re-establish the PMD to point to the original page table
>  	 * entry. Restoring PMD needs to be done prior to releasing
>  	 * pages. Since pages are still isolated and locked here,
> -	 * acquiring anon_vma_lock_write is unnecessary.
> +	 * acquiring anon_vma_lock_write() is unnecessary.
>  	 */
>  	pmd_ptl = pmd_lock(vma->vm_mm, pmd);
>  	pmd_populate(vma->vm_mm, pmd, pmd_pgtable(orig_pmd));
> @@ -1101,9 +1101,9 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
>  		return SCAN_VMA_CHECK;
>  	/*
>  	 * Anon VMA expected, the address may be unmapped then
> -	 * remapped to file after khugepaged reaquired the mmap_lock.
> +	 * remapped to file after khugepaged reacquired the mmap_lock.
>  	 *
> -	 * thp_vma_allowable_orders may return true for qualified file
> +	 * thp_vma_allowable_orders() may return true for qualified file
>  	 * vmas.
>  	 */
>  	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
> @@ -1159,7 +1159,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if khugepaged_scan_pmd believes it is worthwhile.
> + * Only done if collapse_scan_pmd() believes it is worthwhile.
>   *
>   * For mTHP orders the function bails on the first swap entry, because
>   * faulting pages back in during collapse could re-populate PTEs that
> @@ -1227,7 +1227,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  		pte = NULL;
>
>  		/*
> -		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
> +		 * do_swap_page() returns VM_FAULT_RETRY with released mmap_lock.
>  		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
>  		 * we do not retry here and swap entry will remain in pagetable
>  		 * resulting in later failure.
> @@ -1291,7 +1291,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  }
>
>  /*
> - * collapse_huge_page expects the mmap_lock to be unlocked before entering and
> + * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
>   * will always return with the lock unlocked, to avoid holding the mmap_lock
>   * while allocating a THP, as that could trigger direct reclaim/compaction.
>   * Note that the VMA must be rechecked after grabbing the mmap_lock again.
> @@ -1338,7 +1338,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>
>  	if (unmapped) {
>  		/*
> -		 * __collapse_huge_page_swapin will return with mmap_lock
> +		 * __collapse_huge_page_swapin() will return with mmap_lock
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> @@ -1351,8 +1351,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	mmap_read_unlock(mm);
>  	/*
>  	 * Prevent all access to pagetables with the exception of
> -	 * gup_fast later handled by the ptep_clear_flush and the VM
> -	 * handled by the anon_vma lock + PG_lock.
> +	 * gup_fast later handled by the pmdp_collapse_flush() and the VM
> +	 * handled by the anon_vma lock + folio lock.
>  	 *
>  	 * UFFDIO_MOVE is prevented to race as well thanks to the
>  	 * mmap_lock.
> @@ -1409,9 +1409,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  		spin_lock(pmd_ptl);
>  		VM_WARN_ON_ONCE(!pmd_none(*pmd));
>  		/*
> -		 * We can only use set_pmd_at when establishing
> +		 * We can only use set_pmd_at() when establishing
>  		 * hugepmds and never for establishing regular pmds that
> -		 * points to regular pagetables. Use pmd_populate for that
> +		 * points to regular pagetables. Use pmd_populate() for that
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> @@ -1643,7 +1643,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>
>  	/*
>  	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> -	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
> +	 * is then checked again in mthp_collapse() for each attempted order.
>  	 */
>  	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>  		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
> @@ -1764,12 +1765,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		/*
>  		 * Check if the page has any GUP (or other external) pins.
>  		 *
> -		 * Here the check may be racy:
> -		 * it may see folio_mapcount() > folio_ref_count().
> -		 * But such case is ephemeral we could always retry collapse
> -		 * later.  However it may report false positive if the page
> -		 * has excessive GUP pins (i.e. 512).  Anyway the same check
> -		 * will be done again later the risk seems low.
> +		 * Here the check is racy, but such case is ephemeral and
> +		 * we could always retry collapse later. Anyway the same
> +		 * check will be done again later the risk seems low.

NIT: 'but such case is' -> 'such cases are', 'we could always' -> 'we can
always' and 'the risk seems low' -> 'so the risk seems to be low'.

>  		 */
>  		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
>  			result = SCAN_PAGE_COUNT;
> @@ -1790,7 +1788,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> -		/* collapse_huge_page expects the lock to be dropped before calling */
> +		/* collapse_huge_page() expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
>  		result = mthp_collapse(mm, start_addr, referenced,
>  				       unmapped, cc, enabled_orders);
>
> --
> 2.55.0
>

--
Cheers, Lorenzo


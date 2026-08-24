Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A66C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1506B008A; Mon, 24 Aug 2026 12:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99256B0095; Mon, 24 Aug 2026 12:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF0D6B0096; Mon, 24 Aug 2026 12:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA836B008A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:30:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6A91A01CF
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:30:15 +0000 (UTC)
X-FDA: 85136700390.14.2509BB0
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	by imf04.hostedemail.com (Postfix) with ESMTP id 47B6640003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:30:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Grkl/jbM";
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JQ+76ut+G+okbXf0ZcSWheb6ivuE+t/VkYHwZ4nSXw=;
	b=l1+K27jkO7lGPby2sFr4GRXCOBcF9CrDg9O3Ugma23Q9eYFPwG0W/B3/iHE92A2wTrGeID
	NWORT1RWAo8Wf6jSRqUYiNX7sWLO85Dv9EuJXIcRbXj527iRHWhW+XxUANriMEb5Q/3Zj9
	HDWaMwuj5y8i+A37SzGEZ8vXnRC2cY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Grkl/jbM";
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787589013;
	b=CqpavWQQQR43jzCRpVx8v//UNtZCkSTGxNb9TVYd8B7TT7qGSKxjVYrMcQ/NhgYxduYndS
	5ouYchAKYu+dqsOkKHOZcx36Rj6fAiBAhAshv3EMz3g3pVPWrhipzXC51CcMcoO9dW9G4k
	7tv1oSYroivqzm0WMmW38Xmb30w7rWw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jgpyajVUIr2t4I9Iy5Q2sv8r1iWDEksPp99F4zQjlF8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787589012; v=1; x=1788193812;
 b=Grkl/jbMOQ+sJYfR7ZL4G9VeCYH/dX6gdHmzn0UGcma2CwaeI8WMWErYRuafslvZRMh69AnP
 W5AqYUanb1g9IGEoq/Jy+lSN/SLQc1ei18B4tfSTFUsUB5hhxiXYkfGhDJnnAh7HCKqFMX0LQ1c
 x4RdcaW+t+S3P9pUThXZmc7A=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2601:282:1e00:c920::a061] (2601:282:1e00:c920::a061)
	by smtp.migadu.com with ESMTPS id 547ce434333164ee;
	Mon, 24 Aug 2026 16:30:11 +0000
X-Mizu-Trace-ID: 547ce434333164ee
X-Migadu-Flow: FLOW_OUT
Message-ID: <1c96e2f3-802f-472b-81e6-4af17a721a3c@linux.dev>
Date: Mon, 24 Aug 2026 10:30:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] mm/khugepaged: fix outdated comments
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Content-Language: en-US, en-ZM
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47B6640003
X-Stat-Signature: szeazrt5d9nprt1b6zrcrd6hhhzc15nk
X-Rspam-User: 
X-HE-Tag: 1787589013-360292
X-HE-Meta: U2FsdGVkX1/6xMqFutg7X22zc8aGVfSZAB0QMnEzjh+2UT5CHtJrReNAwenOv7p3Xc4tHurXJxDY2bhUjLPkoA8p1ASMYkSETit3GG6PqC8h6NP5qi/2dq0CuTCVVvuozvw0gJDBNoJ0bp3SjkKVx788+x351IKgWJYH8v0r8FCAEErQrRxXcrAj7hNcXjcZ51AVY/5RMzbrjZQK5Um7SmKFrYicpeY8oPxPBN3xNaOpdKcWBCRXowLR8YqcgWJxsxNecXiG9syIR5BgfItKCqBlH5G1bT5PenEzRELsG/M85Vg0PFZZcQXt8Kx4fymINhtMZuhFl1XxiE7TmWA+bj6mv1yRaOjzSfEbd6gOhSfjcOyD9lPdWqqRIVQxGQRyr3ez+KElE9rjcfqu64+DWnDRbCu3AeNUViaLpMLpxUDT6NCs4KIjQ7kZ/PUe58EEy9GHSx5lQfdOGTFGhtOcnKjuhzloJPyxO4rzHzR0oVGB2psFswbo1slxKBoJkRBk0YQyoVPAQzGBXTFXl/ZfOlOI96M5VndBuy0XK0lKTQ6Mmok7NdP+Y++YbxddNbSykpuHRD2dQPED+F64CXE1q0OjyAPXNPxB48hXXUk7ehSc+KkBA5TlGATaGzc9qsiVTBMOyBrco0zm0M9xfSBspe2uxNePs11iOFXzs45exmx231IF6+eMRn+V4f/2cNvh9/QySYOfsUu++65bd+tfHXN9c73N+MCS9/pCp9wMe1zkKezoJxeI699DE9uIsy+SXHr2f6iHTumarayBnwBD1BQKlJiWQI2r9U6I+SsFWHHKrwnHl2weqYyBQ4mkxnggbzeNhA6lQsozJbZCieV2Hu+3me1axte1ZMSMa0FfF34+V+kEow9Hq6cvAMo59DIbPtO+S5UnG9xRtSdEkUpZTZE+itzyXtDSZnuVuMJvbRdNwUj5AG+wVNEihOb3quCEdI2ACAqZ+mU+HTa41Ix
 OaHcES9e
 cEgkOk1mzv+4UYt0+ApoGnMUH3i1n4L7BKAPgT+mdVhcEB7kbHwnPYTUtx2ebqiGEELTexpPnrprwOwmz8APv+j2takzdc9Scpng7Iztv5yNwX7X2qt0zZ+B62t+baK11QzQ1dEvCwvuJFchBfo77y2DwbIuMtj5v5CLM54QWVceV7j9EPz5CZDNqMOsMasdWbttr6LWppbZ14pzIbY7lRZ3K2B7Ie25ru7up+ed2ce4CIp3YAy00BxJvBAnhYyhtjJzaWjsc6ina9DZ1UdIBY14jOt9oxM2GsNqzH/Ggy2fDqFvlh2kZ5HSshLeYcTcRj/ifRnmPhdP4zQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 6:48 AM, Nico Pache (Red Hat) wrote:
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
> ---

Hi Andrew, 

Can you please append the following fixup!

Thank you :)


commit a5b3dde4f1b1657731dc7a1908ef60f6bd6283db
Author: Nico Pache (Red Hat) <nico.pache@linux.dev>
Date:   Fri Aug 21 04:27:28 2026 -0600

    fixup! mm/khugepaged: fix outdated comments
    
    Polish the refreshed GUP-pin comment wording per review.
    
    Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ad7629a0216a..30f17c7494fa 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1759,9 +1759,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check is racy, but such case is ephemeral and
-		 * we could always retry collapse later. Anyway the same
-		 * check will be done again later the risk seems low.
+		 * Here the check is racy, but such cases are ephemeral and
+		 * we can always retry collapse later. Anyway the same
+		 * check will be done again later, so the risk seems to be low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;


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



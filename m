Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720B5606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4nWKBIl
Received: by kanga.kvack.org (Postfix)
	id 0103B6B05B9; Fri,  6 Nov 2026 13:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4CD6B05BA; Fri,  6 Nov 2026 13:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4DC6B05BB; Fri,  6 Nov 2026 13:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 936986B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14E6F1401BE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:16 +0000 (UTC)
X-FDA: 85405566792.02.C432262
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 694DB4000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4nWKBIl;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990594;
	b=qSYyJOXFYjO1s2YJ4hO82lM/oRPYI4OGJuk75+f2lHisdGumiaSN5myuCvTltoxwyfpCoc
	sDpAphtogEUjwtb2ybRJg0J0y+oGUkOXrwpjX0llNw2iMgFWsV73lonwJbBcsxfY8tmsWB
	0FieHk4w9FBaNHDGntJ8ZgP9EFTRiXI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4nWKBIl;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990594;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8pF0aYmIU89pRzWPe8yPX11SMv9dMgokwhgGc6H9Nc=;
	b=vI2eUf9o/s6neEZQfbpiYFZvZn1XHgsar0TjrcYnuLSXJJOAD0jtxNcS5aiJhLn9dinkw2
	rd00WUaRZYQCPoge+UeXOHABoUwyYpI4c572RdorRkEoE4FZxH83NpX+o61HQok9AB6lDp
	5K8PEE5ZLbmWUrrq+n/kt1g2D96dDxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F09E66061D;
	Fri,  6 Nov 2026 18:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5581F0089F;
	Fri,  6 Nov 2026 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990593;
	bh=R8pF0aYmIU89pRzWPe8yPX11SMv9dMgokwhgGc6H9Nc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I4nWKBIl8tXKJ3+BPxBl3gcLNntNlDXpOMWq0UDciIRi/vhxyb+SVA+AGxm4tlLRb
	 ErU0PHjYAVY6AQfm4UaB8ZDSiW7OVQxFkx0UWICNxelFoBjBfyeukW/L/MFanT5z9A
	 CkcDC4eCOMN2nQFaVlDZ4hvwL5i4OBTIDfDBpnDo52M7aWsrEQ/Rr7vEFqf6yBlfIL
	 NueO74dlKWfpi8I8a+bgyVM+K5OUG9g5nFpXceUa7XkPYhucR7X1/atmkXw78NWOwd
	 +7GA0dnTQvZZ1q842wj15u+gOGLm3UL5tmEBVzYesvKwXU0hrbsiO+y4u1JzD9mR4C
	 sfzXv/VY7LXfQ==
Message-ID: <sashiko-outbox-202085@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 30/32] mm: handle PMD swap entry faults on swap-in
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: chenhuacai@kernel.org, ying.huang@linux.alibaba.com, "Baoquan He" <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, "Nico
 Pache" <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, "Vlastimil
 Babka" <vbabka@kernel.org>, lance.yang@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
In-Reply-To: <20261105183940.2236717-31-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-31-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:43:11 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 694DB4000A
X-Stat-Signature: 88es3ewnkg4u7pa9ks7knae7eejrny36
X-Rspam-User: 
X-HE-Tag: 1793990594-240536
X-HE-Meta: U2FsdGVkX1+MwwOUhvPGRK9+/hfOZjrMImo6d9k4oQAWYXBQZvIGAIrNF5+HRbfPtpqtr9cn0H6lGr6n2v4Vrcs/bdGOMIpdw4tRsXXahekGvsZ7XdUEIsaGxPe9tR8BiD9B6U80QEmz3qVJXnfEKws5ZF78qOhzrBpiOGGAsp17w820cYN6JuvYg6kinptrQFSra7bX+MBHKY9iUzjjxxnbTuWBOtfCw4GREdIXQ8tc3AuuG6pv1e0CJhZa3NkKO1L1MK4h07hS0vCvxjDxxbc2ZgoEuqOsIlngO44t2c6yqSzIXWIjWdohCYjmFbRC8tTOkAryyACCvrLcl3vQ8vau9v3reAwTjTwkBlZZ0Pp7M27MR3cawrDFYmVwnHBW4HEF7NYNk5tCXV7Zv/vyiTjY4aTzdoUYrINWK1Yqd4sDqIXJeUazFBOOXNakmP8f7LnNBczRffPHl2Oet2LVz3j9CVQLZcV3ZtEFWlr46q+sNH1jdZ7Rpq1u3ZCVcRJM9xP82i5GQpu4k1QYN3aXuMNgyLKF8Md7SUH8YHLCXqf6EhLoK4gtdoRAlvGawISPCfRKV4dKZN13I2K4esX8mi826XMtVVWSKvbEKtny7wweIj7kPbl83Im+kWa2RpwrHiHUCx3FTacye6IhImDOPtPeVEdmnT0NUwCmX6UNG3iHcm5/1RNu8Z+6cqKfrUl4d2jTMcaGPM7sdrUNVm5nk2J88cl0ajCiAXAwAUaHEN1mOmH93LJsdmQL7h7U6rHkb5PPUICa2NCKGwycrZcs55m25TjahXFbwwhtZHQEN333OVKvOqk5kN1lJK+bTevpScLHZT0JPUxv3+SJGhI3wtWAOkzBZz4h2JU/rJOBVFpBdpY9zfRGhgOppjIl3gr52FrWyn0PSBdI+n/smEVdT7wah9/DeB6MIEMTJV3LRf8PDZaK53lYHbFJM7kpst+RVRK4MKq7lFW00lEGpjV
 UF9nA0GQ
 WhB+7GVV38pdE6mqwkI7R1LlrlDXtotREgsFxniNq6L8G0vQ9ABPz27W5ZBLc0obo1CEGR15y7SBslfbmwywU9fHxfDxPraM55uYPkhgM3NpkNQFL2iS7IWoGjOH4o7IJRtnrZ+z6waGa5RvTEKHMfxyNM47la0N/NlL3lpfbz8Q+fRu4EHN087XfKubEBDthw5aYlfcj+tplI1pUmSRJM0xuftlMZJDwfHTHVuPndtazecrzu2/cGoOT5AZNYdW6jFegbLrsE44DNBc95KDJRYHoibn6qMdg4JBhYAW0AkNVl4cx7PoEp99XetIPadQkNRC4I8QDb+yxaI+qaS2YBd2p9ygS5J4fN4cWGbs55/LVtC5CLyD74xWmEcFpGq39/xVRpv8O+reg8jgaNw5IRt+PZ+sOtJLXiLqmfPMCkaXDJw9W1vOJOTXjIopIewpkpIoIGlp9ysJ4uJYG3DuuufaAfgPdIeGFsJ43wtmyhJd3/79n/HUzYRnllbPiaOXw/9oXdwnGmhNMgpwbQY2+40HbYlyvcCk9e+pAv5EejB1YQdCWExivbqUHE5Z8gN7dNm1Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Critical] mm: use-after-free in do_huge_pmd_swap_page() from
  unlocking PTL first
- [Critical] mm: unmapped PMD swap-cache folio in
  do_huge_pmd_swap_page() corrupts rmap
- [Medium] mm: missing PTE fault fallback after PMD split in
  do_huge_pmd_swap_page()
--

commit 651cc7048660407a18f57e406abe979d3a9ccbfe
Author: Usama Arif <usama.arif@linux.dev>

mm: handle PMD swap entry faults on swap-in

This commit adds do_huge_pmd_swap_page() and hooks it into
__handle_mm_fault() to fault in PMD swap entries at PMD granularity when a
PMD-sized folio is available, or split the PMD swap entry and fall back to
PTE swap-in otherwise.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e02a885ea1d0b..b8d61cdf8cbfb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
[ ... ]
> @@ -2425,6 +2426,266 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault =
*vmf)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_THP_SWAP
> +/**
> + * do_huge_pmd_swap_page() - Handle a fault on a PMD-level swap entry.
> + * @vmf: Fault context. vmf->orig_pmd contains the swap PMD.
> + *
> + * A PMD swap entry is a compact encoding for HPAGE_PMD_NR consecutive s=
wap
> + * slots. If the swap cache still has one PMD-sized folio covering the r=
ange,
> + * map it directly at PMD level. If the range has been split into per-pa=
ge
> + * cache state, or zswap may have per-page state for it, split the PMD s=
wap
> + * entry and retry at PTE granularity.
> + *
> + * Return: VM_FAULT_* flags.
> + */
> +vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
> +{
[ ... ]
> +	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_PAGEFAULT,
> +				     HPAGE_PMD_ORDER)) {
> +		__split_huge_pmd(vma, vmf->pmd, haddr);
> +		return 0;
> +	}
> +
> +	swp_entry =3D entry;
> +
> +	/* Prevent swapoff from happening to us. */
> +	si =3D get_swap_device(swp_entry);
> +	if (IS_ERR_OR_NULL(si)) {
> +		if (IS_ERR(si))
> +			return VM_FAULT_SIGBUS;
> +		return 0;
> +	}
> +
> +	cache_state =3D swap_pmd_cache_lookup(swp_entry, &folio);
> +	if (cache_state =3D=3D SWAP_PMD_CACHE_SPLIT)
> +		goto split_fallback;
> +	if (!folio) {
> +		/*
> +		 * PMD swap entries encode ordinary per-page swap slots. If any
> +		 * slot is in zswap, split and let the PTE swap path load the
> +		 * range per page. Otherwise the range is all on disk and can be
> +		 * read back as one PMD-sized folio.
> +		 */
> +		if (zswap_is_present(swp_entry, HPAGE_PMD_NR))
> +			goto split_fallback;
> +
> +		folio =3D swapin_sync(swp_entry, GFP_HIGHUSER_MOVABLE,
> +				    BIT(HPAGE_PMD_ORDER), vmf, NULL, 0);
> +		if (IS_ERR_OR_NULL(folio))
> +			goto split_fallback;
> +
> +		/* Had to read from swap area: Major fault */
> +		ret =3D VM_FAULT_MAJOR;
> +		count_vm_event(PGMAJFAULT);
> +		count_memcg_event_mm(mm, PGMAJFAULT);
> +	}
> +
> +	ret |=3D folio_lock_or_retry(folio, vmf);
> +	if (ret & VM_FAULT_RETRY)
> +		goto out_release;
> +
> +	/* Verify the folio is still in swap cache and matches our entry */
> +	if (unlikely(!folio_matches_swap_entry(folio, swp_entry)))
> +		goto out_page;
[ ... ]
> +	/* Lock the PMD and verify it hasn't changed */
> +	vmf->ptl =3D pmd_lock(mm, vmf->pmd);
> +	if (unlikely(!pmd_same(vmf->orig_pmd, pmdp_get(vmf->pmd)))) {
> +		spin_unlock(vmf->ptl);
> +		goto out_page;
> +	}
[ ... ]
> +	set_pmd_at(mm, haddr, vmf->pmd, pmd);
> +	update_mmu_cache_pmd(vma, haddr, vmf->pmd);
> +
> +	/* Update orig_pmd for any follow-up wp_huge_pmd() below. */
> +	vmf->orig_pmd =3D pmd;
> +
> +	/*
> +	 * Conditionally try to free up the swap cache. Do it after mapping,
> +	 * so raced page faults will likely see the folio in swap cache and
> +	 * wait on the folio lock.
> +	 */
> +	if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags))
> +		folio_free_swap(folio);
> +
> +	spin_unlock(vmf->ptl);
> +
> +	folio_unlock(folio);
> +	put_swap_device(si);

[Severity: Critical]
Can releasing vmf->ptl before calling folio_unlock(folio) in
do_huge_pmd_swap_page() lead to a use-after-free on folio?

do_huge_pmd_swap_page() holds a single reference to folio from
swap_pmd_cache_lookup() or swapin_sync(), and set_pmd_at() transfers that
reference to the PMD mapping. When should_try_to_free_swap() is true (such
as on SWP_SYNCHRONOUS_IO swap devices, exclusive write faults, or VM_LOCKED
VMAs), folio_free_swap(folio) drops the swap-cache references as well.

At that point the faulting thread no longer holds its own reference on
folio; only vmf->ptl prevents the PMD mapping reference from going away. In
mm/memory.c:do_swap_page(), folio_unlock(folio) is called before
pte_unmap_unlock(vmf->pte, vmf->ptl):

	if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags))
		folio_free_swap(folio);

	folio_unlock(folio);
	...
	pte_unmap_unlock(vmf->pte, vmf->ptl);

With spin_unlock(vmf->ptl) happening first here, a racing MADV_DONTNEED or
munmap() in zap_huge_pmd() (or move_folios_to_lru() dropping a transient LRU
isolation reference) can unmap and free the folio while PG_locked is still
set before folio_unlock(folio) runs on this CPU. Should folio_unlock(folio)
be called before spin_unlock(vmf->ptl)?

> +
> +	/*
> +	 * If the write fault wasn't satisfied above (folio is shared without
> +	 * exclusivity), call wp_huge_pmd() to handle COW or
> +	 * userfaultfd-wp without forcing a second fault.
> +	 *
> +	 * wp_huge_pmd() may return VM_FAULT_FALLBACK if it had to split the
> +	 * PMD; that's a normal outcome, and the natural PTE-level refault will
> +	 * complete the COW. Mask it so callers (and the arch fault handler)
> +	 * don't see VM_FAULT_FALLBACK as a fatal VM_FAULT_ERROR.
> +	 */
> +	if (write && !pmd_write(pmd) && !rwp_restore) {
> +		vm_fault_t wp_ret =3D wp_huge_pmd(vmf);
> +
> +		wp_ret &=3D ~VM_FAULT_FALLBACK;
> +		ret |=3D wp_ret;
> +		if (ret & VM_FAULT_ERROR)
> +			ret &=3D VM_FAULT_ERROR;
> +	}
> +
> +	return ret;
> +
> +out_page:
> +	folio_unlock(folio);
> +out_release:
> +	folio_put(folio);
> +	put_swap_device(si);
> +	return ret;
> +
> +unlock_split_fallback:
> +	/*
> +	 * PTE fallback cannot add a single-page rmap to a PMD-sized folio that
> +	 * has never been mapped: do_swap_page() would hand the whole folio to
> +	 * folio_add_new_anon_rmap() while installing one PTE. Nor can it do
> +	 * anything useful with a folio that failed to read. Remove either from
> +	 * the swap cache so each slot is read back into its own order-0 folio.
> +	 * An uptodate anon swap-cache folio can be mapped one PTE at a time and
> +	 * must stay cached, so that any poisoned subpage stays visible to
> +	 * do_swap_page(). This mirrors unuse_pmd_entry().
> +	 */
> +	if (folio_matches_swap_entry(folio, swp_entry) &&
> +	    (!folio_test_uptodate(folio) || !folio_test_anon(folio)))
> +		swap_cache_del_folio(folio);
> +	folio_unlock(folio);
> +	folio_put(folio);

[Severity: Critical]
What happens if a newly allocated PMD-sized swap-cache folio
(!folio_test_anon(folio) or !folio_test_uptodate(folio)) exits via out_page
or out_release instead of unlock_split_fallback?

There appear to be a few paths where an unmapped PMD-sized folio remains in
the swap cache after the PMD swap entry is split or zapped:

1. If the PMD changed while swapin_sync() or folio_lock_or_retry() was
   in progress (for example, a racing thread split the PMD at
   split_fallback, or mprotect/madvise split the PMD), the !pmd_same()
   check jumps to out_page without deleting the !folio_test_anon(folio)
   (or !folio_test_uptodate(folio)) folio from the swap cache.

2. If the PMD changed because a racing zap_huge_pmd() or
   madvise_free_huge_pmd() zapped the swap entry while this thread held the
   folio lock, swap_put_entries_direct() -> __try_to_reclaim_swap() fails
   folio_trylock(folio). Unlike mm/memory.c:do_swap_page(), which calls
   folio_free_swap(folio) under out_page before unlocking the folio,
   out_page here does not call folio_free_swap(folio), leaving the folio
   and swap slots stranded in the swap cache.

3. On asynchronous swap devices, swapin_sync() inserts a locked
   !folio_test_anon(folio) PMD-sized folio into the swap cache, and
   folio_lock_or_retry() drops the fault lock and jumps to out_release with
   VM_FAULT_RETRY (and MADV_WILLNEED's swapin_pmd_swap_entry() similarly
   populates an unmapped PMD-sized folio). If the PMD is subsequently split
   before the folio is mapped at PMD level (including via the
   !thp_vma_allowable_order() check at the top of do_huge_pmd_swap_page(),
   which splits the PMD without checking the swap cache), the unmapped
   PMD-sized folio stays in the swap cache.

When a subsequent PTE fault enters mm/memory.c:do_swap_page() on the
HPAGE_PMD_NR contiguous split PTE swap entries, the large-folio PTE batching
logic batches all nr_pages =3D HPAGE_PMD_NR PTEs. Because nr_pages equals
folio_nr_pages(folio), the check in do_swap_page():

	if (!folio_test_anon(folio) && folio_test_large(folio) &&
	    nr_pages !=3D folio_nr_pages(folio)) {
		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
			swap_cache_del_folio(folio);
		goto out_nomap;
	}

does not trigger, and do_swap_page() passes the PMD-mappable folio to
folio_add_new_anon_rmap() while installing PTEs. Since
folio_add_new_anon_rmap() initializes any folio_test_pmd_mappable(folio)
for a PMD mapping (_entire_mapcount =3D 0, _large_mapcount =3D 1,
_nr_pages_mapped =3D ENTIRELY_MAPPED, and PageAnonExclusive only on subpage
0), wouldn't PTE-mapping it corrupt the rmap/mapcounts and PageAnonExclusive
state across subpages?

> diff --git a/mm/memory.c b/mm/memory.c
> index 47bba4695d855..e71c590113e07 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
[ ... ]
> @@ -6778,6 +6747,9 @@ static vm_fault_t __handle_mm_fault(struct vm_area_=
struct *vma,
> =20
>  		if (pmd_is_migration_entry(vmf.orig_pmd))
>  			pmd_migration_entry_wait(mm, vmf.pmd);
> +		else if (IS_ENABLED(CONFIG_THP_SWAP) &&
> +			 pmd_is_swap_entry(vmf.orig_pmd))
> +			return do_huge_pmd_swap_page(&vmf);
>  		return 0;
>  	}
>  	if (pmd_trans_huge(vmf.orig_pmd)) {

[Severity: Medium]
When do_huge_pmd_swap_page() splits the PMD (either at the
!thp_vma_allowable_order() check, at split_fallback, or inside wp_huge_pmd()
when a non-exclusive swapped-in THP must be split into PTEs for COW), should
__handle_mm_fault() fall through to the fallback label and call
handle_pte_fault(&vmf) rather than returning 0 (or masking out
VM_FAULT_FALLBACK)?

Other PMD handlers in __handle_mm_fault() such as create_huge_pmd() and
wp_huge_pmd() return VM_FAULT_FALLBACK so __handle_mm_fault() jumps to
fallback: and resolves the PTE fault in the same handle_mm_fault() call.

By returning 0 after splitting the PMD swap entry (or clearing
VM_FAULT_FALLBACK when wp_huge_pmd() splits the read-only PMD into read-only
PTEs without copying), callers of handle_mm_fault() that do not loop on 0 -
such as fixup_user_fault(), fault_in_safe_writeable(), and
user_event_mm_fault_in() - see a successful return while the target PTE is
still a non-present swap entry or read-only PTE, causing subsequent
pagefault-disabled user accesses to fail with -EFAULT.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105183940.2236=
717-1-usama.arif@linux.dev?part=3D30


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089CD606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N33BZPu0
Received: by kanga.kvack.org (Postfix)
	id A4A876B05BC; Fri,  6 Nov 2026 13:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAAA6B05BD; Fri,  6 Nov 2026 13:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0196B05BE; Fri,  6 Nov 2026 13:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1956B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C11D1601A6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:18 +0000 (UTC)
X-FDA: 85405566876.16.5A0B7B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 71864A0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N33BZPu0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990596;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbhcKroRi+cMpYIq+tlS1ByN9fO/QXiijMHvW7/3fRg=;
	b=Ls5ZKUbM9guKG4Eo+BcBbfrUF/U+bKjRYI6z8p5gOJAzbRNk/yWKJpu7w7BnfgwtyDVIrt
	/cxeSEKxiEiJpXPfcRtGlsGXeYdbAyEhBoAiA5U3iuokPmlmiE4TPLkxHl36MbfNhAuUQ0
	cHRPcG4uTK//DxLecwZGoE4QkJBbcsU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N33BZPu0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990596;
	b=j8ub/Qjx3/sA4xrHWqs8HJQv6MgJjkhexMLNl+wJwookbL60fCVEie0vcXSiKDXuCom5Ht
	g8/RUyMyrqDn5XLg1JborZr4SBUkCRO4g4ghONNpyFnV2Y3N1uje2av+LR04mpv1LHRZlz
	cXt6bUg06T4xigGWfSQcFk7huTYXapg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8F3042A29;
	Fri,  6 Nov 2026 18:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377CF1F0089F;
	Fri,  6 Nov 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990595;
	bh=hbhcKroRi+cMpYIq+tlS1ByN9fO/QXiijMHvW7/3fRg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N33BZPu03OebXw0xSed0vOEDw6Ba8r90qPl2WwWqQ+riGoDl4JFaQcDvtvEPQitN/
	 KOe/tb2veySCQy1/rMbD7N5GGjeF3Dxlh/HUtCcI4R2WeU7wGpQdLfItjmXLJPApI6
	 02Bq7uDU8yr6fvQdhXC0DxkRpQp6ALmEVabIQtKSj6YtElPuMbJH6n5o9GBG6ckQBU
	 8KdVX1astruyfpbJM5qZjE+5dFJKu+xQ4piXoLH852EosU6gtJvLhu0P6avBjHZIWV
	 4uDiWBUjmPuHMOocpMRv0FyCXVTzXaHDUAZng1xHpJUSpKrcV/061yk92DAGGh8gUH
	 E0YsXiKlsdZvQ==
Message-ID: <sashiko-outbox-202086@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 31/32] mm: install PMD swap entries on swap-out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: chenhuacai@kernel.org, ying.huang@linux.alibaba.com, "Baoquan He" <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, "Nico
 Pache" <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, "Vlastimil
 Babka" <vbabka@kernel.org>, lance.yang@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
In-Reply-To: <20261105183940.2236717-32-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-32-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:43:13 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 71864A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: z66jiojkyf1go58nadkeyc66rjabwxya
X-HE-Tag: 1793990596-771089
X-HE-Meta: U2FsdGVkX1+/yBvGkWW9CDh6E7GjSREVfUoidUo5HAhL1zN4AjFAuavmO0Mklb/ivOdOOedN/xvEug13hEKmjrjSl3iREZv04oejscXnnJMGrfhYpjiDwtApEAJSGqK2EI235mdo/AnKJeIB0TBQZ5jnV53tWvUdWlrc3zAAPqQkmBPZSu7uGCHTfjA/lD2MA5hOKPhtooOe/4TInYcDsLget8NK1T93RxSlZzXmUmm6xmNhnGoWCH5rmF+ullLlYgcy9+AWPsOPGG3DMTeplXd+GKUbxQdve47i0t8054GsfAyF+bPKHUnf/qi/cEo+6lCXYaXgF8jXlg5aasv/hx2tkY+RtXUn+ljHdZWdQ3vqWaYBvoSjBslEPfIHi922B/yL0BsI42AIvJ+JMAqcbZ6rxqA5/cm6rj1BONIg0SxRSbBLHjRsg4d6fJgcSkwV62JZjhS2Seg4RqZSFYWnjj7vwsbe3qR9T89zPKF32dQdTGunXfd350qOURDozvqFWyGKLxiJ/1u8ia+0xwtXVDpvUVtdALhFx4Rr+c4K93UrIOTG8/GbqYSY9YiBtetNbJ3jMjgutZvhmNPmYXTy0M0JTyh848txG8b7015UyJnth97c4msIgHwH+l5lMMGzQbYlvIWkIBSUXuWAH8NRUVs9DopD4Yg9yyiZm1zT+MZX+uESLV6XUTlgSXxMOeqejCmX5EGpxAIwPRbKZijvq7W/VsYul8aIXDzyIzdOV7D7+gYMvAIIO8Y+UhP1Xr/6Ye1sZ0kO1tiGSOQW2JPsq0xJU/kUqHZCLO/qbPZJ2K3uXsE4wOv0woUFoDZrsHYe+7qGrxtlDuWGnNB+j/KFV2nGCC5w0ErT3hHnUFqPVZw8H8A3iYmbbegjB1LSBwDHmd7eyvsV3fdYfsvHRBv+MK4fyhrd7QddMYlVIYvHb2koyh6pvnOmp5bWOEUOuf93aCo5O48crdZBl0FMisY
 B90RgNhy
 Kam1U1DrCDZ23yJ1nTZb6KUoArvumoZ16Oiz6gxHKoCmytJQrE7Tm/FwfKNNA6+yX/vhsS6sD3TU1XDNP7LLrB2e/Bjrd7fbz6vCKhXIeNLCkcgeto5vYfe8nBI0krbr5HfHufwg8kEBYTD22vZV69viMHp7AAHlA8t2ToOIbEe47LWuu78WLqmNVC6AdHhR7nyQ9Ial8t/iS0p3fZ9KmWDe7sBF31KCV0Bgw+EHxxINVi3ec5sX8LGjLq/FYIulsamgtLVyBprY3YA+6bnhWMMhAQMrNyYimJcHzQAuN4T+ZFnE94Z7A8rLLh6vEC4EysJkKU14qbNKlvt92aZOY2SXd1qGqMBjqIni2UbLeDFkuz5rDMxwdOAm3AAcY9KjI7iU1zPTjShtm+KZH1FoLzz1JgbYMxJB1MVL6FJXhgCOQ0wcRHLjEdmeiLv82A2l9zPrsEY5Gd/Xhwv+YTDVfErJ542fe+iGI1yIgoPyoEftNbJCGfUswXSCi+tXBWqSkJLSaEDYDHszeJ5vmyk5pikPwyephA16+yGuiNeG86Xlbq7XfdXAJXvQD09yF0FI2C5hV
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
- [Critical] mm: rmap corruption in do_swap_page() on unmapped PMD
  swapcache folio
- [Critical] mm: stale swap data via set_pmd_swap_entry() after
  madvise_free_huge_pmd()
- [High] mm: swapped-out PMD THPs omitted from core dumps in
  follow_pmd_mask()
--

commit 5fc4ff682d479e59aca8b75c2c237658535938ae
Author: Usama Arif <usama.arif@linux.dev>

mm: install PMD swap entries on swap-out

This commit avoids splitting a PMD-mapped anonymous THP during swap-out when
the folio is already in the swap cache, replacing the PMD mapping directly
with a PMD-level swap entry via set_pmd_swap_entry().

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b8d61cdf8cbfb..95fce141e114f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -5778,3 +5778,87 @@ void remove_migration_pmd(struct page_vma_mapped_w=
alk *pvmw, struct folio *folio
>  	trace_remove_migration_pmd(address, pmd_val(pmde));
>  }
>  #endif
> +
> +#ifdef CONFIG_THP_SWAP
> +/**
> + * set_pmd_swap_entry() - Replace a PMD mapping with a PMD-level swap en=
try.
> + * @pvmw: Page vma mapped walk context, must have pvmw->pmd set and
> + *        pvmw->pte NULL (i.e. PMD-mapped).
> + * @folio: The folio being swapped out. Must be in the swap cache.
> + *
> + * This installs a PMD-level swap entry in place of a present PMD mappin=
g,
> + * avoiding the need to split the PMD into PTE-level swap entries.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
> +		       struct folio *folio)
> +{
[ ... ]
> +	mm_prepare_for_swap_entries(mm);
> +
> +	if (pmd_dirty(pmdval))
> +		folio_mark_dirty(folio);
> +
> +	entry =3D folio->swap;
> +	pmdswp =3D softleaf_to_pmd(entry);
> +	if (pmd_soft_dirty(pmdval))
> +		pmdswp =3D pmd_swp_mksoft_dirty(pmdswp);
> +	if (pmd_uffd(pmdval))
> +		pmdswp =3D pmd_swp_mkuffd(pmdswp);
> +	if (anon_exclusive)
> +		pmdswp =3D pmd_swp_mkexclusive(pmdswp);
> +	set_pmd_at(mm, haddr, pvmw->pmd, pmdswp);

[Severity: Critical]
Can installing a PMD swap entry here lead to rmap corruption in
do_swap_page() if the PMD swap entry is later split while a freshly
allocated PMD-order folio is in the swap cache?

Once set_pmd_swap_entry() installs a PMD swap entry, swapin_pmd_swap_entry()
(via MADV_WILLNEED) or do_huge_pmd_swap_page() calls swapin_sync() with
BIT(HPAGE_PMD_ORDER), which allocates an unmapped PMD-order folio in the
swap cache with !folio_test_anon(folio).

If the PMD swap entry is then split into HPAGE_PMD_NR contiguous PTE swap
entries while that unmapped PMD-order folio remains in the swap cache, for
example when madvise(MADV_WILLNEED) is followed by madvise(MADV_NOHUGEPAGE)
or prctl(PR_SET_THP_DISABLE) and a page fault enters do_huge_pmd_swap_page(=
):

mm/huge_memory.c:do_huge_pmd_swap_page()
	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_PAGEFAULT,
				     HPAGE_PMD_ORDER)) {
		__split_huge_pmd(vma, vmf->pmd, haddr);
		return 0;
	}

(or when do_huge_pmd_swap_page() backs out at folio_lock_or_retry() or
!pmd_same() after a concurrent split), the subsequent fault falls back to
do_swap_page().

In do_swap_page(), swap_pte_batch() batches all HPAGE_PMD_NR contiguous PTE
swap entries, so nr_pages =3D=3D folio_nr_pages(folio) and the partial-mapp=
ing
check does not remove the folio from the swap cache. do_swap_page() then
installs PTEs via set_ptes() and calls folio_add_new_anon_rmap():

mm/memory.c:do_swap_page()
	} else if (!folio_test_anon(folio)) {
		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages, folio);
		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
		folio_put_swap(folio, NULL);
	}

However, folio_add_new_anon_rmap() assumes any folio_test_pmd_mappable(foli=
o)
folio is being PMD-mapped rather than PTE-mapped:

mm/rmap.c:folio_add_new_anon_rmap()
	} else if (!folio_test_pmd_mappable(folio)) {
		...
	} else {
		nr =3D folio_large_nr_pages(folio);
		/* increment count (starts at -1) */
		atomic_set(&folio->_entire_mapcount, 0);
		folio_set_large_mapcount(folio, 1, vma);
		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
			atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
		if (exclusive)
			SetPageAnonExclusive(&folio->page);
		nr_pmdmapped =3D nr;
	}

Because the folio was mapped with PTEs via set_ptes(), this leaves
page->_mapcount at -1 on all subpages, sets _large_mapcount to 1 instead of
HPAGE_PMD_NR, sets _entire_mapcount to 0, and only sets PageAnonExclusive on
the head page. When zap_pte_range() later unmaps those PTEs via
folio_remove_rmap_ptes(), page->_mapcount underflows to -2, _large_mapcount
underflows, and _entire_mapcount is never decremented, triggering a Bad page
state bug when the folio is freed. (Similarly, if swapoff runs after the PMD
swap entry is split, unuse_pte() hits VM_WARN_ON_ONCE(folio_test_large(foli=
o))
and calls folio_add_new_anon_rmap() while installing a single PTE.)

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9d6353e98e7c7..b76e5f85c9bcc 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2275,6 +2275,25 @@ static bool try_to_unmap_one(struct folio *folio, =
struct vm_area_struct *vma,
>  		}
> =20
>  		if (!pvmw.pte) {
> +#ifdef CONFIG_THP_SWAP
> +			/*
> +			 * If the folio is in the swap cache and we're not
> +			 * asked to split, install a PMD-level swap entry.
> +			 */
> +			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
> +			    folio_test_anon(folio) &&
> +			    folio_test_swapcache(folio)) {
> +				if (set_pmd_swap_entry(&pvmw, folio))
> +					goto walk_abort;

[Severity: High]
Does replacing the PMD with a non-present PMD swap entry cause swapped-out
THPs to be silently omitted from core dumps?

Previously, reclaiming an anonymous THP split the PMD into PTE swap entries.
When dump_user_range() (or mte_dump_tag_range() on arm64) calls
get_dump_page() with FOLL_FORCE | FOLL_DUMP | FOLL_GET, follow_page_pte()
returns NULL for a non-none, non-present PTE, which causes
__get_user_pages() to call faultin_page() and fault the swapped-out page ba=
ck
in.

With a non-present PMD swap entry, follow_pmd_mask() instead calls
no_page_table():

mm/gup.c:follow_pmd_mask()
	if (pmd_none(pmdval))
		return no_page_table(vma, flags, address);
	if (!pmd_present(pmdval))
		return no_page_table(vma, flags, address);

And no_page_table() treats FOLL_DUMP on an anonymous VMA as an unpopulated
hole, returning ERR_PTR(-EFAULT):

mm/gup.c:no_page_table()
	if (flags & FOLL_DUMP) {
		if (vma->vm_ops && vma->vm_ops->may_split)
			return ERR_PTR(-ENOSYS);

		/*
		 * For anonymous or fault-less VMA, return -EFAULT to judge
		 * there is no page Mapped, so we can skip dumping them.
		 */
		if (vma_is_anonymous(vma) || !vma->vm_ops->fault)
			return ERR_PTR(-EFAULT);
	}

Because __get_user_pages() sees IS_ERR(page), it aborts without calling
faultin_page(), so get_dump_page() returns NULL and dump_user_range() skips
the entire 2MB THP range in the core dump. Should follow_pmd_mask() only ca=
ll
no_page_table() when pmd_none(pmdval) and return NULL for non-present PMD
swap entries?

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 071a6eaef1a1a..179ba94494e85 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1330,7 +1330,14 @@ static unsigned int shrink_folio_list(struct list_=
head *folio_list,
>  			enum ttu_flags flags =3D TTU_BATCH_FLUSH;
>  			bool was_swapbacked =3D folio_test_swapbacked(folio);
> =20
> -			if (folio_test_pmd_mappable(folio))
> +			/*
> +			 * With THP_SWAP, PMD-mappable folios already in the
> +			 * swap cache can be unmapped with a PMD-level swap
> +			 * entry, avoiding the cost of splitting the PMD.
> +			 */
> +			if (folio_test_pmd_mappable(folio) &&
> +			    !(IS_ENABLED(CONFIG_THP_SWAP) &&
> +			      folio_test_swapcache(folio)))
>  				flags |=3D TTU_SPLIT_HUGE_PMD;

[Severity: Critical]
Can skipping TTU_SPLIT_HUGE_PMD for a PMD-mapped THP that is already in the
swap cache result in reclaiming the folio without writeback after
madvise(MADV_FREE), leaving the PMD swap entry pointing to stale or
unwritten swap data?

With this change and do_huge_pmd_swap_page(), an anonymous THP can be both
PMD-mapped and in the swap cache (for instance, after a read swap-in in
do_huge_pmd_swap_page() when should_try_to_free_swap() is false, where the
process then writes to the THP in memory while the swap slot holds older
data; or if an earlier reclaim pass called folio_alloc_swap() and
try_to_unmap() aborted before unmapping all mappings).

If userspace then calls madvise(MADV_FREE) on that range,
madvise_free_huge_pmd() clears both the folio dirty bit and the PMD dirty
bit without freeing the swap cache entry (unlike madvise_free_pte_range(),
which checks folio_test_swapcache(folio) and calls folio_free_swap()):

mm/huge_memory.c:madvise_free_huge_pmd()
	if (folio_test_dirty(folio))
		folio_clear_dirty(folio);
	folio_unlock(folio);

	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
		pmdp_invalidate(vma, addr, pmd);
		orig_pmd =3D pmd_mkold(orig_pmd);
		orig_pmd =3D pmd_mkclean(orig_pmd);

		set_pmd_at(mm, addr, pmd, orig_pmd);
		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
	}

	folio_mark_lazyfree(folio);

Because folio_test_swapcache(folio) is still true, folio_mark_lazyfree()
returns early without clearing PG_swapbacked:

mm/folio.c:folio_mark_lazyfree()
	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
	    !folio_test_lru(folio) ||
	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
		return;

When shrink_folio_list() later reclaims this folio, folio_test_swapcache()
is already true, so it skips the !folio_test_swapcache(folio) block (which
would have called folio_mark_dirty(folio)), skips TTU_SPLIT_HUGE_PMD here,
and calls try_to_unmap_one() -> set_pmd_swap_entry().

In set_pmd_swap_entry(), pmd_dirty(pmdval) is false, so the folio is not
marked dirty while a PMD swap entry is installed for folio->swap. Back in
shrink_folio_list(), folio_test_dirty(folio) is false, so pageout() is
skipped and the folio is freed without writing it out, leaving subsequent
faults to read stale pre-modification data or unwritten swap blocks from
disk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105183940.2236=
717-1-usama.arif@linux.dev?part=3D31


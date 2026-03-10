Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE08AEA854E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146756B0088; Tue, 10 Mar 2026 04:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4E96B0089; Tue, 10 Mar 2026 04:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17D06B008A; Tue, 10 Mar 2026 04:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E20D16B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:55:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97777B96E6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:55:55 +0000 (UTC)
X-FDA: 84529545870.21.88781F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DAEAF40008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:55:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J2XxWrGF;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773132954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vtw+nofIWLL8EQeRnihPIN94PDjlzKO6HoSLWGVWP4=;
	b=ZCTs2S4ZDZ0vuuVq06v5NX4YhRQ9s34tIf1XYzJQ/Sz1T3pNT9sOxNaA5Rx28FbjaD59mc
	Ha1aDG5rMFV0ytMCgWBHZT9HcLymDGRaphGR1nGslkjzs7db10T6cGrreUdwv2jjz+EiPz
	KKz9TXuFyESHXpld/Wf5WttWFIZgHGY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J2XxWrGF;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773132954; a=rsa-sha256;
	cv=none;
	b=wysFjL6P99lX4g7gHRm7baMC5M6WqjFwNgIhIwXzTVW+bWckhGwC86Nb5yhZpgCp5sVgC+
	3NkCfFWbRirKAZ3dcXrTHSYjFPf86Yz2YtI/uqUsWvg5D3RyR2Mf11+ZmD3S9OCbUeXCNA
	gVN39bzy9GnVZKqT6e3ogYR8YpHcBI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1CCC4399C;
	Tue, 10 Mar 2026 08:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88950C19423;
	Tue, 10 Mar 2026 08:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773132952;
	bh=p0lnxSdaZCHufR9V6EmcR29pd6I8E03ng7d5cNxF3lU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J2XxWrGFl+fiGtnx6TMPB2GcmKQCFY6B255oBS8cNb9BvzrKD69bmmKb+b932lLD6
	 th5q8OtJDmzrcn44EyTuJlJk7sH7g1dzYdwxP2FkKz542dqrOQKKqMBY50A16E2QFL
	 yA/QR0AdjvxsTajvbDTTJhYUGItFdESedPtHMDPwFaUnlbX2QQV2xyVZUoLKZHCnLa
	 fzZnQz+PJWJEiZEPP48ah5l2F/do2GrCp5Vn4B9xzsa33bX08vZTIoLqWoKTrCbaw+
	 OQHyc9OPo26i1ZnQFrQ/ejbgG0qW9Mv8XlSkrUNauEHUuYks1gAfSlPa3ZocDdI5sM
	 dSbTThnHkqScA==
Date: Tue, 10 Mar 2026 08:55:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 7/9] mm/swapfile: Make folio_put_swap batchable
Message-ID: <078a2017-515c-4f27-853a-e64f4a816f35@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-8-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-8-dev.jain@arm.com>
X-Rspamd-Queue-Id: DAEAF40008
X-Stat-Signature: 9k344or3t9xpkythrasodru3wxunwmt8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773132953-232479
X-HE-Meta: U2FsdGVkX1/d+/C5HdhK2PdHqF/JkjoEAVhWVzqTTiO0Cl0qmZr7peldl1j4FtfAWL8FPNz+8A3BAqiyvdchXDP14taHyT21RYUqLVPkKDgYtq8xE2sGB9ZqXmLOZPLJOPhdRw+DDy3wsJvKFWgLcg2kFYONu1r1N0v7/+yko0EZBSPEbGn2FiDh5dTZdPZeztxMzw5O2kIVQUWUveS12Efu3/pi401OfqK/u2EIfpWP4xnJH0FJ4bLnzzsZsxKPaTIyxcYVqtCDhIL7YkfOERYJehjwjvVIjdpPb99rC3Tu6MomQnKZ/WeqigHBA97CReyrzzbqB/dVTkBZB0pWMqT1YswWQQoIOtf98SwYPxrac5cCsHFnimOkeWAhoexrHfLPel2P1RttSwXyH/KHGjEtmcCtts4Du5rkTf7kQ6x7iBSVcU8rgJh7JLvEqpJeGzxww4oBhKd4k9hK4zyRqq0vL9fBBIEXvs0jjW/kx0qW7TJmPIcjOjuyV5S5Pj3+0wVCVRf3mnC8XmjpYmuaGIJe12Ev/LkUY/WBcJ98Yec1gvdznsa7iaRsqdAHQHhNJ/P3zCHH6f1RaOqYDEaUv3Fyp/xkUDNzgFdE/7R4qw2WPgOO11fauMWs/ZtoOX2zbYTd+dE1DEqgrsNORgErA3x6z1nPjXHq4n4Bc08VLo8LTobrzLarqO9MB/KgDanV608iIdoOgLrDjZq2hX4w3fGhl8D3E7CpJEf7qBUiBnb9+lsmbGmQ4lMsTNAnvh7EhWuYQcSoujvdlwxx2QVFZz37KRNxkIbu1JUZNBWxydBlBt79CHf7jo5ZGqDR4xSUQsEkVDe3ac3oVFT9uSR/C5N5UFnafNlgcvE+bARGGcSg7k3PZDC+pLRXMMbJH96GMzlDaSoLpBGnWqWC7JYOhVxK69rwRUpY0wjafBXZODkAs+OuQptuxZNq6UQgyifWX3iHwAaWhTME0dK8LqY
 rcfr/xD5
 lgAbzuwMNyIZr7YC/ibRfJg1VTI+W3Pfq/OMS27Y+AFOhmj2LvbNIOyxFNtBKiDjAJS/A9c0V8clsug+eaDQMUgj1LTSS3XWFIzkUrgIfk7+vAJDVgxMZNsiKiSVTdQyrH0Xacg/qw3d4K+JZFc0ZDvn8AN4QE2do+mgITC/ygjArQCGvOE5f+WHKzA3r1A5PheJM1iRO2NuSm2tkH1VDCGKnR0hID3O46ffMs2zCkKq7EQMPzom3uUIQVzVi0wDwrEHUOYRaiWI1pF75rM3rW6sdMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:11PM +0530, Dev Jain wrote:
> Teach folio_put_swap to handle a batch of consecutive pages. Note that
> folio_put_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection, and explicitly pass subpage != NULL, and the number of
> pages required.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/memory.c   |  6 +++---
>  mm/rmap.c     |  4 ++--
>  mm/shmem.c    |  6 +++---
>  mm/swap.h     |  5 +++--
>  mm/swapfile.c | 13 +++++--------
>  5 files changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 768646c0b3b6a..8249a9b7083ab 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5002,7 +5002,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	if (unlikely(folio != swapcache)) {
>  		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>  		folio_add_lru_vma(folio, vma);
> -		folio_put_swap(swapcache, NULL);
> +		folio_put_swap(swapcache, folio_page(swapcache, 0), folio_nr_pages(swapcache));

Lord above HELPER. HELPER :) please.

I think in general, let's have the same refactoring in folio_put_swap() as I
suggested for folio_dup_swap().

I'm not sure where this hellish subpage interface came from, I mean there must
be a good reason but it seems kinda horrible.

>  	} else if (!folio_test_anon(folio)) {
>  		/*
>  		 * We currently only expect !anon folios that are fully
> @@ -5011,12 +5011,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
>  		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>  		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> -		folio_put_swap(folio, NULL);
> +		folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>  	} else {
>  		VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
>  		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
>  					 rmap_flags);
> -		folio_put_swap(folio, nr_pages == 1 ? page : NULL);
> +		folio_put_swap(folio, page, nr_pages);

I'm confused as to why some callers use folio_nr_pages() and others nr_pages...

>  	}
>
>  	VM_BUG_ON(!folio_test_anon(folio) ||
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f6d5b187cf09b..42f6b00cced01 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2293,7 +2293,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			 * so we'll not check/care.
>  			 */
>  			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
> -				folio_put_swap(folio, subpage);
> +				folio_put_swap(folio, subpage, 1);

Again, as with the folio_dup_swap() refactoring I suggested in previous patch,
something like folio_dup_swap_subpage() would be good here right?

Like folio_put_swap_subpage(folio, subpage)...


>  				set_pte_at(mm, address, pvmw.pte, pteval);
>  				goto walk_abort;
>  			}
> @@ -2301,7 +2301,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			/* See folio_try_share_anon_rmap(): clear PTE first. */
>  			if (anon_exclusive &&
>  			    folio_try_share_anon_rmap_pte(folio, subpage)) {
> -				folio_put_swap(folio, subpage);
> +				folio_put_swap(folio, subpage, 1);
>  				set_pte_at(mm, address, pvmw.pte, pteval);
>  				goto walk_abort;
>  			}
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 86ee34c9b40b3..d9d216ea28ecb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1716,7 +1716,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  		/* Swap entry might be erased by racing shmem_free_swap() */
>  		if (!error) {
>  			shmem_recalc_inode(inode, 0, -nr_pages);
> -			folio_put_swap(folio, NULL);
> +			folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>  		}
>
>  		/*
> @@ -2196,7 +2196,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>
>  	nr_pages = folio_nr_pages(folio);
>  	folio_wait_writeback(folio);
> -	folio_put_swap(folio, NULL);
> +	folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>  	swap_cache_del_folio(folio);
>  	/*
>  	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
> @@ -2426,7 +2426,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>  	if (sgp == SGP_WRITE)
>  		folio_mark_accessed(folio);
>
> -	folio_put_swap(folio, NULL);
> +	folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));

Again, for emphasis, please do not repeatedly open code the exact same thing all
over the place, 'don't repeat yourself' is a really good principle in
programming in general. Now if one of these callers gets updated and the others
not we're in a mess.

Abstract this please :)

>  	swap_cache_del_folio(folio);
>  	folio_mark_dirty(folio);
>  	put_swap_device(si);
> diff --git a/mm/swap.h b/mm/swap.h
> index d9cb58ebbddd1..73fd9faa67608 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -207,7 +207,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>   */
>  int folio_alloc_swap(struct folio *folio);
>  int folio_dup_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
> -void folio_put_swap(struct folio *folio, struct page *subpage);
> +void folio_put_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
>
>  /* For internal use */
>  extern void __swap_cluster_free_entries(struct swap_info_struct *si,
> @@ -396,7 +396,8 @@ static inline int folio_dup_swap(struct folio *folio, struct page *page,
>  	return -EINVAL;
>  }
>
> -static inline void folio_put_swap(struct folio *folio, struct page *page)
> +static inline void folio_put_swap(struct folio *folio, struct page *page,
> +				  unsigned int nr_pages)
>  {
>  }
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index eaf61ae6c3817..c66aa6d15d479 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1770,25 +1770,22 @@ int folio_dup_swap(struct folio *folio, struct page *subpage,
>  /**
>   * folio_put_swap() - Decrease swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded, must be in swap cache and locked.
> - * @subpage: if not NULL, only decrease the swap count of this subpage.
> + * @subpage: decrease the swap count of this subpage till nr_pages.

Again no nr_pages entry.

>   *
>   * This won't free the swap slots even if swap count drops to zero, they are
>   * still pinned by the swap cache. User may call folio_free_swap to free them.
>   * Context: Caller must ensure the folio is locked and in the swap cache.
>   */
> -void folio_put_swap(struct folio *folio, struct page *subpage)
> +void folio_put_swap(struct folio *folio, struct page *subpage,
> +		    unsigned int nr_pages)
>  {
>  	swp_entry_t entry = folio->swap;
> -	unsigned long nr_pages = folio_nr_pages(folio);
>  	struct swap_info_struct *si = __swap_entry_to_info(entry);
>
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>
> -	if (subpage) {
> -		entry.val += folio_page_idx(folio, subpage);
> -		nr_pages = 1;
> -	}
> +	entry.val += folio_page_idx(folio, subpage);
>
>  	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);

And yeah exact same comments re: refactoring as per folio_dup_swap().

>  }
> @@ -2334,7 +2331,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  		new_pte = pte_mkuffd_wp(new_pte);
>  setpte:
>  	set_pte_at(vma->vm_mm, addr, pte, new_pte);
> -	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
> +	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)), 1);
>  out:
>  	if (pte)
>  		pte_unmap_unlock(pte, ptl);
> --
> 2.34.1
>

Thanks, Lorenzo


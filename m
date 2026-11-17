Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2777606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eY5KBAs9
Received: by kanga.kvack.org (Postfix)
	id BE2AF6B05B0; Tue, 17 Nov 2026 08:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93576B05B4; Tue, 17 Nov 2026 08:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AEB6B05B5; Tue, 17 Nov 2026 08:54:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC526B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:54:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 379BC160439
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:54:06 +0000 (UTC)
X-FDA: 85444754892.15.B8B1A87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6BC09A000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:54:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eY5KBAs9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794923644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqe4yka6zmdqmbIPGKAWwRM6Ez2dyujJozYgr8mnWDQ=;
	b=Yh+1VC3tHjMqIOgt2A5vtHFWrkzLjm7Ej0++V2kGy2m76JxVOesCzkD4SJe+VRdnvvmuVd
	GAcxhaXGseIBwVKeNMcf98kNB39fB/5+lp3L3Hg9GKThIBxG/sMqoMMDaMihK8rlj666fr
	A4bl48b2TalGss54NqemD2PZ0PBfr+8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eY5KBAs9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794923644;
	b=EZIeTYeGJC80hnSqZSVCAXq9yj/Xq0fL6ouqeIxJKuo68C1E6EQjStW/ANZ4GwhEakQ8bZ
	xlwlhSFy7IBYDj9Slim/9gyd8B3/OFfjTkvDOZN86eFEPBo2OTXK92MAdjOOLDDhiXWXmY
	O1tWEPJguCrwUlDRQ7dWE7uhDsOkuOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B6A4419C3;
	Tue, 17 Nov 2026 13:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7171B1F000C5;
	Tue, 17 Nov 2026 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794923643;
	bh=lqe4yka6zmdqmbIPGKAWwRM6Ez2dyujJozYgr8mnWDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eY5KBAs9g2p2pyhRfMC05yNEB9i4QMP4RZ52xLmzkFHeic3SQHVGfC5k81lP1elcJ
	 a2h9lSbPMCS6sghJIV0xdbvKooQZCxU7DIDnvdF4bBw4Hsm7urWSfMpG5SJCXKGP+U
	 5zR76H1WXzEl8Y7Ln89P1XbU9TXQNPgh9QaNgzmvEd/wix1cAGYXvbcWVeN9vfnbVm
	 h6WyByJ5dOekMOUi7TVfroPikXqhM9RkFsR05PShSryOwD+/xDjDV/VzXr5qNniPZC
	 te63dzrEOf2X0JqI6x/hPb4q+kd7LOpl+ut+KI03NfECMo6ekwyXBjfh7leCxEMpB4
	 6ty/RgWJtd3PA==
Date: Tue, 17 Nov 2026 13:53:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: use memory barriers for non PMD-sized folios to
 sync
Message-ID: <avxb050XeV895evT@gremlin>
References: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BC09A000D
X-Stat-Signature: dx4s9x791e4yrmhdwq8yh1gppnkmkncd
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794923644-999701
X-HE-Meta: U2FsdGVkX18Fdka77RUaZmidUy6K1GV2U1iud7BQgzXmGxzO1L2DCkF9biqaH5QaeQ9Rt7at9SqQGupdkFwtiGqt/Mhy1R0m5p8ikgfnkw85tgFqrNTJET8132+gZjkhxTDnQ3v04ZBuTu8MZFaUCYjfVvT9BJuc+sBr4lcQk+I8qzhS/vaiAINgVFcs8r6fdukHJxBwWBKwA9RnkMrgj2RsAl9e8oPajKYfEzneYqZMgMqRf16hgvuoWIMDdnWZLlzuzkX60e2GtLOd7bpxBR9EBDM0zmZC4vGI0+nQRnxi4hVRiXk5ODd2v/jreFtvwejIGcqSnFtuQ+vag0IKDJKdjf1aDq87ZVmx+Mj19hYvpKvcQXQ1ZHuvuOPbejix+hTj/0fgXlvekGvbDBCC6ovRvHXyG3mExN87+U1T1E5EKiwKytmGiGIcGGIZFuPirMXQfFaacQwIE9tmJRCWREYPWyRDs1H84b8C1U81o5yzRgzPCRsfeI6C+IXvR0Jh17xQ8N2tPPN/Pr7jmPkpNjucOEgdQQh8NkMQxWeHJGxxC7pANTXDE+ocSosZdPDZ/w4qamh1O8PlFgyhcukTsvdQrj708XTi7d/uG3PSmigfnRNc8Sq/9CqovOPGpy4Rk/2D0Qogj/yuRJNAcCn+Xx46Fyt1QZrA0FD+JtpAuGzyu4XJQpLN6YIznh1OgrrimmpTm4vnnqLoSoB3svHnls179Qh+G++MGSdoiq6kSoMERXgLeLwac7rBXVAOVWUc3qwBeoPyeykM+ow1q0xBx/J5LRd5tFTRnxrBOO93tTaWQ4vdlOv2BcQ37TyihdngHsh40viUtrZgKwxCmmWXW11ZFjU8cj+nMZSb4RpVAHGKaQV02xuYwwU1VLdtHlVeASd7Afd0j97Jm235oJKEoRbFO3dD2MBk68QbWfpkKcrujc5tpBH4L2jedvb0WCkiN2w8Ar/BMoocdEpbMM0
 GxIx4GQd
 ebtihKM44mTnGeB6WzagYxu+tLVVyZ01h6044zEuFsEanYokJWyMSJMctGdqejnAy/sMH81y2jBxENxnzM899pjVtBhHUpJqe8gFMaD2e+otkJ3lcAVRt7QKAWW0mBaYKFiauPWQ0609ZGjFADr/RJw3qpSFr7I7wh6qQ0G2AdKpUJM/XqWZdkHHxWDyXUAaNh6WEUSodA9d0XjRow+kaJsIYU8bqHyVZlgzOFmT1PS3Unqg8SVx4kofMYXmw5oUe0JN4tAbPu2h87EZDUq1dr+490GjWOIHZ2BbK7m22pXWOAa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 03:00:30PM +0800, Baolin Wang wrote:
> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
> PMD is found while unmapping a folio.
>
> However, for non PMD-sized folios, the only PMD clear that can race with
> this unmap is PTE table reclaim, which clears the PMD only after the rmaps
> for the table have been removed. This is plain message passing, and taking
> the PMD lock is more than needed, like I did in the previous patch[1].

But it doesn't automatically mean that you _have_ to use fragile memory
barriers?

Correctness and robustness in the future are important right? You need to
justify this properly.

>
> Without barriers, the walker can observe the cleared PMD but a stale
> mapcount on weakly ordered architectures:

You mean without the PMD lock?

>
> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
> ================================    ================================
> folio_lock()
>                                     lock(ptl)
>                                     clear PTEs
>                                     remove rmaps   /* W mapcount */
> [mapcount load satisfied early,
>  folio still mapped]
>                                     pmd_clear()    /* W pmd */
>                                     unlock(ptl)
> pmdp_get_lockless() -> none         /* R pmd */
> skip the PMD
> folio_mapped() -> true              /* R mapcount, stale */
> unmapping assumed to have failed
>
> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
> PMD read forbids this outcome:
>
> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
> ================================    ================================
>                                     remove rmaps   /* W mapcount */
>                                     smp_wmb()
>                                     pmd_clear()    /* W pmd */
> pmdp_get_lockless() -> none         /* R pmd */
> smp_rmb()
> folio_mapped()                      /* R mapcount */
>
> If R pmd observes W pmd, R mapcount must observe W mapcount, so
> folio_mapped() no longer reports the removed mappings.

This is insufficient IMO, you need to explain firstly why acquire/release isn't
feasible (presumably because you can't synchronise the clear properly that way).

>
> Pass a 'folio' parameter to sync_with_folio_pmd_zap(), allowing us to
> skip those pfn walkers: pfn_mkclean_range and mapping_wrprotect_range,
> which don't need synchronization.
>
> Similarly, skip sync for page_mapped_in_vma() since the subsequent
> operations don't check the folio's mapcount.
>
> No changes for PMD-sized folios unmapping.
>
> [1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

This replaces an easy-to-reason about lock with a very-hard-to-reason about
memory barriers that are fragile and could easily break resulting in subtle data
race bugs.

And you don't seem to have provided any perf numbers or anything to justify it
unless I'm missing something?

I'm a little uneasy about it honestly.

> ---
> Changes from v1:
>  - Pass in a folio for sync_with_folio_pmd_zap(), per David.
> ---
>  include/linux/rmap.h |  2 ++
>  mm/internal.h        | 26 ++++++++++++++++++++++----
>  mm/memory.c          | 12 ++++++++++--
>  mm/page_vma_mapped.c |  4 ++--
>  4 files changed, 36 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 74cca0e3c726..62e7341de179 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -862,6 +862,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>  #define PVMW_PGTABLE_CROSSED	(1 << 16)
>
>  struct page_vma_mapped_walk {
> +	struct folio *folio;
>  	unsigned long pfn;
>  	unsigned long nr_pages;
>  	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
> @@ -876,6 +877,7 @@ struct page_vma_mapped_walk {
>
>  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>  	struct page_vma_mapped_walk name = {				\
> +		.folio = _folio,					\
>  		.pfn = folio_pfn(_folio),				\
>  		.nr_pages = folio_nr_pages(_folio),			\
>  		.pgoff = folio_pgoff(_folio),				\
> diff --git a/mm/internal.h b/mm/internal.h
> index cd3675c044e0..ad7e051cb198 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>   * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>   * @mm: The mm_struct.
>   * @pmdp: Pointer to the pmd that was found to be pmd_none().
> + * @folio: The folio being zapped.
>   *
>   * When we find a pmd_none() while unmapping a folio without holding the PTL,
>   * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
> @@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>   * against later mapcount reads. Skipping the PMD without synchronization
>   * could make folio unmapping code assume that unmapping failed.
>   *
> - * Wait for concurrent zapping to complete by grabbing the PTL.
> + * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
> + * folios, otherwise smp_rmb() is sufficient.
>   */
> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm,
> +		pmd_t *pmdp, struct folio *folio)
>  {
> -	spinlock_t *ptl = pmd_lock(mm, pmdp);
> +	if (folio_test_pmd_mappable(folio)) {
> +		spinlock_t *ptl = pmd_lock(mm, pmdp);
>
> -	spin_unlock(ptl);
> +		spin_unlock(ptl);
> +		return;
> +	}
> +
> +	/*
> +	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
> +	 * may clear the PMD after the rmaps for the table have been removed,
> +	 * but later mapcount reads could still be observed before the PMD
> +	 * read, making the folio appear to be still mapped after unmapping.
> +	 * Order the PMD read before later mapcount reads, so that observing
> +	 * the cleared PMD implies observing the rmap removals.
> +	 *

This also makes me very uneasy, complicated reasoning like this is asking for it
to break.

Also could this be smaller and clearer?

> +	 * Pairs with smp_wmb() in zap_pte_range().
> +	 */
> +	smp_rmb();
>  }
>
>  struct zap_details;
> diff --git a/mm/memory.c b/mm/memory.c
> index 529a9189e426..dcf205175f71 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2054,8 +2054,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	 * Clear the PMD after the rmaps for the table have been removed, in case
>  	 * an incorrect mapcount is observed after unmapping the folio.
>  	 */
> -	if (can_reclaim_pt && direct_reclaim && addr == end)
> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
> +		/*
> +		 * rmap changes need to be observed before page tables get zapped.
> +		 *
> +		 * Pairs with smp_rmb() in sync_with_folio_pmd_zap().
> +		 */
> +		smp_wmb();
>  		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
> +	}
>  	pte_unmap_unlock(start_pte, ptl);
>
>  	/*
> @@ -2110,7 +2117,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  			/* fall through */
>  		} else if (pmd_none(*pmd)) {
>  			if (details && details->single_folio)
> -				sync_with_folio_pmd_zap(tlb->mm, pmd);
> +				sync_with_folio_pmd_zap(tlb->mm, pmd,
> +							details->single_folio);
>  			addr = next;
>  			continue;
>  		}
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a931243ca42b..9b72ac408c70 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -294,8 +294,8 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			spin_unlock(pvmw->ptl);
>  			pvmw->ptl = NULL;
>  		} else if (!pmd_present(pmde)) {
> -			if (pvmw->flags & PVMW_SYNC)
> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +			if ((pvmw->flags & PVMW_SYNC) && pvmw->folio)
> +				sync_with_folio_pmd_zap(mm, pvmw->pmd, pvmw->folio);
>
>  			goto next_pmd;
>  		}
> --
> 2.47.3
>

--
Cheers, Lorenzo


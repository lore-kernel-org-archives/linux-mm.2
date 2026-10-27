Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA076606A328
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eofv6ai2
Received: by kanga.kvack.org (Postfix)
	id E14836B05C2; Tue, 27 Oct 2026 05:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB916B05CC; Tue, 27 Oct 2026 05:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAC76B05CD; Tue, 27 Oct 2026 05:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB416B05C2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:00:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D76DA09AE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:00:14 +0000 (UTC)
X-FDA: 85367809548.23.ABB139E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 38FFF40004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:00:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eofv6ai2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8DlDJAvruPXNDfmMPYKW0Qy/J9TLOLxMKQ05HOGHqo=;
	b=sgg3x1tI/cyT4pim77siC3tYCsV/Xe6DbTUKkSEGlaL+X+Ub7BI3jVMYxa0r4xubyQy7tP
	YBvdsHdljauf+fd7TobUzYUuyyxcAnZrDF0MvDya368EDFQrgrk8pNKyWvZ1GoiGBOIMhf
	VxtpUZM+MSqY+1unfEEnGfQly0ycp3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091612;
	b=mI7aadLM4kLd99ZXAN0xYAOUPCPwQ2/pj4btucgzfFnN5Y2BapYrRjK7jwAkCcBQVM0p/S
	PqhAvmXOnBUlxRXBjWve11F1xiUVTj1NTGFrNqkVKG0n7lfLN0BNe1VQt2RRmWXvSOrqZH
	fhC2BDasdSck8TFPfI39GWRK2THkKPg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eofv6ai2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B5714090B;
	Tue, 27 Oct 2026 09:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D5D1F01825;
	Tue, 27 Oct 2026 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091611;
	bh=E8DlDJAvruPXNDfmMPYKW0Qy/J9TLOLxMKQ05HOGHqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eofv6ai2VlFZ8W4tIY/vNBiuVBUXPcTgMmFlhTz++Gtx+YFTV6nXclk9sYPKchSic
	 NnwCSuXLwipXbP0A+gAen+yUvSFRRwku8r2LOTcle3gdexi7JAQOHJO3Pa2JDXz1KI
	 LGIHOJCN2cbAI50O1eB9FzobLKVEJEge4ERPexm2I7ferf/krmSGbk0tBGwD1OVg+s
	 qXtdwRA7uNBSDvyALeu8BaBIcs97X3yzNPUv8nx56TU/JOMPFIz10OeHdCBB4YXIPo
	 dberrS78OpiPHfGn2A4cnK5CbaesQ22Q7bU2RmgCARFtkNMv5VUOXN8EzdQZ2A3LGb
	 zLD2vLmc33wgw==
Message-ID: <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
Date: Tue, 27 Oct 2026 10:00:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38FFF40004
X-Stat-Signature: 1e14pce5y18mwerpdgigjx3kk3pfck7o
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793091612-955794
X-HE-Meta: U2FsdGVkX18wLXDwtvPYGFncFTuDyP3tvwO82E66GvqqDiFm3UlvBIFuR/SABdQXRZJiCuqoHYlCrpLHm3h+5dlHka1JEhbV0fS1KnflJBt9go8gsLkhd2lb6K6ODz4pvHlhTR37SgjGYcVQBXrqjJ9Y2QNlQYdmRL2rlTiV7khJMmjqwnIJLibSETJjE+9E/otKAWe+nepHNa2nQIB3RP4PzDlxbqEGY5al5IrjgHw3kG5WfLstTr/mR/GAkfZigxi8CNBUNNF6SNIpt22gy0N/ZsEHL9T5LyPfoDh4rEtWSUh8u04oeMpPPaNN6iPzqa9EMBiR22k4hx2s7IPDrwaFACNYNYV2ET1mr/OC9rgE1WSJnsldqJZXCtEr9/uYuBy8s8GGnodz9g6KxXTMiNvsLEdNDFHxtLO7vNDf2ShRlNRdCgKfTgVqbS5bPmgzKXAOZuME0Zg5Z3UzjIgwufP8yR0dSkZCErF4RHD4t/J8/cLATxLA46lS6SU1DzPcMRS1dXQ66wzG4oDKqdEVIbMhkP920ARS38eNrXq2kzZY6yFVoCcB4imDdOIcPH7rOskJP5WQcUBpKNe8ULac7vCFwio7Nb4RZWT52jHCvttHASODyIih9y4hmM5kShATZfx6gCLiJfqX+SHGCnQrkQSPpOsk0mJRBY/cbFG7dUdehQLYZDq/TvtcgF0zQtv5IvDM0SnUJ0rUBmtQfUi0fVvnJ6mtzQH6VmlfsP+ZSi944MMjmPtpO9XFNul5J7rPw0ToRj48ATx5ntu8gjpu/Qz9BVNeOa+AwoV/9UjqnlEB8RBx85m8NV00d6sOXfXrZ2ZmviO0UjnvByFITVnIrdQURzNGqGA0l39ocpjQ41feu4AuH4oovTQHnvTnnBffDGK8m+tPPE98UxMh50NSnOp9RC5vJb4vw4hDio1Ph0+TIiSoLnQqM6fhQWnl/RD5UYzXU37Xe1CAZle8wvG
 mg2VVPBH
 eEK9WkW3Z02tOwYP26U8CUsmSRw4lLwR/xHVkKBaK/jYM9g7DNPKLUdU4iIXP5AluPUNCdz+KR4CRF7r688H3dHXGdKciK8VFwFqNlKMX39nXdnLJqRyB72rZUU67BhvIEMyfzb4XwqXlo0BAqMo9fxJSybj+44HA6YCTgYxMs2txTLQekbd0NEkJI+nSYLWaKZl2yPnIJLfo5eRS0lPJN+VEVI4WjvQixuSl1rLe8mGfrz7F6CN3ZIEjPWu+UtFgyVMJqkTfUtZJo7XR2TT8AlLdX3f9f2kwoX6QWLG3stSQoDFQXLSEau1KBgKj6U0OPljI5H9781mPAB9cuSr0HwMe8LHEq4iHVcuxWnX4sgEXijnvWDPkiNOXyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:19, Baolin Wang wrote:
> Ayush reported an issue that shmem/tmpfs folios are still mapped when
> truncating them on production:
> "
> BUG: Bad page cache in process ...  pfn:...
> page dumped because: still mapped when deleted
> "
> 
> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
> branch, and I got the following crash info. From the dump message, we can
> see that truncate_inode_folio() is really trying to remove mapped folios,
> which is incorrect.
> 
> "
> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
> index:0x3880 pfn:0x191647
> [  189.171995] memcg:ffff0000cc073d40
> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
> .......
> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
> [  189.172026] ------------[ cut here ]------------
> [  189.172027] kernel BUG at mm/filemap.c:155!
> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> .......
> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
> 7.3.0-rc4+ #277 PREEMPT(lazy)
> .......
> [  189.183986] Call trace:
> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
> [  189.184391]  __filemap_remove_folio+0x34/0x160
> [  189.184633]  filemap_remove_folio+0x4c/0xb0
> [  189.184859]  truncate_inode_folio+0x34/0x58
> [  189.185087]  shmem_undo_range+0x220/0x658
> [  189.185308]  shmem_fallocate+0x2f0/0x470
> [  189.185527]  vfs_fallocate+0x128/0x328
> ......
> [  189.187078]  el0t_64_sync+0x184/0x188
> "
> 
> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
> MADV_DONTNEED synchronously releases the pagetable page before calling
> tlb_flush_rmaps(), this could cause another thread's truncation to skip
> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
> as non-zero. A possible race scenario is as follows:
> 
> CPU 0                           CPU 1
> shmem_fallocate                 madvise_dontneed_single_vma
>   unmap_mapping_range            .......
>   ......
>   (filemap_map_pages() remap folios)
> 				  zap_pte_range
>   truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>     unmap_mapping_folio
>     ......
>       zap_pmd_range (saw pmd none, skip)
> 
>   filemap_remove_folio
>     BUG_ON(folio_mapped)
>                                     tlb_flush_rmaps(remove rmaps)
> 
> To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
> without holding the PTL, the folio's mappings are guaranteed to have been
> removed via tlb_flush_rmaps().
> 
> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
> Reported-by: Ayush Ranjan <ayushr@modal.com>
> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v4:
>  - Put the pmd_none() check in the 'else if' branch (per David).
> Changes from v3:
>  - Collect review tags from Qi, Pedro and Lorenzo. Thanks.
>  - Update the related comments per Lorenzo.
> Changes from v2:
>  - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
> Changes from v1:
>  - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
> ---
>  mm/internal.h | 10 ++++++----
>  mm/memory.c   | 30 +++++++++++++++---------------
>  2 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index b1b0f29d2216..ffb8eaec90e3 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>  
>  /**
> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>   * @mm: The mm_struct.
>   * @pmdp: Pointer to the pmd that was found to be pmd_none().
>   *
>   * When we find a pmd_none() while unmapping a folio without holding the PTL,
> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
> - * indicate that it's unmapped. Skipping the PMD without synchronization could
> - * make folio unmapping code assume that unmapping failed.
> + * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
> + * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
> + * for the table have been removed, but nothing orders the pmd_none() read
> + * against later mapcount reads. Skipping the PMD without synchronization
> + * could make folio unmapping code assume that unmapping failed.
>   *
>   * Wait for concurrent zapping to complete by grabbing the PTL.
>   */
> diff --git a/mm/memory.c b/mm/memory.c
> index e911e63ba1ed..d9c54549b85b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  		}
>  	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>  
> +	add_mm_rss_vec(mm, rss);
> +	lazy_mmu_mode_disable();
> +
> +	/* Do the actual TLB flush before dropping ptl */
> +	if (force_flush) {
> +		tlb_flush_mmu_tlbonly(tlb);
> +		tlb_flush_rmaps(tlb, vma);
> +	}
> +
>  	/*
>  	 * Fast path: try to hold the pmd lock and unmap the PTE page.
>  	 *
> @@ -2043,18 +2052,12 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	 * to hold the pmd lock failed, then we need to recheck all pte entries
>  	 * to ensure they are still none, thereby preventing the pte entries
>  	 * from being repopulated by another thread.
> +	 *
> +	 * Clear the PMD after the rmaps for the table have been removed, in case
> +	 * an incorrect mapcount is observed after unmapping the folio.
>  	 */
>  	if (can_reclaim_pt && direct_reclaim && addr == end)
>  		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
> -
> -	add_mm_rss_vec(mm, rss);
> -	lazy_mmu_mode_disable();
> -
> -	/* Do the actual TLB flush before dropping ptl */
> -	if (force_flush) {
> -		tlb_flush_mmu_tlbonly(tlb);
> -		tlb_flush_rmaps(tlb, vma);
> -	}
>  	pte_unmap_unlock(start_pte, ptl);
>  
>  	/*
> @@ -2102,12 +2105,9 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  				continue;
>  			}
>  			/* fall through */
> -		} else if (details && details->single_folio &&
> -			   folio_test_pmd_mappable(details->single_folio) &&
> -			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
> -			sync_with_folio_pmd_zap(tlb->mm, pmd);
> -		}
> -		if (pmd_none(*pmd)) {
> +		} else if (pmd_none(*pmd)) {
> +			if (details && details->single_folio)
> +				sync_with_folio_pmd_zap(tlb->mm, pmd);
>  			addr = next;
>  			continue;
>  		}



} else if (pmd_none(*pmd) && details && details->single_folio)) {
	sync_with_folio_pmd_zap(tlb->mm, pmd);
}

if (pmd_none(*pmd) {
	addr = next;
	continue;
}


Minimal change required, no?

-- 
Cheers,

David


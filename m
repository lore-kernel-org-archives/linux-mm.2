Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8C2C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C8C6B00DE; Tue,  4 Aug 2026 09:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554296B00DF; Tue,  4 Aug 2026 09:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491E16B00E0; Tue,  4 Aug 2026 09:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1501F6B00DE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:49:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C306A0422
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:22:43 +0000 (UTC)
X-FDA: 85063349406.01.DEA958A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B854920010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:22:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mETS7jtQ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785842561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O04AjETwdkKDFMoFDRH7HNAUs5os4iVo89vC02nF1dA=;
	b=MAxFnw/g5FEcP5RRlgBBMTXt549IVq5seUnVh+Ps25MfB26LIzbiNxPoabTVieqLkTt/RL
	0FkBMnHe+pUC/TTd8upHyWDTSpfUf7zsLL7oDRjJ4o1m36ogz1R+aYRBD8SuKRTsHKXfGt
	bLvLF5BjnzeuA0nS8o62f0JMWKR0ltA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mETS7jtQ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785842561;
	b=yah9qBXx2M55h1ZUZ4HwIYW2LAEi36tdXSkyDvYc/gOs6ewUiDoLyeJurm8956p1uzrzGd
	3rBVwZEy9q7Xu+N+az3Mcq2+PfnFno4E4u6vPBnC6LzqxWiPlYWE8Cx2ldav03OPhkBxjk
	hTn13L0tCWpo6jGm5LI90Pmpx7pvN7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE257433CB;
	Tue,  4 Aug 2026 11:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355F71F000E9;
	Tue,  4 Aug 2026 11:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785842560;
	bh=O04AjETwdkKDFMoFDRH7HNAUs5os4iVo89vC02nF1dA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mETS7jtQ9xPeY0vCfNmg+ddX8fuc7SUbBvCjaH6OSIVCtgc43e2hUnlX4GQ8hVnLp
	 6wlmwsuR15aWXkBkD3bqUj/JLgmtSQUiuVYLRHObbnTQtwRFxGwcIPHO6upxsRhNCF
	 jUEuDv791XD4yslZfyX2uYtLSp1XjxI5cxjjPoKEzOuV65mhd8zYxK82NG56Fm7N89
	 pbF71py3im6THBC+vOhEIjMCGSS1Bdv9a3qnU8xi2XXGG37cqRPZrOVpW7d9Jaxiaw
	 fCO4hp38sQlygOaBiDhDSQ8C1Ut9rDn89dHfwdAGdMgsWlhRkekX4aGc5i1XCMjSPs
	 4TId4Keo909Jw==
Date: Tue, 4 Aug 2026 12:22:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm: constify the pte_offset_map_ro_nolock()
 return value
Message-ID: <anHJ48Glq8EdHatd@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-7-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-7-pfalcato@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B854920010
X-Stat-Signature: ziq66s317tc363u89mwsfwysr64ec8ik
X-HE-Tag: 1785842561-14824
X-HE-Meta: U2FsdGVkX1+0fdkRAJWtzi+CvBjGJhggtNI4jWqe/LVHLw73PTcx3QENhlLv5hj58/mGu7SV9Ed5LKJH5zUsVuj9m977xH4Ep46uwGwlD4PU0NbJQKKFSE63n1CQk8+ZPRSpk/ne0Na5WTREq0WCwfauNIER02vF/kyObJopbIML7yTfpFJvMz0fCrtV8RiqDMx5netZsKpWf7EW602B7tvS8SUCu0VI+qroOoF24xM/AODVOHZnklBIDuwIau8K5j/Y7D9mW1wlOqtvdElGtlF/c7qcbavRkIwuQMMFAyvHUPTgPhFFQP2cQXqMYVa++cHdWYdWBajZ9wepL4FPAkkaCcjeKH1hn02dxXXbTC935Tjyf+Gjdn+UPUHBsF2VKOHlxqB5Vgj+1Zml/nn57GEOmf+4RkQN1QEhUujNf9sz1PJ3EoboF58QWWMDfAdZOpXQQsxDO6tXmSsnc6uxLENeJKpFr6C6IFoA0qTy+WT3KAPRNTDbVS/sjrWRuxppwquQBCzH7QA0eAm6lhwEVVcqVyK/+5OIT0rjfbjFC0d/C0Fyq2srLsFdX7uq7UpYs7+fieQltVC7NkVRp1deivM3nBtvRfxmwCGaqIVisGc5xkAmQOjDPE6V9kfww57PQXZXoXpKJvjXY19MKgp9rRem9vGAmz4C68TRp9iSzMv8sEpCHMSNBpQK/bo2PTBmDXLKi1E4XXWOJLbWsCSGgA+/Ftm/tVJti2M67udtiky83cGxEQwrH0bcVfBplSD3KrGImMSlQNhE1L9r/XrO76bb1wobdMqIv6oA7oxSUmE2qWSTEkJDymwN6ew8VHImAZAUq2T9W60AoZAWGkm7bx6LqWfEIVzYV0Bu/zBfvETwVuSVqeAYbu/Cv3PeReqDSw/ctT8HPXDSO/XB2tRmWiMOTCx0ShxnFQBOoP+n1r7e7vEwG3cjOsY6DFQIyM545XaTY9mDYRf3MDOpUMH
 snu/sQ9s
 sR7gj8MPNOg84U321M9agscBBBzCyALwNKHZ5yPRM1OlZsKddPACtjwPxkZ1NUGqf9Y3/3PDDgPaBaPUxIziuoest+tNDtr8TvYLLln1NPpVER/mwxp3LpvNgtFeD/EtYVYTU8ZrEObHw6qPcTNrK3QiR4AzOse1cql6TeSk6qd5WzVz2s1IH/4tRCjGFcPVEjfA3JFrKTrUJzeranusfL/otIshsTEz3QIIBFHUep7Xt3oTY2Bgq/Bz1G0JxyfciMLGH25fTvX3xny8UiJO0RepxJZcZo2qo7fRqnqqg5Ou3d44/1qK6gUyzDHWzEw/Dl4DqdmFXnojF9OggPkIxY2kc16wJwrDusii40jaMMbZ/epV6iBth2lIqtqMJLYkF4o/DgPY72sSRQ8RkPHZNy5tUZ+ox+Hbwcju8hUrTCHPUmOrSwYlzBM7RdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:44:00PM +0100, Pedro Falcato wrote:
> Constify the pte_t * retval from pte_offset_map_ro_nolock(), for which it is
> already pledged that accesses must be read-only. With it, convert the three
> treewide users to use const pte_t *.
>
> khugepaged passes the result right down to fault code (do_swap_page()). This
> leads to a complicated set of conditions that, in order to be correct, must
> not install anything into *vmf->pte. This is not trivial to work around in
> fault code, and as such just trivially cast to non-const pte_t* in the
> meantime.
>
> The other users are far more trivial and the conversion is equally
> trivially simple.

Ah finally more words! :)

>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

With comment updated as below and nits addressed, LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/powerpc/mm/pgtable.c | 2 +-
>  include/linux/mm.h        | 4 ++--
>  include/linux/pgtable.h   | 2 +-
>  mm/filemap.c              | 2 +-
>  mm/khugepaged.c           | 2 +-
>  mm/pgtable-generic.c      | 4 ++--
>  6 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
> index a9be337be3e4..e29db41b6043 100644
> --- a/arch/powerpc/mm/pgtable.c
> +++ b/arch/powerpc/mm/pgtable.c
> @@ -390,7 +390,7 @@ void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
>  	p4d_t *p4d;
>  	pud_t *pud;
>  	pmd_t *pmd;
> -	pte_t *pte;
> +	const pte_t *pte;
>  	spinlock_t *ptl;
>
>  	if (mm == &init_mm)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b..acf5a5e31d34 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3885,8 +3885,8 @@ static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
>  pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
>  			   unsigned long addr, spinlock_t **ptlp);
>
> -pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> -				unsigned long addr, spinlock_t **ptlp);
> +const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> +				      unsigned long addr, spinlock_t **ptlp);
>  pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
>  				unsigned long addr, pmd_t *pmdvalp,
>  				spinlock_t **ptlp);
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index dc418553e57a..dd51e722c535 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -112,7 +112,7 @@ static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
>  {
>  	return pte_offset_kernel(pmd, address);
>  }
> -static inline void pte_unmap(pte_t *pte)
> +static inline void pte_unmap(const pte_t *pte)

I was going to question this based on whether the contract holds for
CONFIG_HIGHPTE but actually:

#define pte_unmap(pte)	do {	\
	kunmap_local((pte));	\
	rcu_read_unlock();	\
} while (0)

#define kunmap_local(__addr)					\
do {								\
	BUILD_BUG_ON(__same_type((__addr), struct page *));	\
	__kunmap_local(__addr);					\
} while (0)

static inline void __kunmap_local(const void *vaddr) <-- const!
{
	kunmap_local_indexed(vaddr);
}

So nice (CONFIG_HIGHPTE is going to go away at some point though, right? I
hope... :)


>  {
>  	rcu_read_unlock();
>  }
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6afec636881f..af5d3fcd1b05 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3490,7 +3490,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	vm_fault_t ret = 0;
> -	pte_t *ptep;
> +	const pte_t *ptep;
>
>  	/*
>  	 * We might have COW'ed a pagecache folio and might now have an mlocked
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b237f6e7662a..09efac93a8c6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1170,7 +1170,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  			 * Here the ptl is only used to check pte_same() in
>  			 * do_swap_page(), so readonly version is enough.
>  			 */
> -			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
> +			pte = (pte_t *) pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);

Hmm yeah this is nasty, but you explain why in the commit message. Could you
extend the comment to explain it?

>  			if (!pte) {
>  				mmap_read_unlock(mm);
>  				result = SCAN_NO_PTE_TABLE;
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..2cfc6e608ef4 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -308,8 +308,8 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>  	return NULL;
>  }
>
> -pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> -				unsigned long addr, spinlock_t **ptlp)
> +const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,

Can pmd be const too?

> +				      unsigned long addr, spinlock_t **ptlp)
>  {
>  	pmd_t pmdval;
>  	pte_t *pte;
> --
> 2.55.0
>

--
Cheers, Lorenzo


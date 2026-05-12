Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6797CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2E86B009D; Tue, 12 May 2026 12:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299F46B009F; Tue, 12 May 2026 12:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6BF6B00A0; Tue, 12 May 2026 12:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEDE6B009D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:45:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D17A81A055B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:45:20 +0000 (UTC)
X-FDA: 84759343200.10.F6EF094
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0D7A2180018
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:45:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Blgoe6k7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZe4QXCOvLRWttGDV2hAMg/bJ57YbA5OOTt1aVKEKuE=;
	b=0nMiMUWkcmrydTRUaXeaJlHLkoEyGg/cRtDVMVklHE6ELoaKt/H+Efz9wf3h2+USbEkFCU
	8D0nZKTVMI/p3yN/082rKjrCE7MinsekFZMpNqvLpo/QZ+l9lH5Lfl9yUVhCbdaFbYaG4q
	KiNj3pqCVpwIQM0O8l+ZDbIjcrsakqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604319; a=rsa-sha256;
	cv=none;
	b=R407ndbDSsCJEc1z52t3AoPkyosE2H8TP1s/C2Lw96Kxf2vUJdk2KujM9Egoq4Dafd6MGl
	2dEyGQ5aEAGOMxQcA59zvAc/S0NWWqZImxJATJ2jUZkNDCMTQ8sebHOxFjsJKOUkp/mtPE
	ZWP8ePc7BKXZ7bp7qFOsxfi2Qv4UblI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Blgoe6k7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D07661119;
	Tue, 12 May 2026 16:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425B2C2BCFA;
	Tue, 12 May 2026 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604318;
	bh=nWqCxq7T/dq+SPOZyMunKEPynEE38sPxedaX27vX4VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Blgoe6k7d6myKJ/eH1T8UqBraO0ckIsqoEg2Qk8eM/IQFubB+3yd7WkJNTMp89VYI
	 mnGIgwWAreQfVWT0QFvY6K/HIgi8FBPyP07jDM78j2Y6gSd4eqlQ1conhfbWLsf/QM
	 /+6VaA8siC/qB98opCiUfvurPjLq6aFkD85qoTmE1FafYVfG3pzSsQ0LL1OCZexr2o
	 w5jaXHCmcpAnH4LRkcnYoWz4ECcXQXkSJW1I++LK1DLwH3OWSpj1NZziysd1ZXpATI
	 uEbg2+M/OvMSFqaQROQ9I2eXzb7p3ZEJ6LFreAwy0++fDCiTcNSO3spfiKSb9q6dbM
	 S3sEZOlzukBBA==
Date: Tue, 12 May 2026 19:45:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 05/14] mm: add MM_CP_UFFD_RWP change_protection() flag
Message-ID: <agNZE49m8Pkn8CeW@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <ff3420fdd75f58d56827ff3d2eaffc0d74154627.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff3420fdd75f58d56827ff3d2eaffc0d74154627.1778254670.git.kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D7A2180018
X-Rspamd-Server: rspam04
X-Stat-Signature: p17i49dpo48ojfe1b47tzz1yupbfitw5
X-HE-Tag: 1778604318-420330
X-HE-Meta: U2FsdGVkX1+I49txo/LlW+AzT8qNvSCHomvzQeM58b3PNNtQ8yBDQoxs+7HESixUa5B66CoPy6Ak9s7fxSD5dkEsJzYq5vrLGV1tdi5FcB8/79wAg+yNMst/Bv3QMgPf9lBZs14aMyG97Vb9vUKjXYoF3Do8WptszMGSXfsQNUa7AtlqJVOpD/PIsbG4Ioepp03uv1fSsvAr5N6cAguJOinSjnK0SILlc9rCRRjKCz/Fney8UIQXcwGYAyo0vSFK1KSn0s9iOcmw62BN/kELvpmvbIhxTomMTdfGCvYbYnqtRNFhLMiyLgoFTcAV0GUYIB/ysKbG9Y+29IA1WrpsptJOuk4mTHOotusK2svUrWhMDjDoBJkKQAkbex6JV6B6tnnZaoHIl8bSsI9kxoEJXK8bPIBMyaRqkdN183GYmnYnuECpU9F8/79dKUGZGnwIe+l7QoXydmWpV7mKXDcAVYKlYKZe7JBehkFB2u4ma1vUDuWSFRj83qtkzffOMAU7OhbI8Fhpu6Xofz2GqBuBZNiHE5zs5JaowIyDObhzmKNDmyQWfjPu3WAvVsK5Y4CFpLGBLNOObShqlkTScIB7XOuswxzt7KuX5QaHs1+4srSONTgNT4qJtOO5KU4iI2KIAqwc3nLf9a9DaMkSObpSJ+XDwY1FiE1o3nDOE5+0ZW4R+kXQfm5WeuFIGvpuBzmJuKeKlsgOuqTfcJ5KJY0z4rCbhdYJqbPWK8433fVUhIMRm9n8v41q8TDPzJex1g/L1FBK4tR71ABBJ7AzJNSEbk4LBBv81SDoGRS1lljh+MiddgSx5tyta39hFD6uF4YysRnXoy3zsBl3kC3/os4Lz5c5eVJ5SN99zMpMO1tYP6YuynEUBb6ZMTqOByiqyY8jrvw8HNrJ7Ojx4ehQ41ugaFloBUXpb5GGzXpvAhhPLYCeKrCY74+qzitLlZpMk9iMAHNRT4FR/ZIPosifvCD
 bYitAfHV
 BAdH5GL8kEG+Xd2LYdQ0zFgMKGQfBEC2KhHAzKo3Dr+wd4haUUNfSo0s3ANUWXhRyv++75abWKJX/QGZlnte+25DpRSLyoSpVuYclyQPkeTKlBU9ecsTqtUVfup/itwnOe7k3g+hIJm0yDTEECXfFcnS5IRf+AXDmfrCIEUs0cinkV4igsU1fddYVK+IL72IJ1bnjfK7oSPNwkfEIR2vWNqcXf8FbMk/7XYzXikc//42+PvhuG8m8EKQqa1KdYolP6UZ1v8u0Q5EA1elwis/3iDhHZN8QeGbboSjfq5Sp1i5glIoZhfkQAO1UzyC55LNpUo6fcTaszl2tL4SroZf4I9edLhevtDCmdN74Oj6a+vDaGqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:17PM +0100, Kiryl Shutsemau (Meta) wrote:
> Preparatory patch. Add the change_protection() primitive that
> userfaultfd RWP will use.
> 
> An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
> PROT_NONE half makes the CPU fault on any access; the uffd bit
> distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
> hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
> bit, so the two cannot be used together on the same range.
> 
> Two new change_protection() flags:
> 
>   MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
>   MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit
> 
> Both are wired through change_pte_range(), change_huge_pmd(), and
> hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
> share the same semantics.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  include/linux/mm.h            |  5 +++++
>  include/linux/userfaultfd_k.h |  1 -
>  mm/huge_memory.c              | 20 ++++++++++++------
>  mm/hugetlb.c                  | 25 ++++++++++++++++------
>  mm/mprotect.c                 | 40 +++++++++++++++++++++++++++++------
>  5 files changed, 71 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3f53d1e978c0..2b65416bb760 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3291,6 +3291,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>  #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
>  #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>  					    MM_CP_UFFD_WP_RESOLVE)
> +/* Whether this change is for uffd RWP */
> +#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
> +#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* Resolve rwp */

Nit: any reason except copy/paset to use different case in "do rwp" and
"Resolve rwp"? ;-)

> +#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
> +					    MM_CP_UFFD_RWP_RESOLVE)
>  
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index fcf308dba311..3725e61a7041 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -397,7 +397,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
>  	return false;
>  }
>  
> -
>  static inline bool userfaultfd_armed(struct vm_area_struct *vma)
>  {
>  	return false;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d88fcccd386d..2537dca63c6c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2665,6 +2665,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	spinlock_t *ptl;
>  	pmd_t oldpmd, entry;
>  	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
> +	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
> +	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
>  	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
>  	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;

It looks like uffd_wp* are always ORed with uffd_rwp, we could fold this to
e.g.

	bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);

>  	int ret = 1;
> @@ -2679,11 +2681,18 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		return 0;
>  
>  	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
> -		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
> -					    uffd_wp_resolve);
> +		change_non_present_huge_pmd(mm, addr, pmd,
> +					    uffd_wp || uffd_rwp,
> +					    uffd_wp_resolve || uffd_rwp_resolve);
>  		goto unlock;
>  	}
>  
> +	/* Already in the desired state */
> +	if (prot_numa && pmd_protnone(*pmd))
> +		goto unlock;
> +	if (uffd_rwp && pmd_protnone(*pmd) && pmd_uffd(*pmd))
> +		goto unlock;
> +
>  	if (prot_numa) {
>  
>  		/*
> @@ -2694,9 +2703,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		if (is_huge_zero_pmd(*pmd))
>  			goto unlock;
>  
> -		if (pmd_protnone(*pmd))
> -			goto unlock;
> -
>  		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
>  					     vma_is_single_threaded_private(vma)))
>  			goto unlock;
> @@ -2725,9 +2731,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
>  
>  	entry = pmd_modify(oldpmd, newprot);
> -	if (uffd_wp)
> +	if (uffd_wp || uffd_rwp)
>  		entry = pmd_mkuffd(entry);
> -	else if (uffd_wp_resolve)
> +	else if (uffd_wp_resolve || uffd_rwp_resolve)
>  		/*
>  		 * Leave the write bit to be handled by PF interrupt
>  		 * handler, then things like COW could be properly
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 61cda9992043..63f6b19418b9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6434,6 +6436,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>  
>  		ptep = hugetlb_walk(vma, address, psize);
>  		if (!ptep) {
> +			/*
> +			 * uffd_wp installs a pte marker on the unpopulated
> +			 * entry; RWP does not install markers so the

Nit:                              uffd_rwp

> +			 * allocation is unnecessary for it.
> +			 */
>  			if (!uffd_wp) {
>  				address |= last_addr_mask;
>  				continue;
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 8340c8b228c6..23e71f68cf7a 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -216,6 +216,8 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
>  {
>  	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
>  	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> +	const bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
> +	const bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;

And here a single pair of bools should be enough I think.

>  	softleaf_t entry = softleaf_from_pte(oldpte);
>  	pte_t newpte;
>  
> @@ -256,7 +258,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
>  		 * to unprotect it, drop it; the next page
>  		 * fault will trigger without uffd trapping.
>  		 */
> -		if (uffd_wp_resolve) {
> +		if (uffd_wp_resolve || uffd_rwp_resolve) {
>  			pte_clear(vma->vm_mm, addr, pte);
>  			return 1;
>  		}
> @@ -265,9 +267,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
>  		newpte = oldpte;
>  	}
>  
> -	if (uffd_wp)
> +	if (uffd_wp || uffd_rwp)
>  		newpte = pte_swp_mkuffd(newpte);
> -	else if (uffd_wp_resolve)
> +	else if (uffd_wp_resolve || uffd_rwp_resolve)
>  		newpte = pte_swp_clear_uffd(newpte);
>  
>  	if (!pte_same(oldpte, newpte)) {

-- 
Sincerely yours,
Mike.


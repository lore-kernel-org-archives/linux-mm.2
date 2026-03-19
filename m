Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373C11088E68
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DEA6B03BC; Wed, 18 Mar 2026 23:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF616B03BE; Wed, 18 Mar 2026 23:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815456B03BF; Wed, 18 Mar 2026 23:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 701326B03BC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:16:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41A961402D4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:16:37 +0000 (UTC)
X-FDA: 84561350034.17.47A6086
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id 801364000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:16:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK+YWR9w;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9mrbCOmG4x77bnH5kDlZrIOueqBy+MG8B+nctQHjJw=;
	b=GrGw2PeIisiz5oI6NUY0Pumd8To47L/RXmjVhLeLCAxeJGIJ4G7cPk3xd/hS7OiF4kNOZb
	V3A5NUG7nkhhbflq0/llqxG1sqUe8arEIM5CGchlGnSmvWvbi2Jb5Cm4zp+LwKLpPAuIGJ
	1Ys+5RXoEhcLWKEA9cN1Z+oQjjxt7gY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK+YWR9w;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890195; a=rsa-sha256;
	cv=none;
	b=WT2hbvpzazNbNpkyR1a2y9OS6mTxFYg+25hHcM0Dk+3Tv6HlDkHJKdSc8qc8qu7kTeIwl2
	1w2MpupUPu9ofrEyFS3QlnzvK2IB71NbBxPwNYeOIDD907M+Lzw2pal2TbpS5uppOd1Eze
	CwDGfWylvliiCOSUp00qqmuxP7ND/rE=
Message-ID: <cdd47671-c5ac-4170-aa98-cf5e1f09368d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773890193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9mrbCOmG4x77bnH5kDlZrIOueqBy+MG8B+nctQHjJw=;
	b=iK+YWR9wTlQKAnQBbZuoNU4JCZgqBq5Xg3Oe8ViaOu8FDMK6xsbhz85mUkz5Q+RlMiPS0J
	9Gq7nw6gk4lPuDBLudROgvk4ec9G9leSYkWICSN64uoFtWd/MwsnIy7t55vDCxG3xMQrk8
	eG4eANEbPI9U0vYA36TyX6V47PzLfRI=
Date: Thu, 19 Mar 2026 11:16:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <cover.1773865827.git.ljs@kernel.org>
 <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 801364000E
X-Stat-Signature: zk5psfrci39x66ubrxkokncfyousqrzm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773890195-209334
X-HE-Meta: U2FsdGVkX1/NTbU5KS+4rOL1DaTI3iG9QKSqVpMz15/wD9U8u2Q3Q27dhBgr2cc+1d7kJhtp1tSMGL8dfO1gh6/frSXghPlyEaS4Wsi1+sKFk4OzHZ9IgnX2dItofH3jGm1t/QBF46rbdk2e/0MN+RNG5FP7/RrFBu3GD1Fc/J2m+pCdBEgB6qWNK6nvcifl/A9+BvkShhTWwb06YH5S9Kp4HGcM3O5MvuyUWwlJOCwyH892RaJ1V6ZntAr4kweASsQBUprHj8LukgOG2LBBIhfa++CdgZrSPDRTuPW/FM1AR3AOxmhxrqIlZz5dfmQwR4GNlRKuFwVL0AZkktK7w2kGmG3bJk4jryFK01ptx1EK4ePXzQPa575nsb+6TX/jKNsc1L2/p0xcZxoZZo2Drf+BI4vHi85WpERATBvWkYsXnFQ+Ndsrw7jO456VUrm3+8AT/D3ZvWLrArANs6eP5RGak76WC/p47evSNGwmlnxahPNknEqiAsJId3WkVtxzlvJFgrNyM/5h2siP4ZZtWjbxztA9ZBvdt73Wegu08yv1gntlFlmzERE4vSvGQHl7ZJXQipcAPOksY9DThYtpHmR6nK2TbrXJ8xR8QBNTpVqj47XcJl9yPw/4wRbH7P5bFoljTR/VVhaWDUrpNuNtqHjh99tQ8vvaXNx0+x7pUuqsn5bbZ2CAkUIQL5M1nLwLbbwl7/0vLRbQ5ysjH/Q6kdVYcbuXuzKM6+sLsptSxSPvud8FvChi3cm418wnurgGym3kNYJm35gJqwNi7nTydBx8CMJeuptTh9rFmLCW6q3Jb4col3yfy43KT9SglGUfkMxblmSYYd9dj/40tojgeuuL7UJwkfiwumFIuzOVeTkGkRhQFqwcz+kAeVU6XK99NfxwIaj7OGVETBleLfygNCLk/xDNV6u3lOGcYI6OFWvNUSeOFofv1xEZAuYgdcM1+MUw67QZ9kf+1cNF/yZ
 4HTthu/R
 /r1P4XqQVlvPijTdSEZatGCEv+385IORz9r6CmiRfdfXrsqmuVBJE6E8cZHecGABV1ZPgzmtyxGqWerYyOtu51hciAQ5cM6shuW1Ucgc5iLTjj3RA+QWsXw1Ga4QNiPvG9sjACTqPMLhvjJ+S/9j9ibHNNVTUqLzkj5knTHlEh9OGzm2ix4qH5NKbTnUASZvD17LR8jDMAx8vzObwWoEEgN19EOP1XO4gwyeNmjT0jSYmThDVyyUKydrn9HQaSE/byWT6DNgRhndw0R4v8eJuhVUm5bpjcF7/LtW08OQDOjLufl/pkAZ+WH7d8grDOy2JPGts
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> This function is confused - it overloads the term 'special' yet again,
> checks for DAX but in many cases the code explicitly excludes DAX before
> invoking the predicate.
> 
> It also unnecessarily checks for vma->vm_file - this has to be present for
> a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.
> 
> In fact, a far simpler form of this is to reverse the DAX predicate and
> return false if DAX is set.
> 
> This makes sense from the point of view of 'special' as in
> vm_normal_page(), as DAX actually does potentially have retrievable folios.
> 
> Also there's no need to have this in mm.h so move it to huge_memory.c.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>   include/linux/huge_mm.h |  4 ++--
>   include/linux/mm.h      | 16 ----------------
>   mm/huge_memory.c        | 30 +++++++++++++++++++++++-------
>   3 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index bd7f0e1d8094..61fda1672b29 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -83,7 +83,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
>    * file is never split and the MAX_PAGECACHE_ORDER limit does not apply to
>    * it.  Same to PFNMAPs where there's neither page* nor pagecache.
>    */
> -#define THP_ORDERS_ALL_SPECIAL		\
> +#define THP_ORDERS_ALL_SPECIAL_DAX	\

As mentioned in the comments, the pfnmap case is also include in the
'special' case, right?

>   	(BIT(PMD_ORDER) | BIT(PUD_ORDER))
>   #define THP_ORDERS_ALL_FILE_DEFAULT	\
>   	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
> @@ -92,7 +92,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
>    * Mask of all large folio orders supported for THP.
>    */
>   #define THP_ORDERS_ALL	\
> -	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
> +	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL_DAX | THP_ORDERS_ALL_FILE_DEFAULT)
>   
>   enum tva_type {
>   	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6f0a3edb24e1..50d68b092204 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5077,22 +5077,6 @@ long copy_folio_from_user(struct folio *dst_folio,
>   			   const void __user *usr_src,
>   			   bool allow_pagefault);
>   
> -/**
> - * vma_is_special_huge - Are transhuge page-table entries considered special?
> - * @vma: Pointer to the struct vm_area_struct to consider
> - *
> - * Whether transhuge page-table entries are considered "special" following
> - * the definition in vm_normal_page().
> - *
> - * Return: true if transhuge page-table entries should be considered special,
> - * false otherwise.
> - */
> -static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
> -{
> -	return vma_is_dax(vma) || (vma->vm_file &&
> -				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
> -}
> -
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>   
>   #if MAX_NUMNODES > 1
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3fc02913b63e..f76edfa91e96 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>   	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>   }
>   
> +/* If returns true, we are unable to access the VMA's folios. */
> +static bool vma_is_special_huge(struct vm_area_struct *vma)
> +{
> +	if (vma_is_dax(vma))
> +		return false;
> +	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> +}
> +
>   unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   					 vm_flags_t vm_flags,
>   					 enum tva_type type,
> @@ -113,8 +121,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	/* Check the intersection of requested and supported orders. */
>   	if (vma_is_anonymous(vma))
>   		supported_orders = THP_ORDERS_ALL_ANON;
> -	else if (vma_is_special_huge(vma))
> -		supported_orders = THP_ORDERS_ALL_SPECIAL;
> +	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
> +		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> @@ -2431,7 +2439,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   						tlb->fullmm);
>   	arch_check_zapped_pmd(vma, orig_pmd);
>   	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> -	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> +	if (vma_is_special_huge(vma)) {
>   		if (arch_needs_pgtable_deposit())
>   			zap_deposited_table(tlb->mm, pmd);
>   		spin_unlock(ptl);
> @@ -2933,7 +2941,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
>   	arch_check_zapped_pud(vma, orig_pud);
>   	tlb_remove_pud_tlb_entry(tlb, pud, addr);
> -	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> +	if (vma_is_special_huge(vma)) {
>   		spin_unlock(ptl);
>   		/* No zero page support yet */
>   	} else {
> @@ -3084,7 +3092,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   		 */
>   		if (arch_needs_pgtable_deposit())
>   			zap_deposited_table(mm, pmd);
> -		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
> +		if (vma_is_special_huge(vma))
>   			return;
>   		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>   			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
> @@ -4645,8 +4653,16 @@ static void split_huge_pages_all(void)
>   
>   static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
>   {
> -	return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
> -		    is_vm_hugetlb_page(vma);
> +	if (vma_is_dax(vma))
> +		return true;
> +	if (vma_is_special_huge(vma))
> +		return true;
> +	if (vma_test(vma, VMA_IO_BIT))
> +		return true;
> +	if (is_vm_hugetlb_page(vma))
> +		return true;
> +
> +	return false;
>   }
>   
>   static int split_huge_pages_pid(int pid, unsigned long vaddr_start,



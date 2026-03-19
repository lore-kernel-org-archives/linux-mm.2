Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C16108E1E2
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32DE6B0467; Thu, 19 Mar 2026 06:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A066B0468; Thu, 19 Mar 2026 06:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47056B0469; Thu, 19 Mar 2026 06:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C14C26B0467
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:39:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 922B2140462
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:39:41 +0000 (UTC)
X-FDA: 84562466562.07.E2D4712
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D1DF160003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:39:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q6HaUy1m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773916780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2sCf+XpmBXjN7W5tjuMjfNpsLooYEb+0fICURtpELI=;
	b=WI3n6u/+SnwVjc2FOfIvoZUU8KsKlrygUJ+AUfJ8b/WGeqIclSZ0rJRI5/oYW/giTJX4zb
	vNT5L1K9dMQGeOFEkYtwSLseglMd9OEtoHL5yFVTbUSYhXMUtiwsgos85qS+yX/FXOVoKo
	91uKl/6lO9df3UPxc17D8Uq5DJ5FXiA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q6HaUy1m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773916780; a=rsa-sha256;
	cv=none;
	b=LxlpXRNp39fV7S3YVMpDyLcNbzJCD8qlQBLkuBYQ3E6PSz5adTw/big93BZbmqXcsN1F2L
	Nj9t6zW1vaxOQaSK+HVfxAyE/Wh+7N8gDHyUrgZLcFnPFXnhcj/xuybm0qLJ91oSksNj3R
	k9To6J2vrTKbD3CQk7Oevp+j+KJwjPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B68544013;
	Thu, 19 Mar 2026 10:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D49FC19424;
	Thu, 19 Mar 2026 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773916778;
	bh=Wg7+9Y2K5YQyAEuOcnbcZyxttxGObbw3kzU8lDtgx34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q6HaUy1ml9AOF9G/OXp7Hs7j58PoXZGVhBiZYEyXbwf61DbMxN6wwejhcIgfQwr+n
	 dRZkEXCL0Lae9PFzGWP85V8N+2JtJUTjf0k/Jgot4KlwfDmsW7CFVhMYFj2CIWn6oa
	 DTQYu1KnEGvsM505J1IUomTzs+8KCb4QbT8vdinTva5+lIsnYO3aQqmjZlkqH7j1y7
	 aPzsjXqfZnXFsNReiGIRgnkT1cYv+MwCEHp7/n3THJovmltsL8LHlC99eZx8EwL0vW
	 1LId9T6gJSmvjyewIuiPUJiUlMY32PNdZ2/j8hDxxY23tcrODHGqGM/vz+vq7kgVHI
	 DNeoWq5j4TxPQ==
Date: Thu, 19 Mar 2026 10:39:36 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
Message-ID: <e90ae3af-4d7a-4e46-9bdd-ec42eda18251@lucifer.local>
References: <cover.1773865827.git.ljs@kernel.org>
 <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
 <cdd47671-c5ac-4170-aa98-cf5e1f09368d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd47671-c5ac-4170-aa98-cf5e1f09368d@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D1DF160003
X-Stat-Signature: am3r3nno94fdyqfdnzcibmwinsky3p8q
X-Rspam-User: 
X-HE-Tag: 1773916779-251360
X-HE-Meta: U2FsdGVkX19qPSnraZnVQ+pyzXONKa1PhMAI0HjghGx0ALjczVSN1+HW7HcvAPmeWBpasUAEA7RLA0QV3vUPGA6e4/UasWA1ruPM1viiHwQ+V//a9UCmD3jrx3jWTYoWBf/atCJTAgujsHOzQsDKiE6FxctRyMOO8vKh+753RgvMkivfke0cnojyNobge4NDI1HFbcsSftyd3Bglj5zp54SvQIzAkV7d/KubNiGkhoF07AZlCiO8oeaCbqMDdr4bPBMhoRLeGexD4Vxz59kEpkzH8Zcq3GnxUf91LZWQqRYAt5LXiLX1vaxG0DeVQ7Pkoyqrqb7oTqDBPjvA8OHHDl03LZ30HL+jnHODboDmKi3SrBQSZMwoM8rICWT4PaKga1lqS5C3WjnmrzU1TVB1ShPtj0ulppD2jQiswKK+W3EiWwCNCfM2gr86WofYzthHkCH6jRqLe7cfAnnt+s1Lmsypml3aNKuq9y+lsiQ5xiAD+XmdtIL60Ihbhzq/0UmAfGDMZG6zPhdM+mhOI7OZ7tgWkpVn8eGh3PAjdf6xp8rHPDKy02NcePU0QmO4WBL59oa7mbZIgJPREeWTQmD6jXYlqRYIxJkiwxz8NkajtMPcE4LRLN3oi7iqow2N+DEqW0yOJt8SVrC3e6LZdM2RW4iznDbiVDKbpWo26x0vOU6UMdSquSEZ3NAsbsariNX5Vq9R/ZfFRVUHFVXAJWLqjNjF8Wk8GxHfKyt4seD5CESTyaXlfnYoPScAmRiOo+++k5Hpj77b9mgIXIqyl83iPi3AH9Zud6SVh58gAh0JAFKigazNtkpsp2tOqmBInsObdU6nfjIMUtJVDmqFmLFuunTAugcFajR/XB5JbjTnzHvvlu2oA2z3UAFGaRIYHBJancM1LTrTWS5cpBeD/FmnFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:16:20AM +0800, Qi Zheng wrote:
>
>
> On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> > This function is confused - it overloads the term 'special' yet again,
> > checks for DAX but in many cases the code explicitly excludes DAX before
> > invoking the predicate.
> >
> > It also unnecessarily checks for vma->vm_file - this has to be present for
> > a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.
> >
> > In fact, a far simpler form of this is to reverse the DAX predicate and
> > return false if DAX is set.
> >
> > This makes sense from the point of view of 'special' as in
> > vm_normal_page(), as DAX actually does potentially have retrievable folios.
> >
> > Also there's no need to have this in mm.h so move it to huge_memory.c.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >   include/linux/huge_mm.h |  4 ++--
> >   include/linux/mm.h      | 16 ----------------
> >   mm/huge_memory.c        | 30 +++++++++++++++++++++++-------
> >   3 files changed, 25 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index bd7f0e1d8094..61fda1672b29 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -83,7 +83,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
> >    * file is never split and the MAX_PAGECACHE_ORDER limit does not apply to
> >    * it.  Same to PFNMAPs where there's neither page* nor pagecache.
> >    */
> > -#define THP_ORDERS_ALL_SPECIAL		\
> > +#define THP_ORDERS_ALL_SPECIAL_DAX	\
>
> As mentioned in the comments, the pfnmap case is also include in the
> 'special' case, right?

Yeah special = pfnmap, mixedmap. so renaming to SPECIAL_DAX to make clear it's
either dax or 'special' in the meaning of vm_normal_page().

>
> >   	(BIT(PMD_ORDER) | BIT(PUD_ORDER))
> >   #define THP_ORDERS_ALL_FILE_DEFAULT	\
> >   	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
> > @@ -92,7 +92,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
> >    * Mask of all large folio orders supported for THP.
> >    */
> >   #define THP_ORDERS_ALL	\
> > -	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
> > +	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL_DAX | THP_ORDERS_ALL_FILE_DEFAULT)
> >   enum tva_type {
> >   	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 6f0a3edb24e1..50d68b092204 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -5077,22 +5077,6 @@ long copy_folio_from_user(struct folio *dst_folio,
> >   			   const void __user *usr_src,
> >   			   bool allow_pagefault);
> > -/**
> > - * vma_is_special_huge - Are transhuge page-table entries considered special?
> > - * @vma: Pointer to the struct vm_area_struct to consider
> > - *
> > - * Whether transhuge page-table entries are considered "special" following
> > - * the definition in vm_normal_page().
> > - *
> > - * Return: true if transhuge page-table entries should be considered special,
> > - * false otherwise.
> > - */
> > -static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
> > -{
> > -	return vma_is_dax(vma) || (vma->vm_file &&
> > -				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
> > -}
> > -
> >   #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
> >   #if MAX_NUMNODES > 1
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 3fc02913b63e..f76edfa91e96 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >   	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >   }
> > +/* If returns true, we are unable to access the VMA's folios. */
> > +static bool vma_is_special_huge(struct vm_area_struct *vma)
> > +{
> > +	if (vma_is_dax(vma))
> > +		return false;
> > +	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> > +}
> > +
> >   unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >   					 vm_flags_t vm_flags,
> >   					 enum tva_type type,
> > @@ -113,8 +121,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >   	/* Check the intersection of requested and supported orders. */
> >   	if (vma_is_anonymous(vma))
> >   		supported_orders = THP_ORDERS_ALL_ANON;
> > -	else if (vma_is_special_huge(vma))
> > -		supported_orders = THP_ORDERS_ALL_SPECIAL;
> > +	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
> > +		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
> >   	else
> >   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
> > @@ -2431,7 +2439,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   						tlb->fullmm);
> >   	arch_check_zapped_pmd(vma, orig_pmd);
> >   	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> > -	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> > +	if (vma_is_special_huge(vma)) {
> >   		if (arch_needs_pgtable_deposit())
> >   			zap_deposited_table(tlb->mm, pmd);
> >   		spin_unlock(ptl);
> > @@ -2933,7 +2941,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
> >   	arch_check_zapped_pud(vma, orig_pud);
> >   	tlb_remove_pud_tlb_entry(tlb, pud, addr);
> > -	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> > +	if (vma_is_special_huge(vma)) {
> >   		spin_unlock(ptl);
> >   		/* No zero page support yet */
> >   	} else {
> > @@ -3084,7 +3092,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> >   		 */
> >   		if (arch_needs_pgtable_deposit())
> >   			zap_deposited_table(mm, pmd);
> > -		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
> > +		if (vma_is_special_huge(vma))
> >   			return;
> >   		if (unlikely(pmd_is_migration_entry(old_pmd))) {
> >   			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
> > @@ -4645,8 +4653,16 @@ static void split_huge_pages_all(void)
> >   static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
> >   {
> > -	return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
> > -		    is_vm_hugetlb_page(vma);
> > +	if (vma_is_dax(vma))
> > +		return true;
> > +	if (vma_is_special_huge(vma))
> > +		return true;
> > +	if (vma_test(vma, VMA_IO_BIT))
> > +		return true;
> > +	if (is_vm_hugetlb_page(vma))
> > +		return true;
> > +
> > +	return false;
> >   }
> >   static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>


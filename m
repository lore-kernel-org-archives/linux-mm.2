Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49069C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 22:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9176B0088; Fri, 18 Sep 2026 18:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A506B008A; Fri, 18 Sep 2026 18:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153736B008C; Fri, 18 Sep 2026 18:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D31DC6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:10:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 113C280111
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:10:21 +0000 (UTC)
X-FDA: 85228277442.30.6E221F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 298A71C000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:10:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jE261qTp;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789769419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1TtV+41yhkTzs4bJ6Xi6VeMZvDli7BH7XL9fWmfv8U=;
	b=PsbIYAQxJ8D0XS8UJzfomjGDGkU/xZZ/PtLrg1ydk6cBOeoJO4dZvPIDritah+Bi8Uk2RG
	efvggOh/q/CI8rVtS9Faei5grad+KDyUe1vVQG81jZjflUqt+TrX2Q1KLokbp/LMUI88Oz
	0Vlw+lzdBDSuXjAwScLF4p8aibgFdgg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789769419;
	b=ZPlZEg8A0Y705qrdbtaDdm9OajoTezTlTmp1ZEn5Z6nHdomKGZCkwIa4w97/uXYZEqdlVg
	I1PvFSsIh6AJuJsxMfBziKGB0GKjIN8eXWKyXcJ7r0YKUV6Js4GgzEBLYjX5X+3klBdgJ0
	P5F36yFYEgQwiYzaXklinT5PZFZZZlg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jE261qTp;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 827B842E39;
	Fri, 18 Sep 2026 22:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91F41F000FF;
	Fri, 18 Sep 2026 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789769417;
	bh=W1TtV+41yhkTzs4bJ6Xi6VeMZvDli7BH7XL9fWmfv8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jE261qTp9wo1hjbhahG2879J1uBhEcvBx47yxsLOlwm6VaOtfYsQ5MV3uY2CoRazE
	 ojo50Ej/0w+4dlMHzFgOuNTkfXQEmian3zp6SlfsrRnRvpvzqFmMnm1ZSDKwint7H/
	 azZKJ/20JDiCZaWIzfk3tmLjXfFz4BidDp5uhazO+p+4NGst6W5pnXEp+4s7dma+3M
	 3NYnQNdoUzlX6hfH9FHL8f35r1NIcJXvifSwlPf5Fx9DbrSkoWSVvNrn86rwtM7tNH
	 rPYDxUP6gP0duKsHc0Wm77dmJQC36e7YgVa3uC91IawW8fybdXbCBFPz3HAxVvI9Aj
	 jqUwA4HBOFLCw==
Message-ID: <35f36d8b-d215-439c-8e77-3a70deed7609@kernel.org>
Date: Sat, 19 Sep 2026 00:10:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 10/29] mm: make PMD migration-entry splitting explicit
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-11-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-11-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 298A71C000F
X-Stat-Signature: tcih95myewqp7h1he5mit7img7m36dxw
X-Rspam-User: 
X-HE-Tag: 1789769419-682039
X-HE-Meta: U2FsdGVkX1+AWl+/chxmPMGN1kFcMRjVTDJpXUl44bSz38hd4r9/lGk+sypbSSTb58hWuoxB/KQAbfHcCjlksX/ZET9eHQ4p7cDW02JltRsrFC8CcYQenULz7dSiwwV/6zoMd4TFFXddLh2G7aKXI4xiGJDd8IFgXkyv8vlfxamxaMiIBo+gA3t9spT4CQrgNYRM4ImacFyefCinZ14jbAJ4xon1Nm88xuj6hyJkdem7H0wycgwNoOGe7IDSn6yD2cG4YiqbUfNc4CqC0/N2tO2xEm+Yr+kdBeRTX/wH5l600qbw6Y2B+nWMWSTRJpFgUZg3abarPougF045S8aMT2wCOEzn3bN8tYoAZNnPrtR6eQNLKCbIwYBEBLxzlIdNZgFpsagof86161IaeQ7KQxwRMhKexxht3JZ02tBxkSxi9BIMzo15qFhXRXUqyoKxSjviLojie3QuJGNbhIWtancxOAcxmP/eT9uU63qlFRc+DMDKq/T4qiTYp9+MavDA2i7ZkZrfLDXtxnQzjlhA+bcfAN+h1fPF7iJte6TSLV+czhZrtWZDNGjsBQt6EytidlJT6zQyKzi5+Uk72O5nyLXYR6OvzHZ8+lw7Cj4bp+8hqEkyBLPY+4j7aq8wcNhr/wVHBm5CXoiiYB04d6Hg8LwtQLoZCpHqI250cBhU5Glz/jddRUJ4acO38b8JQrpl7wemP6IKDElOpIixjtlcDRLZ+IOXJSwGI0CwfRd+3deMGFvCV0CvbXmOp6xE+K5qb+8iuzuZnG4lk/QDZwWkWRniQdLisQFbP/7yS6nmLz5g6XyArTpsi49Lr8PEUIi/gDx/4RaSmEXUoJsl2QmHmYXhv5zzVnGvoKF2MKRO2BuVVqB+a6BS9Jo1Xt3fUhKYl85hIsax+3FRY98SFN520g2TG8nN4/tIDfQZFLvHX0Hw/JB7JzA6Y0xCFZhk/3dm88VbGgatdrzC9J66vcq
 IsQ+RNm/
 P0vJVJ7moqwBFw/EQpcX3CSK1F4CAIp8MXOZDrUV7B8Y9IimkRFJhcg8z0W/K78j7d7dtxysELqkwOcZl4BXwHgDMgSrwRkiHL/hOQVdZtyTY8byUL2HemUYMqWpV5blyejn1s5fhPgFWizUYeVekK5amxu65GWIZ+YHKFTOgzRM4k6oSlpVkKlsSrjm21LauLPpP4vEWQuC3t+soXmz/q+HNCO6txUGHxqs+jQo+qzPEtFxHLoD+7lMcDdB8caHGDx3F9D75T7CDj2DpQT8c2uc2Ye4QjaXkNqfJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:28, Usama Arif wrote:
> __split_huge_pmd() and friends take a "freeze" boolean that every caller
> has to pass and almost every caller passes as false. The name says nothing
> about what it selects, and the one thing it does select - PTE migration
> entries instead of PTE mappings - is only ever wanted by the rmap migration
> path.
> 
> Rename it to use_migration_entries, keep it private to mm/huge_memory.c,
> and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
> caller that wants it.
> 
> migrate_vma_split_unmapped_folio() also passed freeze=true, but only ever
> runs on a PMD that is already a migration entry, which the generic helper
> expands into PTE migration entries either way. Its folio_get() only existed
> to balance the put_page() that freeze=true performs, so both go.
> 
> No functional change intended.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

[...]

> +void split_pmd_to_migration_entries(struct vm_area_struct *vma,
> +				    unsigned long address, pmd_t *pmd);

Two tele tabbies please.

>  bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>  			   pmd_t *pmdp, struct folio *folio);
>  void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> @@ -690,12 +690,14 @@ static inline void deferred_split_folio(struct folio *folio, bool partially_mapp
>  	do { } while (0)
>  
>  static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> -		unsigned long address, bool freeze) {}
> +		unsigned long address) {}
>  static inline void split_huge_pmd_address(struct vm_area_struct *vma,
> -		unsigned long address, bool freeze) {}
> +		unsigned long address) {}
>  static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
> -					 unsigned long address, pmd_t *pmd,
> -					 bool freeze) {}
> +					 unsigned long address, pmd_t *pmd) {}
> +static inline void
> +split_pmd_to_migration_entries(struct vm_area_struct *vma,
> +			       unsigned long address, pmd_t *pmd) {}

Dito.

>  
>  static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>  					 unsigned long addr, pmd_t *pmdp,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ee8d46827ffdc..873887aed0bc2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2033,7 +2033,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pte_free(dst_mm, pgtable);
>  		spin_unlock(src_ptl);
>  		spin_unlock(dst_ptl);
> -		__split_huge_pmd(src_vma, src_pmd, addr, false);
> +		__split_huge_pmd(src_vma, src_pmd, addr);
>  		return -EAGAIN;
>  	}
>  	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> @@ -2257,7 +2257,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
>  	folio_unlock(folio);
>  	spin_unlock(vmf->ptl);
>  fallback:
> -	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
> +	__split_huge_pmd(vma, vmf->pmd, vmf->address);
>  	return VM_FAULT_FALLBACK;
>  }
>  
> @@ -3190,7 +3190,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>  }
>  
>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> -		unsigned long haddr, bool freeze)
> +		unsigned long haddr, bool use_migration_entries)


Just curious: s/use_migration_entries/to_migration_entries/

>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct folio *folio;
> @@ -3291,10 +3291,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		 * folios w.r.t anon exclusive handling. See the comments for
>  		 * folio handling and anon_exclusive below.
>  		 */
> -		if (freeze && anon_exclusive &&
> +		if (use_migration_entries && anon_exclusive &&
>  		    folio_try_share_anon_rmap_pmd(folio, page))
> -			freeze = false;
> -		if (!freeze) {
> +			use_migration_entries = false;
> +		if (!use_migration_entries) {
>  			rmap_t rmap_flags = RMAP_NONE;
>  
>  			folio_ref_add(folio, HPAGE_PMD_NR - 1);
> @@ -3344,11 +3344,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
>  
>  		/*
> -		 * Without "freeze", we'll simply split the PMD, propagating the
> -		 * PageAnonExclusive() flag for each PTE by setting it for
> +		 * Without migration entries, we'll simply split the PMD and

"When not splitting to migration entries .."

> +		 * propagate the PageAnonExclusive() flag for each PTE by setting it for
>  		 * each subpage -- no need to (temporarily) clear.

While at it: s/subpage/page/

>  		 *
> -		 * With "freeze" we want to replace mapped pages by
> +		 * With migration entries we want to replace mapped pages by

"When splitting to migration entries ..."

>  		 * migration entries right away. This is only possible if we
>  		 * managed to clear PageAnonExclusive() -- see
>  		 * set_pmd_migration_entry().
> @@ -3359,10 +3359,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
>  		 */
>  		anon_exclusive = PageAnonExclusive(page);
> -		if (freeze && anon_exclusive &&
> +		if (use_migration_entries && anon_exclusive &&
>  		    folio_try_share_anon_rmap_pmd(folio, page))
> -			freeze = false;
> -		if (!freeze) {
> +			use_migration_entries = false;
> +		if (!use_migration_entries) {
>  			rmap_t rmap_flags = RMAP_NONE;
>  

[...]

>  
>  	smp_wmb(); /* make pte visible before pmd */
> @@ -3477,15 +3477,28 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  }
>  
>  void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
> -			   pmd_t *pmd, bool freeze)
> +			   pmd_t *pmd)

While at it ...

>  {
>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>  	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
> +		__split_huge_pmd_locked(vma, pmd, address, false);
> +}
> +
> +/*
> + * Split a present PMD into PTE migration entries, for the rmap migration
> + * walker.  Like split_huge_pmd_locked(), the caller must hold the PMD lock and
> + * must already be inside an mmu_notifier invalidate range.
> + */

I'd prefer kerneldoc but I'll let you decide.

> +void split_pmd_to_migration_entries(struct vm_area_struct *vma,
> +				    unsigned long address, pmd_t *pmd)

two tabs ...

[...]

> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -918,12 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	unsigned long flags;
>  	int ret = 0;
>  
> -	/*
> -	 * take a reference, since split_huge_pmd_address() with freeze = true
> -	 * drops a reference at the end.
> -	 */
> -	folio_get(folio);
> -	split_huge_pmd_address(migrate->vma, addr, true);
> +	split_huge_pmd_address(migrate->vma, addr);


Everything up to this point was trivial :)

You say that it already is unmapped (which makes sense looking at the
function name).

In VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio) we verify.

Did you run the hmm selftests with DEBUG_VM enabled, just to be sure? I remember
they exercise at least some of the THP logic in here.


>  	ret = folio_split_unmapped(folio, 0);
>  	if (ret)
>  		return ret;
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2888ee638d872..ee33bbb421008 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -530,7 +530,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  		if (pmd_is_huge(_pmd)) {
>  			if ((next - addr != HPAGE_PMD_SIZE) ||
>  			    pgtable_split_needed(vma, cp_flags)) {
> -				__split_huge_pmd(vma, pmd, addr, false);
> +				__split_huge_pmd(vma, pmd, addr);
>  				/*
>  				 * For file-backed, the pmd could have been
>  				 * cleared; make sure pmd populated if
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 5332c52909be1..feb751e29b992 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2290,7 +2290,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				 * restart so we can process the PTE-mapped THP.
>  				 */
>  				split_huge_pmd_locked(vma, pvmw.address,
> -						      pvmw.pmd, false);
> +						      pvmw.pmd);

You can feel brave and squeeze it into a single line now :)


Overall LGTM.

-- 
Cheers,

David


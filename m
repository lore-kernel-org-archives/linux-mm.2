Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65CA4CA5FF1
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 02:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E46C6B0092; Sun,  4 Oct 2026 22:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097056B0093; Sun,  4 Oct 2026 22:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECCB6B0095; Sun,  4 Oct 2026 22:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B96316B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 22:40:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12CD1120C81
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:40:13 +0000 (UTC)
X-FDA: 85287018306.29.926D41F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B26F180003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:40:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XMUBUTAR;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791168011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8452iUaS5o0CW4R7Mgbqf97iERo9aC326JELO5+2Q4=;
	b=w5p/bmcUs3gFd1Y7Cuc6RbvuF8tPKxLLHY4XxwC5YiAbZv9x6J6390xJ9iyX2k8NImuE7K
	o27bFaWr71YgojhxP80zn5eVxoVVpyUSdKK2YM+N1koAHN7vUrzWDTlhIIqYyvrH+mopBe
	eSUdiyuH2kZ5FolgZKTbF1kb5SnEkh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791168011;
	b=8HT34Yiy5Kh+M0KxFyLR58CetjS75xHaxK+M4GoQiN3BWT4qu+ote6qkhCcyRPA22v3075
	c6PxkR6oGhXsdbmrzTiy6uvmoLPwwe4CTGfTff89NshS5IPrf5ZVWD90OvhCFFB3IXPtTT
	8gMuPe0YaVeKSWW3IdklyvL9g69uCdw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XMUBUTAR;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 939061595;
	Sun,  4 Oct 2026 19:40:06 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EF083F763;
	Sun,  4 Oct 2026 19:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791168010; bh=4nKoqMv1Uc1IZmsQ8w941NyDGQ2IHgdv/9GpM2fH8Ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XMUBUTARAG359qBmKsP9jDxEE8bgeYMhPMO6ZFfBn9WWyS11rP7LAl+jhXbO+E/u4
	 am5BFAH1a+yV1q6HEz3iCJiIFkwOP0hxMXYNH0ghYKSLBOCtc6MlR/kmWfKHpyjhBR
	 jhQMx6WFTbeiXefXKOmjaJDLkuNdm8074HpuOPdo=
Date: Mon, 5 Oct 2026 08:10:06 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/3] mm/memory: remove the mkwrite argument from
 __vm_insert_mixed()
Message-ID: <i64bejs7dhn5bozzphibmoh2ghgzklruvk4evzag7tqkvbq6ez@epb3kdpmcs3b>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-3-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-3-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B26F180003
X-Stat-Signature: 1effqyfbjn1g5skf75bu1h1x97wf3jkf
X-HE-Tag: 1791168010-317617
X-HE-Meta: U2FsdGVkX1/94Rls24ZPkj5X0NbB9tXVj/Osoj/Zqr0ktHwrT9m5aKUEMaFTOq/IqNthWHqH6oZSIdfYnuUE/6IVrAs0lkBeDLSSw/oSYWf/kR9AznZcikRglpkmmReacfs8vwhct7BNCkVf/H1F+tTovr1O3iqQE4nJZrXIsZEh3zJ4UGpjokNxxvWy9wPpG9toLbzaU9CUsuVz7qw1qxY0oV5gO/SnMkj8cP139w/PLeAJZR5xM6BQNYrHucQk07I6CC9fOOzum85E4ew61fbWkIP+3pvJSfoMrwuYcY+YCMay9xIYzc3UgGIISZRyrZzk0mZ++LRCbmtSRhFc/D7w/wrIP0UI6P3w8A/Zj2Bb9PjJfFexuFRdxoZjYGPWoTgTcGJUhNF90pSIohN3oD3yGT7yD0wMbef2wtxI8E20OQok4EIXPL3DHBPK6JWM7BpGNsCw2jgx+ZHgJ3u5e1IakrBoNu5pFKtGZLak25ysZnaK/hRxtC+IBXLX/G5ufyzAzD7wgloVyXgyY51c7Cdl/i06tnKT/pmw6zeRpsI1dgGir/aL1tuPK8+C1EM50NtP69O9ZURPytVEyFMvlsj8exZgPWN8wWR30NrJsYt8Iyb67BgYUEdaWFFY4yDG4QDyEri23CtsrjLa7Dg1Y1ZLJawXQrd0IL4WNjT90lUXlY/ZmRClnsFZrxFWVcpjdpsvLJOCRfF7zleSqite78BNdxk4J+Fkix6ntD39CR9iAUKhpfeI91Q0lmH3V6E6TLf0kRb+vnEol3kkZzyuID38HIh7n+pHk2mbibbmmEVBaEUQov9tQK3ZrSvnwfj5NDbJBfzSMVYknlEHDrOZuuyLzDviEc7iCTuy6Q+mQMCMbTJb4RnYx9AyU6rdqImH1g/HG1U28v+X8xElK//JFfyHqdsQ8gHiEpoVLdYiugiH8rYjyl+cDPgU6BWjpHXdhkJWArRMapQNWe9AP5n
 LJ/BxsaA
 AMHziAHAYcu4kgpMdRnf4j4Xf1G0VyrMCaa/leg0ULgDbIQo2rwzjtLpG9f6zeM7Cq+5STmL6QMicq4rNs1V1b7BavKPRHCqJ66QrWmajohlTB0F+nM0eEng9dJCdcmOqZoILJUy6s9VW5dQTjq8BYabzHsyvqIuS9hhQHXxw5a59mW2uh4N1XCi9mzJsoQIHiq0bV8C2+CC650A9p0xZ3PoqDPgX11Zipxkdvmc10FpP3oBD9Guj7+geQFAf9N+CKHVjgZw04oPYczJ+H13rd7kOOhG471KaWl5OCFXTuJxQqMsNpT5teH45nRdXqFWf9Fcjin58Y7YGuLr2YPsT3nPk1oWlArPRMghB+1UBqc/1AOo/KEozNwmwvko1eiuttLXgmU/bbZuneCOmYlrkREua3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 01:05:33AM +0900, Sang-Heon Jeon wrote:
> __vm_insert_mixed() is only called from vmf_insert_mixed() with
> mkwrite == false, so mkwrite is also always false in vm_mixed_ok()
> and insert_pfn().
> 
> So remove the argument and the unreachable code in insert_pfn().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/memory.c | 57 +++++++++++++++++------------------------------------
>  1 file changed, 18 insertions(+), 39 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4b2e4be28031..6c1d38eba7b2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		if (!mkwrite)
>  			return -EBUSY;
>  
> -		/* see insert_pfn(). */
> +		/*
> +		 * For read faults on private mappings the PFN passed in may
> +		 * not match the PFN we have mapped if the mapped PFN is a
> +		 * writeable COW page.  In the mkwrite case we are creating a
> +		 * writable PTE for a shared mapping and we expect the PFNs to
> +		 * match. If they don't match, we are likely racing with block
> +		 * allocation and mapping invalidation.
> +		 */
>  		if (pte_pfn(pteval) != page_to_pfn(page)) {
>  			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
>  			return -EFAULT;
> @@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
>  EXPORT_SYMBOL(vm_map_pages_zero);
>  
>  static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> -			unsigned long pfn, pgprot_t prot, bool mkwrite)
> +			unsigned long pfn, pgprot_t prot)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pte_t *pte, entry;
> @@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  	if (!pte)
>  		return VM_FAULT_OOM;
>  	entry = ptep_get(pte);
> -	if (!pte_none(entry)) {
> -		if (mkwrite) {
> -			/*
> -			 * For read faults on private mappings the PFN passed
> -			 * in may not match the PFN we have mapped if the
> -			 * mapped PFN is a writeable COW page.  In the mkwrite
> -			 * case we are creating a writable PTE for a shared
> -			 * mapping and we expect the PFNs to match. If they
> -			 * don't match, we are likely racing with block
> -			 * allocation and mapping invalidation so just skip the
> -			 * update.
> -			 */
> -			if (pte_pfn(entry) != pfn) {
> -				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
> -				goto out_unlock;
> -			}
> -			entry = pte_mkyoung(entry);
> -			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> -				update_mmu_cache(vma, addr, pte);
> -		}
> +	if (!pte_none(entry))
>  		goto out_unlock;
> -	}
>  
>  	/* Ok, finally just insert the thing.. */
>  	entry = pte_mkspecial(pfn_pte(pfn, prot));
>  
> -	if (mkwrite) {
> -		entry = pte_mkyoung(entry);
> -		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -	}
> -
>  	set_pte_at(mm, addr, pte, entry);
>  	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
>  
> @@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  
>  	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
>  
> -	return insert_pfn(vma, addr, pfn, pgprot, false);
> +	return insert_pfn(vma, addr, pfn, pgprot);
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn_prot);
>  
> @@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn);
>  
> -static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
> -			bool mkwrite)
> +static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
>  {
> -	if (unlikely(is_zero_pfn(pfn)) &&
> -	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
> +	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
>  		return false;
>  	/* these checks mirror the abort conditions in vm_normal_page */
>  	if (vma->vm_flags & VM_MIXEDMAP)
> @@ -3013,12 +2992,12 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
>  }
>  
>  static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn, bool mkwrite)
> +		unsigned long addr, unsigned long pfn)
>  {
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	int err;
>  
> -	if (!vm_mixed_ok(vma, pfn, mkwrite))
> +	if (!vm_mixed_ok(vma, pfn))
>  		return VM_FAULT_SIGBUS;
>  
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
> @@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>  		 * result in pfn_t_has_page() == false.
>  		 */
>  		page = pfn_to_page(pfn);
> -		err = insert_page(vma, addr, page, pgprot, mkwrite);
> +		err = insert_page(vma, addr, page, pgprot, false);
>  	} else {
> -		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
> +		return insert_pfn(vma, addr, pfn, pgprot);
>  	}
>  
>  	if (err == -ENOMEM)
> @@ -3086,7 +3065,7 @@ EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
>  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  		unsigned long pfn)
>  {
> -	return __vm_insert_mixed(vma, addr, pfn, false);
> +	return __vm_insert_mixed(vma, addr, pfn);
>  }
>  EXPORT_SYMBOL(vmf_insert_mixed);
>  
> -- 
> 2.43.0
> 


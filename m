Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1497606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AX6N7NUK
Received: by kanga.kvack.org (Postfix)
	id 09C296B05CA; Thu, 19 Nov 2026 08:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0261C6B0609; Thu, 19 Nov 2026 08:56:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA53A6B066C; Thu, 19 Nov 2026 08:56:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF6766B05CA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:56:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C35F160ACF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:56:52 +0000 (UTC)
X-FDA: 85452019464.21.8C4A9AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B81C340004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:56:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AX6N7NUK;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096610;
	b=OUXOs8l8KMD8VsWEMOqfF4D4fz0xXAc/jKGxLh+JNxbUYnJBDaHgn2NJpWsyOGN76vAUjU
	AUefq7R2z/hxtwUml68jL/deSeXlCOqN/dEXgBhCX2VEhWZsMw9vcPwWrfRNw8l+AggKYR
	FyPUJc3lQrAPwyrqUf5EkaR5QUk6GPE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIx6Bux1pGDApEL1rLj1d3nFZ3JSNemgDEDuwGhJ5EE=;
	b=wHau3tPlphv3np7YiUVsW3DNz5wsUQmcqDhgkohinpxrKEZW53al5t+9Uq/SwZIyKdFC1W
	OTGur18FGKSy/BxuH7ENwN72u4q67N8cev1wNetzaIBOxaG7gqDtftmc9X+mR02bh32eST
	P3SNMSicok0bLh54XnNJRe4ImoaKeb0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AX6N7NUK;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E09263595;
	Thu, 19 Nov 2026 13:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895931F000C4;
	Thu, 19 Nov 2026 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795096609;
	bh=qIx6Bux1pGDApEL1rLj1d3nFZ3JSNemgDEDuwGhJ5EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AX6N7NUKv9mp9gn/kzY4kW5RrUPF3SGn22v25jisQSCjWcWuPJlf2UIgxrTPgJrjw
	 jk3pE00l2yTz0rptfaTyhdgb0u3Qh1tUpO0Ek1x/nZfEikEPoHVoE/XAmwneC0tq3d
	 UdafLEl3OFft6hrgq5E3rA5WFjycxMy2bi2mendulJ+X8xyJkWoQHFmOk9znESazxU
	 ce5YuJQoIV7sGcuDwBEWKznEAWMfDKC5Jad//dK6Hg8dJ1sHVWDbm/2xXORSWyFR2Z
	 qh2BdQ1nJojbo/tN6VMNx+Js/s7+x99Otf9buy76+dZyy3fISX7tujJ/6GXSNY8UIx
	 TIZVAYjgdLx2w==
Date: Thu, 19 Nov 2026 13:56:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/3] mm/memory: remove the mkwrite argument from
 __vm_insert_mixed()
Message-ID: <av7_y5u1E1hps9q9@gremlin>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-3-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-3-ekffu200098@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B81C340004
X-Rspam-User:
X-Stat-Signature: 3kjqmni84w4ed3r5izo5bzjkib3etz45
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795096610-792536
X-HE-Meta: U2FsdGVkX1/LEZA5M9jzVtNRNXdp2thbtNoVN4IQj6PbcJ+X6PvUI/FmLjDvt+r5Z+Euh1rQb6xrY/nawxe9mveRL8JLfk1/xocY+V2uvlB2zh5RIEIbPtVE0E287a2/rvIqHfo8EULCn0+ao67lpxRHXRt0N9NJ+7bLhUyM3+vXCupaWWvX9fN6PW00XO/Ega/NhJRjuSIINW/QFcYnaL6CIFEHEfa8/IWg7g00mAQ1zS3HoyshYjsrFWUXUKQTYROECyT5JfLFLB4KLYc47098P7kKpZk6glIRZeMWB6VHB4StMJ7l+ysGwWSN58IXYoCBIQLgf75/vtXCjyTbWeWWCO8jkEuCNwoRuMbb5MmrVjpkkOOUC+3NTofGdowLLnhJ3TJ3VzUqOY3ugZAmNHsfKAqVqa8ZZ9RBkaevTg1z3CII62DGhIIKEVwxl0/lC18EFgzkQkoz7+XcVNnDB3JGEo0bN/o4RaqgusyfZAyIgflMzbnB1c0yLlvLdug8CaS8YXEt12qcZFZ4y7yQ30OCGbZMZrK06XeUT38xq1LADhr7hk1dLv5iErBREN6hLGZEraUNABMqJ/H9zsrB2eDQmTgBGWI95rJmlLBjEiptMHUrb9YYXIdC0l+TQ0wLeo2ztSL2qEyPfx5A+TS97P4IG4g1nVhHvDyZWdmLiJ+d5rYbw5bEM8o8kDdMUfqJPIHIWRInUuDnfiuO4xvQXSwyWAtDPB2OhQ1i3bFRoeXyTvTwHMbF6mIGmT0bD11Z+DBBcjRT/I/vkLqhtOpeiV0RHXM8t8MM0Pn9Knhym5cXbizy0ObHV+JNeChpOb55peVwVtcI/dVjQI7NLJuqEW1uE4AscFMM3kY2t9oCtg+HgVMOeRpP3bNeYz31nOX30Ig1923yTtAtFWmNjuJMti7yKCgUzB01Hg6aPD3Oai7MtILHZoHUmeA/SXXc4Ti95YkrU5X8puKzKB3u5CX
 aELuZZ3Y
 /V7UGGpsmlriQ1q8JS5FlUgpzyv4S9vH3oyZHaYDl/xQkg+prD8WY9Nbw/XXo4STUeAM6c6d5ZUQj/1RfDrObhMtL5UEVKFVv5CiUsWVoH8Nj0b6YOkCR5zRQIMU/yLUPpCVB0iwG0yhhw2nYUZ+OVlc4gCPB3ZqYX/OIWBmt1WW/uKGvCLT2S4G3y8yY9BC56LYRcOnxSMsHhy7R0SpSHdib5MYjawri61EYmf9RFTPBYTQcmrVyfUcCI56jaADDZQCJnX0oS4z3JveasrlE2M7lBsy0Ibdm7vdI34xowj01QJucXV7/4j86TuXeZhUfGFhRvusehST6IGQowcerYwLO8B6fSvGl1jGsqZmTEmEA7/JDAxsHpXlvzpVdhY+WPubEbPkv66v1I3g6QHQlYr6DMD+VqQ+UUzw7urUK+7/i7YKU6vdqEC2EgPsMXI13+Faezl6GddZdD0dwSFWpBxEOKOwrvsHEmg3sR0LDJ7r0SijOGCqN9bRR/22J+8WFSyGICGHHhAtfuG9FclPJGZh5cEMQPuJW6DHPWw4CPFf0NVT0ZBDE7o1NY4d9+zkh+DlF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Very nice, thanks!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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

--
Cheers, Lorenzo


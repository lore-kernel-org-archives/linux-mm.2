Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBEBC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 06:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912DD6B008A; Fri, 24 Jul 2026 02:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C45D6B008C; Fri, 24 Jul 2026 02:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC9D6B0092; Fri, 24 Jul 2026 02:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41B976B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:52:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 798F91602AF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:52:56 +0000 (UTC)
X-FDA: 85022752752.17.C7B0820
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 12E0720007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:52:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qLi8XCCE;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784875974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQh3WG8ZOTKZZc3NofMFyJnBswHsD+BcGu/G7zzwLNc=;
	b=tMsJh2lwSC8qSlXADU1xbq3h2IcmWCnmmk4b0OxHz9OE66HE7brNaDZElNSKz3T5CqDbKv
	Mve2z3+HbLTS27kh+I5GxvQSRd3H6FAauHTJFG2zzSuSds1AL3NytdvFJRcQPjQQNxM+/w
	YyG8Y6YCFMl4p/ZUixYM7Wziyw45yaE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qLi8XCCE;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784875974;
	b=wsilO8jzuAPo3qiTE6ksvGa8bUgpGE4VSd+rGuMptgyuh69E8vQxYr9+uZ24bZp3HjhaRa
	EV892AVM8ipSFmee8Qj3A9rdu6i+9I/C7BUGl8zU4ELwjlACNXHYuOiLYHMQ/RFA25NHeK
	Ictv64piW4UfIsOQne7nuhOmxv1KHQU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FF4A1477;
	Thu, 23 Jul 2026 23:52:48 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B1093F66F;
	Thu, 23 Jul 2026 23:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784875972; bh=nAITBKBOA7eXQfiFsE4Td1VsUBH8uj5AMHgZrnkOQhc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qLi8XCCEoA2LvCejbJTu+56nK5kjH9Nhn2ahHYJXSen00eQmhmXWctwb46aWktEue
	 AEgO5CEge1tNKb0TgDNqeD+FWNJrGd9a8uKt9TQLU4PZ8yK3yqcv4EXCrR7hRhtAcN
	 5n+U7QoAFxaRItNOFpCxt5rXw9kN2n037lhZui38=
Message-ID: <7c8b0e38-f13e-449d-a2a7-de1032b831dd@arm.com>
Date: Fri, 24 Jul 2026 12:22:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/11] mm: add PMD swap entry splitting support
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-3-usama.arif@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260722152043.2273289-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12E0720007
X-Stat-Signature: 9cr5urskebuo4pqa5w1rhka614xrat93
X-HE-Tag: 1784875973-864284
X-HE-Meta: U2FsdGVkX1+mkB88cDva7LE5phEyF8RB7u4FhTMDPwb019VYGW87VbZyKF1dzK+q8nnA58Ffgj8Jc4yjLrmmKwvso67EgvD4JbwK88MhZPBh7r28N17ixyrPf9Zeye9PcW+OznB3wfCQCw9v94k24yp4eQ9rB3y8sPqdGG0uPeB8z9LUlgnTJOdnyr1fvREAcA4xriZnHVH4guICrOyngQg+HXilziEicJIjtFV8vzYLOJPSgwrDw8HGHq4VXBA/JJvcBbYNEeqJ+/XxuBxwF1ejBi/Bomnri8WbgaOlQ7N0046y9e1LDdD6vY60gTy6wf5E/nge+T88/I+AA1i7Gf8ULLK/09vwyJLxy1GEzJeUxGwWd2LWxZevnnq5508qCS2nAbDRmeiLpjzVFPLKrQPSqMvDnmHoQ4d2PD3rlYf2a2cuhvieRvx42PMoSAedeongz/s30cWDZqoLg0IV4DMLNMbTLXzkmVrNuS6HmnRDUs/J22dx8yrzDsTiZpvwn+RFWgxtofirtzyfqfz1RrWpOlPq+xLFHtFk18kQb1L6s9554puXjCcqgPl/rzEcFq8PGZJJFJKTB/j2Vt8VQINvl5SxpBgqGM2QP5XXro1lJFgvtvb4qJHGZPLSEN+piHjBLo8ZNiGnNayABbagKeTuw0oFEbr8nTmeBRygnbU42TIdkjuwiV7pInqaWjRcXBy7qVRxrXxHZESikmZ7bLrslLhF6Zpdbt5MJ5Tni3/7PdPmdlKpWGmHqYpdLLaUJmi6xrI8WliCkJ+C+nhG2FOQfZNw3yIFfQ6BcQDw/mB0VDBTYKKnmWSwOYx7F1rz39mX3Kmenf4dbVYxcnUOVmO1HgGDq626LuT6/0bhwwZHR/s//37HFxlaRQNvh/KGYbPBOqQiP5a5fHV38kJ9QQekAqjK2qdElaPf7EKUcN3q/JX+MmzpVufgtzPpqzUdq1E3TU5K+pqq1rUKuM4
 4BUmpWKR
 9w3UrXXzZ9kWfueH+sUUsJUzJE3t+2XUb8UNiRZ7DxzYubCORZzYVHAsAupOQcKnbNy+wZ/wM5wrrxx8Ti+BlgriDlAiB7zlNOmq0oDt3I4D0E+m6zlbJ1ruEHDYnUQIL4LPhFaTXQ2FgMfHQ8ic/CTH52Fd0uVWRpJFZpcIoTVrP574M78cAt6wA3yEytF/r8Jgtk42/s0WYRMnqCiZzfprd7T3WMo2+Y0WSRhlkx9+riuE0ecSaLT4ZBV+9JGAbK5KNySHPE2R7fEwIJOiA/Bv0D1MNVX9zwLrlKRENAL9X42laSy4gVfvmiSQikoCQQ0+1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/07/26 8:49 pm, Usama Arif wrote:
> Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
> entry into 512 PTE swap entries.  Unlike migration splits, no folio
> reference is needed because swap entries point to swap slots, not

Confusing wording. swap entries need reference of swap slots instead
of folios. I would drop the mention of migration here.

> pages.  Each PTE inherits the correct sub-slot offset and preserves
> soft_dirty, uffd_wp, and exclusive flags.
> 
> The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
> rather than *pmd: for a present THP split, *pmd has already been
> cleared by pmdp_invalidate(), and that invalidated bit pattern can
> decode as a plausible swap entry.
> 
> This branch is reached from the explicit __split_huge_pmd() callers
> that hit a non-present PMD: partial-range mprotect / munmap, the
> wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
> added in later patches when the cached folio is no longer PMD-sized.
> page_vma_mapped_walk() does not iterate PMD swap entries, so
> try_to_unmap_one() and try_to_migrate_one() do not reach this branch
> and freeze=true cannot occur in this branch today.  page and folio
> are therefore left uninitialized in the swap branch; a
> VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
> invariant before the freeze path dereferences page_to_pfn(page + i)
> or put_page(page).
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 04e8a6b55343..9819c0ae228a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3210,6 +3210,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>  						 vma, haddr, rmap_flags);
>  		}
> +	} else if (pmd_is_swap_entry(*pmd)) {
> +		VM_WARN_ON_ONCE(freeze);
> +		/* Swap entries have no page for the migration freeze path. */
> +		freeze = false;
> +		old_pmd = *pmd;
> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
> +		uffd_wp = pmd_swp_uffd(old_pmd);
> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>  	} else {
>  		/*
>  		 * Up to this point the pmd is present and huge and userland has
> @@ -3346,6 +3354,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>  			set_pte_at(mm, addr, pte + i, entry);
>  		}
> +	} else if (pmd_is_swap_entry(old_pmd)) {
> +		softleaf_t sl_entry = softleaf_from_pmd(old_pmd);
> +		pte_t swp_pte;
> +		swp_entry_t sub_entry;
> +
> +		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
> +		     i++, addr += PAGE_SIZE) {
> +			sub_entry = swp_entry(swp_type(sl_entry),
> +					      swp_offset(sl_entry) + i);
> +			swp_pte = swp_entry_to_pte(sub_entry);
> +			if (soft_dirty)
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (uffd_wp)
> +				swp_pte = pte_swp_mkuffd(swp_pte);
> +			if (anon_exclusive)
> +				swp_pte = pte_swp_mkexclusive(swp_pte);
> +			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
> +			set_pte_at(mm, addr, pte + i, swp_pte);
> +		}

All these for loops could later benefit from the set_softleaf_ptes() helper:
https://lore.kernel.org/all/20260723070905.3422276-6-dev.jain@arm.com/


>  	} else {
>  		pte_t entry;
>  
> @@ -3373,7 +3400,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  	}
>  	pte_unmap(pte);
>  
> -	if (!pmd_is_migration_entry(*pmd))
> +	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
>  		folio_remove_rmap_pmd(folio, page, vma);
>  	if (freeze)
>  		put_page(page);



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A20ACD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1C36B0088; Mon, 11 May 2026 03:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992B66B008C; Mon, 11 May 2026 03:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881DF6B0092; Mon, 11 May 2026 03:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75CAD6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:37:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EA0A12064A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:37:28 +0000 (UTC)
X-FDA: 84754333776.24.84E5495
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75E8D8000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:37:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KaAXcaJ6;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778485046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJFWRgopc7X0TxEstjnR5pToJKeydx2wiZHlc7E91OM=;
	b=iBMBuOHL4bj+J67qQNwPhMtDcYbe36B3cgvE5qjakego3lgfxpPmbCTts/pA6ujJCaEGRL
	tgGrvX71JBBYG1BXA/2Ii0Jhq1gi/hTNx9Bpv20445h8rXgOeFFp8NT0/dMJ06fjq4gR7O
	VJAps5ytuk3GYvtd5CQ+aIasEWI3Qc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778485046; a=rsa-sha256;
	cv=none;
	b=2F19mycc4rhnO2ZflDZ7us0V4SNdfbTS/Ve1h+JE3E2JoZtDlys3Q0Wc4o8P5ZL8MNEz95
	yAvysPCGmTbrv763vWUVxRo5vuCseqHzaqpZNjusMSQyR5wR0bn0mdUlCsrncUL6wFZfpM
	i033FMAzqV8oZLvRRdL192K/v25boxs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KaAXcaJ6;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0AD060123;
	Mon, 11 May 2026 07:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A0FC2BCB0;
	Mon, 11 May 2026 07:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778485045;
	bh=FpSA1WDpJHlS8rrqUpx43ZgyVTOLt4z5EwUNCLxqToM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KaAXcaJ6BrbJXKn+9jc5GcmuMc74/jrdsBILvtUqu9fOwO7XhNg9Uj2oF3EnXkZZi
	 rNPcDcm/YL82VDA3zwXDVLfBD+jmEdHGa9oHtn2Cb/UEDXtIZZM+fJfapADXdxVIRQ
	 PassE6RB8NTNHvmQMzzoXwk4hRkakrEfk40GklflCunk2D93yXOuQblNDHvQg0vfXN
	 TmBsl3jpo5LERjZXJrNgbhVQO4qFxDyFrEezRgHO3pRJgxTadsr//PBins24D0YHBv
	 Da7NWE/mmSblYQPTu6sL098oDYOZ1RFFb5A3VmARVZlVeT5sC8fYdEdpZEEMsLjUru
	 BX2gD+9BO/zxg==
Message-ID: <4b36ddb9-c11a-4320-85d4-3e059e67384f@kernel.org>
Date: Mon, 11 May 2026 09:37:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm/memory: Batch set uffd-wp markers during
 zapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-5-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75E8D8000A
X-Stat-Signature: j7nwnqft8wt44qe847zztb66pspp7et5
X-Rspam-User: 
X-HE-Tag: 1778485046-68224
X-HE-Meta: U2FsdGVkX199BqSZmrEdVSdV1sGH1tgMTIlFYmh6qfR8aqVMSThlsl8NwRHA/x/Yp/zlVWS3RDD1gwV3ivvhL5FTDW2DUl8LDGNCy4ItUXTq7SvXDX3TEdtkcdmLIH+kqPlaEfUVjRiEhkEBYA6OR9nhVKQ9t/GWBbsH3CeScsxzQ2Q9V2Iy+MK4PsoZbep+7Yne/SoeEQ8jaYeuVyTYoZRsHZvqZEC+ojR9MY9KAny7MiP/2NwwezYogFsZT5dlWf/j+EI6U7b+W7BzT9GSaLZyCF4nv4O+yk2mv3LFcRYJmEaPudqPDpoVRmzuWG56j1k1YBUlZiZqSVc9Pk1pdpCCYOccuy2WKkDDktxHU04yzwteGPJHVuTBxHlV9xoZU4qJRZf606HH9zvYEe583X2rWqOwJmWPj2VdlGqyENYZsV3AtfqrWoz2f440CUHKeT7jJygmYS4MH6DckwqrDFcTxifAlv8j2v+tsICvb0ODD/MEcFaQkxYSLsKT1u0twz4hxwqZYFG34XtW8Ij6lF1CqW/CE8SzRSyIB1KazTVdFgmFebtqCuKnw5LoWwiKZIyalTaf7kiUYoAcJ3fTEA1JNex1fL8XWKUBPmhQZLvqPtQFhxk6mIJrZgfoIa2QPFMFMQm4mAY4W5H1KrySajrRv7L9DExSAp9waAmkGALc4w4UufOaCtKkN8y15TFHKwUDoNpvsSGWVJQZK/lF3qfeyti6yHRgTE8p8QVb5BwlJKeWARWO7XYU7IgJHDDYnflBFlI7reJ6h2ACclC9G+OvoDf8I7hTgHQ/WIwwRYNd69WE8fva3vxp2JvH3hS5976ujPgNgXaTJvamZhrLd3xhw0jXV1Ieq1gycYloZ79Un2W4mplIVBfGuCUE1bd9lPwmMlZ0GH92RR6dVYUs0dF4XyhmIIq3lPbhJPCOFVSwnV+J2vPMPS6xq0HhBbXlrTa3BIZ8OB2xBnKzhY3
 PzpnICee
 GSkx/AnoZyR1Z91OaNx+bjNTtNawWEqL2eW2nUGec7fdgGwLf1LhHTK0yQajX+EKwxVousp6x3MwojXgzJPi/t3KOEIyw166RhfxFiLLVzBT56Vrl7f11TwJ0L4tJFcR2D/AKO9pmcrrCGEVGtL2I++khTKLGvcj7axKEb8Mh2KXkJO2ARt4hh6WqstxyVa8iWwJeT+/7vwSw4I4L/E8Rzk0D3LFV7nkcwJ1na5QZpF3IDGCp1ovGHS5TQ4GOy5PqArL4DZeutDSQ8S2pW69QePWOrNkHl0o1yx2soqYhSBne7M5VeFi7ZezHwzI7xDXjn8Zj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:44, Dev Jain wrote:
> In preparation for the next patch, enable batch setting of uffd-wp ptes.
> 
> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
> that nr through either folio_pte_batch or swap_pte_batch, guaranteeing that
> all ptes are the same w.r.t belonging to the same type of VMA (anonymous
> or non-anonymous, wp-armed or non-wp-armed), and all being marked with
> uffd-wp or all being not marked.
> 
> Note that we will have to use set_pte_at() in a loop instead of set_ptes()
> since the latter cannot handle present->non-present conversion for
> nr_pages > 1.
> 
> Convert documentation of install_uffd_wp_ptes_if_needed to kerneldoc
> format.

You should mention why the uffd_supports_wp_marker()+vma_is_anonymous() calls in
zap_install_uffd_wp_if_needed can be dropped.

> 
> No functional change is intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/mm_inline.h | 34 +++++++++++++++++++++-------------
>  mm/memory.c               | 20 +-------------------
>  mm/rmap.c                 |  2 +-
>  3 files changed, 23 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a171070e15f05..6f7ecede2fb45 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -566,9 +566,17 @@ static inline pte_marker copy_pte_marker(
>  	return dstm;
>  }
>  
> -/*
> - * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
> - * replace a none pte.  NOTE!  This should only be called when *pte is already
> +/**
> + * install_uffd_wp_ptes_if_needed - install uffd-wp marker on PTEs that map
> + *				    consecutive pages of the same large folio.
> + * @vma: The VMA the pages are mapped into.
> + * @addr: Address the first page of this batch is mapped at.
> + * @ptep: Page table pointer for the first entry of this batch.
> + * @pteval: old value of the entry pointed to by ptep.
> + * @nr_ptes: Number of entries to clear (batch size).
> + *
> + * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
> + * replace none ptes.  NOTE!  This should only be called when *pte is already
>   * cleared so we will never accidentally replace something valuable.  Meanwhile
>   * none pte also means we are not demoting the pte so tlb flushed is not needed.
>   * E.g., when pte cleared the caller should have taken care of the tlb flush.
> @@ -576,11 +584,11 @@ static inline pte_marker copy_pte_marker(
>   * Must be called with pgtable lock held so that no thread will see the none
>   * pte, and if they see it, they'll fault and serialize at the pgtable lock.
>   *
> - * Returns true if an uffd-wp pte was installed, false otherwise.
> + * Returns true if uffd-wp ptes were installed, false otherwise.
>   */
>  static inline bool
> -pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
> -			      pte_t *pte, pte_t pteval)
> +install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma, unsigned long addr,
> +			      pte_t *ptep, pte_t pteval, unsigned long nr_ptes)

If we conditionally do something, what about while at it shorten it to:

	cont_install_uffd_wp_ptes()

Also, less churn in this patch if you don't change pte->ptep

(because if you do, you should then also do pteval->pte :) )

So I'd just leave that as is in this patch.

>  {
>  	bool arm_uffd_pte = false;
>  
> @@ -588,7 +596,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>  		return false;
>  
>  	/* The current status of the pte should be "cleared" before calling */
> -	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
> +	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
>  
>  	/*
>  	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
> @@ -610,13 +618,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>  	if (unlikely(pte_swp_uffd_wp_any(pteval)))
>  		arm_uffd_pte = true;
>  
> -	if (unlikely(arm_uffd_pte)) {
> -		set_pte_at(vma->vm_mm, addr, pte,
> -			   make_pte_marker(PTE_MARKER_UFFD_WP));
> -		return true;
> -	}
> +	if (likely(!arm_uffd_pte))
> +		return false;
>  
> -	return false;
> +	for (int i = 0; i < nr_ptes; ++i, ++ptep, addr += PAGE_SIZE)
> +		set_pte_at(vma->vm_mm, addr, ptep, make_pte_marker(PTE_MARKER_UFFD_WP));
> +
> +	return true;
>  }

I wonder whether this growing function is really appropriate to be in the header
file? Can we just move that whole thing into mm/memory.c?

It's called on every try_to_unmap_one() invocation, but I doubt we care about a
function call here.

>  
>  static inline bool vma_has_recency(const struct vm_area_struct *vma)
> diff --git a/mm/memory.c b/mm/memory.c
> index 0c9d9c2cbf0e0..f14311c4d2001 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1610,29 +1610,11 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>  			      unsigned long addr, pte_t *pte, int nr,
>  			      struct zap_details *details, pte_t pteval)
>  {
> -	bool was_installed = false;
> -
> -	if (!uffd_supports_wp_marker())
> -		return false;
> -
> -	/* Zap on anonymous always means dropping everything */
> -	if (vma_is_anonymous(vma))
> -		return false;
> -
>  	if (zap_drop_markers(details))
>  		return false;
>  
> -	for (;;) {
> -		/* the PFN in the PTE is irrelevant. */
> -		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
> -			was_installed = true;
> -		if (--nr == 0)
> -			break;
> -		pte++;
> -		addr += PAGE_SIZE;
> -	}
> +	return install_uffd_wp_ptes_if_needed(vma, addr, pte, pteval, nr);
>  
> -	return was_installed;
>  }
>  
>  static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bd4e3639e26ed..b17dce752a1ea 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2266,7 +2266,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * we may want to replace a none pte with a marker pte if
>  		 * it's file-backed, so we don't lose the tracking info.
>  		 */
> -		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
> +		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
>  
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);


-- 
Cheers,

David


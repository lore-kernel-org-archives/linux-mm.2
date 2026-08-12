Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A620C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3BC6B00AA; Wed, 12 Aug 2026 04:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB136B00BC; Wed, 12 Aug 2026 04:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0C06B00CD; Wed, 12 Aug 2026 04:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A64B6B00AA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:40:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB7DCC02DD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:40:17 +0000 (UTC)
X-FDA: 85091970474.27.1FCEC86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0D82A0013
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:40:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+rN+Ppi;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786524015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mq3ymkIrw8Hhrm/UKi/Wu+q1hg69GV95D/do+h8U2ek=;
	b=JltFD4T3HROkr5uWGMGE6PRxqA6TgyQn2R0KrE5cHW3MiwX6Vj9imMMdP7wHHVIHfLbjDF
	9Sm45ZZ/uvkMwHK1dtyZ6LmZ5j3R41i7y5Z7BDiWvfnuwnPQT41r4t2963Phk71Wbx7Kzs
	eAlw3b4vRK9AFmGpmwOgIzsP+4siJwQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+rN+Ppi;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786524016;
	b=Cs4b8vbfNaEaBvEQv0+eZKyuIuNvalwgYYfv3kQN5DG8ZibInPcq4qm/14KkrGyY/beeZU
	CZd6zZUUvWPXxDdCSifhAbl40F21IXG5sawPlsnrDIdoo7adl0ZxbsgpvfCurgRbswFv6a
	DdfeKtUKgNTN0+0UFiGLjdG0Irgskxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 424CE61834;
	Wed, 12 Aug 2026 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5411F00A3D;
	Wed, 12 Aug 2026 08:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786524015;
	bh=mq3ymkIrw8Hhrm/UKi/Wu+q1hg69GV95D/do+h8U2ek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l+rN+PpiSAL7Scb3iToPKaF33/sDthF1jRfK85YWdfsTzy56BQJEWIvNxTXtPca23
	 aTYGH2iblyr1eGkIL5V6F9IgS6dqro6sBVLtkTwLX5ZUm+i/RqJyPr7p1IsDzMsgD3
	 nJ3G7uUOCRtHfHTT/tEi2ry02XDGpLc9D80KLty77pZDPhkwCnFRYo0o7noym3PH8O
	 u66nlvIdRxMAAZWYWdIacjzDpSjtLaTqgjyr4phRv5L9u2RfZYh3a8DYGBqi/mq4jM
	 AbLS8NIriiZr6ZEAG6M7PEaAMLU2DViqgB3b4vsuO6kvwVVrcLXifm5ciRI04iBPty
	 R1fl5dyp67e9A==
Message-ID: <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
Date: Wed, 12 Aug 2026 10:40:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0D82A0013
X-Stat-Signature: 8x8u9f8yrnykrmkbdyrugia96wpu9kd4
X-Rspam-User: 
X-HE-Tag: 1786524015-278890
X-HE-Meta: U2FsdGVkX1/gDqKwslWYN/7bwMA/e4MfW/IOp8pvSlBCHY9lPO8uXLeSDZH2n4k3cXuCWCfE9HVbD7Xdxp9868Jll7DTyDJOxj6y8UdFrSHeHcQCdF68Wq5JQpoVptx0Gu5PhGDaguegIcU7EMEl0XqdPd+laAQ4WkdvQXclduyrd6bGq4+NNBDrO1mw73qh5ihNlVPOKj5RB013ymHSKbIbKj7GXf1wtAJI9RgnI6a2LapnJTsLLGzJoqEbbK1ZBzRWPVLaib/EoUAINZERy3kdFrAuetSBdh4SAo2u/yLBnX+w4b2WfsUAzzoy6EqR308F5zdU3kGtyPnL4MydgVa9ug8T8xFTwLZ7Q4J8hwqWcwPstWJrg97CVpiAGzxNngxvxBSWEWZz9CF7ntjUUvhWflUB8diCEJwqHN2RDWPzEhKmsyLBMio9+qVIeuD2Uw3ncgGPyaMlXni4kRzjFqAolr7C17VbIjyXlVutHUlmZgxz5Ue3vCcn8wRTTYIAS0W9VIyOKBs+Jj0z/nyP+zKutL0byI5v8/I8u6LHxuyjKFKSCTmy35KOZ7YIGQx3t++QA5cNkFI0lvssD4kdEvOwKZcmXSTyHw6u7kEYPjekv067JuoA53y5jZOiGHzRwKxVOb2Q9msMJjqRh2BsS/FLxBMAQQBTFBJHWbLn+jWfyh5wyTJZvwbtpAp45Z4l7gGe5BjldW7QRg8vktXSyLtllFTU4qep6F4J6Qr8B2RdM4XUTTkeC4TizzaB+uVGDFPEA5+/mVTQwOKmVlrpSZSdxLdjziHKKmC8lfW/e5NcHDABPqrPF8l0RowFTHkIqMKEUp2w2ECUogC0GImbNw6jgwdlilSmECKpfQLbiSNXhX2H3KHoOXkTlMDOdmPYN8VYJMe22UBZBkowhzgQ8F63oSihl8JfQxmwDVdiUA6HOyQWz2mr4MqWP2PbwzcdjyvebAtUfnkxVDoTWJ4
 94g1d2Um
 OoM3fbt7qGDDkidMLcUV7BBz5PawX9U4ZdhajlAPrZbZZsHCrjp8Yzfms5kx2wh6Wgyh65MKm7+5JVNW3i/OLeDn6jvm3dQZsjXQDQZx6lSyaFEzbsARHOGCoBwH9wgvdSIztzJE0gB2y5JO9IlRHuY83DAZV4Y4pn4Wj1yD4ZxyEb1HVLgFiqdFcCE6ARIWqnlqSWnv6CmViXE4yy4Uz22bw0WC/ZcutFyi2PiZddTwpK9yuQb8Mnm5zra7lPKZ1bUhtALak2UgNeV/PJ40eUHJxN89c4lSHSnTX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
> For anonymous collapse, the collapse_scan_pmd() and
> __collapse_huge_page_isolate() functions share a large portion of their
> logic. These functions both check the state of the PTEs and verify the
> following:
> 	- max_pte_* values are not exceeded
> 	- uffd is not active
> 	- lazyfree properties
> 	- non-anonymous
> 
> Merge these checks into a helper collapse_check_pte() to reduce code
> duplication. We also add a helper struct for this function called
> pte_check_context which allows us to pass the required parameters in a
> clean and elegant manner.
> 
> A helper function is also introduced pte_check_fail() to provide a clean
> interface to set the pte_check_context failure results and return
> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
> collapse_check_pte function.
> 
> Two slight modifications are done to the original functionality. We now
> warn (instead of crash) if the anon test fails, and we leverage the
> vm_normal_folio function instead of page->folio, this should be
> functionally equivalent.
> 
> No other functional changes intended.
> 
> This patch is heavily based off work done by Lance Yang, but modified to
> deal with conflicts and feedback received during the review cycle [1].
> 

TL;DR, I think this patch here needs some more work, and we should not fast
track it at this point.

@Andrew, can we delay this patch here for this merge window? Removing it from
mm-unstable shouldn't conflict with any other patch in this series.


> [1] https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 298 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 157 insertions(+), 141 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 90d6e595d282..b7372aba4417 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -65,6 +65,12 @@ enum scan_result {
>  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
>  
> +enum pte_check_result {
> +	PTE_CHECK_SUCCEED,
> +	PTE_CHECK_FAIL,
> +	PTE_CHECK_CONTINUE,
> +};

I don't love this. "pte_check_result" is a bit too generic for my taste. What is
the difference between "success" and "continue"? Unclear.

Likely, "continue" should actually be something like "skip". But it sounds like
we are mixing two things that shouldn't be mixed (a check that can do more than
just succeed or fail).

Not sure if this was suggested during earlier review, the cover letter doesn't
spell it out. Ideally we'd avoid this completely and just rely on existing error
codes. Like scan_result.


> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>  
> @@ -119,6 +125,20 @@ struct collapse_control {
>  	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>  };
>  
> +struct pte_check_context {
> +	struct collapse_control *cc;
> +	struct vm_area_struct *vma;
> +	unsigned int order;
> +	struct folio *folio;
> +	int none_or_zero;
> +	int shared;
> +	int unmapped;
> +	enum scan_result result;
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +};
> +
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> @@ -696,74 +716,131 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
>  	count_mthp_stat(order, mthp_event);
>  }
>  
> +/*
> + * pte_check_fail() - A simple helper to set the pte_check_context result and
> + * return PTE_CHECK_FAIL.
> + */
> +static enum pte_check_result pte_check_fail(struct pte_check_context *ctx,
> +		enum scan_result result)
> +{
> +	ctx->result = result;
> +	return PTE_CHECK_FAIL;
> +}

Looks a bit over-engineered and the function doc is just unnecessary.

> +
> +/*
> + * collapse_check_pte() - Check if a PTE is suitable for collapse
> + *
> + * Check if a PTE is suitable for collapse based on the following criteria:
> + * - max_pte_* values are not exceeded
> + * - uffd is not active
> + * - lazyfree properties are not present
> + * - only anonymous pages are present
> + *
> + * a helper struct pte_check_context is used to pass and store relevant
> + * information between the collapse_check_pte() function and the caller.
> + *
> + * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
> + *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
> + *         PTE_CHECK_CONTINUE if the scan should continue to check the next PTE.
> + */

Why is this doc required?

> +static enum pte_check_result collapse_check_pte(pte_t pteval,
> +		unsigned long addr, struct pte_check_context *ctx)
> +{
> +	if (pte_none_or_zero(pteval)) {
> +		if (++ctx->none_or_zero > ctx->max_ptes_none) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
> +					     MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +			return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
> +		}
> +		return PTE_CHECK_CONTINUE;
> +	}
> +	if (!pte_present(pteval)) {
> +		if (ctx->unmapped == -1)
> +			return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
> +		if (++ctx->unmapped > ctx->max_ptes_swap) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
> +					     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +			return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
> +		}
> +		if (pte_swp_uffd_any(pteval))
> +			return pte_check_fail(ctx, SCAN_PTE_UFFD);
> +		return PTE_CHECK_CONTINUE;
> +	}
> +	/*
> +	 * Don't collapse if any of the small PTEs are armed with uffd
> +	 * write protection. Marking the new huge pmd as write protected
> +	 * could bring userfault messages that fall outside of the
> +	 * registered range.
> +	 */
> +	if (pte_uffd(pteval))
> +		return pte_check_fail(ctx, SCAN_PTE_UFFD);
> +
> +	ctx->folio = vm_normal_folio(ctx->vma, addr, pteval);
> +	if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->folio)))
> +		return pte_check_fail(ctx, SCAN_PAGE_NULL);
> +
> +	/*
> +	 * If the vma has the VM_DROPPABLE flag, the collapse will
> +	 * preserve the lazyfree property without needing to skip.
> +	 */
> +	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
> +	    folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
> +		return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
> +
> +	if (!folio_test_anon(ctx->folio)) {
> +		VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);

Huh, that looks odd.

That should just be a VM_WARN_ON_FOLIO(true, ..) or sth like that.

But in collapse_scan_pmd() that warning never existed? So this raises eyebrows.

[...]

I'll play with it to see if we can do better and will reply here later.

-- 
Cheers,

David


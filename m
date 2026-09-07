Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96974C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED696B00A3; Mon,  7 Sep 2026 08:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5516B00A4; Mon,  7 Sep 2026 08:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB746B00A5; Mon,  7 Sep 2026 08:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 554006B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E23FD140145
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:26:29 +0000 (UTC)
X-FDA: 85186889298.25.D6985B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2398B4000D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:26:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbOi7s5I;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788783988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmJWK+cr7rKoVtR7nNls8ZjI59fsyuTGnN7RsLAmRR4=;
	b=PjVukyud6bhrp7wvvXvzWvkkmIMSo0UUuxB0asRJlptCdSNorxxym4xhOPvbZchbDELxlQ
	pyZW8JvtsemDXWIfGHKDy1dawxqDw5ANg6O4uy7uy5MCDMNzHeECPLw7qpAbMOeIfkbeS6
	PFhnqlN/U/iReWGl2csx8kRXCVuXMkM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbOi7s5I;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788783988;
	b=E1ZWp1RlKw9k0Cciwo9kZjvVyXn31n/igWYpn4012dvbpmjgu3uT/LKBKLqR5rpFdnwmoX
	L95tvSOsq5r4GcwVLcU+9PRZK0F8LFMEoYzsI8k3M0FLsNCe4liZta/qWjtothVOs/Zx4D
	XswrcUMWi031sZr3eIfzoVfw8Z1ZgDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F301B4042E;
	Mon,  7 Sep 2026 12:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ECF1F00A3A;
	Mon,  7 Sep 2026 12:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788783986;
	bh=NmJWK+cr7rKoVtR7nNls8ZjI59fsyuTGnN7RsLAmRR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NbOi7s5IHW6xh2Ss0fhtBjh+tknCeJlWcd+tDb47dOS1YBw8HZxw9Rdbw42Kk33lQ
	 m7RcqFgb5OBG4vY3PS3Z8zy+Zq9t7UFnbHpyczfnIcUWACwKaxTfSe4ixmvgFg7Tgn
	 ewdBlK8cl5k5gD75k4kEYt/EDgYaraYT3At+5HyprlYiCNtaWbttdV93dH+IYSklKr
	 0LQxIQDhWx+7Xzd5bnVDAF0e/H+Fo6ZvkXBhvfAz9FiEtHzabFP+LE4G+n0e/jKLb7
	 p6FlAW5qCCOH+x2/mFc9olTsEqIrkdhzME7jUIL5vV8hIMfYmkBno2+9jixCsKmKUq
	 MZ3HCVJGwqd0g==
Message-ID: <087d76fd-0e1c-485e-bccb-e3ce074439cb@kernel.org>
Date: Mon, 7 Sep 2026 14:26:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
 <20260828055926.346744-3-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260828055926.346744-3-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k4zfnfc4pcg3qqorc9k4r3qzui5cxka7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2398B4000D
X-Rspam-User: 
X-HE-Tag: 1788783987-218800
X-HE-Meta: U2FsdGVkX1/ERh2Ua5EHqKYkjGFXcI8Dxk89jPLUc5dNtvwJm6ap7HG487qeEdbnVim/liTVLLXMcuveLsfRA5ptghUFvTEUNKIdxm9DtB1EMyeApDpUNIHYT62ngRvtKhP1utC9G51mNQB/xYAlDcQxfgGJa2DcLGyTcH0d4uHF+wGvMzhsBSp0u4GyIg8dJU+Rvp5UE7eb8DXKHvOs0rErna2xptxj0gVggl11/VC0hJuYEj8ipSIoMq4Wc9YptKimod85bkMAeVCGfXTLgGebsGof/Fy1rvnSGM3Idsvxv8bZhvY1eK+ClR19x0+pJcvyaegARG0DjHw/lFL+F6e0A+5BQbtCmW2DYYRt4qDOMmH/TYLw3OeJnoRof9oeX15JY7PSuCjEaxjmARAMV9+Q+nInqHcEBE3Xi7raNYqq/KADsl8EU8Q67An/aKZiT1sxPBjZLyCzU9wQYYY439cuZph0fOVTLWxYfutCr5ViMXjd4FnML0Xq4JNPkkVqQDrmQimPAteBwz500TAcn9jpGv3fuAieSsCXMoad39j6kAfgd812sQncj0xfOuLQsP7nqq94DRw77CzOnbmrPmarnzXAtl8ejmMrl6DyJMT96IWtGhLYu3ZygKL/KQjCB9Pw1YzuezLfPMMmYYgDtdJ4OzAs+yB1NG/VwQJEAXC6A+da0P1NF14h/1LuIctuaB/qyC/klQtwihZv4z7vIBh+yP2UK1TsbcnHLoScfcjEEjEc7jxdYQ0BkWm76enxnx/ufT2CsSP4hA+Zofy8yoooBFk27Rj1EAXIdwX9S2LlK0Y5WYlRoTJOP11TWRYWcWgoLel9oTMnHgJr8629/iFVM97ywlvNLVlGofRCu521nsVoL3mN4Wch0GQtwTdk4qqrvXM6C/SRuQWDZiamVze+4i/mb+rbnl4gEhrgDdFT+gCdGBLjYrqozBqMAlx7EtmhnXOeU8bfBpzZHH9
 sVeOFvj/
 3d2+04Rq7qbQuEko9vTc/v7qv+2HgBvXFoeYZFLBH4g4lmNE4uxFkwbSR1NaCXGQv/G3A4OghY4HRrlQ7HMYYeBhDbgdi4Z3qTF55N5I3EkmacgVNnkd7/UMB9VLtfVkNaCaAXhJTei8OIRKV54Abh7GRoJpw1TU8Psk7QKkRNgeEFG1RJ4IwGAJ6lKx+dPg/jrrCoveghZmln3UxRZC7JKouDmPCv8iWUmAVQd9wonS5B6KmoSo50idmUaJnUkOKIgQrcCMaI1SIZ6fszciPYn5TbGeZezP9Euo7ze7hK+JroQoM3vBSpn9n6TC2zVQ/WarCN6p89vDSDmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 07:59, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> After the page table lock has dropped, the folio can be freed
> concurrently. The trace_mm_khugepaged_scan_pmd() is left with
> a dangling folio pointer.
> 
> So using the folio_pfn() before dropping the page table lock, closing
> use-after-free window.
> 
> And other pre-existing bug, When the `for (i = 0; i < HPAGE_PMD_NR; i++)`
> iteration to terminate and the folio operation preceding is normal, but
> pfn will be incorrect. so we really only trace the PFN if it really was
> problematic.
> 
> About calling the respective trace_xxx() functions separately on success
> and failure, refer to [1].
> 
> [1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/trace/events/huge_memory.h |  6 +++---
>  mm/khugepaged.c                    | 17 ++++++++++++++---
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 7b526528f85b..fa828967e1fb 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -55,10 +55,10 @@ SCAN_STATUS
>  
>  TRACE_EVENT(mm_khugepaged_scan_pmd,
>  
> -	TP_PROTO(struct mm_struct *mm, struct folio *folio,
> +	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
>  		 int referenced, int none_or_zero, int status, int unmapped),
>  
> -	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
> +	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
>  
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
> @@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
>  
>  	TP_fast_assign(
>  		__entry->mm = mm;
> -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> +		__entry->pfn = pfn;
>  		__entry->referenced = referenced;
>  		__entry->none_or_zero = none_or_zero;
>  		__entry->status = status;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b597a3e68606..4d360ae87769 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1612,6 +1612,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
> +	unsigned long failed_pfn = -1;
>  	unsigned long addr;
>  	unsigned long enabled_orders;
>  	spinlock_t *ptl;
> @@ -1706,11 +1707,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
>  		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
>  			result = SCAN_PAGE_LAZYFREE;
> +			failed_pfn = folio_pfn(folio);
>  			goto out_unmap;
>  		}
>  
>  		if (!folio_test_anon(folio)) {
>  			result = SCAN_PAGE_ANON;
> +			failed_pfn = folio_pfn(folio);
>  			goto out_unmap;
>  		}
>  
> @@ -1721,6 +1724,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		if (folio_maybe_mapped_shared(folio)) {
>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
> +				failed_pfn = folio_pfn(folio);
>  				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
>  						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out_unmap;
> @@ -1738,15 +1742,18 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		node = folio_nid(folio);
>  		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
> +			failed_pfn = folio_pfn(folio);
>  			goto out_unmap;
>  		}
>  		cc->node_load[node]++;
>  		if (!folio_test_lru(folio)) {
>  			result = SCAN_PAGE_LRU;
> +			failed_pfn = folio_pfn(folio);
>  			goto out_unmap;
>  		}
>  		if (folio_test_locked(folio)) {
>  			result = SCAN_PAGE_LOCK;
> +			failed_pfn = folio_pfn(folio);
>  			goto out_unmap;
>  		}
>  
> @@ -1759,6 +1766,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		 */
>  		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
>  			result = SCAN_PAGE_COUNT;
> +			failed_pfn = folio_pfn(folio);
>  			goto out_unmap;
>  		}
>  
> @@ -1782,10 +1790,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  				       unmapped, cc, enabled_orders);
>  		/* mmap_lock was released above, set lock_dropped */
>  		*lock_dropped = true;
> -	}
> +		trace_mm_khugepaged_scan_pmd(mm, -1, referenced, none_or_zero,
> +					     SCAN_SUCCEED, unmapped);
> +	} else {
>  out:
> -	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> -				     none_or_zero, result, unmapped);
> +		trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
> +					     none_or_zero, result, unmapped);
> +	}
>  	return result;
>  }
>  

Same thought

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David


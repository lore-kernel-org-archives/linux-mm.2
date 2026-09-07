Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A9CC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59336B009B; Mon,  7 Sep 2026 08:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A4B6B009D; Mon,  7 Sep 2026 08:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9146B00A3; Mon,  7 Sep 2026 08:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6F46B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A637A014B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:26:05 +0000 (UTC)
X-FDA: 85186888290.28.B99BBB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E53880004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:26:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M3/tt1xb";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788783963;
	b=7PSl16um3j41nwSCLs3jAGrtfWgWWTSbW5SVfbDlZyaUr1xXBrFn4ZxegeqmOweVGSLNh2
	LOJb+SBhWmQsazg6X7dXXg4wqnCZ2XlsW5H5PhvtUSoap8GaMgJT65pypccDSs+WKERiG+
	0gv6Var0XVZWgQtH48V8ugcAE5eJEUE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M3/tt1xb";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788783963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khFAlLB3IE9nHz5wgfKxVmeFcDHKyAwXXbXcSPy92d4=;
	b=A6D7hs/sMAnp0hFXAMj/r2p5+t2r/QvV+9D3AbdlOKm6PY8aFjvwytoBqzgvFI18pHe7sy
	rg9EwKVUmfuCWB47v1hBP9ccO21OBlutZ3iFUfamS7LbmwhtgUVcmZwV8hMGKxIFgvx5xg
	MO0QgZ0PxPRjgpTEJqNOxczJXUND8Wg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 001E3601F9;
	Mon,  7 Sep 2026 12:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104CB1F00A3D;
	Mon,  7 Sep 2026 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788783962;
	bh=khFAlLB3IE9nHz5wgfKxVmeFcDHKyAwXXbXcSPy92d4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M3/tt1xbUroc0tnLm8UfmiJG4vFvuRkj3HlzlzSU6Z2rP/ZRKVr0VO/am67MU/DOm
	 0infuQjOeYcSJ5oDpXmCCveGVc7y90pgw3mAAXAlZ/8PuR71GDXiLnfSVBDwGZEXEK
	 37VuLhqPawUKwsMgtTI5Tgt3R/Efv7hdyQe70H4x7VOGTwkO/wrtd2pm+7lxWGyqgm
	 tJ2UcP7hiBJala6NQL7RVG6THLmKiGZAsYrf0Gkj0XkoVsKtu/DqS1QSa9C/vILm9r
	 IAs3UC0pgDD+8cHta70g9anwqodk0QnKpCJvjtEvqs3wmcqIiapTSLLBbBBcdKq6Pk
	 FiBqy5ji2Me6w==
Message-ID: <53f3afde-b5a7-4c2e-b6b5-8c844d1b6c8e@kernel.org>
Date: Mon, 7 Sep 2026 14:25:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
 <20260828055926.346744-2-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260828055926.346744-2-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9mmqfehj7fdiqgseibkykmf3hg4pykzk
X-Rspamd-Queue-Id: 7E53880004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788783963-958675
X-HE-Meta: U2FsdGVkX1//9+RQHAAzLIt3RDOVfjwQQql7HEjq8xSjjNn8GcfriV4LqSUAn1jEvFolBVqPQMgKSJ3qXwCGKvbIWKWgh81fyVhS266sbzd58sj645sETh+mBD8fjn9hHr6jGlslITyDj+LyoMSpnsXEDFu952DJvmE7nFOLElWKkR6LEkK1IBIhCu5UIE2cFpcVoOUk9lCkOfWBC9zF2XxFabVm+bL1E1epp9zAntVj4ZqCHce6V9ouwARbRfWa7lzXNEs+pKwl0ZLdWinCaKg4NaAE7GpjdGUdt6V7o0elCjrQZDHwSQIQt/ElkXa8lpsGO80K9YhWyRe2/auKaHp495o7BVtU0+TzGrHKw5J34LMAsHZTQqYYnH6CUZiwUKQXCnzsX/exiJ46LZXOz/8jT9ufiIzKMEW3HJ6qTQBN6Tqe+FxSlx7utivDoRA1nzjG0U0iKCvkVWdZ5HhI6KDDoxcobCwbIX80W9Ke6+/3VdrMUqcDeuVpSl3baPNwZ00TMVY0gkhYfZuZv3mjy9KQoNRqyGbqsAFsQFd2mfjknl2soeOb6arWupSAM+TVLUJC2sDeg7VeI9y1jTJx1fy2O8WzrWv9bl3XfImQnFqlgkrCBFJ8rqqTykKvQ/etIKkVc3qj69tDLUwWy00Twfs69Q6AV2VZG7vtfmiLQcwKzXQ+Ica7bgComXgyOI3kgwZbjKBLQnxCbqZ/8xVukxbS7Bv7K89tILrY6xINez8OoDSJuWdNinUlRI8OiMR35dN/mZvvXcLnRbvQ7gMcuqW/iT8pBM7NumQcZvGOJNQ3ZFSE0CemtLgzAdZnfQ2zI9g9azLM4sC3293LXNJ85KZE1eDWh3PsamUPOVDdTdNPk1fxsNyfQvsf2vEQ1BJDRnsFIdRBLI6MdHSxs/nb9mMHZQVt5YkTb/U3rr+nGawPLjSn2ybDSlWhXcNyYpxNtds7fhofrWruEgewEj2
 6SPWwuT5
 KLT186rIkYb8shSxgtxy3GPoRbi8E46Q9xGh6SQ7/f37mgvfZo9Zs5VG5R/XUlTN/zvIz3nmPVbDKJJvGlSdRwGDPBKJHW4RpsNwHDeEy4yvSQkL7eLOqri/3jcwquFTUxPpm4B2i94nCoJhR7reF9jDsCyQjqevcYrro8wCxFz+6m3SEuj8uqncH9+CjqNluKR/M5FGHKLfNd7s5IuP0Dq8Y0rugXl/bxdOz7G3q3WbXygczMTqR1p9RKongpVc4n/W/js6hrfIz0vrks4SiaowkfiElpHZtulRrhySDkD0MQbRtauTznRrdccgWokJijUSSvn4Uz0Yxc+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 07:59, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> When the swap entries found exceed max_ptes_swap, the loop is left via
> break with folio still holding the xarray value that encodes the swap
> entry, not valid folio pointer.
> 
> That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> plain pointer arithmetic, so the trace event merely prints bogus
> scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> dereferencing the tiny encoded integer and oopsing khugepaged whenever
> the trace event is enabled.
> 
> So when folio is the swap entry value, simply set pfn to -1, just like
> exhausted scan naturally.
> 
> And the folio_put() has maybe dropped the last reference of folio. The
> trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> so using the folio_pfn() before dropping the reference, closing
> use-after-free window.
> 
> About calling the respective trace_xxx() functions separately on success
> and failure, refer to [1].
> 
> [1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/
> 
> Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/trace/events/huge_memory.h |  6 +++---
>  mm/khugepaged.c                    | 11 ++++++++++-
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 5a48c5406cce..7b526528f85b 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
>  
>  TRACE_EVENT(mm_khugepaged_scan_file,
>  
> -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
>  		 int present, int swap, int result),
>  
> -	TP_ARGS(mm, folio, file, present, swap, result),
> +	TP_ARGS(mm, pfn, file, present, swap, result),
>  
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
> @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
>  
>  	TP_fast_assign(
>  		__entry->mm = mm;
> -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> +		__entry->pfn = pfn;
>  		__assign_str(filename);
>  		__entry->present = present;
>  		__entry->swap = swap;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 75639298efc2..b597a3e68606 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	int present, swap;
>  	int node = NUMA_NO_NODE;
>  	enum scan_result result = SCAN_SUCCEED;
> +	unsigned long failed_pfn = -1;
>  
>  	present = 0;
>  	swap = 0;
> @@ -2715,6 +2716,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  
>  		if (is_pmd_order(folio_order(folio))) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> +			failed_pfn = folio_pfn(folio);
>  			/*
>  			 * PMD-sized THP implies that we can only try
>  			 * retracting the PTE table.
> @@ -2726,6 +2728,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		node = folio_nid(folio);
>  		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
> +			failed_pfn = folio_pfn(folio);
>  			folio_put(folio);
>  			break;
>  		}
> @@ -2733,12 +2736,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  
>  		if (!folio_test_lru(folio)) {
>  			result = SCAN_PAGE_LRU;
> +			failed_pfn = folio_pfn(folio);
>  			folio_put(folio);
>  			break;
>  		}
>  
>  		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
>  			result = SCAN_PAGE_COUNT;
> +			failed_pfn = folio_pfn(folio);
>  			folio_put(folio);
>  			break;
>  		}
> @@ -2771,9 +2776,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		} else {
>  			result = collapse_file(mm, addr, file, start, cc);
>  		}
> +		trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
> +					      SCAN_SUCCEED);
> +	} else {
> +		trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
> +					      swap, result);
>  	}

Just curious (maybe Lorenzo suggested that?), why separate out the SCAN_SUCCEED
stuff?

When result == SCAN_SUCCEED, failed_pfn == -1 no?

We set failed_pfn now only when setting result ...

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


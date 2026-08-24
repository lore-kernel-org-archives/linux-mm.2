Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60D5C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32656B008C; Mon, 24 Aug 2026 07:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09A56B0096; Mon, 24 Aug 2026 07:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC5C6B0099; Mon, 24 Aug 2026 07:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9968E6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:54:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28951A04DD
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:54:27 +0000 (UTC)
X-FDA: 85136005374.29.283D330
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E831180004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:54:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giNddQIv;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787572465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KArwytZC5OcI2dxvXgYHTkLKrbYoCCTeXuJL++REIfc=;
	b=7gJssYxjyU0EyNk5AP71I5GFoYTx24p+ThNBichNwgWlJYAKx53vMFGzVTiPu9tbOBRD4N
	j75WpAIze9coQvBFANYwgxl3EjU8frKlXcz2AG6VEhZ4Po1kAAoUo00SBJVNrHsK2EJ7V3
	ymw0ihWBQXfUj38q3d30jGeZuoZqi0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787572465;
	b=JorAPEiqKssKlJ419OMDPnk4jrM3hw4qyaxdVG72WarhqNojGVxYqWu0w9ybeXJaKG6P1q
	fcgokUbtesiqIFZOdikhy4lXWPrFsuToBz0VsgO0fJ/QAdjIbbqop72iAIIqzy4rHPmjXr
	E9/lOG5S4BPppMdmKNsjRrhKZACrZec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giNddQIv;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6950C41154;
	Mon, 24 Aug 2026 11:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176CA1F000E9;
	Mon, 24 Aug 2026 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572464;
	bh=KArwytZC5OcI2dxvXgYHTkLKrbYoCCTeXuJL++REIfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=giNddQIvq5n+6Y/ovLVoiMXGw+vC31sbzAXxS+79oI37cKH+MfEG69hBEE6V4CxWP
	 UBeMfIkVtJqowo49ONLGca8U0OWyINxuPDYloHBI7bdklVhNA9/8h9YSR2eDzqHqkA
	 V61c4soGSwjWNndnaZE0mnW/VC/JuFFfCB5iv8CNb9ahuOuEfE+qOjL0TI2q8RSx28
	 /7zT/XrAjia2djP3xMqO8rChxjaGLNUb+x3xz2Xr/cGE2JdlH1ucQhXqCwRJPXmtyJ
	 h97eMMoSPaA7Wghkd/b+OI3eV9C6tLQjCm5xuhsgo2LDFB3bjQrFgISPnu4mL7V7ea
	 YEQb02/55UeRA==
Message-ID: <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
Date: Mon, 24 Aug 2026 13:54:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260824092935.73892-2-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: c7rjtu8gxe8s71kkzey8gj7xnzrnefax
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E831180004
X-HE-Tag: 1787572465-341553
X-HE-Meta: U2FsdGVkX1+cE0U3+ZjAjfqgx+yjvFVlIFPNpp2saGfBmmTqLRGVx0WjDyG5evL7od6LTsxxW6i7LA1WRmzxjTsTBfWc+eO6Q2p/Mhdwzau4B6qSmiFZpZZ3IVkeeENiak0mMPc5ve0sU8miv7w2uZzT6+xAz8ZE1tfnyJpcEzEEZlnFWebiakV7tHN6Q4uXesN2SJ7pK05rIMlSAcarLjGpM/POsAmzK2wwkkhIoTHh0ODtdAZWxcmMkR9nY8efrj5796ljfdZLJp3VW9Ao8j/H334ESwXpiqqAKMNPqcCXVkHdBHo4rmHiOaJQo+mLApfuwDtd2oig8YCyZspus07CoL6gnRSLeq1Rb6bUUbgtugQ9YWFg5nfeF9ds8l4/26MESXOvOu50X0mpAb2y6lNFt8Sp+EvzRKAoOynph12yamreVqjNtv7uXfAkwd+cNv249Q8eHYy7+XAX7HxOjwAQVIHZb4pkpGNHWjjuZlqYU1NF0IjIJaxkaKe7qBZY6T3wKZvU0hCtbZ60cPYg/UsXRa0i+CClN01j7ViXx4XpQtw1hmKxyyDRYD9dYabFRUHN/YQH64yaMz1Oe1Jat4Y6URpOxZ5lzBMMLXtjZjhT8s7eXQRZGVF+XI7G/dcIgpgqDnmI/0Zr+vTQh0cqiy1B41KKJCyuHujxWCFqEi3qL+Ieuw9Q5PKiC56Ep2+naRQzv1JK3yqHw8txIF1ITwZ0BLQdYMWlsDM2V9fYWB+xei61WSOFo70ZxiEefWD/IYYiahuQ+KCp94nYhEQH3XXeYGJvVUA+f0kgsoFSs/a3BzauLy9MInppokd6vb5CY0pVIRDsN69IkwDPuOs+OAk+JNxX7KWgryUoKIRmEYyMZ7OkAs2BugAsUpaPUQIveAYfHlsan9JTsB2SQW4qlyGG69pB+1RV6bwY6rviy+qefTC/eMp/uCVRAMbYXtlxThXPoIbA0wKXJ+fl5tX
 89ZWfKit
 2okyDFWOCQu/Qf2PMcohodbmgIHNjjHZxNCzPI1DlNByLalspgJKLgHTzYh8s/C4rY2fHtQN5uoj+KHEzmbzFECtE/MZIdPZyPJQEQP4Q55olJDfxSEWVbgcu0OM5b+WryxVuk885+45H92DlaSBtTM44XRB23xrdA45QFNTunYwgMEKphC2oK/ZseL60dnHQVQTbiPqRy70M0cH4wlHC8UVDj9FiNifrmx9zIevV3skSHz8d4m1/kF6L9jnkCWL2yha0bMA1vUQV789pXiRolJ4giZajLoAcnXgVzaS8tQhz80xMFLrAvlT15LJI9Diwt/vdp5HfGcGtkzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 11:29, Vernon Yang wrote:
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
> Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/trace/events/huge_memory.h | 6 +++---
>  mm/khugepaged.c                    | 5 ++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
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
> index 79effd3f3da4..00337405c0e0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2689,6 +2689,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	int present, swap;
>  	int node = NUMA_NO_NODE;
>  	enum scan_result result = SCAN_SUCCEED;
> +	unsigned long pfn;
>  
>  	present = 0;
>  	swap = 0;
> @@ -2719,6 +2720,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  			continue;
>  		}
>  
> +		pfn = folio_pfn(folio);
>  		if (is_pmd_order(folio_order(folio))) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			/*
> @@ -2779,7 +2781,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		}
>  	}
>  
> -	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> +	trace_mm_khugepaged_scan_file(mm, (!folio || xa_is_value(folio)) ? -1 : pfn,
> +				      file, present, swap, result);
>  	return result;
>  }
>  

Shouldn't we just reset PFN to -1 at the beginning of the loop (and set it
initially)?

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D072C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D576B0095; Wed, 26 Aug 2026 04:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445156B0096; Wed, 26 Aug 2026 04:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381C96B0098; Wed, 26 Aug 2026 04:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 206C36B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:13:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADE661C1805
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:13:00 +0000 (UTC)
X-FDA: 85142704920.29.5873951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1A1E41C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:12:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PWUHJOgz;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHM+KLGJhKONQ8oZCL9USP5IfUiOqstnnbJ6mUwf/Kg=;
	b=2xWoMwzJ+KMYOa6xWu4zY1oK/qLNruZxq6tngav+l2zLBrQHdjdjwOOEmxIJJs70nqVFY6
	OUQYQUWAjYQ9Hp21SYQgljiDbY5BT3n7XC1hS5suE9mX3wMokpe4p0UEHhOFoYpzl23PYG
	fWlsTrb15lv91RKLMIhNTOwKGrz06y0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731979;
	b=VBeDxP5qfPqWdEyYcqjd/6RuBXIKed+3EOA0+cpLCohnxIzd8ol1B9zRklqc86rfX/G80a
	uAiOrcBhMYkoVOU2HmeBWKsk9RoOoZYZl6jnFaCuUqzOcylBcyhXaeCJORdAWP93lkobPu
	auZArhTnC8/p2VuM+bt0LWfzi4l9lLM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PWUHJOgz;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DCD160A59;
	Wed, 26 Aug 2026 08:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98141F000E9;
	Wed, 26 Aug 2026 08:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731978;
	bh=mHM+KLGJhKONQ8oZCL9USP5IfUiOqstnnbJ6mUwf/Kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PWUHJOgzhS85nKK26GiYPIQe1YdM9KPHP1BRkbXQ2o/tdh3h4hIqfKbYMR9IKXrmt
	 8lrSbafX0pmxFrgpA9jz6ujqod5rhnUBj9ZpnRNz4YBZvvyMh1E8b5EwLfS5Dy0jyc
	 ckfHPIGBZ5af14FWF1sDnBJHKUnyZW6V7dXI3zQaZBjQiAVyWt6r1Q5vtA9pTsC0j1
	 98p7/RD/+eD5Cv74Y5f02K6pr97YCSlJcxyVwq6PyP5gekKI4yjwWKNg3r2IKM7ZFi
	 cLuDKNNVcJtehBhf/GMuNKjY6YvDeM25NlfpaW2j+HGCwDAehn3Qu8iJfYvSrJt0r9
	 Qa6RlyaKWzqtw==
Date: Wed, 26 Aug 2026 09:12:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <ao6f4773bhQb-CtQ@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-3-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824092935.73892-3-vernon2gm@gmail.com>
X-Stat-Signature: rtiicngtpyno44f4jio5pj98wrtcsco5
X-Rspamd-Queue-Id: 1A1E41C0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787731978-249678
X-HE-Meta: U2FsdGVkX19ftIWkVsuWq6qs0g+WKOcgoJUfyPLkO7u2fCUMJpVjC1VhO+s62td9fmKXxoHkxG+ZBPdGrX3Ujxms1Lkq2CbS3wItz7xHK3rAZI80pgPaID2t4JqWKA2k/nMR7kATln+fFmSxMdm6eKveo68ouMjk+9iubjSeMRaJ8IzN4PvQLCwfWPQnvoUhQPp///XHoVFETLv7/xssFKt3K/RSGVDOv/ZggaOsZpfGeBG6lI1Iqa9T9DyMl8SlPfGLe6o5RCeMDz1Vd4WVmaAEZEmm19LXXS1eJGoMfG2dsZFK6DgyzDje0AD9/AGCvWGXVYV7/wGkh9417+chTPQ6CiIzXQPhwQ4UD4sx+SsyU8RNVMa92w4KBYj7Wol38ZpXFM0bIFlxpJvCr0VZol4CTeULQUVE/wmcTtKE2m+X00dEtRCfF5SaHDJZmAGwzQXdnJaWCK4KPoC8H5QbczrcdBLryka3O39cJpjr4u3249vGKRvDNY7NLWd6HkY1RWT0W+onCEERjPL4QfXzM9cEDd11rvRIFOInz1/Cfe9vL7fJ0AN23rprkx6i1T/kjbsRLb+IzgGhVqjolob0JYUoRqTJywFnUGh1NW3FokcAIM3mpSjJlj/MNvCTItH3rICJlVcqjHCb0YgCy+RB7/R9PP+NnJdAas4gotUibvzseYOD7tCxHeBQG+DKN5VlM5BEYgpyJNxXXgXo2RHwV4s3SKgGpK5oOpeENFZu51UNZOhkqwajoeqldvvW8tzkY/ggPlD9f/50NRN2dQFnxCLEFwx9jMcgW/Q9ISxoxtA0+KUISuQusW2/Y+kGTmjbDNScwMXuhGPJvpXqKy4YqUAAA/8zPKqpOQDcjP53P7FOjHGNEdC9xKo0tx2AajSL+dPqizFajUHyRnlOSald6hoqX+vYlo4H+kRSDNGKE8RB2Gp0pRhqga9Ztlwrsfmst5hiRohuI7SvWy870IY
 QlsQOqi3
 LDg1L9u+UU9oo7DWxn3Gvrrd0iaWy/xHD33J0CmW6xt/L6Wp17wSUW7Az2IE2r5JDUMYY1d7fzJd4yCuhybE+L+/NwI+mKtMJdWuGwsP+yjSfcSVBduFJAg/d0kmzVAQDM3soT/GvSf6twZuoLV+LMt16XzgJuSofYamKW2x5plJqM9w1MoUvPYctRgEuxXhF0dDVYXjqIr/w3TaqZepWctVnAo7oWt4QvIB9ER6+wx8J+GaXknO1pRzfZeEcu9ABDuNzIcHBTbC6oVUTWbemlZAtkeeajK3X/mM9pYlGzj3M6uaVtO2KwgG2RM9pmXiOti51
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:29:34PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> After the page table lock has dropped, the folio can be freed
> concurrently. The trace_mm_khugepaged_scan_pmd() is left with
> a dangling folio pointer.
>
> So using the folio_pfn() before dropping the page table lock,
> closing use-after-free window.
>
> Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/trace/events/huge_memory.h | 6 +++---
>  mm/khugepaged.c                    | 5 ++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
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
> index 00337405c0e0..4e0fca5942dd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1618,6 +1618,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
> +	unsigned long pfn = -1;

pfn_t please.

>  	unsigned long addr;
>  	unsigned long enabled_orders;
>  	spinlock_t *ptl;
> @@ -1780,6 +1781,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		result = SCAN_SUCCEED;
>  	}
>  out_unmap:
> +	if (folio)
> +		pfn = folio_pfn(folio);

And +1 to David on ensuring this is reset to NULL appropriately.

>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
>  		/* collapse_huge_page() expects the lock to be dropped before calling */
> @@ -1790,7 +1793,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		*lock_dropped = true;
>  	}
>  out:
> -	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> +	trace_mm_khugepaged_scan_pmd(mm, pfn, referenced,
>  				     none_or_zero, result, unmapped);
>  	return result;
>  }
> --
> 2.53.0
>

--
Cheers, Lorenzo


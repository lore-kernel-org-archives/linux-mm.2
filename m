Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 799A8C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702526B00F1; Mon, 17 Aug 2026 12:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA8D6B00F2; Mon, 17 Aug 2026 12:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AD46B00F3; Mon, 17 Aug 2026 12:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8026B00F1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:12:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DD2F807E1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:12:18 +0000 (UTC)
X-FDA: 85111253556.02.58789B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D7C3C000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:12:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMzJBZll;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983136;
	b=Uex6ied6KbERwGRV4DN7Y2McX+Prvu3HtRV+NsL57+pZe605Sgnbmhhu+oe0yts/JVlMoU
	tluv6iSYZ3aP9+G+MoeQoy3H2FGgW3OzvUxBBJutrji9xbRpWWv56PlS9kRgaBGnaCV7T5
	C7vU+gHO6NzGmn7NAcCxQVvn4xG9+YU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMzJBZll;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQUvrkehKpwo8jNXcs2xc61eh0IJJnnFxqJq+fJqvow=;
	b=K6Bgog1O4oILJXrKOENsZELHR6VNp2DlBToDyiv0rrZf3PRbuMugPZH1hio0z9YwncQkM1
	PNuFV/OTfOA0GPn1OAUH3mckKNhQb/gl8d/N5e5H8YPFhtyMA043ZAWF2uUxxUIoS8oHtX
	Vy/eUb8PonfHREnRqDSfldAkxrP0fFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91A35409F0;
	Mon, 17 Aug 2026 16:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ABF1F000E9;
	Mon, 17 Aug 2026 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786983135;
	bh=FQUvrkehKpwo8jNXcs2xc61eh0IJJnnFxqJq+fJqvow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CMzJBZllxMo1S2XbnPp2+ODTD9IPmNxlpBKWEemO/6ae+sZK+yiC8J1YN2t5oLDQI
	 zykM+NdAwk/Gm2M1oBQqTlZDJMXMHTRDHj8Eix49bl/yj9DHUNwS3f7wNDtKiacYNz
	 lfbYgrzB4XALIVHOZs2SSzfwSvmKM1ZgLGzaa5BbjmON4PrTADLdblHH1KacPLVnpU
	 5Pq/alv6hVTGv6eIQdLLz4bJ/wDVsNvLNmXbOY4w6JP1V4f1zli5fkXFI3p1Vndej4
	 494gx6ntrO8yURjrgPHQsPXVJBl7IVRIcWUlYL40rjIDDc3YMkmAWuCCV7Zxn6K9qn
	 Icya7Qcq03yvw==
Date: Mon, 17 Aug 2026 17:11:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <aoMynfFI2XK2UXXN@lucifer>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-3-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815051924.194810-3-vernon2gm@gmail.com>
X-Rspamd-Queue-Id: 6D7C3C000A
X-Rspam-User: 
X-Stat-Signature: 5hu3ampa4inkps8w9pp11yxqfpchm3tz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786983136-147813
X-HE-Meta: U2FsdGVkX18h76nE0nlwotjJlF8GITw0EV2J6vg4h+evWshAXc+cQoWlxxj/ZzC8eGj3hGxHmNCq0VPTmwSfHcUEwkGEVH8gOUq7+dh/P16DAs0m0EfD/poQ93yaJ5ZjqEJ1MabbU42isY25zmXyF+h4U5Z4Tin/xsXn/Jil2rjHnFUDi02IrSC1speevVl1G3MU1g7KGS3quDgg7HXBWiaTHRdWbh0vaasSxQAek/zj3jcfE3/lEpjAALWpOX3ISHK3IAWqCcXEFnwZ+mvRrNF8F/4g3TDr+ndeCLVV4dr2u9zNmPrUxK/wxYByBB/Az5Pj9XqT0Z3K6j/pq0CyUg/XwYu700XxJHnGKFzOBgTYaRn5WKcu/UQvIecfYfxITQJwrLCAB3vIImEiUJgah5Ln/95lboRS4jViPFpxQBYOV7K3m9GSEUR4oW8Xb/DMJuYNFB9hH43hYF4dypU85InzpaaOrcsyf7AmkN9ZLjX3dMtkgvX5tBHv4Xp+xIXTDPpSr16NqrDuk6OeOcpAUGRWTri6MeIy3Efa4tlLIkqR8STiy1BiSy0NGCFWpB+2C/QhY5ccgkNCESFPxgVnkmYrHI/Okd6vv8GfIm9MNfAGD3nqiuFmlS1WWO9PedTc09Ox1hspekgdF3ONzB5mHeAm9fKXNMws0jzuc/4FUxTboVa+/ig0ZKb4oBTP7R4UOQWD8PXtekoO8Cj6n/ifteRTI5h6hZm0xxJglJGe7q2Zc99XCBWzV4nQH9b9tYyME//4ymYMCwvzEzVZk9GsBsL6XlxmX+amUdNyc0Wc39ZRj8+MEjnRuoeZSlV9b4DqGcY7zGdOhDVg5t+me/5SrVwRrHjPdkRcu0MSgV9LUlKZQ9KVuVlDkIevcHVHq3nRNyca0tM46WgmnGfBGhXnUMTes0vfmXY9TAzEkdJu/5Cftf2bQeWNKfj3dfcYbFoGbqJOrrV/RjuqRr0mglr
 TY2EUnR5
 d7XfGR/LqcuwnLmRay59rKmhvUeuGNXJsi7KIij+Cj6ZxZ4quWK1rEeSGPJar9OM1Xt2npsTqeI2zgXS8XLGKWdO/rmwf9/TS91rHETrvcxEVTpFLqIC8Z39g18hf3jG7Py7JUnYYrKKnTY046Txmmbv9bQklSYqoBp+zJRqwZgyw2xLRAcCwgPOc9tdKjgOCNif38xV6YcKRG0dNgswX8COo3emLwPMKTHxew1a+86Yqb9bfPF8/vTrK/s3aCOEajf4Q0XCyI/YENz1x6pJ9iiZGdTdSLReOxgcDPkEeWPcKCF2NiXcHtrVu3svCDUGlZgK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 01:19:23PM +0800, Vernon Yang wrote:
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
>  mm/khugepaged.c                    | 4 +++-
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index d3572d4ef453..5dc71d292f47 100644
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
> index e7830761d3a2..7c8c48577408 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1603,6 +1603,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
> +	unsigned long pfn = -1;
>  	unsigned long addr;
>  	unsigned long enabled_orders;
>  	spinlock_t *ptl;
> @@ -1778,6 +1779,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		result = SCAN_SUCCEED;
>  	}
>  out_unmap:
> +	pfn = folio ? folio_pfn(folio) : -1;
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
>  		/* collapse_huge_page expects the lock to be dropped before calling */
> @@ -1788,7 +1790,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		*lock_dropped = true;
>  	}
>  out:
> -	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> +	trace_mm_khugepaged_scan_pmd(mm, pfn, referenced,

Same comment as 1/3 I don't see why we should be storing a pfn value used
nowhere else just for tracing.

>  				     none_or_zero, result, unmapped);
>  	return result;
>  }
> --
> 2.53.0
>

--
Cheers, Lorenzo


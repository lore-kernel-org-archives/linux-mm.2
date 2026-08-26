Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72126C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E396B0088; Wed, 26 Aug 2026 04:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414D66B008A; Wed, 26 Aug 2026 04:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3549E6B0092; Wed, 26 Aug 2026 04:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1CF26B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:08:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02E9DA3490
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:08:03 +0000 (UTC)
X-FDA: 85142692488.01.956DEF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 599D814000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:08:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DR7QvqSz;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQdtBssAwwKPp/yVBHLqOxmBB73GFT/M0a43+g7tuu0=;
	b=11g8MQjV7rlqYquJD8PGSkqQ8JPLpQN9SPIY8pjfn5W0oH8SWtcFWfclNQTbuLBwVFGfxL
	c2ZcqRTyKnqo9oYuiL1LpnckUtsAw7lz5npWjlDyl4Jrvl1jnbVAoUkPH76+C3pERpZFyS
	+hPcC2opz8vHiSdIm+jMstzvWgcRH3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731682;
	b=Eiz5Lplkuv2Xo5rRTNcYFHkUc1mnSVNB3HOozA6G6ldj+6yiahxFrEs29ViP+evQ48mQ8c
	SEicgGg89brfkMqXZA4VqhyYcuH0wqRgjexAce1eqfMYjr1PxumZRwjbTvWba3NQNI2Mha
	pvrCwygUuvTVNss9IO44i5g7Y8sQbV0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DR7QvqSz;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B734160A59;
	Wed, 26 Aug 2026 08:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41001F000E9;
	Wed, 26 Aug 2026 08:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731681;
	bh=QQdtBssAwwKPp/yVBHLqOxmBB73GFT/M0a43+g7tuu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DR7QvqSz+6My6tCuflSAf6AqnatJqWsaMh3RP7hk4YEA4FzjSmojxxWBLFeiV+Ejn
	 1oaldsgxytC3EixN725F6VQ0bRO2T/ae9L7KeLoHPgxBsazha8g3jpsvK1/finMsDr
	 1E8Mi0TiEz2A/eAFphoVdL/ckxOzkFx5oggf04eTTxoUHHC2g7YtUGSOCSNWryjHtS
	 u34f5qoKsO1xjoVhMW1hf8ZtVzB/lWD0dRFYL7eeTUDyXAFjS2k3qG9dUgfvi/IAoj
	 zUelNYzlCy5nEbnBjqJCi45iejK6Co5uMPjg/ukLc2Kjf4reLkiPYfbvXnEhQuHrlS
	 kxHGnJWI4wJ7Q==
Date: Wed, 26 Aug 2026 09:07:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <ao6c6Oe_KV0O1LJn@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 599D814000B
X-Stat-Signature: q8hrbxfkro8utpnewdidbgbkqgwq4jz7
X-HE-Tag: 1787731682-364799
X-HE-Meta: U2FsdGVkX1/wYOpnzuxmg0mKw0iLcExsSp8aFUH/xjVL2GCGo/Ghbcy4skzrXfrMmnwN7x4lJ7oHO0EKJIcWIGI55gMuWH/5nrGPd3vcHPXXS1ncZQKdkhUtyh/02sMm7uEYUh5rcnEIdqP40oGUtfsB3Us47kb/Kr3L2CfNuDMyl5vjwbRW6GTHJNN0w6yvzgOGi1BSSrRAHXtinqafylsNBtOVLgvAyR8TJZi+ISpkKCR7QUuQJ19uU0F8Nrqg51MaQEnAs3x3PncpuNP6r/2puF/oJiHSDPJrKvtI0iIfFuO6CG2wW636r3svGWpErT8MR8FTZPv+OPv7V7yNX0FMC0v6yRvztX3Ee1ozK1rfTCf1H3IZ2BS/DWt/Ezdl2B2rc/XK4g+MAYXyYZ2Z+mxOcwg2r6IXnl1e2TmCfVJnICRE3R2giHXyxQ7Qtvzkpr/3w7qeAaRWX7WykJ/b7GHb0GWHY0KDhUq2FswhecSMsp9HFQgKcL9qh/xAlk32GLDJ01b8cP4jJUk5G5/3oFseETnBVql7NIXM69cAMoarxHbypgiX4YSV0snFvXhftrSHKILnp7cBbIGzuS+KKtvOc+XJ9hohBhAI/P+6MtpA+1szIFzLDfDqMAfzqJBQPvUX8kJ1ETfoZ/4EVEVyoRAbxQfCNZXr4CQW86Vt4TjmWxu+eQIFBvp8RoIA4FI5tXEaXvvR6+DE9GT+968GkJu0ZYDwjkYoHpg+7ozcIg+gqWOHix9qrckB2fzWmr/M4iU3vvZmb9xxxI/UV7pPr7zlFJ993hELH+IUOEJaNYDMTOiwMO1dRKV3gCBUnfmpWUFr35ZkbOXGlLkBzZV1/A9m0Z5uyUiuX6/wvpZWS/XLH9fGfnjFG/tCnHRpS/0hNN8ly3tjeTEROtu0G/jbnpZtbptZe3deAMYEqsNYjcWfTqWVi10aQnmiSknZUBh7ndJp+j+7oJzhDPE1vGJ
 b4WoSHK9
 MKhaPJ/6oCErS43I8GOeWXoHxbzqvS42icq0K+7Ud9TriABWh8m7AzffdfqN8Oi7UlaUhsnRRGcmoKmcZsZp8amG2nJqEBPVX2mpsYvLmMdSI8f+DMohpvkMeTWYf1L8rxOf14c7+aH2eyybB2hB3JDOswRRGIGgerv7ubwj0R0wrfRI20nxIBV0UcE+WinOxc7CdzzfxRcHDv2DlGNxN6Z7BDXkyeNUZLVIOis+guAiMXx2hZKGEdU4LahcPn5GmXAjIO9M7WzCbL8hMToLFtJfK18Jz+edPXuwNLxPSpD3curs7mkQ2pR1k6DH7h9jQ07Br
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:57:05AM +0200, David Hildenbrand (Arm) wrote:
> On 8/26/26 04:44, Vernon Yang wrote:
> > On Mon, Aug 24, 2026 at 01:54:18PM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/24/26 11:29, Vernon Yang wrote:
> >>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>
> >>> When the swap entries found exceed max_ptes_swap, the loop is left via
> >>> break with folio still holding the xarray value that encodes the swap
> >>> entry, not valid folio pointer.
> >>>
> >>> That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> >>> to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> >>> plain pointer arithmetic, so the trace event merely prints bogus
> >>> scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> >>> dereferencing the tiny encoded integer and oopsing khugepaged whenever
> >>> the trace event is enabled.
> >>>
> >>> So when folio is the swap entry value, simply set pfn to -1, just like
> >>> exhausted scan naturally.
> >>>
> >>> And the folio_put() has maybe dropped the last reference of folio. The
> >>> trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> >>> so using the folio_pfn() before dropping the reference, closing
> >>> use-after-free window.
> >>>
> >>> Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>> ---
> >>>  include/trace/events/huge_memory.h | 6 +++---
> >>>  mm/khugepaged.c                    | 5 ++++-
> >>>  2 files changed, 7 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> >>> index 5a48c5406cce..7b526528f85b 100644
> >>> --- a/include/trace/events/huge_memory.h
> >>> +++ b/include/trace/events/huge_memory.h
> >>> @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
> >>>
> >>>  TRACE_EVENT(mm_khugepaged_scan_file,
> >>>
> >>> -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> >>> +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
> >>>  		 int present, int swap, int result),
> >>>
> >>> -	TP_ARGS(mm, folio, file, present, swap, result),
> >>> +	TP_ARGS(mm, pfn, file, present, swap, result),
> >>>
> >>>  	TP_STRUCT__entry(
> >>>  		__field(struct mm_struct *, mm)
> >>> @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> >>>
> >>>  	TP_fast_assign(
> >>>  		__entry->mm = mm;
> >>> -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> >>> +		__entry->pfn = pfn;
> >>>  		__assign_str(filename);
> >>>  		__entry->present = present;
> >>>  		__entry->swap = swap;
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 79effd3f3da4..00337405c0e0 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -2689,6 +2689,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >>>  	int present, swap;
> >>>  	int node = NUMA_NO_NODE;
> >>>  	enum scan_result result = SCAN_SUCCEED;
> >>> +	unsigned long pfn;
> >>>
> >>>  	present = 0;
> >>>  	swap = 0;
> >>> @@ -2719,6 +2720,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >>>  			continue;
> >>>  		}
> >>>
> >>> +		pfn = folio_pfn(folio);
> >>>  		if (is_pmd_order(folio_order(folio))) {
> >>>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> >>>  			/*
> >>> @@ -2779,7 +2781,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >>>  		}
> >>>  	}
> >>>
> >>> -	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> >>> +	trace_mm_khugepaged_scan_file(mm, (!folio || xa_is_value(folio)) ? -1 : pfn,
> >>> +				      file, present, swap, result);
> >>>  	return result;
> >>>  }
> >>>
> >>
> >> Shouldn't we just reset PFN to -1 at the beginning of the loop (and set it
> >> initially)?
> >
> > When the `xas_for_each()` iteration to terminate and the folio operation
> > preceding is normal, but pfn will be incorrect.
>
> The PFN is only relevant when a folio participated in the failure. Maybe the
> following would be cleanest?
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 75639298efc27..371ee0b16d10c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>         int present, swap;
>         int node = NUMA_NO_NODE;
>         enum scan_result result = SCAN_SUCCEED;
> +       unsigned long problematic_pfn = -1;

I find this name... problematic :)

What about:

	pfn_t pfn = -1; /* Assign on failure before dropping ref */

Then:

	if (result == SCAN_SUCCEED) {
		...
		trace_mm_khugepaged_scan_file(mm, -1, file, present, swap, result);
	} else {
		trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
	}

?

Other than that I do think your approach of assigning it on failure is the
right one.

>
>         present = 0;
>         swap = 0;
> @@ -2714,6 +2715,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>                 }
>
>                 if (is_pmd_order(folio_order(folio))) {
> +                       problematic_pfn = folio_pfn(folio);
>                         result = SCAN_PTE_MAPPED_HUGEPAGE;
>                         /*
>                          * PMD-sized THP implies that we can only try
> @@ -2725,6 +2727,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>
>                 node = folio_nid(folio);
>                 if (collapse_scan_abort(node, cc)) {
> +                       problematic_pfn = folio_pfn(folio);
>                         result = SCAN_SCAN_ABORT;
>                         folio_put(folio);
>                         break;
> @@ -2732,12 +2735,14 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>                 cc->node_load[node]++;
>
>                 if (!folio_test_lru(folio)) {
> +                       problematic_pfn = folio_pfn(folio);
>                         result = SCAN_PAGE_LRU;
>                         folio_put(folio);
>                         break;
>                 }
>
>                 if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
> +                       problematic_pfn = folio_pfn(folio);
>                         result = SCAN_PAGE_COUNT;
>                         folio_put(folio);
>                         break;
> @@ -2773,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>                 }
>         }
>
> -       trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> +       trace_mm_khugepaged_scan_file(mm, problematic_pfn, file, present, swap,
> result);
>         return result;
>  }
>
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


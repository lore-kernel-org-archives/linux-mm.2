Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E36B7C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F546B009D; Wed, 26 Aug 2026 04:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E501F6B00A0; Wed, 26 Aug 2026 04:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66F56B00A1; Wed, 26 Aug 2026 04:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B944C6B009D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:09:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2777BA26B0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:09:25 +0000 (UTC)
X-FDA: 85142695890.17.FDAECF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 82D4D1C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:09:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QlFo/Xx2";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731763;
	b=xBhaWkGNtQOz3TtPFJdPda5ap9qNgbHONBzlOOjWzVVDxAf0uDpgd4Waek8yPXDkOv6iEe
	P5mtE+oWvIG9c1xKcIVa0mU6HY3PUwKFPSA2W9q5Li2t7pvpem2xjFUxlD8vHr3DFcPO5q
	RnKnI28BpLAIN9B2wJzQ0y569O8na4w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QlFo/Xx2";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcqiEUwoaQZ5bgWvIscWP1Egql02KyBJna4kdvbmVMc=;
	b=rPjTvZfWijpVawB5jVL8JbJV3DymgQpi+E0Q8g4yWFeip7zScw95w3lLSrbwqjRH6iuUCX
	cNK2bylWy+0WGfNf29VeXiYrkcWP4hEJOIXO0x9xOqPU5qQBr+D3VsDVL7VyqTIfptGtMp
	PRsVWO9L1zkq9JR1BNr1M+GQWgb7b98=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11356600C4;
	Wed, 26 Aug 2026 08:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B16F1F000E9;
	Wed, 26 Aug 2026 08:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731762;
	bh=wcqiEUwoaQZ5bgWvIscWP1Egql02KyBJna4kdvbmVMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QlFo/Xx2MRjymoU4gmfihXhAcIcPGrBb/0sKUf4LqjGIMVLLQxMucPIPgKldUNMDM
	 hYOqwQP6mKIlxBSJfZ4tt7cSusb5U/z/PBOlbE33qu9DwWevlUAdzcL/iMXucNoQwq
	 ZheIptJBCda1yDs7qgnBq/GlxKtDvS2++eUDeqEa2Aba0FDcRFPDuYBVqeT1gFdJba
	 dD+upvrVwf0wrZjXPUxk/1dAYnbMCT3KSB7Z74NvQKYXmmKix8Sp4DKMRuZYG323xW
	 6qVSkNiK03h1a3FYrJ2w/OmkTbrvC5BzwO9+LaVmY14wKinfICPcOUA+aouucIY4i9
	 XyLlHf4EEdV3Q==
Date: Wed, 26 Aug 2026 09:09:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 3/3] mm: khugepaged: fix folio is used after
 folio_put/unlock()
Message-ID: <ao6e9RxwQ-KC1Ikq@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-4-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824092935.73892-4-vernon2gm@gmail.com>
X-Rspam-User: 
X-Stat-Signature: ni4mhaw596anytf96ej3cmxs1qowhga8
X-Rspamd-Queue-Id: 82D4D1C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1787731763-466479
X-HE-Meta: U2FsdGVkX1/cr7DHKbxGqGeqjmIN/B74XgMe0fiGjfWsm+u5R/4c6/w/peEE/fMzL1kS9ndEvYk41jAmj9GcLpk8YDOB2QXqIo4OuQOKm66uFK6danAyAFGv3TIIacH2hruLBeoWHM3SgG7/UjQ7IsxNRM9dbFGb6tzEv4CSAJq/ONsw48NlpJj+ph4dYDZnD2BevL9boT5gA4+i9FdVR+VejeIYdmWtkyc9qvd3ZAVIhwd0XfGvhK8Rif5LI9/C4JiXVQN5SLCyk41cqnU1pbxTUViHSrGR1JmENy9J7vohsA3Xu/ulDjfY/8alTQi4uAq8dORz+LtVjk3rDZCiOVFnFFjqP4Cj0djq5cfmtie5QNu/GJ3w6xClo5f8yiSnb09itRFIfsa6RNLp4ei2TKir/Bw++XJMICqDfznN9CMXG1WL6CUs68Mr92eFBVFsaOSeBCQFy5WdYIAjMH/1uesiXEJolYcW23zfRjIuRF52QIGU0JriRmvVx10gMvoT5aYRZCDEeCN0lAexQoeYv1Gy+i3jQgSMBEW6hKQTnA/1CpcEeHoOSwtOmDUL0hLb35Qk471YHM9BKyQFHA25PH/jqk84GsPWWv/bleYUnO6SgOaJViW3HZIq2Waa5DgVgILYw+8gb6W11E2Mylk0/rBMCjs8ieMhYahxPKqiImMrF6s43dT048Ai1rLApky8wMHd7DCSIU+2HC463z6Lojwq14kG7zn1/U8vuJYnGWs0EePxrc5UMbqw+usiXBWA70elsjevtlRAHLO8vWYzyjIllby+92X0wZrbtLN3U5WgZW/ut1quXMZbGdYfhrXeiVbzRo4TM13pWLTEyi7tn7xHGmiTChthYKS+qiSg5u4gZJNjPpoqzw+8wV9L19Wrz68k9qLmb7UYjpewsOce8Mj2MEuNkfRNkamGmB6ysbKPfCj7E3WWPsu1rvmHXxbINW7otmPPtoEbGQkmQOk
 LhhFlaZo
 tZcZzEkQLEsuOYet0scRhc1D5upctDt2rqrUG4VTpsojtdsu5VCqYLsR4OECJxgcOmhbgQE48I0SHgsTJh4hgRQa8ZG/rfF90GXodAtoMhPcbpS8292Gu+2Hul/YUY5uKNzB0i8bGs30RfCdMyZKpFD0Jm6IPg2+E1Fv0peGe17A4Er6P7m1m1gMZpsJiFAjBsL5tHJarfXhr6Lkeyub1ZjuQc+9ZqYcMoqqLnVdfEMGcVxoe9BfzVJ6RUXsLnWILMuFKBG8CIRQvhIEMuoSatfl/ZhGV+/D3CccOsrvOCRDchaVC1T8Un1uSDHO6weRU7kKU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:29:35PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> On the rollback path, folio_put() has already dropped the last reference
> of new_folio. On the success path, new_folio is already unlocked and can
> be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
> with a dangling folio pointer.
>
> So using the folio_pfn() before dropping the reference, closing
> use-after-free window.
>
> Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/trace/events/huge_memory.h | 6 +++---
>  mm/khugepaged.c                    | 5 ++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index fa828967e1fb..5fb4d92cfd84 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
>  );
>
>  TRACE_EVENT(mm_khugepaged_collapse_file,
> -	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
> +	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
>  			unsigned long addr, bool is_shmem, struct file *file,
>  			int nr, int result),
> -	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
> +	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
>  		__field(unsigned long, hpfn)
> @@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
>
>  	TP_fast_assign(
>  		__entry->mm = mm;
> -		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
> +		__entry->hpfn = new_pfn;
>  		__entry->index = index;
>  		__entry->addr = addr;
>  		__entry->is_shmem = is_shmem;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4e0fca5942dd..24347f1a94ae 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2254,6 +2254,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	struct address_space *mapping = file->f_mapping;
>  	struct page *dst;
>  	struct folio *folio, *tmp, *new_folio;
> +	unsigned long new_pfn = -1;

Nitty but:

Could we use pfn_t? I don't love that we are inconsistent with that.

Also the general pattern for pfn names is pfn_xxx so pfn_new instead?

>  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
>  	LIST_HEAD(pagelist);
>  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> @@ -2633,6 +2634,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	retract_page_tables(mapping, start);
>  	if (cc && !cc->is_khugepaged)
>  		result = SCAN_PTE_MAPPED_HUGEPAGE;
> +	new_pfn = folio_pfn(new_folio);
>  	folio_unlock(new_folio);
>
>  	/*
> @@ -2671,12 +2673,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	}
>
>  	new_folio->mapping = NULL;
> +	new_pfn = folio_pfn(new_folio);
>
>  	folio_unlock(new_folio);
>  	folio_put(new_folio);
>  out:
>  	VM_BUG_ON(!list_empty(&pagelist));
> -	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
> +	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
>  	return result;
>  }
>
> --
> 2.53.0
>

--
Cheers, Lorenzo


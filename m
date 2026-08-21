Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA68C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0966B00A0; Fri, 21 Aug 2026 13:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A856B00A1; Fri, 21 Aug 2026 13:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02ED6B00A2; Fri, 21 Aug 2026 13:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 812136B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:09:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBD4816015B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:09:39 +0000 (UTC)
X-FDA: 85125913278.26.712D376
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2EE9220003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:09:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBDi66cJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787332178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXhsSgD+So1KYv0opzbteQ7Y/GTNQS0Ot83166ZvllE=;
	b=pwrF4eNfirAMaBHGwmMKUkllYg6+atIklyaFLDBIdGjOIKPKd/WFRN9cvIrhM8UA5oJ2Qu
	0seoflWvdkx1U9pHReI9WUG65ZeWWWlxzxfA4rLqzXPjGGfco62FztnBmUZ/suV3Y0jxb6
	10xVwhU1ZxhUXS3DhjapJYGs10Gl2og=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBDi66cJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787332178;
	b=Q/sHIb5/LAA1WZ9/W3IUtQoz/a+d5B0Y9XeB1XCbVpX/af0iPKIixcsLVavVtCDTtS2LLG
	+szHb1Oht9cfJa5AKOYOXj6PCApC/dntBAvsyBXnOP7Ed1ntF2tPUi6ZAP/fdJH4Z9Z1SO
	Yi5p3K0TLkGauUEOPXCbNQbfRxRy0Qs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F83A43B10;
	Fri, 21 Aug 2026 17:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388E11F000E9;
	Fri, 21 Aug 2026 17:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787332177;
	bh=SXhsSgD+So1KYv0opzbteQ7Y/GTNQS0Ot83166ZvllE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DBDi66cJgAuWcv90XqfOjUMXdJYHjk6ICIrClqQjw3fx0PiQ+i6Q1mAYoFtRdzpiP
	 IpgWFLgdtU/zNuaznv4wKX+6cujfcChcyjf3Fxwly2ZqSwCHpO4FHasgjSCEtuXIJI
	 Vcc+9Fes6TFXSxN1oFkXQ86OwFZ/OUubeu9T/WTu9Km13yuzFBkW3sdAKBIuBYZOi8
	 V3gAIIKftBQ10fLj/1kIYtQoTE+cHU95+VP9lCt/6tV0k0r0Ujr55eTko9Kr5y5n9+
	 0btgFaMOEAOIjSmyTCc16eWkpEkBF2yUpl1OJrpasgS1hq6sAoQB8QWQYiJFtxWoKJ
	 Uksb5L6i67JFA==
Date: Fri, 21 Aug 2026 18:09:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <aoiDTwCf6320fedN@gremlin>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-2-vernon2gm@gmail.com>
 <aoMs79VDCnYvA9S7@lucifer>
 <aoMzkN8EfFllT5zH@lucifer>
 <aedcacce-4880-41b0-a4a6-d892465fff57@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedcacce-4880-41b0-a4a6-d892465fff57@gmail.com>
X-Stat-Signature: 7wxc1foi4m9t3bdcu5wp9bkc94iaj777
X-Rspamd-Queue-Id: 2EE9220003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787332178-289736
X-HE-Meta: U2FsdGVkX19mvco/OQZqELRfMeqHBF+gNVcjB+LvjrbgWE/O8WCgyuItb1N4bOuXBn0Nbyjr0FA2EkSXBUYUH+E5V40Fym+7pvifozwuNJiKU76iV9HOUh8kwPgdVDQQessDv4bO/1+vv/VZlGoy1VlpkNTJ9fa4UEEI8GAim2HybrBRxhLDTiPo4ofxc2MOoIA6MnC7M6MCS2+k81+esVUuE+s70UZsjihHUhFxB8zBYj4rPU6B2dI3O80Fh4TVETA/AySnYQHR8ddx3hBI0xvH0cLDjO9reHwk4KZk3KtvImT8vIoMdGWorhbVb1IdTpeRJMfXwyJFFTBV80X02+OGAypVFmj4+EPfGOKw7trJnTKCrVfyrLTz3rQ0Pdv9day7FkadtcxXLefGI1Lck0pphnHxDf1PdmpytE0dmev98FYbJoynVMeYs0wpEZIrvjO5cZxjdiBsZTloiCb3NPw41qxDkqKLUuPQpa1mpB0eoKuF0M/Y/riHJpfbvM+1ScS7GD5+6/xXPFn+H4pvm/A8xM+s1qFDpV54B+PISKoaWooI7tbWIqekksiA9ZJtn3FiQ9C6IUBv0EwVDEj0wjQfTnvgV16FApleFCPOxcIEtdZip5eN8BVtFTkQDPMqeLXV9EiIGAiJxWIRcdN6ZE/MlPqy6LPbWH/H3GO5VpvABmed7EHg5mYk4Piv6HWjvDo5NpuUi1AAMPlqtJp7tFjoaBz6Gs/KydC+W5dB4F0lhaOvilQYypoiqDGp3xiCnN0mBwb+GvcpdKs+LX68cbYaqP90H5eoljVtVO+VeZuzc7+hgBXhYxmlrqDNVXkK19VkOZTUxOxToV9TPO5IHAn0Td1mQgI44kNrxKSlA19zBDVXjI2veQEIsOjASh5PMVyn5yTQ1TMBywX/4pOHTmlaZShjCHXvy22r/8j0W6fgzNf4fBJs0r8LHkaioXc7dBCWXobYmp7iBRObh++
 WFwMBXI8
 ChJvfo7hgse6g3wzxWe40uZLLOwFYyK+9ivTneqT1T7GDST1Fbl2sacz+rj1yngHhRZuEhogAw9Av4YNRfA94f4aG7ZM0lnKYtjiCYUEiak+lJdFceyz0cLJXnzXiCWBfyssj1cxmuqL0MU6Q4eZckRDxL0MApHZHyFSVLjYbq2LmQ81iVQFuDqtdZA0eMazNdVW20RYOuLLI7rkF8XTrHtEAKkXu0WLAusTLTJb1zHbfWlsS1UeM5bh9DeNAaj+XmjlWAjy/OybSxZjHCAwcdxExEvCqisk1ZO5o8JE7Mo8EaGLhvFIhu030P2H/Vos1AZTBvtfcMVQC2Yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 04:17:55PM +0800, Vernon Yang wrote:
> On Mon, Aug 17, 2026 at 05:23:30PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 17, 2026 at 05:10:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Sat, Aug 15, 2026 at 01:19:22PM +0800, Vernon Yang wrote:
> > > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > > >
> > > > When the swap entries found exceed max_ptes_swap, the loop is left via
> > > > break with folio still holding the xarray value that encodes the swap
> > > > entry, not valid folio pointer.
> > > >
> > > > That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> > > > to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> > > > plain pointer arithmetic, so the trace event merely prints bogus
> > > > scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> > > > dereferencing the tiny encoded integer and oopsing khugepaged whenever
> > > > the trace event is enabled.
> > >
> > > Hmm I seem to recall that we were no longer spporting !VMEMMAP SPARSEMEM, but
> > > maybe I was imagining that :)
> >
> > OK seems some museum piece architectures are causing us issues again, fun times
> > (parisc and some mips).
> >
> > >
> > > But this needs fixing in general anyway.
> > >
> > > >
> > > > So when folio is the swap entry value, simply set pfn to -1, just like
> > > > exhausted scan naturally.
> > > >
> > > > And the folio_put() has maybe dropped the last reference of folio. The
> > > > trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> > > > so using the folio_pfn() before dropping the reference, closing
> > > > use-after-free window.
> > > >
> > > > Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > > ---
> > > >  include/trace/events/huge_memory.h |  6 +++---
> > > >  mm/khugepaged.c                    | 14 +++++++++-----
> > > >  2 files changed, 12 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > > > index 291fae364c62..d3572d4ef453 100644
> > > > --- a/include/trace/events/huge_memory.h
> > > > +++ b/include/trace/events/huge_memory.h
> > > > @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
> > > >
> > > >  TRACE_EVENT(mm_khugepaged_scan_file,
> > > >
> > > > -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> > > > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
> > > >  		 int present, int swap, int result),
> > > >
> > > > -	TP_ARGS(mm, folio, file, present, swap, result),
> > > > +	TP_ARGS(mm, pfn, file, present, swap, result),
> > > >
> > > >  	TP_STRUCT__entry(
> > > >  		__field(struct mm_struct *, mm)
> > > > @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> > > >
> > > >  	TP_fast_assign(
> > > >  		__entry->mm = mm;
> > > > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > > > +		__entry->pfn = pfn;
> > >
> > > I wonder how easy it is for people to interpret that this is a PFN of something
> > > only in the case of an early exit.
> > >
> > > It's a bit of a mess that we're exposing internal implementation details like
> > > this, quite honestly.
> > >
> > > I hope there is no expectation of this being there indefinitely.
> > >
> > > >  		__assign_str(filename);
> > > >  		__entry->present = present;
> > > >  		__entry->swap = swap;
> > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > index 617bca76db49..e7830761d3a2 100644
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> > > >  	int present, swap;
> > > >  	int node = NUMA_NO_NODE;
> > > >  	enum scan_result result = SCAN_SUCCEED;
> > > > +	unsigned long pfn;
> > >
> > > See below I think we should drop it.
> >
> > OK we can't because of museum piece architectures that will actually deref the
> > folio to get the PFN...
> >
> > I'd startr by initialising this to -1 then since I guess in theory it's possible
> > xas_for_each() could just not do anything is it? (folio is being set to NULL so
> > that suggests so).
> >
> > >
> > > >
> > > >  	present = 0;
> > > >  	swap = 0;
> > > > @@ -2720,27 +2721,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> > > >  			 * PMD-sized THP implies that we can only try
> > > >  			 * retracting the PTE table.
> > > >  			 */
> > > > -			folio_put(folio);
> >
> > I still hate the idea of moving these outside of the loop, it's just asking for trouble.
> >
> > So I guess instead:
> >
> > 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
> > 		pfn = -1;
> > 		...
> > 		if (xa_is_value(folio)) {
> > 			...
> > 		}
> > 		pfn = folio_pfn(folio);
> > 		...
> > 	}
> > 	...
> > 	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
> >
> > That way you avoid the horror or moving the folio put somewhere deeply
> > unintuitive and inconsistent, and maintain pfn lifetime for some arches nobody
> > uses.
>
> Thank you for the reference solution. After studying the overall
> process, I found that the above solution still has two issues:
>
> - When `!folio_try_get(folio)` or `folio != xas_reload(&xas)`, if the
>   next `xas_for_each()` iteration happens to terminate, pfn will be
>   incorrect, which is inconsistent with previous versions.

Ah you're right of course!

> - when the `xas_for_each()` iteration to terminate and the folio
>   operation preceding is normal. but pfn will be incorrect, also same
>   issue.

Yeah... :)

>
> To keep it simple, I modified it as follows. Is this OK?
>
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

OK looks reasonable, thanks! :)

>
> --
> Cheers,
> Vernon
>


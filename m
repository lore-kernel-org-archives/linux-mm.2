Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AAA7C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7658D6B00F3; Mon, 17 Aug 2026 12:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715CC6B00F4; Mon, 17 Aug 2026 12:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6579B6B00F5; Mon, 17 Aug 2026 12:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38AD36B00F3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:23:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C078C120810
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:23:51 +0000 (UTC)
X-FDA: 85111282662.19.3BB35BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25EE040005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:23:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DO/5UK1s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/vvi+DFlou8f8PFbAZpbS1hopDQtoJmtCluLehs4/E=;
	b=dfFGjf+5xsVeO5vPn6u3Bc36fOVsJtRGtKyQAXL3PRkg82MPED0a8jbvH9IEimo6mZboOk
	QYi5oIbXOwfJN6RvtWjOvI9a4UWyqeYPCDsLWqNq5MMZmrpNpRPBILMhU16tkolJFlmuBT
	3Nxhts+tr4/18fsLZqAr0KZwCaVHjjA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DO/5UK1s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983830;
	b=OE9eOvZax30Er41crm4lIj2jC3HyaAWu06eVAD3+nWymFg7bmm9mqaG6CRLLTIXpWcQyNl
	JHcjW1vlEgMrJIJtaIkvoxlCNqsLJqBpwmtK+NVdypCdAVR52FG165WKuimMOuF1BnrMwB
	T6TTd+NT1tKHD8+hCzQ0jdH01zxFIn8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A58CD601E9;
	Mon, 17 Aug 2026 16:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C81F000E9;
	Mon, 17 Aug 2026 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786983829;
	bh=M/vvi+DFlou8f8PFbAZpbS1hopDQtoJmtCluLehs4/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DO/5UK1ssNLcrIayHml0xY4L03vESqdwM2OervIq1HvNArbtmpckEwdqoiTlZEWmr
	 axhCn3wOd9mP7m3iLZ4K8rP3Gev/yICjRZ9+/7QSY5g4v+Gg5CXOivz6reTfffXAx3
	 JuieUNZntzFC7sC5Vuz0P7OQUoeWe9ux67QlWReeD/lDwkpkULnkt8jJTNKRDErRDl
	 KjxzSX9ogCtAoCRtNInsga6MOBDMYoNXIt0LM634XYTmVijSTwDh0LgzrTRJSs+XLY
	 4SUL2VQNv3gTx8UglzVgiIgvGdvuR8COvHauoqpBUDY0U1ZHYU3PDAafRSu2ue7F/9
	 CAp1wSHtrPCIQ==
Date: Mon, 17 Aug 2026 17:23:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <aoMzkN8EfFllT5zH@lucifer>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-2-vernon2gm@gmail.com>
 <aoMs79VDCnYvA9S7@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMs79VDCnYvA9S7@lucifer>
X-Rspamd-Queue-Id: 25EE040005
X-Stat-Signature: ue8fshguae6zpo8ajybm1pqkpixncxxw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786983829-688046
X-HE-Meta: U2FsdGVkX18jhwVRToWoIhDFAPs7swWeIfoqkyNCALOGJsorX18ha7tQMKaMB42l6R/GPu98YbOoTElmwr4EwCxYRo+l0gmF6sj1pASMza1d0eWWKfMJmrr8vWSoc9gGo/LhVKUxm0w8y9wPDpFgsP751J89658d7DVnv7DiMde9SRuIi9iaRySehE0R8wWsn4uION7bQcdT+xadHfwDmfYFpxGuVURRc41HFbV+x632Y6XA0Io34j+x24vN2o4CicFZptdpeqDONsIxjPNGrjG9IT/8x61BUmGQCFwnhl6om0i23zyjK6x2GOqXpS4V9UPv7YzHTS+Iqk4gQJF6EzwYQ6kaDhsgzhLL/iYkk2jpVZyGhAEEx38smsTDbWwSR+hXQgJvsic8M2MeinlnGKhMoLzqqqp7Bq6z7BOF91GJuRWWWVOlpVzhYR8qDD0rn8ldvT/++9iagyjIxAwaW7ducXm5z9Pw9K56a6DuukZguZK5GIaEacygaK+QnFYp3nmm+E/UI5cr3W3WyCMxIRahfq1FhQIVkexoBJO4PbWs3qcMzvBskWlhaHFMMykB5umIQdnDZ/yVeqHkrsxHvBsaNRPhseuyGMiXAZSXbClFiA9KSf4amHTHbmVeTA8WAzvk2LEpgTzdNMInFuwulQ0ts+RZ239cTPFAESOkN/fjDQf3TEncZi4rP641PpICuoot5x1ywOLqZU0DuPutgsQWGB3CctAZ28/WWz36rTd97pTGFOSB7wMR335616KysuHIojFtfafSEIwbt3i8EUyrbcDxdHyBAEP6nqq19VjrEV2XFfSKaJXFQQGvIhvAZzBr6k+viKKQcje3QSQVYrTnxbZ2y9+iK5lMPo8S10FBAyCCVR+mw4Xc6bNgXT6nD2RGFK2sKQ1kUvL7XHcey/oYpfcSl1O19d0cNk+LyTBSKJIPgdm4TXU/r5KFhPmn36LqEkrPmT3WdMK+sau
 oD0J1aSB
 DfgdNvnMitazwfAof3MeX3MvpCIft4ciC8mefL2cwY2U+2tSQ9GYvdcg35tOpU+qS8JYvm4V+F1yud0eM7bkJGm8+xkk6GLJoLmEi33Avb1pckTJtYFn73jGiXtuA+Y7g6eo2i09CT5dA4YS8TRZk2S5K5eWRW1iKRgBj6KbHKP4vj2G0umW8Str6IwFEEtjp/eMzJobAw8naHz0LjsTDLzUW9pMhVGHMUenncrwaRf3hCy7NaOFGzScU/FJUMWRErdKRPDaVnD6DXpoAph0q/Rlww1fMkoNkj1G5FwNHc0Wa8V0h7IGaPuAhieDXzQ/HPviD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:10:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Aug 15, 2026 at 01:19:22PM +0800, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > When the swap entries found exceed max_ptes_swap, the loop is left via
> > break with folio still holding the xarray value that encodes the swap
> > entry, not valid folio pointer.
> >
> > That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> > to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> > plain pointer arithmetic, so the trace event merely prints bogus
> > scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> > dereferencing the tiny encoded integer and oopsing khugepaged whenever
> > the trace event is enabled.
>
> Hmm I seem to recall that we were no longer spporting !VMEMMAP SPARSEMEM, but
> maybe I was imagining that :)

OK seems some museum piece architectures are causing us issues again, fun times
(parisc and some mips).

>
> But this needs fixing in general anyway.
>
> >
> > So when folio is the swap entry value, simply set pfn to -1, just like
> > exhausted scan naturally.
> >
> > And the folio_put() has maybe dropped the last reference of folio. The
> > trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> > so using the folio_pfn() before dropping the reference, closing
> > use-after-free window.
> >
> > Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h |  6 +++---
> >  mm/khugepaged.c                    | 14 +++++++++-----
> >  2 files changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 291fae364c62..d3572d4ef453 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
> >
> >  TRACE_EVENT(mm_khugepaged_scan_file,
> >
> > -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
> >  		 int present, int swap, int result),
> >
> > -	TP_ARGS(mm, folio, file, present, swap, result),
> > +	TP_ARGS(mm, pfn, file, present, swap, result),
> >
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> > @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > +		__entry->pfn = pfn;
>
> I wonder how easy it is for people to interpret that this is a PFN of something
> only in the case of an early exit.
>
> It's a bit of a mess that we're exposing internal implementation details like
> this, quite honestly.
>
> I hope there is no expectation of this being there indefinitely.
>
> >  		__assign_str(filename);
> >  		__entry->present = present;
> >  		__entry->swap = swap;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 617bca76db49..e7830761d3a2 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  	int present, swap;
> >  	int node = NUMA_NO_NODE;
> >  	enum scan_result result = SCAN_SUCCEED;
> > +	unsigned long pfn;
>
> See below I think we should drop it.

OK we can't because of museum piece architectures that will actually deref the
folio to get the PFN...

I'd startr by initialising this to -1 then since I guess in theory it's possible
xas_for_each() could just not do anything is it? (folio is being set to NULL so
that suggests so).

>
> >
> >  	present = 0;
> >  	swap = 0;
> > @@ -2720,27 +2721,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  			 * PMD-sized THP implies that we can only try
> >  			 * retracting the PTE table.
> >  			 */
> > -			folio_put(folio);

I still hate the idea of moving these outside of the loop, it's just asking for trouble.

So I guess instead:

	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
		pfn = -1;
		...
		if (xa_is_value(folio)) {
			...
		}
		pfn = folio_pfn(folio);
		...
	}
	...
	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);

That way you avoid the horror or moving the folio put somewhere deeply
unintuitive and inconsistent, and maintain pfn lifetime for some arches nobody
uses.


> >  			break;
> >  		}
> >
> >  		node = folio_nid(folio);
> >  		if (collapse_scan_abort(node, cc)) {
> >  			result = SCAN_SCAN_ABORT;
> > -			folio_put(folio);
> >  			break;
> >  		}
> >  		cc->node_load[node]++;
> >
> >  		if (!folio_test_lru(folio)) {
> >  			result = SCAN_PAGE_LRU;
> > -			folio_put(folio);
> >  			break;
> >  		}
> >
> >  		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
> >  			result = SCAN_PAGE_COUNT;
> > -			folio_put(folio);
> >  			break;
> >  		}
> >
> > @@ -2759,7 +2756,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  			cond_resched_rcu();
> >  		}
> >  	}
> > +	if (!folio || xa_is_value(folio)) {
> > +		pfn = -1;
> > +	} else {
> > +		pfn = folio_pfn(folio);
> > +		folio_put(folio);
> > +	}
>
> Hmm kinda hate this you're now mixing clean up logic with some trace logic.
>
> You have to go check out xas_for_each() and see that xas_next_entry() sets folio
> to NULL at the end for the normal case to know this is OK and then figure out
> that this is just for the break cases.
>
> That's not intuitive in already not intuitive code.
>
> And this is a patch you're wanting to backport to fix a bug too... :)
>
> I think you should keep the folio_put()'s where they are for now and limit this
> fix to the trace code please.
>
> I think you should drop the pfn var altogether and do this far more simply, see
> below.
>
> >  	rcu_read_unlock();
> > +
>
> Stray newline added, let's not do that for a backported fix please :)
>
> >  	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
> >  		cc->progress++;
> >  	else
> > @@ -2774,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  		}
> >  	}
> >
> > -	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> > +	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
>
> I mean maybe better to just reduce this to something like:
>
> 	/* folio is NULL unless exited early. */
> 	trace_mm_khugepaged_scan_file(mm,
> 			(!folio || xa_is_value(folio)) ? -1 : folio_pfn(folio),
> 			file, present, swap, result);
>
> As the least invasive way of fixing the trace + limiting the contageon?

Yeah as above this isn't right.

>
> >  	return result;
> >  }
> >
> > --
> > 2.53.0
> >
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo


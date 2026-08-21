Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53416C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A416B009F; Fri, 21 Aug 2026 04:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61CA6B00A0; Fri, 21 Aug 2026 04:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50706B00A1; Fri, 21 Aug 2026 04:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5DD6B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:18:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CED51201BF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:08 +0000 (UTC)
X-FDA: 85124573856.08.FBF4856
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 36A4CA0006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gmLFcMuC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ys3Uj8kuRyrhvynwdvoQqOQA8x+KEUQJRwi9cjOxd9c=;
	b=f0LRnqMw5sJawu2hlPt/i27UvJYxdlt7PQba98rlTexqAfiLrtDAv5xn3UJ8Py4Zab9j/v
	61+ibO5uppQdRlfcq3/pPUSA/5EUdzNmd2WMx0ZkoNrMUnUqdU/UlUWkFYA2sN3TfyoGCS
	Uok9zzr2kh4alTTDW3xVqOED5SpjBAw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gmLFcMuC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300286;
	b=rYjC7QLq8RrLo2ny8HY5GhoYZHtIo3qrln/jk2fhGZeU8sVfqgOsmWQ213JyPHsXMdDGXS
	va2aUulTJWqy7iygea5Y80YCqOjvBCh8GP+MQEi85x18uy3yHGoHJpgpwZiF9tyVzVVLgd
	QE6UQskXJAknzVzSOcQ1Yx8mWD2SSAU=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8487214ad2bso941919b3a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787300285; x=1787905085; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ys3Uj8kuRyrhvynwdvoQqOQA8x+KEUQJRwi9cjOxd9c=;
        b=gmLFcMuCd3UGvx/bf/ZgErK3q8K2t6wwv5WSm7BlYmkgsKwQ6FI31qCLNa0nszrAH+
         LjMazWmrnoMlE+cAIRZl59k+LkviSb8mlnLF/Zys66XhMSx1f5CeG79WHXtLY4ffwiQu
         gpt8mKUe6K2RtQl8hOGW2Cp+XkxpAB8yq/xo2IOJYFejGHze1PrKOnpf0duAKyMZ9PWz
         yL1aKvAe33hnpQZn7q7VNmH5OEfionCr9rJlcG5kjkcrHtxYq4ye5tysYvjqMF7xBXPl
         ncr5aQFwgshdVUKTcePOpEJ/EVPtKVD9yzERKOOD6j7+7xCV4NHV+SoyzP3n9d25zeEJ
         uP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787300285; x=1787905085;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ys3Uj8kuRyrhvynwdvoQqOQA8x+KEUQJRwi9cjOxd9c=;
        b=AVnY2SvLPwCddRufBPG0HRtlWgvx1oRw/lg0vsw+GGFg4LodUallJhcIh0ZArNs1FJ
         PH0S2IzRLSiK0qlODhYY+bo72L98lbLDHJaBTjBg9V7YOw1inuU12Lo44o2ZubsAHHox
         05NvNeGh8rERWJkxH5zaaf7RRoymLrllSUPaXYPCdUo+JX6z6c0t7Ptavjj0NepBFpcM
         /L7MZJqApNaHyBS+dGHmYQA965noBnGTrar7ppFQeHfuBrmyP0MysryYHjcTWKsGN6Fy
         RB7XjltulRvZe1nwSAfyKHXNgqA/EsLcdTf+B0Wh9xpgJ54Ne7KKdSJ8XIA5Tm/fZfMM
         64LA==
X-Forwarded-Encrypted: i=1; AHgh+RrPJjBxS7KjdAmrZb5AupGh7hugl0DAFOEk0FofTB871eoZ3U36f9F3xUsICzDUlXWHeNV+N5TP/Q==@kvack.org
X-Gm-Message-State: AFuF++kXsIWqdkspnati0PQ7LjXhZoLB0O1wMzg4W2t+Y4bZvZaqB4B0
	WQI6FUMhLY9dt1IBDisZ3+Zb5qidlQfolFavUPosfJlmiTUKn4+6c1Po
X-Gm-Gg: AR+sD11slUL8DS41X9coA0w1Mp5kdKKjsSxdTvskbCLxeiM8q61+3JEoicumty0taaE
	vz5n/Xezynu3WKAK7puaxh0vsiqMhGWN+aeEz4dMArBT6D8ILyKbZ0i6uTn9WI4CErq34RmlUML
	uD6O+Inm/QdvcAGD+Koi0pKd5IC0pTl5JSsUYnqXEQRJdexe5qTb+sxlCrSu3V4nLnPC613SaGZ
	0c7mIHqP3pZ6MGneV9ZT/6ONVDMrxqiCK7mEt/9ZfQqSrytsNhFCgdgj43THcZgZtR4sbtbYCKo
	aDlkD0HjugcrMYdQ31STXaqNHMpopHvLpf2NH6u9AqhggvYcqp93vtzwjQHYBeCuJu20Sc7dmtc
	Okx2wXAPq95swkypgY+PZvXUfzB/JmZgodOsTrp8H2gJVM7b+ZIkGzkB8Vwy1KEJ2BMgGsVOlNs
	qUgJSCQUtT3mROI/v8Q3hQ3kfLsHTFRk750DrdJAhS67YutRGJISooS6JISIUY6bB6yNv7n1ELG
	l2Y/K+PXzSJ5Uc5RFA=
X-Received: by 2002:a05:6a00:ba8d:b0:82f:50cd:e586 with SMTP id d2e1a72fcca58-851fa018939mr7767261b3a.13.1787300284873;
        Fri, 21 Aug 2026 01:18:04 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d3362860sm2564222b3a.8.2026.08.21.01.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:18:04 -0700 (PDT)
Date: Fri, 21 Aug 2026 16:17:55 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <aedcacce-4880-41b0-a4a6-d892465fff57@gmail.com>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-2-vernon2gm@gmail.com>
 <aoMs79VDCnYvA9S7@lucifer>
 <aoMzkN8EfFllT5zH@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMzkN8EfFllT5zH@lucifer>
X-Rspam-User: 
X-Stat-Signature: uq7ocsj6ok3eryyh9j3zearwf8cjaxae
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36A4CA0006
X-HE-Tag: 1787300286-279197
X-HE-Meta: U2FsdGVkX194C2Yk7P1x7z/klluacyhulSgrjoZdYP+Uts5oXf0lYTv00u4DWo6uPDQr1nCw0vb47qwKsfFSUGrRH4272VUBn3qHADboBbv3ew5XuMn93SXXCxRm6599ggqccfycdsnWn1c+bicsrQChT6Lsz0m+fSfSj636tSqYuqhzmSTEgP1zrXy/wJT7Z2FP/6v9dwuB45mcmPKdZx0lrMI3XC25rmZcVlrlY86trUjNFw8mqo6EsCqdHt5M+OV4+uvvyX5o52jXthX1557U6J3zO83FpuB/wnTNjJfRxI3OHEvHRkNI2/M1pDO3gE3ryQtuyBHPIWNsyTCKVr6gTTKzrXfCWCFidzJ6dKNUAIVbPnSwu78VKqLqYcKvnDREVm2EQZMRZ1CrayYu5R/85rH7KQkbZ+7GLg99GUEsLHuT/vvMQ8WTFVALZj7kbjgR/Ktlqdqa45vYhvnt/fdH9r70z0wWB6VPkP7XgRcIeEAwhZ+zWzwQaEl+tluKn3g/QcmsI5K/ZsOl/OVUlGcWKo0+29RVcpnpdP8NEUwyX3t5RcR1LA/q9Pb0gW2uTGT5qWV/cs4HUbghJ/Ulh6unEK/axEzVk90JTtf4/Mf8rnE1PGj1gGjWIfwo4cX0t6QJ7Nb2ulB52oMUB6aZTeiIAmlRADLyOXfbeUkS+FW0Q5u4jDB6TjvqQTLJutHxdoSWX4vgxWpQuIyl+zoorhYGAw/mcx7C0PZ5Q2C7XzD2HPF9MJOT4qRn/Z4F2hgqgOysQGKKI3Ds/Tejct1DnZWghVQNbqeOPGu9Oo/PWEArL2ok2/oBB/xyfh6+zyh2JmPtrd4knmpsJP3YucQtSdztvUM5eM0QKUzfIgnAv/Rs/e1X9BG+ALE5y1+aO0RSwu0NRBte4d4N934EFs1mVm/M9s3iVIfozZSljeR0bAvvZnvlH/SfrW1T7mo6sB3tnZxld0nOU4rbc/2n69M
 yVIN8ZMQ
 nSYnChgW+NU0BtoSX3UyiJtbgb/FP6oNRcOC34rEanc7ILlLUsEyexLvB77EaiEZU+9yp46P8jFl61sYJUCLGRDmCq5cOSLGGiDsAjcW7L1LmknqzlvER1tV4bK2fmCVlErnAEttYDvFz6oSoZI07HMOUI5KuPmKs8/eFhLKfLImnlfqkDrkO1ltHL/eM4Ea4zjbE3azg/w1zZVd8XmYbPEDSM+kFad/z1XjG0V876ancFjvO6gWObJOKEYfl6QUR7ezn/5vEZ11BECQASr8/IyPJ3O1ApOl03fAQQcF6VbF55AatP9WYmjfBcYquoVjy+tWphzJTiqch791kWkzTUPdJJ8ycmyxpo9aaiyW2wRNga1gimSw8PQlCdYbS165Yv6ve2VAUH5Np0n4O7h9rwhgMh+G0KlWPkkZi0CuA39j0Yv4aGXE4+1l535NtMmYAz8R5bV6Sj5sRDcIBoWpmHg6/AgxTLMrpNCUtpm0PmmPDFLL36aNzni1ooT9ZuJk/n7VpMSRt4WOBRmEyNIcBr4brSVG1CCZkNvD+1WkosnEq8rI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:23:30PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 17, 2026 at 05:10:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Aug 15, 2026 at 01:19:22PM +0800, Vernon Yang wrote:
> > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > >
> > > When the swap entries found exceed max_ptes_swap, the loop is left via
> > > break with folio still holding the xarray value that encodes the swap
> > > entry, not valid folio pointer.
> > >
> > > That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> > > to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> > > plain pointer arithmetic, so the trace event merely prints bogus
> > > scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> > > dereferencing the tiny encoded integer and oopsing khugepaged whenever
> > > the trace event is enabled.
> >
> > Hmm I seem to recall that we were no longer spporting !VMEMMAP SPARSEMEM, but
> > maybe I was imagining that :)
>
> OK seems some museum piece architectures are causing us issues again, fun times
> (parisc and some mips).
>
> >
> > But this needs fixing in general anyway.
> >
> > >
> > > So when folio is the swap entry value, simply set pfn to -1, just like
> > > exhausted scan naturally.
> > >
> > > And the folio_put() has maybe dropped the last reference of folio. The
> > > trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> > > so using the folio_pfn() before dropping the reference, closing
> > > use-after-free window.
> > >
> > > Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > ---
> > >  include/trace/events/huge_memory.h |  6 +++---
> > >  mm/khugepaged.c                    | 14 +++++++++-----
> > >  2 files changed, 12 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > > index 291fae364c62..d3572d4ef453 100644
> > > --- a/include/trace/events/huge_memory.h
> > > +++ b/include/trace/events/huge_memory.h
> > > @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
> > >
> > >  TRACE_EVENT(mm_khugepaged_scan_file,
> > >
> > > -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> > > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
> > >  		 int present, int swap, int result),
> > >
> > > -	TP_ARGS(mm, folio, file, present, swap, result),
> > > +	TP_ARGS(mm, pfn, file, present, swap, result),
> > >
> > >  	TP_STRUCT__entry(
> > >  		__field(struct mm_struct *, mm)
> > > @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> > >
> > >  	TP_fast_assign(
> > >  		__entry->mm = mm;
> > > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > > +		__entry->pfn = pfn;
> >
> > I wonder how easy it is for people to interpret that this is a PFN of something
> > only in the case of an early exit.
> >
> > It's a bit of a mess that we're exposing internal implementation details like
> > this, quite honestly.
> >
> > I hope there is no expectation of this being there indefinitely.
> >
> > >  		__assign_str(filename);
> > >  		__entry->present = present;
> > >  		__entry->swap = swap;
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 617bca76db49..e7830761d3a2 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> > >  	int present, swap;
> > >  	int node = NUMA_NO_NODE;
> > >  	enum scan_result result = SCAN_SUCCEED;
> > > +	unsigned long pfn;
> >
> > See below I think we should drop it.
>
> OK we can't because of museum piece architectures that will actually deref the
> folio to get the PFN...
>
> I'd startr by initialising this to -1 then since I guess in theory it's possible
> xas_for_each() could just not do anything is it? (folio is being set to NULL so
> that suggests so).
>
> >
> > >
> > >  	present = 0;
> > >  	swap = 0;
> > > @@ -2720,27 +2721,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> > >  			 * PMD-sized THP implies that we can only try
> > >  			 * retracting the PTE table.
> > >  			 */
> > > -			folio_put(folio);
>
> I still hate the idea of moving these outside of the loop, it's just asking for trouble.
>
> So I guess instead:
>
> 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
> 		pfn = -1;
> 		...
> 		if (xa_is_value(folio)) {
> 			...
> 		}
> 		pfn = folio_pfn(folio);
> 		...
> 	}
> 	...
> 	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
>
> That way you avoid the horror or moving the folio put somewhere deeply
> unintuitive and inconsistent, and maintain pfn lifetime for some arches nobody
> uses.

Thank you for the reference solution. After studying the overall
process, I found that the above solution still has two issues:

- When `!folio_try_get(folio)` or `folio != xas_reload(&xas)`, if the
  next `xas_for_each()` iteration happens to terminate, pfn will be
  incorrect, which is inconsistent with previous versions.
- when the `xas_for_each()` iteration to terminate and the folio
  operation preceding is normal. but pfn will be incorrect, also same
  issue.

To keep it simple, I modified it as follows. Is this OK?

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 79effd3f3da4..00337405c0e0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2689,6 +2689,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long pfn;

 	present = 0;
 	swap = 0;
@@ -2719,6 +2720,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}

+		pfn = folio_pfn(folio);
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
@@ -2779,7 +2781,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		}
 	}

-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, (!folio || xa_is_value(folio)) ? -1 : pfn,
+				      file, present, swap, result);
 	return result;
 }

--
Cheers,
Vernon

>
> > >  			break;
> > >  		}
> > >
> > >  		node = folio_nid(folio);
> > >  		if (collapse_scan_abort(node, cc)) {
> > >  			result = SCAN_SCAN_ABORT;
> > > -			folio_put(folio);
> > >  			break;
> > >  		}
> > >  		cc->node_load[node]++;
> > >
> > >  		if (!folio_test_lru(folio)) {
> > >  			result = SCAN_PAGE_LRU;
> > > -			folio_put(folio);
> > >  			break;
> > >  		}
> > >
> > >  		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
> > >  			result = SCAN_PAGE_COUNT;
> > > -			folio_put(folio);
> > >  			break;
> > >  		}
> > >
> > > @@ -2759,7 +2756,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> > >  			cond_resched_rcu();
> > >  		}
> > >  	}
> > > +	if (!folio || xa_is_value(folio)) {
> > > +		pfn = -1;
> > > +	} else {
> > > +		pfn = folio_pfn(folio);
> > > +		folio_put(folio);
> > > +	}
> >
> > Hmm kinda hate this you're now mixing clean up logic with some trace logic.
> >
> > You have to go check out xas_for_each() and see that xas_next_entry() sets folio
> > to NULL at the end for the normal case to know this is OK and then figure out
> > that this is just for the break cases.
> >
> > That's not intuitive in already not intuitive code.
> >
> > And this is a patch you're wanting to backport to fix a bug too... :)
> >
> > I think you should keep the folio_put()'s where they are for now and limit this
> > fix to the trace code please.
> >
> > I think you should drop the pfn var altogether and do this far more simply, see
> > below.
> >
> > >  	rcu_read_unlock();
> > > +
> >
> > Stray newline added, let's not do that for a backported fix please :)
> >
> > >  	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
> > >  		cc->progress++;
> > >  	else
> > > @@ -2774,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> > >  		}
> > >  	}
> > >
> > > -	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> > > +	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
> >
> > I mean maybe better to just reduce this to something like:
> >
> > 	/* folio is NULL unless exited early. */
> > 	trace_mm_khugepaged_scan_file(mm,
> > 			(!folio || xa_is_value(folio)) ? -1 : folio_pfn(folio),
> > 			file, present, swap, result);
> >
> > As the least invasive way of fixing the trace + limiting the contageon?
>
> Yeah as above this isn't right.
>
> >
> > >  	return result;
> > >  }
> > >
> > > --
> > > 2.53.0
> > >
> >
> > --
> > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo
>


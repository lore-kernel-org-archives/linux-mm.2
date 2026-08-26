Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9016EC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8056C6B0099; Wed, 26 Aug 2026 05:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5C26B009B; Wed, 26 Aug 2026 05:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4696B009D; Wed, 26 Aug 2026 05:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC9C6B0099
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:08:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B76D11202F8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:08:55 +0000 (UTC)
X-FDA: 85142845830.02.8887B73
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id E57C6120003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:08:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LT892Fod;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735333;
	b=QN2lWPJE8o3TdktMcPc0DUNkxBErCygzOpc9s8sc6JNp47TuRC6aogGU2YAUsPVhbKcGaj
	a3n+Oc2h2sS5cMUctCucOJ1Yy6TFk5o5RY3QMISKXKKKfVpaA6Dp7aR+BweRdNXSdyASiM
	zcyZMqwXNtF1oCjHLIimjdDb45f6xo4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LT892Fod;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsy4CZwXyrUEQvKaVnRxCtC5ibMuY6bQzne6mmJqiFY=;
	b=58ViroJdcKBioOMs+DtRW/2iTg6t4rrNQcrBYk2BNlFsXK7WGgVqtemnZa2Rr/jATVT+kq
	a3jv27bCsbxMHexNNCdpo2v/4M4b6grbA1R8tecYuvvaiWlhCoM53zqlexYmykZQAVWRsQ
	zxBrpgkl2yknSQYOv3y9K3dAf4t7k3A=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-853f8c34ba4so470450b3a.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787735333; x=1788340133; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wsy4CZwXyrUEQvKaVnRxCtC5ibMuY6bQzne6mmJqiFY=;
        b=LT892Fod1o0FuXPFq9w+aPUFzWRkqwiCE/p5URSG5BXTgMDvx7IigxqzVBtYndYHYw
         iLvHh1HH+HM+C0fxsFjHKP2GLsUW0CtCVX3dzoqoZd9YIsuNXi8RmKVFnaoR1QW2vuTW
         kLJSdW04WLhXhm2NziZZ5Vp+1ErGNz2wVxjWBcdXIa8nmM7+mV/xbIKbkT6A1yBvGAsr
         aFCav22lyQ9OEQxcXOJGxMqjVTdYa3sQw8wL7vLwTLucfp+U7KcpWQJjoasY8fSyrT+B
         tre5w7hyhRdUMjd70dAe4s7MNp750gkAExmpoT+bCVGL8XNVU0nRfV4Z/gZ9y9rLAYJl
         zjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735333; x=1788340133;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsy4CZwXyrUEQvKaVnRxCtC5ibMuY6bQzne6mmJqiFY=;
        b=dbuQo1pm93GJ7bCkPbGaqQ6jxyvgj1Wy/RKRv4JDu9RKp4FOCwLCYzh1PTG+FvXFf8
         /kXlX60NeIT2cjs3lU0qhp5dSxSLWOSwHNIhKHejWctfpDPywu+pDaikAcl+bV4X/aEv
         3+SrFfJUGEnAAUZ7LcQf2xX532SkGKb7WsOx84z3hMBbkPDtCLFj3+volS6i9KnOOLk5
         xiDplSZJCfRU2haQNsipEr3dlaZsNtIXSmdAWTctiklRgBRWahd+4bK7tRXJOQjP/77N
         RKATwFcmMds7wR9xlu5W6WWe7+zfXIag/xSX1l0T1BxWJ/NDOMirK+kETZ2A/nBb4yi2
         WMuA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4Ia/kazoXSwCXv76lneGtD8TfQa8f785m+oJm0VHrT4LYkh8x6xOvU21Ei351mHCYxoYBb4NlOw==@kvack.org
X-Gm-Message-State: AFuF++nBvZEjtvtJfz4VfzUxgSjlTDtOHzfHRFXRcv3NUTI21ed9i3He
	0SvJ5faWFPL8Y0qA4eWsTuLkRZ/V080ERE3qaRt/5aUBLvyroop7dz1j
X-Gm-Gg: AR+sD11hE5H2tH07ineJG4r+g+bXmVN4HQMzuYwP6jRvzSIrCazp1ph0o9w4ajXxHY6
	LH74S+8p6i2JxnN4lgiqigkHeId6KYTkZJalOWMjPxgHepot+mbLyzCa4DBlYCzuVicUHOigEd6
	UnQwPElcFXXJ4ZH86WfO/Ak8UD5cXLoV1RG4svzGsQOb13QbD6NWJbKQVtpPapNslXnAoYi3kpJ
	ptsAEs+oNBWa0xozh6e4X+8L66ucWJ0Nh6KM6HLwBxhMjUz3mJpxlG3UBvQOEaKqefLd3JFq5cp
	ttpTU5sSLDm1w9qF4jlxZNGyNtRbBGYvPIGmK5CtYGPnkqBsdV5L+yO9irrtDN+vdCTaP6+8qO4
	JbUtYe++ZPb9a8Qsg/68Aln/AbTO0qNWBPnnCk1LItQHA8SboUNCzFIE4nWHiyqTaH/8TWCa7hz
	i3eQiKXhRhoVZq+QMZAIIoyiZBllRVGkDc7/8udVrx+cxwSX3sYffgDYO4G6jBCDncCrvcBCroF
	20=
X-Received: by 2002:a05:6a00:4149:b0:852:5f99:1866 with SMTP id d2e1a72fcca58-8536e922f5fmr10466435b3a.0.1787735332560;
        Wed, 26 Aug 2026 02:08:52 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8535cd809bdsm669384b3a.28.2026.08.26.02.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 02:08:52 -0700 (PDT)
Date: Wed, 26 Aug 2026 17:08:44 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <50c73754-5e6e-48af-9d8e-148f4596387b@gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E57C6120003
X-Stat-Signature: pheip3o4n6ngafmrqimuotwa4wcrga3p
X-HE-Tag: 1787735333-605838
X-HE-Meta: U2FsdGVkX1/eKX4VxIR7ivss9dkC/RPXQzHk0ZONO2j+PPtJjplOV7rMM+b7Io59ctY6+a5rvE9sy42uoYr1zwhwuH4s4wZS9LLYu0QXi5ypfc6q/KWnz4o4yt6XN8vfGe/nBjy7GzxiiO69gmdos6iTexJ6hZ0rhYsYlwoBb96fmujwiAhxBeNXZTm/y/KQQu6uT17pQXOa+G1kX5x5AISP31kKVDQ6Iv5uF4XGbJ4u5RGFa3zAsYrqyVZIXs+YzmZnUTibyDQpa6WjtAqVdBTU0+jf8BB4irjVwvI6RLInZlbEKHLS9A/9vkrSnwG70ckoH0/+YzUq73XtwGDIGf0a76hdp9eX3aqXsbzuKijH9OuMWSLIT/IwjzZUKEHD86u2VIOHJEsPB1Pzy/bq/xAAWTiD0HqibjHYPHy4uk3PAyjO5J4S0P4Id64vGdxx6p0hbjGXpBFan1mja8RJKGupBAN1Xz9SFgqTDqRpbps7RNNqRS2MWYQdghZRMqv5/82FX7Cof5uD8X+k3p7JOB0xSSmdh51Uz5Tgbxm+Mo84hi9QFVGevSVslrIKQr51yDGmiurl3PANAX3XXEk1PFWkEWUUdLVLZYEqAyEg7IUlaY9XAMv+216WN22sKJm3OnCloeCkXp6O+1qmi3lUOuIcnZHNzppNdDmyeTwueEruIRjcFTYfElY2/POPd0BJ3jZx3dMD3r6QCfsXGb2W8PE5rpadWJ7fDsSU/ntj/Z5f/sZ7yMYc41bueyILgpL3W2Er+Cf3QDmzCJGoi5MeSm3KoB5hYQ0921NIeptAZiJ9fvOBwdEaKgoliJeYQYoFFrTrWV0L09n3N4O92X4kYV+2OvVTbwWd+rR1Ev8w1OoUR1v7T+JMX3bYdpZZ3T3KFxqQ4t8Dcysr2xbDqnnwnMrhUazXQxXj2rig9Tet6tqrrxXBkTbLPmfVTO2RCJmUteop5KeKVvEJHVS48Fx
 IBYG7A7m
 tJYJ42WodzVMHtZ9h2d+Yr4vdNtIHq4VGqENWBWFALG9PTpe3S+lWQwcgBio7mfKJN343jpEWQG5bri40jb99UjdFRpH0cQsHocFZOoVJP+V3pm7w2B4upjOiUxPfDqqsthADlWm6rSvgeOgooP+3Fd4EB0tifmOR8TQOpKkEy9LkhZyQzYmfQfkMtmrb904IwKO/SJzpqELbaMF1BL+kb9r9d6qyuW5omTK1kVvNrtJcFuAwAKp+RetWIM6fgMDPJZYC+iEohCcWYblqpocTP2bWfQ4jqrIYokJmgxZcVuHFvjvoe21+8AsHlHWGqqal5z3ONx6wQe1jvr0+HJEnaFIPQDxTwQPL63zyjsXinN4KL8fgj51y7aJ+RNeb4gmAy0fD3RPT6qqbTNnUOQVplZp40ZHimDfgGzQOXfSW4Z7elPNjb1VpE4aqNIp80R2pJhbZi7+FMAnOneIwdkxEaEfKNWLt/ZGMPQUMtvTdgqVbOse5iSDTFFz5p9zTXlSDQlJQMfZJUTYIxZn2KZp3/XkD3V48Q1oB7oFAZGRJ7FriqwE=
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

Yes, this is clearer. I considered this approach before, but it would be
quite verbose.

LGTM, I will use this in the next version. Thanks!

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
>


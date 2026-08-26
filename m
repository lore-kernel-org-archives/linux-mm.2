Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EEFC61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18CB46B008C; Tue, 25 Aug 2026 22:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A476B0092; Tue, 25 Aug 2026 22:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052A36B0095; Tue, 25 Aug 2026 22:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD1436B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:44:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 319A44021B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:44:55 +0000 (UTC)
X-FDA: 85141878150.14.AA8ED93
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 59C52140005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:44:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZ7lLYko;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787712293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cA8BuFbVdWVsPxBHUcYsv9jfBYLl6xZCnqzfAhivzwc=;
	b=xuKZ0K5R023N+k4YCsdWY5SJMcP31KC5RVG/UyeRsJMVndyO5ogYNy2UfJ4QjQfyVSxEye
	G8f4VCDaymZyCmiJpEQpLmhoCzMKztKC1FxYSY1U+C857z8a9rH5j+P3W/Qt/NtaNFRP5i
	T2ElhasTCTEQnayTr9XkXy/nqv0jm/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787712293;
	b=X7G33nF7T+//l8YEC01pqvuDijZVG31bldQ4GSOe2t9zWKM7LHQY0ROBN9HAkfMAfzxr0K
	1GcF8HfVBL7ynyTik/JBgQghwiYBvKjwhxEOMQcqWdwfFlFsPDalmwYNqNBxnUVsyVE8hX
	WKkT3yOVSEtbR29q+fI2E5VD0SfL4w8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZ7lLYko;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d6fe26ef1cso5769105ad.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787712292; x=1788317092; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cA8BuFbVdWVsPxBHUcYsv9jfBYLl6xZCnqzfAhivzwc=;
        b=dZ7lLYkomfSov/JmuKJupFwbKCg4gpzonQ12HNWsV24Wi+qgjB+fPe0PzyDalHWNoE
         XwSovSse3QVY5OelakBOhKdmZ1jU1EeUeomYae/0xrz25LTiV6Cn2AJ+AYpl5+t3/FqR
         lYeEYQvJKh/AXAgx5xz9yaYNRLDSnlFxpD2eD8IMQ7GgvTHV1cA/pkdbe24ivruMiqM4
         9A8sSkyPRCFksdeOHxd7zoMSLYiTY5IXr5PtxjKnGb3tsW08ORQ4sicjyRULpKATYDdC
         090tUXiLitcTCfaIMzCBsKa9wFP4oAKNQeXoTLBn6UFwLFvSUGY/+ft6ZvVRjL6NGzMu
         Lvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787712292; x=1788317092;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cA8BuFbVdWVsPxBHUcYsv9jfBYLl6xZCnqzfAhivzwc=;
        b=FxCj6Z/bkF/BJqUy9NsfrUimWKmjkapdmN7gOLMBtcEJBZkU+hPTJscAiKTyDw3D2a
         JIVt2fmC4kfoRMyR7m3vdqnJjfn4ZddZceUSkNJ3dt7yT+tTGfKnrFnURGjK6LyyVwDS
         EXt/e9SXB4uuvWukROp2NGnjPLxBPpxsUvbOxwmGuUVmUllywtVeinfcygLivozzL2XL
         prQLZ8NBv2qaz4oAP8cTyluO+0wTM8Oayp/o+LQVC4AyM6X2R0PshU906J2YGTvq3P8t
         B8smMbs6+OzFxkMo43rSbJH2FKmXidmqYkQHiBDtoTAl/An7BAWaNQTf5XK60/cpnNWp
         Pk1A==
X-Forwarded-Encrypted: i=1; AHgh+RrzXjyvnAjciKMivc34COfolhBzGHnwmxdwYsD2Dpi4FziUkMGgjvT+/C8VuF5HsWaIU2/NnT7Bhw==@kvack.org
X-Gm-Message-State: AFuF++l8dX9V2drfJxg7HA+yNKs/YZxTxVPgkRrMDzKUgD45BMmZoCp3
	vG4nMjQlmTCrz1jT/evqfOmwNrvWED5p0WKTEW9dUfr1s+otQcDcbY6y
X-Gm-Gg: AR+sD11HCOEeo7erj+E5L02DMLq2aq9V3TUoLaWvzJyq340gm1PqWG569PHKL/mxvBE
	3ImhqzlMMWv81Px0q1RjLDX677//GVgVyONbiXsforJtaNxTwPwyLGiPhBpwEppaJNpkKQvTrgT
	0bM9XuL0JmYf5Qd79C2QUA6y2tp2IpD3fWCwnFNgEu09LUw0E2LspAOTkMoNdsFU6yuh4xEtETk
	CVG1cHxB4mGGlkwRd3uTsa9CvgLErr5RW6ZFNr0n/rQDKfSrhBYBwpqzeKeA1vPZ4PND6x67VEl
	yfkec3/O55IHmrwwt5umOe3A9w1MVBEVy89Z5+Wack5/h7/TOWqfWf3/UKI5Em1Id3/RzS7wYJ2
	XobCHxniSgavas0DwfVguK2l470AU+vEzWVs/3AkN8fvgQcLcrsyic49kXaAwCpETE5zA8+ft9T
	QDKRRCR1YrqAyaMBWeKAxvViq2XXgkZvMUK5M5kvJut2Bw6ifahBjMmbVzMF1iFGySnVYnwiEv1
	pI=
X-Received: by 2002:a17:903:120c:b0:2c6:90ec:f601 with SMTP id d9443c01a7336-2d707aaad36mr41806225ad.8.1787712291979;
        Tue, 25 Aug 2026 19:44:51 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d704ba5ca3sm3296535ad.41.2026.08.25.19.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 19:44:51 -0700 (PDT)
Date: Wed, 26 Aug 2026 10:44:45 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59C52140005
X-Stat-Signature: ob4hifwtpjponueupb6zju4jng9ba6bp
X-Rspam-User: 
X-HE-Tag: 1787712293-935454
X-HE-Meta: U2FsdGVkX1+buqsebRS0nMcBHxTfCvsJ+ChgI5NGVwTtY6ssZSNQF2duARPQToGUtIwYiVJQgvX/ujEmyvtyMCn0qhc2++U1HRH7jakMBKmF9O6leTh3141xgrRenrIJqM+gjnCqdyQbpUbPo5OzGm9D65giyxB/TRm1BAyiNiPnxW1pS9v3Z6KOEJG/v2nZJNpvbUkH4Bm79w5SoRBLgNixKtPnLZcs2P2EjjR9O2oLCfQO0KGFDTXV3R4gNPO2SOAR9LsiCx3eYMjhoyD8pJPQU7t0TAE4dwLBfkwf1J2wRtkEqLyGUmJqFh36lOJDtHCf6fnQrG/kmxhmV1c1jKYxHKvPgzndg0tnYPeeKkMEV2+b6uCUnCqNb57XpRchyz80DXzbkzd307PIszv21vdHSggSKh5MJsUqKvQ/AlzUyPDRVn3UHxrC7efxEP3SiJlZEVan/2rQqIM+gKkPMTeUQ+PTXx/kvUzvi/Zo5RM/qPk3UdT+jMyNHwDDOCEysJqoBT694WxOzisDXkCpkfDdKuVm+NfGp/CFCICpr2IU5zXHMBq96bfKQDqQDuB+S/TzPEzYzj5ExLhTmEhamHAPUAmlexzUXAXtSON16jVMbad3QW422QEFi6faLDa93hxaL5T9b2mzDRG3jwyfiX5GHpC3NYSZpQFhI/tysXBlLQ0vzQ30uAWx9j/nf0H7CfRWAzKb/GxIg45y8DkGEZqzQEO7RqlNEd9+9RyxnZ4nncpwQMDMpe1qjoNKqWVKzN9s1f1pRfHYSO5oI8zXH7X43KFn8PM+yOC9Q6A20bZzf68E/JS4ns4ElTglt/wRKU6cW7agldJiAx31oddqg7AKAdGkbQTrgzrBpkfQXK/+F9eisYIcPRZwuv5hwSbiQa0PcQjzcrl1QQyEwdAEm3q7zL7XtMP+t+wfskjo80nQdLARi20zV9ifnkcYTCH4RjgmJjifhjziY7nbZtL
 jSiTVEYR
 EjTBe5Wa+zA0agAN6Wt7JjInCRobpVJxAvaMqJdVVI2suvmvzlBCaqmjEvUTxc2B+PmZ7YYua6viXDGN1IIppojqFOXi+e7xl3Ku2Imh92wfTtrBBicIoLJblF73bi/pNGAaN4tu0wFB19kCRPWFt5/OjXBUXJPiGWyYq3hduw8+gptcN1LnhMeJmMmn5YaFseFP0/qwVSVpdDIbDLTiiNZZ2aR9XHdNWmevIFxyzcmWJfj6S9OBQvAUPn7/TWJB4u3ydMpjoutjnbxaRwwspPQfnPknuS2YkQbTiubiSIYgIE3gwo/KURuZJh973BRc4pD5IAtjdI6xOjqCPrMBrdtNBgurwBjvCCy0UgzQHN82Jj7FD5hu1iB8nYu2nxS5S9n6oAtIzTa3wBAUm/JCkcEUfCsCP9y7YBs7GNJjfMh6To4MpflIPLBh343aKHKsq1WOOcw5z+F5rSIanRPxLeElIxrMMA9xqoiMmOQIULWET635atbyeprhbP/7h/zPXvKMBrC7o+ESls20zDezA7Ra2ra2hP5MkoogtwkMDQPw9L5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 01:54:18PM +0200, David Hildenbrand (Arm) wrote:
> On 8/24/26 11:29, Vernon Yang wrote:
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
> >  include/trace/events/huge_memory.h | 6 +++---
> >  mm/khugepaged.c                    | 5 ++++-
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 5a48c5406cce..7b526528f85b 100644
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
> >  		__assign_str(filename);
> >  		__entry->present = present;
> >  		__entry->swap = swap;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 79effd3f3da4..00337405c0e0 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2689,6 +2689,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  	int present, swap;
> >  	int node = NUMA_NO_NODE;
> >  	enum scan_result result = SCAN_SUCCEED;
> > +	unsigned long pfn;
> >
> >  	present = 0;
> >  	swap = 0;
> > @@ -2719,6 +2720,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  			continue;
> >  		}
> >
> > +		pfn = folio_pfn(folio);
> >  		if (is_pmd_order(folio_order(folio))) {
> >  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> >  			/*
> > @@ -2779,7 +2781,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  		}
> >  	}
> >
> > -	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> > +	trace_mm_khugepaged_scan_file(mm, (!folio || xa_is_value(folio)) ? -1 : pfn,
> > +				      file, present, swap, result);
> >  	return result;
> >  }
> >
>
> Shouldn't we just reset PFN to -1 at the beginning of the loop (and set it
> initially)?

When the `xas_for_each()` iteration to terminate and the folio operation
preceding is normal, but pfn will be incorrect.

If we just reset PFN to -1 at the __ending__ of the loop (and set it
initially), then the above situation won't occur. If so, I will do it in
the next version.

--
Cheers,
Vernon


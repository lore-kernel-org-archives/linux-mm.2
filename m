Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19010C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0584E6B0088; Tue, 25 Aug 2026 22:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EFE6B008A; Tue, 25 Aug 2026 22:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60AF6B0096; Tue, 25 Aug 2026 22:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7ECE6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:47:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 429021C0F1C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:47:13 +0000 (UTC)
X-FDA: 85141883946.29.F89CB08
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BB17C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:47:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AcrVutnK;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787712431;
	b=zQiS2ytfbExtO3rG0nXbmFwDk160pCnjwTbDo3vxpSkgr9fob3v4+kApN2MRgwS29yRHMQ
	J0+zAuxUy01zJ9lwIpsQnepPM3FK0OeKHrVDQ7EtyVWqynzZy6yXFW/rywpvK1uelYoWoH
	/ngkZI5DIdwZdpRk4a8ofeT3itG9qtQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AcrVutnK;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787712431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXjvmi8viN65x79krJkouz9aQjeT14YyvTaCF6GTZNY=;
	b=rI0MKKxGPKKAz4BBuyyULxBDKXieWhXRgqmAbxertEbT2s6ZBWH6SWcH3SJY+gnXpN155b
	yA3p5t7D9QiySw+aKw/BH8bEAxLeswWwV0k+eTldPePKf8Yg9xoQ5ghOJsPFpECuHGtrlw
	TItOHCbpR6dNlgXdL+jjcdQrTn8IxbY=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e58034d05so585960a91.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787712430; x=1788317230; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cXjvmi8viN65x79krJkouz9aQjeT14YyvTaCF6GTZNY=;
        b=AcrVutnK5NI89EwpzcqfzaI1cNLCeU8A6/cbTu4Xv6AfdqWTdQXTgVQuhOsJSoImAb
         Bwn+Y9vziafcHdUuUBwj1Tp7xeiunrhKzrFGpMV64YcxNlczweVrRZgOIO7xRuOQI5cK
         9xjcy8oOuVArxgyVJc/uBJMcZpEM2X8itfhHnoimXAyHUJ/U/UUmhG9pM/pzTZkgOtAC
         X4N2MPIyPxgjefLmYXrE9S+tYdBMzj/MJw3aDh+TSkB7NBjlf+pUu9VRcEuOnyyzW4vm
         l0C8vVNV2gXLdz8N1DaVdADXP8vu6zx55tS5VJq7buT12KKm1iNSRoAooyFcfYkNuHTJ
         hZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787712430; x=1788317230;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cXjvmi8viN65x79krJkouz9aQjeT14YyvTaCF6GTZNY=;
        b=XiPeh+Lw71hkUbTK6BJqvkv7XLE93sOQFLzy9BeDHqW6V8NtPcGI0VLfEBja3GilSm
         3NC3DtjEEJBnTze2V1T3Ubkaq2Up4672eC3pK/ova0uEMIt3qSvH3pbPupIvRzMvcp25
         ZNuPAHFp92cLJ7WFWlLaOuU7O8dCbu8nvDJzoScMB4anXzYuXdJXjXb2XmUQ/Av8lFoG
         bDOmyUySyqYUzyPcgLHkjuCg2OG1KXuLCB6HJVS3ni9CQa3Xx/4faqH1y+oB/NMl3ZLS
         Zq9jUkCbN4By3ppET/vL6SU7l9MqjaM/KjrCpPcqnsEXgGWI119x3qAcZJCWEVibwIAN
         UNeA==
X-Forwarded-Encrypted: i=1; AHgh+RpsCemkZfqu/AI8jUOKTekssZ0PuF3A4lVmbvTLH0BUBwsx+xzxpQkb4d0JaFIjI/S81TTMcirVJg==@kvack.org
X-Gm-Message-State: AFuF++ld/E/HGljmFTIv/Fk0jKQSryabSVg9IzKav8l8yADhmYoEPa5r
	J/uwgVtTPdWC5/OugbsBBYJyJNdn+IvLhM3q86enaSiwLZaxANnJJeci
X-Gm-Gg: AR+sD11+JvDutuFYEWH8exzQgealhy0ZiL74wjiIO/VPCDh16/GyAcvZyjZW+c62hNX
	9XvDKVBn/eJqPlnpoXaRC9R0kYYf8Nx0JKimLzzK4QF1hg8taPfGyPsPN+h6m6nYBBw+c8SeZHZ
	/wFxGyROIKdmC3aV3ZXl0As6aIOJwn1gmMWR4aJrdEVMx9SZ3XdscTYrGup6SZww32hry6lqXoR
	iO7q99BE8Pm3hEzjGnITgHBpvgF0TanIGF175/bWEFB2Ao9JVHpgjnNF6H2BbHCEo+Vq9hm5gXn
	L0M8al5imngeehc5vRikTnT5rKqrVgB/uvmLLBwp6pt4F5CGJhGzq5AmuheOyXQHEnK8wnNgse/
	kPwPZKRpKoDv9/p5Lt3PbbNpdeiIEnAfNOjTe3dB6MztnM1qlaCHafcpADW9IrsSdmnb5gdgvDh
	5Rc5VepO1qn48T4zw0G2vuxVzZDI4AJ0iNrAzMfZCIGKSWmBQHtHRGoXtC0LyGgtces0BvjJmlh
	To=
X-Received: by 2002:a17:90b:4b04:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-3966d5f900dmr7209602a91.8.1787712430105;
        Tue, 25 Aug 2026 19:47:10 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39668a573a1sm2053380a91.14.2026.08.25.19.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 19:47:09 -0700 (PDT)
Date: Wed, 26 Aug 2026 10:47:03 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 3/3] mm: khugepaged: fix folio is used after
 folio_put/unlock()
Message-ID: <50049af3-ff42-4017-a535-aca124620087@gmail.com>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-4-vernon2gm@gmail.com>
 <8001afe8-84e4-43d4-971b-b23f72070339@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8001afe8-84e4-43d4-971b-b23f72070339@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5BB17C0002
X-Stat-Signature: uf7p7oep191h1cy6dfhbqtt67yphnmif
X-Rspam-User: 
X-HE-Tag: 1787712431-211350
X-HE-Meta: U2FsdGVkX18ahvDpekKf3FRnDj1Gosu+vVeqqvHg+k7AGeOWRoSRRiG2oCgO7Z8QO663OVVgRIH9xkAV9O1z4i8euqG1hM2QBrDE5x0kjenFHyDFeRAbxTdaxTI1+NRO2Kr89v0wztaBOEuCweCfgUgVDbSuulTykOdSKuRoQhxChJ//Ajm8yZgWqbJxEbT6yDjqFouzBDfj0cLIB8RJB+NQi1rc9HN7dTHKZO0nOFnZftQ0zuFRMJ1ILBdh2xriTaQ5WiSzURs+vWvYSy1HVGlYeCcImFz2xKhAXzatptZ5DnQQYGTB70zrHr3hYiQpuSV2ZtIzzJFYdYebUA9nXd69hFyWp6XC0Q1zbtGc8aHWJpENaPFdZCFhTSwlOxBzrHPbB3AYHJx1idP43HCBxc/Iz/3jEkh9DRFjAmvfK3BSQoX73YP7qgqW0QcwYgA7ZT28pOr9mWfWh/hhQAywrOpdYe+9aDciMH5dzohoIDa/PhGJZDEQTjO70+Ovse5rZPQTe2kA0wubpMayxYjcILHQ1U2VFel9BYpmTotVmaxI0WQVU1ppsfZVwmsju96tQddkWwaGk5hFVHm5T0XyNITqpFd/ebKr7e79r9KlStEEhAX3zlDjUvB+F3uloZBsG9mZrjCkFzAg6ixISQFoeuPZ3vKg9jQ63bpa6QwblM26fe3QePf4rOyEJM2Dtj60vDa6+v7bzA2mZXCpOlGaiCgG8ezYOZ0Z5DasakZvch6Mp+MwkN7+j18WyIiYM1/Te13hw/lzV5U43JGuT7aE9nhAVBt41fl2KbX0wce0WtMxvn/wMw8t4vS2jgZSjtebQ9GMDGRoHpSXpawWgXY5nsy6hIPRWk4M67rYIQOkMrC6YONAgKa/UQyf0/NfNBqINNiB2/PXS011QTP+fdpd+jgqPlQZn4WblLXssA1may2JDUu7yb+J+wx43JIQu0/bxaMLIiQUQ7dlwIxbjo2
 DmJ0hPnA
 aSrxu165LynID13JJhRLGSCV1Tz+bYmev0pAlIqDmIwFePlicL7Mt28KzMxQ2Qa23cuV0x/aP+D27xVORr8snPq++Cw2zL/p5JF60YVTUTYyz1W9XYHD3qvLhUJ/TfP+BFf0DNLl1LV+HnwmrwXkKcHSQ0lWc38sVGr2Ci00jpEU8jP4tbCz3mTBbdCbKfWMz+8/ttiWlqKMGQWUdT6/bpq7enBTsLOQ+2hyHSs5iO8uoyvjAUMJhaNv1NLBPxAZ9BODQewWE3c/Ku/oXhBRDTM6hcacv7x77jT+V2jVkaiv/X/txcN7rJ1p/ky636Q7lLe+IuHq72tr/qGKj1W+n4yXCSoB0yEzZEw9mNWHwTDkUWl1aPg1wsqWsVKbz5cxwvApGxi4En99UdFeBTTd7sKVJ6NUcgQEdG8xtnOstCgkP+lmMguzV8V7Gn8FTXavR2R5ca4XyFPbR2rSfxkEp+nI9DyJcTKobuj/n6D081Icu60QA6GohEQCvGq+ETsmwh8GGCmSmEU/4MLPSpJEPtM/pYRZo6Mdd9xwUHG2D0+5Z33Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 01:59:53PM +0200, David Hildenbrand (Arm) wrote:
> On 8/24/26 11:29, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > On the rollback path, folio_put() has already dropped the last reference
> > of new_folio. On the success path, new_folio is already unlocked and can
> > be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
> > with a dangling folio pointer.
> >
> > So using the folio_pfn() before dropping the reference, closing
> > use-after-free window.
> >
> > Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h | 6 +++---
> >  mm/khugepaged.c                    | 5 ++++-
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index fa828967e1fb..5fb4d92cfd84 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> >  );
> >
> >  TRACE_EVENT(mm_khugepaged_collapse_file,
> > -	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
> >  			unsigned long addr, bool is_shmem, struct file *file,
> >  			int nr, int result),
> > -	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
> > +	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> >  		__field(unsigned long, hpfn)
> > @@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
> > +		__entry->hpfn = new_pfn;
> >  		__entry->index = index;
> >  		__entry->addr = addr;
> >  		__entry->is_shmem = is_shmem;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4e0fca5942dd..24347f1a94ae 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2254,6 +2254,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	struct address_space *mapping = file->f_mapping;
> >  	struct page *dst;
> >  	struct folio *folio, *tmp, *new_folio;
> > +	unsigned long new_pfn = -1;
> >  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
> >  	LIST_HEAD(pagelist);
> >  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> > @@ -2633,6 +2634,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	retract_page_tables(mapping, start);
> >  	if (cc && !cc->is_khugepaged)
> >  		result = SCAN_PTE_MAPPED_HUGEPAGE;
> > +	new_pfn = folio_pfn(new_folio);
>
> Why not set new_pfn once after successful alloc_charge_folio()?

LGTM, I'll do it in the next version. Thanks!

--
Cheers,
Vernon


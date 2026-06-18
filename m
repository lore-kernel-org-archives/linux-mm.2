Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA886CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84B26B0098; Thu, 18 Jun 2026 08:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A620E6B0099; Thu, 18 Jun 2026 08:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BD46B009D; Thu, 18 Jun 2026 08:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 637D66B0098
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:22:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA9261C4CB2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:22:01 +0000 (UTC)
X-FDA: 84892945242.18.DBD84BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D7C61C0003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:21:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eBThqHWB;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781785319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oakVwrtTl75e0l3uD7ktF2MwTm0qNsotBSURtRb5FJM=;
	b=P9jcAl/nLVyvGHJ2+HTa6fJ3rMGBX6KIZ+9rggyRQgclnrfun7+HfHs70gCkV8QJo7RJ5v
	AxBTJr7d672JzDYAB6+ExNwWIrnWTRDyuoqphIev6bK66U/CUz3vlK17wSOHXfV3kE1ETw
	ndm/454NTECnbM6z+uC8e6b/qQorxHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781785319;
	b=0alzvn7VAh5Ce9xpf1vyLx3F3PPoZOPC6R8zaF31SUuFCwEqOmPuCuD4AMtqyQi+1YpbT0
	s/BhTAD0LHr5N3OVx6q77XMsgOJiluN5h8YOtUaTo61142lLd+21uqSnU7cDo8ZrEehqrM
	s76qiHZRFq17PTjPHXIou+9q8ddBBtk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eBThqHWB;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781785318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oakVwrtTl75e0l3uD7ktF2MwTm0qNsotBSURtRb5FJM=;
	b=eBThqHWBlgxqk7HZmnYTq9QIF7iW6pR98k3YaN4t5wI1AdFBxBlLnQoKL0f5JIflkpL0nI
	zJWLt7OfS3KBBJY6Y3WbATpth93DBMTL9D68smY36VmPl4DyNXvQy0vPLnl/gYAnBe7ZdY
	YOW1fO8t7cic7LQ7RKqKpqJZaEuHZ7M=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-nhgNSDXINBisp5HYti_oIg-1; Thu, 18 Jun 2026 08:21:57 -0400
X-MC-Unique: nhgNSDXINBisp5HYti_oIg-1
X-Mimecast-MFC-AGG-ID: nhgNSDXINBisp5HYti_oIg_1781785316
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5aa6dbdee74so559020e87.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785315; x=1782390115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oakVwrtTl75e0l3uD7ktF2MwTm0qNsotBSURtRb5FJM=;
        b=I9V6nmrCE6lXPfjifcwhbE/MNerU5oBRAuRhD/1Xfcb23EwHCM0/njQtTr7QTSSbHg
         PPde25J0LM/ao+xuoqaAwizJtD77hL0/XgXXZAeGxMyuHKDhYuENb8v9AiR9JKsY9iu8
         O+Vr4qaI0Kwtynpmy0HW3MGYoFU2M5XPLMH63fTwMD+D84NJyMGbhKCtaaPQDuiA6z6I
         UOpQelMBu/UQZ/oaBylHetQ9HxjfTTyRuMwPUFwAPYcwEHbTcngq5QxNwRzinbabyT4V
         YdDdYIqXUEVXY6gpfwN9s2cN9sVekzRqsqUcUMfUEh5wnrFCx7xV0N3vYt40zG8ZHn7b
         eHig==
X-Forwarded-Encrypted: i=1; AFNElJ9u82nwK/XucVr8kDOHpl74HjQKU8PDptZVvqmbxa87lnGDNCdyuD1V1OLUxLk5uqq3C51y6nxmdw==@kvack.org
X-Gm-Message-State: AOJu0Ywh6jAG+Ds22RNOrzYL0Op74kkrVy8uNnaGtGu8Gy7Ll2PcOtG/
	akgLTPurX3u5sH7Hh25hEGZsPuO7hHI6XsDsJtPWt8uVYaKCaJ3vwDuJ0Lcm26d0EOgdrR2it9H
	t9mWAjdgVY/lmuVlnyogvqsCKOccQCrHqO55GGWsIMjUDfzbJE0VL0m63ilzb54rZcW1/Xf+t95
	9irGIXTyL5/MnUoLbDjhGBnF7BAEc=
X-Gm-Gg: AfdE7cmhfCE3aWMJsdq8+iroxkZBjfazcdR5ARaou668Bdsp1fkuej7aJi1GdzOQa1B
	yjEJGINNM5TfNra6pHKir82RKAc08llQImAxtkAsCjgubhokPRzd27dYuLgq0WRWYDeZzn+7pAy
	uWAZpjJRyRqbBCmVfUZGBM4RZxtqRk4E9Fr9nBseZ34DTVDvPkpq6/IWRiiJltCpr2dg==
X-Received: by 2002:ac2:4f09:0:b0:5aa:6b0b:1f25 with SMTP id 2adb3069b0e04-5ad46fbd043mr2595130e87.21.1781785315255;
        Thu, 18 Jun 2026 05:21:55 -0700 (PDT)
X-Received: by 2002:ac2:4f09:0:b0:5aa:6b0b:1f25 with SMTP id
 2adb3069b0e04-5ad46fbd043mr2595098e87.21.1781785314450; Thu, 18 Jun 2026
 05:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251008043748.45554-1-lance.yang@linux.dev> <20251008043748.45554-4-lance.yang@linux.dev>
 <80341f56-6f8f-4e41-8f80-f1863256c662@lucifer.local>
In-Reply-To: <80341f56-6f8f-4e41-8f80-f1863256c662@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Thu, 18 Jun 2026 06:22:49 -0600
X-Gm-Features: AVVi8CfJ0sd7UriSHb8HAxlkm6PJp1ZBqAMPe8985ASDobzYdIBND8EvQ_eAfIs
Message-ID: <CAA1CXcDv7WVxMcGv9OOZDzTzzcfEAnaGbX5dJGwqN5mSWkmRvA@mail.gmail.com>
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	ioworker0@gmail.com, richard.weiyang@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mHJ-5hRokB6ZFLPUEhviUwGuFhV8gQq9IsOG8zjPJEs_1781785316
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D7C61C0003
X-Stat-Signature: t13943het1nyk78puwuqwwwbjekbfo33
X-HE-Tag: 1781785319-34129
X-HE-Meta: U2FsdGVkX18gs83Pzkn9PTBxMMKqcLR+e8/1HbMdRSQMeBaexjj4lEzEmuQxWIjOB3QK1bBxeF4TKhbm1lr8iVFfZwIDJiz1paUZtIbxXN4qcRD4UXzm2TyD9b5jbaS0KdAj5Dtd+3b9BFYVSQK59JW8FXh1MXuRGw+VUYmLRV8QNtbClEQWgVzvCfZd5Zzq5OGCFR24Ki0yPA9JnYnuqhDbolbvEBb1SzJ5YcTCidc1UNkJj/5iLRP/rTg2NL95F1MT/czxZTwy/ivoDjLEG0aHJY5v7K1hj6FIsTJgYjwATzTEx47h5hI5hob5yzu9pkk3E9ikEg6LNIDKNrRtwEJGhsuqXG8dBoN/hRxdCrN0h6AqU86kU8e2OQ0hSLr//XCL4FKGGv63nOLjuwpVa93digCaSaxsEjOmjba20aKc1IQVw8x6FUIjhtqQIWlmay1fZT2Ci2vVg+Zo8HNlQaQAHnXypikFwR6SRqD097O3MMQBmnj+5U5640BuD24HkqYDbmxtn8HkmvNHktpFu9MNamc7SUML7rLdfa+JQwL+1hB5V0QQ0OsXf5m01z8Z/yIS8smL6YJIY7kaBDDdyWzwHXE+G3IpwEFFJu87Jf1dAQjW/RcqkhKDyXn7GJk29kNoYldYnC4KnC5noHInjCxUb3s8dTEVgtIuV82gU5I9Egu+sB5oR4pAuK2oLMHhzkcWC8Pcrv+aHL0a2hLsUyjXfxSLCNLnfRqyGK+r8bTMmkfPRdkHcbonWfgZQ9FSdT0CbRac9Int5YvklC8ot4c8l3OE9zfZWHnI5RGtUJUgEZNJmnofCygciRey8EeVu7CSVO7zJ0n6SJ6S7LEFYvfsQ6sbGCTo7f4YrOMit0ha65oohxh2me34eAiJh20LHXIQO9U4Su7FHUaegNJBLVg6VEak0fHzr36oZKOo9yvIDE5iez1EflKTszCCIzpsXewIGW0bHYOJX6zkhl1
 cVGthK/Q
 JpFwkB0qyKv5X+rYin9cdXhOLmeIy8dUjqK8GEpQY/4i8+1/HUc0Uxtu3wUE1ttIRpjAHJx2Gq84NOuPg/zqnmpJ6rAZ0W9bGSoS5ThLnTvWZhH2fYAO778/iFc1FlLuuih4fLCQvePiTdwYj24cCB0AU1q71KEmULC2PIukPMzyBCU+TLQRn3+65IKiCKYa7Tp7PY9niCPcJ+4o7lkIrwqqLiOzFLhlGxcVheykngD+1i+yd18Z5pPEiWdgyExmnK9mB4jRpgYjmCrqHvSTkGz+AklOFHFzvGadXcNU2pWeyvBlSx8MPNzINB/BE8KhTtEZ4MJ5qIljKC1pP2aBbWoHin7fTwxzTj6Uifecy+XJcK9SYUDkOX90MJxd4wHJCTOtV2iMKLnkDgS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 6:37=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> >
> > As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
> > and __collapse_huge_page_isolate() was almost duplicated.
> >
> > This patch cleans things up by moving all the common PTE checking logic
> > into a new shared helper, thp_collapse_check_pte(). While at it, we use
> > vm_normal_folio() instead of vm_normal_page().
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
>
> In general I like the idea, the implementation needs work though.
>
> Will check in more detail on respin
>
> > ---
> >  mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
> >  1 file changed, 130 insertions(+), 113 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b5c0295c3414..7116caae1fa4 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -61,6 +61,12 @@ enum scan_result {
> >       SCAN_PAGE_FILLED,
> >  };
> >
> > +enum pte_check_result {
> > +     PTE_CHECK_SUCCEED,
> > +     PTE_CHECK_CONTINUE,
>
> Don't love this logic - this feels like we're essentially abstracting
> control flow, I mean what does 'continue' mean here? Other than you're in=
 a
> loop and please continue, which is relying a little too much on what the
> caller does.
>
> if we retain this logic something like PTE_CHECK_SKIP would make more sen=
se.
>
>
> > +     PTE_CHECK_FAIL,
> > +};
> > +
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/huge_memory.h>
> >
> > @@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t =
*_pte,
> >       }
> >  }
> >
> > +/*
> > + * thp_collapse_check_pte - Check if a PTE is suitable for THP collaps=
e
> > + * @pte:           The PTE to check
> > + * @vma:           The VMA the PTE belongs to
> > + * @addr:          The virtual address corresponding to this PTE
> > + * @foliop:        On success, used to return a pointer to the folio
> > + *                 Must be non-NULL
> > + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
> > + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning =
swaps
> > + * @shared:        Counter for shared pages. Must be non-NULL
> > + * @scan_result:   Used to return the failure reason (SCAN_*) on a
> > + *                 PTE_CHECK_FAIL return. Must be non-NULL
> > + * @cc:            Collapse control settings
>
> Do we really need this many parameters? THis is hard to follow.
>
> Of course it being me, I'd immediately prefer a helper struct :)

Hey!

Ive been trying to reimplement this patch, and started converting this
to a helper struct... At first glance it seems like the right
approach, but because the scan/isolate share two slightly different
implementations, we need to leave some logic in the parent. This
results in polluting the rest of the code significantly just to save
one ugly function call with many parameters.

not sure what to do about that tbh.

e.g., (just one of many examples)


-                               NR_ISOLATED_ANON + folio_is_file_lru(folio)=
,
-                               folio_nr_pages(folio));
-               VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-               VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+                               NR_ISOLATED_ANON + folio_is_file_lru(ctx.fo=
lio),
+                               folio_nr_pages(ctx.folio));
+               VM_BUG_ON_FOLIO(!folio_test_locked(ctx.folio), ctx.folio);
+               VM_BUG_ON_FOLIO(folio_test_lru(ctx.folio), ctx.folio);

-               if (folio_test_large(folio))
-                       list_add_tail(&folio->lru, compound_pagelist);
+               if (folio_test_large(ctx.folio))
+                       list_add_tail(ctx.folio->lru, compound_pagelist);

Are we sure this helper structure is the right approach?

-- Nico

>
> > + *
> > + * Returns:
> > + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
> > + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
> > + *   PTE_CHECK_FAIL     - Abort collapse scan
> > + */
> > +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_str=
uct *vma,
>
> There's no need for inline in an internal static function in a file.
>
> > +             unsigned long addr, struct folio **foliop, int *none_or_z=
ero,
> > +             int *unmapped, int *shared, int *scan_result,
> > +             struct collapse_control *cc)
> > +{
> > +     struct folio *folio =3D NULL;
> > +
> > +     if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> > +             (*none_or_zero)++;
> > +             if (!userfaultfd_armed(vma) &&
> > +                 (!cc->is_khugepaged ||
> > +                  *none_or_zero <=3D khugepaged_max_ptes_none)) {
> > +                     return PTE_CHECK_CONTINUE;
> > +             } else {
> > +                     *scan_result =3D SCAN_EXCEED_NONE_PTE;
> > +                     count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> > +                     return PTE_CHECK_FAIL;
> > +             }
> > +     } else if (!pte_present(pte)) {
>
> You're now making the if-else issues with previous patches worse by
> returning which gets even checkpatch to warn you.
>
>         if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>
> (of course note that I am not convinced you can drop the pte_present()
> check here)
>
>                 (*none_or_zero)++;
>                 if (!userfaultfd_armed(vma) &&
>                     (!cc->is_khugepaged ||
>                      *none_or_zero <=3D khugepaged_max_ptes_none))
>                         return PTE_CHECK_CONTINUE;
>
>                 *scan_result =3D SCAN_EXCEED_NONE_PTE;
>                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>                 return PTE_CHECK_FAIL;
>         }
>
>         if (!pte_present(pte)) {
>                 ...
>         }
>
> But even that really needs seriously more refactoring - that condition
> above is horrible for instance so, e.g.:
>
>         if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>                 (*none_or_zero)++;
>
>                 /* Cases where this is acceptable. */
>                 if (!userfaultfd_armed(vma))
>                         return PTE_CHECK_SKIP;
>                 if (!cc->is_khugepaged)
>                         return PTE_CHECK_SKIP;
>                 if (*none_or_zero <=3D khugepaged_max_ptes_none)
>                         return PTE_CHECK_SKIP;
>
>                 /* Otherwise, we must abort the scan. */
>                 *scan_result =3D SCAN_EXCEED_NONE_PTE;
>                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>                 return PTE_CHECK_FAIL;
>         }
>
>         if (!pte_present(pte)) {
>                 ...
>         }
>
> Improves things a lot.
>
> I do however _hate_ this (*blah)++; thing. A helper struct would help :)
>
>
>
> > +             if (!unmapped) {
> > +                     *scan_result =3D SCAN_PTE_NON_PRESENT;
> > +                     return PTE_CHECK_FAIL;
>
> Can't we have a helper that sets the result, e.g.:
>
>         return pte_check_fail(scan_result, SCAN_PTE_NON_PRESENT);
>
> static enum pte_check_result pte_check_fail(int *scan_result,
>                 enum pte_check_result result)
> {
>         *scan_result =3D result;
>         return PTE_CHECK_FAIL;
> }
>
> And same for success/skip
>
> Then all of these horrible if (blah) { *foo =3D bar; return baz; } can be
> made into
>
>         if (blah)
>                 return pte_check_xxx(..., SCAN_PTE_...);
>
> > +             }
> > +
> > +             if (non_swap_entry(pte_to_swp_entry(pte))) {
> > +                     *scan_result =3D SCAN_PTE_NON_PRESENT;
> > +                     return PTE_CHECK_FAIL;
> > +             }
> > +
> > +             (*unmapped)++;
> > +             if (!cc->is_khugepaged ||
> > +                 *unmapped <=3D khugepaged_max_ptes_swap) {
> > +                     /*
> > +                      * Always be strict with uffd-wp enabled swap
> > +                      * entries. Please see comment below for
> > +                      * pte_uffd_wp().
> > +                      */
> > +                     if (pte_swp_uffd_wp(pte)) {
> > +                             *scan_result =3D SCAN_PTE_UFFD_WP;
> > +                             return PTE_CHECK_FAIL;
> > +                     }
> > +                     return PTE_CHECK_CONTINUE;
> > +             } else {
> > +                     *scan_result =3D SCAN_EXCEED_SWAP_PTE;
> > +                     count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> > +                     return PTE_CHECK_FAIL;
> > +             }
> > +     } else if (pte_uffd_wp(pte)) {
> > +             /*
> > +              * Don't collapse the page if any of the small PTEs are
> > +              * armed with uffd write protection. Here we can also mar=
k
> > +              * the new huge pmd as write protected if any of the smal=
l
> > +              * ones is marked but that could bring unknown userfault
> > +              * messages that falls outside of the registered range.
> > +              * So, just be simple.
> > +              */
> > +             *scan_result =3D SCAN_PTE_UFFD_WP;
> > +             return PTE_CHECK_FAIL;
> > +     }
> > +
>
> Again as all of the comments for previous series still apply here so
> obviously I don't like this as-is :)
>
> And as Andrew has pointed out, now checkpatch is finding the 'pointless
> else' issue (as mentioned above also).
>
> > +     folio =3D vm_normal_folio(vma, addr, pte);
> > +     if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
> > +             *scan_result =3D SCAN_PAGE_NULL;
> > +             return PTE_CHECK_FAIL;
> > +     }
> > +
> > +     if (!folio_test_anon(folio)) {
> > +             VM_WARN_ON_FOLIO(true, folio);
> > +             *scan_result =3D SCAN_PAGE_ANON;
> > +             return PTE_CHECK_FAIL;
> > +     }
> > +
> > +     /*
> > +      * We treat a single page as shared if any part of the THP
> > +      * is shared.
> > +      */
> > +     if (folio_maybe_mapped_shared(folio)) {
> > +             (*shared)++;
> > +             if (cc->is_khugepaged && *shared > khugepaged_max_ptes_sh=
ared) {
> > +                     *scan_result =3D SCAN_EXCEED_SHARED_PTE;
> > +                     count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> > +                     return PTE_CHECK_FAIL;
> > +             }
> > +     }
> > +
> > +     *foliop =3D folio;
> > +
> > +     return PTE_CHECK_SUCCEED;
> > +}
> > +
> >  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> >                                       unsigned long start_addr,
> >                                       pte_t *pte,
> >                                       struct collapse_control *cc,
> >                                       struct list_head *compound_pageli=
st)
> >  {
> > -     struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> >       unsigned long addr =3D start_addr;
> >       pte_t *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> > +     int pte_check_res;
> >
> >       for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
> >            _pte++, addr +=3D PAGE_SIZE) {
> >               pte_t pteval =3D ptep_get(_pte);
> > -             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> > -                     ++none_or_zero;
> > -                     if (!userfaultfd_armed(vma) &&
> > -                         (!cc->is_khugepaged ||
> > -                          none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> > -                             continue;
> > -                     } else {
> > -                             result =3D SCAN_EXCEED_NONE_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> > -                             goto out;
> > -                     }
> > -             } else if (!pte_present(pteval)) {
> > -                     result =3D SCAN_PTE_NON_PRESENT;
> > -                     goto out;
> > -             } else if (pte_uffd_wp(pteval)) {
> > -                     result =3D SCAN_PTE_UFFD_WP;
> > -                     goto out;
> > -             }
> > -             page =3D vm_normal_page(vma, addr, pteval);
> > -             if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
> > -                     result =3D SCAN_PAGE_NULL;
> > -                     goto out;
> > -             }
> >
> > -             folio =3D page_folio(page);
> > -             if (!folio_test_anon(folio)) {
> > -                     VM_WARN_ON_FOLIO(true, folio);
> > -                     result =3D SCAN_PAGE_ANON;
> > -                     goto out;
> > -             }
> > +             pte_check_res =3D thp_collapse_check_pte(pteval, vma, add=
r,
> > +                                     &folio, &none_or_zero, NULL, &sha=
red,
> > +                                     &result, cc);
> >
> > -             /* See hpage_collapse_scan_pmd(). */
> > -             if (folio_maybe_mapped_shared(folio)) {
> > -                     ++shared;
> > -                     if (cc->is_khugepaged &&
> > -                         shared > khugepaged_max_ptes_shared) {
> > -                             result =3D SCAN_EXCEED_SHARED_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> > -                             goto out;
> > -                     }
> > -             }
> > +             if (pte_check_res =3D=3D PTE_CHECK_CONTINUE)
> > +                     continue;
> > +             else if (pte_check_res =3D=3D PTE_CHECK_FAIL)
> > +                     goto out;
> >
> >               if (folio_test_large(folio)) {
> >                       struct folio *f;
> > @@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struct mm_st=
ruct *mm,
> >       pte_t *pte, *_pte;
> >       int result =3D SCAN_FAIL, referenced =3D 0;
> >       int none_or_zero =3D 0, shared =3D 0;
> > -     struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> >       unsigned long addr;
> >       spinlock_t *ptl;
> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> > +     int pte_check_res;
> >
> >       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >
> > @@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struct mm_st=
ruct *mm,
> >       for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >            _pte++, addr +=3D PAGE_SIZE) {
> >               pte_t pteval =3D ptep_get(_pte);
> > -             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> > -                     ++none_or_zero;
> > -                     if (!userfaultfd_armed(vma) &&
> > -                         (!cc->is_khugepaged ||
> > -                          none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> > -                             continue;
> > -                     } else {
> > -                             result =3D SCAN_EXCEED_NONE_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> > -                             goto out_unmap;
> > -                     }
> > -             } else if (!pte_present(pteval)) {
> > -                     if (non_swap_entry(pte_to_swp_entry(pteval))) {
> > -                             result =3D SCAN_PTE_NON_PRESENT;
> > -                             goto out_unmap;
> > -                     }
> >
> > -                     ++unmapped;
> > -                     if (!cc->is_khugepaged ||
> > -                         unmapped <=3D khugepaged_max_ptes_swap) {
> > -                             /*
> > -                              * Always be strict with uffd-wp
> > -                              * enabled swap entries.  Please see
> > -                              * comment below for pte_uffd_wp().
> > -                              */
> > -                             if (pte_swp_uffd_wp(pteval)) {
> > -                                     result =3D SCAN_PTE_UFFD_WP;
> > -                                     goto out_unmap;
> > -                             }
> > -                             continue;
> > -                     } else {
> > -                             result =3D SCAN_EXCEED_SWAP_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> > -                             goto out_unmap;
> > -                     }
> > -             } else if (pte_uffd_wp(pteval)) {
> > -                     /*
> > -                      * Don't collapse the page if any of the small
> > -                      * PTEs are armed with uffd write protection.
> > -                      * Here we can also mark the new huge pmd as
> > -                      * write protected if any of the small ones is
> > -                      * marked but that could bring unknown
> > -                      * userfault messages that falls outside of
> > -                      * the registered range.  So, just be simple.
> > -                      */
> > -                     result =3D SCAN_PTE_UFFD_WP;
> > -                     goto out_unmap;
> > -             }
> > +             pte_check_res =3D thp_collapse_check_pte(pteval, vma, add=
r,
> > +                                     &folio, &none_or_zero, &unmapped,
> > +                                     &shared, &result, cc);
> >
> > -             page =3D vm_normal_page(vma, addr, pteval);
> > -             if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
> > -                     result =3D SCAN_PAGE_NULL;
> > -                     goto out_unmap;
> > -             }
> > -             folio =3D page_folio(page);
> > -
> > -             if (!folio_test_anon(folio)) {
> > -                     VM_WARN_ON_FOLIO(true, folio);
> > -                     result =3D SCAN_PAGE_ANON;
> > +             if (pte_check_res =3D=3D PTE_CHECK_CONTINUE)
> > +                     continue;
> > +             else if (pte_check_res =3D=3D PTE_CHECK_FAIL)
> >                       goto out_unmap;
> > -             }
> > -
> > -             /*
> > -              * We treat a single page as shared if any part of the TH=
P
> > -              * is shared.
> > -              */
> > -             if (folio_maybe_mapped_shared(folio)) {
> > -                     ++shared;
> > -                     if (cc->is_khugepaged &&
> > -                         shared > khugepaged_max_ptes_shared) {
> > -                             result =3D SCAN_EXCEED_SHARED_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> > -                             goto out_unmap;
> > -                     }
> > -             }
> >
> >               /*
> >                * Record which node the original page is from and save t=
his
> > --
> > 2.49.0
> >
>



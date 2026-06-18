Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65F8CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878206B009E; Thu, 18 Jun 2026 09:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828456B009F; Thu, 18 Jun 2026 09:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A11D6B00A0; Thu, 18 Jun 2026 09:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31E6E6B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:18:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 760E51C3082
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:18:53 +0000 (UTC)
X-FDA: 84893088546.12.AD8A5B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B55CEC0013
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:18:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P7PY2Erh;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781788731;
	b=ye8FAK860O8wrohxnwqSvuzG4F/9XsjwZ9jPiuOnHqKcMcwTB9aw4PlR5VHzioo/3q/mVe
	MlFrKGl+oyXOVP+4XYdHzHA7qIukBvgEvkI1eiZ4uJkaUDCLcNdqRuY8ZjCjPUj8+KzpBd
	9lck3NbHmfefXM2JYq1ch0+ZEb5z6eg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P7PY2Erh;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781788731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Za9Bazfw1mwjRkfnUkqhxca8JaHcZvFlfnIZYYyltvQ=;
	b=CKcgWxJBEk9ampKBzU07M+0ZMSM4whShsXpA3mjpPrYELvFBHlc3xrwjYuDJzrBH9jvgrQ
	V32waw84B5w9MUu7ZOgO+5UqyBxML1FQMdUAzLGiA7g4TU0Hauw1Q2uD/w321fdTwVR1Ft
	X258cMmM89uUILbq+xF+br26bZLcsms=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781788730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Za9Bazfw1mwjRkfnUkqhxca8JaHcZvFlfnIZYYyltvQ=;
	b=P7PY2ErhkoDhrIrCVrXpmIdyBD0Bd9QTjqeJAjwo5m0sVu90BAFpysMAKmVE0KuG2xS3Uk
	XVm7jVjGJ2ltbCRB6QK+g7JJ+qktRlGyNuCxGZFpSNURc6w15vMUKZeQkubncxOQffyWyV
	8sTOxosIM391NwAen0pjhi/oMgEBWhU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-RFqE2gEjP-u_X91LlVpSfA-1; Thu, 18 Jun 2026 09:18:48 -0400
X-MC-Unique: RFqE2gEjP-u_X91LlVpSfA-1
X-Mimecast-MFC-AGG-ID: RFqE2gEjP-u_X91LlVpSfA_1781788727
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-396aa7e147bso6059101fa.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781788727; x=1782393527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Za9Bazfw1mwjRkfnUkqhxca8JaHcZvFlfnIZYYyltvQ=;
        b=NFeQCQAG7K28TWsEiOuS+yYEZc0+6xDBzt7wzHCcWir+EilrCxloIVid2ZtkXwGLOT
         74Q8667aqJc4ORojwtn6i5gR6M/D8kNL6nZDQPNwjf1KqWDACPAn9XxXzpAZ0r6p45YL
         lWiX4vyD6iWbBepA9GWHPO3u/nv2I6Df7lnsaxg+pBx1J9+/AMnke0SjCtaJ+tw5jVsl
         O/A1M70XI1BuLHfLLrvAdBuVka+T25ztM44biE3vgXftI91kIPFCWke/CQa4e1u0X3vj
         8f3SbGxG2A8/TMVSN9QZ9Ny6z9AO3Qvgg/6xcVOMRkEUp7TIP7+fv1k/2gYp6WJMICvO
         hxUw==
X-Forwarded-Encrypted: i=1; AFNElJ8DzxB6nvrTFNFgWtSEaNnaqguk9x2/eEyV9o7v1vwxy15YouveLoPXOCHyAbZH12NT9XRd/UyOPA==@kvack.org
X-Gm-Message-State: AOJu0YxVu3r2cf95Pis5oxTYj08Stty8WL75WduxUp2ZBUk5SKEveKwL
	KQhlGfAdv/XVuAzVobdw0s0OUAuJrWfyGCcO2DE2OWfJsNFkddB2njUCu7rLm53EYI3s0oxJTWY
	IYTHQiH8RnDepAf197U76ek6h3iHVTp4I3z64tyJK/WZafrC5r+Diff+DhhEMERQdR6VPKUCoBk
	aUOAdrArFJhChMAg5DSNt3bV7ivFg=
X-Gm-Gg: AfdE7clCQ8sKbbJeBT2Ag0DdnWLU4sqxlsVbw0LEYDpV69vtBQ8cVcBpV/Ke9ir3QIM
	9es1vlMBJEHHkx/eGGonaPATvNC2tpZ1E/5OP4sUSH/izWsMwbCvAZpXG33STF58a7Uy4EkPI5w
	pu9cxUHnYLmK+AkpZxAz8tuPssRjFOaUmdtaolv5sdZMNGXBWq0t2H66TTH2wgxUOQMA==
X-Received: by 2002:a05:651c:1b11:b0:396:95eb:160e with SMTP id 38308e7fff4ca-3997780a7e0mr11389001fa.23.1781788726843;
        Thu, 18 Jun 2026 06:18:46 -0700 (PDT)
X-Received: by 2002:a05:651c:1b11:b0:396:95eb:160e with SMTP id
 38308e7fff4ca-3997780a7e0mr11388451fa.23.1781788725838; Thu, 18 Jun 2026
 06:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAA1CXcDv7WVxMcGv9OOZDzTzzcfEAnaGbX5dJGwqN5mSWkmRvA@mail.gmail.com>
 <20260618131024.69667-1-lance.yang@linux.dev>
In-Reply-To: <20260618131024.69667-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Thu, 18 Jun 2026 07:19:41 -0600
X-Gm-Features: AVVi8CdyZHdBkPEbQw-fZn3otpUNKJY8MTqqVGcOEn3U6bSTmYgFJZ5MYiT0jtQ
Message-ID: <CAA1CXcA581SeWTWOz=Kcrw=LW5tshzWyNZMtCnn-X5PrZ0RFVg@mail.gmail.com>
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, david@kernel.org, ljs@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _zp9aLr1IrlFO4N5eS4RUe2O02b5uqSKQZ79Yo31U_M_1781788727
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B55CEC0013
X-Rspam-User: 
X-Stat-Signature: 1tt5ze7fwxmgnis16ws9rpogixds8kdw
X-HE-Tag: 1781788730-859068
X-HE-Meta: U2FsdGVkX18G35v9iQay0dNmmuFW0mKLuDIpzo+X69wfO6VrWr3ssKYiIBkKn7wvS55do62c1B2orww/nkJ3dk/7GCjNoahuff20x4xqquLlyOm/nFyYhSj3GaEOB27Xa/EYk2mqT2nsRyY4TPbd4waAKgT6OYah6Mh7oyMIkPNyIolewPOT0YNQZVJGSlXOc7TeGYwPCU+TK7SnIwlxEcLgpsRFUNGyyb3+FrpdQUwORj8Rc50ON/5u1PRXj4yfEfxBpkdEft9pnp/xhZ9X7QxNexDY0npkcUjNNFhJZGIgXLDsxijUIh3GQ1IzjsVjp4E0XA8H00D5F8yBIRZKrNUIcCJkK2wJnbl5cPC3Y27bmmH22gv3+sRgLYXNTazwDkLWrb+qgOrB6D/d+xn29OxMHWkzUe+s3a4ui+c26iX6TijInKKzgQdkmaX+5p33S4/i2D3j5wVlA7S0zQKJ8/h6LmSf/HBsVuTWuVJwR5YZQgyJCU+rkcsOGkO1BVbDmiCI+6WqnkW5nFUgE+av1iSx15Z0GU4SjMDxv2MSTcBZoMCZqBcun2Ejy1GnHrA7czc9E2K4+V9brUId9uSF12VA133bv1oX3U/zux/Wq+QpetlUSY9M6GC8o3fIuIDt8kJabFDGM+Znw9JtNIgM9YRC04h5cbbwSFYuuNDX7UAmbCIL1VCSStHwoBC9E57G0KHTW+nbZO+ggPrYCRWtEjnGCwWlk7lmxlmPRt6EHnIuuyHpFHtcboMo0kjcbX9fGUvQwJamql+otSvN6NMx4u7yCAwiEaVJ3V5P1DrSiyBMOO5G8mqwR/E47BLI0T5vcg7Ythjp89sUR+WW/GpGOeGF7P3FiBNcxIadU8GRAE4gwQSN7SFpYcvmyKHW/vT7J30OikiUTt196oFtgj9SeyHpF6Ok4fi6wby/4Nsf6ktytYTUN+fkAsiAcOBHpnczalNGS2d+ZT6EC1cwtq9
 54U+VRSw
 oZgvfifHErtz3ndqmhk2M0Ks5CkYWuolSCF9JSCmLZPcXGerc0s/Ye7lh2UMhTY0nptOaeRXxZxQhAbSyKh9VaEUlvc1s2UTQbK8KjLh59OGVy1AqqpR+HRlYcMPtCWUirFQoIrJAT5kDPnNloHB8UzAzHHMV4yvI3eKD40Sj5NAEn7f5mQlSfCQPY7n1aGOlwCLtaNhBpC/A1oJecCUUAR6bdhUcfWOiBMl8MifEXodR+5uDsYiamT1WgBQ2SafqPIpR0CI3D5d2IaDWY1OpuCsbeFGqGxYiOAzvFyYJpV3vUFZItS1ot/ruPLwIR6XUq2Cg3ptjtNL62Kn0hgAke1IdVUq70p//XfjWIghCR2M+ITtyXUuSJh4v2b8ry8zVUMEjFn5qsADhamo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 7:10=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> +Cc David and Lorenzo, address oops fixed :)
>
> On Thu, Jun 18, 2026 at 06:22:49AM -0600, Nico Pache wrote:
> >On Tue, Oct 14, 2025 at 6:37=E2=80=AFAM Lorenzo Stoakes
> ><lorenzo.stoakes@oracle.com> wrote:
> >>
> >> On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
> >> > From: Lance Yang <lance.yang@linux.dev>
> >> >
> >> > As David suggested, the PTE scanning logic in hpage_collapse_scan_pm=
d()
> >> > and __collapse_huge_page_isolate() was almost duplicated.
> >> >
> >> > This patch cleans things up by moving all the common PTE checking lo=
gic
> >> > into a new shared helper, thp_collapse_check_pte(). While at it, we =
use
> >> > vm_normal_folio() instead of vm_normal_page().
> >> >
> >> > Suggested-by: David Hildenbrand <david@redhat.com>
> >> > Suggested-by: Dev Jain <dev.jain@arm.com>
> >> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >>
> >> In general I like the idea, the implementation needs work though.
> >>
> >> Will check in more detail on respin
> >>
> >> > ---
> >> >  mm/khugepaged.c | 243 ++++++++++++++++++++++++++-------------------=
---
> >> >  1 file changed, 130 insertions(+), 113 deletions(-)
> >> >
> >> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> > index b5c0295c3414..7116caae1fa4 100644
> >> > --- a/mm/khugepaged.c
> >> > +++ b/mm/khugepaged.c
> >> > @@ -61,6 +61,12 @@ enum scan_result {
> >> >       SCAN_PAGE_FILLED,
> >> >  };
> >> >
> >> > +enum pte_check_result {
> >> > +     PTE_CHECK_SUCCEED,
> >> > +     PTE_CHECK_CONTINUE,
> >>
> >> Don't love this logic - this feels like we're essentially abstracting
> >> control flow, I mean what does 'continue' mean here? Other than you're=
 in a
> >> loop and please continue, which is relying a little too much on what t=
he
> >> caller does.
> >>
> >> if we retain this logic something like PTE_CHECK_SKIP would make more =
sense.
> >>
> >>
> >> > +     PTE_CHECK_FAIL,
> >> > +};
> >> > +
> >> >  #define CREATE_TRACE_POINTS
> >> >  #include <trace/events/huge_memory.h>
> >> >
> >> > @@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte=
_t *_pte,
> >> >       }
> >> >  }
> >> >
> >> > +/*
> >> > + * thp_collapse_check_pte - Check if a PTE is suitable for THP coll=
apse
> >> > + * @pte:           The PTE to check
> >> > + * @vma:           The VMA the PTE belongs to
> >> > + * @addr:          The virtual address corresponding to this PTE
> >> > + * @foliop:        On success, used to return a pointer to the foli=
o
> >> > + *                 Must be non-NULL
> >> > + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
> >> > + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanni=
ng swaps
> >> > + * @shared:        Counter for shared pages. Must be non-NULL
> >> > + * @scan_result:   Used to return the failure reason (SCAN_*) on a
> >> > + *                 PTE_CHECK_FAIL return. Must be non-NULL
> >> > + * @cc:            Collapse control settings
> >>
> >> Do we really need this many parameters? THis is hard to follow.
> >>
> >> Of course it being me, I'd immediately prefer a helper struct :)
> >
> >Hey!
> >
> >Ive been trying to reimplement this patch, and started converting this
> >to a helper struct... At first glance it seems like the right
> >approach, but because the scan/isolate share two slightly different
> >implementations, we need to leave some logic in the parent. This
> >results in polluting the rest of the code significantly just to save
> >one ugly function call with many parameters.
>
> Been a while ... so I don't fully recall anymore :)
>
> If you already have a patch or series, maybe just post it and we can look
> at the actual diff.
>
> Probably easier than talking about it without seeing the code :D

Yeah fair point!

I think I found a good intermediate solution after all. Which was to
keep the folio local (not part of the helper), as that was the major
source of the noise.

I have a work-in-progress series to address a number of cleanups, the
code should be ready at the start of next week. I just want to test
and verify things first, and it's best not to post at the end of the
week :)

-- Nico

>
> Cheers, Lance
>
> >
> >not sure what to do about that tbh.
> >
> >e.g., (just one of many examples)
> >
> >
> >-                               NR_ISOLATED_ANON + folio_is_file_lru(fol=
io),
> >-                               folio_nr_pages(folio));
> >-               VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> >-               VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> >+                               NR_ISOLATED_ANON + folio_is_file_lru(ctx=
.folio),
> >+                               folio_nr_pages(ctx.folio));
> >+               VM_BUG_ON_FOLIO(!folio_test_locked(ctx.folio), ctx.folio=
);
> >+               VM_BUG_ON_FOLIO(folio_test_lru(ctx.folio), ctx.folio);
> >
> >-               if (folio_test_large(folio))
> >-                       list_add_tail(&folio->lru, compound_pagelist);
> >+               if (folio_test_large(ctx.folio))
> >+                       list_add_tail(ctx.folio->lru, compound_pagelist)=
;
> >
> >Are we sure this helper structure is the right approach?
> >
> >-- Nico
> >
> >>
> >> > + *
> >> > + * Returns:
> >> > + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further che=
cks
> >> > + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
> >> > + *   PTE_CHECK_FAIL     - Abort collapse scan
> >> > + */
> >> > +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_=
struct *vma,
> >>
> >> There's no need for inline in an internal static function in a file.
> >>
> >> > +             unsigned long addr, struct folio **foliop, int *none_o=
r_zero,
> >> > +             int *unmapped, int *shared, int *scan_result,
> >> > +             struct collapse_control *cc)
> >> > +{
> >> > +     struct folio *folio =3D NULL;
> >> > +
> >> > +     if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> >> > +             (*none_or_zero)++;
> >> > +             if (!userfaultfd_armed(vma) &&
> >> > +                 (!cc->is_khugepaged ||
> >> > +                  *none_or_zero <=3D khugepaged_max_ptes_none)) {
> >> > +                     return PTE_CHECK_CONTINUE;
> >> > +             } else {
> >> > +                     *scan_result =3D SCAN_EXCEED_NONE_PTE;
> >> > +                     count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> >> > +                     return PTE_CHECK_FAIL;
> >> > +             }
> >> > +     } else if (!pte_present(pte)) {
> >>
> >> You're now making the if-else issues with previous patches worse by
> >> returning which gets even checkpatch to warn you.
> >>
> >>         if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> >>
> >> (of course note that I am not convinced you can drop the pte_present()
> >> check here)
> >>
> >>                 (*none_or_zero)++;
> >>                 if (!userfaultfd_armed(vma) &&
> >>                     (!cc->is_khugepaged ||
> >>                      *none_or_zero <=3D khugepaged_max_ptes_none))
> >>                         return PTE_CHECK_CONTINUE;
> >>
> >>                 *scan_result =3D SCAN_EXCEED_NONE_PTE;
> >>                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> >>                 return PTE_CHECK_FAIL;
> >>         }
> >>
> >>         if (!pte_present(pte)) {
> >>                 ...
> >>         }
> >>
> >> But even that really needs seriously more refactoring - that condition
> >> above is horrible for instance so, e.g.:
> >>
> >>         if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> >>                 (*none_or_zero)++;
> >>
> >>                 /* Cases where this is acceptable. */
> >>                 if (!userfaultfd_armed(vma))
> >>                         return PTE_CHECK_SKIP;
> >>                 if (!cc->is_khugepaged)
> >>                         return PTE_CHECK_SKIP;
> >>                 if (*none_or_zero <=3D khugepaged_max_ptes_none)
> >>                         return PTE_CHECK_SKIP;
> >>
> >>                 /* Otherwise, we must abort the scan. */
> >>                 *scan_result =3D SCAN_EXCEED_NONE_PTE;
> >>                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> >>                 return PTE_CHECK_FAIL;
> >>         }
> >>
> >>         if (!pte_present(pte)) {
> >>                 ...
> >>         }
> >>
> >> Improves things a lot.
> >>
> >> I do however _hate_ this (*blah)++; thing. A helper struct would help =
:)
> >>
> >>
> >>
> >> > +             if (!unmapped) {
> >> > +                     *scan_result =3D SCAN_PTE_NON_PRESENT;
> >> > +                     return PTE_CHECK_FAIL;
> >>
> >> Can't we have a helper that sets the result, e.g.:
> >>
> >>         return pte_check_fail(scan_result, SCAN_PTE_NON_PRESENT);
> >>
> >> static enum pte_check_result pte_check_fail(int *scan_result,
> >>                 enum pte_check_result result)
> >> {
> >>         *scan_result =3D result;
> >>         return PTE_CHECK_FAIL;
> >> }
> >>
> >> And same for success/skip
> >>
> >> Then all of these horrible if (blah) { *foo =3D bar; return baz; } can=
 be
> >> made into
> >>
> >>         if (blah)
> >>                 return pte_check_xxx(..., SCAN_PTE_...);
> >>
> >> > +             }
> >> > +
> >> > +             if (non_swap_entry(pte_to_swp_entry(pte))) {
> >> > +                     *scan_result =3D SCAN_PTE_NON_PRESENT;
> >> > +                     return PTE_CHECK_FAIL;
> >> > +             }
> >> > +
> >> > +             (*unmapped)++;
> >> > +             if (!cc->is_khugepaged ||
> >> > +                 *unmapped <=3D khugepaged_max_ptes_swap) {
> >> > +                     /*
> >> > +                      * Always be strict with uffd-wp enabled swap
> >> > +                      * entries. Please see comment below for
> >> > +                      * pte_uffd_wp().
> >> > +                      */
> >> > +                     if (pte_swp_uffd_wp(pte)) {
> >> > +                             *scan_result =3D SCAN_PTE_UFFD_WP;
> >> > +                             return PTE_CHECK_FAIL;
> >> > +                     }
> >> > +                     return PTE_CHECK_CONTINUE;
> >> > +             } else {
> >> > +                     *scan_result =3D SCAN_EXCEED_SWAP_PTE;
> >> > +                     count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> >> > +                     return PTE_CHECK_FAIL;
> >> > +             }
> >> > +     } else if (pte_uffd_wp(pte)) {
> >> > +             /*
> >> > +              * Don't collapse the page if any of the small PTEs ar=
e
> >> > +              * armed with uffd write protection. Here we can also =
mark
> >> > +              * the new huge pmd as write protected if any of the s=
mall
> >> > +              * ones is marked but that could bring unknown userfau=
lt
> >> > +              * messages that falls outside of the registered range=
.
> >> > +              * So, just be simple.
> >> > +              */
> >> > +             *scan_result =3D SCAN_PTE_UFFD_WP;
> >> > +             return PTE_CHECK_FAIL;
> >> > +     }
> >> > +
> >>
> >> Again as all of the comments for previous series still apply here so
> >> obviously I don't like this as-is :)
> >>
> >> And as Andrew has pointed out, now checkpatch is finding the 'pointles=
s
> >> else' issue (as mentioned above also).
> >>
> >> > +     folio =3D vm_normal_folio(vma, addr, pte);
> >> > +     if (unlikely(!folio) || unlikely(folio_is_zone_device(folio)))=
 {
> >> > +             *scan_result =3D SCAN_PAGE_NULL;
> >> > +             return PTE_CHECK_FAIL;
> >> > +     }
> >> > +
> >> > +     if (!folio_test_anon(folio)) {
> >> > +             VM_WARN_ON_FOLIO(true, folio);
> >> > +             *scan_result =3D SCAN_PAGE_ANON;
> >> > +             return PTE_CHECK_FAIL;
> >> > +     }
> >> > +
> >> > +     /*
> >> > +      * We treat a single page as shared if any part of the THP
> >> > +      * is shared.
> >> > +      */
> >> > +     if (folio_maybe_mapped_shared(folio)) {
> >> > +             (*shared)++;
> >> > +             if (cc->is_khugepaged && *shared > khugepaged_max_ptes=
_shared) {
> >> > +                     *scan_result =3D SCAN_EXCEED_SHARED_PTE;
> >> > +                     count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> >> > +                     return PTE_CHECK_FAIL;
> >> > +             }
> >> > +     }
> >> > +
> >> > +     *foliop =3D folio;
> >> > +
> >> > +     return PTE_CHECK_SUCCEED;
> >> > +}
> >> > +
> >> >  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> >> >                                       unsigned long start_addr,
> >> >                                       pte_t *pte,
> >> >                                       struct collapse_control *cc,
> >> >                                       struct list_head *compound_pag=
elist)
> >> >  {
> >> > -     struct page *page =3D NULL;
> >> >       struct folio *folio =3D NULL;
> >> >       unsigned long addr =3D start_addr;
> >> >       pte_t *_pte;
> >> >       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, re=
ferenced =3D 0;
> >> > +     int pte_check_res;
> >> >
> >> >       for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
> >> >            _pte++, addr +=3D PAGE_SIZE) {
> >> >               pte_t pteval =3D ptep_get(_pte);
> >> > -             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) =
{
> >> > -                     ++none_or_zero;
> >> > -                     if (!userfaultfd_armed(vma) &&
> >> > -                         (!cc->is_khugepaged ||
> >> > -                          none_or_zero <=3D khugepaged_max_ptes_non=
e)) {
> >> > -                             continue;
> >> > -                     } else {
> >> > -                             result =3D SCAN_EXCEED_NONE_PTE;
> >> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PT=
E);
> >> > -                             goto out;
> >> > -                     }
> >> > -             } else if (!pte_present(pteval)) {
> >> > -                     result =3D SCAN_PTE_NON_PRESENT;
> >> > -                     goto out;
> >> > -             } else if (pte_uffd_wp(pteval)) {
> >> > -                     result =3D SCAN_PTE_UFFD_WP;
> >> > -                     goto out;
> >> > -             }
> >> > -             page =3D vm_normal_page(vma, addr, pteval);
> >> > -             if (unlikely(!page) || unlikely(is_zone_device_page(pa=
ge))) {
> >> > -                     result =3D SCAN_PAGE_NULL;
> >> > -                     goto out;
> >> > -             }
> >> >
> >> > -             folio =3D page_folio(page);
> >> > -             if (!folio_test_anon(folio)) {
> >> > -                     VM_WARN_ON_FOLIO(true, folio);
> >> > -                     result =3D SCAN_PAGE_ANON;
> >> > -                     goto out;
> >> > -             }
> >> > +             pte_check_res =3D thp_collapse_check_pte(pteval, vma, =
addr,
> >> > +                                     &folio, &none_or_zero, NULL, &=
shared,
> >> > +                                     &result, cc);
> >> >
> >> > -             /* See hpage_collapse_scan_pmd(). */
> >> > -             if (folio_maybe_mapped_shared(folio)) {
> >> > -                     ++shared;
> >> > -                     if (cc->is_khugepaged &&
> >> > -                         shared > khugepaged_max_ptes_shared) {
> >> > -                             result =3D SCAN_EXCEED_SHARED_PTE;
> >> > -                             count_vm_event(THP_SCAN_EXCEED_SHARED_=
PTE);
> >> > -                             goto out;
> >> > -                     }
> >> > -             }
> >> > +             if (pte_check_res =3D=3D PTE_CHECK_CONTINUE)
> >> > +                     continue;
> >> > +             else if (pte_check_res =3D=3D PTE_CHECK_FAIL)
> >> > +                     goto out;
> >> >
> >> >               if (folio_test_large(folio)) {
> >> >                       struct folio *f;
> >> > @@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struct mm=
_struct *mm,
> >> >       pte_t *pte, *_pte;
> >> >       int result =3D SCAN_FAIL, referenced =3D 0;
> >> >       int none_or_zero =3D 0, shared =3D 0;
> >> > -     struct page *page =3D NULL;
> >> >       struct folio *folio =3D NULL;
> >> >       unsigned long addr;
> >> >       spinlock_t *ptl;
> >> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> >> > +     int pte_check_res;
> >> >
> >> >       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >> >
> >> > @@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struct mm=
_struct *mm,
> >> >       for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD=
_NR;
> >> >            _pte++, addr +=3D PAGE_SIZE) {
> >> >               pte_t pteval =3D ptep_get(_pte);
> >> > -             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) =
{
> >> > -                     ++none_or_zero;
> >> > -                     if (!userfaultfd_armed(vma) &&
> >> > -                         (!cc->is_khugepaged ||
> >> > -                          none_or_zero <=3D khugepaged_max_ptes_non=
e)) {
> >> > -                             continue;
> >> > -                     } else {
> >> > -                             result =3D SCAN_EXCEED_NONE_PTE;
> >> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PT=
E);
> >> > -                             goto out_unmap;
> >> > -                     }
> >> > -             } else if (!pte_present(pteval)) {
> >> > -                     if (non_swap_entry(pte_to_swp_entry(pteval))) =
{
> >> > -                             result =3D SCAN_PTE_NON_PRESENT;
> >> > -                             goto out_unmap;
> >> > -                     }
> >> >
> >> > -                     ++unmapped;
> >> > -                     if (!cc->is_khugepaged ||
> >> > -                         unmapped <=3D khugepaged_max_ptes_swap) {
> >> > -                             /*
> >> > -                              * Always be strict with uffd-wp
> >> > -                              * enabled swap entries.  Please see
> >> > -                              * comment below for pte_uffd_wp().
> >> > -                              */
> >> > -                             if (pte_swp_uffd_wp(pteval)) {
> >> > -                                     result =3D SCAN_PTE_UFFD_WP;
> >> > -                                     goto out_unmap;
> >> > -                             }
> >> > -                             continue;
> >> > -                     } else {
> >> > -                             result =3D SCAN_EXCEED_SWAP_PTE;
> >> > -                             count_vm_event(THP_SCAN_EXCEED_SWAP_PT=
E);
> >> > -                             goto out_unmap;
> >> > -                     }
> >> > -             } else if (pte_uffd_wp(pteval)) {
> >> > -                     /*
> >> > -                      * Don't collapse the page if any of the small
> >> > -                      * PTEs are armed with uffd write protection.
> >> > -                      * Here we can also mark the new huge pmd as
> >> > -                      * write protected if any of the small ones is
> >> > -                      * marked but that could bring unknown
> >> > -                      * userfault messages that falls outside of
> >> > -                      * the registered range.  So, just be simple.
> >> > -                      */
> >> > -                     result =3D SCAN_PTE_UFFD_WP;
> >> > -                     goto out_unmap;
> >> > -             }
> >> > +             pte_check_res =3D thp_collapse_check_pte(pteval, vma, =
addr,
> >> > +                                     &folio, &none_or_zero, &unmapp=
ed,
> >> > +                                     &shared, &result, cc);
> >> >
> >> > -             page =3D vm_normal_page(vma, addr, pteval);
> >> > -             if (unlikely(!page) || unlikely(is_zone_device_page(pa=
ge))) {
> >> > -                     result =3D SCAN_PAGE_NULL;
> >> > -                     goto out_unmap;
> >> > -             }
> >> > -             folio =3D page_folio(page);
> >> > -
> >> > -             if (!folio_test_anon(folio)) {
> >> > -                     VM_WARN_ON_FOLIO(true, folio);
> >> > -                     result =3D SCAN_PAGE_ANON;
> >> > +             if (pte_check_res =3D=3D PTE_CHECK_CONTINUE)
> >> > +                     continue;
> >> > +             else if (pte_check_res =3D=3D PTE_CHECK_FAIL)
> >> >                       goto out_unmap;
> >> > -             }
> >> > -
> >> > -             /*
> >> > -              * We treat a single page as shared if any part of the=
 THP
> >> > -              * is shared.
> >> > -              */
> >> > -             if (folio_maybe_mapped_shared(folio)) {
> >> > -                     ++shared;
> >> > -                     if (cc->is_khugepaged &&
> >> > -                         shared > khugepaged_max_ptes_shared) {
> >> > -                             result =3D SCAN_EXCEED_SHARED_PTE;
> >> > -                             count_vm_event(THP_SCAN_EXCEED_SHARED_=
PTE);
> >> > -                             goto out_unmap;
> >> > -                     }
> >> > -             }
> >> >
> >> >               /*
> >> >                * Record which node the original page is from and sav=
e this
> >> > --
> >> > 2.49.0
> >> >
> >>
> >
> >
>



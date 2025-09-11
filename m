Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26768CAC583
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228408E0002; Thu, 11 Sep 2025 02:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8368E0001; Thu, 11 Sep 2025 02:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125558E0002; Thu, 11 Sep 2025 02:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 018918E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:20:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83DA9118C9D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:20:00 +0000 (UTC)
X-FDA: 83875968960.10.DF5A8EB
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2B24018000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:19:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FI7SlSgZ;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757571598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gW9kGgY5O1ezjweXONJKB6kktYtOO1YmCHdIBztrWyg=;
	b=DTZ8Km+RCStQ12RPbkdnLupIIT/rcHLheN//bjrJ1dF9UZzXGsBarDx+JZi4qVJKT+YIWt
	XkbdBtRIekAZrgVOBywwKv3CH2ZA8lvMxt0tz8mzTViXhm8iTjO1mw/vvq0XC9wBGgi5y6
	E3GLuVFKs0wT2OKC3TdhjWfxE7tAAs8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FI7SlSgZ;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757571598; a=rsa-sha256;
	cv=none;
	b=XHIVtEDdC+MHDdR/5lUnnFfC89JgFgxdUcMXPuC1YklNP4To22bhZvIOf7ze/cWSXeBivO
	nAmlpEONsft3F7p1PB52AqP9DE6Y6ZK8/wH4H8Qu5G3PYmCZ8R2HnkupUgU7RRTsx3u8ce
	b77paF7DyiSd2D0JQXUmT09ZDKSG6t4=
X-Gm-Message-State: AOJu0Yy1LKBrQZhYfKRR4BnGVT35wJx8u6NXWap61IVlIzQiwafEcwht
	T1pAXiXvf4GdUeGAq40md7pk429b/tPdD8+iyzxJLN7XduG9qbHuLtKhJJSzLNPCwaiU8V7BE4F
	smsNzAdzYKCq4CVD1wd1cWjNED0RKdP8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757571596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gW9kGgY5O1ezjweXONJKB6kktYtOO1YmCHdIBztrWyg=;
	b=FI7SlSgZ6T2JpoAbXzGYBPgBeOzqcveh2/uNEQHF1M9NjML0PvIG3gBH4XjfzZmhOEcr/T
	U+HgfIx04MIg5Bxs6r/iVw4GCCUb2jMzEkyOuxj0420fJrChykbb8qZgse9X4HcD6c5B4y
	YuMyyR6rsNFP5b/42Qpj+UwOSzVOPXI=
X-Google-Smtp-Source: AGHT+IFGtnt2Vv6SnW1AjDnoJHfVqQd98eP0nU8GK5mtsYSq4Y3GNWAX/MZSUTzZwyESeMv3dbmLCN1SIFPpKRJDb6Q=
X-Received: by 2002:a05:6214:20a1:b0:720:e4bd:d3f3 with SMTP id
 6a1803df08f44-762245144aamr20961806d6.26.1757571592842; Wed, 10 Sep 2025
 23:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250911021401.734817-1-balrogg+code@gmail.com> <9CD4E5BC-185A-47E6-9A2C-1B5416DC57EE@nvidia.com>
In-Reply-To: <9CD4E5BC-185A-47E6-9A2C-1B5416DC57EE@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 11 Sep 2025 14:19:13 +0800
X-Gmail-Original-Message-ID: <CABzRoyYo_dmzEJHQGiA3zc4uC_M9yKzEZ6L+VSbdG-t6fnahZA@mail.gmail.com>
X-Gm-Features: AS18NWAZxQBFYdwpNshSnWdM9G9E87ityKhXYKHZyrw40T9emGfPhd7ZwGCqXPs
Message-ID: <CABzRoyYo_dmzEJHQGiA3zc4uC_M9yKzEZ6L+VSbdG-t6fnahZA@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid poison consumption when splitting THP
To: Zi Yan <ziy@nvidia.com>, Andrew Zaborowski <balrogg@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4psbhoi3mks5nem4up69wgjtqhuskbiz
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B24018000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1757571597-869462
X-HE-Meta: U2FsdGVkX1+IH43xvqFmnQPA40QmV1ZeWOeEs3XflepPXNZ7h+Xr3QEGBjkSV/PZTzzW3pNKgmaLHyDLtLn17HtPsbn0DGDDyaN34NWJ0/vkODuSrLxlm+lw4bYyIt3TZWrMfHvnGZx3tj9fUaZpfAaPZ8pgFL0TbSX/fJ50HkqA4H6eHlpipU9pKNuixK6dyeuiIOj8j9KQUhy8Sb+/PuHlME+whzQNzBmKWEykG0ksKDfZfPL7p2zBVsD5HPQ9CVqeVvUBS6Wu1QeqcfYZFPXGl9NNYK927RUbKXYXrCjZ06HTZxf015NUb4oFS6/sZjw51F9ZJ6UsDPXrzqmkqF4ibCtOLgz4thSZMrQ8GnbtgchuK56zkoUrq1QJS9jf+7SEyiTyye0NyyOVksHpT3BfzOgxlkz+iIvRQKuBFz4z/X0ZbMLKy+aAZ24Oa5wnhP9ZDGZrmXOVHLonUum/a8NyhK3Ut/S7c78qPAXijlNNWxHEBT9t7fXxwE3umrl1TbCAFla/SIjUMBqQRaVxGETaezbbSgPDY1dX40GBbPeKJmXt7lFpsyHhxgTW/33C8NmESSuzHHtyydUMrfL6ntaTQgXfBV6dZQJk/IS1zgPq/a2AGzF8FjQs0HF+7EDpWPOt0mBHIw/kIpmEdcyQ9zztqaLTkIQcvJd2MJjsb9wJ+2KrSxTIAmr0b1/Aniq09CmmhzCrDskqbBAPtdiFMLtAW2zMx5fbGi7HevFljukTE9nFzsihmegSByKf51g9PpPr82P1ij9Fih1kpdpHB688ow8D33trZXKXcKECKOAYhtoiQ6TIcU5L6pDjiJB5X1wssGqrLQrnOlcFLRCt7OpEajVwq0yJDG1QL3zXy0eRRHiQpZe1wJokD6YF2LwcghiU7Sr04Jnn/IcNw5/ProPfqVTaYfzveREpnw8slMfRJ1myPk+iBTNOkE8fnXnoSb5QSadZRVN+RMn788a
 +H2Ksu6B
 zBp96+C47XU0LLt5nsjEmZQKxYZyH8/4PWovkRf5uxUbONzLLp7ZPV2saVcQHw8v9GGHMx3fZFal4t2TI0j96qyiJU17XFr0MNw5UXlv1KN/SUdhkO2a4MjaNDIORaSILwqkLTZdfptDX57p0lO61s7v0xymT8n3FpL4dmZa1ZCHvZolXejBFKQKgenAM8+oOAgP9JHj3fSqIBQv/S1lP7CK+qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 12:11=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Sep 2025, at 22:14, Andrew Zaborowski wrote:
>
> > Handling a memory failure pointing inside a huge page requires splittin=
g
> > the page.  The splitting logic uses a mechanism, implemented in
> > migrate.c:try_to_map_unused_to_zeropage(), that inspects contents of
> > individual pages to find zero-filled pages.  The read access to the
> > contents may cause a new, synchronous exception like an x86 Machine
> > Check, delivered before the initial memory_failure() finishes, ending
> > in a crash.
> >
> > Luckily memory_failure() already sets the has_hwpoisoned flag on the
> > folio right before try_to_split_thp_page().  Don't enable the shared
> > zeropage mechanism (RMP_USE_SHARED_ZEROPAGE flag) down in
> > __split_unmapped_folio() when the original folio has has_hwpoisoned.

Nit: s/__split_unmapped_folio/__folio_split/

As Zi mentioned, remap_page() is called in __folio_split() ;)

> >
> > Note: we're disabling a potentially useful feature, some of the
> > individual pages that aren't poisoned might be zero-filled.  One
> > argument for not trying to add a mechanism to maybe re-scan them later,
> > apart from code cost, is that the owning process is likely being
> > killed and the memory released.
>
> Sounds reasonable to me.

Makes sense to me as well!

>
> >
> > Signed-off-by: Andrew Zaborowski <balrogg+code@gmail.com>
> > ---
> >  mm/huge_memory.c    | 3 ++-
> >  mm/memory-failure.c | 6 ++++--
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 9c38a95e9f0..1568f0308b9 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3588,6 +3588,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >               struct list_head *list, bool uniform_split)
> >  {
> >       struct deferred_split *ds_queue =3D get_deferred_split_queue(foli=
o);
> > +     bool has_hwpoisoned =3D folio_test_has_hwpoisoned(folio);
>
> The state needs to be stored here because __split_unmapped_folio()
> clears the flag. Maybe add a comment here to prevent people
> from =E2=80=9Coptimizing=E2=80=9D it by calling folio_test_has_hwpoisoned=
(folio)
> in the code below.
>
> (I wanted to until I checked the definition of folio_test_has_hwpoisoned(=
))

folio_test_has_hwpoisoned() requires a large folio. That is safe in this
context, since this path is only ever called for large folios.

Cheers,
Lance

>
> >       XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> >       struct folio *end_folio =3D folio_next(folio);
> >       bool is_anon =3D folio_test_anon(folio);
> > @@ -3858,7 +3859,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >       if (nr_shmem_dropped)
> >               shmem_uncharge(mapping->host, nr_shmem_dropped);
> >
> > -     if (!ret && is_anon)
> > +     if (!ret && is_anon && !has_hwpoisoned)
> >               remap_flags =3D RMP_USE_SHARED_ZEROPAGE;
> >       remap_page(folio, 1 << order, remap_flags);
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index fc30ca4804b..2d755493de9 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2352,8 +2352,10 @@ int memory_failure(unsigned long pfn, int flags)
> >                * otherwise it may race with THP split.
> >                * And the flag can't be set in get_hwpoison_page() since
> >                * it is called by soft offline too and it is just called
> > -              * for !MF_COUNT_INCREASED.  So here seems to be the best
> > -              * place.
> > +              * for !MF_COUNT_INCREASED.
> > +              * It also tells __split_unmapped_folio() to not bother
>
> s/__split_unmapped_folio/__folio_split/, since remap_page() is
> called in __folio_split().
>
> > +              * using the shared zeropage -- the all-zeros check would
> > +              * consume the poison.  So here seems to be the best plac=
e.
> >                *
> >                * Don't need care about the above error handling paths f=
or
> >                * get_hwpoison_page() since they handle either free page
> > --
> > 2.45.2
>
> Otherwise, Acked-by: Zi Yan <ziy@nvidia.com>
>
> Best Regards,
> Yan, Zi
>


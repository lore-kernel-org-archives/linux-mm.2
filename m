Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6E8CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 20:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F322C8E0003; Thu, 11 Sep 2025 16:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8028E0001; Thu, 11 Sep 2025 16:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8848E0003; Thu, 11 Sep 2025 16:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF0258E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:12:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8454059792
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:12:25 +0000 (UTC)
X-FDA: 83878066650.06.4453B4C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88D221C0009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:12:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="okN/+1Vi";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757621543; a=rsa-sha256;
	cv=none;
	b=6bEtyvwD97J+dzJeky5bD1ElIPsSkhJEBom4FcK+d5wXP1/C0jqtU6C1oxyqi7m/llH9O3
	jYlSW+b9EwgTZLs0m6CEpjXFs5dCdS5ngNW4F+DPIlFnSxlHAQJCw3b/bGrjW+1uY4XXCt
	jzvfAw++VYTn0dJe2kUBr3LZwUKlrdA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="okN/+1Vi";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757621543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcZCQAonckCrUKPKm4x0besmYoVyv0nDELZzfCiKfPA=;
	b=bUEPc8qW0/fwzNzJ80kltNuHIbbLj8h9Kxyj3XbAKbDChIvwfOBTXXQTzP8Z4Z3KpNeLhd
	Vm9ddu6vQ9aH9F4gMIHaHWaotI/yX+UAbnfDRVmLtuOLoR05Bc2Qj4L38ZUGhA7CHoOTyu
	H1PnSC/x7/3xh63J3pntUQvzkUfFkic=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b4bcb9638aso146781cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757621542; x=1758226342; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcZCQAonckCrUKPKm4x0besmYoVyv0nDELZzfCiKfPA=;
        b=okN/+1Vi3Zoabetooii7b2py2bQ43l5NqmKq9MqhlbyGYeit/KnDzcaXKeRY83G4fs
         SKq0ylBPK9Yr+kBoZGFZHi4sKO+ulpz7mo3xtrWiKKFx5U7CKBGnI6tN4ACmy7r424cq
         zOZm9PzsIX1/2LHJBPSqdkPw/VD1QR27YNlaaQolg9ojqCoYJhpmwsfQhcKxKUpDV8cV
         XCUafxT6cS7cpRCA9U27a/nUiszUDJEGECNZovoXzYKnvLpfqIsmtvwcM0niHdTHX5YZ
         jkccQVjNlVci2ghovOv8ooiEQkEgPWBXvG7lVifCmO2xY1u9etH9ljE1yogshwaaOOrk
         S5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757621542; x=1758226342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UcZCQAonckCrUKPKm4x0besmYoVyv0nDELZzfCiKfPA=;
        b=ThBrrRY3taLWleZHqTUVjbEEjCJP05TAFqN44fivUrREzw/Tft5VoS5Tgy/2MBqHGz
         nCDWOXA9Zic1FbAvI7mm89uY+62IztQ4kEhZKxX81AGq5VCpn6JlmGGx21XkX5KLCIy2
         cfrZSuhr6gEkHJ5wNJFsXfrDBMSWPs+9wLhnLFyg6ctPHmTP5ShgmEQdXd2YJn0+A8yr
         3mW0xDJtPUbFMbf5y0g9kZbUblDvjC/EkZcxWalgkgBSc/cLn90QtJrrf6yIGNqrRk+R
         VdS8i/jKS9rxowX4PpHIdEwmvxR04liCI+z/Xq5OEszAJoF0Fxp/D+DG/vfJ7vv6wLIX
         KxUw==
X-Forwarded-Encrypted: i=1; AJvYcCWLvNj+HSnX+XiJysysHHVG2eg8t2LibTbBVLIYYZkuHcKktNSETldBYafREhc5abFR+DiguSOb3A==@kvack.org
X-Gm-Message-State: AOJu0Yyqzdr9WDEdSWUY/VJdJxErX0a7MW4oNUa4S4YPJ8uOLMGBGJCf
	I4jkhOMXxf6bEdtc+isBmrcHwmdquK2C8skFRtEbFMqRMOJY+hP6zK2QayxX7sD1/nnpqQsf+0M
	+QwpBMHRVO6T98BcS22BJaIIDSiSiLJvj+VwfibGy
X-Gm-Gg: ASbGncuNT/Wj+6qze8sN4+7RDr+OEstvSwSjMtaG2DYZZ2Nub+6UPuqJisRL8Oi9XBX
	AAhtiVW4Rtfz+LyTFO/qFZtY96Tlck5ROxyINuQjBCgleLmqjlNQHFYhOHbQA2SAmcsIsWq+Xaw
	rn1mEBKqdNlgZppO7B64AYsoYPS/PToknKBX0gehiK5JyQgnF3yfqEDZNlyJzzlURjkzCz2jpWL
	vgHCY9EuABaNDLeG/oS1MZ92UFvPCRQPICJ6rXgi+PR
X-Google-Smtp-Source: AGHT+IFwYG+oXNRCy8GEbBjKw5plhsNBK2EMVusWy6/CWD8cxMIvggWuNYsOlNkHxqipGFQAF+JfnH7EHJbUsSVWNCs=
X-Received: by 2002:ac8:7f04:0:b0:4b3:509b:8031 with SMTP id
 d75a77b69052e-4b626ecdc80mr14570821cf.13.1757621542016; Thu, 11 Sep 2025
 13:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com> <20250909233409.1013367-4-surenb@google.com>
 <zxbgiqf4d3nlww2xxoea7rud3q4oj2osk657xnhu6r7du4lf3p@es7mqt7joo7b>
In-Reply-To: <zxbgiqf4d3nlww2xxoea7rud3q4oj2osk657xnhu6r7du4lf3p@es7mqt7joo7b>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 13:12:11 -0700
X-Gm-Features: AS18NWAsvUZp8hHhTH4zlA907OSikwteEZk4N0sF9oy4TY-FkBF6EehF-T2LNl0
Message-ID: <CAJuCfpFV0d=JSwA8zDpdrg4C2TpTTZypeX0Qype-EFKHho2bQQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 88D221C0009
X-Stat-Signature: uo6xzoomo8tq595uqpu1gsskkji67ssr
X-Rspam-User: 
X-HE-Tag: 1757621543-521682
X-HE-Meta: U2FsdGVkX18UPnBLnVcuyg+S60ScgPqNJU4z3zJxbVup7O8HOPQXCRbYGA5q5aY8FzMMjHYLYlZqDZFDAJ/kpA8fT9QgW4GjsB60XXAbLLnHVMVs482R8WogvpG8R74FugVsq8LL2Lg8JuiCiku5iJYmNXLPyaSkAtL+n9zuVFcbI/DJlA514oG1cFh9TjD2IT6c7kPo2AReTjrkVULx57KAK2lUFF/czedT9ie2Z/74yk4dsrnr8jvRMSt6r99dwxCBX/2p699v8lVVXNk58gU1AY5/afDWBJdPC/aOzqZ+3CRD5JJaVhCzjKcbkTdMC2R2gKOo+Ih2o3N8vfWyoQkGgGnPXLZtNE7lExkhhnmTrvxfnPiW2QmKmguyBDESz14ulknxgR1X5Fmtvx5XhoP86FzZd/DzCh3Vxzgxd480fq64P0tfW0HP4IYydGmetoQ3aXV76nU3kfMw5D4IyzjlugSaCBh6uGYuqpUntVlUyyVywHuHMzDzel/vptygWR4vb2QagvvjKzXIaxK0HrQ1bo/GOdHz7LHpONO3fcBlu7VLCg7oave3E4sraJVMFuqqi3Gt7kS652tvsR5JuYjE859CdPPElNz1suyNjY9O3VkgGoM5t3S1NxEHlul861sssI7cbCDBb5kH6M6KedmJSmySOI519ktjpIQp8NknPKT4ugGHVPcCxBdRQhz43KO3RuYm7bQ5RXtvJHXDln1T4NMxUjM87kLPprP+xnf4cWugqvyRqDyAf4dqmUrvI2jFBqG3JQ7Gn25XzrnIPukPIVCgzTYGCBEhK2/ce7gBxc5RvDF6QeJMmJ6cXn4Pmbxc97/RWEUvPN0EGsWBlz1OpguhYM3DhVvTP4VeGU8nWxHnKGYjp+MxBsNYfY7awjRgc2BDVe1kNLx1PLkTp532kboZ0T9ANMp1N5a2uHk41wDQZniwY8Bh80zfjd+keICMlGL9lQLD+G/LMSy
 2B+hmrpW
 R3WC0ynv5d1I7NFTkotHLOZ0cAWNlBoNFwS83j6+24zc0GWMVbhMX3bI+lZ2xzxjVukmdQUGkNc/wvGVQiQWFLi/NTP5jsZLvLqeaqofGbLtv95Obh1ApIFM2Y0HLzwVITZHGhz0h8ZRYw3Eacr/C81RZMpZuka/PMcA5ZEcr1W0K9dMp9Tt1xXc+eSkSBH607sbz/BeicTrrR0DMjaG5cScpAekAmlvvqhspQqC/vRaqMGRkJQJpxblXT1p4LjVQZ1PnI4KQJ4Qxenuo5j1mIvINK28x+JHoUq2XAl8siPilADmtsXBdzf58mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 1:01=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Sep 09, 2025 at 04:34:09PM -0700, Suren Baghdasaryan wrote:
> > When freeing "tail" pages of a non-compount high-order page, we properl=
y
> > subtract the allocation tag counters, however later when these pages ar=
e
> > released, alloc_tag_sub() will issue warnings because tags for these pa=
ges
> > are NULL.
> > This issue was originally anticipated by Vlastimil in his review [1] an=
d
> > then recently reported by David.
> > Prevent warnings by marking the tags empty.
> >
> > [1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@su=
se.cz/
> >
> > Suggested-by: David Wang <00107082@163.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  mm/page_alloc.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 1760346bbd24..d21a411e807e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *page, uns=
igned int order,
> >               __free_frozen_pages(page, order, fpi_flags);
> >       else if (!head) {
> >               pgalloc_tag_sub_pages(tag, (1 << order) - 1);
> > -             while (order-- > 0)
> > +             while (order-- > 0) {
> > +                     /*
> > +                      * The "tail" pages of this non-compound high-ord=
er
> > +                      * page will have no code tags, so to avoid warni=
ngs
> > +                      * mark them as empty.
> > +                      */
> > +                     clear_page_tag_ref(page + (1 << order));
>
> Do we need something similar for the release_pages() code path or is it
> happening already?

Pages released with release_pages() should have valid tags, so I
expect no warnings.

>
> >                       __free_frozen_pages(page + (1 << order), order,
> >                                           fpi_flags);
> > +             }
> >       }
> >  }
> >
> > --
> > 2.51.0.384.g4c02a37b29-goog
> >
>


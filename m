Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195FCCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 13:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBC18E0006; Sun, 28 Sep 2025 09:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CB88E0001; Sun, 28 Sep 2025 09:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2AF8E0006; Sun, 28 Sep 2025 09:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46A298E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 09:21:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE4054C108
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:21:05 +0000 (UTC)
X-FDA: 83938719690.23.FA32061
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf01.hostedemail.com (Postfix) with ESMTP id E483F4000A
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:21:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DMOGpfW8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759065664; a=rsa-sha256;
	cv=none;
	b=D3UA//6kuqkHYn6UyqI77li8Q3jP8vkpcShk0nFXSAQQcKAMjFFyaVuwEHqQER+g5Ci5fJ
	j2P9ekB0Ia/7K+CN7eY2UrSP6kJTeztRWNM1/H6KxOega47WAoOGm5m3ua8h7N5ukV0a0V
	3Fgjs66p05gql3NKZ8xwFLccXkM41g4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DMOGpfW8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759065664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuyN8LaIynLMOcVVAC8DjDfcTekaNgJ1YBpvc463uzg=;
	b=TFZneKQMLgYpQ869WPUt0w9Us4rlPD1inicy7/rtGToItGRN43oVpOEphxBXHiVR+siLb4
	mHH8zHZL4f/sk7E6tkfxjKKOlZf7O5/4Mo2spYxGj3mAdQo7rplJztIuxXwIsJKFg1kx6Q
	oEtqCFjT0EpkU1BtdoA/5GF5q3LS+YE=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2680cf68265so31738595ad.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 06:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759065663; x=1759670463; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vuyN8LaIynLMOcVVAC8DjDfcTekaNgJ1YBpvc463uzg=;
        b=DMOGpfW8D5awql1p75POPjf2/MNoKIVzs8drIIJZipTH1URI0+0WgZe1yuhxJGM88U
         LRUiLHJdiZU15G4w7TY2oSmvsCHieORMO5JNMm+kjhqGfIONDmIsabl7MpcakQrzRE24
         vAx28hIjqRaLq9YimD7DVoZHo5y4J6YS1uJEDkaaJgNVD9vVZ64GrwbgDfFJ6AWm0dz6
         pPUKMAQaMyfGa553EOwkfFfnc3vDDEwO4MbB+aRuTSzXNXeav6TgHvMQewOWSNaJIX1c
         OjzIlbTXqq+9JIXnvoWrBxjVp0NT4l7T2nefGrvLXzW5RtxEY4zSamFYEz5PvOVp7bUY
         WrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759065663; x=1759670463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuyN8LaIynLMOcVVAC8DjDfcTekaNgJ1YBpvc463uzg=;
        b=CvTMRgS5w6+o7WDCcZ5tniCJQYYMEgac6z0ps3CQQtx8wV8FM0HsJsWYznJemQPlgX
         vFnsLa8Q6qa81hh4+a2MpndcxoZr2kbn2SlpbP80zrm15HlAqf91dK9knCaGIN1KgPlk
         1dyCcHTTagn3LCw8mUP2Z0M6z3TpdCyop0To1pxfCB2OhmrhEmO9Xf8uH/bZwkWtwGd/
         X/unHPUmcLWvl7zYhFtFunUiBkLRyBYLRkzeo+8iLz1b+cm+MFmXgThUsXhyL8zr/4Fa
         gv9snWhtVsV4pOJAtSGGzFRrb3gu4U4LrlUHGrr3Cp5KozZgQuE1UsDuEUip9omEMZlB
         jlQQ==
X-Gm-Message-State: AOJu0Ywt1Ik9PzS3Yx80zUpyslb/uiW+h50ZegqlCRsYcr5GJ5Ljp7Z6
	tcFinIWc5HNYDEh1Qm0v14hcIPKAy6syGluNHqiZgtW28xDnf7Zq9ZR8QvzZUKZk18WynWKeSiP
	ORLwXIEmS06u5SQjPzujnRCpucRA9jKo=
X-Gm-Gg: ASbGncvy0EnqQjkXTmXpGkSeyUZ75WcereXpjTsVwY//mWhFZSyl0h8RpMGHLoiAujC
	zlj+TsM/0dz6j6hFAAY9B8HesLBWKQ0LLlC+61204386Xloy/0lyQUoSA7Lb6mjTeXW3YapYKif
	NIeC/Z0h81IAIbuQbgtno/NzjT39ALkphoqUUj4SzC0qhQd/Oe7AySkE96+nwhae76cwFOaq0yI
	cM/Cfw=
X-Google-Smtp-Source: AGHT+IFRY7I1KjBJHD7Gi4iDoz0ScrOwSI8gibtvMBpXyv84g3To5Nz+4EvBusFuikjVvBGDoVwGH9iWdxQZsANhsOE=
X-Received: by 2002:a17:902:dac2:b0:260:3c5d:9c2 with SMTP id
 d9443c01a7336-27ed4a93585mr142568915ad.48.1759065662606; Sun, 28 Sep 2025
 06:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250927064926.1496579-1-jianyungao89@gmail.com> <933cfdc7-9e3f-4dec-a5d9-bb193b0b7f13@arm.com>
In-Reply-To: <933cfdc7-9e3f-4dec-a5d9-bb193b0b7f13@arm.com>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sun, 28 Sep 2025 21:20:54 +0800
X-Gm-Features: AS18NWD5h28x_EqzgNeA5bm5R8WhOU4cAhQuKUd1TqaJB4e2HcCJNRb3F5Oq-pY
Message-ID: <CAHP3+4DpW1R4nP2c5JOK_==zDXBRkHyJggBp4KrCxv7dPfb3Eg@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: Fix some typos in hugetlb module
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E483F4000A
X-Stat-Signature: qckug5jd6bjtpm7uu98o43mopdd4yzce
X-Rspam-User: 
X-HE-Tag: 1759065663-675353
X-HE-Meta: U2FsdGVkX18UefStynTwZiGo5LEnkIhUQkbLFv4JS3GBc3XgKboE1/rS+M2F2ksa6gmtqnzr1OXuvNLQaWvUuIX6p1nIdrUjTD1J7le6dpb8vO+qZOfx0kUvjU5RLQhLgyGcftjaJ/8VB5IBHv28ZnUJuGHtnySAs8GpZmD++HAD1dWggFibnmDqhw6LJcKyRXfe4NuH9tjVwKvvZcB7ACad4o8K7Ac79CJYXUSpCYu5LqjMhhYyJYIDvSSZbLZNSilLgwGRSbZ5b9C0pzHHVOh1S5c8BY3lHC/wLi5yZUk2JMeFHkpK60AuN2QEaFcqwT7SX03o1JWogWfFdqgHF1i5/WH/ExLMyr0MJ4639yTOJVfJmeb7j8NEV13L0WEQ5Oe+42y6Q2V78xbbbMfWGSR2USRBOPiDnN4EtT3O4kL6Fw1IjROfoiBoB4xaveJ9lRsX6tySDxAbh/fnfKQJULGuOGZmbmxJ6Y1uTS41XOATijHk2VS7c/Fdl3ZhzK6Xa5w8YsW8u/AtLnkBqS7XjDmQnviVuqL06ffu7igUq9syaObYtNw8zq8EP/pp+3irJ+BK3iJoU0qDGkWh0VqJgO5dqFNgdfw9b39T1gXn33gmO2Fu7Pv3UXR7ycYBdJyjaRD6YjXnQ8IOJMx11QRO3ismaeHZhzLSzHXbDe3U8O08qqH77oOYLr3AvpCHKBGQL0XczlJcTUU+yaAKfQ7lrG0mUTLXZVfYphS53N8AY2gAzsvzqnADTyT4u3D5AAURmDZfdyOzojcHjDG/K3kHMRu5jDDkvi4wUaKJYj3mvF8BmB47BWXN9L5LxUXEk9M9UTP0IVZhGUyiKJpeB1c/WACpsDgc8VZdSeqizagZ5tvTk9B652Cll0u35Xn7ZWNdrk3uERXhhgh/1yCbkdZIWoHBhHNAh+JR9E9hNHaPdFf1s8uQTXfVOt7+2UZ1d7+i0mWR7WXiEh1LaEDWlx5
 BxlBs07Q
 poV9eVusdSwyeOOohUEB5K768xI5IaOjFMOE7ga1sMEZjAyw+vdqta7kqEnlzNnYoKbHgd/llLh6aB68bPJMMjfUHRzqdc196X0KFomJTxCh+YlsuBGs6+3mHYypz7rktg2NTikjnJVE2235aKnXyHg2LQnJosN0inb94LJfbVzvnqitHbD74UvpRonmDlQR2yVCEw+D+X6XerRrlY4pL1fguwxl2Ps+3MUJ15X1ZJD6sE27d2M8Y9UZtPcpV3QhiBXneIIDhzUnqXVdqPdZDj24c8NOgkUKT4kkBL/dEFLzw5mXoic9ukV8cjJ374VV87yeiQYCOJRvVUMB6vmw2MXB6mbttknYEH5AS1wCvXwR9JFK6BjUinzbPjDO2BVld9nT7xHxkroO/m4inljXaX+SupDlaIPj+bV0LwuLUuityw/4hbQllfrOvWp8Yaox0/TOXeq6hkoqflqWL0axVrWNM/mU/wfn2dEZ/FZo1u4Dnb2shOIj3Fee0Ri1sqkTnCO5cOKlL7ncCV3LggHERQliBFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 28, 2025 at 8:56=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 27/09/25 12:19 pm, jianyun.gao wrote:
> > There are som typos in the code comments as follows:
> >
> >    differenciate =3D=3D> differentiate
> >    refernece =3D=3D> reference
> >    permissons =3D=3D> permissions
> >    indepdenent =3D=3D> independent
> >    Spliting =3D=3D> Splitting
> >
> > Just fix it.
> >
> > Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> > ---
> >   mm/hugetlb.c         | 6 +++---
> >   mm/hugetlb_vmemmap.c | 6 +++---
> >   2 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index eed59cfb5d21..8ff9edd09504 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -2954,7 +2954,7 @@ typedef enum {
> >        * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
> >        * that currently vma_needs_reservation() has an unwanted side
> >        * effect to either use end() or commit() to complete the
> > -      * transaction.  Hence it needs to differenciate from NEEDED.
> > +      * transaction.  Hence it needs to differentiate from NEEDED.
> >        */
> >       MAP_CHG_ENFORCED =3D 2,
> >   } map_chg_state;
> > @@ -5998,7 +5998,7 @@ void __unmap_hugepage_range(struct mmu_gather *tl=
b, struct vm_area_struct *vma,
> >       /*
> >        * If we unshared PMDs, the TLB flush was not recorded in mmu_gat=
her. We
> >        * could defer the flush until now, since by holding i_mmap_rwsem=
 we
> > -      * guaranteed that the last refernece would not be dropped. But w=
e must
> > +      * guaranteed that the last reference would not be dropped. But w=
e must
> >        * do the flushing before we return, as otherwise i_mmap_rwsem wi=
ll be
> >        * dropped and the last reference to the shared PMDs page might b=
e
> >        * dropped as well.
> > @@ -7179,7 +7179,7 @@ long hugetlb_change_protection(struct vm_area_str=
uct *vma,
> >               } else if (unlikely(is_pte_marker(pte))) {
> >                       /*
> >                        * Do nothing on a poison marker; page is
> > -                      * corrupted, permissons do not apply.  Here
> > +                      * corrupted, permissions do not apply.  Here
>
> Can also fix the extra space between "apply" and "Here".

Sure, I will fix it in the next patch.

>
> >                        * pte_marker_uffd_wp()=3D=3Dtrue implies !poison
> >                        * because they're mutual exclusive.
> >                        */
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index ba0fb1b6a5a8..e6f79b2c63ee 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -75,7 +75,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page =
*head, unsigned long start,
> >       if (likely(pmd_leaf(*pmd))) {
> >               /*
> >                * Higher order allocations from buddy allocator must be =
able to
> > -              * be treated as indepdenent small pages (as they can be =
freed
> > +              * be treated as independent small pages (as they can be =
freed
> >                * individually).
> >                */
> >               if (!PageReserved(head))
> > @@ -684,7 +684,7 @@ static void __hugetlb_vmemmap_optimize_folios(struc=
t hstate *h,
> >               ret =3D hugetlb_vmemmap_split_folio(h, folio);
> >
> >               /*
> > -              * Spliting the PMD requires allocating a page, thus lets=
 fail
> > +              * Splitting the PMD requires allocating a page, thus let=
s fail
>
> lets -> let's or let us

Okay, I will also fix it in the next patch.

>
> >                * early once we encounter the first OOM. No point in ret=
rying
> >                * as it can be dynamically done on remap with the memory
> >                * we get back from the vmemmap deduplication.
> > @@ -715,7 +715,7 @@ static void __hugetlb_vmemmap_optimize_folios(struc=
t hstate *h,
> >               /*
> >                * Pages to be freed may have been accumulated.  If we
> >                * encounter an ENOMEM,  free what we have and try again.
> > -              * This can occur in the case that both spliting fails
> > +              * This can occur in the case that both splitting fails
> >                * halfway and head page allocation also failed. In this
> >                * case __hugetlb_vmemmap_optimize_folio() would free mem=
ory
> >                * allowing more vmemmap remaps to occur.
>
> As Wei says, this patch can be merged with the earlier, thanks.
>
Get it, I will merge this patch to the next one.
Thank you very much for your review!


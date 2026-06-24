Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBC1CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 23:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77B56B008C; Wed, 24 Jun 2026 19:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C278D6B0092; Wed, 24 Jun 2026 19:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DFB6B0093; Wed, 24 Jun 2026 19:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 809D76B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:08:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01B6C1404F5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:08:22 +0000 (UTC)
X-FDA: 84916346886.28.80C6640
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 12F18C0004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:08:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Umww1J2z;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782342501;
	b=a/DSzBkmZrwQ9K7Pt8yoGS4lFJ4A2/oFdwdLKzxPE1nVnFGmmTYyDaMCYxXbP/1ol0FbgW
	P8GU7DpGCI7Auh4y7/jmGM4IjQ25wjltP1iU5gLHGZLqesV2mPKqL8AP4+/Zme4Dv9V3be
	wQUMv+/C1rIkVwWgd5H+BtFPi+V0BGY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782342501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fHkr90D90S1AcwNcJcCz4YNxvQsSfEc7T9eLgJMlGk=;
	b=UW5ROFtpIDzVfGo0rkZeKwO60G8jifl9ALhi56yHx8Le8ynF1ykACHaHFvmIU2IANWRkqj
	n4u8zAKpW0FewwDAbQVthuXnjNW7JBkPm3xVe9EY/XN8bbM3RejwW/Ttwa35nzwlrVgK6h
	SCGuSX34Ud9SlNgHZcZZniK15JwEHdQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Umww1J2z;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49263703c6eso5520695e9.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782342500; cv=none;
        d=google.com; s=arc-20240605;
        b=j5a3Gtq/5xn/Fc+SAcUJVpgQPIOh1a3OCPhctS17aaW4Dyif9s8yn7g6fqvjop4urY
         p0uWFcK4tMIA3YDHQGto+yAznk6fqSZCBL0Kp/idtxAahQx5dF78pm0/uYnmokhXJuDU
         kg3opQwQkVk1sUYOvYHscBFImSEtOYI5TECf6+7EsIkn8xVr2pfda0yKEUe/IXtaiutR
         M3YymdnB9N98LbKglR8zUnK1+b4hR+2MNmnIhM6HSV6GwvWttKmFnyzHrVAhMyAItYGi
         egO5uJArUszMoD4xdhIxFpu5yAZQBOsbf+jbQ6fpcCg7/s82WOGgg2oZy3ePHKLS7/4b
         awvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+fHkr90D90S1AcwNcJcCz4YNxvQsSfEc7T9eLgJMlGk=;
        fh=YjZ1mMGOcj7Slpix7uEfsBb4ONs2RREhutWhvk0wMvE=;
        b=iqJAmver8TmR3Zbjsj2NaMwMT4gP/0FP6tFioRsVqTykK4XavFqDSbSHk/mcSrIM5R
         YAyFYQmEIFrSZUrsq5u8NHDTCRinHU4BR0sSSWVMK2+2DiFyjhUYl0sC7/cIVHVycwnH
         7VJFu6BbKmQmRoDs5escaaRsY0Fbv7mUnukqYe4pQXT4iuRk90lNW2Wu9fo64eR2BBYV
         BxG+CWugQhrsmiUVYGCa3kihsh8A9PwHlOMznG0R7ACoRENY7YwdYMMYhZcVXBok+L3L
         g5RGmwskfOUp912MPBPfPreZ5+raPqo9t7WAiQ4nzksLR+a7YtGIDb2jkgZromdLOLrc
         Qbdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782342500; x=1782947300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fHkr90D90S1AcwNcJcCz4YNxvQsSfEc7T9eLgJMlGk=;
        b=Umww1J2zJFrjGMHryBZImvb04ODVppzgcMIaHz/dhYS7plrK6HKySR7Vs7BV8J8Bu+
         Y0vuJ4sRbMqE/UvY4h0EKIiJ7hAQZQSlCXDpgJSYXd6yWRa+4M+kyuPhjR0qWiP9CXEZ
         e6u/0cJVmItJRmw2LkU+1LxqJUtXxnq+3bZEam7Ylg3gvc6RtZ8DBsLjCI4q1uSLMAN7
         SohTIrT73goQcxF0Fz4dL5pO93nQLCxNsAskvMcKuOD9gIZNBcqre6Bod6nHQbyIx6E6
         xHMBAuen2rim38GQ3a/mK9HM9TRQDQgnezpMqxjQ+YCmg5P9fa1iwqMcUpHsDdSFzGTo
         nAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782342500; x=1782947300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+fHkr90D90S1AcwNcJcCz4YNxvQsSfEc7T9eLgJMlGk=;
        b=flaLyVFU+rVqpunpFgUYAvXmTnsRG+wsYZOH0dqJCqvbp8FjRGZ3Es6CLl2qhhYqmY
         tx8JuGw9rABUGmoyuyfWJsDMEajSq4eJboc9GDC/0lOivbEROBZoCP457tLsYOH5F49p
         OXwKkQW+a36Gqs7fXtyxCRMQq/H5dlhnS83miW3OmNytidlhxOsZwbqvqi89qp9oq7oC
         lzG8Oq2855m84iK5M/tI61NL9ebc8gya9ohWitK7IrZMQqdXTaE8o8RCy57Z3D3j6CiN
         TPnwZ8xyKFvl1Fe0xVOlpfDVWFzDxPhng4pEvDQp1ue/kd5n38WJFB4Uy83zrtTVZhGg
         nGmA==
X-Forwarded-Encrypted: i=1; AHgh+RqznnJTMlUbGl6L0VENC+rFVkW0Y+5TeWJKor2l8JaKnFMf60trrWLt2cWGeYfhvFkDcrbuLdqENQ==@kvack.org
X-Gm-Message-State: AOJu0YzGLCfpolf1XgXzebB8bd/GIGVNfuVXsYyBi3LJnA+x7RFJdyrp
	iXh0+XFJPSEOeRMMZwHfTxncJwnwO8a0uCHpcSOHXq4KsvzbMcpxo1MUaxha2ekG84HaDgOR60O
	N33/p1ktKOTZR70S9c0i3rOqm8JxJvTc=
X-Gm-Gg: AfdE7cntYO/zR/W8zVfH08A0vJs4z5udjq1nR9wnc7wz+8g+6a6gfsZ6r/ldjF5jS/z
	Oo4BPzOryEVPnKNwYnSYx0K+hvThPuVmKjau408tnrGjsw51kbo8UlEKHnJb/4RK3P8XWq0ItVt
	A+Z+vqrJJSamj6VRXyA7th29NKTxyvw+zdngYRwJE5U7pVjWLa7ZOhI/2GJwR0Bb2EnuGlxBf1T
	6fcV6zjJlS0I0Q7RxcRZeTCW6/Iq+isNK3sUOxH58+PWnbYQ6I01k/fR5uS2n6WGr84btV2DTRg
	Juq9UQ6y30Y9GIoGCzFytL0Ky6CC5d7DTEnA5+kKgqen7KqKj1sNTvQ=
X-Received: by 2002:a05:6000:288c:b0:462:93cf:d510 with SMTP id
 ffacd0b85a97d-46ad90f5d88mr14558516f8f.12.1782342499561; Wed, 24 Jun 2026
 16:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-3-nphamcs@gmail.com>
 <ajnNWRO7apBq2-kQ@google.com>
In-Reply-To: <ajnNWRO7apBq2-kQ@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 16:08:08 -0700
X-Gm-Features: AVVi8CfZPRJXeQiZ-QI0fuqfZ80V8OQT-rm0BmrU_pyrNuBxccG3s68zL1rO5Pk
Message-ID: <CAKEwX=MtyRQawS-1LRnpqUhTqfY2Dfm0S57Bgwsd2ZAWJgk9VQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/7] mm, swap: support zswap and zeroswap as vswap backends
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tx97c8camfpb3hfos9ze1ri4mqmrc9qd
X-Rspam-User: 
X-Rspamd-Queue-Id: 12F18C0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782342500-649820
X-HE-Meta: U2FsdGVkX1/nD7BnBxsNRR2p76e/EIS/VH3g/ewj9E+FR/egI9jxON+DrfcAPVguBABKQY7lcZhP1VpMHpdQMUO3OQk6ry6BYnPjQqHc1iPrTGD0NCGSujvhh1Uaf/NOD9USKkrLsYCC1cXeITEMNSqPfMUmjH31a6kgGVCOzSpHaMb10QQaebFVEHnUK4QRZxJMDvn24oXPQoDAL/IlsZfYvi+3tqEKu2BkGVC69r+dOLQBvrzyFr1BNE2uB/QomRgCzxWvKolBz5EqBf9ZxzchDt36BcLgQ5Wx/H+kaCWi6itXjDS4OEYsHMscUj9E5GYCVjLVhRZWBzY2m58lUnvSJSGH345ziXGF8i3TqooLdkJYVufIGhpwh1X1EvcnF80Y8LC9nMkV+Cb4kGk1/X2I8iPrN3DRiSA+avn6n7PHuLdoBmzLRUdRdMO9S3bGGowK7DTURlMthy5rzKXbdZrB8+CcvI83mvEUeKlMUvVHSBt3A8YrAuUDMtVaIJwhKeu2Cz0uvYQlHfz7OThPkp31iZcfryMmkeUtmcWIJlY2M/ECshvQc0ricJXwJrT8KooeAOiDyoBdZgjKSMu6fxcWIOaBIqKZMLkhr+YxpKhiOTnP4i74dBKNcSLWqn4XaGv9qe88vk5jn6Fn4y3uGgt0sqnUwr7xa2/AA5qerdq+qyYT4OMrJdD4Cm6eX+RvVHMvDHY/VT4F2pYqJVPeGZXC4Dhg+Opb0VJIRygcXCfBmH9HB+JFDYAOcWX1fFRT+FtcWLKiJQ3vs7YvzXlsGn36mZ+ARtreHWqWDBc8GYOccFCfbEsZnMSvKzRsT2nXsmuGYwvYs2hUAFjKECwMSUPwY/EI7Lq+LNCT+omu18+zmbKHACO3ttHc1t647dVXxP2AdhBullr1d5fOBRq81ZWBdwJxhht/0RZ2zGa0HJww822vMIBSpqo7+tDIUf5AiwfauakcNwl2gwKTkvE
 C/PiyUno
 JR1pcfuZ8//fvxmOSsARHr5Odi3FMZdUkQpehDypt2J65Wz6PUW0xFOL2/PGHpwScLDVOhmUwvzBuouFpCCP2uHXD6kJLpKiBqT9r8Hm+/GQpNxfqnxCwW85QLa+hmg/c/9YwABjyCz22yTxoKKffOiOvwbM+JFNufuWf91kMZ8sOUfQWepTA/5HOYRZhr8/7vOWFV1uaeTT3kIcqwOv11KS1a6y1b0ERSmRrKs+MBt1KuaeTVPEjYoybY96++FeBHjQTafeWgq9KCTv+C/zi3CcDrDMnho+N4TIR4eL572VkxCn0PvGibRRJGVPEr/wawbh+oZnxF6fFlPgDKJRKqRQzl6y59ajxVcH0FJc8VxvL//STdZ+bODt/8YAYF9iuU4TReLMcGl7fF7mbXTw//BYlxW5ZhxvCXAqBp4Vk3Eoyy6leqNH+dCIBXvfEDtvewwLufkH/6UmmXlBOCRblzcktNPN1eyfHTY9C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 5:16=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Jun 12, 2026 at 12:37:33PM -0700, Nhat Pham wrote:
> > Build the virtual swap layer on top of the swap-table infrastructure.
> > Virtual swap entries decouple PTE swap entries from physical backing,
> > allowing pages to be compressed by zswap (or detected as zero-filled)
> > without pre-allocating a physical swap slot.
> >
> > This patch only supports zswap and zero-page backends. If zswap_store
> > fails, the page stays dirty in the swap cache (AOP_WRITEPAGE_ACTIVATE)
> > - physical disk backing fallback comes in the next patch. Zswap
> > writeback of vswap-backed entries is also disabled - the shrinker
> > skips when no physical swap pages are available.
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> [..]
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 993406074d58..466f8a182716 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -38,6 +38,7 @@
> >  #include <linux/zsmalloc.h>
> >
> >  #include "swap.h"
> > +#include "vswap.h"
> >  #include "internal.h"
> >
> >  /*********************************
> > @@ -762,7 +763,7 @@ static void zswap_entry_cache_free(struct zswap_ent=
ry *entry)
> >   * Carries out the common pattern of freeing an entry's zsmalloc alloc=
ation,
> >   * freeing the entry itself, and decrementing the number of stored pag=
es.
> >   */
> > -static void zswap_entry_free(struct zswap_entry *entry)
> > +void zswap_entry_free(struct zswap_entry *entry)
> >  {
> >       zswap_lru_del(&zswap_list_lru, entry);
> >       zs_free(entry->pool->zs_pool, entry->handle);
> > @@ -994,16 +995,21 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
> >       struct swap_info_struct *si;
> >       int ret =3D 0;
> >
> > +     /* try to allocate swap cache folio */
> >       si =3D get_swap_device(swpentry);
> >       if (!si)
> >               return -EEXIST;
> >
> > +     /*
> > +      * Vswap entries have no physical backing - writeback would fail
> > +      * and SIGBUS the caller. Bail before we waste a swap-cache folio
> > +      * allocation.
> > +      */
>
> Seems like this comment belongs in the previous patch, and the other
> comment movement is undoing what last patch did.

Yeah this comment belongs to the first patch. I added it after the
fact but commit to the second patch.

TBH, the first patch kinda not do much. It just declares a new special
struct swap_info_struct, with some helpers and checks, but it's not
hooked to any allocation path. Logically it should be squashed into
this patch, but this patch is already 600 LoC, lol.

>
> >       if (si->flags & SWP_VSWAP) {
> >               put_swap_device(si);
> >               return -EINVAL;
> >       }
> >
> > -     /* try to allocate swap cache folio */
> >       mpol =3D get_task_policy(current);
> >       folio =3D swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NU=
LL, mpol,
> >                                      NO_INTERLEAVE_INDEX);
> > @@ -1416,25 +1422,25 @@ static bool zswap_store_page(struct page *page,
> >       if (!zswap_compress(page, entry, pool))
> >               goto compress_failed;
> >
> > -     old =3D xa_store(swap_zswap_tree(page_swpentry),
> > -                    swp_offset(page_swpentry),
> > -                    entry, GFP_KERNEL);
> > -     if (xa_is_err(old)) {
> > -             int err =3D xa_err(old);
> > +     if (is_vswap_entry(page_swpentry)) {
> > +             vswap_zswap_store(page_swpentry, entry);
> > +     } else {
> > +             old =3D xa_store(swap_zswap_tree(page_swpentry),
> > +                            swp_offset(page_swpentry),
> > +                            entry, GFP_KERNEL);
> > +             if (xa_is_err(old)) {
> > +                     int err =3D xa_err(old);
> > +
> > +                     WARN_ONCE(err !=3D -ENOMEM,
> > +                               "unexpected xarray error: %d\n", err);
> > +                     zswap_reject_alloc_fail++;
> > +                     goto store_failed;
> > +             }
> >
> > -             WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error: %d\=
n", err);
> > -             zswap_reject_alloc_fail++;
> > -             goto store_failed;
> > +             if (old)
> > +                     zswap_entry_free(old);
> >       }
> >
> > -     /*
> > -      * We may have had an existing entry that became stale when
> > -      * the folio was redirtied and now the new version is being
> > -      * swapped out. Get rid of the old.
> > -      */
> > -     if (old)
> > -             zswap_entry_free(old);
> > -
> >       /*
> >        * The entry is successfully compressed and stored in the tree, t=
here is
> >        * no further possibility of failure. Grab refs to the pool and o=
bjcg,
> > @@ -1487,6 +1493,7 @@ bool zswap_store(struct folio *folio)
> >       struct mem_cgroup *memcg =3D NULL;
> >       struct zswap_pool *pool;
> >       bool ret =3D false;
> > +     bool partial_store =3D false;
> >       long index;
> >
> >       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> > @@ -1524,8 +1531,10 @@ bool zswap_store(struct folio *folio)
> >       for (index =3D 0; index < nr_pages; ++index) {
> >               struct page *page =3D folio_page(folio, index);
> >
> > -             if (!zswap_store_page(page, objcg, pool))
> > +             if (!zswap_store_page(page, objcg, pool)) {
> > +                     partial_store =3D index > 0;
> >                       goto put_pool;
> > +             }
> >       }
> >
> >       if (objcg)
> > @@ -1548,7 +1557,9 @@ bool zswap_store(struct folio *folio)
> >        * offsets corresponding to each page of the folio. Otherwise,
> >        * writeback could overwrite the new data in the swapfile.
> >        */
> > -     if (!ret) {
> > +     if (partial_store && is_vswap_entry(swp))
> > +             folio_release_vswap_backing(folio);
>
> Hmm the above should also only happen in the !ret case, but that's not
> obvious from the code here. I think all of this should go under if
> (!ret), but maybe reverse the polarity to avoid the indentation?

Yeah that's just me avoiding indentation lol. But yes, it only happens
in !ret case:

>
>         if (ret)
>                 return ret;
>
>         if (is_vswap_entry(swp)) {
>                 if (partial_store)
>                         folio_release_vswap_backing(folio);
>                 return ret;
>         }
>
>         ...
>
> Alternatively you can move the check_old code for xarray into a helper
> and do:
>
>         if (!ret) {
>                 if (is_vswap_entry(swp)) {
>                         if (partial_store)
>                                 folio_release_vswap_backing(folio);
>                 } else {
>                         zswap_free_old_xa_entries(swp, nr_pages)
>                 }
>         }

Yup! I can switch to this if you think it's cleaner.

>
> Also, I think you can probably drop partial_store and check the index
> directly here.

Ah yeah. That's true!

>
> > +     else if (!ret && !is_vswap_entry(swp)) {
> >               unsigned type =3D swp_type(swp);
> >               pgoff_t offset =3D swp_offset(swp);
> >               struct zswap_entry *entry;
> > @@ -1588,8 +1599,7 @@ bool zswap_store(struct folio *folio)
> >  int zswap_load(struct folio *folio)
> >  {
> >       swp_entry_t swp =3D folio->swap;
> > -     pgoff_t offset =3D swp_offset(swp);
> > -     struct xarray *tree =3D swap_zswap_tree(swp);
> > +     struct swap_info_struct *si =3D __swap_entry_to_info(swp);
> >       struct zswap_entry *entry;
> >
> >       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> > @@ -1599,16 +1609,25 @@ int zswap_load(struct folio *folio)
> >               return -ENOENT;
> >
> >       /*
> > -      * Large folios should not be swapped in while zswap is being use=
d, as
> > -      * they are not properly handled. Zswap does not properly load la=
rge
> > -      * folios, and a large folio may only be partially in zswap.
> > +      * zswap_load() does not support large folios. For non-vswap
> > +      * entries this is unexpected on the swapin path: WARN and
> > +      * sigbus. For vswap entries __swap_cache_add_check() has already
> > +      * filtered out ZSWAP-backed THPs under the cluster lock, so the
> > +      * large folio here is zero- or phys-backed; return -ENOENT to
> > +      * fall through to the phys/zero IO path.
>
> Hmm should we start simple and avoid THP swapin for vswap initially?
>
> IIUC, it isn't really vswap specific. Even without vswap, it's possible
> that an entire folio is on-disk, not in zswap, in which case THP swap
> should be allowed.
>
> I assume it's not common for zswap to be enabled and an entire THP worth
> of pages are not in zswap, so maybe we can add this later?

I was thinking of removing it altogether haha. Are we even doing THP
swap in for non-sync IO devices?

if (!folio) {
    /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
    if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
        folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
[...]
else
    folio =3D swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);

So I guess it's primarily zram that does THP swap in here? on
non-SWP_SYNCHRONOUS_IO devices, seems like we only do "THP swapin" if
we catch the page in swap cache (minor page fault). :) Will zram users
like vswap?

OTOH, zswap might be getting THP zswap-in support soon, so it's not
just zram backend that cares about these kinds of check? :)

Or maybe I can keep it, but separate it from this big patch to make it
easier to review :) Lemme play with it.

>
> >        */
> > -     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > -             folio_unlock(folio);
> > -             return -EINVAL;
> > +     if (folio_test_large(folio)) {
> > +             if (WARN_ON_ONCE(!swap_is_vswap(si))) {
> > +                     folio_unlock(folio);
> > +                     return -EINVAL;
> > +             }
> > +             return -ENOENT;
> >       }
> >
> > -     entry =3D xa_load(tree, offset);
> > +     if (swap_is_vswap(si))
> > +             entry =3D vswap_zswap_load(swp);
> > +     else
> > +             entry =3D xa_load(swap_zswap_tree(swp), swp_offset(swp));
> >       if (!entry)
> >               return -ENOENT;
> >
> > @@ -1623,16 +1642,14 @@ int zswap_load(struct folio *folio)
> >       if (entry->objcg)
> >               count_objcg_events(entry->objcg, ZSWPIN, 1);
> >
> > -     /*
> > -      * We are reading into the swapcache, invalidate zswap entry.
> > -      * The swapcache is the authoritative owner of the page and
> > -      * its mappings, and the pressure that results from having two
> > -      * in-memory copies outweighs any benefits of caching the
> > -      * compression work.
> > -      */
> >       folio_mark_dirty(folio);
> > -     xa_erase(tree, offset);
> > -     zswap_entry_free(entry);
> > +
> > +     if (swap_is_vswap(si)) {
> > +             folio_release_vswap_backing(folio);
>
> Is there any advantage to calling folio_release_vswap_backing() over
> zswap_entry_free()? Seems like __vswap_release_backing() ends up just
> calling zswap_entry_free() -- and I don't see any vswap-specific state
> being cleaned up.
>
> I wonder if the zswap code should call zswap_entry_free() directly? Same
> goes for the call in zswap_store() above.

Most just not repeating the vtable lookup-and-lock and what not. :)
The pattern is repeated the third time in swapoff when I allow phys
swap to be the backend of vswap in the next patch so I figure probably
should add some helper.

>
> > +     } else {
> > +             xa_erase(swap_zswap_tree(swp), swp_offset(swp));
> > +             zswap_entry_free(entry);
> > +     }
> >
> >       folio_unlock(folio);
> >       return 0;
> > --
> > 2.53.0-Meta
> >


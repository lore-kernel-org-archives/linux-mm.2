Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EE1C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 21:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0196B008C; Tue, 25 Aug 2026 17:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071EB6B0092; Tue, 25 Aug 2026 17:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56D26B0095; Tue, 25 Aug 2026 17:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9AC56B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:32:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 132811C09D8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:32:25 +0000 (UTC)
X-FDA: 85141090650.26.96E7EBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30D844000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:32:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lA6wOVwl;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787693543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3Yulk4VTVrpzD/uY0vBKxbBDFnJs+mNDK140uZ2gpM=;
	b=h4goJYDbkBiN2ks2Pxy2tCm6M9LDuAYiQFoEvPWlRQRdCID9F8daPPh/Ul9zavcNH3MKEZ
	Le2JtXS/0jOB1xDqo7WXU0IH8+QIwa3NVOO6qQLWzo3ky1kCaFHn1IGTO7+lSQuCVw7d2s
	4PooiM3DbamhVa3XK4Gr0IBADSX+25Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787693543;
	b=lA77/EtAr06OxkiOIdUYuEvN58oWnR228mp1SBgoJgxezE6kotUxqbjcmqiV4dqgdV5Vve
	XhTl0JrrRF9WSSXosseVdLY/cH66ey3UcZv9SxO9A3wLrcHGWi7tLhf9IrckgbZfBObaBf
	rK+C03L7FoBTp5W+gfa+7xSsSzzd75o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lA6wOVwl;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CD766011F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3341A1F00A3A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787693542;
	bh=c3Yulk4VTVrpzD/uY0vBKxbBDFnJs+mNDK140uZ2gpM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lA6wOVwlL9Tz0tI4MGr1exSe/kkd5zYuel4cqASUsoMV3FIA5kT/yYZfxTCQeLYQC
	 LRL2wD1zfCSTZHWJAZTeJWIRhCiftQyWimfEtkT7WcLAhFBv3BaZfoTSmSHvlxGcoi
	 pfz+eiBcuXaM+yJ3NKFXGGhMYvRnuZq24th0c3u/HGNQMNEsByeCFJp17lZJQ7zm/z
	 E0H1/7uP+xBUGvrmDKfdho54XyIc4qjyf3Yf9wf/DUQFGj7uBk2GZm+SvJzwXBggj5
	 CEalTYCeXPN3y+n+JLpbqg/JzZcsSxDHVPR7nY5W9cOPIpyi7mmyepSjvDUmnsWbQ5
	 lnSurl4Ky+RXA==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5276d598b96so1717281cf.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:32:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoviUPuGdXSGXzu9vecLdbZkZd8/7Mz4PUutzGCWriSynqnvf7ade2Fwzy3No7c8iyWg5B1FzdQ9g==@kvack.org
X-Gm-Message-State: AFuF++kf3fxjMLHQP1kViJJSzzN6SYzqrX27qf9kjvbouGG+dpzNCPi7
	qBdsDqyqZStqpoQfj+tZ1ZFWMiGvuPcJEgVgwWHDjaRp329V+vfYhhI2q+TMcEFdJrID6d+dDEA
	Gb/HUv3Th/jZUX6Wa0BKeNaJ0sVYD8XQ=
X-Received: by 2002:ac8:5fc8:0:b0:51b:9878:8242 with SMTP id
 d75a77b69052e-52e42231f85mr21953011cf.6.1787693536655; Tue, 25 Aug 2026
 14:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-6-baohua@kernel.org>
 <CAMgjq7AJnWGGH=FNuV7ynXjbffktsDRgdcyagLUJUwJf1ukaJQ@mail.gmail.com>
In-Reply-To: <CAMgjq7AJnWGGH=FNuV7ynXjbffktsDRgdcyagLUJUwJf1ukaJQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 26 Aug 2026 05:32:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zFR+fX-D5KAVyaX+CQGOcb18M6vKMuDSKVSo6s9Jitnw@mail.gmail.com>
X-Gm-Features: AcwNN1XYUS3kF5lKS4fT3QlwykT26zxptGxMmVfQpds82H3nJMd_JeTa323wSek
Message-ID: <CAGsJ_4zFR+fX-D5KAVyaX+CQGOcb18M6vKMuDSKVSo6s9Jitnw@mail.gmail.com>
Subject: Re: [PATCH 5/6] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30D844000B
X-Stat-Signature: 8dt71684zu5y8mosed6ynuqijcnoitro
X-HE-Tag: 1787693543-686397
X-HE-Meta: U2FsdGVkX18sSAMbgq6XJyKBcBiJGtrlT57o2a9P/jKmgDyV3d/tU2uvb/rFmaQLaJRIQETm9NXjdwTPXfSCW4P/ysDwbZTKJNWaOFBzlJaPKf0ZCVVvpW1kL6N30SA8NBnv53P4rDqdsVzMHn8dXxpkxdZBPQ5hkNgQ3VL4jPtZUSboGqlzmtdPHXR7zOxO/vc95lYz2EtgMm9NSdEqV1K+1sqLpU+wn1H16apWLPqJpmI0C0M0VD+1GTzSCMGTdcVBf3MOjTR/qlU1S84IXukZRsS0EIx5j2A0HXN4B0ptcoQr5WsEm8irCeUNwJLp4+oTI0zHlzQ2gBGbH+Ipz9tNFVytERwA+npM2dImCP+mYfWyzXWgZOgbTaPi0Q0LmK62RI1atzlUN8Jip24I5kelYcQ/DR162KoZWq1Rnun+35eF9mZTu+LHYkrvtF5cU9PywNVExXeWbBIWS8X6ycsmQ7J2xlNTGCiawIwXRJiYJ/0IZcsF8fYeIQnsIanXuNdXoEurfSfg8Bl1rBO8Qd4UWCoGnv2vx9x0HV7xgyzSKi77TYtvmw8mWy2iuOCYz1u5c6TsqeaQmOJeCkRmsGEwprRlCCPjQSIVWoqF0JLYgbacXLrFBO6rUAX4CtRSwp9u97BXU5wLmSTjDdK9g99NtjvQ5YPBI7HoIWO+chzeuT34HrTKjojRbzZl1Ra3wIcc/sw7oq8LzhX9m5fipuNWeGchj9nPnrP3pdgHJfuvY/gRFM4RYOCPu4Ya9WuQKbe1uVGIxUimlpOCR1IybgROasYpu3tBJl4Ms4AIqlot+veA1wnDlHWl+xtCLKX2x6PnEb6udkmWgTSx+kxkJAa7fQxPHOzJ/yeILxumSNEK72bGgZIZWNzfB/HisNbSKBSpAQ0ksrpKmehFui7obOIUT9Du/gAwLkKG5LzFwJyCjRCqX+4ClNOF1YEztXEwKoFhRC+RloAsg+4uFyi
 D6Oc4UAC
 QRHZ4OB2JhQCa8aO80eitH3Zob689a0KfygfYAYF8TuN08exajCma5PvWxc2xpp7Gsv7kYvhe0W04hj1QDm0VPT291IuP3S50lYx2c1ngh0eEQzjuEXfeYb1otwlnmsqYEuSQTX0k9jdtFubva+iCmBlnQJF6FuSUl7ITrUbthw9Py56VZ22Wfli65CY+4pIKJVL5Z2Zbhy36Y48tHCBqcGTKbHrqqXdIvx/wYhY/FLPz3YQX8uXEqNAPm/xNqssoblzrFrL75IutMk11JDfcE2w8MCCNghKHDbf8ifzA+mS8EZsi/qqY0VrNwqy3A2fR5cVOtoHPa4hazs6y2lhs1Ux6ZSHKrX/qv1aOa+Zt0AXpjxttiLc6E99wqhbTIBQDm7FO01CICfxTMjPbt2EzJHLk5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 1:45=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Aug 21, 2026 at 6:38=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > For reclamation, it makes sense to reclaim folios from tail to
> > head, as folios near the head are relatively hot. However, when
> > moving folios from the oldest generation to the second-oldest
> > generation, using the tail-to-head order would effectively cause
> > a cold/hot inversion.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>
> Hi Barry
>
> This looks a really good idea, thanks!
>
> > ---
> >  mm/vmscan.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7bd01875fade..2fd82b2ca4d1 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -191,8 +191,20 @@ struct scan_control {
> >                         prefetchw(&prev->_field);                      =
 \
> >                 }                                                      =
 \
> >         } while (0)
> > +#define prefetchw_next_lru_folio(_folio, _base, _field)               =
         \
> > +       do {                                                           =
 \
> > +               if ((_folio)->lru.next !=3D _base) {                   =
   \
> > +                       struct folio *next;                            =
 \
> > +                                                                      =
 \
> > +                       next =3D list_entry((_folio)->lru.next,        =
   \
> > +                                       struct folio, lru);            =
 \
> > +                       prefetchw(&next->_field);                      =
 \
> > +               }                                                      =
 \
> > +       } while (0)
> > +
>
> I got following warning from checkpatch:
>
>     =E2=97=8F checkpatch.pl: 92: WARNING: Argument '_folio' is not used i=
n
> function-like macro
>     =E2=97=8F checkpatch.pl: 92: WARNING: Argument '_base' is not used in
> function-like macro
>     =E2=97=8F checkpatch.pl: 92: WARNING: Argument '_field' is not used i=
n
> function-like macro
>
> Maybe you could try b4; it helps run these checks automatically. Feel
> free to ignore if you think these warning at pointless.

Yep. I vividly remember adding this rule to the coding style, and Xining
added the corresponding `checkpatch.pl` change:

commit 6813216bbdba1 ("Documentation: coding-style: ask function-like
macros to evaluate parameters")
commit  b1be5844c1a01 ("scripts: checkpatch: check unused parameters
for function-like macro")

But once we started writing the code, I was influenced by its context and
ended up following that context instead.

>
> >  #else
> >  #define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (=
0)
> > +#define prefetchw_next_lru_folio(_folio, _base, _field) do { } while (=
0)
> >  #endif
> >
> >  /*
> > @@ -3932,9 +3944,10 @@ static bool inc_min_seq(struct lruvec *lruvec, i=
nt type, int swappiness)
> >         for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> >                 struct list_head *head =3D &lrugen->folios[old_gen][typ=
e][zone];
> >                 unsigned long protected[MAX_NR_TIERS] =3D {}, delta =3D=
 0;
> > +               struct list_head *pos =3D head->next;
> >
> > -               while (!list_empty(head)) {
> > -                       struct folio *folio =3D lru_to_folio(head);
> > +               while (pos !=3D head) {
>
> Do we need to change the while condition now? Since this commit still
> moves folios one by one, will it stop when the list is empty?

For this patch, we don't need to change the `while` condition. That change
is more relevant to the next patch:
https://lore.kernel.org/linux-mm/20260821102538.22642-7-baohua@kernel.org/

So I guess I could move this while (pos !=3D head) change to the next patch
if that makes the review easier.

>
> > +                       prefetchw_next_lru_folio(folio, head, flags);
> > +                       pos =3D pos->next;
>
> I tried prefetching in MGLRU previously, and it didn't look very good
> but there is no regression either; perhaps it's very arch-dependent.
> Anyway, I think we can keep it here, maybe further optimize the
> prefetch later.

Yep. I guess we may want to keep it to help architectures that are
sensitive to prefetching.

>
> >                         new_gen =3D __folio_inc_gen(folio, old_gen, &ge=
n_increased);
> >                         if (gen_increased) {
> >                                 delta +=3D nr_pages;
>
> The rest looks good to me, thanks!

Thanks for the review!

Best Regards
Barry


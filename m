Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E21CC624DB
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F696B008C; Thu,  3 Sep 2026 22:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D04F6B0092; Thu,  3 Sep 2026 22:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D8F6B0095; Thu,  3 Sep 2026 22:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF836B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:28:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9CAB1205C7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:28:53 +0000 (UTC)
X-FDA: 85174496946.09.5D391A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFB5840002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:28:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3qNwl0I;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788488932;
	b=45qkMHDT35beHMkDVheAMYbHjrw9VTPiAscmIooToARfkfYbc1lBv5sohlYtK5Oja8AT8m
	qDabIGbO5x7jwLjzU/d2BRjcwV37HgCYTWyY+q4yk5zFchgrnTzs5atBSUIK9ua7fNTAZ0
	+Hrs+QjwuNT5TAJtpMfIJ+Ysb6tXmeY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788488932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr/6gU2VLqIj9f6Ya7EWpzVWAPYr+S/Edep5AAlZVio=;
	b=yZMpomQ7EkKlZEB8QcNBWtwx/+PjoscLtpmXkRfI5hrrhmAOMUJR1M21PXzIhsMwOrKUJr
	1etGg4sJCoAampkCg8Ybx2KQoetCH8dNBxATQvCHCGEc5ZT5b86qNi6slxbKvrSLbF1vhQ
	5ZbvPF4Z4XsA683x1mThe4xzfxKgeus=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3qNwl0I;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF11E4120E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38701F00A3D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788488930;
	bh=gr/6gU2VLqIj9f6Ya7EWpzVWAPYr+S/Edep5AAlZVio=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e3qNwl0ItANLtHEi6CUxgYlSJ8qEA/UT9aU8sDgUiEmy3kKlC/OqBRB0aIXbpGyjV
	 VJJr3v2lobw+4c2lpEQef/jzmEpgsM7Eh3x8L67yABn7WTPhKNHU31dc63lWXWTTcQ
	 mArPr0NqO9jUn8DNLgv3ldY4DLmIKjlzg/DN16aU/JTMIPRZVf7jXs7jicGxzgSzcv
	 8R5YkeIRTNNk3JXcRWUM0WLzKCeDnDxxGkIiBE03CPRl++V+chLUYG2FKTfKIHa1I6
	 tnAGNegcKtj59dgcFC0WU6xau8guwobKUk3DU43UoMroOq7HtiS805x75Z7Dg4RNkj
	 xjmiTkO+1nSvg==
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7777fa8f1ccso175086137.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 19:28:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxjKjW5AksIjWj2t9Lj06jFn+UBbN5JwBExUFoBdJyhlKCNOIJtbpFnyc6MMy2kraDKLTT+6fMbJw==@kvack.org
X-Gm-Message-State: AFuF++lm1smxAJCC2JfLq1IclIf5RVyapQoTQLNUPLk+m7HtrJz6e51j
	vxmHpVHKVs9P2GMT7xsXAeJbvttyxYWDhXXii0cvnOyA/hfIuFf5FqdHc38uFL02fMEa99SLRYN
	eQ58zlmB8MiuYttG0aRKdlWZlLMF8XkY=
X-Received: by 2002:a05:6102:5814:b0:786:b28e:f980 with SMTP id
 ada2fe7eead31-78a4a99f7c6mr721213137.10.1788488925089; Thu, 03 Sep 2026
 19:28:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260901232421.40157-1-baohua@kernel.org> <20260901232421.40157-7-baohua@kernel.org>
 <c1992315-8e2a-45eb-a042-29f1f1725f76@linux.alibaba.com>
In-Reply-To: <c1992315-8e2a-45eb-a042-29f1f1725f76@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 4 Sep 2026 10:28:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ybQbbxxyz5EU29cckoQQpm4PrQi3W2Bu3Mb22UCjFBrQ@mail.gmail.com>
X-Gm-Features: AcwNN1XlTuf33SqEleYaxTuUb-aK9RfjrAN952awxM3DqUWGAJMxHfNaoPeCQ4k
Message-ID: <CAGsJ_4ybQbbxxyz5EU29cckoQQpm4PrQi3W2Bu3Mb22UCjFBrQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DFB5840002
X-Stat-Signature: 4g38iei9afifgfrb11p5m7yrjj9d5fyp
X-HE-Tag: 1788488931-362780
X-HE-Meta: U2FsdGVkX19uypW1WjxGebbmXrt7BO0OYsDc6sMkjuUCKTBj3UZ8B34cIzJOSwCgb0GKLKLiEprJizMugECGOmi9OjNDj5HnB0juYXzhKAeKGmUt5rtDXdiT+W89JzEtdXenxblydCCRJUno7xSDrwMKNKhG1w3HlCZJl4WI2bhhiuP03NEfbWwhxknazqwVonwqo66NHO/Fe+iiBma0mPm8KbpSReDecdL4knfiINPpBD5dvZbBFP783qAB+6cA/2+ENtMGT0WT1lTxENCJ67cUizvnCsSuJmuXP25zMgPJMMXsaHrT46uRiHsNGfS/pTMv244DTTotI+x5yXpWZqXRvesV4knmWEKDqTUu7iwaSFeyS7Lzt2PqrWeXZe2RQy+WOMUzaxNI4TvxMnkGgLWriL/vsvn6VVrIyuC8uPklIYcR5f1RlD8ncXuLJE52x6mKr90V67l8oLG79Fb/XjQQMKaI+vDawra5qI0fTczC4wHmw56+qEp1TUQdD7jHPhCxM1vUi1kcIqtV4DXEObmwkMUOV3FojgC3akvt2OLc8jNIXRlPX877YqlRfq6L9JoV+lJivbVabui8APg9hYc33MIKSojGwp6hTiMEtD5SVBuFboe6Mk7qAOBco5TxIo7NU3lzfK/JMtMqb9rFAg8NOtUPha6cLXt4qpmkPEajV/vNRBgSO/XSdPfh41lGbYrUZ6FuxSqtaXhcW2HY5QO3og04adFJ65UH29eCKSy9xnYF9OfTgiL/8B704uPxjKGQ8xiyo2/x/f1xwORUFxjj9/C5sVvWZZ61217SbchWu/hXSfW/Egq4SaPZC6D3g4bL2JZbHaJa+mjUzC1ayto6QBsvsuewB1YjKR4xOhzy4iKBXLgVvWBqiEEyHoJDN1pNJij/Xuwx5Kyy4RK0Rnxnftlj4kZMXvcYetqtxkI7JoLYBSlMWPwxEu+6odjg7t6xcx/X9Mdn2/aJB6+
 6yt160eh
 ThL2nYnoXCt75nx6CIJxzQjzHdFMlao3661g90Y8wJXMseBhZ1U+QEO0/ZSKzo9ZBZ1oLYkhWZfdMj0aNIwHLQcW84ngTVAu7ObYTzgM7br9dmXJhaO3S1umrmCTAGLCtbXA30SwlH6yilYOg6wVk1s1I5j5LtSrVDLVXyXpCINJ+F5uhihZYtN6HLThgPCyKI7CQbJDQllTTTTE/LMpkBwI2vPQJb2wDppFzXEtle2lXAma0tbcJ4GeiAWx0TMK+/Fgp3oveP0iALaMm7OqCm2CTcA8hwBI6H9B78q40hbNq3fhJho2ZAf5W6G4NdoTWGEGZfvJq7eGkMkf4GdJKCyXe69cPmWfnbNCDCX+cnftSXMhyHGkOrPlD0+wrMxz7tg2WLogk+dVQvE9nfh3bAHvGpJQvgPRGqz46+c4zo4cgzsYmDM/gEn/U5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 9:53=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> > For reclamation, it makes sense to reclaim folios from tail to
> > head, as folios near the head are relatively hot. However, when
> > moving folios from the oldest generation to the second-oldest
> > generation, using the tail-to-head order would effectively cause
> > a cold/hot inversion.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> > ---
> >   mm/vmscan.c | 23 +++++++++++++++++++++--
> >   1 file changed, 21 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 1907a946840d..76dfa9575852 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_folio(struc=
t folio *folio,
> >               prefetchw(&prev->flags);
> >       }
> >   }
> > +
> > +static inline void prefetchw_next_lru_folio(struct folio *folio,
> > +             struct list_head *base)
> > +{
> > +     if (folio->lru.next !=3D base) {
> > +             struct folio *next;
> > +
> > +             next =3D list_entry(folio->lru.next, struct folio, lru);
> > +             prefetchw(&next->flags);
> > +     }
> > +}
>
> You did not mention in the commit message why this prefetch was added.
> Just curious, does it really help performance?

Hi Baolin,

Thanks for your review.

I had this discussion with Kairui and thought it might be
useful to keep it here:

https://lore.kernel.org/linux-mm/CAMgjq7AJnWGGH=3DFNuV7ynXjbffktsDRgdcyagLU=
JUwJf1ukaJQ@mail.gmail.com/

It might be arch-dependent. Some architectures could benefit
significantly from prefetching, while others might see little to
no impact.

for my x86 test, it has very slight improvement:

***** no-prefetch:

agetest:
...
gen 100:    2.421 ms
gen 101:    2.424 ms
gen 102:    2.420 ms
gen 103:    2.413 ms

Total:   248.418 ms
Average: 2.460 ms

agetest:
...
gen 100:    2.393 ms
gen 101:    2.396 ms
gen 102:    2.395 ms
gen 103:    2.392 ms

Total:   245.627 ms
Average: 2.432 ms

agetest:
...
gen 100:    2.433 ms
gen 101:    2.427 ms
gen 102:    2.432 ms
gen 103:    2.450 ms

Total:   249.186 ms
Average: 2.467 ms

**** has-prefetch:

agetest:
....
gen 100:    2.314 ms
gen 101:    2.310 ms
gen 102:    2.321 ms
gen 103:    2.303 ms

Total:   237.619 ms
Average: 2.353 ms

agetest:
gen 100:    2.342 ms
gen 101:    2.343 ms
gen 102:    2.339 ms
gen 103:    2.335 ms

Total:   239.929 ms
Average: 2.376 ms

agetest:

gen 100:    2.344 ms
gen 101:    2.347 ms
gen 102:    2.352 ms
gen 103:    2.348 ms

Total:   241.188 ms
Average: 2.388 ms

Basically, it=E2=80=99s 2.3xx vs. 2.4xx, lower is better.

Best Regards
Barry


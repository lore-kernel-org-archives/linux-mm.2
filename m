Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94B4CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 05:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016958E00BD; Tue, 14 Oct 2025 01:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30948E0005; Tue, 14 Oct 2025 01:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D008E00BD; Tue, 14 Oct 2025 01:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6E1F8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:08:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89164BAE1F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:08:09 +0000 (UTC)
X-FDA: 83995538298.26.0545901
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id B525F8000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:08:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wwMNJmn7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of edumazet@google.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760418487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5JkuuVSayA8Ofu2uznRObRn+eA97FQhk4dZT2qKwso=;
	b=2IZ7m2RxdLUXTwHwns9260i4pywvwQt+VEzDnUAsSVkDZjvQGYO5WG3mYmuOqylFhVijVc
	oY2sm32SqCS8RwWVat14tVV4whVe3gV4Noim47n+wHwRzqmTpp6M6+5fSnAx5lcELqFKYx
	rxBaYgUubj/ablxa8SmrPscA2yAWFas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760418487; a=rsa-sha256;
	cv=none;
	b=Or2oz805cphJqkNhZEj02GAimvosofdMPxBX5pj9Slqsv53doQp+BnHULeN+tKj78Y7G4Q
	PFlwT74w9yV8BISaSCWqzXBph0auQm/lVigtOgIl0CHVbijOUMsKLb6IUBetpgNHGLoKA2
	ZMORc4gmn115fkR4jShs/78wo1ZH/ok=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wwMNJmn7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of edumazet@google.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=edumazet@google.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-855d525cd00so873252985a.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760418487; x=1761023287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5JkuuVSayA8Ofu2uznRObRn+eA97FQhk4dZT2qKwso=;
        b=wwMNJmn7mYWvaXf+j6IHIM65qxylhFr+FeZlFoQ5yFFVl9+Z43AmLkuEHW3SRodzFw
         YKZmnPUmIM8Nh3lLsoPqdM0ZBzw2clfjtXt5ljRZB59sF6eW0HQIcyHa6eSTBhNp99ox
         IsQzkE001kbkWpit8vX40napDSHhFqCUKxC7vdaBXyMq3QYlcIVuyPrRp/Pgh0L1AOUo
         umin4K91Sl6oqy1KA4snbt6GNhENOj8sa3+KId2RZhlrnDgBlW70Yjfjx3Wigwp65YjF
         3xl2zABOyZx16i6SA0XregRGwNooA08/4tPruUyESlQXzfW/O6aIbfTlZCctRXeiqVHV
         CjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760418487; x=1761023287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B5JkuuVSayA8Ofu2uznRObRn+eA97FQhk4dZT2qKwso=;
        b=EpCCuvaz05XS1NBJmnIjDQne9O/TuS6W/kAhmRD6E4b8bmL7Rpvqa41MVHPVZX0Z7j
         Mx/PPUhgD4KbR9SOCF8qqd7hPNYzdrw1ttZF3/T30Nd0njZm+b5VgXP1MfgFoQ9bS9lI
         jJKIMHD72wjJ0X6MBDiOlG/ZxGJG0PF1RvW8vKh8FsoOqYU0dJB0g7ltPk9b6I3K6k7y
         Skz1FkfpZ0pxtEakSr8OmbHJbPPP4eEMKnCoVvfkOkbm9VIRR+EUGxqUCvWuiKibX5ba
         qtxSkN/Uy8owQOHOcIHmBZRSM2kmupI8DAaApuYRq43nKflEHyRmeO+za2wjdbFHSJ0j
         mrZw==
X-Forwarded-Encrypted: i=1; AJvYcCX+QInCn6OjCOqeRxvYp+ayefWt3j2rn5VfL93ceLGqPksYwcoFoch6Yw7zSqb82vMS4mc71d/RZA==@kvack.org
X-Gm-Message-State: AOJu0YxG0oUJU9RwoMuuUbgyOqCM0NGj7DUrN8PFiqsrPEbQNcPvj76K
	aumcpnHq1+tCyDsED68R+pzL3+66IH0IicKYvmhfTcgoLIr7TnlheRQ6MQfCPQN4v30FMhl0iO/
	J+HlonxQKGkj8Uwe5/GniEpmAbj2nBUJPGS5Ws+68
X-Gm-Gg: ASbGncvkqBqfKOUzmGcpAzv4Dtd6IclKVqPeGt0SI+viYR8S6oqr/HeO99O3E6pLfBc
	pbb4sd2QxAjnVUeH1vfoifQdgPdN0XLB101HR2tAxQn3iWbsFt3i4H2OLIQTi+gGmtx0rvLhmU5
	drmcuxbkuC5T8yyQXy32Kaw2J+Gx/xlCB08GKnjcjSr5dut0ZMs9o32TWwzZdbiP7fZS2tAmtsN
	2Ar0gv8GluRKbAAUD/xU5sW4czII0W1k/9UMA525So=
X-Google-Smtp-Source: AGHT+IG/8aE+aHcI9fnIx7BC8BEsSWywbVC7oJ9GTxoNgoK6tWmthKLsGkvfKsZG/szhyaZle3TfMxlghiUG7vn+aPI=
X-Received: by 2002:ac8:7dc7:0:b0:4e7:1f14:c30c with SMTP id
 d75a77b69052e-4e71f14c405mr115414241cf.69.1760418486272; Mon, 13 Oct 2025
 22:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
 <20251014035846.1519-1-21cnbao@gmail.com>
In-Reply-To: <20251014035846.1519-1-21cnbao@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 13 Oct 2025 22:07:55 -0700
X-Gm-Features: AS18NWCWxB4_7MksVcSk_C7g7SO9YHjPuxXQz_zjkiBQ0xejWPMAGosiT_EXkB8
Message-ID: <CANn89iKCZyYi+J=5t2sdmvtERnknkwXrGi4QRzM9btYUywkDfw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Barry Song <21cnbao@gmail.com>
Cc: corbet@lwn.net, davem@davemloft.net, hannes@cmpxchg.org, horms@kernel.org, 
	jackmanb@google.com, kuba@kernel.org, kuniyu@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linyunsheng@huawei.com, mhocko@suse.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, surenb@google.com, v-songbaohua@oppo.com, vbabka@suse.cz, 
	willemb@google.com, zhouhuacai@oppo.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B525F8000A
X-Rspamd-Server: rspam02
X-Stat-Signature: aicib3beifmkqwmufb3z5kuop5dqcg9n
X-HE-Tag: 1760418487-139887
X-HE-Meta: U2FsdGVkX18Vmx61jENKXcvlOVq1byCHd7gH4UkcQidshB6k2KBt4m4rU6ej4DsJZyyC0rxPUxWCaZ6YfcwPdWRp24ZWYbOYZS28HkZzkdytFbg88IvWYMf2iwHy5mkwfNi6ZZkGEuGc0SizbU0uItz4EjhMfXKuxO7K5guTKwiO4iDJpbQff541KTuonckA1LUf5et2Jmg1n8tULiMuYIoocQNjHi/mGWAA9scGSY+Lqt04P+0F03e0hCFEIlTD+SAJ+ssqpt7eSAYvOCbngE6BLHXapCBHHDnIFHt8aB05zvqkCz3efNGMrLdJ2hf0OfQNU8Ra6iyX5RXY50nBVNDZT1PIfjkuRaZQB8hdTMusvG0AzocI1KhokLAfbkUbwT26u39vc3Xj5DUQt+U4c6upAkvE6V+DnEdT3zQdDGx/Nk5g6YQp96ngIjflsC8e5ofYrppdIVjMHMxFEwW8JnGR5yi2dn/5LlD9EOWKBT5rvL3WijmVzJ82imHPPmJl7OJPjtuYb41jt1/sYgL0uz0nh2KnqY6w4fWAVhDw5en6ErL7hFTNcJwVzSvmCCpytHrz7oTbhbmGTa/dFTs1UTilgupm7twWuj7EZFZ6h/P5yqFjGSQhW8dRNWkyhNhNzfdBzA649XFCwoc4x6Olslds4jG+K+YeH0LiH9uTKpUScG6p3bZe4bmv4lhGx5i/pdybkRnJsFeFRlE+pcGtZm7/iFHlTtQuoHgfoVw6g2LHyFAd+Bpu0QSu+n3DOaeyvDbFR4A/OhihRszVPJD9Ke+79tDKmwkguxHTKp69TOBLWia8HS7kxnEOZWzZYoPVVSDNrOGzllfuIFtDag7OXcVHs3k/bLXGQrvdXeDu8CQ8Y5YVYiMvtvY1HGcF+EeKUzMr3T+oTFRIq4JpD785CvHgh4FrF988nOjaGUi+PIwReozrsOhS5xZdJDph7BjdFRTW2KaG1yvXo5TlLz1
 mT70c2bP
 QboV/HpvUzHY1+1KJvRZVmcqBvTQkys6GM6Gfimgu4HcqXkrZPGHm620JvkQRDs6iXc4qa8CNXNcIzywQw3o7X4FCIKKeekBhDJ9Da5diNt2jSFwkP8OfOWd3VhdEIUNf2D/I9ULYLr1MJpTCt18gpWp0+w/2d0MdiU/JaPnKp7OfvHkzYuetmGP+Otz74r9cfbNCjkO4IHFbyKktGx4p5moaOeZGO/bx3pL2RS7f5vUlNgvHOeNRRnD58OlhkTyrzYos
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 8:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> > >
> > > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation=
/admin-guide/sysctl/net.rst
> > > index 2ef50828aff1..b903bbae239c 100644
> > > --- a/Documentation/admin-guide/sysctl/net.rst
> > > +++ b/Documentation/admin-guide/sysctl/net.rst
> > > @@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on=
 a per-NAPI list. This
> > >  list is then passed to the stack when the number of segments reaches=
 the
> > >  gro_normal_batch limit.
> > >
> > > -high_order_alloc_disable
> > > -------------------------
> > > -
> > > -By default the allocator for page frags tries to use high order page=
s (order-3
> > > -on x86). While the default behavior gives good results in most cases=
, some users
> > > -might have hit a contention in page allocations/freeing. This was es=
pecially
> > > -true on older kernels (< 5.14) when high-order pages were not stored=
 on per-cpu
> > > -lists. This allows to opt-in for order-0 allocation instead but is n=
ow mostly of
> > > -historical importance.
> > > -
> >
> > The sysctl is quite useful for testing purposes, say on a freshly
> > booted host, with plenty of free memory.
> >
> > Also, having order-3 pages if possible is quite important for IOMM use =
cases.
> >
> > Perhaps kswapd should have some kind of heuristic to not start if a
> > recent run has already happened.
>
> I don=E2=80=99t understand why it shouldn=E2=80=99t start when users cont=
inuously request
> order-3 allocations and ask kswapd to prepare order-3 memory =E2=80=94 it=
 doesn=E2=80=99t
> make sense logically to skip it just because earlier requests were alread=
y
> satisfied.
>
> >
> > I am guessing phones do not need to send 1.6 Tbit per second on
> > network devices (yet),
> > an option  could be to disable it in your boot scripts.
>
> A problem with the existing sysctl is that it only covers the TX path;
> for the RX path, we also observe that kswapd consumes significant power.
> I could add the patch below to make it support the RX path, but it feels
> like a bit of a layer violation, since the RX path code resides in mm
> and is intended to serve generic users rather than networking, even
> though the current callers are primarily network-related.

You might have a buggy driver.

High performance drivers use order-0 allocations only.



>
> diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> index d2423f30577e..8ad18ec49f39 100644
> --- a/mm/page_frag_cache.c
> +++ b/mm/page_frag_cache.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/mm.h>
>  #include <linux/page_frag_cache.h>
> +#include <net/sock.h>
>  #include "internal.h"
>
>  static unsigned long encoded_page_create(struct page *page, unsigned int=
 order,
> @@ -54,10 +55,12 @@ static struct page *__page_frag_cache_refill(struct p=
age_frag_cache *nc,
>         gfp_t gfp =3D gfp_mask;
>
>  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
> -       gfp_mask =3D (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
> -                  __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
> -       page =3D __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
> -                            numa_mem_id(), NULL);
> +       if (!static_branch_unlikely(&net_high_order_alloc_disable_key)) {
> +               gfp_mask =3D (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_=
COMP |
> +                       __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
> +               page =3D __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDE=
R,
> +                               numa_mem_id(), NULL);
> +       }
>  #endif
>         if (unlikely(!page)) {
>
>
> Do you have a better idea on how to make the sysctl also cover the RX pat=
h?
>
> Thanks
> Barry
>


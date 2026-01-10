Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276A9D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 05:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E256B0088; Sat, 10 Jan 2026 00:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB7C6B0089; Sat, 10 Jan 2026 00:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472106B008A; Sat, 10 Jan 2026 00:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 345B46B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:48:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAFE455AF8
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:48:54 +0000 (UTC)
X-FDA: 84314975388.10.914B3A8
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9587140003
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:48:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mgycGVuz;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768024132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbNBS6+582THKiphuJq71Lq4d9pP5yCfw3WH36b5sQw=;
	b=Mba/4S+Ts1208dyEyS+iY4M1FYADIwl6AgEjAS7/gductVcAFbp9OdZ5cHgrpJhfYEyBZn
	To/wY9ZfTQ1QbBKqDstqNO57Yy+eJWThw0352g6JgQECMKjFEsBGN6OFYqmlxADGEeUp7M
	DaYIQZx9talEMCsiS2z8+AL5fQHFwaU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mgycGVuz;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768024132; a=rsa-sha256;
	cv=pass;
	b=48jgi8mBUgPL3LeqtXIu4jMI6uD6K5sia6fW3+R6O7if2Bcvxu3252Fk98Riecop8dLXXW
	36TXM6NUW2msvzTb5/LNufBRYWiS0GFxj22fpkDO1b2BI/x2XM4BcBMur0eEjL3v2k2Au+
	9Yuwgc05lT72Fod+u0MHd1DIVPn6S0g=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso29025e9.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 21:48:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768024131; cv=none;
        d=google.com; s=arc-20240605;
        b=CfquWpklykAfGiLPDRNPFouWr25xf5vLU1qybTVI9s4p+RC2Iat+TlSMuaV//GTG1b
         9/wbtXQCLtK8YOte5R6vCW2oRSAZk3YidX1IgwduA+jyMr9/Bn7yVcpvLLQXFFvqm2uo
         IGNJv2aq2vC9/T5KzGJpDUickGzMujRffkeH5FwGtSQaMMuOZdYesKCf5EbQZKvMMRs0
         THES49NPm1TSgRKL6Cx+34ShT3c8ex8JHepMkkfSLDuAJtOrcIB35hS4Lf0BcFT8eGCZ
         ldkR2SkN9hyyJMNbsx5yBF5+2ZtviYSe03RcYXC5vN20QI1FLrmDJwUuMIy+wel91dxh
         1ixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TbNBS6+582THKiphuJq71Lq4d9pP5yCfw3WH36b5sQw=;
        fh=3W9AZdv1TAqM/tz+A96ovMIUQCou85FcjIf8a8O8I0w=;
        b=Y/JuFZ1xKlBJ1aIFX2YbBbhb+UvSqVkMisW2OiCqqu1H9K/WQSeKAdvgra6yGpfuWu
         giF3E2KlivjE6gDLNkuRVe7w624MWCJH1AasJ9OMUKFau6wScfemBzSUMqfn7t610Iea
         aPrG9NovsLw/EcoeshOM5dGxkQr0NjswnSEDeUoW8vox+Dq/Z5Nx/EIZDguso3ttSlEm
         DIoaCadlXoPHNzl4Jclqg0dwweFfX3WW6Gca+1vI4ivmz0FkNfpy7YJNkNQ3+w/ilY6H
         YF3hTTKLLc/5SJCZhqU7VKS0sV+MdSUPdutekmBlFdqj72o46VtaXfpFwQKTNtT6eCaa
         Ijsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768024131; x=1768628931; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbNBS6+582THKiphuJq71Lq4d9pP5yCfw3WH36b5sQw=;
        b=mgycGVuzYi28NGDmTnVEai2OFte/+gryEij6kfZ7I2uDvKINYCgt7kut6sJ4RkGYtz
         7LraY5z0ULcfWLfT8s/XWqixp6Digs7DNR9BuNXz05O0P+TQKSBOzWk+S1yvfSlr/bHv
         MoSkrkr54LTlI6PRr4ZKLqQGC/Ajjm40OKoFQoH3k+q2sWyd0lbFBvizMd4Rnhdtgpyr
         MMomPsUWFd5Nz2XVJkVpOa/1Z11GDyqefqhrKS6zKUSla7F4SLFI9gn/rIEV58t7t5IF
         vq9TpTtrdF7SoolIfJYgOFd3SYzQ66G0h/A2JGdhLSbjg8P/KhACZeQ8FfP662lGScNI
         cGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768024131; x=1768628931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TbNBS6+582THKiphuJq71Lq4d9pP5yCfw3WH36b5sQw=;
        b=wCsufukiTPfyo1P9G25EvYcfvuQYd+maC0UFoMWCinAPYnNhsXO8wP63Z3qdN3w42E
         b0UkUFxeN7jMX9JHEHeNvXsu2mYx9sV8IsB6o8rywcRp3XbpXQtkdNOIaXaPV2Dnqk8g
         lNHJLWyQdWACAp7YbK8UIhL6EOdILdRsRebxfvItW088+RAVqZUMeTWSIXLkqpKYW/cz
         sboPpDhoHEfxsnBhqArEzVU+1PmonhoCGLVV2GG9ISQQJYYmYYNoKbj9iVRnFZAXPHwQ
         l+DAelsP4ZJGpmFpdUdUJ3V3xCuCC4n66s983V6olyxo7favPlu2b7SwE4B6m4SS3UNT
         79lw==
X-Forwarded-Encrypted: i=1; AJvYcCVng7UYGE0yOY/U3nQVcN1JVCI/yomRaghg8EjtbbuBfs+yJNBoV2UVH6jpCo0bCGFz2Acw9aZgBg==@kvack.org
X-Gm-Message-State: AOJu0Ywgqj++XH9uEld0NTd0DBFQ01GamBBlzhCYvMoqvBY8b+UtdohD
	/zXCZz5y0mn977TPrC7Zw9PVX800Zarxw7rU9eqA1453UTX0f0FbgOuHMsjRpeMNPKRxibklv1I
	pZkHJ+YGG1MQ9DTPncAEENAbf+IaZ3WbPRyR9mJZA
X-Gm-Gg: AY/fxX6vbtZkdNXUdbm8h6egvweZAgqyz/1+AbucDAYkx9GFMLJa53/fKP5K57b2wMM
	KAlTYovIax5J9qm8RTkmB2Wx8XNsQg5gvt5oZZdI+Dog5yKWMY0nDiW9I1uL3YF4Z3NiLUecXua
	IdbV5U0jGlwp2PFjucSLLHMxBfOLRR/bNhABkOwripuDx2pRHU44e53ib5qyhsZGAXEEGXxY1PD
	XDBfg8leRjYT4PFYVNwe1vj/kwNW37rtQx6Ey+QRToD9nEhm0qvYUg1SshyvUKh9HHJ/+SAhWUA
	jVn72EdVhKpFdd/ARoXZubVRufVo
X-Received: by 2002:a05:600c:6a93:b0:477:76ea:ba7a with SMTP id
 5b1f17b1804b1-47ec5b18753mr233785e9.3.1768024130914; Fri, 09 Jan 2026
 21:48:50 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com> <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo> <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
 <aVHWOMa9n40_8Yu3@hyeyoo> <CACw3F53p9TyAZs2pn+aHo85=aZx0+unaoLjeFtEK8DJ8A5TD4A@mail.gmail.com>
 <aVSojEWdFPsb1fg7@hyeyoo> <CACw3F51ZnjaHtsorT0ao8S5K8Tvzgqb6fT9hr-WBavkqivz+BQ@mail.gmail.com>
 <aVy7L-3pc4JUYBEn@hyeyoo>
In-Reply-To: <aVy7L-3pc4JUYBEn@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 9 Jan 2026 21:48:39 -0800
X-Gm-Features: AZwV_Qi18lgv65yORn7Pvp_oZbAw-fLVKU2au5YVXPT1OwuP166-f_JTqoWbsPw
Message-ID: <CACw3F53YOMWam5OsktJLtw0bhx4Btq-1vnz+ZgcZi43rH4j0wA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
To: Harry Yoo <harry.yoo@oracle.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dqmzbegkgf7ehnwi1tttrk7dokmhhwky
X-Rspam-User: 
X-Rspamd-Queue-Id: B9587140003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768024132-427412
X-HE-Meta: U2FsdGVkX19aHHhuHIDESFz5kRiQHbTgrJ0XH9ecswQozH5NKnjhCJwej5ac/ev84JWOACXTq8PSJN8gpbbOYFW9OHaeMRImbehUw9IgD/8lWM8QZYb2cx/XgfvGG/3LD63dbS0nXmoN38NhtbOlF7RuoG0GiuZb9p4Vr44syv0M0/r+1urgJxsS3wI6BaSzomyNEMNgCSy3ElNWAE3i3qBJ7BBVQB64ozY4+G9HJw2M2oa+BGldcdOma8RU5qp8hqxZ1S6EaEg2oiELOtcJr/apgIBT4o9Ry+PGI/LuDQsOQe0qzrZH6xjq+t8NSd1NGhEYQWWhPE1C07jn7Z+9uMnNV+L7O+fTSplvwxz4UEfhqlHeX0sirJonziq3hWe7pafkcSsCI4V419r3qm6vrtBhmZw9p8/ddInb41iNwoigGgHVSsgrvmHoF5Hl9j/z/+2IBFxQh9QHIQdjGiU/aLTBBx+oKDPAiQJfQ1D62+4wMbSbqaPLWm2ZQsrq2H7zQl7GaRDsrN0OzqNlZkb1z3Bm+maiYTf6b9El/v0EO4lbsV2CRNdAmJXyH6j7zdSjRE3DrAe5ouwzUlGx+HwPaSG+XfiFZzrj/JkAR3+w3u05/2lTw3YsRv+xu3OHIildGKwgI30RzY69ouQ/rLKXUUuf1WoyW0vfFYH8O9wD0A+zoN7mjajg65KfiBtE7gjLq6pREm7aRBE+ryPc5jrQS6eb9m+UP1sDVt9lQzrk9g9J8g0bqE3g72lErAFY+jvdgoy545BlOcpVe1pHbU4odWo7a6xqHeBUInVjYr/tPymUHiNRIgOvQzXSvkILjpg2E6sItfW/LKvKqJcClzdsPPf430ohUR3BQDWiw2lqKQ8/rvV4v1J8lMM4MlRLXohh/MmUZrr+0geX02BYmn21bwEI2EDSe7Tcflig3WTUW8v1umYxWLP0QzKODOq7hFtNEZqUii5hhK8A7xr/ICE
 8PubSuyx
 aGLn2zhUENs9mKqgkmkddvznv7yNs0bFqblkOCgspjNgNB9tz65Vk0MVIR8XyuWrgKFOBhWF1s7gw5hwiTNJeplZOdRwHF9RSC8kwbz2MwI8P+1cNExBmO09PgKWVbBto2PJIeqjsAyvC9TPSwoye4D3zgKJ5DsDgqf+iXlxcUgcosQrsLnJL5MkgRrTe0iH4q03LMuaLHDeFtFF1b9nsg74fdkM+S5wBrZBBAXepY8gFUEOk0pL9KTF527aJgSUYecWoWohET6pqqK/6Cstwfm/4LTAzKVrJIToN6gkDUbHyGhcD+yiFzKnyBTkV4qPSTzVT3rxHciuJsZWSORCgyeHTGCOqJJWp2lt7lYRHHa3lFMda9bngkuWUprk9hwT9qddy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 11:35=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Jan 05, 2026 at 07:40:00PM -0800, Jiaqi Yan wrote:
> > On Tue, Dec 30, 2025 at 8:37=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > > On Tue, Dec 30, 2025 at 04:19:50PM -0800, Jiaqi Yan wrote:
> > > > On Sun, Dec 28, 2025 at 5:15=E2=80=AFPM Harry Yoo <harry.yoo@oracle=
.com> wrote:
> > > > > On Fri, Dec 26, 2025 at 05:50:59PM -0800, Jiaqi Yan wrote:
> > > > > > On Mon, Dec 22, 2025 at 9:14=E2=80=AFPM Harry Yoo <harry.yoo@or=
acle.com> wrote:
> > > > > > > On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > > > > In general, I think they're not designed to handle cases where
> > > > > the allocation order and the free order differ (unless we split
> > > > > metadata like __split_unmapped_folio() does).
> > > >
> > > > I believe the proper way to fix this is to do something similar to
> > > > pgalloc_tag_split(), used by __split_unmapped_folio().
> > >
> > > Yeah, that will work.
> > >
> > > The difference is that pgalloc_tag_split(), split_page_owner(), and
> > > split_page_memcg() only support splitting the whole page into many (>=
 1)
> > > smaller pieces, but we're trying to create only one smaller page from=
 the
> > > original page.
> > >
> > > > When we split a
> > > > new block from the original folio, we create a compound page from t=
he
> > > > block (just the way prep_compound_page_to_free does) and link the
> > > > alloc tag of the original head page to the head of the new compound
> > > > page.
> > > >
> > > > Something like copy_alloc_tag (to be added in v3) below to demo
> > > > my idea, assuming tag=3Dpgalloc_tag_get(original head page):
> >
> > Actually I had another idea for page metadata like page alloc tag and
> > page owner - how about we do the special handling AFTER
> > free_pages_prepare()?
>
> Sounds good to me.
>
> > Looking at free_pages_prepare, it actually breaks down compound page
> > (if it is compound, using free_tail_page_prepare), adjust page flags,
> > and deals page metadata:
> >
> > for (i =3D 1; i < (1 << order); i++) {
> >     if (compound)
> >         bad +=3D free_tail_page_prepare(page, page + i);
> > ...
> > page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> > reset_page_owner(page, order);
> > page_table_check_free(page, order);
> > pgalloc_tag_sub(page, 1 << order);
> >
> > Even the original compound page has some HWPoison pages, these
> > operations should be done in the same way when no HWPoison page exist.
>
> and we're not losing hwpoison flag after free_pages_prepare()...
> that actually sounds fine.
>
> > The compound structure will be gone after free, the alloc tag will be
> > reduced after free, the page owner will be reset after free.
>
> Right.
>
> > So instead of splitting these stuff into temporary compound pages, why
> > not getting rid of them in the first place with free_pages_prepare()?
> >
> > This is unique to the freeing path, so we don't need to mimic
> > everything __split_unmapped_folio() does.
>
> Not 100% sure how it'd work in the memdesc world,
> but for today, right.
>
> > At high level, applying the idea to __free_pages_ok (or
> > __free_frozen_pages) looks like this:
> >
> > +static bool compound_has_hwpoisoned(struct page *page, unsigned int or=
der)
> >  {
> > +       if (order =3D=3D 0 || !PageCompound(page))
> > +               return false;
> > +
> > +       return folio_test_has_hwpoisoned(page_folio(page));
> > +}
> >
> > static void __free_pages_ok(struct page *page, unsigned int order,
> >  {
> >         unsigned long pfn =3D page_to_pfn(page);
> >         struct zone *zone =3D page_zone(page);
> > +       bool should_fhh =3D compound_has_hwpoisoned(page, order);
> >
> > -       if (free_pages_prepare(page, order))
> > -               free_one_page(zone, page, pfn, order, fpi_flags);
> > +       if (!free_pages_prepare(page, order))
> > +               return;
> > +
> > +       if (should_fhh) {
> > +               free_has_hwpoisoned(page, order, fpi_flags);
> > +               return;
> > +       }
> > +
> > +       free_one_page(zone, page, pfn, order, fpi_flags);
> >  }
> >
> > Under this idea, free_has_hwpoisoned() doesn't need
> > prepare_compound_page_to_free() anymore. It can just directly call
> > free_one_page() when it selects the right order.
>
> Right.
>
> > The only imperfect part is compound_has_hwpoisoned(), that we need to
> > make a call to whether free_has_hwpoisoned() or not ealier than
> > free_pages_prepare().
>
> Right.
>
> > free_pages_prepare() clears PAGE_FLAGS_SECOND
> > flags on the first tail page of a compound, which clears
> > PG_has_hwpoisoned. On the other hand, we can't easily exclude
> > PG_has_hwpoisoned from PAGE_FLAGS_SECOND. Because PG_has_hwpoisoned =3D=
=3D
> > PG_active, free_page_is_bad() will confuse and complaint that the
> > first tail page is still active.
>
> Adding a comment like this wouldn't hurt:

ack.

>
> /*
>  * Should be called before decomposing compound page in
>  * free_pages_prepare().
>  */
> bool should_fhh =3D compound_has_hwpoisoned(page, order);
>
> > I have implemented a working prototype and tested just fine. I can
> > send it out as v3 after clean it up.
> >
> > > > +static void prep_compound_page_to_free(struct page *head, unsigned=
 int order,
> > > > +                                      unsigned long flags, struct
> > > > alloc_tag *tag)
> > > > +{
> > > > +       head->flags.f =3D flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > > > +       head->mapping =3D NULL;
> > > > +       head->private =3D 0;
> > > > +
> > > > +       clear_compound_head(head);
> > > > +       if (order)
> > > > +               prep_compound_page(head, order);
> > > > +
> > > > +       copy_alloc_tag(head, tag);
> > >
> > > Do we need a similar thing for memcg? Probably not, since it should h=
ave
> >
> > Yes, I think we don't need to do anything for memgc, it is already
> > uncharged in __folio_put().
> >
> > > been uncharged before freeing (as long as we're not using it for kmem=
 pages)
> >
> > You mean the folio was charged to kernel memory, right? From my
> > reading of uncharge_folio(), it covers the kmem case.
>
> Yes but I think not all kmem pages go through uncharge_folio() given
> free_pages_prepare() handles uncharging kmem pages.

I see. Then doing free_has_hwpoisoned() *after* free_pages_prepare()
also address this concern, right?

>
> > > Perhaps a comment on why we don't need to split memcg will be enough.
> > >
> > > Do we need a similar thing for page_owner? I think yes, although it w=
on't
> > > crash or cause a warning, it will be inconsistent if we split page_ow=
ner in
> > > split_page()/__split_unmapped_folio()/etc but not in
> > > prep_compound_page_to_free().
> > >
> > > > +}
> > > >
> > > > I tested now the WARNING from include/linux/alloc_tag.h:164 is gone
> > > > for both 2M and 1G pages. BTW we also need to copy_alloc_tag() for
> > > > HWPoison pages before pgalloc_tag_sub().
> > > >
> > > > > > > > +             total_freed +=3D nr_pages;
> > > > > > > > +             curr =3D PageHWPoison(next) ? next + 1 : next=
;
> > > > > > > > +     }
> > > > > > > > +
> > > > > > > > +     pr_info("Excluded %lu hwpoison pages from folio\n", t=
otal_hwp);
> > > > > > > > +     pr_info("Freed %#lx pages from folio\n", total_freed)=
;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >  void free_frozen_pages(struct page *page, unsigned int ord=
er)
> > > > > > > >  {
> > > > > > > > +     struct folio *folio =3D page_folio(page);
> > > > > > > > +
> > > > > > > > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(f=
olio))) {
> > > > > > > > +             folio_clear_has_hwpoisoned(folio);
> > > > > > > > +             free_has_hwpoison_pages(page, order);
> > > > > > > > +             return;
> > > > > > > > +     }
> > > > > > > > +
> > > > > > >
> > > > > > > It feels like it's a bit random place to do has_hwpoisoned ch=
eck.
> > > > > > > Can we move this to free_pages_prepare() where we have some
> > > > > > > sanity checks (and also order-0 hwpoison page handling)?
> > > > > >
> > > > > > While free_pages_prepare() seems to be a better place to do the
> > > > > > has_hwpoisoned check, it is not a good place to do
> > > > > > free_has_hwpoison_pages().
> > > > >
> > > > > Why is it not a good place for free_has_hwpoison_pages()?
> > > > >
> > > > > Callers of free_pages_prepare() are supposed to avoid freeing it =
back to
> > > > > the buddy or using the page when it returns false.
> > > >
> > > > What I mean is, callers of free_pages_prepare() wouldn't know from =
the
> > > > single false return value whether 1) they should completely bail ou=
t
> > > > or 2) they should retry with free_has_hwpoison_pages.
> > >
> > > I was thinking that once free_pages_prepare() returns false, it alrea=
dy
> > > has done all the work to isolate HWPoison pages and freed healthy por=
tions,
> > > so the caller doesn't have to do anything and can bail out completely=
.
> >
> > Does this change the meaning of free_pages_prepare()'s return value?
> > My first take is it returns if the preparation+check works are good.
> >
> > I don't know if doing the freeing work in free_pages_prepare() is a goo=
d
> > idea.
>
> As long as it's documented in a comment, why not.
>
> It doesn't make callers' code less readable. The semantic is the same;
> callers should free the page only if free_pages_prepare() returns true.
>
> They don't have to care why they should not free it.
> (either it should not be freed back to buddy because it's bad page,
>  or it had hwpoison page(s) and healthy portions are already freed)
>
> > But if it is fine, we can actually hide the ugly
> > compound_has_hwpoisoned() entirely inside free_pages_prepare():
> > - true means preparation + check work are all good but caller needs to
> > free prepared+checked pages itself
> > - false means one of the two:
> >   - some check failed and it is impossible to safely free pages for cal=
lers
> >   - this is a compound page with some HWPoison pages, and healthy
> >     pages are already freed safely
>
> Yes, something like this could be documented in free_pages_prepare().
>
> > Doesn't seem very clean with a boolean return type...
>
> The return type could be an enum type, but that wouldn't affect
> the caller's behavior (bailing out) anyway?
>
> No strong opinion from me on the type.

I just noticed free_pages_prepare() does have an external caller
compaction_free(), so I want to be cautious about adding new freeing
behavoir to it.

Maybe I can wrap compound_has_hwpoisoned(), free_pages_prepare(), and
free_has_hwpoisoned() into free_pages_prepare_has_hwpoisoned() and
make it private to page_alloc.c.

Let me put this together in V3. I also want to correct my previous
latency measurement. Both the compared group and baseline take less
time (2ms vs 0.066ms), but it is not ~2x but ~30x.

>
> --
> Cheers,
> Harry / Hyeonggon


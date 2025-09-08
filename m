Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403B5CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1DB8E000C; Mon,  8 Sep 2025 11:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992048E0001; Mon,  8 Sep 2025 11:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880DB8E000C; Mon,  8 Sep 2025 11:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76A998E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:33:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5131511881F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:33:19 +0000 (UTC)
X-FDA: 83866476918.21.212E0FC
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C9FC1C0017
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:33:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C615m4xg;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZVrR3an19UV8FKFFnWTfq7Zz5DZQLrwj3scgnZZSmI=;
	b=NeYfY0iUlC+pxM3FhiR2IaGYIYKjB8Lhlxiaua0xWeLlY/QEUmJPNXCxqaJkWbOSJZyGct
	c6Ylak3/CDD741DTkqUgC6oXcof6ZW1mRclir+PVZmqBxFc2Ve+A+XT03wDVtdLwSzxBBV
	pE/NNRyYG6drJ0vRfYopFQhLO4xrjik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345597; a=rsa-sha256;
	cv=none;
	b=BFxXG5p+O6goVeeqLKfxZ1YHp6UyAF8YbuchQUigY8cxlE7T7bVnKb6BS2wL8rWzZf++dd
	kxGrqjEv9B2n+e6+A5yGXaIGI63G43JipZrLUmro9ouwOsJ3AeXLGLgza99wc748ewg4jH
	dnptS6bIAdzZsNd15+7KZ6ndijeNxRc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C615m4xg;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62205eb63f9so4724178a12.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757345596; x=1757950396; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZVrR3an19UV8FKFFnWTfq7Zz5DZQLrwj3scgnZZSmI=;
        b=C615m4xgQ0KUhaMzgsUaGJjQYI1bh/DNnhOBH8SGV6R3Nuz3Y+cVvhG3zrDbZ1XFYu
         UsR2lIPGtPUvSsmVyDRgjWMjMvBzBdbqkysuNS2yaJrR/ta8914LoaCxQ+okitcnQtlW
         ndrmlmdqVzEfkXTm/rZQn530GMYv5Tv1siFqWoCw+cC6EF4PVaFD77h31x7bHWAt1sow
         C5aqaPhCh/mhYnZBJKtSQXwMBWn5YKlUZ6ooBaiR2t8mx3m5NXMpDSOxbwz3pN9ZNLxD
         zMjcij73tfEBMX+FBz52Ij5TSp9tICvLILw9arMG/LkfHw0FmGJfYG57u/BM/Ue84u+D
         LWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345596; x=1757950396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZVrR3an19UV8FKFFnWTfq7Zz5DZQLrwj3scgnZZSmI=;
        b=jWs4eAlngJ9poRczBHz5LIOl2oooG2X3KPJ1J8LNcqS7+z0jh5HTXBgQQF8LWE4nSh
         gr7xdbqvcW+0MOIoGg7W78RTdqJIKsGd3x3HGfXkg6On+NbycRYTAKuN9IFSB2NFBwrP
         QD4Z/7BQ/rQ3Cxj4PLczzrDb1/5EuXBf+hCoBysr4F6nU47G7mL/X0YasCr+YSvDGnJP
         bSCrP+uXkwaVtvXZWUQ9gOo5cBP906NB12O48geoz02bCONE+bW6BkSkIbgr/WZP3sas
         UU39dGF80YBXU8myrMf9p08DEgbJJqQuK9Z74VQeYZkcogiya1uQXE5P3s8BUZnxbkS4
         9B5g==
X-Gm-Message-State: AOJu0YzOSL6V+O2fzIhOEITRO56Js0TUfJvUJKJZWoU2gz0AyAVvbEbm
	ln540ToRV9XBo+FN38uy6kJFWn32x66jUaLo762Af04456y0vZPKtQrUR+XFjm4/hplLxiMZI1l
	ROaCeNSPAHGEcpIwBTc9ziOcCD8ADP4c=
X-Gm-Gg: ASbGnct61fCLt35Bmjz8PImQO9KH2m5dgrsEmQG9jN4YF25KdAWmeiK5E/0Z7slhk4x
	VrsyGUafM4yQKLG9nLWPBDOV/1UxSonZsjvwZAi1Mygd4k+PdBNOKAeNqssP9/6tb9PoBorA8Aj
	SHwyjF0iLrAs50slR9E2zvuUogbpiwQXNSzWCiHWRAhvPVizpDtFoEeVdn7bi3/naVDV+7OGD/R
	uuRekTLgPk=
X-Google-Smtp-Source: AGHT+IFRFi5Xqpl2pdT2FnrxwsH/ow75+LcLyLfi/+OQwqwShtSEx3U0nw6dCvXNmCJHklh+F0eyqHKuhFK+SySG/DE=
X-Received: by 2002:a05:6402:26cb:b0:627:c107:842d with SMTP id
 4fb4d7f45d1cf-627c1080d8emr4566072a12.4.1757345595382; Mon, 08 Sep 2025
 08:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-12-ryncsn@gmail.com>
 <4e0847db-0503-406b-95b4-02ee7e8f9604@redhat.com> <CAMgjq7DwOe_OJ4qyfY-2=kmaY4tfvQGaedie+6NvPPX7YD0YGA@mail.gmail.com>
In-Reply-To: <CAMgjq7DwOe_OJ4qyfY-2=kmaY4tfvQGaedie+6NvPPX7YD0YGA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 23:32:37 +0800
X-Gm-Features: AS18NWDbSr0Gkko7eoHtA8RoONl_d7BHBe6TNsfkvf1so0l3yE74J8Gr3SEqiHM
Message-ID: <CAMgjq7DWOiz85i0aQZFKgdWcBvKLZDHkOT-FCiXwiax1kbSZng@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tjm71xyrpthntqst3wuiyp1c3477aooq
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C9FC1C0017
X-Rspamd-Server: rspam10
X-HE-Tag: 1757345597-966449
X-HE-Meta: U2FsdGVkX1+B9G/PCgb89m/G2Ys53Hfs2E+20h+c3MfC6BVB1aOAw6RnprhYO8NfUu4IuqMnjuIMwNv+ZvPpeNATxPce8fwER1tShK/ML/1+XXl8X/LuKCse7g5GTke4Tk8ZrrmDgl7b5OJUaXnBVRRn52PrpsP7ZR4MEInbb+u8jZsehGCCNOiDqX5dLJshB/VpFePKXIZU3xJOVBgnar+czNiSsxoxwkLNQBohWjbfIsrWntWAyWAy1ItFtIuR3JQsXlHw0PZshNT7D/eQI0WhxQoWvot/3sFvEuhBf9+OYqWh3iKlQYYPRlcWpsUoy8e8n1UbW5w5CEXrZa2aMveZFx2uFLdRWpxt2OB3Kno/x1aASfoxhBlPcJ8CKsx/x2g2Sr0a1MctZAsko394Wyx+3O8ZAsfQ1M1tTFz6hNgRPVxRmeMtmUf9e5j8TaovseazRz+0R5o6Vazg8fOXBhCXXJqUnCk35aW99/O9mY0/2Ck05rj5i3DtFpui7JdkbHimxWVM/sp5Gt/Kk6Gv2mMZqzBFpq7QlZ2gAGgxGEkwcX58c6ccNvueB49czE7y7TxhJAlhPdJ6CR4X1aoNw3auRzX+5ELgydNrmGOgbTV8bHDe78xdwts2Oamq2sIAtTce6XcqqBN3nnVAJ5cFE0GqbGpVhnAiDagshfozLHyp8jib8MprXIOGiZInGbW+ftgPL9z+EGL1xLI8pcxZDGwzls/HwEb75ICBljnCrgReQwwHFkZecqRE8zsLNMTyQ/6+ONa79V6fchdeU858NeqJ0Ph2btY+MZnICylnAhyov3uX2vD9m+6ng1E18qvgNkxfD1cnKKvZCpFHLTY3VuQgebtEN0S4JnlaiAfgnOyJoubhuDVE9RqzfFW+6jkrspQH9yg+LEA/I06OC+AY/02fI4UXQR0KraAAyU2+9AJQmGEiieSgFnZNzWrO2izJepXmjWJ+JEL1w4xqjYg
 FPge45Mx
 aDQN260QUOEs6NXM/7XPRrZQcXBN+39EPbNWaG4uvqa1POMvcOZkmUDOEEiBmtN6SdwvZ8gmAKhaeTtQ3YMcoD0v5xeIQs2a7EuYlnRVePhBYxtFg53EeR1GBvERoq/OosJEmcMRKQwukCPWl4YYlvAlikKro1paPtytGWma6Mmz2lteuvMKefPbgi4gm20s0YCsB+gWuVF96oazRT+zrL3Elp6QSelJ/rJ4VuR0sm/mtzuyoA3/Ul0pYi6qaou1MOM9pPqa7254z/vwKySWAU3+hDLmwzZAhvWS0saeVjEHDdGaQwmOadEKLrHw4JZ4OOoC5EPUvvmoKXEKLvhR7gwESWhnkTwfHu8fTmtYGPkOe5CtF0cSVxjiibwGvUl/DsqJQR95ZK91Q96Ey/NwitXq00y2+Rbt5aAACRJdZm14zrZstumDHEei8yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 11:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Sep 8, 2025 at 11:09=E2=80=AFPM David Hildenbrand <david@redhat.c=
om> wrote:
> > > +static inline struct swap_cluster_info *swap_cluster_lock(
> > > +     struct swap_info_struct *si, pgoff_t offset, bool irq)
> > > +{
> > > +     return NULL;
> > > +}
> > > +
> > > +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> > > +             struct folio *folio)
> >
> > I would probably call that "swap_cluster_get_and_lock" or sth like that=
 ...
> >
> > > +{
> > > +     return NULL;
> > > +}
> > > +
> > > +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_i=
rq(
> > > +             struct folio *folio)
> > > +{
> >
> > ... then this would become "swap_cluster_get_and_lock_irq"
> >
> >
> > Alterantively, separate the lookup from the locking of the cluster.
> >
> > swap_cluster_from_folio() / folio_get_swap_cluster()
> > swap_cluster_lock()
> > swap_cluster_lock_irq()
> >
> > Which might look cleaner in the end.
>
> That's a very good suggestion.

Hmm, one problem here is swap_cluster_lock's args are the `si` and
`offset`. But swap_cluster_from_folio returns a pointer to the
cluster. Retrieving the offset / si pointer after having the pointer
to the cluster seems redundant and troublesome.

I think maybe swap_cluster_get_and_lock is better. (Not sure if it
looks strange to take a folio as argument).

>
> >
> > [...]
> >
> > > -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > > -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > > +struct address_space swap_space __read_mostly =3D {
> > > +     .a_ops =3D &swap_aops,
> > > +};
> > > +
> > >   static bool enable_vma_readahead __read_mostly =3D true;
> > >
> > >   #define SWAP_RA_ORDER_CEILING       5
> > > @@ -83,11 +86,21 @@ void show_swap_cache_info(void)
> > >    */
> > >   struct folio *swap_cache_get_folio(swp_entry_t entry)
> > >   {
> > > -     struct folio *folio =3D filemap_get_folio(swap_address_space(en=
try),
> > > -                                             swap_cache_index(entry)=
);
> > > -     if (IS_ERR(folio))
> > > -             return NULL;
> > > -     return folio;
> > > +
> >
> > ^ superfluous empty line.
> >
> > [...]
> >
> > >
> > > @@ -420,6 +421,34 @@ static inline unsigned int cluster_offset(struct=
 swap_info_struct *si,
> > >       return cluster_index(si, ci) * SWAPFILE_CLUSTER;
> > >   }
> > >
> > > +static int swap_table_alloc_table(struct swap_cluster_info *ci)
> >
> > swap_cluster_alloc_table ?
>
> Good idea.
>
> >
> > > +{
> > > +     WARN_ON(ci->table);
> > > +     ci->table =3D kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER,=
 GFP_KERNEL);
> > > +     if (!ci->table)
> > > +             return -ENOMEM;
> > > +     return 0;
> > > +}
> > > +
> > > +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> > > +{
> > > +     unsigned int ci_off;
> > > +     unsigned long swp_tb;
> > > +
> > > +     if (!ci->table)
> > > +             return;
> > > +
> > > +     for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> > > +             swp_tb =3D __swap_table_get(ci, ci_off);
> > > +             if (!swp_tb_is_null(swp_tb))
> > > +                     pr_err_once("swap: unclean swap space on swapof=
f: 0x%lx",
> > > +                                 swp_tb);
> > > +     }
> > > +
> > > +     kfree(ci->table);
> > > +     ci->table =3D NULL;
> > > +}
> > > +
> > >   static void move_cluster(struct swap_info_struct *si,
> > >                        struct swap_cluster_info *ci, struct list_head=
 *list,
> > >                        enum swap_cluster_flags new_flags)
> > > @@ -702,6 +731,26 @@ static bool cluster_scan_range(struct swap_info_=
struct *si,
> > >       return true;
> > >   }
> > >
> > > +/*
> > > + * Currently, the swap table is not used for count tracking, just
> > > + * do a sanity check here to ensure nothing leaked, so the swap
> > > + * table should be empty upon freeing.
> > > + */
> > > +static void cluster_table_check(struct swap_cluster_info *ci,
> > > +                             unsigned int start, unsigned int nr)
> >
> > "swap_cluster_assert_table_empty()"
> >
> > or sth like that that makes it clearer what you are checking for.
>
> Agree.
>
> >
> > --
> > Cheers
> >
>
> Thanks!


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE6A9CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053C36B0006; Tue,  2 Sep 2025 19:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BA36B0007; Tue,  2 Sep 2025 19:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA9E6B000D; Tue,  2 Sep 2025 19:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D98666B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:44:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85C47119E4F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:44:29 +0000 (UTC)
X-FDA: 83845941858.25.54D47CF
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id AEF9F20004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:44:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fi4rWan8;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756856667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4gypALbh/DCtbuR4Owfnzd4p8s7lS4q6xKY8wUJafA=;
	b=DOC8wr4LcJjrHaVV4Qi2CyyTaUfCp1ZE9RgrD8VVVwGV2Y/j4ZXTcc9fYrk6kyxfxaXzpP
	kjBwtEOnx1PvmXfoQ7lZlR9MYGaR+JPjZaoAGyILa/j5dTJWCbU38ODOezhPZQNo/usT87
	lJILih45enWYo8ymSpEGCYghbE9Nd2U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fi4rWan8;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756856667; a=rsa-sha256;
	cv=none;
	b=HL9KhsldTv9Gx6Heq5emE3zRaNLZL2PYkPISBsZm9lHsaKy0+p6S7MCTtHXltn5PTQPVqN
	0t77tGZuYGkh5tWNi3ghKbvBwuFnjI2wli6c2dacr8xTUpWUYvWapToeYUV4IRVAG5AcHG
	uYWnKk2BwbBdZ6KfYNVAudo2zWr+SiM=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e8704da966so373489785a.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 16:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756856667; x=1757461467; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m4gypALbh/DCtbuR4Owfnzd4p8s7lS4q6xKY8wUJafA=;
        b=fi4rWan8EflBzyeALqQ3us0S1EW5CnvX46v5cclcj+ft1SXa1xJNO4+CoEKIf92Ciw
         4/svmCAnifznZuREKYeklIIHVJpnLlpxfVKETd2xteiXa16padzBpaQsjDxb7hp+yYPl
         SULlOPoFadYZtPGeTOH0wqBoxwFq0tCvMBPpd8Pdd2cRU4rNQ/6d/nuQPMLjSngSE+qi
         cjMavODoerwhyjEQBGaNVMeFc6dkx4VCmg+27QtsKFeGxosYP+rxMubaRGJ+qLFkZDwP
         KveLSsRhDd4cxnkSaIxkaSIg5+4lb1KOUhjn7aHUcLd3O8hVLFpsoTn9agQ2zuwGYiAc
         uDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756856667; x=1757461467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m4gypALbh/DCtbuR4Owfnzd4p8s7lS4q6xKY8wUJafA=;
        b=h4Rgj5lI/AqmJ8Xhyf/2N9rLuSZnSFnWRKOgvdEQtdrdAyGlSE3gU0MHxf4lNa6ywK
         H8M0b27n4onhkv8sJd/jLd3Bi2SKIsW/9pc3Bla6ScbNWG+evzWFra2Xv6n4dPB2bdKJ
         ig5NOOAYa8bTo3hfVk6ESt1+KTFzN5CluFvzwo9Mw/CQR2S4oKyM0T6aNoZ0Ogjrr/Ns
         3Qg0N3wOrsTexnzcEWO+LsqZfdjVODDCoEXtaT1fEAIbloWYAhbVKvDSYPYz4JEqPQ4C
         DWojoZSAdOEJj+NTn5xSNSKrfD5S2hGClF+fkMbtnOszud454nRa6OADkz6fM9gDa4xJ
         yJ6g==
X-Gm-Message-State: AOJu0Yxv3Da+pz9qlUdmOcxb7JjMirhAGUJgRX+hfdWuZlIdnxyvg+c8
	DDI3VGzCG7ZtOoV8a0FbBny2kqp/q0JeWAuiXdMZ5AHt3Zubxdh1Mn8xVlFScrWxk3Be7iXkYDX
	fiXRG0puXT3JOo2b+RtaUppbM5lnvlBY=
X-Gm-Gg: ASbGncsaN+mvUAMUR675p72GMRhxTjOWjW6e/q+poT6tjb71gUU+vBkglIPJRqCpUS4
	505m3igu6TtAouqMztcP/bSbrCqvAOHUanbPvRX7aX2RwInxUfQGalnpOQHXhUTlURYJXat9U9n
	3WuA0nNj+6BLntmw7y/t6P8sps85Xd8SzlTaMOU7yG85Pe78Q0/QqoHJH0u9vjjReg4/rBBRTLp
	RCKjT8+NNy0PIZ+cQ==
X-Google-Smtp-Source: AGHT+IFsE+UUzTBnEhjz0fAD1lCkgGhafZx1Kl233Yf1560jOjMGEvqXgAj1E/rPotR+43710igd/8m1XiVQMmqan2M=
X-Received: by 2002:a05:620a:1a8b:b0:7f8:c51d:f42e with SMTP id
 af79cd13be357-7ff21df26a3mr1479006785a.0.1756856666709; Tue, 02 Sep 2025
 16:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CAGsJ_4yRa65ogB0d90LmtOigGTqQ9mM-eUU6VbmcX63j6vgHEg@mail.gmail.com> <CAMgjq7A5Gr2V9TDFg=_S+SjZ1r1gWXTtRGNofuzAgWNYLMW_DQ@mail.gmail.com>
In-Reply-To: <CAMgjq7A5Gr2V9TDFg=_S+SjZ1r1gWXTtRGNofuzAgWNYLMW_DQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 3 Sep 2025 11:44:15 +1200
X-Gm-Features: Ac12FXzzAbYcUk6ci8hyrQxV1ebiNF8fm7FKUh9xIW9YZAjH0WxMp39hD7KyfgY
Message-ID: <CAGsJ_4w7iV0YU+sXdYPrzqXAdaLncoP7bnGx8ELcpETL6y+cOQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AEF9F20004
X-Rspam-User: 
X-Stat-Signature: imwb7suzc5zrmri8gg8138zqnqxd6grk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756856667-463516
X-HE-Meta: U2FsdGVkX1/SwwGf/q0j0NB1brvjqSZqrK9k7pmGFtGG94PRV6ZXN392vJMIewr89YbZJY0mLNhn5EDYT6CJbA57PVonhIgTjrtnEgLD284tU5fhkm8tl1h0FSKjkgb/maybzXyWrXPdG7BluHXKmMqdE9Fh3r3XzMA8T8Aed93v5XFbxsYU56/0gy0m/PRRmKCmjE4+pBsoXXx0U/noou+yWnL57Jfg1i43iOy2MUI2wPEN2YgKKjr+EhYgIjGcwWD2lQ650LlJvLzBJf8ptOJ0yHIMU81oZlfbHCEhmH/e79LxGnwgmxXmP8al/J5yRDavsc/ALMOVyOKtmMtOAkcf2LGpU5YUOm2kd+rBlUJ6bQZZ84gGydhL9J5gYySv6pa2ysfgwWonXzbsyP/91cW8Ite5t2WJK4UnL5dlSYWkUJk+5ReBB3kBlxehlQNVe2+6QqBPEKGqKSsyYhTp3k0BEn4Vgrr/k9c1P6TzmFrOHbLjWd42K/VcnJDanf/O8oDDtT6bEQ2kiCtJi5ge48GmMl9ivUgiH9wrWn8OLYHKFGgaNASerkQKob6tj3Oj0EwXU4bWH7iwA9cjxJscifkrC13zw32KYDXCkH2bvmsxMdBaDpZMYEzb84dIP6Oh1hGsMlxBPp1xZDFzmA76Ggp45YskabxkPNE0Ps4JykLLa9mv49s5CE0bILxWHZHVJzvNNKAOrT5cyk7jVbXZyjRqJXV5MLMjpswgQTyR8yHQ0k/UmCkCpzK1H5iSHe4KGXQn79+yMk+ZSEWqAFAA1l7AEqKWzx81Ju3srsWlZP7tAuBitZviQ0c3uUmiPMVGdsqXz+kBA69H4sWkqDKZDSMI74YAT/lB1G6fwHxBvFLyeY8B9aR7pACpT1lEkcWK59iwpd+7H8fX8Pn5Dvcc/qi9x5CUY6hEp1DicMrnPlGUrb9EglhQDpm1oLVEX41DlCTISxtoBPn3NejPqkb
 ue3L+zKX
 Vbc3QbOJvf0hP4ZcUIHovrGOUiZXKzh7V+vt8RSkyYx5szfaq49GaH9NNd/SqOotBQUgk2GnR/Nl4vCU0IERmkiiCD9jGjcaxn1MSLAj+XshT4HjJF2I3eTmFF5QjHDc5c2xshY+TatdzK06eLayPAcJvLoOIp1bvH6ZaCWqGQGrFbiV1Fm7fRsych85Os1VvwRVjpTqYQyVogaUvR8fwjB5+wNpfjN7h3EK+MSacpPHWPNmNfxPq32yRtwSLg/8aUrUwEaMwa0rSQT6nZcoQ3urlf/GxFYcycc+HhcCuG217RBc7AFQrHP4VX8c6hs+/JA1ZJHE/2X6QFt0rh1pdst7krCBqjuMVNINy0wNrhpKNS11V6wuFOcU8bOZxFGL8uQ41v6DlYfOWKoCZZQEgWvUJ9nLbsoNOYJ/e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Sep 2, 2025 at 6:46=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > > +
> > > +/*
> > > + * Helpers for accessing or modifying the swap table of a cluster,
> > > + * the swap cluster must be locked.
> > > + */
> > > +static inline void __swap_table_set(struct swap_cluster_info *ci,
> > > +                                   unsigned int off, unsigned long s=
wp_tb)
> > > +{
> > > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > +       atomic_long_set(&ci->table[off], swp_tb);
> > > +}
> > > +
> > > +static inline unsigned long __swap_table_get(struct swap_cluster_inf=
o *ci,
> > > +                                            unsigned int off)
> > > +{
> > > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > +       return atomic_long_read(&ci->table[off]);
> > > +}
> > > +
> >
> > Why should this use atomic_long instead of just WRITE_ONCE and
> > READ_ONCE?
>
> Hi Barry,
>
> That's a very good question. There are multiple reasons: I wanted to
> wrap all access to the swap table to ensure there is no non-atomic
> access, since it's almost always wrong to read a folio or shadow value
> non-atomically from it. And users should never access swap tables
> directly without the wrapper helpers. And in another reply, as Chris
> suggested, we can use atomic operations to catch potential issues
> easily too.

I still find it odd that for writing we have the si_cluster lock,
but for reading a long, atomic operations don=E2=80=99t seem to provide
valid protection against anything. For example, you=E2=80=99re still
checking folio_lock and folio_test_swapcache() in such cases.


>
> And most importantly, later phases can make use of things like
> atomic_cmpxchg as a fast path to update the swap count of a swap
> entry. That's a bit hard to explain for now, short summary is the swap
> table will be using a single atomic for both count and folio tracking,
> and we'll clean up the folio workflow with swap, so it should be
> possible to get an final consistency of swap count by simply locking
> the folio, and doing atomic_cmpxchg on swap table with folio locked
> will be safe.

I=E2=80=99m still missing this part: if the long stores a folio pointer,
how could it further save the swap_count?

>
> For now using atomic doesn't bring any overhead or complexity, only
> make it easier to implement other code. So I think it should be good.

I guess it depends on the architecture. On some arches, it might
require irq_disable plus a spinlock.

Thanks
Barry


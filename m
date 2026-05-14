Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66462CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A7C6B0088; Thu, 14 May 2026 02:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CAC6B008A; Thu, 14 May 2026 02:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A016B008C; Thu, 14 May 2026 02:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 625576B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 041AD1C0EE2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:42:08 +0000 (UTC)
X-FDA: 84765080778.24.9BEF956
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id D6BE020005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:42:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SYLLshWp;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778740927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnqF4f836w1iRFlgDP3Byk//1F+uE+yaxhPK4VwjX9U=;
	b=zchmvF5w7FriHZSfxsbwlJnWbT3jGifNWRQ0G8fzh0PLQdJ5m6dOOicRIwMl7uM4173U6r
	/Y7L0EeLyGUnDHRFD75a6hnHu9Kqt3qt83eKLPaPBzq8QM47+uGJcLlWkOOIsS5A8De0Y9
	rKpnA1EnHM5FNNg1m2lDQK0Bt4bDkeY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SYLLshWp;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778740927; a=rsa-sha256;
	cv=pass;
	b=VDdKZLFg78pBtERyaqocmdF0DA6S+jvevh+PCLN1w2/KEeNwlQh7KZOBChkIUKM41G4UWj
	ZA/gg1j7hNlU2Eka/LOIghMzomTMjdh8Z7lyk9CB2MUYr9IHdXXxhRFRVzBkc94WUTtSBu
	q7GM16N2w4aqUwSFHrr/xIcM3rOXySs=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso11148760a12.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 23:42:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778740925; cv=none;
        d=google.com; s=arc-20240605;
        b=jl2PgHBmmn3wpUK6fTvgFv2JfCQ1buubyr7ib1ZKz77YaYX8Eub3R1IhZm1v3a6Jpl
         +MdO5eCSOorpPcbNd2ls1G/aM229kPQrGTLi+zP5eXSyPG7qxJbLvQQMbJmxJL5+P+E4
         QyO8rxFyh6BIEwnXWsfrYNhPOQJpdh4QaIJf4ZB5xiFZXAEkS5JpMgirPtkrbuWLMYaE
         v2sAegaAiR71SvTh8smqpIdnQ7jQVnFkuBH8CwkbQB6YWI0hWS8qwfs9dznnjmWmkziE
         wfxLsjCjslT23y//dUr/XY3N1A8/UGI0+dlFUI7uc+c2yXywBwJT/gR9fHqgNfdKgdZR
         q9gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nnqF4f836w1iRFlgDP3Byk//1F+uE+yaxhPK4VwjX9U=;
        fh=wtYRkXwhuUYih6j8Crb+Oir25Y5zdXng6A3p5RFNE2Q=;
        b=TlU8yOj00UlM1yCGSqUPuC5w+R/zz+9BDhhW8Lgt3YgQqP02y8ujAnnZv4DrMfjc/0
         ujqzAhQh9cpKT7DzMmfaake6TPvO1eQ+3BwH6THHh6IjYL6y95aG6jtT3bHatw6TNfPB
         iulT3pBaCLAlYWHWeMGBx+HcMSwV9lblSDibM0yB1NlfwpoKbhB7b8EhM7mw9dBo4YAt
         6k0UC0RsDa4GLARZagOwFNGjCaDvw16RYuiTZ7XlyxJY9m4+ANItiN0HuTibOChdre09
         TLQP42t4LuUeey95LhH0K1F3REBkLQhtWQ7d8++fS7FvT5BGhoUAtYRCInKv+LURCozd
         D6jA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778740925; x=1779345725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnqF4f836w1iRFlgDP3Byk//1F+uE+yaxhPK4VwjX9U=;
        b=SYLLshWpyQ9D5IFmvkuCt1T+rb/ji49PcqtaYePJnT/rGNiS7qncyTZZs8XnlUpx3L
         aDPERCDPLgDC7e1tJ9zGoQx7Y3KAlS+0nUBZN5I5sZ1KoNRZlSTC+s0pwVG24P2ILeH5
         h6RGuFWp+ucQ2zW1/zH9Xl9Og4kYZoIk/kBvqannTJvnkK3WdlEfns/QQjMupvq0G7vs
         lFY9DTxA+Mm+owr3qmV0/L7nyj0QpfUp1iJDr8zZrC4Gx4Bmk9VLUfiAXkJsYFiLiGR7
         ZYYzwSa+RhijrnifKX2Qiax+ItdkGQsOQHEBmZYy0uzVWxARJM2JlNYEX8rrlGCSlknl
         15uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778740925; x=1779345725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nnqF4f836w1iRFlgDP3Byk//1F+uE+yaxhPK4VwjX9U=;
        b=VzVKEBzKBi+mqQvEUO8Jl7eMb6LmV2P9ZKtyZJQIfZ+Lc09Cfi2ReAx5+kE4UA+ZX3
         Cdb+XQd0he69g0lSLxO3KvGh+GgWM+hjBsNB1a5RKFMCEQV5svduii7ScS1O/KdwJEV9
         9x/4bczfRbztAR4iVFyGJj+qDTM1ulkdFCS2kWKpPnrPd0y7q6wncdUQ216EdxZ9QSQr
         DL4qSchJBBqPiBQ4GTbQg27kFG1uzwJDZE3oOmgj4CP/jpChaP5rGKpqQrcOv1NXacr6
         w6Fzwq1dMif9xDHYh9oQ04pIxNEFnDxi+RFjZFtKTNGXBBcdVdzAEOklGcvK4O7yTYWP
         9OkA==
X-Gm-Message-State: AOJu0YxWDNM00GG4mEWo/kvngvPfGXRvsBkIjpq6zYoFZyPOE9TjEoYs
	aCoT4HUg9YM43Eny5VIB2zSRjli1oaHlOal6/hZ7mEOERBAI7zeY0iAXVTRO+ux6ndnbU9Czi71
	0omUrWmZKyZxJwfk4OaTNar7JBxkLWQI=
X-Gm-Gg: Acq92OHQQHuYWdzlT0ZPasdCUd+HeUqnsvc6nkZs/yA8c1ydjOHBX/fE9ESqVNKDrd3
	tOt9gbGEk62f6J8x5j8RQQQ2ZdetyK9tVnwTOCYYtfyryzSkRI+MVAl6jTQOijUybltSDIaNbKS
	XoqujRRlVKSeXTgWKrKEJ3+6po5sC2B+Ccl8emLyOpfKxFDutm/iHEXdpSAVNRJvVrfI5HUjWXq
	3w/TWGGemTk3p58cCfoBRSAYBMPDJ5IwoW/kccDc8SjnpnXRZEuLarLBhMRUssBCuLjihJJLxxI
	KPw9LFZuYbOHwpA/2ljn3WpdPukh4eduANyNAt6F
X-Received: by 2002:a17:907:97d2:b0:b9d:1673:9994 with SMTP id
 a640c23a62f3a-bd3c1b3d411mr450085266b.39.1778740924976; Wed, 13 May 2026
 23:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-3-baoquan.he@linux.dev>
 <CAMgjq7Ap=hEmHg+5Da=NdOQS1JK1FY+WepmW=3HEC4XHfsUmuw@mail.gmail.com> <agUuEizORebR3A0O@MiWiFi-R3L-srv>
In-Reply-To: <agUuEizORebR3A0O@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 14 May 2026 14:41:27 +0800
X-Gm-Features: AVHnY4LLmo8I93QdQB-HNBeGynW_E6fyviszlireFKH5G6Z3IgYPD6gCugQXjVc
Message-ID: <CAMgjq7BsajR=cBqZWyMovjAWgV9-WDq-ubzXUHO1Puvug6n9=g@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, baohua@kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6BE020005
X-Stat-Signature: 47dwgtqhaxyycc411gspni59p316mn6j
X-HE-Tag: 1778740926-907812
X-HE-Meta: U2FsdGVkX18QykxZhliHaFriJq+4wVxB5UyU8xt+MRslph2aoheNYKuQKQHMmsvUvcX2rtdhNlD7zYgoFWMsnhyhD3I8QULNzF4ccaSeup/2kjyKsrsA65ASYaNpC8JwJStAP+H43Q0e9CGOzRQQ9hD5Y3HAEUwYy3jjzHyti5AqwHHfwBbhFsw2JIMgmdzlxXc1o17t9/YGZSqfQklMH/u2hWoJuSrc8Y+M/p82+IlG5S3m6LH5GtEQ6rgPXqJU04Ao8V76V48c4abdjwANCBKUFABzyppLr8pcwY242XtNJ1qtSXf2U8BHKfHJQy+SCb9W9WZIdeiKitRIBjOeR5xYOJC+BlWMQN4OPJOSULyjM4vG9LhPTfV2ywDDKcZXJokOHd5RYuvTdgE45CfcX1cRsTsI+0z9oPDzfmuXO0VK2v1WkZaJmCjzxnnIXVLfGhPjGa43RufGIvVjlOVh25pQoMLp/5SlAeDw7gZUN67GBf0wxrq0jvs7sSuwfqD0hv703PjD17cu73oL81CeFiF+MjQxl152x85O8Do+I1oOv94Sl2USUL0YKeqYREQADyWBolgPW9piddAqm/YPNNQXh2ky+eD04C5n8Vtx/EKtmY7lvC4Cg7pKTZFaedbw0nmPHYliIom61GgQpPZ1bcjFJYv5bchHtC1dFkwbIcaQvuUojDXeNV3KPeOXT+zvkqffq1aSIyhdRIsu96ZaRC1r1C/62J9dwhDwDxqgLT7luEHGGF6Xz6CEKjhag3TubViJ0k84lS1U65DNlqTLXAn1vcPaslz8vY/h/UWoNuKY6mM6L4Mslff/cIPxvwbMAqccyHYJqvRaPmmHhQeoGU50BWfMtZFKu6jgLtLve7oCpzU7yCdCp+ca1vhkCC4GBdUQlPMP462eFEDRQb/sJ+74ahBGv90UH9Z7+QnCpfV5VIvpW2oxk2POAQtzFC/FasHxPcGIt62vpTO8mLO
 cn9LGtBk
 NAX2P4M/XzE0oGTA2Nmiqh+VPuhwsWxua0PsW4VhiktCzQNMYwXK86UFvIs0pwNw4TduJ7Tkuj+kWsbG8WsiWHDFm9uIXoyiolQJOopG0yALVJ3Knm2EJdsfUYoYmIHy3uxVg6ObFIVqkL4NvXFPoFQq1921X9UbpuPPnaU6DMzwsK294jxFQccaff770LhWHCLitmQ6iUpAzkLgBo0xLQBlbKcUZjBYdlwNGe2BPLIET/vYm3RsYT+DKIz2hd6f2HAb9E3SgHlk9tbNsyGfvd2KdEtgq+7ZS22fWyTFcpOs2JIGi7sDd/GcvF4IKKW30a/X9GfGDDj1w1WWGHw8v2zMxhr12UighvSx962CKRSEJuxeNtEuWciwfranHh4PrnG9y8A94Hsqqb3syq8rV0kvFHHTSH00vREF7+X7TbMq8E1Amvp/OQ3jmiK/N9qzQziVCR8KND5r/eK0w1wGmRwQsxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:06=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 05/13/26 at 01:53am, Kairui Song wrote:
> > On Tue, May 12, 2026 at 6:50=E2=80=AFPM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > This simplifies codes and makes logic clearer. And also makes later a=
ny
> > > new swap device type being added easier to handle.
> > >
> > > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > > and bdev_async, and only operations read_folio and write_folio are
> > > included. In the future, there could be more swap device types added
> > > and more appropriate opeations adapted into swap_ops.
> >
> > opeations -> operations
>
> Will fix, thanks.
>
> >
> > >
> > > Suggested-by: Chris Li <chrisl@kernel.org>
> > > Acked-by: Chris Li <chrisl@kernel.org>
> > > Co-developed-by: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> >
> > A few nitpicks below:
> >
> > > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_p=
lug)
> > > -{
> > > -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->=
swap);
> > > -
> > > -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> >
> > This sanify check is dropped and not added back in anywhere. This is
> > fine, but it might be better to have a similar VM_WARN_ON_FOLIO in
> > swap_writeout?
>
> Good catch. In the old code, it's called by both swap_writeout() and
> zswap_writeback_entry(). In zswap_writeback_entry(), the folio is
> allocated in-place, we don't need to worry about it now. I am fine to
> add it back in swap_writeout() because adding it inside all three
> swap_write_xxx() is a little too much.
>
> Cscope tag: __swap_writepage
>    #   line  filename / context / line
>    1    288  /home/bhe/code/linux/mm/page_io.c <<swap_writeout>>
>              __swap_writepage(folio, swap_plug);
>    2   1053  /home/bhe/code/linux/mm/zswap.c <<zswap_writeback_entry>>
>              __swap_writepage(folio, NULL);
>
> >
> > >  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> > >  {
> > >         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->=
swap);
> > > @@ -642,13 +664,7 @@ void swap_read_folio(struct folio *folio, struct=
 swap_iocb **plug)
> > >         /* We have to read from slower devices. Increase zswap protec=
tion. */
> > >         zswap_folio_swapin(folio);
> > >
> > > -       if (data_race(sis->flags & SWP_FS_OPS)) {
> > > -               swap_read_folio_fs(folio, plug);
> > > -       } else if (synchronous) {
> > > -               swap_read_folio_bdev_sync(folio, sis);
> > > -       } else {
> > > -               swap_read_folio_bdev_async(folio, sis);
> > > -       }
> > > +       sis->ops->read_folio(sis, folio, plug);
> > >
> > >  finish:
> > >         if (workingset) {
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 4840fd40f36f..8c42632e6765 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -3780,6 +3780,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, s=
pecialfile, int, swap_flags)
> > >                 goto free_swap_zswap;
> > >         }
> > >
> > > +       /*
> > > +        * init_swap_ops() sets si->ops based on flags. It does not n=
eed
> > > +        * swapon_mutex, and must complete before enable_swap_info()
> > > +        * exposes the device.
> > > +        */
> > > +       error =3D init_swap_ops(si);
> > > +       if (error)
> > > +               goto bad_swap_unlock_inode;
> >
> > I checked the comment above previously and it looked good. But the
> > error label seems not that correct after double check. inode->i_flags
> > will keep the S_SWAPFILE flag. Maybe something like add a
> > inode->i_flags &=3D ~S_SWAPFILE here and goto free_swap_zswap. Sorry I
> > didn't check this part carefully last time.
>
> Right. How about moving it zswap_swapon() because it only relies on
> si->flags setting currently?

You mean before zswap_swapon()? Then that sounds good to me.


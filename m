Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7770EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A986B0005; Mon,  2 Mar 2026 14:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B026B0088; Mon,  2 Mar 2026 14:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D336B0089; Mon,  2 Mar 2026 14:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD27E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:28:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E7831B73ED
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:28:39 +0000 (UTC)
X-FDA: 84502109958.22.56C5D6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6202C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:28:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TEoYUqEI;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772479717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in1GUs5hLtcwLUkyI1j9HOgHJ+rW1x01B6f7HGhDnFA=;
	b=SHFFj7/Q6a/rVOA60Fmt6FUpQpzArCSizBgzwtsO/mYnfnVLdV7iiywsGZlFC8YFQiE0U+
	lWLX6x0EB0KXYAf3oaV6nmS4msRJkf3OE6peFOmDz0HpKZPGhsPMAX6EKxSSb2HkBiA6pB
	mRtBRqqD/jlfZ9Kpg45amTbL5I0Va3M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TEoYUqEI;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772479717; a=rsa-sha256;
	cv=none;
	b=U96UV2nfS5+fB2Oc9rhLQq1fwLsZBzAl3kiflJDwyZqun0qeEMnZAbMkRvqxHStC1iPhCG
	W2eAzYC1PnOgb2yFTIC+2U5jg9ihHQmFJNrbGi+PnwT6ywzwwSPpHTHT0PYRS4R/qxdtQT
	Y5X6B+EoeDP0Q8SakiHobBaaT+6Cl4Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB47960018
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E325C2BC9E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772479716;
	bh=0yANM4TjUmLoPYRRwljmLH64WJZjU2FC86wBfFh4lBA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TEoYUqEI/R5HXAbafMUrcQ49ou4vhcSWwrhUyS/eR0NScKCmN3ii2HWtsqKnEAZbx
	 eIwzKE2shbNO/qnuarVA59a15J+rsWf/UGuBFASVo4kgvi//0JlE5cCJGqDjChe91W
	 c8H4kX6fw8egHSMIp9BDZv7oFarzJaYjHRmcxyXH6RDC7mLoHr9N4ACkA+/luQq9Wr
	 4+EXrXLpM5hEhL1uAuiX8dhz5y1L8RhY/fFQez3z+VzExwsg4xUMqMjxCK5RKZ+1p6
	 k/iCI4EwIfVu9wf7WUJLZby0ynFA+B6jmEm4A61iu4eBDF4ghP3q07/e5ZmCRXFK+N
	 WXEqOj4+Fq9pg==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64cb577e79cso4870530d50.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:28:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUuw8XESxYTKqyIlw0hjxu7d9bt5Zz1U5tUxUF10+CRoRa8JJC/cL3ojsrU6wCCYh77VblmxWpCtg==@kvack.org
X-Gm-Message-State: AOJu0Yx9mG/7dc31cA3oQGc0Mcuw3egQVBlARxlexPJ+P3diSFA3S9Oc
	zdlkeaDvoMxR7jg+N5+u8/VFGpU5ZCnaY6NQkbZih89ZABRinRO4p5SA3whZemjn7wVlRTqrFwz
	8jnJSbGtM6bfsTGy39RbITPRNwUV7Ir6FXM2ig2+1Kg==
X-Received: by 2002:a53:b3cd:0:b0:64c:21c4:d017 with SMTP id
 956f58d0204a3-64cc23040bdmr9314842d50.78.1772479715374; Mon, 02 Mar 2026
 11:28:35 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-3-bhe@redhat.com>
 <CAGsJ_4z-TB3qZ1t0H1EgB8ir-eut9oLeFMP+tn2oM3PVco2h+Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4z-TB3qZ1t0H1EgB8ir-eut9oLeFMP+tn2oM3PVco2h+Q@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 2 Mar 2026 11:28:23 -0800
X-Gmail-Original-Message-ID: <CACePvbWVdfG_dBY1FTnMshNkyMSbU1WxX74VhENcVNXB9CFQXg@mail.gmail.com>
X-Gm-Features: AaiRm51lfNRcre3Mdfa4OobWLHK7wEKis3LrzqsFyd5yGzJPbxT6_VFoRdvgz-c
Message-ID: <CACePvbWVdfG_dBY1FTnMshNkyMSbU1WxX74VhENcVNXB9CFQXg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's methods
To: Barry Song <21cnbao@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6202C0005
X-Stat-Signature: m3ik8mpptnpwy43ty6ej9dhg6qzkt1dj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772479717-524355
X-HE-Meta: U2FsdGVkX19MsK9gMByK/6N8ZyNSJBjcxRFbiPQ6R/llsWjyVq/Cxzxf+6ME/Ow7f0HI82pWsOjiq/02Mkfww/HT7CYh7ptZYrN6eerUKgCmDTxezTFjXhP7htsp3broluGbomiPlhc/RovAEHPN0Hf6E2DwshkIYpkESM3pvvWDwNsIdVhtYGcfcqT56f5hCL/PJCjqP5yOZzIJCBN9rA08bjV0ZCuYXDspOWlXMqoCfqC0HXc9LbcizunLsx/DsqpP1Dbyxu7/WNQBN02f4teVzcjasMgaYqAmcsRN+np6Fw/9xHLg2rc2enOWZKT7a1FSwrfSadSG4n3J2+t7YPBQNAf2QIKXLUKNjZKVfZBezxTWMZSBKoVFGuIspeZWfy2XcaIVS6zIvDz3fMNLCDn9Fwsdx2uusrnsctLBwMIUBJ6sdtsk2zUbdii3O2EJsDMwt9wBVuz/HpQQ5ahTDtjFYC/7NoZm1krQ0C2Y3Hbrx5TfosX6lUDXAmWAJhdwGs2fD/rj5Bp2t3nqReiIWNJw1+f3BC1wjZJ+irFPaex3YFmxEarj/1YpR08RYeTyffmmIsgRL0adU40/pOCxam+hdK977WND87uXCRBRWFClZUkTNQNH0WXP/cX3evEEeu+Yn3H+qzRg7TE0CHeLMOx8z+KqyjijX15kOZWuSQGdK+EebftzfS2h5jPpdbccP2RMzCXPLw5go8iDIqZkVNG0hUDpe4F4FYNiohTpCNBUTow1vsQfaITQIxohg+BDeI7qc+4d62eIolp4iLB8yZaaW6hcc5X99jmIGwDYDIyGUqPzN/Fgq9k3Pk+crEKpN54/CEgdFdx0z9wRhROiX7m3eMXxlFn6BzWwlNnIigkPzwZDc1KQn/1JmnhsVaI9KiaRcgJRAU3cuJ70v9XHyrl7f0WkQMr5J1gLW6oJokgn+WMzY/BpXeZROC0faZV9YT0Fl1342RwV56G2zGv
 D8rUUu6F
 zdV7aObonqXwYNjLLGH0RbOObhdaybKMBpUJmO7Z5B8PYwekF5alMgDhwtm50h76NAR3p7kvalPdW2gBMn2IkmwMhsVXTrqJXATXUgpgh+uIH+lA3PINqNyGrlVZVoHJSQ9ZY0jVaKorKTo8IP4ZhAa1hsecljJ/ZRZfldGaj6noQJXMN0nvRjnLKGJKCcg6dpi42HFuTPuYBj+W93eWm63PEEYfT4rIaX9vSj0GvdC8okvXQwhFiehGuXjCmblxpc7929P+pWtLLBCdWycZNHDq53+S5anPspwU6Gv8p1yAvqGNqwdfNVDpUVnoDHZvwTtHochbWi94121bdBSoXT25gXgnjzpeIPly6x4dlY+Hwvbui1UvhVbr1XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:11=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 6:40=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
> >
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> >
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>

Thanks for sending this series out for discussion.


> > ---
> >  include/linux/swap.h |  13 ++++++
> >  mm/swap.h            |   1 -
> >  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
> >  mm/swapfile.c        |   2 +
> >  mm/zswap.c           |   3 +-
> >  5 files changed, 76 insertions(+), 45 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0effe3cc50f5..448e5e66ec5c 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -19,6 +19,7 @@
> >  struct notifier_block;
> >
> >  struct bio;
> > +struct swap_iocb;
> >
> >  struct pagevec;
> >
> > @@ -222,6 +223,17 @@ enum {
> >  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
> >  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
> >
> > +struct swap_ops {
> > +       void (*read_folio)(struct swap_info_struct *sis,
> > +                          struct folio *folio,
> > +                          struct swap_iocb **plug);
> > +       void (*write_folio)(struct swap_info_struct *sis,
> > +                           struct folio *folio,
> > +                           struct swap_iocb **plug);
> > +};
> > +
> > +int probe_swap_fs(struct swap_info_struct *sis);
>
> Does probe_swap_fs sound a bit odd?
> What about init_swap_ops? Not sure if we have a better name.

We can also call probe_swap_header(), which effectively detects which
implementation of the swap device operations the header requesting.

> Do we really want it, along with swap_ops, to live in
> include/linux/swap.h? Could it be placed in mm/swap.h instead?

That is a good point.  The mm/swap.h is likely better (if possible)
for the swap_ops related declaration because all those ops are
internal swap behavior. We can move out later if there is a reason.

>
> > +
> >  /*
> >   * The first page in the swap file is the swap header, which is always=
 marked
> >   * bad to prevent it from being allocated as an entry. This also preve=
nts the
> > @@ -284,6 +296,7 @@ struct swap_info_struct {
> >         struct work_struct reclaim_work; /* reclaim worker */
> >         struct list_head discard_clusters; /* discard clusters list */
> >         struct plist_node avail_list;   /* entry in swap_avail_head */
> > +       struct swap_ops *ops;
> >  };
> >
> >  static inline swp_entry_t page_swap_entry(struct page *page)
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 161185057993..c390df3f5889 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -226,7 +226,6 @@ static inline void swap_read_unplug(struct swap_ioc=
b *plug)
> >  }
> >  void swap_write_unplug(struct swap_iocb *sio);
> >  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plu=
g);
> >
> >  /* linux/mm/swap_state.c */
> >  extern struct address_space swap_space __read_mostly;
> > diff --git a/mm/swap_io.c b/mm/swap_io.c
> > index d1cdb10ba133..47077b345ae3 100644
> > --- a/mm/swap_io.c
> > +++ b/mm/swap_io.c
> > @@ -240,6 +240,7 @@ static void swap_zeromap_folio_clear(struct folio *=
folio)
> >  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> >  {
> >         int ret =3D 0;
> > +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->sw=
ap);
> >
> >         if (folio_free_swap(folio))
> >                 goto out_unlock;
> > @@ -281,7 +282,8 @@ int swap_writeout(struct folio *folio, struct swap_=
iocb **swap_plug)
> >                 return AOP_WRITEPAGE_ACTIVATE;
> >         }
> >
> > -       __swap_writepage(folio, swap_plug);
> > +       if (sis->ops && sis->ops->write_folio)
> > +               sis->ops->write_folio(sis, folio, swap_plug);
>
> Do we want a swap_write_folio() wrapper?

I vote that it is better to keep these two lines as they are. No
wrapper is needed. Is that wrapper used in only two places? Also we
have too many swap_write_page/folio-like functions. Adding one doesn't
provide enough value, it is likely causing more energy to distingish
with the other similar functions.

> >         return 0;
> >  out_unlock:
> >         folio_unlock(folio);
> > @@ -371,10 +373,11 @@ static void sio_write_complete(struct kiocb *iocb=
, long ret)
> >         mempool_free(sio, sio_pool);
> >  }
> >
> > -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **=
swap_plug)
> > +static void swap_writepage_fs(struct swap_info_struct *sis,
> > +                             struct folio *folio,
> > +                             struct swap_iocb **swap_plug)
> >  {
> >         struct swap_iocb *sio =3D swap_plug ? *swap_plug : NULL;
> > -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->sw=
ap);
> >         struct file *swap_file =3D sis->swap_file;
> >         loff_t pos =3D swap_dev_pos(folio->swap);
> >
> > @@ -407,8 +410,9 @@ static void swap_writepage_fs(struct folio *folio, =
struct swap_iocb **swap_plug)
> >                 *swap_plug =3D sio;
> >  }
> >
> > -static void swap_writepage_bdev_sync(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
> > +                                    struct folio *folio,
> > +                                    struct swap_iocb **plug)
> >  {
> >         struct bio_vec bv;
> >         struct bio bio;
> > @@ -427,8 +431,9 @@ static void swap_writepage_bdev_sync(struct folio *=
folio,
> >         __end_swap_bio_write(&bio);
> >  }
> >
> > -static void swap_writepage_bdev_async(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_writepage_bdev_async(struct swap_info_struct *sis,
> > +                                     struct folio *folio,
> > +                                     struct swap_iocb **plug)
> >  {
> >         struct bio *bio;
> >
> > @@ -444,29 +449,6 @@ static void swap_writepage_bdev_async(struct folio=
 *folio,
> >         submit_bio(bio);
> >  }
> >
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plu=
g)
> > -{
> > -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->sw=
ap);
> > -
> > -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > -       /*
> > -        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > -        * but that will never affect SWP_FS_OPS, so the data_race
> > -        * is safe.
> > -        */
> > -       if (data_race(sis->flags & SWP_FS_OPS))
> > -               swap_writepage_fs(folio, swap_plug);
> > -       /*
> > -        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > -        * but that will never affect SWP_SYNCHRONOUS_IO, so the data_r=
ace
> > -        * is safe.
> > -        */
> > -       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > -               swap_writepage_bdev_sync(folio, sis);
> > -       else
> > -               swap_writepage_bdev_async(folio, sis);
> > -}
> > -
> >  void swap_write_unplug(struct swap_iocb *sio)
> >  {
> >         struct iov_iter from;
> > @@ -535,9 +517,10 @@ static bool swap_read_folio_zeromap(struct folio *=
folio)
> >         return true;
> >  }
> >
> > -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb *=
*plug)
> > +static void swap_read_folio_fs(struct swap_info_struct *sis,
> > +                              struct folio *folio,
> > +                              struct swap_iocb **plug)
> >  {
> > -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->sw=
ap);
> >         struct swap_iocb *sio =3D NULL;
> >         loff_t pos =3D swap_dev_pos(folio->swap);
> >
> > @@ -569,8 +552,9 @@ static void swap_read_folio_fs(struct folio *folio,=
 struct swap_iocb **plug)
> >                 *plug =3D sio;
> >  }
> >
> > -static void swap_read_folio_bdev_sync(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
> > +                                     struct folio *folio,
> > +                                     struct swap_iocb **plug)
> >  {
> >         struct bio_vec bv;
> >         struct bio bio;
> > @@ -591,8 +575,9 @@ static void swap_read_folio_bdev_sync(struct folio =
*folio,
> >         put_task_struct(current);
> >  }
> >
> > -static void swap_read_folio_bdev_async(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
> > +                                      struct folio *folio,
> > +                                      struct swap_iocb **plug)
> >  {
> >         struct bio *bio;
> >
> > @@ -606,6 +591,42 @@ static void swap_read_folio_bdev_async(struct foli=
o *folio,
> >         submit_bio(bio);
> >  }
> >
> > +static struct swap_ops bdev_fs_swap_ops =3D {
> > +       .read_folio =3D swap_read_folio_fs,
> > +       .write_folio =3D swap_writepage_fs,
> > +};
>
> const?
>
> > +
> > +static struct swap_ops bdev_sync_swap_ops =3D {
> > +       .read_folio =3D swap_read_folio_bdev_sync,
> > +       .write_folio =3D swap_writepage_bdev_sync,
> > +};
>
> const?
>
> > +
> > +static struct swap_ops bdev_async_swap_ops =3D {
> > +       .read_folio =3D swap_read_folio_bdev_async,
> > +       .write_folio =3D swap_writepage_bdev_async,
> > +};
>
> const?
>
> > +
> > +int probe_swap_fs(struct swap_info_struct *sis)
> > +{
> > +       /*
> > +        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > +        * but that will never affect SWP_FS_OPS, so the data_race
> > +        * is safe.
> > +        */
> > +       if (data_race(sis->flags & SWP_FS_OPS))
> > +               sis->ops =3D &bdev_fs_swap_ops;
> > +       /*
> > +        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > +        * but that will never affect SWP_SYNCHRONOUS_IO, so the data_r=
ace
> > +        * is safe.
> > +        */
> > +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > +               sis->ops =3D &bdev_sync_swap_ops;
> > +       else
> > +               sis->ops =3D &bdev_async_swap_ops;
> > +       return 0;
> > +}
> > +
> >  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >  {
> >         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->sw=
ap);
> > @@ -640,13 +661,8 @@ void swap_read_folio(struct folio *folio, struct s=
wap_iocb **plug)
> >         /* We have to read from slower devices. Increase zswap protecti=
on. */
> >         zswap_folio_swapin(folio);
> >
> > -       if (data_race(sis->flags & SWP_FS_OPS)) {
> > -               swap_read_folio_fs(folio, plug);
> > -       } else if (synchronous) {
> > -               swap_read_folio_bdev_sync(folio, sis);
> > -       } else {
> > -               swap_read_folio_bdev_async(folio, sis);
> > -       }
> > +       if (sis->ops && sis->ops->read_folio)
> > +               sis->ops->read_folio(sis, folio, plug);
> >
> >  finish:
> >         if (workingset) {
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 915bc93964db..af498f9af328 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
> >         /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap =
device */
> >         enable_swap_info(si);
> >
> > +       probe_swap_fs(si);
>
> Can we move this to enable_swap_info(), or perhaps even
> deeper into setup_swap_info()?
>
> > +
> >         pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:=
%lluk %s%s%s%s\n",
> >                 K(si->pages), name->name, si->prio, nr_extents,
> >                 K((unsigned long long)span),
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index a399f7a10830..7ce906249c7a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
> >         folio_set_reclaim(folio);
> >
> >         /* start writeback */
> > -       __swap_writepage(folio, NULL);
> > +       if (si->ops && si->ops->write_folio)
> > +               si->ops->write_folio(si, folio, NULL);
>
> swap_write_folio() inline wrapper?

Again, I think keeping it as is is fine.

Chris


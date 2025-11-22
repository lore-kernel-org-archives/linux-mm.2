Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DF8CFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C866B002E; Fri, 21 Nov 2025 20:52:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844356B0030; Fri, 21 Nov 2025 20:52:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A8B6B0031; Fri, 21 Nov 2025 20:52:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 609AB6B002E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:52:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 141B013BA8B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:30 +0000 (UTC)
X-FDA: 84136568460.22.02979F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1ACCF180008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dwBz5/ut";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763776348; a=rsa-sha256;
	cv=none;
	b=2OqCMc1npnBCoxq5Xa+b+C60deZmek6DErqlNpZUUtROS7FE5dA7B5SjSxoQfur5l0rwcA
	raYAvldfx567kwxh/+yPpupm4gEcDURzokqO79fcIdTI68ojf8B3bwMfzgb7U+Hs/6H99M
	kao0EUiTs6uNDiNSI9oYvNnj5z42aAE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dwBz5/ut";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763776348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6oMI9xlRxkdFcr+RHk1ePMa54iHaPycKJJErgf/2fw=;
	b=ryJ08Eo5t+56vCzztCfYCHV5GicEz8RRNdqdq2CunOmHNKdAULGz2mtGY1bo5Z6VIk0yMW
	dehBtRYWRolixn9Ty2zhIU87VMjT3+PPd9/hh6BOoW+hHd+SDOylsWy+znAlh7oJaNkXo8
	L9OYcKOb5GNcLkero4VTjkFeb7R2SXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5085544249
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCF8C19424
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763776347;
	bh=aWgIyKHO9MiwrQJ9D7qvo9FEuf7fBKRBbssGPZpR0OU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dwBz5/utaVrULDbO/d67bP5YGflIHd7eLX1CZkA9POq8d7XBr4bhwWj7AU8sfAuzf
	 u8XasAAKK8uDaGqMqHq4RbKrLuy+5xcmQ4Ds5zbAjR2FtcbonFn5i2ZttTjeUABd6K
	 opqSITejz0lLaZg8K7G0kFMxccrh6Q/0yJs82dr7clwW4Hj+gMcVyRBU1Crok3SSVh
	 qYs5bfjpDpjUC4Hr7Bd9i/zBaEuXDTj1S0xbDRSb/9KzXT8rMorp/+mCj1flsqBIbR
	 rwXSTJiVTEf+RhzBIWJeKLYy5D/yo2tgid0OkzMLB+jSnRAy/zjdeBaUYeF0JYBLvE
	 J3RqYDZNHHUWA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787ff3f462bso40304437b3.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:52:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXg3PFYDpTppZU9a8ptHGdQk4tW+MwAz0joCtezUlVANDD9UTtILDz6ZO7dPIPziXZPLtktOD8eEA==@kvack.org
X-Gm-Message-State: AOJu0YyhAAu5ElpH3ybX8EmjzEEINNXP5DkVRbupkVC1kqff3a2PdCye
	BoGcmcQcjiN3owt/2OoY5mN8n2vzhf0zyMN/TtgbSKeenuXUoCzXVMwi4/ChkAEh4mGgaDFKQkH
	cEGCOXSqlNDqMji0ap/y/98WCL6/Ep8lp/cHIRrN/8Q==
X-Google-Smtp-Source: AGHT+IEl4bNbKmaPYlfGYC8dnID5VD3tDTozz1qaMTMLCuoeoCt3g58K+9BOE3/wirrR1O9vZOXRIuN+BP3DJEYjsuA=
X-Received: by 2002:a05:690e:14c4:b0:63f:acc8:f163 with SMTP id
 956f58d0204a3-642f8e2dba4mr5638824d50.21.1763776346304; Fri, 21 Nov 2025
 17:52:26 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <454ejfdrzcdo5a4fmqeaf4nwhxwqnvgmcj7ussl7ws3lpdc7zg@67yqrig42erd>
In-Reply-To: <454ejfdrzcdo5a4fmqeaf4nwhxwqnvgmcj7ussl7ws3lpdc7zg@67yqrig42erd>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 21 Nov 2025 17:52:14 -0800
X-Gmail-Original-Message-ID: <CACePvbWEXfuwk1MuhGn5JV674vJnmaGY2Q5=Am1O9bDVK_J0PA@mail.gmail.com>
X-Gm-Features: AWmQ_bnYyU77Ed5AU_PR4L5ZzviglMUtfKFK3m3jwcWtVt0nQZs0ZPyh1OmReuM
Message-ID: <CACePvbWEXfuwk1MuhGn5JV674vJnmaGY2Q5=Am1O9bDVK_J0PA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1ACCF180008
X-Rspamd-Server: rspam07
X-Stat-Signature: si7wymtzypsg3nphkykrr4tm6je1nak8
X-Rspam-User: 
X-HE-Tag: 1763776347-266036
X-HE-Meta: U2FsdGVkX1/SrXoJwnMmMlowOprfpiTrS8OzUk0nvdNCr3mwLo4D0a+AGtbT7UeYeXUX2SkSPgq/Va8GbSodNDmO5g7cuab3vWt1pzzQXRu7APnAcVoIa9KI/wqIYo8Uufj2Lqv++zj4YlxtQvaPuhAQNi8jlsrdsK7NP7gCRkJ8sKUzT5Dsk8iJa4vaL4IoD6pSGfbAbwPaHot3ETY9GBN/5/FMu3u1GDK4Qu3Lud/+1br3780fbHqAqwuVUrr2cSspQ0LMx8xxWBbwehuqp/6+pupUI9eSj1nL2E30nBrvaFt+yyuCl2s8WzNSXQr9fpGGmX/LOSJHXQmOYnJ/rJ7TlWSvehbRG9N0+7CWWnjfCM73U1l7X77VqAIYgwFMmUVmpM/SFcgyF/Twb/QExIFmb/1dQQASJNgk6AU4UVZvYnajZr5RiNkoiI2WN9N3Ubh1prTCrnsgt2GFnhaE1uejDi+chEpd7mGIqM5YkredIeMzuUmapV0KIv8gFEZZH2WESv8cVsVTmSasX8iTelBprhhf2a9/VNemwFWxnwX97xWwYB6/kSWWrtdLYcPv5V9qrf/b3zy6j0hR2X00S9cbfwralxTfPJ6RYjeiXtu5RSIrCa3AXFrjnqaDUXCCWMPv2gLx4dUwbRrRvOorw9NsrIYfkQOaKp4/92g2vDpmNhE0a9IGdc3YngR3uQtze3LYXApsCaD8O4kaYCiXYsk+azlUD5SzuLj0r5fMLLIjeac7OqxL2VwunwdYlbeYg9svRngYOYJTsGy7OPIe2nkgAyfDaXcf2j+azBz2clWOiLG5pNz4U5iL3iXW3VBBiDGlAh3rQoVUwKSvjiDVQq2j1grNh1ZHNMQhRBzozqpE0w+4fdLSq6gInNp9xvmFzThWqdxtdNs4f9TFZTs9tRNp3qJyFVUknfFWQ1Kn9Y/tZxBqrxpi2dKfAewxzwTaPV8H/BEPhEDi8KZ3dI5
 vQt/s8SR
 J0iM2zpR2IF5pvgBWjnWkTt0dxr6QKY4nNJNc+LCWTknik664PR1O9PlRxZ8EwL8qYSKy1t5swnz2mEc18/lj8K7mM26nJU+++HbCYtjJJZ6Y2CgRuaFBRwq9EUAOpmBJQAgzNSqegY15MngrRFXdWgHCTv/g8ZO5DehTx0QXjlSl9T71a3mx+RxeiRdm+l7Qf1WWwOEfdka04whbrHCAI8n0pPXW3F4U02KG3sRpSQQudYCYiSls9+u6KH2pFSesiUYI5kgvm2JGR0KIE5LnYE+Jqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 7:14=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile. That waste swapfile
> > space.
> >
> > The ghost swapfile is a swapfile that only contains the swapfile header
> > for zswap. The swapfile header indicate the size of the swapfile. There
> > is no swap data section in the ghost swapfile, therefore, no waste of
> > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > prevents accidental read or write of ghost swapfile, bdev of
> > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > flag because there is no rotation disk access when using zswap.
> >
> > The zswap write back has been disabled if all swapfiles in the system
> > are ghost swap files.
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
>
> This was brought up before, I think it's not the right way to go
> upstream. Even if it's good for the short-term, it's a behavior exposed
> to userspace that we'll have to maintain. With the ongoing work to
> decouple zswap and swap backends, this will end up being something we
> have to workaround indefinitely to keep the same userspace semantics.

Actually, this doesn't need to be the short term solution. It can be
long term. I get  it your zswap maintainers do not want to get
involved in the ghost swapfile. I will leave you guys alone. Remember
2023 LPC swap abstraction talk, the community picked my approach to
the VFS swap ops over the swap abstraction which the swap
virtualization is based on. I take some time to come up with the
cluster based swap allocator and swap table to clean up and speed up
the swap stack. Now I am finally able to circle back and fulfill my
promise of the VFS swap ops. Have a little faith I will solve this
swap entry redirection issue nicely for you, better than the swap
virtualization approach can.

Chris

>
> > ---
> >  include/linux/swap.h |  2 ++
> >  mm/page_io.c         | 18 +++++++++++++++---
> >  mm/swap.h            |  2 +-
> >  mm/swap_state.c      |  7 +++++++
> >  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
> >  mm/zswap.c           | 17 +++++++++++------
> >  6 files changed, 73 insertions(+), 15 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 38ca3df68716042946274c18a3a6695dda3b7b65..af9b789c9ef9c0e5cf98887=
ab2bccd469c833c6b 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -216,6 +216,7 @@ enum {
> >       SWP_PAGE_DISCARD =3D (1 << 10),   /* freed swap page-cluster disc=
ards */
> >       SWP_STABLE_WRITES =3D (1 << 11),  /* no overwrite PG_writeback pa=
ges */
> >       SWP_SYNCHRONOUS_IO =3D (1 << 12), /* synchronous IO is efficient =
*/
> > +     SWP_GHOST       =3D (1 << 13),    /* not backed by anything */
> >                                       /* add others here before... */
> >  };
> >
> > @@ -438,6 +439,7 @@ void free_folio_and_swap_cache(struct folio *folio)=
;
> >  void free_pages_and_swap_cache(struct encoded_page **, int);
> >  /* linux/mm/swapfile.c */
> >  extern atomic_long_t nr_swap_pages;
> > +extern atomic_t nr_real_swapfiles;
> >  extern long total_swap_pages;
> >  extern atomic_t nr_rotate_swap;
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 3c342db77ce38ed26bc7aec68651270bbe0e2564..cc1eb4a068c10840bae0288=
e8005665c342fdc53 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -281,8 +281,7 @@ int swap_writeout(struct folio *folio, struct swap_=
iocb **swap_plug)
> >               return AOP_WRITEPAGE_ACTIVATE;
> >       }
> >
> > -     __swap_writepage(folio, swap_plug);
> > -     return 0;
> > +     return __swap_writepage(folio, swap_plug);
> >  out_unlock:
> >       folio_unlock(folio);
> >       return ret;
> > @@ -444,11 +443,18 @@ static void swap_writepage_bdev_async(struct foli=
o *folio,
> >       submit_bio(bio);
> >  }
> >
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plu=
g)
> > +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug=
)
> >  {
> >       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> >
> >       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > +
> > +     if (sis->flags & SWP_GHOST) {
> > +             /* Prevent the page from getting reclaimed. */
> > +             folio_set_dirty(folio);
> > +             return AOP_WRITEPAGE_ACTIVATE;
> > +     }
> > +
> >       /*
> >        * ->flags can be updated non-atomicially (scan_swap_map_slots),
> >        * but that will never affect SWP_FS_OPS, so the data_race
> > @@ -465,6 +471,7 @@ void __swap_writepage(struct folio *folio, struct s=
wap_iocb **swap_plug)
> >               swap_writepage_bdev_sync(folio, sis);
> >       else
> >               swap_writepage_bdev_async(folio, sis);
> > +     return 0;
> >  }
> >
> >  void swap_write_unplug(struct swap_iocb *sio)
> > @@ -637,6 +644,11 @@ void swap_read_folio(struct folio *folio, struct s=
wap_iocb **plug)
> >       if (zswap_load(folio) !=3D -ENOENT)
> >               goto finish;
> >
> > +     if (unlikely(sis->flags & SWP_GHOST)) {
> > +             folio_unlock(folio);
> > +             goto finish;
> > +     }
> > +
> >       /* We have to read from slower devices. Increase zswap protection=
. */
> >       zswap_folio_swapin(folio);
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index d034c13d8dd260cea2a1e95010a9df1e3011bfe4..bd60bf2c5dc9218069be0ad=
a5d2d843399894439 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -195,7 +195,7 @@ static inline void swap_read_unplug(struct swap_ioc=
b *plug)
> >  }
> >  void swap_write_unplug(struct swap_iocb *sio);
> >  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plu=
g);
> > +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug=
);
> >
> >  /* linux/mm/swap_state.c */
> >  extern struct address_space swap_space __ro_after_init;
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index b2230f8a48fc2c97d61d4bfb2c25e9d1e2508805..f01a8d8f32deb956e25c3c2=
4897b0e3f6c5a735c 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -632,6 +632,13 @@ struct folio *swap_cluster_readahead(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >       struct swap_iocb *splug =3D NULL;
> >       bool page_allocated;
> >
> > +     /*
> > +      * The entry may have been freed by another task. Avoid swap_info=
_get()
> > +      * which will print error message if the race happens.
> > +      */
> > +     if (si->flags & SWP_GHOST)
> > +             goto skip;
> > +
> >       mask =3D swapin_nr_pages(offset) - 1;
> >       if (!mask)
> >               goto skip;
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 94e0f0c54168759d75bc2756e7c09f35413e6c78..a34d1eb6908ea144fd8fab1=
224f1520054a94992 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
> >  static DEFINE_SPINLOCK(swap_lock);
> >  static unsigned int nr_swapfiles;
> >  atomic_long_t nr_swap_pages;
> > +atomic_t nr_real_swapfiles;
> >  /*
> >   * Some modules use swappable objects and may try to swap them out und=
er
> >   * memory pressure (via the shrinker). Before doing so, they may wish =
to
> > @@ -1158,6 +1159,8 @@ static void del_from_avail_list(struct swap_info_=
struct *si, bool swapoff)
> >                       goto skip;
> >       }
> >
> > +     if (!(si->flags & SWP_GHOST))
> > +             atomic_sub(1, &nr_real_swapfiles);
> >       plist_del(&si->avail_list, &swap_avail_head);
> >
> >  skip:
> > @@ -1200,6 +1203,8 @@ static void add_to_avail_list(struct swap_info_st=
ruct *si, bool swapon)
> >       }
> >
> >       plist_add(&si->avail_list, &swap_avail_head);
> > +     if (!(si->flags & SWP_GHOST))
> > +             atomic_add(1, &nr_real_swapfiles);
> >
> >  skip:
> >       spin_unlock(&swap_avail_lock);
> > @@ -2677,6 +2682,11 @@ static int setup_swap_extents(struct swap_info_s=
truct *sis, sector_t *span)
> >       struct inode *inode =3D mapping->host;
> >       int ret;
> >
> > +     if (sis->flags & SWP_GHOST) {
> > +             *span =3D 0;
> > +             return 0;
> > +     }
> > +
> >       if (S_ISBLK(inode->i_mode)) {
> >               ret =3D add_swap_extent(sis, 0, sis->max, 0);
> >               *span =3D sis->pages;
> > @@ -2910,7 +2920,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
> >       if (p->flags & SWP_CONTINUED)
> >               free_swap_count_continuations(p);
> >
> > -     if (!p->bdev || !bdev_nonrot(p->bdev))
> > +     if (!(p->flags & SWP_GHOST) &&
> > +         (!p->bdev || !bdev_nonrot(p->bdev)))
> >               atomic_dec(&nr_rotate_swap);
> >
> >       mutex_lock(&swapon_mutex);
> > @@ -3030,6 +3041,19 @@ static void swap_stop(struct seq_file *swap, voi=
d *v)
> >       mutex_unlock(&swapon_mutex);
> >  }
> >
> > +static const char *swap_type_str(struct swap_info_struct *si)
> > +{
> > +     struct file *file =3D si->swap_file;
> > +
> > +     if (si->flags & SWP_GHOST)
> > +             return "ghost\t";
> > +
> > +     if (S_ISBLK(file_inode(file)->i_mode))
> > +             return "partition";
> > +
> > +     return "file\t";
> > +}
> > +
> >  static int swap_show(struct seq_file *swap, void *v)
> >  {
> >       struct swap_info_struct *si =3D v;
> > @@ -3049,8 +3073,7 @@ static int swap_show(struct seq_file *swap, void =
*v)
> >       len =3D seq_file_path(swap, file, " \t\n\\");
> >       seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
> >                       len < 40 ? 40 - len : 1, " ",
> > -                     S_ISBLK(file_inode(file)->i_mode) ?
> > -                             "partition" : "file\t",
> > +                     swap_type_str(si),
> >                       bytes, bytes < 10000000 ? "\t" : "",
> >                       inuse, inuse < 10000000 ? "\t" : "",
> >                       si->prio);
> > @@ -3183,7 +3206,6 @@ static int claim_swapfile(struct swap_info_struct=
 *si, struct inode *inode)
> >       return 0;
> >  }
> >
> > -
> >  /*
> >   * Find out how many pages are allowed for a single swap device. There
> >   * are two limiting factors:
> > @@ -3229,6 +3251,7 @@ static unsigned long read_swap_header(struct swap=
_info_struct *si,
> >       unsigned long maxpages;
> >       unsigned long swapfilepages;
> >       unsigned long last_page;
> > +     loff_t size;
> >
> >       if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
> >               pr_err("Unable to find swap-space signature\n");
> > @@ -3271,7 +3294,16 @@ static unsigned long read_swap_header(struct swa=
p_info_struct *si,
> >
> >       if (!maxpages)
> >               return 0;
> > -     swapfilepages =3D i_size_read(inode) >> PAGE_SHIFT;
> > +
> > +     size =3D i_size_read(inode);
> > +     if (size =3D=3D PAGE_SIZE) {
> > +             /* Ghost swapfile */
> > +             si->bdev =3D NULL;
> > +             si->flags |=3D SWP_GHOST | SWP_SOLIDSTATE;
> > +             return maxpages;
> > +     }
> > +
> > +     swapfilepages =3D size >> PAGE_SHIFT;
> >       if (swapfilepages && maxpages > swapfilepages) {
> >               pr_warn("Swap area shorter than signature indicates\n");
> >               return 0;
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 5d0f8b13a958da3b5e74b63217b06e58ba2d3c26..29dfcc94b13eb72b1dbd100=
ded6e50620299e6e1 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1005,14 +1005,18 @@ static int zswap_writeback_entry(struct zswap_e=
ntry *entry,
> >       struct folio *folio;
> >       struct mempolicy *mpol;
> >       bool folio_was_allocated;
> > -     struct swap_info_struct *si;
> > +     struct swap_info_struct *si =3D get_swap_device(swpentry);
> >       int ret =3D 0;
> >
> > -     /* try to allocate swap cache folio */
> > -     si =3D get_swap_device(swpentry);
> >       if (!si)
> > -             return -EEXIST;
> > +             return -ENOENT;
> > +
> > +     if (si->flags & SWP_GHOST) {
> > +             put_swap_device(si);
> > +             return -EINVAL;
> > +     }
> >
> > +     /* try to allocate swap cache folio */
> >       mpol =3D get_task_policy(current);
> >       folio =3D __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
> >                       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> > @@ -1067,7 +1071,8 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
> >       folio_set_reclaim(folio);
> >
> >       /* start writeback */
> > -     __swap_writepage(folio, NULL);
> > +     ret =3D __swap_writepage(folio, NULL);
> > +     WARN_ON_ONCE(ret);
> >
> >  out:
> >       if (ret && ret !=3D -EEXIST) {
> > @@ -1551,7 +1556,7 @@ bool zswap_store(struct folio *folio)
> >       zswap_pool_put(pool);
> >  put_objcg:
> >       obj_cgroup_put(objcg);
> > -     if (!ret && zswap_pool_reached_full)
> > +     if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapf=
iles))
> >               queue_work(shrink_wq, &zswap_shrink_work);
> >  check_old:
> >       /*
> >
> > ---
> > base-commit: 9835506e139732fa1b55aea3ed4e3ec3dd499f30
> > change-id: 20251121-ghost-56e3948a7a17
> >
> > Best regards,
> > --
> > Chris Li <chrisl@kernel.org>
> >
>


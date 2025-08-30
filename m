Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E510FCA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 15:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26C86B0007; Sat, 30 Aug 2025 11:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7B46B0008; Sat, 30 Aug 2025 11:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEA56B000C; Sat, 30 Aug 2025 11:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6016B0007
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 11:25:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 192EA56C1C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:25:34 +0000 (UTC)
X-FDA: 83833798188.20.3C42440
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2FDF5C0009
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:25:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PNB5q0Qm;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756567532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6kYItPA2rvepUFOxaTnei2fpyIaZlQm+Xg013dccqM=;
	b=OSIBN2kej+LHAnDywe51LjSIU4VJ7+UoqY2+KHM3sRpL8s8Z1iQDGSkTsZAgbL67Ae23H1
	1i2XSpoKYE1o7R/UoA2ionYu8+/3mzonzoAb1ndF1X/CnSKwuAYn8FRJNYMIqIzUJp86+q
	JlgimcmWLg+BsSokOmYd4Br4KzOLRVA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PNB5q0Qm;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756567532; a=rsa-sha256;
	cv=none;
	b=IreT5Gebw5hSM1Qmv5G6uokzABWym2hBdyXds3W2GBZzXq5TJNvFfD67fuz5MV+b635ViJ
	9ygQ9Ox9Qi/YOqGulAgMbUPau9axV9YMUtL/5UpIj42coKcYyFXmVae+Fz3DVRj8GO7QEE
	JfhNDIypw/ADIqzy4EwscFpL0q3+kHM=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61cb4374d2fso4064363a12.2
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756567530; x=1757172330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6kYItPA2rvepUFOxaTnei2fpyIaZlQm+Xg013dccqM=;
        b=PNB5q0Qm4qH0Nt6R4Mgkn4PGt1CEhwGx88m9qAgTawrbdFHcS2NB1VM1vmasupr1iu
         AgTFri8+5jYcCggSmdvFNQOx0mnilDo/oF3WvA+u4+DXjSEV4Y+MN2MHUZH/tTv3KZAf
         SEu4v80LbVDBNJggxsVpFJ2VnfrKfpU6D1iSejcwDCEX7KFlZNrq1rV9pGjSDJ1gK9G8
         bbL/CQPkJjiM6Ogjn9+j8zgZpLIl/Rt+t1OoQW84GkR1xF2/fdDewz5e8wMgc3XTuYDg
         jbIaSNs5jUGE8wGwZXPVx1LlqKzek9N72NHUyuellbldlrAPb3OnWyn840PhKcU356hh
         FLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756567530; x=1757172330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6kYItPA2rvepUFOxaTnei2fpyIaZlQm+Xg013dccqM=;
        b=thnwVMoPKkEQL29puN9nrESeyiTW9MqQPg2c3W17vGh1qvpadv0mMQuKi6estYgZku
         c9UP1TyIY+vTBZl16y6+DhM9Al7LWqZKkqKvuMrN3A5Z4KdN182bCypxbFebIij2fMdX
         iVbfyY4AzjfVrpmWoIUHAWZgg9jwI9CdnjW2oBGCIZuXFhRm7tp9keN0HaRdXHytwvt0
         4BRrs5mmLVcOpwipGxFB+XSMimOmMS9+wbGhByYssEJakqve6QDS18m5oskOQXRu1FJy
         j1zSWIfV5hSqYjm2kpemnYgT0IxX18UO2o5kUR7E4fPnVpAafaQFF8ognjKGZuB042wK
         NItg==
X-Gm-Message-State: AOJu0YyHIcbu6K0rzIjRNKRdVH7buxqrM6mnytYKMuaEiBf82W8+7t3F
	f1SAtAmIwKdvDAneIfEmwVYKqVTCInVp8os/8rKD+0STyRZN/kO5+qpxsdirdyWJdSER9xkH5c9
	qnsfMR/jRZCfjSLJFHSY4LYu2FSFmZhY=
X-Gm-Gg: ASbGnctSenDZBAxyD3GtlCkjswPlXS+qM+ba7jhu2wSN4heKoj5qCrxlgGfTn5/cCSp
	Oolw0wQqkUHn3Za4CBjiLQbWvhhIV214bqi6+lGSgpQKHE+KkcereCxJWB0WVJD6Jt4eRwYNg4n
	Y0qAQ7yHdbOasoKgfWEc9XRZ+Pb7/cBFKMrsQb2zsmzlVhMBa8MuM555I+2RynvQQXPnmHqkzcs
	17unxSDYvTqa0NI3A==
X-Google-Smtp-Source: AGHT+IEG/i9X+YtYffXXjBDaRIylIj01ccFFC782cu4dGLzAX1iUtuOg8wg0de6jTk1W/+z/qvvdiRqHhLqkUMJCkP8=
X-Received: by 2002:a05:6402:42ce:b0:61c:5cac:2963 with SMTP id
 4fb4d7f45d1cf-61d26eb426fmr2073283a12.29.1756567530195; Sat, 30 Aug 2025
 08:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-8-ryncsn@gmail.com>
 <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com>
In-Reply-To: <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 30 Aug 2025 23:24:53 +0800
X-Gm-Features: Ac12FXwkRmXS_EEoguE7kdUtX-HWl799kuxhC4q_pkBr2-9zH7mf_51DiLIJbJk
Message-ID: <CAMgjq7Aznd7=m6JTNGM4EyFj+6pqHTRBCo2hsQL-cKi0LZggOg@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2FDF5C0009
X-Rspam-User: 
X-Stat-Signature: x89fu1ca3111u6ogezw5n6sz7de8aujq
X-Rspamd-Server: rspam09
X-HE-Tag: 1756567531-398262
X-HE-Meta: U2FsdGVkX18Lx8K9NEu8J0CcIg/dtRhBGIniHkpf5a+XVgThqBUQ80rQGhpUJt9AdspwWOpFtJuop5m3/f5KijnF4Ik42KZuZkic6zfWJsM5cJeN6CGqZ7eicij+sm7jXm1AvdTRbfSOPtuEjsM1kOA5Z4EbzxkL7fSygzXam5xq5JsmiSubACZ15XSel6Ta9mAdgXP49MwH6Ykk4E4Q47ypoxx/hNprZhrxnrLbQKMuxzqxZ0uSv8KoTgLmTGrLHGrzZwho65s8C5juqS6k9Q1ma0QbkHMBcmdFAoDVRIp+rn0/p0kzxL+127jySzslO6FSWaAhAVVDSA78YTOJ4aS0vVvjBtti54+dCzarj3oh/ItG62T4vuPahz2s7/4w6zl+2KG6vOV8BCRAy9CER7iylMFqfhYhmiyTW0DRWgmfe5DNpgxbVkCkBZlNrRG5bJ918vi9idqQ/LibWj5m9vqEVI95WbVnYatdopxpBUQZsQl49koPHU0OU4/JBEn1SiZ8xUhjjtD+V9rlaJUI/W6DdZZ/FaEzaw2fSqPJeBvTB3o1NifPbVaPWrhdWG6lV3LO1Tw2XPWvvieXNfN3/O9QfOzhWK5sLVMCoh4Xkq0IqkqUF0cUwA4QbxE4iASH/8rgexlLDOEE1qcq6QLxi2lgPCCnpTI5D2sCqBcPjc1zqCKxfLxVn8jdF4EzCkS/bTWsKNXDsExtKqjFjia42i1nJKkOcdohmTQ9up4vw3My2ED17eYdKFts3acOP0RgGwkyotg67w9IL36wp1nPCj/LFn5DyzHMSV9tZVQUKnoLuqqb1lAsTJ/4PCfoejMS3Vnmybx29o3xHKbZeDHpIPkCE+uYzTg6tVB/GL4uy2bmaeaEeWNFbPx2AZawcK87Nsn04GgsaAP3vRXUNxHoOsZcL3EhW0iicCCTYWe3rsigYw9BJ8WxS6ZueyGbwj2GzxJNUyGZqesDG4i/Rho
 DqMclzpe
 itYAB3uh8Vd+KHzh+6PAahdzCXRDra+7rMakiCoED4peN8OSQPmDEY6HjH+Mfgi2XcSZB6SAkYr7B8YWSukVO43V7k+r/RYLOFBxIqzF2O1lTlkUBr8oHdP1wCcb4XdqEP2hP+tFQyU8UC9XA+lCeM668kF37o6Er/TYMBJsfKs70Fyg075UEUxBQHdmsJDCbIJYt2QVnlPgQWZtNNomjz7h+XeYyB4mMaEBb5IkDb9nM7vYuejCcHOTOhRXvnc+kxWEEWoWJXJlihed3Qs1MdSPiOCS67GUKyeLgbprZrfoRg1mCpgSbAH5+p2pziB7b3T5X6W8PdjIqy8F1ELjvzVXz32vek0wxa93NRXttMykBIdCLY2ohRUmrGaTytz6otx+IQReqHv2TG4Auj93LdS2NSuZIGFPXn6xF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 1:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Kairui,
>
> It feels so good to remove that 64M swap cache space. Thank you for
> making it happen.
>
> Some nitpick follows. I am fine as is as well.
>
> Acked-by: Chris Li <chrisl@kernel.org>

Thanks.

>
> Chris
>
> On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Swap cluster setup will try to shuffle the clusters on initialization.
> > It was helpful to avoid contention for the swap cache space. The cluste=
r
> > size (2M) was much smaller than each swap cache space (64M), so shuffli=
ng
> > the cluster means the allocator will try to allocate swap slots that ar=
e
> > in different swap cache spaces for each CPU, reducing the chance of two
> > CPUs using the same swap cache space, and hence reducing the contention=
.
> >
> > Now, swap cache is managed by swap clusters, this shuffle is pointless.
> > Just remove it, and clean up related macros.
> >
> > This should also improve the HDD swap performance as shuffling IO is a
> > bad idea for HDD, and now the shuffling is gone.
>
> Did you have any numbers to prove that :-). Last time the swap
> allocator stress testing has already destroyed two of my SAS drives
> dedicated for testing. So I am not very keen on running the HDD swap
> stress test. The HDD swap stress test are super slow to run, it takes
> ages.

I did some test months before, removing the cluster shuffle did help.
I didn't test it again this time, only did some stress test. Doing
performance test on HDD is really not a good experience as my HDD
drives are too old so a long running test kills them easily.

And I couldn't find any other factor that is causing a serial HDD IO
regression, maybe the bot can help verify. If this doesn't help, we'll
think of something else. But I don't think HDD based SWAP will ever
have a practical good performance as they are terrible at rand read...

Anyway, let me try again with HDD today, maybe I'll get some useful data.

>
> >
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.=
com
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swap.h     |  4 ----
> >  mm/swapfile.c | 32 ++++++++------------------------
> >  mm/zswap.c    |  7 +++++--
> >  3 files changed, 13 insertions(+), 30 deletions(-)
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 4af42bc2cd72..ce3ec62cc05e 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -153,10 +153,6 @@ int swap_writeout(struct folio *folio, struct swap=
_iocb **swap_plug);
> >  void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plu=
g);
> >
> >  /* linux/mm/swap_state.c */
> > -/* One swap address space for each 64M swap space */
> > -#define SWAP_ADDRESS_SPACE_SHIFT       14
> > -#define SWAP_ADDRESS_SPACE_PAGES       (1 << SWAP_ADDRESS_SPACE_SHIFT)
> > -#define SWAP_ADDRESS_SPACE_MASK                (SWAP_ADDRESS_SPACE_PAG=
ES - 1)
> >  extern struct address_space swap_space __ro_after_init;
> >  static inline struct address_space *swap_address_space(swp_entry_t ent=
ry)
> >  {
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index df68b5e242a6..0c8001c99f30 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3203,21 +3203,14 @@ static int setup_swap_map(struct swap_info_stru=
ct *si,
> >         return 0;
> >  }
> >
> > -#define SWAP_CLUSTER_INFO_COLS                                        =
 \
> > -       DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
> > -#define SWAP_CLUSTER_SPACE_COLS                                       =
         \
> > -       DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
> > -#define SWAP_CLUSTER_COLS                                             =
 \
> > -       max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_=
COLS)
> > -
> >  static struct swap_cluster_info *setup_clusters(struct swap_info_struc=
t *si,
> >                                                 union swap_header *swap=
_header,
> >                                                 unsigned long maxpages)
> >  {
> >         unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_C=
LUSTER);
> >         struct swap_cluster_info *cluster_info;
> > -       unsigned long i, j, idx;
> >         int err =3D -ENOMEM;
> > +       unsigned long i;
>
> Nitpick: This line location change is not necessary.
>
> >
> >         cluster_info =3D kvcalloc(nr_clusters, sizeof(*cluster_info), G=
FP_KERNEL);
> >         if (!cluster_info)
> > @@ -3266,22 +3259,13 @@ static struct swap_cluster_info *setup_clusters=
(struct swap_info_struct *si,
> >                 INIT_LIST_HEAD(&si->frag_clusters[i]);
> >         }
> >
> > -       /*
> > -        * Reduce false cache line sharing between cluster_info and
> > -        * sharing same address space.
> > -        */
> > -       for (j =3D 0; j < SWAP_CLUSTER_COLS; j++) {
> > -               for (i =3D 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTE=
R_COLS); i++) {
> > -                       struct swap_cluster_info *ci;
> > -                       idx =3D i * SWAP_CLUSTER_COLS + j;
> > -                       ci =3D cluster_info + idx;
> > -                       if (idx >=3D nr_clusters)
> > -                               continue;
> > -                       if (ci->count) {
> > -                               ci->flags =3D CLUSTER_FLAG_NONFULL;
> > -                               list_add_tail(&ci->list, &si->nonfull_c=
lusters[0]);
> > -                               continue;
> > -                       }
> > +       for (i =3D 0; i < nr_clusters; i++) {
> > +               struct swap_cluster_info *ci =3D &cluster_info[i];
>
> struct swap_cluster_info *ci =3D cluster_info + i;
> looks simpler. Pure nitpick and personal preference, you don't have to
> follow it.
>
> > +
> > +               if (ci->count) {
> > +                       ci->flags =3D CLUSTER_FLAG_NONFULL;
> > +                       list_add_tail(&ci->list, &si->nonfull_clusters[=
0]);
> > +               } else {
> >                         ci->flags =3D CLUSTER_FLAG_FREE;
> >                         list_add_tail(&ci->list, &si->free_clusters);
> >                 }
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index c869859eec77..c0a9be14a725 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -237,10 +237,13 @@ static bool zswap_has_pool;
> >  * helpers and fwd declarations
> >  **********************************/
> >
> > +/* One swap address space for each 64M swap space */
> > +#define ZSWAP_ADDRESS_SPACE_SHIFT 14
> > +#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
> >  static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
> >  {
> >         return &zswap_trees[swp_type(swp)][swp_offset(swp)
> > -               >> SWAP_ADDRESS_SPACE_SHIFT];
> > +               >> ZSWAP_ADDRESS_SPACE_SHIFT];
> >  }
> >
> >  #define zswap_pool_debug(msg, p)                               \
> > @@ -1771,7 +1774,7 @@ int zswap_swapon(int type, unsigned long nr_pages=
)
> >         struct xarray *trees, *tree;
> >         unsigned int nr, i;
> >
> > -       nr =3D DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
> > +       nr =3D DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
> >         trees =3D kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
> >         if (!trees) {
> >                 pr_err("alloc failed, zswap disabled for swap type %d\n=
", type);
> > --
> > 2.51.0
> >
>


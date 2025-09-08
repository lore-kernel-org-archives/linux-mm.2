Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A092FCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2818E0015; Mon,  8 Sep 2025 11:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083568E0001; Mon,  8 Sep 2025 11:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB43A8E0015; Mon,  8 Sep 2025 11:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3FBA8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:10:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CBB01601C1
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:10:45 +0000 (UTC)
X-FDA: 83866420050.30.CFCFD61
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89B7A20009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:10:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X3/19SQk";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dO3Pa6dEWUP8pelQvefMYAqpzf+ZorOHLTvnJ330hQ=;
	b=5QT5BbHY5p3/Zcnfh7Mww+0bGphjcx7qaCC+V58Cki/kVvsID/pzgIKQl31nSm8NB9wVps
	vWikfMNogUoY7ELcUHPzpHsqIPxYFXlEBKhD7rclsGUZvdoZqUdPOcRTAo2zWHW3xMq2LJ
	3Lrp3r5iEYKnBMuqPkgFNa2U14ZdCfQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X3/19SQk";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344243; a=rsa-sha256;
	cv=none;
	b=LCzzhP2gnXM0G1Q9mwCSBIi5dljU7xWWNa3kfPf5J95mx8Wn16rh9XFtvXmvmIQKOPM/S5
	xV3lhhVnZvR8cWoK/iN8y43oyJSOlyUjX3KhyE0Jb6rl4pyD/sFYMITFlQ8YY6wKOYL53G
	tArJ1TvA8KX96wxgFC+PyTSZVqo93+0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62105d21297so6486111a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757344242; x=1757949042; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dO3Pa6dEWUP8pelQvefMYAqpzf+ZorOHLTvnJ330hQ=;
        b=X3/19SQkNGNhzorz5AEhhkA88ulKA9yzKGPb1U+wP6lPHZHGjL/By6m/dFGOi1rz9f
         3gJmFr3KZIqsEPCqHLS4ZDXB/Q337qdlAR06Fh5XhBttleHM1s8flhSIqwPRnU0RdKWV
         r2pfS9uNQmjEPPNpAuwyerLD5GBTu7RVhligXPq3CEiQ62fbbIbTAB4koUslqaQJ2a2j
         FuUHW+ZD5GBYzfueMMEqzJZbVamVY2QOfV6I9BkvLNxDfcjmyfqqEfeXkVAL1f1A7N8y
         7e2EfO/hfpDs6rq5Tx/0VdU9ShJifSt6e36LMYs5y26jGfe8AVlqfBCHFsfknTonORX+
         ZNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344242; x=1757949042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/dO3Pa6dEWUP8pelQvefMYAqpzf+ZorOHLTvnJ330hQ=;
        b=XCwhqyLp6UE1Wl/J+/OK86WR08m8xyvSCtSTwHxeJt3oSZd/PvvNN3hmJT3rgbRsxI
         Q4XjdFvSFofV/NfMppf1BMkBhMq6Ij7xNxu6e2IskWU1ifF0+8C//zR8LjJkX/1Y1O6t
         7tzqQLRlB+1kxy0ZfhnE57vE0nWL3zGz4FQG5IMv0kxL2TvYEHSS7gV0PEzz7Pl7b06w
         yLHY8OA9n8GtezIBMY3isPLHIoai5/zatv1Lhub0faJ36mKv/bUujSNgzs5Sx+RLAVJa
         ioPKD37kvENBbJ5j4eMtA+Tosqbsq7Mc/0U4VSifOHYghPN7R3W1AXbmgenfK/EWfacd
         zWkQ==
X-Gm-Message-State: AOJu0YyoArQzPt6FQv3YOUqFfKgp47H8QvU9bXAvO7ED1rRlC9nZTMWc
	JZpCOVuPBzFeLFJu9JAr3icWUhs91Feen/DyF5py8Jl194X9izVtVObP9JwXKRQH/RnWvjSHu19
	IB5r+6Uk1+ACaadDRYzymfvWq6Z1cMWKRLryjMyU=
X-Gm-Gg: ASbGncuU29XuAnDhjEWXDu75zFZLb5kQcWz+PgPyNaE7JjzNLF7uijsp5vqbMFN5hYL
	pLBSDHtUVrKLXDJsogJ/wZUI6GqXctq3z2mbWztws3DYjPijelkCJwFjIqxshj0doGpD+XGQZf5
	Zh13X3+XsLVUrO7W//Mtb3LJetlCPdiX30SXr8J32aufMJ7bBhggY85Hn8B+4mD2ewbzKqSMN08
	qOEqBqg/ZM=
X-Google-Smtp-Source: AGHT+IHnINkBVpoQfKvgRMifbAKSbbKVvSSsU75fh0HsrYLeTsWizN/4a6ihqC0j6vCvL42vfQxG+u48mAibFUSQ4OI=
X-Received: by 2002:a05:6402:2553:b0:617:b28c:e134 with SMTP id
 4fb4d7f45d1cf-6236d2ca6cfmr8301330a12.0.1757344241773; Mon, 08 Sep 2025
 08:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-12-ryncsn@gmail.com>
 <vj7utcgrseaot6ktpbwgshthmjza7w7vk2glede273tza7yfi6@cyxppxoney5u>
 <CAMgjq7CLSuSfRwMYqNL9ZU3ehpZfR6oewHsYtLD4CTXcvEKOTg@mail.gmail.com> <eu3s6hqfcbkymjqk2rrngzx7qxjzpivfty2dr4lrduxohxuuuv@g63qihvder5d>
In-Reply-To: <eu3s6hqfcbkymjqk2rrngzx7qxjzpivfty2dr4lrduxohxuuuv@g63qihvder5d>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 23:10:05 +0800
X-Gm-Features: AS18NWAOZumiwP4vIZdf4GKuXoH9G7uXKNhi2ON0m9FsP07PZ039SG3x5bSA-As
Message-ID: <CAMgjq7AHZ+X83pOUiOfhXWkV158uAvv=NQE6ibh33BQVgPJ5iA@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: Klara Modin <klarasmodin@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89B7A20009
X-Rspamd-Server: rspam05
X-Stat-Signature: fo7xysmbc9ke6aqc6f7hpmgtq4ge9jcw
X-Rspam-User: 
X-HE-Tag: 1757344243-63584
X-HE-Meta: U2FsdGVkX18GK45T/7U303DPka1GnvSAnKnkNtsR23ilhWggIgIiCTcklo8Uxk/462YSlUf1G5Us91oZAAoaD+9MWABZSzbBe0djZP1cqmkNE7VDLTnSprhD04gPqEpFpyYeNO5u4KZ/xPsJypj4leqklRN802BsOtEEi6of3VoctsYUckJKdArZ+KWvPzbAHkWFY+fS8+XynkmjARTcqlOjay3RtgDaThY/KHySoczPI/+cmRkwQP9JgLLVafsWF5FRwRLIyDU0LtlABFIO2nFCKvjyeVFyW21JdESqdF3VlpRV6rvVWajWHAJKTSGJMhkhc4AnfAYeI9M2L6j452UkeTIa1TttId3FX7zHPVAPdvY1qS+FxuKkwURtDGrL6eJ6CI5cIbiDIa52GsWxOO2rjS3D+n5S7YNE2c7TMgbnRyo5V50z5yQPXmmLw+ZuI2NcnCQ9iEiO08JGUx3iqp45iCFWe9dZoiJ+mxfHYLSw4IVyWr3iEiNXe45SR+5WPYmB/v3Siorqy6fiFztyU463ejK+X4JWvEuWVIsb7vnKMgJSOAPVCbI/9KqofT0Xt+N3QzIOvbSuOmZkek6P2SYGxdorq+25zq2XE6i8IoCL1fVyEMr13fYcGffJeBMWD8lO3PYWsbR5pcXElxGgRAX01RcPS271TjzWXIG38bi+q9RhdAftLPbYASFaL+qo1sJ5jfzZxEopbAaHES+mdiQ/p9h+THxHGUlzDWG4+iKpAStWZaHntxFtRpKc+8oFS7I+sUzg+hClE23Aoyx10BdM5luyjA5iZMwY12rOj9B2iouPLLrtJugFBU1adnXSEeHdQP46QgupnY7UKCgS0yRyd/qLsfCILPWdUMH+ecsugwofvmqfu/lB2i+RiNITVwKF+MLQYY22SkUt7qH3enkYVR4jtUoi7cgm8RY8GROieJdYjxNT9Fr6j+c0r1YjFdvOoovQcJ6lQFXh4RV
 YGxZssBI
 m93q44O4BU2oMlWh7OyXsvpgaC0hOMMCDvJJVQNnAHOf9vEP3Q3VA08vQai/p7GdwBelsca+cieS0TKiKYSscU7k1EK7EqAB52R5EuvBI0483Wk7bgBRv5KSoxC/ipvgGn/FLx9Alsrk829zriN/ypBnpdN88YEah4Uxz3ouVDNz1Xla1JP0Bn7cyBTtPdIXw0Fe9nUuPzoJFj4TvsD/8dEiM6mgFys6/B9IJE9pcMfJ64Yf/qnILZ2j3nwCmM/EtM/ZyynTU/qxcvpeKveKLCp8JuORoVZ6tqfjdzdYrvV/ZVR8dg+CYqOi/J0+fNntTeK6gDrw8wyT90/iwaRHpUZIC2EtAyqkf/C8hMPjMmYvRabezB563rFLmnUvuKTmCfCpbNMupIW7Wdz8G3VXVR6INKo3GcHMxo3AiYOATVu4My9NuFnSanJUztQss+uRiB1I1Y84x9QbArR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 11:01=E2=80=AFPM Klara Modin <klarasmodin@gmail.com>=
 wrote:
>
> On 2025-09-08 22:34:04 +0800, Kairui Song wrote:
> > On Sun, Sep 7, 2025 at 8:59=E2=80=AFPM Klara Modin <klarasmodin@gmail.c=
om> wrote:
> > >
> > > On 2025-09-06 03:13:53 +0800, Kairui Song wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > Introduce basic swap table infrastructures, which are now just a
> > > > fixed-sized flat array inside each swap cluster, with access wrappe=
rs.
> > > >
> > > > Each cluster contains a swap table of 512 entries. Each table entry=
 is
> > > > an opaque atomic long. It could be in 3 types: a shadow type (XA_VA=
LUE),
> > > > a folio type (pointer), or NULL.
> > > >
> > > > In this first step, it only supports storing a folio or shadow, and=
 it
> > > > is a drop-in replacement for the current swap cache. Convert all sw=
ap
> > > > cache users to use the new sets of APIs. Chris Li has been suggesti=
ng
> > > > using a new infrastructure for swap cache for better performance, a=
nd
> > > > that idea combined well with the swap table as the new backing
> > > > structure. Now the lock contention range is reduced to 2M clusters,
> > > > which is much smaller than the 64M address_space. And we can also d=
rop
> > > > the multiple address_space design.
> > > >
> > > > All the internal works are done with swap_cache_get_* helpers. Swap
> > > > cache lookup is still lock-less like before, and the helper's conte=
xts
> > > > are same with original swap cache helpers. They still require a pin
> > > > on the swap device to prevent the backing data from being freed.
> > > >
> > > > Swap cache updates are now protected by the swap cluster lock
> > > > instead of the Xarray lock. This is mostly handled internally, but =
new
> > > > __swap_cache_* helpers require the caller to lock the cluster. So, =
a
> > > > few new cluster access and locking helpers are also introduced.
> > > >
> > > > A fully cluster-based unified swap table can be implemented on top
> > > > of this to take care of all count tracking and synchronization work=
,
> > > > with dynamic allocation. It should reduce the memory usage while
> > > > making the performance even better.
> > > >
> > > > Co-developed-by: Chris Li <chrisl@kernel.org>
> > > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >  MAINTAINERS          |   1 +
> > > >  include/linux/swap.h |   2 -
> > > >  mm/huge_memory.c     |  13 +-
> > > >  mm/migrate.c         |  19 ++-
> > > >  mm/shmem.c           |   8 +-
> > > >  mm/swap.h            | 157 +++++++++++++++++------
> > > >  mm/swap_state.c      | 289 +++++++++++++++++++--------------------=
----
> > > >  mm/swap_table.h      |  97 +++++++++++++++
> > > >  mm/swapfile.c        | 100 +++++++++++----
> > > >  mm/vmscan.c          |  20 ++-
> > > >  10 files changed, 458 insertions(+), 248 deletions(-)
> > > >  create mode 100644 mm/swap_table.h
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 1c8292c0318d..de402ca91a80 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -16226,6 +16226,7 @@ F:    include/linux/swapops.h
> > > >  F:   mm/page_io.c
> > > >  F:   mm/swap.c
> > > >  F:   mm/swap.h
> > > > +F:   mm/swap_table.h
> > > >  F:   mm/swap_state.c
> > > >  F:   mm/swapfile.c
> > > >
> > >
> > > ...
> > >
> > > >  #include <linux/swapops.h> /* for swp_offset */
> > >
> > > Now that swp_offset() is used in folio_index(), should this perhaps a=
lso be
> > > included for !CONFIG_SWAP?
> >
> > Hi, Thanks for looking at this series.
> >
> > >
> > > >  #include <linux/blk_types.h> /* for bio_end_io_t */
> > > >
> > ...
> >
> > > >       if (unlikely(folio_test_swapcache(folio)))
> > >
> > > > -             return swap_cache_index(folio->swap);
> > > > +             return swp_offset(folio->swap);
> > >
> > > This is outside CONFIG_SWAP.
> >
> > Right, but there are users of folio_index that are outside of
> > CONFIG_SWAP (mm/migrate.c), and swp_offset is also outside of SWAP so
> > that's OK.
> >
> > If we wrap it, the CONFIG_SWAP build will fail. I've test !CONFIG_SWAP
> > build on this patch and after the whole series, it works fine.
> >
> > We should drop the usage of folio_index in migrate.c, that's not
> > really related to this series though.
>
> Interesting that it works for you. I have a config with !CONFIG_SWAP whic=
h
> fails with:
>
>  In file included from mm/shmem.c:44:
>  mm/swap.h: In function =E2=80=98folio_index=E2=80=99:
>  mm/swap.h:461:24: error: implicit declaration of function =E2=80=98swp_o=
ffset=E2=80=99; did you mean =E2=80=98pmd_offset=E2=80=99? [-Wimplicit-func=
tion-declaration]
>    461 |                 return swp_offset(folio->swap);
>        |                        ^~~~~~~~~~
>        |                        pmd_offset
>
> (though it's possible I have misapplied the series somehow).
> If I just move the linux/swapops.h include outside the CONFIG_SWAP ifdef:
>
> diff --git a/mm/swap.h b/mm/swap.h
> index caff4fe30fc5..12dd7d6478ff 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -3,6 +3,7 @@
>  #define _MM_SWAP_H
>
>  #include <linux/atomic.h> /* for atomic_long_t */
> +#include <linux/swapops.h> /* for swp_offset */
>  struct mempolicy;
>  struct swap_iocb;
>
> @@ -54,7 +55,6 @@ enum swap_cluster_flags {
>  };
>
>  #ifdef CONFIG_SWAP
> -#include <linux/swapops.h> /* for swp_offset */

Oh, I think I know what the problem is here. You disabled SHMEM too.
Most users of swap.h includes linux/swapops.h already. But for
shmem.c, it doesn't include linux/swapops.h when !CONFIG_SHMEM
 so swp_offset is undefined.

It's true that the problem is in swap.h, it should include swapops.h
for !SWAP too to avoid build error like this. Thanks for the report!


>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
>  static inline unsigned int swp_cluster_offset(swp_entry_t entry)
>
> it fixes that issue for me, and my other CONFIG_SWAP builds do not seem
> to be impacted. I attached the config in case it's useful.
>
> >
> > >
> > > >       return folio->index;
> > > >  }
> > >
> > > ...
> > >
> > > Regards,
> > > Klara Modin
> > >


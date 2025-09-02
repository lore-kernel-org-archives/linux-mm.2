Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0DD3CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1802D8E0005; Tue,  2 Sep 2025 12:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1567E8E0001; Tue,  2 Sep 2025 12:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0933B8E0005; Tue,  2 Sep 2025 12:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED8468E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:39:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 877AD1DCEE2
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:39:32 +0000 (UTC)
X-FDA: 83844870984.24.8AB26D2
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B08F20006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:39:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EygE1vRZ;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756831170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KULDNgiYHmmPCuUqyY0RJ/0WhWSbFCxPKKLg6IajuDI=;
	b=TCckVvtZY/Js7Os/ZFvTwMJPTiqeoD5VOJeIyu3nu4JVxRbVYfhi3rKNuHHuGUcHVtoNhW
	ER7A2vAv20DG1+jdMAscHv5vpAx7K3KDo9Cr8DhPHkt+QT4zSgt4zAk1UP9nlOrmLygY6k
	TEGiFDmjfMFN77dU/+GRWYgDR9Lp0og=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756831170; a=rsa-sha256;
	cv=none;
	b=xdphuZLb6pQSDb8qaafKOcF9oZvTYUXmfCmtxK8JiBFntzQvv5vrhhTPVVDA2zyNaDUXlm
	Pmp9vzoHLyoU2hqILXcsftlarFky+VJETtOoHdm3giJ5AEOF/51f9orUrafGS7UgofTXuX
	jNlWV9jLypid6LcqCmV48itBTvPKhGc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EygE1vRZ;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afeec747e60so914227266b.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756831169; x=1757435969; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KULDNgiYHmmPCuUqyY0RJ/0WhWSbFCxPKKLg6IajuDI=;
        b=EygE1vRZoHVAuYlZzHIe989uzA1kOrIciIY2qBCa4yB9Vjrk5iYKduMQPX04jUnDdF
         kWVkDLOOVHy0rjb5TBAU1ul945jgz1zQ0dcpihlcrhbKlMEVPcmweXRjs1aTsG5h1lGC
         UnHfTmOeHa0leTU5m7haOIsbUgzmVp1F5UL90+/9B5JewH9CC7ymQQeS6//TF0nW70To
         VdGcjV39LjmfIqabGrNMBtS7OxZ30qYwt/6VjZaqyMWR5nZjVP7wH7byizkYRx2X8ZKp
         2T99Ed0cqK7bK7aWh3UH2sPitu7l2zHmmELQn68F00UkITqqhSj4Gou8MzMeJEHeOcnf
         YT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756831169; x=1757435969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KULDNgiYHmmPCuUqyY0RJ/0WhWSbFCxPKKLg6IajuDI=;
        b=POkub4uPtk2//xX2FuWP2NuosSD6o7aw90krTKjaipJYIVLpMGxQG3VvyEvMeDOqpq
         MHUwYJmcvBhi2NfJsZh3w4HFP65Hm/A8Jxz7cC0IHW8zjM/iBbtN/IJa154c+dFUks+H
         lz7aL98Pzv1LGEx9DNhbpeRSzPRws58APryzSzKPWfYIaydUWPgOsgw7tejer1hIusMP
         5SAtFfkTFQIXwqDPhXJIhKyEcX8eGAkuQ8fZSXvPqIQ+vqYaYp9t2WewXt4uhQ9EIhOX
         7zsXrERmSaYY9B7ixX9bOVX5H/rD4HWY1W5V/I5FrWeVU6MHr858Kp8yRTVEy0qEvO9T
         J0hw==
X-Gm-Message-State: AOJu0YxQPRCIBS2LcwZf3ZSLNd6MphaZwJra88zKhHhCck+LhhZhimOe
	PNcuYAPWe0GY3SYJ3BTIJ8JKHxBnzPLQpJDA/oHN/KOAsyCpdTPMmpfv/M7Z26aS9eU3/+oCIm+
	seStzc+fzC5FmCTFImpbIDaze/9r0BzU=
X-Gm-Gg: ASbGnctBn+7F5krdENGgxlLx0rrLV5doEZM2qfqiCkuhzzSvsMIseDVMoAl/gYIcIBJ
	AtsrRm0QkoB/x5/FScQV3hZqeWmL9DyMKMMjBiC8HyvSXflmMFIMtQcDEViO7PAHkyH98gehe/X
	f0XpMGZA+8bYpv6qZoFR8HKW+ku+9zKPBps8rQY8mV9Z0eGVWGm0us7c/MEucdFE8BOulEsZmWa
	Pq0Ab71Yjg=
X-Google-Smtp-Source: AGHT+IFRf7sPflJDkEdO/QSYtWCkjAgoR/6FK9Cto6Nj1y7bD9WdS6dLt7SGBpbWPpBvR6Vc9rlOJOqThfz0PWW7O/0=
X-Received: by 2002:a17:907:94d6:b0:afe:d590:b6af with SMTP id
 a640c23a62f3a-b01d8a8b60bmr1159614066b.20.1756831168587; Tue, 02 Sep 2025
 09:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <c4a729b8-be9e-4005-aab6-91723fcf0080@redhat.com>
In-Reply-To: <c4a729b8-be9e-4005-aab6-91723fcf0080@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Sep 2025 00:38:52 +0800
X-Gm-Features: Ac12FXwuchJT2yLVFLgtl3lm-EW28Pq9-K675kfkDbUYK12I5RGhC7MPXRDFURI
Message-ID: <CAMgjq7D9uO58213Shb5sHx=ebvUdvO1mOnaVdb=dOY2Zr1QoEg@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B08F20006
X-Stat-Signature: qz4oyjxp37sukdy1fszng53rkadpr1ny
X-HE-Tag: 1756831170-555312
X-HE-Meta: U2FsdGVkX19oziZrphlue7e0tOrbhiugksRU07wBuO4qFU8F3xmQG9cKDG6Bih+LiNmk0DbuWfK7HX1nwC/aqw2lyiG+U9p2pVwcwzjbGEGH+DpqUeasQZYR8e/AB7O8tnWsJhEQUzRlWlUOa96BSKPqSZZI/EbuGUCR+cZHW+cpXgs1HCOMwJk7X9Vk6jV3xwVDizVtQlvLnCPd/RybVlDKUcqCclY6QEpAhmVGo6SB3NCcx/4TzrFiwBGBL/0r1jKaJhGyFJWiZJwXNxUzMQ4VO/dZ19XzYdPTVunHiYB6wYbELIAZvmWMR1JlOXT39ATsn2VFDwRtUTrZc1YTRQNyqqtPtIbBO7ypNcrWDSud5fiIvmUeMMK+EuiTxJmLyTwVBgJ8yK2l/IK0fYfuaa3OIUoVttNRsagKJH9BMg5BV3OhIkggGMwj0eU7k2Uj07IV6XHP7YYqb3HSt2ZjifEfl7cZAyci4Y0bO5vyk0v90bMRhVq+YGSJKPJuub/tsdqL4UOG90JFyxwCoLoKuCu2wTFGPLyJrdkxLI8L/enooVypx0Cc4GT23V7MfnCeq/jf7lHsHxu/i6gHrF5gYHUpwoh4Ub48Lc2pth3aEdYcdo5QGgwwo3fF65+0MIHz0mpS61ohePRYf8zoDM9oxS+FmYJxsx2zmnBlh/U/nsPfNJ0rdAYRWvMhNnEU7inXLMrtDglgK5VDFxHSo6LAvsjJRJatQ3rF4eU5fks3rLA/v+Hij5UghC/HlP860W5sLQtptXR4vv56G/R3bJfdCDBOiUBUG/mEObFLx3GwI0Lr0dc/IQfX11EX8WpcHWQFUdxGWgUQzzQn1LGBHZbKuT8nl+3siUflk9M/NkSXPtnTvoZgGtwEBsWGFV5a1ot882GKXJvVzTo91wEFs0vLWedHxPV7P/OVDZHuUiEltCid60BdWYjbk9jEKfNDhioQIqlk5soZaQ1FXvG3Kqa
 zczJnITT
 uF+l62ezhFZDX+NbaerfBxn4xdGNAAyRSp47A7Xiq232AFmK0/oir8JaZwugPD4JcEPyiK21ik2efRr4LLw9Db+BGtOjEeCaWHWw3l+/WhN9DNqAbXEANbFdNyCjcztbMbj/xTfQgSP8EUWEv1dLnjAjVOergZKuQq2nFpj4j52VUyjqhuFUSw2k53BljG47FEpHvrw9TVNuO+nXPY+GsnB7/X4eY0aE6okjNpJUwrJKhNhfV6awHwQOLokFJL0OR22TuKJibgjM9RBt9oJoNYk+aKJ6P9oiP7x4p4hGDbaDwze9OCuZPg62a5/z1zwUv0A0z1wKT9tTKnxHx/MJuc6CqDJHtd0zTlOhpBzp6tQsMuVUM7o9tfLC1RRWTk27Db1LNdPagGEgj/WzewNdiCwuocw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 7:22=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 22.08.25 21:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Always use swap_cache_get_folio for swap cache folio look up. The reaso=
n
> > we are not using it in all places is that it also updates the readahead
> > info, and some callsites want to avoid that.
> >
> > So decouple readahead update with swap cache lookup into a standalone
> > helper, let the caller call the readahead update helper if that's
> > needed. And convert all swap cache lookups to use swap_cache_get_folio.
> >
> > After this commit, there are only three special cases for accessing swa=
p
> > cache space now: huge memory splitting, migration and shmem replacing,
> > because they need to lock the Xarray. Following commits will wrap their
> > accesses to the swap cache too with special helpers.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/memory.c      |  6 ++-
> >   mm/mincore.c     |  3 +-
> >   mm/shmem.c       |  4 +-
> >   mm/swap.h        | 13 +++++--
> >   mm/swap_state.c  | 99 +++++++++++++++++++++++------------------------=
-
> >   mm/swapfile.c    | 11 +++---
> >   mm/userfaultfd.c |  5 +--
> >   7 files changed, 72 insertions(+), 69 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d9de6c056179..10ef528a5f44 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >       if (unlikely(!si))
> >               goto out;
> >
> > -     folio =3D swap_cache_get_folio(entry, vma, vmf->address);
> > -     if (folio)
> > +     folio =3D swap_cache_get_folio(entry);
> > +     if (folio) {
> > +             swap_update_readahead(folio, vma, vmf->address);
> >               page =3D folio_file_page(folio, swp_offset(entry));
> > +     }
> >       swapcache =3D folio;
> >
> >       if (!folio) {
> > diff --git a/mm/mincore.c b/mm/mincore.c
> > index 2f3e1816a30d..8ec4719370e1 100644
> > --- a/mm/mincore.c
> > +++ b/mm/mincore.c
> > @@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, =
bool shmem)
> >               if (!si)
> >                       return 0;
> >       }
> > -     folio =3D filemap_get_entry(swap_address_space(entry),
> > -                               swap_cache_index(entry));
> > +     folio =3D swap_cache_get_folio(entry);
> >       if (shmem)
> >               put_swap_device(si);
> >       /* The swap cache space contains either folio, shadow or NULL */
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 13cc51df3893..e9d0d2784cd5 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >       }
> >
> >       /* Look it up and read it in.. */
> > -     folio =3D swap_cache_get_folio(swap, NULL, 0);
> > +     folio =3D swap_cache_get_folio(swap);
> >       if (!folio) {
> >               if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> >                       /* Direct swapin skipping swap cache & readahead =
*/
> > @@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                       count_vm_event(PGMAJFAULT);
> >                       count_memcg_event_mm(fault_mm, PGMAJFAULT);
> >               }
> > +     } else {
> > +             swap_update_readahead(folio, NULL, 0);
> >       }
> >
> >       if (order > folio_order(folio)) {
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 1ae44d4193b1..efb6d7ff9f30 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
> >   void clear_shadow_from_swap_cache(int type, unsigned long begin,
> >                                 unsigned long end);
> >   void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, =
int nr);
> > -struct folio *swap_cache_get_folio(swp_entry_t entry,
> > -             struct vm_area_struct *vma, unsigned long addr);
> > +struct folio *swap_cache_get_folio(swp_entry_t entry);
> >   struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask=
,
> >               struct vm_area_struct *vma, unsigned long addr,
> >               struct swap_iocb **plug);
> > @@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t flag,
> >               struct mempolicy *mpol, pgoff_t ilx);
> >   struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> >               struct vm_fault *vmf);
> > +void swap_update_readahead(struct folio *folio, struct vm_area_struct =
*vma,
> > +                        unsigned long addr);
> >
> >   static inline unsigned int folio_swap_flags(struct folio *folio)
> >   {
> > @@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_e=
ntry_t swp, gfp_t gfp_mask,
> >       return NULL;
> >   }
> >
> > +static inline void swap_update_readahead(struct folio *folio,
> > +             struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +}
> > +
> >   static inline int swap_writeout(struct folio *folio,
> >               struct swap_iocb **swap_plug)
> >   {
> > @@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info=
_struct *si, swp_entry_t entr
> >   {
> >   }
> >
> > -static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
> > -             struct vm_area_struct *vma, unsigned long addr)
> > +static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
> >   {
> >       return NULL;
> >   }
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 99513b74b5d8..ff9eb761a103 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
> >       printk("Total swap =3D %lukB\n", K(total_swap_pages));
> >   }
> >
> > +/*
>
> While at it, proper kerneldoc?
>
> /**
>
> etc.
>
> Also documenting that it will only return a valid folio pointer or NULL

Good suggestion. I added some kerneldoc in later commit for this
function, do it earlier here is better.

>
> > + * Lookup a swap entry in the swap cache. A found folio will be return=
ed
> > + * unlocked and with its refcount incremented.
> > + *
> > + * Caller must lock the swap device or hold a reference to keep it val=
id.
> > + */
> > +struct folio *swap_cache_get_folio(swp_entry_t entry)
> > +{
> > +     struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> > +                                             swap_cache_index(entry));
> > +     if (!IS_ERR(folio))
> > +             return folio;
> > +     return NULL;
>
> Maybe better as (avoid one !)
>
> if (IS_ERR(folio))
>         return NULL;
> return folio;
>
> or simply
>
> return IS_ERR(folio) ? NULL : folio.
>
> > +}
> > +
> >   void *get_shadow_from_swap_cache(swp_entry_t entry)
> >   {
> >       struct address_space *address_space =3D swap_address_space(entry)=
;
> > @@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
> >   }
> >
> >   /*
> > - * Lookup a swap entry in the swap cache. A found folio will be return=
ed
> > - * unlocked and with its refcount incremented - we rely on the kernel
> > - * lock getting page table operations atomic even if we drop the folio
> > - * lock before returning.
> > - *
> > - * Caller must lock the swap device or hold a reference to keep it val=
id.
> > + * Update the readahead statistics of a vma or globally.
> >    */
> > -struct folio *swap_cache_get_folio(swp_entry_t entry,
> > -             struct vm_area_struct *vma, unsigned long addr)
>
> This also sounds like a good kerneldoc candidate :)
>
> In particular, documenting that it is valid to pass in vma =3D=3D NULL (i=
n
> which case the addr is ignored).

Agree, I forgot this one, will add some doc.

>
> > +void swap_update_readahead(struct folio *folio,
> > +                        struct vm_area_struct *vma,
> > +                        unsigned long addr)
> >   {
>
>
> Apart from that LGTM.

Thanks!

>
> --
> Cheers
>
> David / dhildenb
>
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D061BCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FB68E0002; Wed, 10 Sep 2025 22:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347558E0001; Wed, 10 Sep 2025 22:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F0C8E0002; Wed, 10 Sep 2025 22:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6A08E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:34:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1BECC035C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:34:22 +0000 (UTC)
X-FDA: 83875400364.28.307DC74
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F92640009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:34:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5nuNmbh;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757558060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lz642Xq8oX63R09MnUYhrlSY78PtpczrNszTJt1BqEQ=;
	b=Cc9P5+NQbm4zO/OPU9J8T/vvtq+vrq3D7rYKCgAp0hQfnRa2sp9PGVX3ufSEo8O8H/vEqX
	hlUdC/x/MNYxwDLX0WSlGYp0hwnTyJJaotQ4r+LmxmJS5bZCQeFqW+yn/+IVwC5ZBwnpA/
	+Pxk8etgwfUSRzaopziS0xm4gcIX7Wo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757558060; a=rsa-sha256;
	cv=none;
	b=42sjzf5WmhcZfSD0OleUY6rU4LGP1JUbPbNEl0lnVT8PV8dJUZ9uvckWlSDrTZty4g+KKB
	CFZFR4YK/WY+BI1ffx4ZFC3jd/byMxz1JiNXxaYs65vGnKXcq4vNTHD3XHRKzkhtuSFT4K
	Tj10KZjfsrA5GScYTwPo+ARN+d2H/nI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5nuNmbh;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCXDlMusazFeBnTp6ZqXc3w4Mdqj7AyJ8mzOdZOgPjCXnpCQLRezGRFQX1nFf79gyYfp55n6PZPDcg==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757558057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lz642Xq8oX63R09MnUYhrlSY78PtpczrNszTJt1BqEQ=;
	b=G5nuNmbhnO5nsaASAuQkQIpCJAXN3mJkZzeBid2Ze1JtbZacCuytyys4V191NKG1xnv6mL
	lKB4jZyO5PJxSEcuoCYNm8NNVib9wpcBhqKe+k5xTvl1rCMXA/iDlY5Vy4uDVLUvZo3UmD
	MbeqfiyT/S+BgVpxfcuaiMf5D2hU8WU=
X-Gm-Message-State: AOJu0YwNaKuQAc1Xn28FqlWEpj+knTad4JIpF0Ik0v2bZ/SzVqgozSrk
	COgR7ZSdXI99vH8lywIVAiEtQihhUeHTYQU6pyo/8j3OYmH1A40p8uPerCRytLNReV7ksHC+lKP
	aHybB4RSVxN7L8UDj08BG7cnA4NiJeWw=
X-Google-Smtp-Source: AGHT+IFlYXGxf4gsjShHPJhCBaoJX93IipJXqS1qWx6AlfTuIygz+Zt1F7O22/ZJnLahqXuEAb9kudWSaFs6FH4OT2g=
X-Received: by 2002:a05:6214:5193:b0:70d:fe0e:68ec with SMTP id
 6a1803df08f44-73941de39cdmr229112726d6.54.1757558055123; Wed, 10 Sep 2025
 19:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
In-Reply-To: <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 11 Sep 2025 10:33:38 +0800
X-Gmail-Original-Message-ID: <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
X-Gm-Features: AS18NWDEJVbzC05I1hGfJV7UGKmNBz8bk9n2hfDOr2UCy3HPoihYmtfyIIiHab0
Message-ID: <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: Lance Yang <lance.yang@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F92640009
X-Stat-Signature: kb38i9y1ufhfjwkt3659de1qosrdm156
X-Rspam-User: 
X-HE-Tag: 1757558060-324376
X-HE-Meta: U2FsdGVkX18+7pvpmXwqisAhQ700h7ON569NTAGOhWr89zU7LEYq4djGturyedklb/eursyEwjgQdas6jPkxiFlO0jiMSgZD8xXTi2VHamLfAdx0OqwrtgJ38EC8H/CQyIG7Nl2pNVEA7uMsSCp46B3YXLtcOmmQdECYgV22MgP+MOvUckBcOxPxfAK3TPNJT+GlN0cyh6HrPXIqFpFazfYFe/w6z7ICpj5+DnkB4WV22RShl5Hl6RyIfECZgiin6o/f1BjY1my5SwB5vcMvNUjSnbBx/2NOAnA91snRtSgpUERfZobuIQvzTXzDukT3zGYwnvMEMfebFjxmJ/kAfQfPPw7IkCmUDAbmZr0SngzG7nHwgcamnA/5Ivjtvp7kYhw496Yp07Kwg9XzDrPOpB9nU40xCkoA75iZSyloy61ADXo79RYj13M5JKN6m8OXm04juW/353sjnrBgfQAIY8r7bOIiH2jQ3OLR+czIAWYs1hGMBeA0H/TeI6sOfelYwTV68roJWqexPPYqD60kUUHMq1vixaNBurwCIYfCf/2kMlMlehJ+MSBG+8rwFKDlVU6fh+2zhnFg+n5miGePT+/QIGZK7ub0IPF8GR7amAsLcfQcWeDddj9BMzVS50EhvCNTJPuEZ5pWNfgpr3HNHvMEX5VlZeRzkQcVqOZbcKfnvTycBN3u2u2Eu+lzYH3TGOBp5wyVwiIY8NbIh5620Kk/nbpo4A8FzVRbSkyydmghwCAN25n9rUDPFEGjf7XzsnBI5iEfeCUXJFSgE5vdVKz59HbqwkOpeX0rNFu5/cVViGQws/vaYyGIoX9TX+/37nOYTmCXVHS3D2Hgv3o9eJTjU2YQe/4i0mvT7EwZZWvgWDO6y/GODS1UeJB/f9XUUaQFL+3JF3dM9qKj/8m8ganIxvl1k4iwDGAY2CJ4G6WGbX5GcK+qFZ4kskQ5uG38bTR/2cuSGsuFrxzcZe7
 n8AMsaCU
 aR4UP5Q8q3Rq+sxhYATRnJdqMLV/Xpnd4otnKmE/RpnkTY4HYE/siRwFUxuGp5K3NWkGFp5aze7T6RhIFYhBYXYlj47Rw6/9rxV+rbeisDa7Hmxk/6+4hAKbfpqeicUy3X7mUAjzu4QUnucfxuf34+Cj/XKG7hk/NR23f0w8fIKC5IBn7+XPbYLg8cRpDt6XojGBd9n9igo7fLHgVfMwl+fdL1h+8V1e0irjY3P9E5YKpkkU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:27=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
> Hi Kairui,
>
> I'm hitting a build error with allnoconfig:
>
> In file included from mm/shmem.c:44:
> mm/swap.h: In function =E2=80=98folio_index=E2=80=99:
> mm/swap.h:462:24: error: implicit declaration of function
> =E2=80=98swp_offset=E2=80=99; did you mean =E2=80=98pmd_offset=E2=80=99?
> [-Wimplicit-function-declaration]
> 462 | return swp_offset(folio->swap);
>
> It looks like a header might be missing in mm/swap.h. Please let me know
> if you need any more information.

Confirmed that just adding #include <linux/swapops.h> into mm/swap.h fixes =
it.

diff --git a/mm/swap.h b/mm/swap.h
index ad339547ee8c..271e8c560fcc 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -3,6 +3,7 @@
 #define _MM_SWAP_H

 #include <linux/atomic.h> /* for atomic_long_t */
+#include <linux/swapops.h>
 struct mempolicy;
 struct swap_iocb;

Cheers,
Lance

>
> Cheers,
> Lance
>
>
> On Thu, Sep 11, 2025 at 2:37=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce basic swap table infrastructures, which are now just a
> > fixed-sized flat array inside each swap cluster, with access wrappers.
> >
> > Each cluster contains a swap table of 512 entries. Each table entry is
> > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE)=
,
> > a folio type (pointer), or NULL.
> >
> > In this first step, it only supports storing a folio or shadow, and it
> > is a drop-in replacement for the current swap cache. Convert all swap
> > cache users to use the new sets of APIs. Chris Li has been suggesting
> > using a new infrastructure for swap cache for better performance, and
> > that idea combined well with the swap table as the new backing
> > structure. Now the lock contention range is reduced to 2M clusters,
> > which is much smaller than the 64M address_space. And we can also drop
> > the multiple address_space design.
> >
> > All the internal works are done with swap_cache_get_* helpers. Swap
> > cache lookup is still lock-less like before, and the helper's contexts
> > are same with original swap cache helpers. They still require a pin
> > on the swap device to prevent the backing data from being freed.
> >
> > Swap cache updates are now protected by the swap cluster lock
> > instead of the Xarray lock. This is mostly handled internally, but new
> > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > few new cluster access and locking helpers are also introduced.
> >
> > A fully cluster-based unified swap table can be implemented on top
> > of this to take care of all count tracking and synchronization work,
> > with dynamic allocation. It should reduce the memory usage while
> > making the performance even better.
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Chris Li <chrisl@kernel.org>
> > ---
> >  MAINTAINERS          |   1 +
> >  include/linux/swap.h |   2 -
> >  mm/huge_memory.c     |  13 +-
> >  mm/migrate.c         |  19 ++-
> >  mm/shmem.c           |   8 +-
> >  mm/swap.h            | 154 +++++++++++++++++------
> >  mm/swap_state.c      | 293 +++++++++++++++++++------------------------
> >  mm/swap_table.h      |  97 ++++++++++++++
> >  mm/swapfile.c        | 100 +++++++++++----
> >  mm/vmscan.c          |  20 ++-
> >  10 files changed, 459 insertions(+), 248 deletions(-)
> >  create mode 100644 mm/swap_table.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3d113bfc3c82..4c8bbf70a3c7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16232,6 +16232,7 @@ F:      include/linux/swapops.h
> >  F:     mm/page_io.c
> >  F:     mm/swap.c
> >  F:     mm/swap.h
> > +F:     mm/swap_table.h
> >  F:     mm/swap_state.c
> >  F:     mm/swapfile.c
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 762f8db0e811..e818fbade1e2 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -480,8 +480,6 @@ extern int __swap_count(swp_entry_t entry);
> >  extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_=
t entry);
> >  extern int swp_swapcount(swp_entry_t entry);
> >  struct backing_dev_info;
> > -extern int init_swap_address_space(unsigned int type, unsigned long nr=
_pages);
> > -extern void exit_swap_address_space(unsigned int type);
> >  extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
> >  sector_t swap_folio_sector(struct folio *folio);
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 4c66e358685b..a9fc7a09167a 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3720,7 +3720,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >         /* Prevent deferred_split_scan() touching ->_refcount */
> >         spin_lock(&ds_queue->split_queue_lock);
> >         if (folio_ref_freeze(folio, 1 + extra_pins)) {
> > -               struct address_space *swap_cache =3D NULL;
> > +               struct swap_cluster_info *ci =3D NULL;
> >                 struct lruvec *lruvec;
> >                 int expected_refs;
> >
> > @@ -3764,8 +3764,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >                                 goto fail;
> >                         }
> >
> > -                       swap_cache =3D swap_address_space(folio->swap);
> > -                       xa_lock(&swap_cache->i_pages);
> > +                       ci =3D swap_cluster_get_and_lock(folio);
> >                 }
> >
> >                 /* lock lru list/PageCompound, ref frozen by page_ref_f=
reeze */
> > @@ -3797,8 +3796,8 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >                          * Anonymous folio with swap cache.
> >                          * NOTE: shmem in swap cache is not supported y=
et.
> >                          */
> > -                       if (swap_cache) {
> > -                               __swap_cache_replace_folio(folio, new_f=
olio);
> > +                       if (ci) {
> > +                               __swap_cache_replace_folio(ci, folio, n=
ew_folio);
> >                                 continue;
> >                         }
> >
> > @@ -3833,8 +3832,8 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >
> >                 unlock_page_lruvec(lruvec);
> >
> > -               if (swap_cache)
> > -                       xa_unlock(&swap_cache->i_pages);
> > +               if (ci)
> > +                       swap_cluster_unlock(ci);
> >         } else {
> >                 spin_unlock(&ds_queue->split_queue_lock);
> >                 ret =3D -EAGAIN;
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index c69cc13db692..946253c39807 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -563,6 +563,7 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
> >                 struct folio *newfolio, struct folio *folio, int expect=
ed_count)
> >  {
> >         XA_STATE(xas, &mapping->i_pages, folio_index(folio));
> > +       struct swap_cluster_info *ci =3D NULL;
> >         struct zone *oldzone, *newzone;
> >         int dirty;
> >         long nr =3D folio_nr_pages(folio);
> > @@ -591,9 +592,16 @@ static int __folio_migrate_mapping(struct address_=
space *mapping,
> >         oldzone =3D folio_zone(folio);
> >         newzone =3D folio_zone(newfolio);
> >
> > -       xas_lock_irq(&xas);
> > +       if (folio_test_swapcache(folio))
> > +               ci =3D swap_cluster_get_and_lock_irq(folio);
> > +       else
> > +               xas_lock_irq(&xas);
> > +
> >         if (!folio_ref_freeze(folio, expected_count)) {
> > -               xas_unlock_irq(&xas);
> > +               if (ci)
> > +                       swap_cluster_unlock(ci);
> > +               else
> > +                       xas_unlock_irq(&xas);
> >                 return -EAGAIN;
> >         }
> >
> > @@ -624,7 +632,7 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
> >         }
> >
> >         if (folio_test_swapcache(folio))
> > -               __swap_cache_replace_folio(folio, newfolio);
> > +               __swap_cache_replace_folio(ci, folio, newfolio);
> >         else
> >                 xas_store(&xas, newfolio);
> >
> > @@ -635,8 +643,11 @@ static int __folio_migrate_mapping(struct address_=
space *mapping,
> >          */
> >         folio_ref_unfreeze(folio, expected_count - nr);
> >
> > -       xas_unlock(&xas);
> >         /* Leave irq disabled to prevent preemption while updating stat=
s */
> > +       if (ci)
> > +               swap_cluster_unlock(ci);
> > +       else
> > +               xas_unlock(&xas);
> >
> >         /*
> >          * If moved to a different zone then also account
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 8930780325da..8147a99a4b07 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2083,9 +2083,9 @@ static int shmem_replace_folio(struct folio **fol=
iop, gfp_t gfp,
> >                                 struct shmem_inode_info *info, pgoff_t =
index,
> >                                 struct vm_area_struct *vma)
> >  {
> > +       struct swap_cluster_info *ci;
> >         struct folio *new, *old =3D *foliop;
> >         swp_entry_t entry =3D old->swap;
> > -       struct address_space *swap_mapping =3D swap_address_space(entry=
);
> >         int nr_pages =3D folio_nr_pages(old);
> >         int error =3D 0;
> >
> > @@ -2116,9 +2116,9 @@ static int shmem_replace_folio(struct folio **fol=
iop, gfp_t gfp,
> >         new->swap =3D entry;
> >         folio_set_swapcache(new);
> >
> > -       xa_lock_irq(&swap_mapping->i_pages);
> > -       __swap_cache_replace_folio(old, new);
> > -       xa_unlock_irq(&swap_mapping->i_pages);
> > +       ci =3D swap_cluster_get_and_lock_irq(old);
> > +       __swap_cache_replace_folio(ci, old, new);
> > +       swap_cluster_unlock(ci);
> >
> >         mem_cgroup_replace_folio(old, new);
> >         shmem_update_stats(new, nr_pages);
> > diff --git a/mm/swap.h b/mm/swap.h
> > index fe579c81c6c4..742db4d46d23 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -2,6 +2,7 @@
> >  #ifndef _MM_SWAP_H
> >  #define _MM_SWAP_H
> >
> > +#include <linux/atomic.h> /* for atomic_long_t */
> >  struct mempolicy;
> >  struct swap_iocb;
> >
> > @@ -35,6 +36,7 @@ struct swap_cluster_info {
> >         u16 count;
> >         u8 flags;
> >         u8 order;
> > +       atomic_long_t *table;   /* Swap table entries, see mm/swap_tabl=
e.h */
> >         struct list_head list;
> >  };
> >
> > @@ -55,6 +57,11 @@ enum swap_cluster_flags {
> >  #include <linux/swapops.h> /* for swp_offset */
> >  #include <linux/blk_types.h> /* for bio_end_io_t */
> >
> > +static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> > +{
> > +       return swp_offset(entry) % SWAPFILE_CLUSTER;
> > +}
> > +
> >  /*
> >   * Callers of all helpers below must ensure the entry, type, or offset=
 is
> >   * valid, and protect the swap device with reference count or locks.
> > @@ -81,6 +88,25 @@ static inline struct swap_cluster_info *__swap_offse=
t_to_cluster(
> >         return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> >  }
> >
> > +static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_en=
try_t entry)
> > +{
> > +       return __swap_offset_to_cluster(__swap_entry_to_info(entry),
> > +                                       swp_offset(entry));
> > +}
> > +
> > +static __always_inline struct swap_cluster_info *__swap_cluster_lock(
> > +               struct swap_info_struct *si, unsigned long offset, bool=
 irq)
> > +{
> > +       struct swap_cluster_info *ci =3D __swap_offset_to_cluster(si, o=
ffset);
> > +
> > +       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with s=
wapoff */
> > +       if (irq)
> > +               spin_lock_irq(&ci->lock);
> > +       else
> > +               spin_lock(&ci->lock);
> > +       return ci;
> > +}
> > +
> >  /**
> >   * swap_cluster_lock - Lock and return the swap cluster of given offse=
t.
> >   * @si: swap device the cluster belongs to.
> > @@ -92,11 +118,49 @@ static inline struct swap_cluster_info *__swap_off=
set_to_cluster(
> >  static inline struct swap_cluster_info *swap_cluster_lock(
> >                 struct swap_info_struct *si, unsigned long offset)
> >  {
> > -       struct swap_cluster_info *ci =3D __swap_offset_to_cluster(si, o=
ffset);
> > +       return __swap_cluster_lock(si, offset, false);
> > +}
> >
> > -       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with s=
wapoff */
> > -       spin_lock(&ci->lock);
> > -       return ci;
> > +static inline struct swap_cluster_info *__swap_cluster_get_and_lock(
> > +               const struct folio *folio, bool irq)
> > +{
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> > +       return __swap_cluster_lock(__swap_entry_to_info(folio->swap),
> > +                                  swp_offset(folio->swap), irq);
> > +}
> > +
> > +/*
> > + * swap_cluster_get_and_lock - Locks the cluster that holds a folio's =
entries.
> > + * @folio: The folio.
> > + *
> > + * This locks and returns the swap cluster that contains a folio's swa=
p
> > + * entries. The swap entries of a folio are always in one single clust=
er.
> > + * The folio has to be locked so its swap entries won't change and the
> > + * cluster won't be freed.
> > + *
> > + * Context: Caller must ensure the folio is locked and in the swap cac=
he.
> > + * Return: Pointer to the swap cluster.
> > + */
> > +static inline struct swap_cluster_info *swap_cluster_get_and_lock(
> > +               const struct folio *folio)
> > +{
> > +       return __swap_cluster_get_and_lock(folio, false);
> > +}
> > +
> > +/*
> > + * swap_cluster_get_and_lock_irq - Locks the cluster that holds a foli=
o's entries.
> > + * @folio: The folio.
> > + *
> > + * Same as swap_cluster_get_and_lock but also disable IRQ.
> > + *
> > + * Context: Caller must ensure the folio is locked and in the swap cac=
he.
> > + * Return: Pointer to the swap cluster.
> > + */
> > +static inline struct swap_cluster_info *swap_cluster_get_and_lock_irq(
> > +               const struct folio *folio)
> > +{
> > +       return __swap_cluster_get_and_lock(folio, true);
> >  }
> >
> >  static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> > @@ -104,6 +168,11 @@ static inline void swap_cluster_unlock(struct swap=
_cluster_info *ci)
> >         spin_unlock(&ci->lock);
> >  }
> >
> > +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *c=
i)
> > +{
> > +       spin_unlock_irq(&ci->lock);
> > +}
> > +
> >  /* linux/mm/page_io.c */
> >  int sio_pool_init(void);
> >  struct swap_iocb;
> > @@ -123,10 +192,11 @@ void __swap_writepage(struct folio *folio, struct=
 swap_iocb **swap_plug);
> >  #define SWAP_ADDRESS_SPACE_SHIFT       14
> >  #define SWAP_ADDRESS_SPACE_PAGES       (1 << SWAP_ADDRESS_SPACE_SHIFT)
> >  #define SWAP_ADDRESS_SPACE_MASK                (SWAP_ADDRESS_SPACE_PAG=
ES - 1)
> > -extern struct address_space *swapper_spaces[];
> > -#define swap_address_space(entry)                          \
> > -       (&swapper_spaces[swp_type(entry)][swp_offset(entry) \
> > -               >> SWAP_ADDRESS_SPACE_SHIFT])
> > +extern struct address_space swap_space;
> > +static inline struct address_space *swap_address_space(swp_entry_t ent=
ry)
> > +{
> > +       return &swap_space;
> > +}
> >
> >  /*
> >   * Return the swap device position of the swap entry.
> > @@ -136,15 +206,6 @@ static inline loff_t swap_dev_pos(swp_entry_t entr=
y)
> >         return ((loff_t)swp_offset(entry)) << PAGE_SHIFT;
> >  }
> >
> > -/*
> > - * Return the swap cache index of the swap entry.
> > - */
> > -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> > -{
> > -       BUILD_BUG_ON((SWP_OFFSET_MASK | SWAP_ADDRESS_SPACE_MASK) !=3D S=
WP_OFFSET_MASK);
> > -       return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
> > -}
> > -
> >  /**
> >   * folio_matches_swap_entry - Check if a folio matches a given swap en=
try.
> >   * @folio: The folio.
> > @@ -180,14 +241,14 @@ static inline bool folio_matches_swap_entry(const=
 struct folio *folio,
> >   */
> >  struct folio *swap_cache_get_folio(swp_entry_t entry);
> >  void *swap_cache_get_shadow(swp_entry_t entry);
> > -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> > -                        gfp_t gfp, void **shadow);
> > +void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void=
 **shadow);
> >  void swap_cache_del_folio(struct folio *folio);
> > -void __swap_cache_del_folio(struct folio *folio,
> > -                           swp_entry_t entry, void *shadow);
> > -void __swap_cache_replace_folio(struct folio *old, struct folio *new);
> > -void swap_cache_clear_shadow(int type, unsigned long begin,
> > -                            unsigned long end);
> > +/* Below helpers require the caller to lock and pass in the swap clust=
er. */
> > +void __swap_cache_del_folio(struct swap_cluster_info *ci,
> > +                           struct folio *folio, swp_entry_t entry, voi=
d *shadow);
> > +void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> > +                               struct folio *old, struct folio *new);
> > +void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
> >
> >  void show_swap_cache_info(void);
> >  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, i=
nt nr);
> > @@ -255,6 +316,32 @@ static inline int non_swapcache_batch(swp_entry_t =
entry, int max_nr)
> >
> >  #else /* CONFIG_SWAP */
> >  struct swap_iocb;
> > +static inline struct swap_cluster_info *swap_cluster_lock(
> > +       struct swap_info_struct *si, pgoff_t offset, bool irq)
> > +{
> > +       return NULL;
> > +}
> > +
> > +static inline struct swap_cluster_info *swap_cluster_get_and_lock(
> > +               struct folio *folio)
> > +{
> > +       return NULL;
> > +}
> > +
> > +static inline struct swap_cluster_info *swap_cluster_get_and_lock_irq(
> > +               struct folio *folio)
> > +{
> > +       return NULL;
> > +}
> > +
> > +static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> > +{
> > +}
> > +
> > +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *c=
i)
> > +{
> > +}
> > +
> >  static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_=
t entry)
> >  {
> >         return NULL;
> > @@ -272,11 +359,6 @@ static inline struct address_space *swap_address_s=
pace(swp_entry_t entry)
> >         return NULL;
> >  }
> >
> > -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> > -{
> > -       return 0;
> > -}
> > -
> >  static inline bool folio_matches_swap_entry(const struct folio *folio,=
 swp_entry_t entry)
> >  {
> >         return false;
> > @@ -323,21 +405,21 @@ static inline void *swap_cache_get_shadow(swp_ent=
ry_t entry)
> >         return NULL;
> >  }
> >
> > -static inline int swap_cache_add_folio(swp_entry_t entry, struct folio=
 *folio,
> > -                                      gfp_t gfp, void **shadow)
> > +static inline void swap_cache_add_folio(struct folio *folio, swp_entry=
_t entry, void **shadow)
> >  {
> > -       return -EINVAL;
> >  }
> >
> >  static inline void swap_cache_del_folio(struct folio *folio)
> >  {
> >  }
> >
> > -static inline void __swap_cache_del_folio(struct folio *folio, swp_ent=
ry_t entry, void *shadow)
> > +static inline void __swap_cache_del_folio(struct swap_cluster_info *ci=
,
> > +               struct folio *folio, swp_entry_t entry, void *shadow)
> >  {
> >  }
> >
> > -static inline void __swap_cache_replace_folio(struct folio *old, struc=
t folio *new)
> > +static inline void __swap_cache_replace_folio(struct swap_cluster_info=
 *ci,
> > +               struct folio *old, struct folio *new)
> >  {
> >  }
> >
> > @@ -371,8 +453,10 @@ static inline int non_swapcache_batch(swp_entry_t =
entry, int max_nr)
> >   */
> >  static inline pgoff_t folio_index(struct folio *folio)
> >  {
> > +#ifdef CONFIG_SWAP
> >         if (unlikely(folio_test_swapcache(folio)))
> > -               return swap_cache_index(folio->swap);
> > +               return swp_offset(folio->swap);
> > +#endif
> >         return folio->index;
> >  }
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index d1f5b8fa52fc..f4a579c23087 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/huge_mm.h>
> >  #include <linux/shmem_fs.h>
> >  #include "internal.h"
> > +#include "swap_table.h"
> >  #include "swap.h"
> >
> >  /*
> > @@ -36,8 +37,10 @@ static const struct address_space_operations swap_ao=
ps =3D {
> >  #endif
> >  };
> >
> > -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > +struct address_space swap_space __read_mostly =3D {
> > +       .a_ops =3D &swap_aops,
> > +};
> > +
> >  static bool enable_vma_readahead __read_mostly =3D true;
> >
> >  #define SWAP_RA_ORDER_CEILING  5
> > @@ -83,11 +86,20 @@ void show_swap_cache_info(void)
> >   */
> >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> >  {
> > -       struct folio *folio =3D filemap_get_folio(swap_address_space(en=
try),
> > -                                               swap_cache_index(entry)=
);
> > -       if (IS_ERR(folio))
> > -               return NULL;
> > -       return folio;
> > +       unsigned long swp_tb;
> > +       struct folio *folio;
> > +
> > +       for (;;) {
> > +               swp_tb =3D __swap_table_get(__swap_entry_to_cluster(ent=
ry),
> > +                                         swp_cluster_offset(entry));
> > +               if (!swp_tb_is_folio(swp_tb))
> > +                       return NULL;
> > +               folio =3D swp_tb_to_folio(swp_tb);
> > +               if (likely(folio_try_get(folio)))
> > +                       return folio;
> > +       }
> > +
> > +       return NULL;
> >  }
> >
> >  /**
> > @@ -100,13 +112,13 @@ struct folio *swap_cache_get_folio(swp_entry_t en=
try)
> >   */
> >  void *swap_cache_get_shadow(swp_entry_t entry)
> >  {
> > -       struct address_space *address_space =3D swap_address_space(entr=
y);
> > -       pgoff_t idx =3D swap_cache_index(entry);
> > -       void *shadow;
> > +       unsigned long swp_tb;
> > +
> > +       swp_tb =3D __swap_table_get(__swap_entry_to_cluster(entry),
> > +                                 swp_cluster_offset(entry));
> > +       if (swp_tb_is_shadow(swp_tb))
> > +               return swp_tb_to_shadow(swp_tb);
> >
> > -       shadow =3D xa_load(&address_space->i_pages, idx);
> > -       if (xa_is_value(shadow))
> > -               return shadow;
> >         return NULL;
> >  }
> >
> > @@ -119,61 +131,48 @@ void *swap_cache_get_shadow(swp_entry_t entry)
> >   *
> >   * Context: Caller must ensure @entry is valid and protect the swap de=
vice
> >   * with reference count or locks.
> > - * The caller also needs to mark the corresponding swap_map slots with
> > - * SWAP_HAS_CACHE to avoid race or conflict.
> > - * Return: Returns 0 on success, error code otherwise.
> > + * The caller also needs to update the corresponding swap_map slots wi=
th
> > + * SWAP_HAS_CACHE bit to avoid race or conflict.
> >   */
> > -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> > -                        gfp_t gfp, void **shadowp)
> > +void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void=
 **shadowp)
> >  {
> > -       struct address_space *address_space =3D swap_address_space(entr=
y);
> > -       pgoff_t idx =3D swap_cache_index(entry);
> > -       XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(f=
olio));
> > -       unsigned long i, nr =3D folio_nr_pages(folio);
> > -       void *old;
> > -
> > -       xas_set_update(&xas, workingset_update_node);
> > -
> > -       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > -       VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> > -       VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
> > +       void *shadow =3D NULL;
> > +       unsigned long old_tb, new_tb;
> > +       struct swap_cluster_info *ci;
> > +       unsigned int ci_start, ci_off, ci_end;
> > +       unsigned long nr_pages =3D folio_nr_pages(folio);
> > +
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> > +
> > +       new_tb =3D folio_to_swp_tb(folio);
> > +       ci_start =3D swp_cluster_offset(entry);
> > +       ci_end =3D ci_start + nr_pages;
> > +       ci_off =3D ci_start;
> > +       ci =3D swap_cluster_lock(__swap_entry_to_info(entry), swp_offse=
t(entry));
> > +       do {
> > +               old_tb =3D __swap_table_xchg(ci, ci_off, new_tb);
> > +               WARN_ON_ONCE(swp_tb_is_folio(old_tb));
> > +               if (swp_tb_is_shadow(old_tb))
> > +                       shadow =3D swp_tb_to_shadow(old_tb);
> > +       } while (++ci_off < ci_end);
> >
> > -       folio_ref_add(folio, nr);
> > +       folio_ref_add(folio, nr_pages);
> >         folio_set_swapcache(folio);
> >         folio->swap =3D entry;
> > +       swap_cluster_unlock(ci);
> >
> > -       do {
> > -               xas_lock_irq(&xas);
> > -               xas_create_range(&xas);
> > -               if (xas_error(&xas))
> > -                       goto unlock;
> > -               for (i =3D 0; i < nr; i++) {
> > -                       VM_BUG_ON_FOLIO(xas.xa_index !=3D idx + i, foli=
o);
> > -                       if (shadowp) {
> > -                               old =3D xas_load(&xas);
> > -                               if (xa_is_value(old))
> > -                                       *shadowp =3D old;
> > -                       }
> > -                       xas_store(&xas, folio);
> > -                       xas_next(&xas);
> > -               }
> > -               address_space->nrpages +=3D nr;
> > -               __node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
> > -               __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
> > -unlock:
> > -               xas_unlock_irq(&xas);
> > -       } while (xas_nomem(&xas, gfp));
> > -
> > -       if (!xas_error(&xas))
> > -               return 0;
> > +       node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> > +       lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> >
> > -       folio_clear_swapcache(folio);
> > -       folio_ref_sub(folio, nr);
> > -       return xas_error(&xas);
> > +       if (shadowp)
> > +               *shadowp =3D shadow;
> >  }
> >
> >  /**
> >   * __swap_cache_del_folio - Removes a folio from the swap cache.
> > + * @ci: The locked swap cluster.
> >   * @folio: The folio.
> >   * @entry: The first swap entry that the folio corresponds to.
> >   * @shadow: shadow value to be filled in the swap cache.
> > @@ -181,34 +180,36 @@ int swap_cache_add_folio(struct folio *folio, swp=
_entry_t entry,
> >   * Removes a folio from the swap cache and fills a shadow in place.
> >   * This won't put the folio's refcount. The caller has to do that.
> >   *
> > - * Context: Caller must hold the xa_lock, ensure the folio is
> > - * locked and in the swap cache, using the index of @entry.
> > + * Context: Caller must ensure the folio is locked and in the swap cac=
he
> > + * using the index of @entry, and lock the cluster that holds the entr=
ies.
> >   */
> > -void __swap_cache_del_folio(struct folio *folio,
> > +void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio=
 *folio,
> >                             swp_entry_t entry, void *shadow)
> >  {
> > -       struct address_space *address_space =3D swap_address_space(entr=
y);
> > -       int i;
> > -       long nr =3D folio_nr_pages(folio);
> > -       pgoff_t idx =3D swap_cache_index(entry);
> > -       XA_STATE(xas, &address_space->i_pages, idx);
> > -
> > -       xas_set_update(&xas, workingset_update_node);
> > -
> > -       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > -       VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
> > -
> > -       for (i =3D 0; i < nr; i++) {
> > -               void *entry =3D xas_store(&xas, shadow);
> > -               VM_BUG_ON_PAGE(entry !=3D folio, entry);
> > -               xas_next(&xas);
> > -       }
> > +       unsigned long old_tb, new_tb;
> > +       unsigned int ci_start, ci_off, ci_end;
> > +       unsigned long nr_pages =3D folio_nr_pages(folio);
> > +
> > +       VM_WARN_ON_ONCE(__swap_entry_to_cluster(entry) !=3D ci);
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
> > +
> > +       new_tb =3D shadow_swp_to_tb(shadow);
> > +       ci_start =3D swp_cluster_offset(entry);
> > +       ci_end =3D ci_start + nr_pages;
> > +       ci_off =3D ci_start;
> > +       do {
> > +               /* If shadow is NULL, we sets an empty shadow */
> > +               old_tb =3D __swap_table_xchg(ci, ci_off, new_tb);
> > +               WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
> > +                            swp_tb_to_folio(old_tb) !=3D folio);
> > +       } while (++ci_off < ci_end);
> > +
> >         folio->swap.val =3D 0;
> >         folio_clear_swapcache(folio);
> > -       address_space->nrpages -=3D nr;
> > -       __node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
> > -       __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
> > +       node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
> > +       lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
> >  }
> >
> >  /**
> > @@ -223,12 +224,12 @@ void __swap_cache_del_folio(struct folio *folio,
> >   */
> >  void swap_cache_del_folio(struct folio *folio)
> >  {
> > +       struct swap_cluster_info *ci;
> >         swp_entry_t entry =3D folio->swap;
> > -       struct address_space *address_space =3D swap_address_space(entr=
y);
> >
> > -       xa_lock_irq(&address_space->i_pages);
> > -       __swap_cache_del_folio(folio, entry, NULL);
> > -       xa_unlock_irq(&address_space->i_pages);
> > +       ci =3D swap_cluster_lock(__swap_entry_to_info(entry), swp_offse=
t(entry));
> > +       __swap_cache_del_folio(ci, folio, entry, NULL);
> > +       swap_cluster_unlock(ci);
> >
> >         put_swap_folio(folio, entry);
> >         folio_ref_sub(folio, folio_nr_pages(folio));
> > @@ -236,6 +237,7 @@ void swap_cache_del_folio(struct folio *folio)
> >
> >  /**
> >   * __swap_cache_replace_folio - Replace a folio in the swap cache.
> > + * @ci: The locked swap cluster.
> >   * @old: The old folio to be replaced.
> >   * @new: The new folio.
> >   *
> > @@ -244,65 +246,62 @@ void swap_cache_del_folio(struct folio *folio)
> >   * entries. Replacement will take the new folio's swap entry value as
> >   * the starting offset to override all slots covered by the new folio.
> >   *
> > - * Context: Caller must ensure both folios are locked, also lock the
> > - * swap address_space that holds the old folio to avoid races.
> > + * Context: Caller must ensure both folios are locked, and lock the
> > + * cluster that holds the old folio to be replaced.
> >   */
> > -void __swap_cache_replace_folio(struct folio *old, struct folio *new)
> > +void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> > +                               struct folio *old, struct folio *new)
> >  {
> >         swp_entry_t entry =3D new->swap;
> >         unsigned long nr_pages =3D folio_nr_pages(new);
> > -       unsigned long offset =3D swap_cache_index(entry);
> > -       unsigned long end =3D offset + nr_pages;
> > -
> > -       XA_STATE(xas, &swap_address_space(entry)->i_pages, offset);
> > +       unsigned int ci_off =3D swp_cluster_offset(entry);
> > +       unsigned int ci_end =3D ci_off + nr_pages;
> > +       unsigned long old_tb, new_tb;
> >
> >         VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapc=
ache(new));
> >         VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(n=
ew));
> >         VM_WARN_ON_ONCE(!entry.val);
> >
> >         /* Swap cache still stores N entries instead of a high-order en=
try */
> > +       new_tb =3D folio_to_swp_tb(new);
> >         do {
> > -               WARN_ON_ONCE(xas_store(&xas, new) !=3D old);
> > -               xas_next(&xas);
> > -       } while (++offset < end);
> > +               old_tb =3D __swap_table_xchg(ci, ci_off, new_tb);
> > +               WARN_ON_ONCE(!swp_tb_is_folio(old_tb) || swp_tb_to_foli=
o(old_tb) !=3D old);
> > +       } while (++ci_off < ci_end);
> > +
> > +       /*
> > +        * If the old folio is partially replaced (e.g., splitting a la=
rge
> > +        * folio, the old folio is shrunk, and new split sub folios rep=
lace
> > +        * the shrunk part), ensure the new folio doesn't overlap it.
> > +        */
> > +       if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> > +           folio_order(old) !=3D folio_order(new)) {
> > +               ci_off =3D swp_cluster_offset(old->swap);
> > +               ci_end =3D ci_off + folio_nr_pages(old);
> > +               while (ci_off++ < ci_end)
> > +                       WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(c=
i, ci_off)) !=3D old);
> > +       }
> >  }
> >
> >  /**
> >   * swap_cache_clear_shadow - Clears a set of shadows in the swap cache=
.
> > - * @type: Indicates the swap device.
> > - * @begin: Beginning offset of the range.
> > - * @end: Ending offset of the range.
> > + * @entry: The starting index entry.
> > + * @nr_ents: How many slots need to be cleared.
> >   *
> > - * Context: Caller must ensure the range is valid and hold a reference=
 to
> > - * the swap device.
> > + * Context: Caller must ensure the range is valid, not occupied by,
> > + * any folio and protect the swap device with reference count or locks=
.
> >   */
> > -void swap_cache_clear_shadow(int type, unsigned long begin,
> > -                            unsigned long end)
> > +void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
> >  {
> > -       unsigned long curr =3D begin;
> > -       void *old;
> > -
> > -       for (;;) {
> > -               swp_entry_t entry =3D swp_entry(type, curr);
> > -               unsigned long index =3D curr & SWAP_ADDRESS_SPACE_MASK;
> > -               struct address_space *address_space =3D swap_address_sp=
ace(entry);
> > -               XA_STATE(xas, &address_space->i_pages, index);
> > -
> > -               xas_set_update(&xas, workingset_update_node);
> > -
> > -               xa_lock_irq(&address_space->i_pages);
> > -               xas_for_each(&xas, old, min(index + (end - curr), SWAP_=
ADDRESS_SPACE_PAGES)) {
> > -                       if (!xa_is_value(old))
> > -                               continue;
> > -                       xas_store(&xas, NULL);
> > -               }
> > -               xa_unlock_irq(&address_space->i_pages);
> > +       struct swap_cluster_info *ci =3D __swap_entry_to_cluster(entry)=
;
> > +       unsigned int ci_off =3D swp_cluster_offset(entry), ci_end;
> > +       unsigned long old;
> >
> > -               /* search the next swapcache until we meet end */
> > -               curr =3D ALIGN((curr + 1), SWAP_ADDRESS_SPACE_PAGES);
> > -               if (curr > end)
> > -                       break;
> > -       }
> > +       ci_end =3D ci_off + nr_ents;
> > +       do {
> > +               old =3D __swap_table_xchg(ci, ci_off, null_to_swp_tb())=
;
> > +               WARN_ON_ONCE(swp_tb_is_folio(old));
> > +       } while (++ci_off < ci_end);
> >  }
> >
> >  /*
> > @@ -482,10 +481,7 @@ struct folio *__read_swap_cache_async(swp_entry_t =
entry, gfp_t gfp_mask,
> >         if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, e=
ntry))
> >                 goto fail_unlock;
> >
> > -       /* May fail (-ENOMEM) if XArray node allocation failed. */
> > -       if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLA=
IM_MASK, &shadow))
> > -               goto fail_unlock;
> > -
> > +       swap_cache_add_folio(new_folio, entry, &shadow);
> >         memcg1_swapin(entry, 1);
> >
> >         if (shadow)
> > @@ -677,41 +673,6 @@ struct folio *swap_cluster_readahead(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >         return folio;
> >  }
> >
> > -int init_swap_address_space(unsigned int type, unsigned long nr_pages)
> > -{
> > -       struct address_space *spaces, *space;
> > -       unsigned int i, nr;
> > -
> > -       nr =3D DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
> > -       spaces =3D kvcalloc(nr, sizeof(struct address_space), GFP_KERNE=
L);
> > -       if (!spaces)
> > -               return -ENOMEM;
> > -       for (i =3D 0; i < nr; i++) {
> > -               space =3D spaces + i;
> > -               xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
> > -               atomic_set(&space->i_mmap_writable, 0);
> > -               space->a_ops =3D &swap_aops;
> > -               /* swap cache doesn't use writeback related tags */
> > -               mapping_set_no_writeback_tags(space);
> > -       }
> > -       nr_swapper_spaces[type] =3D nr;
> > -       swapper_spaces[type] =3D spaces;
> > -
> > -       return 0;
> > -}
> > -
> > -void exit_swap_address_space(unsigned int type)
> > -{
> > -       int i;
> > -       struct address_space *spaces =3D swapper_spaces[type];
> > -
> > -       for (i =3D 0; i < nr_swapper_spaces[type]; i++)
> > -               VM_WARN_ON_ONCE(!mapping_empty(&spaces[i]));
> > -       kvfree(spaces);
> > -       nr_swapper_spaces[type] =3D 0;
> > -       swapper_spaces[type] =3D NULL;
> > -}
> > -
> >  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
> >                            unsigned long *end)
> >  {
> > @@ -884,7 +845,7 @@ static const struct attribute_group swap_attr_group=
 =3D {
> >         .attrs =3D swap_attrs,
> >  };
> >
> > -static int __init swap_init_sysfs(void)
> > +static int __init swap_init(void)
> >  {
> >         int err;
> >         struct kobject *swap_kobj;
> > @@ -899,11 +860,13 @@ static int __init swap_init_sysfs(void)
> >                 pr_err("failed to register swap group\n");
> >                 goto delete_obj;
> >         }
> > +       /* Swap cache writeback is LRU based, no tags for it */
> > +       mapping_set_no_writeback_tags(&swap_space);
> >         return 0;
> >
> >  delete_obj:
> >         kobject_put(swap_kobj);
> >         return err;
> >  }
> > -subsys_initcall(swap_init_sysfs);
> > +subsys_initcall(swap_init);
> >  #endif
> > diff --git a/mm/swap_table.h b/mm/swap_table.h
> > new file mode 100644
> > index 000000000000..e1f7cc009701
> > --- /dev/null
> > +++ b/mm/swap_table.h
> > @@ -0,0 +1,97 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _MM_SWAP_TABLE_H
> > +#define _MM_SWAP_TABLE_H
> > +
> > +#include "swap.h"
> > +
> > +/*
> > + * A swap table entry represents the status of a swap slot on a swap
> > + * (physical or virtual) device. The swap table in each cluster is a
> > + * 1:1 map of the swap slots in this cluster.
> > + *
> > + * Each swap table entry could be a pointer (folio), a XA_VALUE
> > + * (shadow), or NULL.
> > + */
> > +
> > +/*
> > + * Helpers for casting one type of info into a swap table entry.
> > + */
> > +static inline unsigned long null_to_swp_tb(void)
> > +{
> > +       BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(atomic_long_t));
> > +       return 0;
> > +}
> > +
> > +static inline unsigned long folio_to_swp_tb(struct folio *folio)
> > +{
> > +       BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(void *));
> > +       return (unsigned long)folio;
> > +}
> > +
> > +static inline unsigned long shadow_swp_to_tb(void *shadow)
> > +{
> > +       BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=3D
> > +                    BITS_PER_BYTE * sizeof(unsigned long));
> > +       VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
> > +       return (unsigned long)shadow;
> > +}
> > +
> > +/*
> > + * Helpers for swap table entry type checking.
> > + */
> > +static inline bool swp_tb_is_null(unsigned long swp_tb)
> > +{
> > +       return !swp_tb;
> > +}
> > +
> > +static inline bool swp_tb_is_folio(unsigned long swp_tb)
> > +{
> > +       return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
> > +}
> > +
> > +static inline bool swp_tb_is_shadow(unsigned long swp_tb)
> > +{
> > +       return xa_is_value((void *)swp_tb);
> > +}
> > +
> > +/*
> > + * Helpers for retrieving info from swap table.
> > + */
> > +static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
> > +{
> > +       VM_WARN_ON(!swp_tb_is_folio(swp_tb));
> > +       return (void *)swp_tb;
> > +}
> > +
> > +static inline void *swp_tb_to_shadow(unsigned long swp_tb)
> > +{
> > +       VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
> > +       return (void *)swp_tb;
> > +}
> > +
> > +/*
> > + * Helpers for accessing or modifying the swap table of a cluster,
> > + * the swap cluster must be locked.
> > + */
> > +static inline void __swap_table_set(struct swap_cluster_info *ci,
> > +                                   unsigned int off, unsigned long swp=
_tb)
> > +{
> > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +       atomic_long_set(&ci->table[off], swp_tb);
> > +}
> > +
> > +static inline unsigned long __swap_table_xchg(struct swap_cluster_info=
 *ci,
> > +                                             unsigned int off, unsigne=
d long swp_tb)
> > +{
> > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +       /* Ordering is guaranteed by cluster lock, relax */
> > +       return atomic_long_xchg_relaxed(&ci->table[off], swp_tb);
> > +}
> > +
> > +static inline unsigned long __swap_table_get(struct swap_cluster_info =
*ci,
> > +                                            unsigned int off)
> > +{
> > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +       return atomic_long_read(&ci->table[off]);
> > +}
> > +#endif
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 6f5206255789..a81ada4a361d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -46,6 +46,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <linux/swapops.h>
> >  #include <linux/swap_cgroup.h>
> > +#include "swap_table.h"
> >  #include "internal.h"
> >  #include "swap.h"
> >
> > @@ -420,6 +421,34 @@ static inline unsigned int cluster_offset(struct s=
wap_info_struct *si,
> >         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
> >  }
> >
> > +static int swap_cluster_alloc_table(struct swap_cluster_info *ci)
> > +{
> > +       WARN_ON(ci->table);
> > +       ci->table =3D kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER,=
 GFP_KERNEL);
> > +       if (!ci->table)
> > +               return -ENOMEM;
> > +       return 0;
> > +}
> > +
> > +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> > +{
> > +       unsigned int ci_off;
> > +       unsigned long swp_tb;
> > +
> > +       if (!ci->table)
> > +               return;
> > +
> > +       for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> > +               swp_tb =3D __swap_table_get(ci, ci_off);
> > +               if (!swp_tb_is_null(swp_tb))
> > +                       pr_err_once("swap: unclean swap space on swapof=
f: 0x%lx",
> > +                                   swp_tb);
> > +       }
> > +
> > +       kfree(ci->table);
> > +       ci->table =3D NULL;
> > +}
> > +
> >  static void move_cluster(struct swap_info_struct *si,
> >                          struct swap_cluster_info *ci, struct list_head=
 *list,
> >                          enum swap_cluster_flags new_flags)
> > @@ -702,6 +731,26 @@ static bool cluster_scan_range(struct swap_info_st=
ruct *si,
> >         return true;
> >  }
> >
> > +/*
> > + * Currently, the swap table is not used for count tracking, just
> > + * do a sanity check here to ensure nothing leaked, so the swap
> > + * table should be empty upon freeing.
> > + */
> > +static void swap_cluster_assert_table_empty(struct swap_cluster_info *=
ci,
> > +                               unsigned int start, unsigned int nr)
> > +{
> > +       unsigned int ci_off =3D start % SWAPFILE_CLUSTER;
> > +       unsigned int ci_end =3D ci_off + nr;
> > +       unsigned long swp_tb;
> > +
> > +       if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> > +               do {
> > +                       swp_tb =3D __swap_table_get(ci, ci_off);
> > +                       VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
> > +               } while (++ci_off < ci_end);
> > +       }
> > +}
> > +
> >  static bool cluster_alloc_range(struct swap_info_struct *si, struct sw=
ap_cluster_info *ci,
> >                                 unsigned int start, unsigned char usage=
,
> >                                 unsigned int order)
> > @@ -721,6 +770,7 @@ static bool cluster_alloc_range(struct swap_info_st=
ruct *si, struct swap_cluster
> >                 ci->order =3D order;
> >
> >         memset(si->swap_map + start, usage, nr_pages);
> > +       swap_cluster_assert_table_empty(ci, start, nr_pages);
> >         swap_range_alloc(si, nr_pages);
> >         ci->count +=3D nr_pages;
> >
> > @@ -1123,7 +1173,7 @@ static void swap_range_free(struct swap_info_stru=
ct *si, unsigned long offset,
> >                         swap_slot_free_notify(si->bdev, offset);
> >                 offset++;
> >         }
> > -       swap_cache_clear_shadow(si->type, begin, end);
> > +       __swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entrie=
s);
> >
> >         /*
> >          * Make sure that try_to_unuse() observes si->inuse_pages reach=
ing 0
> > @@ -1280,16 +1330,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t =
gfp)
> >         if (!entry.val)
> >                 return -ENOMEM;
> >
> > -       /*
> > -        * XArray node allocations from PF_MEMALLOC contexts could
> > -        * completely exhaust the page allocator. __GFP_NOMEMALLOC
> > -        * stops emergency reserves from being allocated.
> > -        *
> > -        * TODO: this could cause a theoretical memory reclaim
> > -        * deadlock in the swap out path.
> > -        */
> > -       if (swap_cache_add_folio(folio, entry, gfp | __GFP_NOMEMALLOC, =
NULL))
> > -               goto out_free;
> > +       swap_cache_add_folio(folio, entry, NULL);
> >
> >         return 0;
> >
> > @@ -1555,6 +1596,7 @@ static void swap_entries_free(struct swap_info_st=
ruct *si,
> >
> >         mem_cgroup_uncharge_swap(entry, nr_pages);
> >         swap_range_free(si, offset, nr_pages);
> > +       swap_cluster_assert_table_empty(ci, offset, nr_pages);
> >
> >         if (!ci->count)
> >                 free_cluster(si, ci);
> > @@ -2633,6 +2675,18 @@ static void wait_for_allocation(struct swap_info=
_struct *si)
> >         }
> >  }
> >
> > +static void free_cluster_info(struct swap_cluster_info *cluster_info,
> > +                             unsigned long maxpages)
> > +{
> > +       int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER)=
;
> > +
> > +       if (!cluster_info)
> > +               return;
> > +       for (i =3D 0; i < nr_clusters; i++)
> > +               swap_cluster_free_table(&cluster_info[i]);
> > +       kvfree(cluster_info);
> > +}
> > +
> >  /*
> >   * Called after swap device's reference count is dead, so
> >   * neither scan nor allocation will use it.
> > @@ -2767,12 +2821,13 @@ SYSCALL_DEFINE1(swapoff, const char __user *, s=
pecialfile)
> >
> >         swap_file =3D p->swap_file;
> >         p->swap_file =3D NULL;
> > -       p->max =3D 0;
> >         swap_map =3D p->swap_map;
> >         p->swap_map =3D NULL;
> >         zeromap =3D p->zeromap;
> >         p->zeromap =3D NULL;
> >         cluster_info =3D p->cluster_info;
> > +       free_cluster_info(cluster_info, p->max);
> > +       p->max =3D 0;
> >         p->cluster_info =3D NULL;
> >         spin_unlock(&p->lock);
> >         spin_unlock(&swap_lock);
> > @@ -2783,10 +2838,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, sp=
ecialfile)
> >         p->global_cluster =3D NULL;
> >         vfree(swap_map);
> >         kvfree(zeromap);
> > -       kvfree(cluster_info);
> >         /* Destroy swap account information */
> >         swap_cgroup_swapoff(p->type);
> > -       exit_swap_address_space(p->type);
> >
> >         inode =3D mapping->host;
> >
> > @@ -3170,8 +3223,11 @@ static struct swap_cluster_info *setup_clusters(=
struct swap_info_struct *si,
> >         if (!cluster_info)
> >                 goto err;
> >
> > -       for (i =3D 0; i < nr_clusters; i++)
> > +       for (i =3D 0; i < nr_clusters; i++) {
> >                 spin_lock_init(&cluster_info[i].lock);
> > +               if (swap_cluster_alloc_table(&cluster_info[i]))
> > +                       goto err_free;
> > +       }
> >
> >         if (!(si->flags & SWP_SOLIDSTATE)) {
> >                 si->global_cluster =3D kmalloc(sizeof(*si->global_clust=
er),
> > @@ -3232,9 +3288,8 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
> >         }
> >
> >         return cluster_info;
> > -
> >  err_free:
> > -       kvfree(cluster_info);
> > +       free_cluster_info(cluster_info, maxpages);
> >  err:
> >         return ERR_PTR(err);
> >  }
> > @@ -3428,13 +3483,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, spe=
cialfile, int, swap_flags)
> >                 }
> >         }
> >
> > -       error =3D init_swap_address_space(si->type, maxpages);
> > -       if (error)
> > -               goto bad_swap_unlock_inode;
> > -
> >         error =3D zswap_swapon(si->type, maxpages);
> >         if (error)
> > -               goto free_swap_address_space;
> > +               goto bad_swap_unlock_inode;
> >
> >         /*
> >          * Flush any pending IO and dirty mappings before we start usin=
g this
> > @@ -3469,8 +3520,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
> >         goto out;
> >  free_swap_zswap:
> >         zswap_swapoff(si->type);
> > -free_swap_address_space:
> > -       exit_swap_address_space(si->type);
> >  bad_swap_unlock_inode:
> >         inode_unlock(inode);
> >  bad_swap:
> > @@ -3485,7 +3534,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
> >         spin_unlock(&swap_lock);
> >         vfree(swap_map);
> >         kvfree(zeromap);
> > -       kvfree(cluster_info);
> > +       if (cluster_info)
> > +               free_cluster_info(cluster_info, maxpages);
> >         if (inced_nr_rotate_swap)
> >                 atomic_dec(&nr_rotate_swap);
> >         if (swap_file)
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index c79c6806560b..e170c12e2065 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -730,13 +730,18 @@ static int __remove_mapping(struct address_space =
*mapping, struct folio *folio,
> >  {
> >         int refcount;
> >         void *shadow =3D NULL;
> > +       struct swap_cluster_info *ci;
> >
> >         BUG_ON(!folio_test_locked(folio));
> >         BUG_ON(mapping !=3D folio_mapping(folio));
> >
> > -       if (!folio_test_swapcache(folio))
> > +       if (folio_test_swapcache(folio)) {
> > +               ci =3D swap_cluster_get_and_lock_irq(folio);
> > +       } else {
> >                 spin_lock(&mapping->host->i_lock);
> > -       xa_lock_irq(&mapping->i_pages);
> > +               xa_lock_irq(&mapping->i_pages);
> > +       }
> > +
> >         /*
> >          * The non racy check for a busy folio.
> >          *
> > @@ -776,9 +781,9 @@ static int __remove_mapping(struct address_space *m=
apping, struct folio *folio,
> >
> >                 if (reclaimed && !mapping_exiting(mapping))
> >                         shadow =3D workingset_eviction(folio, target_me=
mcg);
> > -               __swap_cache_del_folio(folio, swap, shadow);
> > +               __swap_cache_del_folio(ci, folio, swap, shadow);
> >                 memcg1_swapout(folio, swap);
> > -               xa_unlock_irq(&mapping->i_pages);
> > +               swap_cluster_unlock_irq(ci);
> >                 put_swap_folio(folio, swap);
> >         } else {
> >                 void (*free_folio)(struct folio *);
> > @@ -816,9 +821,12 @@ static int __remove_mapping(struct address_space *=
mapping, struct folio *folio,
> >         return 1;
> >
> >  cannot_free:
> > -       xa_unlock_irq(&mapping->i_pages);
> > -       if (!folio_test_swapcache(folio))
> > +       if (folio_test_swapcache(folio)) {
> > +               swap_cluster_unlock_irq(ci);
> > +       } else {
> > +               xa_unlock_irq(&mapping->i_pages);
> >                 spin_unlock(&mapping->host->i_lock);
> > +       }
> >         return 0;
> >  }
> >
> > --
> > 2.51.0
> >
> >


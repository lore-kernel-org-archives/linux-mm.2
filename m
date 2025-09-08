Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062DCCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FCB8E0012; Mon,  8 Sep 2025 05:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600748E0001; Mon,  8 Sep 2025 05:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF1B8E0012; Mon,  8 Sep 2025 05:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 352468E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:29:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E254D1DF869
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:29:06 +0000 (UTC)
X-FDA: 83865559092.22.A998995
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1072A4000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:29:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2BPIuCz;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ooin1G88GdZ0+3wSDhxUHtkMqwER0rPq5jXYI5jvdI=;
	b=SoGLYZg1KihrXracKifW3SW1xjG08TYshnqARheVvZeDMgIJkDpliMeeE7hVNvjf4/NonF
	zSGOIKX/wQyyBbJquOK/5vxi2CPcVMOME6Uoj4te1artireCJY6NXPYePTOBODiJXYfbrZ
	3PclNxtyAhzPt+iD7JPGm8NOmPiu3qw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2BPIuCz;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323745; a=rsa-sha256;
	cv=none;
	b=Lpvw8S8iAkYZ+vKlz/s2G4R0WLPFs6oqOu+XB9naWtNbKnO+CojbS6YSduGXxE9hNiX1b5
	1Pirsu2ED/8cfxu/pe7WdNJrcyBB21dVP/7JqqoUDfgqCf/G5lOS8dl+zhQGNUk5Y4nfB2
	EJ5aR1tDofwz05DXoVoo2BRNXgwrC84=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso7291960a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757323743; x=1757928543; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ooin1G88GdZ0+3wSDhxUHtkMqwER0rPq5jXYI5jvdI=;
        b=A2BPIuCzbdVr9pBxeY4mexZzjqZQCunCK3fE9OWXB2IWw9KU/FLQrkb3pZl0x9Tjed
         hqvjxEIcadAQWKEd40MxX6qUhCzE5X7xRoxr7jM7eXYCmxyriYWmP7xIv3ppE7+qkWeM
         0snFwMsTMyp1ggCOcNBiu9iiS/MUa8rGYJOOF+kAuaCwh7gANzMeeczvp6wKpwL4obTk
         nxY+QXPzoFlvtTyaef+DRc4Se8iCkaghhooOeVoFblc6ofQSUHDpvySTrtktsgdoFKX3
         GTm1i0sdacicd7IGu5xpHELdgSadUe7WPkf5sL2bziNLaqQWmySbxygcG5GtocqiUQeA
         u3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757323743; x=1757928543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Ooin1G88GdZ0+3wSDhxUHtkMqwER0rPq5jXYI5jvdI=;
        b=adH0k1bL7VE14A3CLox4larrNK6ErFZ04rRSvjlt1gVSFYUFu0gTbKYeyoxIJqZiwc
         khlLZbOApQE7Dfp/AEJ/hiPAgQ+B+I8IAo4x46hBHIMm9izlhE6rTfjVZ85zVPOg2TDw
         UPHJ3gB+07iY3kN9Lnrz1dU4tOS65UHAHWT3XL/+g1+sM9mf461q9Xal/o3rAccsJ80s
         9gozhUF4zHVzRLqiPaOOEuzcw5c3TSrohofxZHoYvguDPhljgaRTq1VTq8zXs8+ehlv8
         Uu05calYnFLOGl12rtPh5DiVu5vGv+Gi8OVeTgz2jGZrsq8SxAvJvMqFOwUshbyko+5S
         q0kg==
X-Gm-Message-State: AOJu0YyOr/Z4e/i/86oQ6OjHPybUr9nczs0VwcDAHChDwgrH2qDz0BFZ
	Kj6KAYle9nvBy9N1PRb2Z1kuqAjKQRwI7NHPYEMoEDa/O4Uo4/12w780ohtih/yrjfk0y3phFaO
	xyuXXcJY9yKeylLnioxjTGUHkt7PKo0Y=
X-Gm-Gg: ASbGncsfktU+0tQl1vnuknoU/KLHDsOmgBe3Z59hHYOqIw+A2oZYZcxWNM2KDj6jW2Y
	Jt+63t/SaFfWAIthre5/d3WijmiZ5oqPQ09BuwjO2HULUvS2MmstGT6RsN4Bf0t2oCaPiAVRTWR
	hx93CI+iwcB9s5kBChO5uNjXddfrwHGc4t1E5rr8fIp/CnbDaVKHxMBJ0/uEnAH5PierzyDREZu
	7Lr3FnyumvBxgtRwqH0PA==
X-Google-Smtp-Source: AGHT+IEOq1WZvNp7RsZJzT2joT2V7EGbKS0rr1lEaYYRTxNqeng2QJ7n+ufynse4ZchY5MrJtEMb73i93D4BHKB+qzk=
X-Received: by 2002:a05:6402:1eca:b0:627:4ee2:311b with SMTP id
 4fb4d7f45d1cf-6274ee234c9mr4021795a12.10.1757323743116; Mon, 08 Sep 2025
 02:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-9-ryncsn@gmail.com>
 <1ee09786-ed3c-485e-99e4-48c4d2b92ced@linux.alibaba.com>
In-Reply-To: <1ee09786-ed3c-485e-99e4-48c4d2b92ced@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 17:28:25 +0800
X-Gm-Features: AS18NWBOELUCiaRBWWIvM9ECMaTp2eBhzWUmPrmjMqEJtKCwjrbscaUw6f9dQlg
Message-ID: <CAMgjq7DPgUNT41pS+591UUR2TfR5pCrABD8y6CKWF-ENpPBN0g@mail.gmail.com>
Subject: Re: [PATCH v2 08/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1072A4000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1pjnp179drjnhidxhjniu79wkr5e9m3u
X-HE-Tag: 1757323744-980388
X-HE-Meta: U2FsdGVkX1+81Qkx4R1MjEVeeEjeC3bput13PZRaezbJ481DDHbhIfDEpZRaPrO55tWbdeoW7kipVpQKpQ+L3d/Xvde0MlfLuXjm//pfYef5/Cq+geJZH+/kpFGzX3mFRxax3bBuxJgQvbiGgYK3OsdWohrgrT8fRRSGkFsY/1XGjsna/onNuF9hDlibDLRK6oZ7SSQyxAHtFSH2J94B7K5BveOMB9U4hwnw6i1ySZZqkEDxJM26pl6Z8q72/OdkTPypDQ0vIZI7RvFI/DZ1oKvJICQWKfNiu0yn4kFkmG0hWJM6FQAFBecVrGnvn3Qy/R1I/jM2GvlN5b/+tuyUeQPADowjvQlosqijJU9Ae3pxLl2H5vZMpLR/5ppRqIrC9VmI4jQXje1DR6ZZbgJ1d7mZO9kgxVkzuSGnU3PAUU5mokTQHtQTCxZaXFvyfGdBr3+CnR08RCcSV4Hb13OAsa33SLtQnJrNeF+Y7nh5LtIfV64sdhy4QL9CCSDbSioBWoxRJbyTo5v42+jFxNJz0L/GeUVcKLSWM/mH70J0CkORFcYbqxOuQTEFdESxw5QbgSjv+VEQwcyHM9rFoDRxzqHZth+NdVIl0HmeGqV+A/hBWJO0vf8jcNqb0RMypv3sGAKF8Sp79Oxq2KHww6IDdLZW6jPfyIoUEUBAGSZfeoxJnk1Jxa24ySe8j/HdP6vMacPcCCkY66xxB/ozI1/bLosDN9IBx50RSVs0an6Dg6d6u3hmVccOf+Vo1fA3BsISSZ3ilNMWBv6U2hXoairz2u9aZ4WkaIiMXrOcDhObO5oDMsTmXv6kYqA7sRviC/LowGh8gjgSQ5APB3YnDX3pqSSXsY+jKlFbL4tCk2wYeIxu2nSnvt425TuhtuJxUWyrKf3SfbHI5E+31J3ZbWgs6QOnn8yZ5bBFeb5cZ/I8USm6GpcX2vn9dw8XzgMAXIJzjTeOTVgkcjk0EJRSLDH
 3sGRI2b3
 WPB8YBL6HVAYzITtiUikanZwbUhQYj7ut+ojlu6aToV+IWcqmdhvwJxOASFyQsBUKEuDXSQOs6Che5gD6suuEIqVNfIEWkjVkbMQCzdNWTb4CYQA+/kvjzlXdIagUo0D0Nx0DPmn4UMd04pttBwvKptgfCMQ5h51X4STMNMuVNFqIXImiti3dKrunuodyMgRzW8iwBh609aKHqd61mJLFAiRPNExWsuLfloraOTdkdku9XA5yf2W4miJG1E1RamKjVLTEGpmAahyane4t+pd6A4O3c5abYPZItqhZ67qCJS2zhHKGz36g9mj8gxpZupk4yHsE3chQxpJAg3ExvN2cauReVqHoLcieAVA38Zf7xiISMQx4L1kQCK2tTaevsUV9JvwFz9VLTNncBPprGPSk7nHiiMUvC5tbud8AZpKQAZInpHY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 2:04=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/9/6 03:13, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Shmem may replace a folio in the swap cache if the cached one doesn't
> > fit the swapin's GFP zone. When doing so, shmem has already double
> > checked that the swap cache folio is locked, still has the swap cache
> > flag set, and contains the wanted swap entry. So it is impossible to
> > fail due to an Xarray mismatch. There is even a comment for that.
> >
> > Delete the defensive error handling path, and add a WARN_ON instead:
> > if that happened, something has broken the basic principle of how the
> > swap cache works, we should catch and fix that.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > ---
> >   mm/shmem.c | 42 ++++++++++++------------------------------
> >   1 file changed, 12 insertions(+), 30 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 4e27e8e5da3b..cc6a0007c7a6 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1698,13 +1698,13 @@ int shmem_writeout(struct folio *folio, struct =
swap_iocb **plug,
> >               }
> >
> >               /*
> > -              * The delete_from_swap_cache() below could be left for
> > +              * The swap_cache_del_folio() below could be left for
> >                * shrink_folio_list()'s folio_free_swap() to dispose of;
> >                * but I'm a little nervous about letting this folio out =
of
> >                * shmem_writeout() in a hybrid half-tmpfs-half-swap stat=
e
> >                * e.g. folio_mapping(folio) might give an unexpected ans=
wer.
> >                */
> > -             delete_from_swap_cache(folio);
> > +             swap_cache_del_folio(folio);
> >               goto redirty;
> >       }
>
> You should reorganize your patch set, as the swap_cache_del_folio()
> function is introduced in patch 9.
>
> >       if (nr_pages > 1)
> > @@ -2082,7 +2082,7 @@ static struct folio *shmem_swap_alloc_folio(struc=
t inode *inode,
> >       new->swap =3D entry;
> >
> >       memcg1_swapin(entry, nr_pages);
> > -     shadow =3D get_shadow_from_swap_cache(entry);
> > +     shadow =3D swap_cache_get_shadow(entry);
>
> Ditto.
>
> >       if (shadow)
> >               workingset_refault(new, shadow);
> >       folio_add_lru(new);
> > @@ -2158,35 +2158,17 @@ static int shmem_replace_folio(struct folio **f=
oliop, gfp_t gfp,
> >       /* Swap cache still stores N entries instead of a high-order entr=
y */
> >       xa_lock_irq(&swap_mapping->i_pages);
> >       for (i =3D 0; i < nr_pages; i++) {
> > -             void *item =3D xas_load(&xas);
> > -
> > -             if (item !=3D old) {
> > -                     error =3D -ENOENT;
> > -                     break;
> > -             }
> > -
> > -             xas_store(&xas, new);
> > +             WARN_ON_ONCE(xas_store(&xas, new));
> >               xas_next(&xas);
> >       }
> > -     if (!error) {
> > -             mem_cgroup_replace_folio(old, new);
> > -             shmem_update_stats(new, nr_pages);
> > -             shmem_update_stats(old, -nr_pages);
> > -     }
> >       xa_unlock_irq(&swap_mapping->i_pages);
> >
> > -     if (unlikely(error)) {
> > -             /*
> > -              * Is this possible?  I think not, now that our callers
> > -              * check both the swapcache flag and folio->private
> > -              * after getting the folio lock; but be defensive.
> > -              * Reverse old to newpage for clear and free.
> > -              */
> > -             old =3D new;
> > -     } else {
> > -             folio_add_lru(new);
> > -             *foliop =3D new;
> > -     }
> > +     mem_cgroup_replace_folio(old, new);
> > +     shmem_update_stats(new, nr_pages);
> > +     shmem_update_stats(old, -nr_pages);
> > +
> > +     folio_add_lru(new);
> > +     *foliop =3D new;
> >
> >       folio_clear_swapcache(old);
> >       old->private =3D NULL;
> > @@ -2220,7 +2202,7 @@ static void shmem_set_folio_swapin_error(struct i=
node *inode, pgoff_t index,
> >       nr_pages =3D folio_nr_pages(folio);
> >       folio_wait_writeback(folio);
> >       if (!skip_swapcache)
> > -             delete_from_swap_cache(folio);
> > +             swap_cache_del_folio(folio);
> >       /*
> >        * Don't treat swapin error folio as alloced. Otherwise inode->i_=
blocks
> >        * won't be 0 when inode is released and thus trigger WARN_ON(i_b=
locks)
> > @@ -2459,7 +2441,7 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >               folio->swap.val =3D 0;
> >               swapcache_clear(si, swap, nr_pages);
> >       } else {
> > -             delete_from_swap_cache(folio);
> > +             swap_cache_del_folio(folio);

Oh you are right, or I should keep the delete_from_swap_cache here.

Let me just rebase and move this patch later then. Thanks!

> >       }
> >       folio_mark_dirty(folio);
> >       swap_free_nr(swap, nr_pages);
>
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B931EC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 17:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364DD6B008A; Mon, 21 Jul 2025 13:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEDD6B008C; Mon, 21 Jul 2025 13:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B68C6B0092; Mon, 21 Jul 2025 13:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 027486B008A
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:55:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A129A1D6FCE
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 17:55:29 +0000 (UTC)
X-FDA: 83689023978.21.65ABA02
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACF8480008
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 17:55:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hWAKLyey;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753120527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrkuuoMFnjNnyN4EGKSAvsjDnC4VRrZnL1lKzFulqZo=;
	b=a57pyDsECU+3yH1rSpDeWVYgrIucZVOuyZitYBEKJE+SZp6ROHfprFJ3Ck8nqObx75Zykd
	5TlYomRp0hyS8/7OwdLebcc6oF7YrK5WrcS4HJVYtqIjX+RAZCdaLVgS37HP5tmR0pQeek
	G5/hTO3VdLdo8kKqtWNIfWW3prgRVFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753120527; a=rsa-sha256;
	cv=none;
	b=RivEfR5VyEqnmoO3d10jN00bxAhZkwFO/AkeLJ9TCSPugThztjDbSBKJaoe4OvtUmiRqve
	K92bPBcZQHN+Wip8MMi+Z2BTjgDNF9O/YqK03syyCMf5bmATTurDR0NC2WesnoGwNPPFpa
	4vq/mjFMVBDIjN6fkhySAxf1oTUYDTY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hWAKLyey;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-32b43c5c04fso51038031fa.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 10:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753120526; x=1753725326; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrkuuoMFnjNnyN4EGKSAvsjDnC4VRrZnL1lKzFulqZo=;
        b=hWAKLyey1LFt3BN2kyBAICicjj3fc5uJrpIZHzLOV+4OtB1nJ8uo4sN/rs6mERcUJ3
         pDAhg4UrVQ4ggzwpuvU9vTatOf6leb5SSrBx9rUYBYLeRixreeOIS8paMMh3XE6Gj7Ca
         t0WwJCjK1dKsEBraf+ejXtNzeVA6mphgu8tuTziRsUb2WqUo+7sYDi4g0sA35dxWcXKz
         VVnZfAw4MNapXOYo4pPEfkoAQ57waxg9evSmZDXwlaviT4ynk57UDDfKWD6kQ6pYlsZB
         StH9B2Qs8t7zKakaGuMlxRVkVuLexbeG0rZkexCcTL3aRp9ppKqwz2HWZNYdYcujjEoN
         mwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753120526; x=1753725326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrkuuoMFnjNnyN4EGKSAvsjDnC4VRrZnL1lKzFulqZo=;
        b=a5CMsNk/lzHydz9YMNHfmauMmI9aRf6FAzF3ZjasxykkBwsh93TixDDv0/ptNKpU6P
         u5aya+RjBCs+9qMmBxSuDN21Rtd3Zljs9hBToyzP7kRVd/2hRLZlQqzD1+24SO3icEMA
         JPtrekQJFk7fPQ4V7wF8ELS+3d0SfMv3+2Q1/TAi+k2+BRWTmohzBlJQZ/x3mm5xfoIl
         16HwMiqeRDNYdQo08waqCRyfy0ERIUZI2zia4j5npzag5LIAmXBWXaMptQ3d4QwWwW4C
         fBzbY0mHZ+c2XcYnPrARZL+TNMEIegu9Zf3aIQpqYhbTuU98Vnsn3ly8WXp8cOd1TLl3
         +Dwg==
X-Forwarded-Encrypted: i=1; AJvYcCWI8+3hEMMukgr7VDgXkwCjbhAWD9qrOiyBO0X1pn9uaVB8Co13kvnEYphz/7kEErhbYD63Nws5hg==@kvack.org
X-Gm-Message-State: AOJu0YyCSHqXQG5iyRvoXgTYumoAr87BQMtPhRSzTd/TFWR+ygjFUwgw
	Eu+gbNjcJBBi70ZysdyTd2sTJe+QXy8hrcReqnYLtjYrKnc7ykW8vUgKWZ/voeLL1wuhlpyUG1H
	HcVoZyq4N7pTovtNey5jl4oyQ5FAjcNo=
X-Gm-Gg: ASbGncuyWubvZ21l80XE6fVEARP1ah9dzpjXCkJkxpc/zfYpk9kiu2/GYHQxg0WeHES
	YNpI1UDOAoqzA6x+0YaNSN7xEgyn9rFhsCeX4XL3kcqUB9y3mllsU317pcpAt2gn/XIbrinPtC8
	0Lr5l5Rs+msBUs9P6oxpZrMZKAcLtbQjc63cxmRNn++pM/ab9miIA8wSMNi4P/vu7oHa8vCLVEX
	gWcLZHS
X-Google-Smtp-Source: AGHT+IEBZNG4EAB29FW7u+2QKV577OMsk1kn2rLGCVkV0FCNpxuApY+lFJ80jIdavWr5znA+wJbXYBWPwP7A+gd51NI=
X-Received: by 2002:a2e:8a82:0:b0:32b:968d:1fe4 with SMTP id
 38308e7fff4ca-330d264bdb2mr703831fa.14.1753120525308; Mon, 21 Jul 2025
 10:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <87beaec6-a3b0-ce7a-c892-1e1e5bd57aa3@google.com>
In-Reply-To: <87beaec6-a3b0-ce7a-c892-1e1e5bd57aa3@google.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 22 Jul 2025 01:54:47 +0800
X-Gm-Features: Ac12FXzuKPqdRzilZJZ9PfrOhS-4V7Snv2ZZdRZ9zGzCBekbhLwa5jp9bupPS-M
Message-ID: <CAMgjq7CtLM0psoHmSguv6SFH3BH+vMOn7CJnjVxnUhoc_chTuA@mail.gmail.com>
Subject: Re: [PATCH mm-new 1/2] mm/shmem: hold shmem_swaplist spinlock (not
 mutex) much less
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <21cnbao@gmail.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ACF8480008
X-Stat-Signature: zan3z1exmf9e4gzeucio71k15o5eubqz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753120527-122908
X-HE-Meta: U2FsdGVkX19qFe60NgabEAngKaTj2qOoIkqZhru7r/Avfw9+BDK9ZqZnZ8QqnxDI+YMUtMxIvF2w3sboSHdOQIvDKqxkm2C2hZ8j+AzRya12ZLm5lr0u5u5f4bJgdqH9QSh1paho54jU2UNUyvDMIfS0NzVU3Ral2lpFll+8YYrWfHoQp3jR6tfNq1sdN8laVJvSMIPdQdcRiQLp3Olq70okFOdGM7mkjcFZH/owfMIP3SzEj7dsM2pKpjRkkJAdY8kHXkA/pEuhY9IPzbxQJaT1CIhBvphZmVyJZyKubS1wmCPdkwKQEc9kFSixpssUXDh9oLEctHr1haq4ITQI3yFPYDH/W0i6WnMuUs4TjoG68JraEmujdxtG1bWAc/QeO9/09YH31Ny4F5apM4/Lt4ZhO05ns0E+Tn8NNeMnjsNJUF9VE4rzEDGVsRwKz4kRx7w6y1R5R4GPTR3HTYuph9H0SpO4m/SH0F0xHpmLu1bg7poe2rhJGpyTI6fG8J8bZGN0Il3/nVwPly11OVrilCYrCV40EALTaLmujznY1Mvb4rRiSbrJ/DfHiBvEZbEO6xkXWIu5imKitbX6OErtAmNDRzUaFI1ApzrLqFlM49f563TbYliEV8HuPXLaD0J0RQSiA1TMjnzr6wcCWDqaQrohFfMr7ABUPip6k/Xr/2qP+rXXWAv2Ou6NcCHF8boZM+V6SKek05YySvpbtEV8kXPJKh5o/JVaUOmd2ov1N1CVaeA8ZWkBjp7IIK0bCo2baPqHI4KyqpFxqFcyDUDT4QH3rHEMIsn2qXZbhcOArZFgNYG8ei3O6MP2nAsEbmXpjdbSBLUG/ziroWXPpbFjySyt+/DFffUSQ1HO3MKfEYv6IMvl221AQyyDDeE88gETHpnaaTVmaudnbRZwf6oudoFijSxCI+uxsi+pE07+gxjkO5Ey4vygWq183tUk+e3xH+q/KffUVll/H4WioTE
 XHcK/Vrv
 VWqIFdZm9J1WVVUynPgQ2usdV21kR4dA8/U8adY6UYFfCTrDearlk/dFWgqYkD03ySTHlqvZu/FsQ5VoRDhaHALzMHQlEeG+pWjGOAYVzOovN7E9w0sPh4czDXDlFNnR/+dLlAFK4TJVh2T+SQoGkWpZturJOjTG8ToSqv76FvvMTUTt9wvw+Rr1oDigWm4s71f0bsr3zQibYHyAans61YhoN7Rg2GmZ5C2zp7TygJNnWNwBigb/3CwyHR0XtD1NriJJVK5cTgfpLedsJjYsQVN7xfuKgnsKhBvcccT1W4ugV5uCvuz1XBI1XIKGPtvIXCSdmoGtBEVjDSVDIY1QOrcEe1Sz0LHhJVwZusQce3pASCNECi2bVphlhVVGT4khZ2w7yGFMv+Jyj7UEpUoLyJxNgyWDC1p9ZFKl2ZGxEgP92VgVhXl0Y/9wSY2+F0YyFYv3RRk2R3xpjTWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 16, 2025 at 4:06=E2=80=AFPM Hugh Dickins <hughd@google.com> wro=
te:
>
> A flamegraph (from an MGLRU load) showed shmem_writeout()'s use of the
> global shmem_swaplist_mutex worryingly hot: improvement is long overdue.
>
> 3.1 commit 6922c0c7abd3 ("tmpfs: convert shmem_writepage and enable swap"=
)
> apologized for extending shmem_swaplist_mutex across add_to_swap_cache(),
> and hoped to find another way: yes, there may be lots of work to allocate
> radix tree nodes in there.  Then 6.15 commit b487a2da3575 ("mm, swap:
> simplify folio swap allocation") will have made it worse, by moving
> shmem_writeout()'s swap allocation under that mutex too (but the worrying
> flamegraph was observed even before that change).
>
> There's a useful comment about pagelock no longer protecting from evictio=
n
> once moved to swap cache: but it's good till shmem_delete_from_page_cache=
()
> replaces page pointer by swap entry, so move the swaplist add between the=
m.
>
> We would much prefer to take the global lock once per inode than once per
> page: given the possible races with shmem_unuse() pruning when !swapped
> (and other tasks racing to swap other pages out or in), try the swaplist
> add whenever swapped was incremented from 0 (but inode may already be on
> the list - only unuse and evict bother to remove it).
>
> This technique is more subtle than it looks (we're avoiding the very lock
> which would make it easy), but works: whereas an unlocked list_empty()
> check runs a risk of the inode being unqueued and left off the swaplist
> forever, swapoff only completing when the page is faulted in or removed.
>
> The need for a sleepable mutex went away in 5.1 commit b56a2d8af914
> ("mm: rid swapoff of quadratic complexity"): a spinlock works better now.
>
> This commit is certain to take shmem_swaplist_mutex out of contention,
> and has been seen to make a practical improvement (but there is likely
> to have been an underlying issue which made its contention so visible).
>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/shmem.c | 59 ++++++++++++++++++++++++++++++------------------------
>  1 file changed, 33 insertions(+), 26 deletions(-)

Thanks a lot! I've also seen this issue, and we observed this
contention on 5.4 kernels and I wasn't sure about how we can optimize
it. This is very helpful.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 60247dc48505..33675361031b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -292,7 +292,7 @@ bool vma_is_shmem(struct vm_area_struct *vma)
>  }
>
>  static LIST_HEAD(shmem_swaplist);
> -static DEFINE_MUTEX(shmem_swaplist_mutex);
> +static DEFINE_SPINLOCK(shmem_swaplist_lock);
>
>  #ifdef CONFIG_TMPFS_QUOTA
>
> @@ -432,10 +432,13 @@ static void shmem_free_inode(struct super_block *sb=
, size_t freed_ispace)
>   *
>   * But normally   info->alloced =3D=3D inode->i_mapping->nrpages + info-=
>swapped
>   * So mm freed is info->alloced - (inode->i_mapping->nrpages + info->swa=
pped)
> + *
> + * Return: true if swapped was incremented from 0, for shmem_writeout().
>   */
> -static void shmem_recalc_inode(struct inode *inode, long alloced, long s=
wapped)
> +static bool shmem_recalc_inode(struct inode *inode, long alloced, long s=
wapped)
>  {
>         struct shmem_inode_info *info =3D SHMEM_I(inode);
> +       bool first_swapped =3D false;
>         long freed;
>
>         spin_lock(&info->lock);
> @@ -450,8 +453,11 @@ static void shmem_recalc_inode(struct inode *inode, =
long alloced, long swapped)
>          * to stop a racing shmem_recalc_inode() from thinking that a pag=
e has
>          * been freed.  Compensate here, to avoid the need for a followup=
 call.
>          */
> -       if (swapped > 0)
> +       if (swapped > 0) {
> +               if (info->swapped =3D=3D swapped)
> +                       first_swapped =3D true;
>                 freed +=3D swapped;
> +       }
>         if (freed > 0)
>                 info->alloced -=3D freed;
>         spin_unlock(&info->lock);
> @@ -459,6 +465,7 @@ static void shmem_recalc_inode(struct inode *inode, l=
ong alloced, long swapped)
>         /* The quota case may block */
>         if (freed > 0)
>                 shmem_inode_unacct_blocks(inode, freed);
> +       return first_swapped;
>  }
>
>  bool shmem_charge(struct inode *inode, long pages)
> @@ -1399,11 +1406,11 @@ static void shmem_evict_inode(struct inode *inode=
)
>                         /* Wait while shmem_unuse() is scanning this inod=
e... */
>                         wait_var_event(&info->stop_eviction,
>                                        !atomic_read(&info->stop_eviction)=
);
> -                       mutex_lock(&shmem_swaplist_mutex);
> +                       spin_lock(&shmem_swaplist_lock);
>                         /* ...but beware of the race if we peeked too ear=
ly */
>                         if (!atomic_read(&info->stop_eviction))
>                                 list_del_init(&info->swaplist);
> -                       mutex_unlock(&shmem_swaplist_mutex);
> +                       spin_unlock(&shmem_swaplist_lock);
>                 }
>         }
>
> @@ -1526,7 +1533,7 @@ int shmem_unuse(unsigned int type)
>         if (list_empty(&shmem_swaplist))
>                 return 0;
>
> -       mutex_lock(&shmem_swaplist_mutex);
> +       spin_lock(&shmem_swaplist_lock);
>  start_over:
>         list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
>                 if (!info->swapped) {
> @@ -1540,12 +1547,12 @@ int shmem_unuse(unsigned int type)
>                  * (igrab() would protect from unlink, but not from unmou=
nt).
>                  */
>                 atomic_inc(&info->stop_eviction);
> -               mutex_unlock(&shmem_swaplist_mutex);
> +               spin_unlock(&shmem_swaplist_lock);
>
>                 error =3D shmem_unuse_inode(&info->vfs_inode, type);
>                 cond_resched();
>
> -               mutex_lock(&shmem_swaplist_mutex);
> +               spin_lock(&shmem_swaplist_lock);
>                 if (atomic_dec_and_test(&info->stop_eviction))
>                         wake_up_var(&info->stop_eviction);
>                 if (error)
> @@ -1556,7 +1563,7 @@ int shmem_unuse(unsigned int type)
>                 if (!info->swapped)
>                         list_del_init(&info->swaplist);
>         }
> -       mutex_unlock(&shmem_swaplist_mutex);
> +       spin_unlock(&shmem_swaplist_lock);
>
>         return error;
>  }
> @@ -1646,30 +1653,30 @@ int shmem_writeout(struct folio *folio, struct sw=
ap_iocb **plug,
>                 folio_mark_uptodate(folio);
>         }
>
> -       /*
> -        * Add inode to shmem_unuse()'s list of swapped-out inodes,
> -        * if it's not already there.  Do it now before the folio is
> -        * moved to swap cache, when its pagelock no longer protects
> -        * the inode from eviction.  But don't unlock the mutex until
> -        * we've incremented swapped, because shmem_unuse_inode() will
> -        * prune a !swapped inode from the swaplist under this mutex.
> -        */
> -       mutex_lock(&shmem_swaplist_mutex);
> -       if (list_empty(&info->swaplist))
> -               list_add(&info->swaplist, &shmem_swaplist);
> -
>         if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GF=
P_NOWARN)) {
> -               shmem_recalc_inode(inode, 0, nr_pages);
> +               bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_pa=
ges);
> +
> +               /*
> +                * Add inode to shmem_unuse()'s list of swapped-out inode=
s,
> +                * if it's not already there.  Do it now before the folio=
 is
> +                * removed from page cache, when its pagelock no longer
> +                * protects the inode from eviction.  And do it now, afte=
r
> +                * we've incremented swapped, because shmem_unuse() will
> +                * prune a !swapped inode from the swaplist.
> +                */
> +               if (first_swapped) {
> +                       spin_lock(&shmem_swaplist_lock);
> +                       if (list_empty(&info->swaplist))
> +                               list_add(&info->swaplist, &shmem_swaplist=
);
> +                       spin_unlock(&shmem_swaplist_lock);
> +               }
> +
>                 swap_shmem_alloc(folio->swap, nr_pages);
>                 shmem_delete_from_page_cache(folio, swp_to_radix_entry(fo=
lio->swap));
>
> -               mutex_unlock(&shmem_swaplist_mutex);
>                 BUG_ON(folio_mapped(folio));
>                 return swap_writeout(folio, plug);
>         }
> -       if (!info->swapped)
> -               list_del_init(&info->swaplist);
> -       mutex_unlock(&shmem_swaplist_mutex);
>         if (nr_pages > 1)
>                 goto try_split;
>  redirty:
> --
> 2.43.0

Reviewed-by: Kairui Song <kasong@tencent.com>


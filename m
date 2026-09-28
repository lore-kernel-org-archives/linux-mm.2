Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B25EC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B876B0088; Sun, 27 Sep 2026 21:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5546B008A; Sun, 27 Sep 2026 21:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656A66B008C; Sun, 27 Sep 2026 21:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3371A6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:14:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 842EE160B12
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:14:33 +0000 (UTC)
X-FDA: 85261400826.17.3C9AEB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 996DCA0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:14:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QLCw3fgG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790558071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyC72KWxqDJlbXy+hKU7j6uBzgNXP3yzZ3b3YBNMi7A=;
	b=QXXQJxtxxuwH250K0LbScqtHmFrAxQiVIHEI9ddgrLLsegcPKE/pWkSI/toDSQsBKmigNU
	YTZ7q6ANDjnLU+RoVDfdrutQxPe0LDTMbFoHVSr+KmIl3fqC9cgHQnTVNTgN5HGUNEWDyF
	kF+KDmVBiJJOWsvGRnEh3lK6jrGAWw0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QLCw3fgG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790558071;
	b=oWWaOZvreswjjMZ96Lu1RipJqV6KivCCEWw+JSTNyOeuUTn1Vnw0J972zqCuy9dUpizDN0
	NmKggi2dn9IztnrPW/cUFSU8l8+m8iRicV9r7Tk8tdE/damM/c1YLXK+gt86GBfoMxruDY
	4pk+1YwzFGA8Of+ENDkXTMFuQFnTpCA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AF6F4478B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709A51F008A3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790558070;
	bh=EyC72KWxqDJlbXy+hKU7j6uBzgNXP3yzZ3b3YBNMi7A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QLCw3fgG6q/kDHGYx4lHt+MrSUfstHkF0ztBYLEPnlZPSGbxTDekAXN+eXBnndUJL
	 oW6HhlSsSNs5WiJPbnRCTizdTReW+4jgqebmckTMndCBIRpJu5laZ0bcH5q7h2FBIF
	 Ae5gIHNxsZwYPAss4VjubqamHU4r+63w7W3OcvVi/fqEfLmtBkHVjVBJQSEJ7oqnj5
	 BWLKlnf+jX6VhDxGWeTNO9A6mjGue66KL9IRwruaTm9itXuVoqwGddt6PjQFoEfroA
	 A27kxghPj9WL1YYgjtZzrWYfYDVc5LL7MN+rk1uYi3DBf0fHCXuvH/qZsGS3ZyvLU9
	 zG3qbj4jsWTLA==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aaf688ebb0so2452375a12.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:14:30 -0700 (PDT)
X-Gm-Message-State: AFq9FYI4NjrWLeF+NPv5gz0JrRe8WYbMY4msAh9VA8BaFyAGyQOYXmhE
	xsxvpJ6NlFQvQwbAOo3p0yYyFu5E12ZZsQgHUKgVG6dV4mMOIKBLEfpuWRGLbyGVUrl1t7f59pT
	4/Rr7IoGoRl9JK74IgzJHpA/VKMMhfdWym2z2L1ruoQ==
X-Received: by 2002:a05:6402:a0ca:b0:6aa:9f93:e991 with SMTP id
 4fb4d7f45d1cf-6aac8f40750mr7984598a12.3.1790558069240; Sun, 27 Sep 2026
 18:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-2-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-2-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 15:14:18 -1000
X-Gmail-Original-Message-ID: <CACePvbVrd+e6FAK6m8PuoD_Lcen13SeYus=gbQxXCm10AZm1ZA@mail.gmail.com>
X-Gm-Features: AclHuK-AO377KDisb_ZyQ54ljtndVAy04GqfAKOJ8KfE0jbtV5rzs_avyITVamQ
Message-ID: <CACePvbVrd+e6FAK6m8PuoD_Lcen13SeYus=gbQxXCm10AZm1ZA@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] mm: xswap support for zswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d16jrw47qnj7sn46pq8i1e356ppfyn5o
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 996DCA0004
X-HE-Tag: 1790558071-915491
X-HE-Meta: U2FsdGVkX1/lk5LF1X204mt+uCNoOpOMCZ5VE3QTAnr5jxtzqykNbNPf/MZKQnFI3NOlYmPTJ48ovIo5GY16nK5eT8vgX8vyFwPR7t233WtetWeLkywxaKmpObx5rkq2iKEI/3CkQV6HbQ7wRuskeWNezz27XLRXrsn6VuUCT1ubqJEYW4a0MeiPGMp992gsFy7/Sy0Kcu2RWHxOpsIRR3EQ5j62ZL2qok0mAuH3y4JrKOY2tq43hsahSagfUboASKJAxtuWfm/YMoveGq6FV0wIcRDBclqzrNIPVdfSN3eghbLZNui5tk/0EH4yLCZep5iyCfblm8GIaJ+2hVGwUc5hCBWkogU6Iq8i1zKGYTNlgHFUzXOKqyeTlEwrmaCEKMJLavDg6fXZWnW63FBvWi9IXo+tXkUqA/KY99E2g4W/l5xQxNN70Mu3oRSsp/h4pqPfXh/EFJEmYFSVrgV8QeR44ZROYrnBMYWZGZzRWnRPfuPtPKGiidnFuXI/owVBdEErQdBpY/cgzCOJ/plTCVYa943g4mEvrZzyJN9/kIaofLuz3M+4jZFZSgZTxAE2Se3uJqS/ER5u84aQlODI0EgVo1Ys2dXJKpyKVYvytmh72tZEUz81HvbTzcpt5y7O5kzU7QNrC2dB9/TIEXgjpAsBielC2/2Zn2MDR3m0J/kXQYSEWSddenGvnSNUh2PnahYLMjVE72II6Jcm+Bgm+FOyIQZoDN3QJfXLjj8WKjOSQ/tRXCg+LSu6LtOvodLtCm5/Arbq3OKDqr8uqnLeyorn1seeouTCOFTysz1Y5ZSPGHitkJ3ECm0iEXdridgk7zcXncjDlCp08wAJVUtPgmuhUpEkak8Q9bceFCS3p6P8K3McdbaQu+QnlTfncULTHCDzW64BIwUIOnhoNR26pa36gehunBwaoZNCujQibXBmq8UaygbyzLWw59pNsfO4frkZUtEOKcNAYHmiBf1
 E4HmOQd3
 XUaQpLSmfu07VArk/sMUEvuf0rRYhYeTMrnuYt/x+EhjFPUaCERXlE2bIDHeiX6wvZfx7rmpfSRwbJZrWYyLHa82ZSLd3VVJf22xuSruuSSDWRYzgEfbyCPpndyZH4aEsC3D7mgMjlGo3U7ueLgrN4LmV6sgL7G33cCNZ7nf/v6awjBuQoU/5WjZvSrkXqmXBZ6r/z5cJg2aKPKnFad41lZBDwYMBQ44zvgBqx5PtUiTkumdpJD9xSwGDZ7DBPP0juwiaa2a0hc4SiHKYZzTEt1mVHxE2YrErRnx0OJDqccjGladX7MNZOB/jdXz/dCy6rNx14G4IVu9EgydLq0hqrHlsqPV87asHkIRELFY0VGa0DOpNiM2VDB860zWOfss8BhlPtrJDPaK2Bd1al0+Udt4AkTu+5HtIlRb5a7TSDswDxC/EJmyhNCajcXZjaxcCVIfw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:19=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> From: Chris Li <chrisl@kernel.org>
>
> Introduce extendable swap device support - xswap.
>
> An xswap device has no backing storage and no swap data section, so
> it wastes no disk space. Creation is via a sysfs interface added in a
> later patch.
>
> Zswap writeback is gated on whether a real (non-xswap) swap device is
> active. nr_real_swapfiles counts such devices and is maintained at
> swapon/swapoff only, so the gate reflects "a device exists to write
> back to" rather than "a device currently has free slots". This keeps
> writeback working even when the real swap device is full, and avoids
> a double decrement when a full device is swapped off.
>
> Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Chris Li <chrisl@kernel.org>

Reviewed-by: Chris Li <chrisl@chrisli.org>

Chris

> ---
>  include/linux/swap.h |  2 ++
>  mm/page_io.c         | 19 +++++++++++++++++++
>  mm/swap_state.c      |  4 ++++
>  mm/swapfile.c        | 28 ++++++++++++++++++++++++----
>  mm/zswap.c           |  7 ++++++-
>  5 files changed, 55 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 43155e122b5c..b4331ca4759a 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -201,6 +201,7 @@ enum {
>         SWP_STABLE_WRITES =3D (1 << 11),  /* no overwrite PG_writeback pa=
ges */
>         SWP_SYNCHRONOUS_IO =3D (1 << 12), /* synchronous IO is efficient =
*/
>         SWP_HIBERNATION =3D (1 << 13),    /* pinned for hibernation */
> +       SWP_XSWAP       =3D (1 << 14),    /* extendable swap device */
>                                         /* add others here before... */
>  };
>
> @@ -375,6 +376,7 @@ void free_folio_and_swap_cache(struct folio *folio);
>  void free_pages_and_swap_cache(struct encoded_page **, int);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
> +extern atomic_t nr_real_swapfiles;
>  extern long total_swap_pages;
>  extern atomic_t nr_rotate_swap;
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 1da4ff484f09..d685c2e2429a 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -248,6 +248,15 @@ int swap_writeout(struct swap_io_ctx *ctx, struct fo=
lio *folio)
>         }
>         rcu_read_unlock();
>
> +       /*
> +        * xswap has no backing store: keep the folio.  ctx->sis is not s=
et
> +        * yet, so look the device up from the entry.
> +        */
> +       if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP=
)) {
> +               folio_mark_dirty(folio);
> +               return AOP_WRITEPAGE_ACTIVATE;
> +       }
> +
>         __swap_writeout(ctx, folio);
>         return 0;
>  out_unlock:
> @@ -482,6 +491,16 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct=
 folio *folio)
>         if (zswap_load(folio) !=3D -ENOENT)
>                 goto finish;
>
> +       if (unlikely(sis->flags & SWP_XSWAP)) {
> +               /*
> +                * An xswap entry only ever lives in zswap, so zswap_load=
()
> +                * must have found it.  Unlock and let the caller retry.
> +                */
> +               WARN_ON_ONCE(1);
> +               folio_unlock(folio);
> +               goto finish;
> +       }
> +
>         /* We have to read from slower devices. Increase zswap protection=
. */
>         zswap_folio_swapin(folio);
>         swap_add_folio(ctx, folio, READ);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 625c185a1ca4..8bba3e533b28 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -837,6 +837,10 @@ struct folio *swap_cluster_readahead(swp_entry_t ent=
ry, gfp_t gfp_mask,
>         struct blk_plug plug;
>         swp_entry_t ra_entry;
>
> +       /* xswap entries live only in zswap; readahead does not help. */
> +       if (si->flags & SWP_XSWAP)
> +               goto skip;
> +
>         mask =3D swapin_nr_pages(offset) - 1;
>         if (!mask)
>                 goto skip;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 280dd906eb18..13ae681acf07 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
> +atomic_t nr_real_swapfiles;
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>   * memory pressure (via the shrinker). Before doing so, they may wish to
> @@ -733,7 +734,8 @@ static void free_cluster(struct swap_info_struct *si,=
 struct swap_cluster_info *
>         /*
>          * If the swap is discardable, prepare discard the cluster
>          * instead of free it immediately. The cluster will be freed
> -        * after discard.
> +        * after discard.  xswap has no bdev and never sets
> +        * SWP_PAGE_DISCARD, so it always takes the free path below.
>          */
>         if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) =3D=3D
>             (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
> @@ -1216,6 +1218,9 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>                  */
>                 lockdep_assert_held(&si->lock);
>                 si->flags &=3D ~SWP_WRITEOK;
> +               /* Count active devices, not merely those on the avail li=
st. */
> +               if (!(si->flags & SWP_XSWAP))
> +                       atomic_sub(1, &nr_real_swapfiles);
>                 atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>         } else {
>                 /*
> @@ -1273,6 +1278,8 @@ static void add_to_avail_list(struct swap_info_stru=
ct *si, bool swapon)
>         }
>
>         plist_add(&si->avail_list, &swap_avail_head);
> +       if (swapon && !(si->flags & SWP_XSWAP))
> +               atomic_add(1, &nr_real_swapfiles);
>
>  skip:
>         spin_unlock(&swap_avail_lock);
> @@ -3266,7 +3273,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>
>         destroy_swap_extents(p, p->swap_file);
>
> -       if (!(p->flags & SWP_SOLIDSTATE))
> +       if (!(p->flags & SWP_XSWAP) &&
> +           !(p->flags & SWP_SOLIDSTATE))
>                 atomic_dec(&nr_rotate_swap);
>
>         mutex_lock(&swapon_mutex);
> @@ -3376,6 +3384,19 @@ static void swap_stop(struct seq_file *swap, void =
*v)
>         mutex_unlock(&swapon_mutex);
>  }
>
> +static const char *swap_type_str(struct swap_info_struct *si)
> +{
> +       struct file *file =3D si->swap_file;
> +
> +       if (si->flags & SWP_XSWAP)
> +               return "xswap\t";
> +
> +       if (S_ISBLK(file_inode(file)->i_mode))
> +               return "partition";
> +
> +       return "file\t";
> +}
> +
>  static int swap_show(struct seq_file *swap, void *v)
>  {
>         struct swap_info_struct *si =3D v;
> @@ -3395,8 +3416,7 @@ static int swap_show(struct seq_file *swap, void *v=
)
>         len =3D seq_file_path(swap, file, " \t\n\\");
>         seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
>                         len < 40 ? 40 - len : 1, " ",
> -                       S_ISBLK(file_inode(file)->i_mode) ?
> -                               "partition" : "file\t",
> +                       swap_type_str(si),
>                         bytes, bytes < 10000000 ? "\t" : "",
>                         inuse, inuse < 10000000 ? "\t" : "",
>                         si->prio);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 507f2d19fd2a..96fb993d18cb 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1018,6 +1018,11 @@ static int zswap_writeback_entry(struct zswap_entr=
y *entry,
>         if (IS_ERR_OR_NULL(si))
>                 return -ENOENT;
>
> +       if (si->flags & SWP_XSWAP) {
> +               put_swap_device(si);
> +               return -EINVAL;
> +       }
> +
>         mpol =3D get_task_policy(current);
>         folio =3D swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NU=
LL, mpol,
>                                        NO_INTERLEAVE_INDEX);
> @@ -1567,7 +1572,7 @@ bool zswap_store(struct folio *folio)
>         zswap_pool_put(pool);
>  put_objcg:
>         obj_cgroup_put(objcg);
> -       if (!ret && zswap_pool_reached_full)
> +       if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapf=
iles))
>                 queue_work(shrink_wq, &zswap_shrink_work);
>  check_old:
>         /*
> --
> 2.54.0
>
>


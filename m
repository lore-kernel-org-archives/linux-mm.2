Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BDCC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E054A6B008A; Mon, 28 Sep 2026 01:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F2E6B008C; Mon, 28 Sep 2026 01:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57266B0095; Mon, 28 Sep 2026 01:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0A406B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:27:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2558E120B83
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:55 +0000 (UTC)
X-FDA: 85262039310.25.A06D35D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3E280C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mL5yvZ5i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790573273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtDQsUaoE80LpGWygXylMoxi45gP7jEU9bpilPAR5EQ=;
	b=YLMc1/2/Q0ko8TON4Hl0qKrmnClDaaPDM/rnDbPghxFix4WiR30Ql1gWSQD4xiwFmjPdHz
	g55K3zVMYy9Cz4ls6vbU4NVXMWYa3CRC8f1TSLyeFWULYeA5rnO46KnZUbfib+B8dlTv0P
	aoUfUkJ1H5KtIeDifAGYntyKgMOmBhA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mL5yvZ5i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790573273;
	b=sYI3u4jza8ickYAMx2O23RL0ahTcmlruLcKB5VNQBMeZHiuyZHHIaF9vJZxMTx30Ds625M
	jq+TTAFGPnl7NPx3U5wUPqKWGSwAFBqQscIw3xdhkOOkF6sLUEGk9enZHIr86ql3H+/UL2
	aUgPP6/7vcbnsRy0VS7fuuuOsY8gY2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8519B43D6C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3F01F0089A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790573272;
	bh=LtDQsUaoE80LpGWygXylMoxi45gP7jEU9bpilPAR5EQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mL5yvZ5iMgi0ScuF9PQW7dTbRPCRDiCgGCmuPAUsbO/bmzz04FJ3F0GxJLP4Yo1Kg
	 ddA+nboQO13qF65jrFBN+y0OeXLX1bWSOcPcMOK1LAMykj2CHObqNh/vUr0XC1O2bp
	 zGnCX7v/GI0ptnJ7hLAV9Ifsu7JcDeBO99m8IAOnDy/Fxki6vgqAj//pKHqGXXwAxq
	 bf2VtzZwwbPsvwAwjrUENox2vKISFDTC0Ej0wA85olC2zVY3G0TE3u1kSOLwYTnynt
	 4MksyOBGE3M2P9q7zhyCOapk3l8Lw2QZV+SxVr/rDqaJC1NtZbbeYk4mvVN0nRWPnj
	 zCqrEZQIPjIvw==
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac62c88c7cso1751171a12.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:27:52 -0700 (PDT)
X-Gm-Message-State: AFuF++mY1X3FE8n32/EYp7hSIhvNaCuAC1uvC65JJq/9BfiYSYf27nyH
	9bi6fhgrJI++yLjS/20qhOQ09djT8YXrasOMjfpVfuu6+apL0vZaKZOEoyyu9LLA8OzA4zg1Cko
	lS76OZdaAi+7buQdBDiikyDjH+6PaGYDby/UQXbwBng==
X-Received: by 2002:a17:907:e0c7:10b0:c2a:f439:f028 with SMTP id
 a640c23a62f3a-c2af439f86amr378049266b.24.1790573271283; Sun, 27 Sep 2026
 22:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-10-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-10-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 19:27:39 -1000
X-Gmail-Original-Message-ID: <CACePvbWa5RwGsgeg5qpQBqCdS34dfWs6kbpqjtEBpUo7R-20ZA@mail.gmail.com>
X-Gm-Features: AclHuK8pRQ2CTtQwqyX1ttiYtcOzoPDoMittu3JII_QT55qE4hqN0Lg9tjKul68
Message-ID: <CACePvbWa5RwGsgeg5qpQBqCdS34dfWs6kbpqjtEBpUo7R-20ZA@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] mm, swap: defer xswap shrink to workqueue to
 avoid lock recursion
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3E280C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dojs1pts669ne5c8spjzno3dfyjy5d47
X-HE-Tag: 1790573273-171725
X-HE-Meta: U2FsdGVkX1/fzjQoSLVJX09tNEoN/m3bpT2Lw+A+yPjrmfjZ08HJnktSw5Cd3gJyI4tofSR8WPQsdoJLJnMHkBQyDFTD61yUE76TQIQPB0psNklZd+1myWV3o+/5RSRwJMM2vc64xIfmk5uWcXg4QAUZSxe3VMl8j9fTgki41hv2lclWutMxCXCGfqvNZ2/X1XdgephaGSTqd+XPnO6J0bfi4jB38BXsXGuLNdnwRrbqnMTMGhqNrBWPMKceIRxajKb/YZN5DGrqkz/PGv5URnSkU6x5HJVVZmgc7ovcYQkf8L6qzMj+dnZiCW67nxJgIFjtUkCc+NpxERUDSRs4rYcTcLyxSSl8NbGfbJ68p+y5+Z7n/eblx8uTCNZzqNtAbfJeFnBXqlr7rhsCRamVmcLWx5cYL7+tzoQ+Mr5QlUOp9subgHXU/InnZzabpAtFB2AxfaCUFfrcMY6nbSRSXu9yoACDtrYp7QfLhclssZl4/V8z/gV69BEvvz8Hhc/pd9Lwpb7+9HidihD5bH4k5V0z1KUDOF93sh3MV1Wkf00w3+GS45LvoT3nJ6hFWf2dGkAlBubeXYAMEEsROsRnypPKCkoGP15F9MlzdDxqiYNJDliAjDLSTOCCahGUuQjw0XbswpITOPa+QHOVco99QRGdZeQ9YNIhf3xdk8ii0J79QhXzcPWYJHzkf5u4ZDIEmMTG282bgQoscECZh24v7R5ehQb9aN0ThP8D0nJsGTBhcqpWd6yZ3wDFnr3ORq2KMFxJRZNbJqZgWp21Rzk6/fDM3h2q4vVSC9Y8R4WvFT3Rg5h58oKs8NdBbnn5XWuG6yni4IsMnEOSNOCWHwZdeEO4eOIJyRTGXed6YvSCS+8HY4AXTJ2ejyo1dZave47vxm0Mmi9gLWroHAt4cwUZW5tMyhlWhzc6DiL8qrf8SZGS/tlEGtBh0jZA5FpblVlcv/zF8ILqL2X8ADp3yJm
 Z4vSRuI7
 ah0XaTW5XzBCGB7ruRhs0671qYjiqqYokvPuu5k1o2pvSGdUFJ1vm6z2FV7NZp2wbKfM4Xo6aHgmWYyAa/Oi4wZGMON5H+l0bgD5bNGJNMKibi8neiwK33aXZqCXjSC53/6ewGOQrCZXmKNioEz+IBo3w+KsmYpMDlRvKH+1XUknyiKFw7uhuJnfRnVCdDluW+C540TVOXZOmIPXNRKdyPxSU++WtWAtU0w5lpvHCVdN13q1EQG/O8ELdccYSOmFSnLF3GHdisR1zZetf6nxmiNNDnwRh2PzNIJtoL3eOvOJn34lSGexV8CunY3Dcw4VttkakCgB34qiA5qQWhD8XMZoal+T8nvTmGgqGAcCJoLIa1SY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:21=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> __free_cluster() called xswap_try_shrink() while holding ci->lock, but
> shrinking unmaps the backing pages and the subsequent unlock faults on
> the unmapped address. Run the shrink via schedule_work() instead, so no
> cluster lock is held. The work is only scheduled for xswap devices and
> is cancelled on swapoff.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>

I will skip the review for shrinking related patches for now.

Chris


> ---
>  include/linux/swap.h |   1 +
>  mm/swapfile.c        | 123 +++++++++++++++++++++++++++++++++----------
>  2 files changed, 97 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8c62a53667bb..30642bb481df 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -246,6 +246,7 @@ struct swap_info_struct {
>         struct vm_struct        *cluster_vm;    /* VM_SPARSE area for clu=
ster_info */
>         unsigned long           nr_clusters_max;/* total clusters in the =
xswap address space */
>         unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
> +       struct work_struct      xswap_shrink_work; /* deferred shrink tri=
gger */
>         struct mutex            xswap_lock;     /* serialize map/unmap op=
erations */
>  #endif
>         struct list_head free_clusters; /* free clusters list */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5b31aacb3ec5..351c68bcd70b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -699,7 +699,9 @@ static void __free_cluster(struct swap_info_struct *s=
i, struct swap_cluster_info
>         move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>         ci->order =3D 0;
>  #ifdef CONFIG_XSWAP
> -       xswap_try_shrink(si);
> +       /* Only xswap devices, and not while the device is being torn dow=
n. */
> +       if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK))
> +               schedule_work(&si->xswap_shrink_work);
>  #endif
>  }
>
> @@ -3328,6 +3330,7 @@ static void free_swap_cluster_info(struct swap_info=
_struct *si)
>         if (si->flags & SWP_XSWAP) {
>                 unsigned long nr_mapped;
>
> +               cancel_work_sync(&si->xswap_shrink_work);
>                 /*
>                  * Cluster 0 keeps the bad header slot, so it never empti=
es
>                  * and __free_cluster() never frees its table.
> @@ -3452,6 +3455,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>         spin_unlock(&p->lock);
>         spin_unlock(&swap_lock);
>
> +#ifdef CONFIG_XSWAP
> +       if (p->flags & SWP_XSWAP)
> +               cancel_work_sync(&p->xswap_shrink_work);
> +#endif
> +
>         wait_for_allocation(p);
>
>         set_current_oom_origin();
> @@ -4011,8 +4019,9 @@ static int xswap_collect_page(pte_t *pte, unsigned =
long addr, void *data)
>         return 0;
>  }
>
> -static int xswap_unmap_clusters(struct swap_info_struct *si,
> -                               unsigned long start_idx, unsigned long nr=
)
> +/* Caller must hold si->xswap_lock; -ENOMEM leaves the mapping intact. *=
/
> +static int xswap_unmap_clusters_locked(struct swap_info_struct *si,
> +                                      unsigned long start_idx, unsigned =
long nr)
>  {
>         unsigned long start_addr =3D (unsigned long)si->cluster_info +
>                                    (size_t)start_idx * sizeof(struct swap=
_cluster_info);
> @@ -4025,11 +4034,8 @@ static int xswap_unmap_clusters(struct swap_info_s=
truct *si,
>         unsigned int noreclaim_flags;
>         int i;
>
> -       mutex_lock(&si->xswap_lock);
> -
>         if (vm_start >=3D vm_end) {
>                 WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> -               mutex_unlock(&si->xswap_lock);
>                 return 0;
>         }
>
> @@ -4049,10 +4055,8 @@ static int xswap_unmap_clusters(struct swap_info_s=
truct *si,
>         xpd.pages =3D kmalloc_array(npages, sizeof(*xpd.pages),
>                                   __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KER=
NEL);
>         memalloc_noreclaim_restore(noreclaim_flags);
> -       if (!xpd.pages) {
> -               mutex_unlock(&si->xswap_lock);
> +       if (!xpd.pages)
>                 return -ENOMEM;
> -       }
>
>         xpd.nr =3D 0;
>         xpd.max =3D npages;
> @@ -4066,10 +4070,20 @@ static int xswap_unmap_clusters(struct swap_info_=
struct *si,
>         kfree(xpd.pages);
>
>         WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> -       mutex_unlock(&si->xswap_lock);
>         return 0;
>  }
>
> +static int xswap_unmap_clusters(struct swap_info_struct *si,
> +                               unsigned long start_idx, unsigned long nr=
)
> +{
> +       int ret;
> +
> +       mutex_lock(&si->xswap_lock);
> +       ret =3D xswap_unmap_clusters_locked(si, start_idx, nr);
> +       mutex_unlock(&si->xswap_lock);
> +       return ret;
> +}
> +
>  /* Track the end of the run of pages that is already mapped. */
>  static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
>  {
> @@ -4090,6 +4104,16 @@ static int xswap_mapped_end(pte_t *pte, unsigned l=
ong addr, void *data)
>  #define XSWAP_SHRINK_SLACK     XSWAP_GROW_CLUSTERS
>  #define XSWAP_SHRINK_MIN       (XSWAP_GROW_CLUSTERS * 4)
>
> +static void xswap_shrink_work_fn(struct work_struct *work)
> +{
> +       struct swap_info_struct *si =3D container_of(work,
> +                       struct swap_info_struct, xswap_shrink_work);
> +
> +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> +               return;
> +       xswap_try_shrink(si);
> +}
> +
>  /*
>   * Try to shrink the cluster_info tail: unmap contiguous free clusters
>   * at the end of the mapped range.
> @@ -4097,14 +4121,16 @@ static int xswap_mapped_end(pte_t *pte, unsigned =
long addr, void *data)
>  static void xswap_try_shrink(struct swap_info_struct *si)
>  {
>         struct swap_cluster_info *ci;
> -       unsigned long nr_mapped, last, idx;
> +       unsigned long nr_mapped, nr_tail, nr_unmap, start_idx, i;
>
>         if (!(si->flags & SWP_XSWAP))
>                 return;
>
> +       mutex_lock(&si->xswap_lock);
> +
>         nr_mapped =3D READ_ONCE(si->nr_clusters_mapped);
> -       if (nr_mapped <=3D 1) /* keep cluster 0 */
> -               return;
> +       if (nr_mapped <=3D 1)     /* keep cluster 0 */
> +               goto out_unlock;
>
>         /*
>          * Reclaim on our own, but only once the mapped range is at most
> @@ -4113,27 +4139,69 @@ static void xswap_try_shrink(struct swap_info_str=
uct *si)
>          * an RCU grace period.
>          */
>         if (swap_usage_in_pages(si) * 2 > nr_mapped * SWAPFILE_CLUSTER)
> -               return;
> +               goto out_unlock;
>
> -       /* Find the last non-free cluster from the tail */
> -       last =3D nr_mapped;
> -       while (last > 1) {
> -               idx =3D last - 1;
> -               ci =3D &si->cluster_info[idx];
> -               if (ci->count || ci->flags !=3D CLUSTER_FLAG_FREE)
> +       /*
> +        * Count the free clusters at the tail of the mapped range.  Scan=
ned,
> +        * not tracked: the count must be exact to size the unmap, and an
> +        * incremental count falls behind on out-of-order frees.
> +        */
> +       nr_tail =3D 0;
> +       while (nr_mapped - nr_tail > 1) {
> +               ci =3D &si->cluster_info[nr_mapped - nr_tail - 1];
> +               if (READ_ONCE(ci->count) ||
> +                   READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
>                         break;
> -               last =3D idx;
> +               nr_tail++;
>         }
> +       if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> +               goto out_unlock;
>
> -       if (last =3D=3D nr_mapped)
> -               return; /* nothing to shrink */
> +       nr_unmap =3D rounddown(nr_tail - XSWAP_SHRINK_SLACK, XSWAP_GROW_C=
LUSTERS);
> +       if (!nr_unmap)
> +               goto out_unlock;
> +       start_idx =3D nr_mapped - nr_unmap;
>
> -       if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> -               return;
> +       /*
> +        * Only shrink a run that reaches the mapped end; otherwise
> +        * truncating nr_clusters_mapped would orphan the active tail.
> +        */
> +       spin_lock(&si->lock);
> +       for (i =3D start_idx; i < nr_mapped; i++) {
> +               ci =3D &si->cluster_info[i];
> +               if (READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> +                       break;
> +               if (!spin_trylock(&ci->lock)) {
> +                       spin_unlock(&si->lock);
> +                       goto out_unlock;
> +               }
> +               spin_unlock(&ci->lock);
> +       }
> +       if (i !=3D nr_mapped) {
> +               spin_unlock(&si->lock);
> +               goto out_unlock;
> +       }
>
> -       last +=3D XSWAP_SHRINK_SLACK;
> +       for (i =3D start_idx; i < nr_mapped; i++) {
> +               ci =3D &si->cluster_info[i];
> +               list_del_init(&ci->list);
> +               WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
> +       }
> +       spin_unlock(&si->lock);
>
> -       xswap_unmap_clusters(si, last, nr_mapped - last);
> +       if (xswap_unmap_clusters_locked(si, start_idx, nr_unmap)) {
> +               spin_lock(&si->lock);
> +               for (i =3D start_idx; i < nr_mapped; i++) {
> +                       ci =3D &si->cluster_info[i];
> +                       WRITE_ONCE(ci->flags, CLUSTER_FLAG_FREE);
> +                       list_add_tail(&ci->list, &si->free_clusters);
> +               }
> +               spin_unlock(&si->lock);
> +               goto out_unlock;
> +       }
> +
> +out_unlock:
> +       mutex_unlock(&si->xswap_lock);
>  }
>  #endif /* CONFIG_XSWAP */
>
> @@ -4197,6 +4265,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>                         }
>                 }
>
> +               INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
>                 return 0;
>
>  err_unmap:
> --
> 2.54.0
>


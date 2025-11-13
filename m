Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A4BCD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 06:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3227E8E0008; Thu, 13 Nov 2025 01:08:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2508E0003; Thu, 13 Nov 2025 01:08:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9A78E0008; Thu, 13 Nov 2025 01:08:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09EA38E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:08:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A44E312E34F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:08:39 +0000 (UTC)
X-FDA: 84104554758.20.41C01C2
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 78A171C0006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:08:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWwyEqWy;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763014117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t22dgTeDrtFxWGb8huXOzqou4mk9fcSHfq/TLjMh8ns=;
	b=V96ZFce1fcnJ4k2BSDWQInRg2K8WiiAnRAZnwZ38Sku8wcLcOK/8AcUIoQn5YyzJQ+M14b
	EIG8GF3wJAnOqHbM3rfFLiyfr3w07ph4h5HoHWhH/ug483vTSxjoES/Z5BejJ2JrQU2aRc
	K5zFmIBnWycgR8tWD/8tb8noZaVcIoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763014117; a=rsa-sha256;
	cv=none;
	b=GSzsV+OQYZ3+S6JtICf5XzmBy85xK01ifxA/WFcmjXAPnsnKxwO/351KhLuhtHWAsvv0aT
	aVE7bfwx2WawZPpE0AIC8XVXIOETh+4eXVv73aysvnw7NyvDKKSXeR7YZGLmCALntx3JmS
	8Drf5XcViznXhPnbQdzP0Z9jbNGR7LU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWwyEqWy;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b727f452fffso241814466b.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763014116; x=1763618916; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t22dgTeDrtFxWGb8huXOzqou4mk9fcSHfq/TLjMh8ns=;
        b=ZWwyEqWyKem34jKeHPIey+VBUmfE+R3Kfhj7zbWYY2wRjMs9jEcJALfp75RD4ZWanx
         Uh9Gq1hlLAdKnFbO8ErRbab2yIZU0DzhheqLqHbTwNfpfcF40WEjdtayHRC/Z6XWUprB
         skjvF00o8T26q5tPNXBVBs1oBSVIdGFZOHdJbr7EXzKFV5JWbb5xGpwWYVsboBYQEroq
         1BRgsXnnijeQAKm78YpaAqtv3hnBBScNNVBypRRqGvVEF3AXk1DIYKsn7adw8ksffLHv
         xB20JjceGf/pf//sLqVA5nwJig27ZNjAhKUcMckwSsx41QL7Z9RykJd6M5b1aLPtyfhj
         KiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763014116; x=1763618916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t22dgTeDrtFxWGb8huXOzqou4mk9fcSHfq/TLjMh8ns=;
        b=UjpWdl/P0AZZ9Obp5ysM5Qmuy7X6wCiZzHGTRPEYBQKqeKyxpEGSP8hOz6BaabDnHJ
         D+EoKGJouyvhsvZoq82MDuMO2S3eaWN/5aM+B1zpAmnRtA725wh/IrhIa045bY+jlaps
         GtQnetlTlPeosNh+ZsOExzouSCGtpu1hxz2IgJBFMkbmJwdlMcFTXOKj5mRHu4j1aIRz
         DjAD8QGOJUp63yCMzU/gqhrFCp3EZvEzpsFgeGFmmPyYyMuDQmuGgcqJPaKh1wLKLMNj
         WrDTiOFGFrUIMzg4/PD4qdIVEkdyxqNBAA6iZhk8+wgoK0kumVWxkc33Lx0WU4ekUTFZ
         sEIA==
X-Forwarded-Encrypted: i=1; AJvYcCVECkd1JqMfF6lhJr85uDtPUKUM4MK5KRFxmFIvGtBP0gC/tAi4fURpL7s/mKm+nQxVkUfUzEIsOg==@kvack.org
X-Gm-Message-State: AOJu0YzbXYci1Hb3HX6qvbDtFIkjVO+Ebj+iDNH01v8PDk9ecr97n9V3
	ucUGM3w0N9A7XjzzHpBOReajXXiGGV7DD6Am3Qr73/bOy7d3IgiBF9QZWarl8fqgFxLE5K1SM1X
	g3OnwrVANyEPE+aQSpp0UIr/PZI+hvm0=
X-Gm-Gg: ASbGncu4B3Fu0/wdSjD7exPslABX6zUgVRI0QoJMMfRVCHzIlpGo4oTxgl2z42PIMqu
	vBxRiBqlU6lk53DELyizK6AIhErf6cJfXnAyvrkIIY6O93zi6zTtl7AVswS4Oh/ccObNHSshGKt
	uqiPq0bA2j02rLz61d06VCiwtqFkKKIzMan+h/OpTlNbnfa7s+k3XlY3VW8G4cAxLoL8RRBAjJg
	7kGz05KfE1puQr/uShbExlke45onfaOyTVAIVnIM5TIgQMrwNVc5ONyXqiA0AC1r8vx8LY6PsGI
	KDJSwAeZVAd8AkaTwASM
X-Google-Smtp-Source: AGHT+IG7kqoXB2Wkka2Lo2zxPzuYPWP59bLwZ31GR/ODVeDKoIwplQX0m14wtg7CumzW9bsmTAPYXvf/G0tEKzBgNt0=
X-Received: by 2002:a17:907:eccc:b0:b73:2e54:a002 with SMTP id
 a640c23a62f3a-b73485707c9mr186790266b.15.1763014115205; Wed, 12 Nov 2025
 22:08:35 -0800 (PST)
MIME-Version: 1.0
References: <20251109124947.1101520-1-youngjun.park@lge.com> <20251109124947.1101520-2-youngjun.park@lge.com>
In-Reply-To: <20251109124947.1101520-2-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 13 Nov 2025 14:07:59 +0800
X-Gm-Features: AWmQ_bltIMHm1Q-8yi3-GESMpbrkRwF6RIVrr2aS5VGUNJ1V-cdA8bflp4lx-lk
Message-ID: <CAMgjq7AomHkGAtpvEt_ZrGK6fLUkWgg0vDGZ0B570QU_oNwRGA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm, swap: change back to use each swap device's
 percpu cluster
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chrisl@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 78A171C0006
X-Stat-Signature: xyy7xuabji8de7nbwexoe1mcatdoqonw
X-HE-Tag: 1763014117-865289
X-HE-Meta: U2FsdGVkX18ZPcW3gnJb5LR+dwQedmDfRoAfusH5VlQr5c6zHCGxNYmrxpz6UDEIF9oNfc28+0IPGeNCs+6gVARYvGLbvpeYFgNQtwgMtVHaahfjzsGfVBMBbOVw4ooDmlHP9Vv45s/I4vyvWEO1DaRzr25YnscwTOputiHpmqaUD7Y2b1GZQFir3IKne158zLMF/6OIXfZ/yLVYyGwnvUOu30/0FCCvdh3YyJ0MyFZJ9QTs5cb04jNnLq5FQqGfdhEQDd0o9I+GUzqJfFMnOe/ZXzrme96LoQpacpEeTrwT5cujBYxsHjMrM/2p49NJjgvdAUnkEH8AVOFhrM4qUVqRIpXZPkB6Hds/CvSwaSN1WZIyFpHBkXo3dPsXOPidUvGh/n1QneBJyiNLSTur9zBwty7tHzhFdogM634LlwZ3f92FQUwcaHt5Im7OIrAeYNd2DQRhA8v/dfz8juySj5K0NOyHnTeThHLTy6nIADtyY08nv3TBcSWKkFzHqZDd9JGaCZihNFCqe/Off7WiugZJShup5jQpfU0YpuopRndtQui9xznbpw6rJnVAK9Zimwz1q1bii7hqNdjH74KoRCsFwyJM3gPoSOk7dtSyWrhCofdbiZ8ttoSMpp7J15Cx0tPX8+Y7TG0FCPG/vmcM199HFiWYMeAls5HvsB1f7AwHzl9OfDx+w4zP1I+OVU2/6asLLd1DYFf4CpXxn0nNhL8iMdcpFc+2lmJI/K8jOsT92e4yR/fTiXhTMmHliWZlpehIqVRwMh5bxEkp5HkNMwdws9/Ab5LeQcsZTYxmZozIzdX9cOrGPiA+r/2Psc/bpaiwY+WkEno790Mb/H8lomiwfL2QEpUX6+nd7VHGfQaMYE06rPQ+6A/EE0o3hjNnMZ9hv97aHRyWnvusexgHWBpFCoSXhYgSQ92EGCW3RHLGEFQAv40D2c2UR4DM/qCVjMmlp3Tb2NtC53pnQwc
 dZh7jqma
 tAAyfwhUg6v/yisOXlHtpSpErZBIIVCx3MCaWQBY2rc1KuqpXypreojzWQt+xPn1XnEd/2zsN2IK4fJrbkjvQiQqMVV05aaXW0Y7uTXu70KpA0uUYGgda61/5G6j3wUF5RRYGSsTdsIS7HOiIoJzSiqrX+9LfbNZmUDgpPQxCzhFic9GLRrQbkdakf4gq1cuMCZGCrgX1EBV3PsMnKtGkBa2slL0OKjhokHoIt2o0nJyty8M21bvvFPYGWaprqvyyxBV8MDAUb0iVc1G8BKXnpXlptL4sAwLSr3b6RpdzaBYbgP8BJx3jK4WUt3PdME2tQc2s31iiqnvrUVQBaAntz1ilF5jBIY76iWMJXar9r8atlMRrBieqQxF/QnhXvuExxntcxZWp+8FYc0oIcYPPzBOIsrsYf1Z4bPKomS/JXGc5Ctk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 9, 2025 at 8:54=E2=80=AFPM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
> allocation fast path").
>
> Because in the newly introduced swap tiers, the global percpu cluster
> will cause two issues:
> 1) it will cause caching oscillation in the same order of different si
>    if two different memcg can only be allowed to access different si and
>    both of them are swapping out.
> 2) It can cause priority inversion on swap devices. Imagine a case where
>    there are two memcg, say memcg1 and memcg2. Memcg1 can access si A, B
>    and A is higher priority device. While memcg2 can only access si B.
>    Then memcg 2 could write the global percpu cluster with si B, then
>    memcg1 take si B in fast path even though si A is not exhausted.
>
> Hence in order to support swap tier, revert commit 1b7e90020eb7 to use
> each swap device's percpu cluster.
>
> Co-developed-by: Baoquan He <bhe@redhat.com>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

Hi Youngjun, Baoquan, Thanks for the work on the percpu cluster thing.

It will be better if you can provide some benchmark result since the
whole point of global percpu cluster is to improve the performance and
get rid of the swap slot cache.

I'm fine with a small regression but we better be aware of it. And we
can still figure out some other ways to optimize it. e.g. I remember
Chris once mentioned an idea of having a per device slot cache, that
is different from the original slot cache (swap_slot.c): the allocator
will be aware of it so it will be much cleaner.

> ---
>  include/linux/swap.h |  13 +++-
>  mm/swapfile.c        | 151 +++++++++++++------------------------------
>  2 files changed, 56 insertions(+), 108 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 38ca3df68716..90fa27bb7796 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -250,10 +250,17 @@ enum {
>  #endif
>
>  /*
> - * We keep using same cluster for rotational device so IO will be sequen=
tial.
> - * The purpose is to optimize SWAP throughput on these device.
> + * We assign a cluster to each CPU, so each CPU can allocate swap entry =
from
> + * its own cluster and swapout sequentially. The purpose is to optimize =
swapout
> + * throughput.
>   */
> +struct percpu_cluster {
> +       local_lock_t lock; /* Protect the percpu_cluster above */

I think you mean "below"?

> +       unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offs=
et */
> +};
> +
>  struct swap_sequential_cluster {
> +       spinlock_t lock; /* Serialize usage of global cluster */
>         unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offs=
et */
>  };
>
> @@ -278,8 +285,8 @@ struct swap_info_struct {
>                                         /* list of cluster that are fragm=
ented or contented */
>         unsigned int pages;             /* total of usable pages of swap =
*/
>         atomic_long_t inuse_pages;      /* number of those currently in u=
se */
> +       struct percpu_cluster __percpu *percpu_cluster; /* per cpu's swap=
 location */
>         struct swap_sequential_cluster *global_cluster; /* Use one global=
 cluster for rotating device */
> -       spinlock_t global_cluster_lock; /* Serialize usage of global clus=
ter */
>         struct rb_root swap_extent_root;/* root of the swap extent rbtree=
 */
>         struct block_device *bdev;      /* swap device or bdev of swap fi=
le */
>         struct file *swap_file;         /* seldom referenced */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 44eb6a6e5800..3bb77c9a4879 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -118,18 +118,6 @@ static atomic_t proc_poll_event =3D ATOMIC_INIT(0);
>
>  atomic_t nr_rotate_swap =3D ATOMIC_INIT(0);
>
> -struct percpu_swap_cluster {
> -       struct swap_info_struct *si[SWAP_NR_ORDERS];
> -       unsigned long offset[SWAP_NR_ORDERS];
> -       local_lock_t lock;
> -};
> -
> -static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) =
=3D {
> -       .si =3D { NULL },
> -       .offset =3D { SWAP_ENTRY_INVALID },
> -       .lock =3D INIT_LOCAL_LOCK(),
> -};
> -
>  /* May return NULL on invalid type, caller must check for NULL return */
>  static struct swap_info_struct *swap_type_to_info(int type)
>  {
> @@ -497,7 +485,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>          * Swap allocator uses percpu clusters and holds the local lock.
>          */
>         lockdep_assert_held(&ci->lock);
> -       lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +       lockdep_assert_held(&this_cpu_ptr(si->percpu_cluster)->lock);
>
>         /* The cluster must be free and was just isolated from the free l=
ist. */
>         VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> @@ -515,8 +503,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>          */
>         spin_unlock(&ci->lock);
>         if (!(si->flags & SWP_SOLIDSTATE))
> -               spin_unlock(&si->global_cluster_lock);
> -       local_unlock(&percpu_swap_cluster.lock);
> +               spin_unlock(&si->global_cluster->lock);
> +       local_unlock(&si->percpu_cluster->lock);
>
>         table =3D swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KE=
RNEL);
>
> @@ -528,9 +516,9 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>          * could happen with ignoring the percpu cluster is fragmentation=
,
>          * which is acceptable since this fallback and race is rare.
>          */
> -       local_lock(&percpu_swap_cluster.lock);
> +       local_lock(&si->percpu_cluster->lock);
>         if (!(si->flags & SWP_SOLIDSTATE))
> -               spin_lock(&si->global_cluster_lock);
> +               spin_lock(&si->global_cluster->lock);
>         spin_lock(&ci->lock);
>
>         /* Nothing except this helper should touch a dangling empty clust=
er. */
> @@ -642,7 +630,7 @@ static bool swap_do_scheduled_discard(struct swap_inf=
o_struct *si)
>                 ci =3D list_first_entry(&si->discard_clusters, struct swa=
p_cluster_info, list);
>                 /*
>                  * Delete the cluster from list to prepare for discard, b=
ut keep
> -                * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster cou=
ld be
> +                * the CLUSTER_FLAG_DISCARD flag, there could be percpu_c=
luster
>                  * pointing to it, or ran into by relocate_cluster.
>                  */
>                 list_del(&ci->list);
> @@ -939,12 +927,11 @@ static unsigned int alloc_swap_scan_cluster(struct =
swap_info_struct *si,
>  out:
>         relocate_cluster(si, ci);
>         swap_cluster_unlock(ci);
> -       if (si->flags & SWP_SOLIDSTATE) {
> -               this_cpu_write(percpu_swap_cluster.offset[order], next);
> -               this_cpu_write(percpu_swap_cluster.si[order], si);
> -       } else {
> +       if (si->flags & SWP_SOLIDSTATE)
> +               this_cpu_write(si->percpu_cluster->next[order], next);
> +       else
>                 si->global_cluster->next[order] =3D next;
> -       }
> +
>         return found;
>  }
>
> @@ -1037,13 +1024,17 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si, int o
>         if (order && !(si->flags & SWP_BLKDEV))
>                 return 0;
>
> -       if (!(si->flags & SWP_SOLIDSTATE)) {
> +       if (si->flags & SWP_SOLIDSTATE) {
> +               /* Fast path using per CPU cluster */
> +               local_lock(&si->percpu_cluster->lock);
> +               offset =3D __this_cpu_read(si->percpu_cluster->next[order=
]);
> +       } else {
>                 /* Serialize HDD SWAP allocation for each device. */
> -               spin_lock(&si->global_cluster_lock);
> +               spin_lock(&si->global_cluster->lock);
>                 offset =3D si->global_cluster->next[order];
> -               if (offset =3D=3D SWAP_ENTRY_INVALID)
> -                       goto new_cluster;
> +       }
>
> +       if (offset !=3D SWAP_ENTRY_INVALID) {
>                 ci =3D swap_cluster_lock(si, offset);
>                 /* Cluster could have been used by another order */
>                 if (cluster_is_usable(ci, order)) {
> @@ -1058,7 +1049,6 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>                         goto done;
>         }
>
> -new_cluster:
>         /*
>          * If the device need discard, prefer new cluster over nonfull
>          * to spread out the writes.
> @@ -1121,8 +1111,10 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si, int o
>                         goto done;
>         }
>  done:
> -       if (!(si->flags & SWP_SOLIDSTATE))
> -               spin_unlock(&si->global_cluster_lock);
> +       if (si->flags & SWP_SOLIDSTATE)
> +               local_unlock(&si->percpu_cluster->lock);
> +       else
> +               spin_unlock(&si->global_cluster->lock);
>
>         return found;
>  }
> @@ -1303,43 +1295,8 @@ static bool get_swap_device_info(struct swap_info_=
struct *si)
>         return true;
>  }
>
> -/*
> - * Fast path try to get swap entries with specified order from current
> - * CPU's swap entry pool (a cluster).
> - */
> -static bool swap_alloc_fast(swp_entry_t *entry,
> -                           int order)
> -{
> -       struct swap_cluster_info *ci;
> -       struct swap_info_struct *si;
> -       unsigned int offset, found =3D SWAP_ENTRY_INVALID;
> -
> -       /*
> -        * Once allocated, swap_info_struct will never be completely free=
d,
> -        * so checking it's liveness by get_swap_device_info is enough.
> -        */
> -       si =3D this_cpu_read(percpu_swap_cluster.si[order]);
> -       offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> -       if (!si || !offset || !get_swap_device_info(si))
> -               return false;
> -
> -       ci =3D swap_cluster_lock(si, offset);
> -       if (cluster_is_usable(ci, order)) {
> -               if (cluster_is_empty(ci))
> -                       offset =3D cluster_offset(si, ci);
> -               found =3D alloc_swap_scan_cluster(si, ci, offset, order, =
SWAP_HAS_CACHE);
> -               if (found)
> -                       *entry =3D swp_entry(si->type, found);
> -       } else {
> -               swap_cluster_unlock(ci);
> -       }
> -
> -       put_swap_device(si);
> -       return !!found;
> -}
> -
>  /* Rotate the device and switch to a new cluster */
> -static bool swap_alloc_slow(swp_entry_t *entry,
> +static void swap_alloc_entry(swp_entry_t *entry,
>                             int order)

It seems you also changed the rotation rule here so every allocation
of any order is causing a swap device rotation? Before 1b7e90020eb7
every 64 allocation causes a rotation as we had slot cache
(swap_slot.c). The global cluster makes the rotation happen for every
cluster so the overhead is even lower on average. But now a per
allocation roration seems a rather high overhead and may cause serious
fragmentation.


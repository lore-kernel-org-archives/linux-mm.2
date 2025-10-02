Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA8FCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 03:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39588E0006; Wed,  1 Oct 2025 23:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F3B8E0002; Wed,  1 Oct 2025 23:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BD48E0006; Wed,  1 Oct 2025 23:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83A4E8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:03:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28C8A58764
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:03:47 +0000 (UTC)
X-FDA: 83951679294.13.7F7FEF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41FAB100006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:03:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WEH8jwFg;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759374225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xl1Cvhmlf/9lMWIu5UbWcsXkbQekR0hq3oKTHV4P9Vs=;
	b=pm+M1Xh2rcR6uKxVDpzSKwPv+96BH6yHUVzT1zfE1evNE2AWqt3COwDLO0WpmhR3///lD1
	Uvfk1sXXC0PNqaYE6o5LUT2oyQZQDz1BHj3VUYQf6yDM3wzarV6kvTlF44PcMRbjU/xitZ
	XxIvYlOb9W5+7Tu9oxYhOu7PsvlKV5w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WEH8jwFg;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759374225; a=rsa-sha256;
	cv=none;
	b=YZElQh94x3UfoF52dAaTKRy5osXezak1WBckgFncRd2k20N8v+5fHZ9EQ7QPIMSVCe9CvU
	CfxeLJJOCKAVla0A4c2geIoWFzMkQ0G7KE3DdOxuope4AsFNlR8i9b6F/GZgBjrQrV2uAb
	Ij/UUYkd+uO+n0r4Lo4cRZNgp5n7whQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4554663D37
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAC1C4CEFD
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759374223;
	bh=yMrfrbTF3i4kHXIHt5dXj1BqQ59Mh4163rX4hy4uDk0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WEH8jwFgp5lK4kza7wdscMDrJ8NXgPFJqL+jmIpS7BgWqOC8jkX1nCidwsvLJ1he3
	 41W3fe9Zmgc7AymtNQpIcBqD1J9bM09oY1uUC159/3Of/JvDSeBJNa2sDkEtkgjWL5
	 tKQYr3htbZD85rJmEZASHVikDLigiobfZixpGvGfgrUa91Mc3UI/UaXWaluGNYpAAh
	 N5ev88K3f83nm9snHW4h5qXqSJfUJVwg0iwJcwCltjLltDLqboQL2xp1xLKSTBvsru
	 +/Olonav63xrl/a+ysXeUUeWut+c9uisnvu5ptWR3iL9DEXd5MQ2ZmogBEOkjbYTod
	 QWmGX7tSznb2Q==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d603a269cso6475697b3.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 20:03:43 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy370dZESlcYZv+rCul0qJong33wW7xrSGe0g4FESQ/DD3x0fmd
	5h2WnfqyLfIJnOSJuVoZfoSqiU33KnRZd/aOy9EzszGf/zUpAo68IOGlgNCkPW7k9OjtitvpCGl
	ndND0HCQ+J9EvprIJYUIFCr3vPHNOkMSFPs5lXf9KeA==
X-Google-Smtp-Source: AGHT+IEXKGqL5hJjdXsqXsjxnfdIFdyV7/olHNH2maj/Royvl+p57ZYheGgWpbaQd/TINGCr+yl3c03mLNM1ZUJk/wQ=
X-Received: by 2002:a53:cc41:0:b0:628:a8b3:2d5c with SMTP id
 956f58d0204a3-63b6feef50fmr5487647d50.4.1759374223149; Wed, 01 Oct 2025
 20:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250930063311.14126-1-bhe@redhat.com> <20250930063311.14126-3-bhe@redhat.com>
In-Reply-To: <20250930063311.14126-3-bhe@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 1 Oct 2025 20:03:31 -0700
X-Gmail-Original-Message-ID: <CACePvbUozJDOtj2hcepfhp865vGou7-s48NbrJ5sBT_udOeCgA@mail.gmail.com>
X-Gm-Features: AS18NWC2QJ_woQ0k9SYvk0yYv_9QauDXZHeByGDL5FZ6qfqBfS_iodsqBPOcamc
Message-ID: <CACePvbUozJDOtj2hcepfhp865vGou7-s48NbrJ5sBT_udOeCgA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/swap: select swap device with default priority
 round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41FAB100006
X-Rspamd-Server: rspam05
X-Stat-Signature: zcehs3srq5we1jrwktjade5f58n8mkux
X-Rspam-User: 
X-HE-Tag: 1759374225-932749
X-HE-Meta: U2FsdGVkX185p5MfLqZ4C41Z/SicA+Qmlhu7lf9oDx7Mx9KaWingcGcgj1lIslw2ZOuaymAq/hdzqE1q4oDhWY4ZMn5InABjvFCGadPt4jm6r+7JokvpOkwNobcGo9ZBBUCqRu7k2dyN9T2Yrcj0fvIUnhVDtuvdRTO7NHB7bNeQkZxYED3Si5ZSEFw/qLzIOa1OacTceEYRp7Pb8lzyxRW1oIF/6Dn7fcYvfxfws+ItdWOuSTOfBcKh6XtSkvDdGmWYsTui4I17ElBscQv5XlbN/C5chjg5vyzEfED9ZnL132XzHDrFfjkvmofT517d2GQoP0K7rBAqE93H1ZZhhgjy98j8toLmHmU5Mt5WqhuIyDIKDNWKhj0hllg5pcgC7h7XmkgBNDua9EG0ms3Qqjr3bkd4ab7F+aEnuP3cDGqs7ve/ol0goGAfrD2iS5wHekBaGQ9Aw6o3n1WJ5GTe/vHNBFkCROov0F3KUeql02H4BfeTqeF1hx6OnBbG3W5R/bn68VRFq3f137y1LuFk63cdgBP5krtgC88z+AYfb5+qU7PdP/x/ot0b5+E403TfpRgiaa11hgcabP0aLSDPKIZBYdkNbOAG8EMAYTFMJMyPZMqCqDLa3VcZqjBywBKZRq3iG/AiTvFHHiEAGov2GNfjLa+H1TPB4flYR9DNnX65RdyOHpL7J9yIg8SWZxEy0PLODcatuNINRxYMYDV1IyM6PtCummvh6A7oblefVub4RmHFZu7sCfk9e6wUEEkAYDXtyYuzqtUJsUOL5YvOeb6WGferJ8fX7MdfdZzoPLP4xnQT0MDlgWoul/sie+eXvIpRSTkCQt5NXCIgjBDQIVNMF6CktYgpyg44m8hnT4wgD+NriX860VuQXWv0TZ62mWDSqdoOjEudIzQbCe1qk/zHPde9ZwFcf7Sm8ELqe8GrdLZUjt7ELCV7ZLPE9JxkVYDsyCOnYgOMD58KNNF
 cUQ7l+4q
 yz6ur2CAF3RLjpA3waGn+KbgULyO7UnhoD7PMc9snjZ44WTlbB/yE1W4NYlsXPO4ZnBFsKVKBbsWEyNyk02OHQoH9ZsVO/Mw07H+YdT7ZwnpehXCCI9iJl3fKSsBxqvZ9+VBwjZ0Hs4Tvu7BpI6YEE2i1joi0f24+Fqb6IX85KWNswgzqh1Th4PqxbMfp6Hyy1jlohCIsFEVes9ZuEba0Tvz1ODy+Ik9NoHnRO0SC5Fh9CrOByWdcABbNBRsbktIGdxtrurwx3wABw2YvFSb3RHNMile9AVDZPIsRyiZgbrr/RXC+OyQ73d7ZvTuMRbsA92kVD1vdi/WjScQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for removing the node id complexity. Those negative priorities
have been very hard to follow and reason. Now with the extra 18%
performance boost just cherry on top.

I am very happy with this outcome. Could not ask for better.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Mon, Sep 29, 2025 at 11:33=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Swap devices are assumed to have similar accessing speed if no priority
> is specified when swapon. It's unfair and doesn't make sense just because
> one swap device is swapped on firstly, its priority will be higher than
> the one swapped on later.
>
> Here, set all swap devicess to have priority '-1' by default. With this
> change, swap device with default priority will be selected round robin
> when swapping out. This can improve the swapping efficiency a lot among
> multiple swap devices with default priority.
>
> Below are swapon output during processes high pressure vm-scability test
> is being taken:
>
> 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
>    priority from high to low when one swap device is exhausted:
> ------------------------------------
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
>
> 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
>    sharing the same node id is selected firstly until exhausted; while
>    on node no swap device sharing the node id it selects the one with
>    highest priority until exhaustd:
> ------------------------------------
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 15.7G   -2
> /dev/zram1 partition  16G  3.4G   -3
> /dev/zram2 partition  16G  3.4G   -4
> /dev/zram3 partition  16G  2.6G   -5
>
> 3) After this patch applied, swap devices with default priority are selec=
td
>    round robin:
> ------------------------------------
> [root@hp-dl385g10-03 block]# swapon
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G 6.6G   -1
> /dev/zram1 partition  16G 6.6G   -1
> /dev/zram2 partition  16G 6.6G   -1
> /dev/zram3 partition  16G 6.6G   -1
>
> With the change, we can see about 18% efficiency promotion relative to
> node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> the worst.)
>
> vm-scability test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Test with:
> usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
>                             one by one:      node based:      round robin=
:
> System time:                1087.38 s        637.92 s         526.74 s   =
  (lower is better)
> Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/=
s (higher is better)
> Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s=
  (high is better)
> free latency:               15769409.48 us   10138455.99 us   6810119.01 =
us(lower is better)
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  mm/swapfile.c | 31 ++++---------------------------
>  1 file changed, 4 insertions(+), 27 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index f9b3667fb08a..2bd8bd76ea28 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
>  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
>  long total_swap_pages;
> -static int least_priority;
> +#define DEF_SWAP_PRIO  -1
>  unsigned long swapfile_maximum_size;
>  #ifdef CONFIG_MIGRATION
>  bool swap_migration_ad_supported;
> @@ -2534,10 +2534,7 @@ static void setup_swap_info(struct swap_info_struc=
t *si, int prio,
>                             struct swap_cluster_info *cluster_info,
>                             unsigned long *zeromap)
>  {
> -       if (prio >=3D 0)
> -               si->prio =3D prio;
> -       else
> -               si->prio =3D --least_priority;
> +       si->prio =3D prio;
>         /*
>          * the plist prio is negated because plist ordering is
>          * low-to-high, while swap ordering is high-to-low
> @@ -2555,16 +2552,7 @@ static void _enable_swap_info(struct swap_info_str=
uct *si)
>         total_swap_pages +=3D si->pages;
>
>         assert_spin_locked(&swap_lock);
> -       /*
> -        * both lists are plists, and thus priority ordered.
> -        * swap_active_head needs to be priority ordered for swapoff(),
> -        * which on removal of any swap_info_struct with an auto-assigned
> -        * (i.e. negative) priority increments the auto-assigned priority
> -        * of any lower-priority swap_info_structs.
> -        * swap_avail_head needs to be priority ordered for folio_alloc_s=
wap(),
> -        * which allocates swap pages from the highest available priority
> -        * swap_info_struct.
> -        */
> +
>         plist_add(&si->list, &swap_active_head);
>
>         /* Add back to available list */
> @@ -2692,17 +2680,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>         }
>         spin_lock(&p->lock);
>         del_from_avail_list(p, true);
> -       if (p->prio < 0) {
> -               struct swap_info_struct *si =3D p;
> -               int nid;
> -
> -               plist_for_each_entry_continue(si, &swap_active_head, list=
) {
> -                       si->prio++;
> -                       si->list.prio--;
> -                       si->avail_list.prio--;
> -               }
> -               least_priority++;
> -       }
>         plist_del(&p->list, &swap_active_head);
>         atomic_long_sub(p->pages, &nr_swap_pages);
>         total_swap_pages -=3D p->pages;
> @@ -3428,7 +3405,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         }
>
>         mutex_lock(&swapon_mutex);
> -       prio =3D -1;
> +       prio =3D DEF_SWAP_PRIO;
>         if (swap_flags & SWAP_FLAG_PREFER)
>                 prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
>         enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
> --
> 2.41.0
>
>


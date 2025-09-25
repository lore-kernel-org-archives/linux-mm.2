Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9E9CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 04:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51F98E0007; Thu, 25 Sep 2025 00:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29A58E0001; Thu, 25 Sep 2025 00:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FC18E0007; Thu, 25 Sep 2025 00:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFE3C8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:36:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 613C7119624
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:36:42 +0000 (UTC)
X-FDA: 83926511844.01.AC9F1B1
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EB09A0016
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:36:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g7oAUr5L;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758775000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fj8rGJkHIDlvRHZJmqpRK/hYu0VFRhdbohHYayA8boA=;
	b=rdhtw6UppTVxlqAMnFKs8sPSqBWXdLblOK9j5KCAHBwxaGSlCN9Z8uuq+4ZuZyxL9lnQQK
	YRsSirsyuCmfS3Q+S4dSNAP1F+Vc+5GG1JtJ3E+s9ef18Xfbtg3kimq7qZho/DTjjmK6vc
	PtMA+NGOst/Alo6Sw4u/mugzwVBsszc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758775000; a=rsa-sha256;
	cv=none;
	b=MyKmKyig29xc6IZcVCF0vk3VmHSebwCm+P3KwBXaBN5DwOoR81XA04dZ1Jyw4jA1VDoVmP
	xD3UGFSHCeTycYAHqWgRI2S6mo4w2HKI9G78D+ljILzdra2ubqAdVrwXa7JmC7LG/9BoXm
	LcyA6YY+GREIwJk12Qduhd7RdU2ZnyU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g7oAUr5L;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-62fbc90e6f6so748382a12.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758774999; x=1759379799; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fj8rGJkHIDlvRHZJmqpRK/hYu0VFRhdbohHYayA8boA=;
        b=g7oAUr5LWDWCgcB+mZAg9QajF0riqch96lp5/Qxig4CRAouQ5Ir+oAOiQqdwyxCzUc
         Ev8ZOlRsUH5RtUv3yimB5jSHw4c7C0ujtFJf3PB4R2UHcNdTbrCAhod0vFWqiRUv7x62
         jmStSLy6oc3ofJutEpdBYpPeOYP00bysPQ1+L1UfIvl5Tn9CTM5xojpwNdJBBqnlXsWn
         h57VA37mQv3yWiI+940xdL5j71Qpof0eTFCRmz6rP66R1OarTiN0vAcfHy3Fe+5b75x3
         H0NCv8QE/yDZ+ALnY3RBIC1tqJXEtT2ERr9I412NryPqyQh4mn/qadgF2tO+FROuQYiN
         CtRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758774999; x=1759379799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fj8rGJkHIDlvRHZJmqpRK/hYu0VFRhdbohHYayA8boA=;
        b=VT48reFcBUznAxXXEEKkXRPjY65mUwf2QVslJPJ9ltrE93DL7L42vBd9QCW+NVTCa7
         ZZ6ZyVfwL+KezXk7cowpHa9XY7ozL6vWsF9LYSzkCIFqgg9clMDyl5aZE9JzmUkwdQtP
         eLyCaOTenrLZzdt2f88Y2/9mAIWSDktdJK5uFGsTHMP8STke4Ktyj1qOlFGW0cwrzM5m
         GpocxUQP5aYOKQXCcszHnzJIh7W26K3ukJrdHmVluZDgLH2tB6WnBDDa7sZTCKKp1B65
         PCyqHGJARYa59jkQ5dp2nJJvSRDzo+FiL9f8ynNzhEA6sDF0revmh3xZ4tCoAjFFUyj9
         1/yw==
X-Gm-Message-State: AOJu0YzoaAGSn03/z2f7TiIlCU2KztlsPB/B45I6FCBdfdGVz12UqJwZ
	iu/cI0dlnPYhCDLltG59LF2uQR9U4aPhwbol6AXRTDxDaB5RpO5/oESqhe1lqVwSpQPxUnWLnfj
	yn8JSdWN4coCZv15INygzEPZ4+pAk/ZQ=
X-Gm-Gg: ASbGncvQFqm2lX5BsPyJJQX55A1/01v/s2LQM8eWtkrFf4Q4QC6hZzAWZm7ohSJRGJ/
	GQk8dkhLd7ICSmq6jlABWZSwxHMSmXI2Dp74ZS4XenNk8fU76ZR1QdlKgXxFiTxQDBjwxAb8eZo
	dE2wqyQw41ayVb6frF+lEvgvDxXnQ15ppvgkwPCKOSp9w4S53d90MywANc9wbtFc54FWaxAVFW2
	829MJo=
X-Google-Smtp-Source: AGHT+IHF0DtgUGVgOvTfiiCPSq+YQg/mYlKm3uWFMnJ7A1YEowAH7OW0bylFs/noUifPfsqZhwJEkhAd9OP8JMoVpEY=
X-Received: by 2002:a05:6402:1e8a:b0:62f:bc3f:abb8 with SMTP id
 4fb4d7f45d1cf-6349fa73e43mr1497315a12.24.1758774998606; Wed, 24 Sep 2025
 21:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250924091746.146461-1-bhe@redhat.com>
In-Reply-To: <20250924091746.146461-1-bhe@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 25 Sep 2025 12:36:02 +0800
X-Gm-Features: AS18NWDnkSNo9X4bOFLyWd9jfUjiwD4zfCSHLBNqY9du9cNu4ZLiX0MPIsIow8M
Message-ID: <CAMgjq7CtBRjwxCp=HvW5xZUGg-5MgKLOHy2tJ+0GC7KmA1BNjw@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: opo749jgo4dh3n8x38irkcoc5g8qcpi1
X-Rspamd-Queue-Id: 7EB09A0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758775000-331847
X-HE-Meta: U2FsdGVkX1+4yvaIm8z4T0PSe2IcQ1yHluvOoudo7oW3KhrBQ1UW6eJVQxUrAEaBMxm/G7zgD4utRwd1HnWIIoCJ4W8m0gA7IXiZU22qtyqlBSE7uKkJWxtnH8MWFqp2CezRlwDz6nB3Ic7Gz9ohy7IWBvyC4EOetyKHo6bF0yCWPaUeFRkBjsPn8OadaHhxPBxvG5/2gITTj7QNQVTaTCSN7T+0Zu2nmoC4kD0jmsKUMv4V6vnJRp6GXRh85HBfaMnypKLdE3RFJZenoy0TEm1OkWf6hH54oHCSSOMT/LjnAjaoxYtzOQLl3fxB3E4EwewxvhzYLrJd+0BmtB6SmccoNsF3+MN27N22IDeYc/kb1hcaD5z0qfW1BwiXI5ClK4dmNM2hB+mQ5iX9Cnta8qn0neAVXR7s9ZtbEdb3S+k2Tr2ko4e/X2IUBoNKDlJs1hDQA/uO3T3+f6cgVf4by3hmWNIdu9Dx4yrmwpJZQaylazB63LcjDuYcc9Ji/MzsBhfi96DH9/V+S4/GXGbR+5ECmc+t4t0p1RZPj/lUtq0CD5G5UjzuMJ//NCj3cMC0StXN0q0ZJMmVIVtFLPJiMmmfNOacvYtTrN+mgaydNtoTqG7mMX7mFLn7z3JqpbfwHXeX8KvgRElcnJVnoBRE0+MIrJYRcNFndYznXJI4YKGazTq7ZehjQMHnlS7pZCPq1Hq7LgQJfG3Aq2WhNmaKO8PY9w1+2X5WJJQ9+exmPEQ0xJGbxxl7iiEyti7lveZAxui2oQZnzr9PphKNKBNcL51I9+3e6Apg3uTETr6v7ue6JzGaRrWqsjAQz/DTOae46/bL88gnvB5ktvOZ/5aTOkCcSnIJL5rqciTv7EDQm14bimKSRdLdPYguBIo/lRH/zrGRf+sDWv7nAWkyoGbTSak1cHCWnE7v79+qwYjIax+Lp77JbgCHkwzx9/i1Zka1fUBGnevCYBLZ9KEvq9K
 R8rBNyE/
 ON0z+txZ2uBoKvcymiRHNhaRkukK0RYetc1+IueKsxlCa0SGN46JH2fEVJKHGXUlyLe2TN6vKiiOd0gza2sqMmV3QzXDSjFUfwKeD3skX3z/GWCW04fMHtbDuL+kxzFWnFtuWi40I0C/wgedYuxYd6nXHcayN6mPtN1bSlOZUDozuQNlo3/r7kIQa8XpEybdZGyCMKq9oDxA7FDP6b6LO51n1Sp/MF8UGW68LLQFjgkJwZzQj4Xqugl++C8zIiM7ja7y7WvQEhCU1NHvDyxAb2p+YeVvwJ9wRvVP6VbZ+d/Xd/DpvWbNqm3pYrKN8BUDZjVTKt1rn7uUuL9LR6rGJFj1obkDA7G918j+0C95w0uP3NoU1GLys+sstaQ/7Mtxycrk9OiEGd7Osc3bttUdHabBU2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 6:15=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Currently, on system with multiple swap devices, swap allocation will
> select one swap device according to priority. The swap device with the
> highest priority will be chosen to allocate firstly.
>
> People can specify a priority from 0 to 32767 when swapon a swap device,
> or the system will set it from -2 then downwards by default. Meanwhile,
> on NUMA system, the swap device with node_id will be considered first
> on that NUMA node of the node_id.
>
> In the current code, an array of plist, swap_avail_heads[nid], is used
> to organize swap devices on each NUMA node. For each NUMA node, there
> is a plist organizing all swap devices. The 'prio' value in the plist
> is the negated value of the device's priority due to plist being sorted
> from low to high. The swap device owning one node_id will be promoted to
> the front position on that NUMA node, then other swap devices are put in
> order of their default priority.
>
> E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
> swap devices.
>
> Current behaviour:
> their priorities will be(note that -1 is skipped):
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G   0B   -2
> /dev/zram1 partition  16G   0B   -3
> /dev/zram2 partition  16G   0B   -4
> /dev/zram3 partition  16G   0B   -5
>
> And their positions in the 8 swap_avail_lists[nid] will be:
> swap_avail_lists[0]: /* node 0's available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:1     prio:3     prio:4     prio:5
> swap_avali_lists[1]: /* node 1's available swap device list */
> zram1   -> zram0   -> zram2   -> zram3
> prio:1     prio:2     prio:4     prio:5
> swap_avail_lists[2]: /* node 2's available swap device list */
> zram2   -> zram0   -> zram1   -> zram3
> prio:1     prio:2     prio:3     prio:5
> swap_avail_lists[3]: /* node 3's available swap device list */
> zram3   -> zram0   -> zram1   -> zram2
> prio:1     prio:2     prio:3     prio:4
> swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:2     prio:3     prio:4     prio:5
>
> The adjustment for swap device with node_id intended to decrease the
> pressure of lock contention for one swap device by taking different
> swap device on different node. However, the adjustment is very
> coarse-grained. On the node, the swap device sharing the node's id will
> always be selected firstly by node's CPUs until exhausted, then next one.
> And on other nodes where no swap device shares its node id, swap device
> with priority '-2' will be selected firstly until exhausted, then next
> with priority '-3'.
>
> This is the swapon output during the process high pressure vm-scability
> test is being taken. It's clearly shown zram0 is heavily exploited until
> exhausted.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 15.7G   -2
> /dev/zram1 partition  16G  3.4G   -3
> /dev/zram2 partition  16G  3.4G   -4
> /dev/zram3 partition  16G  2.6G   -5
>
> This is unreasonable because swap devices are assumed to have similar
> accessing speed if no priority is specified when swapon. It's unfair and
> doesn't make sense just because one swap device is swapped on firstly,
> its priority will be higher than the one swapped on later.
>
> So here change is made to select the swap device round robin if default
> priority. In code, the plist array swap_avail_heads[nid] is replaced
> with a plist swap_avail_head. Any device w/o specified priority will get
> the same default priority '-1'. Surely, swap device with specified priori=
ty
> are always put foremost, this is not impacted. If you care about their
> different accessing speed, then use 'swapon -p xx' to deploy priority for
> your swap devices.
>
> New behaviour:
>
> swap_avail_list: /* one global available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:1     prio:1     prio:1     prio:1
>
> This is the swapon output during the process high pressure vm-scability
> being taken, all is selected round robin:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@hp-dl385g10-03 linux]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 12.6G   -1
> /dev/zram1 partition  16G 12.6G   -1
> /dev/zram2 partition  16G 12.6G   -1
> /dev/zram3 partition  16G 12.6G   -1
>
> With the change, we can see about 18% efficiency promotion as below:
>
> vm-scability test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Test with:
> usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
>                            Before:          After:
> System time:               637.92 s         526.74 s
> Sum Throughput:            3546.56 MB/s     4207.56 MB/s
> Single process Throughput: 114.40 MB/s      135.72 MB/s
> free latency:              10138455.99 us   6810119.01 us
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h | 11 +-----
>  mm/swapfile.c        | 94 +++++++-------------------------------------
>  2 files changed, 16 insertions(+), 89 deletions(-)

Hi Baoquan,

Thanks to the patch! The node plist thing always looked confusing to me.

>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 3473e4247ca3..f72c8e5e0635 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -337,16 +337,7 @@ struct swap_info_struct {
>         struct work_struct discard_work; /* discard worker */
>         struct work_struct reclaim_work; /* reclaim worker */
>         struct list_head discard_clusters; /* discard clusters list */
> -       struct plist_node avail_lists[]; /*
> -                                          * entries in swap_avail_heads,=
 one
> -                                          * entry per node.
> -                                          * Must be last as the number o=
f the
> -                                          * array is nr_node_ids, which =
is not
> -                                          * a fixed value so have to all=
ocate
> -                                          * dynamically.
> -                                          * And it has to be an array so=
 that
> -                                          * plist_for_each_* can work.
> -                                          */
> +       struct plist_node avail_list;   /* entry in swap_avail_head */
>  };
>
>  static inline swp_entry_t page_swap_entry(struct page *page)
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b4f3cc712580..d8a54e5af16d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
>  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
>  long total_swap_pages;
> -static int least_priority =3D -1;
> +#define DEF_SWAP_PRIO  -1
>  unsigned long swapfile_maximum_size;
>  #ifdef CONFIG_MIGRATION
>  bool swap_migration_ad_supported;
> @@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
>   * is held and the locking order requires swap_lock to be taken
>   * before any swap_info_struct->lock.
>   */
> -static struct plist_head *swap_avail_heads;
> +static PLIST_HEAD(swap_avail_head);
>  static DEFINE_SPINLOCK(swap_avail_lock);
>
>  static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> @@ -995,7 +995,6 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>  /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
>  static void del_from_avail_list(struct swap_info_struct *si, bool swapof=
f)
>  {
> -       int nid;
>         unsigned long pages;
>
>         spin_lock(&swap_avail_lock);
> @@ -1007,7 +1006,7 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>                  * swap_avail_lock, to ensure the result can be seen by
>                  * add_to_avail_list.
>                  */
> -               lockdep_assert_held(&si->lock);
> +               //lockdep_assert_held(&si->lock);

If this needs to be removed, then it doesn't seem to comply with the
comment above?

Here we are modifying si->flags, which is supposed to be protected by si lo=
ck.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55A1CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F588E000E; Wed, 24 Sep 2025 11:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0203D8E0005; Wed, 24 Sep 2025 11:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78128E000E; Wed, 24 Sep 2025 11:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D53958E0005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:55:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D6BF11B005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:55:08 +0000 (UTC)
X-FDA: 83924592696.10.BC352BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D2F540004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:55:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lpfdxij4;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758729306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGzSF11Ta823hlSE+LI00k6h9KcTjG4H+KC3qQJ/IdI=;
	b=f2kgZM1bTgB3WlDT09RORyQvVyD7NyaumaAY0F0D9tc4RensVhri13c8k66tHlki8Z0sc5
	XL9z4dNC6/AQ0mngIpw9ZFQIdVuvylboJWjsE2oKPlAmXgXjVxKzPrZXkl/QmVuOnratIx
	eoPKrEm3uAddq0zfrYJdvp2PS1P3FJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758729306; a=rsa-sha256;
	cv=none;
	b=Cx9TKVHtGz2H+c4gnQM9Rm+a7OuhxqrxJi68wiz8KPMj6P/VVZqBjX9mhRpprOcjyE9U2K
	GfmYyB97Tzl/58caqIaeWeB83Pckd+Y7FDOTDex5zvJ3nCwt7nRhlU9xMX8H974bYkKLQV
	4TMUPMhiGkRd12Eml93JIodGiVGMurk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lpfdxij4;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5F2360146
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836D8C4CEF8
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758729305;
	bh=mWaKqJQWTIFGe0BigPK1ZnmndOQ08YU1NkzJd2JZ00Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Lpfdxij4qavaxZqwzFjE1ZJLZ/yXM1WwPoJI9S81M3AbwKsiskB/jYBugzIxwQfb2
	 B1WuFhWv+Ll+K9asLpyvwVjiueDO0aH5W2IA7kv8a26euYEIZSLozWJm1AWJ8Jo4T5
	 g5P3T0MOjQN2CuP18z6tWSxbyzVF/cEHQQifQdGQK2DxAVoSM9Ia+hcPJLiHS9VMEl
	 iu5Q68QzZdXKVGngprLlwK4OOpyBJqMFgSwixDRr7BaYBxBC6ksHUDW2H5YjPbf1Wv
	 HJhL3eCy7SsHKcdWVh4inSeA6eDwm9SOX3aSukq+47PMe3edsT3pLz+LMuOzJqpJ/Q
	 ZRdwQ8gbDFvDg==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-74435335177so13377827b3.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:55:05 -0700 (PDT)
X-Gm-Message-State: AOJu0YylMLQgttXuhXXIjQ0WrWa6Dybq97y2XwgNgh+G/ERc7yOAUsN3
	fiXLt1nx8kUMvPr8kzZh7WUsLgVDK+cfWT8htaYUbZ5/iLucNo4GY2erEgN1BndFI3rWGr60t2k
	pxXjXPatngaQsjJWHo/kkrs7D5eVai5/IHxkGk7F3Eg==
X-Google-Smtp-Source: AGHT+IE78ztn+WZyu4+hasJOep9F/IkUbRJPBVVD0qJqO2t0rwzT3mHLfZHAffi/r/2UJQg6aMoHhrr6Xq6okvgMiYE=
X-Received: by 2002:a53:d9c5:0:b0:635:4ecf:f0ce with SMTP id
 956f58d0204a3-6361a7490d4mr136611d50.26.1758729304539; Wed, 24 Sep 2025
 08:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250924091746.146461-1-bhe@redhat.com>
In-Reply-To: <20250924091746.146461-1-bhe@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 24 Sep 2025 08:54:53 -0700
X-Gmail-Original-Message-ID: <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
X-Gm-Features: AS18NWD24CMC0QeaC2jNRXrOLtX9kFJ9oxfl5LWI-CF-IrKpHiU1oQLP_zpzwiI
Message-ID: <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6D2F540004
X-Stat-Signature: oqxh7ckogdx3hyopfi7nikhxm1gfzh8b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758729306-742604
X-HE-Meta: U2FsdGVkX187I2jZB+zQeWWdiAgqJyJxml4nZLC4G5iNBIcOsTjP6fyvoWmuelqpSxi5E2BrtZo4q4NN3EEX/zWNrpgP8v4T9KxpmDAb3UMSPYT0rII6D1Nb+QkuKDgIA30VcoE0WG9EVEf3zc+c8zRDmVQEhJnFEN+7bfhtdVeZYqM7FDoOf7wagCtu+ZNkhBaw2vffLcbWJg5XNBJhDiFCpCi6kyTaEEhW7iwMwJ30CK04RipRJSSBTY3Tz1lCkAOYvSeLeL3DP3P8ZsNucqOSipkEMsUyeq8W2+/FVuUDzxkQbuZa27joi8NZqMh1eeJFLfbO2wa0yup4XnE33V0plWfhcymU3+weLeyUWKHgnONGbSrP22Uew73XLIL2KUCrF20LssWeWGMManVqgKUZzXRZmJsP7CSYCxzitMX3TmL8MD/uXbGnn96CbA+6dBE6rCuMs6nVJ61bu6Rswt8huqmwe++WscLiDubQvE1hHQhUsFsa/a5EgGeQCL4BIfyxR0bm5/hValhTpEXlOfsKWQYnN9Mesc01Sl+1/5WLehBnPPWcn57dSukYuOW/M4fVuyR6RhIC88UKAC5T/tWRrLuNIKPiczCs3MeiU2gU3rNBJbO0fee0JoAuc54TCpGbCbiSyopsoz/QGyJ7vYhrCPgJHdxtCHe1R8T9R+X2Ho3nAIXgP5L8xGajDh3TH604R5SYksr6Z5a2gSJ+ycJwcWgXTWgv29LeAD28equkeroQa5bd/O74zy1e658vM2y0GOLKnxw0zLE66sGusVh6/iq4lxsKmAnSP9Q+xV7Y+j1CZws8Oys8gcgDQbkvQCAMOITrQHPR0r2LRtqACnaMf624EzcaBuOtOK257H5j34GC0Yea2STSRqI33iWKChyR6z8dFG5lD03qVL5iS/6D2RFZzd+/yY2ff2HbUepH3CmY8PBPhG/qrb6boWG3cP7QT0poSNiKwVyWupu
 ws1ClRmP
 APk/7oCTKew/xjSMLdHkgbFbUkKDEHooMjbk9f76ZbAVYde+vXbwc8DnXhXn1FUT8ci283S5pBAcYuGOJBJRkyoSvkhtbt2ZDHNKCC3XBybBQMTpm3PDlpCw3w4v08RnF+ijMuX856sntvk03SJsLmJxbIoxmfIdYdD42Dhk7bsdpu4X4KAHqyKfZdHyb8ZgiaFZRxU8JUcAs0ml4FxnYCT0kKq2ow4Pqv85HKlFH9XD1gejBki5gSSTrGHlW4M/4NMQqVCmL+SpkY/Bt9S/G6YJp8Jfo6NsqlLQ1et3cPbT41kVFgFWwbg1c60taSt6o2Vlp8Reqtvdx/Lw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

Very exciting numbers. I have always suspected the per node priority
is not doing much contribution in the new swap allocator world. I did
not expect it to have negative contributions.

On Wed, Sep 24, 2025 at 2:18=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Currently, on system with multiple swap devices, swap allocation will
> select one swap device according to priority. The swap device with the
> highest priority will be chosen to allocate firstly.
>
> People can specify a priority from 0 to 32767 when swapon a swap device,
> or the system will set it from -2 then downwards by default. Meanwhile,
> on NUMA system, the swap device with node_id will be considered first
> on that NUMA node of the node_id.

That behavior was introduced by: a2468cc9bfdf ("swap: choose swap
device according to numa node")
You are effectively reverting that patch and the following fix up
patches on top of that.
The commit message or maybe the title should reflect the reversion nature.

If you did more than the simple revert plus fix up, please document
what additional change you make in this patch.

>
> In the current code, an array of plist, swap_avail_heads[nid], is used
> to organize swap devices on each NUMA node. For each NUMA node, there
> is a plist organizing all swap devices. The 'prio' value in the plist
> is the negated value of the device's priority due to plist being sorted
> from low to high. The swap device owning one node_id will be promoted to
> the front position on that NUMA node, then other swap devices are put in
> order of their default priority.
>

The original patch that introduced it is using SSD as a benchmark.
Here you are using patched zram as a benchmark. You want to explain in
a little bit detail why you choose a different test method. e.g. You
don't have a machine with an SSD device as a raw partition to do the
original test. Compression ram based swap device, zswap or zram is
used a lot more in the data center server and android workload
environment, maybe even in some Linux workstation distro as well.

You can also invite others who do have the spare SSD driver to test
the SSD as a swap device. Maybe with some setup instructions how to
set up and repeat your test on their machine with multiple SSD drives.
How to compare the result with or without your reversion patch.

> E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
> swap devices.

You want to make it clear up front that you are using a patched zram
to simulate the per node swap device behavior. Native zram does not
have that.

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

Any tips how others repeat your high pressure vm-scability test,
especially for someone who has multiple SSD drives as a test swap
device. Some test script setup would be nice. You can post the
instruction in the same email thread as separate email, it does not
have to be in the commit message.

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
You can clarify here lower is better.
> Sum Throughput:            3546.56 MB/s     4207.56 MB/s

Higher is better. Also a percentage number can be useful here. e.g.
that is +18.6% percent improvement since reverting to round robin. A
huge difference!

> Single process Throughput: 114.40 MB/s      135.72 MB/s
Higher is better.
> free latency:              10138455.99 us   6810119.01 us
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h | 11 +-----
>  mm/swapfile.c        | 94 +++++++-------------------------------------

Very nice patch stats! Fewer code and runs faster. What more can we ask for=
?


>  2 files changed, 16 insertions(+), 89 deletions(-)
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

That seems like some debug stuff left over. If you need to remove it, remov=
e it.

The rest of the patch looks fine to me. Thanks for working on it. That
is a very nice cleanup.

Agree with YoungJun Park on removing the numa swap document as well.

Looking forward to your refresh version. I should be able to Ack-by on
your next version.

Chris


>                 si->flags &=3D ~SWP_WRITEOK;
>                 atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>         } else {
> @@ -1024,8 +1023,7 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>                         goto skip;
>         }
>
> -       for_each_node(nid)
> -               plist_del(&si->avail_lists[nid], &swap_avail_heads[nid]);
> +       plist_del(&si->avail_list, &swap_avail_head);
>
>  skip:
>         spin_unlock(&swap_avail_lock);
> @@ -1034,7 +1032,6 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>  /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
>  static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
>  {
> -       int nid;
>         long val;
>         unsigned long pages;
>
> @@ -1067,8 +1064,7 @@ static void add_to_avail_list(struct swap_info_stru=
ct *si, bool swapon)
>                         goto skip;
>         }
>
> -       for_each_node(nid)
> -               plist_add(&si->avail_lists[nid], &swap_avail_heads[nid]);
> +       plist_add(&si->avail_list, &swap_avail_head);
>
>  skip:
>         spin_unlock(&swap_avail_lock);
> @@ -1211,16 +1207,14 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>  static bool swap_alloc_slow(swp_entry_t *entry,
>                             int order)
>  {
> -       int node;
>         unsigned long offset;
>         struct swap_info_struct *si, *next;
>
> -       node =3D numa_node_id();
>         spin_lock(&swap_avail_lock);
>  start_over:
> -       plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avai=
l_lists[node]) {
> +       plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list)=
 {
>                 /* Rotate the device and switch to a new cluster */
> -               plist_requeue(&si->avail_lists[node], &swap_avail_heads[n=
ode]);
> +               plist_requeue(&si->avail_list, &swap_avail_head);
>                 spin_unlock(&swap_avail_lock);
>                 if (get_swap_device_info(si)) {
>                         offset =3D cluster_alloc_swap_entry(si, order, SW=
AP_HAS_CACHE);
> @@ -1245,7 +1239,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>                  * still in the swap_avail_head list then try it, otherwi=
se
>                  * start over if we have not gotten any slots.
>                  */
> -               if (plist_node_empty(&next->avail_lists[node]))
> +               if (plist_node_empty(&si->avail_list))
>                         goto start_over;
>         }
>         spin_unlock(&swap_avail_lock);
> @@ -2535,44 +2529,18 @@ static int setup_swap_extents(struct swap_info_st=
ruct *sis, sector_t *span)
>         return generic_swapfile_activate(sis, swap_file, span);
>  }
>
> -static int swap_node(struct swap_info_struct *si)
> -{
> -       struct block_device *bdev;
> -
> -       if (si->bdev)
> -               bdev =3D si->bdev;
> -       else
> -               bdev =3D si->swap_file->f_inode->i_sb->s_bdev;
> -
> -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> -}
> -
>  static void setup_swap_info(struct swap_info_struct *si, int prio,
>                             unsigned char *swap_map,
>                             struct swap_cluster_info *cluster_info,
>                             unsigned long *zeromap)
>  {
> -       int i;
> -
> -       if (prio >=3D 0)
> -               si->prio =3D prio;
> -       else
> -               si->prio =3D --least_priority;
> +       si->prio =3D prio;
>         /*
>          * the plist prio is negated because plist ordering is
>          * low-to-high, while swap ordering is high-to-low
>          */
>         si->list.prio =3D -si->prio;
> -       for_each_node(i) {
> -               if (si->prio >=3D 0)
> -                       si->avail_lists[i].prio =3D -si->prio;
> -               else {
> -                       if (swap_node(si) =3D=3D i)
> -                               si->avail_lists[i].prio =3D 1;
> -                       else
> -                               si->avail_lists[i].prio =3D -si->prio;
> -               }
> -       }
> +       si->avail_list.prio =3D -si->prio;
>         si->swap_map =3D swap_map;
>         si->cluster_info =3D cluster_info;
>         si->zeromap =3D zeromap;
> @@ -2721,20 +2689,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
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
> -                       for_each_node(nid) {
> -                               if (si->avail_lists[nid].prio !=3D 1)
> -                                       si->avail_lists[nid].prio--;
> -                       }
> -               }
> -               least_priority++;
> -       }
>         plist_del(&p->list, &swap_active_head);
>         atomic_long_sub(p->pages, &nr_swap_pages);
>         total_swap_pages -=3D p->pages;
> @@ -2972,9 +2926,8 @@ static struct swap_info_struct *alloc_swap_info(voi=
d)
>         struct swap_info_struct *p;
>         struct swap_info_struct *defer =3D NULL;
>         unsigned int type;
> -       int i;
>
> -       p =3D kvzalloc(struct_size(p, avail_lists, nr_node_ids), GFP_KERN=
EL);
> +       p =3D kvzalloc(sizeof(struct swap_info_struct), GFP_KERNEL);
>         if (!p)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -3013,8 +2966,7 @@ static struct swap_info_struct *alloc_swap_info(voi=
d)
>         }
>         p->swap_extent_root =3D RB_ROOT;
>         plist_node_init(&p->list, 0);
> -       for_each_node(i)
> -               plist_node_init(&p->avail_lists[i], 0);
> +       plist_node_init(&p->avail_list, 0);
>         p->flags =3D SWP_USED;
>         spin_unlock(&swap_lock);
>         if (defer) {
> @@ -3282,9 +3234,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       if (!swap_avail_heads)
> -               return -ENOMEM;
> -
>         si =3D alloc_swap_info();
>         if (IS_ERR(si))
>                 return PTR_ERR(si);
> @@ -3465,7 +3414,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         }
>
>         mutex_lock(&swapon_mutex);
> -       prio =3D -1;
> +       prio =3D DEF_SWAP_PRIO;
>         if (swap_flags & SWAP_FLAG_PREFER)
>                 prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
>         enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
> @@ -3904,7 +3853,6 @@ static bool __has_usable_swap(void)
>  void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  {
>         struct swap_info_struct *si, *next;
> -       int nid =3D folio_nid(folio);
>
>         if (!(gfp & __GFP_IO))
>                 return;
> @@ -3923,8 +3871,8 @@ void __folio_throttle_swaprate(struct folio *folio,=
 gfp_t gfp)
>                 return;
>
>         spin_lock(&swap_avail_lock);
> -       plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
> -                                 avail_lists[nid]) {
> +       plist_for_each_entry_safe(si, next, &swap_avail_head,
> +                                 avail_list) {
>                 if (si->bdev) {
>                         blkcg_schedule_throttle(si->bdev->bd_disk, true);
>                         break;
> @@ -3936,18 +3884,6 @@ void __folio_throttle_swaprate(struct folio *folio=
, gfp_t gfp)
>
>  static int __init swapfile_init(void)
>  {
> -       int nid;
> -
> -       swap_avail_heads =3D kmalloc_array(nr_node_ids, sizeof(struct pli=
st_head),
> -                                        GFP_KERNEL);
> -       if (!swap_avail_heads) {
> -               pr_emerg("Not enough memory for swap heads, swap is disab=
led\n");
> -               return -ENOMEM;
> -       }
> -
> -       for_each_node(nid)
> -               plist_head_init(&swap_avail_heads[nid]);
> -
>         swapfile_maximum_size =3D arch_max_swapfile_size();
>
>  #ifdef CONFIG_MIGRATION
> --
> 2.41.0
>
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15A8CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 02:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484078E0003; Wed,  1 Oct 2025 22:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434AE8E0002; Wed,  1 Oct 2025 22:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A078E0003; Wed,  1 Oct 2025 22:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 227668E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:57:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DB75C030F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:57:22 +0000 (UTC)
X-FDA: 83951663124.07.5819C95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C221940005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:57:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oobs3cNy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759373840; a=rsa-sha256;
	cv=none;
	b=vfocPHBMUcjE+raVNmqkf/QhofY1hh/1vQq/PE0w9EfTIoRWJF+L9I8x/88LyNIjeD9JhO
	P1KpSYR2OmEBei1Bs8QNBMJWzz7Ph3ixOh1/VuPvOsJqm/9SG/ThQqpeI0R0nvs6q6i7vj
	OBhFYs9KFyWixUL1FRDvOuiwAHV0+QU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oobs3cNy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759373840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbAmYiOtkB6AdSUIvOR2rx8A/ASdBhwGt5tCY8f05lQ=;
	b=sxQgBfXKx1355bgJLOJ2qejoyxsobUcE+Tpr4AToFZ2SaB9E9CJraBEVJ2fP0qtFgp2mrN
	FWwEhSDDl8haDOMXVk5t5seKnXpFF6Ad+nl0eD6RpFZEXvi6SHjP6BwhCqjXfToNYAZTXi
	Ir+h5qO+bP2BYf4AGlwTpPO05318yo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F06DC63D2C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B824C4CEF7
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759373839;
	bh=Ch46zqDqQ4px2xvmehHO7hng1rhx+9R7ppJv1QCl3Yo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Oobs3cNyBRssluCX4AWZ5cSpxz62ApsruvBxdpa6I5Not+G36fti1b0o7uJj1eZU5
	 gCS6LuHNuFnL0Brif3GorOZ4Zd2+KmXeWp2As2D8RqCChiv3xFJj9fyLYdV/GwWpRn
	 mmRzcYA/n6iXrZo31duEiitasUykUIbJ7mE5hIB4z4HHTFple2/IGKc3ZfcfocJwu1
	 SfRWQu/Qy7ReXUWDdpd6+KjDio83OmYV51auOuzd2NnTI6MMm2c7xlI7y0cXAiRr1q
	 UINqPxgHyYehft6mAF2avAHfQ/mH6cy6SYEXZR/Ip7w9bu0OEm9WB0GNpthJl4lozg
	 I6lbS6Jng+Wcw==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-74625f748a0so6865027b3.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 19:57:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YxAn7M7ZnWTSon513ZoKLIcFp1+ZgNXeeaxS2kGrXSYS5QJOfCC
	8eGDdw/0TTKca8g3vhx4vW5HXA2fm/GkpDLKiMTOWtVT11bY//0Nmjk1J/3iIcYeAH9aACXlBTd
	qpji/VAymj7mHWSwPptRD3+aPFceH0yMurHjUBF874g==
X-Google-Smtp-Source: AGHT+IFnLZn8soL+ZKL+UnxUO4yIsl3jkCAc5ECSSR1dzkhQyUKd08/WmPvoG9BE+U8yRnTHLK0W07KhWX+FhNrYWJg=
X-Received: by 2002:a05:690e:2066:b0:635:4ecd:75a3 with SMTP id
 956f58d0204a3-63b700a6ccbmr6150636d50.49.1759373838795; Wed, 01 Oct 2025
 19:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250930063311.14126-1-bhe@redhat.com> <20250930063311.14126-2-bhe@redhat.com>
In-Reply-To: <20250930063311.14126-2-bhe@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 1 Oct 2025 19:57:07 -0700
X-Gmail-Original-Message-ID: <CACePvbV99m+9hAjC0=RPxEWeAyxACDkp1nWz-=WGtyxN7=LGLQ@mail.gmail.com>
X-Gm-Features: AS18NWDJrdngrGuh0UXAELVoI52ptiwhoktxLYn6Hkc1d3VESudOxDYE_VsZI7o
Message-ID: <CACePvbV99m+9hAjC0=RPxEWeAyxACDkp1nWz-=WGtyxN7=LGLQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/swap: do not choose swap device according to
 numa node
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C221940005
X-Stat-Signature: swik7hpka7r3ty55hphbb5fx74s47oqo
X-Rspam-User: 
X-HE-Tag: 1759373840-156767
X-HE-Meta: U2FsdGVkX1+LezuNm3U57M6NE5iOlwctb3A8okXZM5mQ/cbwHDf4iPRZ+bR9oZQzUydmMLPRpcyYfyKoamqVExHqNSQ4ezuqrB9wKcwptlbf2QYP2dPWK8sURegmg+eFrFQXiuaIIKlFM23hGR7Fn5/XtANedNdslDRs4ks8zEDczpfFZqg9xcsUYSZETMuE0IfVlUxjOA5t5kZ86Mw+vO5wdNqFIQGKAk1elmdoKgv0cf3ZwPeK9qvh5pjxEWkWwErSm0e1KYR2xoQOHOmNLB/weVBvPVZjY69RexBBFkv5WwWZ+Hb9uwmVDIoNG/zmX5QhKN+5JnqspD2aBmLL09VGulbKykTrAdIkGNHPDfaeaNtHgXhZig+flX5Cl7fRMCNPtP8P4sqNfd9/rZXujaa/Px2wd1tEKdWnXsbl/sJbDLOMssb8z4sc2OmSMbiE30qhkLkg8cjMD6NnAk4LhsFiUGNfuMOgLwf+OUF18jGgPqtqeG4kh5CzHUxGd8Fa3MWmm+nbWUmROpVJroIiKBw8oukGyINzXfafKiAbGoCtMfX29+awvRIcmoo+JBOevdGbLv+tZCK0UfyRL9f6TWUGPHEs6VUHcV5F1i9RqTD32NiVcPZPqyT9p9iAS04eobOKYA6KMZr4zqTKgDOkipzWehHlnbpY2q9eJXtysemz+6eANJe9cyDqPZ8m+iaAjvgVLz77OXTnKXXGEowlnp5JD2RzGeGMOV/vFQUmh0nJGUzzcHd0FKrDHr+KX3wDXU78NKaEzXxIrN2O6rg/aacnm9CG96EXD2PAxRA8xS0oJsov16263Mp2a8jZTn7F9HCkzt1HJVOzxBoJFBnsdhJSGuqBv/TdlFQRZcOw/Ox4Sj7XcFrjpsVF4sZmaT2Sxq0u97+lCfXCtoFGXcOA0uDjUL2m7X6P1fzSfb74p0/wkpAOiODH08wVgnk1V5YFiZkxYaDN63D1Yvzfiev
 WrdbT6jk
 qpYKYsQqJKokuPeiVSE133g+lEwOdqTCC1CayLHSLFxpNaG4OQyLo4kVIkdnzfZSszC5RowBraEqf6UzkcEJCkVfcL6JuO0pmawTu7mkk4dd988mEgLm+uyAU6C/miFWsCx0l9Nh/VajuJrXkTrYohD2hQcP3tWj85dQGwggjOpfKfUyrLQX0zlYb3hpE2aNyPzvZ8IjfNwbIjGgNa0D3UdSyw/zqqrgJzOe0hGfBRL5AdBap4RFSYORcoDbc6d4psKyNGOQ9hCnv+uZJyktyI1Or9y0C0Xzt1ojEqr+G6MdXlZOtRXXtGGqnuAute2/S0LrlPlqVDIYKKh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Mon, Sep 29, 2025 at 11:33=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> This reverts commit a2468cc9bfdf ("swap: choose swap device according
> to numa node").
>
> After this patch, the behaviour will change back to pre-commit
> a2468cc9bfdf. Means the priority will be set from -1 then downwards by
> default, and when swapping, it will exhault swap device one by one
> according to priority from high to low. This is preparation work for
> later change.
>
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  Documentation/admin-guide/mm/swap_numa.rst | 78 ----------------------
>  include/linux/swap.h                       | 11 +--
>  mm/swapfile.c                              | 76 ++++-----------------
>  3 files changed, 14 insertions(+), 151 deletions(-)
>  delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst
>
> diff --git a/Documentation/admin-guide/mm/swap_numa.rst b/Documentation/a=
dmin-guide/mm/swap_numa.rst
> deleted file mode 100644
> index 2e630627bcee..000000000000
> --- a/Documentation/admin-guide/mm/swap_numa.rst
> +++ /dev/null
> @@ -1,78 +0,0 @@
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -Automatically bind swap device to numa node
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -
> -If the system has more than one swap device and swap device has the node
> -information, we can make use of this information to decide which swap
> -device to use in get_swap_pages() to get better performance.
> -
> -
> -How to use this feature
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -
> -Swap device has priority and that decides the order of it to be used. To=
 make
> -use of automatically binding, there is no need to manipulate priority se=
ttings
> -for swap devices. e.g. on a 2 node machine, assume 2 swap devices swapA =
and
> -swapB, with swapA attached to node 0 and swapB attached to node 1, are g=
oing
> -to be swapped on. Simply swapping them on by doing::
> -
> -       # swapon /dev/swapA
> -       # swapon /dev/swapB
> -
> -Then node 0 will use the two swap devices in the order of swapA then swa=
pB and
> -node 1 will use the two swap devices in the order of swapB then swapA. N=
ote
> -that the order of them being swapped on doesn't matter.
> -
> -A more complex example on a 4 node machine. Assume 6 swap devices are go=
ing to
> -be swapped on: swapA and swapB are attached to node 0, swapC is attached=
 to
> -node 1, swapD and swapE are attached to node 2 and swapF is attached to =
node3.
> -The way to swap them on is the same as above::
> -
> -       # swapon /dev/swapA
> -       # swapon /dev/swapB
> -       # swapon /dev/swapC
> -       # swapon /dev/swapD
> -       # swapon /dev/swapE
> -       # swapon /dev/swapF
> -
> -Then node 0 will use them in the order of::
> -
> -       swapA/swapB -> swapC -> swapD -> swapE -> swapF
> -
> -swapA and swapB will be used in a round robin mode before any other swap=
 device.
> -
> -node 1 will use them in the order of::
> -
> -       swapC -> swapA -> swapB -> swapD -> swapE -> swapF
> -
> -node 2 will use them in the order of::
> -
> -       swapD/swapE -> swapA -> swapB -> swapC -> swapF
> -
> -Similaly, swapD and swapE will be used in a round robin mode before any
> -other swap devices.
> -
> -node 3 will use them in the order of::
> -
> -       swapF -> swapA -> swapB -> swapC -> swapD -> swapE
> -
> -
> -Implementation details
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -
> -The current code uses a priority based list, swap_avail_list, to decide
> -which swap device to use and if multiple swap devices share the same
> -priority, they are used round robin. This change here replaces the singl=
e
> -global swap_avail_list with a per-numa-node list, i.e. for each numa nod=
e,
> -it sees its own priority based list of available swap devices. Swap
> -device's priority can be promoted on its matching node's swap_avail_list=
.
> -
> -The current swap device's priority is set as: user can set a >=3D0 value=
,
> -or the system will pick one starting from -1 then downwards. The priorit=
y
> -value in the swap_avail_list is the negated value of the swap device's
> -due to plist being sorted from low to high. The new policy doesn't chang=
e
> -the semantics for priority >=3D0 cases, the previous starting from -1 th=
en
> -downwards now becomes starting from -2 then downwards and -1 is reserved
> -as the promoted value. So if multiple swap devices are attached to the s=
ame
> -node, they will all be promoted to priority -1 on that node's plist and =
will
> -be used round robin before any other swap devices.
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1ee5c0bc4b25..5b7a39b20f58 100644
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
> index b4f3cc712580..f9b3667fb08a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
>  EXPORT_SYMBOL_GPL(nr_swap_pages);
>  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock=
 */
>  long total_swap_pages;
> -static int least_priority =3D -1;
> +static int least_priority;
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
> @@ -2535,25 +2529,11 @@ static int setup_swap_extents(struct swap_info_st=
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
>         if (prio >=3D 0)
>                 si->prio =3D prio;
>         else
> @@ -2563,16 +2543,7 @@ static void setup_swap_info(struct swap_info_struc=
t *si, int prio,
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
> @@ -2728,10 +2699,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>                 plist_for_each_entry_continue(si, &swap_active_head, list=
) {
>                         si->prio++;
>                         si->list.prio--;
> -                       for_each_node(nid) {
> -                               if (si->avail_lists[nid].prio !=3D 1)
> -                                       si->avail_lists[nid].prio--;
> -                       }
> +                       si->avail_list.prio--;
>                 }
>                 least_priority++;
>         }
> @@ -2972,9 +2940,8 @@ static struct swap_info_struct *alloc_swap_info(voi=
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
> @@ -3013,8 +2980,7 @@ static struct swap_info_struct *alloc_swap_info(voi=
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
> @@ -3282,9 +3248,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
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
> @@ -3904,7 +3867,6 @@ static bool __has_usable_swap(void)
>  void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  {
>         struct swap_info_struct *si, *next;
> -       int nid =3D folio_nid(folio);
>
>         if (!(gfp & __GFP_IO))
>                 return;
> @@ -3923,8 +3885,8 @@ void __folio_throttle_swaprate(struct folio *folio,=
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
> @@ -3936,18 +3898,6 @@ void __folio_throttle_swaprate(struct folio *folio=
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


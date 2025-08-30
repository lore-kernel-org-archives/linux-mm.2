Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE0EECA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 04:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09428E0003; Sat, 30 Aug 2025 00:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC2A8E0001; Sat, 30 Aug 2025 00:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA89C8E0003; Sat, 30 Aug 2025 00:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C639B8E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:08:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96DF9BC72D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:08:04 +0000 (UTC)
X-FDA: 83832090888.01.D0BFFB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4FFDA000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:08:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZpDZxWQ;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756526882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PavnXWJOHlvi/tmV9LjRCwz6GfQ6b2mqdBvuSK6jcFk=;
	b=fN+gqrl2XD4dKKZeM5zBli742bZzsXElvEF3Y7NnspDP4rtM73KbnLHG3fa6QTzM379YD3
	/oiagIJMePb35Bdvg0XoPwRF2M2TYI0i9uG5O2eMXnKJffLeBGQAfwrtXyzkMyOZ+asGOi
	oB3T2OZqWLO15WR9uc5Jlp7+O/D4vvQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZpDZxWQ;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756526882; a=rsa-sha256;
	cv=none;
	b=tNoCVYUbxrtikPXZscBfzCfizVE0d/Um7Vzd2q1T/ZLuFC5MP5oyDuixCetQlRQ8SXn0Qt
	UgJT7B6Y4zwCn4zNZ2hevCPrwL4K3OLne4LDyGJqfizG9LH+6ro6aQ1UNGTMRTgkPE1sl5
	2Y+YmTNfMuZtudO48y4sZ/4eG3MzP9M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C6BF44535
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81649C4CEFD
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756526881;
	bh=WE5PVICidQ/Af11xBg6ROnfejgezwmEu2dAUnN1Ax9s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eZpDZxWQT3IG2krT879UGpSzN5RzbGHJh4R0zVZ7uGMiUHn9vzgyEpNesCpzJttIP
	 Wavmb7fxmdjDfdyIznYFmLzyccor4zA7tB8+KZNJ54JnHtfYdh/+3/AZRVUJRMosxE
	 bDnlQNOvVF6AtmC+vvYY7aJH7NwsrQaiwftxlHF0/3oX1YaFzsq44Zlnj01PYssn6p
	 f0aFN4/rZmKMckNvoqCgwhnZxrKLQkV8RI4Vq1pdejiy5cfPu+wbeykDcUUNm9/77C
	 bLEuAt8rlvFGiUCMdqkSSI9cI1haGMJUhDn0bDrubL+QdOEiOiXOKsCIzUaqEgzzrj
	 1xiglQJrE1AUg==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d5fb5e34cso26351827b3.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:08:01 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx1f3q6hxWSpVB/2Lq88giunksOYSlM/EfsGVlhi1s70+WufAhi
	sodIQviUnVm/9pOxBD8vHZp/iXDFJLi+9pve+dkvZD32aQJPGJ2vfuPdzgnb2fYriWYtrmfwLgn
	S+GAj0JAZNhcZor+l4BgM/tJcDp4xRsLG71T9dPs3HQ==
X-Google-Smtp-Source: AGHT+IEGj0eWIZC0zESlF+y3aUbu6XK1GeXnZhulqFwB5QqMwxUlAK1udpHTk2v6e+YYWXkxZsvYyAECgDQ3J6/NAFw=
X-Received: by 2002:a05:690c:55c6:b0:720:950:1559 with SMTP id
 00721157ae682-72273d26f59mr12885407b3.17.1756526880512; Fri, 29 Aug 2025
 21:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-8-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-8-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 21:07:49 -0700
X-Gmail-Original-Message-ID: <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com>
X-Gm-Features: Ac12FXzbMtEozPRn03rr8JMWk3TBwwY9nmEZgIuso-7nlwmYTCX6dNBl0fu1UwE
Message-ID: <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4FFDA000D
X-Stat-Signature: gpyuf6c91uwr3xgmkyjeeiex8t6wmb4j
X-Rspam-User: 
X-HE-Tag: 1756526882-994968
X-HE-Meta: U2FsdGVkX18NYBT7X2xvX7KQxRiekLmQ9rFl11dpYEGh5UL4fd43zXJ+6iCqGlQMEONp8j+UJtCTghEka04YRAIOwJ3I7xHvXIJxy5P0RcoS8NllPp7aULZNaHn1eKmWy5AUEmw8LdFEng/V9YzrHioPYCBYp5AubDkr8SupxwhEGg7CCTcKyTyvdNnZ7pYDviZDgbjMamZC8/qPtoVSn5xsAqgudDlY9DJdIA/b/M69HUDgeAqxw7AWoAueqb9bosZd8M2Ytlvie5Pjbh1DVS2nZxcFU6odJwTPZ3SqQkNr0kMWl78YEvwgAPqY2DnSOh86kkfyj6sWMUWW3pbyDlJ63NE46nE/lcD2sgOFPGlaDaV5U2X0HOv4/qF5lTN0qxWRqRtSeouco9mJqADn3YPwCE7ITAimdj1x7Fx70ZT7YvyjBFas61mM3OyIZPeiGtmjalne8fUOVJEJWsJscTubFAhC9Iqjc+8+YaK2l6L2EfNQDbW9CdEjMCvsWwNsmIgugUbVgT6YGLp15a6nwuwzPzkvU0x7esjvJwsM7hKjpLiKQUH0xjukBn/FwmSiG4jpIT7kX6QpZ+YMXpg2hcjchPFR5kUMSKc0Z54gFlX5zZSo4kW1RwA1Gqv90V4VeliCskUQpnw4S6qm/bywVZNSLc1aS3tAlLtXbPq53daWdMv6g/xqa1zX9gcOhM/GoUdaAy2NLsr7qMUYHl9c6Sa9AkiZY3ErTrbK3DfJ/GIjUdZt5YjdSw8abGd1gaDVOA2jFO3Rb9CEWFu5Z7GU/b7yyVvBaEjLdMNm7p39ddOghKO5Kt/GAYQvakb/ApnWBc4vFc91uGhT91Vr/EF0Whkk1X4YNfXuj/yqrPuqfd62QEG9gXFeu5epHfB7hFKoHXUIbUt37Ru9bxUVL30hWfp7BfHNyoJF9BTw2UcHisE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

It feels so good to remove that 64M swap cache space. Thank you for
making it happen.

Some nitpick follows. I am fine as is as well.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cluster setup will try to shuffle the clusters on initialization.
> It was helpful to avoid contention for the swap cache space. The cluster
> size (2M) was much smaller than each swap cache space (64M), so shuffling
> the cluster means the allocator will try to allocate swap slots that are
> in different swap cache spaces for each CPU, reducing the chance of two
> CPUs using the same swap cache space, and hence reducing the contention.
>
> Now, swap cache is managed by swap clusters, this shuffle is pointless.
> Just remove it, and clean up related macros.
>
> This should also improve the HDD swap performance as shuffling IO is a
> bad idea for HDD, and now the shuffling is gone.

Did you have any numbers to prove that :-). Last time the swap
allocator stress testing has already destroyed two of my SAS drives
dedicated for testing. So I am not very keen on running the HDD swap
stress test. The HDD swap stress test are super slow to run, it takes
ages.

>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.co=
m
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h     |  4 ----
>  mm/swapfile.c | 32 ++++++++------------------------
>  mm/zswap.c    |  7 +++++--
>  3 files changed, 13 insertions(+), 30 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 4af42bc2cd72..ce3ec62cc05e 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -153,10 +153,6 @@ int swap_writeout(struct folio *folio, struct swap_i=
ocb **swap_plug);
>  void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)=
;
>
>  /* linux/mm/swap_state.c */
> -/* One swap address space for each 64M swap space */
> -#define SWAP_ADDRESS_SPACE_SHIFT       14
> -#define SWAP_ADDRESS_SPACE_PAGES       (1 << SWAP_ADDRESS_SPACE_SHIFT)
> -#define SWAP_ADDRESS_SPACE_MASK                (SWAP_ADDRESS_SPACE_PAGES=
 - 1)
>  extern struct address_space swap_space __ro_after_init;
>  static inline struct address_space *swap_address_space(swp_entry_t entry=
)
>  {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index df68b5e242a6..0c8001c99f30 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3203,21 +3203,14 @@ static int setup_swap_map(struct swap_info_struct=
 *si,
>         return 0;
>  }
>
> -#define SWAP_CLUSTER_INFO_COLS                                         \
> -       DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
> -#define SWAP_CLUSTER_SPACE_COLS                                         =
       \
> -       DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
> -#define SWAP_CLUSTER_COLS                                              \
> -       max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_CO=
LS)
> -
>  static struct swap_cluster_info *setup_clusters(struct swap_info_struct =
*si,
>                                                 union swap_header *swap_h=
eader,
>                                                 unsigned long maxpages)
>  {
>         unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLU=
STER);
>         struct swap_cluster_info *cluster_info;
> -       unsigned long i, j, idx;
>         int err =3D -ENOMEM;
> +       unsigned long i;

Nitpick: This line location change is not necessary.

>
>         cluster_info =3D kvcalloc(nr_clusters, sizeof(*cluster_info), GFP=
_KERNEL);
>         if (!cluster_info)
> @@ -3266,22 +3259,13 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
>                 INIT_LIST_HEAD(&si->frag_clusters[i]);
>         }
>
> -       /*
> -        * Reduce false cache line sharing between cluster_info and
> -        * sharing same address space.
> -        */
> -       for (j =3D 0; j < SWAP_CLUSTER_COLS; j++) {
> -               for (i =3D 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_=
COLS); i++) {
> -                       struct swap_cluster_info *ci;
> -                       idx =3D i * SWAP_CLUSTER_COLS + j;
> -                       ci =3D cluster_info + idx;
> -                       if (idx >=3D nr_clusters)
> -                               continue;
> -                       if (ci->count) {
> -                               ci->flags =3D CLUSTER_FLAG_NONFULL;
> -                               list_add_tail(&ci->list, &si->nonfull_clu=
sters[0]);
> -                               continue;
> -                       }
> +       for (i =3D 0; i < nr_clusters; i++) {
> +               struct swap_cluster_info *ci =3D &cluster_info[i];

struct swap_cluster_info *ci =3D cluster_info + i;
looks simpler. Pure nitpick and personal preference, you don't have to
follow it.

> +
> +               if (ci->count) {
> +                       ci->flags =3D CLUSTER_FLAG_NONFULL;
> +                       list_add_tail(&ci->list, &si->nonfull_clusters[0]=
);
> +               } else {
>                         ci->flags =3D CLUSTER_FLAG_FREE;
>                         list_add_tail(&ci->list, &si->free_clusters);
>                 }
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c869859eec77..c0a9be14a725 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -237,10 +237,13 @@ static bool zswap_has_pool;
>  * helpers and fwd declarations
>  **********************************/
>
> +/* One swap address space for each 64M swap space */
> +#define ZSWAP_ADDRESS_SPACE_SHIFT 14
> +#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
>  static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  {
>         return &zswap_trees[swp_type(swp)][swp_offset(swp)
> -               >> SWAP_ADDRESS_SPACE_SHIFT];
> +               >> ZSWAP_ADDRESS_SPACE_SHIFT];
>  }
>
>  #define zswap_pool_debug(msg, p)                               \
> @@ -1771,7 +1774,7 @@ int zswap_swapon(int type, unsigned long nr_pages)
>         struct xarray *trees, *tree;
>         unsigned int nr, i;
>
> -       nr =3D DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
> +       nr =3D DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
>         trees =3D kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
>         if (!trees) {
>                 pr_err("alloc failed, zswap disabled for swap type %d\n",=
 type);
> --
> 2.51.0
>


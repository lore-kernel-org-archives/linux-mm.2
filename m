Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2216FCA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 15:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA738E0003; Sat,  6 Sep 2025 11:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791DE8E0001; Sat,  6 Sep 2025 11:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CED08E0003; Sat,  6 Sep 2025 11:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A96E8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:30:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BA4711A6C8
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:30:47 +0000 (UTC)
X-FDA: 83859212934.11.630B98E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3702240014
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:30:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAq8jPbx;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757172645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAapPc2qhnzjy7nOVJ4Y3N7t3yjUjXjb4vEKbf7q6VM=;
	b=ya/xElhertLaCvdPbuOmZzibAXT6cJ/KhymlY7XNkUuUP9h4MsNa4t2ZTBovroGyfgWSjE
	cgV/5pcDdkCc2xXb0vTWLxsPP6awsLQKXpzhJyYJHQAx8Brz4HbvFYvyfXZF7ZVsRaICSA
	peqTiv9YSuTd3dOHmjZV374CNstcUj0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAq8jPbx;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757172645; a=rsa-sha256;
	cv=none;
	b=A2ZMy2yHx8yOguroVBr/yLLsnCQEXNlzqSM+11weIZ1iOG2aigqGjQ3+IIlvjjnHc80YyP
	H0xLReXdJsjZsPxgyJHHKDyIU0qn9ynWcraEN8fJrq8s9AVVtwE7oGYUfRfRowuoyBPCqk
	8yyFpPTBy7GGRSL48EFNrfPwZgRZ6Oc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F61D601DC
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEDBC4CEF9
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757172644;
	bh=g1c7pmqYGdbllg7o35qAzoZrQoIU1NY0r9sjW7XaxNQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mAq8jPbx0pyIJ1TWk1Cd20AkLdNlCtjwiFTA5S2eMQyBbwu2jHNhaXNcJrshfDj3I
	 L8rvZXxxzDYRYnaohxHUofmfTzX4xw5lW32DVcvRHaKz1qGXXfnVbJGlq45PEDNxgL
	 0UPT8CZsdoALZkgikerybaMZw71NvdTLADVAybFiYVyWGX10WYA+Yw6rn0l+WpQa/+
	 lWzmga2JVwUdyrQ8mHqT4bm6a5bNPIXFrSWQYsyKbU+MsIQfQJnY/hlTwCmHwOk0sO
	 2sKJYF8w+xVrX+OBBRHuEdxlALIE/iO+WUIa07feRo9s2sRjM59rF2otDjutmCjqqG
	 PHz3Ge6yZdpww==
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so51695e9.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 08:30:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YyAwgFfzt4xIspsF4ebqdvPcO2ih+JzifZhj5jsA+6fZA1Uxn+S
	nomZ8S4jNkQmvbO82LEXjUnVkEU4IrS3TgfYz23LdVc2/olvK9PCXHy+14Sii9Hzk2mqPqG47Ix
	9ml9llY3U13lKt2CWvB0t/NYCMDNB3mfOMZdJA8NY
X-Google-Smtp-Source: AGHT+IGcTDtOO7jVD2IShUgX/B8MUkNbthw2EEGd3v4tMOQuVs9TJUfUxLMoFi6zxaQjXsNqv9SNvBEP+lQ2OzrZUjU=
X-Received: by 2002:a05:600c:3ba6:b0:453:79c3:91d6 with SMTP id
 5b1f17b1804b1-45dde171a90mr822485e9.1.1757172642757; Sat, 06 Sep 2025
 08:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-14-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-14-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 6 Sep 2025 08:30:30 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNLUE87G5=MK-dpR4tAXoEO8jQYE0A+a7Rtk+f3yBcvxw@mail.gmail.com>
X-Gm-Features: AS18NWAXog6NTi4W8Zzjfo_0uE8VQjblDzke_IoBAmkHq0oxfQ3saVS4e3Z2VA8
Message-ID: <CAF8kJuNLUE87G5=MK-dpR4tAXoEO8jQYE0A+a7Rtk+f3yBcvxw@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] mm, swap: remove contention workaround for swap cache
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
X-Stat-Signature: xe4ee4pwe6ihrr3b5grqpt878md9bos1
X-Rspam-User: 
X-Rspamd-Queue-Id: 3702240014
X-Rspamd-Server: rspam01
X-HE-Tag: 1757172645-401958
X-HE-Meta: U2FsdGVkX1+VGGhAQtcy3SVqwf7aM24SippCEGD8GhGvQd/JyKfrsObcpg4Zipg6dDaocQmUiLakVtnliYCTrmCjbwCtB1dAhnBJpSn/D4LFWP6ZyA0FzQAngAnLybiDi1VnTQ4F4e60+c4TEF3/fV9B2uAxgk7Svm6mrkSgn3q5gn1qvn8HBQr0hW+KH/RSnE3O4A7kpDiFMJsstNcIfnH3l+O1/wFe7EIro/J1of2kmdxqsJnht+CO5QwUHBDPBzW+q50tKmHjF+V9Zf9Ng09Lk5TpWyAifNQ3wxM2vPpyRJ/+dMcipD98yEekwtqe3UkfYtLfhm8Gt0CtOXUsgkKgoiVjTEAr0fZxG95UbT5qTRJt8+fLv0FDfZANuu0vy2XA7VV8f5jkSjKGiwEfpntxTeJeYRxb5eG0cGUMgX85jMCP0iAcLc2etUaXNMdt/TiVSpp4gR4EyRFjkCowyYG8cRZKfLNfINWiR8+7fbn8o4yJFmfjqN8nQ1vctE9BeULnJCBCInS310FL0jSIOz7qRQ57gykqDUtjNTsGZqVr8c+lysUx5iOiMwQs0pZFNZXUDg602PgjzGIjgtXTfG47jJq8aZ6Z1HcrIy54vvRrKoCiVpLAlTLqWao8J5ibBZq3/2qIXEFLjcvHa3xFPY9sD7v0c8VsN7HhAJphq66T8IFnYDPNBIwPMXPTVuNVP7DPfUCr1ZpuFQPvhph84MNVuewz1M+Hv1ZzvOqy72fkHeli04xlgoqclW5x5d0gnUAjJ7zM0olYsi+kOyCSPnyIR+izG1DbdId9tGzyhmr6deK3dWXRh6iIeIPOjRy7ZIJ3cq3n0IN/InJMc9TWn9KFOEc0YhbVAwse99NfD7rPahzhe8zjhm5LiogU23HBWuFZW5dOWCMK/qYKfqqxlNV9YrGo1URlx0ZSOaYYsXbX0izyHfn4m2S40VaYmUGJwwH3KipI07ZBvUKkeoA
 vGRPdG1J
 QDm+aDwjBHcFvtvhN+aMwHH8z2Kd4ydnKBSPgDx0CnDUr1rFJWLKxPcM2cwOlxuI9Ig+xXbt7S8wCn7V+EaYtgfI5X/8N+vRYWebqrW6F0flDSZ2ADc8Ug3nKaeTJOEXPtOd/ygsXtqxjuVAWEaBxgfNlw2yk83V31JvZnpllv8vSYj95Ys8850tIgcK5tM5J4fKtIoK8UMuI/wchUN51cRgOiFDxzOZo6JAQt2YS2SFNKp8HeAWhsFHcsT1Vv9gg3LFdGbC2llc35AEvMTCZmPZwEKvBlxgB72Siu4DrGcPr1Y5NjNhbSp9/fk64NEeDQg6EsjecdMRfjMOo5NosMTnn8Jql/JBpacKY75jXr0chIszdKimy5m/zP6eO/vh8zzVsr8KZGs4icB7A98KpkubUCEGOc/cR4UPF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cluster setup will try to shuffle the clusters on initialization.
> It was helpful to avoid contention for the swap cache space. The cluster
> size (2M) was much smaller than each swap cache space (64M), so
> shuffling the cluster means the allocator will try to allocate swap
> slots that are in different swap cache spaces for each CPU, reducing the
> chance of two CPUs using the same swap cache space, and hence reducing
> the contention.
>
> Now, swap cache is managed by swap clusters, this shuffle is pointless.
> Just remove it, and clean up related macros.
>
> This also improves the HDD swap performance as shuffling IO is a bad
> idea for HDD, and now the shuffling is gone. Test have shown a ~40%
> performance gain for HDD [1]:
>
> Doing sequential swap in of 8G data using 8 processes with usemem,
> average of 3 test runs:
>
> Before: 1270.91 KB/s per process
> After:  1849.54 KB/s per process
>
> Link: https://lore.kernel.org/linux-mm/CAMgjq7AdauQ8=3DX0zeih2r21QoV=3D-W=
Wj1hyBxLWRzq74n-C=3D-Ng@mail.gmail.com/ [1]
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.co=
m
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  mm/swap.h     |  4 ----
>  mm/swapfile.c | 32 ++++++++------------------------
>  mm/zswap.c    |  7 +++++--
>  3 files changed, 13 insertions(+), 30 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index e48431a26f89..c4fb28845d77 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -197,10 +197,6 @@ int swap_writeout(struct folio *folio, struct swap_i=
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
> index cbb7d4c0773d..6b3b35a7ddd9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3202,21 +3202,14 @@ static int setup_swap_map(struct swap_info_struct=
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
>
>         cluster_info =3D kvcalloc(nr_clusters, sizeof(*cluster_info), GFP=
_KERNEL);
>         if (!cluster_info)
> @@ -3265,22 +3258,13 @@ static struct swap_cluster_info *setup_clusters(s=
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
> index 3dda4310099e..cba7077fda40 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -225,10 +225,13 @@ static bool zswap_has_pool;
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
>  #define zswap_pool_debug(msg, p)                       \
> @@ -1674,7 +1677,7 @@ int zswap_swapon(int type, unsigned long nr_pages)
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
>


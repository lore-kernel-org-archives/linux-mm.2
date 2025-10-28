Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F0DCCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F0E800F7; Mon, 27 Oct 2025 21:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476A4800E4; Mon, 27 Oct 2025 21:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36625800F7; Mon, 27 Oct 2025 21:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22FFF800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:28:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAAD0B7F3F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:28:43 +0000 (UTC)
X-FDA: 84045788526.30.B8FC1B3
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3C93100003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:28:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="C/kdkmn3";
	spf=pass (imf05.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761614922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uudUrLm/0mjXC7TKzbbAq1WAckCAEYcLZ5na1CdGW7A=;
	b=3wGZS4cluOOYV194v1ZqUr4fADlRN86gcggKtlhtaR7WBPkqMRSUnQpxS68qRgUaiZh0ad
	vfrfa1rBLkZBTehkQP+TMtMUCBmDZxX0xv995PjQOhlUcZr56HkVSc4xTMnzRtL2zVgFwA
	6bHxy+7sGalLHTjkuFC96kb9or9PSuA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="C/kdkmn3";
	spf=pass (imf05.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761614922; a=rsa-sha256;
	cv=none;
	b=Sob5d8Ui3I3PfR2611nv5yF1ZoKNQCICMd1sunOlyFHmfhihnrsKB1G6Mm2IWp+gCVeBDc
	2v6xhVLU3yKPFW0/NAVv0GxVBrrJnyDr4fsXRxAWdT3jbDaX6zsXsV+KLjjFJ+nNUI0+O1
	2yjUtZR/BBdzkc9wvAuy6GBAJtdKM7A=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-587bdad8919so3847e87.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761614920; x=1762219720; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uudUrLm/0mjXC7TKzbbAq1WAckCAEYcLZ5na1CdGW7A=;
        b=C/kdkmn3RvJd556yvFyWLArH3rrNmQ1OOSOk4kz5UkDXw4YcHrtIgozsAUQmqbMaxn
         xmjFrScm/JndSmjNb/+KzqJWNXTlucX72G4u/nuIxTINDsi5DuzQOyr4KF0LhXqaljfd
         bdAl7aNknVGZqbaYIR40Zn0EfReShpKWGSByqxIARy7w8Xd8iaecX+o5iTY1dx4Uvx8k
         pO9jQBzeTMOBvD2jBWKrWKzUjI3sJNzrlG1of6hsXAY1f0t/vVe637ayEnDTRTKWpmgQ
         lnl8ZRFVZAdUBM+8n2LvtQtGu4mqNOpne2HbNaQaAvQU/J6XTDcFVkaffWodRFsdZEN7
         yjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761614920; x=1762219720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uudUrLm/0mjXC7TKzbbAq1WAckCAEYcLZ5na1CdGW7A=;
        b=tBW9SKNJ/EjBFoCIP+5b/WMezMlH0sLX9zxQXFI/sp/WLazrBOqggC6fvdB0WyBe3C
         jl1peotx5qdo3sghFQQPW/8MbkZwlTRapWvZ4TGdoqkvo/nvzp3TopK7eu/H/L31A12Q
         iTsFRehhb0YcP996ppQZn3iAyHQ/YhYC3QohjZSEwaXsyRG/PU+2mWIozjWzxqmdPKH0
         xz1VUG4BLyyB6xr+KRD3YDe/VcNCk70KsxdFUGRch9iAfEYkpqZJbJv78sDBOVClzoDC
         Je3geT2F4WZ1yPFbvmf5yKNKyOVAMPRtxnB1b7Yz0G/LTG9niQR5nJDaAZ7MHF3o+tau
         Py+A==
X-Gm-Message-State: AOJu0YywHRfUuS0QVkEEvwrJcM1HMp5XI3GyROWp0sXY5GSqIlFVVZF2
	6l2ELe0FGZYQtNTkEP5UeYzMM+jDvsG86ePO3OD0uKlfJPSAIw5S/nhpdvZzH+NGntk/qPgbDti
	F3UdJM2c7aqaEBNzQl7QFH1qTurE4G0pCRdqwONPI
X-Gm-Gg: ASbGncsSTepF7Xv7J6P13aIfrFtzHUJVCuVfPrPFh0/lk8jqk9H4yYlGHvx9AMfiL1J
	PK1kotLmVaD1EZIiRbFxJ2Ya4u/s0QMukZfH+4mBsGxiDauc7KE4NLzKbek78gLEhHYkoUgblov
	+yIJ1iosq9LZ8pkPSJ0R2SIFkqPIP6PmHV2FOp80JhYJZouKeS5FrNcgvawqlJlvrP+IKshxtjw
	7D+zfbRXC9xvw+XB2hrfnNVutSSPUmMngSfr/bu4k3emlq04yuDp94XhE4B
X-Google-Smtp-Source: AGHT+IFBoLiQRrpBTKUGaTQcXL4ERfHZgHQ/w/BLDv8lG1Ga2BhuiFhb7mtWJmnIqYrW8x0KSDkdefcJDzm8uzajoY0=
X-Received: by 2002:a05:6512:ad2:b0:592:ee58:60a4 with SMTP id
 2adb3069b0e04-5930eee6e42mr242838e87.0.1761614919618; Mon, 27 Oct 2025
 18:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20251023074410.78650-1-byungchul@sk.com> <20251023074410.78650-3-byungchul@sk.com>
In-Reply-To: <20251023074410.78650-3-byungchul@sk.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 27 Oct 2025 18:28:09 -0700
X-Gm-Features: AWmQ_bnqYdKwxxg9YQPGoqUVrnDXXkWGqIBoMC60Klx63No-6OANkxxfufMibgc
Message-ID: <CAHS8izME4W3ENXNXf4Cxegmk9xnRmKajpRMQ18L0=FGTFebeaw@mail.gmail.com>
Subject: Re: [RFC mm v4 2/2] mm: introduce a new page type for page pool in
 page type
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, 
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, 
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch, 
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org, 
	kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com, 
	baolin.wang@linux.alibaba.com, toke@redhat.com, asml.silence@gmail.com, 
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, 
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E3C93100003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7tor7ocnra9rzzoogt9o3asygzej1xmd
X-HE-Tag: 1761614921-901279
X-HE-Meta: U2FsdGVkX19Tyaj1zrP5Za1jSQF7w860WnauwOt9CYXTrTTWEQd7ReQcfGN5W1Cmf6zf80OwT8Y1fjhqEIO+nS+6KxpB8cdWt1m4W4Wo+OICkmCabORcMObJ9pFlv9bWuJAxOXiLpoGKOGWq5FUZYTH3WQlYTdKugol3ew1K+wlVvgUdU+P7bCtFtBI/zGYyisKYGqYjTszoiHBqPj0Slah4UBe4VykvYUkisaBpc6IHx2HgJHS280YhjE7Wz62Bukh8QFkBLs2vykKwPgxN63aOE5qabyjKm6NZrfEQRyXayKRisqH1W2zy3ViMVjL4b6mg59pfcPOK5fhkz1Mr/q8Zus55QhxETIPJhesXcr0lOZ2xptCFM0gdf/DPJxYACsvmysgv7+tQ1CS1rorUGUI/Uc8MO1GcJlIOUz1JC4VPRgKGrm1JnjIgfYG0qGkNCw4kGlnm583yXM5ZfqdrVqdFPaKrUxovPpD/0BhlD0n0hLh8DHew+4e4R3invOV9xdGwBQOOiWIIcsBzgTBORLhDIq3sI7zEMPo9o9OItreYorMYIm92FWUNABnTqHgrUxcczBjNtWAu2ADNqp4lUotdtMHqvjXFQf+BBi+0t+yvW8XPgCCXuG+KDhZCuysRm0QQbAqDiJzEJTFOiAlZbaLfwP/fSUV2e3GJXGkfwMbHdPxtzaUQVfO4xrZJ8JHif+8XPFXL1M2xHj69j3qTXuADpMZ6Auf8lyyH2QbQh3gumSgnG7Izy2HiFM43UJ0W4jBG3hDdLSB1xR+kDtsLgR/j/3VqddiW1zR8qqKfYZr62syWBJcN3d6LKnZ028U4YQ/Hn27nAl2tvU7aATWh3DHWtZoRErgF7LI02P69xlCUUPB7rbkMNMq32n+IFKg2o5TtmUqXpC1/OwHryJ+3fJ3TmJH/Ah1agKAEFv9KCOMmatU25ju7F2HA/EjlFdqZ+xbRK13SxC25ToC2uyd
 2HsNAIWS
 dVCzcYkdh7ZsW+bupCCzc7uviqcclg15C9Mi+hadUtRQoEg4r3W2vovXAVf6DyzR/G37C2w2FGn1eQCgLvxwXZ9GlIyJgj2r04dnTbq59pePGQEO3o98nYkJwg12UdVWvK+ZMZ32Lestq0/walt7xwEuFB067wLvJ2UWMeEU6ULFK2F5i1/kpL5VT5l7VU7+NXXEuT1f0Vjk+FDWUyv0t6j0ixaEJQm/mLd4bJyH7B8C29znnJIvRc+E9Qigf6ijGNNjvHDGp4vdWbpqKJagmt4O0UsqlZLiWH3Minoc9Eh0q6Th8ZqUxBfUOM4knqf8+OHcMvApkzEQlYnPRKINtUkitDDyYh238DUtETPPD5DW0c8WxGilzTroThNogmMhd+rn8LJ6R6M52uGI3qr3LUSs1Q8w8nQTbjKTIiUoiJZYuQ1h0NN2/qFJhjNyv/PDs9r8ZgG+cPZOLJayO3w0HZkIX3RKDK/of+Ak1OeEXbyH6/vM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 12:45=E2=80=AFAM Byungchul Park <byungchul@sk.com> =
wrote:
>
> ->pp_magic field in struct page is current used to identify if a page
> belongs to a page pool.  However, ->pp_magic will be removed and page
> type bit in struct page e.i. PGTY_netpp can be used for that purpose.
>
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
>
> This work was inspired by the following link:
>
> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmai=
l.com/
>
> While at it, move the sanity check for page pool to on free.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
> Hi Mina,
>
> I dropped your Reviewed-by tag since there are updates on some comments
> in network part.  Can I still keep your Reviewed-by?
>
>         Byungchul
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
>  include/linux/mm.h                            | 27 +++----------------
>  include/linux/page-flags.h                    |  6 +++++
>  include/net/netmem.h                          |  2 +-
>  mm/page_alloc.c                               |  8 +++---
>  net/core/netmem_priv.h                        | 17 +++---------
>  net/core/page_pool.c                          | 14 +++++-----
>  7 files changed, 25 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en/xdp.c
> index 5d51600935a6..def274f5c1ca 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq =
*sq,
>                                 xdpi =3D mlx5e_xdpi_fifo_pop(xdpi_fifo);
>                                 page =3D xdpi.page.page;
>
> -                               /* No need to check page_pool_page_is_pp(=
) as we
> +                               /* No need to check PageNetpp() as we
>                                  * know this is a page_pool page.
>                                  */
>                                 page_pool_recycle_direct(pp_page_to_nmdes=
c(page)->pp,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b6fdf3557807..f5155f1c75f5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4361,10 +4361,9 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>   * DMA mapping IDs for page_pool
>   *
>   * When DMA-mapping a page, page_pool allocates an ID (from an xarray) a=
nd
> - * stashes it in the upper bits of page->pp_magic. We always want to be =
able to
> - * unambiguously identify page pool pages (using page_pool_page_is_pp())=
. Non-PP
> - * pages can have arbitrary kernel pointers stored in the same field as =
pp_magic
> - * (since it overlaps with page->lru.next), so we must ensure that we ca=
nnot
> + * stashes it in the upper bits of page->pp_magic. Non-PP pages can have
> + * arbitrary kernel pointers stored in the same field as pp_magic (since
> + * it overlaps with page->lru.next), so we must ensure that we cannot
>   * mistake a valid kernel pointer with any of the values we write into t=
his
>   * field.
>   *
> @@ -4399,26 +4398,6 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT=
 - 1, \
>                                   PP_DMA_INDEX_SHIFT)
>
> -/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magi=
c is
> - * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit=
 0 for
> - * the head page of compound page and bit 1 for pfmemalloc page, as well=
 as the
> - * bits used for the DMA index. page_is_pfmemalloc() is checked in
> - * __page_pool_put_page() to avoid recycling the pfmemalloc page.
> - */
> -#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> -
> -#ifdef CONFIG_PAGE_POOL
> -static inline bool page_pool_page_is_pp(const struct page *page)
> -{
> -       return (page->pp_magic & PP_MAGIC_MASK) =3D=3D PP_SIGNATURE;
> -}
> -#else
> -static inline bool page_pool_page_is_pp(const struct page *page)
> -{
> -       return false;
> -}
> -#endif
> -
>  #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
>  #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
>  #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0091ad1986bf..edf5418c91dd 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -934,6 +934,7 @@ enum pagetype {
>         PGTY_zsmalloc           =3D 0xf6,
>         PGTY_unaccepted         =3D 0xf7,
>         PGTY_large_kmalloc      =3D 0xf8,
> +       PGTY_netpp              =3D 0xf9,
>
>         PGTY_mapcount_underflow =3D 0xff
>  };
> @@ -1078,6 +1079,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
>  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
>  FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
>
> +/*
> + * Marks page_pool allocated pages.
> + */
> +PAGE_TYPE_OPS(Netpp, netpp, netpp)
> +
>  /**
>   * PageHuge - Determine if the page belongs to hugetlbfs
>   * @page: The page to test.
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index 651e2c62d1dd..0ec4c7561081 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -260,7 +260,7 @@ static inline unsigned long netmem_pfn_trace(netmem_r=
ef netmem)
>   */
>  #define pp_page_to_nmdesc(p)                                           \
>  ({                                                                     \
> -       DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));               \
> +       DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));                          \
>         __pp_page_to_nmdesc(p);                                         \
>  })
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fb91c566327c..c69ed3741bbc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1042,7 +1042,6 @@ static inline bool page_expected_state(struct page =
*page,
>  #ifdef CONFIG_MEMCG
>                         page->memcg_data |
>  #endif
> -                       page_pool_page_is_pp(page) |

Shouldn't you replace the page_pool_page_is_pp check with a PageNetpp
check in this call site and below? Or is that no longer necessary for
some reason?


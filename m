Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891DCC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 22:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242D18E0006; Tue, 22 Jul 2025 18:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B1F8E0001; Tue, 22 Jul 2025 18:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130DF8E0006; Tue, 22 Jul 2025 18:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 006938E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:17:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96107C04AB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:17:32 +0000 (UTC)
X-FDA: 83693313144.05.219DC79
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id B7EE28000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:17:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mP5QIUNv;
	spf=pass (imf02.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753222650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwq8/R8i8xM+jxXlYCuXM87SJ5yS6lKTE4JLQ6WPr1o=;
	b=pQ9IjlavuP7CXIH9UOyTfyvSAnFnK4aC6ROJM+FjrfQIJNozintw22Z2DrJ+UUjbuLmyxh
	vASQhc3QTPOjcZcT/+eivU9vhlJpDr8a7uS/lHSFlvX/jn3wXzJaqU60yVbi+/FUp5gyUC
	RfwosLckDhyPL/usqirAWz63SW5pGSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753222650; a=rsa-sha256;
	cv=none;
	b=Fv9UqROmj90KBfFD8/Vu1ESgblycQEvbvXyXCrC1pZY2J+KGAdrfIhzfT1vCyQKFM+DbQA
	MoS1l6N95QORhhdUaSV836uMTFi/BLBDWKv0Yt/pyC/5iS8au2t3Yw4/2S/2Uqv+xAM7OP
	z2S245fpaEZ2jJ7YVwWdU31H4Q1Xm+8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mP5QIUNv;
	spf=pass (imf02.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2357c61cda7so24035ad.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753222649; x=1753827449; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwq8/R8i8xM+jxXlYCuXM87SJ5yS6lKTE4JLQ6WPr1o=;
        b=mP5QIUNvHkcfeeErCypbNWm64nPbnf2RbRBy4Iw9BrA+iB1yvaYOjbxVrIc0gnwyLp
         IRdk/m3p84bXqGgiH+qR7JcaPcO7AmbIosIKFGceytu+Gk/QDU8VPWeVF1zSA0aLbReh
         x8FhIi/HfSnePagUUQxOqTiY0O8tzjdADyhdYCXladNiV4aGrq8OSuvS9BwX94AoBnl7
         Y/GI1SBuCK4tLHzpEYDfT/BSCU+yUkdIc1/6ReN6nIwyOVtJe3xA+5xq54bLMnCkRkKF
         FdhRLv7sbvEKnCq02/eXnlQKUs29dsf+5liAMvo4fACpBjZc00F65H7ZCvRyo9/M7iHY
         vC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753222649; x=1753827449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwq8/R8i8xM+jxXlYCuXM87SJ5yS6lKTE4JLQ6WPr1o=;
        b=vSVc1fjX4U1xNpjab6illIv2ohgTMK2Jo1e33qwH7B0cjUpx29kikEGGQaef/AFnN+
         dSjJm2VnzEVMQLworc8rLNb1d7Up/W24M8UAK+6vkmnwGjeLXR1Wc6uEHZjOTAbln5KI
         nGnwoqqJKAKAeZmt4u4Ldh3cCThw9nG/g7AzQ/jcagJw50sJrLa5s9ZhO/Pt6rQ0BVtE
         MDDkY1wlPirzUkcSWv3xVaqBAHPUbszr01t8YP9dIi8Uq3THb+KwAq3XzAj4SpfFV+XT
         Pu1PylhhOmuf6I4r7QL+Fpxx5D9Sije1X8VpfObZVF4J/Wc2rZlRLBEbanG61tlMqO0N
         +Nzg==
X-Gm-Message-State: AOJu0YxogBz3XK3VB6TvrL0MnvwrIhgfqiVQHR0IXWN162KyQTEDIDdH
	BXXQx28Oz49p2IugY/n3y6pZapxAfPhDkmWf444oe89GL6ZEpMNFQVzJGQl+EzBToDp7oIIoCDT
	j886WXc2XTFVSyh81vAFo+WJmcHFmyj8dzJgQJzN2
X-Gm-Gg: ASbGnctameH6oMn1HjzfyULATeO8aFo3quWCPp/uNKMdGq52GS+ZN6mKbityvNEbvpZ
	6QO96o3EM0vxLYk+eR4mi0cF74fDgsil9WdM84YvwowtspYElGFH9wt79c7iDchJ5W4A7Zzbsw4
	6AkzmRRL5CXa6rOaURd1x2666Pm1EUZ8nmfIipByJDgxQcz+DTu7JRjPoQsKSx5CAy779cc4NkE
	l/3qnd44ThaYu3Xlaq80iWit3trvWJ1kL9QeQ==
X-Google-Smtp-Source: AGHT+IE/ajbWm3e4FGD0Iam/+O5HMy51w2t6TfHeMRIh15ZibxtN49seddjK0pf9Q1p4k6AShrharBO0lOO8vm4xehk=
X-Received: by 2002:a17:902:ef4c:b0:21f:631c:7fc9 with SMTP id
 d9443c01a7336-23f9768690amr1184045ad.0.1753222649125; Tue, 22 Jul 2025
 15:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250721054903.39833-1-byungchul@sk.com>
In-Reply-To: <20250721054903.39833-1-byungchul@sk.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 22 Jul 2025 15:17:15 -0700
X-Gm-Features: Ac12FXyQGTpNbFtlw2q6Pc3nggpdLqj6g3Hr7vfFoOMAJXp98eJzBFERPdnHCgk
Message-ID: <CAHS8izM11fxu6jHZw5VJsHXeZ+Tk+6ZBGDk0vHiOoHyXZoOvOg@mail.gmail.com>
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool in
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
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B7EE28000C
X-Stat-Signature: 8czjcytifpwtbegc1uwfdy34m5p975wf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753222650-817414
X-HE-Meta: U2FsdGVkX1+5yjjEnZ+TzCFDZVP7e5UynIsjFnDxCvGrWkODFQSXQ7NhqRzfcknzSFOebaVB2QDIlbOaQRDfE/iT/Z15xQfqNZvWD50DoF7BoER9eDV82hHiLyUBcSjg0JRThkjeliHmNfV9rgAzrGWzZTXvkf3YQF3V+MyNcNRaqZ+qbuOq0cem4K5DK26W0Dmji9ShTTPPTFi0ywiCu8zs/G1B6CaBG6AE5mGrWeOsQ+o6qSbs1935XFO8oe8mI2ZqgP2hC4DPkuYpjF437ldT29Mb0CxY3uJrgkTKSi3F/C72SsAxKZ4wvQO9m6cSA+WgIS4K/pEgkeyl4jf9Z+7A76sJL6hYLbS5hWNmcRaAWetVkrM4TisfB6eYBoNB25cK4I/9FV9yN9FRqtWUSmnr0IZ7WGpCNByazKTeHBiyl/BOXc8sUc3QhUPIu+GbHodJDeAeP59/6cUw+ZgzenBKpXolB/FI0SdKja6C16VWlMCCZdPZkaU7wsU08eqcCCRzL5LwDkRP3k3JSq6nERhLAv0TaO8XIV5QhVBWPmkaAf4yORlcS7HVi5QJew9mO5tA24C5WF2o/51afps3cNIsL16whzWyiXW8T+T0xFrigB4lgl1yw1sfedNCGcIsKzyugcjs+GKHKwu9YtckFcf08UnYHY6CJULMHVhZFIHek5wX5TjvZO/4Hc8P+e0OPEFAcfKzboEqByiOtQohkltc/b7q5d+us7Ci9wiPfgTMu98SeTygEE802LfZI/m64vWVIcQSZX6Z3lpX5W01tvrB+4NkQTUfxvoXxt7SgKJE8ViAIyykPri4vHlpWb+XgqsfqufJIxvSHToCcVNJtBssVX55Q9d7obHRUwUBJAczq/G3Zo2I9ljkDyShCSg7KJTCwLp1BKsBE8pTNVxEkec7yeq6GxL0EezscUQYdPUzzDff7XqBVUOCFw3OcN1/vMyH5+QNwPnkZhv6N7h
 hJ86mv1j
 J8sce9bCIZQZ+jRlRMhaBGDB7Yz0ou9PtKy5Ieb6RzcM2HLKBYALxVKQ6LxUoi1wAvN/DgUYEunF6ZCpcuW/mzjCJ+ZqqRzqC/rhnaUW8TvdlYDrW489RH8O+eIyxFDksQCgGNU8TCKpFgDcHP4zni7p1TdiQ37aGhH2wCLorxy5MvJST3puJ+hCXVKSwsB1qUJZY5C9U2OpsDjbRYqBN7ffV5/ZSOqeY2nvoiiTPGrh/iBdp2aOnxrvFFjhGQssxqw+zt8w/tmcrscRjKp5HkcK3yY7VglyHBZIJVlUgb3FxHMOEyWTm4OgDjWrRbHBmG+jCHqhspzFN64depYTxS0sTi1Cv5cSu80Zi9EiCO8p7s1yZ+T5ThfWf0RW05CJK/9zKdwfzI3/oyF8qJXtPxvtTnGMzE13Ky2I6//qquqBbjkkUBrKU17MtTt3NxpGzahbHr0TryAcVqo638jNUzmzR1m0+I89/ilwrkcPFwmpymS4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 20, 2025 at 10:49=E2=80=AFPM Byungchul Park <byungchul@sk.com> =
wrote:
>
> Hi,
>
> I focused on converting the existing APIs accessing ->pp_magic field to
> page type APIs.  However, yes.  Additional works would better be
> considered on top like:
>
>    1. Adjust how to store and retrieve dma index.  Maybe network guys
>       can work better on top.
>
>    2. Move the sanity check for page pool in mm/page_alloc.c to on free.
>
>    Byungchul
>
> ---8<---
> From 7d207a1b3e9f4ff2a72f5b54b09e3ed0c4aaaca3 Mon Sep 17 00:00:00 2001
> From: Byungchul Park <byungchul@sk.com>
> Date: Mon, 21 Jul 2025 14:05:20 +0900
> Subject: [PATCH] mm, page_pool: introduce a new page type for page pool i=
n page type
>
> ->pp_magic field in struct page is current used to identify if a page
> belongs to a page pool.  However, page type e.i. PGTY_netpp can be used
> for that purpose.
>
> Use the page type APIs e.g. PageNetpp(), __SetPageNetpp(), and
> __ClearPageNetpp() instead, and remove the existing APIs accessing
> ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic() since they are totally replaced.
>
> This work was inspired by the following link by Pavel:
>
> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmai=
l.com/
>
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
>  include/linux/mm.h                            | 28 ++-----------------
>  include/linux/page-flags.h                    |  6 ++++
>  include/net/netmem.h                          |  2 +-
>  mm/page_alloc.c                               |  4 +--
>  net/core/netmem_priv.h                        | 16 ++---------
>  net/core/page_pool.c                          | 10 +++++--
>  7 files changed, 24 insertions(+), 44 deletions(-)
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
> index ae50c1641bed..736061749535 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4135,10 +4135,9 @@ int arch_lock_shadow_stack_status(struct task_stru=
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
> @@ -4168,25 +4167,4 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>
>  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT=
 - 1, \
>                                   PP_DMA_INDEX_SHIFT)
> -
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
>  #endif /* _LINUX_MM_H */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 4fe5ee67535b..906ba7c9e372 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -957,6 +957,7 @@ enum pagetype {
>         PGTY_zsmalloc           =3D 0xf6,
>         PGTY_unaccepted         =3D 0xf7,
>         PGTY_large_kmalloc      =3D 0xf8,
> +       PGTY_netpp              =3D 0xf9,
>
>         PGTY_mapcount_underflow =3D 0xff
>  };
> @@ -1101,6 +1102,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
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
> index f7dacc9e75fd..3667334e16e7 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -298,7 +298,7 @@ static inline struct net_iov *__netmem_clear_lsb(netm=
em_ref netmem)
>   */
>  #define pp_page_to_nmdesc(p)                                           \
>  ({                                                                     \
> -       DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));               \
> +       DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));                          \
>         __pp_page_to_nmdesc(p);                                         \
>  })
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2ef3c07266b3..71c7666e48a9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -898,7 +898,7 @@ static inline bool page_expected_state(struct page *p=
age,
>  #ifdef CONFIG_MEMCG
>                         page->memcg_data |
>  #endif
> -                       page_pool_page_is_pp(page) |
> +                       PageNetpp(page) |
>                         (page->flags & check_flags)))
>                 return false;
>
> @@ -925,7 +925,7 @@ static const char *page_bad_reason(struct page *page,=
 unsigned long flags)
>         if (unlikely(page->memcg_data))
>                 bad_reason =3D "page still charged to cgroup";
>  #endif
> -       if (unlikely(page_pool_page_is_pp(page)))
> +       if (unlikely(PageNetpp(page)))
>                 bad_reason =3D "page_pool leak";
>         return bad_reason;
>  }
> diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> index cd95394399b4..39a97703d9ed 100644
> --- a/net/core/netmem_priv.h
> +++ b/net/core/netmem_priv.h
> @@ -8,21 +8,11 @@ static inline unsigned long netmem_get_pp_magic(netmem_=
ref netmem)
>         return __netmem_clear_lsb(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
>  }
>
> -static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long p=
p_magic)
> -{
> -       __netmem_clear_lsb(netmem)->pp_magic |=3D pp_magic;
> -}
> -
> -static inline void netmem_clear_pp_magic(netmem_ref netmem)
> -{
> -       WARN_ON_ONCE(__netmem_clear_lsb(netmem)->pp_magic & PP_DMA_INDEX_=
MASK);
> -
> -       __netmem_clear_lsb(netmem)->pp_magic =3D 0;
> -}
> -
>  static inline bool netmem_is_pp(netmem_ref netmem)
>  {
> -       return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) =3D=3D PP_SI=
GNATURE;
> +       if (netmem_is_net_iov(netmem))
> +               return true;

As Pavel alludes, this is dubious, and at least it's difficult to
reason about it.

There could be net_iovs that are not attached to pp, and should not be
treated as pp memory. These are in the devmem (and future net_iov) tx
paths.

We need a way to tell if a net_iov is pp or not. A couple of options:

1. We could have it such that if net_iov->pp is set, then the
netmem_is_pp =3D=3D true, otherwise false.
2. We could implement a page-flags equivalent for net_iov.

Option #1 is simpler and is my preferred. To do that properly, you need to:

1. Make sure everywhere net_iovs are allocated that pp=3DNULL in the
non-pp case and pp=3Dnon NULL in the pp case. those callsites are
net_devmem_bind_dmabuf (devmem rx & tx path), io_zcrx_create_area
(io_uring rx path).

2. Change netmem_is_pp to check net_iov->pp in the net_iov case.

--=20
Thanks,
Mina


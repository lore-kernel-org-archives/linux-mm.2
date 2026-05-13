Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FCECD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165086B008C; Wed, 13 May 2026 05:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CB16B0092; Wed, 13 May 2026 05:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A5B6B0093; Wed, 13 May 2026 05:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAF616B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:42:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80F48140796
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:42:44 +0000 (UTC)
X-FDA: 84761907048.26.35E9BE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAFA780003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:42:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cr8uxAh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIyAf97Bj8JDrPmK68PMxsSFSbADrc3mn1C0Tc4sA7E=;
	b=Ap+SbHPqUh2sk3ZoYXJjeYLZqWpvxCtFTXASptik4VOMMPpCTTLXj1wdonSGShZUfuovR+
	J4LdGcbkgfNkJGa4yEIOzY3TrCd71We7foTfL0f1UDTW+TMZYYsySVCdSDe1WrFqSDhXov
	SgV6MifzPV9FRXs3bWdoxytqMpTDqhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665362; a=rsa-sha256;
	cv=none;
	b=ZQI54tKZds+L3nH9EbKmISHu8cJctdGVhawIoeKDEEI/wsFKEbHybwJxeRsKftPlbAZnh1
	vXLkRlP6ZenACTy3fpqar6wc+UoPHrjB+4RH/In1L3kQjPRGds2gqZbHaISctchM8eKi9b
	FaEuVDvaOrguoxlN1Tiw3F5jZm3edY4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cr8uxAh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70691441DE;
	Wed, 13 May 2026 09:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23B4C2BCB7;
	Wed, 13 May 2026 09:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778665361;
	bh=i+awaBjbzoGv+bzIIAVOHA5A0tzwaWXH1wgME3EZtME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cr8uxAh+loQpjXmCoE2TaiGITt+TcZwPIbr+2RkfQvmH016d7LsS1fYXzAGa6tfaf
	 9aDJgI4NZQWIIfDBz/fxuLE/C3bF1QUfjJm+eaXZpA2bd1iUEfFaidDc9+2lnQk7Q3
	 fQJRqh1thkcoH/XcJKSphQ+kRTI9UCWbfmO7NEFJcIOb1DT9Y1d3+rxytyM6koiRnU
	 o67Kghqz/3Sl1fwOV1noQq1Zz+1JhcTHzbgMwOwLPK3z3cP5r0vFt1ZXjSDshcLTta
	 3mJYS/6/YKEFhO2y4qtuIGDtUUcWsUjMz9l5ZpGFjeP+r/soM1XXNhz2++NoEly8au
	 TOmcMnI67TGGw==
Date: Wed, 13 May 2026 10:42:38 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, 
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, 
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com, 
	pabeni@redhat.com, david@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org, 
	willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com, 
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com, almasrymina@google.com, 
	toke@redhat.com, asml.silence@gmail.com, bpf@vger.kernel.org, 
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com, 
	dtatulea@nvidia.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <agRHF2EnFw-OZ2-u@lucifer>
References: <20260224051347.19621-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260224051347.19621-1-byungchul@sk.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AAFA780003
X-Rspamd-Server: rspam04
X-Stat-Signature: 1tfuyqkuops1m19q7egrnkfjjg34tus9
X-HE-Tag: 1778665362-687685
X-HE-Meta: U2FsdGVkX1/Un2yReudPz0sKZpUuaG8q6Brjzpj+pOPgxU3vbqNDiLhamxoacUZZOHKsfK5/rQVfFIc1A1l8zoMcg7fWRoWpzyEXq13T8ZyIQ1xPusAvc4ejFqfCZcQQGHkTqSYMipTh+ktVOIKeq/ldm50o6H+I8KxYfSvxre7G/M84l8q3mPIAppG3hRmci6J+HHL3pM5MvhBFSBcOgtQUhvoiYpfo7SKeMQaCai6eftieStIvxOquRwOrbLsoFOo8m9Zfy8ioFcdg/i7L+xJXQUpeZItnMRmSGV8hPT3AGJJKbHU3rgyCYDa3A8AOe5iJrDM5RUHiomMlCeOucF8MAFPmB6MNViic4njFzsBC3WHG+N3uyyQkAbm3gxMyRRcTteIvuD5s0bf15he3tjlhxChPkwK0/AKKzc49G0Bf4ZzYwLD6Tgh98P4kxbFOceHbDXgGOP45UfggJLGUbpm8RgJe74AVD+eUZl4vmqM2eerj6jrIbKOzEpIM1uX7TXQX+yIgXEzXcabm7B6WfzB2XOPdz6ez18+vhcJnRtWIsKu8aGBb9RzNfiT7KrfWo634BMoLgmquuqMDRnQpfuY18btjfAOtDwZgBGD6uAQBW0+i4ZQKtoM43PtdTx6GdL9XbOrNbVR09BfQUgp5uuDgN0+xAj45Kz/3KPAvqa3Z9qOGn7wMfs+naWZqzqTti/9xYIF1vlpvM4pC2Ev0QTqFencuoQaAkQoDJBjF3mDqHVYQYK90/qL5KZq2qZVT1JzlHF0oWRH4So/j3A9ewL7OSd0NCcza/XIkt3GslBNSyfJNtnuin6SrAVEq41gczGpAd9SJjG5uA7qErK2sdNsIjFQNigPnJogAwAH0nnVHvPcBqOiKfFW2HSfY4AYYLpo1e+erdJUqq2nZlZEpEFOtpMq9Q0r0gzG3qKQIPutbXH1nCKeslgzYUEmlRUMM7++eiSefWEuIaYblyxG
 w5vSz9jv
 04nmDHOBAjXD264npBErPp353PS/93b/ThQwCSW54NcIJjE+Cz76O+zq2i/sDDOj65gt77Veu3N5oDH3Ejy1yrh+kSThaRsQsOYsR7NkxNOarg8z+s/kx381w5dsNi/Nf7xNOmOXrOyRdhmyX1e1I+H7B0C8T2yxRQ6mjxjA3w96hsaWmXMPg+yCV9gbYsP8s1C7gViUGYveRVBjXmTmn7RgAVKc6QGec7Ab2ch6KpF6Qwl6XixVFOSxrlMsrY0A2uscFbwQtQ4kreqW8gTpICrCJ+l/d/gI94B7o92UC9GSNdqSYBD+XkdiZmbL1p3wk3FJnA4KrQAGgphiHkHr6tCYPOALdhYZDVW8heXH3IMJv3s0aS7WSP/M7d1KMxs2yRmLQguE8ECa7N1hyhQzuDyoyHVe45w9Hunm1pNCmZ7+FvdZ1008qv3z37D59f/GAoswcArFRH/11yksqxdKqdiBFsK7S6PQLn5hsmpDuVROjE7rUKfbyk6WQQD7GA6We39O65faDwVHiu7921E9r0fk7sbTeuK9d95lV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc previous kernel mail address
-cc David's very previous kernel mail address
+cc David's current mail address

Hi,

Just an annoying reminder to please check people's addresses via
get_maintainer.pl, as otherwise stuff might get missed! :)

Cheers, Lorenzo

On Tue, Feb 24, 2026 at 02:13:47PM +0900, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
>
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
>
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
>
> This work was inspired by the following link:
>
>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
>
> While at it, move the sanity check for page pool to on the free path.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> The following 'Acked-by's were given only for mm part:
>
>   Acked-by: David Hildenbrand <david@redhat.com>
>   Acked-by: Zi Yan <ziy@nvidia.com>
>   Acked-by: Vlastimil Babka <vbabka@suse.cz>
>
> This patch changes both mm and page-pool, but I'm currently targetting
> mm tree because Jakub asked and I also think it's more about mm change.
> See the following link:
>
>   https://lore.kernel.org/all/20250813075212.051b5178@kernel.org/
>
> Changes from v3:
> 	1. Rebase on mm-new as of Feb 24, 2026.
> 	2. Fix an issue reported by kernel test robot due to incorrect
> 	   type.
> 	3. Add 'Acked-by: Vlastimil Babka <vbabka@suse.cz>'.  Thanks.
>
> Changes from v2:
> 	1. Fix an issue reported by kernel test robot due to incorrect
> 	   type in argument of __netmem_to_page().
>
> Changes from v1:
> 	1. Drop the finalizing patch removing the pp fields of struct
> 	   page since I found that there is still code accessing a pp
> 	   field via struct page.  I will retry the finalizing patch
> 	   after resolving the issue.
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
>  include/linux/mm.h                            | 27 +++----------------
>  include/linux/page-flags.h                    |  6 +++++
>  include/net/netmem.h                          | 15 +++++++++--
>  mm/page_alloc.c                               | 11 +++++---
>  net/core/netmem_priv.h                        | 23 +++++++---------
>  net/core/page_pool.c                          | 24 +++++++++++++++--
>  7 files changed, 62 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 80f9fc10877ad..7d90d2485c787 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
>  				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
>  				page = xdpi.page.page;
>
> -				/* No need to check page_pool_page_is_pp() as we
> +				/* No need to check PageNetpp() as we
>  				 * know this is a page_pool page.
>  				 */
>  				page_pool_recycle_direct(pp_page_to_nmdesc(page)->pp,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 13336340612e2..0db764b3d6b84 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4824,10 +4824,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
>   * DMA mapping IDs for page_pool
>   *
>   * When DMA-mapping a page, page_pool allocates an ID (from an xarray) and
> - * stashes it in the upper bits of page->pp_magic. We always want to be able to
> - * unambiguously identify page pool pages (using page_pool_page_is_pp()). Non-PP
> - * pages can have arbitrary kernel pointers stored in the same field as pp_magic
> - * (since it overlaps with page->lru.next), so we must ensure that we cannot
> + * stashes it in the upper bits of page->pp_magic. Non-PP pages can have
> + * arbitrary kernel pointers stored in the same field as pp_magic (since
> + * it overlaps with page->lru.next), so we must ensure that we cannot
>   * mistake a valid kernel pointer with any of the values we write into this
>   * field.
>   *
> @@ -4862,26 +4861,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
>  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
>  				  PP_DMA_INDEX_SHIFT)
>
> -/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
> - * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
> - * the head page of compound page and bit 1 for pfmemalloc page, as well as the
> - * bits used for the DMA index. page_is_pfmemalloc() is checked in
> - * __page_pool_put_page() to avoid recycling the pfmemalloc page.
> - */
> -#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> -
> -#ifdef CONFIG_PAGE_POOL
> -static inline bool page_pool_page_is_pp(const struct page *page)
> -{
> -	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
> -}
> -#else
> -static inline bool page_pool_page_is_pp(const struct page *page)
> -{
> -	return false;
> -}
> -#endif
> -
>  #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
>  #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
>  #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0426cac91c0bb..30c4eb24e4edf 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -939,6 +939,7 @@ enum pagetype {
>  	PGTY_zsmalloc		= 0xf6,
>  	PGTY_unaccepted		= 0xf7,
>  	PGTY_large_kmalloc	= 0xf8,
> +	PGTY_netpp		= 0xf9,
>
>  	PGTY_mapcount_underflow = 0xff
>  };
> @@ -1071,6 +1072,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
>  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
>  PAGE_TYPE_OPS(LargeKmalloc, large_kmalloc, large_kmalloc)
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
> index a96b3e5e5574c..85e3b26ec547f 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -110,10 +110,21 @@ struct net_iov {
>  			atomic_long_t pp_ref_count;
>  		};
>  	};
> -	struct net_iov_area *owner;
> +
> +	unsigned int page_type;
>  	enum net_iov_type type;
> +	struct net_iov_area *owner;
>  };
>
> +/* Make sure 'the offset of page_type in struct page == the offset of
> + * type in struct net_iov'.
> + */
> +#define NET_IOV_ASSERT_OFFSET(pg, iov)			\
> +	static_assert(offsetof(struct page, pg) ==	\
> +		      offsetof(struct net_iov, iov))
> +NET_IOV_ASSERT_OFFSET(page_type, page_type);
> +#undef NET_IOV_ASSERT_OFFSET
> +
>  struct net_iov_area {
>  	/* Array of net_iovs for this area. */
>  	struct net_iov *niovs;
> @@ -256,7 +267,7 @@ static inline unsigned long netmem_pfn_trace(netmem_ref netmem)
>   */
>  #define pp_page_to_nmdesc(p)						\
>  ({									\
> -	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
> +	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
>  	__pp_page_to_nmdesc(p);						\
>  })
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d88c8c67ac0b7..cae9f93271469 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1079,7 +1079,6 @@ static inline bool page_expected_state(struct page *page,
>  #ifdef CONFIG_MEMCG
>  			page->memcg_data |
>  #endif
> -			page_pool_page_is_pp(page) |
>  			(page->flags.f & check_flags)))
>  		return false;
>
> @@ -1106,8 +1105,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>  	if (unlikely(page->memcg_data))
>  		bad_reason = "page still charged to cgroup";
>  #endif
> -	if (unlikely(page_pool_page_is_pp(page)))
> -		bad_reason = "page_pool leak";
>  	return bad_reason;
>  }
>
> @@ -1416,9 +1413,15 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>  		folio->mapping = NULL;
>  	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		/* networking expects to clear its page type before releasing */
> +		if (unlikely(PageNetpp(page))) {
> +			bad_page(page, "page_pool leak");
> +			return false;
> +		}
>  		/* Reset the page_type (which overlays _mapcount) */
>  		page->page_type = UINT_MAX;
> +	}
>
>  	if (is_check_pages_enabled()) {
>  		if (free_page_is_bad(page))
> diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> index 23175cb2bd866..3e6fde8f1726f 100644
> --- a/net/core/netmem_priv.h
> +++ b/net/core/netmem_priv.h
> @@ -8,21 +8,18 @@ static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
>  	return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
>  }
>
> -static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
> -{
> -	netmem_to_nmdesc(netmem)->pp_magic |= pp_magic;
> -}
> -
> -static inline void netmem_clear_pp_magic(netmem_ref netmem)
> -{
> -	WARN_ON_ONCE(netmem_to_nmdesc(netmem)->pp_magic & PP_DMA_INDEX_MASK);
> -
> -	netmem_to_nmdesc(netmem)->pp_magic = 0;
> -}
> -
>  static inline bool netmem_is_pp(netmem_ref netmem)
>  {
> -	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> +	struct page *page;
> +
> +	/* XXX: Now that the offset of page_type is shared between
> +	 * struct page and net_iov, just cast the netmem to struct page
> +	 * unconditionally by clearing NET_IOV if any, no matter whether
> +	 * it comes from struct net_iov or struct page.  This should be
> +	 * adjusted once the offset is no longer shared.
> +	 */
> +	page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
> +	return PageNetpp(page);
>  }
>
>  static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 265a729431bb7..877bbf7a19389 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -702,8 +702,18 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
>
>  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  {
> +	struct page *page;
> +
>  	netmem_set_pp(netmem, pool);
> -	netmem_or_pp_magic(netmem, PP_SIGNATURE);
> +
> +	/* XXX: Now that the offset of page_type is shared between
> +	 * struct page and net_iov, just cast the netmem to struct page
> +	 * unconditionally by clearing NET_IOV if any, no matter whether
> +	 * it comes from struct net_iov or struct page.  This should be
> +	 * adjusted once the offset is no longer shared.
> +	 */
> +	page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
> +	__SetPageNetpp(page);
>
>  	/* Ensuring all pages have been split into one fragment initially:
>  	 * page_pool_set_pp_info() is only called once for every page when it
> @@ -718,7 +728,17 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>
>  void page_pool_clear_pp_info(netmem_ref netmem)
>  {
> -	netmem_clear_pp_magic(netmem);
> +	struct page *page;
> +
> +	/* XXX: Now that the offset of page_type is shared between
> +	 * struct page and net_iov, just cast the netmem to struct page
> +	 * unconditionally by clearing NET_IOV if any, no matter whether
> +	 * it comes from struct net_iov or struct page.  This should be
> +	 * adjusted once the offset is no longer shared.
> +	 */
> +	page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
> +	__ClearPageNetpp(page);
> +
>  	netmem_set_pp(netmem, NULL);
>  }
>
> --
> 2.17.1
>


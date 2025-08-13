Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B60ACA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0158E01BF; Wed, 13 Aug 2025 02:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51238E01B6; Wed, 13 Aug 2025 02:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9686F8E01BF; Wed, 13 Aug 2025 02:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 822938E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:09:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27B3D14026E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:09:13 +0000 (UTC)
X-FDA: 83770706586.22.FA7A24C
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id 842414000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:09:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755065351; a=rsa-sha256;
	cv=none;
	b=BDHI9WOD7QE3rVts0PM9FaRROPRKYvs+YsYKcwRU62osUFFKFsUa7yUZyEZims0g2XWMEF
	KBp0cliZqp50IZMTi5Nw5wYlxC/DjEcyqBl+vYMIEnDWaO2ong/7rbPisgJ+F0nkNJFE2z
	VE9jJca1sFE6XVkhnf/Ml9kSBpoIyvI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755065351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hY+K4iO2jFIDgvQlSmZGXAZAC7nQZfJxGWFuPRGplmA=;
	b=7T5hdsk2X0Xol0uscVVJpxyiUqs1286jU9vZCE/HHDPbFToeb2/8pumwKFBuFW+D0WVkD+
	YIow8VWMFRhh+RVPUH54j9MLDFGetH7XGdX+1f5xJ4ok8cLJFIE9BrHji7tFLTWSLaNuVe
	wkeP2e4Ul5hDTXm9F+dW5wqboV+i3PU=
X-AuditID: a67dfc5b-c45ff70000001609-ca-689c2c035287
Date: Wed, 13 Aug 2025 15:09:01 +0900
From: Byungchul Park <byungchul@sk.com>
To: akpm@linux-foundation.org, kuba@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250813060901.GA9086@system.software.com>
References: <20250729110210.48313-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729110210.48313-1-byungchul@sk.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85O+e4Wr0tq7ciyHURrNa9Hu1idIFDEhRBH5KylYc21Flb
	mUaXmUK18tLFyDltUpkuwZip0zLymhWUGcaxm7lSkGyVlnnD2jEiv/34P//nx/Ph4Wm1WzGN
	NxgPiSajLlrDKhnll7G5C+j5dv2il8MBYC8qZOF2Xzzc+uBWgN1ZiuBH/xsOflfWI+ipfcTC
	55puBNdze2mwP09m4GfRAA3t9R4Obru2QGteBwP3T5fR4ElrYCEleZCGyn4vB6fc+RTYiy0c
	NJamKuDywE0ayiwfOHhZYWfhfeFvBXRUpzDw2FbAwLeMWhpaU9dBvWMy9D7tQlBbVEZB7/ls
	FpozKygoqWzm4FKTg4WPya0Immo8DGQMnWEhKzEVwWCfT+lN/6GArLr33Lp5QqIksUJN11da
	uFvQQgnSgyeUUG57xwkO12GhOD9IsEpNtOBynmUFV/dFTnj76j4rNFwdZITytmCh3N1DCSlJ
	Xlb43v6a2eq/U7k6Uow2xImmhWv3KPU38u6gA5m7452FwRZ0L8yK/HiClxFnXhFrRfwIX0uf
	LccMnkOe1X5nZGZxIJGkflpmf6wlXWlJI0zjAo4Mt42ReSLWk+Kcj5SsUeGV5GfJVDlW4+XE
	mfKJlVmFJ5DHmZ+Yv6tBRBruHKnTeDq5NczLsR9eQeoaqpDMk/As8rD0ka+i9B32lif1jhb0
	9+KppCpfYtIRto3S2kZpbf+1DkQ7kdpgjIvRGaKXafUJRkO8dl9sjAv5/inv+FC4G3U3bq9G
	mEeasarGkCy9WqGLMyfEVCPC0xp/VfYuX6SK1CUcFU2xEabD0aK5Gk3nGc0U1ZLeI5FqvF93
	SIwSxQOi6d+U4v2mWdCOyeGFgTkn17Tf00ScK/Zejor9Wrc30eD2tF7Ebelzs4w9Ueu95gvN
	2s6kUE3VScWmxdaBYzkT9mpndJSZM5MWOENeXbmwtipm84ldOKSk03Aku+fZhiirZWlubNyi
	iPHUvI1cxbYMP9O5MCnHs8oprZkZWte5+uo4VcCv7Q9ePDmoYcx63eIg2mTW/QGB7RhvSwMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzHfZ/vc8/zdNz2SHho2E4WqbCJT2WVtfHIMn8xjLrpmbvVVbuj
	FWNRI81VfoSuS5mkrqhdqrsU6q6rMFKLkx/9UG1oqS5NP1a6zPTfa+/P+/X+68NgZ61oJaOI
	PimoomVRUkpMivf5J3lhT518c1mvGHSlJRQU/46HB11GEej0lQhGxz/SMFNrRWC3NFLwwzyC
	4N7dMQy6N8kk/CqdwNBn7aGh2BAKnQX9JNRcqsLQk95EgSZ5EkPt+CANF4yFBOjKE2kw5zSL
	oKUyTQQ3Ju5jqErsoqGtWkfBl5IZEfTXa0ho1haRMJRpwdCZFgTWvGUw9nIAgaW0ioCxKzkU
	tGdVE1BR207D9dY8Cr4mdyJoNfeQkDmVQkH2+TQEk79nJwczRkWQ3fCFDvLkz9tsFG8e+In5
	x0UfCN729AXBm7SfaT7PcIovL/TgU22tmDfoL1O8YeQazX96V0PxTbcnSd7U7cubjHaC1yQN
	UvxwXwe5f+lh8Y4IIUoRJ6g2BYSL5fkFZSg261i8vsQ3ET3Zm4oYhmO3crkZbqnIiSHZddxr
	yzDpYIp152y2cexgF9abG0hPmmPMFtHcdPdCBy9h5Vz5na+EY0bCbud+VaxwxM6sD6fX9FIO
	lrCLueasXvKv6sHZpr/N1THryj2YZhyxE7uNa2iqQw5eyq7lnlc2EhlIop1na+fZ2v92HsJ6
	5KKIjlPKFFE+3upIeUK0It77eIzSgGY/puDs1FUjGm3bXY9YBkkXSVr8suXOIlmcOkFZjzgG
	S10kOUdnI0mELOG0oIoJU52KEtT1yJUhpcslIQeFcGf2hOykECkIsYLq35VgnFYmohulC+Rt
	O5UDp63B/sv88PdMp6FHu/aQ+dMG0iIbD6SsAR1hocPPQozgd98tP9B+80hfb92J92VVIXbG
	FHRuvc/CwIf+I1qRuvlQ/JlgblWwvSZLu7qtw8vSsjHmlnIiMmhNGcPeOmN29zHX5fq91aSZ
	Xl3s31D9fs+BMEiRb5KSarlsiwdWqWV/AEGc1q0tAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: ckw9x4b1xnauwcg856chsbmoo13pcd84
X-Rspam-User: 
X-Rspamd-Queue-Id: 842414000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1755065350-962805
X-HE-Meta: U2FsdGVkX1+hzratlVgh+D3ZDwN0F7NniX50VYbuZ0nWs5HrgI57C41NKn5LoV/sB13JHiKd107jdzhfd2YAiTYl3oQhFWxE9TsywCvgx3qdH173a7Armj+O66UqhMB9C/b6y4gD9a/O4ny68y/qnv2dJnKBixl4X7RM4bT30SkUquF5sESDqklLpupvvl62w+7NyTyYG7zcnsW/199FX616HnPH75h7d6Ej73XN1kBtqQBmAq7/YPJTpVxL8cBL90rQaBjWJ/Jt77sA0yJeSNGf1NckxBtfiC/xwYsxubJhe91OLcIl/YLeYJ6mo6A0vvpGtrMeJOrDICASaXkHlsuIAjrGXQH1dyIJ9eR+zkzgShg4YnElWgDIe3g6iAo+pFfPX3GCRMIcGy1rwaW4LmPf0IlIrKHZSQE9ge7cxz4aEAsC9ljLgi+9ziUD+gL476KCzqIaJPtqwunyhvfvS13um+22+6mGKULRGO1aQShj40gFFxFAQd2e0gdupepSG6FLwBNIgnFJhaUqaeLoJCa7Q7VJu6xaALgroVOww5G2DTm1fcD4/tnb53AZQWgontsXfilYqC8PRlOwA1RSc593IgXVMIDrv7mzEeIWoDrlShwIiG3ELVihnRD/29dx1QPtn23usdBaUU9Ydkj+0S5UwNYzjtdfaPBlS6kSkoOcjqlpy1e6C5bu8stZC4qu6kDSFzOq0orxjsu2DK3/jE3TQ6fu3YfkYK1kycJWp52XL9jgzs1jXuskNIAmL6E6wMvPo0N2BSCIPm0vrqg0EmL9gikHGXUDq8FqUP5oqkecCazOKqhtTpr0W8GTcaC25RE7bgz9ktdJ3O2X7v3EBOryT4A02TpPV2xDJ6n3dnyU9aF5NO7i2jZ1fM4EMovVt8dK285AQFimcFtfADNVSIg9WaH0xigBJBqwGRLB8nHs5ysW4H4/qwjHmAbU0fynR82WmZgPhSPa4c8kOCp
 DpAHJExK
 0RbEKaNJjhgnMyygCxeIfNBOJtaToXqHsGkDKwhQUU0KE9IvXRE/dq6439gCcxvS/d8MjC4M3ifgcnOMYHAi/xqvn4qSUy4z6J7jtXTLM2VNcxqcd9Rt1uFtEqr7akD2ew1Li8X/ygJ0DZ+uv0/9Nrq4KmgLJzxEi8c0XmH+pp6meJSJO6u/vb86qqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 08:02:10PM +0900, Byungchul Park wrote:
> Changes from v2:
> 	1. Rebase on linux-next as of Jul 29.
> 	2. Skip 'niov->pp = NULL' when it's allocated using __GFP_ZERO.
> 	3. Change trivial coding style. (feedbacked by Mina)
> 	4. Add Co-developed-by, Acked-by, and Reviewed-by properly.
> 	   Thanks to all.
> 
> Changes from v1:
> 	1. Rebase on linux-next.
> 	2. Initialize net_iov->pp = NULL when allocating net_iov in
> 	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
> 	3. Use ->pp for net_iov to identify if it's pp rather than
> 	   always consider net_iov as pp.
> 	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> 
> ---8<---
> >From 88bcb9907a0cef65a9c0adf35e144f9eb67e0542 Mon Sep 17 00:00:00 2001
> From: Byungchul Park <byungchul@sk.com>
> Date: Tue, 29 Jul 2025 19:49:44 +0900
> Subject: [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type
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
> For net_iov, use ->pp to identify if it's pp, with making sure that ->pp
> is NULL for non-pp net_iov.
> 
> This work was inspired by the following link:
> 
> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on free.

Hi, Andrew and Jakub

I will spin the next one with some modified, once the following patch,
[1], gets merged.

   [1] https://lore.kernel.org/all/a8643abedd208138d3d550db71631d5a2e4168d1.1754929026.git.asml.silence@gmail.com/

This is about both mm and network.  I have no idea which tree should I
aim at between mm tree and network tree?  I prefer the network tree tho.

However, it's totally fine regardless of what it would be.  Suggestion?

	Byungchul

> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Mina Almasry <almasrymina@google.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
>  include/linux/mm.h                            | 27 +++----------------
>  include/linux/page-flags.h                    |  6 +++++
>  include/net/netmem.h                          |  2 +-
>  io_uring/zcrx.c                               |  4 +++
>  mm/page_alloc.c                               |  7 +++--
>  net/core/devmem.c                             |  1 +
>  net/core/netmem_priv.h                        | 23 +++++++---------
>  net/core/page_pool.c                          | 10 +++++--
>  9 files changed, 37 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 5d51600935a6..def274f5c1ca 100644
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
> index 0d4ee569aa6b..d01b296e7184 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4171,10 +4171,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
> @@ -4205,26 +4204,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
> index 8d3fa3a91ce4..84247e39e9e7 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -933,6 +933,7 @@ enum pagetype {
>  	PGTY_zsmalloc		= 0xf6,
>  	PGTY_unaccepted		= 0xf7,
>  	PGTY_large_kmalloc	= 0xf8,
> +	PGTY_netpp		= 0xf9,
>  
>  	PGTY_mapcount_underflow = 0xff
>  };
> @@ -1077,6 +1078,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
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
> @@ -298,7 +298,7 @@ static inline struct net_iov *__netmem_clear_lsb(netmem_ref netmem)
>   */
>  #define pp_page_to_nmdesc(p)						\
>  ({									\
> -	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
> +	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
>  	__pp_page_to_nmdesc(p);						\
>  })
>  
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index e5ff49f3425e..f771bb3e756d 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -444,6 +444,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>  		area->freelist[i] = i;
>  		atomic_set(&area->user_refs[i], 0);
>  		niov->type = NET_IOV_IOURING;
> +
> +		/* niov->pp is already initialized to NULL by
> +		 * kvmalloc_array(__GFP_ZERO).
> +		 */
>  	}
>  
>  	area->free_count = nr_iovs;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..2f6a55fab942 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1042,7 +1042,6 @@ static inline bool page_expected_state(struct page *page,
>  #ifdef CONFIG_MEMCG
>  			page->memcg_data |
>  #endif
> -			page_pool_page_is_pp(page) |
>  			(page->flags & check_flags)))
>  		return false;
>  
> @@ -1069,8 +1068,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>  	if (unlikely(page->memcg_data))
>  		bad_reason = "page still charged to cgroup";
>  #endif
> -	if (unlikely(page_pool_page_is_pp(page)))
> -		bad_reason = "page_pool leak";
>  	return bad_reason;
>  }
>  
> @@ -1379,9 +1376,11 @@ __always_inline bool free_pages_prepare(struct page *page,
>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>  		folio->mapping = NULL;
>  	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		WARN_ON_ONCE(PageNetpp(page));
>  		/* Reset the page_type (which overlays _mapcount) */
>  		page->page_type = UINT_MAX;
> +	}
>  
>  	if (is_check_pages_enabled()) {
>  		if (free_page_is_bad(page))
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index b3a62ca0df65..40e7a4ec9009 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -285,6 +285,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
>  			niov = &owner->area.niovs[i];
>  			niov->type = NET_IOV_DMABUF;
>  			niov->owner = &owner->area;
> +			niov->pp = NULL;
>  			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
>  						      net_devmem_get_dma_addr(niov));
>  			if (direction == DMA_TO_DEVICE)
> diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> index cd95394399b4..4b90332d6c64 100644
> --- a/net/core/netmem_priv.h
> +++ b/net/core/netmem_priv.h
> @@ -8,21 +8,18 @@ static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
>  	return __netmem_clear_lsb(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
>  }
>  
> -static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
> -{
> -	__netmem_clear_lsb(netmem)->pp_magic |= pp_magic;
> -}
> -
> -static inline void netmem_clear_pp_magic(netmem_ref netmem)
> -{
> -	WARN_ON_ONCE(__netmem_clear_lsb(netmem)->pp_magic & PP_DMA_INDEX_MASK);
> -
> -	__netmem_clear_lsb(netmem)->pp_magic = 0;
> -}
> -
>  static inline bool netmem_is_pp(netmem_ref netmem)
>  {
> -	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> +	/* Use ->pp for net_iov to identify if it's pp, which requires
> +	 * that non-pp net_iov should have ->pp NULL'd.
> +	 */
> +	if (netmem_is_net_iov(netmem))
> +		return !!__netmem_clear_lsb(netmem)->pp;
> +
> +	/* For system memory, page type bit in struct page can be used
> +	 * to identify if it's pp.
> +	 */
> +	return PageNetpp(__netmem_to_page(netmem));
>  }
>  
>  static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 05e2e22a8f7c..37eeab76c41c 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -654,7 +654,6 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
>  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  {
>  	netmem_set_pp(netmem, pool);
> -	netmem_or_pp_magic(netmem, PP_SIGNATURE);
>  
>  	/* Ensuring all pages have been split into one fragment initially:
>  	 * page_pool_set_pp_info() is only called once for every page when it
> @@ -665,12 +664,19 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  	page_pool_fragment_netmem(netmem, 1);
>  	if (pool->has_init_callback)
>  		pool->slow.init_callback(netmem, pool->slow.init_arg);
> +
> +	/* If it's page-backed */
> +	if (!netmem_is_net_iov(netmem))
> +		__SetPageNetpp(__netmem_to_page(netmem));
>  }
>  
>  void page_pool_clear_pp_info(netmem_ref netmem)
>  {
> -	netmem_clear_pp_magic(netmem);
>  	netmem_set_pp(netmem, NULL);
> +
> +	/* If it's page-backed */
> +	if (!netmem_is_net_iov(netmem))
> +		__ClearPageNetpp(__netmem_to_page(netmem));
>  }
>  
>  static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
> 
> base-commit: 54efec8782214652b331c50646013f8526570e8d
> -- 
> 2.17.1


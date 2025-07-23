Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F47C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 04:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3096B0096; Wed, 23 Jul 2025 00:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172CF6B0098; Wed, 23 Jul 2025 00:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061B76B0099; Wed, 23 Jul 2025 00:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6AE96B0096
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:46:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAA181DB03B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:46:21 +0000 (UTC)
X-FDA: 83694292962.25.44CC8BB
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id 486D8100002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:46:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753245980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8RXA+PfWHp/MQu+lu7kACg6oH5l/svzRVq78IOeOlZk=;
	b=t0Ealqw6L6sRoxp86BeDvMq5+LMKhZxsjbfNwLgiGxprIpTR0/dHWFoAfKrvoxEI4zN69u
	qhHAkkrPAdaEjs4SGfU1hoQyFiIwifIfgQ/M0anrnFAx/RtpyHNMgnsCUljuLockW/D+sj
	yeCs/BOTXZ3QQSNxhNx8RyFfkx1DKT8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753245980; a=rsa-sha256;
	cv=none;
	b=YQIS4pcv2tzb9ptdMvK4JPYX87YnV832sK2PzYNONEV4YWeJZh1HLamPKZPaWBC7GwXvAZ
	fDS3HsYliDcjKNtBNzjZBYLvhVbTb6WOIXG/O8KCnsFga6ga+MLTv8AdGaeaRiMk1wZRGo
	1secwLM5jpFguBIvsI7aqWGCqFPRHyM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-669ff7000002311f-bd-68806918915e
Date: Wed, 23 Jul 2025 13:46:10 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mina Almasry <almasrymina@google.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	toke@redhat.com, asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool
 in page type
Message-ID: <20250723044610.GA80428@system.software.com>
References: <20250721054903.39833-1-byungchul@sk.com>
 <CAHS8izM11fxu6jHZw5VJsHXeZ+Tk+6ZBGDk0vHiOoHyXZoOvOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izM11fxu6jHZw5VJsHXeZ+Tk+6ZBGDk0vHiOoHyXZoOvOg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85O+c4WhzX7U0/RIsopeyCySNFV4qXICtNCLuuPLSRrtjW
	0uiyUrqIM63sMpeuUvMSSKt0VopNU7uRGJN1Xa2sKC9ltdRJyymR33783+f9/54PD0/LH0tC
	eLVGL2o1yiQFK2WknaMuzcRqo2r2l67JYKm4xkJ5bwpcfWuXgKWsEsHPvpcc+GsaEfxoaGLh
	a30PgiuXvDRYnqYz8Kuin4b2Rg8H5bZV4C7+yMDdY1U0eE42s2BK99FQ09fFwRF7CQWWG0YO
	WiqzJHCmv4iGKuNbDp7dtrDw5ppfAh8dJgYemEsZ+JbbQIM7azE0WseD91EHgoaKKgq8mRdZ
	cF64TcHpVisL79PdCFrrPQzkDhxnIe9wFgJf72BbV/ZPCeTdf8MtDif1Hd00uVn6nCKu2ocU
	qTa/5ojVtofcKAknGa5WmtjKTrDE1nOKI6/a7rKk+byPIdXvokm1/QdFTGldLPne/oIh3bVO
	ds2YBOmCRDFJbRC1sxZulaqcRU5qd05Miv9XE2tEBdEZKIjHQiR+4TxLZSB+iE8d2RaIGWEq
	zrf76QCzwjTscvUN8VghDBfW5kgCTAtnOXzl6OgAjxEScIuxhgqwTABc5zjBBCrlwn583TRv
	OA7GDy58YIa/TsMD+a10YIQWQvHVP/xwPAmn3cobMgUJa7G78/TQ+DhhCq6rbBpslw4u2cHj
	c5l1zPD2E/G9EheTjYLNIxTmEQrzf4V5hMKKmDIkV2sMyUp1UmSEKlWjTonYvivZhgZvrPjA
	wAY76mmJcyCBR4pRMuOtQyq5RGnQpSY7EOZpxViZ985BlVyWqEzdJ2p3bdHuSRJ1DhTKM4oJ
	srnevYlyYYdSL+4Uxd2i9t8rxQeFGBG9s2O9orN5FvHNXxm8tqodlvqL4r8ayrrbxj2JWOZf
	pyn1L10eLMuOQuVn4ksLN/8W9VkLl4UWLvgQovdstPqc8+s+R+3vXbPEWTCjP+7yimq3aXrs
	vNHS62GRS4JMm5yeOMPkRe3noyWfQifoVmeGcS8LqL2x8RNzCtNi9GbNAQWjUynnhNNanfIv
	HUOvsl8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvTPTmQGtjhX1Ci6xikZwI5HkGIXwQOLEKMH4YGJMsMJgG0rB
	FhGMS4VGBAUBl2gpiKKCSCSUpQUs0RYp4IMEgyIu1SokKpssVQRFCzHy9uU///nOy2FJyQOR
	N6tQJQhqlUwppT0pz7BtqRuwQivfbDTMBkN5GQ33fyRB8XuzCAylNQhGxl4zMGlpQjDcaKfh
	q20IQdFNFwmGZzoKRst/ktDd5GTgvnE3OO72UPAwzUSC82IzDZm6cRIsY/0MpJhLCDBUahmw
	5beIoK0mSwSXf94hwaR9z8DzOgMN78omRdBjzaSgRX+PgsErjSQ4skKgqXARuJ72ImgsNxHg
	upBPQ8f1OgIutRfS8FHnQNBuc1JwZeIcDXlnshCM//hr688eEUHek3dMiD9v6x0g+ap7rwi+
	s6GV4Gv1bxm+0HiUryzx4zM620neWJpO88ahXIZ/8+IhzTdfG6f42g9b+VrzMMFnpvbT/Lfu
	LoofaOigw732e26PEpSKREG9Kfigp7zjTgcRnxOWNDlqp7XoxtYMxLKY24JzUw5lIA+W4nxx
	gXmSdDPNrcWdnWNT7MWtw7cbckRuJrmrDC46O9fNC7j9uE1rIdws5gA/sqZTbqWEO4ErMgOn
	4/m45fonanp1LZ4oaCfdFZLzwcW/2el4BU6tzpu65MHtwY6+S1P1hdwq/KjGTmSjufoZJv0M
	k/6/ST/DVIioUuSlUCXGyhTKwI2aGHmySpG0MTIu1oj+ftHdkxM5ZjTyfIcVcSySzhFrq0/L
	JSJZoiY51oowS0q9xK76U3KJOEqWfFxQx0WojyoFjRX5sJR0sXjnPuGghDssSxBiBCFeUP+b
	EqyHtxZBfEFMlTI0f1f4vIrTkQ/69s6+dUI3Ht37dRPrWGqGJUUjFwqOHYluVaLWsLTQ8/3W
	ILsrKM3e5VOZd+DiaITucfXQ+i/qnXRl83elKlS+rCpEeCn3b/jlPMx+W/iinny7JuaWSvNy
	wBa8PGulSTNr0BIwrJeW+J5JK/7MDDhXSymNXBbgR6o1sj+Zpd0oQQMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: znnebo4urdui99zszdx1p1rycbprewpy
X-Rspamd-Queue-Id: 486D8100002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753245978-508478
X-HE-Meta: U2FsdGVkX1/UCoCFx5IIVPZFZ3GZROIXX2LVZ2ag0jvFyRvZsBODh0CEzeBweBXkHyK0+NPAUZz8fafBX1kd+LolZCjBEw6QdEQHrkDIK/Gb3h4stuVsLoRgUeIbajnqvdMFtnYLj45Piuxtk+nrUcKSJRbQmBEmre1in5aZ9dEX0SlmKr9hKWwYNCyW3ft5fQmWZpuqMaTCHOrFQoZsMHh6+EYU1B64eZfOuw8KP1PIPLUEM7L6qg5plLTRWrdSwDNpsAiEsSAURMaSfiMwoih3gVQu/2dcuzJk+IhfdjiQ0RPg6FVLnWPOY/Eq3ithsXE/D0A9WZ4zy350gm03EjEiBn/sB5e8EUuZ1shLK3uUJhnmCOPOjTrIldPEjwSk3SSQnRsmd69V+6qabwmxrYaOiTHuHs28g7AxwldnwqOE4yEyh5waNyhtdRH9440qUoXtDiGMIoU1yfQVLd6+OmkgEEejS4Qc5YC4sGkujumuyWez2afPTgCraC5t6Ax+bZf3UfZJi3dbqyG2ynesdvoBR5eOY4YeCtsyNz2z3ZDTVH+lwURsuLFXpBNNasVIu5qfugwyri5enad2I5YjRqWQX2t5xwEwkZ1N6gteuaAEaWGOo0ihaN5aYJmpOK3x4OjxWxeRo2YpsE9MuTBfHm1NTmDrlz878wfJPkKLZRsXjqZJ6+ARmofaZIm1Hj/+qCxDw2PndHbs8OF1jYM4Qu2IQ8peAg8l71m7bnzObvXbbIDoHJiJ9gm6+h6NUc+dgcFUEaVa0qu/xRD+2V4AR3crx5QpA/RiXP0jtmdAd7k0f8iBFt13KzuBF/7cJr0cWSmy8eAruq4tPeNSQF30jKh8eGwCN0mhSpeTBmKksYAlIPNHUs+vaJRJ63dTA3fXD85oWOFVrWh0rT2F3zi9L51HaXwMx2oZGyq6TXZv3rOEBjBqlQMciQptuHQ8MM4nlujd/WEIV5Su38JGIyF
 yyfoDSVE
 PDSApVXIMUyii6c8sNPvuszvfm0XGkQLvKrCGhGaAADVABFPcNhfTyyoFly490ZptnFr9IhaqFWdAt1PrkedpARp2NRc4R3Z5AcHH/c9EOKU/iP7yfWu1gtT0vv0v8C2eLeSV5ucxXXMuG1KAhNrKwcA+Ru9iUaq9TlsqFJynbZo5t6xRBkUJiZfFzh9JmPxHaOwn4C8S9jGG6qU2aJBun1qgkeaa4BZnIR/CKyWctUvK1EI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 03:17:15PM -0700, Mina Almasry wrote:
> On Sun, Jul 20, 2025 at 10:49 PM Byungchul Park <byungchul@sk.com> wrote:
> >
> > Hi,
> >
> > I focused on converting the existing APIs accessing ->pp_magic field to
> > page type APIs.  However, yes.  Additional works would better be
> > considered on top like:
> >
> >    1. Adjust how to store and retrieve dma index.  Maybe network guys
> >       can work better on top.
> >
> >    2. Move the sanity check for page pool in mm/page_alloc.c to on free.
> >
> >    Byungchul
> >
> > ---8<---
> > From 7d207a1b3e9f4ff2a72f5b54b09e3ed0c4aaaca3 Mon Sep 17 00:00:00 2001
> > From: Byungchul Park <byungchul@sk.com>
> > Date: Mon, 21 Jul 2025 14:05:20 +0900
> > Subject: [PATCH] mm, page_pool: introduce a new page type for page pool in page type
> >
> > ->pp_magic field in struct page is current used to identify if a page
> > belongs to a page pool.  However, page type e.i. PGTY_netpp can be used
> > for that purpose.
> >
> > Use the page type APIs e.g. PageNetpp(), __SetPageNetpp(), and
> > __ClearPageNetpp() instead, and remove the existing APIs accessing
> > ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> > netmem_clear_pp_magic() since they are totally replaced.
> >
> > This work was inspired by the following link by Pavel:
> >
> > [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> >
> > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
> >  include/linux/mm.h                            | 28 ++-----------------
> >  include/linux/page-flags.h                    |  6 ++++
> >  include/net/netmem.h                          |  2 +-
> >  mm/page_alloc.c                               |  4 +--
> >  net/core/netmem_priv.h                        | 16 ++---------
> >  net/core/page_pool.c                          | 10 +++++--
> >  7 files changed, 24 insertions(+), 44 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > index 5d51600935a6..def274f5c1ca 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > @@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
> >                                 xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
> >                                 page = xdpi.page.page;
> >
> > -                               /* No need to check page_pool_page_is_pp() as we
> > +                               /* No need to check PageNetpp() as we
> >                                  * know this is a page_pool page.
> >                                  */
> >                                 page_pool_recycle_direct(pp_page_to_nmdesc(page)->pp,
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ae50c1641bed..736061749535 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4135,10 +4135,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
> >   * DMA mapping IDs for page_pool
> >   *
> >   * When DMA-mapping a page, page_pool allocates an ID (from an xarray) and
> > - * stashes it in the upper bits of page->pp_magic. We always want to be able to
> > - * unambiguously identify page pool pages (using page_pool_page_is_pp()). Non-PP
> > - * pages can have arbitrary kernel pointers stored in the same field as pp_magic
> > - * (since it overlaps with page->lru.next), so we must ensure that we cannot
> > + * stashes it in the upper bits of page->pp_magic. Non-PP pages can have
> > + * arbitrary kernel pointers stored in the same field as pp_magic (since
> > + * it overlaps with page->lru.next), so we must ensure that we cannot
> >   * mistake a valid kernel pointer with any of the values we write into this
> >   * field.
> >   *
> > @@ -4168,25 +4167,4 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
> >
> >  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
> >                                   PP_DMA_INDEX_SHIFT)
> > -
> > -/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
> > - * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
> > - * the head page of compound page and bit 1 for pfmemalloc page, as well as the
> > - * bits used for the DMA index. page_is_pfmemalloc() is checked in
> > - * __page_pool_put_page() to avoid recycling the pfmemalloc page.
> > - */
> > -#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> > -
> > -#ifdef CONFIG_PAGE_POOL
> > -static inline bool page_pool_page_is_pp(const struct page *page)
> > -{
> > -       return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
> > -}
> > -#else
> > -static inline bool page_pool_page_is_pp(const struct page *page)
> > -{
> > -       return false;
> > -}
> > -#endif
> > -
> >  #endif /* _LINUX_MM_H */
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 4fe5ee67535b..906ba7c9e372 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -957,6 +957,7 @@ enum pagetype {
> >         PGTY_zsmalloc           = 0xf6,
> >         PGTY_unaccepted         = 0xf7,
> >         PGTY_large_kmalloc      = 0xf8,
> > +       PGTY_netpp              = 0xf9,
> >
> >         PGTY_mapcount_underflow = 0xff
> >  };
> > @@ -1101,6 +1102,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> >  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
> >  FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
> >
> > +/*
> > + * Marks page_pool allocated pages.
> > + */
> > +PAGE_TYPE_OPS(Netpp, netpp, netpp)
> > +
> >  /**
> >   * PageHuge - Determine if the page belongs to hugetlbfs
> >   * @page: The page to test.
> > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > index f7dacc9e75fd..3667334e16e7 100644
> > --- a/include/net/netmem.h
> > +++ b/include/net/netmem.h
> > @@ -298,7 +298,7 @@ static inline struct net_iov *__netmem_clear_lsb(netmem_ref netmem)
> >   */
> >  #define pp_page_to_nmdesc(p)                                           \
> >  ({                                                                     \
> > -       DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));               \
> > +       DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));                          \
> >         __pp_page_to_nmdesc(p);                                         \
> >  })
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 2ef3c07266b3..71c7666e48a9 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -898,7 +898,7 @@ static inline bool page_expected_state(struct page *page,
> >  #ifdef CONFIG_MEMCG
> >                         page->memcg_data |
> >  #endif
> > -                       page_pool_page_is_pp(page) |
> > +                       PageNetpp(page) |
> >                         (page->flags & check_flags)))
> >                 return false;
> >
> > @@ -925,7 +925,7 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
> >         if (unlikely(page->memcg_data))
> >                 bad_reason = "page still charged to cgroup";
> >  #endif
> > -       if (unlikely(page_pool_page_is_pp(page)))
> > +       if (unlikely(PageNetpp(page)))
> >                 bad_reason = "page_pool leak";
> >         return bad_reason;
> >  }
> > diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> > index cd95394399b4..39a97703d9ed 100644
> > --- a/net/core/netmem_priv.h
> > +++ b/net/core/netmem_priv.h
> > @@ -8,21 +8,11 @@ static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
> >         return __netmem_clear_lsb(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
> >  }
> >
> > -static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
> > -{
> > -       __netmem_clear_lsb(netmem)->pp_magic |= pp_magic;
> > -}
> > -
> > -static inline void netmem_clear_pp_magic(netmem_ref netmem)
> > -{
> > -       WARN_ON_ONCE(__netmem_clear_lsb(netmem)->pp_magic & PP_DMA_INDEX_MASK);
> > -
> > -       __netmem_clear_lsb(netmem)->pp_magic = 0;
> > -}
> > -
> >  static inline bool netmem_is_pp(netmem_ref netmem)
> >  {
> > -       return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> > +       if (netmem_is_net_iov(netmem))
> > +               return true;
> 
> As Pavel alludes, this is dubious, and at least it's difficult to
> reason about it.
> 
> There could be net_iovs that are not attached to pp, and should not be
> treated as pp memory. These are in the devmem (and future net_iov) tx
> paths.
> 
> We need a way to tell if a net_iov is pp or not. A couple of options:
> 
> 1. We could have it such that if net_iov->pp is set, then the
> netmem_is_pp == true, otherwise false.
> 2. We could implement a page-flags equivalent for net_iov.
> 
> Option #1 is simpler and is my preferred. To do that properly, you need to:
> 
> 1. Make sure everywhere net_iovs are allocated that pp=NULL in the
> non-pp case and pp=non NULL in the pp case. those callsites are
> net_devmem_bind_dmabuf (devmem rx & tx path), io_zcrx_create_area
> (io_uring rx path).
> 
> 2. Change netmem_is_pp to check net_iov->pp in the net_iov case.

Good idea, but I'm not sure if I could work on it without consuming your
additional review efforts.  Can anyone add net_iov_is_pp() helper?

Or use the page type, Netpp, as an additional way to identify if it's a
pp page for system memory, keeping the current way using ->pp_magic.
So the page type, Netpp, is used for system memory, and ->pp_magic is
used for net_iov.  The clean up for ->pp_magic can be done if needed.

	Byungchul

> --
> Thanks,
> Mina


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718CDC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 05:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0054A6B0092; Mon, 28 Jul 2025 01:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DE66B0093; Mon, 28 Jul 2025 01:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33B26B0095; Mon, 28 Jul 2025 01:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D35586B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:27:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B1BE10F001
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:27:59 +0000 (UTC)
X-FDA: 83712541878.27.DF9D9A3
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C1B1120004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:27:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753680478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=OpUbF1dALkJRsaSv3bzuQDiFIxtUqi1qK6grAvN7qSw=;
	b=d3b+fDeY0Aa6MqYhciqQ+PPIBl/DGD71aYoJQqe5ZdwSXFg1tpeTw8hq81V6yFxNBG8hdB
	HepxB9grz0PyaeX0yyWmjgH1mNWxRMzNV7XHe0UacBNwHUqJNOBMZIagP+s1TkcgD3awtX
	TYhiIjT75cYF6WmPdWNIwOqOCRIbOR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753680478; a=rsa-sha256;
	cv=none;
	b=3S/+ZSLBV9UGhYoB0Y6P/63cpKnS2pCk57XUTky0fCJHj+hHR9ZCUrAQFtwJ+akarbBvek
	yR7xfsl3PvxccpLXblZJIVKsTiAwdcHc/t8SId3j6XWpBz+XdkK1jGO3IocCruVP7joo6V
	D7dFfulfVq+GYjbBohsjEIrpHPnSvVU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-681ff7000002311f-55-68870a5843d3
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2] mm, page_pool: introduce a new page type for page pool in page type
Date: Mon, 28 Jul 2025 14:27:42 +0900
Message-Id: <20250728052742.81294-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTcRgG8P7nnJ1ztlycZtTRiGhQkpVlFL1RmH07REaU0E2o1Q5tOC/M
	S85Ipo40aybWwnTCyrS5KeocTkXF5r2izFrMLlqWZuVdW97AvNC3H+/D83x5aVzSTfjSyshY
	Xh0pU0lJESEa9nq865woTbHnVwUFxrISEqzTCfD0S7UAjJYqBFMzHylYqG9FMNncRsLvpgkE
	BY88OBhf6wj4UzaLQ39rHwVWWwj0Fg0QUJfmwKHvbjsJet0cDvUzIxSkVJsxMFZqKeisyhTA
	/dlCHBzaLxS8rTWS0FOyIIABp56AjtxiAsYMzTj0ZgZDq2k9eF4MIWguc2DguZNPguthLQb3
	ukwkfNP1Iuhq6iPAMJ9OQl5yJoK56cW1kawpAeS19FDB/lzT0CjO2Yu7Mc7d8BzjanI/U5zJ
	FsdVmv25DHcXztkst0jONpFNcZ/e15Fce84cwdV8PcjVVE9inD51hOTG+z8Q3GiDizzpfV50
	WM6rlPG8enfQJZGiqm8Bi/54PME+ZMa0yBWUgYQ0y+xja7Q91H/njA0um2T8WLd7Bl/yOmYP
	azZMLVpE44ydYkvK3MuBN3OG/duWTCyZYLayw6a6ZYuZ/eyo6wGxMrqZtZY3LpdZRk+z32+b
	BSuBD/vM7Cay0GoTWmVBEmVkfIRMqdoXoNBEKhMCrkRF2NDiw4tuzF+oRhOdp52IoZHUSzx4
	4KZCIpDFx2ginIilcek6cXTh4kksl2kSeXXURXWcio9xoo00Id0g3uu5JpcwV2WxfDjPR/Pq
	/ylGC321KPCOH2YXpuRvCZ9gDUlHW7ydrsSz2dMf1v4IGy9FBWuq5NslVo0tthBzCru2nSrt
	Ee0Ievl8+6ssn8EnwjeXr2sdUcPz2sYKP3rTu7CQkK/lhr3+qecm36m0J5LS9Z6dx0D3Im49
	Xxd6KDxh1Pdn8EBxrz3UkmwvMR/piLJOTkuJGIUs0B9Xx8j+AepeyKfsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRWUgUcRwHcP8zszPj5sKsLTnZIWyHYXhB6k9axB6sSdN6KUOI3HJqF892
	1dQQNDctSbPDMF1hIzSvsFbxVsrbyhJlY/PWchE0Na/1ClOjtw/fL3xfvjRuXU/Y0sqIaF4V
	IQ+TkkJCGHAyxfGyME3hsl7iDNryMhJKV+Lg9WiNALQlVQgWVwco2GxsR7DQ2kHCVMs8glcv
	l3HQftUQsFS+hsNE+zgFpXp/GCk0EdCQVo3D+KNOEjI06zg0rs5QcLemCANtRRIFLfldAuip
	yhTAs7UCHKqTRinoq9OSMFy2KQBTcwYBXbnFBMxlt+IwkukN7bo9sPxpGkFreTUGyw/zSTC8
	qMPgaa+OhB+aEQS9LeMEZG/cJyEvORPB+srW2kzWogDy2oYp7+Ncy/QszlUWf8c4Y9NHjKvN
	HaI4nT6Gqyhy4NKNvTinL3lAcvr5JxQ3+K2B5Dpz1gmudsyTq61ZwLiMlBmS+z3RT3CzTQby
	giRIKAvhw5SxvMrZK1ioqBrfxKIGzsVVThdhScjglY4saZY5webMTVLbJhl71mhcxbctYVzY
	ouzFLQtpnKmk2LJy406xmwlkzR3JxLYJ5gj7S9ewYxHjxs4anhP/Ru3Y0rfv8SxE65BFCZIo
	I2LD5cowNyd1qCI+QhnndD0yXI+2Li1M3Hhcgxb7zjQjhkZSK9GkR6rCWiCPVceHNyOWxqUS
	UVTBViQKkccn8KrIq6qYMF7djPbRhNRG5BvIB1szN+XRfCjPR/Gq/y1GW9omoY7DrpOnZQnD
	PZnv/Ja/7FoQOx8zid+M+VX3+3y2FF8yWlwD8xWxna/qdm++/5RNkClZZzb72Zt8NFbhsfXm
	wA+Ko2e7rYb+zMZ5mPbv/SmWHZIc4KfdD3oupQbdC5C1dRfknb84mJLYdedWR2KwTFTQ6OjT
	IHPPok4pDJobhK2UUCvkrg64Si3/C0/gid/OAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 6C1B1120004
X-Stat-Signature: psn3iux6un8bww4rese9mhss1az7kia6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753680477-495700
X-HE-Meta: U2FsdGVkX1/QQMuaje7BXgzjNB9m6owX6u/rncy4qUuAnd5syX6F2vXzLjJ1WZLSrgtgW44yS1Wd/4+7+2TMVpIIEVOQk2NDvwKpQF2fn2/wpOq2F/I2KFV2aWNwphTTQ/ZYzVIt3kn9BSTwNBZwYMPoG19kakNENJUwU7f+3aHsoEI5CPjaU+Y6CNq8kpGowWzMDLa7zd0zXghMV5U/99xhCD5/9GZrXhfrDhOHevYpfCG9yC6CUv5oO3zmMxcuPFO8v7r9q8swPU7itolEG5S19tSf+h3xGZW4Avqfps3gGgWVbl5VXCBHUJyN418ybipM4wQwKc1rP2G6UJJGVPRFLek+cbmoiCgzuebu1p4CarjQzRaSk5M/9O3rHYTPyB1KZ2LKgBySYwtNOPalXhYcD4H47RjqPLBBsFatehdQDLI5FQDsMB/VgshGcmsNgHWs0tkOsJl33OVgvQ5kaPTInjv7vJ8p27aEOm74maNHy8gZiaY1rIjxbgJtJVm9PUviya/vMGvy0nAA/MXEBzwqUZw7numa9JOmANk4ey4nb5YpYziQ9pBQyFnZMjP+ksFYm5WIHzoMabAlG1rHpxYpT1UOb5LZmvwPinz6D5IEwx4mtrBqBxxySudqV0vgo5vZgNSqYvhWfdbqzPBcvfcDCjni/04BaCJ0LaaMHHwLk3J96zSsFBttslhvNKWy+OBhcclVyRzvNhQX7zRwvsbRIubtYc5e2wT0NQvFw5y7O7D1Yb8wLIaXvcOLfDU2c7cX83N3GelcMuUs1bQ0/OiF+1OJiIW/bQHw4+1MLkckWg28K4EOyNl5QyvWaEQ0J+qpovzrKcSBVyd4+iaNW0O6kqMAWrVh3EnbzxYC6GEZYWr4ErV0bLXoZ2jJUwcQa8L0ncDyBiwAP6II1AgV6KGu2W48cNZTrytzWEadZFLWfkLR5XyRd0BWHQzo1aHS6F2rDqkEy/Re6HJiQg3
 Yc+tQdl7
 OS1+RuKdt/QvWTgToSWc+oSw832/4xmaIc05Eu3keMqYmrOlkNN7QsdvkCPgEUXIm0tCBxlV4HXpc/EoEIH4ZoD2GqsryRab40S3ewkl0A3z7a8hU6FoMwQUDExumGhy779ij2OZq+c5N/mhnqKIpkr/k2QoBZzn/zNnFRdhFeWaenWqg6W4YoKT8yAH3Yhuvr3BXuAoKanVu4MaeiX95TTJLMzIjRCmr/mwn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes from v1:
	1. Rebase on linux-next.
	2. Initialize net_iov->pp = NULL when allocating net_iov in
	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
	3. Use ->pp for net_iov to identify if it's pp rather than
	   always consider net_iov as pp.
	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.

---8<---
From 08b65324282bbe683a2479faef8eb24df249fd18 Mon Sep 17 00:00:00 2001
From: Byungchul Park <byungchul@sk.com>
Date: Mon, 28 Jul 2025 14:07:17 +0900
Subject: [PATCH v2] mm, page_pool: introduce a new page type for page pool in page type

->pp_magic field in struct page is current used to identify if a page
belongs to a page pool.  However, ->pp_magic will be removed and page
type bit in struct page e.i. PGTY_netpp can be used for that purpose.

Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
and __ClearPageNetpp() instead, and remove the existing APIs accessing
->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
netmem_clear_pp_magic().

For net_iov, use ->pp to identify if it's pp, with making sure that ->pp
is NULL for non-pp net_iov.

This work was inspired by the following link:

[1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/

While at it, move the sanity check for page pool to on free.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 io_uring/zcrx.c                               |  1 +
 mm/page_alloc.c                               |  7 +++--
 net/core/devmem.c                             |  1 +
 net/core/netmem_priv.h                        | 23 +++++++---------
 net/core/page_pool.c                          | 10 +++++--
 8 files changed, 33 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 5ce1b463b7a8..79a3ceff3952 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 				page = xdpi.page.page;
 
-				/* No need to check page_pool_page_is_pp() as we
+				/* No need to check PageNetpp() as we
 				 * know this is a page_pool page.
 				 */
 				page_pool_recycle_direct(page->pp, page);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3bfb566ad202..d01b296e7184 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4171,10 +4171,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  * DMA mapping IDs for page_pool
  *
  * When DMA-mapping a page, page_pool allocates an ID (from an xarray) and
- * stashes it in the upper bits of page->pp_magic. We always want to be able to
- * unambiguously identify page pool pages (using page_pool_page_is_pp()). Non-PP
- * pages can have arbitrary kernel pointers stored in the same field as pp_magic
- * (since it overlaps with page->lru.next), so we must ensure that we cannot
+ * stashes it in the upper bits of page->pp_magic. Non-PP pages can have
+ * arbitrary kernel pointers stored in the same field as pp_magic (since
+ * it overlaps with page->lru.next), so we must ensure that we cannot
  * mistake a valid kernel pointer with any of the values we write into this
  * field.
  *
@@ -4205,26 +4204,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
 				  PP_DMA_INDEX_SHIFT)
 
-/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
- * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
- * the head page of compound page and bit 1 for pfmemalloc page, as well as the
- * bits used for the DMA index. page_is_pfmemalloc() is checked in
- * __page_pool_put_page() to avoid recycling the pfmemalloc page.
- */
-#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
-
-#ifdef CONFIG_PAGE_POOL
-static inline bool page_pool_page_is_pp(struct page *page)
-{
-	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
-}
-#else
-static inline bool page_pool_page_is_pp(struct page *page)
-{
-	return false;
-}
-#endif
-
 #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
 #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
 #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8e4d6eda8a8d..548a68415845 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -935,6 +935,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_netpp		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1079,6 +1080,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
 PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
 FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
 
+/*
+ * Marks page_pool allocated pages.
+ */
+PAGE_TYPE_OPS(Netpp, netpp, netpp)
+
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
  * @page: The page to test.
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 100b75ab1e64..34634552cf74 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		area->freelist[i] = i;
 		atomic_set(&area->user_refs[i], 0);
 		niov->type = NET_IOV_IOURING;
+		niov->pp = NULL;
 	}
 
 	area->free_count = nr_iovs;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fa09154a799c..cb90d6a3fd9d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1042,7 +1042,6 @@ static inline bool page_expected_state(struct page *page,
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-			page_pool_page_is_pp(page) |
 			(page->flags & check_flags)))
 		return false;
 
@@ -1069,8 +1068,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(page_pool_page_is_pp(page)))
-		bad_reason = "page_pool leak";
 	return bad_reason;
 }
 
@@ -1379,9 +1376,11 @@ __always_inline bool free_pages_prepare(struct page *page,
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 		folio->mapping = NULL;
 	}
-	if (unlikely(page_has_type(page)))
+	if (unlikely(page_has_type(page))) {
+		WARN_ON_ONCE(PageNetpp(page));
 		/* Reset the page_type (which overlays _mapcount) */
 		page->page_type = UINT_MAX;
+	}
 
 	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
diff --git a/net/core/devmem.c b/net/core/devmem.c
index b3a62ca0df65..40e7a4ec9009 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -285,6 +285,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 			niov = &owner->area.niovs[i];
 			niov->type = NET_IOV_DMABUF;
 			niov->owner = &owner->area;
+			niov->pp = NULL;
 			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
 						      net_devmem_get_dma_addr(niov));
 			if (direction == DMA_TO_DEVICE)
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index cd95394399b4..4b90332d6c64 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -8,21 +8,18 @@ static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
 	return __netmem_clear_lsb(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
 }
 
-static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
-{
-	__netmem_clear_lsb(netmem)->pp_magic |= pp_magic;
-}
-
-static inline void netmem_clear_pp_magic(netmem_ref netmem)
-{
-	WARN_ON_ONCE(__netmem_clear_lsb(netmem)->pp_magic & PP_DMA_INDEX_MASK);
-
-	__netmem_clear_lsb(netmem)->pp_magic = 0;
-}
-
 static inline bool netmem_is_pp(netmem_ref netmem)
 {
-	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
+	/* Use ->pp for net_iov to identify if it's pp, which requires
+	 * that non-pp net_iov should have ->pp NULL'd.
+	 */
+	if (netmem_is_net_iov(netmem))
+		return !!__netmem_clear_lsb(netmem)->pp;
+
+	/* For system memory, page type bit in struct page can be used
+	 * to identify if it's pp.
+	 */
+	return PageNetpp(__netmem_to_page(netmem));
 }
 
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 05e2e22a8f7c..0a10f3026faa 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -654,7 +654,6 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -665,12 +664,19 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 	page_pool_fragment_netmem(netmem, 1);
 	if (pool->has_init_callback)
 		pool->slow.init_callback(netmem, pool->slow.init_arg);
+
+	if (netmem_is_net_iov(netmem))
+		return;
+	__SetPageNetpp(__netmem_to_page(netmem));
 }
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
 	netmem_set_pp(netmem, NULL);
+
+	if (netmem_is_net_iov(netmem))
+		return;
+	__ClearPageNetpp(__netmem_to_page(netmem));
 }
 
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,

base-commit: 97987520025658f30bb787a99ffbd9bbff9ffc9d
-- 
2.17.1



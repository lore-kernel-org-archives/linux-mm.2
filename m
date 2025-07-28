Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398C4C87FCF
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1FDF6B009A; Mon, 28 Jul 2025 04:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7B86B009B; Mon, 28 Jul 2025 04:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D606B009C; Mon, 28 Jul 2025 04:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A13726B009A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:20:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45F3D1401B5
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:20:24 +0000 (UTC)
X-FDA: 83712976368.03.326E13B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf01.hostedemail.com (Postfix) with ESMTP id D7A3240002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:20:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753690822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=vx48vio019PpR9y8NZYh5VHdGrFfq9oyzLclzsBWm7E=;
	b=EhuU76wz4/ZixjPXfEnMw0vpAOs4tNCupvLQgAGDCjIcIH3J1ZookLt46IEQ2XnNICShZk
	rk3QpFyWxSYL3aCGDX+EVv4codgt23Q9JmW+Xljxpqt+JvfEsgp+yej9jAlh51FMEDC6yD
	Vdvju/MVpTlTYLSUtX4ZNMLea64awbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753690822; a=rsa-sha256;
	cv=none;
	b=7oYrb1zrzyptpgQZumXBXzHkV23/ZdcwuniQIpS2j7mz706NoP1kjn5BHgktD85Ea8obLA
	GioNuuXfj+xwVm/72eEYF5yRS5XoXo8P9sxcKR6zmYdzjj+wbCUqtTf2ioEbAF3kh487dn
	uHB5q+sYIu/nhg9Z1SDx5pG1Jhrs+Mo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-681ff7000002311f-1a-688732c3f9fa
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
Subject: [PATCH v2 rebase as of Jul 28] mm, page_pool: introduce a new page type for page pool in page type
Date: Mon, 28 Jul 2025 17:20:08 +0900
Message-Id: <20250728082008.34091-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250728052742.81294-1-byungchul@sk.com>
References: <20250728052742.81294-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+++cnXMcrg5T6qRQMenCpDSxes0IMag/hFD0JTKokYe2vI15
	SaPLUtGSXFIZpQu2TJ2Xsma5KWq1LdOiknlhdvGySrp4KTVvs2xN+vbjfX7P8+llCMkYGcAo
	k1J5dZI8QUqJSNGIr2GjLSxPEWrWLQVdbQ0F1TMZUDFgEYKuqh7B5Ow7GhaaWxFM2J9T8N02
	jqDUMEWA7k0OCb9q5wj43OqiodoUA/3lQyQ05ZkJcF1uo6Agx01A8+woDVkWowB0dRoaOuq1
	Qrg2V0aAWTNAQ2ejjoK+mgUhDFkLSGgvriThR5GdgH5tFLTql8PUy2EE9lqzAKYu3aKg+2aj
	AK469BR8zOlH4LC5SCiav0BByXktAveMZ220cFIIJc/66CgZtg2PEfhhZa8AO1teCHBD8Qca
	601puM4ow/lOB4FNVRcpbBq/QuP3PU0UbrvhJnHDYARusEwIcEH2KIV/fn5L4rGWbmqf3yHR
	jjg+QZnOq0N2HhUpCt02QjW9P6PZwGvQp+h85MNwbDh3zzAk/M+/dTYvU+x6zumcJf6xPxvK
	GYsmPSxiCPYhzdXUOr2BHxvPafsrvQWSXctVPDB7Wcxu4TTuV4LF0dVc9f0nXt+H3cpVtP/x
	OhKP05A1TS46ZQzXOKhe5JXcU6OTLERiPVpShSTKpPREuTIhfJMiM0mZselYcqIJed6g/Mx8
	rAWNdxywIpZBUl/xl225ColQnp6SmWhFHENI/cWqMs9JHCfPPMWrk4+o0xL4FCsKZEjpCnHY
	1Mk4CXtcnsrH87yKV/9PBYxPgAbdGVqoGfk4H3m4LXl7z5t410hacJeq+va6XY8MRV1Wvw2r
	ItqD9/aqHkfpZT+T3crru/0U0THOcw7lMp+Q3kjjuRNpedldgb6J/gXP7EHdnfLTmTsrcl27
	Y3Uo6Kzp0d0InBH57TAtazlqfm2esFu0w47GNS/2Or6W1u+pMx6sF0vJFIV8s4xQp8j/Anxe
	LVYCAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTcRjG/e+cnbONJodlddIPwSAGRmZR+UYRXelP0A2EKJBaeWhLN8em
	MoNi5ciKXCszSpdNSuemZS2bl1Jkm6sl3WbWuk7tQpGpuaXp7LIWffvxPr/n+fIKCEmATBYo
	1fmcVi3PlVIiUrR5efF896ISRXqXC8DS2EBB/Q892Ppa+GBxuBBEJl7R8LvdhyDsvUvBF88o
	gsvVYwRYHhlJ+N44ScAH3wAN9c5NEKr9SMKdkmYCBk7do6DUGCWgfWKIhiMtdTyw3DTQ4Lno
	58Njl4kPZydrCGg29NHQ02ah4G3Dbz58dJeS4K+wkzBS7iUgZFoFPutMGOseROBtbObB2MmL
	FPReaONBWcBKwTtjCEHAM0BC+dQxCioPmxBEf8TWhswRPlR2vaVXzcOewWECN9lf8HCw4z4P
	t1a8obHVWYBv1qXiE8EAgZ2O4xR2jp6h8etndyh873yUxK39y3BrS5iHS4uHKPztw0sSD3f0
	UluTdopWZHO5ykJOu2DlbpHCHPUQmvFt+vZqzoDerzmBhAKWWcz+tHj4f5liZGwwOEH85SQm
	na0rj8RYJCCYJpptaAzGg+lMDmsK2eMFkpnL2m40x1nMLGEN0Qe8f6Nz2PrrnXFfyCxlbf5f
	cUcSc1qPjJNmJLKiBAdKUqoLVXJl7pI0XY6iSK3Up+3NUzlR7NO1B6dOt6BIzwY3YgRIOk38
	KeOoQsKXF+qKVG7ECghpklhTEzuJs+VFBzht3i5tQS6nc6MUASmdJd64ndstYfbJ87kcjtNw
	2v8pTyBMNqC0gWjWmS94jl6onbFuvyzTYc/yLht5nulre9pruzW23vUs5XZJvezkZ+naSmL2
	CrlR5thYd727yXzWHEhMdIRMq88llnVem5VcHN7RY0yIqisaFrV7XTeudrsKrnzN7O9Kq+oO
	75EKD9lVpq1PHo769VsuVdGadxmvtujLCkuXS0mdQr4wldDq5H8AhTp9/OUCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: D7A3240002
X-Stat-Signature: crfonxzfm7pawt9kx5p1wmngj5nuw4md
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753690821-68004
X-HE-Meta: U2FsdGVkX18SKb56eb/GwA6hbB+5z8P5zbjIJl6lxr2g/bj3vc/6KLUozcI57xmeMSjuNwQYE65YjQBkx2lWFikqeA2qoxCBZrQJ20rRIiVObVI4l/pnqqxTtvsm4nZ6RJG1pOKNL9rw7VdLqOFxuvp+DrBH0pzkP1kXwQGg9x21AF9Pzw2a/liWLva94LO+/kqSiQUWrieFJ/c2CgYvJnYbLaviP1NvJw1id7Ogn6kuX4pLj9gBTo+F9qmRED02cwQ8Kn0VSNwIsHxf8POY0nHwByXrIuSiTPT/J8TMsL782AvQrbrOJwIaF5dCW9dSQszckZk/IwFgkI31g4cWCLOcdyoTMHvol+uvVZ7FSvcOYDHMGRSxRX6UqfkShjP5+jUzGx3aiLMdE+6ZaKgEt4E49E8V5CRLdtlQXqf9bM/8hSquQhRpFFSiAAn7mMgNCPFadSF+AqgTl/LS5NcWPigU5DvB6mh5CEicA7QbErHCjjk/uxOH676lvpor9lR6HR3cKCR4p3VvFxXDAa9qpvMpLkb55H0mKC1BlF6fBwh4O0tLmFXhs3ySnOBgrgfVo9K+QlwbzeSDhjNmPdKjLd2HiW0lZI4kPvRInFi0vm9SW/9S453l9rZuluCJ4HvnHBHnlkDk0wQ+mDEp7gvhwUa9ROIm3O0JTb1ohiH0fVJxYyxLt+KJf8efEVQvikPsSxSHzwglEl76lo+VfYb5ZysJztRddDNvtCnJhiaa9T3S//T8CIIP9UGbudapEkM3D4lse2S166dzIgNTh/QazlKZc3EgiBBY7rHj0Fah36zTgL6bwWHP2OP/pSzD24txfF7xRWi4fjyk7SJby0y0QkCws98G516/ik/h2uZAHPDFT+GNtj3jv6M7sJ88oYZTH4BPkxuKez9IheRYMjaMr7EBkM8tpSv/svB4AGwnzm1jXINfEhqeQt0kFW4ww061nRcvIWhQE4LAElb/inb
 YprAEPGA
 bNC8wY2VVPw2FTfH2Kg9dO+1gtgnZkhKF86Z9jajQTp3jsQ3Tz0pV4bOweYW/qVq+eR1/3yZCW84fRULkuiwBY/SFnykiyznAYdaetIPIwsnr7kl4hbELfoQQvRhnBetGvW3Z3OPjs9AHAOurSWsvDLfNpKk/Iih6zRiev4VJ77pPPPozq2DYdmk24yQbrBxjmw8majoecyLxZTq5bTDrwMrDmggCGKIMIt1u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rebasing on the latest linux-next/master is required.  Otherwise, a
build fail is observed.  Sorry about the noise.

Changes from v1:
	1. Rebase on linux-next.
	2. Initialize net_iov->pp = NULL when allocating net_iov in
	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
	3. Use ->pp for net_iov to identify if it's pp rather than
	   always consider net_iov as pp.
	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.

---8<---
From 26c9a731f388b788d6ea972c313bc8da8831412b Mon Sep 17 00:00:00 2001
From: Byungchul Park <byungchul@sk.com>
Date: Mon, 28 Jul 2025 17:09:20 +0900
Subject: [PATCH v2 rebase as of Jul 28] mm, page_pool: introduce a new page type for page pool in page type

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
 include/net/netmem.h                          |  2 +-
 io_uring/zcrx.c                               |  1 +
 mm/page_alloc.c                               |  7 +++--
 net/core/devmem.c                             |  1 +
 net/core/netmem_priv.h                        | 23 +++++++---------
 net/core/page_pool.c                          | 10 +++++--
 9 files changed, 34 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 5d51600935a6..def274f5c1ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 				page = xdpi.page.page;
 
-				/* No need to check page_pool_page_is_pp() as we
+				/* No need to check PageNetpp() as we
 				 * know this is a page_pool page.
 				 */
 				page_pool_recycle_direct(pp_page_to_nmdesc(page)->pp,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0d4ee569aa6b..d01b296e7184 100644
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
-static inline bool page_pool_page_is_pp(const struct page *page)
-{
-	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
-}
-#else
-static inline bool page_pool_page_is_pp(const struct page *page)
-{
-	return false;
-}
-#endif
-
 #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
 #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
 #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8d3fa3a91ce4..84247e39e9e7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -933,6 +933,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_netpp		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1077,6 +1078,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
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
diff --git a/include/net/netmem.h b/include/net/netmem.h
index f7dacc9e75fd..3667334e16e7 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -298,7 +298,7 @@ static inline struct net_iov *__netmem_clear_lsb(netmem_ref netmem)
  */
 #define pp_page_to_nmdesc(p)						\
 ({									\
-	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
+	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
 	__pp_page_to_nmdesc(p);						\
 })
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..4cceb97ca26a 100644
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
index d1d037f97c5f..2f6a55fab942 100644
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

base-commit: 0b90c3b6d76ea512dc3dac8fb30215e175b0019a
-- 
2.17.1



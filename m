Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D6D4D5C0C3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF8E6B0089; Mon, 15 Dec 2025 22:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADFC6B008A; Mon, 15 Dec 2025 22:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E875F6B008C; Mon, 15 Dec 2025 22:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC35F6B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:03:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 931818AC1E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:03:35 +0000 (UTC)
X-FDA: 84223838790.15.436A175
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id A5E3F40005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:03:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765854214; a=rsa-sha256;
	cv=none;
	b=ifR56o/hbm7WsAlpyp6xnfpS6BEAnv7FBSe78IMr7GZGBGyivFlOPg/U2qMNWWJ51/eRvB
	jhcouJaEFXTGnSag2t0Mwtl59P19E/LpACmEPU3gv61t04P5Ki/ApBj4ulzfNYaI8FJu6E
	WxlsCDMYOhgjpEzF3P/5ipRujxevcSE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765854214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntRVadRMX6QYMydz25v+bMm5fhdxd9jJGz9OeHvzCCw=;
	b=eVgrWz8D3TBcQotnoinz0f/yjIPNw8c/EmYN6l62zJXrmOSb2shy9bkM3qr+Wqgsl4GaLd
	u5/j/k4/tgffVzpxPpt9eYmsy8tm7heqMcBJsZWL2PeWjmLdLGnLkIK4QOxC1VwTSRUShF
	gkDBwARUUVWrpDBz0mqhZuw5bnNO5dY=
X-AuditID: a67dfc5b-c45ff70000001609-50-6940cc005167
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
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
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [PATCH v2 1/1] mm: introduce a new page type for page pool in page type
Date: Tue, 16 Dec 2025 12:03:14 +0900
Message-Id: <20251216030314.29728-2-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251216030314.29728-1-byungchul@sk.com>
References: <20251216030314.29728-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe/eenXMcDU6r7NWoYBCRmF0weYIy6fp+EYxuUHYZecqhTpll
	KgQzjUzSzFzZZrEoy7y0mKlTty5q62JQWMqi2mqlXTQLXZaXWJsS9e3H8/z/v+fLw2NFhzSU
	V2sOilqNKlnJyhjZ16mXFk15EqNeYvUEQ7m5hoXqX5lw7a1VCiM1HyVQXtWAwDvyigOf3YFg
	qP0BC31tgwguXxrGUP40j4Ef5lEMTc0fEXwpq2Whx+HhoNoSC+6rvQzYjjdi8Jx6yEJh3hgG
	+8gAB0etlX5xnY6DZw1FUigdrcDQqHvLwfPmchZcNT4p9LYWMvDIcJ2B7/p2DO6iGHCYgmG4
	ox9Bu7lRAsMnL7DQdb5ZAvX2Lg7OdJpYeJ/nRtDZ5mFAP57PgjGnCMHYL79yoNgrBeN9FxcT
	QXOcTpa29X/D9Nb1lxLaXXaaoc7bjyW0yfCGoybLIVpXGUYLnJ2YWqpOsNQyWMLR1902lj4s
	G2No07sVtMk6JKGFuQNs3MwdspUJYrI6Q9Qujt4rS+z5bJakPdmU2eWoxTrkWFOAgngiRJLB
	SiPzl03HunGAWWEBcTpHJniGEEtuNLxABUjGY2GAI7Y7P9nAYroQR1quuFGAGWE+Kf59YUIk
	F5aT/h/38aR0Hqm+eXeCg4Qo8uqmfSKv8GfsulHpZH4aeXT+g7/L+w8sIOaLisAY+6u59UYc
	uEuEfp7YPt1Ck84Qcq/SyRQjwfBf3fCvbvivbkK4CinUmowUlTo5MiIxS6POjNiXmmJB/he7
	emR8pxUNPtvcigQeKafKqW+1WiFVZaRnpbQiwmPlDHm+M1qtkCeosrJFbeoe7aFkMb0VzeYZ
	5Sz5suHDCQrhgOqgmCSKaaL271bCB4Xq0K4j+qyj8Vv1cXuGStd6Nj5uCd4Zvty73Xss+02q
	XlrzZVOHvq9eYwzbvcG2zRpWscNo25Ib7nsd+Xl3eNeStJw5Okt878LClpy0c9XXlDQqit3/
	KSTbdfZDrrfCK3dRx5bxuovr3EmZsYrYpLme/PgeWZWmNnSVLypirms9KQlRMumJqqVhWJuu
	+gM2/5eLXgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUzMcRzHfe/7e+q47ec0/YaxnVljc7E5+xgSZr6zeX4a/nC/8aPf1LG7
	tDIPlzJEyUOTq+wMoafL9XSXTtbVEXmK2lm4lDQkRlIdy11m/Pfa5/N6vz//fDisLqLHcbIh
	TjIaxBgNo6SUK+YmTx/RGCXPMJfSkGMrZKCgPwGutTloGCjsUkBOfgWC3oFWFoZcHgTf6u4y
	8NH9FcHlS30Ych6nUPDdNojBWdWF4ENWEQOdnnYWCuzLwZf3joLqo5UY2k/dYyAtxY/BNdDD
	wmHH9UBxqZkFd24DDU8q0mk4N3gVQ6W5jYVnVTkMvC4couFdbRoFDZYbFHzJrMPgS48Cj3Us
	9D3oRlBnq1RA38lcBpovVCmg3NXMwtkmKwMdKT4ETe52CjJ/HmMgOykdgb8/UNmT0UtDdv1r
	NiqCJHm9DHF3f8ak7MYLBWnJOk0R7+37CuK0vGKJ1b6XlF6fRlK9TZjY848zxP71DEtetlQz
	5F6WnyLON3OI0/FNQdKSe5hVYzcr522XYuR4yRgRqVdGd763KfY0rk5o9hRhM/IsSkUhnMDP
	EqxHWnCQGT5c8HoHhjmUXy4UVzxHqUjJYb6HFaprfjDBxRh+lXDrig8FmeKnCBm/cqkgq3id
	0P29Hv8pnSQUlNwZ5hB+ttBa4hr21QHHZR6k//ijhYYLbwNZLnAgXLBdVAfHOBBNLs/GGUhl
	+c+y/LMs/1lWhPNRqGyIjxXlGJ3WtCs60SAnaLftjrWjwBPlHfh52oF6ny2tRTyHNKNUZGiB
	rKbFeFNibC0SOKwJVR3zRspq1XYxcZ9k3L3VuDdGMtWi8RylCVMt2yjp1fxOMU7aJUl7JOPf
	rYILGWdGzpP19cZOcYJszoAN/ohef/Ejuz7uebde725dgD6Rm+L6g84DQ5+lyM2TGg3hbdo1
	WVPD1jgsuhPLOtaNfKqbPxmSboYeGTNrx6biflSkdSz0ddSUbN3yfuVad8iOxfqr53fur1nf
	cTG9TNl1QjdRDmMOTXiY6R6flvdpiTZa3aKhTNHizGnYaBJ/AwrqE/1AAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: A5E3F40005
X-Rspamd-Server: rspam03
X-Stat-Signature: pnf6sn9rqcd58htkzm3713cwtazi9y4c
X-Rspam-User: 
X-HE-Tag: 1765854213-395741
X-HE-Meta: U2FsdGVkX18CxSwNHZD/hV//p7zGQipDSWqBs/lz7uJVqWZFec7acwpf49EuKL1UhwkhiFC13T6Nv3C8Pc+7ABP+j+GiiGMW9MI0kfNmiB3TEMPfwdHQNCxGu8aLG8zD3S+cT60jA4LPdIpx5FWIu9pfHBGWUjYn45TMyeRc6fuxtAwxQeqkoxb5dslESDyyro2pt5lAcZbiZM/YYasR1IoJwrjXhyyKe/hijqmxT4/FCm9ttm85Ci76twSJTRbtzpdn50WI5XPh3Q6H8me3LGj5fdUwsnT53id55TkbqD6m3/GHaRF9k7yv2RKFR1L2kKI4iLFWxoi4Ax9Zm3VoX9gWC9yX7yJnInbFN511Xy4Dmzy9mtA7rFM4SashN9l95+5C9A3PXHZRLd1UprNKbZvkoV/HPCACGvI1r8KgfERbeGiOBJ6aiXONMBpCLokCDkrCAWUJZ3d9cJuwI0TkTycECSa5F8Fr3hKxgseYX1IiGxnyWVZSM/7l3fvqgxJBEfRBCe7o9byCSN2SpcrvlhqjySeuE2h4Bm7+T+AA7qiqSyO76VBgLS+hwMEmdCO2D1SExFvAECbUU1zNBjpB7l36OQW7RHH891nhppKSYnAdjjxJ+WN+ON0uoIvRexDMoICzFA/jXWkbEt7VCs6ERqMSMjA9kCBjOj7ONHRCD/HOmzbiU/ShTAZYh+WXNww4I32+xiT3MPAefvz+U9yFNGg4EPtEE9JnoAal+oZ2IWciY/foYIsM8N3x+voRX+fTCZdAJLUiFJVau9QmpoGctSkPwRp8eMz73CD5jCNJy3tMkAiURsHalKV577O7GdPu5TkJox8SpMbRxDF0HNU9dmObTMzEwAovKjudnWo4rXHD4jq/xVHJrfiR90SxNX8Lhmpak2foQc+tJWFUy2iHBFnW52+/I63zTaCgOOkhZ7Z4qDXLmnnPBBkSDljaryD5E19MWXnPIzkHYyfvHI1
 R5C3W0tx
 he4eVD6FFrB6Zm6L5Q5doJ+yLA9JTE5mASXXsviw/Vta+88Fzs8gnqjMCVxKrhuh9f67sy7kCEPT2GvdXM4KQqV/RBrhJh+XTwvweT3gqw2iOj2ZKT2wgAZWhzdZQuniwL1SF6ZxG3Rx8GFQYm3L7kn+VdrXSEOQgj6PJa3+lK9qTkwe7f4ELk6xBZPdYHpPtwAfdCx+OMiwhslGs/5S7LPM6x4MqMmoVYbL5Vegr+GV3rtlFzxW7x6Zq+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
determine if a page belongs to a page pool.  However, with the planned
removal of @pp_magic, we should instead leverage the page_type in struct
page, such as PGTY_netpp, for this purpose.

Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
and __ClearPageNetpp() instead, and remove the existing APIs accessing
@pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
netmem_clear_pp_magic().

Plus, add @page_type to struct net_iov at the same offset as struct page
so as to use the page_type APIs for struct net_iov as well.  While at it,
reorder @type and @owner in struct net_iov to avoid a hole and
increasing the struct size.

This work was inspired by the following link:

  https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/

While at it, move the sanity check for page pool to on the free path.

Suggested-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          | 15 +++++++++--
 mm/page_alloc.c                               | 11 +++++---
 net/core/netmem_priv.h                        | 20 +++++---------
 net/core/page_pool.c                          | 18 +++++++++++--
 7 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 80f9fc10877ad..7d90d2485c787 100644
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
index 15076261d0c2e..94f824bf0d38c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4565,10 +4565,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
@@ -4603,26 +4602,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
index f7a0e4af0c734..39a21ee87b437 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -934,6 +934,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_netpp		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1066,6 +1067,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
 PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
 PAGE_TYPE_OPS(LargeKmalloc, large_kmalloc, large_kmalloc)
 
+/*
+ * Marks page_pool allocated pages.
+ */
+PAGE_TYPE_OPS(Netpp, netpp, netpp)
+
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
  * @page: The page to test.
diff --git a/include/net/netmem.h b/include/net/netmem.h
index 9e10f4ac50c3d..2a73b68f16b15 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -110,10 +110,21 @@ struct net_iov {
 			atomic_long_t pp_ref_count;
 		};
 	};
-	struct net_iov_area *owner;
+
+	unsigned int page_type;
 	enum net_iov_type type;
+	struct net_iov_area *owner;
 };
 
+/* Make sure 'the offset of page_type in struct page == the offset of
+ * type in struct net_iov'.
+ */
+#define NET_IOV_ASSERT_OFFSET(pg, iov)			\
+	static_assert(offsetof(struct page, pg) ==	\
+		      offsetof(struct net_iov, iov))
+NET_IOV_ASSERT_OFFSET(page_type, page_type);
+#undef NET_IOV_ASSERT_OFFSET
+
 struct net_iov_area {
 	/* Array of net_iovs for this area. */
 	struct net_iov *niovs;
@@ -256,7 +267,7 @@ static inline unsigned long netmem_pfn_trace(netmem_ref netmem)
  */
 #define pp_page_to_nmdesc(p)						\
 ({									\
-	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
+	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
 	__pp_page_to_nmdesc(p);						\
 })
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5bb3a7844abb6..c126a9790953b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1042,7 +1042,6 @@ static inline bool page_expected_state(struct page *page,
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-			page_pool_page_is_pp(page) |
 			(page->flags.f & check_flags)))
 		return false;
 
@@ -1069,8 +1068,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(page_pool_page_is_pp(page)))
-		bad_reason = "page_pool leak";
 	return bad_reason;
 }
 
@@ -1379,9 +1376,15 @@ __always_inline bool free_pages_prepare(struct page *page,
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 		folio->mapping = NULL;
 	}
-	if (unlikely(page_has_type(page)))
+	if (unlikely(page_has_type(page))) {
+		/* networking expects to clear its page type before releasing */
+		if (unlikely(PageNetpp(page))) {
+			bad_page(page, "page_pool leak");
+			return false;
+		}
 		/* Reset the page_type (which overlays _mapcount) */
 		page->page_type = UINT_MAX;
+	}
 
 	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 23175cb2bd866..6b7d90b8ebb9b 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -8,21 +8,15 @@ static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
 	return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
 }
 
-static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
-{
-	netmem_to_nmdesc(netmem)->pp_magic |= pp_magic;
-}
-
-static inline void netmem_clear_pp_magic(netmem_ref netmem)
-{
-	WARN_ON_ONCE(netmem_to_nmdesc(netmem)->pp_magic & PP_DMA_INDEX_MASK);
-
-	netmem_to_nmdesc(netmem)->pp_magic = 0;
-}
-
 static inline bool netmem_is_pp(netmem_ref netmem)
 {
-	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	return PageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
 }
 
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 265a729431bb7..323314b1333ee 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -703,7 +703,14 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	__SetPageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -718,7 +725,14 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	__ClearPageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
+
 	netmem_set_pp(netmem, NULL);
 }
 
-- 
2.17.1



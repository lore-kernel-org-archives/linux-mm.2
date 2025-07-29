Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2E3C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 11:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA45C6B008A; Tue, 29 Jul 2025 07:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79EB8E0001; Tue, 29 Jul 2025 07:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69316B0096; Tue, 29 Jul 2025 07:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7F476B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:02:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C11159807
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:02:53 +0000 (UTC)
X-FDA: 83717014626.18.2D298DB
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf30.hostedemail.com (Postfix) with ESMTP id EE11580009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:02:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753786971; a=rsa-sha256;
	cv=none;
	b=Ft8BbvLIDzV7cwKCSrwPe+a52fpop5t8SIuAO7r8d9aMLQUtFens1FvHeFQ0PqEEVCqwV2
	ZfKUO0gIPcSHEto6FbyTXP5UPGyZMrER5ndXUHNaaBhIVKuRRXIWIliT2J8SQos7kgB2g1
	KKofkJzZwkLHT4de38X5P7rodVyRZhI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753786971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=pQhS46ck9vMptFLJF2TnYd7qmGI77BwiIuQAoeYpbms=;
	b=nDm61JHzEYLDMi1ffL6b/49ykXSoANhDQ0CEgtqrAH3iCbjdvm5ckBKYaR4HdHEUXNy4SK
	UfKPT58kaGoFNewRegIvLaAOrFrXdbRxepB7xJbF6gNT2+znvSV7fTciH1vycOEK5Nn7nu
	vef8zLj2Wt0XYFnO6IlYXxM/Lr7Xz7g=
X-AuditID: a67dfc5b-681ff7000002311f-53-6888aa58c3dd
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
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au
Subject: [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type
Date: Tue, 29 Jul 2025 20:02:10 +0900
Message-Id: <20250729110210.48313-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRe0hTcRQH8H67d/del4PLkrwZGAwiMVIrpRNG2B/CjYiEMKT+0Jm3ttIp
	U6crhC2lqalJafiYtRRNp2Jt+cSJ75kmmWlMm89Qwle+Wr7CfOB/H873nO8/h8JENtyFkslj
	OIVcEi4mBLhg3rHwTJAhWeo1U+QDuqoKAsrX4uHdeB0fdIYaBKvrP0jYNnciWGm3EDDbtoyg
	6K0dA92XJBz+VG1gMNU5SUK58TqMlUzj0KitxWDyeRcB6UmbGJjXF0h4UlfKA51JTUJfTQYf
	sjaKMahVj5PwrUFHwGjFNh+mW9Nx+JRXhsNidjsGYxl+0Kk/CvaeOQTtVbU8sKcVEDCY28CD
	avMgCS/79QT8TBpD0N82iUP2VjIB+ZoMBJtrO5ULmat8yO8YJf1OsxqrlWDb5n5j7MeyIR5r
	bermsfV5IySrN8ayplJ3NtXaj7FGQwrBGpdfkKzteyPBduVs4mz9xEW2vm6Fx6YnLhDs0tQw
	HuB0W3ApjAuXKTmF5+UQgXRT4xBlCYzvMZqQGs34pyIHiqG9mUVzC37g5C0tuWuCPsVYrevY
	rp1oL6Y0e3XHAgqjP5PMq+bEvaUjdCgz3TaNdo3TJ5neavXOnKKEtA9jG4nb7zzBlL9v3rtl
	6AKKsaX8w/aDY0xLqRXPRIf16JABiWRyZYREFu7tIVXJZfEedyMjjGjn5yUJW3fq0HLfzVZE
	U0jsKJSmaKUivkQZrYpoRQyFiZ2EUcVPpSJhmET1iFNEBitiw7noVnScwsXOwnP2uDARfV8S
	wz3kuChOcZDyKAcXNVLOV7r1TJiuBv0NlLu+fnzhzazllzaEpx2Qnb/X7qM0Dy8JclUi2ZjI
	9GDRdmsubdXPyd5hG7Ljnb5xbleE/YPBgii+c8KzpkClkBrOsjT6FvcEBX2YvzHs7Bm6kl6Y
	UGR0Hij0yhypcPyaUxmiu5bgr+xu1mmUJfzeAFe+hxiPlkrOumOKaMl/uVc42+8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTcRyG/e+cnXMcDg627HShy0oSKzPQ+nXBhG7/gi6Q0cUPOevURnPa
	lssFxbylVtq6rLIWGKLpFi2m6SZOzJmXLCvDWjenhoNKltmynFJp0beH9315vrwMEdpAzmAU
	qmO8WiVTSikRKdq2OnvJHnO+PLq8bzqYrHcosPzMgNu9diGYzDUI/KNvafjtbEHwrbmVgs+u
	YQSlt0YIMD3NIeG7NUDAQEs/DRbbVvCUe0moz6sloP98GwWFOWMEOEd9NGTZKwRgqtLT4LrZ
	LoRnNUVCuBwoI6BW30vDizoTBT13fgvB21RIQvv1ShKGjM0EeIrioaUkDEY6BhE0W2sFMHLu
	JgXdxXUCuO/spuFSVwkFH3I8CLpc/SQYx/MpuJFZhGDs54TSZ/AL4cbDHjp+Mc50uynsGvxC
	4OrK1wLsbngkwI7r72lcYkvHVRWR+Iy7i8A2cwGFbcMXafzuZT2F266NkdjRtxI77N8EuDDb
	R+GvA2/IHVP3idYc5JUKLa9eGpckko9lBqe17srosFUhPfq04QwKZjg2hssfz6MnmWIXcm73
	KDHJEjaaqzD6J1jEEOxjmrvSmP13NIVN5rwuL5pkkg3nntzXT+QMI2ZjuXfvj/9zzuEs9xoJ
	A2JKUJAZSRQqbYpMoYyN0hyR61SKjKgDqSk2NPFq+cnxC3bkf7GpCbEMkoaI5QV58lChTKvR
	pTQhjiGkEnFa2Wl5qPigTHeCV6fuV6creU0TmsmQ0mniLbv5pFD2sOwYf4Tn03j1/1bABM/Q
	o/1Gnb0462Pqj4w4c1XpSevenYVJyy/NT269m7gx6GtMIMhPxCcaKh90rk1ICuz1DA3wc5+f
	DZ4HUduw8BR/Yd3VmgV9kTna9c5VljiPL/esqqCzOnd3z2igU3IUvwopfRKRsEcQ0bHZER73
	cHY7u2JRs4EN+3X00PaBWdLeLeZOKamRy5ZFEmqN7A+KYYIM0QIAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 9a8n18ofxrtj7jg3oecrax7rgb74dn1g
X-Rspam-User: 
X-Rspamd-Queue-Id: EE11580009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753786970-141864
X-HE-Meta: U2FsdGVkX1+SwuhPnlm22mfX7Z8UGbRSgqkNCcTJ8LKKN0oqaoBUU4gcxEv+Mo/RUbudIMBac7JOL+6utt2O5BCPvGWsrQt3ZAswylqGn1LWjuVKXE3C4LDdhlOmrA9Ta1fNk87Al4NpyOMsPKDpuBVdnCLjJ7y59acs86eYknu1uwWaHvItySBiIQ1HayBGB4Rfor/9KEItrjmTLbYpSwlfSoNamh3KAOsnlvvGmzAbEsnjEJs2nOhfglDojQWHKrK3z94Dyw92wG6a7TnUgEpFDeoIMfs6g6dptjGJzwpV6ktqNLXWoo6jUDmWzFi9eCBybTzIFGavjdfCon+KhLC74sl7SrySyTa9md3w/bb8au3izSRPOi32YEYQ33p2SkpLgiZzlIG7X4kjoOz8MvYtavh0uoMPjcCwUZTzXtDGQmwPs45leZoyGDW5mOGTQIZhtRqesC71EFunuzW2hqJ8gpd0jFnRacMlxe5HVUf4yTGeFzxht9xtx1Q0s1qAvn3+bRTBmola0e96bG9Rls0LwOolxxmICRF/j5Rfid65eMV8u/AlWzEJS3niA9MvcEMDYi20xozDI3gxsUVTbkhbbz3Pjm1A7xY38XQ8gTdZfU78cnqUyvdYCHhXSo0Ps9OL3PnGqAQbDAgaSQNIOi+7v+pHJRffRbZnKkSjdk6Wo+c7Uhp3CosV066dfWxMKqH1iCRICj1ZaSi6wuQDWYAlEP4C5jTiW50KQCt8tOfYHRte+cGNoy6LAobRKMeyDqiP0hqF60jWbkU8Ej4wn4pTGxcWPc0dApkUC0TxhCb0Ntn3bVOq4b9jySSVwgjcWfXbcFWhFNdKG1bV99lCEOwukyArwOwIophy0CXlrwRuV4taq1qe2CWBquG11rRehw0kQCQVhMOu93QSpghk0EOhoEM92fWfU/QMFsdOL6xlx2aDEKQSVT+bxStSWL5sqR8KRJHpQs47kxocAu5
 6HQdHKMa
 B9eDg68S6M7s73sxgwPj0e0nz1gSE5oyveh/vv5tOvAcKJe9pCmgGwkBiUSp1LQOABeJ6m4LvsSTwQHwseTOX0BsCgYKnCovyiYArhfaiQMBpdbMkU1FfOV7l9MfgiE1nX8hljifkIJXRRpW7fPl2QhZHCXnzSsjG1FzI4ELf9Q5jvnYfc2HBpZhDgYrLHISRifDceZ7qoDs5yRM+Mq031iHoYp5158IaJBdiriQX+B//0SJMIf0bWlzIGvat8oHt+OUx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes from v2:
	1. Rebase on linux-next as of Jul 29.
	2. Skip 'niov->pp = NULL' when it's allocated using __GFP_ZERO.
	3. Change trivial coding style. (feedbacked by Mina)
	4. Add Co-developed-by, Acked-by, and Reviewed-by properly.
	   Thanks to all.

Changes from v1:
	1. Rebase on linux-next.
	2. Initialize net_iov->pp = NULL when allocating net_iov in
	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
	3. Use ->pp for net_iov to identify if it's pp rather than
	   always consider net_iov as pp.
	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.

---8<---
From 88bcb9907a0cef65a9c0adf35e144f9eb67e0542 Mon Sep 17 00:00:00 2001
From: Byungchul Park <byungchul@sk.com>
Date: Tue, 29 Jul 2025 19:49:44 +0900
Subject: [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type

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
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          |  2 +-
 io_uring/zcrx.c                               |  4 +++
 mm/page_alloc.c                               |  7 +++--
 net/core/devmem.c                             |  1 +
 net/core/netmem_priv.h                        | 23 +++++++---------
 net/core/page_pool.c                          | 10 +++++--
 9 files changed, 37 insertions(+), 45 deletions(-)

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
index e5ff49f3425e..f771bb3e756d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -444,6 +444,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		area->freelist[i] = i;
 		atomic_set(&area->user_refs[i], 0);
 		niov->type = NET_IOV_IOURING;
+
+		/* niov->pp is already initialized to NULL by
+		 * kvmalloc_array(__GFP_ZERO).
+		 */
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
index 05e2e22a8f7c..37eeab76c41c 100644
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
+	/* If it's page-backed */
+	if (!netmem_is_net_iov(netmem))
+		__SetPageNetpp(__netmem_to_page(netmem));
 }
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
 	netmem_set_pp(netmem, NULL);
+
+	/* If it's page-backed */
+	if (!netmem_is_net_iov(netmem))
+		__ClearPageNetpp(__netmem_to_page(netmem));
 }
 
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,

base-commit: 54efec8782214652b331c50646013f8526570e8d
-- 
2.17.1



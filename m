Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39ADFCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B4B8E0006; Thu, 23 Oct 2025 03:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952838E0002; Thu, 23 Oct 2025 03:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868828E0006; Thu, 23 Oct 2025 03:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756A08E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:45:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F74B160A77
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:45:00 +0000 (UTC)
X-FDA: 84028592760.27.CFCEC25
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf19.hostedemail.com (Postfix) with ESMTP id 506191A0014
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:44:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761205498; a=rsa-sha256;
	cv=none;
	b=XpPlc1BQutzEyCchXb1XzbWcbIsvf7e08j/rdbsT8nPN0JwPQTEjfkCHYJPqSCY9bHp8mV
	DhPFSRn84Ba3VDb0ViQT96DQkJxewKWTNTZoqgD+Rm3mKU7bHk81m4yOLLaSrbKkRAuvjb
	N02ByE064B1XHU3FG9ZEoltfJig9Mc4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761205498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=lyaLQ+gYFf6FLMP+MiLbS2IZ4+W485nU1ADqrG7+vE4=;
	b=6zLrsuEk55BY5izA2/u6XvoodG/Hfz5V5SFYOQGX9eohstKEsQwRingP5XbUXXF0z1Hb1N
	5cUpGclY/bg+T3ku6sGML3KgKFLLZL8r8PxxD0PhbgSsh8fN5E9LI5ZBtaFvHgtB09ObYd
	NLAz0IxQLtrOQo73wRQOwzV5TVp3gb8=
X-AuditID: a67dfc5b-c2dff70000001609-d6-68f9dcf85542
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
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [RFC mm v4 2/2] mm: introduce a new page type for page pool in page type
Date: Thu, 23 Oct 2025 16:44:10 +0900
Message-Id: <20251023074410.78650-3-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251023074410.78650-1-byungchul@sk.com>
References: <20251023074410.78650-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+59zds5xuDitzNMNZZaBkV2Y8VoREgXHoJtBURE52sGNdMZm
	S4NIa1GZmlqG2YSJNE0Nc1q7oGLzXlFzXZiUrmYZaVl4GW5Wtil9+/E8z/v79NK4OEewnFaq
	Mni1SpYqIYWE8EdoxXrfB59i45VcAejr60ionc6Eqo8WAfjqvmKgr3mCYNL3noLZli4EEx3d
	JIy2jyOorPDioH+lI2Cq3o+D1fYVwUjpQxK+dHkoqDXtBbdxmIDmq2YcPDd7SMjXzeDQ4huj
	4JKlOiBuzKbA8aRAALf993EwZ3+k4LVNT8Jg3awAhu35BPSWPSDgV0kHDu6CBOgyLAXv8+8I
	OurNGHjzykl4e9eGweOWtxTcchpIGNK5ETjbPQSU/L5Gwr2cAgQz0wHlWOGkAO51DlIJsVyO
	y0Vy7d9/4lzTg36Me1daRHCu1mcYZy0boDiD6SzXWB3D5bqcOGequU5ypvFiivvwrpnkekpn
	CM76KZ6zWiYwLv/yGHkg7Jhwu5xPVWp59YYdyUJFyVPpmTuJma0vGrBs5NiWi0JolpGyb5rc
	glxEz/Hfz4eDMcmsZV0uHx7kJcxGtrpkMsBCGmdu0Oz71oa5YjFzkO3vzsOCtwSzhv38JywY
	i5g4Nsc5gs/rI9jaR21zHMJsYXv/dlJBFgc2jiI/Nb/poFlzT9I8L2OfVruIQiQyoAU1SKxU
	adNkylRprCJLpcyMPZWeZkKBxzBe+H3cgsYdh+yIoZEkVJTQPa0QC2RaTVaaHbE0Llki0h4N
	RCK5LOs8r04/qT6bymvsaAVNSMJFm73n5GImRZbBn+b5M7z6f4vRIcuzUZIxnPokpyy98pSU
	vq74RNlpfPbUosQBaflUpDHakzFUWecdLN/3Mm2nXxkxujU6ovCVTb6waV3R4+uh3pHJsF1R
	305s9tsaQjoPr99vqDrfE6FS67pL+72rI/OGe/HkRUlRawxtY1O7VxaXsca46dC+basoh1Xy
	4shFMb2njZAQGoVsUwyu1sj+AaCCXvwUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRf0yMcRzHfZ/nued5Oo5np/LIjN0Ya+uHTfaxrDW/etgYs7EYOjx1R7/c
	qXVouspwlMJZ0k2Y3HWRLv1ULd1VkpJrtWv9VAlJUWldpVxt/nvt/eufN42L+wk3Wh5+gVeE
	S0MlpJAQ7vdN8JjssMu8X15fBxm5OSQYJ2PgeU+xAOw5XzHIyC5EMG5vp2CuvAbBmKWWhB/m
	UQRPH0/gkPExkYA/uVM4lJR+RTCY9oKELzW9FBhN+6A7a4CAsmtFOPTefkdCUuI0DuX2YQri
	i/WO4fw4Csy6OgE0FSYL4N7UMxyK4nooaC7NIKErZ04AA1VJBNSlGwj4pbXg0J3sDzWZrjBR
	P4TAkluEwcQtHQktD0oxKChvoeCuNZOEvsRuBFZzLwHameskPFQnI5iedEwOp4wL4GF1F+Xv
	xaltNpIzD43g3GtDG8a1pqUSnK3iPcaVpHdSXKYpisvXu3MamxXnTNk3SM40eofiOlrLSO5d
	2jTBlXzeypUUj2FcUsIwecD1qHDbGT5UHs0rvPyChDLt282R9/fEVHzIw+JQk68G0TTLbGZn
	+w9rkBNNMhtYm82Oz7Mz483qteMOFtI4c5Nm2yvyFozlzEG2rfYWNt8lmPVs/1+XeVnE+LBq
	6+BChGXWsMZXlQvsxGxh62arqXkWOzJNqVNUChJmokXZyFkeHh0mlYf6eCrPyVTh8hjP0xFh
	JuT4Pit2JrUYjTcHVCGGRpIlIv/aSZlYII1WqsKqEEvjEmdRdKBDEp2Rqi7yioiTiqhQXlmF
	VtGEZIVo7xE+SMyESC/w53g+klf8dzHayS0ONQj9zttUszoPTdm6gN2Ww6fEjW25G080XAnu
	WBbYaF15VX9sR7z657clhp0uvtO7rN/fL2a0eW98nDWV62++PHTZYoidre/sVe0JFvQJDzbv
	f6PrHth+98naNsG+CLEuZIU5a+mj0d8XF41s7PDoUT/yT398tsAY+On4l4aUUuOxS6slhFIm
	3eSOK5TSfxAth6D3AgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 506191A0014
X-Stat-Signature: cu5b4bxiokk6ay8ws6muqmk4q8sag5jf
X-HE-Tag: 1761205498-241680
X-HE-Meta: U2FsdGVkX19PYLxAtcW0n6HX0iJA5RAx+yW2HDrHv6grS3BQKZTru3RX8cnNOZr2A1nOu+3Q5OZ5QCiOEYQGbIKZ5BHXFL3Q4khQ/dP6C8de24dsI+F0l+dRuuafFP+t5VQOyQfv2uYIVDAvy9OZ3CPtd9K7MeZAY1giiDknrBuk6dw8pFtuZC8tOOxWN84KEVYJ0l7q0ZXXPimOlhq0zdMYwCyCSs8RjhnmlDiTsxIKlscqqzIoAyUAi8vZyKvfgxZIEQrw3aFlHM1OInlhp0bRjWt2+jgLu2U3Y64r+KyrG5EE3PU2MMzTWmE/eKNGbE7Wq4iEv3IKYGdXvbphgWS2xZZoqhjj4m2rVlo3/JFTi/OAndRVNazznCLArKJL4PfO8JTzcg5by6+LRgkKSDhK8BIaoAvZ7OUcNSdPSpEYIUHh2cjIa5BqzvxnWAxNaR8uyQ42xDg+qDQwd3uIXhSZ9DPm6CuzjK6Gx9YHVzPeQNEjUm9tLzsM4SnxIggb+ZhmHr+/DzUPZ85jTm8X9zDWjNHSOPf5iDo9OiqvJU0J9VXCwvjXQkGZKQ+wQD7cmyo3mWj4qT0k2kLdRC7vceEkFaMm69QuvEpdfk24COgFFnRAru2inOD4hvCmiZcIvo5TXqYooDp4x6D/hhYJe+Dhb0C2j+lcYTpcjVtHFe9FCegUJIGGECZL62cwfcNrgsBiSSQuUsRP2ZIY4WdJWMsOXUxs7tyh5Xy8Dn4SQPhgJk/egMz2WJGL6HGj7SYUGLRfGEPa+uypJQDA0YMfLRz01KCw7h8vIN31lzaTQmU57qfvW5Vbg01fCmtYy59+Ogxv3wtd84oer6f/T2lCOK3suJq094a0eIb5PXQEpFYu/j6/ZrOD+A6VU30y8qUMP8ldWCB1Cw56rIlVTaMCbmEm7B9Jkq+9wCh/rsKyzEfO9F9ETmL6B0yYlLwMonuiEI3GFcMj/6bMMG0N6Pn
 xiM61XXK
 I6KBD4YGfwCEeV51yUIwdbeRx5K9/+iBj/9E5jAL1NN+cd++cLl4lxLpbT4FszdtEgeFgNMBRgHRcRYuK4uyC/LV12sQ6pMwC2v6Sw++egMO0PUejYYIOQ5aakx/Syqg92GdaJv8tXPBFuMRRF37AE2jDOmVBMGy2pwSXOxek7C5vgUqwn4eyZ1WdHGJI/aZ138SNQp69CU3d4I0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

->pp_magic field in struct page is current used to identify if a page
belongs to a page pool.  However, ->pp_magic will be removed and page
type bit in struct page e.i. PGTY_netpp can be used for that purpose.

Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
and __ClearPageNetpp() instead, and remove the existing APIs accessing
->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
netmem_clear_pp_magic().

This work was inspired by the following link:

[1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/

While at it, move the sanity check for page pool to on free.

Suggested-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
---
Hi Mina,

I dropped your Reviewed-by tag since there are updates on some comments
in network part.  Can I still keep your Reviewed-by?

	Byungchul
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          |  2 +-
 mm/page_alloc.c                               |  8 +++---
 net/core/netmem_priv.h                        | 17 +++---------
 net/core/page_pool.c                          | 14 +++++-----
 7 files changed, 25 insertions(+), 51 deletions(-)

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
index b6fdf3557807..f5155f1c75f5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4361,10 +4361,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
@@ -4399,26 +4398,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
index 0091ad1986bf..edf5418c91dd 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -934,6 +934,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_netpp		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1078,6 +1079,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
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
index 651e2c62d1dd..0ec4c7561081 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -260,7 +260,7 @@ static inline unsigned long netmem_pfn_trace(netmem_ref netmem)
  */
 #define pp_page_to_nmdesc(p)						\
 ({									\
-	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
+	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
 	__pp_page_to_nmdesc(p);						\
 })
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb91c566327c..c69ed3741bbc 100644
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
 
@@ -1379,9 +1376,12 @@ __always_inline bool free_pages_prepare(struct page *page,
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 		folio->mapping = NULL;
 	}
-	if (unlikely(page_has_type(page)))
+	if (unlikely(page_has_type(page))) {
+		/* networking expects to clear its page type before releasing */
+		WARN_ON_ONCE(PageNetpp(page));
 		/* Reset the page_type (which overlays _mapcount) */
 		page->page_type = UINT_MAX;
+	}
 
 	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 5561fd556bc5..664a9fe87c66 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -8,18 +8,6 @@ static inline unsigned long netmem_get_pp_magic(netmem_ref netmem)
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
 	/* net_iov may be part of a page pool.  For net_iov, ->pp in
@@ -30,7 +18,10 @@ static inline bool netmem_is_pp(netmem_ref netmem)
 	if (netmem_is_net_iov(netmem))
 		return !!netmem_to_nmdesc(netmem)->pp;
 
-	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
+	/* For system memory, page type in struct page can be used to
+	 * determine if the pages belong to a page pool.
+	 */
+	return PageNetpp(__netmem_to_page(netmem));
 }
 
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2756b78754b0..c43a0f4479d4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -700,12 +700,11 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
 
-	/* For page-backed, pp_magic is used to identify if it's pp.
-	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
-	 * and nmdesc->pp is NULL if it's not.
+	/* For system memory, page type in struct page is used to
+	 * determine if the pages belong to a page pool.
 	 */
 	if (!netmem_is_net_iov(netmem))
-		netmem_or_pp_magic(netmem, PP_SIGNATURE);
+		__SetPageNetpp(__netmem_to_page(netmem));
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -720,12 +719,11 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	/* For page-backed, pp_magic is used to identify if it's pp.
-	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
-	 * and nmdesc->pp is NULL if it's not.
+	/* For system memory, page type in struct page is used to
+	 * determine if the pages belong to a page pool.
 	 */
 	if (!netmem_is_net_iov(netmem))
-		netmem_clear_pp_magic(netmem);
+		__ClearPageNetpp(__netmem_to_page(netmem));
 
 	netmem_set_pp(netmem, NULL);
 }
-- 
2.17.1



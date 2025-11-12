Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37195CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950178E0012; Wed, 12 Nov 2025 02:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9004D8E0002; Wed, 12 Nov 2025 02:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF3B8E0012; Wed, 12 Nov 2025 02:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6233E8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:41:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A86A12CB51
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:41:32 +0000 (UTC)
X-FDA: 84101160024.08.2FBC95D
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37E3CC0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:41:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762933290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vEdxvEJF6AklM+Rjk+lMWlYzf+olEF6RTJxPn9fUSw=;
	b=yhiM8SfesQWf9OhzKXU65ERj6D8nvUTDPXoClDQcsm7prgF7jlaWEXOWJg4dRh+rPIJyTL
	CxhYI10TCA2oY06mhTDxkcsMXQq4vAdV/50SS+CGZ+3+ng3Lua/0psN6uvMce+u4iC0Fml
	2Zz1dxwwRkDMVdUpgIjnrnE/3T083aA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762933290; a=rsa-sha256;
	cv=none;
	b=p9XXjxm/++//sk5q7aFlU8+wBoKkp/4Vp7jODQrSjfl7G0/q9wCGNOPF7HYgWaNQbvbti6
	S/0h8M6ukCM5IklLrFuvGpaeW63RD/YEho5hkPXAL8Yw2x8VyFoNRmqVsRsi227TUDzu2Q
	5Zt7WuUUgJgrnfHb5x6hydtPaPEGT5o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-5a-69143a24e040
Date: Wed, 12 Nov 2025 16:41:18 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
	sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251112074118.GA31149@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-2-byungchul@sk.com>
 <20251106173320.2f8e683a@kernel.org>
 <20251107015902.GA3021@system.software.com>
 <20251106180810.6b06f71a@kernel.org>
 <20251107044708.GA54407@system.software.com>
 <20251107174129.62a3f39c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107174129.62a3f39c@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa1BMYRjH5z3n7DmnHavXFl76wKwME1IG8zCGPr7GZcwwY1wGh85otYUt
	q8xgaQdFKypqLTbXbqaZjdpSLpWED5lMOgbdL4i2qcQq0mYM337zf575/Z8Pj8hqn6umivro
	WNkYLRl0vJpTfxl3bV7gUn99iOW0L9gL8nnI+x4Ht5tdKvDkdzFgzy1CMOB5K8BIeTWC/qqn
	PHRX9iG4njXIgr3WwsHXgh8slJR2IfiUcYeHjupWAfKca6DpVicHZSeLWWg9W8NDsmWIhXJP
	jwDHXdmj4kKzAC+LrCpI+3GThWJzswCvSu08NOaPqKCzIpmDZ7YcDnrTq1hosoZBtWMSDL74
	jKCqoJiBwTOXeajPLGXgXnm9AKl1Dh7aLE0I6ipbOUgfPsXDpWNWBEPfR5U9KQMquPSkUQgL
	pscUhaeVn90svZvzhqGvM85xVHnwnKEltvcCdTgP0MLsIJqk1LHUmZvIU2ffeYG+e13G05qM
	IY6WtCyhJa5+hiYn9PDrJm5WLwuXDXqTbJy/fIc6ovjC3H1dq+MST6SxZnRxRRLyEQleSH6e
	rRH+sj03e4w5PJO03CwYYx7PIoriYb3sjwOJpTCTS0JqkcW9AslQGlXegR+OJb1u89iSBgOx
	1TYgL2txIUPaL/j+ySeQZ5ntnJdZHESUXx+ZJCSOcgC5/Uv0xj44lFz92D7WOxHPII+KnjLe
	LoIHRNJQ14L+HDqFPM5WuBSEbf9pbf9pbf+0DsTmIq0+2hQl6Q0LgyPio/Vxwbv2RjnR6Ifd
	Ojy8xYX6Xq6vQFhEunEa0uan16okU0x8VAUiIqvz1wzvxHqtJlyKPyQb9243HjDIMRUoQOR0
	kzULBg+Ga/FuKVaOlOV9svHvlBF9ppqRabHf1vmbG9a+WJa2cVH/pnOORM2T7mk9Rz5sq38Y
	mjlZezEtfXvOyYDhspaE+3Mip+wv7X0054bbJR1tbl8Vid9fS3GvDKlNjd/BJdxL/eb+kjX9
	Td/V4Lw93Xs2hEVq27aGb5I2WpeaX20Y8Z3ta73il5WzfL3ZMG/8oYOmDuoJDLmh42IipNAg
	1hgj/QYWkDtbXQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+59zds7ZanSal05mBbMIVmlB5duFEqL6E13pQ9CXXHXSg/PS
	ZqKBuMoyLU0ra85Fq8h7jGY5JxqxmTqtDMVaVGpmmiYq3sg0zRlR3348z/s875eHJRUlEj9W
	jIoVtFFqjZKWUbL9Wy6sCdjsLa6trQwGk6WEhuIf8ZDfXi6B8ZJuAkxFZQhGxj8wMF1Vg2C4
	upaG784hBA/ujZFgakymYNTykwR7RTeCXsMjGr7WdDBQbN0HbXldFFSm2EjouFZHQ3ryBAlV
	4/0MnC8vmCku1TPgvOOSwJuyDAnc/PmQBJu+nYHmChMNrSXTEuhypFPgMhZSMJhdTUJbRgjU
	mH1hrKEPQbXFRsDY1Ts0tORUEPC0qoWBG01mGr4ktyFocnZQkD15mYbccxkIJn7MVPZnjkgg
	90UrExKEz7ndNHb2DZD4SeF7Ar81ZFHY/ayewHbjJwabrWdwaYEKp7mbSGwtSqWxdeg6gz++
	raRxnWGCwvbPm7C9fJjA6Rf66YO+R2VbTwoaMU7QBm0LlYXbbq2O6d4bn3rpJqlHt7enISnL
	c+t5U1EB42GKW8F/fmiZZZpbybvd46SHvbnlfHJpDpWGZCzJDTK8wd0q8RheXCw/OKCfPZJz
	wBsb3yEPK7hSgu+8Nf+PvoB35XRSHiY5Fe+e6iHSEDvDi/n8KdYjS7l1/N2eztm/PlwA/7ys
	lshEcuN/aeN/aeO/tBmRRchbjIqLVIuaDYG6iPCEKDE+8ER0pBXNbCgvcTKrHI0073YgjkXK
	efKQFV6iQqKO0yVEOhDPkkpv+eRxTlTIT6oTzgra6GPaMxpB50CLWUq5UL7niBCq4MLUsUKE
	IMQI2r8uwUr99GhHkCrPR6i66L/pyqLszFOhxtMRYmOjPslmq0s05c9zNJ2tbnnk2EgsCZ4z
	mqS6tKOYeFMz2huQH2afGj7Ue3+qwcw9oxa4TAZXin13bjQrrZc2W745MzseE4ca8Ou5p19t
	/qX5stRyQm33mzzgtUp7uPBxV+rrXcte3t7pP/icUFK6cPU6FanVqX8DpSw1ej8DAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: 59d38f7fnhe1xnz8zwp81pptwgw73911
X-Rspam-User: 
X-Rspamd-Queue-Id: 37E3CC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762933287-255693
X-HE-Meta: U2FsdGVkX19SJI6gAx5dHehwTwsaEGZx7wtc0w0csQGAgjY62mcPiRQD/XIL7zypBhyK79OSm9OdgX8wD7TFoSrf9FsGAGC7DXBQclTGW3n+TVx5uo80fbNWID07zK/kNDNViqYLQ4tGgzAdNMF/tnLE4llTr5hCJeAvt3yxYYA/yeNyVOeglwk9d9qEZv9iFqIU7oTD5ucuW8XYSYPgbBJB7iXEFmLz3gRRZYAmqSoSoIeGLg+qW5IE/Zbr0FZeoZR1DO3hwOgDni08HVZaAoQctfBWbI/pwQ9dLd7bM7YoKA/6yKtomURo96/6NHWj4FZJyKG+0ITIOfYLFsUY4fbzaT8dCZ4KyQ2CfW/sQrH0RV0CH0lcW/IL4fkH5uvqKkWSrb8dS4ZQA7DR0wPZ2TEfBXe3jdKUUh/l2OKIAEl6mzhFyx3hF6Jh8iPgtaZtMUlE9fUBIiOgHnjtj/nsd9JzoOzSX+LCOtgtLeaDNbPnVNZ4hJwEQ4ehZ/sZVYEc7+4ywou9surLOtnPkKu5gm2e1khhwyHH+EwVdIuNp3OGgK6aKhuI2qvdCKX22/ILx1l30T1bEF4/NO8i1OpEBhMTRZZBoSW2+2xFStqsX7PS9rA0cfxMM2TJhqRYVZlOvTc3vlQUmjqGeKAqLnmtafmH4GGwf8JJ4L+krkvdGzhbninNuu4X6xHZgVKAdUmxCByID/fDFfQU1vHYqL0ue7zy2gJioIOakNF1RmqjDFDG+6xHdbTe7BHrA8kIjnoSm39YtwOMOpP5UI3fs1gPDtYJuBcR9Z9+Ky6kRa6/wYsMB6fSGvuO47mJtqF/ZTwAC2JBS8MSQon7sHuBwyGENR6WO9t07iHonSk3fYyqzA+XtHIemwLWRCMcGbvnzCpPRQu1OzDpkEKImwWo2umv95QgaBtT5Q3ByQLu9w0gMEIGRlED/0Po7ptOzRrBPiNXV/6WA1NSzEvsTXULedm
 aZcvkRgH
 xaa/8QBW0PEcvDvnrIOJpVtODgrOjjLx9x4dD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 05:41:29PM -0800, Jakub Kicinski wrote:
> On Fri, 7 Nov 2025 13:47:08 +0900 Byungchul Park wrote:
> > The offset of page_type in struct page cannot be used in struct net_iov
> > for the same purpose, since the offset in struct net_iov is for storing
> > (struct net_iov_area *)owner.
> 
> owner does not have to be at a fixed offset. Can we not move owner
> to _pp_mapping_pad ? Or reorder it with type, enum net_iov_type
> only has 2 values we can smoosh it with page_type easily.

At the beginning I tried to smoosh it with page_type but it requires the
additional logic or something to save and restore the value of enum
net_iov_type if the netmem is net_iov when updating page_type like:

  if (netmem_is_net_iov(netmem))
	type = get_type_from_niov(netmem_to_niov(netmem));

  /* Unconditionally clear the value of enum net_iov_type. */
  __{Set,Clear}PageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));

  if (netmem_is_net_iov(netmem))
	set_type_to_niov(netmem_to_niov(netmem), type);

Or page_pool_{set,clear}_pp_info() callers should handle it in a similar
way.  I'd like to check if you are okay with this approach.

Or I can make it simpler by adding page_type to struct net_iov like the
following.  Jakub, do these approachs work for you?

	Byungchul

---
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
index a3f97c551ad8..081e365caa1a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4252,10 +4252,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
@@ -4290,26 +4289,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
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
index 651e2c62d1dd..b42d75ecd411 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -114,10 +114,21 @@ struct net_iov {
 			atomic_long_t pp_ref_count;
 		};
 	};
+
+	unsigned int page_type;
 	struct net_iov_area *owner;
 	enum net_iov_type type;
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
@@ -260,7 +271,7 @@ static inline unsigned long netmem_pfn_trace(netmem_ref netmem)
  */
 #define pp_page_to_nmdesc(p)						\
 ({									\
-	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
+	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
 	__pp_page_to_nmdesc(p);						\
 })
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..01dd14123065 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1041,7 +1041,6 @@ static inline bool page_expected_state(struct page *page,
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-			page_pool_page_is_pp(page) |
 			(page->flags.f & check_flags)))
 		return false;
 
@@ -1068,8 +1067,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(page_pool_page_is_pp(page)))
-		bad_reason = "page_pool leak";
 	return bad_reason;
 }
 
@@ -1378,9 +1375,12 @@ __always_inline bool free_pages_prepare(struct page *page,
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
index 23175cb2bd86..6b7d90b8ebb9 100644
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
index 1a5edec485f1..27650ca789d1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -699,7 +699,14 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
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
@@ -714,7 +721,14 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 
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
 


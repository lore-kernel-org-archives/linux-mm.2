Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A903AD6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C36B6B008A; Thu,  2 Apr 2026 14:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A846B008C; Thu,  2 Apr 2026 14:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0936B0092; Thu,  2 Apr 2026 14:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF90B6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:13:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AFF71A08A0
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:13:58 +0000 (UTC)
X-FDA: 84614414556.28.419C4E8
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf07.hostedemail.com (Postfix) with ESMTP id 994B540004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:13:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VN/xKWhW";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775153636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Ia1sFEyXeZdxVFbuj/aPmaW6OhiGG63EnIUFcXLkNs=;
	b=65ehRzWxqRoxa3TkJubEVPuZ2sdtdkdFVwPAbN+c6/U8uy/JbQCnE1QWxerQqZPmerxQ7p
	ard4aC0HZKDhKPxSXMYUVTLHu1IJj70tJzBnMZzXDVjrEy99fhn/4GMUrsVP4hqt09to8n
	OfDYhn0FuqH9zJkDEueat9whdtmjmjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775153636; a=rsa-sha256;
	cv=none;
	b=niYORHzcYuhrgJukVsvhtn4LaUZ0tlpP/+9bTm/E2yYMpcHHolxv78btQhDGLah7B6R+CO
	MLnpx772ohZ+Ow1BOZbTeR6izdOReyw4m20NY2tSw9OrsHpL82I7XZ0zl6aGEexTT8q0RJ
	PcIOztOIKtqrfPxNHmC+IgbU/2/X5zI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VN/xKWhW";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775153634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Ia1sFEyXeZdxVFbuj/aPmaW6OhiGG63EnIUFcXLkNs=;
	b=VN/xKWhW4T1d6MRH4BQZ9XDkgsNICk0RkaHsoJ4/SHiiK6qO9J3HbBdh0Xc3S36J4CQqal
	RNBEpGOL3dXoJiLQg6UnaZ0fD5w075XAel8y95zYT8oejYfkDczwhXCdeDMmGteExVe2+F
	eGQvFOpEYfTV9f4BOZfgHiHqflW+bdU=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	leitao@debian.org, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 2/4] mm: use tiered folio allocation for VM_EXEC readahead
Date: Thu,  2 Apr 2026 11:08:23 -0700
Message-ID: <20260402181326.3107102-3-usama.arif@linux.dev>
In-Reply-To: <20260402181326.3107102-1-usama.arif@linux.dev>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 994B540004
X-Stat-Signature: nu9dfsh4gi16fcfs4tfqa1e6ygf3nd66
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775153636-58640
X-HE-Meta: U2FsdGVkX18neHYXVTxJWVn4b5iD63w7SPPH5vC3Xlg9yXfCBFMu1SGoF3Jr8D4W1RbPb18QneOFKEZnnxBEsTUJR8NtILXi44SlHE/qwoHRmZv5ZRZI8zM+dkQxBAc0fcjEtU+lmBe84x5Gt9l6fB23zCs1x278qaIc/lj5URM4vd8zBKX36KOiRoRPBAQZm2WHXZs2KmdLsO1adgbduXrXaaHlR7nRXaxY6ZkYzt3j69Fcu5IHM0ZjLwOc2KoXaijSev1eQ8PZRK0l9mTj5USnfJqXL4FvS57Auf9S7GPpR/YgLR0MdAzdij/pAjQp15NAebBW/Hn/19SEHXymAOcCSngXMX9veCItMMNO1nq1GwS15lxpI1HCwmsK8WlDjOaJQyw5a4x4v9FUzd/8qm6VSqzufCd1jR7JXNdGkLf8PJWs4RqdT9cCYdsl26KfIz3iYP1An9FhatrxbPzYvcliE0Ibe7+hjKmb7teiSVSscPp1ez/cdBvVQ/BJVEZc/OUeDbZnSL6OChdiDa8Oqohpuxc1zrKuNORXH/Zito9fZK/TOmCzTq2WM29PNHT/1jzrgaIwGywB2BRpSUkMM1J+052d2oZnAYHhN4koLXFrhLk1uTqHUYK0pmvXkHW6IKNVVzYz8WUk9uSW9CL5sm1E8svVrxx5jyz9dbZ9xJLTyXEGlGwPwMn6iElh/306+eTIJLE13XYLbrVp+Ncqbih7uls5s9Be0RQrJVl3izGH/CY+Qdu2IFfjlp+0weFg70PjqbEiIcLoCv9R+0nqTXyv/qc7nOZoXRqry42DdE5M5OxYokh1q9NkHHvZC5hqVX6NaK1NVFCLbaXEvg7VItAoiD8FIppoy2McDy4jLItDYnUOJJQNS0TzkMb3UBw/msm0yTjYd95SkAT17Fs3+CSk1bVMghXUc79H82xi3jGLdoHShy/ADJ8Oiv7mBjPLYRtR4EY/QPqmd7E0goH
 tbV1rSxs
 J76XKkahTqEFKzaKVfJMS8hmTgl1FnQbV7Xfm8mYiAppY0QXntfXfvfYgxMcCko2vgt7exIrIHCzBLEg5itCqeAXYhXa9JTQJ1bvM39JCAy9E48wBa5sKhi/+OSq6uD/GODQk9SRKdojpzTdIPv4KcWt9s0uhgzajCFrX8tqokTuCCnkRkaODRKF8kW04AChAUREbAeBkBGPScGH7HC/LKSKniW2zat2V8MxV6evI7/Is9+nJ/1gw7OTtQuajEz0cYvmdTK5BlYxqGcd/tauZZXNTww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When executable pages are faulted via do_sync_mmap_readahead(), request
a folio order that enables the best hardware TLB coalescing available:

- If the VMA is large enough to contain a full PMD, request
  HPAGE_PMD_ORDER so the folio can be PMD-mapped. This benefits
  architectures where PMD_SIZE is reasonable (e.g. 2M on x86-64
  and arm64 with 4K pages). VM_EXEC VMAs are very unlikely to be
  large enough for 512M pages on ARM to take into affect.

- Otherwise, fall back to exec_folio_order(), which returns the
  minimum order for hardware PTE coalescing for arm64:
  - arm64 4K:  order 4 (64K) for contpte (16 PTEs → 1 iTLB entry)
  - arm64 16K: order 2 (64K) for HPA (4 pages → 1 TLB entry)
  - arm64 64K: order 5 (2M) for contpte (32 PTEs → 1 iTLB entry)
  - generic:   order 0 (no coalescing)

Update the arm64 exec_folio_order() to return ilog2(SZ_2M >>
PAGE_SHIFT) on 64K page configurations, where the previous SZ_64K
value collapsed to order 0 (a single page) and provided no coalescing
benefit.

Use ~__GFP_RECLAIM so the allocation is opportunistic: if a large
folio is readily available, use it, otherwise fall back to smaller
folios without stalling on reclaim or compaction. The existing fallback
in page_cache_ra_order() handles this naturally.

The readahead window is already clamped to the VMA boundaries, so
ra->size naturally caps the folio order via ilog2(ra->size) in
page_cache_ra_order().

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h | 16 +++++++++----
 mm/filemap.c                     | 40 +++++++++++++++++++++++---------
 mm/internal.h                    |  3 ++-
 mm/readahead.c                   |  7 +++---
 4 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 52bafe79c10a..9ce9f73a6f35 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1591,12 +1591,18 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 #define arch_wants_old_prefaulted_pte	cpu_has_hw_af
 
 /*
- * Request exec memory is read into pagecache in at least 64K folios. This size
- * can be contpte-mapped when 4K base pages are in use (16 pages into 1 iTLB
- * entry), and HPA can coalesce it (4 pages into 1 TLB entry) when 16K base
- * pages are in use.
+ * Request exec memory is read into pagecache in folios large enough for
+ * hardware TLB coalescing. On 4K and 16K page configs this is 64K, which
+ * enables contpte mapping (16 × 4K) and HPA coalescing (4 × 16K). On
+ * 64K page configs, contpte requires 2M (32 × 64K).
  */
-#define exec_folio_order() ilog2(SZ_64K >> PAGE_SHIFT)
+#define exec_folio_order exec_folio_order
+static inline unsigned int exec_folio_order(void)
+{
+	if (PAGE_SIZE == SZ_64K)
+		return ilog2(SZ_2M >> PAGE_SHIFT);
+	return ilog2(SZ_64K >> PAGE_SHIFT);
+}
 
 static inline bool pud_sect_supported(void)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index a4ea869b2ca1..7ffea986b3b4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3311,6 +3311,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	gfp_t gfp = readahead_gfp_mask(mapping);
 	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
@@ -3363,28 +3364,45 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 			ra->size *= 2;
 		ra->async_size = HPAGE_PMD_NR;
 		ra->order = HPAGE_PMD_ORDER;
-		page_cache_ra_order(&ractl, ra);
+		page_cache_ra_order(&ractl, ra, gfp);
 		return fpin;
 	}
 
 	if (vm_flags & VM_EXEC) {
 		/*
-		 * Allow arch to request a preferred minimum folio order for
-		 * executable memory. This can often be beneficial to
-		 * performance if (e.g.) arm64 can contpte-map the folio.
-		 * Executable memory rarely benefits from readahead, due to its
-		 * random access nature, so set async_size to 0.
+		 * Request large folios for executable memory to enable
+		 * hardware PTE coalescing and PMD mappings:
 		 *
-		 * Limit to the boundaries of the VMA to avoid reading in any
-		 * pad that might exist between sections, which would be a waste
-		 * of memory.
+		 *  - If the VMA is large enough for a PMD, request
+		 *    HPAGE_PMD_ORDER so the folio can be PMD-mapped.
+		 *  - Otherwise, use exec_folio_order() which returns
+		 *    the minimum order for hardware TLB coalescing
+		 *    (e.g. arm64 contpte/HPA).
+		 *
+		 * Use ~__GFP_RECLAIM so large folio allocation is
+		 * opportunistic — if memory isn't readily available,
+		 * fall back to smaller folios rather than stalling on
+		 * reclaim or compaction.
+		 *
+		 * Executable memory rarely benefits from speculative
+		 * readahead due to its random access nature, so set
+		 * async_size to 0.
+		 *
+		 * Limit to the boundaries of the VMA to avoid reading
+		 * in any pad that might exist between sections, which
+		 * would be a waste of memory.
 		 */
+		gfp &= ~__GFP_RECLAIM;
 		struct vm_area_struct *vma = vmf->vma;
 		unsigned long start = vma->vm_pgoff;
 		unsigned long end = start + vma_pages(vma);
 		unsigned long ra_end;
 
-		ra->order = exec_folio_order();
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    vma_pages(vma) >= HPAGE_PMD_NR)
+			ra->order = HPAGE_PMD_ORDER;
+		else
+			ra->order = exec_folio_order();
 		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
 		ra->start = max(ra->start, start);
 		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
@@ -3403,7 +3421,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	ractl._index = ra->start;
-	page_cache_ra_order(&ractl, ra);
+	page_cache_ra_order(&ractl, ra, gfp);
 	return fpin;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 475bd281a10d..e624cb619057 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -545,7 +545,8 @@ int zap_vma_for_reaping(struct vm_area_struct *vma);
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp);
 
-void page_cache_ra_order(struct readahead_control *, struct file_ra_state *);
+void page_cache_ra_order(struct readahead_control *, struct file_ra_state *,
+			 gfp_t gfp);
 void force_page_cache_ra(struct readahead_control *, unsigned long nr);
 static inline void force_page_cache_readahead(struct address_space *mapping,
 		struct file *file, pgoff_t index, unsigned long nr_to_read)
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..b3dc08cf180c 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -465,7 +465,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 }
 
 void page_cache_ra_order(struct readahead_control *ractl,
-		struct file_ra_state *ra)
+		struct file_ra_state *ra, gfp_t gfp)
 {
 	struct address_space *mapping = ractl->mapping;
 	pgoff_t start = readahead_index(ractl);
@@ -475,7 +475,6 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
 	int err = 0;
-	gfp_t gfp = readahead_gfp_mask(mapping);
 	unsigned int new_order = ra->order;
 
 	trace_page_cache_ra_order(mapping->host, start, ra);
@@ -626,7 +625,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 readit:
 	ra->order = 0;
 	ractl->_index = ra->start;
-	page_cache_ra_order(ractl, ra);
+	page_cache_ra_order(ractl, ra, readahead_gfp_mask(ractl->mapping));
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_ra);
 
@@ -697,7 +696,7 @@ void page_cache_async_ra(struct readahead_control *ractl,
 		ra->size -= end - aligned_end;
 	ra->async_size = ra->size;
 	ractl->_index = ra->start;
-	page_cache_ra_order(ractl, ra);
+	page_cache_ra_order(ractl, ra, readahead_gfp_mask(ractl->mapping));
 }
 EXPORT_SYMBOL_GPL(page_cache_async_ra);
 
-- 
2.52.0



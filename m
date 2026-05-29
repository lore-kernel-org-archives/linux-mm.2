Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CF6CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40886B009F; Fri, 29 May 2026 08:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30966B00A2; Fri, 29 May 2026 08:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E5A6B00A1; Fri, 29 May 2026 08:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65A096B009F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1A484134C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:46 +0000 (UTC)
X-FDA: 84820363572.03.A1C9178
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D8C2A0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=h+Xilcb+;
	spf=pass (imf15.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9pDd68+wLvH4AeGJEXTLZCNqdsKkVQuDmz0y/Qyl40=;
	b=6d1uJCbr5cXjgZtk7hvUzc1P0cAHTc//oJmZXSInFK/RzjZHyKp/Yjj/YIl9M27vzAT15k
	5XBG7vLBlg9J2IlE8i/pLbKhHyTneJw3sDG2zUwZijc0yMh2EC34EvO9W9ZrTWAVCJlJbr
	OdKhBulNKbdk9aRmYGlv9/EqJBD+uSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057185; a=rsa-sha256;
	cv=none;
	b=pQbnc/h+JEwGEgen0ENWpZEk1ZLdA2yvPaX8BQ9tr9QduCEJVu5CyHyyHahOfFhlwBW7ay
	MASwDwRgaoCrRRjU7NMrvaB47ywZV+jpFo3z3Sl83YhZGFPSKOxtSabxECKwVXFArun1t8
	wvrJ/KGAIHt5XamUKPymV667AdMYxZw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=h+Xilcb+;
	spf=pass (imf15.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057179; bh=e9pDd68+wLvH4AeGJEXTLZCNqdsKkVQuDmz0y/Qyl40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+Xilcb+Fe2a+TdyND9eRmzpcWn65K1nBdf+U1Tcpxrle9mkaWuaGs92Dj7+4Gyqu
	 E5kqBNXOpgr4kNi7T3fhli4vTM6GVQ2gt42yEsJ1O+AzgjDPfPS6p4L/Zf9KtjNZMy
	 Bx2TH95F4j3um3bRRG5JuxuisRPgCw5F6ZQVWuXw=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057176tr24p40mn
Message-ID: <tencent_69E7033C2446FE6E922D28B82E9F59142D09@qq.com>
X-QQ-XMAILINFO: NcJw5CIirWgGxMPMMf2Xe4hBEBXn4hAHfolRSxm6+zPzISbV8Hly/4GctJa4j0
	 /Zwax7rBPKgCvjRhIpWIEMfK/hLRiJNnJv5iYpCP8i5S5K3nMVpulonB9o0ul+xA9hcQ0mx+X+85
	 2NJdkYsR/B9ahT5scviN33mGJYnW4QltRFCRA/lTjDQyeTozqDPEHYSzmODT52L4xGBHcR4WnJaF
	 NhiOv+sE1NQE9qdszpvr0iVpMg8Pg4hGvHwTZAYU/iWhgHiNF55eMcX50UFh1lRdS/1nkur5lydG
	 FLVGBLwrVzv+ga0RF6bxF7z4ZioHDKh0OD31pp0hlwJyixBEswr0ReNnl/sQqaY5YJqwyMEfdekZ
	 BxIHOMNKyY9mOQOAFul5mbS43GsrLLEZHPI3LG3oHH9JFzJCLc7NBbvGNyw2ymKgu5pYqJcFhPYg
	 kqyDna8DHjyvVjont2VGFEVUjYSRU2XMZZWUA9y+4pG8beI1CPfssyimdEl6HmNaMfyxfF9t/3Yc
	 tEF5zoBXdSUa77Ch8bC1GoOt1OsGGkoANEY+PUbZ2Euob8C4ZQXrFYl8TfFBPIw6vFsbr0zBx+bg
	 kLjBaUboDP11xAE1vE1nGBGjt9PGzGtCxUfbzmwXXnXOrhjRPzBOCj4gsNWALJu4p7eL21EPDvmQ
	 yfjvioRg6edGBBhgP+AUxlOWr30REOTMsq1ImSZqKgUENMxZdrua4namZUD2CBC0ig8kQu7LKTnG
	 GgNKS3nkTVMEYshUKswxb8TGE/0LPku+SBz63hq8MjjbqqDvDG62UnFwV9QAYSYmgo/iK7qkwQyv
	 Kpug2b7ABBs7Ngszgk0QwvkTIIEMLxv3f+VgAERJ2tQLbyc6++FXndclzN1PUsN64zhsQvfNabqE
	 Y+vXnSkAEg914R0pjjmh1S0keSAE5pBD+4U2HAZ4NDfZSLV9QsnaOzuy0CYJj0fEDjpSVjTRUFRC
	 NuZ8cFSN+FpmpCHw9H+z+PS6RIuqlUi3KihEhPHgtzjuv+AgbUeKiC4tZfg6FUWgmuP4QpqeST3T
	 uVTGS3pWJ1c3t/Vd5ezCpKIta1kwPhccBSJQYQaFnXzjMy7UEUUwf1rvHM7Ih/TUBiGqSBww==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 5/9] mm: add common locality admission for zswap large swapin
Date: Fri, 29 May 2026 12:19:24 +0000
X-OQ-MSGID: <20260529121928.4115683-5-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: n1o3qzartn5r4pyd96s6b9oezoi66176
X-Rspamd-Queue-Id: 7D8C2A0007
X-Rspam-User: 
X-HE-Tag: 1780057184-827950
X-HE-Meta: U2FsdGVkX185Kg+ZTzaocHjsYLv5rcbcSua2T2Hp3f+mWalUiTAOBs65Z+0BysZkpgrMWhZP+nQDhi4UgnNKmM9fxR8XFNyp2nSWitYM4/GyfROeR1vTxjALj03XDQ5kcrR1W14+Bc3cp62MMzMiIgLsx2AKRnr1epQAPtFe7HRlzAT49wQlE2Lb+e9wvOuUHB/Coq8bwOamqFQ6lRCSFsfPZ0M4qYhxBH3W7A8rQ+SxiyrmyTm8nFpLATbxeZFRYb6QgL/yTCQMtH3ylCTs1usPXOaq02gLFwi/5q+JnNRWgIY7RvCcZKrkt2CdQK6lDJOJjnw49vW95oD9LfCyTsxh1ibgSRt0Sd/mvISoDjD9Aaf+dfHr+dIEkuJgAVjp39V9wgEoU5xoG7vGqYJaDwCU8ojofFQ8YOdzu7fD0l2xehXRONPxGZWbPxkkenjwqZ9k2wslcuHZQbBOl4YQC2qV1FtXLrgm5PJKz+lcPiqZ1MZc9TK2DIJg7XXdXrtAfJ0ZKqKt6aiHz0jYCc2t9z0w7/fQ7BK1+pAvbaaaPxvnEQTZR/S7MWrH+RfGJSZA558j55Uh0ZSH5fZnjhao7YhLVQNg6yFr1m7bQ2yRBylLyZxIBtFuJtyP+6u1s+DNvfFhkip1JfKvph430KRdWs3i1If2ykJ+VNyiYHc2NzRIl+Lk2zEMFeXtgzby60ar2ITL1UANv9YTI4giucJvQ5qM8sMwmWNj7b6yrnqIsQtZ+f9eFqwsZbQo71gw36gr8WmQsvtpCAF/4CdtIuEeyVOvHZZLr5qwWq0zCxdVhlGYmxCXA6H7RKv8mux/Mhav4yFy8lcPYO+ndTp4IS9I9oz24SdLl6YkKRMTpw1bZKf77ZHBgIWSLkoozfzQc6UZBYWQ+yaG7C3OA3iCOiZCHWuLGl5jV6kB/ZPKm9z2BGgcFHeYsI8/YunDZkk2wYqYZaUwZBBBh5v1xTN2mq1
 Y4BiYLsL
 +qtppTpah61sXBslyUNviA29UKxPCDjfzOGgE6VCBKD3nwZk4TFHkdsYiIt8OXkdoORjOtogUvW9IBpiXPvcJlgqv4vRcYmuRdA4MzV2mTFA11nJcSKgcC0QXMalyFL225sER0e67enziUh4tqy7e5+RqHBuHhww4+ff2hTp//ONVAYiMRkW/kodgK+EMPCl3zDMa+sztk983zVmzwqs+aRYJHvBcs4b+Yjb/gkT7Tj9UZ4DQtlZPdpKJUP+9Ef+S2V/m5uS2lIDXekAa9fnUfPvXQYK7x8qaJI6IBVyF3a8hy1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fully zswap-backed ranges are safe to load as a large folio only when
the caller has a reason to expect the neighbouring slots to be useful.
Otherwise a sparse refault can turn one 4K demand fault into a 64K
decompression and swapcache fill.

Add a common admission gate for zswap-backed large swapin. The common
layer keeps backend checks, the 64K cap, recent-refault rejection, and
zswap reclaim-pressure rejection. It consumes a caller-provided locality
order mask instead of looking at anon or shmem state directly.

Callers pass no locality evidence for now, so this patch only installs
the common policy hook. Later patches add anon and shmem producers.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/memory.c     |   2 +-
 mm/shmem.c      |   2 +-
 mm/swap.h       |   8 ++--
 mm/swap_state.c | 118 ++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 117 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d73a19692dea..92a82008d583 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4849,7 +4849,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
-					    vmf, NULL, 0);
+					    0, vmf, NULL, 0);
 		else
 			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 56c23a7b15c7..fa99b48ed62b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2031,7 +2031,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 
 again:
 	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
-	folio = swapin_sync(entry, gfp, BIT(order), vmf, mpol, ilx);
+	folio = swapin_sync(entry, gfp, BIT(order), 0, vmf, mpol, ilx);
 	mpol_cond_put(mpol);
 
 	if (!IS_ERR(folio))
diff --git a/mm/swap.h b/mm/swap.h
index ea7e1f3c4410..dd35a310d06d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -323,9 +323,10 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
-		struct vm_fault *vmf);
+			struct vm_fault *vmf);
 struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
-			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx);
+			  unsigned long locality_orders, struct vm_fault *vmf,
+			  struct mempolicy *mpol, pgoff_t ilx);
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
@@ -418,7 +419,8 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 
 static inline struct folio *swapin_sync(
 	swp_entry_t entry, gfp_t flag, unsigned long orders,
-	struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
+	unsigned long locality_orders, struct vm_fault *vmf,
+	struct mempolicy *mpol, pgoff_t ilx)
 {
 	return NULL;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f03ad4832f16..5a4ca289009a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -21,6 +21,7 @@
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
+#include <linux/sizes.h>
 #include <linux/zswap.h>
 #include <linux/shmem_fs.h>
 #include "internal.h"
@@ -556,6 +557,24 @@ static struct folio *swap_cache_alloc_speculative_folio(swp_entry_t targ_entry,
 					mpol, ilx, true);
 }
 
+/*
+ * Initial conservative cap for speculative zswap large swapin. Locality
+ * evidence is supplied by the caller or by generic VMA hints; the common
+ * swapin layer keeps backend safety and pressure decisions here.
+ */
+#define SWAPIN_ZSWAP_MAX_SIZE			SZ_64K
+#if PAGE_SIZE < SWAPIN_ZSWAP_MAX_SIZE
+#define SWAPIN_ZSWAP_MAX_ORDER			\
+	ilog2(SWAPIN_ZSWAP_MAX_SIZE / PAGE_SIZE)
+#else
+#define SWAPIN_ZSWAP_MAX_ORDER			0
+#endif
+
+struct zswap_admit_ctx {
+	bool pressure_checked;
+	bool reclaim_pressure;
+};
+
 static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages)
 {
 	unsigned int ci_start = swp_cluster_offset(entry);
@@ -586,11 +605,84 @@ static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages)
 	return true;
 }
 
+static bool swapin_zswap_locality(struct vm_fault *vmf, unsigned int order,
+				  unsigned long locality_orders)
+{
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+
+	if (!order || order > MAX_PAGE_ORDER)
+		return false;
+
+	if (vma && (vma->vm_flags & VM_RAND_READ))
+		return false;
+
+	return locality_orders & BIT(order);
+}
+
+static bool swapin_zswap_refaulted(swp_entry_t entry, unsigned int nr_pages)
+{
+	unsigned int type = swp_type(entry);
+	pgoff_t offset = swp_offset(entry);
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		bool workingset;
+		void *shadow;
+
+		shadow = swap_cache_get_shadow(swp_entry(type, offset + i));
+		if (!shadow)
+			continue;
+		if (workingset_test_recent(shadow, false, &workingset, false) &&
+		    workingset)
+			return true;
+	}
+
+	return false;
+}
+
+static bool swapin_zswap_admit(swp_entry_t entry,
+			       unsigned int order, unsigned int nr_pages,
+			       struct vm_fault *vmf,
+			       unsigned long locality_orders,
+			       struct zswap_admit_ctx *ctx)
+{
+	if (order > SWAPIN_ZSWAP_MAX_ORDER)
+		return false;
+
+	/*
+	 * Treat zswap-backed large swapin as speculative. The common layer
+	 * consumes caller-provided locality orders, but does not inspect
+	 * anon-specific PTE state or shmem-specific mapping state directly.
+	 */
+	if (!swapin_zswap_locality(vmf, order, locality_orders))
+		return false;
+
+	/*
+	 * A recent workingset refault shadow in the target range means reclaim
+	 * already saw churn there. Keep the refault path narrow instead of
+	 * speculatively decompressing neighbouring slots.
+	 */
+	if (swapin_zswap_refaulted(entry, nr_pages))
+		return false;
+
+	if (!ctx->pressure_checked) {
+		ctx->reclaim_pressure = zswap_pool_reclaim_pressure();
+		ctx->pressure_checked = true;
+	}
+	if (ctx->reclaim_pressure)
+		return false;
+
+	return true;
+}
+
 static unsigned long swapin_admit_orders(swp_entry_t entry,
-					 unsigned long orders)
+					 unsigned long orders,
+					 struct vm_fault *vmf,
+					 unsigned long locality_orders)
 {
 	unsigned long candidates = orders & ~BIT(0);
 	unsigned long admitted = orders & BIT(0);
+	struct zswap_admit_ctx zswap_ctx = {};
 	int order;
 
 	if (!candidates)
@@ -616,9 +708,14 @@ static unsigned long swapin_admit_orders(swp_entry_t entry,
 
 		state = zswap_probe_range(range_entry, nr_pages);
 		switch (state) {
+		case ZSWAP_RANGE_ALL_ZSWAP:
+			admit = swapin_zswap_admit(range_entry, order,
+						   nr_pages, vmf,
+						   locality_orders,
+						   &zswap_ctx);
+			break;
 		case ZSWAP_RANGE_MIXED:
 			break;
-		case ZSWAP_RANGE_ALL_ZSWAP:
 		case ZSWAP_RANGE_NEVER_ENABLED:
 		case ZSWAP_RANGE_NO_ZSWAP:
 			admit = true;
@@ -769,8 +866,8 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 	ret = swap_read_folio(folio, plug);
 	/*
 	 * Swap readahead allocates order-0 folios. -EAGAIN is reserved for
-	 * retryable large zswap backend races and must be handled by the
-	 * synchronous common swapin path.
+	 * retryable large zswap backend races and should never escape to this
+	 * order-0 path.
 	 */
 	VM_WARN_ON_ONCE(ret == -EAGAIN);
 	if (readahead) {
@@ -786,6 +883,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
  * @entry: swap entry indicating the target slot
  * @gfp: memory allocation flags
  * @orders: allocation orders
+ * @locality_orders: orders with caller-provided locality evidence
  * @vmf: fault information
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
@@ -794,16 +892,20 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
  * existing folio in the swap cache for @entry. This initiates the IO, too,
  * if needed. @entry is rounded down if @orders allow large allocation.
  *
- * Context: Caller must ensure @entry is valid and pin the swap device with refcount.
+ * Context: Caller must ensure @entry is valid and pin the swap device with
+ * refcount.
  * Return: Returns the folio on success, error code if failed.
  */
-struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
-			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
+struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp,
+			  unsigned long orders,
+			  unsigned long locality_orders,
+			  struct vm_fault *vmf, struct mempolicy *mpol,
+			  pgoff_t ilx)
 {
 	struct folio *folio;
 	int ret;
 
-	orders = swapin_admit_orders(entry, orders);
+	orders = swapin_admit_orders(entry, orders, vmf, locality_orders);
 again:
 	do {
 		folio = swap_cache_get_folio(entry);
-- 
2.34.1



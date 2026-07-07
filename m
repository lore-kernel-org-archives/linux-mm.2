Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4963FC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B72F6B00B8; Tue,  7 Jul 2026 03:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3680B6B00B9; Tue,  7 Jul 2026 03:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231446B00BA; Tue,  7 Jul 2026 03:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE3CB6B00B8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:33:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 850888D455
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:22 +0000 (UTC)
X-FDA: 84961165044.04.DBBB5E4
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id E8A87120005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mMueRABV;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409601;
	b=XfWYWaCGSyreS/xqMr2o8O8AjJLkkUvoTse8SAdNI5L16Wb9xaJNYI9+TAizpRuKumLS1B
	wV8EFDzQ5xm3sOhV/dk86vz91omQJh05o8+lioNDoTZm2JjO7jq55zsNHYoUFz09dmrJyD
	5SjSGM9wJ5y7gHMo73Z4LZ/U6GWoqY8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mMueRABV;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yh6zGJfbd35MyAYRN2MelR3OTuUTkPH69DCSpZ2wP6M=;
	b=Hu24eqoycuiMFbdN8cES06iyoFJXdSaEekrqWraUyLAwOJOM9lhfjaFe/QgJOlHbvyqoIg
	M4KguWFYEPQY5LVMMc6OcyiLLI5uzXCdD0TJM0ANBHEX5VyR7IPu6POTXJwr9rG9g0RlVX
	BuTTR2hCAsAlnrqwkdO2DnVEdTBDncw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yh6zGJfbd35MyAYRN2MelR3OTuUTkPH69DCSpZ2wP6M=;
	b=mMueRABVmHdn7VcElUnEDAcYm0NRysqPEOahvsd5x0yRw7EoKJILX/QeALTEPFOvGe2N4G
	vbUrXA8wyEEXuewdliFtslRd/ARNK3FnZajUFygPl3Mh0uyp3iuIovLR19e0Jo/ZX+PyTk
	QNUsamfupct0izLjxFxhgqffEZsr6gk=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 3/7] mm/swap_state: do zswap conversion in __swap_cache_do_del_folio
Date: Tue,  7 Jul 2026 15:32:00 +0800
Message-ID: <20260707073215.72183-4-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8A87120005
X-Stat-Signature: zjk8hcroe44qeqtppttamfq4es7sffsw
X-HE-Tag: 1783409600-515885
X-HE-Meta: U2FsdGVkX18hORfZPeuq6AlCQ+trJ+L57domLBcqoHQy/XkgSf7Kkb8Ufdv04QqqoaPnBUxfJsqUtQv5YGdMTir+ptfY/xvl4COf2CsJLyD/NKDeBQsxbKUqdiI+k0+GUxB0Nbjttx4f90IYH8W+6h8QCLsZiap8nnPiryto+lz++5dJQPd5bh9TRoh3xuLWNL5tztX8nnn50cRt2ySYA3CJ15R6ymiTGPsSQIavKdThOPjjSuz5wH53ecHMIgkkZDmij5TiiG4aJNtgUa6dKUTlJlUajg5Gho9WMSW9JfRboq6r0832KK8GokDDTrDxAeaWaYABplvAUED1RNcPhRNTUrbjl+n+xLQPNxRrT9rhAs03YV5+QXLxOUKCHhKBkOqrBoEhbvr0Sq4EPBVsLK1RhXzeFdDBO7lNRUmUBTJ8a9Z6jLBHae5t2L9sv6pMOmWluf+QbxCgE9zr1L1ncYGY6tM/6ydiqU/vismnAA6DZ9+/EZCsJw7IJaQy4MF1KuokVQ023RNMKkDMpH2X0M/x+QEpAh2li+Czgp3Zfgy1Ny/C9+yF+oZB4JzUI/lAwAoPCncmhk6Rg/Qp1xtFSJSNwMP1ojVuLTjRQ6INDMo4NmyhDTYc1kGIb8hpoJZM7ehx8edN0NeXD25v9ZJbyyTLnnL6opkjve0w0g5lt1re9lDvqEcn2uUFJXAdNbzgWPt5unrtkmWfHe8QZPVqant9NYKqesKJYDMaRhIuiHLdVILYafo5j8dxahdvmddDzNAJrIF7JIS5E4fRIVoBRX7ziGgI1yF9B1xvZDfm5+cipHBI+ZQKF2mnBfgQGvWHcwdzwsnCvOCKB4ofqllWel+jc1X07mciG4oIKCTuK/3mixikedmQATrDc38GYsdbLkJ3x37r9AFdFcJmTy5q0Rzg69nQyCUom1mAeAVRwBpv7fDaGKlILh4CV2x+/HV3l7HtQFlz0JRgWE0Vovd
 KZ6uvsF5
 ehKrZyvEjT08Ca4C/RRgzH6cM5TJUQZt1ABbS4RBX9/S7aYYjTrUU5w595BLM7w9InjvCGSI3pBVnpI/KPhEOao3Ey7a8j2y0XN0bjw4PgLlkVJRFm7YCWLEFBwf9IMlxbSJJr6mYz3Xd7yIKG4GWf+60CsKqOld2+6ky17xmXBKyP0269j2coFkdu1Jx6oro11i14/VePNgVMsh2Ul6sRdjBra5nrwsb2f5Jj0p9RxVG/8aBFsmfDwkoRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add zswap_try_convert_to_pointer(), called from __swap_cache_do_del_folio
under cluster lock. When a folio is evicted from swap cache and a Shadow
entry is written, this helper checks if zswap has a compressed copy of
the slot and replaces the Shadow with a Pointer entry.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap.h       |  5 +++++
 mm/swap_state.c |  7 +++++++
 mm/zswap.c      | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/mm/swap.h b/mm/swap.h
index afe2200bd160..1b07a08e5277 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -211,6 +211,8 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
 extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 
 #ifdef CONFIG_ZSWAP
+void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
+				  unsigned int ci_off, int type, pgoff_t offset);
 unsigned char zswap_swp_tb_get_count(unsigned long swp_tb);
 unsigned char zswap_swp_tb_get_flags(unsigned long swp_tb);
 int zswap_swp_tb_dup_count(unsigned long swp_tb,
@@ -218,6 +220,9 @@ int zswap_swp_tb_dup_count(unsigned long swp_tb,
 void zswap_swp_tb_put_count(unsigned long swp_tb,
 			    struct swap_cluster_info *ci, unsigned int ci_off);
 #else
+static inline void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
+						unsigned int ci_off, int type,
+						pgoff_t offset) {}
 static inline unsigned char zswap_swp_tb_get_count(unsigned long swp_tb)
 {
 	return 0;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6fd6e3415b71..20fb57adbb7f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -278,6 +278,13 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 		/* If shadow is NULL, we set an empty shadow. */
 		__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
 				 __swp_tb_get_flags(old_tb)));
+		/*
+		 * If zswap has a compressed copy of this slot, convert the
+		 * just-written Shadow to a Pointer entry referencing the
+		 * zswap_entry, so the data can be found via the swap table.
+		 */
+		zswap_try_convert_to_pointer(ci, ci_off, si->type,
+					     swp_offset(entry) + ci_off - ci_start);
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index 81115ca4d10a..f6e8259ab56a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1652,6 +1652,41 @@ void zswap_invalidate(swp_entry_t swp)
 		zswap_entry_free(entry);
 }
 
+/*
+ * This is called after the Shadow entry has been written. We replace the
+ * just-written Shadow with a Pointer entry pointing to the zswap_entry.
+ *
+ * Context: cluster lock must be held. Cannot sleep.
+ */
+void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
+				  unsigned int ci_off, int type, pgoff_t offset)
+{
+	struct xarray *tree;
+	struct zswap_entry *entry;
+	unsigned long swp_tb;
+
+	tree = &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
+	if (xa_empty(tree))
+		return;
+
+	entry = xa_load(tree, offset);
+	if (!entry)
+		return;
+
+	swp_tb = __swap_table_get(ci, ci_off);
+	/* Entry must be a Shadow (just written by __swap_cache_do_del_folio) */
+	if (!swp_tb_is_countable(swp_tb))
+		return;
+
+	/*
+	 * Save the complete original swap table entry value, which includes
+	 * the swap count, zero flag, and working set shadow information.
+	 */
+	entry->swp_tb_val = swp_tb;
+
+	__swap_table_set(ci, ci_off, pointer_to_swp_tb(entry));
+}
+
 /*
  * Read the swap count from a Pointer-type swap table entry. The count
  * and flags are stored in zswap_entry->swp_tb_val which preserves the
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2305E9A040
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152AC6B008C; Tue, 17 Feb 2026 15:06:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15BC6B0095; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71BC6B0099; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B52F46B0092
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E8501B4528
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
X-FDA: 84455031864.24.0D4A881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74FC3C0007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8OiHT2e;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358810; a=rsa-sha256;
	cv=none;
	b=JM/20JfE0GtLO9BVXl6YQrBWATKGAxrnm90MwShdb3Xz9wM5a79POdcKL4z4b0dGuPgy0P
	elHleikslI+qroEcP14hvHr1z8dlJ4JXDj40vYE2DjGN6U1s/IAHkOr0vi2xhwJaBUg6zO
	NU3o3oqgV7tnEoTM/PChtqoVAJMI9GE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8OiHT2e;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh09qgby8S6xDVlW5KdfbSbFeHI4SQYQYdGZvGyhK/w=;
	b=VPtAgp4kl4Yg9Lqqhp2wbiPBxaT0XK3e7Gf2kmPY7NP5jY65/jJ1V4SEOLrDkrUtXnr7Kz
	Kp6vuDpfTglwY7j0I7kS1yh28RUELZySgoP9Uq+Q14Pie/ZM6EqtLPqhB7B9jzooZyP/xx
	flLgxU/BhJmYy1oDUh3UcIlvttbPSAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BCBE44514;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37A06C2BCB2;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=7ccEw4+ezs68KMz6fmNdjYtqMbjfhzcscScI6KcPzUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=J8OiHT2eE3DlaYKatWo+dd4pnGx/M4i692s/JVxxjfG/j8kSZeu60E7c7JkM4aJvp
	 FoLGUstn77WKbzf03SXl3SRtk/8ebGFZyCwSbtdyZNqKzLBMdjy0lFVcf9XlFrJT1T
	 /khiNe3Rk0zXJpu7nGwgf+N/2qll96YxSQyoRrqZ8UtpJ/DrisCn6w7E9XAIp4JI28
	 FGry1m58Zo4hASlfeip2qxa2ngIDNTU8+dL9dGzu3021j45sNxZ4BFIPWK2qpddsQ2
	 Z9fUb+6rqR7rKgg2WXBuZl8rYkxJ1AqzuEatW/kbri92shJxT4JKcqJPjjZClLeoy+
	 LpJ1Sk8XzOwyg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295F5E9A041;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:31 +0800
Subject: [PATCH v3 06/12] mm, swap: implement helpers for reserving data in
 the swap table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-6-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=8791;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BTH7PLu1JcCgfu/sHFpEotAODg5Cd2G+MvLqcP9QWOM=;
 b=kwNrfINbrKtC6jXGNfgmIhLqrjWcMLCyvEj5ix/mnx2kOwM6ww0c3q7Sj/4mqrTZ2Eh++2F5f
 Q95rpjHt1EqCeD1ddDcqRe4rN/dZFYt+6WosAwkWwOjmuUxMnOPaaXU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 74FC3C0007
X-Stat-Signature: 1agbnwhzgf7uoffutezdkemnd17jzoc1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771358810-225999
X-HE-Meta: U2FsdGVkX18BMQDiu6T1n3bKbfGH9npWE4XE5bigSwT2HP5Xgh6wFVzy9+n48OdDYDWD8ONQbwQw19j/zdDImXHkodsdJjVLf1CNRWgkzqLziJbJ5RfoOJKbmV1cKhcTfOUKg4dqlyAzLBrNi/OG8jYxOqg1GFsXSGZDpZgH0iH6Na7NC4ik7LrgjPzCMk+SLcmah6qN+nUTtaYH5Sh+U30LoISRFo/3P1ZsFzIOUs5NKtb3qw4p6uZin5PUhiv9Ri13iL/RGj/2v6ozKTMe51ALfdHLMMVQDsy/6qZaYgf4NLFtkwY2icF2vuVtiGrnjWSGqsaP1d1TWZbZ8lkA4MbtbJORSOLJ9POUWamsqthgLp4ef7nGB7G3ypaQGy5FJjmqBuHUT5m1cwW3rSZL0oMs45oLiVRt3/CzvmHp9OROyVbdXiU7p7xb5dnbbAU72XpZUDWwccGaHKnRDKZX2CzFR1RJ+eL+JVMVHLyGf+cZklZwAUYBdhioEZ4iw2ByPfZRGP+UMFeAAZ59sKi0ihVnmsSL0jyfrnCUZIhuPz5OiOB539GFGVxKQElOnhAruTEDTE9WR5O2YWxMESwEe0MulHTUieDgZF72i5G6YIZbhZUXgyjt1qVvNQ5Pe2rsDA5KUlciK0J++Pun1PrT1e2sZZ3fkvV7EpxvkjiyblBFUPtk7vBxJIZ3sHerq9xx0plF5sSIObUpwisU70KTJ90Fhfmx0+PGlMhxnSTApOz/iaOQSLUY39kT2670JsZ+mgCp8NYbKVPDaijnWLuX/vrIv/NcswgI/KrVPW8AS1X/3sx9r9/8Sv/5E+3NH+rtfmQ0OBLGvguYePMApqD+8ZIVOCkSl2h0rdp0s1u5c1nKCkTXEd5zXLlSPuGoOPxaJHNh7UKW/1+o5KGIbYBFb/D/WBhCV6da7e4ZV6KaLVgLXUSaErLnadZotk842j5iZ0QVy9Em92PCC5s5zCI
 Eaqymm3q
 5ACSlclThmTFUeEMzFjBJfDuejlwc4/uqd7qqK5v41vsOanoB5UULxA1IXMqhCnDlbiodo2OM4KevyOBrNqrj3GBdmi7XajE5CMT0/E1kGCYLgMxshmoz0bPoIKLDg/ncrauGBk+NpGYqnzAticjWmKRgBfDPYO0KpdW+pO8TN3OxvJJYM2EDcjhfJGbkD/f5Ur4mBbNgN/eAPtvKRgVhXcgdLn+iQwRn/qiPH/t6JjVyrq4qAUfuWxL6MpP8FsSJQjMOHxo91WteK0vWlW6MDToGJlUWFkIpcXJmXzjB9Q10WWv69RNGQJk80ASp8G9mYEzM21M/bdBerUSP9UTcfZ8cLZ0faQwifQaAKMzH8iCUazq9EcbDi2FNaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for using the swap table as the unified swap layer, introduce
macros and helpers for storing multiple kinds of data in a swap table
entry.

From now on, we are storing PFN in the swap table to make space for
extra counting bits (SWAP_COUNT). Shadows are still stored as they are,
as the SWAP_COUNT is not used yet.

Also, rename shadow_swp_to_tb to shadow_to_swp_tb. That's a spelling
error, not really worth a separate fix.

No behaviour change yet, just prepare the API.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c |   6 +--
 mm/swap_table.h | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 124 insertions(+), 13 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..e213ee35c1d2 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -148,7 +148,7 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
 
-	new_tb = folio_to_swp_tb(folio);
+	new_tb = folio_to_swp_tb(folio, 0);
 	ci_start = swp_cluster_offset(entry);
 	ci_off = ci_start;
 	ci_end = ci_start + nr_pages;
@@ -249,7 +249,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
 	si = __swap_entry_to_info(entry);
-	new_tb = shadow_swp_to_tb(shadow);
+	new_tb = shadow_to_swp_tb(shadow, 0);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -331,7 +331,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE(!entry.val);
 
 	/* Swap cache still stores N entries instead of a high-order entry */
-	new_tb = folio_to_swp_tb(new);
+	new_tb = folio_to_swp_tb(new, 0);
 	do {
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) != old);
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 10e11d1f3b04..10762ac5f4f5 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -12,17 +12,72 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
-#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
  * 1:1 map of the swap slots in this cluster.
  *
- * Each swap table entry could be a pointer (folio), a XA_VALUE
- * (shadow), or NULL.
+ * Swap table entry type and bits layouts:
+ *
+ * NULL:     |---------------- 0 ---------------| - Free slot
+ * Shadow:   | SWAP_COUNT |---- SHADOW_VAL ---|1| - Swapped out slot
+ * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
+ * Pointer:  |----------- Pointer ----------|100| - (Unused)
+ * Bad:      |------------- 1 -------------|1000| - Bad slot
+ *
+ * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
+ *
+ * Usages:
+ *
+ * - NULL: Swap slot is unused, could be allocated.
+ *
+ * - Shadow: Swap slot is used and not cached (usually swapped out). It reuses
+ *   the XA_VALUE format to be compatible with working set shadows. SHADOW_VAL
+ *   part might be all 0 if the working shadow info is absent. In such a case,
+ *   we still want to keep the shadow format as a placeholder.
+ *
+ *   Memcg ID is embedded in SHADOW_VAL.
+ *
+ * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the page
+ *   struct.
+ *
+ * - Pointer: Unused yet. `0b100` is reserved for potential pointer usage
+ *   because only the lower three bits can be used as a marker for 8 bytes
+ *   aligned pointers.
+ *
+ * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
 
+#if defined(MAX_POSSIBLE_PHYSMEM_BITS)
+#define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
+#elif defined(MAX_PHYSMEM_BITS)
+#define SWAP_CACHE_PFN_BITS (MAX_PHYSMEM_BITS - PAGE_SHIFT)
+#else
+#define SWAP_CACHE_PFN_BITS (BITS_PER_LONG - PAGE_SHIFT)
+#endif
+
+/* NULL Entry, all 0 */
+#define SWP_TB_NULL		0UL
+
+/* Swapped out: shadow */
+#define SWP_TB_SHADOW_MARK	0b1UL
+
+/* Cached: PFN */
+#define SWP_TB_PFN_BITS		(SWAP_CACHE_PFN_BITS + SWP_TB_PFN_MARK_BITS)
+#define SWP_TB_PFN_MARK		0b10UL
+#define SWP_TB_PFN_MARK_BITS	2
+#define SWP_TB_PFN_MARK_MASK	(BIT(SWP_TB_PFN_MARK_BITS) - 1)
+
+/* SWAP_COUNT part for PFN or shadow, the width can be shrunk or extended */
+#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
+#define SWP_TB_COUNT_MASK      (~((~0UL) >> SWP_TB_COUNT_BITS))
+#define SWP_TB_COUNT_SHIFT     (BITS_PER_LONG - SWP_TB_COUNT_BITS)
+#define SWP_TB_COUNT_MAX       ((1 << SWP_TB_COUNT_BITS) - 1)
+
+/* Bad slot: ends with 0b1000 and rests of bits are all 1 */
+#define SWP_TB_BAD		((~0UL) << 3)
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
 
@@ -35,18 +90,47 @@ static inline unsigned long null_to_swp_tb(void)
 	return 0;
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio)
+static inline unsigned long __count_to_swp_tb(unsigned char count)
 {
+	/*
+	 * At least three values are needed to distinguish free (0),
+	 * used (count > 0 && count < SWP_TB_COUNT_MAX), and
+	 * overflow (count == SWP_TB_COUNT_MAX).
+	 */
+	BUILD_BUG_ON(SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2);
+	VM_WARN_ON(count > SWP_TB_COUNT_MAX);
+	return ((unsigned long)count) << SWP_TB_COUNT_SHIFT;
+}
+
+static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned int count)
+{
+	unsigned long swp_tb;
+
 	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(void *));
-	return (unsigned long)folio;
+	BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
+		     (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS));
+
+	swp_tb = (pfn << SWP_TB_PFN_MARK_BITS) | SWP_TB_PFN_MARK;
+	VM_WARN_ON_ONCE(swp_tb & SWP_TB_COUNT_MASK);
+
+	return swp_tb | __count_to_swp_tb(count);
+}
+
+static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned int count)
+{
+	return pfn_to_swp_tb(folio_pfn(folio), count);
 }
 
-static inline unsigned long shadow_swp_to_tb(void *shadow)
+static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned int count)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
 		     BITS_PER_BYTE * sizeof(unsigned long));
+	BUILD_BUG_ON((unsigned long)xa_mk_value(0) != SWP_TB_SHADOW_MARK);
+
 	VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
-	return (unsigned long)shadow;
+	VM_WARN_ON_ONCE(shadow && ((unsigned long)shadow & SWP_TB_COUNT_MASK));
+
+	return (unsigned long)shadow | __count_to_swp_tb(count) | SWP_TB_SHADOW_MARK;
 }
 
 /*
@@ -59,7 +143,7 @@ static inline bool swp_tb_is_null(unsigned long swp_tb)
 
 static inline bool swp_tb_is_folio(unsigned long swp_tb)
 {
-	return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
+	return ((swp_tb & SWP_TB_PFN_MARK_MASK) == SWP_TB_PFN_MARK);
 }
 
 static inline bool swp_tb_is_shadow(unsigned long swp_tb)
@@ -67,19 +151,44 @@ static inline bool swp_tb_is_shadow(unsigned long swp_tb)
 	return xa_is_value((void *)swp_tb);
 }
 
+static inline bool swp_tb_is_bad(unsigned long swp_tb)
+{
+	return swp_tb == SWP_TB_BAD;
+}
+
+static inline bool swp_tb_is_countable(unsigned long swp_tb)
+{
+	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
+		swp_tb_is_null(swp_tb));
+}
+
 /*
  * Helpers for retrieving info from swap table.
  */
 static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_folio(swp_tb));
-	return (void *)swp_tb;
+	return pfn_folio((swp_tb & ~SWP_TB_COUNT_MASK) >> SWP_TB_PFN_MARK_BITS);
 }
 
 static inline void *swp_tb_to_shadow(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
-	return (void *)swp_tb;
+	/* No shift needed, xa_value is stored as it is in the lower bits. */
+	return (void *)(swp_tb & ~SWP_TB_COUNT_MASK);
+}
+
+static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
+{
+	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
+	return ((swp_tb & SWP_TB_COUNT_MASK) >> SWP_TB_COUNT_SHIFT);
+}
+
+static inline int swp_tb_get_count(unsigned long swp_tb)
+{
+	if (swp_tb_is_countable(swp_tb))
+		return __swp_tb_get_count(swp_tb);
+	return -EINVAL;
 }
 
 /*
@@ -124,6 +233,8 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	atomic_long_t *table;
 	unsigned long swp_tb;
 
+	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+
 	rcu_read_lock();
 	table = rcu_dereference(ci->table);
 	swp_tb = table ? atomic_long_read(&table[off]) : null_to_swp_tb();

-- 
2.52.0




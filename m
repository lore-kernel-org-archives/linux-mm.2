Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6DFC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B526B00AE; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A646B00AF; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41936B00B2; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70A306B00AE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 041061C033A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:43 +0000 (UTC)
X-FDA: 85071776328.24.EFF9954
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf12.hostedemail.com (Postfix) with ESMTP id B90C44000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPqQvQiPE4kEALk74lRO5DDWcNFrfIK1y5fB18D5pfI=;
	b=ULLiumWKqGEmZa7fyCQfFHFEkIHsXniOMhvbAdE8QpFTNLYlD91QTcrOwUOqcAOxDxCLQA
	/d0BOwAf0qfUVGqmdDwDOgM9KPWFcPw9FCPf0KxRrhXmu6Hrd9fd5ORP055B7y4FaXga4a
	M0glgOEbTuRvkZKJNTgbosZm8u6Nk6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043202;
	b=pjDSkv3Nw/BQocDsFS05IMQ5TCToF9JLVKKpRyYoQL+31EZZ55rSCKzzCJY5ZoUTkLeoG7
	eTq4MZKsGVuR0LSYE2v5l2iPiZ21cqhLNXFqqMTGsdIj7N7QCE9JLY90IjpDT2PcW7N5ky
	wBhAnUqXPyitDtMKHrsKVrIA4b91WyM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 7 Aug 2026 04:06:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mm, swap: give hibernation swap slots their own swap table entry type
Date: Fri,  7 Aug 2026 04:06:34 +0900
Message-Id: <20260806190636.446205-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806190636.446205-1-youngjun.park@lge.com>
References: <20260806190636.446205-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B90C44000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dby8fjhb61zsgh5brgggdggqggixyb3h
X-HE-Tag: 1786043200-274497
X-HE-Meta: U2FsdGVkX1+7BnKFszPOPJRv5cRV1+SL0ueyq9mtBgwp1/3d88ft7XLtCosTke3T/wOaVdPxUzO6I6AgZj38nA7DSjG9SZWgoBwYlli4XtRCmUcPAMTcRb+Oi7KA5UqNBHcOvOl6fjIuNf/ScJb5BKbBgUhbJOPa9RoiIO7zZwgfahocfUDD/eVTLHMzU43OjfZOoC/E6exMcNwrhKkSidRnU2uLfb9iTpxW3uK9WQ1vR+0tmmfXNUqmnXoH85a0Ji3L5zVSWYz5MndVj3OW6XzrtZvPKznTXgbiwZIqoAlxFvywM2HUa6855twzHJSmFUTPuVexiGu766CpMZApdxA788QvgEfzvxroQqxqhGgnSC1pHgUb2CudXzchzjlatqw6v11C1b25nq4legg2OE98Zh4hAuupPb9a81g9KJ/W6OkpdqDmQSPn460x7FrNpMXFywm5NOhtYyhWOLmIsi6BKjL1DKoEm+rnsogqXMC6yK4XCr9ZpFDQi3uQmqTOVcBB8MESzKZA1ORR/fdzdjtZQW8nL2yR+U08VOce5hW++BALE6ySueudVQO/MVAKJqC8PjqXjSDpt2wdvEnybVKb25+qSCpZ4Xjeix5KVJ39/fh7DCgPf8FPslkQrjvTXoVlEPkW/IFa/kFFVWAZHlODNMfCEx09BHEDpaqdXIGwUvTDJkSVUICX7bFMTJhMd6U7k5heeNAewB4wnh1qKiJaAwk6LHO+TPUZEbSyEJxFNUQw/hMKMbfCeTTsr6MW0+Qlm/sl83vCyvjSwr4zGScFLnpRhB5jxIOP7LaGW6wxDmoJCWt8w4OQLRILpO2h/YZuuT3pjuX/JGrvIACDMsCtTfhPju1sePthhrMyImE8hnEeRrSD5xeXAg4xmyHDZuzKWAusUsuMwwHlOrFQAv8Q2y70aUNAyaMuFCFZ7bHiX8icmZp//jqb8fzmXYGFPc0Nk+CT7D4P7P5Vmhk
 jcOnetmB
 YyTxDkfeUhjrsEqXqOKcHIw9WV1zE+dA4317OQwLVAzmkd5veOeDfI0uaxedGTl+aNoemahC8XJ8m6ZvVh/ZQyZHiaSPba6F6y8+QsRWqC2yT1P7+jJ41sfloxn1js1s/37T0z5FFe/SduyLj/usbenwAt1be1gUqPPNLuv3Hp2rY08JnScozGa1Gu5njyEj3WcX0nV8WPst7/pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
out.  An anon slot swapped out with no workingset shadow looks exactly the
same, so nothing in mm can tell the two apart.

Give hibernation slots their own type.  Bit 4 and every bit above it are
set, the same shape as SWP_TB_BAD.  Bits 0 to 3 are taken by the shadow,
PFN, pointer and bad marks, so bit 4 is the first free one.  Neither type
holds data, so the value alone says what it is.

The entry has no swap count.  Hibernation only allocates and frees a slot,
so a count would never change.  swap_free_hibernation_slot() frees the slot
directly, there is no count to put first.

The next patch needs these slots to stop looking like shadows.

Suggested-by: Kairui Song <kasong@tencent.com>
Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swap_table.h | 12 ++++++++++++
 mm/swapfile.c   | 13 +++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..c1c516bcc17e 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -30,6 +30,7 @@ struct swap_memcg_table {
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - (Unused)
  * Bad:      |------------- 1 -------------|1000| - Bad slot
+ * Hibern:   |------------ 1 -------------|10000| - Hibernation slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
  * and together they form the `SWP_TB_FLAGS_BITS` wide flags field.
@@ -54,6 +55,9 @@ struct swap_memcg_table {
  *   aligned pointers.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
+ *
+ * - Hibern: Swap slot is reserved by hibernation for the suspend image, and
+ *   must never enter the swap cache.
  */
 
 /* NULL Entry, all 0 */
@@ -81,6 +85,9 @@ struct swap_memcg_table {
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
+/* Hibernation slot: ends with 0b10000 and rests of bits are all 1 */
+#define SWP_TB_HIB		((~0UL) << 4)
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_FLAGS_BITS
 
@@ -166,6 +173,11 @@ static inline bool swp_tb_is_bad(unsigned long swp_tb)
 	return swp_tb == SWP_TB_BAD;
 }
 
+static inline bool swp_tb_is_hibernation(unsigned long swp_tb)
+{
+	return swp_tb == SWP_TB_HIB;
+}
+
 static inline bool swp_tb_is_countable(unsigned long swp_tb)
 {
 	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f5dfc7e59191..a337387f7431 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -928,7 +928,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	 * upon folio unmap.
 	 *
 	 * Else, it's a exclusive order 0 allocation for hibernation.
-	 * The slot starts with count == 1 and never increases.
+	 * The slot carries no swap count and is freed by offset.
 	 */
 	if (likely(folio)) {
 		order = folio_order(folio);
@@ -940,8 +940,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 		order = 0;
 		nr_pages = 1;
 		swap_cluster_assert_empty(ci, ci_off, 1, false);
-		/* Fake shadow placeholder with no flag, hibernation does not use the zeromap */
-		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
+		/* Exclusively owned by hibernation, must never enter the swap cache */
+		__swap_table_set(ci, ci_off, SWP_TB_HIB);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1929,9 +1929,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		old_tb = __swap_table_get(ci, ci_off);
 		/*
 		 * Freeing is done after release of the last swap count
-		 * ref, or after swap cache is dropped
+		 * ref, or after swap cache is dropped. A hibernation slot
+		 * has no count and is freed directly by its owner.
 		 */
-		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
+		VM_WARN_ON(!swp_tb_is_hibernation(old_tb) &&
+			   (!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1));
 
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
@@ -2201,7 +2203,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	/*
 	 * A slot with a folio in the swap cache is freed when the folio
 	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
-- 
2.48.1



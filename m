Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F15C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE146B008A; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD686B0092; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3916B008C; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 033316B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:22:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73190C040B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:18 +0000 (UTC)
X-FDA: 85089052356.09.7E3726B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A9B620011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xNRHe8mCUw3+/qBpPsvAM2RnAfvSmjZm2WVwPjyoD7c=;
	b=S3f3/+EVDdnJW66swtR9kmHG2wddBHew5nBVH61s2xG705dzbKMq5Zc0JSySRXU06KpOdW
	5b6hRWbLp9mj1MysSJbTU/oBtWax4LLz9PLVIWD+W7lPGV7hzb0PYqG0hQZezFzYNOvSYo
	HU1pMQPctrSuP68o8f+3SjFnmrjc3eg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454536;
	b=uEt5GyJ0bxusoM/0jOY5n8bTeivgjK1nsmsuk6irPhuOnoCkM1FWNrCSJxUo1wgG4iQyFU
	qKfeqOTRo5XLIzwfB/fIn18OutKVXe1pHdDXDGIxt+G6nwVSfn3LIJ7MZqzJGi6klIkuaz
	Op6dev9TO1SxskyU8XsDYzK9R81wH/E=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 11 Aug 2026 22:22:13 +0900
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
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH v3 3/4] mm, swap: give hibernation swap slots their own swap table entry type
Date: Tue, 11 Aug 2026 22:22:08 +0900
Message-Id: <20260811132209.2862708-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260811132209.2862708-1-youngjun.park@lge.com>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q194ymqtt9dbs8ye3xxzjrn74r47rnw4
X-Rspamd-Queue-Id: 2A9B620011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786454535-346943
X-HE-Meta: U2FsdGVkX194W3CiHf4QZeW6VDY4IWaKXilAJ6g3p5vJgZ8DaGSjtynyuicDRMfzi6tE/q3WTnnpw1W91fUc+SaGCPtobg7PkYIYi3V19rZ2Mq54BNYzilfImEPx5Jqg72j3+IlzAUymlgFQhCIUwIpXYqqf2K9SQw8XTXEju3hMSquhw+s9O3yeb9siZXsYynNYCkDJs+UeumhlVBIwK0dnaPMW6+mblwT69gZ83FTqWF2MPdUlnfI/579gbxYWI5KKCGRNPvVM9a/Amkt/JP8NXHgKONig6OwdoemCbAZXNOGPfXgtaLqRcfJpuRMuyQ+2BsJMMgiuvxgeQ9aPqV9MlMvLSKgkcux0B+VXTTorJyb5sluB34eG6Z8PyQTNT7FlLn5UTBwP2qUeW1OQA5XNDZAX+z+ZbbKMjQR2sVvEwtS/pv3TRLvSDOQDhqtNIMJ8r+GCyGz5ztJDDWea5Iz+N8QTVMMS4jYBXsVitMyvwXy929eOGANB43h32wILNcnWSQwDDoRevd+W5cLczgv4pOT0/bg5wushn6PaZSbnG/Hlxug0B2rLGfJ8iULeMoz+wi6xJGcaYQOPMIuLiWXe4wrcF3UardfKVVpH9s4ml0D/zw9GwR3djwrveA/20ecOsmWUUZGR31OhKlhowDplmNSF6qVqr6Yv3LuM0BZ2A7hy7Abacuohx8dhfIADgpVYjEAMUg66KGaQsFsSkEKkmOINFkwTe9mSI1HWrqxQODmS5ic8d+MH8gUo1X665LIr9rsMmysEnOkw3sX0TlLpbZ/Vg3FuxHFptfnxii4QRWLdnChgNK7uOegwrwW4I5jASXGmyFoavUCN3nkdfBlW3QPhfbrQE3e4IspY2ZtA6bHRxMJ+yzLN+5cfl4aKZV3zqJE6q4P+CvlsBi3QYEBcRR7SfCdsbB5WHTShSPpSAe0e2mXXj8jBkQoPNMFLK4OpkLEivNUB3AGAamV
 g5z1X6T5
 9wE3/t/Y/B4537Ike0QmJL2ANpsLa9hFDLTdf3bVMYLfYtdOJblHDB6y9SpjBiWqJKPUsdnDieH8p1ZaZqmtrXZx1McM4kM/mZ/9dA4HGbJ4F17JBIvvpSJZ1NTDcLocyhxHun4Gocx0Q+dvhl5VNaZBHxlCq2IvmsSh2ZuzfdgzGe05VtBfVRcUfRg7Yi7fs1wefnb80LaICK9I=
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
set, except the count field, which stays 0.  Bits 0 to 3 are taken by the
shadow, PFN, pointer and bad marks, so bit 4 is the first free one.  The
type holds no data, so the value alone says what it is.

The entry has no swap count.  Hibernation only allocates and frees a slot,
so a count would never change.  swap_free_hibernation_slot() frees the slot
directly, there is no count to put first.

The slot is no longer a shadow, so the previous patch keeps it out of the
swap cache.  The count field stays 0 as well, so code that reads the count
without checking the type sees an unused slot instead of one at
SWP_TB_COUNT_MAX, and a wrong put is caught by the existing underflow
check.

Suggested-by: Kairui Song <kasong@tencent.com>
Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swap_table.h | 13 +++++++++++++
 mm/swapfile.c   | 13 +++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..b916a6493521 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -30,6 +30,7 @@ struct swap_memcg_table {
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - (Unused)
  * Bad:      |------------- 1 -------------|1000| - Bad slot
+ * Hibern:   |    0     |------- 1 -------|10000| - Hibernation slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
  * and together they form the `SWP_TB_FLAGS_BITS` wide flags field.
@@ -54,6 +55,10 @@ struct swap_memcg_table {
  *   aligned pointers.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
+ *
+ * - Hibern: Swap slot is reserved by hibernation for the suspend image, and
+ *   must never enter the swap cache. The count field is kept 0 so it never
+ *   reads as a slot in use.
  */
 
 /* NULL Entry, all 0 */
@@ -81,6 +86,9 @@ struct swap_memcg_table {
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
+/* Hibernation slot: ends with 0b10000, no count, rests of bits are all 1 */
+#define SWP_TB_HIB		(((~0UL) << 4) & ~SWP_TB_COUNT_MASK)
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_FLAGS_BITS
 
@@ -166,6 +174,11 @@ static inline bool swp_tb_is_bad(unsigned long swp_tb)
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



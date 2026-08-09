Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887F3C5AE49
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D49A6B008A; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7846E6B0092; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650CA6B008C; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318D66B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0A688057F
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:35 +0000 (UTC)
X-FDA: 85082007150.12.4E0FF13
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49AB1140005
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786286794;
	b=hp23psMy8X+BXKEQ+3msF/HlyHcCiU7kT0nZxpdWMh9Wx35yba7QpJpmmkkW5daRjIaHXN
	z3C7a2h+hH8rJCIAFWbyrePfxQt9HgHoIEeAF0sstiQheXSHaIssmWx7nMEIAFanz3UlnK
	IDJ9I2wn4wT3pfIabgfs1lVJ12NMNrw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786286794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xNRHe8mCUw3+/qBpPsvAM2RnAfvSmjZm2WVwPjyoD7c=;
	b=MuAN+d1qW9Xdu98PeOM85t0mUUhwKelvzIdrdtfZKzGfn9CwibyI+AH+sML6h9ciuIDYJg
	v8atQpKjgdAgdN1Lb4O3vCrjCvtMKogdL7kftLyiW9bAO6eGgZWquwvglp/UD3VQTzACkI
	kHAqNiRBKrqGBe4b73AEQ3rytFhAQ/U=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 9 Aug 2026 23:46:30 +0900
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
Subject: [PATCH v2 3/4] mm, swap: give hibernation swap slots their own swap table entry type
Date: Sun,  9 Aug 2026 23:45:58 +0900
Message-Id: <20260809144559.2104856-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260809144559.2104856-1-youngjun.park@lge.com>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49AB1140005
X-Stat-Signature: jpfgzqjowtpd59bud3xmhjdjgqqeyx71
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786286792-209106
X-HE-Meta: U2FsdGVkX1/U30534qwdGGBVjzdR6CIpnE1qTV5XrD87ICLombQy+84IfofJdFVSYCE0DYB8mWM255crmVwa6K5E6HLa2UPIAgLVBmC2rYW2l1SvMF779/z4IjQV2t12PWxEsjSWH+HD5o26a8yp125eqoNRps4gildu71INmjX7n8aWhg3w4x/sDeBy5AEdd9sQGwhjSm96d9ZWir5lkOtYoOT7PLPoCak59eiwFTN5SscW+vu701C/CJxIfVHW0iIiM25G3Jg0XwxLNr29pQgCs6d4+NbmQYyc6ecJFNqBHYM7AB4MyynDzUVFZLumb419Pp6q/PgosembDZhsW24tM83EQ+2rA0vGxscKsxb4a4b5qFtYTl5DYV39X4cmGF98IuIlLyleKeqPRXDVrY6biMkUly6vlAG4iG7hU4AfwDlGCXhHjldRYbkIsgaHOOYot6LeX2ZLyqguutlH6Db8FAJy6auLSj8i2y/AtpK7y3PyAzug2WsGXgCWclBjt3Dmf/n3BEsmtWzIej2RKXChRUXl5y1Q3dDC8C6kizqg524cxrpzyEOfImSp6q2QUf0XL+YpOYsRKWYIRU4PvU600o9GGQADaKXkC2LHrX9NF6mbS1ZZzCAQFLB4ypEN9gCLw6dPA30PMOiH+wOgmpUGmqRMvrO7U/7ydw5eSyLhUtKC47nCY+lXa6+8vEcjGZqg4yek+UTx1gh02WytoQfOMGQswT1cEk820wXXmKnB3ADL4RoMukZ6lY1tFPd6uUWoOsSan405299LETJOOuF4KetLBHdZbUvOr0L+iqf1jbe45hvUJiG3BwGLUtwMFZm8Sz8xgDWa5qUoHRLXyHGttofA0d9/eXRTlI3MvMSfEhSPpOVSkLoy+wMcsHzKOd/yuj/jxzA6dscwFE1mQA8rfd9Un7qaPbTMOx37vxp4EBH5LPM/KxVVINKwuKwDU+nFykr3k2xQRBx9xNe
 xmNUYGOO
 QpWk+dtlpsyc9P2gEXvLSVb3UFGS2bk7JK0oevCfcukDetrTizhsPA9HX8qNLlr4oUZj/N5JVLjOMX041pbjHCbLn1vnnOwTEvtJFs4eKMj7pGgzCHoXPCDWOtfbbERRpdtoU/uUqZTjx1NPz0Q1paYsfwICeij4DnYTDbkwRsC94g4nnjuKflJXfP4AKr2G4v6+bVtsIHRV75lY=
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



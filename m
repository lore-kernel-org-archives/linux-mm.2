Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9687CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5706B0095; Fri,  2 Oct 2026 20:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6962C6B0096; Fri,  2 Oct 2026 20:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D33F6B0098; Fri,  2 Oct 2026 20:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8206B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8208EA61D9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:29 +0000 (UTC)
X-FDA: 85279506858.12.F5CF1F2
Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 51A05180007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmmb2E1M/b4aWFMcAV2PChy+gWAirHDsWI+RWTVpI6s=;
	b=DsG00h2hkUQbwagfSN5Bs/VbU/Nc6eZToEl/z4NphEUxf/7vMpo7BcyySL2+dAKFSyVlCy
	zrlrjD5yBxoZn1t0q0h388Dda5G+ii9Y6FKSu17u3bkeX8b7fB0WLu302wjzI0U0qD3cvn
	+EzOVb+ArcCi4+XW8MpRD6mxzv+/Nho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989167;
	b=7xf/IcNhVgva37bruDqtFX35T2I383KqbhTcPfMZzf94i/TLqvtX2rAeLl3w7Urj8Tdt9+
	3YD7NdDmZCRkd1J3H2lePJmILG1B44WdAAht9NeHSz7HaP9XLytG03ee4D1+/OEnOIzoRg
	2HH16kk7qkdi0YFJE7oE1cH0+G8k/b8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b12d5abc85844bdb;
	Sat, 03 Oct 2026 00:59:25 +0000
X-Mizu-Trace-ID: b12d5abc85844bdb
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 02/12] mm, swap: tag a swap table entry with its owning xswap entry
Date: Sat,  3 Oct 2026 08:58:50 +0800
Message-ID: <20261003005900.909710-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51A05180007
X-Stat-Signature: bsxj6nanu8ed6ihwhw3prjufio5wa94a
X-HE-Tag: 1790989167-891522
X-HE-Meta: U2FsdGVkX1/ssAYEib9c5U44DWeItDdI87PIlDrie5y/RPX3oF/LWeIztA2dQ7WGl4zTKsxs+RiSG0exLyjhXFKU/EJin4DsLtAiUtC98vUUckhsIxwgn3oteo8YfqHw/1IAg9SaDRRYtcyUzHWo8PU5pXRvqSMesqpDPEnXd50mHwrDsiqRQhaKQiQge9904YDniRriMk7l5hwvGhlWZIi4QoVuqSW5IYiXbgflVxx3XvUgFMdWL8/4dV4auxjXLkLwN82bZ1LZ4FPXYsv+6ziOeVZx4Eq25JROsoTu+WVKWU0U9y5Ap1TiaoT6GmzVUj4jTIKnyXTC7qRLaxRJX7HS+EwE7pM4+rVxS673iQSArHt0sfjQs+ynIZO2tKlWoBZDVCHJqaYzgCp/CEt9sBDUgTj1eA2LwyXqzd5ThFaYOTbBGRSTNf99a34irneM4r99DHZoXtq6f5lI+oTAuefUh+Wq7NGVd4ZhSKwIeE9t4g8eXDD23ZlL84xPGVk37wO5kFu0RHkjyvBSlA1KceuA4NM18lYcvyEu0cc9OJmCAfVkRNBI8xqy5wPG3Ve9k/SFNYVBc0kylPtloSMzGYtV3kOD8CUa+BAnZxUA2RS+oLv7xOe0BQouWh0zJhV0NA4ZJPknBhuMzVW2MISzjB1bYGmJ+0bmRqOhsyRcAEd7cVrnGwTBAUugtLTJFBfsT13lSBMIlcCIzDqv7H2Q2NkJfrHBPgYbsbJroK9DulhKyGKZpgo/vCdPKDktWsxCV3zRZZJHeVt1ypp3jXwsSAFRrnkhQORrl8VO7klsC0+klnCKyWDKhGlaIhHyIQgqUuY7UPzy506TlwAEr/zvbolEhUr06WWNls1u447AmSLuj6UqSuEuxvYLf9AFlmict8NZXC9QPIKBquIHbS9jT+LmmycVq2IOQ5koF4ayGZhYquNVEl3hxuhFJrXUXbfr+PH5zZEZchBDAARhs4g
 SFdGpTNY
 KKvzhzIi1Y6uGD6jTy4NRcjMNK0fqfkvpkDWaj8eH+mibkPuT7PC+SqoCknrkScrV648YLR3Ftqh7z8bRn7wPLsqVclbpQTogX63QDNiZHZKtesVHSW1G4OSM+3ZPni6CFqHJkclLAkh1k0orUbzfn+HHVo+uAqmHpEdWHelGo6UUrwSxD5kvqa8hMt5JsxleAKLqdmDqbKD5lfHLUaus62qIy8/qT65wP4Dzx1WWkJzxDLaDy/rl4SKLElA5A4B/KGVEgJ42LwaaXWRJ26zVWLXIDEhFkHUakTd9S/JrVktJevE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap folio can be written out to a physical device. The data then
lives in a slot on that device, with no folio in the swap cache. Store
the xswap entry in that slot's swap table entry, so the owner of a
physical slot can be found again.

The low three bits of a swap table entry tell its type; 0b100 is free.
Use it to mark an entry that points at its owner, with the xswap type and
offset in the bits above.

Two paths hand out or cache a slot and know only the other two types.
Make them skip a pointer entry: cluster_scan_range() must not hand it out
as free, and __swap_cache_add_check() must not put a folio over it.
Otherwise readahead on a physical device can walk into it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swap_state.c |  6 ++++-
 mm/swap_table.h | 61 +++++++++++++++++++++++++++++++++++++++++++++----
 mm/swapfile.c   |  3 +++
 3 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3a4e9e447b0b..c5c182489d6a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -179,6 +179,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return -ENOENT;
 	ci_off = swp_cluster_offset(targ_entry);
 	old_tb = __swap_table_get(ci, ci_off);
+	/* Readahead of a physical device can hit an xswap-backing slot. */
+	if (swp_tb_is_pointer(old_tb))
+		return -ENOENT;
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
@@ -196,7 +199,8 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb) ||
+		if (unlikely(swp_tb_is_pointer(old_tb) ||
+			     swp_tb_is_folio(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
 			     is_zero != __swap_table_test_zero(ci, ci_off) ||
 			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))
diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..22322519c3fe 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -28,7 +28,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Pointer:  |----------- Pointer ----------|100| - (Unused)
+ * Pointer:  |C|-- xswap type/offset --|100| - Backend slot
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -49,9 +49,9 @@ struct swap_memcg_table {
  * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the page
  *   struct.
  *
- * - Pointer: Unused yet. `0b100` is reserved for potential pointer usage
- *   because only the lower three bits can be used as a marker for 8 bytes
- *   aligned pointers.
+ * - Pointer: A physical swap slot backed by an xswap entry. `0b100` marks it
+ *   and the xswap type and offset go above it; C is SWP_RMAP_CACHE_ONLY. See
+ *   the layout in the CONFIG_XSWAP block below.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
@@ -81,6 +81,59 @@ struct swap_memcg_table {
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
+#ifdef CONFIG_XSWAP
+/*
+ * Pointer-tagged swap table entry: the reverse map from a physical slot to
+ * the xswap entry it backs. Layout:
+ *
+ *   Pointer:  | xswap_type(8) | xswap_offset(53) |100|
+ *
+ * The low three bits identify the entry: 0b000 is a free or bad slot, a
+ * shadow entry ends in 0b01 and a cached folio in 0b10, which leaves
+ * 0b100 as the only marker still free.
+ */
+#define SWP_TB_PTR_MARK			0b100UL
+#define SWP_TB_PTR_OFF_BITS		53
+#define SWP_TB_PTR_TYPE_BITS		8
+#define SWP_TB_PTR_OFF_SHIFT		3
+#define SWP_TB_PTR_TYPE_SHIFT		(SWP_TB_PTR_OFF_SHIFT + \
+					 SWP_TB_PTR_OFF_BITS)
+#define SWP_TB_PTR_OFF_MASK		((1UL << SWP_TB_PTR_OFF_BITS) - 1)
+#define SWP_TB_PTR_TYPE_MASK		((1UL << SWP_TB_PTR_TYPE_BITS) - 1)
+
+static inline bool swp_tb_is_pointer(unsigned long swp_tb)
+{
+	return (swp_tb & (BIT(3) - 1)) == SWP_TB_PTR_MARK;
+}
+
+static inline unsigned long xswap_entry_to_rmap(swp_entry_t entry)
+{
+	unsigned long type = swp_type(entry);
+	unsigned long off = swp_offset(entry);
+
+	VM_WARN_ON_ONCE(type > SWP_TB_PTR_TYPE_MASK);
+	VM_WARN_ON_ONCE(off > SWP_TB_PTR_OFF_MASK);
+	return (type << SWP_TB_PTR_TYPE_SHIFT) |
+	       (off << SWP_TB_PTR_OFF_SHIFT) |
+	       SWP_TB_PTR_MARK;
+}
+
+static inline swp_entry_t xswap_rmap_to_entry(unsigned long swp_tb)
+{
+	unsigned long type = (swp_tb >> SWP_TB_PTR_TYPE_SHIFT) &
+			     SWP_TB_PTR_TYPE_MASK;
+	unsigned long off = (swp_tb >> SWP_TB_PTR_OFF_SHIFT) &
+			    SWP_TB_PTR_OFF_MASK;
+
+	return swp_entry(type, off);
+}
+#else /* !CONFIG_XSWAP */
+static inline bool swp_tb_is_pointer(unsigned long swp_tb)
+{
+	return false;
+}
+#endif /* CONFIG_XSWAP */
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_FLAGS_BITS
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0d1288d36452..af7a7524fc4d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1120,6 +1120,9 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		swp_tb = __swap_table_get(ci, ci_off);
 		if (swp_tb_is_null(swp_tb))
 			continue;
+		/* Backs an xswap entry: the slot is not allocatable. */
+		if (swp_tb_is_pointer(swp_tb))
+			return false;
 		if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
 			if (!vm_swap_full())
 				return false;
-- 
2.54.0



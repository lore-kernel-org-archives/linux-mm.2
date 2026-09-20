Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573D8C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250536B0093; Sun, 20 Sep 2026 03:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227F16B0095; Sun, 20 Sep 2026 03:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1174D6B0096; Sun, 20 Sep 2026 03:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E74176B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87FBF803D6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:08 +0000 (UTC)
X-FDA: 85233294216.11.6AB3807
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9C04DC0006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888866;
	b=IwOS22vS0c4e9hP7QO8lf1x2Nl3yRczDy36tVEaHq3ejlZH4cDurlgl6ES6sgz1i15tiuy
	QijXhr3jWSNf5GOfG6uXINjiz1a5EWiBmbN9zB51fAZZnK/IbYOpBKx4JS3rKjiHIn9wvx
	zQcbGMynYv9VOFXkhJdbAhtI4EHw0MQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHUyZdthuXPDrvKDa7ezddb/iuOkDw/ZaD+tgeUvnQQ=;
	b=fNvLUFjtG6/JbRCEr91qLqko20AnNDHfcmYu06qBUUjXKWo0yQG2+/4my7rfAcBxpkxRXN
	+71ShpOT/43A11qS2p2wZlUdgXsWgrN3Crv7HCXqMzbNEO1ZF4Dii1dYOfaTEWiLFTvbZ4
	PK3rrS8xx2D4x39odYrcU0nb6fkZsy8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 7076cf7401952f87;
	Sun, 20 Sep 2026 07:21:05 +0000
X-Mizu-Trace-ID: 7076cf7401952f87
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
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 02/17] mm, swap: tag a swap table entry with its owning xswap entry
Date: Sun, 20 Sep 2026 15:20:28 +0800
Message-ID: <20260920072043.430390-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C04DC0006
X-Stat-Signature: mseobezpbad88hgwg4xg8mdzrfdrardn
X-HE-Tag: 1789888866-492667
X-HE-Meta: U2FsdGVkX18dec5QteJcxxCKwKaSxpBB92LgkQDpE4cR9y2et7d378eK7mkuHusdUNDiceRs3KyYZ1+gLth0ju/mQdrBKJ09Cu5C/8Yf5sWL2OTibFvTD7nuX7JfCZxPOhF568Y5TPcHvtzTrry5sfhwThDMMPyAufI/FfVOPpBfjPuyHGEhpKmeV/n3hK4m48TcgRnDMcD9lcF5VpktpOg9Qien9mUOS4/wv3j0Qj3KGNE8sRy6HPDpc31DTatXBYNZaA8EbjxnaBDQ2wtC1FpSNotjwUf0aJHMRV0S1WkdT2+EiJebFjvB5L6HcmMQ8woh4He8HeN/RRSa/5YWU7qfN0TD+HD25dZ2ypwMGCs2oQWTwTb1ZiWgfgSdQsQH24JO81O3y7CCbYL7RvcstLJoCu+Z0cJpmLfc9T6lBQmQnOJc95GOYmnZ83jJChK4TXfN2vX2ddqrwa7hgznVjsmFHbdvSFNFkKfImS5pY6VtB6zdY6qD+4zhxBkM5GdkDh4UR8Qx7dne8X4ZafPh85s9DQkxVpyJjDx8qapN8+t6rgyZaDhsNqnG+vJAc/lRifvJeQD//5tL3DX7Z6sGxl5X4SgaaDP9i58LxqfnAXhv3U2DZuLSTrAA9yTrlXUHvANtKH6IqSEYQIHak3vEgs5axYASz98tpuBJj2z4eF1nq2CwwOgCHmxPSzOK4sIvp+Cq/pfbLzA0CMPbx9S+I0sVP3If756ctNpg/3mN3HMNSacDeQRl4ga6baR3nFZeUwR0tKqbgdZaFbUXmvWTslqyjKVn1ZJmGMz11+Ac2EfNkyhGmFbQCzEADW+NZGk7MCDzOYOUPqwSHfxNxOzRim7YU0miVSBICX/Xe3XahtfrMmfdnUxRbtl9Xhy4gJxhUWpuW9q20GtX7081eeTBC+atbjb874yhc449zZALMpfZPy+6iEI8zN0tikikgWU840KU85elM1k9UgxuKzy
 tBumo3Jq
 d/8QL5QH36ar0DHPtv55+8o5kbxR38BzFJMmk4HZ9M/1Zc3nsseKpflL0UUVdsXKO/LmIPZasZOO5AV2SvkQwePk57lU14ATA3yMrSYv629ExKBTo/O2NYlnbWMhS5t8LZAosJGnBbXxI4Nk31PoKhw2fRl470DBn+0Hdi3RZCf6AB+NVAQImAT9ZrDytCGSHGd6dqbRKzVXt7K1tAPelJXwS2OYsIpZMDQ1CKMVfKoDiTEPwp1Q2fDtfnieh/E0AanXTFFm1YBRvqL70vEByjsZJj5/jNpUs4oJHhlpbIGY1f3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap slot can be written out to a physical device. The physical
slot then holds its data. That slot has no folio in the swap cache.
Record the xswap entry in the physical slot's swap table entry, so the
physical side can find it again.

A swap table entry can tell the type by its low three bits. Now 0b100
is left for extension. Use it to point at the owner. The xswap type and
offset go in the bits above.

Two paths hand out or cache a slot. They know only about the other two
kinds. Teach them to skip a pointer entry. cluster_scan_range() must
not hand it out as free. __swap_cache_add_check() must not put a folio
over it. Readahead on a physical device can otherwise walk into it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swap_state.c |  6 +++++-
 mm/swap_table.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c   |  3 +++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8bba3e533b28..135d9573a9dc 100644
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
index e6613e62f8d0..524d397a995a 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
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
index 29118082cd7a..ad6703aadd3d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1032,6 +1032,9 @@ static bool cluster_scan_range(struct swap_info_struct *si,
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BB1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A976B00BB; Tue,  7 Jul 2026 03:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBE36B00BD; Tue,  7 Jul 2026 03:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085B56B00BE; Tue,  7 Jul 2026 03:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D06DA6B00BB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:33:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 706D21A0363
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:50 +0000 (UTC)
X-FDA: 84961166220.13.0E24DF6
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAB7140006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NuXKu0DZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKVZ/psH/tEHHl32AP1GNPm3Y5x3NGt0wvhWlFRYJvg=;
	b=mt0ACgWOeQhznliJGi4a/OfI2iO4qEnYiKOb2tcNvYAdhn3YafE0zTQ3ZPGXtcgyqZzhMy
	r2SpMTmYy/EIwx7qdHQpIiKvY+2jfIPdVREEJx0RfbUyTXFJNQXF3GBGW8oroobP+tzRPt
	WEz4AfwjWoVUih566MNn5oFxrsC6uvo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NuXKu0DZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409628;
	b=T2Urx/9iT3WStBP7En98g3Ul7BeFXNdUfY19TsBdcdsLseAvTIY6gURfBWWqiiXCJX3e01
	xmxerRBE21yufFWxfeJOWXfiFKmyGKO4KmXSkmzh9i/cmzBRTJQlenl6uojcEMjEcm60Kq
	YRdCpf0PjZiovA/sgulFC/VCAWiohJM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lKVZ/psH/tEHHl32AP1GNPm3Y5x3NGt0wvhWlFRYJvg=;
	b=NuXKu0DZjUo5DrsrUYwbSM9Rd5esEWdalKeFYSU3MAWRKu2Llq00qlxcNF7Z9c/kynDBYP
	a1ObF7hnihCG/QbQqZG9BEB0n3laKfDhBbfTpMpEdRPEHf6gajDcyjNSA6zQE/S0n3aFcw
	sEv/zZ4V3sYOnMvd8Ao4Ntsc1cJlDzA=
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
Subject: [RFC PATCH 5/7] mm/swapfile: handle Pointer entries in count/dup/put paths
Date: Tue,  7 Jul 2026 15:32:02 +0800
Message-ID: <20260707073215.72183-6-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t8bcz651754bh1xe1padfim7awwtptb4
X-Rspamd-Queue-Id: BAB7140006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783409628-204088
X-HE-Meta: U2FsdGVkX1+X8Dbdlg88YQ6GBdGC8mDTI5wPPccgAjXicLt+zPbo7K+Iru8B7Rlew0ixQrstY9Pi6lHsR1yhoh+77/s+aa5o80s6F37WS6cTkwLgGFE04wDDT8R0estxey/GbQPOHEC9gKgI5gKoyGm5VdRf17KDXomDl4DZwkLi0VYOnlvLH+oLmSRJndx1QGu+mkiC+mXWuJQfh9j8UHBu/Cd6wU1sa9VXnRJqpxK1bwsHu4ZlrCAOx076YuXtl0b6yrct0wikhxd+Wx8LAAKMHwb1GFpSJrYhSFPLPvf+Z+n9tLFmUvAdHXCM6za1P3DjFtQ19Gn/fhr3A0c4cCv3SvlHatY0acPPeyHWBpdE87sgMNi4iu30Amluh4MpwmFSfYrEQ/qNZ8oogsObflJcqrMjQSsoI6ArPjMpoG/iqH+8ei0PzwoT3kHYobWJ6e1l2YiMJu/G7yHeJ2ydf6OR7gGf7/7MKkNYGl8UMJotd9K5qdBmPrrybL2jEg+igMOId3glTTHFeIu899hpP368VdP07Hf4cE4f2G6G8QuQJaIqN8DhYpHGS1I+u9kChE63ZljRsS3Ma1RPOBQY2tQyq57LZ6DVKqHSF2j/xm4bBsJZpxER8sv/4YJokWZeKuEUKZPx3TH5lqgAmw2Z+gxxgBWAdNd802eZKXnV3ppyeAQfutgAEpDek/nc1ChT+qC2PpEBoBhRur+z7WuuYhErIzf786lv3MGbUYg2qb69T9QL3GThm3DMCiq84nJ6d4mL4DBOqQStWPDo6H+50d1B+lfQ/NIrAyl2NuY3aXWWl/JpsJZ62kd7Epg5kjn7OhoVN/k6GAAkTxUI786dSk+zl6nTqCEW+r4rOuNLYxkcczpr7dWiPYSNbvSCIv5cnO1vC3gk+X0WriWTqIB9UXJ2zIcu/1FAX6pcKNT9BLM1ACeCKEqNkQHDbSydz0KZVAW7WwwmB2a5VQjQ/+X
 0FS8sRdo
 NxQsFpoFOtA9BYOiQKpVkYO50t21wlZqMWiCviXMGTyIIQzTJ3F812nfHOSs/L3RpgqlovLH9YfXH+nRV+OKWjPGGdEwdQSYxMKkVE6MKwGW7go5QJKWVMTGI/11giezC2fwuwC67lvLgmHygRNQ1awWiBtdB6PQblV7kzBQXyyKJggXgrzbX6t8KVbNFsobHOaoVd0Ww1XBM5/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update swap count, duplicate, and put operations to handle Pointer-type
swap table entries where the count is stored in zswap_entry->swp_tb_val
rather than inline in the entry bits.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 95 ++++++++++++++++++++++++++++++++++++++++-----------
 mm/zswap.c    |  5 +++
 2 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a602e5820513..15572383cafa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1536,25 +1536,51 @@ static void __swap_cluster_put_entry(struct swap_cluster_info *ci,
 
 	lockdep_assert_held(&ci->lock);
 	swp_tb = __swap_table_get(ci, ci_off);
+
+	/* Pointer entries store count in the zswap_entry struct */
+	if (swp_tb_is_pointer(swp_tb)) {
+		zswap_swp_tb_put_count(swp_tb, ci, ci_off);
+		return;
+	}
+
 	count = __swp_tb_get_count(swp_tb);
 
 	VM_WARN_ON_ONCE(count <= 0);
 	VM_WARN_ON_ONCE(count > SWP_TB_COUNT_MAX);
-
-	if (count == SWP_TB_COUNT_MAX) {
-		count = ci->extend_table[ci_off];
-		/* Overflow starts with SWP_TB_COUNT_MAX */
-		VM_WARN_ON_ONCE(count < SWP_TB_COUNT_MAX);
-		count--;
-		if (count == (SWP_TB_COUNT_MAX - 1)) {
-			ci->extend_table[ci_off] = 0;
-			__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, count));
+		if (count == SWP_TB_COUNT_MAX) {
+			if (!ci->extend_table) {
+				/*
+				 * MAX without extend_table: MAX is the real
+				 * count.  Decrement and write back inline.
+				 */
+				count--;
+				__swap_table_set(ci, ci_off,
+					__swp_tb_mk_count(swp_tb, count));
+			} else {
+				/*
+				 * MAX with extend_table: real count lives in
+				 * ci->extend_table[ci_off].  Pull, decrement
+				 * it, and either move it back inline (if now
+				 * fits) or write it back to the extend table.
+				 */
+				count = ci->extend_table[ci_off];
+				/* Overflow starts with SWP_TB_COUNT_MAX */
+				VM_WARN_ON_ONCE(count < SWP_TB_COUNT_MAX);
+				count--;
+				if (count == (SWP_TB_COUNT_MAX - 1)) {
+					ci->extend_table[ci_off] = 0;
+					__swap_table_set(ci, ci_off,
+						__swp_tb_mk_count(swp_tb, count));
+				} else {
+					ci->extend_table[ci_off] = count;
+				}
+			}
 		} else {
-			ci->extend_table[ci_off] = count;
+			/* count < MAX: simple inline decrement */
+			count--;
+			__swap_table_set(ci, ci_off,
+				__swp_tb_mk_count(swp_tb, count));
 		}
-	} else {
-		__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, --count));
-	}
 
 	/*
 	 * `SWP_TB_COUNT_MAX - 1` triggers extend table allocation. If the
@@ -1596,7 +1622,18 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 	ci_end = ci_off + nr;
 	do {
 		swp_tb = __swap_table_get(ci, ci_off);
-		if (swp_tb_get_count(swp_tb) == 1) {
+		/*
+		 * Pointer entries store count in the zswap_entry;
+		 * handle them before swp_tb_get_count (which returns
+		 * -EINVAL for non-countable types).
+		 */
+		if (swp_tb_is_pointer(swp_tb)) {
+			if (zswap_swp_tb_get_count(swp_tb) == 1) {
+				if (ci_batch == -1)
+					ci_batch = ci_off;
+				continue;
+			}
+		} else if (swp_tb_get_count(swp_tb) == 1) {
 			/* count == 1 and non-cached slots will be batch freed. */
 			if (!swp_tb_is_folio(swp_tb)) {
 				if (ci_batch == -1)
@@ -1647,6 +1684,11 @@ static int __swap_cluster_dup_entry(struct swap_cluster_info *ci,
 	/* Bad or special slots can't be handled */
 	if (WARN_ON_ONCE(swp_tb_is_bad(swp_tb)))
 		return -EINVAL;
+
+	/* Pointer entries store count in the zswap_entry struct */
+	if (swp_tb_is_pointer(swp_tb))
+		return zswap_swp_tb_dup_count(swp_tb, ci, ci_off);
+
 	count = __swp_tb_get_count(swp_tb);
 	/* Must be either cached or have a count already */
 	if (WARN_ON_ONCE(!count && !swp_tb_is_folio(swp_tb)))
@@ -1923,13 +1965,19 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		old_tb = __swap_table_get(ci, ci_off);
 		/*
 		 * Freeing is done after release of the last swap count
-		 * ref, or after swap cache is dropped
+		 * ref, or after swap cache is dropped. A Pointer entry
+		 * means zswap has a compressed copy; the xarray still
+		 * holds the entry and zswap_invalidate will free it.
 		 */
-		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
+		if (swp_tb_is_pointer(old_tb))
+			VM_WARN_ON(zswap_swp_tb_get_count(old_tb) > 1);
+		else
+			VM_WARN_ON(!swp_tb_is_shadow(old_tb) ||
+				   __swp_tb_get_count(old_tb) > 1);
 
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
-		if (!SWAP_TABLE_HAS_ZEROFLAG)
+		if (!SWAP_TABLE_HAS_ZEROFLAG && !swp_tb_is_pointer(old_tb))
 			__swap_table_clear_zero(ci, ci_off);
 
 		/*
@@ -1961,8 +2009,11 @@ int __swap_count(swp_entry_t entry)
 {
 	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
 	unsigned int ci_off = swp_cluster_offset(entry);
+	unsigned long swp_tb = __swap_table_get(ci, ci_off);
 
-	return swp_tb_get_count(__swap_table_get(ci, ci_off));
+	if (swp_tb_is_pointer(swp_tb))
+		return zswap_swp_tb_get_count(swp_tb);
+	return swp_tb_get_count(swp_tb);
 }
 
 /**
@@ -1980,6 +2031,8 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 	swap_cluster_unlock(ci);
 
+	if (swp_tb_is_pointer(swp_tb))
+		return zswap_swp_tb_get_count(swp_tb) > 0;
 	return swp_tb_get_count(swp_tb) > 0;
 }
 
@@ -2556,8 +2609,12 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		if (!folio) {
 			swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 						swp_cluster_offset(entry));
-			if (swp_tb_get_count(swp_tb) <= 0)
+			if (swp_tb_is_pointer(swp_tb)) {
+				if (zswap_swp_tb_get_count(swp_tb) <= 0)
+					continue;
+			} else if (swp_tb_get_count(swp_tb) <= 0) {
 				continue;
+			}
 			return -ENOMEM;
 		}
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 1bb484d1ac87..58259673ce2b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1774,6 +1774,11 @@ void zswap_swp_tb_put_count(unsigned long swp_tb,
 	VM_WARN_ON_ONCE(count == 0);
 
 	if (count == SWP_TB_COUNT_MAX) {
+		if (!ci->extend_table) {
+			count--;
+			entry->swp_tb_val = __swp_tb_mk_count(entry->swp_tb_val, count);
+			return;
+		}
 		count = ci->extend_table[ci_off];
 		/* Overflow starts with SWP_TB_COUNT_MAX */
 		VM_WARN_ON_ONCE(count < SWP_TB_COUNT_MAX);
-- 
2.54.0



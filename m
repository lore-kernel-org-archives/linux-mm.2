Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37A1E9A03F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416FD6B0092; Tue, 17 Feb 2026 15:06:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CEF6B0098; Tue, 17 Feb 2026 15:06:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094896B0092; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A99BA6B0096
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62BBC8B4A4
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
X-FDA: 84455031864.05.9DF518E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51CBB140003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SIKYesRw;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
	b=Kv9cnUyQEXTvQbwFxDFwXsAVrsEClMyiV+ymom3uvAiIH9Vp4Fo4GG45K2M7hinjtxgG5k
	FyEwiXo5e5w0OacEypXTs5pSV4NXVgUGkXErmENd72wH0eF9IA9FkF64A46sfw1FFXG9ji
	r/tLj4Bzm1pYMt0ELzNV7ry0yr5IN4o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SIKYesRw;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358810; a=rsa-sha256;
	cv=none;
	b=nTBhmGJ53XG8gfMKSDxPXY4Odkze47FgGuG4WllvGDe6LFByhJ8LBSrSHZ0+1LUJw5MTm0
	5JC0sE5T4Sn/gtJb9+kgCDyP1IYx97GhVf/9+/TGbIE5bZlf5HMOXwqEPx9xhHNUZdlBoy
	Z9VtotsjjayAtQGnR3PBc1quhuAm2Fw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44EE0444FC;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2221CC2BCB1;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=kkyIO7qcZVQTh3+ze8oW5mG1QCXOTV0RvL1Yuf71ALQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SIKYesRwERy/ynLCuN07+Lfx/mJNkCuitXyQpogz+p9/HbW/CzNmmmCaW0BpKTkbb
	 13L4QYTp2J4Eb/PTCA1cH3H2ZEglfQUZxljIhTyH0y3EoIZiRIdWlX0GrtSSgtMG0P
	 gUuLQP76tlTYcDkQvBbMcnVQy7ySnjpOOO0CVyaIQPwa7OwEwftrKNFvoz1P0DVKkF
	 lJO02W8aOSWmZmZyFkYaLOQm93GuJ+jFDDapfmri5QfpMsfW4L+heTMPwAidj/oCV2
	 ED7QyrqdFsrOPbLHxyfoj9NBbhb0JsOjLTW+dueHzuRQSuE078CccGXuVKQ8fcxqNW
	 7A110n+bCN7gQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BA0E9A03F;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:30 +0800
Subject: [PATCH v3 05/12] mm/workingset: leave highest bits empty for anon
 shadow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-5-f4e34be021a7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=8883;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=FaLMbQqW7ETAqIJMdO/kAwe98yiKvc5zz/kgiu2u1QQ=;
 b=pQN1t0j6CHA2oC08LYU0OEK7PZ/8AhMXlDMi0uSE0lFxNbrUfqX68zDoPOehvXglLZdP+29Z0
 OJjVjspUFy+BUMnHkaYDcyHn6CtQtNwcg5ghVWfvg3xdEkFfJyQyj0+
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 51CBB140003
X-Stat-Signature: yau5n5jtnud1eusy9cti7kqjwue4bo3k
X-HE-Tag: 1771358810-468909
X-HE-Meta: U2FsdGVkX18Y2ILqgKUH5GU76iRJIXjDskptrsteG/00Fm3eLBJjVPJm9em+FEFANvD7l1id6oDyIMtzRPehkQRswTkZL/VXM4RiMolOZBtAgEipyP+EGovrm/qvGlGyAWKTNw45gXacqCNqyRT5dicdbkM0wIVP4rPS4V++mV7dSzk8iFuvfBgqkM+L/6jynF2qbCHPi95ATSLCvAtXfLAN8CTzlLQNoxqf4CPRSv1/1aNma0XKD+bX9q0nW1y2Bszhy3LiDvBr91Z+y4izGvOwcq0JcDSt286nKTG95XaUZh+gQv5u6VopSw9gb1Hh2cNra/ewKVPl2ScJldcWDj5HM9z/jkJOfLbUcx4kwxuN9Fu/neKKAmjQc2eaWGj7OaM843mmZbADCCK9t7HhleIqBFOzt2v6J7JzRZfdbeS6zbBDPv01KJxqpRTHKD8nUjQel9Hk9xyHoPcZsMO4tzo0nXzrD7W9+23fbLv8wIb5ChSQOCZtwpXH7al7piGYEs57bdaalhjFRRUgkSmElTceH/orPHv3auppT1880fOCwr0fCip6UW0mvXJMAY0PVm/OeWj2BWqYnKLFoOV6gG9HaXbgecSUIDFa0bRpkWL+HnVRX5HxCS02AwJN/emb34FeY2JGQJInhNg+w/ngRvMsgAok/uW5efSb31M19HR/NAAjW3+pklv9CYG9TU6zutl9RVc77qogw03KP05NkrkIZqZla83v2kdFXQ1LcCIj3ChnIPFgoVGhlJwxTmIlI8JDHB0QW84iyNM8+v/HoVbSGmGpLpaGwG/0OJ/E0vdr6THHrcL/GbIiXPaK0na0KfdAo1QmxBwHlxmCnVUQdt7SffaMO9rWosv7XUeNUHSpzU8CvHy3i8C0kgCiuYIAR5KdW0WWxBujeL4JBdC6ghb7fm5uUXhdK8Wvv55DZfikWdXXDF24gro06Gi/IjbbJjz/i+G0qSL6kzKqu/+
 t5zR6LUH
 ar488MV5+/xS4ozQMwcZ9mE/OcTqiqYo4ryzdw65/g9O37bOL57Wjv07YpWLG5qkt5yGevFPXZLygfYoHZ6IXWncWfjpgB4WmI2Sy+VoyVsKgAAvseWxlFTpCfgFj/2Beb/smNDSPRnGVUO09Tyqy5VFU5YeV3SXCC48sqFJIu+LBPG5OzX+IhRoS0wqKWgSucdXFX2NImm3S2w1ge26lYt4M8akgQCq3Fs6EOlzALer4G90OyIhtty1AEMXXe6FMRZX9X6aSXkeMJ6cDBYBaM/rfk32K4oGXxFdhGUtDxctfjxMsfcYdSfbE9ZYSU/G07u5bTlo9WqFOa2vtiLJ54qTIGHSnwC37IdkcNn1qO7p87VHFttKdqqzPWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap table entry will need 4 bits reserved for swap count in the shadow,
so the anon shadow should have its leading 4 bits remain 0.

This should be OK for the foreseeable future. Take 52 bits of physical
address space as an example: for 4K pages, there would be at most 40
bits for addressable pages. Currently, we have 36 bits available (64 - 1
- 16 - 10 - 1, where XA_VALUE takes 1 bit for marker,
MEM_CGROUP_ID_SHIFT takes 16 bits, NODES_SHIFT takes <=10 bits,
WORKINGSET flags takes 1 bit).

So in the worst case, we previously need to pack the 40 bits of address
in 36 bits fields using a 64K bucket (bucket_order = 4). After this, the
bucket will be increased to 1M. Which should be fine, as on such large
machines, the working set size will be way larger than the bucket size.

And for MGLRU's gen number tracking, it should be even more than enough,
MGLRU's gen number (max_seq) increment is much slower compared to the
eviction counter (nonresident_age).

And after all, either the refault distance or the gen distance is only a
hint that can tolerate inaccuracy just fine.

And the 4 bits can be shrunk to 3, or extended to a higher value if
needed later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_table.h |  4 ++++
 mm/workingset.c | 49 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index ea244a57a5b7..10e11d1f3b04 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -12,6 +12,7 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
@@ -22,6 +23,9 @@ struct swap_table {
  * (shadow), or NULL.
  */
 
+/* Macro for shadow offset calculation */
+#define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
+
 /*
  * Helpers for casting one type of info into a swap table entry.
  */
diff --git a/mm/workingset.c b/mm/workingset.c
index 13422d304715..37a94979900f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -16,6 +16,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "swap_table.h"
 #include "internal.h"
 
 /*
@@ -184,7 +185,9 @@
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
 			 WORKINGSET_SHIFT + NODES_SHIFT + \
 			 MEM_CGROUP_ID_SHIFT)
+#define EVICTION_SHIFT_ANON	(EVICTION_SHIFT + SWAP_COUNT_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
+#define EVICTION_MASK_ANON	(~0UL >> EVICTION_SHIFT_ANON)
 
 /*
  * Eviction timestamps need to be able to cover the full range of
@@ -194,12 +197,12 @@
  * that case, we have to sacrifice granularity for distance, and group
  * evictions into coarser buckets by shaving off lower timestamp bits.
  */
-static unsigned int bucket_order __read_mostly;
+static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
-			 bool workingset)
+			 bool workingset, bool file)
 {
-	eviction &= EVICTION_MASK;
+	eviction &= file ? EVICTION_MASK : EVICTION_MASK_ANON;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
@@ -244,7 +247,8 @@ static void *lru_gen_eviction(struct folio *folio)
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
-	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
+	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
+		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
@@ -254,7 +258,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, type);
 }
 
 /*
@@ -262,7 +266,7 @@ static void *lru_gen_eviction(struct folio *folio)
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	int memcg_id;
 	unsigned long max_seq;
@@ -275,7 +279,7 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
-	max_seq &= EVICTION_MASK >> LRU_REFS_WIDTH;
+	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
 	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
 }
@@ -293,7 +297,7 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -331,7 +335,7 @@ static void *lru_gen_eviction(struct folio *folio)
 }
 
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	return false;
 }
@@ -381,6 +385,7 @@ void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	int file = folio_is_file_lru(folio);
 	unsigned long eviction;
 	struct lruvec *lruvec;
 	int memcgid;
@@ -397,10 +402,10 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
-	eviction >>= bucket_order;
+	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-				folio_test_workingset(folio));
+			   folio_test_workingset(folio), file);
 }
 
 /**
@@ -431,14 +436,15 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 		bool recent;
 
 		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction, workingset);
+		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction,
+					     workingset, file);
 		rcu_read_unlock();
 		return recent;
 	}
 
 	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
-	eviction <<= bucket_order;
+	eviction <<= bucket_order[file];
 
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -495,7 +501,8 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * longest time, so the occasional inappropriate activation
 	 * leading to pressure on the active list is not a problem.
 	 */
-	refault_distance = (refault - eviction) & EVICTION_MASK;
+	refault_distance = ((refault - eviction) &
+			    (file ? EVICTION_MASK : EVICTION_MASK_ANON));
 
 	/*
 	 * Compare the distance to the existing workingset size. We
@@ -780,8 +787,8 @@ static struct lock_class_key shadow_nodes_key;
 
 static int __init workingset_init(void)
 {
+	unsigned int timestamp_bits, timestamp_bits_anon;
 	struct shrinker *workingset_shadow_shrinker;
-	unsigned int timestamp_bits;
 	unsigned int max_order;
 	int ret = -ENOMEM;
 
@@ -794,11 +801,15 @@ static int __init workingset_init(void)
 	 * double the initial memory by using totalram_pages as-is.
 	 */
 	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
+	timestamp_bits_anon = BITS_PER_LONG - EVICTION_SHIFT_ANON;
 	max_order = fls_long(totalram_pages() - 1);
-	if (max_order > timestamp_bits)
-		bucket_order = max_order - timestamp_bits;
-	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
-	       timestamp_bits, max_order, bucket_order);
+	if (max_order > (BITS_PER_LONG - EVICTION_SHIFT))
+		bucket_order[WORKINGSET_FILE] = max_order - timestamp_bits;
+	if (max_order > timestamp_bits_anon)
+		bucket_order[WORKINGSET_ANON] = max_order - timestamp_bits_anon;
+	pr_info("workingset: timestamp_bits=%d (anon: %d) max_order=%d bucket_order=%u (anon: %d)\n",
+		timestamp_bits, timestamp_bits_anon, max_order,
+		bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_ANON]);
 
 	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						    SHRINKER_MEMCG_AWARE,

-- 
2.52.0




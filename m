Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC6DCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F956B00AE; Fri,  1 May 2026 17:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBEF6B00AF; Fri,  1 May 2026 17:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD56A6B00B2; Fri,  1 May 2026 17:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A606F6B00AE
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E4701A02CF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:22 +0000 (UTC)
X-FDA: 84720079164.27.77473E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A2D6100007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sWQhubef;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgxBTWqOKAh8Tvtnq2FGvyiSxVNHdjijPk4ZHvtJw4A=;
	b=UYf+lkdfADw0npD47epdlFeAAHPDxhhMT7Td7LLdJRnWtBloR7I3eTL3X7e/gTC2BlFRD4
	73vG1Qr4rS4sEWNRMae9KKNuMQIwMl4xxiqZDHQw3tBvTxjXSNfIwcwvvNMCgITBxQbMcx
	6pKqVhfpC0C9nOd/kPZ6ucgTXVkKdc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669460; a=rsa-sha256;
	cv=none;
	b=H4H37hCdD5tmevuoFBYjRUSUxDouzsHVdLf2LDz1t3b8IZoE4iGXxdUpndXSa3WAS198zl
	MF8s0W+H2RjCA7gIkGHZsHKiJRdiRM2E2VM/Kvh7tqhfzrnO4RJp3AOB0YIeE5G2ZElKzX
	A6tl+8wcUDr+qSbIT74pVJpB9uKxtmQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sWQhubef;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38C2744775;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19DE7C2BCB8;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=tHaw3tfLQDdMlRkLC7d39ZVgj9socWvo29ap6QmaxjM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sWQhubefyPkGM4BWTPRy9Ywc1mFfVZImQgysH0xEuLNngQhjfRu+AiaIBOLsyV7V1
	 nnKFhSHSZn2qJboqJtZouUN/2TiEGYKfuUnaV8NHxbAJZMOfv3lKHZXY7WZq/cYZ2z
	 pKOiIwTqiJrM7Yg4lhsWbQLXdV8H9qiHaeNESV9VwRHOIvwG22h11eKXxpRgUWyR/u
	 bmgyw/643c9wWx4/4qQ9NRCmIXcu1eirs6+hoWeFLMM1eFfwkHUDFUPl3bsPqd0nRy
	 ArphTz5gDU/w0rF9V6bGrhIUUlT4kSsTHebmWqLz6SRxwgGPJSeOXJ30OWqM9TulNK
	 WkBUXlkQmXAJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103FECD3423;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:12 +0800
Subject: [PATCH RFC 26/32] mm/workingset: properly define the format of a
 folio shadow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-26-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=6409;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BHsPRvLdIXuKL3/5pLqvcCuBLzJEpjMu3hI5uV7aekI=;
 b=AcTOgAnvvy963ARcizG0u5Uont1pyDQrOxeIwl5U9ZU8DRZnP0MT4tUKr19pgaGqHDFeirdzz
 XLtUak8Rg5sBgd6KvulitmR+E8YDSYWip1TC4e5UormFnuF5hLwTJ2u
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A2D6100007
X-Rspam-User: 
X-Stat-Signature: rio7agd5wfy5t3w5grnihmxrmjgxsker
X-HE-Tag: 1777669460-687003
X-HE-Meta: U2FsdGVkX1+6MxU8XWl982f5FNXJq//9eEe8q1peBNaxGdEZ3LoArzrFqmB68E4E6MiJ0BOwTVJx4W6UrfONU0UEx9KbxLm8Ys9P5VUcPpLIIuV2YjAKMdFzlR6ySbM6KBQSQ+htDeOTDM1Z3OfeBOdZ0PR7AqOV1CGABR8NWykTdusc2IxsNIupb+UevTqCTYGkBA0DqhexwTQzfqYQpMoPAykOxJhFml/bWU7Bxs4g3K+gkOkW/JujZG3m+CO2vt3oXnFBgDVaFPfhgZAN8TOnxJmkw9Egm3NXJCQixLiObuB1ijShdEukSe0rU5nuO3YsxnRCx2m+8zo9+Ce7KxnJczFPmRgj38o3bdcxscZFwl5ZybQk+8I+Va2Hu3+zp96YuwnoOuxy2IeEh7bWo5LYNZCsE4gYg+tl+iUPVrir5BiBzZTw/u/7sg1ORJPVmRAJT6bUoonPb8pinGhh1OuTMHoNP40eoA8Q4FhuDJqhWj+MozXv2homJEIjbYFIevCm98lsdAwD2liceeAcB4q2qDfI4UKLL56jfdtiIsXvj7bL3YHNrc57pFkDm2KDdd+rgCD7Uaj3RWc2Hk3hrHjlEvXRTqjEAmUfgKUlBkHTuoiEJXkjlOjn0W5A2bVewI32Rsmndct+5NGTKMz4US6WzK0+nwPJ1G+wWeQvMLA5WgMo4sChnOyqHVQWjlZb2VnUVAhiZitWASlEGjTsQlJ+I5JsBH7HB764ZIgfm7S68NNvNKQUAuh//GZalaBKjI9VkLDJ2Bn88jZ+okxT0Vp7yDrTgnMNanyo9mTjSP5okr31/LLBxRDib5dqpUvZc2E/lTuQUqG4YWboRPG+Q++1eMdedbBPF94EahFBeWgsfb7N2/xDM5BKmKVagQ5348itOdor+bXXkU5tPlP1ePgllqV7OpHKWfh9HVuulncwrhoGNXXwhsQPRKmdbfC/PN7rayU/OmJ1nQ2JFCK
 IcVjuMr6
 9FvibdDb8jjf2F3fgFg+KtD1xSi3h07xYzuYKUSarK6RTKQhR++74rIUSv9rvZVIX2HBj8t5wuc/fKOjh4NT9EjR+PRfW2p2DiuGPSTO8uFI/Z6S+2RK63ZUR/uDy2+KihCxhOIsdNE8OPGogGjjsRAOEaBqxLuXLXpqnTDU4ZAhXfjaXa4JlNm6Muhb9zSL27EVc2UGNwMwtYMzy3y8jJgbVKo4h7Y1tuRV/nonKLur4tTaksomfNScowKh8Cn3GdiaVI+qF44S/gcRQRa+9uqjTBN8r1v/R9Uh+4gghNe6U4g/xZHJMTUyXvkNAtPNc19FhxkMWoCcAGfZSotgyntu9qtrNXsodHccyEgoWb/1Z5nqE5LCnm8FaqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The shadow of an evicted folio can be roughly divided into two parts:

- The common and mandatory pack info: which contains the memcg info,
  workingset bit, and pgdat.
- LRU specific eviction info: which is a "timestamp" for Active/Inactive
  LRU, and generation sequence for MGLRU.

The common pack part is the same for both Active/Inactive and MGLRU, and
the data stored presents the exact information. Meanwhile, the eviction
info part could be truncated, which is OK since the eviction info is
just a hint for LRU to determine what to do with a refaulted folio, and
in the worst case, only has a limited effect on the system's
performance.

Add some comments on this, and consolidate the macros for these two
parts.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/workingset.c | 61 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index b472ac34943e..622e00ac28b6 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -184,13 +184,35 @@
  * refault distance will immediately activate the refaulting page.
  */
 
-#define WORKINGSET_SHIFT 1
-#define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
-			 WORKINGSET_SHIFT + NODES_SHIFT + \
-			 MEM_CGROUP_ID_SHIFT)
-#define EVICTION_SHIFT_ANON	(EVICTION_SHIFT + SWAP_COUNT_SHIFT)
-#define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
-#define EVICTION_MASK_ANON	(~0UL >> EVICTION_SHIFT_ANON)
+/*
+ * Active/Inactive LRU, MGLRU have different info embedded in the shadow.
+ * Shadow format:
+ *                   /     LRU Eviction Info    \ / LRU Pack Info \
+ *                  +----------------------------+----------------+-+
+ * non-MGLRU:       |SC|   eviction timestamp    | NID | MCID | W |1|
+ * MGLRU:           |SC|     seq number   | refs | NID | MCID | W |1|
+ *                   ^                              ^      ^    ^  ^
+ *    Swap Count (anon only)  NUMA ID (NODES_SHIFT)-+      |    | XA_VALUE
+ *          Memory Cgroup ID (MEM_CGROUP_ID_SHIFT) --------+    | mark
+ *                    Workingset Bit (WORKINGSET_SHIFT) --------+
+ *
+ * Shadow is a XA_VALUE, 63 / 31 bits are usable.
+ *
+ * The LRU pack info part is used to identify which lruvec a folio was
+ * evicted from. This part is always accurate so we never lose the
+ * basic track of faults on each lruvec.
+ *
+ * Eviction info is either a snapshot of the `evictions` counter of an
+ * lruvec when the folio was evicted (lru timestamp, for active/inactive
+ * LRU), or the min_seq number when the folio was evicted (MGLRU). This
+ * part may have shrunk, so we may get inaccurate info, which is usually
+ * fine and could be tolerated.
+ */
+#define WORKINGSET_SHIFT	1
+#define LRU_PACK_BITS		(NODES_SHIFT + MEM_CGROUP_ID_SHIFT + \
+				 WORKINGSET_SHIFT)
+#define LRU_EVICT_BITS		(BITS_PER_XA_VALUE - LRU_PACK_BITS)
+#define LRU_EVICT_BITS_ANON	(LRU_EVICT_BITS - SWAP_COUNT_SHIFT)
 
 /*
  * LRU refs uses LRU_REFS_WIDTH + 2 bits, the 2 bits are PG_workingset and
@@ -212,7 +234,9 @@ static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
 			 bool workingset, bool file)
 {
-	eviction &= file ? EVICTION_MASK : EVICTION_MASK_ANON;
+	BUILD_BUG_ON(LRU_EVICT_BITS_ANON <= SWAP_COUNT_SHIFT);
+
+	eviction &= BIT(file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON) - 1;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
@@ -257,8 +281,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	unsigned short memcg_id;
 
-	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_BITS >
-		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
+	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_BITS > LRU_EVICT_BITS_ANON);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
@@ -284,7 +307,7 @@ static bool lru_gen_test_recent(struct lruvec *lruvec,
 	unsigned long max_seq;
 
 	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_BITS;
+	max_seq &= BIT((file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON) - LRU_REFS_BITS) - 1;
 
 	return abs_diff(max_seq, token >> LRU_REFS_BITS) < MAX_NR_GENS;
 }
@@ -512,7 +535,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 */
 	eviction <<= bucket_order[file];
 	distance = ((refault - eviction) &
-		    (file ? EVICTION_MASK : EVICTION_MASK_ANON));
+		    (BIT(file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON) - 1));
 
 	/*
 	 * Compare the distance to the existing workingset size. We
@@ -781,12 +804,10 @@ static struct lock_class_key shadow_nodes_key;
 
 static int __init workingset_init(void)
 {
-	unsigned int timestamp_bits, timestamp_bits_anon;
 	struct shrinker *workingset_shadow_shrinker;
 	unsigned int max_order;
 	int ret = -ENOMEM;
 
-	BUILD_BUG_ON(BITS_PER_LONG < EVICTION_SHIFT);
 	/*
 	 * Calculate the eviction bucket size to cover the longest
 	 * actionable refault distance, which is currently half of
@@ -794,15 +815,13 @@ static int __init workingset_init(void)
 	 * some more pages at runtime, so keep working with up to
 	 * double the initial memory by using totalram_pages as-is.
 	 */
-	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
-	timestamp_bits_anon = BITS_PER_LONG - EVICTION_SHIFT_ANON;
 	max_order = fls_long(totalram_pages() - 1);
-	if (max_order > (BITS_PER_LONG - EVICTION_SHIFT))
-		bucket_order[WORKINGSET_FILE] = max_order - timestamp_bits;
-	if (max_order > timestamp_bits_anon)
-		bucket_order[WORKINGSET_ANON] = max_order - timestamp_bits_anon;
+	if (max_order > LRU_EVICT_BITS)
+		bucket_order[WORKINGSET_FILE] = max_order - LRU_EVICT_BITS;
+	if (max_order > LRU_EVICT_BITS_ANON)
+		bucket_order[WORKINGSET_ANON] = max_order - LRU_EVICT_BITS_ANON;
 	pr_info("workingset: timestamp_bits=%d (anon: %d) max_order=%d bucket_order=%u (anon: %d)\n",
-		timestamp_bits, timestamp_bits_anon, max_order,
+		LRU_EVICT_BITS, LRU_EVICT_BITS_ANON, max_order,
 		bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_ANON]);
 
 	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |

-- 
2.54.0




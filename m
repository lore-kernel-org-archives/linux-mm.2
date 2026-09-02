Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B47C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3454A6B008A; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7026B009B; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC9E6B008A; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF85A6B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DA63C0144
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:03 +0000 (UTC)
X-FDA: 85168353606.01.5C607BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15B07C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n8Ny8sNa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmG0CQzJePsar5gwB3xekgBqOdm/C26FgJRtjKQ+zDg=;
	b=RL+qnJofd2pyhptsqc25KAPk+B/Dy0dvOxT7NxvR3R9ZfRRAIzvZ5BGhiaB7p0TrWdEN3X
	HYslHjV/cnV4A+v8FYvi24PE2TjhkzqNl0xEsuJ4rDA/6ZcUj670GbW5KGeSk/Rv0J8dot
	k0LtWp1mDIMpbj3yWC+SGMNty1FpJ4M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n8Ny8sNa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342661;
	b=0fU6PolevOcoQbSdLuXaM7Cl/JsWdc61YzjGpIQlXeVUm4OkCaRAzuJUDKEd6lUAVLMW8C
	Rmx1zgKYu7wN85hhhqp7RvqXiPz0vLO4UQrQXDv4TRTpiX5RVcBx5NVL43wZCTFDAL4m39
	JU7Arj4yADclzD+AgMc//Vb9UCsSKTc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1254043F82;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF483C2BCFF;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=jG5UqbWsyVbezkV41xqUdAasSe0ofR2mWRBqrf7A6ds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=n8Ny8sNadRoXZc1wZGhOxdbronaGepGQlLo1lE03Ymq0POBsCcq18MZ8UMFTuRjoh
	 nHd8AQMUrSFPqsBHIEfg88ph2KM+e1L5Vaze8EK7Mdo7QsIqlxOm5+Zmo86xDGe9EH
	 7azDIaN1BYKJSb+dmH9lNibWguBvmF56DkksY7yE6MXRkNlJQNlN3Y7WscggY+GITH
	 IOM/OrK2cvwY2sc2SKjnnV9j8VY3+r4IVL3X3jGweHIpAVvrvQ28zXM6Jw7FiAHS9o
	 ljx0MOPV/Ay34uLpb3GoP9CUQ9I9u8fh3SoLW9JPMYhIxRhT455j1wnyqAnrifoGg+
	 SOxtHgnuzhZ6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C939EC624D5;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:55 +0800
Subject: [PATCH v5 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-2-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=12787;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zxYuxsra7NFMR4nkZh6H9MzBo2geXOCAuVHC5Rnh0Mc=;
 b=mXppRTYUV1N75361XEkMMew93aY2VH4XNSoJQWgx3GqkmrehcYsOhUrwBEYGUx8feLKOvANGK
 3ZcaODNft2zDzbrWYv30B9Kxi+a5nWf8DKduc/+8gkwiPLhrZUTrI8r
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 15B07C0002
X-Stat-Signature: 1uoixh7ofnzfk3k6kz474xaydeyoo6q5
X-Rspam-User: 
X-HE-Tag: 1788342660-816667
X-HE-Meta: U2FsdGVkX1/Aa8tWhtJmmtfLdBBhpeByyVMKeGqjPHQHDfCEUDSR1ySRXW2IR0HBXCVDl4T4hPFlQJLK4Ry9Bhq7Rg6tTlxbTNVpOTVU7PYX5DkrGt30LQMINAv7lTM0JN8zq04hAkdYzjL6NW4tDCs4XXEVXzxE2+ny35KscyMR5pY/vZaN2BDcLhZWnKXpNOejELJLgmJR6VEFfTbZGmPzZzXwfXAMtVO5YwEj7DnvWO1T2Qbi3/f0EhjQUKqXSrlt05zZeMqtS6dus2mKxEUSShECR75BX6Js+X8TG+ZkGIRvgbz6M0wCujvN+8wyPtro6Hms7Qt2DVBR0OwwdPsLhSMpYfVYecsPx/e8+Bk6NImsH3BU66wjGsE8R5aUh3/wphiJPcUpBLDr9bcPLPjH439w3E+jAppJA1wBFvD29cFCCxT+zkOH4tPZmbxQFaBsOroObin/jkUS6q5UYNHrVaslZjiYk9bVN9zakXTnDlJ2l0wzqX/SBmqHqRyR2/jZ7/4GXZl/3fWaY053qVp7Kj2aZKCkNXkjlfMj8a5Mb+YcvR/HBG09GvYsJai0fic2ah3NMhD0L9EoEE5Nh1ncoXlQKdYAcYcGtGAWq7qH3fudrmZXq+qtCJk2qCtHQmpOGk1jtQEJe14n8p4fPpTd7UCISfbWltigu9n38MAeOsMsCfmeSgeaqC5aTTjKjGiI8H3l06sC7AIKhC58huLGpWv+Zx55SCJUj11jh5yNPDoZxwE9x/CCgKOB7uYCw1bq7o7Y0Iz17P/NxjsjBOVaKv9SGa2nL1pZJEjeOHtWk3wZz96FF9lk0krsdd57ARpzKPN3G5/KUQI1LBElEhDbLx4b2ggV57sz23ZpRYSMPYuwo+5WKcdBZcHuoZYLFkD2FAAAfZM9Q/1r+LHLM/eZMoZ59H4YmtCXF7UU8O78Eh5wr5emJ0u7CpmnhpZfyOrFxqrc7QF6uZnPw0c
 uIqd9I0m
 tXLeb4jnNfHHL0loSDZWfRLGyJPMWoyghGIumpnHe2MgclEusSY/b8nU5e4uVJp77DrrZ5n5fbB5V3A/fweoRmtFW3Eh+KRkL7T1PvJmW1bgPnb5gvvj2zz90TZxMAsAHTOS3+sruebg+LM9AM28lcQ0LuJqM3/fPtYdNbgIjgUqA8FK+Enbeueuq1tqJ8rMZYIAkdT+xumoyHlTtXLoDqgBR1UWb7uz8blnkKs7YUI3hJ0xGPDGwNu/rAUn8sq8pY1EwIee6i+J1SaKTQ0kD/RIFdbhFVNTvC/kxyM9w1kwpbDPv5JKGPkDieC3p6CqMWXg/bK4sEhpNyy23+CO61bMl2AfY1vzW4uhU8p5qhjgp+B8RlOXSaVMqaK0LpNwZgV3XXmfEeQz49l3FNjhnCefy2J54I4QhjnhUtber+P2RPhVYi5rsdXuEwbkhuRpQKOtmMH3tAg2pGUes3NCBoTEO2UJE5+KaoeLy1TglkHc+2fYZmA2o9bXTKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of doing bit ops on folio->flags.f, introduce helpers for
adjusting a folio's refs and generation info, making the code easier
to debug and understand.

No functional change is intended: some combined atomic operations are
split into two, which only creates harmless transient states. There is
no measurable performance impact, and some paths even look slightly
better in the generated assembly.

Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 84 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/mmzone.h    |  1 +
 mm/folio.c                | 19 ++++++-----
 mm/vmscan.c               | 61 +++++++++++++++++++---------------
 4 files changed, 122 insertions(+), 43 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..3f4bd5b02b54 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -142,10 +142,66 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(const struct folio *folio)
+/**
+ * lru_set_gen_flags - Set the LRU generation number to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
+ */
+static inline void lru_set_gen_flags(unsigned long *flags, int gen)
+{
+	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
+	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
+	/* Store gen offset by 1, zero means the folio is off-list. */
+	*flags &= ~LRU_GEN_MASK;
+	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+}
+
+/**
+ * lru_get_gen_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_get_gen_flags(unsigned long flags)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
+	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
+	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
+	return gen;
+}
+
+/**
+ * lru_set_refs_flags - Set the LRU referenced count to folio flags.
+ * @flags: pointer to the folio flags
+ * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
+ *
+ * For MGLRU, PG_referenced holds the first ref, and the extra bits hold the
+ * remaining refs. For classical LRU the extra bits are not used, so it can
+ * also be seen as the refs count never exceeds 1. In both cases, refs == 1
+ * means PG_referenced is set and the extra bits are zero, and refs == 0 means
+ * PG_referenced and the extra bits are all unset.
+ */
+static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
+{
+	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
+	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
+
+	*flags &= ~LRU_REFS_FLAGS;
+	if (!refs)
+		return;
+	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
+}
+
+/**
+ * lru_get_refs_flags - Return LRU referenced / access count from folio flags.
+ * @flags: folio flags
+ *
+ * Reads the LRU referenced count set by lru_set_refs_flags().
+ */
+static inline int lru_get_refs_flags(unsigned long flags)
+{
 	if (!(flags & BIT(PG_referenced)))
 		return 0;
 	/*
@@ -155,11 +211,24 @@ static inline int folio_lru_refs(const struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(const struct folio *folio)
+static inline int folio_lru_refs(const struct folio *folio)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+
+static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+
+	do {
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
 
-	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }
 
 static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
@@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
+	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
@@ -295,7 +364,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	/* for folio_migrate_flags() */
 	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
-	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
+	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
@@ -339,7 +408,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..c9ecf370cd9f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -497,6 +497,7 @@ enum lruvec_flags {
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
 
 /*
  * For folios accessed multiple times through file descriptors,
diff --git a/mm/folio.c b/mm/folio.c
index c02dcea9c03c..fb874fe492b2 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
 
 static void lru_gen_inc_refs(struct folio *folio)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int refs;
 
 	if (folio_test_unevictable(folio))
 		return;
 
 	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+	if (!folio_lru_refs(folio)) {
+		folio_set_lru_refs(folio, 1);
 		return;
 	}
 
 	do {
-		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
+		new_flags = old_flags;
+		refs = lru_get_refs_flags(old_flags);
+		if (refs == LRU_REFS_MAX) {
 			if (!folio_test_workingset(folio))
 				folio_set_workingset(folio);
 			return;
 		}
-
-		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_refs_flags(&new_flags, refs + 1);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
 static bool lru_gen_clear_refs(struct folio *folio)
@@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	if (gen < 0)
 		return true;
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
+	folio_set_lru_refs(folio, 0);
+	folio_clear_workingset(folio);
 
 	rcu_read_lock();
 	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fdd13299a04a..24d09711e820 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
 		/* Activate file-backed executable folios after first usage. */
 		if (is_exec_file_folio(folio, vma_flags)) {
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+			folio_set_workingset(folio);
+			folio_set_lru_refs(folio, 0);
 			return true;
 		}
 
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return false;
 	}
 
 	/* Promote on second access */
-	if (folio_lru_refs(folio) > 1)
-		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
-	else
+	if (folio_lru_refs(folio) > 1) {
+		folio_set_workingset(folio);
+		folio_set_lru_refs(folio, 0);
+	} else {
 		folio_mark_accessed(folio);
+	}
 	return true;
 }
 #else
@@ -3266,11 +3269,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int old_gen;
 
 	/*
 	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
@@ -3279,20 +3281,24 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 	 */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
 	    !is_exec_file_folio(folio, vma_flags)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return -1;
 	}
 
 	do {
+		old_gen = lru_get_gen_flags(old_flags);
+		new_flags = old_flags;
+
 		/* lru_gen_del_folio() has isolated this page? */
-		if (!(old_flags & LRU_GEN_MASK))
-			return -1;
+		if (old_gen < 0)
+			break;
 
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+		new_flags |= BIT(PG_workingset);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+	return old_gen;
 }
 
 /* protect pages accessed multiple times through file descriptors */
@@ -3301,21 +3307,20 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		new_gen = lru_get_gen_flags(old_flags);
+
 		/* folio_update_gen() has promoted this page? */
 		if (new_gen >= 0 && new_gen != old_gen)
 			return new_gen;
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
-
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 
@@ -4716,7 +4721,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -4932,8 +4937,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		}
 
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
+			folio_set_lru_refs(folio, 0);
+			folio_set_active(folio);
+		}
 	}
 
 	move_folios_to_lru(&list);

-- 
2.55.0




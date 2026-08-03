Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E53C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173AF6B0095; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A986B0099; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039226B009B; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6F0A6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47BE3A07DB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
X-FDA: 85060992492.23.6369BB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3FAE8C0009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLCl9gKu;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786444;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibiMREw09YhIpxwVTj2fcvaS5TdMf/A/Keqi1G3zH+s=;
	b=rBekKgtKBJuFkmBYsZbfuCosMTlGaLpJTBQTpAMQC4AqFhYaC6DK2Bj04+AWc2FoAVvouH
	mPctTdyJHBvFW6RIDIdK+Camwkhg4+7u/Gkf9lHaraX2bYXbDcFi/Y/RFq3rfdhgM6z3vO
	eAp5M/6FJERRFHrFuCH+Wk7Yk3VD044=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLCl9gKu;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786444;
	b=auF/olgPwCZb5v8RjR/C8S67lOOTN/s0VJwuXV5/TvB/URjv6OvgxDPLSdDYEZ10GNE2Sj
	vqbSH4/YYHaghn2pCs2GNpYPXXgfxfv0zN6MoNT0ULItIhoCxP0tEI8qG7r6fGnZCmhvpq
	aDYpcHcYqDdBe6BTYtqv4I9tda/xqn8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFB6643E8F;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70D35C2BD01;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=FNUTYJ+a+7ODLOGzOoW6j4FqgHRc+4ZX4B7EJpjWRyU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OLCl9gKuH/4x/H5dhI5afXs7bdIYFItM6PKprk3rTJJbTj86fp8bcSKrbUewdDdUM
	 xhPEYivmGbsGCKHIFeZVEPEH+0TK+XTuDOzkB2EwEvhi3YPnnmOk9sjQTm2PcNnYcP
	 jMjppwii10+nNyETaX9qTgiRptPJe57z5PEMAmzqVFNU2DllIis3WDHkJF+sFjCTEs
	 hdgw9yvlmcXxZJ3UBZksT/iA+c+ofNjtZ5U0g2U2OFGwPnxjkoP+cFDucQ2bh3jQdo
	 PgPXUqDR4SbMcQnS8MNtWTp01TqOe96skJg1hj7tPEzCoPXxtefHRumMWODtDA7l7O
	 AH7n4sLMAxQfA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52579C55196;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:46:59 +0800
Subject: [PATCH RFC 03/15] mm/mglru: introduce and always use helpers for
 manipulating page flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-3-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=13228;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=j32su+iOIBqsw3MNs5eaPY0pZ0cjNkd2GlGBsSoBXBs=;
 b=23sX+FLqku/fL+mFJbJV6+sZUakmQeoahPbxBx/yHOVrlQz7z5P1g1FK6gtGQRbjVH4Ml8WCq
 1A2/BR9mDJMCAceZpoBxrrfiazVFmdXq+GG59v4qO356e8pH6hCQcVw
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 3FAE8C0009
X-Rspam-User: 
X-Stat-Signature: wg7x6ctwq7ykh4kux8cpigjajs7xf1cy
X-Rspamd-Server: rspam04
X-HE-Tag: 1785786444-889583
X-HE-Meta: U2FsdGVkX1+Sdx/AbRJ2Vd9bcr4k+sCaUm9RBA4sevz/awo4pFYsDEFiTi41+ZkFSERnSIlRkwHUw6OKZTLHPO9YgSMHKUbofiB5m9EwMKb/TBMgh+5GdDYPBR/SF/PNmhN8g52F/1Rfp8RXIViuiSz0Vmr6+KO5B9r1+AKzN+RkfCtbRuKOLt7l2VWpReU1p0WVGK+2ZoncXCgOVcpMLHhsp5DB0x6C0u/W65J7W5GPOQTyOBVpkGQECeXAj6s5UK+hBWqk7h/D40o1t96SCnS0pK//g8dspOcRdV4LrPDBeLYk7S98TdRrXHfzqdzYX/B8UyHf7shExGuiUjk+GDomoVgyK0ULPP5nOPJHzh7PVhbhTIdJMZhp89w8MDRWPb0uv+XWzzYIeRDpHqmcVPgQOIyT4JWIFisp2+G0YZc3jRDMMLekwwmXGby6jUH5sBmDeJ+0UBunsVUEEnzAqbyzwsHKoMbxJ4zGv/ZsEAfgpuJKtMYpnMsPUIt5QbcgK833gZzblu2LUq5/mdGgofuarzzLW+gSDxbDPRf6/xZtPd3nlMlnbhM7dhzb6ArMplDyXJD95BlzmEMo5z9qQiopwIeQMpeUadZJ/YmkpLpiubSSD2Bfo0pZIezz67aXJGQ8d1KYXGTVfAgvoK/2dTHWYOtDWR/q+PQmdleHjBm0vtY0iybDt1IgBwMsQr8nqVCfY/FbNTd4W6BmxhAHrgP2oWxdDWRN/2YQFY7iGXJ6+66+NCVXSeCBkWjLcYV5WruWCD76oLEf0DeKk578i4pZgPswY6wRJsdCpfNL2GmAwLVW2rrA/HnOB4Tmu03RBgO9Q0FIwfW42wM55o/0ja1y9dM5GxrVhqd+PjETiICbcGEtER+yf6JY2mO9IxABKeRiED5zP2eYJURBVsAvR3H6juLMf5rSr1qXP8O/AA6nUNqF6PyDPb5QaDjafrE+VGZFXrBmgjWzdJUJ1K5
 NtYntwqP
 sW6kP1G4QK+Ba6yFwAtWh1vgAQ7qzKUfuY7tGBxGdNnqOxzv9IsmliV8+QR0mQm/Iblge9CArKu8bYCuP82IrLv2goCi8bLhKleqe6y2aZY7kqt2cl1Eg/Y88UqczKGYVreO6oFyvQ4YXNgV6uYa0sMROF5MwfSVDJWEZt4whedP4goyM8iGkzl1wuQz8PEYcRm7tr4a9cedasAA5N0jacywmwxJ3xfqPj1ELt6dPC8qPphgjx7Ennu9pwEmHekPomzcwjpzxplUZz5SNrn38IkxGDFpoJXVBMRF+VM+hOjMT8nCYXFr4WEzyy3VjZ2LERLP2VzAQG/YqryBosF/p+Rq0cNf2Vc8wGliHmwXnLStmYFDAfmNT9ggCjg/ke5Yfy1lS819EAzauz7DH5y2uYc4E0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of doing bit ops on folio->flags.f, introduce helpers for
adjusting folio's refs and gen info, make the code easier to debug and
understand.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 83 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/mmzone.h    |  2 ++
 mm/folio.c                | 19 ++++++-----
 mm/migrate.c              |  2 --
 mm/vmscan.c               | 68 +++++++++++++++++++++-----------------
 5 files changed, 122 insertions(+), 52 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 3ad1619ce8ca..4076e3f7dcc8 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -141,10 +141,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(const struct folio *folio)
+/**
+ * lru_gen_from_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and LRU_GEN_MAX, inclusive. Returns -1 if the
+ * flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_gen_from_flags(unsigned long flags)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
 
+	gen -= 1;
+	VM_WARN_ON_ONCE(gen != -1 && gen > LRU_GEN_MAX);
+	return gen;
+}
+
+/**
+ * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @gen: generation number, between 0 and LRU_GEN_MAX, inclusive.
+ */
+static inline void lru_gen_set_flags(unsigned long *flags, int gen)
+{
+	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX || gen < 0);
+	BUILD_BUG_ON((LRU_GEN_MAX + 1) != MAX_NR_GENS);
+
+	*flags &= ~LRU_GEN_MASK;
+	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+}
+
+/**
+ * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
+ * @flags: folio flags
+ */
+static inline int lru_refs_from_flags(unsigned long flags)
+{
 	if (!(flags & BIT(PG_referenced)))
 		return 0;
 	/*
@@ -154,18 +186,46 @@ static inline int folio_lru_refs(const struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(const struct folio *folio)
+/**
+ * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
+ */
+static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
+{
+	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
+
+	*flags &= ~LRU_REFS_FLAGS;
+	if (!refs)
+		return;
+	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
+}
+
+static inline int folio_lru_refs(const struct folio *folio)
+{
+	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+
+static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+
+	do {
+		new_flags = old_flags;
+		lru_refs_set_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
 
-	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }
 
 static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
 {
 	unsigned long max_seq = lruvec->lrugen.max_seq;
 
-	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
+	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX);
 
 	/* see the comment on MIN_NR_GENS */
 	return gen == lru_gen_from_seq(max_seq) || gen == lru_gen_from_seq(max_seq - 1);
@@ -269,7 +329,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
+	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
@@ -294,7 +354,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	/* for folio_migrate_flags() */
 	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
-	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
+	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
@@ -305,9 +365,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -338,7 +396,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a26c8b855222..8048c6b0544d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -496,7 +496,9 @@ enum lruvec_flags {
 #ifndef __GENERATING_BOUNDS_H
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
+#define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
 
 /*
  * For folios accessed multiple times through file descriptors,
diff --git a/mm/folio.c b/mm/folio.c
index a9e328c3f21b..f90b7f86dbe3 100644
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
+		refs = lru_refs_from_flags(old_flags);
+		if (refs == LRU_REFS_MAX) {
 			if (!folio_test_workingset(folio))
 				folio_set_workingset(folio);
 			return;
 		}
-
-		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_refs_set_flags(&new_flags, refs + 1);
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
diff --git a/mm/migrate.c b/mm/migrate.c
index b937cbd76480..c737d0682fa4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -779,8 +779,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fe7cf5d42e0c..f5b0a7c63a3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -842,19 +842,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
 		/* Activate file-backed executable folios after first usage. */
 		if (is_exec_file_folio(folio, vma_flags)) {
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+			folio_set_lru_refs(folio, 0);
+			folio_set_workingset(folio);
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
+		folio_set_lru_refs(folio, 0);
+		folio_set_workingset(folio);
+	} else {
 		folio_mark_accessed(folio);
+	}
 	return true;
 }
 #else
@@ -3260,11 +3263,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
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
@@ -3273,20 +3275,24 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 	 */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
 	    !is_exec_file_folio(folio, vma_flags)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return -1;
 	}
 
 	do {
+		old_gen = lru_gen_from_flags(old_flags);
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
+		lru_gen_set_flags(&new_flags, new_gen);
+		lru_refs_set_flags(&new_flags, 0);
+		new_flags |= BIT(PG_workingset);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+	return old_gen;
 }
 
 /* protect pages accessed multiple times through file descriptors */
@@ -3294,22 +3300,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
+	int old_gen, new_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		old_gen = lru_gen_from_flags(old_flags);
+		VM_WARN_ON_ONCE_FOLIO(old_gen < 0, folio);
+
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
-			return new_gen;
+		if (old_gen >= 0 && old_gen != min_gen)
+			return old_gen;
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
-
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_gen_set_flags(&new_flags, new_gen);
+		lru_refs_set_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 
@@ -4712,7 +4718,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -4930,8 +4936,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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




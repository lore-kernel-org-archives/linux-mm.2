Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5223C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7616B009E; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4EB6B009D; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655366B009E; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFAE6B009D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE42012079B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:28 +0000 (UTC)
X-FDA: 85060992576.05.557E31D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A5C9340007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJliByqC;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4S8OXShQhED8a8iv4Vh8neYDFc5UopVaNZm5S7fELE=;
	b=uW73BBfBntISqokcrgzOL8V9w1Kuk93UYkP5FeALByWg8rjpMJYieBZLvntMf4eyESYGAq
	hKHfaUp9lcsMrQCdjGdUJXGroDOZCge8Bjwzk66Z8+rO8BTdInYqJa6+X+9SNxyCqpVdqJ
	rWofHkhn4HD0vpTqr9lvd00MLxrkMCg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJliByqC;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786446;
	b=CK/Vz13yENOuDTheojDGSSyu/Zyh/E6R/01EVHuNhdSZOcZawEqM4s8PlvM0ehJTG/Ajra
	oIV1AyKr5uCW4csM6sGn+SiejqpuFuiSkaXANXBgLYVPCzdwGaRDRVfWUR/qSSDB4MYyLL
	VN0iIaBdPeeTm/AsDy3O8X4eYePZqhU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A26F4505A;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16D94C2BCFA;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=5Spxi6AE7pqNpQLt2qla4NEl4WlMj9DJOAfIyYr9o9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pJliByqCy5ody7eU79GVRSPSk+eexK73f7T9s2SBA49hSB0o4C8OvJINOuOy/0Jst
	 Zf5hdfZyM3BmdZVlhGa9zwvPZ1qDpxZajvv36UNiDD9+TQyCF1PF3iKIS1IRw58cEH
	 S1jWRFCCHZPkg9acN8GoaJYbQsmHXUvnFfAvmigjHZ72t6HDzavzGxtQJdRuRutMuI
	 rit3kvALB2TShQJNLsrks/iT+tefbNu+yb5c9/D8oiZCntRW+LBOYSasZJZWzBXP0R
	 2Wwz0shzNISUK1tDmHAqLUyuj0SooD4iiZRQSuup57dcIK3OXX/Bcpz2Hvd6o03mc+
	 f8U0t7cC5Gh4g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0079C55196;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:06 +0800
Subject: [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count
 a generic API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=9394;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pavYdhuAU5OwgfCxwjbABkIxiu5hT6fbcrjm/x7ACsw=;
 b=d3wg6Yy52t36UmlNDlDQoCaeid1WRHhSSSH1k9fIA07ImY/PrYXUV4Ynfyh44gvYQPVityi4D
 GpazfrxHVV0APh8Tm1fpf0blBikgvUg/l5TmvuUwYEJSj4j9ENJVudp
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A5C9340007
X-Rspamd-Server: rspam01
X-Stat-Signature: ao9nadroa51shkkrf4by7yumkwswiis8
X-HE-Tag: 1785786446-135378
X-HE-Meta: U2FsdGVkX1+1b3jJ1pNbagLDX0z94a+TD8rwixxSDCkE7pTvEHYCbyrgucaimkkXnQyq+CL/yeAe0QwsMbj4bxGuIFBQAX/OxOcnKR2euEvz33imY57ytqC8uvIckdlMFga4ew0yYfavd1Wq6t+BC3hCU4XTOxoH8NNH7JSStGUTm/lquFSKX/Oxjl3TBbqKabiBv7qQL0dNN2Cju7Bt+irvmrDgXo8ySObh9P4QO/RtnnnH5M7CAQOmccThTomffucYaU5hVol3P3o1bckUM1Mi6dTK6VYvrmzwgJqo/iLoYYzjpDuHc9zMWRDN+hA3Sc5iaxTgT3IEU7kuamVB4W+BRrHx5q4UB7rsYAZ2Pus/e+DyMdFeZQZgA+A0xwzS4nGF8PsEzH8drPT3A9QE+E5FWrbUuYGyx/o042DdfupIustbo88pndpMdLonur/PqWGWC9lPezVgHxWevCzhYSVNAnnRsqijE9TBWosr7QeTKEnI8xakPMGmLsNS3zO6KidsQTC5DJP/uDNd24e4GY8yK+EQU0lg/nY+JgrmxegM2tU0YCWM9Y28YtTXOZrL06wIMXH+CHIe5vvQOboCGuZSC2epV3nhkIQZLCSiWePVv+kBiwszrWRftnFrnMl95dCWxEZLXjXnA5ykcrj0+g/71M0wtDmYy6xyxcfBn3yp/Ydo9LkmvWyv7x66wAl4taZZ8OQxNCH3mbGiEhdWvLYYK0QudZ58E08aH0gXtTDHa/QjTZnnBRpnR90qERBwxrW/wiXSMBR6QwLVaKu7yUUUVf1e4XzDW/crruZbudkSb4kTgKEhnsZqEzKinJ3KHaJl93ZkNkuyNlriL0d7PUBR0juMqdkXeVXP2xUyUUE2gtS61tbTj4TqKeKX81jHmwbgHRRyfxoxH42lOSnHzBFJ3DfD+VsdYysgG6jP2mOHY6Jf9eo5UOHT8SGlY60QK95u0IogNnuXekF3iMB
 unamSueW
 gjRw3lSBaOH2VKl2XzZeumFoHjqee+Du4S4AnkqwiwvbF84GelKe4t9ffNktQne0EXziAOjEl881+12+v/9qsB3fFr7Bhdn9CK3RxaM6ZdPo1Agq7vVii381j9uGliUHyNT5ROPyb1ueqCoeZ9Mj8lYqgnr4El8hI9LiMzKqdzF8XveSSaJr1tRLNWQ26XNic01GakrsugIQO4mTAly+B68KDZ754brEjrWPf27A9y+a1b/wNBJ7UHpAVUEQM4d5skO4XAIyjuA+Xz0HlgBDpKBBRoPeVICWLYvtEXuupB9ZUblZw8xhjGqhaMEyNe9xsGvfU2Lbi1nIOBiEQAEcbof7srzZRUVLN/twMLD9L1oCd2ng+SSyGqrggzFkBwQqgzBr5J1X4I0oggqeoQGXkciYuzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for unifying the API for checking folio referenced status,
expose the referenced times counting as a generic API. For MGLRU this
helps to adapt other subsystem based on the referenced times counting,
for non-MGLRU this is still bitwise compatible and there won't be
major behavior change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 233 ++++++++++++++++++++++++++++++----------------
 mm/migrate.c              |   2 -
 2 files changed, 155 insertions(+), 80 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 944baa91bf18..a13b7d3c033a 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -94,6 +94,161 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 	return lru;
 }
 
+/**
+ * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
+ * @flags: folio flags
+ */
+static inline int lru_refs_from_flags(unsigned long flags)
+{
+	int refs;
+
+	/*
+	 * Return the total number of accesses. Also see the comment on
+	 * LRU_REFS_FLAGS.
+	 */
+	refs = (flags & BIT(PG_referenced)) ? BIT(0) : 0;
+	refs += (flags & BIT(PG_workingset)) ? BIT(1) : 0;
+	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
+	return refs;
+}
+
+/**
+ * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
+ */
+static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
+{
+	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
+	BUILD_BUG_ON((LRU_REFS_MAX >> 2) > (BIT(LRU_REFS_WIDTH) - 1));
+	*flags &= ~LRU_REFS_FLAGS;
+	if (refs & BIT(0))
+		*flags |= BIT(PG_referenced);
+	if (refs & BIT(1))
+		*flags |= BIT(PG_workingset);
+	*flags |= (((unsigned long)refs) >> 2) << LRU_REFS_PGOFF;
+}
+
+static inline int folio_lru_refs(const struct folio *folio)
+{
+	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+
+static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+
+	do {
+		new_flags = old_flags;
+		lru_refs_set_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
+int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec);
+
+/**
+ * folio_is_referenced - Tell if a folio was accessed before.
+ * @folio: the folio.
+ *
+ * This helper currently only works as intended for MGLRU, as it checks
+ * all LRU_REFS_FLAGS. It might be fine for non-MGLRU to replace
+ * folio_test_referenced in some cases but the user should be careful.
+ *
+ * Returns: true if the folio's LRU referenced / accessed count > 0.
+ */
+static inline bool folio_is_referenced(const struct folio *folio)
+{
+	return folio_lru_refs(folio) >= LRU_REFS_REFERENCED;
+}
+
+/**
+ * folio_mark_referenced - Mark a folio as referenced.
+ * @folio: the folio.
+ *
+ * Ensures the folio's LRU referenced count is at least
+ * LRU_REFS_REFERENCED. Won't do anything if the count is already larger
+ * than that. This helper currently only works as intended for MGLRU.
+ * Not a drop-in replacement, but should be fine for non-MGLRU to replace
+ * folio_set_referenced with this after audit.
+ */
+static inline void folio_mark_referenced(struct folio *folio)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+
+	do {
+		new_flags = old_flags;
+		if (lru_refs_from_flags(new_flags) >= LRU_REFS_REFERENCED)
+			return;
+		lru_refs_set_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
+/**
+ * folio_mark_referenced_by_bit - Mark a folio as referenced by bit.
+ * @folio: the folio.
+ *
+ * non-MGLRU may want to make use of the lowest LRU referenced count bit
+ * explicitly as a referenced mark.
+ */
+static inline void folio_mark_referenced_by_bit(struct folio *folio)
+{
+	set_bit(PG_referenced, folio_flags(folio, 0));
+}
+
+/**
+ * folio_clear_referenced_by_bit - Clear the referenced bit of a folio.
+ * @folio: the folio.
+ */
+static inline void folio_clear_referenced_by_bit(struct folio *folio)
+{
+	clear_bit(PG_referenced, folio_flags(folio, 0));
+}
+
+/**
+ * folio_test_clear_referenced_by_bit - Test and clear the referenced bit
+ * @folio: the folio.
+ */
+static inline bool folio_test_clear_referenced_by_bit(struct folio *folio)
+{
+	return test_and_clear_bit(PG_referenced, folio_flags(folio, 0));
+}
+
+/**
+ * folio_is_referenced_by_bit - Test if the referenced bit of a folio is set.
+ * @folio: the folio.
+ */
+static inline bool folio_is_referenced_by_bit(const struct folio *folio)
+{
+	return test_bit(PG_referenced, const_folio_flags(folio, 0));
+}
+
+/**
+ * folio_is_workingset - Tell if a folio is part of the workingset.
+ * @folio: the folio.
+ *
+ * Can be used to replace folio_test_workingset safely. For MGLRU the LRU
+ * referenced count tells if a folio is a workingset as intended. For non-MGLRU,
+ * the check below only holds true if the PG_workingset bit is set.
+ */
+static inline bool folio_is_workingset(const struct folio *folio)
+{
+	return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
+}
+
+/**
+ * folio_mark_workingset_by_bit - Set the workingset bit of a folio.
+ * @folio: the folio.
+ */
+static inline void folio_mark_workingset_by_bit(struct folio *folio)
+{
+	set_bit(PG_workingset, folio_flags(folio, 0));
+}
+
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+{
+	folio_set_lru_refs(new, folio_lru_refs(old));
+}
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -171,58 +326,6 @@ static inline void lru_gen_set_flags(unsigned long *flags, int gen)
 	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
 }
 
-/**
- * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
- * @flags: folio flags
- */
-static inline int lru_refs_from_flags(unsigned long flags)
-{
-	int refs;
-
-	/*
-	 * Return the total number of accesses. Also see the comment on
-	 * LRU_REFS_FLAGS.
-	 */
-	refs = (flags & BIT(PG_referenced)) ? BIT(0) : 0;
-	refs += (flags & BIT(PG_workingset)) ? BIT(1) : 0;
-	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
-	return refs;
-}
-
-/**
- * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
- * @flags: pointer to the folio flags
- * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
- */
-static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
-{
-	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
-	BUILD_BUG_ON((LRU_REFS_MAX >> 2) > (BIT(LRU_REFS_WIDTH) - 1));
-	*flags &= ~LRU_REFS_FLAGS;
-	if (refs & BIT(0))
-		*flags |= BIT(PG_referenced);
-	if (refs & BIT(1))
-		*flags |= BIT(PG_workingset);
-	*flags |= (((unsigned long)refs) >> 2) << LRU_REFS_PGOFF;
-}
-
-static inline int folio_lru_refs(const struct folio *folio)
-{
-	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
-}
-
-static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
-{
-	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
-
-	do {
-		new_flags = old_flags;
-		lru_refs_set_flags(&new_flags, refs);
-	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
-}
-
-int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec);
-
 static inline int folio_lru_gen(const struct folio *folio)
 {
 	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
@@ -369,11 +472,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
-{
-	folio_set_lru_refs(new, folio_lru_refs(old));
-}
-
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -401,27 +499,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline int folio_lru_refs(const struct folio *folio)
-{
-	return 0;
-}
-
-static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
-{
-}
-
-static inline int folio_inc_lru_refs(struct folio *folio, bool promote, bool is_exec)
-{
-	return 0;
-}
-
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
-{
-	if (folio_test_referenced(old))
-		folio_set_referenced(new);
-	if (folio_test_workingset(old))
-		folio_set_workingset(new);
-}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
diff --git a/mm/migrate.c b/mm/migrate.c
index c737d0682fa4..806f1e913a38 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -786,8 +786,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*

-- 
2.55.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B272CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85526B008C; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99406B0093; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBC06B0092; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92D396B0095
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44F9AC106B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
X-FDA: 84720078912.07.515E4EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 33DCA40007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAmSEqbq;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669454;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JQsDcgvyTDRJqdmz9OZBFELPBNu3/uONh9TgLArsU8=;
	b=N+ATDVLa0PupG+bHtWvHrFv8hmm9sOzU1I1DmfphR06zI6i5W11SdfalDfWP4XYswSdEy2
	4IgtjR6pNSkuUszs48dwiwdhZwr9216o3QlMnxCRCBky2MPqUXRFH5E7f9RvP5oAMzpnld
	7vheHKga5M5HPDwSXoVjjB+efBOSev4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669454; a=rsa-sha256;
	cv=none;
	b=ybv/L9MWmqmvsv0jSm4k/OwIzTkXFZwMNZVmxB6Ugx1t1wXmiFGjdTyISfN7yp57H/9115
	jknlUZMnQIUo/9/EywNZCbbaNgTFOldFTZqBgBymSnzk0J1i5+8S5n20QcB8zAzHK0+xjs
	dUpDWzzUT1/Xji16IOj3ABowYxNImaY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAmSEqbq;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92EB944561;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46A74C2BCFC;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=+yHr1JUmHMBO/y47bjd3AbfSo7VRCUCZK/eF6pT8Uug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OAmSEqbqJCQDBhXLKYIAnCuNdNDAI6pKrDwh/DjUCWjNu8cLS3tHTGXHZVorD14Li
	 OPmJkGKv7vsnpOFRfHRYH3qXtPMskwMS5wRKs2XeO3GczliySj/3Gij6q1sIsWpsVU
	 bwNaE7FHnKJDxTeozfbgMzIN6st+BJqi2vGhtYuxS3efBAJJtntLAtM05A3qAm/8nr
	 u80HjvTN33int/JjlncUHKHtkX5mxssSD72rh44777ddeFdt6nKxrxDvyhSGhA/499
	 Xg6BJatkK0YUkFhB9MNADd0k7w3MW3e6HQsZOk4rWEff6OXSX81R/1o2lVtqo0z3oU
	 Z5oXEeJaBhFGQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A224CD3428;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:50 +0800
Subject: [PATCH RFC 04/32] mm/mglru: introduce and use helpers for updating
 lru_gen refs and gen
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-4-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=11174;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=mzihrAcNLx/NNYmCzxNjqi9MDgaAfA8pw6JJnBYfLik=;
 b=j0O5d5xSHhkEfT9k9tlkSBlFTxKwdl0D0BGzjPwChutOeH8vLWMM6u/U27G5/QSuQHgqcNsvU
 AL5Gr7VHj2sB1LF7d9VyPPUEF4dpyE0lonDCo0bpHOgWsQzqejyhscP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33DCA40007
X-Rspam-User: 
X-Stat-Signature: gniwctyin8h6edpshbpz7rccj513su91
X-HE-Tag: 1777669453-796188
X-HE-Meta: U2FsdGVkX1++RmKEJ38BpyV3xaSjcwStZsKgae3k3+n2D5rcKRhA7sPsdyMptTdegKlxHtnoaWKohf1iyUkQSDyQN63bjbBUVO2exb8vixv1AHODYaPyjudPeTtrtdcD3yIHBs8v0BN4WQNPKL8IoQe0pFYV4+5bcVifkySSKAwQGT6gVoBGigV7NRLkBH2+mSYn6WGEu8ZTTGCtGi+PTB8XN04WC5xTOZNVVapsy5jmoJd0Lvss1yKkT2mDeycN1NKy/Uwsv74BsgxHzV2CPyNYCkrL8aJDb9EX5sAh6ceqaeBKrbjKoqKqG38QXPBRaQR8zkIMaPa9UaX5YLXsGM5q1Qmi0Ya6aQ7oDllXhH207g1zhQaYl4xbOovrj3jRrxv6cR071unVTD6AiCKzoJWU0Qay//CK/t0hBEvlnNlhxUTrrQMC/XVbYCq9tisYBtWFFuvnEuntjqUOQnmJbdMr7YB1N2E0PZtHe3n3cehy5/1eBte/jhsYCdDhnlL5MZ17hHCvwmXY2x/n7pq47z/0V4teZixDW/feJUEvjNrREX2lGkdSEgzck8z5VqWby8nO8xRfbEsWhU8innIBdb/37P8hJKAN62J8fEikTaszQl/kcpB4IBj6OjvkFXMzVDOQuDbnQzbuCt+F4m6N9oN9ACj01ynTI4CWtsMN4M5flIC7/WLy46Ogzdnn6PEODG0OL16Sm69n6WNnNbY34YIQ3fUIHF/ik9Wq6zws231PRuqKmYFguirTv7gPck4DmiCK0f1CbATOEk0QETDcK5+cekhjCnLyN5hOpmsT7QD16hVd09dpP/KdMcJ0nHLnelU9NPwGCyap76QDUBf6a/IlaQObqUnLRB94v3oxHPFLpagru7C1ztIcpwQZbhmBvlqG5rDSXym3op9MeEOKOkKbCfWiWaj7Gi4FX0TQekas6yDsLafmHN3ajLBYrkloSjksSc7qcui978g+S5A
 raBFk0TZ
 M1XI9zZ4+G/K/z//HLwsMv5j+8Bpo4vw2fqgbEQaWHOwNV5IBnZf1YPRUcd3iKAxqo+MkM1HF5vSoy0IfcqFKZXkz9hlGT/TzwiGeiKJ+OsyJLLXuZxPyAB0tY1t6crmgYdqsbvI/MpKR4+WWtwu7I7rJeugBAACpEUUr5LGu14kmpgbbSLmhf5uwOhuLwBzvf1oLkJMF2cxBGGxvfufB/YGxfu2cZwoSc8meMJHIh20XEyrj4tLrVtDLUjKJXw1XsBtZ1lEVhn0uCtO9hebMldxWdB7dehKx1wIFDrB7mDw6rDyR6m5wNnN27gu7lPkQdI/sCGIxcYj1BZmLs4zJdhKF8hbffA8CbFyn9aBGiivRqetNLt04hlsv/y3hgKjUxMvZbU4Bb8kB1tsHPFUXPz4qTpfzb9kDZdf+UA4Og1BCTkORc6LfPMjSaBCNI7nbOYtEtgJC/DDqTXFQ29PWbKEOi4n+BQ9aDNJgam2TIW6KeKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of keep touching the raw page flags, use helpers for adjusting
folio's refs and gen info, make the code easier to debug and understand.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 79 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/mmzone.h    |  2 ++
 mm/migrate.c              |  2 --
 mm/swap.c                 | 17 +++++-----
 mm/vmscan.c               | 52 ++++++++++++++++++-------------
 5 files changed, 111 insertions(+), 41 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 9c8ad8af37de..eade9f2d6afc 100644
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
-	unsigned long flags = READ_ONCE(*const_folio_flags(folio, 0));
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
-	unsigned long flags = READ_ONCE(*const_folio_flags(folio, 0));
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
@@ -305,9 +365,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(*const_folio_flags(old, 0)) & LRU_REFS_MASK;
-
-	set_mask_bits(folio_flags(new, 0), LRU_REFS_MASK, refs);
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
index 9adb2ad21da5..e4c51961ec27 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -493,7 +493,9 @@ enum lruvec_flags {
 #ifndef __GENERATING_BOUNDS_H
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
+#define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+#define LRU_REFS_MAX		(BIT(LRU_REFS_WIDTH) - 1)
 
 /*
  * For folios accessed multiple times through file descriptors,
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..23248484a165 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -763,8 +763,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
diff --git a/mm/swap.c b/mm/swap.c
index e7037ea2c10f..6204496d48f5 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -393,24 +393,26 @@ static void __lru_cache_activate_folio(struct folio *folio)
 static void lru_gen_inc_refs(struct folio *folio)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int refs;
 
 	if (folio_test_unevictable(folio))
 		return;
 
-	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio)) {
-		set_mask_bits(folio_flags(folio, 0), LRU_REFS_MASK, BIT(PG_referenced));
+	if (!folio_lru_refs(folio)) {
+		folio_set_lru_refs(folio, 1);
 		return;
 	}
 
+	/* see the comment on LRU_REFS_FLAGS */
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
+		lru_refs_set_flags(&new_flags, refs + 1);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
@@ -423,7 +425,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	if (gen < 0)
 		return true;
 
-	set_mask_bits(folio_flags(folio, 0), LRU_REFS_FLAGS | BIT(PG_workingset), 0);
+	folio_set_lru_refs(folio, 0);
+	folio_clear_workingset(folio);
 
 	rcu_read_lock();
 	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7a1f08147dee..2ca1d6d80259 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -843,12 +843,14 @@ enum folio_references {
 static bool lru_gen_set_refs(struct folio *folio)
 {
 	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
-		set_mask_bits(folio_flags(folio, 0), LRU_REFS_MASK, BIT(PG_referenced));
+	if (!folio_lru_refs(folio) && !folio_test_workingset(folio)) {
+		folio_set_lru_refs(folio, 1);
 		return false;
 	}
 
-	set_mask_bits(folio_flags(folio, 0), LRU_REFS_FLAGS, BIT(PG_workingset));
+	folio_set_lru_refs(folio, 0);
+	folio_set_workingset(folio);
+
 	return true;
 }
 #else
@@ -3191,28 +3193,31 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen)
+static int folio_update_gen(struct folio *folio, int new_gen)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
-
-	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
+	int old_gen;
 
 	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
-		set_mask_bits(folio_flags(folio, 0), LRU_REFS_MASK, BIT(PG_referenced));
+	if (!lru_refs_from_flags(old_flags) && !folio_test_workingset(folio)) {
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
+		lru_gen_set_flags(&new_flags, new_gen);
+		lru_refs_set_flags(&new_flags, 0);
+		new_flags |= BIT(PG_workingset);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+	return old_gen;
 }
 
 /* protect pages accessed multiple times through file descriptors */
@@ -3220,17 +3225,18 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int old_gen, new_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
-
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
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
@@ -4639,7 +4645,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(folio_flags(folio, 0), LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -4854,8 +4860,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		}
 
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			set_mask_bits(folio_flags(folio, 0), LRU_REFS_FLAGS, BIT(PG_active));
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
+			folio_set_lru_refs(folio, 0);
+			folio_set_active(folio);
+		}
 	}
 
 	move_folios_to_lru(&list);

-- 
2.54.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8CE6C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3060C6B008C; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD6F6B0095; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC7A6B0096; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D034C6B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34B321C1CDF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:41 +0000 (UTC)
X-FDA: 85158809442.06.471CCA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2049E100008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f14jp/nI";
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbECExriJUdkQ0Z6jWT+jGvHXqQL1IOjKfWGPT59EP4=;
	b=CzXlYuAxb2FsjgVIhbQNtvGgi3pl0oyMsAoajh8Gu/g5lQgkDJoKQf3oACbYjLV+kSTE09
	2LrQ6I/PVcWn39emMWQQK0qhhQmOupfZhfhH9IX9FfG0d/7dNld584h/lZCC+i3gucqu0/
	0SAoTmJtqzpEq5dwOP7evnTTPzKLJok=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f14jp/nI";
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115419;
	b=ohIAwwyVMNJMh0Ge3bCaFz3BE2y/IROR0GU9eNWkyXp9OVe4eFILknoFk7FV4ep5Qhl3OE
	XHtdEjJLTuGV00lQW0/ZfAZJE3rsBbJ7TqzKodJ1SomRhgYOmRrQq2/TIqc/IQn3PeHSK4
	ts0ZaYxyHg0vh3/TuuW98ZJqMb94aPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D83E444FA;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0C39C2BCFC;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115417;
	bh=BmIJEHuM2IDbhjxzbujXYHOKiImgaACmoJFlhjiTrRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=f14jp/nIU7khpFSr2jVvUQaTcVBwjevKkDM0DvM2WYnrBooG3bpqtxSA+CghdbQbc
	 U5R8Jpmxn0teDvPS3HPTxuvyk0//q2uyg+WQO3lcrwy8BPIWEMXHRe4bGhqO1E60xF
	 rgb1TK4YaKkg16ZKmnYFrA4KlDHw7gkYZLxAx7dzEhHL4XPgIgMTTiqGGNGodtG/h8
	 oIA3wWbRCAFNpLEG4mHvtiftAnTbjBgENbdUAp6xQpDetfC1+E4tG+vc20Y81I8WBB
	 ixOUZCQAIAi1o7VD6FV9MMipF40K4rWapi+hbZ2nm3C/jo4qg9+R6FQDnAuOmZh+wN
	 /Gg6xBv2qDXcw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC48C61DE2;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:32 +0800
Subject: [PATCH v4 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=12684;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=9YR/yHPBoBzJHU5LqVAM1pdyJ1Ysbia718YddvWvXiU=;
 b=nrov2DFK/cj5nINZPA8E2X09keGEZ7abpXRNJXiPLWGjkAMMlhTp2oXjYOASYhOEjg/rcAo10
 4qE5tAzT6g1Bm7LZ8abdXX8zLcqeBuaI0Mfi3hQ5N6SeJvoT6K0/cPR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: un7igqu8z94qgdonu1smpn8oauufyj3p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2049E100008
X-Rspam-User: 
X-HE-Tag: 1788115418-522027
X-HE-Meta: U2FsdGVkX1+0N8AdITdRKA0QXFOCDoBmnKwZ/2EO/GTRadAsAiYOqG2ezM9mC996D7xsL+3cKLG4ugW8MCcZNfgQG4HxpE+yygbu+PHRsS2SyyDHPVR2po8vFaUFXC9fDmaESTL77ScSMx6gWwVUNAPGiRysNHlYjAnlKBBs5GGjRxwlyrB2a8dxX4d90G7ISrtcoLVVihMZSiF5svlWrrR/4+8nGwbRuAFrT2rmBjWviAb4bMd/Vi4JG8GfiypJCyyg5cPm1ohAbfsAuUw53SFThQyPvWHhIpU42UVcOY0S6hHpcOC6QsrjPyuG3ndyPLBiTCpP+q80g/hmAKw/pqelwqCaXvKWMtqBdiPWPSL75OYQjV7rixTztwtOhKgva6vZ0nSXh/zepP7R4HGU8S/vEjlQZSx8TUbGQ8CF5zsdWHyZsN+VYaIeHxLovKjk4RtcHLfeXdeyQmF37Q5twPWkYc7bQ+EHDIw3TZOhY/1D0shKlU+UMuuuEHDjtnjSwj9GRMLEaYifoa+wW1epFXSaQ7Vxr0K7XZIP0Bfbo57QkhjiAP5o0eALbSqQvwwH14GJvuXDx0Vc+dEpHZVR/SWjiJ2EbV8v+5VZxoisCBwl40VP3sNZaLfxEo8FIlgpoiH5RXY/my+0TSY3fe1Sprb8pUvPvV4WGvhODKuMZdQyleOKl/HffMaVtBiqQHJjRPw+gcdcbk/QG9fOPtKqqW95q+BkcAmP0SNM9Y6cFX2u06K0CovKUGdHTu2YFkFk+OyPTko45oYQWGM5FbldZ9674i6VYMCP8KG2kezHNSO6wFjD3cFNYfU0alu099Dh9mvFJ9FUXtfz0nkXo3Vt9X8gErSu5scVawkXZD8mrvCkdQJCp9elivpDyEC8XZTuuQcIcrgq2UnQlYahSavAVu9G0/AhAA8aqDgw+2iazbqcYdZiVK7OKD3Y3yBIfK04+RezyIx2iJB35uA3Qsc
 xE/ZlRfG
 idcNQ16ciKhx2zqldpZyn6lJqEhIHAdYedq4/uTRrx8Mgsp+tW9gU+mQuHlo9CQ/E3kvobzhvtHn1kVVYj3MWUncO5FziAJQ8elfzirBGuON2TA5XtBemNmL1WHyw6jSnigxtE3lySXxTuXEUcJdXOnghRwrzYauifNiTfurgxfMr886IB/+BacEQVy7Cuu/Jxz8g4J74VU7KZw6yG+z3FzZ4XSSbgYRUWekNzAUENKxTj32PokNCrNw6/GoZXol3yErKYVLznyKdtXxLvR/5iCUPc/BlVHNS9WoDS2ONe69crEh+wk80Y9p0FWNVTzjkIJOk9sgJWcetPoWdDynUrG4AUZGxmkRMhZ5VtRY9dfBGWngYeO4vU/gdmqn7szkfcljvPLf9Ei+EtPMaTr3KjV3SpsAFRJj4QscqbUAtp16qp9aYsQZYw3LEjvCy/KktNHeL
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
index f11491ee9ed5..992d0d3e2311 100644
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




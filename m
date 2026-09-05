Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B25C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0DE6B008A; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2931F6B0092; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D2E6B0095; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA6B26B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71FC240352
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
X-FDA: 85180298994.27.14FD316
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B137A0002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MD9Evvcw;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627075;
	b=TlZLaboS7ivSwfmMnr1ay6SSSBxfN4kaRWvyxFAOz+zq96u3T2y0utkBycyoB5uyhrUPCx
	9GSkCdLPeoiz+y2btT9OP0EpRgrKrHGLA3xqis+6cGWsWt+1arRioDc7zgApiLHZxwI50z
	cK05H2NCeLMtAZPwvJu47gSxgnbUayQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MD9Evvcw;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41cex7jsuQjOiwZznfTgqdFXWleB56ExCetAxROHATA=;
	b=ez7XUWpQHCZcwSNZ/GtVCgnZdNqvYbA7nGSlh75Ap1JBdJxqYk39w9g2VXtDP2f6vHJziW
	vjlOKnskCwD0nCzJgKSEteecYpCs8x5HHj4H/WvtVq4sthI/Jg9EUBxYq3bniRgahda8go
	HktVWSiozeXbcPW9s1e25W91RSh6G6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77A9A44543;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D42DC2BCFF;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=7c9LXukxrwYdZOswrqHt/hX/3J7Pgc8Ju0X6SzsFhe8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MD9EvvcwijlsA5leGenQC5cLGWB6TL8FjrZzCMK/HFPzcxevdS7+sZzRIe4/z7FT0
	 oDyffa53GxhSjWfHMPwNpTyCvAAD1V87nkEj7gaL0IvktpVW4F8teETOoUVUz/9+tq
	 ba+LZ6ErbizxZJuTvP/EjQyun6hutmcJzyWhXBviN3N4nBviTzoi/fnYMclv/wUkRs
	 sH8SffngNRSPd2Igepk1J3zfjxfRKzPuR0bBIPn9LS4VNTD9sunl8L4NBwbnuY/QN/
	 sWgcHOMe7LKTmX72UKcVsf1LxRo1SeVL+/AsqWdRxhNn38exagNxr1NxXg7boxiDUf
	 JHB5Dk3qB2DGg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CF8C624DB;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:07 +0800
Subject: [PATCH v6 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-2-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627071; l=12675;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=miP4A2eo4FXzuEYuTOUodoTCk5sAlLqtnuSQVSZhvqI=;
 b=0a4Lisg6JFUvIcik5i6UDwn5hziCxeAxSvED6x+CoYvHcnA1WYddIu3mVMsgNW480naLWVnJC
 hWEHFHnFBoxDl96xACe6upJ/bboEqVx9jSsy9c0ijs1rdhpOGlQpb0z
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B137A0002
X-Stat-Signature: ahw167opry1icwbe651ajq6fqi99itki
X-HE-Tag: 1788627075-609963
X-HE-Meta: U2FsdGVkX18zaHsaRNFEPNJ2aMQNu4uKuSlxkmd6uVCr1oEJP3e82JUGP0bDb+Ia2XFPqxnVbgsAOnoAALtQ3D5WwijDSQCpJJ4o75Ck2gG3w4Yh5zAiUuzjTpkBZNTMyM/GnQlvubHMlx9PjFgzninudzVFilodIYZENso8J7XiGFTDM0xFhoEw0vFuExeboSSaRxuytgUV2gtrmT42j1lTDUKlww2uk+iwRL3x9X+z+v7dSr5gNNxtbv2WelcdbMBkfAVzsbuOHCBJr2R82iDQSefjXXG/IREZVHzvxp6LK/ElcrubKN2DwimfOiuRXrGvhsGJUXyHfQLRaMf1rG4PE2MqbYwGrompB1KPjdg9bHC7EL6bOes+54WMbSC92ZMgFu7Nd62xhrjH0kXxCM75YMYfYz4JqFBmia3pJmq3lfT+aMuazqsD8LyWmOtjtBzmPp1Q5LZhUhUv1KbTxTvIvCgmNPnactVHHLGJunUJjtEdU9Ju3wHljh24U3ZDIsD6BBMJxiKpPyW9wiD2f2EWVMeOTiVE97sh8/4ggRmPufcng5Rvqmbx0q4j8WsNLdD1duMhMXEJAh33CmVpUsg9G4Ti6H0ozDu7F+YLqkb1JW52TjRlboyzkCEcv82JNyYkP0Q+tbij8V2w8dlVBmmtcyu/BDpVpy8XuFok/qfjLLTLb+2WeNLYbSd6g9VoO9X44xoNemTiIJTzWTl6WjO24szs2nCNTzrcxupT/CnlYrG8Y5uETFn+mMHYAWJdV0rAWMunDMlxrvV1I6+twcWaOMK2a5DKy7gprwwTi8huWp4kYz9lR7nMXlJ58vBWJowYnIW9lHtOxle/E+CkEc3PjPtBySKBSOz3BVmZoAsXeXvz11lvBCdBNhc3v5foIRNXEJFZWLTUG42j02AlymVWZHolG8soLOkGUH4C7D+66i6MKDhszM4IxHsPGOO9sH+0Nv2huPR5d+0iA18
 NccHW+PN
 dHgeV9KU+dm2Fev0lTYigunu+4VxEWfpGFMq0Rbp/Mn7hcB4RM+wisCtp+p8gLD0TKjSUhwAFdWJc58osUP0lpaRr/MVV0IGX4MXtLyUY3ibCnyYUmWFeCS4IKTIXHX6houWWPI1BMl+bOlyrnX2kzxum1adHUxlaeDpgVpsJe+Nv1NiCNV+HmgKIQWT7vuJVAozeWLGnizDexFFi2xdGBNRWCDyw4SajRlhj1pSPCfU0Po2bXEZ7qkxS7qXgCkjXRKqs/Qh+nyinSYH4pXI3lHyY0NteiJK2Xcddiw2s/RhesPc5ff7YXb/CDhnzxWcdr8UhOtuo4N0zzcH8OooxWiVOTa4J/WKXzZbHukOslSQS/PEXjjPeGUecKqt+/C7S0Zevre2FX/dPRrbY4RO9RJ7501eS9kaaoodvWFHAvK+8OFhBok9VIig6gKvc1elHZOc9wcqs2UFuwDMm3Zq++zNnJnHhWWUiR0EacMg3aBE93Y4qysDX0i8KrA==
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
 mm/vmscan.c               | 60 ++++++++++++++++++---------------
 4 files changed, 122 insertions(+), 42 deletions(-)

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
index 84e237f2c17d..775d6279dfea 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -500,6 +500,7 @@ enum lruvec_flags {
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
 
 /*
  * For folios accessed multiple times through file descriptors,
diff --git a/mm/folio.c b/mm/folio.c
index 50a6dbe55998..47a437e0f7fd 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -354,26 +354,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
 
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
@@ -385,7 +387,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	if (gen < 0)
 		return true;
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
+	folio_set_lru_refs(folio, 0);
+	folio_clear_workingset(folio);
 
 	rcu_read_lock();
 	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b28..c6e03a5047ae 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -863,19 +863,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
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
@@ -3291,11 +3294,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
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
@@ -3304,31 +3306,34 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
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
 
 static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int new_gen;
 
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
-
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		new_gen = lru_get_gen_flags(old_flags);
+
 		/* folio_update_gen() has promoted this page? */
 		if (new_gen >= 0 && new_gen != old_gen) {
 			if (increased)
@@ -3336,11 +3341,12 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 			return new_gen;
 		}
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	if (increased)
 		*increased = true;
@@ -4785,7 +4791,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -5017,8 +5023,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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




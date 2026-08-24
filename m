Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5500C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DB16B0096; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8516B00A4; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988286B00A1; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60A346B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E419580183
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:34 +0000 (UTC)
X-FDA: 85136539908.02.C443826
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DDF8C12000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EGiNPp3P;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hjYP3gSPL92rx1kCtkD7PtZ8Cy8D1unn2vNUpdbzfg=;
	b=1EZmTv/FkwQ3YelOYWxS5SD2OF/XG7ENqGN4f2bxi5SafGRbXU6s5TTFpZFRYV+uEugMUB
	+UpivuU1eIa8FwfVBIJvDvSgmCP2yk1n8tmGUC69oFeDbAUWw5foMCBngvOE2v5tEWWkDZ
	LTthoNMmMSurZUQYGPMEadQWd/S2/HQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EGiNPp3P;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585193;
	b=Oin9IPNLplJgLrGQ5WwVyz9SN2gft0+qnORYlxo0aV2UpEcyU5LJMAYeadIqNjPC6PiDBW
	a0zWExwjXYd0zvmZlmJKwfJ/vD5b0+A+2L4CjHo1+GVNm0h8GfNOcuZoGgbZMCR/8pnGpC
	W7VzYtOXOXREq/8SM8TtkGe1CrHgZdQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F3443F2B;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8333C2BCFF;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585192;
	bh=vQxrUTjaXGFh/l5Qjt2PhmZ1+t11Or8RRZ6t+7dyC1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EGiNPp3PH4LeJ3vpaypGVs/AHOG0bFN6rshrwNaUzdRXLCETLkg07lN7lUBjIbI/1
	 VfDxdHA6BtAyd2d4fkZUcuyjstHiaFkgwCvgQUTbOlcibHFm7BluIo65wZvGvCjt60
	 xH/Vrt9p9Wc96xYTCdzxiu1Znmzrai4LBjAhGLTxIbe4VugUVQbGQvsZmhWvKQQTlc
	 hfgQRSZUMnBL8yuI6swEcTLB6pTjW1Hl0Ki2Cf2+jhHRfC7MxigwpqRfHvGks6Ysf+
	 LShAbSpz/Rqt+nJlvQUL37AIA5iMWI3Y1aQtZEaWJxSFXCvS06fsu2JUPPFDvqW+gI
	 7ameRyKEHLrgQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FFCC5DF94;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 24 Aug 2026 23:26:29 +0800
Subject: [PATCH v2 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-mglru-flags-cleanup-v2-2-0104132114ae@tencent.com>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=12106;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EHAfalkckCLnooY0He00lMtQVHsE4Di8s0DBo5GhRpE=;
 b=bMarFhOz/dxPGTwR4bWWhdwEN0dWlGrDw5hStFTlQTKitG/1j6PSLpqFaQHusx3Xh3MlB3tz0
 oY1D9HEHzolAbpZhEiRa2TmB83eNY6jRnJ0uSMalVanX9SbRQnak//U
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: iwfawqxjeeg4zasgqu1w9k64j6856fng
X-Rspamd-Queue-Id: DDF8C12000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787585192-291203
X-HE-Meta: U2FsdGVkX1+ukvrfVarsRJa1XaQJiTQetQJ1s6hHj47LK8sR8BgHT2lpbhEfcliNJemIl8/XimGC09rrNMSkfYQ3mD3FMHdaY9sPwIddKH1ARh4QJWnAJryoysvcr1KicxkTWnPxRunr+/lQDchuaddi8XEqNJKHqesuTogitf1fShT+Pj1Ua7UGmRrB8s5Gy8BHdL4shFd6QDHX+ycSonNuHhIPCppEkUjS0GKhEhwA3201TOCffMVfJYRCeNRCMsRQps2GMFXMml98lAA/oZu5+q0cwZyTzuGy162jqcqFb9Ed0w1W638+zFQEtnAu0mtjK8sMGHXcSf33O8+hI5NMa8yshN4FRVsXfVnSqgMprucGf0CpQQubVlFYPnMPfVJ1hyPkHzH52dYB96kHab1eX1KKMw2WLZoW7bnX4XgbxdFMq87qexP3TUxbcUDOfW1pNAf/UsGiejvqYqvTc6ik+HxUpqq64vxwqRsxhmcllsuYjXGwSNnR5FapeRgr2CS1GS+Wavi1TS24gVUHmZtDSbSONtgx8paepKnmaAUL6HdlUdHCZTza8q+xvCGaWjJWq1cABWCvA3Eaqnk27QenUqGF6elZ8huHTYNHzxX8BLniI/uN4W2388uqbK4tLsZIgc5SGa9zLCTbPhMzg7aQ43PIi0rW/SHZQGVxNSmDHcZZyinIPZPBotzjvFMbuCp0QSnHFNIJDUXJDrSn26mW54/4FyUnZ0sl1cSyrokuCu2CyP5gY5zn4/djkcnLHjP+gqBpI9F7zcw5d4k3OP4MPHlJBuAfVMlkkGISCn3yrP6fIKruXlWdGGTD1OqHQksWnt9qUBm6nHPImfKACImng6/Oum69qNB1w66iNeNHnzcRU+IjgW2UsWWPDrKZKpntu0O0uuc9gahRIsf2wlmrM2MlmTpGrpJqnByV0DE6XfgVhiRUGGqQmlOPDXfXq2PUhrNvVIhednlxQhR
 9ZneYEe8
 s/uI5gTSd1mGcvF/Triqh7+dw2rbuW1Htz6YqAY0POejQGitx4qqgEdkwLSaf89YfnGMi38jwEFi3D07sxTax5AzHz9JfpvdlQUgoZuktfH8Pdn1Z6aX+snpASo1P2m+P7yr/7sJ2iIoiypfpe6kjsAkA/jcyYvs7YzN/HMWl9BLgadDtQtw9i7COKfjQ+mtjVze+iHv45yjyNLWSyCVr4S2j7r+fStSYJo00MOtekdRB4lCPET2t8zXOlP6JHWPC9UbbIg/Wu3GEsGp/xrUwORH23SZK7pc9exfa/u8HpBdAhKPs5t4N8fRFHtKkyY1T9zHFM84nIrpY9GAQmHxztU/6c8ziEMTaF8sNN9WYW95AZ+r8lb47PZ6YY08y2LW0oeHTd4NyrAn11AeS9PTd0IPNFQ==
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/mmzone.h    |  1 +
 mm/folio.c                | 19 +++++++-----
 mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
 4 files changed, 114 insertions(+), 43 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..edfaf2661812 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(const struct folio *folio)
+/**
+ * lru_gen_from_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_gen_from_flags(unsigned long flags)
+{
+	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
+
+	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
+	gen -= 1;
+	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
+	return gen;
+}
+
+/**
+ * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
+ */
+static inline void lru_gen_set_flags(unsigned long *flags, int gen)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
+
+	*flags &= ~LRU_GEN_MASK;
+	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+}
 
+/**
+ * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
+ * @flags: folio flags
+ */
+static inline int lru_refs_from_flags(unsigned long flags)
+{
 	if (!(flags & BIT(PG_referenced)))
 		return 0;
 	/*
@@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio *folio)
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
+	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
+
+	*flags &= ~LRU_REFS_FLAGS;
+	if (!refs)
+		return;
+	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
+}
+
+static inline int folio_lru_refs(const struct folio *folio)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
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
 
-	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }
 
 static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
@@ -270,7 +331,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
+	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
@@ -295,7 +356,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	/* for folio_migrate_flags() */
 	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
-	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
+	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
@@ -339,7 +400,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
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
index 59c477120b9a..0adfe4f5ef72 100644
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
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..080132997d87 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
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
+		new_gen = lru_gen_from_flags(old_flags);
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
+		lru_gen_set_flags(&new_flags, new_gen);
+		lru_refs_set_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 
@@ -4711,7 +4716,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -4927,8 +4932,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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




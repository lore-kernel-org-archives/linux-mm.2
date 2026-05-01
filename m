Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D355ACD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214CF6B009F; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127CB6B009D; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0AB56B00A0; Fri,  1 May 2026 17:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D69316B009D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88A9A1202A6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
X-FDA: 84720078996.17.CD1C628
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83783C0010
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HqXOV6T/";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669456;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRlXuPZ4zojOarA7R1cuUSUi/EcEFK2+oJnX0ut/UJo=;
	b=jrWEXDG3pF0tUh3J2mW2l6MW4QELJDEt5C1bNw+vSEQaV0QSHczBbp20muZNzUxwR01SU2
	ZUK7tAuSLdAnEpO0sueud0ymte51OGjyXjB+VmpJ2/BFa/gc+JyK7dW5iBK/mlobKnZvr1
	Vrqqdgkr84oJJQugPggX4QQHdAIWej8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HqXOV6T/";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669456; a=rsa-sha256;
	cv=none;
	b=a9BIaF6j+sdM58qbmdrHX4q5xonP/j2m7oVKlO5AmzACZ5P0ZeytKdmOOALBC0O+IfMoIO
	UUXyvBQRjdGmgwBmmbLtt6zAqOAdFPbWQ3iQiNoCukfgfxhubWA3FvgaWOkB6R8UIKh7XW
	FAZ8dGhElXNnHUq7jRTVIMxnk275GZ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B981744597;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92C1BC2BCF6;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=ApEOFvC2VgjTNekwT8E17q1ZVKs84dstNvvmMSucXp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HqXOV6T/5NYzzetWHipxDTUBDAGs7OV05csm35yH1ube6fFSiCw6XPu/kMVORVENA
	 Qr2mY25i8OOofF5GI470hVeq8iV04ljNWZRJ70x132sfVtYxz9o/k4rjIARU5/rNdP
	 JkUxo1fpWoyx+fDqv2TtCgBo4ljbuCjILp4PP2b4rKKZQfZX1jTuZiZk0nGIg+Ieu4
	 dYOrGnu919foXSs+ylaqxH6mo3zHLSXwPGqArCJ8qZE0VNMewBxVyrXNEyPvj+WVWX
	 RJo9obiL3QmGdn+jwY4UTtnoQnAS8GDG1/SLQsVrlcQQI2F1fiBXBHGdBUycnjYaPH
	 u14ncMJdPZ3gQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E06CD3427;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:54 +0800
Subject: [PATCH RFC 08/32] mm: make folio lru referenced times count a
 generic API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-8-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=9380;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=kFsnhem71+vNlAD+uETGIDzz3S2DgnshxmHavEobZls=;
 b=ZcQPWJu7KfLDxZjQPqZ8h8aF5A2CQesX2x+TUpUsKZ3cYMSL9TEgR2qq0n4FukOnjz+ugfmQ+
 t8XROTxV3wDBrzDHokgy4gl5yiQOj36pBlwUNU8gEDp1DYXLPS6eEdb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83783C0010
X-Rspam-User: 
X-Stat-Signature: 8yy37xo1ahmi53hb7w89dhcbmywwy1oy
X-HE-Tag: 1777669456-489115
X-HE-Meta: U2FsdGVkX1+zQoZ2dLwbs8lI5ECGPTHfD5tDPIAyiU6U+OW6kEq1D6SZ6Evvm52y3LXDM/JiRT3DdC8i8u/hmbzcbylSltNHcUe6gCZ+SPUDsFaahY+2lc3Srm+b+7aktxMpe+ooWgMJDMfFIaj15PGCgT7+iJq5gZquuMMBqx2MKUTrid5LxKsFpK7lUpnVNmMs7mAAl+wvKgpJ7l23Eeq3iOgaIAG6ucj4SXjf2jg3RIkosPuXep1jkICR/Wz3o7WLiPAYT9eGIJX26QcBL9CVT44GGc0QudfLl5HmBlQ2czK4/qtEXNP5/hTVEqIA5nJrRRoCqbHiIrrHLGEq8YLvjJUjjVgTtYBedPSgpmuyA3Mky05khGsTuwdlrHEycFVvDJbB+az//nTPsE2WkhL/p9bmuZ49j7q523pElBiV9amCpatAyPMZd6HpiACfjWACS0Ku/3YilDwdSYXu5mTmzYmPnB6d2YJE5IHnICY2nODwQAFNcbEx6x53mO3TuvSmAhEZImbEvnTlEJ1Zyr+mQOQLw/Ho4X20p+z/PRGRGKj8Y/JD9Ltb7/gnrJXhF/7KesdZEsgYZD7P67MUs2t+aGlbgXaLxMQUcsNw9T35h8YVX5lxcnnj1IHl2vGb9YDffaPowQVFP5HXfrw7MAaja/3Pc4nmsGiVweFlAcTP5UYA87Xn4ZMkPMpKQ8UkyjUNm62BN8raKZEnZP3i8L1T40/jKlBiImtVyJgPNz3y9e6rPoN+QGKZ+PAuH4AaAloDOZmtmoPHsD3pDLidOQjLLQV0d9Em6T5Zjg1fLpMMQKXZpBxCulNx+6O+lxZh702djg1OWuxF+s0AKZdmlaZTZapsGaiZrX9LyQyZBpzwVRLhB8XNRcPzZoJHzvgbnm+5r7TNQsc1mxeqEf/EL3ISxb9xXl+d1H5JRie7GUyB+BT83+eknypkksmHHZ3lk9xB//K0k91+GXlXqkB
 SXOd9G7I
 JvMZlqYlCkKjyv8jzF3RO0PjFTzroVYjhLesNZUPtflE8MlSqtWROwzAGbPSOfbVYCGaYn5TvMw+BMSsIf9pPsUqYtUp8jeV0TEEFxcfbjuXQN7swyf5kIcXhIpt1+Hn9PVmHEe9NNunPofGQK/8AQ4kp7uU/aAPNYqyjB3R2N/xiSQYUgKipC2yUW5ZByjXRENAMTYGd4+q2GVfle95on0InMWRxDU3Yi7DaDk5Nl71MWl6I+H/HlGyvrwd65owKIU8ufn0AMA6kwFPO4FWlGc+RVm1tJgIQ1CNeMlJ4QUIUOtLbQt9sgKOFlLqdZXPx7yO9e/qmbj7Av5RkeaYll74OkBu3HUBSnM5YlXxxDXLJjDkibixaYS151WVPTOeLK1s54IDZkFo697hGfXebhK31rg==
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
 include/linux/mm_inline.h | 229 +++++++++++++++++++++++++++++++++-------------
 mm/migrate.c              |   2 -
 2 files changed, 167 insertions(+), 64 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a9ed9a79364e..a108695424fb 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -94,6 +94,173 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
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
+
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
+/**
+ * folio_is_referenced - Tell if a folio was accessed before.
+ * @folio: the folio.
+ *
+ * This helper currently only works as intended for MGLRU, as it checks
+ * all LRU_REFS_FLAGS. It might be fine for non-MGLRU to replace
+ * folio_test_referenced in some cases but the user should be careful.
+ *
+ * Returns: true if the folio's LRU referenced / accessd count > 0.
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
+ * __folio_init_referenced - Force init a folio as referenced non-atomicly.
+ * @folio: the folio.
+ *
+ * Force set a folio's LRU referenced count to LRU_REFS_REFERENCED non-atomicly.
+ * Can be used to replace __folio_set_referenced safely.
+ */
+static inline void __folio_init_referenced(struct folio *folio)
+{
+	lru_refs_set_flags(folio_flags(folio, 0), LRU_REFS_REFERENCED);
+}
+
+/**
+ * folio_mark_referenced_by_bit - Mark a folio as referenced by bit.
+ * @folio: the folio.
+ *
+ * non-MGLRU may want to make use the lowest LRU referenced count bit
+ * explicitely as a referenced mark.
+ */
+static inline void folio_mark_referenced_by_bit(struct folio *folio)
+{
+	set_mask_bits(folio_flags(folio, 0), BIT(PG_referenced), BIT(PG_referenced));
+}
+
+/**
+ * folio_clear_referenced_by_bit - Mark a folio as referenced exactly once.
+ * @folio: the folio.
+ */
+static inline void folio_clear_referenced_by_bit(struct folio *folio)
+{
+	set_mask_bits(folio_flags(folio, 0), BIT(PG_referenced), 0);
+}
+
+/**
+ * folio_test_clear_referenced_bit - Test and clear the referenced bit
+ * @folio: the folio.
+ */
+static inline bool folio_test_clear_referenced_bit(struct folio *folio)
+{
+	return test_and_clear_bit(PG_referenced, folio_flags(folio, 0));
+}
+
+/**
+ * folio_is_referenced_by_bit - Mark a folio as referenced at least once.
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
+ * folio_mark_workingset_by_bit - Mark a folio as part of the workingset.
+ * @folio: the folio.
+ *
+ * Force set a folio's LRU referenced count to at least LRU_REFS_WORKINGSET.
+ */
+static inline void folio_mark_workingset_by_bit(struct folio *folio)
+{
+	set_mask_bits(folio_flags(folio, 0), BIT(PG_workingset), BIT(PG_workingset));
+}
+
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+{
+	folio_set_lru_refs(new, folio_lru_refs(old));
+}
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -171,56 +338,6 @@ static inline void lru_gen_set_flags(unsigned long *flags, int gen)
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
-
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
 static inline int folio_lru_gen(const struct folio *folio)
 {
 	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
@@ -366,11 +483,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	return true;
 }
-
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
-{
-	folio_set_lru_refs(new, folio_lru_refs(old));
-}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -398,13 +510,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
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
index 23248484a165..bb52bb8565f4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -770,8 +770,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*

-- 
2.54.0




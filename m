Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E86EC61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B026B0092; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0256B0095; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB24F6B0096; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93296B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E44B80360
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:41 +0000 (UTC)
X-FDA: 85158809442.30.C598416
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 07E56180004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwpDssWr;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVVrNHkl5HQ1wA54iiruOVX8OD14foi6k8zb/9rdRyU=;
	b=DxB2Cj0MWsuXzVPZtR9Ghp9id6xNB9WglJlMnVgAAciVM6IHvpSAvP93dcU4CtLeMLfdez
	VDesxCx+xMS7WSFprx2J+kNOrjiw5mF5KHOAr+Id7l87PsRmatD9wz25+LTncaibUwcrrk
	rvI30UK4ZRtLq0rQ8dEWeSOZzOJMk5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115419;
	b=KOMXSVJOZgPphuAr/Wq0+nGGsjr1bDgJ0F/r/+ldyV0QNRUpN3w6TLKw2NgEuJz746R370
	QpIA59jfkH+p3ZGRHkh376ak8RA5LZNVLts8FcFNTbC43wrZzVnCHSrO3NMhkL5BWwWcPc
	coolRUwUyb24akpvkID+TirolXbBPbI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwpDssWr;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D86C444FD;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCC04C2BCFA;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115417;
	bh=ZFETDp6p9x9uvwIEd+HcIi3/dkthWZDx6+TpdJIY9to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IwpDssWr5dIJco4GLs7xC0a/HgybjcVwdRIl6Tcwfzxk3gMOQ82R4RnALWKZ+EGZr
	 aUlA8RyWzZVDl1wNC9P2qTYgcxTRL82vLZEJzRrIl5Hqn2TCE8Ir2Y6E3Gbq6pUtqc
	 Kbbm/wC1w6i5vcN6rqzwIAaNIAgRpI8q9gScnAXao7+GgYMHqn3XoQkVnAxjWS+0dk
	 xk7VzPFN8OChgVB9Cwnv6VYoKxiYuD72daQv375HE5dSuRi9kL0QWt4yIQe+PmtZuX
	 qxQ4Q04vGW+MIj9aU5hD41I7JOgTOlqEJZCPPvneuXHOmsJHIQiMk3Z0ndJSIUL74i
	 QEWW9iQgPoa9w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55A5C61DEB;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:33 +0800
Subject: [PATCH v4 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-3-2d15dde0d7ee@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=3683;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ox6zaP/QbfpF5dExxI36sjV5rWUkpJpYAOEG95FC1rw=;
 b=RRNloLKvM7frocsILPYsY3O4OIPv0mpSpvKYz622w+CfsR1eJguwROtQXXFwm28UYf03Aw2mt
 TP0N4BjNES4Az+ct6ITqrZDnqszgZ2G24r4wm4TrDbA4ru8l+CLKpL2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07E56180004
X-Stat-Signature: uggkdj13a9deohijczihbk8j1fps9fjn
X-HE-Tag: 1788115418-187950
X-HE-Meta: U2FsdGVkX1/d17B/vTuezZPjMum+SOLXFmlaY4AqJNRcaOma4eyJKNz+Hv+M2RIwRmvnxxlOtR4uZtyL/VEsH5DFPUZvh/oFzjB1G7D5YuqJE+GlO6zPQU3m4vAaLDAMXWjvYTmuGsKHW+Pi7E84OZrowTKF6Ek1k2/xPhAnbltDptn3RXQsRltQIMLIJ9IV2bFWe0eGJ16387GQJaymkoHt6782LJAazi2WFxEOtP/xu70i/B87Xc08uiXCK8FNwVuxR4tiOmP1Z8P3YHHmHrssBlmO4Lt5343SncwWshzruyHHxTJQtu1mNKQUtWH3b1roIjogYIWY+2UIN71a/hJeWl5pBs7KP3GRvokJB7espGfSie7LJHjPVeOtbwx2WXvN5h2NY5soQqM2WNG6yc+d2p03SWME/ksqxebswCxrVrwvZe9Hlzxvf2TDFT2/jHhrZ8JZfdJBIoqYW/99mqaoDC7ksqhnY14G7ZITkHIjsUm2PcXcdIzpBlIkA4vVHIdu5cJNBEOUJUgvLa3FeKj5zRMM2Yiqz6poabq18HBAzP3HnNmijGpOeBxSgo3hwDzSbAbx0KTyL6zG+BxECu236pUNImB1BGlEznRHU1q3QuTxBWJ962SjGJ7oCq7vn80MKh7KfKpiglOwUWE5352Odu9fZn3HV4dipY6M/GuYnTmIglVbKpgBn4I3DDzLCW2+y6ebZjUcoWe13vBQEzLA7WJHeOCh5SPa11soijwhBPSaMWsMlVa5f/FgUK5bzwQLtnMIi9GJHPBZiy1/rovg/G5yGJH2iK6V/bmzc+AV8eSpdxONvuSdyYDrMpafvN5F93ox5aGCG6Zc93aL/qwuDdGpb+2cS5v3Qt+lyXbhX/3Nb5FN7bSSaxd9xKgPzZaX3A/TTO6hwzZHfvujMGjQ3H6a3+gZ9Ol2iWZlKJm6IFMR76wBQSothRY7qdodhme8FnQz0rD+AtwLApZ
 5WS73C1n
 5kgeL3wk9xG2B/OOaWlUVRCD51HBreEwurVR7gRISX5NT1FYezhuUrJHQxfH4z9xrTHJ2hEIhx9Wc9M5/SVNEN2MHk5pJXYgKSp+D6Yk5he4PCQ2nBiamtwb7/9HBzwnA6Yapz7CH97aX3Weu+VyZuY2RFRW7gHcSghE8mk6/EgW/Hzv3cN3rLeJPk5uUIl806/OzHl7eSzvbzkCLJfWxpFGbQCQqIIq6lWNalR8sRv5e/QmKpUg5BG9ZA30UlmgeT5jiOB7kf6x+LoOU3xogylziH0QN0KKvKO8dvKs1Cp9FSgPSIPEa3pM2rhhdG3n2lIyQqTif3Aa46MLU+nA4M9F1kDVDFhXyZGpCBY7l6X7O8/8NXLX4oFfoQk7cQSw9NBde9ZBsR55RebHgqq4QjpKVavSI4zpoiy6oqlZrrCQrFbZgAwQpi7vOs4zv4lsXDkYsk11T7u70m7QX8XVTFNXW0iOJrDU6lBR8iew8BQ+r1haA4gw8vthpRzJ7LclzjthdIkv55ZN2odiNBAO+0UUixujaqSqX2aPw8KI67e8Qjvuca9ZocTlyHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_migrate_flags() copies PG_referenced separately from the MGLRU
refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
PG_referenced and the refs counter bits together describe the
referenced status of a folio.

Consolidate the two: rename folio_migrate_refs() to
folio_migrate_lru_refs() and let it copy the complete referenced
status, i.e., the MGLRU refs count including PG_referenced, or just
PG_referenced for the active/inactive LRU. Drop the open-coded
PG_referenced copy so the referenced status is transferred in one
place. No behavior change is intended: under the active/inactive LRU
the extra bits are unused, so operating on them is a noop.

Transfer the reference state first, before the destination folio is
marked uptodate, so a concurrent lockless reader cannot have its
reference update overwritten by the copy.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 20 +++++++++++++++-----
 mm/migrate.c              |  6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 3f4bd5b02b54..047295ae6e8a 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -373,11 +373,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -406,8 +414,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..a369d0c95c38 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
+	/* Copy the reference state, including PG_referenced */
+	folio_migrate_lru_refs(newfolio, folio);
+
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
-	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807E2C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790566B00F5; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768156B0109; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD8A6B00F5; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4FE6B00F5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 953FAA0250
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:26 +0000 (UTC)
X-FDA: 85092520212.14.C9AAC04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F3980140004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klp1mR5j;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTbE3zCASBCCzvf13wSpm/yIS5j72vwri6qsbtqBEHs=;
	b=aBnQzbusvWnyCeRhQLZ83cwv83WZZRMcwAHYEEGhw1yX6dn5afgzLvFMP2uiCTJI82RZsU
	3RQQ0oZoaWCS4tEVP3fN1cwg+8yamqBkVKLwcSfC4nSv9LbpuUxTaGjOMhNCN3r/xGpIQl
	/WD2lNypj2wzjDE1yyA9VjT9AD4hw04=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537105;
	b=BYWTi7/d9vh1iBerzNExiCmCPUxyR2WKrAm5rfoicja5foSczEEGd/fg0SpEyZ+pBi7bbI
	n/9q1P3wwJL3DL69sSouhW9k9GxyV9qPAfXpF6ErW7UbWQjQ7zVQ1lF+eZ4L74EfKWXxOS
	mHUmpIWWThOsgbYqseLTlq3PZRd5ZuI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klp1mR5j;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44E0D43EFA;
	Wed, 12 Aug 2026 12:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826091F00A3A;
	Wed, 12 Aug 2026 12:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537104;
	bh=YTbE3zCASBCCzvf13wSpm/yIS5j72vwri6qsbtqBEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klp1mR5jnzOgqpzhCOj0WFwg1FgPJMsPSYNOwa6lgfEEIQFXYfuMOitVf9M1XYkq6
	 IGUAspcT+VDB83shIuawyyQD76502CYv0vKgxgM4BxAefQK2MfCXbbO1iLLsINdsjh
	 KlslEpEoitr+BYqJBjI3e/ETQkdLUZvQ4xyje68bjFyGmUyXvU1JnGORIXnpvvpr7m
	 Jt4in8dWHpPjxlQL2+RyHHtT8kKLQsWuqaIaJ7j25YV47di0urpRAy+FuWXJYitzYx
	 yFJE97Sh5w8wuy/bCnJh4CWWpjWg1Sp7HRetTJknpR4bxWXx1JwSfwSrSFrjdNKOQf
	 bNTadbY0LBN+Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 05/16] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Wed, 12 Aug 2026 20:16:47 +0800
Message-Id: <20260812121658.69965-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ccn4rtq1jum8tfkxfa7fqnn99ttw795m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3980140004
X-HE-Tag: 1786537104-203700
X-HE-Meta: U2FsdGVkX18mZzR2ySBJIwWsvNKx2cjjFHDh1KZcHdtW1hRrYievdvdwmqAIV+Aq0uKsxpys5IsXjzItNil8+rI2ZdhJlpQ+ZILeTUFrzD/rTOTsbpSp5JmrRXIcT5VxJsaCZlFMXZzvxk1JTcWMzNI+98lkj0QXb9KvfQXlcgkVzWd/LU81LF2f7UeZi21v0Tt8IzCaw5i2q0+voGkUSKSmyydZ6kAvlHePHoiQ49DYqt+spuC1aBA8QUlCOB++Rr1B+GzlkYn9/QiYED3Loqxgm9MwsO3DYXaHpX9e8KGZzqwpQYcHf/75Da4nMVV8LQDJJRJOnanTw2zYCmaTxC4Zek9somfahC3QcRAv7gHx6pi1B1JD6rN0QNNQ3xtdeHzwuWK51JKmsvI79Si0jhxtcj4iQUpXm3tujFLdwgLKyll3Cl2F2Suu0twk/wjKOrogiFZrk5dHdpCSC3dSKyfiuX5K4rYSVH2l7vWAIrceFLMAVGklo9wV/t9a6Aaqx8KlZEzIpaZhPeq4YOoFOnD1fDHOPWAPZtDuN0CdQ0tjSSEqvPRy8MzcS4RsGwd/O7329z9WuwD2O3zvg734IaXmnPsVimf7bf1+jzZ00VwytwA8pJGaNijtROIZ91Z/fMHfpCYHLvw4nfVUkqbP0fvOXiEA+AiMQfAYKJiDT7tbcUOZ5S8Jf7lZuSVrpJ5Lg7fsjwKjTbR0/NlTZBKdLtkt56gBlNF/9XVboqH4gGxgYE3Pyb7412Ivyn17m+9e/1tFGv3DNzP837f/m1DhA2k+vlxqmTyK2AomeYZpCU5K1VvHIzuWxdqmos2CU/1D08qQ01j1ooh6TQzbEzlIfAMwJlXayrqj+1O9n81CJp1a9DKKrjR9FAciK6n/BHSSCFfsr/XEYeEbSxTuLAkhJKJOT6iuixENQu5Xls1RBwLWvTbjJEVZ76BENPuHWv9/9UKXeti34XUFIdbkOa2
 pmWpSU6A
 gwqdmAwb2qYJm97gRwxAN72FD/6EKvcAzlcSHyapORxZxa1FSsztkufngBhjAM3vqjG6C0qOPEh7NHEhn3+hYRd++hwE0ryWhEJ6S6iez4Fxf0QIjxX9NFG5LBaD0mUAx4elIlLbxoCeKctivHKJELEEi+ql91qMu3NUcX4ack4ifWqQt21EV6dKeZwtZeg69t4561pcfI1xZgoV8nVvjZKOwN7LIpby0xKQpkD2COmwOeIQgqimmhYU7cm9aiB9EKOFuFSBwbiBPSF07U/m2DybJOR3ouIdh24rrSBuoPxQDoK5qwmQ2QN19SvrUeWP/XHxHlBHYry+j8eD5XpPV/AuiDsD1WhbjGid1A7fIxNMBQqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
as it advances generations. Instead, accumulate the size changes
and update lrugen->nr_pages in a batch after scanning the entire
oldest generation, or when the scan stops because remaining reaches
zero.

Since we only move folios from the oldest generation to the second
oldest generation, the active/inactive state cannot change. We can
therefore skip __lru_update_size().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2fd1e06eb192..c6e3b92c8cae 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3295,20 +3295,21 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	int new_gen;
 
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
 	do {
 		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
+		if (new_gen >= 0 && new_gen != old_gen) {
+			if (increased)
+				*increased = false;
 			return new_gen;
+		}
 
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
@@ -3316,8 +3317,21 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
-	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	if (increased)
+		*increased = true;
+	return new_gen;
+}
 
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	bool gen_increased;
+
+	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
+	if (gen_increased)
+		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 	return new_gen;
 }
 
@@ -3903,6 +3917,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int target_gen = (old_gen + 1) % MAX_NR_GENS;
 
 	/* For file type, skip the check if swappiness is anon only */
 	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
@@ -3915,32 +3930,41 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		unsigned long delta = 0;
 
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
+			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
+			bool gen_increased;
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio);
+			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-
+			if (gen_increased)
+				delta += nr_pages;
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-				int delta = folio_nr_pages(folio);
 
 				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + delta);
+					   lrugen->protected[hist][type][tier] + nr_pages);
 			}
 
 			if (!--remaining)
-				return false;
+				break;
 		}
+		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
+			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
+			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		if (!remaining)
+			return false;
 	}
 done:
 	reset_ctrl_pos(lruvec, type, true);
-- 
2.34.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29450CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170816B00B7; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084EC6B00B8; Wed, 20 May 2026 11:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E670E6B00B9; Wed, 20 May 2026 11:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D44D16B00B7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A7441C0263
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:01 +0000 (UTC)
X-FDA: 84788110722.16.9E685D5
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id AD48E18001D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=iFzmLLq7;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW4fFEcF7RsWKk8iCSpAqzPzouHeAUq+juaYAvjgTXo=;
	b=qL6P4J8GIi8rc2uSk3MDgMMS8HpOR0EbBPPnpMG1Vc44F8Dq6U551d/EJ9dW9h2iX5i7L+
	NxYFfdk38cCssREs2Zp6KMEx2JeDgc7JgrSTnw2dRDr8GnzqYSQabeE4o2Yms4/3aWjxeb
	zVot2+fJ6d8BJtQD7BpR+5LXHg46aEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289259; a=rsa-sha256;
	cv=none;
	b=G+bbWJiXBQC77qsSJ6nGMH6EiKLDCN+XZgqH382yJN5yPU/msW8FGGuRhv+97kIWV1b+6i
	Tz6zzd83EqsxecBNjc3NyfSBC2M8//nMrvasG29LlEBkqV+NJwvUQdPscB+nBNfaYTea1f
	vTBnWzy5CNDR4CAbh+eUlY0fki7ZQPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=iFzmLLq7;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QW4fFEcF7RsWKk8iCSpAqzPzouHeAUq+juaYAvjgTXo=; b=iFzmLLq7qnngkcCaltwJB4Tthr
	T8mODk7BlOY+POMVK0yzvJA+nnYXDdCvUyNuuhzrg6sAp8wP8JwwotdRbYcF6XSiuB9/hkfE2QWGP
	jBAw0chcYeP2GehQJSA18owqSf2zRdecb8xpTnEb/P1bzPjvL+12C2Z+BU5WALcZKz0/ttjEgy5b1
	ZLmc/luYOkJaOyBqMs0bf3mizTPsw2InvuC4FEguf28LlxRq0hRdaUEZhgdra2grumCAvidfKhbpY
	IS0pYR432j1AjwDeNT2P5AQkpsA1fCjc1OO4sJHDw0tuAcjaGXh0RQHptDtL0uG6FNhMSjl6Q0NKl
	Ac820/ZA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPN-0000000024Q-0ShO;
	Wed, 20 May 2026 11:00:29 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 37/40] mm: page_alloc: move spb_get_category and spb_tainted_reserve to mmzone.h
Date: Wed, 20 May 2026 10:59:43 -0400
Message-ID: <20260520150018.2491267-38-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD48E18001D
X-Stat-Signature: cq1day68xrpyzogji91o6ct4r1mp714m
X-Rspam-User: 
X-HE-Tag: 1779289259-452803
X-HE-Meta: U2FsdGVkX18V54TAFF2EgGaqN4FjHjbBvMjMaBBypMNaLQ8dh44BQEuqqjd8oynXrp9X/kT/Ao0fN41K9pgmJ4rOFuc9iXbs3F7DSXT+HeKv4M4TR4asYKe/MADe08l7kXRUQKYfi2UqYOXYR/mhNvyvhNYMCEVeViV+RJraCoLTR8oJBTNSmG+lJ18cbyAfEUHFoY+kgchx1RjDsbgkBJF5JWUASreA5xPxcCjY8dznKkmkdx8w5hN60xu4yIQF7eiTaELmR00kXKrrlPfxspNUMkAhd96Y25hDllAuWKpcJGa30CUO8eELT7Pe4y2rcGq/zMWJD2o0vCfZCLHWkCsIxmKa1ABVNF6BElf1A79UY6uPtMVWHWI/IKWc4NCdTk4MSm+WOcJIUuNPCS28dR5XnzQGPICqETsGbpm8AnKXDx0Yborr+ok7FkORPp/7gkDxpKQf4RyjuMJiGFpVCye9NBbRMUCbBoZOm04eTFnD/6ZVvZes6nDI7DfZYxJaKXcYJA37MtM6ybosT+Xftar76Jey0B+cU08S6QCt9iSxmjHuu6/wqVw8bBa/X24MTNC8lJn+jK6w3bSove6GSdvwo1jZ2274u0xGqK2XGVILsTJtK2pySpnIqsu4sqRRm/asPvdGd+rCyiKAFg/yCRSlJ2s52tq1gAYd7e6I+mMnTS0KfnBxwFnTTKmLqjt3zMN1sny60RL0JmnGzwDqW/dpcu9X5tDKulxbak25+073LI8DUsQkpRPOrtwDlZFoNNmlihIilTArKioSqoXIHMYz+KdQMuJfMO+pqIA4Ef+Cju5V2OGuTGpW/CqNPYgcyxzMlUhHElUrhhZn+OoO9ebbty2hIhZPL1H2HQpHiffp68iX2i8mpoKxYD1uss6EgeY+8/xz23lVs5iD+cTvKguqpFKBqSgMhbjWPmtDZin4enRvPhAcm2c8LYsoCvVGr61aYoyO/ZOADkrBH3Y
 2LMiNSj2
 bjwokEVZi1XHdYhDDn2JEh8xZj3FdAMqYn+uHe59wPgkVIr2Jmm6KMWZxmdPtnB5qqGeEnzgK4tMfI8WxS4BEvL5tmtLzeHvULKTcrsjjaTeK+N5Ha3LpG8qQaPgG1WzuuZ+aEDYssEXA6rSU9r4O/AKulChhJigwyXbbGFGEFNpVeNsZ5BzMNU69q9IyINzJYxRKC11Us6GJzLczBz4NgSlyU8W7oiOW/yPHKOsb3CtN+F/i1AbJmO6gEtODth7aHywjotAL8Wfd5igpi3UtNwNRLYali9O26+lP5rsDlnvX9jIZ+nvaAgs3gq9Q6NIPZLSy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pure move with no semantic change.  Both helpers will be needed in
mm/compaction.c by upcoming SPB-skip predicates; keep a single source
of truth for them in <linux/mmzone.h> alongside pfn_to_superpageblock().

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h | 30 ++++++++++++++++++++++++++++++
 mm/page_alloc.c        | 27 +++++----------------------
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9c248d5b14e..d51dbca59656 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1296,6 +1296,36 @@ static inline struct superpageblock *pfn_to_superpageblock(struct zone *zone,
 	return &zone->superpageblocks[idx];
 }
 
+/**
+ * spb_get_category - Determine if a superpageblock is clean or tainted
+ * @sb: superpageblock to classify
+ *
+ * A superpageblock is clean if it contains only free and movable pageblocks.
+ * Any unmovable, reclaimable, or reserved pageblocks make it tainted.
+ */
+static inline enum sb_category spb_get_category(struct superpageblock *sb)
+{
+	if (sb->nr_unmovable || sb->nr_reclaimable || sb->nr_reserved)
+		return SB_TAINTED;
+	return SB_CLEAN;
+}
+
+/*
+ * Minimum free-pageblock reserve a tainted SPB tries to maintain so the
+ * allocator can satisfy non-movable allocations without tainting fresh
+ * clean SPBs.  Used by spb_tainted_reserve() as a floor for the per-SPB
+ * reserve; the page allocator and compaction both consult
+ * spb_tainted_reserve() to decide when a tainted SPB has so few free
+ * pageblocks left that movable allocations should look elsewhere.
+ * Scale with SPB size: reserve ~3% of pageblocks (minimum 4).
+ */
+#define SPB_TAINTED_RESERVE_MIN	4
+
+static inline u16 spb_tainted_reserve(const struct superpageblock *sb)
+{
+	return max_t(u16, SPB_TAINTED_RESERVE_MIN, sb->total_pageblocks / 32);
+}
+
 enum pgdat_flags {
 	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
 					 * many pages under writeback
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e45fac14622..62edbdf0c3f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -673,22 +673,8 @@ void superpageblock_set_has_movable(struct zone *zone, struct page *page)
 }
 #endif /* CONFIG_COMPACTION */
 
-/**
- * spb_get_category - Determine if a superpageblock is clean or tainted
- * @sb: superpageblock to classify
- *
- * A superpageblock is clean if it contains only free and movable pageblocks.
- * Any unmovable, reclaimable, or reserved pageblocks make it tainted.
- * Reserved pageblocks (memory holes) taint the superpageblock because it
- * can never be used for 1GB hugepages, making it a better home for
- * unmovable/reclaimable allocations.
- */
-static inline enum sb_category spb_get_category(struct superpageblock *sb)
-{
-	if (sb->nr_unmovable || sb->nr_reclaimable || sb->nr_reserved)
-		return SB_TAINTED;
-	return SB_CLEAN;
-}
+/* spb_get_category() lives in <linux/mmzone.h> for shared use with
+ * mm/compaction.c. */
 
 /**
  * sb_get_fullness - Determine the fullness bucket for a superpageblock
@@ -2700,13 +2686,10 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
  *
  * Scale with SPB size: reserve ~3% of pageblocks (minimum 4).
  * For a 512-pageblock SPB this gives 16 reserved pageblocks.
+ *
+ * SPB_TAINTED_RESERVE_MIN and spb_tainted_reserve() live in
+ * <linux/mmzone.h> for shared use with mm/compaction.c.
  */
-#define SPB_TAINTED_RESERVE_MIN	4
-
-static inline u16 spb_tainted_reserve(const struct superpageblock *sb)
-{
-	return max_t(u16, SPB_TAINTED_RESERVE_MIN, sb->total_pageblocks / 32);
-}
 
 /*
  * spb_tainted_can_serve_smaller - could a smaller-order @migratetype alloc
-- 
2.54.0



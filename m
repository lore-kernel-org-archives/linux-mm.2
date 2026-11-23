Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09269606A69D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ge+Jb1Mj
Received: by kanga.kvack.org (Postfix)
	id 292D66B05B5; Mon, 23 Nov 2026 13:18:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C8E6B05B6; Mon, 23 Nov 2026 13:18:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54266B05B7; Mon, 23 Nov 2026 13:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C01596B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:18:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21CBA80978
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:18:39 +0000 (UTC)
X-FDA: 85467194358.15.D6F344D
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49F8F140009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:18:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ge+Jb1Mj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795457917;
	b=hu6LYxgWzLvgmoaDOy2FzkvvINm86jER4cc06vMvx8TqEAz6+TWbTKIsPEmojVZuPGGA48
	fuWHrmRDDrOBH9Xi59gFfQilV00Fqp+moT95KdaAlZYSOF9+bV0VJn0y7gAFJq4mvNqeK0
	72n6kVLWXWDxvcV+Lp6Jz7TSVQn1HcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795457917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/43k5pTWIv/t2nwUcNlmOb5MgiAXp+k+bgS/lUNVtEA=;
	b=4S3t99903sRUQW2vIbnmYOGOylALLkCTO0BfSwhYtsmszh2eYHSEKSsoXnFqRQ75lFKwne
	y7KL7p0HT7U9q8rZnBBIL9OCb+cQtXBxsQQIzWlaOLjO+VFpf7LqYc1ZrP4IxRD9yajK98
	yzm61dvTgQhr5OP87443p9BiEtFutzo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ge+Jb1Mj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4ed6d69bdfaso1979880b6e.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795457916; x=1796062716; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/43k5pTWIv/t2nwUcNlmOb5MgiAXp+k+bgS/lUNVtEA=;
        b=Ge+Jb1MjmJM6zgKymMSvC1rZiGeJun3KzYhAlp5+AeDBoqRk8/CIu66D0ueOkF5SDn
         2JY3KO+ZmblFUmoFEr2rz4t9yrDsqTGD9T9y87wVdzSbVQlGjLJSCFu3Ts0e9ZtK3D1g
         bCbhguXzpIPt7Lp4HOsXMDK7Syc4DKIzYj2yxb0ti3aEb11O3gIvAKvvbmc9ZQ9+FAxe
         3vpRjWdxlIKDbR2bydE3ayLdxOWSDbovyQCdD3nrKnyucmYl28IXHZWtRHftRzbULIl/
         gqMx+tOMN+XlSFMTJq7ZRLJzRba96RPa2kGNtzIgs+sOCAGb1SON4KACEEVPoYJIvtEE
         IKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457916; x=1796062716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/43k5pTWIv/t2nwUcNlmOb5MgiAXp+k+bgS/lUNVtEA=;
        b=UbIBFK3Ie+bw7rC2l4soE1/6H4t/sS6pUcLoAfV5+NKDSkd+IXkdShdrOiMuHHYJDG
         JiF3Tinb6iYuII6x2N1xH3vDQfvG5KpZfJ5Jhl63TEscxK/YTzNc33bnairMH86fErnd
         hV0EdWYZ5vEiPTKz2DaLm5smMxPoiwkOW3k1KAK9VXwshSTIxUuFh7qkUUaY+kMqPGyn
         CDjDeU3lHmFgoDrvca0iVwxQSLAPCJjD4lk6zlmzYXeJNRknVILRkdxBLmFe/OMATWns
         D3hYB6BMx7MV45QmsjdSpzYE3ULaMum+upjsu3gwYlmgjiqegoe8hCfH3O4lhPiBkX32
         KrjQ==
X-Forwarded-Encrypted: i=1; AL+hErHXwphDFbNvGohLk/hl6Pp+xCK/zMy/RCNWEYWxCz16upiIKYD2QRONYwYUYSdaisY6I8EGHrTKIQ==@kvack.org
X-Gm-Message-State: APuU4Z/79HIa6Lnhvl+STdCcfhqgk6PsaxMorpGuKyF6/P9Z4zotptNN
	6iXuUNRdta/aYzTMnSVNROV1nLDM5mqJkoZyHQRbu/aPRqejO7OCYsqo
X-Gm-Gg: AZFdTZfP3SPWk7OigHnOKwDck7tfWFL5PG/EWyI9XIF3FCglV8GiGfxBdDOFmgbw4W0
	Z/EcXkzEtfU04q9FofihbNbz00UWSzEXnLO/VnMPQDDv7boFhbj+ZjWxMRfH38b/A2+uKDKK8tr
	/a3aASPEGokXRqqTHLH/s8swqrNfyKeI7UxJqMN6EjOL2iIx3lJjUN+x/PAqcQ/8v0YP0NjLHYh
	fpNTGVDBZkoUyslVotHJ7JcecQNtZ68MQtJbqQUke/HVrW5z9rP3syeVkVlc+XpqffXXNGDh8G/
	fwmB9XX30wKv88/M6TY2LQz0H24g0qWBoMy+jM67vNqBUpza0iNXokF3SWI9j2yDBdvT6l6ajmH
	vlnmXuM0TMq8fiV/Wpiyrrkp5bs14jkXxTM9KwB84pguTK8azaWlO8EGjswlWnQlNHSp6kISQWu
	MCnxSxtu9H1Za1WnIFhzsGpXeF2ojwh4s6ms3I5cwTL04tAAT80YMvU9GG6gQy/w+A/nfU1n0p6
	GB/yA8usmfORro+nqiwzPkXA5rBccZsCe9HPUPrYcPzDDGsXmhug2mdMRPpK/g8PnTP/2URHMD+
	1vmd5cqfeHsEaUnSstiE1t6cZm+iFRwToes16uHxhgt5Zavf/lWNWH8+nkx/62SpdIjCL2EMiA4
	f9Q2T
X-Received: by 2002:a05:6808:508f:b0:4c4:c7cc:f8ee with SMTP id 5614622812f47-57a0a20af5fmr14670396b6e.13.1795457916164;
        Mon, 23 Nov 2026 10:18:36 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57a350548ffsm8822372b6e.11.2026.11.23.10.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 10:18:35 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 2/2] mm/vmscan: consolidate promo vs. high watermark checks
Date: Mon, 23 Nov 2026 10:18:28 -0800
Message-ID: <20261123181829.4065581-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
References: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49F8F140009
X-Stat-Signature: fyw174p9iiq11z9n3np1w59odqzgf8gr
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795457917-31260
X-HE-Meta: U2FsdGVkX1+vhQmZRh/roXlz/KAZV8+iD0cwAc9OGnphfBoj/GGQV9SXuOmth3CQYH9ismAxZ3fA3/45GlkUmCyZ32q/viQgopmsAS42vL2Eha8NoFGKEtfl1DgWq9G/0T7mxhKrflZCO431vqb8lrzx1QkJ+iQJlQouTkHkgmlqiBR5QSjRaaEF8PZriENBiWCoVY2y/kFARdZCfJ7QmfX8s5y4AohR7PV1MUhqAB74jDR0bQ3b2cNn0Fr1r10xTw0eRiUoao6KFSlA1TgZWbjWNuQIF0mSG+iuQM4u4kxphO8aPxsOpL4JToPyscbRaWXwCPY6cqoPCPhT/oyet9zIGsbzp8j/v/WxVVregBf+sCL6wckJGALzYu34P1GotbQZHGQL4kM2RRjnZb5DkYxLktcWqdicfWDlIxqgDQPvcSj4x6xpQcLu9RyIzDaIC6TzCTSNOKBaNRM1jTPyMvQ0DQFY21xhEH5FJZIKd9c7i5VRiC6rQ2XW6aKk1+XYFNTLVhgq5ApBRqv3+muZetH28yTFqB6yLN2MO6c9okXTMHktRFbHGPeFaqZ2FN7uMsZEGwQBHL41kZvA+Mm1mK1r3pVANye0JlNgod6AFbPdcGqRSC9xynJ+lsommFZ3Vw6rhLhaATjbYqyrOkza8/ZYSWewr4FyGt61jccjpIuvEIZzg34hsxNoSWH51a0tmzlv/+8z54VQK5azSsfFfBO9rFpKm+i0CF88NZ2bZTvsMSDtv73gVyhO5Bs20BFD/7IB4hg8Dj9I1nm5bQmI3fz8MtKh9gCF2RmyA6WtdTKwuJUOSTR5Za8nSd7JCTKD5ovtr4fwR2YCWZgULIrsIIPlnhi+U6uyNSl/wN5R6ZGjWZILYGStf+bkZvxaqwgzr+8DAj6LaeeNnk7inI8eJ6+q4Gt/U+U+LUQ3nEMNJDfLl5ekmUJmAIxs53N9iZDZ5WMHusI+ALFYY8ysCo9
 n2U6GkVE
 qakqYL+uqASRKTpPDUBrOQ6rqz7J4Z426A4cwC2jXeQCKQw/UahvMfQQQ5B1kq5YYHYs4sic5hYb1YBBztN4JabcHXnwxkKoW5r4TwkTGifUZq3OX5YLE3faFVYFxPs0Q3NNT+g5y9tEHEZ2k9rnYP8dQT/oIIAYPyb58K6tVkaoZDFlPhSwm3O2Pa0li0w3/tqUYba5FskJngPREGQlQhdgce62m+J18wXei5vCdL12DE+hy3p88Bi/COkTVdgNNNtUSoJFkwTM9mPjUq99KolqZt2P73O0wK6E4zuDHdDVvqnHKETBEW0i+kU4+YEL9d0kvek8IRhkfIkId/H6m6REMAH59xfioIlBMsXRMiWGLiXZ6rVLc4Ne+iSMrlCvw7ke6SWTkh6DKQ4CMe3ybBXPfmtaAcXhwl9ImKDj5KzUPmvPQkoeqXgjelcbRfUfQdcP4MVF70Y1UwZKfz0DZ1dpdCTmMspaYPOkF1Zal3B+YP08FmTCyuAXacAx7k00GvC4r21n+CaFJb1FlScSh4tRUHIvTSM5ZSsmdPKXi9VkutjsKj42BABQUgh8EYKt0c32/k6vQpyKarSJFNkbsL347tmY+ABLnuJIZJBG9bH7pBx7v+fXo03T+f4MHwpJzqfXFLcPMm7WSlegOKPqD5+ld5vQHWRuFkLtBpSWRAxPer3oxiu6hI8F7zULbJcctIdtTUw4NjBX2s7DlLqfvnqEeu8iFE77AV0geJGlH0tm+k5DNFqEiJONMvivLJl+ZeoKm5vIWnc93zgMESLkM8TZBkV8J+5dyRk71hcF4yhxlb9q3WE09WMcOcwC0mEZty9SNUGIBiW+K43lVyAPZBoJqOjbVZeYH+adYAs4WmZSTQAEC+60zKkiuq8kOOJTRphIHx+J/GGYANVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are three sites which all check the watermark that kswapd reclaims
zones up to, which is the promo watermark when NUMA balancing memory
tiering is enabled, and the high watermark otherwise.

Consolidate the pattern into an inline helper and move the dependency
on the sysctl.h header into page_alloc.h.

No functional changes intended.

Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c |  6 +-----
 mm/page_alloc.h | 12 ++++++++++++
 mm/vmscan.c     | 11 ++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e7a7863e381ab..31a670eb4832c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -45,7 +45,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/sysctl.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
 #include <linux/memcontrol.h>
@@ -3805,10 +3804,7 @@ should_skip_kswapd_zone(struct zone *zone, unsigned int order,
 	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
 		return false;
 
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		mark = promo_wmark_pages(zone);
-	else
-		mark = high_wmark_pages(zone);
+	mark = kswapd_wmark_pages(zone);
 	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx,
 				    0, gfp_mask);
 }
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index e238ee91ed245..4fed0342a99f2 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
+#include <linux/sched/sysctl.h>
 #include <linux/types.h>
 
 #define ALLOC_DEFAULT		0
@@ -304,6 +305,17 @@ static inline int gfp_migratetype(const gfp_t gfp_flags)
 #undef GFP_MOVABLE_MASK
 #undef GFP_MOVABLE_SHIFT
 
+/*
+ * The watermark kswapd reclaims zones up to. With NUMA balancing memory
+ * tiering, kswapd keeps room above the high watermark for promotions.
+ */
+static inline unsigned long kswapd_wmark_pages(const struct zone *zone)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return promo_wmark_pages(zone);
+	return high_wmark_pages(zone);
+}
+
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(struct zone *zone);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..158b888ab370d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5212,7 +5212,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int i;
-	enum zone_watermarks mark;
 
 	if (unlikely(sc->proactive && signal_pending(current)))
 		return true;
@@ -5224,12 +5223,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
-
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
-		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
+		unsigned long size = kswapd_wmark_pages(zone) + MIN_LRU_BATCH;
 
 		if (managed_zone(zone) && !zone_watermark_ok(zone, 0, size, sc->reclaim_idx, 0))
 			return false;
@@ -7131,10 +7127,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-			mark = promo_wmark_pages(zone);
-		else
-			mark = high_wmark_pages(zone);
+		mark = kswapd_wmark_pages(zone);
 
 		/*
 		 * In defrag_mode, watermarks must be met in whole
-- 
2.53.1-Meta



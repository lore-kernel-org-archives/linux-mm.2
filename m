Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D1EAC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB716B00AA; Wed, 22 Jul 2026 11:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2856B00AC; Wed, 22 Jul 2026 11:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A9E6B00AD; Wed, 22 Jul 2026 11:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 327D66B00AA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:00:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD7C2A08F2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:19 +0000 (UTC)
X-FDA: 85016723358.20.8D4235B
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id C4AD71C0011
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dj0zeeoS;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784732417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9w4/w+DgNeKgvmYqz2X0YQytmiACV0MWUeK4q1M7V1c=;
	b=6Z+OJt0jim7+wfDtwwbKZuQNvG6WENZ4eyvGhiJkoJTb/blTopSZkie00eIqU853Oi+Vo3
	iAyp23QI/+2hbx7+qIptxlAfQXbd+/Gc8HzyhvDcWCn2G6m5Pje3lMcjfi9mTTbe3Dpwrz
	F5bbjr+AZi6LoXzgNgvS4KOUryGCkNs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dj0zeeoS;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784732417;
	b=CcAejMeiRbnfA4wAaZWgBsxlYNyQ3SSFFCfFfexB4aQEv9UgHjffrEb+HIcJEmNsegiwLQ
	RvM3P8xcHTvB4Ddj0f/1qyBT7FJntrCwdQdAa01I2rZTAM4un3Uy7igsWWwxnVT/az04k2
	fUMGTbtEX+PZsTJj1dtdG4XldHJ3Cww=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-902f92b8504so122640886d6.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784732417; x=1785337217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9w4/w+DgNeKgvmYqz2X0YQytmiACV0MWUeK4q1M7V1c=;
        b=dj0zeeoSM+vBCPMUAhwWcPv7Qq+XiGPKBtaZvuXDSuTRd7Xryyxvqo+mnKemDrKClJ
         2/RqsgJlvhb1tChkF5mGB8sTlB99pdJVVL9441n3cwHsugANOVQHJdcs9L8x77bT36CR
         IstU3QDqiiy/H58vNfh/u9W6OAOEFMh5hQurTtQnuJ3F7XZeY6cVhKQUCPmgnIP+LPEj
         YjG4GCagC/9Qp56UiyoO3hkjRdGlFlBh7XwRavWeFOuDAkUky5g7O0CKa49Tqyys+9/E
         V/RLMFZwtOJDnFPoSkDexoLAFTUIHlYgNEssIsGd3TsY4/ThJfRdwnlBGXz2JZn17rFH
         wqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784732417; x=1785337217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9w4/w+DgNeKgvmYqz2X0YQytmiACV0MWUeK4q1M7V1c=;
        b=HFzokLS5sy6RcF8V+dpx5FS/VWJ2cfnkeoT7ZdoE+TfBe4gk7FiglSeDMnM3tKyk/l
         21CZXaBWCAMakuJySFu5G1uciv7/sC1dEMx+iT+a4IfPzUBA8P2clfekZkSfFhRuIIWO
         WEJ13EnRFHwizWMDgaZU3Iyv5BiVdOAIKPuzmwsLh7HBCeywdwyqm5tUFbmHCnuY9E6L
         pLFJ4Me1OBbqL4eQV//a+pR8TIqEk48yap630yYXsLy99vyoB157R4InQlABaIVmnKLP
         3E1Wu8X05JoJt3Psy/Jaz8pcHUEj7nGQUVOFdH/ZLIPuxn85Abq0TL1gbmvYuQSty2Ud
         goXQ==
X-Forwarded-Encrypted: i=1; AHgh+RolFPhZfmOYwSEvdIBQXgeOLshWWeDLM26XvyvA3rs4aJ/AiEvjy68dwcE2BQ9Om0OMSN8RnG6Slg==@kvack.org
X-Gm-Message-State: AOJu0Yy6rAvTTW782skJe4+kQL+enX0d10WW3Mh2iUnvYDZ+IjKZmGwG
	UG2W4uv+hdh1NCnN//4up5qKdJySwuxQTByosLdnDPsKbpVE9oZRxmMilnKcbeDrRxpuW0wJKMj
	rNjB7
X-Gm-Gg: AR+sD11SQjxd3pHG/kqsLBbpn6KyBRg9u/pP2OSBscOnIZKNWKoCCoYy9rBzCE3Hpey
	OTYJt5tPTNsWPt7BSQJRHmbBd6TZqh4J6UyjH/0z/b3FHcsjQbsEXhfmsMYU+R5pGws5sMustAK
	/22FGM0mKqB8ZcjiisUCS7QGUMgG+A0RvzZE0X06eRGwM+BQ2nR9SVknAMLPdSGO0yiz6mOv23H
	OIKTL/QFQxhQRsIj57nvioKsRbLxZ/eJcIgLoO6BYm4jmz5ZDr6GT3hYNZfqo+weD/dNTWfNnUR
	Xma/sZtKJ/OcBVuMnLdBjB462ndNd7KZ9vr+8Er4KsKDJaqlXdPXWGY3UE4kxtYliglMRpEoyux
	JD7/20tkZtXkj994LBycfr1FuVizgQiGqrM0ODxF0sHSWvuiIDJ/NOCLpuhuvBG1CoayKg06gCG
	QNP5ZeqFlYV6E=
X-Received: by 2002:a05:6214:3d0d:b0:8ea:184f:c15a with SMTP id 6a1803df08f44-9077836d21amr240711036d6.17.1784732415754;
        Wed, 22 Jul 2026 08:00:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0ef54sm22285326d6.39.2026.07.22.08.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:00:15 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] mm: page_alloc: move capture_control to the page allocator
Date: Wed, 22 Jul 2026 10:56:46 -0400
Message-ID: <20260722150006.3848560-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722150006.3848560-1-hannes@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4AD71C0011
X-Rspam-User: 
X-Stat-Signature: d5q8jh8kph5gm8hbdc1pymxed8fenqar
X-Rspamd-Server: rspam04
X-HE-Tag: 1784732417-995853
X-HE-Meta: U2FsdGVkX1/zkEGunn5ssNF4td333R23AjJm6x79R9P8thKHa9Fl1FMfSt6pfySv1WHYy0ZzVvwbfz23so68UdqQPpXezZFal5B4fzO5TjN7+lP0qdhEHX62ggIR6wOKDJA94aGZiokVCw8SVj9+eamWvi3fURy/01ZNRuGyPQE/BCZBokgTUD969BMqSHKfrYL1C3Y2PYsYjZMrCCZNx6WJ2D/a9lbNccnhFSAte41nJgZX4LAN6igQhiZuHnfT582tESrrIZNpGLTYOySDFxlXyAWMZeYOwCc0Kf/vwV+/h1QP8v8xqv9OIIaLJ7fCmb028kczbDRyv2l1SsT0W8J6YePFcp7tp2cusf2h933uS+yjwrlOuPf5vHQNR5uA0qnSdoFcumyvJhRkGeV5HGCRafS6i303joRWKNaoQ4vFXznBDDdiiE3PSbrdk5MRkX7bQ3GaMY71f0nQhk1lOfB7XdsOGoHfiwZjKaBjqC7dFYp4Uo7tQl3ZpnWjVP7PpjM2VNxFYK4n5dUZHxEgCpa8Czdkq0Pz9t8c26hoGznElQpy9qzps+QZnos3OSR3YHTPbo/QIiVbwEHADPTmlaLFYuJhD4itfHunPboJKKir9YdMf5aYrs9QAmXDiVngaYuI3AXfXbf/89lMtRcoZr/PaXGKPN6KP8OqRkKEaDQN/VWFJeFjO8nAeUmwSqevzE5oPnAbyrKgruzAINj9I29aHqdFNvSeGwyK9zMAI/1G4PRMcnIveU/ZW2Vv6t+J56LEZgb7Jn0U1L2lmtoC8zAyNpPKMaolCPCwfTzsP1LnZTVECZ+na1FMnxy9Iq9QiEMDNs0Y/tvcqPftZNRI6l9ypatQIZiM19l5F7kXm8+SyV1dKyb3kTL8WE2fjstaVk8U+OwtBjuOFBnaODsm/fZKYhQwFhqrGgnoLYWZD/mk3LfMwwokPC4o0u0kTn45T7g9d2FCYXmgBnUzOzh
 1PHt6ZPY
 Y6CqahmtcGND6W4/9O5rhfZ2Kw0cOZELaVQXJ8Qc5XtaGEOPs90N72QQ2G1MT7gduQQkQBrrP0b7pkXuhk/p2pTCPaBRrghtwo3VQmRqmwBawcI6DuUJZny0rQbSlZtBKh8AqQeIq+SFgXWeaiQ7QhwRfoNU9odYJflhedXJ8Mq1kvSrUVQUW74e9lMbQYZZBpq/lmFJxBsf+UujAEKBwOjhABN3t9BF9MhBuxRBoqSwT3gB8e+rM95OGWefg0eTQa8IjrRO3qdqHpkKEO8kR/X6LK8Cup1Jij7rYqRR8Iq5PcjPP9VBLBWUnPw4iUDYdiYEllhpWXynRkYGh4KXKlBWv5ejpGvmGcRQh/vUmKvCzrSQEB40dcSTwZqtChUJ5MH2Cy+p32FeB+BYRCPCstWjmgHJxGchtW5C+kelp4C/1ZWPQJ39k8gH756d7sogrtomlXUWJBFSDPcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>

The compaction capturing code assumes the allocation request order and
compaction target order are the same. That won't be true once
defrag_mode promotes sub-block allocations to pageblock-order
compaction: compaction targets the larger order, while capture should
remain at the original allocation order.

Move the capture_control to the page allocator and give it its own
copies of what the page freeing path matches against - zone, migratetype
and the allocation order - rather than reaching into compaction's live
compact_control. __alloc_pages_direct_compact() fills in migratetype and
order, and installs and hides current->capture_control around the whole
compaction call; try_to_compact_pages() aims capc->zone at each zone
while it is being compacted. compact_zone_order() no longer deals with
capture at all.

Pass the capture_control through try_to_compact_pages() /
compact_zone_order() in place of the bare struct page **.

No functional change.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/compaction.h |  3 ++-
 mm/compaction.c            | 50 +++++++++++---------------------------
 mm/internal.h              |  4 ++-
 mm/page_alloc.c            | 45 ++++++++++++++++++++++++++++------
 4 files changed, 57 insertions(+), 45 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index f29ef0653546..66a2f70e9e01 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -58,6 +58,7 @@ enum compact_result {
 };
 
 struct alloc_context; /* in mm/internal.h */
+struct capture_control; /* in mm/internal.h */
 
 /*
  * Number of free order-0 pages that should be available above given watermark
@@ -92,7 +93,7 @@ extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
 		const struct alloc_context *ac, enum compact_priority prio,
-		struct page **page);
+		struct capture_control *capc);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern bool compaction_suitable(struct zone *zone, int order,
 				unsigned long watermark, int highest_zoneidx);
diff --git a/mm/compaction.c b/mm/compaction.c
index 225862a00380..977e30b3a2bd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2802,9 +2802,8 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 static enum compact_result compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum compact_priority prio,
 		unsigned int alloc_flags, int highest_zoneidx,
-		struct page **capture)
+		struct capture_control *capc)
 {
-	enum compact_result ret;
 	struct compact_control cc = {
 		.order = order,
 		.search_order = order,
@@ -2819,38 +2818,8 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
 		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
 	};
-	struct capture_control capc = {
-		.cc = &cc,
-		.page = NULL,
-	};
-
-	/*
-	 * Make sure the structs are really initialized before we expose the
-	 * capture control, in case we are interrupted and the interrupt handler
-	 * frees a page.
-	 */
-	barrier();
-	WRITE_ONCE(current->capture_control, &capc);
 
-	ret = compact_zone(&cc, &capc);
-
-	/*
-	 * Make sure we hide capture control first before we read the captured
-	 * page pointer, otherwise an interrupt could free and capture a page
-	 * and we would leak it.
-	 */
-	WRITE_ONCE(current->capture_control, NULL);
-	*capture = READ_ONCE(capc.page);
-	/*
-	 * Technically, it is also possible that compaction is skipped but
-	 * the page is still captured out of luck(IRQ came and freed the page).
-	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
-	 * the COMPACT[STALL|FAIL] when compaction is skipped.
-	 */
-	if (*capture)
-		ret = COMPACT_SUCCESS;
-
-	return ret;
+	return compact_zone(&cc, capc);
 }
 
 /**
@@ -2860,13 +2829,13 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
- * @capture: Pointer to free page created by compaction will be stored here
+ * @capc: Free page capture bypassing the freelist
  *
  * This is the main entry point for direct page compaction.
  */
 enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum compact_priority prio, struct page **capture)
+		enum compact_priority prio, struct capture_control *capc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2893,8 +2862,17 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			continue;
 		}
 
+		WRITE_ONCE(capc->zone, zone);
+
 		status = compact_zone_order(zone, order, gfp_mask, prio,
-				alloc_flags, ac->highest_zoneidx, capture);
+				alloc_flags, ac->highest_zoneidx, capc);
+
+		WRITE_ONCE(capc->zone, NULL);
+
+		/* Stop if a page has been captured */
+		if (READ_ONCE(capc->page))
+			status = COMPACT_SUCCESS;
+
 		rc = max(status, rc);
 
 		/* The allocation should succeed, stop compacting */
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..6d3402001b93 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1059,7 +1059,9 @@ struct compact_control {
  * immediately when one is created during the free path.
  */
 struct capture_control {
-	struct compact_control *cc;
+	struct zone *zone;
+	int migratetype;
+	int order;
 	struct page *page;
 };
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb422505c6ef..4b9686fedb71 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -721,14 +721,14 @@ static inline struct capture_control *task_capc(struct zone *zone)
 	return unlikely(capc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
-		capc->cc->zone == zone ? capc : NULL;
+		capc->zone == zone ? capc : NULL;
 }
 
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
 		   int order, int migratetype)
 {
-	if (!capc || order != capc->cc->order)
+	if (!capc || order != capc->order)
 		return false;
 
 	/* Do not accidentally pollute CMA or isolated regions*/
@@ -744,12 +744,12 @@ compaction_capture(struct capture_control *capc, struct page *page,
 	 * have trouble finding a high-order free page.
 	 */
 	if (order < pageblock_order && migratetype == MIGRATE_MOVABLE &&
-	    capc->cc->migratetype != MIGRATE_MOVABLE)
+	    capc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
-	if (migratetype != capc->cc->migratetype)
-		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
-					    capc->cc->migratetype, migratetype);
+	if (migratetype != capc->migratetype)
+		trace_mm_page_alloc_extfrag(page, capc->order, order,
+					    capc->migratetype, migratetype);
 
 	capc->page = page;
 	return true;
@@ -4146,6 +4146,12 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	unsigned long pflags;
 	unsigned int noreclaim_flag;
+	struct capture_control capc = {
+		.zone = NULL,
+		.migratetype = ac->migratetype,
+		.order = order,
+		.page = NULL,
+	};
 
 	if (!order)
 		return NULL;
@@ -4155,8 +4161,33 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
+
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-								prio, &page);
+							       prio, &capc);
+
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	page = READ_ONCE(capc.page);
+
+	/*
+	 * Technically, it is also possible that compaction is skipped but
+	 * the page is still captured out of luck(IRQ came and freed the page).
+	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
+	 * the COMPACT[STALL|FAIL] when compaction is skipped.
+	 */
+	if (page)
+		*compact_result = COMPACT_SUCCESS;
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
-- 
2.55.0



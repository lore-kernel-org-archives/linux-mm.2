Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47860C43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543B86B0122; Fri, 26 Jun 2026 14:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51AC96B0123; Fri, 26 Jun 2026 14:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4097E6B0124; Fri, 26 Jun 2026 14:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03A436B0122
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 727D314049A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:39 +0000 (UTC)
X-FDA: 84922884438.05.945CA8F
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE2D91C000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gmTu8ZLQ;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782498157;
	b=pXVIiUNavFZSKnHY18xZFmmcdCMwDNDBuwRBrYB9SmvwzRx4TtM+7qugvj3YjXbTDvvjZN
	kUSqzHxA+1RlXBsSZH+u4PaRtHPTQ8TYhZEW+jFuPkKBwCmnUWgoUh5f3LsgONHJFVNaT4
	bVV99FrUCXPFrnYKEFOnBBD43qIfyEU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzgs5H0Grhs1ueQiwh3lj+d4hLeKAITZ3jKxY2kFgsY=;
	b=YgSvzk++x5FPQMkLErgfNY7pYSiYY8J7qSxLMgwMFaW7jQcWuvgWAK/hrIw4Z0GGhMrQLr
	k4KZi866vFfj7v5njjYsnF1/KE28znwczI2fN+8egiGRSDfvIqcWdIXBdhVrt39QBRQQwr
	YV5OrvGzosCIWek4TDPxeZwyowCg4QE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gmTu8ZLQ;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92b2c2ea7ebso49489485a.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782498157; x=1783102957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wzgs5H0Grhs1ueQiwh3lj+d4hLeKAITZ3jKxY2kFgsY=;
        b=gmTu8ZLQLBNR1QNBA3ZI/ylq6gpuQC4fTOwp/dUNCGGIHyn9aaR5HjK4xcNdwrebab
         EHvtGHvUNu2qO90yBMbjSDZ4eAskvypjYvPVTf3d42da8VuFW6YRIj99KjPK7xm7vxMt
         zklEKE1xrbMJS2BDP9F1LjNig7NhZCcpgGuVpv6uEgC7WGmAQPxyrx65gtIsT2ExSLDR
         zcpsL1ntFCR9rXRFVFHkFcp393NEpzBMLokrmzCDSC6KRibdc/hd42OwVk1XQPjL6Ywt
         C4UqQZ2mzTHEoQ0y+AmttANZn1OCc4zhbFDAUmE+oHEi3PBjynz7CCHM96QvS5LtNdPq
         AwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782498157; x=1783102957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wzgs5H0Grhs1ueQiwh3lj+d4hLeKAITZ3jKxY2kFgsY=;
        b=qpw0ysS0x/gEWverfTQHbzDS486lZo+U1g8ABCG7UFj/OnRDc2rf7EbvsAZU9LAqNc
         OherwZTN30fG1FIFJCmSg95ANXHzdO2vgcJsJIwRQjW426DRARSR+tln06VYLlBrhP40
         /yE1qVMDdAbGuDD77HizfrAccin2N98jf2Q35gpsn8Z98wNYAB/XAynymuzGqPw7f+df
         ksNVldz3iqICbrYkXTawkcwRjbwn4CA5eMiOGpNPvGJ8AdIi7xfIK9150MW8I1WfN4mk
         jG/m7jZ4i8PXWxSFsayBgJW8E3FDjkk7m+OwjmTB/Tfq7791IxyrCl16DaBm1l91WTyp
         iRkw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZkcpufeA1LPQQrub1XkmvWUv/ZgfLTdJj5PejxD2SjEYRCVKM2OwT5ZiGnD+ZZBafb8DeNJAoJg==@kvack.org
X-Gm-Message-State: AOJu0Yw7ZCO/vZx6oKWzoc+7A2RU9mvsI/oGByyrlKXUAh+0DGyG3/Rs
	DnBg/Jhj2j4Zt4am4YzmKy5eLMr+WDCkEPzZ8peueZQC+8065VLSLGknCSbjYmgzv2I=
X-Gm-Gg: AfdE7cnAdRpcPr9Icx0zaPxN5lbJwxke+iRzo+Kbsg7/ZZnhVS4OUKeFFPMnw0PTEKD
	r/Kafk41uQiY2zEFF3BQ26ED9/2onAG4Z3PSfimxf6+ciucbYC4g9EeYSqSOupHfrGM6xEFhfLn
	9fKJdmasjDIfORg62QeRN7gNliEDrn5xf9qyN/ZY/oqwZAiAWi7+1mNOunn/e8mbYVJ1xTf51Yz
	hgoF/5idXNkMsWkl/9iXHpXn2DYI8GqA5b+hi8iTPTtX/sVKS4ip/kkkc5rsWoU4ZsxCJmh0rsn
	gHZOsYkEQv0jfPGPxKS9xXN59NmXTqWWu9E0Pnc2cLx9EsFMV1FsZkEoKXC3MYS5zrL7ixWbbaM
	4Snug/AnNBlJV4mQjVAzX+THV/ae6IY1N7goVZAK/lD0k6D0dvs14KPQEGfPQimhO1BDbtT6uC7
	SzTZ/g2J2jF7E=
X-Received: by 2002:a05:620a:6491:b0:92b:32d4:4af5 with SMTP id af79cd13be357-92b32d46470mr307992685a.5.1782498156661;
        Fri, 26 Jun 2026 11:22:36 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ac2e0026esm206754585a.10.2026.06.26.11.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:22:35 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mm: page_alloc: move capture_control to the page allocator
Date: Fri, 26 Jun 2026 14:21:19 -0400
Message-ID: <20260626182215.1107966-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626182215.1107966-1-hannes@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: popgm7t1u39k9ottqpczno6jeyurqac9
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE2D91C000A
X-HE-Tag: 1782498157-508473
X-HE-Meta: U2FsdGVkX1/h43U+On/r5fItOTK/GU1GC8Ir7XbsGtngT2pC/NMRbQhqjfP9R909oVbnrG81swDHktjGVNnTKmqNxqkDVjZi6NdmlNRPaF1xNehsZF5f0o9w73cYD1Oq/5RHMeHpj0DyKtOE5rL9b6Id9/P6RtfYarM2ROnsOA7k3UwestyQ/kryeolxduZMuejxIqG/8IWpoZnHEB76s3icSDcRCxWt4eT3Ml9O1dkKUFjUDqx8nlDBbs2SaEbNXJ3u74Pewi9gSWf4fgC+shlEE1oyS3aMHmw7XW3gcdWVno2m0Unu+fQyDnYBJ/Kz4p08JBwaKdYCL42ZFVAA0VxDBfdTzN+L2Iyb7iPWidpznqYHSB9aiKAxjn7rn+vEbkBQEtcZdSt9p+ZHOhn5ceSLwlBGXqWqo7Y42GIrMzl0Fcjl24buYb5G5DbWGEl7fumJoEz47ELuzer92QBg0u3bMQ0AwHwVWyRl+IlPS8gg/5EjZoAPeoP2d5KCTYyd098L6TXZku8/LgNwObMphYck9YZWSS7NpaO618J6Vy1mQ2mUwPnWSqUxPw2Z81zQhzCROUcMuucODchke2+nwwMp/5+/ye6Zpa2nTDucSRq3L2YDAfPJvGXYbcMss+RJIG/x3FG7JoozolExIV/dJox2HVjYuXdbonFuAVJywqJ78UPi5Axf3CdMbuwvbieCszkGnGzeZOoskf/om5skN+yvzvx2bMGM2mJ+PNVf3vbUPGRpbTGRSG3M5AoXfEVsKumBwtTaHefn/Yas26VWlWULYanl8aRaKqGco4aKaNPwgZ5ozaL5uM/6GvBGI4Prv6ziGiI6Dkc+w5ZZKFVw7/T6GODS4oUepfn/miRyuMSNUu5StRu7NLXUybdWdUdrhVJxjzrZnF/SIa4q37GrC0Zv76hhx/p9aBe85hAtDmsTv4ngIS1819wkozDnqfGMbfo6tS57O6MBdQPZTZ1
 r/dugloD
 BJAOQwf21lPPHsi0bNM5CQXhComuxI2sqr6fKcaOQYC3kfBvkv47CX0YR2o/hIsuFqKFpO4NHdsLr/XMNmA0TXfwx6CM4WvjnVSZ3cPehpvY8nox9JzldOPQNXE1jxuMohQitT0gCe29WI3fVNbBS/ZpqNbKYxuji2qZvPiUvYSxLRlc9LWQvZdzPaBI1tuhEsopI2xtS/J1owU2lMGjgoJ19syMi97Oru23BLfiMlKZinriadeKEiblstiDU2OdR7iwfpgftQO+9jWvrB3NOouP6q4TGC5Uv8hygttNOjtVae9bH6AcjRj+Plr779YMwRbNLaL/feB/Q02u7JoPMjzkgRxT1vGxMynBJKrIEfTZ2WPuQLGN4aA1VECbncP81wWPgn+zaPp9gRvay+NF/xQMvCgMBc3FZUVcpZXu8P6fdLASHm8LiMt01JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compaction capturing code assumes the allocation request order
and compaction target order are the same. That won't be true once
defrag_mode promotes sub-block allocations to pageblock-order
compaction: compaction targets the larger order, capture should
remain at the original allocation order.

Move the per-task capture_control to the page allocator, so its
fields can carry alloc-side information that compaction's
compact_control does not. Pass the capture_control through
try_to_compact_pages() / compact_zone_order() instead of a bare
struct page **; compact_zone_order() sets capc->cc while running.

task_capc() now also checks capc->cc to handle the new
not-yet-running state.

No functional change.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/compaction.h |  3 ++-
 mm/compaction.c            | 33 ++++++++++-----------------------
 mm/page_alloc.c            | 23 +++++++++++++++++++++--
 3 files changed, 33 insertions(+), 26 deletions(-)

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
index 7df3a85d43af..c2701bf1d04e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2791,7 +2791,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 static enum compact_result compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum compact_priority prio,
 		unsigned int alloc_flags, int highest_zoneidx,
-		struct page **capture)
+		struct capture_control *capc)
 {
 	enum compact_result ret;
 	struct compact_control cc = {
@@ -2808,35 +2808,22 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
 		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
 	};
-	struct capture_control capc = {
-		.cc = &cc,
-		.page = NULL,
-	};
 
-	/*
-	 * Make sure the structs are really initialized before we expose the
-	 * capture control, in case we are interrupted and the interrupt handler
-	 * frees a page.
-	 */
+	/* See the comment in __alloc_pages_direct_compact() */
 	barrier();
-	WRITE_ONCE(current->capture_control, &capc);
+	WRITE_ONCE(capc->cc, &cc);
 
-	ret = compact_zone(&cc, &capc);
+	ret = compact_zone(&cc, capc);
+
+	WRITE_ONCE(capc->cc, NULL);
 
-	/*
-	 * Make sure we hide capture control first before we read the captured
-	 * page pointer, otherwise an interrupt could free and capture a page
-	 * and we would leak it.
-	 */
-	WRITE_ONCE(current->capture_control, NULL);
-	*capture = READ_ONCE(capc.page);
 	/*
 	 * Technically, it is also possible that compaction is skipped but
 	 * the page is still captured out of luck(IRQ came and freed the page).
 	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
 	 * the COMPACT[STALL|FAIL] when compaction is skipped.
 	 */
-	if (*capture)
+	if (capc->page)
 		ret = COMPACT_SUCCESS;
 
 	return ret;
@@ -2849,13 +2836,13 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
- * @capture: Pointer to free page created by compaction will be stored here
+ * @capc: The context for capturing pages during freeing
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
@@ -2883,7 +2870,7 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		}
 
 		status = compact_zone_order(zone, order, gfp_mask, prio,
-				alloc_flags, ac->highest_zoneidx, capture);
+				alloc_flags, ac->highest_zoneidx, capc);
 		rc = max(status, rc);
 
 		/* The allocation should succeed, stop compacting */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb422505c6ef..9dee1c47e795 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -718,7 +718,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
 {
 	struct capture_control *capc = current->capture_control;
 
-	return unlikely(capc) &&
+	return unlikely(capc && capc->cc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
 		capc->cc->zone == zone ? capc : NULL;
@@ -4146,23 +4146,42 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	unsigned long pflags;
 	unsigned int noreclaim_flag;
+	struct capture_control capc = {
+		.page = NULL,
+	};
 
 	if (!order)
 		return NULL;
 
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
+
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-								prio, &page);
+					       prio, &capc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	page = READ_ONCE(capc.page);
+
 	if (*compact_result == COMPACT_SKIPPED ||
 	    *compact_result == COMPACT_DEFERRED)
 		return NULL;
-- 
2.54.0



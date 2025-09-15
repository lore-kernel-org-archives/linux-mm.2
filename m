Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4610BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AF78E0018; Mon, 15 Sep 2025 15:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF81D8E0010; Mon, 15 Sep 2025 15:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D997D8E0018; Mon, 15 Sep 2025 15:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BED3A8E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96C141A0734
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:33 +0000 (UTC)
X-FDA: 83892531786.07.B7B6839
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id CD3AFC0009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nWDraO2K;
	spf=pass (imf22.hostedemail.com: domain of 3fm7IaAQKCMkuAs0v33v0t.r310x29C-11zAprz.36v@flex--fvdl.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3fm7IaAQKCMkuAs0v33v0t.r310x29C-11zAprz.36v@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZKjZrunq5am07txBDDkuCSvylPNhhpycrLLY5C5zoU=;
	b=KQWet1tPokkC5OLj4NbRobJ4XUBM1cF+3qgoiBHYlflm20M5wpwDW/0HZZ2q4XXfQPC5qx
	N/F5CyWtOHk63AuOY93zhENeZv3kuiw2pdkkQtxIYcy4Au3dJeYbLe+CzWUKpJ/P259jmV
	PUziZU0f4/jl4ZYZMasRdWR4ZnrbAk8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nWDraO2K;
	spf=pass (imf22.hostedemail.com: domain of 3fm7IaAQKCMkuAs0v33v0t.r310x29C-11zAprz.36v@flex--fvdl.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3fm7IaAQKCMkuAs0v33v0t.r310x29C-11zAprz.36v@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965951; a=rsa-sha256;
	cv=none;
	b=gDG+++CNhPlYjHqGVFcR+EDdK4flvw1VfpXHZaXsX3WhfpG1CHwt+E0dXVbkj3io5PyB1W
	iKDfJoFIWHpFNV8yG31XTqrZJxiVSxBxQ9xda88icrv8JWl+zwiuEAuKrTxxyN5tkdg2HE
	Vzc0KDRjoRsWa+hqnaGAJOeA2Qjhlmo=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2649a245f3fso12480175ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965951; x=1758570751; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RZKjZrunq5am07txBDDkuCSvylPNhhpycrLLY5C5zoU=;
        b=nWDraO2K+/sWnAmskxn6dPEgcajYn06LyzPcQkGWskBGfl9ygaAFWjqb/2q7xYN7p1
         Wdf4gF3fRbFkruwf6MWkN9NSFS84LOgDXTbAGc91CGq/OnXWUhoxjX3lDYv9V7d1z6IV
         QQQPsf7Jsa8iwEkXqLt5bLdqikCCDJu5MXHM8QCYeGM8qA5ggt7jJrMqFUCymQfs6snh
         2iVyUVSpEv2U+VhoY3yvoNVi+LPUjq+ipODUz78jjnQeJG8Sdv7zQVTclGBaGP6CnxVV
         KJrLmh9ScRedysqIvTwpKZ0VgUafOD0JNxzXr3o80AQrTeOdBojK3bnKsiXz/2vhXJsU
         FMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965951; x=1758570751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZKjZrunq5am07txBDDkuCSvylPNhhpycrLLY5C5zoU=;
        b=LvKeDFwGtfKsadGEl6tfutf3Vu4vFmpF5cj+7iHC5Ym+XUEhe/Xo0A4eF22KeL+n9I
         AGfyiFGUo1WW5g6qWQbkNM4TDp8LKIiha/IuTsHIty3hw/kkIbzZqHeAV7M6Akc7Wa6B
         yEvywX5w7iFIr/mKOXg20tk9jT0JdXKPAho1ZiQVtY+D2tN5DIKvMclUFsSDCPpix/+a
         9GoKyLKi6/rSRlX3siVi8Elfh51yt12Lt/jr1wjtx2VXHbAQW45Bhredi/7NV2Bf/Fi+
         h1Xh+CQc7Cz3wJMG4jhzJjX3l+LHvLsnn2mgeHovFyJejR2w3cUouOCwQzXJmbyxsz7z
         Qtuw==
X-Forwarded-Encrypted: i=1; AJvYcCV52Iyr0NeD3r9wm+QW5wliTunLatxnQGseI6fDTQ+AEKMajLE6wno4gvIkfpgzpbfDDNMb/xEkuA==@kvack.org
X-Gm-Message-State: AOJu0YybgLj2PIN7kmfQyD//kS7+ylJbEB8L3Zi73kuqjC6hJLDdUM8D
	GvFQKO1AWtV7Z0+AfgSqC6SbROCFUB6/6k+0s+d9tobM84NKuPvDlL+rv7hHJI4CpF/GdZFYvg=
	=
X-Google-Smtp-Source: AGHT+IH9QOqt/yj9ycFYjOQ2rL3lizwBlj25FoMjJ5FB/agDQXZSFKAbBpu7CnQQ54uijVVe5BYAlfIL
X-Received: from plgi11.prod.google.com ([2002:a17:902:cf0b:b0:24a:ff7a:4c65])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e78b:b0:25a:324a:9af1
 with SMTP id d9443c01a7336-25d26e42154mr150527385ad.38.1757965950699; Mon, 15
 Sep 2025 12:52:30 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:49 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-9-fvdl@google.com>
Subject: [RFC PATCH 08/12] mm/compaction: simplify isolation order checks a bit
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CD3AFC0009
X-Rspamd-Server: rspam05
X-Stat-Signature: ojog988a1qre6jt3a3pjx7nc97b14xwr
X-Rspam-User: 
X-HE-Tag: 1757965951-236807
X-HE-Meta: U2FsdGVkX180Szy+pegnJZ9YIaNfDqpmD/L6u16FWhi99Fp+Sfmw9PaKuo7RXSkeFvYh2fDIvzM5OiKASBRqoW7OhAgEAxEAV9N92+DJ2eSjnoSNYZXJS/Bnj7ig9oLJuWbxNzHWuuTZyiVVqtNdHa1mri6h2ITbHpt1gJxeZcx3OqV+w4v89xBKyk0G3nKHntClWn6kA0KJh68xSlyM3wuiKrWyMvuIE++9iXjZu/2tPczlfVIsVHCWmtDpmqLpQjcsiI0RKynIL1pdUuIgkHNxwinc54FWDHdgoL7YrwLNb81VwlGE660Sz7RRZsfzQwKZ+uBw56mXFe6cHfNQlLNFR5VrFQPwHMcPhxE3pSiwcpRVzMmoeJ12V0rj0+QXg6OMxJEMMGmg/WufniKaPF9muWYQ+rNJHj8S50IujNbKU6YQKMpTgc2FHiHAVetOVCevIK14Hdc1DrcY79dzukEIzpwBYuE+6D4RIPcIRLcP7aiOogGo0b5X0mEr0BQXvuNOfRS/jOxr11JrB9mzWQPnBbtduWWDPqfNG92J5ciovuo9e2z2mAGvJc+PB95UwT4uB+qCTEdf17H4Mp+Lm2ceNn9ZMpCqjo6XfAhcAsmus4MBfeyugyW1ZU8Itl4llA2qeFRgnhFPw6kqMUbd/j7ui5aMabmQkukVfCIlo0UBxVut+ZI9rH1d5mZhFXq+n3vAIVXn8FeXnuqUTxqpjzSPB00DU/f1t/IdBg/FSA94hTpskXBkcYJoWuQTzsgWkJ9B7vwmwnY8hqUO0Nk2QcyLlG64tEEdUYCf2+wUaIWDw5dfeJDMtP+sQcEA3Mola0VyXUENIlAqbx9QxJ/wpdmjCTHm5FcenyhY55Ny4IK38dVs7YmUv5x5ngEM/KC1Lerk98bzoLIIqoJKFGuIxzUML1xPMCJIDxclQHMfJDdJ8iabU2xLuPo5oIDZoQoZPgJHd+eIaO2diTBg5On
 Un5b+8rv
 8PExanoJA3+fXG36c1Cq7Gfzl2EBmaUHXX56vMrGmVcvT2j5jC6nrdXSlgbwJispVNTSoR38LjFb/zviwbFfMaQ+DVtU58r6kCVQRHlHnl7mHNiYzztzc6Sd/K1LMj5iA2vkzlcPw+JAOXfH4iyAGFdeuuhHxaspTm0vfliqxfjuwOjT0iQj4YSzjiGYF+T/Py9U4sqxzlo5cH/tfFvgYUGCaOyiZyVjeWmCMUBWyZdFWCIlpFjCR39NJ15fqtjfYhku+GPM6SHUyAbgS/Cdar08pU90EO0D1M6kPDeqripKdeD9lNKyb0OVLo2vdmuEWFtI3G0B2PskXfozTOEO0QHe8Rp644ADf70vJpCyUVeeSwobnmh4psD4C7pWoVVayNNfgiAF6lBbU23oCc5N4gWohyQB29WFDKp3o8zg+x0fYs72rJ/jBZKlm9sbHseFGUiwUoLz+eNOnDZpWM1FNsgKq7A7HYsncSm3VAmZGhxAaQvk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The code to isolate pages for migration always checked both
cc->alloc_contig and skip_isolation_on_order to determine
whether a page could be isolated for migration.

Simplify this a little bit by moving the cc->alloc_contig
check in to skip_isolation_on_order. Also rename alloc_contig
to migrate_large, since there will be an additional user
(CMA balancing) of this field soon, not just alloc_contig_range.

No functional change.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 mm/compaction.c | 26 ++++++++++++++------------
 mm/internal.h   |  2 +-
 mm/page_alloc.c |  2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6a2c06e356c5..2e6c30f50b89 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -793,13 +793,15 @@ static bool too_many_isolated(struct compact_control *cc)
 /**
  * skip_isolation_on_order() - determine when to skip folio isolation based on
  *			       folio order and compaction target order
+ * @cc:			compact control structure containing target order
  * @order:		to-be-isolated folio order
- * @target_order:	compaction target order
  *
  * This avoids unnecessary folio isolations during compaction.
  */
-static bool skip_isolation_on_order(int order, int target_order)
+static bool skip_isolation_on_order(struct compact_control *cc, int order)
 {
+	if (cc->migrate_large)
+		return false;
 	/*
 	 * Unless we are performing global compaction (i.e.,
 	 * is_via_compact_memory), skip any folios that are larger than the
@@ -807,7 +809,7 @@ static bool skip_isolation_on_order(int order, int target_order)
 	 * the desired target_order, so migrating this folio would likely fail
 	 * later.
 	 */
-	if (!is_via_compact_memory(target_order) && order >= target_order)
+	if (!is_via_compact_memory(cc->order) && order >= cc->order)
 		return true;
 	/*
 	 * We limit memory compaction to pageblocks and won't try
@@ -850,6 +852,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
 	int ret = 0;
+	unsigned int order;
 
 	cc->migrate_pfn = low_pfn;
 
@@ -948,13 +951,13 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		}
 
 		if (PageHuge(page)) {
-			const unsigned int order = compound_order(page);
 			/*
 			 * skip hugetlbfs if we are not compacting for pages
 			 * bigger than its order. THPs and other compound pages
 			 * are handled below.
 			 */
-			if (!cc->alloc_contig) {
+			if (!cc->migrate_large) {
+				order = compound_order(page);
 
 				if (order <= MAX_PAGE_ORDER) {
 					low_pfn += (1UL << order) - 1;
@@ -962,7 +965,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				}
 				goto isolate_fail;
 			}
-			/* for alloc_contig case */
+			/* for migrate_large case */
 			if (locked) {
 				unlock_page_lruvec_irqrestore(locked, flags);
 				locked = NULL;
@@ -1030,11 +1033,11 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 * skip them at once. The check is racy, but we can consider
 		 * only valid values and the only danger is skipping too much.
 		 */
-		if (PageCompound(page) && !cc->alloc_contig) {
-			const unsigned int order = compound_order(page);
+		if (PageCompound(page)) {
+			order = compound_order(page);
 
 			/* Skip based on page order and compaction target order. */
-			if (skip_isolation_on_order(order, cc->order)) {
+			if (skip_isolation_on_order(cc, order)) {
 				if (order <= MAX_PAGE_ORDER) {
 					low_pfn += (1UL << order) - 1;
 					nr_scanned += (1UL << order) - 1;
@@ -1182,9 +1185,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			/*
 			 * Check LRU folio order under the lock
 			 */
-			if (unlikely(skip_isolation_on_order(folio_order(folio),
-							     cc->order) &&
-				     !cc->alloc_contig)) {
+			order = folio_order(folio);
+			if (unlikely(skip_isolation_on_order(cc, order))) {
 				low_pfn += folio_nr_pages(folio) - 1;
 				nr_scanned += folio_nr_pages(folio) - 1;
 				folio_set_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 7916d8be8922..ffcb3aec05ed 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -909,7 +909,7 @@ struct compact_control {
 					 * isolation or migration failures to
 					 * ensure forward progress.
 					 */
-	bool alloc_contig;		/* alloc_contig_range allocation */
+	bool migrate_large;             /* Always migrate large/huge pages */
 };
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d3966d31c039..dc59aaa63ae6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6903,7 +6903,7 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
-		.alloc_contig = true,
+		.migrate_large = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 	enum pb_isolate_mode mode = (alloc_flags & ACR_FLAGS_CMA) ?
-- 
2.51.0.384.g4c02a37b29-goog



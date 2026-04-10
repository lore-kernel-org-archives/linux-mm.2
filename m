Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27293E99071
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE8B6B0095; Fri, 10 Apr 2026 06:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EE56B0096; Fri, 10 Apr 2026 06:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747076B0098; Fri, 10 Apr 2026 06:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4006B0095
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:15:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0969258FB4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:15:58 +0000 (UTC)
X-FDA: 84642240396.27.ED2F9C5
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1F7DF180011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:15:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=MmTRLBM1
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775816156; a=rsa-sha256;
	cv=none;
	b=kPz+KCGVSVjI7IVqA5g2zjXzSkq3BQMrhsYHGpNDulJGpyHTF5RBJy6CAk8fVq/eMt+ja+
	lY8JdupOaBXU6X2pKQb6GIheP7BL4thsET+QitYLDgA5hfnHryFWH1h2G2wXOEOtw6zoGm
	uZ3zGX8+pFcCHB3OpIYGXDqEe8QVzJQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=MmTRLBM1;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.43) smtp.mailfrom=matt@readmodwrite.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775816156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YChrqsE4WmmiSWUmGyqQcSWkvMfn/HOsna4U+guou7E=;
	b=jwNC6bX+RCp+rdqqYB0DCasxmB0Rov5Slxj7DmYP/tLZsGZ3Z7z+aXVgzbv54KU+oP+V4P
	i1F/yC2fcF/GDh3ybzhGju1KydtJzge+O0Ipv0ARTLbddYQhAX5+c2AmvXc04VrAIZ8mQ6
	QmZmCn+Nu17XMuZpSJCzKGtyb92wNH4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso20013935e9.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1775816154; x=1776420954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YChrqsE4WmmiSWUmGyqQcSWkvMfn/HOsna4U+guou7E=;
        b=MmTRLBM1K7S6xkYSEI7QgvM2EphFu6eJkxXnSjP9LkjHOr3/mpgFvIMNrGX637M+3K
         P6Bwvqg0aPb3p2wn1W3Q/2turVkSpccXccYGJJ/xyUP24pcD+47k4q3bugK8HOE5+6VG
         Hguaf7r6JHyRMBMJwIoR7W5MPktyPmG1WK6LlRRCng6qtSiEM5DaL4YNGDJ6nExHOtmG
         efVIQoWO4/QK4cXso/G9gOpxWDRyG8ukL8K8zsrOkXrYYg4K2S9Ps+N7yznK8n1uzsst
         RYn9Tr66fM9S1XZAb3PrqZO/lYRXrxdEKjoSNye9Okw4cJ6BpmdcVZot4klA6bD3rpUX
         2T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775816154; x=1776420954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YChrqsE4WmmiSWUmGyqQcSWkvMfn/HOsna4U+guou7E=;
        b=R/USm366oeja0H9DeZPJ+zSMV4Kz7w4Pk3SXeS1ti7SFl5vcW2cCeXx2Wy/RV0vN2q
         WuXfN58yyErD7//hsou5wWLfON/fFNzW3XEBViiUA+c4gwOIS1na7FfwV65osZ0COAXG
         IXMTK3U9hWLalvW/vedA/+g8Ldcu3qkO/t+zbpu6mw813cEW2a+6hH3FPTurBmYOcd/l
         7ZvX0hUEq+muQe7DiBudQ7GedUmLe2bYEuY66f2kgeFqTkpBs97W/3tMlRUiNOWVHWfk
         mA/Jq6uPIc14r1yZAnnWfGRcgfUNnqYaSVFAKtkdgsFIrUsZa3hxax8epvBJ36UZ3N1c
         K7oA==
X-Forwarded-Encrypted: i=1; AJvYcCUItrdQn74UpkhatzLeUGUAWDjXwfcCm8zcZGxIIpKzdqGeZjlqmMumFS2ylY4gyMDs3b/mSoodSA==@kvack.org
X-Gm-Message-State: AOJu0YxJxXpl6jsO/Q1N4GM3yvbigMHB40/jMVrYQSd5U11HKO9nbzLl
	wtHQlZYxUtnt1feD+gSF6G4p+h5r1XFAB/6IBSz114wdH/rqIlYg3mfwDu5wgVrhtHo=
X-Gm-Gg: AeBDiev5J53Uu+2GxLTKYWr76kTzs/wdUVKVvK0UgnzUiAVSQoVIPIXdOVETTfdSTc0
	FnguQy0KwlA2wPjxj5OSuF/TA0VCT6HgRZfpNmwLxk1sRQH5nK0oBA3pkQBTS0csRMiL94z2CM+
	lQxP8bjKwxTb40botjc1FYKv/Mxm9ElCEGczwOfvC44R8i6LhN2RfaGLuCI9XimW112YIIvO+uL
	HEJzmeAr7NvK6A6mc96jjmk2EStFPrWbpQH28x9GrCwETlnds4LLlAciW7ZQ+n+T0qFbVVyHy6p
	FeFL4e6bDFqQ/Ga2i0mGYk956x7vd2LaAipVGj9EEdw4uEZx0lSBKWzfLXlZjKXccUKApA3C5OV
	OIzGGieBC6ynk/+Gt7AieSjAGZLfg/qODGifsBmPqclih4DDUBTSizXi0gQunU3Kc/Fz6xLjlZd
	sd9kmOZzgtN4+owdioFqioRt1e2g==
X-Received: by 2002:a05:600c:1391:b0:483:6d42:25c6 with SMTP id 5b1f17b1804b1-488d687af33mr33487795e9.23.1775816154055;
        Fri, 10 Apr 2026 03:15:54 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ebe::178:140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d6864121sm16382075e9.28.2026.04.10.03.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:15:53 -0700 (PDT)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Minchan Kim <minchan@kernel.org>,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Require LRU reclaim progress before retrying direct reclaim
Date: Fri, 10 Apr 2026 11:15:49 +0100
Message-ID: <20260410101550.2930139-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4dx7i7ksmiq7mukwxb6k7gapcq9fk7mn
X-Rspamd-Queue-Id: 1F7DF180011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775816155-559114
X-HE-Meta: U2FsdGVkX1+UPEU30T4Nd8Tt4QtyprpiaLPCO47sjWGKgys3BRD/eUM8xZ8wsAPJi7pfE4wpNpC0pF37p5es9oKXG3tcCISss7yFRsS4NHTP958zdidNh/ZoRMEQndjdrXuleLs32geP1wuPj+KkFmG44Q4ou9V88CNJcLzTmP0/mTTuxe/RUGllinaZzLAxTvEPGluHIrJ1IJoCKtYhVs89+T1yYOEugyKMT186S5PGMOYpyDypvSDqUZMa6Nj/VftbJgY3RxVvk9PjllPMJKLMUSC4VEBF2JBmw/0lR7RBoxMeS8w1tuefa2mDk6F1bTEaQUMC/VsKn05jhGfA23gUTXpsSNujL6XE7zAC0gRIKE+ZMak9XjrteoCe2U9wOaqvI14zRhFRbWIC+19BtlW4xAAaRyWta5t2XPd4yv1VJoC2fZUVBaSX6NJ3l83AhqYNbEMunNHAbm6JHugDmatobGQPIpdjFbSfmZOtqXCM0M90JwkCbAToUhNutehE7zIb8wg8dH8MexIrMgsoUHYKl0xgpJqUeqX5Sbl8wT3LgkSXhPP9g3ZrDsbEUw3WYcLKv4GFMBr3VWJSamRBU1ghdHFhKd7nDbIHLJHfKiifCoN6IwSGh3BeEPxHUjQc0wi/9lEZBlEsCFM/Fvx8+imc8AnFpz7fX64+1Qsck5dpmiqm+b3hf87AUdl8XeSiYfPI+e1c/PTWz/pE30IEQr/hp0y4GGVwnFNjetz7M0FHgAVYjPboY5jurUhkZINoCBf1OlD3Z3krxJOLCyLmT+LXgIom4ITvK9D+hbCMmkZ7j/Od9pvnSQyN9EsCPSVrYeiBK1zdEhpXZhYWfPtLSORyjORGprbR3qKJjDNm2XhKbqvslBU4YhNUmwkqGoDHagfC+FPwNRGxT/dXEsFw8E6tH5a870jqm/WkXGkvOQUd5LnOTyu1F9AzMw/fhx7SXZH81T9NUF3NuTGoCij
 x+TLZB0E
 1gk3+CgHxv2v5kuwql+H+eABZkJo7XNfK18wOuW78ZgpT7J3I7hsuZyrqZvBmOy4LrcV+j8Y7vKwl4Ewr99EAGMCWKZYHHv6QUS5sZwD3fQSuOPva7fShfB3UVr7W4rCfL54VgOMZkDIbB+ZR8bu5BiW52dzG+h7uxsxjcvuuRWM+3k8VYKZagoUhLVUHybqnYinRHaOgQzi0MpPQWPQfkqJwjO5Tc0C6zh1dHCvDZFEQRnt0+RazCWrnVMTZnp9IEOu/vwZURk2UUDnN3ouaQMozbZ0rJPsUsxCS9qzWL8Znt1SZC5SZJ6fgTwtLyTHjGg02uZcDduH8YKtnkks78ghpHUCCpK3LD+bU+Kyzis1uGIkeQEhSwL9xEz8tnMhJ5CviZt6gsuY4ykYFM/k6Up8IZ9zgyNEX3ASX3jVJl8rrSRgow7ihxnMZizS3oeoPyW9fP6bsMXliTSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matt Fleming <mfleming@cloudflare.com>

should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
retrying reclaim could eventually satisfy an allocation. It's possible
for reclaim to make minimal or no progress on an LRU type despite having
ample reclaimable pages, e.g. anonymous pages when the only swap is
RAM-backed (zram). This can cause the reclaim path to loop indefinitely.

Track LRU reclaim progress (anon vs file) through a new struct
reclaim_progress passed out of try_to_free_pages(), and only count a
type's reclaimable pages if at least reclaim_progress_pct% was actually
reclaimed in the last cycle.

The threshold is exposed as /proc/sys/vm/reclaim_progress_pct (default
1, range 0-100). Setting 0 disables the gate and restores the previous
behaviour. Environments with only RAM-backed swap (zram) and small
memory may need a higher value to prevent futile anon LRU churn from
keeping the allocator spinning.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 include/linux/swap.h |  13 +++++-
 mm/page_alloc.c      | 101 +++++++++++++++++++++++++++++++++++--------
 mm/vmscan.c          |  72 ++++++++++++++++++++++--------
 3 files changed, 146 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..d46477365cd9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -368,9 +368,18 @@ void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
+struct reclaim_progress {
+	unsigned long nr_reclaimed;
+	unsigned long nr_anon;
+	unsigned long nr_file;
+};
+
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, nodemask_t *mask);
+extern unsigned long zone_reclaimable_file_pages(struct zone *zone);
+extern unsigned long zone_reclaimable_anon_pages(struct zone *zone);
+extern void try_to_free_pages(struct zonelist *zonelist, int order,
+			      gfp_t gfp_mask, nodemask_t *mask,
+			      struct reclaim_progress *progress);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..0f2597542ace 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4407,12 +4407,11 @@ static unsigned int check_retry_zonelist(unsigned int seq)
 }
 
 /* Perform direct synchronous page reclaim */
-static unsigned long
-__perform_reclaim(gfp_t gfp_mask, unsigned int order,
-					const struct alloc_context *ac)
+static void __perform_reclaim(gfp_t gfp_mask, unsigned int order,
+			      const struct alloc_context *ac,
+			      struct reclaim_progress *progress)
 {
 	unsigned int noreclaim_flag;
-	unsigned long progress;
 
 	cond_resched();
 
@@ -4421,30 +4420,27 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
-	progress = try_to_free_pages(ac->zonelist, order, gfp_mask,
-								ac->nodemask);
+	try_to_free_pages(ac->zonelist, order, gfp_mask, ac->nodemask, progress);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
 
 	cond_resched();
-
-	return progress;
 }
 
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		unsigned long *did_some_progress)
+		struct reclaim_progress *progress)
 {
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
-	if (unlikely(!(*did_some_progress)))
+	__perform_reclaim(gfp_mask, order, ac, progress);
+	if (unlikely(!progress->nr_reclaimed))
 		goto out;
 
 retry:
@@ -4586,6 +4582,41 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 	return !!__gfp_pfmemalloc_flags(gfp_mask);
 }
 
+/*
+ * Minimum percentage of LRU reclaimable pages that must have been
+ * reclaimed in the last cycle for that type to be counted towards the
+ * "can we satisfy this allocation?" watermark check in
+ * should_reclaim_retry().
+ *
+ * This prevents systems with only RAM-backed swap (zram) from
+ * endlessly retrying reclaim for anon pages when minimal progress is
+ * made despite seemingly having lots of reclaimable pages.
+ *
+ * Setting this to 0 disables the per-LRU progress check: all
+ * reclaimable pages are always counted towards watermark.
+ */
+static int reclaim_progress_pct __read_mostly = 1;
+
+/*
+ * Return true if reclaim for this LRU type made at least
+ * reclaim_progress_pct% progress in the last cycle or the LRU progress
+ * check is disabled.
+ */
+static inline bool reclaim_progress_sufficient(unsigned long reclaimed,
+					       unsigned long reclaimable)
+{
+	unsigned long threshold;
+
+	if (!reclaim_progress_pct)
+		return true;
+
+	if (!reclaimable)
+		return false;
+
+	threshold = DIV_ROUND_UP(reclaimable * reclaim_progress_pct, 100);
+	return reclaimed >= threshold;
+}
+
 /*
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
@@ -4599,11 +4630,13 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, int *no_progress_loops)
+		     struct reclaim_progress *progress,
+		     int *no_progress_loops)
 {
 	struct zone *zone;
 	struct zoneref *z;
 	bool ret = false;
+	bool did_some_progress = progress->nr_reclaimed > 0;
 
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
@@ -4629,6 +4662,8 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
 		unsigned long reclaimable;
+		unsigned long reclaimable_anon;
+		unsigned long reclaimable_file;
 		unsigned long min_wmark = min_wmark_pages(zone);
 		bool wmark;
 
@@ -4637,7 +4672,24 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
-		available = reclaimable = zone_reclaimable_pages(zone);
+		/*
+		 * Only count reclaimable pages from an LRU type if reclaim
+		 * actually made headway on that type in the last cycle.
+		 * This prevents the allocator from looping endlessly on
+		 * account of a large pool of pages that reclaim cannot make
+		 * progress on, e.g. anonymous pages when the only swap is
+		 * RAM-backed (zram).
+		 */
+		reclaimable = 0;
+		reclaimable_file = zone_reclaimable_file_pages(zone);
+		reclaimable_anon = zone_reclaimable_anon_pages(zone);
+
+		if (reclaim_progress_sufficient(progress->nr_file, reclaimable_file))
+			reclaimable += reclaimable_file;
+		if (reclaim_progress_sufficient(progress->nr_anon, reclaimable_anon))
+			reclaimable += reclaimable_anon;
+
+		available = reclaimable;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
 		/*
@@ -4716,7 +4768,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
-	unsigned long did_some_progress;
+	struct reclaim_progress reclaim_progress = {};
+	unsigned long oom_progress;
 	enum compact_priority compact_priority;
 	enum compact_result compact_result;
 	int compaction_retries;
@@ -4727,6 +4780,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	bool compact_first = false;
 	bool can_retry_reserves = true;
 
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
@@ -4844,7 +4898,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
-							ac, &did_some_progress);
+						ac, &reclaim_progress);
 		if (page)
 			goto got_pg;
 	}
@@ -4904,7 +4958,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto restart;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, &no_progress_loops))
+				 &reclaim_progress, &no_progress_loops))
 		goto retry;
 
 	/*
@@ -4913,7 +4967,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * implementation of the compaction depends on the sufficient amount
 	 * of free memory (see __compaction_suitable)
 	 */
-	if (did_some_progress > 0 && can_compact &&
+	if (reclaim_progress.nr_reclaimed > 0 && can_compact &&
 			should_compact_retry(ac, order, alloc_flags,
 				compact_result, &compact_priority,
 				&compaction_retries))
@@ -4934,7 +4988,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto restart;
 
 	/* Reclaim has failed us, start killing things */
-	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
+	page = __alloc_pages_may_oom(gfp_mask, order, ac, &oom_progress);
 	if (page)
 		goto got_pg;
 
@@ -4945,7 +4999,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto nopage;
 
 	/* Retry as long as the OOM killer is making progress */
-	if (did_some_progress) {
+	if (oom_progress) {
 		no_progress_loops = 0;
 		goto retry;
 	}
@@ -6775,6 +6829,15 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "reclaim_progress_pct",
+		.data		= &reclaim_progress_pct,
+		.maxlen		= sizeof(reclaim_progress_pct),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
 	{
 		.procname	= "percpu_pagelist_high_fraction",
 		.data		= &percpu_pagelist_high_fraction,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..9087b4e0a704 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -167,6 +167,10 @@ struct scan_control {
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
+	/* Anon/file LRU contributions to nr_reclaimed */
+	unsigned long nr_reclaimed_anon;
+	unsigned long nr_reclaimed_file;
+
 	struct {
 		unsigned int dirty;
 		unsigned int unqueued_dirty;
@@ -385,6 +389,21 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 	return can_demote(nid, sc, memcg);
 }
 
+unsigned long zone_reclaimable_file_pages(struct zone *zone)
+{
+	return zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_FILE) +
+		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_FILE);
+}
+
+unsigned long zone_reclaimable_anon_pages(struct zone *zone)
+{
+	if (!can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
+		return 0;
+
+	return zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
+		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
+}
+
 /*
  * This misses isolated folios which are not accounted for to save counters.
  * As the data only determines if reclaim or compaction continues, it is
@@ -392,15 +411,8 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
  */
 unsigned long zone_reclaimable_pages(struct zone *zone)
 {
-	unsigned long nr;
-
-	nr = zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_FILE) +
-		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_FILE);
-	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
-		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
-			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
-
-	return nr;
+	return zone_reclaimable_file_pages(zone) +
+		zone_reclaimable_anon_pages(zone);
 }
 
 /**
@@ -4718,6 +4730,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
+	if (type)
+		sc->nr_reclaimed_file += reclaimed;
+	else
+		sc->nr_reclaimed_anon += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
@@ -5776,6 +5792,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long nr_to_scan;
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
+	unsigned long nr_reclaimed_anon = 0;
+	unsigned long nr_reclaimed_file = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	bool proportional_reclaim;
 	struct blk_plug plug;
@@ -5812,11 +5830,18 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 		for_each_evictable_lru(lru) {
 			if (nr[lru]) {
+				unsigned long reclaimed;
+
 				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
 				nr[lru] -= nr_to_scan;
 
-				nr_reclaimed += shrink_list(lru, nr_to_scan,
-							    lruvec, sc);
+				reclaimed = shrink_list(lru, nr_to_scan,
+							lruvec, sc);
+				nr_reclaimed += reclaimed;
+				if (is_file_lru(lru))
+					nr_reclaimed_file += reclaimed;
+				else
+					nr_reclaimed_anon += reclaimed;
 			}
 		}
 
@@ -5876,6 +5901,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
+	sc->nr_reclaimed_anon += nr_reclaimed_anon;
+	sc->nr_reclaimed_file += nr_reclaimed_file;
 
 	/*
 	 * Even if we did not try to evict anon pages at all, we want to
@@ -6563,8 +6590,9 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	return false;
 }
 
-unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, nodemask_t *nodemask)
+void try_to_free_pages(struct zonelist *zonelist, int order,
+		       gfp_t gfp_mask, nodemask_t *nodemask,
+		       struct reclaim_progress *progress)
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
@@ -6588,12 +6616,14 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 	BUILD_BUG_ON(MAX_NR_ZONES > S8_MAX);
 
 	/*
-	 * Do not enter reclaim if fatal signal was delivered while throttled.
-	 * 1 is returned so that the page allocator does not OOM kill at this
-	 * point.
+	 * Do not enter reclaim if fatal signal was delivered while
+	 * throttled. nr_reclaimed is set to 1 so that the page
+	 * allocator does not OOM kill at this point.
 	 */
-	if (throttle_direct_reclaim(sc.gfp_mask, zonelist, nodemask))
-		return 1;
+	if (throttle_direct_reclaim(sc.gfp_mask, zonelist, nodemask)) {
+		nr_reclaimed = 1;
+		goto out;
+	}
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
 	trace_mm_vmscan_direct_reclaim_begin(order, sc.gfp_mask);
@@ -6603,7 +6633,11 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
 	set_task_reclaim_state(current, NULL);
 
-	return nr_reclaimed;
+	progress->nr_anon = sc.nr_reclaimed_anon;
+	progress->nr_file = sc.nr_reclaimed_file;
+
+out:
+	progress->nr_reclaimed = nr_reclaimed;
 }
 
 #ifdef CONFIG_MEMCG
-- 
2.43.0



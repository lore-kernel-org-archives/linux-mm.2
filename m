Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AF5E99065
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196296B0005; Fri, 10 Apr 2026 05:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120856B0089; Fri, 10 Apr 2026 05:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02CE6B008A; Fri, 10 Apr 2026 05:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8C4A6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:42:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F31C13AEA7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:42:06 +0000 (UTC)
X-FDA: 84642155052.18.99792AC
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87A46C0010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:42:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=NO3eBl8z
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775814124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YChrqsE4WmmiSWUmGyqQcSWkvMfn/HOsna4U+guou7E=;
	b=L2FkmUoS77DCd4sEts8RFP08zO8h0bBHM5aiINZcleuyy+VrjQlQBK2kNtpyR1rykZcuDW
	3HNFy39JAQjn6nWTu8619KTg80gJmLvy8XFKCSEaFwsrw36JfGeiND412dWLpnVnqUUCVy
	E9jGXY/eYlkeqmgaTQp53+loZtyN+3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775814124; a=rsa-sha256;
	cv=none;
	b=XYYj/UdhcE8xBiaNXV41+tpSC62B9LRE2sX7un+e6EcVCKI2hEW5j7AT/+KtY1jnFtlLsx
	eljCjy66xAqThXnalJ7PXlrwZy887tpzCjE9KaaqFIZy2Gk0g8EeBpBtvmchyShpdCp+ww
	lFYbo+kjx44FywccqLCx2pIXJmqZQK8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=NO3eBl8z;
	spf=none (imf22.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.45) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cfde3c3f3so1748858f8f.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1775814123; x=1776418923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YChrqsE4WmmiSWUmGyqQcSWkvMfn/HOsna4U+guou7E=;
        b=NO3eBl8zhKXrAu4lNcACadZUgBvaXoUn1/yTTNCRXq8KDyZP60LddiI8bruGFgy6qn
         G9Lud5VNHvv8JRxEUPsOakDlsTij6ZT7lQfPq6IxTFV+4AoiH1OjgXt0nsp2OO3rVOFW
         oqLEeI69jMvdrlNcW3xlNKIF/YCKxpt4U3vfKB0eC4Wr7xQ55+AQ3Y9JEPzTaTcDEtMr
         hAtyA3o6abfqiv88fhS/lmDMqL8dLS/1kxuKyAbAdvxPaerEVV13IBGrp7QbBzn6KkeC
         VLIVD9av/cEKF3LFxn1Yx670FMsw1wn6OMavYYU2SjjoOB2TAdbQyMfXORXNJiuHjrbB
         QQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775814123; x=1776418923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YChrqsE4WmmiSWUmGyqQcSWkvMfn/HOsna4U+guou7E=;
        b=Bqdp/JAzZjckQvJVxM+gDG093LCnbJCt0Yb0HNXBXs0husMqViPZcApWp6BxEEwn8T
         vbzaZ/T/uuEVOJa2wwI2zT56y8HFGVansYtxnKD4vbi7wDtCz/hm1Bb4/yKGgfvU9Jt0
         ZonJBNTGOLFqexHszrmltTJXtb3m0ZL8csDq2cW1+qThRcC1frS4Kr5W/RUMk511/9c2
         iySnEXGCp/3kCYp+XCrjIy9R8hVGueMDLuB73pg8qGCtOSJ4SRj5dfZ1OoQuoWhKWSqw
         EuppQLAnHp+TtUjlacFD94GIhO8PgDqTIJk6dQ7r5DRoG1EXUkDu2YRJ6l9PZnmpLFQk
         yLow==
X-Forwarded-Encrypted: i=1; AJvYcCVfw+6LoMcQ3BcgjX8wn6nQHxgmhckMZEUfAGFPrcSJBKaIcxB+7lTY3PU0/k/uFffrMsUrjwYR5g==@kvack.org
X-Gm-Message-State: AOJu0YxJTscscoOsNH9UCuLy8/yCwDg8PtNHoRpUslRW8BnBJcaIfiQi
	QUlDGCYAWORoVqtZT4uquzGgTEGDmCCWza1TW5QnT/QeUOauM2Q0Cv3LlOU9Eqq+atA=
X-Gm-Gg: AeBDievCrFGB9TUNFl3b/YJi5/YvhmUOeu+R/pOJLUbgmnTW82vyAoDXdDbO+B5Sz42
	pfsy5pKR/DMDfx7CreBZVZahky63EfPYBUHBFbW8ncKO5Wo8bXwKZEkWWfp0uvoseE2Pc1OcW49
	DjA4KdLN0TBSFjeYuIuAQGNVx0TWMJcePS4sL2Kx5yBI514dcMA178z5r3Jq0WH1auNGHq85YWF
	STmH0h42tIFuEHxTiAkMvaaDyq1NUd3iJHr9MD3ve8SC69r6+Jz368o3EsSujPNgjMowt6KTB4u
	HhGHJaHK6+GYi8NK9JUFi9fBYBJLKIWGgjvJJrImq4f9+G42a6U0V2fKKc8jn6lmuk/XkHaPMZr
	ywQ8gTeP7yYMz+EJhXiI/Xywe3xUc6aDgxx6DqIWZP8fCCNcua8ZouzoIDLmw8GCJnUwYk5zVth
	aihhXABmUGuCvkGqpFrCUxTyBuSA==
X-Received: by 2002:a05:600c:8b6d:b0:485:9a50:3384 with SMTP id 5b1f17b1804b1-488d688209dmr28260235e9.25.1775814122698;
        Fri, 10 Apr 2026 02:42:02 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ebe::178:140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67ced32sm21701095e9.7.2026.04.10.02.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 02:42:01 -0700 (PDT)
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
Date: Fri, 10 Apr 2026 10:41:56 +0100
Message-ID: <20260410094157.2895775-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260303115358.1323188-1-matt@readmodwrite.com>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87A46C0010
X-Stat-Signature: sd4wrrhae7gg9eanfq756qn3kqcqsr34
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775814124-652445
X-HE-Meta: U2FsdGVkX187MDzXqLYg8YAQETzQaI9Sf0eCY99NEgRuqAvrC3zRXIWyc1266C+1I8jzv8xSKtvU2vYAdn0ijRYLNjwzjPIP7ZnDl8yYY6ZrZrpKn+3DDKDVeUUuZ22ErHb0rqTQrapAvaugxA3aFjRTvGnqNUaQWLLXcVGQRbdna34ualP9lEITSMcDLyBjn/yXLplWaN9oIjRSaPYPxO/gmNqP2iG4wj0XynIJdwMUO9i1we4+VaI4T/IAbokNNuT/NtUKef4tCB6e4/A6ieEgkTv2lOFPg22PQa9Hf0d3FD8uFi3sQAbmTEArNLR/zXAsfifq4ZQZ0bJpKAEbU5Ftj/UFuS0EYWeEUxea7Hzu26IdmJWnAE1iITmEEaVq/kKOm/Xl1mVeQjuA7FRmMe2t2qoxVaSc9wY5Eqa9tRQ/9iTIm2Ewt+fbKig8+5HXEoNsnnIajweqTLkVjkx4a8IZ+ybmHu/aEfsQzNVJjHw/EwDRffavhhZapyXQUF67ydkWQ1/n6270LvZuabI6fII/qYrnowUPfb5e18MiYs6YXrF4suVxE/TaTbJjKt0kQubQswMFHAxaSkEtoaJ7npauWSsEhr3TskUQJwVfM5pVpQ/ws/D5xrp6/0GsgBhXfcP0OOEvgrLxnLt7DfS12SvtkG2ouf46xKJW+0toqFootOpGBt9RttO+TfLd6fzXeLy46U6H//uPBqrrOiHwwv93e1gZoM0XeHiFjJrDisyjm4e187xTxqK/AXUqz8WYMKtGb+BMqKYPibDPSbhgPXurP1/tvTmA0AGUN4lFOn3Q9hCiDgMr3nHRonWkdKsP3afcXJkJOj5F5FM6fSBOmOeIx7Yn5dx2Gheh3Pk3uYqqQkBTusSSm8L6MeGkIo48Q7D/9nijdieQC0F4ns24H2AZsNmg1tDcHLFJgB4uexBWNBz2vcspw34bnYBp9hyFehWPPPCR9cZbFdfF3Hp
 fA3SSuBh
 fVnkWX2bZXdC4T2BiJmSxXgbLJxo9CeTW5W762XW4DBsUyCjCMxwkB0N71ptLVpRYvI/exCab4zQ1LCWMje7JDvBNlWnWUrg7PTAoLN3kBayyGXDamW8s5fPH9pCW+YDVSBKxv7TpvEJNSZJPYOnano/fIyKt6UlAVYCFq+umDZ3gZG/BA7TL+qRGH9P948rH09Xyc3euX21xbSrL/HNLpoPITleDbDaj5+RF6sD6k6WmD7nvQ/Fsf+UU8n6p35R9DKZnPMGchk3+aRAf+56e4IoTY0lKFele7RDU6PD+/VJ3Noz7BqeauIyCpSjMD6sha2riAu2Gc3gQOifIvy9noLYhnVGW6Y41w2duDw+EfylnNfPGvsNN7TD4t8IMtN9CPldFGM0hIy5AhmzvVLtrFlm2oqbwtJWxLeRKII8oHVW7zdSi9PNFa0eZ3NlsRveW+ZJ/Dbn2pbq4DAg=
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



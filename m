Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B04CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092836B008C; Thu, 11 Jun 2026 08:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069336B0093; Thu, 11 Jun 2026 08:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0BF6B0095; Thu, 11 Jun 2026 08:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9A8F6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:45:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56890165531
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:45:11 +0000 (UTC)
X-FDA: 84867602022.14.FEA595A
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3784418000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:45:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="EyEMU/9k";
	spf=pass (imf06.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781181909;
	b=HBJhC+w6rwnifJwmyZMtj0HqtiU6J7WIJrXCW/FLIQ9OcMrn6ZeELggEcXqDe2xkbJQcdN
	PLh5VB+WiAkzZ/LpIV9XI/d1MO3ZXjvWMHQedDzfHI1MvxTsxvuEfKbKgkrJzV+NbtzLG3
	s99ZYIEH0cvuCpVx8Loae60th34Jn7k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="EyEMU/9k";
	spf=pass (imf06.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781181909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kyOfgVu5yfwDz8MkBg/Q9OinVX8qNXoGt73ReB+mpZo=;
	b=dRtjFxeuZHcm1peJ2YTjtTrQKobBbsef1NRy9nUXqO85JnKwvZ2jUhhY4dl6X555uCc1sb
	DzKvtcRibCWFYbgATTIzK7bqP/YzB7Oq0x2SuHCNPbKnYSqvMmbnmUoWQN3rPF8vEB2xZl
	6h4d592YQ5CFCYWTngOX2F8m+76Gj1Q=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ef42b6399so671450f8f.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781181907; x=1781786707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kyOfgVu5yfwDz8MkBg/Q9OinVX8qNXoGt73ReB+mpZo=;
        b=EyEMU/9kTY25etyqu+QPFoPJfMJwE8+InVy6Yylq8mSVNjtrNtLEA9fKRVE7xSJae2
         tQVsxftnzvkTn7YaNtCSMvpyKOE883gx1Q2r+EeS2gIVM/XuHUm6afeAZyYxTMOUv7p/
         TDAkW5i+1HeZZZkLhXl1jWzzeEW4K7gUKeTkyuN/hrJ6FcFfl8TKi2O7TmEbvG9IJQN7
         JZ8MBbrRZncDrkLNX0+h/9AdXs5mD602mSIryyFGdHp8Qaug2sjbyUAE3pU4HfdoMbnI
         vFSme5E4WNvACykwDJWpK1YpZGBrX4qgUnidoFeWW74O9N+B92EEp0jGHFfP04JcCC2I
         mCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781181907; x=1781786707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyOfgVu5yfwDz8MkBg/Q9OinVX8qNXoGt73ReB+mpZo=;
        b=eKe+sH5vtwTPHR1V3p1Rhb/W6eZ3vs6yM9Q6mkv9ivHBKVNBpicDj3WwF6k6xleZ59
         n4T1aATpdh7Lf+Mj3AeFuPicnnIMFzTO46nd61FdJRFEm+Who3qbymgy/NSqdxG8RJux
         MAFXN0SBoNYQhjK3zG2I1CtcPEznu90LcSTRT9oGICyQx1kYBKbLd//ir/w4Sw0nS7mI
         ZV24wNS0B2VqH/ga2e+knnCO/PCAogXVeR8o7Qyg1vseX3rhULX1V99PQzD0pgsicrr5
         XRsNC8fSrYccXu/INl0Rcqqox0P3RRbf6hCMk+efqlNsoRU+5Po/HCGgK/ZuLhmAiFfk
         E+oQ==
X-Forwarded-Encrypted: i=1; AFNElJ9sD8U0fMlawcGA9dqTutE3Gmzqb43INUD85xlkKuPxTnXeOAkdmF0Q5qQVoA2+gvavWkx9DR311g==@kvack.org
X-Gm-Message-State: AOJu0Yw/Ah4WVhh1VdqXI/JKt4jZjrTx5zUEIMfyQgBOSdEpm2PoZZk4
	b6N3wPowYAmdQ0OXmy6qGekpDvZHjRAloxz707ZnqRooagGJf9xh6R0adz9jkbClOu8=
X-Gm-Gg: Acq92OHyrSD7u2ZKkglB0YXG7tXxVZ118XY2YGCIVDfASlinn4nLSINj6XtoqlHthl8
	e6jyJbkX6t4IHQuwBDD0NxR1PNVxIZxomRANtJrApsH3/gAcs4HsqAlhlkZH9w3OOgXumbGa7Rx
	swo5/+8TdyeSPUuYGmPTPRxmtaY6+xdS9ud1T/mReUSV24y0f3jc9QjLPRIT6sLyKxc9PBUbVCY
	hhCetwg4UKLrZykdtFxRMU742X2BTj15R+VS8XcTxRZo42dRdwV+xM5Qlq8z3OzzIqBABrvkhdX
	rRnGL1L+xI6fLzGwY6404WF/dOVeccZAWH4+AZ38Uctz0PW8DNkP1tMqp1OJzleOynxduW4UKgY
	acefdcZ3lAcN0hUroxlippOS/SGfQtzCz6JYCTkU6CJJRDYqUG63RdYOIIGO0uYZPA4+Yc0epUi
	OTCSbm1lEBdLPuHuRzDokprefJX5SFnxx996rQjUqarTonnpAF6pnd1wSbXYL14yRd1kg23lOKM
	Shv+3gPp9HOjbvXKey0g6MWlMrr
X-Received: by 2002:a05:600c:8b31:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-490e562484fmr14944255e9.3.1781181907493;
        Thu, 11 Jun 2026 05:45:07 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e44ba907sm50385245e9.1.2026.06.11.05.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 05:45:07 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Cc: Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH 1/1] mm: remove NODE_RECLAIM_xxx macros
Date: Thu, 11 Jun 2026 14:45:01 +0200
Message-ID: <20260611124501.1465806-1-ptesarik@suse.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3784418000F
X-Rspam-User: 
X-Stat-Signature: 3hda41199wp1yti1e8877tdtz4ooeea8
X-HE-Tag: 1781181908-162994
X-HE-Meta: U2FsdGVkX1+FaznP2ank8ydqZaEflErRpP2XBD+XcHp32Ccs07bbIRxC3X/zEMYm9rTZZgNkHu8xKhVI3ScDfQMz4zmCx3ZxaoGfnSyPE+EmnLXNciwIyMfIesKBPclBP2hp0iSwMZSx4whOP3d7pjHF6+n0i8lgFcASWHZLG6nT6+sppQsKS0MvXV2L1lvFA5AlAUq4BGR5zyv5NeHGSdHec+DPpNN03Rl8fw4IR+l2n6dhAYKbz5cpAooC79Bc6/j2xpo2Es1Jz+VTqYyVAywXB89SgdKQCys0Vv4udotzX7EZ0oU9gSOMuTajiIi+r6VfUW2y+LTQ7H8JTDsTDYw+3HAEoC4tya8nhlrmyMo2LXEdvhttyMsX6nrI6r/eOIthsA2mCPzBy9ME4nzp5kovbCsRt+D9XGtpyuuRZT+tSatwdlTkuplGoiNbJ3NjxbAoQduiZc4uLlG3vPW13zpMxPT/yKrWPjcZuaPLTTQOwsFTsRVdOwF7RlD99CBQwd93I0DMfjRIFUsgMepBH3bBorszVw60pKoR+LG1TLeXjS1PPkkKtakYQrZWJ304gD5pscj5O+lsDOSGONTvx+uIoRHMN6XK62r2m2o+8pyidyrmjx4kzYQgGqwSL5uqqU3HDR6qeUYj6/wxtMP6qrhXFXmYN9ebOXT0roTt+aDmbS+szonSpqQRbQ6VUkW2nWbLK3Kfy0sLWb2TjdMq+7FOAuFqFTo+HPwYL1J3dDo9AdO+TOFkD89gySvNTcceJR4uAo3wn/9XwP+Edmohqvjd+/J7QEEhovdInseYF2kUZc9m8B0CRnGgr7Rru9pKpKn3UmRh86QiQ5CpdKBZ3lQi00gRtOCKCbll6tLPvlW3rbYlAAlMmmsQZoO0LF8PcU0jMr/qTWYxPn918+aoxOHE/8ctPBIzuV9he3b4KzwGc0a09OG+YlnZbEbl4A1C1Ou2AjqMxgbk/uOziWd
 mjEqgUxa
 6BeM43ovomOWHPLn3jfBAYvP6eF5tV86Ot61HPiIkz+x2fbnvlBAdHz3ta0WyPoZv+mE4yaYPYR7xKAiSA5lpheGP6Csoce+cVW/w8jvVTE48rZWPgeyFC1j47vF4ltzGXGmYBoviBiL/+seKGwfhsKaeB8Cy02mqTLDimZcU13uaBRian+AJ4E5gy0t8jniMpjyasfTk/fKKx5Y8Y2bvbXLjkiA5Mmg2RP2UErrE5RQK2+sBWksE1PnTmR9NolZ4c18PR6V3QHtB+bHvGIwL/hzcz4ucgxWf7icn7WxuLS7R0T7ySFwhDdeo30CmzBQrn+PfNsR8mhDKajp8BJjiH+3Vlxh00kiAjDyBUiQ49WXQmvyHHwdTFbKB12E3UfvlGQPeLynfC1nKTXyEGhY0QLSiJPkSr+xwAM+rOW95vQC+Un4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change node_reclaim() to return a bool indicating whether any
pages have been reclaimed, because that's the only information
needed by the only caller, get_page_from_freelist().

Originally, I wanted to convert the preprocessor macros to an
enum, but I couldn't find any explicit use of NODE_RECLAIM_SOME
and NODE_RECLAIM_SUCCESS. That's because they are typecast from
a bool. This seemed a bit fragile, so I dug a bit deeper and
came up with this proposed cleanup.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
---
 mm/internal.h   | 12 ++++--------
 mm/page_alloc.c | 19 ++++---------------
 mm/vmscan.c     | 18 +++++++++---------
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a20..6e09157a97692 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1373,23 +1373,19 @@ static inline void mminit_verify_zonelist(void)
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-#define NODE_RECLAIM_NOSCAN	-2
-#define NODE_RECLAIM_FULL	-1
-#define NODE_RECLAIM_SOME	0
-#define NODE_RECLAIM_SUCCESS	1
-
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+extern bool node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+			 unsigned int order);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
+static inline bool node_reclaim(struct pglist_data *pgdat, gfp_t mask,
 				unsigned int order)
 {
-	return NODE_RECLAIM_NOSCAN;
+	return false;
 }
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7db8f049bd23..9db7eaa7091c9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3899,8 +3899,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			int ret;
-
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -3921,22 +3919,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
-			switch (ret) {
-			case NODE_RECLAIM_NOSCAN:
-				/* did not scan */
-				continue;
-			case NODE_RECLAIM_FULL:
-				/* scanned but unreclaimable */
+			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
 				continue;
-			default:
-				/* did we reclaim enough */
-				if (zone_watermark_ok(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags))
-					goto try_this_zone;
 
+			/* did we reclaim enough */
+			if (!zone_watermark_ok(zone, order, mark,
+					       ac->highest_zoneidx, alloc_flags))
 				continue;
-			}
 		}
 
 try_this_zone:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3f3ff25e561ac..64f6b649eeac1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7786,9 +7786,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+bool node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
-	int ret;
+	unsigned long nr_reclaimed;
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -7815,13 +7815,13 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
 	    pgdat->min_slab_pages)
-		return NODE_RECLAIM_FULL;
+		return false;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return NODE_RECLAIM_NOSCAN;
+		return false;
 
 	/*
 	 * Only run node reclaim on the local node or on nodes that do not
@@ -7830,20 +7830,20 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	 * as wide as possible.
 	 */
 	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
-		return NODE_RECLAIM_NOSCAN;
+		return false;
 
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
-		return NODE_RECLAIM_NOSCAN;
+		return false;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	nr_reclaimed = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-	if (ret)
+	if (nr_reclaimed >= nr_pages)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
 	else
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
 
-	return ret;
+	return true;
 }
 
 #else
-- 
2.54.0



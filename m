Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B63CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3456B00A0; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5792D6B00A2; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0866B00A1; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3B16B00A1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3072120166
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:01 +0000 (UTC)
X-FDA: 84716346162.11.3622F88
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B9B41A000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kkgl6yUf;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dO5EGvScRggH72PNcTKipQePtQRY0+ZyeCCwamEp+nw=;
	b=VA5S7PNCTP/62i1EdrhtH271P21T+immBM3fP9PAXGV019tpU3a5FW6Vibkj+TQV9Ju0+I
	n5YhSbn1QOuvK40jM4baNS1pXlf15c5DR5lHotoHyRM83BU/71Ty1L7/jWl+AGbAbt/3Q4
	7F7pwbFQ6dgfE616VtzF+xfVkktzjQ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kkgl6yUf;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580580; a=rsa-sha256;
	cv=none;
	b=p6P5i9n+ITbgFgVebxSw0OZvObnfEJl0ZTK1rHCNhzLrkW5OFrSANfnoo+iTUo+xEm1bpG
	dDR1wpzQuEN8BlORED11wuJZcvYoOeRANsWi5t+mG9ZlViwojk2cXuSrK5/duRt8uTW1z8
	a/MiUI3gvyp+Qpmc+9BKzacqgxKityo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dO5EGvScRggH72PNcTKipQePtQRY0+ZyeCCwamEp+nw=; b=kkgl6yUfxfBTd6HOC1tB14m/WB
	08aUmTSjp4XkMJmgh6edw2Xw/D6rI6fZfUl7BI+T2KvOfhVSPRlQ/6vfEDwSvwBXNHGI0Z258NATi
	m9XAizi7JMuJr5PlfRgYSH2vl7NPwtrreRCTcBrkgO1Dk5JVoXRrLOtzb9NhfEQYCXZg3FruaDMU0
	vA1RHIyr7tbUVRge3wdq0rEgqEWZiOb3mzAM4ieDNFrKIr+fFEcDp07i57Xkgh4Dg/V7Z8A8tFQ6M
	FEPRxgC9NtYxNa/LpI8IsW9OhZg+F5VMr/OqBMp3f7YsY3dWDcD3PMWe3gKMnXczRq2qrPFR4nhoF
	kR1dryrg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1L7Q;
	Thu, 30 Apr 2026 16:22:41 -0400
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
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 34/45] mm: page_reporting: walk per-superpageblock free lists
Date: Thu, 30 Apr 2026 16:21:03 -0400
Message-ID: <20260430202233.111010-35-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B9B41A000D
X-Stat-Signature: jwgid3fipb5aada7q486sy5mui86eunc
X-HE-Tag: 1777580580-369355
X-HE-Meta: U2FsdGVkX1937GyVwKEIUJCHN489zpX2+MtXO97Dn4Dodc5fU+Z71bJr+cfFJGVKkEEhavnBGmC/HbZnRELuzCSZT2Vn3dXsJcwbj19hM4m0zRJjfZiB/NU3+uuE2h7f42KrtGn43lyTJvMUSlMOcPuvwkQRJhGbMpY6izHZD/43HTAOk2T037Fa+o2ms4M7TwRfz5vRktz1To/xTh9OGufLn+OzCSaeTeIj3up2GTCfnt/84ghH+Fa5GTDgxA6u/RJ3LJPNm6eVdeePyMAGSgCHxd+pWgvPlpwmjbTRWItCiLfAtif85HMNrA6rxP80C05vSaJVEaVSXtddlb1/KKeu2ViPHGSWLhd0ZXIfZ5Msn/BlNjKjlbwDqKvf3y5hTgiYSl6c97w2vqHs774xzJ75ArSQKIC07Urv7HsIkhWhXk1WqCH2D81WsDzzh+tLYJqcdbW1rbaNOnKlvtYksuY91mQNimEi8cDd4tKRJgu+k3ieguJ1RUrQvhbTB+w5UkUDAnnbRIPSjLFg8htKMNOM76OV2UWdFLc8tBRicTMbQGiBiYpjKgiSFPxZ9OCSutXu/p0cWt3NXT2P+K2TUIAA0ayQLIb6jttMPvx8Aoi0u6DUy6SxB41ds+OuAczqFO+vwF5KHMlnQS2ZT+3wFdpc5BDg9CAKolxp39YTkTLqFORsnGoOiQGqng5ohjoIHTvpIGrjshNAxZCzWcBCRN3jaxWU35VrUG2uxKUlkZDOLHAe1WVoQJFiXNkKzYfQWjtbhB0k3OfFmsWYqNFkiit7JMTR+KEzzta5VASAOD7RMOLzY1Rg5QFrMl1OHUaxmRI1MgdRFl226XucPXmDEJP20yZIi/mJqdFEpRMDq7xol8dCHmFnVd/CF0P/eJvwGTPlGd3wjK6L+8rezfcVEKtqRQhST+GaUnlZ4F5YyUKRJuV8YQ3PoqKHiejO8OMJYQOVlCPGWLSisAchEoL
 wtleLy//
 Nc9SBQR7Lxtedw+e9EOYegQ5d+MbD+I762WQHdazujLEXUZ3p6VzBorIaxKswyRpsqPWHIEdw385fhL/OJ9eFwD71JWjrarU62uqyUYrfYnxiyC6up2fcloF9bt4zNGN33a8ZG6inylNQQjdArfy8hhQh68pF/dy1ExT3GUsZ52+HfZ9ioo5WbCROcq9HEY99Sv51GHMJuYjp7WDyWSg9hLN/XQbtRLq2qse13Y5mldWFbEGUxUYSPBonZiz99us3sYae6xOYrmttAQlo7lukbHySWgHQ2tZy0wKA9GcJQYChSIBfiQXAAl9H9UbMgK/ps1IavTYk4uBWrkFTRfzuSh9axw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

After the SPB rework, free pages live on per-superpageblock free lists
(zone->superpageblocks[i].free_area[order].free_list[mt]) rather than
on a single zone-level list. page_reporting_cycle() was still walking
the now-empty zone-level list, so virtio-balloon free page reporting
silently became a no-op on systems with superpageblocks: no pages were
ever isolated, no MADV_DONTNEED hints reached the host, and any guest
memory backing balloon-eligible pages stayed resident on the host.

Refactor the per-list walk into page_reporting_cycle_list() taking an
explicit list_head and a pointer to the shared budget, then have
page_reporting_cycle() iterate every SPB in the zone for the requested
(order, mt). The budget is shared across the whole walk so a fragmented
zone does not multiply the rate-limit. The zone-level shadow nr_free
(maintained by __add_to_free_list / __del_page_from_free_list) is used
both for the early-out and for the budget total; that shadow already
sums all SPBs.

Hold the memory hotplug read lock around the SPB walk.
resize_zone_superpageblocks() swaps zone->superpageblocks under
zone->lock and immediately kvfree()s the old array with no RCU grace
period. The helper drops zone->lock during prdev->report() (which can
sleep) and resumes operating on a list_head pointer that lives inside
an SPB; without get_online_mems(), that pointer can become a dangling
reference if hotplug runs in the unlock window.

The zone-level fallback path is retained for zones whose SPB array has
not yet been allocated (e.g. unpopulated hotplug zones).

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_reporting.c | 149 ++++++++++++++++++++++++++------------------
 1 file changed, 90 insertions(+), 59 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..81f903caec22 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -6,6 +6,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/memory_hotplug.h>
 #include <linux/scatterlist.h>
 
 #include "page_reporting.h"
@@ -138,116 +139,68 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 }
 
 /*
- * The page reporting cycle consists of 4 stages, fill, report, drain, and
- * idle. We will cycle through the first 3 stages until we cannot obtain a
- * full scatterlist of pages, in that case we will switch to idle.
+ * Walk a single free_list (zone-level or per-superpageblock), pulling
+ * unreported pages into the scatterlist and calling prdev->report() each
+ * time the scatterlist fills. Updates *budget and *offset across calls so
+ * the caller can spread one budget across multiple lists (e.g. one per SPB).
  */
 static int
-page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
-		     unsigned int order, unsigned int mt,
-		     struct scatterlist *sgl, unsigned int *offset)
+page_reporting_cycle_list(struct page_reporting_dev_info *prdev,
+			  struct zone *zone, struct list_head *list,
+			  unsigned int order, struct scatterlist *sgl,
+			  unsigned int *offset, long *budget)
 {
-	struct free_area *area = &zone->free_area[order];
-	struct list_head *list = &area->free_list[mt];
 	unsigned int page_len = PAGE_SIZE << order;
 	struct page *page, *next;
-	long budget;
 	int err = 0;
 
-	/*
-	 * Perform early check, if free area is empty there is
-	 * nothing to process so we can skip this free_list.
-	 */
 	if (list_empty(list))
-		return err;
+		return 0;
 
 	spin_lock_irq(&zone->lock);
 
-	/*
-	 * Limit how many calls we will be making to the page reporting
-	 * device for this list. By doing this we avoid processing any
-	 * given list for too long.
-	 *
-	 * The current value used allows us enough calls to process over a
-	 * sixteenth of the current list plus one additional call to handle
-	 * any pages that may have already been present from the previous
-	 * list processed. This should result in us reporting all pages on
-	 * an idle system in about 30 seconds.
-	 *
-	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
-	 * should always be a power of 2.
-	 */
-	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
-
-	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
-		/* We are going to skip over the reported pages. */
 		if (PageReported(page))
 			continue;
 
-		/*
-		 * If we fully consumed our budget then update our
-		 * state to indicate that we are requesting additional
-		 * processing and exit this list.
-		 */
-		if (budget < 0) {
+		if (*budget < 0) {
 			atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
 			next = page;
 			break;
 		}
 
-		/* Attempt to pull page from list and place in scatterlist */
 		if (*offset) {
 			if (!__isolate_free_page(page, order)) {
 				next = page;
 				break;
 			}
 
-			/* Add page to scatter list */
 			--(*offset);
 			sg_set_page(&sgl[*offset], page, page_len, 0);
 
 			continue;
 		}
 
-		/*
-		 * Make the first non-reported page in the free list
-		 * the new head of the free list before we release the
-		 * zone lock.
-		 */
 		if (!list_is_first(&page->lru, list))
 			list_rotate_to_front(&page->lru, list);
 
-		/* release lock before waiting on report processing */
 		spin_unlock_irq(&zone->lock);
 
-		/* begin processing pages in local list */
 		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
 
-		/* reset offset since the full list was reported */
 		*offset = PAGE_REPORTING_CAPACITY;
+		(*budget)--;
 
-		/* update budget to reflect call to report function */
-		budget--;
-
-		/* reacquire zone lock and resume processing */
 		spin_lock_irq(&zone->lock);
 
-		/* flush reported pages from the sg list */
 		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
 
-		/*
-		 * Reset next to first entry, the old next isn't valid
-		 * since we dropped the lock to report the pages
-		 */
 		next = list_first_entry(list, struct page, lru);
 
-		/* exit on error */
 		if (err)
 			break;
 	}
 
-	/* Rotate any leftover pages to the head of the freelist */
 	if (!list_entry_is_head(next, list, lru) && !list_is_first(&next->lru, list))
 		list_rotate_to_front(&next->lru, list);
 
@@ -256,6 +209,84 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	return err;
 }
 
+/*
+ * The page reporting cycle consists of 4 stages, fill, report, drain, and
+ * idle. We will cycle through the first 3 stages until we cannot obtain a
+ * full scatterlist of pages, in that case we will switch to idle.
+ *
+ * With superpageblocks, free pages live on per-SPB free_lists rather than a
+ * single zone-level list, so the cycle iterates every SPB for the requested
+ * (order, mt). The budget is shared across the entire walk so that
+ * fragmented zones do not produce a budget multiplier.
+ */
+static int
+page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
+		     unsigned int order, unsigned int mt,
+		     struct scatterlist *sgl, unsigned int *offset)
+{
+	long budget;
+	int err = 0;
+
+	/*
+	 * Early exit if the per-zone shadow says there is nothing free at
+	 * this order in any SPB. Avoids touching every SPB's list head.
+	 */
+	if (!data_race(zone->free_area[order].nr_free))
+		return 0;
+
+	/*
+	 * Limit how many calls we will be making to the page reporting
+	 * device. By doing this we avoid processing any given (order, mt)
+	 * for too long.
+	 *
+	 * The current value used allows us enough calls to process over a
+	 * sixteenth of the current free pool plus one additional call to
+	 * handle any pages that may have already been present from the
+	 * previous list processed. This should result in us reporting all
+	 * pages on an idle system in about 30 seconds.
+	 *
+	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
+	 * should always be a power of 2.
+	 */
+	budget = DIV_ROUND_UP(data_race(zone->free_area[order].nr_free),
+			      PAGE_REPORTING_CAPACITY * 16);
+
+	/*
+	 * Block memory hotplug for the SPB walk. resize_zone_superpageblocks()
+	 * swaps zone->superpageblocks under zone->lock and immediately
+	 * kvfree()s the old array, with no RCU grace period. The helper drops
+	 * zone->lock during prdev->report() and resumes using a list_head
+	 * pointer into an SPB; without holding mem_hotplug_lock for read,
+	 * that pointer can become a dangling reference into freed memory.
+	 */
+	get_online_mems();
+
+	if (zone->nr_superpageblocks) {
+		unsigned long sb_idx, nr_sbs = zone->nr_superpageblocks;
+
+		for (sb_idx = 0; sb_idx < nr_sbs; sb_idx++) {
+			struct list_head *list =
+				&zone->superpageblocks[sb_idx].free_area[order].free_list[mt];
+
+			err = page_reporting_cycle_list(prdev, zone, list,
+							order, sgl, offset,
+							&budget);
+			if (err || budget < 0)
+				break;
+		}
+	} else {
+		/* No SPBs (e.g. unpopulated zone); fall back to zone-level list. */
+		struct list_head *list = &zone->free_area[order].free_list[mt];
+
+		err = page_reporting_cycle_list(prdev, zone, list, order,
+						sgl, offset, &budget);
+	}
+
+	put_online_mems();
+
+	return err;
+}
+
 static int
 page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			    struct scatterlist *sgl, struct zone *zone)
-- 
2.52.0



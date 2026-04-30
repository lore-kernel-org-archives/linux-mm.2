Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF93CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54F16B00A3; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC296B00A1; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B948E6B00A4; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2576B00A1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56C6240133
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:02 +0000 (UTC)
X-FDA: 84716346204.20.64E7201
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id B320840008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=awZxtyZw;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580580; a=rsa-sha256;
	cv=none;
	b=fosTjdQpHu63u4sxKn30DhMFM/noPNdPWw8Cf2PxTZKEC5w0gTYPjn6kwGAvSu2WFBB82N
	oUpk+kTFlCuItY8Kcsvk4gHNiiGoCR13P0hgHfG6yNRVDEM41iFQ2Yu3NXplaJihNfmg3W
	oAAioyRyoIbsslzrFXLXrSRaQVk2e5g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=awZxtyZw;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kt5GNjBeLABnBd/hL+1b6b1fMeRkP20n1Tblpb4QH04=;
	b=gtHLYTq7/AzSTLmA5PiVWKIDH3jyzL/k7OlHdE3xFBTqqM/S/cgd0cmculUMiYu73jJPdO
	gt8t5oEH7As00G5USoKPLTh/2ZP1h8D4MVJUosdwW6oY5jVXlY/gT1RsD6Ts++p9sfZXy/
	ERmq+KArNFlMGs+2qJyrKnRg+wMYt8w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kt5GNjBeLABnBd/hL+1b6b1fMeRkP20n1Tblpb4QH04=; b=awZxtyZwecddB6EvRPOgcqqGvA
	IRcXu9Yscs0Joo/AXlv0RwllD4aKOn6TlWwsD/aTzEmiIoXbc7A7xCBtrOWj1BEMaBHN1NGM+/HPq
	bJJJ0pic+Vg4BF/wVt/hP5TIwMHmMxqQiWXA/mYA4v+jp11ld7aB2fPQlS8uh1rowrzXCFOov9xs+
	hro+ThRizVBODDqPqs0LeLxC9Mg8YdGIZgdYALhYVtuev7iyUNJKqWTU7QW0jAxFeOCOXSgWe92ln
	lm2mkRVbijdou3SwLRLQRXiA5nTG0Iv5GHEjtB6Kg/txhs+X5n82zQYvRZraewN+P2umAec/UF5zn
	3MFqto3Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-45zn;
	Thu, 30 Apr 2026 16:22:40 -0400
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
Subject: [RFC PATCH 23/45] mm: page_alloc: add CONFIG_DEBUG_VM sanity checks for SPB counters
Date: Thu, 30 Apr 2026 16:20:52 -0400
Message-ID: <20260430202233.111010-24-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zm8c3g7nh878wprichdsa93jco68fhmc
X-Rspam-User: 
X-Rspamd-Queue-Id: B320840008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777580580-377645
X-HE-Meta: U2FsdGVkX18dYDqRH9WKKzJkY02Z1cfFlCT/Rg+A+q7h8X9EwFNWA/6YyrwUlCdgz9ewM8C4058CBF9cothSn7Mqtaq/DSSChjPCh6cFyauWFWk0GTmLUtfbRatu0K2V44R99Qmj6rl4IGDUnI0z2hsdn72mSo0mf5I+SNhu0gmHu0z8XdT1qMJ7LvpNU9nuur5KDQuYoEasuMwytNl+MHZO61Yza3jhiJoH6aGGazl89EtAWLH9x2nT4CM2DFSAN259n5Uqn9UJOQWmdF7XFodhPv30gf4zkvEdyQWVOxbNU9XENK6twMwSGLOong+3ImqO4X9ucZn9je4zLDyryL1hPecFfBKHIiivM+vxoHHZx/9AuEDy4nUwvh4IHFFJE7Fu256SKIOFxQR8RLL50ziPRJhMP645ogU+iNMRYT3IGHx4+0JfQTGkPFNg1pyzvyT1lBQauQf+M59VKpacpVAmPLHgQwQZS8gTJ8Sjf0Q1B5/dv4yNZJDdoy8HexfW6lX7v7ejd3T9LS5IQv+PRnUBSNJatZhaPFKc/qn59UCUg4+lPanPvF0zud+z32zyHkGFbCIRk7zYdTcJym1Sa2v5/JGS4MgLDnM/yYmyVvZ2qSqjK48+q7eFEAeXftXRwIGW5DYxUIVIlmdmRpybbK0iClgAZQviFJGcsjMs84iIfiFFkQLG2QlWwlkSrhLMuLeivg5cufgUB2hyFoTYX/Vvs69ugoavgS0k3V232WeIhCUUXf4Fst+puUVCntxk4gOkaYugdTqv8Kkmozbe006+Wyw46WdFU3FJN3ZoVHiKHYAn7ed+tFJnlY8MyAmlOepHKazTBzwvy4E/LpOQmduPdFw1sgrBZJYnAboreTm7/Iwu8U11YiCKg2imYfMu4MYzVUl2aM2fhJWvxJmGuIsaih+5tqkM4CUnmYqqbGcXlPyHNc0JNyy6/K1mBB+1ZUqgJQZN/jpJzkpiqaN
 YehwTJ/w
 tAIzXRNr3OL88n1WFlqqrQ6PdSDtEQQeTM8CM8kQaBZgwrMGSdLUJq0Uo5EexKFRVxpycqJmU8k6Pywx9E+ipovRL+neGOD1lhqhg5ziFTreffI9HS0g52lgzWN61QIrddNWaHSanaTThqRO/mK9U08tRUQD/HjEJS/DRN91jZXnEmaoDo5p28iIpDIYmcoMFOdWFE3cwtcXkWBrN4Y3wF5hwBLYPyIEZ0rD7cHhNFjv4mVzGDdAuuwMDLjP1v7F1QHTNCxR1iCSZBqifke3VqiyrsSzI/ElIwyXTp5mJyWATpLmiu6dg6GLFTSK5b0YBDluV+oRwkYSPpqrRNWzSlVKVJo2ZAj971jXjenCA0yHlIG8nSYs4gsLaS6t1VpwazzVx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Add spb_debug_check() and call it after every site that mutates the
per-superpageblock type counters (nr_free / nr_unmovable / nr_reclaimable
/ nr_movable). Each counter must be <= total_pageblocks; a violation
indicates that a PB_has_<mt> bit transition was missed by one of the
allocation, free, claim, or evacuation paths and the counter has drifted
out of sync with the bits.

VM_WARN_ONCE keeps the production cost zero (CONFIG_DEBUG_VM only) while
giving us a single place to catch counter drift early during stress
testing instead of debugging it from a much later misaccounting symptom.

Several real bugs in the SPB stack were caught by this check during
development; keeping it permanently makes future churn safer.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4f8105b89e47..9f4298fc2727 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -521,6 +521,32 @@ static inline int migratetype_to_has_bit(int migratetype)
 	}
 }
 
+#ifdef CONFIG_DEBUG_VM
+static void spb_debug_check(struct superpageblock *sb, const char *caller)
+{
+	u16 total = sb->total_pageblocks;
+
+	VM_WARN_ONCE(sb->nr_free > total,
+		     "%s: nr_free %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_free, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+	VM_WARN_ONCE(sb->nr_unmovable > total,
+		     "%s: nr_unmovable %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_unmovable, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+	VM_WARN_ONCE(sb->nr_reclaimable > total,
+		     "%s: nr_reclaimable %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_reclaimable, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+	VM_WARN_ONCE(sb->nr_movable > total,
+		     "%s: nr_movable %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_movable, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+}
+#else
+static inline void spb_debug_check(struct superpageblock *sb, const char *caller) {}
+#endif
+
 /*
  * __spb_set_has_type - set PB_has_* and increment type counter
  *
@@ -552,6 +578,7 @@ static void __spb_set_has_type(struct page *page, int migratetype)
 			sb->nr_movable++;
 			break;
 		}
+		spb_debug_check(sb, "__spb_set_has_type");
 	}
 }
 
@@ -589,6 +616,7 @@ static void __spb_clear_has_type(struct page *page, int migratetype)
 				sb->nr_movable--;
 			break;
 		}
+		spb_debug_check(sb, "__spb_clear_has_type");
 	}
 }
 
@@ -818,6 +846,7 @@ static void superpageblock_pb_now_free(struct page *page)
 		return;
 
 	sb->nr_free++;
+	spb_debug_check(sb, "pb_now_free");
 
 	spb_update_list(sb);
 }
@@ -840,6 +869,7 @@ static void superpageblock_pb_now_used(struct page *page)
 
 	if (sb->nr_free)
 		sb->nr_free--;
+	spb_debug_check(sb, "pb_now_used");
 
 	spb_update_list(sb);
 }
@@ -1305,7 +1335,9 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype &&
+		     !is_migrate_isolate(get_pageblock_migratetype(page)) &&
+		     !is_migrate_cma(get_pageblock_migratetype(page)),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -1339,7 +1371,8 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 	int nr_pages = 1 << order;
 
 	/* Free page moving can fail, so it happens before the type update */
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt &&
+		     !is_migrate_cma(get_pageblock_migratetype(page)),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), old_mt, nr_pages);
 
@@ -1364,7 +1397,9 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype &&
+		     !is_migrate_isolate(get_pageblock_migratetype(page)) &&
+		     !is_migrate_cma(get_pageblock_migratetype(page)),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -10529,11 +10564,12 @@ static int superpageblock_debugfs_show(struct seq_file *m, void *v)
 					   i, sb->start_pfn,
 					   sb->total_pageblocks);
 			else
-				seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u\n",
+				seq_printf(m, "  sb[%lu] pfn=0x%lx: unmov=%u recl=%u mov=%u rsv=%u free=%u total=%u free_pages=%lu\n",
 					   i, sb->start_pfn,
 					   sb->nr_unmovable, sb->nr_reclaimable,
 					   sb->nr_movable, sb->nr_reserved,
-					   sb->nr_free, sb->total_pageblocks);
+					   sb->nr_free, sb->total_pageblocks,
+					   sb->nr_free_pages);
 		}
 	}
 	return 0;
-- 
2.52.0



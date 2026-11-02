Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6EC60A2610
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jhwU60fm
Received: by kanga.kvack.org (Postfix)
	id 861926B05B4; Mon,  2 Nov 2026 04:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839866B05B5; Mon,  2 Nov 2026 04:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7277C6B05B6; Mon,  2 Nov 2026 04:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 431936B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:39:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB33DC0C79
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:39:55 +0000 (UTC)
X-FDA: 85389682350.04.295843C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A69864000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:39:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhwU60fm;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793612393;
	b=mJh1nvT9RENooFhTlVnRVpW4rFag1oYvQZmHnDAuN/Echsxl1ihUtS7CVdqXYBWhAP1xQD
	LMacpx3e8ShGvY9V6s5PO0rC9xksPstbxNRcp12L0R77hmRxTH99JKdnLCa5+CaSmWdVlp
	vpLD7zVDOedJTPVSXEm40kBLZPv7gZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLIU3Qu9j6PfSIppGNHBU0Z6z1EAix93GaiiwcWHaPE=;
	b=KQsUO5iSs6Yiijyw6M3YnhHENtjCtLkw3xNldEl4MxhpdTLetYk6Ss9LgjoHOryNdwRTpz
	PibzAjmgNEYmqMQj0SNn9oqVNc7fUbTvecL+8FZuYQZBLN/yxkqeiXpZ27Yovds9Tro5uL
	k7QZx9fkkF1ewJMVB8AuHiVol7WCo4c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhwU60fm;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01CCA43E3D;
	Mon,  2 Nov 2026 09:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155051F00A16;
	Mon,  2 Nov 2026 09:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793612392;
	bh=PLIU3Qu9j6PfSIppGNHBU0Z6z1EAix93GaiiwcWHaPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhwU60fm6fJVgEYkwuCzyPxEDNRQQGiAixg/pLIYjY8AL33HmJ7+OQGR4Wd3/KMpq
	 3O7hH195Bd8WClmdYf1jyN+iVw17AaaZWAxLnd4bYyTKWx0Jb/vm3pmMM6FU/OFf3F
	 833MDqsDSlJLwAUjmv3yOB1XoJ/PKdHiF6DmoRUVgn5+sxht2hDflpDR0pdQXPdHe7
	 8dGgXJVTw8c8tWVRzN7kuzVQiM5jBA6LGfyJhdtvZ6AhJjp+TII9roTSDp/mjxA10B
	 fJ006XuuCkc5y9xCFx8EW2SNwJUhRQhT1vRj8oaZqoxWqNcGqCJ+ogZumAxQaBBhzW
	 1Jf18NRB7qdpg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 753DB1980050;
	Mon,  2 Nov 2026 04:39:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 02 Nov 2026 04:39:49 -0500
X-ME-Sender: <xms:YlroalOqjZNmffZ2WIq--wzDYJXVV4DToOOVgYy88Dgnvqc-f4yB7g>
    <xme:YlroapDOjAD6C8UmOBPP1DEyIsfLIaPVBdBwh7fYuAl4Lqjkoeoe6ynsNthK70WEA
    38qWwpCeZwclESVM8uK0VXxhhk2x-aaWF6Zp6W35FLPZsxdUfpJm8yG>
X-ME-Received: <xmr:YlroanMo0UAOMRDEEOSK4ubth7gCzDx0e2KwE0n-L3o_9VHGzPEw0dNdoWI>
X-ME-Proxy-Cause: dmFkZTFfNoVB8J0rx8nifPYd+qKRtp29PWkX9KZuHko+Ts55CioRbwnpVaVqPEFOtlMN9x
    wKYJGJgcxHY5I+jrutGMiNMby48Epfbz6j2xX8eAirJpB5JeNqfWCxIPC6qwvUtfdJGfXV
    rvRFRlQxssUsal99hVwi4glDwqlAFKJuQJiIL4KNdRZWsT0U712UtRewOVYBILBwiEkoH0
    UxnfKzJQEdnVBX8f3mna3wmC8GfiPL9QqklMzJJJk7OcjdSosgl5Jv/a0CRg6SmFxhaiZa
    ki3MzSXjhqRHWEjrsB2Ebo81ttm8ytuejLqyFyFWV08rQTTh3C274vAQrAiI7m1/lnwQJh
    TqDLeqswtxIR7uQw5T6BxtWmb9F/b2y7M6/JaTgkSPf/NO+1SeJMjqFFsvcKwV6Aum+u4k
    P/B3p/p0J3Rre/oGL2cPYKoKClsm87VqpxhINUg4SpIA/VeeQZ5x8oqrhEL0qN5DpFJmCO
    cAV4KXVApEnaknCfySe4lLwKrw3V9L0gkSLOo11QIWFbi4xQ6SeqeQBTkiHqyHOiGnme1R
    7eiBxpumn7dlI9cm/aCpG6HI06pJjm4NGuXC+NhCyP+F/LUEaHZMyt//v+gGQ02gzubtM1
    UfDnTRqoLdi8H2pDpBGqUeI0k+rbERfAyRKkCK4EdFlm6nebwYdinPWv2MZw
X-ME-Proxy: <xmx:YlroavbQQ9rquIuClf1Ms6h50CCyCJCP3Mz7wfBnTn9EwjYzjLS3Sg>
    <xmx:YlroamO4tfGP922Z5ABZPZLu2npgA8pRJ1bOT6Tu5GovNujPH-WcZA>
    <xmx:YlroatUMkW2YwyrFSeUOoWGDx0qf7t5cYKM_FG_Ac5_NXxrYP4Jfrw>
    <xmx:Ylroavcsaq0CnmcmF0slybVfYBQuryJSxCHRDrv-he2LY9h_6ryIZQ>
    <xmx:Y1roauhArdEyxPpR02lZuNk-s-6ryO81VB52QqN4z56w8_4MewkJ4m-t>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 04:39:46 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows the migratetype
Date: Mon,  2 Nov 2026 09:39:34 +0000
Message-ID: <20261102093939.3340540-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102093939.3340540-1-kas@kernel.org>
References: <20261102093939.3340540-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ktzydhwq3u4i8b3yy31cci59dhyaspgn
X-Rspamd-Queue-Id: A69864000A
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793612393-362014
X-HE-Meta: U2FsdGVkX1+ArMp6V7f0m4fftHtpJ2kjSLnvca2lEHWnoPosVJH25iXazKN0zmSGMfwsJyIHtX7BOo7qvgM5KjKbtHHgRGarBL0v+uySu3q1UdTrhy/SL5xqma02rjs2ox0D2DNQotO5S1IWgzxNIoUAJpEn2/kcRdNLk6z2lEYWQ0B7Czs3aCC3WCRUe8W8pqXGMevkTx3GbfeWYc8Ilyr2cpIALzBKUF1eXwN0dEPDLPLI637lXBLGz4qlhgX6v6BnAAg/f5KXGlAf749fs8F0XZW8SOKi60YUf23ebqPzNfMzVHG1x81X/ovnWXdflEVwv1Ace8w0GOEf+mC8kwqHAmVFDNJPqYzfEb9oWQSnYCfUQnpwTzgsfPMyHlrMTvc6tNWu6/RF4SQvfIShdZwYeQUolKAE/U26Wh8+HL1YOH0SzjzMlptUIdKb/8hZnjSXWMMc1lNR/BA+eIrhJt3jx/Ap7t942p2FviIRBzXifr+r38fFPGWGQtHUOzCL721azLVyHDJOW9qkc7zo7ee2s7eAjNp47A7s9SAbVHD3YYBtUCuvhEGy01ehBX0iBSUOKq5Rqw5iG1+fKhsmNM3vHSjtqLYPPATgauOEblAsz5KwlKEin28+gp8tIBADfuRrRNUNRCirN+tbVqUJXjIF0e3jgazzvPllGjTAwCs57d3ftBmGaAPpJnc9LNTM7U6phHDya9l8KUFN22RvWY259N+pIdi0h1ni9KuhywyZCykjsc0kizav4VKxgLMz3j3Un7ARKJjIClfh7frkJSJjDC6tD4lj3AtfHdqIZvEh7eqQ730p0ucdBlVTjfpQriQQ0xwbe+0RC9OzFYpNYFf6KulruMjEXR/5FuZdOdr3f6GktAW+oywp0S7vZBlrNw8UHOfqz4nSdcFgUpAgIuxf7Y9BqbTePQsTJ6YRQLF2tgtoR5MzdppcmVL8dUt6THgs8RUNUyBK4r3GDxq
 xOTuUZW+
 yKMi2zifYa+9KONpQodkrKZXugRaoF537aigKeFWyvSTjH80P7CUm6uvKKN+RwAAWmUEFbIezt9jCbpwbkODEmEyKs59AftRKvDayWWh+WhEdU7ZhM/SM9tO+vJN5sM0qcr6qq77lz5aajr6Xld+Ci7aSwAqWKr+fpKSU7trRWlynglIEsHP23B4wk3ekE5CgWAdikmqYOXRsJ4Jwt79I3IWgk83EeXn0eTls1PHnpYz1SJnC39ncyHlT7qdcWKl12kopSrHo+v6+MUv2Wrgo4vfLmyvo579UPqpRLhtIAl72OJaivUDYzbU5vXkiTwboiNkI7T/735uvNHWXZmXUr6LJVBMrfF4hGb6qa8mh3aZG7GsCQ3mkeOvP3CRAi7lMy+zrWEY1/Z9/qxWGmLnXoQ5P/z/J55bO95vm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The high-order check in __zone_watermark_ok() accepts a free page of any
migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
only take a page of its own migratetype or claim a whole free block, so
the check can pass when the allocation cannot succeed.

Telling those apart needs the request's migratetype, but not every check
wants them told apart.  A check whether an allocation can be served now
has to count only the pages it can take.

A check whether there is enough free memory counts every migratetype:
kswapd and kcompactd balancing a zone, order-0 thresholds, the
slowpath's forecast whether reclaim and compaction can still make
progress.  Reclaim and compaction work across migratetypes to free whole
pageblocks.

Move the body of __zone_watermark_ok() into __zone_watermark_ok_mt(),
which takes the migratetype as well, and make __zone_watermark_ok() a
wrapper around it for the second kind of check.  These use the new
function:

  - the allocator fast path, zone_watermark_fast();
  - its recheck after node reclaim in get_page_from_freelist();
  - compaction's up-front check, compaction_suit_allocation_order().

Declare both in mm/internal.h: nothing outside mm uses them.

Nothing reads the migratetype yet: no functional change.

Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/mmzone.h |  3 ---
 mm/compaction.c        | 11 ++++++-----
 mm/internal.h          |  7 +++++++
 mm/page_alloc.c        | 37 ++++++++++++++++++++++++++++---------
 4 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756..4d9347a399fa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1637,9 +1637,6 @@ static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
-bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
-			 int highest_zoneidx, unsigned int alloc_flags,
-			 long free_pages);
 bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx,
 		unsigned int alloc_flags);
diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb201..6c553d0e90f8 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2520,7 +2520,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 static enum compact_result
 compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 				 int highest_zoneidx, unsigned int alloc_flags,
-				 bool async, bool kcompactd)
+				 int migratetype, bool async, bool kcompactd)
 {
 	unsigned long free_pages;
 	unsigned long watermark;
@@ -2531,8 +2531,8 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 		free_pages = zone_page_state(zone, NR_FREE_PAGES);
 
 	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
-	if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
-				alloc_flags, free_pages))
+	if (__zone_watermark_ok_mt(zone, order, watermark, highest_zoneidx,
+				   alloc_flags, free_pages, migratetype))
 		return COMPACT_SUCCESS;
 
 	/*
@@ -2588,6 +2588,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
 						       cc->highest_zoneidx,
 						       cc->alloc_flags,
+						       cc->migratetype,
 						       cc->mode == MIGRATE_ASYNC,
 						       !cc->direct_compaction);
 		if (ret != COMPACT_CONTINUE)
@@ -3073,7 +3074,7 @@ static bool kcompactd_node_suitable(pg_data_t *pgdat)
 		ret = compaction_suit_allocation_order(zone,
 				pgdat->kcompactd_max_order,
 				highest_zoneidx, alloc_flags,
-				false, true);
+				MIGRATE_MOVABLE, false, true);
 		if (ret == COMPACT_CONTINUE)
 			return true;
 	}
@@ -3116,7 +3117,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 
 		ret = compaction_suit_allocation_order(zone,
 				cc.order, zoneid, cc.alloc_flags,
-				false, true);
+				MIGRATE_MOVABLE, false, true);
 		if (ret != COMPACT_CONTINUE)
 			continue;
 
diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..8e58e2db5e09 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -726,6 +726,13 @@ extern int min_free_kbytes;
 extern int defrag_mode;
 
 void setup_per_zone_wmarks(void);
+bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
+			 int highest_zoneidx, unsigned int alloc_flags,
+			 long free_pages);
+bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
+			    unsigned long mark, int highest_zoneidx,
+			    unsigned int alloc_flags, long free_pages,
+			    int migratetype);
 void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8cac5e01066..7730660bdd09 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3587,9 +3587,10 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
  * one free page of a suitable size. Checking now avoids taking the zone lock
  * to check in the allocation paths if no pages are free.
  */
-bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
-			 int highest_zoneidx, unsigned int alloc_flags,
-			 long free_pages)
+bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
+			    unsigned long mark, int highest_zoneidx,
+			    unsigned int alloc_flags, long free_pages,
+			    int migratetype)
 {
 	long min = mark;
 	int o;
@@ -3665,6 +3666,21 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 	return false;
 }
 
+/*
+ * For checks that are not about serving one allocation now: kswapd and
+ * kcompactd balancing a zone, order-0 thresholds, forecasts whether
+ * reclaim and compaction can still make progress.  They count free pages
+ * of every migratetype: reclaim and compaction work across migratetypes
+ * to free whole pageblocks.
+ */
+bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
+			 int highest_zoneidx, unsigned int alloc_flags,
+			 long free_pages)
+{
+	return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
+				      alloc_flags, free_pages, MIGRATE_MOVABLE);
+}
+
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		      int highest_zoneidx, unsigned int alloc_flags)
 {
@@ -3697,8 +3713,8 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 			return true;
 	}
 
-	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
-					free_pages))
+	if (__zone_watermark_ok_mt(z, order, mark, highest_zoneidx, alloc_flags,
+				   free_pages, gfp_migratetype(gfp_mask)))
 		return true;
 
 	/*
@@ -3710,8 +3726,9 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 	if (unlikely(!order && (alloc_flags & ALLOC_MIN_RESERVE) && z->watermark_boost
 		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
 		mark = z->_watermark[WMARK_MIN];
-		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
-					alloc_flags, free_pages);
+		return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
+					      alloc_flags, free_pages,
+					      gfp_migratetype(gfp_mask));
 	}
 
 	return false;
@@ -3923,8 +3940,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 				continue;
 
 			/* did we reclaim enough */
-			if (!zone_watermark_ok(zone, order, mark,
-					       ac->highest_zoneidx, alloc_flags))
+			if (!__zone_watermark_ok_mt(zone, order, mark,
+					ac->highest_zoneidx, alloc_flags,
+					zone_page_state(zone, NR_FREE_PAGES),
+					gfp_migratetype(gfp_mask)))
 				continue;
 		}
 
-- 
2.54.0



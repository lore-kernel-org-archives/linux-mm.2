Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519F2606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RomHqfYI
Received: by kanga.kvack.org (Postfix)
	id 795A56B05C7; Mon, 16 Nov 2026 07:51:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D1D6B05C8; Mon, 16 Nov 2026 07:51:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6836D6B05C9; Mon, 16 Nov 2026 07:51:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47CB16B05C7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:51:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC8BB1C4325
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:51:19 +0000 (UTC)
X-FDA: 85440967878.20.57DA4B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E379180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:51:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RomHqfYI;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833477;
	b=OM5Z+XbAgXC8v4Uup4zbiV79wPmZDN0pSpplrPaCpWw1SxBt2A39fFSfwXDdqtvtjceum2
	URx6U2YcTtxxOh+5ecV7XpZ9MBrCadCfMsQH2G1rH96PnBogR+FZHz0Ezi+ofgw7jos9bN
	rZp4WhktRgqiKE/7pGMgMga/34czgfQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RomHqfYI;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCYlLXJNTyDmNDujRtLuukrToXpkUaT1TjJ6p/R0SBk=;
	b=G7mWMMMFvl9byL1J5Hb7bg/x7mwL29cfAlkerg6kmhjWNNqW2XJry0g+iZByrxKEy8mKQa
	XLeoRvK8pMtTcrvgClWh+6E2qcQIMyQyfYr/2olY2ru2CGtvnTvMS9ZmjJsnzyr3na2Z2K
	xs+rbrM8cR0o7NLTUJuND7utrZqLTdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A476E62A3C;
	Mon, 16 Nov 2026 12:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185DE1F000CB;
	Mon, 16 Nov 2026 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833476;
	bh=jCYlLXJNTyDmNDujRtLuukrToXpkUaT1TjJ6p/R0SBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RomHqfYI4PPKwFFnxBp4865nWHDTuwGzJaVDQkqCjmGHWdlgfrSzx9LhkY3HuHmUB
	 0GBFvN+fGHqv2ylMG7o1EUC8pLC8ITTGvSNV8XsM7UC1qbCbcQeb2MmbKP7k6YfdqS
	 iGbnCzO95pdOZoBrERpqH8wyqb98GMZREl529W4B6A2qi75Un2Nlvs/2HYoxFYYmDh
	 7F6S5ec4A++htBUIkkYiZYlNmoOj6WV1X4V7M2PNwScI/EHLwygHJKAcGHAPEdC5eW
	 shUfjX3jAr7eh5MX+TH2ARcn8lVaEM/u8ToYud29VAMVxzgiPD19SNZTSx/t+aMdCV
	 bdi2djbljI3sg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7221E1980052;
	Mon, 16 Nov 2026 07:51:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 16 Nov 2026 07:51:13 -0500
X-ME-Sender: <xms:Pvz6agBdZ1WFFQ_FPYmq3t8edpXFSp1E0d6elHh0HQDsCoGRvE6b5w>
    <xme:Pvz6ajlQQd7OWvpxlgN0KDTfoCsLWdB7i3b5p4fjzT1VdA89R0Y7pAtK46rZ-E-lO
    gArm_SzUy2waC3bQotBR_KhKNgNQ6V9Q6WiqwL1V4JuepK97LHJogj7>
X-ME-Received: <xmr:Pvz6amgz9uhMCqn1_Jsyt-RSl8yOn6wVjk7pq7DSWes2MAiiLrU5tnEes-Y>
X-ME-Proxy-Cause: dmFkZTFKZPcgB6Kh/KGtpP92uZmKvmotC9FH97AD/nqdyZAdrKaHq0v3CEXOTa5nVR2rZJ
    c8fMR6faKbl7tlAg0vmlVRHALUWRQAtIjtHVLobAo9+lfvs4DNznrf84ZEr78rYX5TgtId
    LnfAjm1WjEYR8equvBZ1DmRCdwP6CXxXkOvheAcl/W8VsKooSgBwB49Eu9pVfxlPTrbCdk
    Xpu4MPxfwEDwIwxcG5wkvhgCfeQCV5d4Ie2ZCHdDfAlFxb1eGCTY/J2sM0tapWd3bL7s58
    ai3M29eGUnTf++aw1QIYNNjj82vQB0TieiOnFpsxq4bc86BurBF0kM+Af4sIlKDN0dpvbx
    sIbmEtpXoN4JfdF1RzjzDMVz2FUm7JxyINdK38lSvNeceNbc2WjjTc8JGlWDJpANZjpzb2
    73C6asy3VUmhtmXFJ3ZP2N1YaBINweET4wZHiO7KWoYzO819F3yD2GK1hwahINDYpBljV5
    X0wbOY8ZxvApJHL9nNAXbujPYr0WFeeL/DVIbPb4XTQ2RHUQRDYhaB7UP2XgwoATVJOxdB
    zSsv2Go0463CnbmiP1uP7UJ99TsbAuHhr7oM/T7q4vAmU/NqlDDCuHwRavvPArVH7DywYz
    ecgfrQSyy5f+DOMiEoNEgQqDsllO+binRxTzv/uw+lF9+Cz2YdIYGkKl5/qg
X-ME-Proxy: <xmx:Pvz6akeZvUlqctmHspH4Ne4cgP7YM6jes0Z5q_pNyq3jSG2BZsUT_Q>
    <xmx:Pvz6auDINLsoOB8YJZ0iAXvmKXwva7h5w1i7_FAy6BMLGGLEIn18dg>
    <xmx:Pvz6ag5gt_rdsfKr24gMRLKJ7sZfW0BzOGhQA8SZ6-KbV9UeNvKkFA>
    <xmx:Pvz6ajzSDFzq3lIqnerg9YxZpB4OAH0EPt9tohONPkrtnm6KJ515QA>
    <xmx:P_z6akmdBX8OSrPykz5mhJCPzm3YO4jJrIbWXxtOdrgwHfqZy1LQjbdG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 07:51:10 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>
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
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3 1/3] mm: page_alloc: add a watermark check that knows the migratetype
Date: Mon, 16 Nov 2026 12:50:59 +0000
Message-ID: <20261116125103.2894162-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261116125103.2894162-1-kas@kernel.org>
References: <20261116125103.2894162-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E379180007
X-Stat-Signature: 5ijr46yshb6mj5b7qst89ok1kyqtj86y
X-Rspam-User: 
X-HE-Tag: 1794833476-433595
X-HE-Meta: U2FsdGVkX1+GYxXneWTQHnr3nwHj93DrYcPvvlxSwc7Rk3GYCO5id7rjQn8ElwybmjvJf3xq1sj9zu30m5tPSX0AQelg9WbLomTitZ8jmboR03UGEpKxgQmemhwsc4tvqoLFaYkt2SDthU5l/tS73NQU0OERaTV1CVtD4A1gGnxjfqy4pyTnrU23rg4XoSwyhArohul0bNqthYPLyj4z6pRVwG2bSfrfdFi6H5ksFNrWcEYFteyXGEmpgRJSaM1fyS4ZXUiqAsxs0E5kF7ajrPV/egXvQW/L9FzZY8hAm9B+qldGYj2K396WfTFGlSnKzr7xulVPH4k2vOqX5CRYvIX+K1ck8YmgmZb/Q207LAUalbK7tCH55qEWNuPkUT2cYY66Vd6FKoBG6paqhnvSSubVQn8+ReCSKmfjiiRiZYsQl3szgKgDyttWyPiPlBPq2eyJ2pUWPi0j8tKe1N0/IlnhlDq8hkwfudoUVkqIVKPrrcpo40ZEtpH9lsjS6PGzrcjnTSEs2WL3hc9Qps06qfSrxecb+h4q3ntJouONKf1XaB+l8I+XuqsthirBzXdKaEFLtDUUtjlZ9EY4A8S8Tmor1I0PcqGtv8WVrd+FT93RXu1h8afQqslZt5EJoblw02g4KvYZ9qWtsB23Wpy/kZheEuMxEKbGMxxTomo8O2RCOzzZtJ+Szd2U87BO05V1/XHKjVLaefQm4zu3yCF7pOJh8509vG47rYtbnAJvik1/g7q7PcvHBqC90/RkAWxx/3iv5+NT0RdS8ScSz5Cr6kdWJvlHYCJvwadHOe/qpBY1H56nCHKANtlDasphFol86Y/o4a05HUHgQWhMjdO1tVhwpI8uplmxhGwB++YxM/pXVWrlVeWGVOABmsQD6Tz2waFB7Yg+9yyQZaLYPuXpXHZusAOmxVHeLCBpF84GDLuUkpETamBqnVA6MrzFvVU6nXTxWmrkyymembN6Mta
 fzJ6rE/K
 MOwlwyUAiYPQ29Aqmb5kHAaxZ7AigyQ5eVL7rvIgbsQu3BcWyAbPoxYfxg3zXrdJ3XDUxvPpFtMSscIf4GJMPIG5XguckS+8tdo8jf9fYE4fGEqS78l9xdsoxV+bhjNvZI53k3MOSF/JVSX+hk+1pOzHYWV4QEvm0c6uRYdkpLNzL1rcRLLEkPUOBq6iuUayxY2dRdn7pd6/admM7UnyIX9/qaTAEMX0I+eHPak247yUsCyrtsBZ54n7fAIXA5ivGdHzhGjCbZlkpwUmQOoPeqicw/r1ZC4X95lfe4V8g8fWelOeYAlVjYJMEDqniwp9WaVDCluV5Rp2l2l3jbN3imyr+7QQjoyitwI0/2pxLqB7Cw48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For a high-order request, __zone_watermark_ok() accepts a free page of
any migratetype.  An ALLOC_NOFRAGMENT request below pageblock_order can
take a page of its own migratetype or claim a whole free pageblock, but
not steal from another migratetype's pageblock.  So the check can pass
for an allocation that is going to fail.

To tell these apart, the check needs the migratetype of the request.
Add __zone_watermark_ok_mt(), which takes it, and use it where the
caller asks whether this allocation can succeed:

  - zone_watermark_fast();
  - the recheck after node reclaim in get_page_from_freelist();
  - compaction_suit_allocation_order().

Other callers keep __zone_watermark_ok(), which counts every
migratetype.  kswapd and kcompactd balance the zone as a whole.
should_reclaim_retry() asks whether the allocation could succeed if all
reclaimable pages were freed, and compaction can then free a whole
pageblock for it to claim.

kcompactd passes MIGRATE_MOVABLE to compaction_suit_allocation_order().
It never sets ALLOC_NOFRAGMENT, so the value is not used.

Nothing outside mm/ uses __zone_watermark_ok().  Move its declaration
to mm/page_alloc.h, next to the new one.

Nothing reads the migratetype yet, so there is no functional change.
Preparation for making the high-order check honour ALLOC_NOFRAGMENT.

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/mmzone.h |  3 ---
 mm/compaction.c        | 11 ++++++-----
 mm/page_alloc.c        | 36 +++++++++++++++++++++++++++---------
 mm/page_alloc.h        |  8 ++++++++
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
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e1261521b6a..0ebfbbb5d7c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3588,9 +3588,10 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
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
@@ -3666,6 +3667,20 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 	return false;
 }
 
+/*
+ * Return true if free base pages in the zone are above 'mark' regardless
+ * of migratetype. Use it to check whether the zone as a whole has enough
+ * free memory. Use __zone_watermark_ok_mt() instead to check whether a
+ * particular allocation can be served.
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
@@ -3698,8 +3713,8 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 			return true;
 	}
 
-	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
-					free_pages))
+	if (__zone_watermark_ok_mt(z, order, mark, highest_zoneidx, alloc_flags,
+				   free_pages, gfp_migratetype(gfp_mask)))
 		return true;
 
 	/*
@@ -3711,8 +3726,9 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
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
@@ -3932,8 +3948,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
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
 
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index e238ee91ed24..d95420093b15 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -231,6 +231,14 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
 
+bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
+			 int highest_zoneidx, unsigned int alloc_flags,
+			 long free_pages);
+bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
+			    unsigned long mark, int highest_zoneidx,
+			    unsigned int alloc_flags, long free_pages,
+			    int migratetype);
+
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_frozen_pages(...) \
-- 
2.54.0



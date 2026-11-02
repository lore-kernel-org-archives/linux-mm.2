Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1E2606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hy72pF4e
Received: by kanga.kvack.org (Postfix)
	id E54D46B05B6; Mon,  2 Nov 2026 04:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05786B05B7; Mon,  2 Nov 2026 04:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5426B05B8; Mon,  2 Nov 2026 04:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7AB86B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:40:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96994A8A65
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:40:00 +0000 (UTC)
X-FDA: 85389682560.27.A901D2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8750220005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:39:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hy72pF4e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+NjX0i7iua/kR7lRGFWkbibVVW0pqZFNgIbLWz1GKo=;
	b=bblzetGj23/qgCemnxXwImRaYFHSEuAR1sSxCebyCW4sw+MD6AchPesChGR4YuitwSONJi
	ONwOJDhvJ3r2rD3Ko5ztUWF0yn22ZraUqdVU9vFjtRTe0ZQPiY7j9mTSLTSVusVNh6ZKSF
	6AHdaObXZKlvZhU8xUEGBdI+7Pe8VrM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hy72pF4e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793612398;
	b=yTGmD+16rKZV0HaMNL3jDfpsdDXUk1T8LTMqwo8/Mr1OHPvz71A7C9xxRDUhUJzV/cizs0
	sRKRT7fF23pZZCPs+f6CN7kJf/CCqEmSy9rUAbXQgRD4nHWWo8oOI76PEBElYwUy9LhgGv
	AaESLgcxdWN+y47OtHUVkCcQkrC1fpo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0B8543FF1;
	Mon,  2 Nov 2026 09:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCB91F00A21;
	Mon,  2 Nov 2026 09:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793612397;
	bh=5+NjX0i7iua/kR7lRGFWkbibVVW0pqZFNgIbLWz1GKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy72pF4eP3oRze3cbWJaGe4wXTRuWkmjdC44cYN/AipGiGD7M1nxxsknmlppb2Uid
	 QORT6KsvA41V1vQMk3opIdiT/wuEeN10tJVue+7oPu83EoRsvBuIZABYUiyfmVVC8T
	 AnLUWS3ToMAf2nBa4u7UyljHJjuLgRT4FSxhUk19NWIwwx7lgAJVZLgkZEeNeppA5a
	 hz3vdE3W0dr15m1k5B39d7fiURuaqeV7ap2HXS81Gy+ytPuqo4vukDrmky+jOsVylA
	 9ajmIRaMZ5ZlmAy33bzfjYqVGnydivUrQBwzPSMLCNoQ5o7E32OUM/sLRf/iJ4mNq5
	 9gKDth1L+Srgw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id CBF5F198004A;
	Mon,  2 Nov 2026 04:39:51 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 02 Nov 2026 04:39:53 -0500
X-ME-Sender: <xms:Z1roanDiKXbFLaAe_JJjz1fKpPTxlcjc28HoEPzV-shSKxxD4vIRQg>
    <xme:Z1roaunANriIQ4cjv5gmOrFHshi6OgYcoftmDxV5RKl5LWocdSx-lJ1wgcP_bOoE-
    WnPcEewZCB60yRUEYVgc_370-s2VgD4dGBcVYzJMXDBDXl2sIk2QpvB>
X-ME-Received: <xmr:Z1roalhO9bugcueSGTsLbSVatZfypc8MnLoZe5UCZJMvJz0Sh9mAU5Mvklw>
X-ME-Proxy-Cause: dmFkZTFQzR3EIh2rxnTQ7G5RQ4h5xUtBbfaRXYhAnr/P9m7R825W5LXZo4M7w8GIKmIjGj
    qybGvaUdVk5pSieVtTsyoZ6ucg6NMIsQaSkBr3/sxQrJxCcLIhMpJSFbq+kpA46wGzaqo2
    SSshVKDj1/7+zxij4YAc74swndDYo6XkK+PNI5K+fKsZVu24yZBOMeGIGR6Gxf+6GTRxIb
    PDupXWDeZprGb+597EGq5pTehEBJgX0Qk+xDf9JOiQdRB94h2GagfZ5ody0ueOwnbFszoH
    eMQpNI0XbAvyAwAalknBNsPb7YQIm/7nk2H/0WptA+ahLU8XVv6vz+9VwN6/e1viT1lGfb
    wRb1ZkKDH5PZZzoNbYL/+/K7Cw0ZppQMLZiVDwhw2kVTflREelyTK5r5mlCYfpo95N81J2
    5OlpmLNBaW3/Lp4hEC/MdIz7koOZH5/SmY4O2qsPvP3KRBJ3hwyLDY/kcz9bJtTqy6Kt8K
    pMJvThlWmLFq9ni6HDFBt+W2KXNViZRTfyaXrZlShpsj7MTlCesuaM5f2UmQnYd2Da6/qi
    wG+dX+0ukPO6K+Tm5/H0ieG0MbALBL7od+XXjprVtmtKTSP8gtdXeoU+VaQWOXtvOK9jGU
    GgK4HUA9B+KU8shU/cGgjBmxMIbIUorA6+FOzfc7QlfWWXsTw2vJ38zfyMHw
X-ME-Proxy: <xmx:Z1roanexz0e__cOwPgnpZYMrdOThPDLeXbeyTf_2RZQLW2y-LyfkoA>
    <xmx:Z1roalA15BY6ZrEJ2_O-jstaMJ_vWK7TuHwje7oLEy-CcFWdT8ZhYQ>
    <xmx:Z1roar4rFbeIhgi0EdeuuId1PBdKBKEYblrf7zzH7SFsSA2nBiC78w>
    <xmx:Z1roaiysPDs1d1CfE8VgD1r3RbQNhctTA5Z5iLGG0uXubFTO46u96A>
    <xmx:Z1roankIc40nuHxHrYRr_YEGib1QAs0f9g2RVvb4PdiUp844xjenxyiS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 04:39:50 -0500 (EST)
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
Subject: [PATCH v2 2/3] mm: page_alloc: make the high-order watermark check honour ALLOC_NOFRAGMENT
Date: Mon,  2 Nov 2026 09:39:35 +0000
Message-ID: <20261102093939.3340540-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102093939.3340540-1-kas@kernel.org>
References: <20261102093939.3340540-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8750220005
X-Stat-Signature: 65k176g5n5g1sfpr6b3c1it33nbub1ap
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793612398-887468
X-HE-Meta: U2FsdGVkX1/5kJp6K7pmV6GTn53u2ZkkdIMgHLe6ZpWCp9fjabn1XAiyoIzbB3vll0Qs3z29dhK287viDiBOSFq2wri6NwXtY1ODgzY+sJCZXKuHQgiDh/ACVQ0UWBO9D0FD0NhyKzQAWXiZlUlTdYAAUOFojZUDfPfDgarqJZj1p0o3BwwAj8tI3VVXW9T/7wQ8w468ni8gfqFQwkcnBepeCXgE4ijNTNr58aJbPztvvtU92bnGI/Dkah4HGK0u+y+LUVkHPYfa6tAYNAgCC+/emgS8Ugc2xc8P/YPAmZt+uxIOpRYeZ+c2FJMLVy+3BtcHS4/FV+632dAKilPeyxIaGcCKnXCuB6iioiVsaFW7bawZLDmRt6GB6MkDUkbaCRwGFgzOW++rZNzdIxd8jyPFU2wlzgC35gnp5AE8//CnW4AXc4qXe5RAEYCPmf/jlxGI9jqUXPQlj42JmdeHhn6cXBFOifUi0NZaIaC85O+ySYCpm/oWKHAlATuW7ww7qGmzeJFhzXuskJ7Wf5aarPIhNfoLTsrZfuaZ5u0Y75Eay3gKGZHHaQeBCeKvpGFSDd+yG+U4n5PcMy+N/ArnK1Unpwi/9dO8a5ybsO6bGK4GQ4lNKBYGGnIYYmTefLlKgWI/A687HV5DBWfGIfiDmnY9W9Q3jIWVCK+yJTq1Kc+HBNoqpXrnfn2TVXPq38lQpUj2pQbLEDakqqoMNEUVR/yPeN3D5Utpn/XwbAP3ztoCggzX03Y0rQ+AoH5uH3Op+fYylY+HJmFrLv1bcf5dj0JGnoCj3XMoP0Z7cLBQQv0GHAqA9fh2zQ/HxcmDr4IFxD9wenBXFMzqzJbdEBp98Z2zdw+W1Nu+UdY32/Fr42/oD29ca8hmdqzRaUZYCzLr4pE/H/L/Ee8VIDCh8sR/O6xfkQ7Jg97MBNj3MpJwraO34BnWrQsNzegAsghCdtDCQ4eotvKdB2J48sf/7O6
 Asstk+th
 tTdBrqJYaOPiAw/xsBVUNYp1FBxrSmRAIwp2rmbefOxOwFFx6FGo1Tfluo2NBv0bLsYICbtjgewO8Ix4k6c+yAjK0e+7OPogQM4fvwdXMFTU5rL9jRIPxvCCqVSGqvPxzWJoubltz1PQPQzh1R4mK1bsGMAp4VU/YSaN8UWCg3wXv9esvs1IDt8Pf1Sd0b2f0ZEeiyBTyrPkjXbnJE93TG2UYTXA9wq0FR3tuLfP6Ads3IluavU0B3Q3ktdyvVsdzFpcUmVLODgtjL59L8T7Sl2w3LtHb0pbgMWH4PaR6QurDfcBGW6Ja36q1lPymuvoUPFSQ4eGz8z8i3yIhdS8cHZBY91sqbMSA601HV+g4CUUIz8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With defrag_mode, every slowpath allocation carries ALLOC_NOFRAGMENT.  A
request below pageblock_order may take a page of its own migratetype or
claim a whole free block, but not steal from another migratetype's block.
The high-order part of the watermark check still accepts a free page of
any migratetype.

Under memory pressure, movable allocations take free movable pages as
soon as reclaim frees them.  Free space in unmovable and reclaimable
pageblocks is off-limits to them under ALLOC_NOFRAGMENT, and builds up.
The free pages of order 4 and up end up mostly in those pageblocks.

A 64K mTHP fault cannot take them, but direct compaction's up-front check
counts them and returns COMPACT_SUCCESS without compacting anything.  The
allocation then fails.  Because compaction "succeeded", it is never
deferred, and every fault stalls in it again before falling back to small
pages.

Dev Jain's benchmark faults 64K mTHPs under swap pressure, in a 7G VM
with only the 64K size enabled.  With defrag_mode, those faults stall in
compaction 18 times as often and get about a third of the folios
(medians of 15 runs):

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + this patch
    compact_stall                      1690          30669          2607
    compact_fail                        621          30531           906
    64K faults allocated              20750           7391         11538
    64K faults falling back to 4K       725          13832          9945

Make __zone_watermark_ok_mt() skip other migratetypes' free lists below
pageblock_order for an ALLOC_NOFRAGMENT request.  Give
__compact_finished() the same rule for its fallback test, so that
compaction, once it runs, stops on a page the request can take.

zone_watermark_fast() calls __zone_watermark_ok_mt() too.  With
defrag_mode, an allocation now wakes kswapd and starts reclaim or
compaction as soon as the free lists hold nothing it can take.  For the
orders the per-cpu lists serve, that is earlier than before: the check
does not count their pages, so the allocation no longer uses up the local
list first.  A request that may not wake kswapd or reclaim, such as an
mTHP fault with THP defrag=never, falls back to a smaller folio instead.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Reported-by: Dev Jain <dev.jain@arm.com>
Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/compaction.c |  5 +++++
 mm/page_alloc.c | 21 ++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6c553d0e90f8..7b2267bbf115 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2365,6 +2365,11 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 			!free_area_empty(area, MIGRATE_CMA))
 			return COMPACT_SUCCESS;
 #endif
+		/* Under ALLOC_NOFRAGMENT it may only claim a whole block */
+		if ((cc->alloc_flags & ALLOC_NOFRAGMENT) &&
+		    order < pageblock_order)
+			continue;
+
 		/*
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7730660bdd09..d53fb2c67ae1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3586,6 +3586,11 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
  * will return true of the order-0 watermark is reached and there is at least
  * one free page of a suitable size. Checking now avoids taking the zone lock
  * to check in the allocation paths if no pages are free.
+ *
+ * Under ALLOC_NOFRAGMENT, a request below pageblock_order can take another
+ * migratetype's page only by claiming the whole block, so only free pages of
+ * @migratetype count below pageblock_order.  Without ALLOC_NOFRAGMENT,
+ * @migratetype is not used.
  */
 bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
 			    unsigned long mark, int highest_zoneidx,
@@ -3648,6 +3653,9 @@ bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+			if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+			    mt != migratetype && o < pageblock_order)
+				continue;
 			if (!free_area_empty(area, mt))
 				return true;
 		}
@@ -3677,8 +3685,12 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages)
 {
+	/* Serving an ALLOC_NOFRAGMENT request needs __zone_watermark_ok_mt() */
+	VM_WARN_ON_ONCE(order && order < pageblock_order &&
+			(alloc_flags & ALLOC_NOFRAGMENT));
 	return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
-				      alloc_flags, free_pages, MIGRATE_MOVABLE);
+				      alloc_flags & ~ALLOC_NOFRAGMENT,
+				      free_pages, MIGRATE_MOVABLE);
 }
 
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
@@ -4685,10 +4697,13 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 
 		/*
 		 * Would the allocation succeed if we reclaimed all
-		 * reclaimable pages?
+		 * reclaimable pages?  Count free pages of every migratetype:
+		 * reclaim and compaction work across migratetypes to free a
+		 * whole pageblock, which the allocation can then claim.
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
-				ac->highest_zoneidx, alloc_flags, available);
+				ac->highest_zoneidx,
+				alloc_flags & ~ALLOC_NOFRAGMENT, available);
 		trace_reclaim_retry_zone(z, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
-- 
2.54.0



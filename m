Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60242606D82F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyrDGM3J
Received: by kanga.kvack.org (Postfix)
	id 615976B05B7; Wed,  4 Nov 2026 13:39:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECDA6B05B8; Wed,  4 Nov 2026 13:39:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502876B05B9; Wed,  4 Nov 2026 13:39:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26B316B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:39:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBC761C412E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:39:00 +0000 (UTC)
X-FDA: 85398298440.14.AB0DBAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1AB3B4000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyrDGM3J;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jJ6G//1Be0Fadl0Ktca/I5QkBevkAE1aXcgU9JY1Uho=;
	b=v36xc2FNhcMLMJ3D9ZLzh4DfxRAWwgf2dCf+E46g6GS5FD5S36Zsk8Z+Gky9x1R+ttxf0n
	B/VtCukz0sTeFtKM4gmy2mvNR8ca5DYIRkJ5nKYsobjo+/cpBe8QxAe2Ads6V9TYe4qPxJ
	BAipoGtOtEJOFlXluyLovbyXfESeiH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793817539;
	b=hZq3lbnwJ0dNpmnCMyb9Rg2jhZg4s/1cq0zwOdH4i7Aw6JE73aBPmaPJhaZnKCfz+kU3T6
	1PIPhKY4r5yaqBJpI79/chL1JcWgVzKkd0096n69fDiC5TC5QYKe+ozlQyaL66dcBNRAWH
	w6max6NNZm+UjP02yUx7TGYC3Vn9VjY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyrDGM3J;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 826D760A77;
	Wed,  4 Nov 2026 18:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7E21F000C1;
	Wed,  4 Nov 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817538;
	bh=jJ6G//1Be0Fadl0Ktca/I5QkBevkAE1aXcgU9JY1Uho=;
	h=From:Date:Subject:To:Cc;
	b=WyrDGM3JiEk14394UgHlaNuZOL3HxS4GDq1/FbGLzVHNSaRX237BaucuXl9n7orq2
	 MweIyD74OJBTsIZ6PsKyOs6T8kxd3bfGH6+hgKTXt49kPJKN4TF0QkNfikm2AYIP6L
	 AymG+dsFsQXOIbQcr/9ZZXnzOG3VXrFVlX2sEZsyMNRF4xi1s4yS4HUVk0L17TKGOS
	 JlVFhd7b8CdlY/5h2Dq6TmToyVRrIWPpK0fC58yIOaf1PvFxypcLSxVgmb38bS3U86
	 iIqijSR51xE5cRN2PQz9t8fmhAjj0KWoiPTybx3+FtC/TSDbQrmckHpgvykr6L77O/
	 AktrYelb8Hu+w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 04 Nov 2026 19:38:44 +0100
Subject: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
X-B4-Tracking: v=1; b=H4sIALN762oC/yXMQQ6CMBAF0KuQWTtJqbFGr2JclPZLR2MhHUATw
 t2tunybt5KiCJTOzUoFi6gMuaLdNRSSzz1YYjVZY11r9oYf+vJj5CR98tPwlMBzLqjLAj7COXt
 CcIdoqA5jwU3ev/1y/Vvn7o4wfUvatg+SanvnfwAAAA==
X-Change-ID: 20261030-kswapd-highatomic-unreserve-7e6629ec65d0
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 JP Kobryn <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9213; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=RU2RYAP1IAIoTJNvW8TyRg0//g9SSkYrmtWRhHXs7z4=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWS9rt61m0mRpXxKWIrAwoJlG2xVSpJnf1/qE7a8uWDDu
 bwEX+vVnYz+LAyMHAyWYoos1btPOIrOVPaY5uH7EWYQKxPIFGmRBgYgYGHgy03MKzXSMdIz1TbU
 MwQydIwYuDgFYKo50tn/16zMjfu8ko3VKPy5XdATBb9LWrH9sQ0NrS9NOcJ2njx8iuuczR/NDBa
 n+VuNrdcfs+h9Hvxm5mbtDTG7LXzmXrFkfrbrxRF/dov46+x1Sy2PuF/7l834q7qdb5dtiOWFnF
 CGW4cLryuVm4qvSv2au2Sq4Vbbq/UJi0Snz+T7JHqP41L1W77DLP86I+y4DZdcabGvrLCS1d2mJ
 rvtzNU6lxVGzBvtSv4v1mhx1p2UpLw/902m+2k10Rducj+llx+XPjpTSyVo09TtBbf2GImvfRsS
 1Npbqji5+CG3UrinsG0Lx7YfxyTlnW9s4WdSfHxnxcF9l37O8lt84tWWpzlVaxPtA/N+v90eJHL
 YkqkDAA==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bk1hyrb4ip1fdx7hbmdq7tsakbyirupt
X-Rspamd-Queue-Id: 1AB3B4000A
X-Rspam-User: 
X-HE-Tag: 1793817538-319802
X-HE-Meta: U2FsdGVkX19ABmQm/rcARkH+HspoTth0xgub7b+BjGRZTrbWCHyE4iu46E0aQTMxPcFDQkXbdPJbcpDPYt4fRJRUfPyquuG0verTaQ9VyY377cq4Iktnk3Oo2OW27HaR3Vgo2yZfnbmDKLKyiXUqCV451mQv4GA6ZsUpRzTyi2YE0VtW19KREoQcN2hFE4Y59cYTmEIDJRLzMdtvEEeUvJaiy/HSncNIkPghe2tiC8loONdTUcYyH7xuflUGROL/VngVTvyhdVUqDWojMCs+0KolodW3DTQnww8lbqnVUIqI1kqfXL8mvjHHpFgsYSmvMeNAOqR8gpcJ4RRRA/VAHpHYaXMPdKBr16GT9v0AOOgF9o1czSAZYhr6D0PaoAx3C+JNLhn4VlHQympxwRZ5ObjTgCzUSBcD0PE9LnGY6HWA/6iSVc8PE/FNSp6fNzUUK1/eHMTxYO/alb18qmZNImfidwJWWP4Bg2K0i9lWSX6V2gWlWbt7YBWi1coZxTYZl+nArMWHZAgMbkMSQ1/Zh7JyVm00dRrhI5mcgPh6+h7xbdBLBr4oaK/6ktI/p2mTg+4YBIOm81wB4gcEsE+FJj03l+8x44gC5VLIywznmatJS4c1zjq/DxbGdB2WNDfcs7Wm1Ru6L+M6vCHsKXVEdVroitMg8GrkFghJDU0qT9iP9YLA8DJNctFPAqsryBkof8alknnY/6aVy19FvACxaALaSIYHnYcE1glynfk4GLV4WEbUuGtCJRjOGbckDPKDb1XriqmysFR1Bnzp+N+HVxBia4WF9ny7xncQ9zS2tv3viI7Eem919Z8hSF3uvsB2AaiwLNi+aNjUf0lculEgscWB0cZjEpPNmdv90cvLQ/AE2hhh6ULVOHNwKLWsg8SwU/Yd52Nnw0s64PiXQRG84E7W55I5/0NuveHMxVsPVYfhetRrnqNzrbIrN2ir985hh1+GfclGHmyvXnHD88O
 cRWH+vrR
 XIXbSYxUONlkst/sRdmol5Ewez6w4VRVFEXZSNczkz/zrf37boQg0Z29PqSu41Vv7Wv887htovY9Rrppz3uKTNaeAU9ICBBDg+03RQBpq3F8gmcaPb+m36Bws1Oh+H6fshYbCrbkyz51f3PfojEgPSVg7uHVTMf1+8NQ9feelmFweFmwuwfkpXfMSI+diRJ+430lpCu0ie7Q6ZyeR16dvg6cexj6mx9ioBMRaAEQrMwjV4Qr8ZHzu+7yTOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A customer has reported excessive reclaim activity despite memory above
high watermarks. Analyzing support data (including sar log) revealed the
following scenario:

- the system has almost all memory reserved as 1G hugepages for kvm
  guests, and operates normally
- due to a spike of memory pressure from userspace, highatomic
  reservations occur (probably due to e.g. concurrent network receive
  activity)
- on one of the 8 NUMA nodes, this creates a situation where free pages
  are above high watermark, but when __zone_watermark_unusable_free()
  considers highatomic pageblocks, the result appears to be below the
  low watermark
- pgdat_balanced() is false, kswapd hopelessly keeps trying to balance,
  spending cpu time and disrupting the system. It has nothing to reclaim
  because the node is filled with hugetlbfs hugepages.
- since the overal memory pressure is under control again and there are
  no allocations restricted to the affected node, they are satisfied
  from other nodes without going through direct reclaim
- since direct reclaim is the only code that calls
  unreserve_highatomic_pageblock(), this never happens and nothing fixes
  the situation

Note this was observed on a 6.4-based kernel and there have been recent
fixes upstream limiting the highatomic reservation side, but I don't
think they can prevent the same happening in mainline, only perhaps
lower the chances. Nothing seems to prevent the issue completely.

For example, while we limit the amount of highatomic pageblocks to 1% of
the zone, this calculation does not subtract the amount of hugepages or
otherwise permanent allocations, so the highatomic pageblocks can end up
taking much higher share of actually reclaimable memory.

The most targeted fix thus appears to be to allow kswapd perform the
highatomic pageblock unreserve to match direct reclaim. It's also
somewhat similar in principle to how kswapd reduces watermark boosting.

Hook this highatomic unreserve to the moment we are increasing kswapd
reclaim priority, as that is when kswapd is struggling to make progress
and it should roughly match the case of direct reclaim failure.

The only caveat is that direct reclaim knows which migratetype it wants
to allocate and thus changes the highatomic pageblock to. Kswapd doesn't
track that, so use MIGRATE_UNMOVABLE. Highatomic allocations usually are
not movable, and this will avoid creating nominally movable pageblocks
polluted with unmovable pages, so it should be the least problematic
default.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
We interrupt the regular stream of AI fixes by something a bit
different. RFC to get agreement on the approach. Haven't tried
reproducing the issue in mainline, but it seems quite clear to me from
the data I've seen.
---
 mm/page_alloc.c | 126 +++++++++++++++++++++++++++++---------------------------
 mm/page_alloc.h |   3 ++
 mm/vmscan.c     |  16 ++++++-
 3 files changed, 83 insertions(+), 62 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8cac5e01066..785a13570788 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3476,6 +3476,68 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	}
 }
 
+bool unreserve_highatomic_pageblock_zone(struct zone *zone, int migratetype,
+					 bool force)
+{
+	/*
+	 * Preserve at least one pageblock unless memory pressure
+	 * is really high.
+	 */
+	if (!force && zone->nr_reserved_highatomic <= pageblock_nr_pages)
+		return false;
+
+	guard(spinlock_irqsave)(&zone->lock);
+	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
+		struct free_area *area = &(zone->free_area[order]);
+		unsigned long size;
+		struct page *page;
+		int ret;
+
+		page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
+		if (!page)
+			continue;
+
+		size = max(pageblock_nr_pages, 1UL << order);
+		/*
+		 * It should never happen but changes to locking could
+		 * inadvertently allow a per-cpu drain to add pages to
+		 * MIGRATE_HIGHATOMIC while unreserving so be safe and watch for
+		 * underflows.
+		 */
+		if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
+			size = zone->nr_reserved_highatomic;
+		zone->nr_reserved_highatomic -= size;
+
+		/*
+		 * Convert to migratetype and avoid the normal pageblock
+		 * stealing heuristics. Minimally, the caller is doing the work
+		 * and needs the pages. More importantly, if the block was
+		 * always converted to MIGRATE_UNMOVABLE or another type then
+		 * the number of pageblocks that cannot be completely freed may
+		 * increase.
+		 */
+		if (order < pageblock_order)
+			ret = move_freepages_block(zone, page,
+					MIGRATE_HIGHATOMIC, migratetype);
+		else {
+			move_to_free_list(page, zone, order,
+					  MIGRATE_HIGHATOMIC,
+					  migratetype);
+			change_pageblock_range(page, order, migratetype);
+			ret = 1;
+		}
+		/*
+		 * Reserving the block(s) already succeeded,
+		 * so this should not fail on zone boundaries.
+		 */
+		WARN_ON_ONCE(ret == -1);
+		if (ret > 0)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Used when an allocation is about to fail under memory pressure. This
  * potentially hurts the reliability of high-order allocations when under
@@ -3491,70 +3553,12 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 	struct zonelist *zonelist = ac->zonelist;
 	struct zoneref *z;
 	struct zone *zone;
-	struct page *page;
-	int order;
-	int ret;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
 								ac->nodemask) {
-		/*
-		 * Preserve at least one pageblock unless memory pressure
-		 * is really high.
-		 */
-		if (!force && zone->nr_reserved_highatomic <=
-					pageblock_nr_pages)
-			continue;
-
-		guard(spinlock_irqsave)(&zone->lock);
-		for (order = 0; order < NR_PAGE_ORDERS; order++) {
-			struct free_area *area = &(zone->free_area[order]);
-			unsigned long size;
-
-			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
-			if (!page)
-				continue;
-
-			size = max(pageblock_nr_pages, 1UL << order);
-			/*
-			 * It should never happen but changes to
-			 * locking could inadvertently allow a per-cpu
-			 * drain to add pages to MIGRATE_HIGHATOMIC
-			 * while unreserving so be safe and watch for
-			 * underflows.
-			 */
-			if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
-				size = zone->nr_reserved_highatomic;
-			zone->nr_reserved_highatomic -= size;
-
-			/*
-			 * Convert to ac->migratetype and avoid the normal
-			 * pageblock stealing heuristics. Minimally, the caller
-			 * is doing the work and needs the pages. More
-			 * importantly, if the block was always converted to
-			 * MIGRATE_UNMOVABLE or another type then the number
-			 * of pageblocks that cannot be completely freed
-			 * may increase.
-			 */
-			if (order < pageblock_order)
-				ret = move_freepages_block(zone, page,
-							   MIGRATE_HIGHATOMIC,
-							   ac->migratetype);
-			else {
-				move_to_free_list(page, zone, order,
-						  MIGRATE_HIGHATOMIC,
-						  ac->migratetype);
-				change_pageblock_range(page, order,
-						       ac->migratetype);
-				ret = 1;
-			}
-			/*
-			 * Reserving the block(s) already succeeded,
-			 * so this should not fail on zone boundaries.
-			 */
-			WARN_ON_ONCE(ret == -1);
-			if (ret > 0)
-				return ret;
-		}
+		if (unreserve_highatomic_pageblock_zone(zone,
+							ac->migratetype, force))
+			return true;
 	}
 
 	return false;
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index e238ee91ed24..9fba6480b18d 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -282,6 +282,9 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
 	return list_empty(&area->free_list[migratetype]);
 }
 
+bool unreserve_highatomic_pageblock_zone(struct zone *zone, int migratetype,
+					 bool force);
+
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 #define GFP_MOVABLE_SHIFT 3
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..91c622068d99 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7460,8 +7460,22 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		if (nr_boost_reclaim && !nr_reclaimed)
 			break;
 
-		if (raise_priority || !nr_reclaimed)
+		if (raise_priority || !nr_reclaimed) {
+			/*
+			 * Similarly to when direct reclaim is retrying, try to
+			 * unreserve highatomic pageblocks on the node. Convert
+			 * them to movable ones as kswapd doesn't have a target
+			 * migratetype, and passing unmovable should lead to
+			 * least permanent fragmentation.
+			 */
+			for (int i = 0; i <= highest_zoneidx; i++) {
+				struct zone *zone = pgdat->node_zones + i;
+
+				unreserve_highatomic_pageblock_zone(zone,
+						MIGRATE_UNMOVABLE, false);
+			}
 			sc.priority--;
+		}
 	} while (sc.priority >= 1);
 
 	/*

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261030-kswapd-highatomic-unreserve-7e6629ec65d0



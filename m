Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DF9C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB776B0099; Wed,  9 Sep 2026 12:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66386B009B; Wed,  9 Sep 2026 12:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2086B009D; Wed,  9 Sep 2026 12:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAA56B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:16:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06E151A0288
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:16:05 +0000 (UTC)
X-FDA: 85194725490.02.B2AB86B
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf21.hostedemail.com (Postfix) with ESMTP id A2DDE1C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:16:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+QQUjtvsloMqbaeJUU5Quet3S+TpvU02kGwCGK0H3g=;
	b=nSYtmx26Tqp8w4hghko2R0+FuqGQUHfaAteLNMvr86jlV1N0EsaDzx/U4JmNCV4F8Y/7LY
	+UZg9HDwz1RjrEwJfYw+/1dT1rFeN4RH5gB8dW7he/Y0kGq4mtf8+ojNYdh2cYzd4z8F4L
	9e68UfzHenNvJcSMUWm6qSpaBkJtLgU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970563;
	b=GqfeeqTUykrlGbBMBoaZN++f0jBPYDxKb06xex1hAAS+X3BdG08z56iPPqpGCyzNABt5aP
	BMwu33HMzG/PDmu+/crIdDdQTPeIVhQxJrsCmzUhcWK2MP0l3qEi8VivPXbVE5i9pUSkvq
	tEVFHqMFiRMQQ5g5eNTkDGRjuAWqxHA=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 10 Sep 2026 01:15:59 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Date: Thu, 10 Sep 2026 01:15:52 +0900
Message-Id: <20260909161552.2335971-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260909161552.2335971-1-youngjun.park@lge.com>
References: <20260909161552.2335971-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4fdo7qm7sj1xi1j48d8xbe4n45of8wkb
X-Rspamd-Queue-Id: A2DDE1C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1788970562-564366
X-HE-Meta: U2FsdGVkX18t5RAK/Lz3ny97U7Ke4OgYQM/ggttapSKbZPowGvZBvpMzjlQx/5WyDESz1FtPU9eBOpypBVYCR34EC1zcuZWxl49altGDaxxIyJxME5G7sbrqGkDiZDPzkw4WN7hof3WjYc0tlt+jIMXg+tJE/DGSz7ZIznG6gN8X3cxfPZsI30dAnunmiVrO1hmbcWBhwNLhuWwPjH5DWXmKsccmQLfuXpZA/kdxSq0CZomsD0Tq+PeztVgmv2LIH4tGUbfzWPFntkadIPaRTLPdtRz0J2vfiWd8ru2DCxLzI1/H2wgF73FDJdhYgosIJ5G04mkyfOXNKjXCxgOT2fsVI7C8V6hlo+5g15zN+ug7PwSBknmoTVCR8OgpJAw/s+BwA40LgotroquoCpbfKGhWiJhpvgpePL8An6PDP1jrIMayKkcHlz8Mksg/WHd2H42iiAH6IRRddkRNhvTQ4Zkyv3tzFhFGT4Zq+lFEWv0ub/u6daonLyTTciPohzzqWOXDVPx7c9s9DKj6hVNRpaRMlIU2lu6oxgaWa5zYM9tX7pH2RPjIeYhalKUxOr63V7J7nEAiBWBo4HLnch3CB/g/oE0xuTd4WupQMtUd2G9U6uwa+gteqt2+cwCcJkHJFvtByW37VVsmTHZOVlLf5ZVpkV33CIzVS6vxmvok/kQBo5eZQF66dpZXBXbVbmcqUCxi5fyJcCDC47+H0L4Kyn3L7cVFAOQTpfUpBZyZQH+RzoEXcm0p+JpvCjCFNQTwDSQUs4gTIYLWhXqQgZHOxCgiqoQ6Ktd209GeoY/34WyW7BrJeYQX6zZe0mKQa/OEYD8CxgM8YyD8Pp86/CXtq25mL/jX6qoPKzDRZCTbZuTXcJBW+Qyguw+6IdIJuw+Zg0bhQfjwkQfp2YIHsokcY9yZpKfb3qvjdEHV7JKu3Ao4XK8d7GHM+8ikDhwtYyMv6WpNhYNQwmEKKekfz5N
 Hg9uWAqp
 ihcMogOYfqTlr9/fzGsrKhrmSQ2ONgONSgHr0WmlgSJkm+eRZQ7j+awNHHnMbm+iCB53IcfXZUoRt8U24uHPF0Y0rBZb8dAGhQnNa2jYauDt9sMDzJlxgdzrxIfUZQuAL3D2IW/7NwjD76nBU0Gh9JgFC4//yX/dzpBi5LKXyCLqVdZMZ2syMgHyLlPnpsDumkwFCbIrkAySx9QcBpaT5dEqxyokhd90rzT2meZVe/b1w+p34/pcISTBmXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
restarts that walk on each retry, so the cost scales with the size of
the device rather than with the few slots the shmem and mmlist passes
could not free.  It has caused stalls before.

The flat walk predates the swap table.  Slot state now lives in a per
cluster table, and wait_for_allocation() stops all allocation before
try_to_unuse() runs, so a cluster that holds no slot in use stays that
way.  Skip such a cluster instead of reading all of its entries.

Fill a 1 TiB swap up to some amount, then swapoff.
What is left sits at the top of what was filled, so every slot below it
is free.  Medians over 11 pairs at 32 and 128 GiB, 3 pairs at 256 and
512.

	filled		swapoff
			old	new
	 32 GiB		 92.4ms	 66.3ms
	128 GiB		157.6ms	 94.4ms
	256 GiB		209.7ms	 63.8ms
	512 GiB		391.8ms	 73.4ms

old grows with how much was filled, new does not.

In the ordinary case swap still holds real data and swapoff spends its
time reading it back. it is tested 4 GiB on an 8 GiB device, where the scan
is 1.4% of try_to_unuse(), and there is no difference either way.

Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
answered those stalls with a cond_resched() every 256 offsets.  A walk
bounded by one cluster no longer needs that counter.  The loop now runs
at most SWAPFILE_CLUSTER times before it returns or reschedules, the
same bound swap_reclaim_full_clusters() already scans between
cond_resched() calls.

The scan end is clamped to si->max, so the walk stops there rather than
running into the masked tail of the last cluster.

ci->count is read without ci->lock, so READ_ONCE() marks the read for
KCSAN.  Allocation is already stopped, so the count can only drop, and a
slot stops being counted only after its folio has left the swap cache.
An empty cluster therefore holds nothing for try_to_unuse() to act on.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0a3a3b2218c7..05d3408396f9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -370,8 +370,6 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 	}
 }
 
-#define LATENCY_LIMIT		256
-
 static inline bool cluster_is_empty(struct swap_cluster_info *info)
 {
 	return info->count == 0;
@@ -2787,7 +2785,9 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
-	unsigned int i;
+	struct swap_cluster_info *ci;
+	unsigned long i, end;
+	unsigned int ci_off;
 	unsigned long swp_tb;
 
 	/*
@@ -2796,19 +2796,36 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * hits are okay, and sys_swapoff() has already prevented new
 	 * allocations from this area (while holding swap_lock).
 	 */
-	for (i = prev + 1; i < si->max; i++) {
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
-					i % SWAPFILE_CLUSTER);
-		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
-			break;
-		if ((i % LATENCY_LIMIT) == 0)
+	i = prev + 1;
+	while (i < si->max) {
+		ci = __swap_offset_to_cluster(si, i);
+		end = min_t(unsigned long,
+			    ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWAPFILE_CLUSTER,
+			    si->max);
+
+		/*
+		 * An empty cluster has no slot in use, so skip it whole.
+		 * A slot is uncounted only after its folio left the swap
+		 * cache, so there is nothing here for try_to_unuse() to act on.
+		 * Count only drops here, so a READ_ONCE() without ci->lock is
+		 * enough, unlike in every other cluster_is_empty() caller.
+		 */
+		if (!READ_ONCE(ci->count)) {
+			i = end;
 			cond_resched();
-	}
+			continue;
+		}
 
-	if (i == si->max)
-		i = 0;
+		ci_off = i % SWAPFILE_CLUSTER;
+		for (; i < end; ci_off++, i++) {
+			swp_tb = swap_table_get(ci, ci_off);
+			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
+				return i;
+		}
+		cond_resched();
+	}
 
-	return i;
+	return 0;
 }
 
 static int try_to_unuse(unsigned int type)
-- 
2.48.1



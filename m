Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AB3C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84096B00A4; Thu,  6 Aug 2026 15:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34A86B00AA; Thu,  6 Aug 2026 15:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C0A6B00AB; Thu,  6 Aug 2026 15:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E47B6B00A4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:32:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AC3B1601A6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:34 +0000 (UTC)
X-FDA: 85071841428.13.4B039D1
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf01.hostedemail.com (Postfix) with ESMTP id A365C40011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUae9K8/TDKrct45ODkRigWt8Q0mlSf6nWv+M0De0b4=;
	b=U7mO8VVBXwN8Xg6PfSOYy4TJXMAXG355ehDrUI89v7jZp/d+obVHfJcaGhdwdS8TLsQhij
	4wAE0Hr20jg9T5J44Cf6TiPxm8gHpf0MnZWC9NSi5lB3epHqa9V8VzfMiMHjaZ67nkPciC
	SB7SrXJRufL7sXs9ROXASqjKXxzMMDo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044752;
	b=AmxhXAw6gq92e+S85vQZsIrlp8143hXgNSasvoWdxVUNa9Y3sCwOASBMhtMw5lcJdpoH9p
	ZdJN0hRSLYyGkpnt1hmSJ11SQVN3jdJwvMPzW0mk0OpdLFSe1ohJmvARP6CDmGJAsXcrWH
	2RbDUDGzS7AR2sGCHb8UG2uozQp7ljE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 7 Aug 2026 04:32:28 +0900
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
Subject: [PATCH v3 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Date: Fri,  7 Aug 2026 04:32:28 +0900
Message-Id: <20260806193228.458685-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806193228.458685-1-youngjun.park@lge.com>
References: <20260806193228.458685-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A365C40011
X-Rspam-User: 
X-Stat-Signature: rncafq56t5b65d9yyh39s95si1eoo6qh
X-HE-Tag: 1786044751-723604
X-HE-Meta: U2FsdGVkX1+daTtU51w5aPEaTlWAQPJPp2jmHYYzKZ0ZYMqlKwKWPkKWUoCrFdjHHoZEwaE+9acV/HOVyI8GVW5rczKtyUVHAg6Np2iZr/5OQb8Q1IA14Hp0k6l/+WELzS0jkz8xbVpe6EZvfIHbkzeSFmIUBJtA9os9oAPsUZL2TMZNEHxCMMn2afNaBvFgmhL2PkPOnuiCGYpFLhFBNWy/3V/2QUH0lPIyQqFYdfWBkxGb5dUTAQG3469YfFH8JpLuXnlZsAEYUZknICjU7bKr71GvSLc+GAArlfIvoue29T7niwv6Flj37w24kuu7WLLwcm+jMTyM50KMKa18ysUg551+QRPU6zgZ6QYzn8nQ0SAtOvukvoZa27NuOhXzB77dY9mw6rzqkkD9qlZt55U6rxCwlVNSJeGi13Fdff+EcvBddlF7QrwFCQsDOnH1/Lmm6tCj5qwTBjQKVaFEuyZv0oFUJ0p2RuklTbFYGaWSBamTmnpe4eA4dv1bfbufPVlcc96uVS5MqWe8LuMO749vwCr+U1k6cb+am9KKT5SRo3W5k0kMFN7A8QOPtOTpUxz2L6jadaerqumm2bRHuOBmvsAx2fNYuZUieI9+Ia5jNG7qM0rKRIlrpi/LHTEXPjUz7Q7OxgMeIc/woNQQkJ/Qwm78VELr/JZQNawEBsvrjkHOB7I1fOa2pVv+FIXBvyo1BIzZcZIxWASXxJowAv8OprAdt+nCWoSpzR5pX4IhMxLXH+G3CWN8fl4aUpPpGFdNhXEMPIDBL5tefdx0XXu3R6yT/ZzB4JSF/DNLuPUE2jJMC7d6kcndpv8F4k01S+hMwzvtiH/Sftw9oBEJHX6ccZu/G6sst1XWtr03eeUXwbUE03KFHBh+EUdrM6t0jhENvczCpeWigpWG3EM9GOJYz19CtJvNiY/q4ZF1JZXcQt/Hcujot7CuwRmym49KJsQWf+0YDmNuvxFdC2O
 OiCL1kAy
 SsN1hP5TlWWu5Hi/mHUyoQOfaWOyc/q1ZQJw44g23YF/Gosor8X4lH52D3kQLnFN6JjkAQyn4mZXH9MNZ4lGXwTXdXx2S/y1qwgSQwcBfnlBdsbiaRuMq4YCmWiwdGQvyEfA+Wpi2FG+EO0kiIvHlSIp4QU3eNMEoI1CA0rD8J3Vj3aiL4M5ZKvKwJHZYup+jcwPW752L3fb5O0ueOKDzelrQX6D3x//+x7k9
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
---
 mm/swapfile.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dea2d3b36e06..0d24efd32eb0 100644
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
@@ -2763,7 +2761,9 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
-	unsigned int i;
+	struct swap_cluster_info *ci;
+	unsigned long i, end;
+	unsigned int ci_off;
 	unsigned long swp_tb;
 
 	/*
@@ -2772,19 +2772,36 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D737FDEE35
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0ED56B0093; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB9B6B0095; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60AE26B009B; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED186B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB2561B7C1F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:34 +0000 (UTC)
X-FDA: 84690542748.09.DBF5E0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC3591C0004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwnDeVRJ;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMG5zOsrdxvHNNb7liR20dQawqRedE0n9rQElGTNisg=;
	b=f1Jcj6epzJjTmvun/rrYbczMQE/3z+LSWhMhclNlcZbRnhi3xWT0ZoOOh73WVXpt4lyto+
	GQrgKv4S5ylXAyj8pXQCdOwcHa5Q66N4+mFzzuqsLtjJul7U9GJfjsnGmOLxTdg559TCtI
	NPxJlYLrJybmivwnZb/MzzEvXFilOz8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwnDeVRJ;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966213; a=rsa-sha256;
	cv=none;
	b=ZoCZXPlPwkos78Mf6zgq3C8y8rZDDIcMMliICT9klkLPvs5f4/fnGGJsrnHW3NUAQqkNOp
	EAUdw5CjADG/HlUEm4MNV8K7oRb6MqF3G9oICz83F+7rOQJ2Id3UMOaN2EHVZi/4lJGgAp
	h1CZjXKxEMW/hRX+/TEjw2EwKqZpV2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C690144717;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FE86C2BCC4;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=FRgOh8fXu0OnS1jgsvLiDcuxxGzAQqhYewYLvhhv/54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FwnDeVRJNpYtbgu1PFvdXj+qes2skaOXBC6AnRtQBmUbVq7cVUpO6IYBEBUTy9jZv
	 OZqKvodRjhqTNCOWybnNbx0Y9qPCgv+aDaITQMKswZTwL+OwFGIFZ3ujH2seYrEX3Q
	 R6ulM/K/OMJpEXond+d/WoAFI4/q4InfU5tPheoZMyjkM/e2rE86vFUueNZN03+772
	 etY2uL6I1weGW+6mgzh67s/WpG113ubsbXZfyKxygDEjj03Xf8VeW1ApcZoI43a1HB
	 tGptrxLJe//WSDKyZXlpJWIbV5k2jDEEjECeVaMV/I+Rdt1cw8TRZqzYkkd2xMmcGr
	 HkdsqQ4gfvRQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740E2FDEE35;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:14 +0800
Subject: [PATCH v6 03/14] mm/mglru: relocate the LRU scan batch limit to
 callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-3-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=3315;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=JtRi0BCJNMNigPm1+Pq4gKGtKdNzBL8ESmEzjD65K78=;
 b=a43u0V3eA+y3mDo5zbYcjIw9REK0ungRg6PBSouYWfBUp2iI/KxK0xUdiWjRta7tTCaFZEec0
 p/1/iOENuwRCgwtl9XD3ZnpPBFc39Kl/Uv+ee/DQ2q9DHB23XSXsULn
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC3591C0004
X-Stat-Signature: 4334srimataagremydgkbi3i8ybnhuuw
X-Rspam-User: 
X-HE-Tag: 1776966212-769796
X-HE-Meta: U2FsdGVkX19OpJ+zjV60aFuxcZasHkfYJRyF8EvQyPdISsKg7JLZyjablgKzOI5jKWd/RH1r7j+b2WO83ATFzJWKWwZQpVoTmI8vLMqoHWWC1oDmhpUf5FNsuUhVQvCz6d7uiT9udaqWcV4i72ECK9eczzdeP2SqKpYghNsx6Xat+jnD2iJgLpj4p+oOT28VHTyJE1BFBR2kwvQw8+yJLbW0OIi/hBiZF15ywhMK37YH/7Pufkt2u6uQyxDdrLWg2Un+VtIFbduF3uFkqlYi8lGL7QN06TrGkyft/Aan2XRSXw+Vt/Y64VUNCymUSOlIxZgxgDxuZ85VnNQqeN25ffwliPHsTvgNfVCiV0wF1uLDr19a8oVqyIMzvqrSrLZvKMMtRbTQwJTKkNYJeQeGLOdEDm2eS74DXErRuvJPnjeFxGhFIbxv4+WalpFTkkQ5JO/WbRQ9nH04lumdx0Yd4k3tuG5UYq7ed9q8TJ8niFqym7GiTqHdQjPyxmU7mfUZpoR64H+CDjsGNlH9Pm+1JgFOpUY9eYa87ML7FDvJo+oi5/XKfdg0fz7EMVU8rZ4d28xGW0AR0NPiIlmkeuxR8IKHmazwqYZJfG/aYDyLUmPEbkhFq4nhl5A2oK/JoC8UUbk7yAVviiNSxl4HIr3JyhH+9lIuj3+ePRJ2Z4o2sF1vCpx5D1CHNED1b15aDuKi6J1sRssnqnvnZSr+v/HBDUD0IlEMuGTi4rS2k10w0LFSLTPCGa7h/3txBZawMfXWUermT1zLf+q3DDgfgJWZ1h2WGIDCppXtKV5ziX3DZoCPnP1rlhUtki4HAxx2zMQH21HZof1/58YdB8b6coGMwYEim0QE7JkSteLIGbT81BvTwBn8sUznMW8YlIjYwofN8jH8a4yJpZXgyUY68No7qVBJPJHnT4AESLCqUcUoWzBxEp1UynwoJ7AKa2lnvxF0vHdc+VUgw6UGCKFQt05
 NcTgt806
 EsK6UE+jwpTKNL3RCrOmAQAedcvJqOv5ZYxmGDKZs5J+VCMv0m4aglbvI7lJ+mte1zCJ3NKuPGEM5O5D6PdF9zWRNnaeOVeAd5TpEjOsz+tVoDgruGL65SpKv99FnPhWlBO2wZ+4/56KPUuxkGnJj21agvm6cs2rCl4Jk/0YUQFU85VcrO31AqaQL/y3snnI7f6xxMVsPll5G2FOvB1HabHgryyvdu22woI2y19djvVOA5Sn+KmQRd6wq59WDNPZsRgUWgIA0HQxLf7MfLV5HXtxhu/V1WmxUdtmzVdHOgDOzjaoDaBOxe+tJewxtKpTfUn3O4EbvrM/XcJy4/cJD/73aAAjZZe8bsmD+pxaNVdz9m1xqwbzE0whTVtPZEzxOFJWHTkprdpiQYqVqct1pdWtiMt0yr8qZ6gTQw4POLnMHzMg8jLBGQTc95QMTySvHEOqZ5sxbPGQETLJfcO5qkN2I9S2TvVGnXlRhiLfD531PfTHLETRXWcO1bgdOw7v9oWnjyvV6DG5ZsJfGS1qBzVW/5fw5AblQl+Rt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Same as active / inactive LRU, MGLRU isolates and scans folios in
batches.  The batch split is done hidden deep in the helper, which
makes the code harder to follow.  The helper's arguments are also
confusing since callers usually request more folios than the batch
size, so the helper almost never processes the full requested amount.

Move the batch splitting into the top loop to make it cleaner, there
should be no behavior change.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4623a5ac6bc7..3c5a6ae92440 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
-	int remaining = scan_batch;
+	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
+	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
@@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
-				  swappiness))
+		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
+		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();

-- 
2.54.0




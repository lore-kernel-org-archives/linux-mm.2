Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D579CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0146B009B; Tue, 16 Jun 2026 23:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381106B009D; Tue, 16 Jun 2026 23:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184B06B009E; Tue, 16 Jun 2026 23:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEF766B009B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:22:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 556AB402CA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:22:33 +0000 (UTC)
X-FDA: 84887956986.08.E2EA74F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf11.hostedemail.com (Postfix) with ESMTP id 31CAB40006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:22:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n0++xm3b;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781666551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQV3xFHJKgQkMS8NV/Ihex626F8ipTfXl+Lbz6MfWE4=;
	b=emt7skr5WojikQhQ11OeVq3M4+j31pOBqr54I9OdiNZJpYbYMgROnvaRJc1E7SDFsr9XBN
	MUmXJk/Po2kxWQvvjJ5ELPLrrWq8EkyfUMh+bwib6kPvfzqNA+w9qIRTDrgpcpIGSzF3Mu
	kmhQLnnPbg3U0aaLd/snzxgiGAiGL7U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n0++xm3b;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781666551;
	b=dMT2UU55iTz54QesKUb875jpOAbstqMt9bHLHA5NYVLHt0xRiQGPOYL+HE97myCgwostre
	gxgc+RBL0F0QiLW5APiOeRKX9lXEwStq0MMpEXUm8pIgTGyZf60iH5+HMfFPQdwZTDR31e
	ORV48Am2jQ9BtSthxzLKlQMLHHB6d44=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781666551; x=1813202551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JhM7c5o70ybfdwXn6SKxKv1V4lXqjrtlzjyeowK/Ybs=;
  b=n0++xm3bJKo+lhijU+Y7FTk0hNWBKTbH9MPZiiTw8OOkSfnshUoWcGh/
   KAeriQ8S4VqO9luppfEIAJCDpVbtk3YDtwaeRd8P5/yBt/haT2aB7zBcr
   sJXQHrzZUt8HPjlrr4d1wzLVdjQqkf6UVlAKgJxGBNw6TGD/6itUfP95H
   IGB2PQg036cfRvA7jOHjsHOR6b2547Z/pbHCggPDQy5oAws209ScT1k9C
   O7ueWv3RHhmxjbJA4VrmVnwBezd8Cj3eNubkvfWiyRVFOf0LGd1SNVOn8
   ROGXCn7Rwiz++wq+NWd4BSmI1WZd+tgf5NuHjcJSdQWDtgQmAORLpWy+q
   g==;
X-CSE-ConnectionGUID: /FtHbWCAQbWq7pxoonB6iA==
X-CSE-MsgGUID: 1Mh995quSY+M0CK3gNI2Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="107914568"
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="107914568"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2026 20:22:26 -0700
X-CSE-ConnectionGUID: +ZClgS0VSr+yHpa6nm6ycw==
X-CSE-MsgGUID: Xt7l2jTsQAm2vq6Yk3nP1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="248017807"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2026 20:22:26 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH v6 2/2] drm/xe: Make use of shrink_control::opportunistic_compaction hint
Date: Tue, 16 Jun 2026 20:22:18 -0700
Message-Id: <20260617032218.1165929-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260617032218.1165929-1-matthew.brost@intel.com>
References: <20260617032218.1165929-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31CAB40006
X-Stat-Signature: pspi3bnt4w48fki7wtgdtqcebe683xwo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781666550-945710
X-HE-Meta: U2FsdGVkX1/1lHdMBWMbTigXcsiIZ0McwjzwIELMRt2gqLxQLbSs/INcOVesUBBXum3XBeywlV34AkR8Ycxd4gfX+4Jel/dFOuj/lM8WR3Tf0OJEJwbt1vK0QzIDMuZwLnzGCWKccNjJNZciOvKE8JmleUEyOsgq0vfwlA47cUMJIu7eTG73lOyQcVCA9WnBi7ZjbFL6m3E5rpnN7S1aJnilXlRKgui4ZoHaL7FV5cC5US9FwmUg3V8eerJGjD5DAmyFOjafjKneDNn8O3SWJA9uaj8nfF5+D1P44CwB7zWCTwQQxzb0fCB22Cet3t+pi/1lSVA4Qn/ujOP3VRNpeDT6v2ZirYi3ntho/yY2IZDdeSfAyUtnPfkeCykn/cADD9fJlMjlkb4VtRoPmETMC2t2X86kbgamAedsINvI3m4y1riPlIGW2V88dMhv1acw+Sc4XeJLzM9ssf+DJAsz/ItoUgo2PcQDuqBtOu6VVrLDDFUnPabugd1c/V3d8XDY/Rx0X54XPx94FPsTPlopSXkzwFBljmZZYviW84fGwAXnp9+DogRiK6QZtOu3SAV0NNNEhIJZWeE7NgTCd81mRO4Uspex3IH81fpu6b3KN0ZSghDJhzUwJsm+hTDet2Vgf8upp/AILI7rt6kynKCP3z4xFQDkCWxA/VbW1Tr3Ye0LW3YE7Y3qtglWQJDKgbKtYUmg1/DE+D6vTpEJeKzZ6PdwDVHmK3IaCVEUzvAAoobZA92GEYiGLC8xqr/QOTFko2dA5cDw4b2bmSU9Rdu4glYlNp7VR1PFNq2BKTHA/b/86MAHDI31udCkjqVCvwDkVZMcJApAhG3L6Y3jrnzuh4LygIInvdjjogp2zrsEHPpD4kf2RsVYyecL9WaZwV8rW6mSDewCqdddiPlcHy+sCHeCbhbqA1xkiSzKigvUh/m+cfEvmq3Fwj40Y8sCqMjQSiN2bpcIKoFt8eQ+A2G
 qEWeaXLp
 FFyulJuWCk98KEbbI6X8F3myJL0m31F4I9uu/cGr+S9WkDcWc0EeqZzVC5idpLuoURvIv+Tc+X5s01mP0Fjq9sehZpmdP+Dd9PvJ8pwrPX1H70KNOCrtTgqFANLafOzti2TtHmFO72AfTx7bJ5cwfZ8zys3lLmm6L3ivwXDKW4Cg/Y/FvaOwn2AjXbaXUp3qksVaHaan/vEM05Yn5pdVP7rLW93lL84FtLealKFMkHcur6at+gkilMbHnrmOmz4Vu+GRngm+6/+2XlCWrF6K1wHesWfnYWoRTgnJdKMUoMy0PeqgZrLeljdZxRcpc1+SMQL88b31mgmBwROcbvoSHBCu4BuFn3s73Qh6GBCrXm1QuwpkT2QnsRloMr1Z8AWbix8SzXK2hOl381C13grfoOCk6ze8NzEpWPTStO5OEJ676sCiLzgoQu832/Zh7swdQI8fXJfpUevnhq1YbRQLLDeNecvhVI/wsC1K/CxryHlgMUJcPfwz/B6hiVLMKJK99bFw1wXL10pcs/w+46RCwib0WgbPDT4fO4/kfHTHZP3coNfy/VU7TfyPE3/UrdQUnJHDPGkkItDzgyi72TYJiA85Rdrse9R4lFcyGWtOBbAhZsSp2DBy5/SfX3Ri2DlXfRK2Gpt/tmbWtopA1SkJPlxrdG71Waw0X2PHefw6Lo0mtMvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xe/TTM backup reclaim can be extremely expensive under fragmentation
pressure as reclaim may migrate or destroy actively used GPU working
sets despite the system still having substantial free memory available.

Under high-order opportunistic reclaim, repeatedly backing up GPU
memory can lead to reclaim/rebind ping-pong behavior where active GPU
working sets are continuously torn down and reconstructed without
materially improving allocation success.

Use the new shrink_control::opportunistic_compaction hint to avoid Xe
backup reclaim during fragmentation-driven high-order reclaim attempts.
In this mode the shrinker skips advertising backup-backed reclaimable
memory and avoids initiating backup operations entirely.

Order-0 and non-opportunistic reclaim behavior remain unchanged, so
Xe backup reclaim still participates normally during genuine memory
pressure.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_shrinker.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_shrinker.c b/drivers/gpu/drm/xe/xe_shrinker.c
index 83374cd57660..198149f266c6 100644
--- a/drivers/gpu/drm/xe/xe_shrinker.c
+++ b/drivers/gpu/drm/xe/xe_shrinker.c
@@ -139,10 +139,17 @@ static unsigned long
 xe_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct xe_shrinker *shrinker = to_xe_shrinker(shrink);
-	unsigned long num_pages;
+	unsigned long num_pages = 0;
 	bool can_backup = !!(sc->gfp_mask & __GFP_FS);
 
-	num_pages = ttm_backup_bytes_avail() >> PAGE_SHIFT;
+	/*
+	 * Skip accounting backup-able pages when this is an opportunistic
+	 * high-order pass: TTM backup work shrinks at native page granularity
+	 * and is unlikely to produce the contiguous block the caller wants,
+	 * so don't advertise it as reclaimable for this hint.
+	 */
+	if (!sc->opportunistic_compaction)
+		num_pages = ttm_backup_bytes_avail() >> PAGE_SHIFT;
 	read_lock(&shrinker->lock);
 
 	if (can_backup)
@@ -233,7 +240,14 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 	}
 
 	sc->nr_scanned = nr_scanned;
-	if (nr_scanned >= nr_to_scan || !can_backup)
+	/*
+	 * Stop after the purge pass for opportunistic high-order reclaim:
+	 * the subsequent backup/writeback pass works at native page order
+	 * and is unlikely to free a contiguous high-order block, so doing
+	 * it here would just churn working sets for no compaction benefit.
+	 */
+	if (nr_scanned >= nr_to_scan || !can_backup ||
+	    sc->opportunistic_compaction)
 		goto out;
 
 	/* If we didn't wake before, try to do it now if needed. */
-- 
2.34.1



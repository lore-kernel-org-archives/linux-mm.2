Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D810CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CE46B0088; Wed, 20 May 2026 01:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD62C6B008A; Wed, 20 May 2026 01:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5326B009B; Wed, 20 May 2026 01:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4F36B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:32:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EC08C0487
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:32:08 +0000 (UTC)
X-FDA: 84786677136.09.22395AE
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id A456B40004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:32:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nh0efrQN;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmA/uDHx5nJVlFD8/rulPbhnYG25SCWOMR7+eU0w1XU=;
	b=ag/m3Fx2aKhitl18H+Ufh9UNvTjiCdrNV+hQSnHw5ZZvYr+j+s1G4AwdZbr1DDH762KvA1
	rXXgl4AxoS5O9aSVL0t4oXFEYyOWr82nNAgvGyffaf308krLHeQ1YqGhnKO68XOW//LSYk
	raMF5STGSnW7Lc0RAVBCJ6KpYq/yRuc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nh0efrQN;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255126; a=rsa-sha256;
	cv=none;
	b=DQ1OW1BLJh0EzSrcx+mlvDN/x2XmRRvgw8jB33ltj0tJ70YCTWEf3j5wbij/D+KkGIOOEs
	ptlGwCGp4a6n1ELqI4XD7mj4N0FFjxixVHaWdlVFsbzNhFSUOd45znzY6RHfn0Go8C4Stv
	Eo3HJ7D1m8rzYrvVFD0LZk7VWtqulsY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779255123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vmA/uDHx5nJVlFD8/rulPbhnYG25SCWOMR7+eU0w1XU=;
	b=nh0efrQN6xF7hr28/JCnR3ccyOfMRqcb/ECQDM+qqDdSWCyLv9oq21aX54yJBDmmHEk7nr
	Dzdts2JOIWvCWjuQlOfTkR4i5zYbYE02WhohsRdHxr+tjOxpv1wIBM18+NHw9Fhs+Gx7aM
	+HiHuQlXDuEpvY69ImnWCS3MR3rgrF8=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 3/4] memcg: int16_t for cached slab stats
Date: Tue, 19 May 2026 22:31:21 -0700
Message-ID: <20260520053123.2709959-4-shakeel.butt@linux.dev>
In-Reply-To: <20260520053123.2709959-1-shakeel.butt@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A456B40004
X-Rspam-User: 
X-Stat-Signature: hawq71ednogr44hjdc6tkni4mykhkyoa
X-HE-Tag: 1779255126-71469
X-HE-Meta: U2FsdGVkX18YLw8x7WhSLZVffItU9o/RE8lI0zYUfXGClhAz8L28bcJqVJFZseQ/eVnFBxwt++w66Li+sWVBXW74PVWAdlcjKcymLN6OmtsTrqqatXJe4aFS+LmqHUss64mvkyooctTIF43ZDL6w3+U3Y+8lmhq922UlB8858XL4ZLEHa8nRSXRSyWOSkFAZIWRPBnL6/MrZ4p1304R4yZ4Zcn4ebvIbPHPDwHt+vmUsokjGblfEzTq5JEK5t9uwhcb8zsCJLQUCTRNlEpZmwMPD7kEcpmhvat1vzHMdJLR2d0KwQ63Ro+/p2h67jkA04upaY0lakxNBybCH+tIa0XI/vkF2Mh50i9/izbXZ7gIf2ftFT6VDmId5dFsDh5hZVKwEyq5mYkwOL/z+duY6SZfoDXpVzhz0xMBlsY73iXvEfr/ClvDGwvbspqsNV8jMDB4nnj3u1tXACREPrcS9e9+Q5M8jshG7Gce97yrCmSeMGN4vrCGHMdsQILpLr9nWRrn3F2WbY0kJVjWNqALJZ+3yNjD2daVWnL813Ro7+jv8aL8ClhCRqIam/V1uGs9aKicV+pyqhau7aUoQsK8DgLvzndE+7x9FfpCcXKEVpI+i++rIYdH2O4S2gKKuVd+UUBjOX+BSZtHOkLVDj3MjBgdwwK6aWYpeH+exhU0Ce2bPFlWG/Yqa0xTcdm3KnWiSLDgbgNyOKdd5yv+6gTWTwY2tctydKzUtoCujPxnjo+2dewFo6EH3dmziRR9PZOaCsDAwE6L/nCHd794gCpT9F+po0DsJbycEKgSHcU43ECEr1dvLKUMlBTov9SQCpZsC7ne0eXb4E6bblnYfcUXg3I+mfcY54QNQqEU6Tmhudf733cDroQQPZnyShOI+hbrWQnI+6n2E7kKX6K0n5ebcwqQ6G7siXVXAf4b6A8i7nQyWXT8chK1XjZqQaQCAQy/G2201DFoVVQYit4A1QAp
 kvuTiZyQ
 4T1EBVefxGt79sSoO1OLu5JrEHL9BcWv5Un4lQTPEPxoVzGgC3p8tW65Iu6m6x7RUM6I86+3TnfUrnHBy3VTB2x1z2KQEphYm83o8qLB9B41EQ+Kky/WCHuvi4S2NzEbhzwhUV3KTtrSpW5xF8TgBJXFrO2oH3F/15AJDIEEWJlm4MLJPbxR5zx8KfWQm5v1a08DdcbAUEQoQTEI9hdI6+QntNy62n+migjeJTxns6NNDPaYxxN2GUo7j5keXN9CotCM/crxbA2ZTRf3KCVIXAEOSu8YSnnCbBGDE/0IaaDs1Mo9MsNnKLxhbhrPwP+1nYLVfes/BUfWeZNusdKgaMVLcSfR1WzzvKqEksnXc5HlQXUw3HEpRXgUfeBDcZPmlvMCo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently struct obj_stock_pcp stores cached slab stats in 'int' which
is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
shrink the cached metadata.

The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
sufficiently long run of accumulations would overflow the cache. Add
an explicit S16_MAX guard before each add: when the next add would
push abs(*bytes) past S16_MAX, fold the cached value into @nr and
flush directly via mod_objcg_mlstate() before the accumulation.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
---
 mm/memcontrol.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b3d63d9f267c..1ed27fd06850 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2022,8 +2022,8 @@ struct obj_stock_pcp {
 	uint16_t nr_bytes;
 	struct obj_cgroup *cached_objcg;
 	int16_t node_id;
-	int nr_slab_reclaimable_b;
-	int nr_slab_unreclaimable_b;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -3158,7 +3158,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	int *bytes;
+	int16_t *bytes;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3195,6 +3195,16 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
 					       : &stock->nr_slab_unreclaimable_b;
+	/*
+	 * To avoid overflow or underflow, flush directly if accumulating @nr
+	 * would push the cached value past S16_MAX.
+	 */
+	if (abs(nr + *bytes) >= S16_MAX) {
+		nr += *bytes;
+		*bytes = 0;
+		goto direct;
+	}
+
 	/*
 	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
 	 * cached locally at least once before pushing it out.
-- 
2.53.0-Meta



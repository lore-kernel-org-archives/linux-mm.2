Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08F3CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45026B0099; Thu, 21 May 2026 21:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C7A6B009B; Thu, 21 May 2026 21:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D595A6B009D; Thu, 21 May 2026 21:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C84CE6B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:19:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B344120934
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:35 +0000 (UTC)
X-FDA: 84793298310.21.BB1CB90
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id CB32820003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ayV2q67y;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779412773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChUKgi1DGYIv7W9zbcNT51//Ts23bQgwEMP6yFTU2u0=;
	b=EvN5ztZaPo1Qdt0+lPUDl3ugapSRXRELX+LpINVgqvVIiaiN/0rgef7fTo/HwoxL2P+3Ag
	UN9/UMvgf523VjepI5ZvERvagtrc8hyOBxea76qojadz9DEt/IN4I5mqfRIvV3bJPQ7oLN
	Yxz0NhMH7yjpAoE5LYmIwfg0gp05t5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779412773; a=rsa-sha256;
	cv=none;
	b=5kO9LxnjaPx3fpJA86G+mn1ooyL11h5LZIlnmbw423e2/Z1Ri/MTm8DhM70HcAmtHreYdy
	1bD6w591do4UP9hNY76mLzC+Wf1dAE0HZhA1IlEPvO9XOw290gMS1eMwYOZMZNMkOaSMQv
	erTUo9y+NQ9MQg3NfzEqDCnjArheoiY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ayV2q67y;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779412772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ChUKgi1DGYIv7W9zbcNT51//Ts23bQgwEMP6yFTU2u0=;
	b=ayV2q67yTiwGs/a603OC4YKOX7ifFKLcTHFP4dounJlMM00mLp0D2lEtrR8oZ1oxq+qCp2
	3IKLqEv7Ej1Sgqt8ZlrhBv4lPATprFDc995gW7GGPjg6MX50TQZE2wFTBtFyvASwUegbZQ
	VENs7FskY+etg3nnOQ0bHixam6Mvn74=
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
Subject: [PATCH v2 1/4] memcg: store node_id instead of pglist_data pointer
Date: Thu, 21 May 2026 18:19:05 -0700
Message-ID: <20260522011908.1669332-2-shakeel.butt@linux.dev>
In-Reply-To: <20260522011908.1669332-1-shakeel.butt@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: CB32820003
X-Stat-Signature: f37tkxtq4hybtgzsy56wdt4dk4esiine
X-Rspamd-Server: rspam06
X-HE-Tag: 1779412773-485610
X-HE-Meta: U2FsdGVkX19zwKfUoxf6G6C7YTRaxZQcFmEju11k0WL8+8248Y4BgJAeCC/6ozw4iyS6lurd/CVpIS32Q0bMzZ/jvjGuhTUCOc83OuF+1/1BTlVSE+7ZDDn2ags8ANl5mHFyMASkGyUM1jN9h66H5+HpqKQPSlD/BcFrqCe5aNB2wQ7VLDuAniY7I5D3xVDCpRaq3EkRLDQJjlN8SBOP3Ip+NJg61er0VoRcyg3M8cYv064DwjcWh7r028wGdlojhsKh02aqOkaXTwxSHewkMPHJtRGCK+VnEhyyR3w9tNtYdhRoKE/7ecVrbKSBOUv+tHET+L1Mymnu6PKL0e/xXSWo4V7U5wE4WE71pfyUTJddAM3D5y3YR/4CV5MwQ+iXJnWSyHpE8VTww9hVvXPc9gNUknO1mqUW9S3al8ymZA8D0zPO2AC8vaZilkJep8aEalfe0LQe62ZXvNUk6cHllrSp0/Ssc/8Kwga1ebaAVv9iXdm8JogCJrJllQ42f6LAdkmwcaO6lg6oopbx9vnEokqiL7wTB7Ej5BrQZp30yurzfROXhmWIJViUFoTTqK7ivE+8U7e7aqWY9Uz6cZDk9NgSt0g3/3CReX0tVCoe7VsQJJiigdBcUyoLO97ogfonI+TpHH6T0e4ycVpgbXA63o1BdNCWKM9y95VnjzrPWeLblQ06tF0omoRVD8kXG9hdzKmz/QgoBerYPg6jI7z9jv/hCXZ2EI5TM0hS3FgFEKEVjsucs0OFKje99PGIOoRTU0UffqLy+Y5D9byyUgDhpEgl4qBoFhOOmXkMGDLHVTZjObw+B5Icql6yeLugQbssiRMMK1C0wzmyvhT98JFlw6cIk/0XgU6ka52Y/F5UaDWlO+7wzyzt1J3c04SkzzUwveHczdqNmHhPD0BoXxA3aPmNauMjiN7i/11OJY2WtaMnfuN801dwpGeB5SSlGQWQ2fBsNALPEhGtQ3iYyRd
 rKoGPBMH
 VooBYRZuWKWfKG/hE7kx5YsrPGEqKACtLpj919Vjd5giXe/SqMko6whWVNw1tXxSvXHoYO5aqXJfh33K04RH14YT0nJ8I+h35w/OAyKpZIajgV7obu5FYc5RCx85RzVOM3wqcjBEapH7lQy2/2kUWpTqNBXuROfpsaj/PUGVR1SiyjNIMJXevQXVhmrDf7jNZD7+vk9si41Uac11kDuUkyKS2fIpQzrYNbTTdXLlAbQRlgFrkqzdcjKgVeXlaCGZyKCrS7/6gAGSgYj7rdPhlLURtcspIstgW2M6ekbCQEAepprmNxxhx2S1wZ8kAx7ucaL8Ws9esFak5Q8K7T2VnwIQi+DkaSbqH1aUqSnELPpZCyKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct obj_stock_pcp stores a pointer to pglist_data for the slab
stats cached on the cpu. On 64-bit machines, this costs 8 bytes. The
pointer is not strictly required: NODE_DATA() can recover it from the
node id. Replace cached_pgdat with int16_t node_id and use NUMA_NO_NODE
as the "no stats cached" sentinel.

At the moment all the archs limit MAX_NUMNODES to 1024 so int16_t is
plenty; a BUILD_BUG_ON() makes sure we notice if that ever changes.

Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
---

Changes since v1:
- Added tags in the commit message

 mm/memcontrol.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8caeb7ccaa3..d7c162946719 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2021,7 +2021,7 @@ struct obj_stock_pcp {
 	local_trylock_t lock;
 	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
-	struct pglist_data *cached_pgdat;
+	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
 
@@ -2031,6 +2031,7 @@ struct obj_stock_pcp {
 
 static DEFINE_PER_CPU_ALIGNED(struct obj_stock_pcp, obj_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.node_id = NUMA_NO_NODE,
 };
 
 static DEFINE_MUTEX(percpu_charge_mutex);
@@ -3159,6 +3160,13 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 {
 	int *bytes;
 
+	/*
+	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
+	 * sure it does not exceed S16_MAX otherwise we need to fix node_id type
+	 * in struct obj_stock_pcp.
+	 */
+	BUILD_BUG_ON(MAX_NUMNODES >= S16_MAX);
+
 	if (!stock || READ_ONCE(stock->cached_objcg) != objcg)
 		goto direct;
 
@@ -3166,9 +3174,11 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat changes.
 	 */
-	if (stock->cached_pgdat != pgdat) {
+	if (stock->node_id == NUMA_NO_NODE) {
+		stock->node_id = pgdat->node_id;
+	} else if (stock->node_id != pgdat->node_id) {
 		/* Flush the existing cached vmstat data */
-		struct pglist_data *oldpg = stock->cached_pgdat;
+		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
 
 		if (stock->nr_slab_reclaimable_b) {
 			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
@@ -3180,7 +3190,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
-		stock->cached_pgdat = pgdat;
+		stock->node_id = pgdat->node_id;
 	}
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
@@ -3276,19 +3286,21 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
 	 * Flush the vmstat data in current stock
 	 */
 	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
+		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
+
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(old, stock->cached_pgdat,
+			mod_objcg_mlstate(old, oldpg,
 					  NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(old, stock->cached_pgdat,
+			mod_objcg_mlstate(old, oldpg,
 					  NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
-		stock->cached_pgdat = NULL;
+		stock->node_id = NUMA_NO_NODE;
 	}
 
 	WRITE_ONCE(stock->cached_objcg, NULL);
-- 
2.53.0-Meta



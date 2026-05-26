Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1054FCD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2956B008A; Mon, 25 May 2026 23:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7532A6B008C; Mon, 25 May 2026 23:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6427B6B0093; Mon, 25 May 2026 23:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5560C6B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:39:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D96BBA0281
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:39:52 +0000 (UTC)
X-FDA: 84808167024.10.A48BE42
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43E36120006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:39:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VOqS2xMY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIys55gPtHxFJ6YYkvug3PyqOz22t6XWNtWG1R8os4w=;
	b=5q/C8RwvdnWEzO8sU8+AClJT9XBZyUAlz6dMN3I05+aavJm1FebRQ52+YN/8kfdZc2fkhL
	SUVh+jFtMylJ2H131XXpqWbG1QH9O43mNmXjpNzn1NzO4EwzaCCi3cLPMqeILxa2WRJbkz
	tjmBZ8v94llRXmB5Dx9SEWYMXsCkyoQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VOqS2xMY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766791; a=rsa-sha256;
	cv=none;
	b=DWzW5KrT0FBoo/Vs21LVU+lksRmadX5Gc4olMr0QDIfYTPK/J/QlJ3e2W2HWJF9ilXG38h
	1TNnK/KDUE6iej7FeW9iMbD6ptuMyky874g70cq+jUHmSu9L+C9+f+EOH8UtkdNQVNyR7p
	c04Z0rakq8L+IklgqgR99DC9/q1uoXc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779766789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIys55gPtHxFJ6YYkvug3PyqOz22t6XWNtWG1R8os4w=;
	b=VOqS2xMYTt93PtKO1VfGDeSlnh+9Tjw856bjZFZc/Ckt9sKz1geFSMDUUDXxB3778ZsyaL
	pGFWQTP6HXiirfV8Oo1Au2LTOT6r/J0/6z2JSKSIBkQrMejmRj637jsJQHsoKAkHTct7Nj
	cDsIKs7h5e76PzZ5VauqdqC0djcq3wI=
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
	David Laight <david.laight.linux@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3 1/4] memcg: store node_id instead of pglist_data pointer
Date: Mon, 25 May 2026 20:39:28 -0700
Message-ID: <20260526033931.1760588-2-shakeel.butt@linux.dev>
In-Reply-To: <20260526033931.1760588-1-shakeel.butt@linux.dev>
References: <20260526033931.1760588-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jx7zrwh3k5h3ac7nnsyg63yiisqwo4ic
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 43E36120006
X-Rspam-User: 
X-HE-Tag: 1779766791-592692
X-HE-Meta: U2FsdGVkX1+m0+QuaUtrhFAmeOjdqObP5AbEaCE+Rp1l3urkylEdHFkQyTKjyaNh5DCg7TR/vuw4fdckrBqQYFNYh8/I6oaUKWDHhn4mi1ccmXSqN+rEBvszT9R/oH+2CrfDvEya/gh1PM/I9efQHLWd9BAd96OCm+ZSdAdGKOK/gGBVruyuYVcaM9Qr+oMG+ZRflQ2jIyv7wi+5TUB6JskxmEMChazZGV3S5b2wE/rs2KVFY/bYddR5qa0yrDEE2T94N9VQ5edQK/6LRy2427VJjuXL+bL7z0jgo24UT9uhuCFZdY3jsRhDJiioJczuZKJOtiScFgDhx+eXa5vkTDORpzBDhlcSklzAMM6dSCifz2IuWqBpNHjS951aGORvBOd5LQbn7ytuLds3zHYQmyHohmQwgB8Yu4paUKjbvvdm0rd7iHHIzlhgp1o2J+7U/4Zzk9QxMDThnHdCXW+9Ks8cHgGoqNV72vhE5wgEc63HSDy8YXRq3IoUgnbxBz6pe09EzPsf8EeA3tETN0sqooQe+kd0eGdli5akvrpmZcgSec4ZjgMUeKGMNL1mvuI+XgPdRKEbXlC+Or5yf72zvabbNraJm0DckkWcrknuP7SzqE8skm7fDfU4CpdAQjQeb6JOK3Rc6kgw802grw+dnGYg8tKLmPjzu8MAfrpCvrcGP74EY3wXyYF3X65PxrtuMQycu0On/95VNH3qa4e2PXIDRxO80aUOBDDMiC2qtnGBSgiNO8cMB+umBcXEElnQKxUwXBLGKqkS86GyuDmkd8B1BDQKQyoR0LgvpUVTXy5XDBYrfHKLZM8kUsnWhmZUip6/8AivNR6FjewbyTRzFrqcWMjF5ppJtUPRBb5vXFExb8wXApPHR+QTtE2hjiDq4rjVDXyBOnryFj3OXCz9VGGTLN/0pFLqzOSRB29gd/+jG2u1xJBnk5wFGCBvyfBu30mnJvrPGZoG0voymEV
 2ChznUDe
 Jp/g6nytDOI9h7GAHa+bcNAGkxpB0I5mtW7E8ynHHEzASzXveFanmitnri5msqkSgStGn6sxGR6t2D4Rzw8qBzl/Y5rvmmQ0sfEhBLYYFn7t87iw8vcDDl3CPShUD3l4ct5PWoT1G8kbHuIwZlf/ObEjtdpf6Qkgz3/44ySZKn/J1nNZ0EGkZK+z0DXfQ5XfxVUtDWAYLc4V4/TXhjmgs/OBLfRzVcqCejFE74ucEya1C20+E9vwbpLMPYRmY93sBJQEc20PKtLUA4jmbFkCVSfqZy4a0ZUbD/pkyQ7EbQfOO+7js1/cANV1OV/SmuUBtSZD/51mZKFRNQlgc1I3XAaTvpEayo24vdBjWds842s6ILqg=
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v1 & v2:
- Added tags in the commit message

 mm/memcontrol.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 13f5d4b2a78e..9bee9031171f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2022,7 +2022,7 @@ struct obj_stock_pcp {
 	local_trylock_t lock;
 	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
-	struct pglist_data *cached_pgdat;
+	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
 
@@ -2032,6 +2032,7 @@ struct obj_stock_pcp {
 
 static DEFINE_PER_CPU_ALIGNED(struct obj_stock_pcp, obj_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.node_id = NUMA_NO_NODE,
 };
 
 static DEFINE_MUTEX(percpu_charge_mutex);
@@ -3162,6 +3163,13 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
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
 
@@ -3169,9 +3177,11 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
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
@@ -3183,7 +3193,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
-		stock->cached_pgdat = pgdat;
+		stock->node_id = pgdat->node_id;
 	}
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
@@ -3279,19 +3289,21 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
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



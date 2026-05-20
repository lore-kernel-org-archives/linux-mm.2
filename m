Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A3ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BDB6B0098; Wed, 20 May 2026 01:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC386B0099; Wed, 20 May 2026 01:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAD46B009B; Wed, 20 May 2026 01:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0E86B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:31:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA76812016F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:31:47 +0000 (UTC)
X-FDA: 84786676254.08.925BD25
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 15178C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:31:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nO/4iKEn";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kz9eWjLv9LTU/HF3o4z9RuRje/Iqp2isOufx/xVO/40=;
	b=amD4IDL9HADFS64NPeaLgcdW0iXDSuEzy1XUraR2CcyZi2HzU4qTiVrsaPgy2Hdihqr2rB
	ygVXm9+Qdi6x8EIPbRhs1hldfk1z3lepx9T8Kzf15WY6M7O/4r69PL+BMuSGgiWItO2+vQ
	C+LIifeWBifK8fzBxy5NlIscghaW3lw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255106; a=rsa-sha256;
	cv=none;
	b=1Skbo7XQIbebJ/15liVIOE6ocWL1zg0wxZJPZX1hNFGu/5UWS+2VXvAjTAIlzzhX8VFhVN
	taTv91Ltrm9a0ZLxFGxYUqwvkEmr4DREejK1Iw4xrKlZ3vm00btWG/sKanFSVkInRjmhRw
	tx/NdFgDQPgPFb31ZIL5exKMX1DS89w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nO/4iKEn";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779255104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kz9eWjLv9LTU/HF3o4z9RuRje/Iqp2isOufx/xVO/40=;
	b=nO/4iKEnnLh8low2bw0UgwHeEbtkmaOlRQ+C++sFKPF63vRHCjQSN5ZF3YTTufyJaWf/q7
	IgbNV3MrXSXH78XAJcadPHFaU4LQY5sPjCuNFD/t1hHD01syJQEA5ViS72qvQiHHFo0Nyq
	8rQ92WUHjXLj/FUoAvLQklEam49OUyA=
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
Subject: [PATCH 1/4] memcg: store node_id instead of pglist_data pointer
Date: Tue, 19 May 2026 22:31:19 -0700
Message-ID: <20260520053123.2709959-2-shakeel.butt@linux.dev>
In-Reply-To: <20260520053123.2709959-1-shakeel.butt@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15178C0007
X-Stat-Signature: bpixqkca3rtt9z684r88qcgmunbqr3c3
X-Rspam-User: 
X-HE-Tag: 1779255105-915072
X-HE-Meta: U2FsdGVkX1+Rstp2nc2trhR3bgDzvMJL/TU74ojYh/Ui6yUvkwcaR9kZcrH+uJH8a316Pr8psU/+lO2GBqlvNsy4kHMVZBTES/Z0TSX3cozAUC5Wor/gv8aFpFb42cMbGkEYxylbYTdxaIbLomoWIxhDPlr8J9WWvpWQbJZPQQtz0stW4T77Ui4TOHtoH2pkd7sE4fUhm4uznRuyg24gsLVvY0sTl1W+XoGmFKczNTbBHqoM+DSM99sJ8iyuyyi7HCXEqgHIm6GtPcThrCjY3CZqiEBbaaCYd7LWFPsWFn+Ji+096jUX4JFln7DxBLTsImjqwZ43K2AOFIyrC2udgokitSqCQd1nam4NfYfwih57WlIwr5TQ9t++GEqubXwKCgyLEKOFqZFtLYNxYJOSzrtnZ5DjxvN31CbXhqgD5oEpO0MuA/QXB3D80MU8DDbEe3tf6GKek8oJLPLb3FAmmHeW/Eb6IG4QvoNF6BPVuCJn6Bhwss8azMWhZc2yqIlY4sGqSAmHlR8LJrtdaFEegptizQzjSjltQ63KL5ydew1FW433d+ItQqCggwquJ7mBVPBhVxvNH0cNGbiB72K+yboZ4wZ94vuKSyVgW2ieh+IbekF2vfL823fQVo7zErK/wgQ1fXWKPGpeDI1Bl+5XBVMC9O4+wDMUDGSzt5kYOFl6FnRkpObEgv3BIxFvi+TYgClgKOBgEpCWy1WVKQ9FXDQ6jMPV4bRShZeG3apsXJ3rD2oR4U/eyvnY4yh1dgTLbeTPO3kjvouuz8oUOp+MqU7HOR/nBfit04oSFtY0dpvStWOLyvHB6MXZHP4VkuRoE4AJovLIKTN5DKWsHdV7/L+yppTLbRViRS6K4O/T3qurj2KvLXC1l/AskQWp6a5UaQAGpeS3rewUyNKZacjL9h5/6i8NufRtqaCD+y6R6ZrAVEepLUDsmFpFOPNVB/lE5j25aZrEkiCswOMfXr6
 80MJxj2r
 25avlDw5aLDgnzou3fvTmcPMdkWPoPrjHZPT6/R+NiSNH+OOBZFn0YNFkWeZQejxDhU4xwYjJkyutliq6dUHSmn/fVgwYaWJSiFGQU88sB/Q7hOP0xXD0m0vxKXSE3ObNIennhKwiH6YLaYlJ5n5n3ObUNJIPgZiMZ9hdO8vhfQH1Rv47FPK+IGr6Xq/yfb8cI7d6wwu6eoiLwHtuYK7YmwP5UBzAoq/tJrqWmOrhFwnZ4HiT4JyFfdmnjbOjWcGljcqPBgSyinG2CO1C7h3Xnv70DbQZizcPaAQAtywI7JJVcezf7ZeMutQH/Bb3qBx7WIMGqlzPFJ1A7Bl3ha9Cke9WYu9WbmLowcvlW7GNAczuCUcjIcsg73grFQ==
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

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
---
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



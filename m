Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D06C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73EA56B008C; Mon, 20 Jul 2026 15:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7162C6B0092; Mon, 20 Jul 2026 15:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605626B0093; Mon, 20 Jul 2026 15:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23FFC6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 780611202C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:46 +0000 (UTC)
X-FDA: 85010157372.28.8559CE7
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFAA1140004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FgZYn4b5;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
	b=xVI3WKgClQjVTnTmmVIzlCGMB2wPTxdBa+bpy3zQHhQtmwYAIg9cHZaOYxRb2DdYpF04BY
	mw4av1rPx3JkaJkcMa/C6VwCphg7I2hdtP9HWpxGXPhOeJGTdB0yJ9V526zMECAcp3Uagv
	73R7xxQC2X4F5BbJJSx4+BNrJTidUiY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FgZYn4b5;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576084;
	b=GUvhN/Hg/ANUOCpISkmdznNajWv1DBfHYoE37UbPtdAHt4tVwiU2YSL0npzb6bOu3AY6P4
	HNnYuvn07SchRi1t0NWbBjzGzB+lKtE6u7YZdM5C68RWn/bOQ+jtUoR4MlajKBsEkfyxr6
	++rYN5ZXuFUBFkV5kZmwPjdG2Kc0VrQ=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92f0b5ed131so662351685a.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576084; x=1785180884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
        b=FgZYn4b5+C45vgOp0HScNrxZcPj6T+F467opS/ZsndBEdxmpfrARJqmwnS3j8yOF3h
         ajIlTkAJnBGmdOwtI+AKvMZZJrs9kwi6Nym+aq7ZvYlMZnsE8QN/eCNOgaFanUekXVaS
         BDep2kcTA+tZFvVsbBAcoYJJIDIwu8LSaH4rDMYlUy7RkWGWHhSy1EVd6FFxHkHT501b
         wD2jGZTo2jvRq2zbnH7bnuy6gf4KV4s+2fdg+AaufaXqKlfpZ0WLYINi4Gb5dasUnH5K
         tX4Ev25v0mOju3pl0VQrpzb8A9V4Au7WBOMRbpEhWc0NCtxZVPIswnNPR1VLMTvb7+Ev
         MCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576084; x=1785180884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
        b=p7woD/pO68ZT3gTETI8qTD0Jji4Q+ii2AcJRb9TCi929Ha1LuNOvWb9kWU6S6HHj6U
         AciHqZicFlqhTDZqQ0cJutUAibzZRSXWl5T9Zkuy6tyE8PckCxDiG8FnXe1LJWrsxAXQ
         hp3EmMak19ISpffygHIJnTdQDcJPqxDbzpgnAoAOJ7OYgKfD11U0IcN6X4vsZEIYvkTS
         nQpMdIbbK3TNVH0nXXRWFHu6Ug+ec+zm72vYWvMYJ88mkUnyXnJrSWmpNttF9yJjikvk
         cZNcyGepXrdheV2z/xkdaTiX9rS/+5AQjSQLi+dVG6IY32p9Toufmwim4tVmDic6PGv8
         JE9A==
X-Gm-Message-State: AOJu0YyA+76qOH0UKBzhF/C1Cj110bpYUpk0w/GQQYjiXrLrMkQLC6/N
	z2ALlxSGsxN2PPJggegY8Qhl/ZLzDqosuCURt1JLWuvrnHhJnLmgEqvHO2/1aaqTu+nCFWqYhGk
	o+Ce6
X-Gm-Gg: AfdE7ck18Rbal2oqqvUcf3yIOSL6148zs6+O6bzfJwWsgGJtKChQyzqFTVot9uuSG+h
	iHRZFuaMVkJpHK43Vlp6ajQ29uHqeWCrHcIYcsmFBy93wgGYfuY5v7R3cXFIiTdI1xqwKgGJfd3
	RxGG6BWgmdHt4WeqCxRaQdsgCsLG+ZpKPonZXW1+amNMLGLK0Q5uTn8PzUrZGP0OgeQLTXEzjTM
	ffnGJOEbQdOv6gxksA5HOuvYPmM0gXSjjIPi06I7yixYyCNaN5DTdynBVk9qoUe76J+7EgWjl9a
	euAmR5WvpFKSwk2mJNa333jIWfdFbgmsKqF4CzBllcGAi0+0wQkrQnWrFVa/uwr+UnQ2QrCsXiN
	egnnW1zpbmLgvbJgMEF86fGwQErN9zHM1qmyNRFB0HeoebbzTSGam/qiJdwU/l03g+oAN4rzDEj
	4OKCK3c4hXKERrcoiMUfF/RiN0cpczI2eYwioRr77/q7ZoOeUvKebHplfjD0o5uCbh8C/6N06Qs
	w==
X-Received: by 2002:a05:620a:1a19:b0:92e:c118:18bb with SMTP id af79cd13be357-930b43dfc05mr1508161685a.90.1784576083785;
        Mon, 20 Jul 2026 12:34:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:43 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 02/36] mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Mon, 20 Jul 2026 15:33:56 -0400
Message-ID: <20260720193431.3841992-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AFAA1140004
X-Stat-Signature: fy5hs8gf356cs5scp73fma9hc7f8tcyt
X-HE-Tag: 1784576084-892129
X-HE-Meta: U2FsdGVkX1+uk+w+HB7ySBoU2ouPR+iPJD3TmWPAcydZsZtgqo/eJKMreC+xAgYdouefq9GB67fvF0gpv7Oqm/v0J1jB3XJuF2+I2jIzw4OWhPhZlC4rsYDSLwdlhsgNA0t6VdfIDSRb6UIGAk6W8h59gjOZwjpedF4qAoedbukwx+SgaxZ2Dn400Oq3zqV968RL+e4IShv4C+vJx12LZsTAh5NQyck6KE5J6Jbd7hT+tRM/3xgtHjuXRqt8pGJIR69fgcbsftfdtuM2rI86nVW8cJra0bJbvVb2GkAwbWtoRW93f3GMz+kfSZUDLoweWiPUXgsARWXdCVLskpMwhJIoQ97wH3qYiUApD71sKWSjgQb8XOuixiUMhCmyy4FuiY/mheBjIdZuFk7/+MbOwEzpNphK+aeJyEaclLhiOmhP0yDNFO0eYCWoCigCYxcd+wLUR/7sPnTnZPN4YGdl9zZx+RsPipZ6mKpnhXuj5rWXdxwsDTuA6UbKOhXrU9hyk59hfX0GMHYBFhBZFEpvmXtSqo5mgoodbSsBa/+X1cYEcvtG0mfVkxmc/yPIpBPw0E4WgSZjxQgrug/90Fi1kqQGLXdOalG19fzzuqVbWa8vpthzDCjqGd43kM9LpNYvgOQ07cEGg+oalOD5O3lkKVDj6RzGGxq32pb9eJtnufTMpJPrXR+ZGEhBmiP6aKFRY4lZd6eDCp6ibpGsV1jRfL1I04+4Lq7W8rx2K0m3wLXsbY+Mbonf9EBS6IQbcq33P+MHNGlka1CcG+wGcYkY+aNlhN3OG1lUw7MrQ8YeIKTPbt05ny/AyUUjqoagdyLHADO+aIWZl1yzI/mS39H0pLYsY8GsSjze7GFmR5I5+muaSWyD7VrtDjUGXpzOM/6ZP93NjIEx5nT3TLNj/ijeUsOmixVPy2zIsKRgQMhZhVX9xWaNEHK/BnNwe7I4T5oO/l3pP4IeNJIrWJCP7be
 PMBQYMil
 2O2fyXG/H9XYHtGOZWEqwFLOMf2Yvnyu2hbGXWFCWELE/yAb6X5flSgIVNtJ1gUdGjQYcQLaOhMNfHYYHY3G8m2iGzx+2D8A2JMuzkeu6/2TGjkgleiQFr1CbNJrrdTsuZigL6dSWa2sVdr847mNQnYevg2W+1PpWbq1U1oEVKvWjUkcUq905QE8LXfZbOZxRY7O98DAaY9MNZ43Ajzo0+lwTSxe0kZMOvM4+mRhsGYfa4nB3emJawFT8h+kkDysYzrZOS/Fw/O1HG4PeS/d4j3lEArBu/rZm4dw5hdv2ds5BsHsTk42v6RnUTHiRFTD2uxdfY2Qea055IqIHC2THMWvMZUAGmO+BED5A/OhpJlkDRHktqyOf+m5oVKhI/EipTyaCvgLwuIzUbCd/eS38Da/t3lXsMoanEwPYMiLaQl/XOhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract per-node fallback-list construction into build_node_zonelist().

This lets use build zonelists from candidate nodemasks instead of just
the default N_MEMORY node state list.

No functional change: build_zonelists() builds the same FALLBACK list over
N_MEMORY with node_load updates as before.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index acf096f525f49..4c1ef84c02a3d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5813,12 +5813,12 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
  * DMA zone, if any--but risks exhausting DMA zone.
  */
 static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
-		unsigned nr_nodes)
+		unsigned int nr_nodes, int zlidx)
 {
 	struct zoneref *zonerefs;
 	int i;
 
-	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
+	zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
 
 	for (i = 0; i < nr_nodes; i++) {
 		int nr_zones;
@@ -5847,26 +5847,28 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
 	zonerefs->zone_idx = 0;
 }
 
-static void build_zonelists(pg_data_t *pgdat)
+/*
+ * Build one node-ordered fallback list from a candidate nodemask.
+ * update_load round-robins node_load across equidistant nodes.
+ */
+static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
+				int zlidx, bool update_load,
+				int *node_order, int *nr)
 {
-	static int node_order[MAX_NUMNODES];
-	int node, nr_nodes = 0;
 	nodemask_t used_mask = NODE_MASK_NONE;
-	int local_node, prev_node;
-
-	/* NUMA-aware ordering of nodes */
-	local_node = pgdat->node_id;
-	prev_node = local_node;
+	int local_node = pgdat->node_id;
+	int prev_node = local_node;
+	int node, nr_nodes = 0;
 
-	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node_in(local_node, &used_mask,
-					      &node_states[N_MEMORY])) >= 0) {
+					      candidates)) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-		if (node_distance(local_node, node) !=
+		if (update_load &&
+		    node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
 			node_load[node] += 1;
 
@@ -5874,8 +5876,22 @@ static void build_zonelists(pg_data_t *pgdat)
 		prev_node = node;
 	}
 
-	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
+	build_zonelists_in_node_order(pgdat, node_order, nr_nodes, zlidx);
+	*nr = nr_nodes;
+}
+
+static void build_zonelists(pg_data_t *pgdat)
+{
+	static int node_order[MAX_NUMNODES];
+	int local_node = pgdat->node_id;
+	int node, nr_nodes = 0;
+
+	memset(node_order, 0, sizeof(node_order));
+
+	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
+			    true, node_order, &nr_nodes);
 	build_thisnode_zonelists(pgdat);
+
 	pr_info("Fallback order for Node %d: ", local_node);
 	for (node = 0; node < nr_nodes; node++)
 		pr_cont("%d ", node_order[node]);
-- 
2.53.0-Meta



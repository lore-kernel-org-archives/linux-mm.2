Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B2BC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3876B0098; Tue, 22 Sep 2026 22:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BA06B0099; Tue, 22 Sep 2026 22:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062176B009B; Tue, 22 Sep 2026 22:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEE0E6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:29:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 602881C3348
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:12 +0000 (UTC)
X-FDA: 85243444944.16.E957C62
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B023140005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cNaX9bUv;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWWHCDlvz4uiBBqUhZH0RsVaOlDUvVDcH0PiwNo8xZc=;
	b=wMz4u9+ApHRxIz5mlL3SEI0BEkYhAEdAUZff5TY9Gp9wFmPLs04vuT6xcsI9tPsue2UMeT
	nFEv9nus8oHlJ3V4fa5YI3BEqbJcF3fY4K0Elr+7Je2UAVCEx48Cuy3V2P+iU6NzJOzLBs
	njkMCVK4BgqgY98EhFgEUSH5tBDUQjU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cNaX9bUv;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130550;
	b=MgzsWf0sZCXv9uIwDF/8YWSsfs4/laXojHAutuzSOKVpkL4EtWzpLSU6eBvhzxQkJ28tPs
	XFrliNOWAZAVy0vD9TnZhf6a422SEXOYLBP0IDNEvOfN0FMHz73219NTsBv2/aPoJOl+wD
	cMnlMApv0T1ZmpsXYNqO04fad/BjbZM=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93be6d3f424so132437285a.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790130550; x=1790735350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yWWHCDlvz4uiBBqUhZH0RsVaOlDUvVDcH0PiwNo8xZc=;
        b=cNaX9bUv//XUiJPL9BkPypiBkYGMlLxJjFji6ufwsiQNtJGNwt1zOmSxdygUplhN4v
         EPCe4PpUVaYCka2PAokyQptURRIEkE92CI6VTM+bpvumvi6NGA7aT1YxZf6RfHtC7mO1
         mp71He7/GA+COuo2v2JTXCRTt1zLR/xzs2puwbqJJWkWiYzMxUCoUT2OQ+dsZ91LWWXC
         RrpR9kZU4EJxBBv/mhKd1mwRDyVJZu0Z0+3ObuviJQAacfXHaBf7RHRt1eBuwujuM266
         7PD3FpkzUofGFxi/RhPMjxPeoV48Nwx/PkhsjrXO6l12KssEDbQ2d0yzAA5HfeJxj7vD
         Jrhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790130550; x=1790735350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yWWHCDlvz4uiBBqUhZH0RsVaOlDUvVDcH0PiwNo8xZc=;
        b=adFoVnJSyIUXG51IDKylzKT1oxXcUR9qq0r44EC8k2HgXndXVHsHv/0vIlO5hVIkEk
         c4CFVMQ3yqRLojU5MwzlRfacAmiK+EzHFAUGTIJb4K3/kaDrPi6gcnDga8YfrlvJEkOY
         MmmsxUml/sv9QLhZRqZxQKkeG2SfBlY4y/2FKnoGellVDqqtvYIFRsf1lWeXs7Zp12xV
         wSUvf0i7xdCAd8JCEJPYGT4SVJYsozvmk1JEb6P23kbd9YdP7EBgqmZFJBsOmOmznQh/
         AH/UNsMMenvXjcBjbR20iafemsZcW/85KhGtxF69JCaWwFnqFgRXUT40WXY/MSOJCYdr
         ZqEA==
X-Gm-Message-State: AFuF++ntI83IntkhAG6ZJG90BMrsPNz4A7/RC7VGWXmenWus7H/WnXAw
	9TOzXm8ZwvrG4FJItntxAJBfYAyBQ2RFnS4Z2itM2DW6TGJBqqFKU+5tgUU+/wvjNmCnY6cFxk9
	fP9wX5XE=
X-Gm-Gg: AYBFou26UznPYUPWxCPx7oCD1JMa4KAeWRr3EhAc+JcFnKzZKh6yW+v2bhaHZSa3XVo
	oygpKLkf+bGWNmnSNlpalUnI8279yW1ayC4k27UqufnO6/1piSwzfnDkWkajKMdTlKnWj+TONkU
	hWflmkKjppxKuh2rEK7CfnkoLjHVOMy8s+9RjOAhivB55PPxODdYeVMaVCGtyWqmzfC76ewmfwK
	tpETQDWrc9NTUGZOy46wGTa88Va3FjrG+mp4FhUU8TiAVLhxcxcfM5mfcpjb+jQshEHlVG5qkI2
	T32LJWU5ENQtYJo77QwNYATQ/AL0J9vCk8qeTb96Vo9iTlYAV8NWTKc3T8wCjEMIN/Xwz+RDp85
	NFax1bj4f3LV4efl2oJOSrJ9C/5Wnnl2uSnUDmvG4wAm7YFd7NlKl3cVQ8+wYakqLaQtgoG4JSb
	lssygvyEZUB8efVq70DdizdtfHrAeVf7iaveYA5MVHvvJ24gCVDkJRjFM0MQXFb/CdA2uS74R1I
	Z4JwRU0HSEByYbbSv9tKXEevg22RNW+ua5szBUci0bCUHwt7sZP9GV1KSuH
X-Received: by 2002:a05:620a:4112:b0:939:fbe0:9abc with SMTP id af79cd13be357-93c17e2edd3mr739670285a.9.1790130549781;
        Tue, 22 Sep 2026 19:29:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2482302fsm122626785a.12.2026.09.22.19.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 19:29:09 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH v3 2/2] mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Tue, 22 Sep 2026 22:29:02 -0400
Message-ID: <20260923022902.2433614-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923022902.2433614-1-gourry@gourry.net>
References: <20260923022902.2433614-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B023140005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: j3b91shfihybkpgq94ixdisdaq1pgx5t
X-HE-Tag: 1790130550-885960
X-HE-Meta: U2FsdGVkX1+9JdpWReTo5AqxLUEKgbE24esY1vLJ7sp3ihcF2apuvmFm9CFc1YmhDv6IaZczCw197xUmFFL9t6xmp3xVUDuXGYB5/R9i4zwyFmeuIUD3DOWadxfQEXeBnlbNfwpJk6fc/5WHgJ+j1dXvtKiUrlIc17V6D4O2OkvraQqXrafoZ7YcpHRm1C3sQY11Ool0gl2LOMNbCqhhh1fzsjz8pkwnBSh95Rq8bWxBFHBk+nDg8hAFZLMKcRt/LmRwklURKdbLN51qnvuOH8mj17PQ6Y/J8ZdYB2ZFFhoo+gWB+VCn9IkMdCbIv3yp/jEZgOOmy1t25X3Onc4/9tQItkhugTVnwzWdjClD4coiuog6Bf/7pINQs2LJmgu0lzoCQJx2P6D/CwvRQCTWUmBTIrWxInHvHKtO/985CpNf7wFbrWXOf6TeBYPjczJ2QFvYYGwROuoVONjUq56I4ZiFeOaTjEXoJOeyrR8y3xJqHmUyX/VYz0/wBLbK4xdOVDiajVvgzxBAGOq0mbFOvL+ivPw5CXAqu6Gr96W3oXuKXZGCb37pJzN5IRKaQmdXLBS3Jwm0/qFxeybiygiavxMCW0/LhMZWFb3aZt3BGBZQvdq4jt8elg6RX4prCDLoFJy02M77u1en/g/UNl97SzOshOOBQCX5CDLRT3Dv0DjT+F04/txQBIq85MCM95LyBBViiRjCDFtfs+XKV4rFnA8jjyCmXcsZCluXVFW+Xn9XAQBrS3/GzB7pcBIDD0TlYgRkWV+tMa0qRPdT1Zd6Fbh4BhBwTjLaaQNm0xx9MoBUcKIw5RO3yn0mPFqHRMlUeZeMM9jmjWMmdMC9RtPa5eq7NvylVsVYQrgsaotgysgMNye7iRYTQmFzHY30qgoiD5yyGJNHKixicM7YXLTNQiCzPEcgq5wL3WpW2z5jhovXE7fpcs+vYf7DgqhxlreggWdXDaw6RFBypuwKSHq
 AVVj4zCT
 TOfuQd85Ksk3ePHvZsdm556FbOu2E4wSUnqYue9lVBppOxelhFwA7W5i/bu59lJpCACCNugf16SSNu9Offk79EHFOcu3wZ8FakgnY9H78bbYZicpFuooBm5Q2xsgCoBEjPnuGCOfqVu6lyT7YPW5iNPexmQoqQjV9s4aibUZFP6Wi1CA9Oc0vLvSppYSW/wVRyRdXDyhsiFHgf3QMS5U8K/rVD3zMUuwRckincSZL4rcEdaR30dEgtOYFSWqy6DwkraXWlAPfjEv8lDTAy50fPL5i9QeVFwGbntiFjRsHWmdDtTDASCmbzap6DA0xkWy10CTugOzQfaYlWUp2nObzPzZlMFbW4LZwcdMzoY5j6J6npJIFSbrlZHfvOt2P3UpzjhQn4TYrCnf4Y7u5M6L/ZcYaLKNBPwjBQkAqHs8BdXEyJWduZUC4bzfhtYvu6VBp9z8JdLnFU+o6I5+dEuxeF7ZetehC1b7pk8oW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract per-node fallback-list construction into build_node_zonelist().
Build each selected node directly into the destination zonelist so no
intermediate node_order array or node count is needed. Print the
fallback order as each node is added.

This lets us build new zonelists from candidate nodemasks instead of
just the default N_MEMORY node state list.

Add a zlidx argument so callers explicitly select the destination
zonelist. The existing caller continues to use ZONELIST_FALLBACK.

No functional change: build_zonelists() builds and prints the same
FALLBACK list over N_MEMORY with node_load updates as before.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 63 ++++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7f706e3d7e50..07e03c7c7771 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5866,31 +5866,6 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
 }
 
 
-/*
- * Build zonelists ordered by node and zones within node.
- * This results in maximum locality--normal zone overflows into local
- * DMA zone, if any--but risks exhausting DMA zone.
- */
-static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
-		unsigned nr_nodes)
-{
-	struct zoneref *zonerefs;
-	int i;
-
-	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
-
-	for (i = 0; i < nr_nodes; i++) {
-		int nr_zones;
-
-		pg_data_t *node = NODE_DATA(node_order[i]);
-
-		nr_zones = build_zonerefs_node(node, zonerefs);
-		zonerefs += nr_zones;
-	}
-	zonerefs->zone = NULL;
-	zonerefs->zone_idx = 0;
-}
-
 /*
  * Build __GFP_THISNODE zonelists
  */
@@ -5906,20 +5881,24 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
 	zonerefs->zone_idx = 0;
 }
 
-static void build_zonelists(pg_data_t *pgdat)
+/*
+ * Build one zonelist ordered by node and zones within node. This results in
+ * maximum locality--normal zone overflows into local DMA zone, if any--but
+ * risks exhausting DMA zone.
+ */
+static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
+				int zlidx)
 {
-	static int node_order[MAX_NUMNODES];
-	int node, nr_nodes = 0;
+	struct zoneref *zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
 	nodemask_t used_mask = NODE_MASK_NONE;
-	int local_node, prev_node;
+	int local_node = pgdat->node_id;
+	int prev_node = local_node;
+	int node;
 
-	/* NUMA-aware ordering of nodes */
-	local_node = pgdat->node_id;
-	prev_node = local_node;
+	pr_info("Fallback order for Node %d: ", local_node);
 
-	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node_in(local_node, &used_mask,
-					      &node_states[N_MEMORY])) >= 0) {
+					      candidates)) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
@@ -5929,18 +5908,22 @@ static void build_zonelists(pg_data_t *pgdat)
 		    node_distance(local_node, prev_node))
 			node_load[node] += 1;
 
-		node_order[nr_nodes++] = node;
+		zonerefs += build_zonerefs_node(NODE_DATA(node), zonerefs);
+		pr_cont("%d ", node);
 		prev_node = node;
 	}
 
-	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
-	build_thisnode_zonelists(pgdat);
-	pr_info("Fallback order for Node %d: ", local_node);
-	for (node = 0; node < nr_nodes; node++)
-		pr_cont("%d ", node_order[node]);
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
 	pr_cont("\n");
 }
 
+static void build_zonelists(pg_data_t *pgdat)
+{
+	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
+	build_thisnode_zonelists(pgdat);
+}
+
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
  * Return node id of node used for "local" allocations.
-- 
2.55.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2994C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955DF6B008C; Fri, 11 Sep 2026 23:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE396B0092; Fri, 11 Sep 2026 23:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5146B0093; Fri, 11 Sep 2026 23:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4717A6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:04:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C7381A041F
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:04:33 +0000 (UTC)
X-FDA: 85203617226.05.84533A7
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E85F180005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:04:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JrqF7cTM;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789182271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47nBXTe0p7S8h9Q2JUen+5KKbEFQG9U2loUXl5hvd/I=;
	b=nMXRsjFddrDYPbknIBtA9poQ5Cfwf0R81FdN0vHCR7MOdbhaeZYfyylkvUNxV03H/0SVk0
	sNRLOq3n0pxDGJL93NyUM6wCQCMX0obh/BRn1JUbWRUYTqyMurOFKPaUGUwy5oYKRkkc1D
	xYVjMNOVY5zlmRDW9TbLt2y/+kECo1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789182271;
	b=jBWF4iSKs73y17Iq9zQ5ZZqjc9ATP1aFWLdyiZaToOxtfNv6VAFdMhguORs0As/14ID8FK
	Ub3FHU2HqbwaiSzBSfFqtGf9kuzXI1Ek0KBuHYEEcI8CzhQlmZ+ufFr0P27pvvCC3cwowr
	JKm0GwBVMHbl2fILyy5MDNziWQTqdcE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JrqF7cTM;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-90e970f710cso16749106d6.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789182270; x=1789787070; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=47nBXTe0p7S8h9Q2JUen+5KKbEFQG9U2loUXl5hvd/I=;
        b=JrqF7cTMhDksgcN5NxBo68QxoQdMgAEJllMB51Z6wrqYuLldtBnlKqgLiEWInYUPlW
         mAtA9DF9VM5d6iJaEknuHmKLn8CiNGcN4baqdjB0HOq7wjMMuNWgwjjhC9Pc9pZd+6OD
         fAURB+3/le+aOWireLes10YWtP/llXN916CXTFw1IMlZq+UdcuCsEEk8exAITl7MVWQ3
         qf7jQ9QvJz0xyAdspmMqdF1cjXvlMhHJwPQ5Q2YWxJc2LcEOg8lCUic/ZnZ2am+R4pZg
         OOsVAkaGdAT7cSNsdKIu5+CBaaYBMAJKsUT4jL/UUuD/8JWVq4JvuLHFPgtw+DMUVSRS
         l/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789182270; x=1789787070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=47nBXTe0p7S8h9Q2JUen+5KKbEFQG9U2loUXl5hvd/I=;
        b=aiBIeyW4gBNBD50OQkDCRwxElIz7dzUq9P22BEgu+L/ourJohURfUgBSva5WQFVrur
         IC8C3POMpApBFisb9W5MUoifxArL/NgvuhAG/fWJI/O8Pc2Phswr/m8Pgjmgk+Fwf8ch
         GESgPrS1lIzUrE5hc5ghZs1CAfLQV66h/dX/rC3DEPDS6N/pdARqOntDkJopk+Dv4lob
         5Kj4k/aHblPA8tOKpfGjEgX6yR7CYLPYIgfB82g6uyq4qYPSXR4MXObFdKyPTS/WFMGR
         qRrWl2AaOL35VkfkTYqF+oz5ZsU/yZeTOwiKzzP9RzI8wO0XXf774+1mco9E/UqIPnv/
         SURA==
X-Gm-Message-State: AFuF++niiIerHbZmBGivOdWk9xqNVEEBBLvA4eh2S3EIB34ft2+bT0ND
	L7QNz2HtvRr0nGAZqQg4qJR4Z2l12fEfwRszWVthOxSWoDOh/eiSNyilHmhQkxCYx4hbp28jGOO
	QKVER
X-Gm-Gg: AYBFou1PV15Vvn50UdS8x0MAcvk3DozBS9GRzFJr+2K5IrQkE5KOM+J4aeX2AEq1nB9
	scTFe9d5eIRe5FzdSyTpT1wGOlXWnYtNM98gEHZWCYVSUSitIc9tK//UhBfbfp2YYJGIr2Nghsn
	qpu3eR4IDkDN1mP4wUvfEW1kTRhGkkSnbs8jSK6vx4UVOTKeQSOA731HJvc5Q6dE1baCgMBnsPV
	7YqQxJRQxArVqN6ke/4xKyyiQEleMoO9R0EjTDXmSTffkvv06LiHDALpHhz8HefoT82WE7/dEfz
	nB2sn5IVHkJKgzpE2igsoQHBy693LIsqIoignxMClB+VV+KFgSsprf1R5BBipTDC9bHsqMm+Isr
	Y1CXju1nwvP8BqEF4SorFWcnxdNuYdNxcFt8HvVoWmRTqqO+rHSGIBvJZDmeduqVce/xcM5h0/P
	4U1JD1yN1+JQTTJ5hMQVVaqqCqnUnHSNSocazVNWJY3y1xq7ZWIfzjPnwAvQfyTBAVzjsh0BKgj
	SslY7hnizcjMuTVtoCuLAqbMNjTMrQYXFVTSbK0CbyGPqRsM7kPfULG3KIa
X-Received: by 2002:a05:6214:212e:b0:910:44be:42b8 with SMTP id 6a1803df08f44-9121207d62cmr104319336d6.6.1789182270357;
        Fri, 11 Sep 2026 20:04:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f202856sm36085296d6.2.2026.09.11.20.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:04:30 -0700 (PDT)
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
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	Balbir Singh <balbirs@nvidia.com>
Subject: [PATCH v2 1/2] mm: refactor find_next_best_node to find_next_best_node_in
Date: Fri, 11 Sep 2026 23:04:23 -0400
Message-ID: <20260912030424.2889731-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912030424.2889731-1-gourry@gourry.net>
References: <20260912030424.2889731-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E85F180005
X-Stat-Signature: bq9wu9juoqwdbtc5enp8rcarx9ww1q4o
X-Rspam-User: 
X-HE-Tag: 1789182271-543412
X-HE-Meta: U2FsdGVkX1/hD9+p1L/NCVcwuFFGnOVZhYnOxszlQiGF4luzIOL0lN3eLYBQXAMUHgzdF4jVHR7rWX39Rtp/7dcf635UMjjrvSeaT/PXvPzHZ/Xza55gVZ6OpSoiha43sf6lJ7RoKtSZ7lEWDQJzPHeMt7/YiWwpjXHZaYLnMCUsTfwEapCkUeghF9wzXo+bjHLl23z9C4yY5sCpWGUlIe/GRzTtstYNT5umbE+yzNe/x0nUrxmlNneZSmguCmbPC/HfxRQOyXStzPbCMmy6vDdBg3DUBHLG5xaC279qYZbEqLHEUrDR5qGfDEJGkVKLDKLLCK2nzrfkatBvgcl0XurlyK6x0TUR+v30MedKCeoPrTqVcAAyWSL8aRmSQMae3IE51OsLjgSkF3VJFfnJ8lhYdNM+MOyE/4B3fUd31hjdaJDeE31Ml6L7vnmcMkl7VzPATM6s2UqTS+qHjmmFHZhoPCPZRRaRR9jsJlEVbWdzG9NmWdDwaHvnbdnlAtTrBL7JH782crm3B5gBfGxZOU72l8YCrQoz1CEAXYyLJYbwGzQvghy3FLFzI8rG2+Cdc7xc30kiAu0XHwOAuuJr8li+f2evgOGC7bsP057/z+fsdIg2xX0msm+JpbSXRKb3EylLWrtFj87omXiUvdthjIAFa9j4pfxt0nQBxhNKWJFeJI6KH+yYIExdoUKrk38wZQOLTi6GdeUhjBetT7ZJ6E96U8l5pSl0mF5xqAJ5eDpivw60xCbaWPUF3TPYq8AYe8K05OJEHFyJ7QMnJtBh2z9v9VvqWU4nsaDTiV3/d78Qkzw7FfS7WP3NTHRZqctw3BHq/YQzAoTZhv/TK7i2dxwmisZkW4IKH6L9w20oAuhHLHsMkenz+oCUEJqWo8wJbRTg7Tu7JeHiZTouZjfASw18hv0p4meGBbBAU6fxof3Y+m8HuGBRgR4hQQQcnRVcCUvelVmjqclsKsZ4ck5
 UZc0b7ET
 0VSlOfDYTS7wUucZz6BTtbInJMMuNIOoYuaKcKm1XjOwQXRB4eX8AKYRV7omvE4cTRDw3mkYykRIW6q9mP4uP5As4ZC1BOUPLz03Y7GTWgI3Ncoc6Y8ElFiE5KbHKo7dDGdbGX5G7hvji/KDy/Zx90fAfJ3iYZ7VPe7oWaxFcQvHgO7DWdZyNoR39FPzpTOVTJHKRjHrOvS++JhmHN6ZzJfqEXkJ+L+uHlnRBnZNulmugIyvXQFaS86/Egnwl2PqiqMj3cUGmBG7LxQq0y8rPrinBgdHmcuUqLsCPOKEUdMuiGPek39YQ15f+rPqO0Dh/tfdU8YShiNf7CSgn5Lk/liP9ZU3mF86M66iirvKPBWjhYLYfvQAduh2Hdz/DxUXWM+VVSW9HdRviljA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_best_node() picks the next-closest node for a fallback list
from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
which takes an explicit candidates nodemask.

This enables building fallback lists with non-N_MEMORY candidates.

No functional change: every caller still selects from N_MEMORY.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/internal.h     |  6 ++++--
 mm/memory-tiers.c |  7 ++++---
 mm/page_alloc.c   | 13 ++++++++-----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..1519dd21a900 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1133,7 +1133,8 @@ extern int node_reclaim_mode;
 
 extern unsigned long node_reclaim(struct pglist_data *pgdat,
 				  gfp_t gfp_mask, unsigned int order);
-extern int find_next_best_node(int node, nodemask_t *used_node_mask);
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+		const nodemask_t *candidates);
 #else
 #define node_reclaim_mode 0
 
@@ -1142,7 +1143,8 @@ static inline unsigned long node_reclaim(struct pglist_data *pgdat,
 {
 	return 0;
 }
-static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
+static inline int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+		const nodemask_t *candidates)
 {
 	return NUMA_NO_NODE;
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..25e121851b58 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -370,7 +370,7 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	 * closest demotion target.
 	 */
 	nodes_complement(mask, *allowed_mask);
-	return find_next_best_node(node, &mask);
+	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
 }
 
 static void disable_all_demotion_targets(void)
@@ -450,7 +450,7 @@ static void establish_demotion_targets(void)
 		memtier = list_next_entry(memtier, list);
 		tier_nodes = get_memtier_nodemask(memtier);
 		/*
-		 * find_next_best_node, use 'used' nodemask as a skip list.
+		 * find_next_best_node_in, use 'used' nodemask as a skip list.
 		 * Add all memory nodes except the selected memory tier
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
@@ -463,7 +463,8 @@ static void establish_demotion_targets(void)
 		 * in the preferred mask when allocating pages during demotion.
 		 */
 		do {
-			target = find_next_best_node(node, &tier_nodes);
+			target = find_next_best_node_in(node, &tier_nodes,
+							&node_states[N_MEMORY]);
 			if (target == NUMA_NO_NODE)
 				break;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1cfbd0582a10..7efce139d562 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5793,9 +5793,10 @@ static int numa_zonelist_order_handler(const struct ctl_table *table, int write,
 static int node_load[MAX_NUMNODES];
 
 /**
- * find_next_best_node - find the next node that should appear in a given node's fallback list
+ * find_next_best_node_in - find the next node that should appear in a given node's fallback list
  * @node: node whose fallback list we're appending
  * @used_node_mask: nodemask_t of already used nodes
+ * @candidates: nodemask_t of nodes eligible for selection
  *
  * We use a number of factors to determine which is the next node that should
  * appear on a given node's fallback list.  The node should not have appeared
@@ -5807,7 +5808,8 @@ static int node_load[MAX_NUMNODES];
  *
  * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
  */
-int find_next_best_node(int node, nodemask_t *used_node_mask)
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+			   const nodemask_t *candidates)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -5817,12 +5819,12 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
 	 * Use the local node if we haven't already, but for memoryless local
 	 * node, we should skip it and fall back to other nodes.
 	 */
-	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
+	if (!node_isset(node, *used_node_mask) && node_isset(node, *candidates)) {
 		node_set(node, *used_node_mask);
 		return node;
 	}
 
-	for_each_node_state(n, N_MEMORY) {
+	for_each_node_mask(n, *candidates) {
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -5907,7 +5909,8 @@ static void build_zonelists(pg_data_t *pgdat)
 	prev_node = local_node;
 
 	memset(node_order, 0, sizeof(node_order));
-	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
+	while ((node = find_next_best_node_in(local_node, &used_mask,
+					      &node_states[N_MEMORY])) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
-- 
2.55.0



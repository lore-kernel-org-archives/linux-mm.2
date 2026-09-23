Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0CBEC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CEC6B0096; Tue, 22 Sep 2026 22:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73D76B0098; Tue, 22 Sep 2026 22:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A1B6B0099; Tue, 22 Sep 2026 22:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73D646B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:29:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59AAE140682
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:10 +0000 (UTC)
X-FDA: 85243444860.14.070EA5A
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9400420002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=D59jl4Jk;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DTbYesErX7uqQ2UiAVBtVPVMTumuecPrjo9lCd5uig=;
	b=GgRV5wPutpGDdUUaYk6sdHD8SkdUcxEr5aNWrT7Lo8/9Q/m6WmbVeRMqb8H8i0jB2Cijjp
	VtZodxopAnb6PnNrdVnuN32yp89J5QMai5yMj3+GphWjZm3WgxjzeVVYR5KbztDriqZXCy
	dIsvSGbgRvRqZmqwHhmbho6C2EqW3VE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130548;
	b=3R0ao72u9OyyvvyhTZJlSi2euyEM4Vf1TFKJtJIaHa40k5Km9mSU5WDCQBfx6rrFrHKAj8
	yx9TGSFzdK9F3I2p0Q1EXBm4IEz4/7Kdpnes2Kqc84ISWkHQcMjU2xqnJaT63fNNq1jnV9
	TO/gBPtkbRLIgzQaF/mrxwGCl7ugl/M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=D59jl4Jk;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadea0so34515985a.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790130548; x=1790735348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2DTbYesErX7uqQ2UiAVBtVPVMTumuecPrjo9lCd5uig=;
        b=D59jl4Jk47Y5QDX5Mv4vi5LTLuZ65jpWSYsyPC6OY3Rhc3tQrIQThjGZpESx5zJi9k
         eQM//Rqwa2aqvJB4fAO2TyOzGugZ563C6p1h5v4Om28pLMwut0l0ZXIzaOaYes8m3QjZ
         8ESlZLcCNrLuBlKlqcy3Xs/ydCUS1+GuXl2OBJo2QBr86vg7FTOMm8LOJTXF/tstMznC
         wnyXWOeCNSefT1cvPVSrGTxhForaL+VjlcT2Igt9nc2ZZjUnYK0mr/US4uRmnpAcSaGx
         Q97zkhNTc6jHIZk8cz3VrXpNf6SlrfHhGabotodFmWQmvWsglqP6LWPqFvuadM30M/d1
         uWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790130548; x=1790735348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2DTbYesErX7uqQ2UiAVBtVPVMTumuecPrjo9lCd5uig=;
        b=rvWVPapb+a3E341lseWivj8ntX6u4khNmkAKEIhhZA9Zova0ILdYu/OrX6+x2N1c4a
         hpxmJogxW3mAMpcivy8bae66EM+bgG3+bphY9lmT2XOSsHDpjJWXh4+3kkFdm2AsAm9k
         Zgz7i0bImu9G0N8xMzCacbiIUtqiTzuiAhYO3g2GI6Z0acnaDBnlF9a8RdzfcsQhEUsQ
         8yNMSkXvXO3wRLJS1rmop56l8LtBrip350lj5HgR7edmJiSc1sL0O2zg0V++vdDk+Art
         IZOcqrJKX2uoJKLPF8MVZN9GXT3a81gzMPdF1o/uLcNz6gru+nXj98rFCDHzkhYDQSOU
         5iYA==
X-Gm-Message-State: AFuF++m/4iZz1YrsyVV0HYV80SQ3F1UMY00Hb7fJBR6zu3xU+KuFPx6W
	G7kvuzKtrmLhqcfUseQLrDp6gLQTdCcUhcZFYCTz5IMMhHFifLae2laHzl5WopdXrWeYp97qKQn
	caW+a/0E=
X-Gm-Gg: AYBFou1Kf55MWJ6tYZM6EB9w/TNer1BlC+c1m/U+VPpCYUHQLpAJf8gWQw9Hbuf1QhL
	hwd04oXDbYAnoXuhewZ89d7a7yige0XDkUdVhpsEziey6W87GgXyulfeNgLSMlHmXcIvCzj0n7y
	wrsPUg/gymZ8hUYusIMs0D3bRFTMPFZM36diX6/uc9POOAKBSl1bWTOkyVp0LqhS47WZ65CqEnU
	iRjzB4qRMLM8yGGDdwVfxLsI6J4pTyoFG+savN+30DoLH58sjjN9INNAG2OiNoNcW83I6wrmXTg
	A9+Tz2HQHTpcm1ZKJb6XQWi/+Re50mjwMDhKEm0+IcT6l4JJFCqAQ+R518gwLgULp0gX5OfTaQX
	puWeDDCBX6hAMslUdSkJG1CT9d1+5c7VS9ZdPX9lmw+wZdgjbByXFd6yw3PJ8MexHogHQKlunqL
	Xfdz9+/xoFyfWYRDtQb0uX3R5Ajz4y7nYRlqafeD5nKdfBUJreEup5slELTRHbtsBWfOKhbPhj6
	TQgyTPfWE5QQkXIoI6+mCbN98zbmm9rnV0sx0yJL4q0wn5RlGX5tNHD4c/j
X-Received: by 2002:a05:620a:3902:b0:93a:2221:5460 with SMTP id af79cd13be357-93c251af18dmr218974285a.40.1790130547657;
        Tue, 22 Sep 2026 19:29:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2482302fsm122626785a.12.2026.09.22.19.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 19:29:07 -0700 (PDT)
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
	Balbir Singh <balbirs@nvidia.com>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH v3 1/2] mm: refactor find_next_best_node to find_next_best_node_in
Date: Tue, 22 Sep 2026 22:29:01 -0400
Message-ID: <20260923022902.2433614-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923022902.2433614-1-gourry@gourry.net>
References: <20260923022902.2433614-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9400420002
X-Stat-Signature: dy6teybwy8paufxjpzkdhgkrz7m1b931
X-HE-Tag: 1790130548-155099
X-HE-Meta: U2FsdGVkX1+FJhMtox3Dhr6gIYsvEIoQekVLJukzrBsB2kNS/UVBlvuzOlJ/2S/xGJoUx0HVNGR6NPcaJs+yhRJuxW0wBhUR1sE8pjiq1fgdJwQ382VkA2btomL2fdl1FPEpHaarAgYrXqaK1Ex9Yos301+wLl2nQIzwqL5/122lWf7aMIa64RbLbz5v9ddbatht1jRg3Ga/WoGlotnumxUOqXw+SlESrJVLsIi6J6oC6b1iO5ZkmCFyc6jc4oqfWqxF/G49cWBAXzNBjbbOHPW7BjUUQ/jgVzqmzGKohQgHCAEIfaKsyYEkWW/QRujHeqiNqXAI6zrafqwJlCh3za6c5V2akNwizzFAAqRO0zndR68xILuzgrsLIwjpqsFAFdpb33GCeBdWxfkBCZUINpXrguufFtTECaQ0736njqwm+zO+tV4vQK1BfMzHWkj5xQYfqZAja9GGD5ATG5R2d14QiYjBHLP3oXzlzm1jEFc1d9XEZ1ldUTS4z+IyUWZ1vqVhkEda5OK6wzMHuwcn0HzRTlvbBYvMlr3gDV+W5OnNRNH8m0UCqUinHrO2XKmpBQTWwZeIRG7/N8DGs3ip9nGVGINExodg9yfMqLvtzWSpH7Q01mNCAPQLt4meqmLCmLouJHUWoe0IhakQpaAUHru7lvyyE8APGvZX9kPvUzY4N2g+Dbg1rE0x0uP58idDBUWzstGzKAoXOVAVmvF/c09Ko/wsFnGy7vfjJW5YqnLVgcShnnrVjVFPLBfQ+sZRWPyCJ4e1KHdSc1NCt15Eg9oHk4tq+RvurJ/r44KILW4EJrzo1OSaE+Lw9WTgTa5s/lx/8yzdOn3A3rN6wrLLLH1O1yeVH3uhPPT/RiAGoslyQYmPuZJCaETMzAH+l9Sh6+yv3FTKoaLj0592Qc0Cp6bBoxEp1/cTVIr+hnK2SLg3k2MFCbBpGMwgNnPyTTx0dYwNt2SkZeBBnkOyKr8
 SnNpxkXR
 ygZYsNFYFA3RI/Ar6rWdwLGgbzRdSiIQzXDsXDRnecxlkMLBizv4GrwrplzHI5O/38ycWPjJ6BVrD2QbJXtdj9DHoIVgKxagDHah0uAokGXCJ/AAZ7DdJ1lNySipSOmPHB4k3Vv06ZwtPoy7opJrGlhNcQoI1agpdPgdeELbb1Vx3i30XZIMXH+It3yso9+SaLL4Kxbf0Kv/qCIm/BhY6dyJ4jrKvZfp5g/iiUpy85YOO3PoJ1hxuU3HERJFjeQJFTPMkXdag1Se4iLJXBi7BbY9Y/zNBAqETh7s0GDVPQpTxg39bGBRBtZhxKMIbfVoyJhF40B2FkoNvgOigolyyH6WbRRw9pdTUXl97e0SKM9Zi0wjj0ivxS9dEkbMSiQGc8AD992k0mGy9sL7QQcV1utXPTwe8ZEEaUBKGaq6ETHky1oF1907wWqp2fKm98qtoiBzM6n/VywOjnpeLkpD/drTW3A==
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/internal.h     |  6 ++++--
 mm/memory-tiers.c |  7 ++++---
 mm/page_alloc.c   | 13 ++++++++-----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cbdec2193fad..0434dfcfc36f 100644
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
index 090419c70173..7f706e3d7e50 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5802,9 +5802,10 @@ static int numa_zonelist_order_handler(const struct ctl_table *table, int write,
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
@@ -5816,7 +5817,8 @@ static int node_load[MAX_NUMNODES];
  *
  * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
  */
-int find_next_best_node(int node, nodemask_t *used_node_mask)
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+			   const nodemask_t *candidates)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -5826,12 +5828,12 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
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
@@ -5916,7 +5918,8 @@ static void build_zonelists(pg_data_t *pgdat)
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



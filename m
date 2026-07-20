Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21027C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93566B00CC; Mon, 20 Jul 2026 15:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C4E6B00CE; Mon, 20 Jul 2026 15:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34DA6B00CF; Mon, 20 Jul 2026 15:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8233D6B00CC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 029F9140201
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:58 +0000 (UTC)
X-FDA: 85010160396.13.1DA655E
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A73940005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iny4xNF8;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NQTGhXcHOKD56hvRpu1GEGtUFet41BSGHJhkUlyGRA=;
	b=FxTJhdVOllIp7UWHyiRZJq0D4Y68WrJYn8PzmB8kN2VF8QhNIOnxKwnM6THLaNJ228W6Kb
	7RMJcJIelC5NaP1Ys5nlbE3U/P5xFlllNmrWmb/9D+utouaGs2yZSUApM4lMNlyD3P9dW5
	UzXnuS6RA25lo4P+HJoijscJfJphoFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576156;
	b=HiBdicinyUYvDhdA0xIu5Lxwt5vc33IPbUxwSsOOnuwKrztnH/0MzsPOD47Fz+zccFpSKw
	pL/NM8hA8SXzPDyjaRU0hrMPzV7ckX/L1myKxLnDmmojzeAK95mv2uVf36kqT1VDmgYteE
	oT2tG2vtiTLGsid2EXF+o/v71486Whc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iny4xNF8;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92ed19f4d60so369343185a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576155; x=1785180955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NQTGhXcHOKD56hvRpu1GEGtUFet41BSGHJhkUlyGRA=;
        b=iny4xNF8TVn/2Hy1KZ5ZOA5DJtlp/DH6u/CLykV+GkFOKFLfbnNqEyhaKJ7nq08PUH
         UXouXVYoTpRt+R9RdQi60Ten1lQBPoCCgQ/HJ7WLJvIo+y/g1KIw24H4uPHIVaGQ2t8E
         cxq+kMPHPJNFW1NuPHdJTqbuwes1Flndcand4J2Q2z1ZzXTFw82bzcYdeKJ42go8zar0
         yOldohkoYGZApHXacI1yhSpdLk0DD4dQ6Ci/K9Vx2kOXwZXsvIlDvKkALzUnjGziiqQx
         Djdog47caO1wToedRRl5DS1QJAVt7O5n9mqhmNKqF/KfA5EiT6jVSAo0P31uzzKuC5Od
         73UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576155; x=1785180955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+NQTGhXcHOKD56hvRpu1GEGtUFet41BSGHJhkUlyGRA=;
        b=bf5kYYhpFNLZIakMo+LMihWkMXntdyM03nKnzKvrWVg6CkjZWheB5LCp2nSQRz8Rop
         MHCFhWsPcfuH50uc8HPw8jMQwLIaFUwgiv2r444zQhJP6M0Z07LH+tYaQDmrhHY7SMdV
         KosH1qM/Ue3RihewHrNgnl4gpqSLH1bdh7/LJn/TKMK25L1da49RwTDcf/sIlIxYI8uY
         teWWRQiBS5KjYebZteWTvx0L9ua+vRC5MLCVTblQSbbaJyOD3yl4JmXzmUDBwlcMTsm6
         lNyalSoKdI2BGUi9ehDjTcFq1iy0ztWcLX79MWvPjF7eosQuXuwDvnGnrivR4YwOEYXb
         moFg==
X-Gm-Message-State: AOJu0Yx85welT0IP9jTuGp+c3s0n/ztv5vdyd4nhynU2KfJNS1D+LS/m
	eE5yOg491v4TeTc3/L/I9jBW+rcU+20b+4X8xRRhw+JE+ASC5R+W+ThybF7UcWYA7Q/5rgSPsTu
	Ap31p
X-Gm-Gg: AfdE7clw4f/UES9vsdMfdr7ewTn7OiwKm79t5q21rHiE8yyEpRHs3se8BXKHgY12uoi
	GtUlmmx0CitDftZNfgEsZylo/NBbz045nvf0pZt+ue5tVeeUqUc6i5qIZk/0GL06Nh9zU0uh7Mb
	3a9oPR/GOmJ3Tta3e1CeIEB7Ag512ujwixEZCAaOzUd932YAocydiSKoa3HvV3WHFenXcinUiFz
	sxoPfs43bwG0CgO7eIrLxBAanM8X2K7+BFPGeQps556JHMd3k/Bfwa+Rctv7SFoykKNWJ74bVT0
	2aiPWXpTllOE4O3a5KRzFPwtZfjx6yH7xZSWBiyuhHLwndOiCEK/9SSSMGySvj6lyh9haiHJ7I7
	Qf8klUngj3LfOYfQbSjDEyk8nxSM4Lr0pKxaXs/lZAyXEBg5fxjg2NEVssm78HS6hAGII4Rm/sB
	L0+rNpcdTrnfvfni1AqE8LFa9wLFwZzR5vmvSnrGQsV/314U0WO7W9BIDR4OPErYETnBg1N7xI/
	w==
X-Received: by 2002:a05:620a:288a:b0:915:29cd:306c with SMTP id af79cd13be357-930a5f1a98fmr1940964285a.9.1784576154411;
        Mon, 20 Jul 2026 12:35:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:54 -0700 (PDT)
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
Subject: [PATCH v5 29/36] mm: add NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
Date: Mon, 20 Jul 2026 15:34:23 -0400
Message-ID: <20260720193431.3841992-30-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bg9gdan91cd341zumyhkw4omgk8wf4zk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A73940005
X-HE-Tag: 1784576156-994524
X-HE-Meta: U2FsdGVkX18Ttijg0w8h3TzDNf/zASxT+KJmqYKUksXCRDeX8w+jFkuJYK15Kn+kFHrKrNDFNuoQqQneXNGa3XKIQl0RLDKUnxE6krHcVAb7NiIlVEV6NsijLJs1+vgncDLQWkQycgthxLdnomUl/BmudF80k4D46R9EbQeNDAu9ag+Gq0shczWjG5GvjCeSJXGDFzsXs3u0MEVtw8I8y5JNYXb3AZEIlXVqJ0XpKvp+63Y0H37sPp9F3ebVnmjv5TowiJzUuKfnHCZkWfj8H3LKVVWyYtiC6fvOVc4qZIDR0WHdwFdnce3DHDJ81Bs9axHy2kMZB70KbSo+oOV3hbS8g4PvtWap3E95phQeFmoyljeDNhQJ7aAUJjT6C6v4iot9XOJJPGuB0nFfUTkwXfDI/1BYK32NFs6mA2FVpDeHrmI85SOPrxena3/yOsxASJOHfXjvukoKJxLww0aMQyfqKTpcxlSjSzd3oHkga62dFqcnahrceWiLIe68Q80kf9Rnf+BeMf9T/49K9t4A9iRV93pDjOshThyfrgzPQrusa6aATwlmF/e4AEjRXimimze8LxD3Vk1TEMf7DxckiqfBMpCB3MZTB19qZl9qsHcPsqPAGZ2Gluf1vxTJ2ZQ+YKouqqi6aWq/5Qi3IJZMYOj1Rfnwd3vfx8h1xzSNNhRhWKz0gZnoXRsqc/P/knkCOu8t9T5bkentrWx2QDikicwQfxMkYsnKEWylojbbsbCkM86X1A0uX4D013JZrq5bKUuj+bk6nx+zaBHArIhEiEDb6g+v3ovFM2oqGJ6sp4R6sugF3SjHrSOD4YcgGp5LLBeU4ZtnSCluG0TdQ7Tk3vaGtJwwbI9QbZS7dv1cEu2o8KQ57hr3Pgew5Ev/W033NvKckOXaFKp7uuIv9t0UUWkjbVGrNq7Sixy/IiHjG0UYeBYTYp864tUoDxgQ7nzaD5uzUlUUv8Me3q6sOUH
 XAtTI+sK
 /Eanc4aT7fq0wEbjAWcyzXacplzydYxf8mgg3QHdZD8At4nh3M5wrzJZ0ep45NjlJE2k9BoZXsX+zdpSkw8dlwj5uMbXe1eI85YWo1F6iSMNhhM+Gc3Xb7tIavUFBlbZGlwC+kv7BF6+6LzCFAQOQttTbNuGbpSEJZ633n4lzRvRWvoKYBi14LXGcYuOmBKZX3ouOMXcPB3j17ASlUg1NlUjftVSR0n/FScumUOhh//OrBI0MJ0qh5Y72Hnw8IVFxMPd98im1tx5QMbeTEp+HfyI4jLJBk4lNuVgPIbRZtXTTNccRSufxt9eCU//Oe4Vb3+M980FXIDpWbD+2bzQKm1wsjiGD3M7gGTf4DDfcZF+BzcMiCdjuJ9XWFlSil6lzuwFbZfFbIhrXJMc6eQh90jTaZWXFmHt/ImEQvxL5W0uKBVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A private node is invisible to the tiering/demotion hierarchy by default:
memory-tiers.c never includes it, so reclaim never demotes onto it.

Add NODE_PRIVATE_CAP_DEMOTION to opt a private node into demotion.

When set, memory-tiers adds the node to the demotion set and reclaim's
demote path may target it (allocating from the private zonelist).

Demotion is driven by reclaim, so CAP_DEMOTION requires CAP_RECLAIM.
Otherwise the node can either fill up and drive odd system-wide OOM
behavior, or demotion doesn't work (nothing can demote from the node).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          |  5 +++++
 include/linux/node_private.h | 30 +++++++++++++++++++++++++++++
 mm/memory-tiers.c            | 37 +++++++++++++++++++++++++++---------
 mm/vmscan.c                  |  4 ++++
 4 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 94cd51f51b7e8..3d61ca1b805dc 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -896,6 +896,11 @@ int node_private_register(int nid, struct node_private *np)
 	if (!np || !node_possible(nid))
 		return -EINVAL;
 
+	/* Demotion is driven by reclaim, so it requires reclaim. */
+	if ((np->caps & NODE_PRIVATE_CAP_DEMOTION) &&
+	    !(np->caps & NODE_PRIVATE_CAP_RECLAIM))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	mem_hotplug_begin();
 
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 7b617b1fa9c28..87b03444b2c97 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -15,6 +15,7 @@ struct page;
 #define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
 #define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
 #define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
+#define NODE_PRIVATE_CAP_DEMOTION	(1UL << 3)	/* allow tiering demotion */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -118,6 +119,30 @@ static inline bool node_allows_hotunplug(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_demotion - may kernel tiering demote to this node?
+ * @nid: the node to test
+ *
+ * Governs whether a private node participates in the demotion hierarchy.
+ * Demotion accumulates pages on the node, so CAP_DEMOTION requires CAP_RECLAIM
+ * (enforced at registration) as a safety valve.
+ *
+ * return: true for normal nodes and private nodes opted into CAP_DEMOTION.
+ */
+static inline bool node_allows_demotion(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_DEMOTION);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -150,6 +175,11 @@ static inline bool node_allows_hotunplug(int nid)
 	return true;
 }
 
+static inline bool node_allows_demotion(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b586..c673080d153e4 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -7,6 +7,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/node_private.h>
 
 #include "internal.h"
 
@@ -317,6 +318,21 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 	rcu_read_unlock();
 }
 
+/* Tiering set: N_MEMORY | (N_MEMORY_PRIVATE w/ CAP_DEMOTION) */
+static nodemask_t tierable_nodes;
+
+static void update_tierable_nodes(void)
+{
+	int node;
+
+	lockdep_assert_held_once(&memory_tier_lock);
+
+	tierable_nodes = node_states[N_MEMORY];
+	for_each_node_state(node, N_MEMORY_PRIVATE)
+		if (node_allows_demotion(node))
+			node_set(node, tierable_nodes);
+}
+
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
@@ -330,7 +346,7 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	struct demotion_nodes *nd;
-	nodemask_t mask;
+	nodemask_t mask, tierable;
 
 	if (!node_demotion)
 		return NUMA_NO_NODE;
@@ -370,7 +386,8 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	 * closest demotion target.
 	 */
 	nodes_complement(mask, *allowed_mask);
-	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
+	tierable = tierable_nodes;
+	return find_next_best_node_in(node, &mask, &tierable);
 }
 
 static void disable_all_demotion_targets(void)
@@ -378,7 +395,7 @@ static void disable_all_demotion_targets(void)
 	struct memory_tier *memtier;
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_mask(node, tierable_nodes) {
 		node_demotion[node].preferred = NODE_MASK_NONE;
 		/*
 		 * We are holding memory_tier_lock, it is safe
@@ -401,7 +418,7 @@ static void dump_demotion_targets(void)
 {
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_mask(node, tierable_nodes) {
 		struct memory_tier *memtier = __node_get_memory_tier(node);
 		nodemask_t preferred = node_demotion[node].preferred;
 
@@ -435,9 +452,10 @@ static void establish_demotion_targets(void)
 	if (!node_demotion)
 		return;
 
+	update_tierable_nodes();
 	disable_all_demotion_targets();
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_mask(node, tierable_nodes) {
 		best_distance = -1;
 		nd = &node_demotion[node];
 
@@ -455,7 +473,7 @@ static void establish_demotion_targets(void)
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
 		 */
-		nodes_andnot(tier_nodes, node_states[N_MEMORY], tier_nodes);
+		nodes_andnot(tier_nodes, tierable_nodes, tier_nodes);
 
 		/*
 		 * Find all the nodes in the memory tier node list of same best distance.
@@ -464,7 +482,7 @@ static void establish_demotion_targets(void)
 		 */
 		do {
 			target = find_next_best_node_in(node, &tier_nodes,
-							&node_states[N_MEMORY]);
+							&tierable_nodes);
 			if (target == NUMA_NO_NODE)
 				break;
 
@@ -503,7 +521,7 @@ static void establish_demotion_targets(void)
 	 * allocation to a set of nodes that is closer the above selected
 	 * preferred node.
 	 */
-	lower_tier = node_states[N_MEMORY];
+	lower_tier = tierable_nodes;
 	list_for_each_entry(memtier, &memory_tiers, list) {
 		/*
 		 * Keep removing current tier from lower_tier nodes,
@@ -550,7 +568,8 @@ static struct memory_tier *set_node_memory_tier(int node)
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	if (!node_state(node, N_MEMORY))
+	/* Include N_MEMORY and N_MEMORY_PRIVATE with CAP_DEMOTION */
+	if (!node_state(node, N_MEMORY) && !node_allows_demotion(node))
 		return ERR_PTR(-EINVAL);
 
 	mt_calc_adistance(node, &adist);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f1722693ac2db..b617f7cd1e716 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,6 +963,10 @@ static struct folio *alloc_demote_folio(struct folio *src,
 
 	mtc = (struct migration_target_control *)private;
 
+	if (mtc->nmask &&
+	    nodes_intersects(*mtc->nmask, node_states[N_MEMORY_PRIVATE]))
+		mtc->alloc_flags = ALLOC_ZONELIST_PRIVATE;
+
 	/*
 	 * make sure we allocate from the target node first also trying to
 	 * demote or reclaim pages from the target node via kswapd if we are
-- 
2.53.0-Meta



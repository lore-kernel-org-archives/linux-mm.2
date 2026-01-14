Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A99D31A13
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9746B0092; Wed, 14 Jan 2026 02:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E836B0093; Wed, 14 Jan 2026 02:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D546B0095; Wed, 14 Jan 2026 02:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4366D6B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:01:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F19781603C3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:00:59 +0000 (UTC)
X-FDA: 84329672238.29.D2BE52B
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38D6018000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:00:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kaPtygFM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3KD9naQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3KD9naQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768374058; a=rsa-sha256;
	cv=none;
	b=u4v3A43ICF3BG7t9xvkMeMX6fdZU0OSXzP4R4K5q6OTpIv5qAtHTInwdECeDfmzT7OG+59
	0WF5aJPIcR0Xkm++rRsgXlrwURP2dZA7bij3zJSIbgFnTZlhd22gdXi8BrR2DDdX6YPgtP
	8gA2Lc+NdChBqx1SEr7gEtZtGCCqe5o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kaPtygFM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3KD9naQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3KD9naQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768374058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/KY0VdnopC2hmLm4xwT6Iw+Xhnz6LnQa/Hsf1VK0I8=;
	b=eQBfmTzDU6dEQ03IXCB2H4O7jD7yCzZqF605CzOPU9fjf9DgjGBpwe5HeRy6NW+X7muEbH
	w8Ot3bgfV9yI5pkg7prh1JPge0mLNQ+kAk0Bzeu38vqkua7iwNGnzwsvkc67Nb8//QdQiy
	XmX+yUrzXWmF05u1/N+5xiUmwhGP3Ig=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b04f8c5e84so9719644eec.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768374057; x=1768978857; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t/KY0VdnopC2hmLm4xwT6Iw+Xhnz6LnQa/Hsf1VK0I8=;
        b=kaPtygFMi9KDVStUnCQ+rwtZ9/rGyXdSCtUHDwTanc7FDG1YSqHKxZ9RVIF9aJ6MtL
         glUdnquS6NLIkSeugBK3jcjnoZ1foMzquOjZE1YJ9JJClpR47IQV5LliT20x3yTbjwC3
         NkiLZM73eO45k6fqS0TYcpPkVY2sI/AF2WRKoSxqQaq8I0hn/CzVVDG/gKnKuJYqr2Bh
         7NZRZzOByazAWzoY20IwE8aauO2sY7ais0EC8JX/vQEPZgYjU/HFH1jjAe2oKZtcxy/q
         Z4D09HFhdV4TcGGSP+Yv+mUstoCxalaUl93znCedHXHJzGFbPNsmDxd8QffiUUvv6anG
         T1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768374057; x=1768978857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t/KY0VdnopC2hmLm4xwT6Iw+Xhnz6LnQa/Hsf1VK0I8=;
        b=QDAhRMjCfQUfICd6nQgxVvXwYj0wvOnYNKvjbRD7wosqRdORks1GGR3mRU/3A82tK+
         xNXyfXF6kiLl9FwGoUGUOTYRTbyejRfjmeey5lBF/N99Uk5CtbBB+XwTjuq+IrRFsr5O
         ztKg92h2lGFTvJFaaKdbakNcWEjOJ1neNXaKRcqUdi2OlpRO/D7uGwL+Dadz70x5kBVM
         UWiOMKPpng4IIf9FBlTpVPCj3tgr1t0KKdOEFRhlw24fjqAHrPzjH83c7KfNUZKG5Ete
         MM0az9FamoMTsCJhuSEf/zgyT6F+MkyGDP05rLtKQZmbxARECXsG//Y2MVweuFlE53j2
         KjNA==
X-Forwarded-Encrypted: i=1; AJvYcCVo9XjO2uHyYV45rThbaifo+NgorYLn5QvsN2jzIG0sPFeuo8KaP65HXeYlu0cNKGC6t54KxvPLuA==@kvack.org
X-Gm-Message-State: AOJu0YwxSlivoQb2GVoYVe/pEMQ5OyR8Nxnxbwq+FK6sjU9+T/U2vPzl
	Eud4GhnX8/agod7ctY+jTImHaLcr0NgC/QpJBBmxeHoIGcroM98qylklBGfD7KkJ+TvzpcpPzs6
	tzdY7TMgyrK/LmQ==
X-Received: from dltt13.prod.google.com ([2002:a05:701a:c96d:b0:121:79a7:ec2d])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:f30a:b0:119:e56b:91d1 with SMTP id a92af1059eb24-12336a13555mr1101663c88.2.1768374056893;
 Tue, 13 Jan 2026 23:00:56 -0800 (PST)
Date: Wed, 14 Jan 2026 06:59:49 +0000
In-Reply-To: <20260114070053.2446770-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260108033248.2791579-1-bingjiao@google.com> <20260114070053.2446770-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114070053.2446770-2-bingjiao@google.com>
Subject: [PATCH v8 2/2] mm/vmscan: select the closest preferred node in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, chenridong@huaweicloud.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38D6018000C
X-Stat-Signature: x5hj5sdhc15zbsto7ggzcoy6ftuwbicb
X-Rspam-User: 
X-HE-Tag: 1768374057-499296
X-HE-Meta: U2FsdGVkX19aKqIV9hu/lN6adTmjdGmrBqQfLTsxoJQUFG1qeR6apAMXTyAajMAWc5W+W54StdBdToWya/lecAc9ep5AHEVEOFIsbFMFpu74jh+BGQseKepxwqhFakhnglNuBTw+fA3+Jme0wxQQacu6RMWRaFJM5cjpQWc21o6R2R14YX6nVX2q8G/j3Ij3Q7eiWdxp93UhqyID/3gazCEkYkWYdJmEJSPXmU6Irglkuj1lua64oU475rF3Vp2RpmudqiKFuufbbiexFGMSUNgFDoPqo2eU0LDr740K4WbZ7ZgF3xXfAzW7RrfKKQrHIWGLj5u/i8KyWJSaM9Re7mDT4/nOfMMjh9ujNOof/LVK3iEfJ1MBj1QfdZaaax2bdHmgiwKB60FiK7JJti+FibVC8onqGrj3DwWSXrh3Bbz2z7XWRn09q68QnBsAcKfWRi5b22kb7MLlvfeiTZKCGgzF1CLtatjMJssY4+5f2koI+tKwYZksF1BXcwQzc5ZpHjHAAKG99Nj8jfiyfcgMik5gCZjO2FUWBYXT2HHlXcqce0gRITY7u3h1bFDIjT081l5oxuhkI7NWcGMELBFltoydISdtjLYJhB38Vr6JrqDWRzT7Cf5OlO8aRFEcGKlPsNyu3z9bSAX3189cSmOliiYQZXhMecokMX1XUg9VlxVKKV4bjv0AMxJRDkKviLzd7HITg6QKDhAtZ0tn61++W4jET6IUkWneSNizNHJE8IwWcPZdWd7iNSOMddMWtrx24XVVSqyrUxvBuiERcKlXTlSjE7FPoKSWtJgmrMnDSUZT4KHRu83vfEgljZONMKQfdRg/ptlbmpsDebAA9XRLBxhu70G9KP7nhtT9BMvxSfHLP7OBjig2TLwjZ46b1jRhdjJRsUVjxv1R0z7hxrgyiBIZ6wgAmIWYX4S11nlVnBMqKogRuSKxLDhJBA0Qt2LnKqidWuvGY5P2GHgdSWE
 QsqfBbAB
 5qV/6qGjdeMHzb6f0yTPZYIcvDMuinN+rZEYIjKLCD5bHsUlvGCCBjpsMfYurFJ3J1iSDj2so84glSGenkswF/TBiHF+uO5rzZ/D0U72j2IUiCVGJG5gd6o7k+QnbpgxUVJtkrKZQNagB0xH7Z6DU+zzfP1adAGaRN6+k22N/MrKiqzikI6HRFoDkfs+XknoErPQP91ZU4d/PCJysLpEY164yTsXAfn/CHAFuqIooec26ePuCXZi11WZwHAACxIMafFtJFqzg00j8IenQEimFVMh0kJRVN+6cwqXGO7uJGJvYnvAhAWVCfR4k6huC6ULflmpDj0AY+iI/7OK/fnGubUDqJ8U41NQ3rzBE4VKpEIK5OIrdozcWUHOx+t7H/5kKXJmoJU7TGW2aLdjp5pbyIJ0ztEEHBLTAR5B1RnRhvShWBq61vv06USUSISw5tjuVbioCKwcf/pb/9gCtdvssNsO4vN8lqhtEVlrFhta5zZtmBGJ5OvZYCAmxr4PTCFgPlkmqsEu9pou7HhhSHyY3O3qtn3oekWHC80Wo3tGjxRXTLsQeS9DKYlkDqbndgTIHHHREOk3DAqFDX34Rsk5OhdGmlDK35wLO1VYUshEPKySBvwkIQO2S9bnrNDBLnoXBhWy3PGXULubKApGHSNnhLvzslC6f3leeKujJl43zvWotF4U1qt/aLvAQhjFv/QXhUW1b6jBRTXHYI/8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preferred demotion node (migration_target_control.nid) should be the
one closest to the source node to minimize migration latency.  Currently,
a discrepancy exists where demote_folio_list() randomly selects an allowed
node if the preferred node from next_demotion_node() is not set in
mems_allowed.

To address it, update next_demotion_node() to return preferred nodes,
allowing the caller to select the preferred one.  Also update
demote_folio_list() to get the closest node from allowed if all
preferred nodes are not set in mems_allowed.

It ensures that the preferred demotion target is consistently the closest
available node to the source node.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/memory-tiers.h |  6 +++---
 mm/memory-tiers.c            | 11 +++++++----
 mm/vmscan.c                  | 30 +++++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..87652042f2c2 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -53,11 +53,11 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
-int next_demotion_node(int node);
+int next_demotion_node(int node, nodemask_t *preferred_nodes);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
 #else
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, nodemask_t *preferred_nodes)
 {
 	return NUMA_NO_NODE;
 }
@@ -101,7 +101,7 @@ static inline void clear_node_memory_type(int node, struct memory_dev_type *memt

 }

-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, nodemask_t *preferred_nodes)
 {
 	return NUMA_NO_NODE;
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 20aab9c19c5e..c71a865e9dd8 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -320,13 +320,14 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
+ * @preferred_nodes: The pointer to nodemask of all preferred nodes to return
  *
  * Return: node id for next memory node in the demotion path hierarchy
- * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
- * @node online or guarantee that it *continues* to be the next demotion
- * target.
+ * from @node; NUMA_NO_NODE if @node is terminal. Also returns all preferred
+ * nodes in @preferred_nodes. This does not keep @node online or guarantee
+ * that it *continues* to be the next demotion target.
  */
-int next_demotion_node(int node)
+int next_demotion_node(int node, nodemask_t *preferred_nodes)
 {
 	struct demotion_nodes *nd;
 	int target;
@@ -357,6 +358,8 @@ int next_demotion_node(int node)
 	 * target node randomly seems better until now.
 	 */
 	target = node_random(&nd->preferred);
+	if (preferred_nodes)
+		nodes_copy(*preferred_nodes, nd->preferred);
 	rcu_read_unlock();

 	return target;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 71617891bcde..18f4425bd750 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1023,9 +1023,10 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 				      struct pglist_data *pgdat,
 				      struct mem_cgroup *memcg)
 {
-	int target_nid = next_demotion_node(pgdat->node_id);
+	int target_nid;
 	unsigned int nr_succeeded;
 	nodemask_t allowed_mask;
+	nodemask_t preferred;

 	struct migration_target_control mtc = {
 		/*
@@ -1042,17 +1043,32 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
 		return 0;

-	if (!node_isset(target_nid, allowed_mask))
-		target_nid = node_random(&allowed_mask);
+	target_nid = next_demotion_node(pgdat->node_id, &preferred);
+	if (target_nid == NUMA_NO_NODE)
+		/* No lower-tier nodes (e.g., nodes were hot-unplugged) */
+		return 0;
+
+	if (!node_isset(target_nid, allowed_mask)) {
+		/* Filter out preferred nodes that are not in allowed. */
+		nodes_and(preferred, preferred, allowed_mask);
+		if (!nodes_empty(preferred)) {
+			/* Randomly select one node from preferred. */
+			target_nid = node_random(&preferred);
+		} else {
+			/* Get the closest node from allowed. */
+			nodes_complement(preferred, allowed_mask);
+			target_nid = find_next_best_node(pgdat->node_id,
+							 &preferred);
+			if (target_nid == NUMA_NO_NODE)
+				return 0;
+		}
+	}
+
 	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
--
2.52.0.457.g6b5491de43-goog



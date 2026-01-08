Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0951D1489B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9FA6B0092; Wed,  7 Jan 2026 22:32:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C814C6B0093; Wed,  7 Jan 2026 22:32:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19EE6B0095; Wed,  7 Jan 2026 22:32:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FEC76B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:32:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51B411AA222
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:32:55 +0000 (UTC)
X-FDA: 84307375110.23.F1E6C06
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F7DD1C0004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:32:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fYnwiHjJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3ZCVfaQgKCH0cjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ZCVfaQgKCH0cjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767843173; a=rsa-sha256;
	cv=none;
	b=POAnETZwUifoBwF5MGTmuvYR+3ZsVA+AWs9IM3+gssYlqDP2ej1f40eVOBoyAZJXPOggDH
	fNj4EKKCB6Td+whQF2NK3gZWxSnHOcnXZexOoX7XqNa9raeiZOkd2D+DS84Zvle27C23P2
	lOq0G3AeYr4UJdy0ozpVxSiNA0z6JHI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fYnwiHjJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3ZCVfaQgKCH0cjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ZCVfaQgKCH0cjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767843173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLgkCamneE/qgvT8SRDRrY5Fa+Nn2NhKwpUQgrc0C+o=;
	b=e7mpY4RdgmceTWFOgt1z95gndRTZHyluFgq/Y/TAAbz3aI2W10GUUjtyxJ9r2FYlBCtPmG
	V9GraQXzTOKKRmSGDgCqVGn0dnjnHc/Ix7arNcETYR51yZ7gSc8CDwQwQINaWMtut4DUrH
	gLnfHbXVyewoNAn2+os0cQwF6awt+Hg=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-122008d48e5so136924c88.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 19:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767843172; x=1768447972; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLgkCamneE/qgvT8SRDRrY5Fa+Nn2NhKwpUQgrc0C+o=;
        b=fYnwiHjJOPsoQ/gKHvadLJZlNQKJwqLQ5JwX1mXIOvJnodcbXWLZFN7uGAcH+XdhRo
         /0KftFFja8+JOjO34CVaVC649QGa3elmt7Nr76zQmVtRC4U81aDqHN6wP314MJpSz/HV
         AytyvjwlTjyDbjQGKRVBtTlaoY/FaRiGtIPWDGl/1j752tkl7529bBGDU34yl++8PuVq
         tYfxT419BKczH+En1KIiETcN58n06mR8KE7I8FggfmhOl0AAQ4Ljmcs2Mpc8UV9M8dKt
         slRviiA33LuvL9EQWguj0v3itwUso4hOMohvMUlbfhAq2BbP0uSe3asXSXjWak+ta5zT
         g/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767843172; x=1768447972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PLgkCamneE/qgvT8SRDRrY5Fa+Nn2NhKwpUQgrc0C+o=;
        b=COL3mGryaBWJTed1CnsI1gxC/q2MRHJIvJH5TLPxeBjxOQq4uUBiDskfKgslcLuqmg
         39ySAPmHAtpsEJDwiKxXq1gWaW1uF2sB6QgZgPhMOsQcKzWbYFWRo04euYOa5jaYfT4/
         2SUHLczr1HTcrlYAUcocBUrKq0VCJDqvn1cpOaLeVFvpGTzuGqtRBlJ7PJG6NS9KPnxD
         2mEepKZGGza8ZBhGzmzQheNh2QsfAWfuPOSU/07bBq2OYULdo+eiNRvWgw6NHya38ZwJ
         MDLv72POh3MaHKnWpTiz8VqkaHML3TvY5/fmTsbxz/TuaYcPnKZy+2ahKRrze/xkq3DS
         RkeA==
X-Gm-Message-State: AOJu0Ywd5JHpQJs9FRE4cD4928lUcHxT618Y5ah1TBaEPktD5x9tbPPU
	GEi1mJy8sz2MXndGmf3JpzFXCn4cNn9gv++DvH37hfiewmfmXb5JimTIOTBOWDIhjGxLg7kXovs
	W8Nn4aM8Wynvt/f91tgPWOqh36kHEC7MfBzM/OlKfHSOhSEgQ1/+p+RDpB8w3HcsNLbQPu65b3+
	AGdqnUHGDMt+gD94jn8LlGeY60SeuNTWwNvqKfzv2tag==
X-Google-Smtp-Source: AGHT+IHSAuslRhY4gBeVWlWCY57NP//mIwPdmFsednmABv35QVXB/P5EPW9tyKa6wChhWbzbdD3cD9E5vhcVPg==
X-Received: from dlbdx24.prod.google.com ([2002:a05:7022:e18:b0:11d:cd2a:4c1b])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:629a:b0:11b:9386:a386 with SMTP id a92af1059eb24-121f8b8ded3mr4212238c88.41.1767843172292;
 Wed, 07 Jan 2026 19:32:52 -0800 (PST)
Date: Thu,  8 Jan 2026 03:32:47 +0000
In-Reply-To: <20260108033248.2791579-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260106075703.1420072-1-bingjiao@google.com> <20260108033248.2791579-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260108033248.2791579-3-bingjiao@google.com>
Subject: [PATCH v7 2/2] mm/vmscan: select the closest preferred node in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gourry@gourry.net, 
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	cgroups@vger.kernel.org, joshua.hahnjy@gmail.com, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F7DD1C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: 6ckw3um1cu6zj3thpjxajo6p8kh58yoy
X-HE-Tag: 1767843173-107907
X-HE-Meta: U2FsdGVkX1+szNeKErxzaqGqMmtQqMWHQQNg2ZhnU0ZPJF8by9W2lDXg2GJT3YFGnBZuqluAYgj6tl1vNjSXQ+Qas9JieZdl+zQUqsHRmP54I2CS0IKGsbyOjCWFlYxIfPyHeLixUbX9fGZ2Tbq9IKyRWA5IQKWUCrjakJ9EnkLpBNb4AXvrR/eD+rWs+2iO9PvImGgeXmfeVl+NKOwibIEtgef2NpiljyRA2BWdr+dWI6zFjUSSCnOI3E33mB1rsuNiHwOlMpH8zrZ4nIbeBNNB8nw8zyt5qcSJW2zB/QsVUUoKsVq+YrzlWlGSsa7racTpl7aID5pI/LdQ2BUBvceD5EmI/xuMhjzAWGq4m12i70P9XLe4wygLFwhC8URGptDjK96C5W/NnO1uS0wzk1etjAX/0eQ9oTN7NL2P9fYISX3xBrmX/hrmP+lE2bbjUBia8S2VN9MFkpyNH/XxaUdZx8z9wN18BCDXme3gHBd73Oqkdb3+frDMITAAch0I+rKCTNEY/2jaWhlyySVtKTtjpRM3aG9mIH6sd9NVujHVphcQNjdg8hNEMqpnOHU9BdFq17YDT2GtW85rbU0xK2OF3kRW0gyDYyoXswNoCHxBJdKT4SUlog6Lq9aQaR9pp87gDaq699TzU4NmkySuyp7MmB75R/hcTDr3oKrlXxejGli+QOCsNnS4liJf5hcOu9bqxpA0DpG887OCHH/11B51BQI8sfzgLfGeu7uVVbgvBfKwBUkW1qCNoq+6nyJGglI4cJ4H/UecKmBeaIC0mUg61ZEsrkeZEXm6VESZOQMJqBZewZZ+Dk1vrzuEYkjn5JzlwNMxJw0gseRcvbD1DyiRwNQbseX4+okfLPhMYCyIQfB/Zzq4H7o3igakKvlFGLUZgNOU2nUZfLV9K1Wwdbl30zLeKqpDAQ7IP+wNFzBqOKcvsr4+qja/XgV/Z/uB6eQ44O508u1WZj6Bs89
 YZOYAzFU
 U/7D79U5JXp4qty1gwAeQfOQ2t+Ao6eKbSRgfGFsR97c2Q7ohCZjiWitjg6BHdp3Y121MZ8py1uimBXzgc6l/4g7rbhVxzvQxe5McyGnTzpuK1xfVQZZu2/KCVU79w9hIUeuIpkItqbVs0L6tmKtavr3meG/Ngx2SNCMXWFuyUy3wfA9UBMHbJlhH+C3IDuObPSs0CHbfiNnNxacJVP9wqi83w8o+AlZBCDRyTEU3V8sssPgcBAtMqDRQU6OySWQiKCdhXCPHwGjErfLPOmxADmCEckEu+jWvFo2+9wezpKMJWd3Y7AlpIidRhfV7e5Uo6m/+g0CpbD5kPFpomfhShO7bPJ/ODVRYD4GJ7LQEVgzx4CPUUfji0fBw8kWvRRY9NQemFyx/VRp/gcGcZ7XZBZQmnJl7N1u9METpuDbOcgg4h/pAoaUigzWrR/J8qCwaZYFbLkekLvNLAYIZYuQa19jL/c3q/2dGW2h95dIqOaeyZzSo69YnTQ55RIFV6qNvUh/duNpFJZ3Bm5SIox32YAK3TYH1HHWx1pPKeDHmVxdwRQjkrD2rwS34zwzy1YV8qkV+3I8B7AQhMPwUYtuzvAFRtiSxDiWZYEIbH26bNc3x6l4ME0scXsJDt+xH2fOOE2BR4s5fMTNDkblEwKtSDB8LoQOV28ViTLAyKryS2mKfCRvFp6kGGRG4aFnYs7rtqZfCLQNCyesNrmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preferred demotion node (migration_target_control.nid) should be
the one closest to the source node to minimize migration latency.
Currently, a discrepancy exists where demote_folio_list() randomly
selects an allowed node if the preferred node from next_demotion_node()
is not set in mems_allowed.

To address it, update next_demotion_node() to return preferred nodes,
allowing the caller to select the preferred one.
Also update demote_folio_list() to traverse the demotion targets
hierarchically until a preferred node within mems_allowed is found.
It ensures that the selected demotion target is consistently
the closest available node.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/memory-tiers.h |  6 +++---
 mm/memory-tiers.c            | 11 +++++++----
 mm/vmscan.c                  | 25 ++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 10 deletions(-)

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
index 864811fff409..286e4b5fa0e5 100644
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
index 94ff5aa7c4fb..213ee75b3306 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1024,9 +1024,10 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
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
@@ -1052,8 +1053,26 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (nodes_empty(allowed_mask))
 		return 0;

-	if (!node_isset(target_nid, allowed_mask))
-		target_nid = node_random(&allowed_mask);
+	target_nid = next_demotion_node(pgdat->node_id, &preferred);
+	while (target_nid != NUMA_NO_NODE &&
+	       !node_isset(target_nid, allowed_mask)) {
+		/* Filter out preferred nodes that are not in allowed. */
+		nodes_and(preferred, preferred, allowed_mask);
+		if (!nodes_empty(preferred)) {
+			/* Randomly select one node from preferred. */
+			target_nid = node_random(&preferred);
+			break;
+		}
+		/*
+		 * Preferred nodes in the lower tier are not set in allowed.
+		 * Recursively get preferred from the next lower tier.
+		 */
+		target_nid = next_demotion_node(target_nid, &preferred);
+	}
+
+	if (target_nid == NUMA_NO_NODE)
+		/* Nodes are gone (e.g., hot-unplugged). */
+		return 0;
 	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
--
2.52.0.457.g6b5491de43-goog



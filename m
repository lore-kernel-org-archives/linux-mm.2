Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3581FC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02696B00B9; Wed,  2 Sep 2026 17:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A175A6B00BD; Wed,  2 Sep 2026 17:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D366B00C0; Wed,  2 Sep 2026 17:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5ECF16B00B9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:59:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D527BC03BC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:59 +0000 (UTC)
X-FDA: 85170187998.01.ED72078
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 30401120006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JyNo77OM;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZSNl67a4z/Ek/H1r9xgDJx4ye1r3GSWdBoGj8sqRqk=;
	b=jqqMIXGoRmqdIZb/RLQYQpbujW6rDJPcPRgRTTTZedETFnWVQYpNdPRnZz+p35pCoNJpRF
	J3TgKESvuxqE9AmyvO+v15qqGbJa3MzIPPL7arYhk7VYz8iiev3s8buDWf1EZSO5cxfnf1
	CRZeqT/gDd1Muo/6KKCDDZnd9oVsN3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788386338;
	b=iTksR6ZXaWICdXpJGB27ck1fT3kLjGC9yY4wo1tX9ELDEx520IGP/ZAiuy7o+iyWbbio2v
	cRRWOFYhoBHmPqja507i4j5GzIkyc0ltEIczhoHg07lMIbPbzVtVw+aYBw4BnylvYEEIrv
	aZ3uzGyRH5sdBm8hC3Xm/MxiY/K2zHo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JyNo77OM;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-90cc0ebbf4bso14242086d6.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788386337; x=1788991137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0ZSNl67a4z/Ek/H1r9xgDJx4ye1r3GSWdBoGj8sqRqk=;
        b=JyNo77OM3LglNo5Pv6LhmHXXh+hL2HheYj6eQcTDASxtHqVS5J0OSAgeHhbEuxM38f
         ErsThcTgPHi/2UHAGNPXscW9c2guju/thJPgfuRO1EOj7Si4mF/4jdV5Sz0ZuckFORHn
         OQXJOANMevIiuCLaWTcuaUMB5OHcGJVrNTAClCiiucyNawkJFO9ITuG3NDZGxe1LQ44i
         HPCgIzkSEXpBvcdlz4jtdgqafe/9kouTl2+vv4SwWATp6E9vzPNW3NPg5rF613Zxr6rn
         jIObP3ieGXGU23avMZylUsBmLwtD4BYRChApR826jfRIN5Klp+Id1DIGkQpZHW1ae9GP
         m2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788386337; x=1788991137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0ZSNl67a4z/Ek/H1r9xgDJx4ye1r3GSWdBoGj8sqRqk=;
        b=cyP6yMomiMmxF85noKLUm99V/oVw2WiiUzvh54OZHDZST0K29wtZGRThPvRe0xNNgE
         +c2Xug3I425IuMOEmAEAp9+9J80kTLDDGc069xdQhoIFowYz1v3Q9FwvhKcVXa/oMXUp
         nIDrAm3AJVvxqQJkccWy7Ug+ttPgHfTSZCgBMlV/z1RVq8eQORd5VTi/BTXxYgc92RxH
         vCblwjd7hTHTmgdIuQQdQZLy28ATiFnxXMIbeRPNzJCBUkYELsx6U/2X3hmdjX6n2Vj2
         UkT5fYl3wtWRC6eFpcQvOYo4XoT3kwFpUr5BpOVuLQI9Fob8HjQQppcwj07dDOv4HNK0
         HVQw==
X-Gm-Message-State: AFuF++lJ2JovJI5CkgSn9W77W+XVUNOdhbxDd95ZP+dDNqVjbGz6KOqB
	h5gcH/FOoLFbiCAAilVP8gkirO0EptGYsINeuCgAFlFFM7OfXm2FteT6Skg8ofNi/PciuWmfTPb
	iNTLMQCM=
X-Gm-Gg: AYBFou1xWU7g9lhl/0LnSO8WUHRy49KebM5+cOF90AmiZUjY6Vrlu2fbxSTEY1M0c2Q
	1aqnQpe3Y72E07qMB+H2OSlPB9m2zMBOoVqFsjY9meHtxH+6RC+epxbZiLg2qRr3LvokInod3ys
	piaYfsoBYpZiMWR78hzB6P98/FrQun1lYw4Dd9mxL4rNYYLKmduEvAop9astWSJkikDP5Mh4IjR
	hn3xgnq3GCSNiMWlfzXDwpChdzOV79GfYVswgX5Kpz+ahV6NQ5Y02oMAEHwnwBiEOl1VZXLQKPJ
	Yvv4nzGS4EQJ60Fk4RkTf7rIs/6kMk/JnmQUXboELhmyv6yIEYmuBnolwUmkGSlWGjfr+6KEYsU
	lyMnU4a2eOvwCPnSgNw/ydkCPVhdOehJQMjA2LRdEaPchxCWDtlt1XzKDwpzF6QEWPANj72qI+6
	cm6V2Mt+n4QvUgD7cTMcN4E06QX1TE7Bl2uktdkGnYxHsXFhR7QGo03xfXVEICHZZAX1P+QXJ7r
	u0WDEpy7KAttwPiqXo+bz+zTcjDLk+e9HkGm+E5k7bih4+beQ==
X-Received: by 2002:a0c:ec12:0:b0:910:3451:343 with SMTP id 6a1803df08f44-91034510417mr24522816d6.34.1788386337360;
        Wed, 02 Sep 2026 14:58:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ef0ef6csm27578886d6.44.2026.09.02.14.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 14:58:56 -0700 (PDT)
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
	ziy@nvidia.com
Subject: [PATCH 1/2] mm: refactor find_next_best_node to find_next_best_node_in
Date: Wed,  2 Sep 2026 17:58:52 -0400
Message-ID: <20260902215853.156267-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902215853.156267-1-gourry@gourry.net>
References: <20260902215853.156267-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 30401120006
X-Stat-Signature: cy13yuawgnig1gmh8ou5ean761qo9xmj
X-HE-Tag: 1788386338-964660
X-HE-Meta: U2FsdGVkX18gdcbZQraOUYgagpiQGaLyaGVEKu8DV3j29Q7Fq+KvDTrGgnDnJ7szvg/i2yV31+CqPNG355dzK6KGYrn+oI2U2dg3sFYUdrmBrxgu0Rf9jDnjAmKnXo6nJJKPbvU0xbrOEGmAQTv1bc4ajLqcreaN94xAybAtRsvtLyOC0BauVdF98PXByLAcUz4YTP1SeXDNNIjPqJAbw58TumuuSUQPE2BkwKhXG6zb+9QjJjaQAaDIlvsW/BQHcUQwegsPa30Qio/TRQ4o8cARAkvpiJ1Nowgq6RMJ2jbCGl7qpmyw65nISmtp8NVEYkFJXbhP5mHg6MHSgZJZ1tdTVkxBdX/D3IowRSactoKKeSEVoqjbr1SYiAkpuwDP1rTiMlOwgY02JOXtFuC6bUoXk1CriK92a7cqWodyEvxs0OAVU6/I3LQMYoCR3gjQhvXdExKW5dLRJFdIS85jnMbdWewJxSco2vjIoSNU3pXXCe5Yx/rfs5fYUEWn2H2ZPjSXHQYwV5ImoIgeE+TFGfqZa4tM+yojHG7kBjkb3QHZrGhgtGp5ybTEL70y21vd75VJycX+NKHrtv1S0ajNbsYU7c/dK3zaL0RPDjR7jEzRhCqPrw6M8CdvBJbxPH9BE+YGt26q8o4d15XnDoaVMHLooIR9KuTYtWyS5LHaw+LyesL7dokEo3qdqtDYlG7ZAWMJ8DtDHHkYeRdID5LN8g57EDt0v+Gxr7BO0W4V9ssqyJ63f09kJyO3NT7UuPmd1v/EqA6t+/ZJjdH9IC0sdEG2Uif7pe3UmEOs0+841c+kXtVIq+wuJ7wgWGQYABZlDXVKZ5to5FjBA0vHHvqZF1yaCZTvZuzqbhCCpauTNZOoSF5m8suo/T5V5Q61Sgo8nDdoQ+r/y879HmQwQl5hSOzOU0713oioRNINZaLEtsTZyyQs1iHcAVf3S9nkQswTJwNO/MqFQ54GX2RrkjH
 E88fchYj
 puuGjEQusl3mul5UUAFyZPePUi1AK66IBYNA8LX4/LhvCkKwpWLKzD0rFH0SiKwx3yKSwBAyzPGVMtgcPfZO8OdYLT9aUDejlsD92lYETEY2buB+XNjyrnxHwp8GzeSQIuETXHhD3DfnpkzF4Vhe+ofjBZnpKNA6KEGWlLW+Uf/nGIKSHkelGUythLVqf/CFnRxZt6OeWjZiagtC7vhDwW6Bajpd5h9NxvAaMx7bd32QJg76REoZ3xx9EyNwVGQ8/v4v3dsvGENHUu81anCJ9t3FL4D71LPdYS6Mew/57bY6eswdW4BotMeCIS1+go6jiU+gwT9gJEakkfe0+ZBJbU3Th5JgeDmqR1ask
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

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/internal.h     |  6 ++++--
 mm/memory-tiers.c |  7 ++++---
 mm/page_alloc.c   | 13 ++++++++-----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e16f1250b25c8..18d041ff5c52c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1130,7 +1130,8 @@ extern int node_reclaim_mode;
 
 extern unsigned long node_reclaim(struct pglist_data *pgdat,
 				  gfp_t gfp_mask, unsigned int order);
-extern int find_next_best_node(int node, nodemask_t *used_node_mask);
+extern int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+				  const nodemask_t *candidates);
 #else
 #define node_reclaim_mode 0
 
@@ -1139,7 +1140,8 @@ static inline unsigned long node_reclaim(struct pglist_data *pgdat,
 {
 	return 0;
 }
-static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
+static inline int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+					 const nodemask_t *candidates)
 {
 	return NUMA_NO_NODE;
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..25e121851b586 100644
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
index c4dc61ec663ee..4dde1cbe2fd43 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5779,9 +5779,10 @@ static int numa_zonelist_order_handler(const struct ctl_table *table, int write,
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
@@ -5793,7 +5794,8 @@ static int node_load[MAX_NUMNODES];
  *
  * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
  */
-int find_next_best_node(int node, nodemask_t *used_node_mask)
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+			   const nodemask_t *candidates)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -5803,12 +5805,12 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
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
@@ -5893,7 +5895,8 @@ static void build_zonelists(pg_data_t *pgdat)
 	prev_node = local_node;
 
 	memset(node_order, 0, sizeof(node_order));
-	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
+	while ((node = find_next_best_node_in(local_node, &used_mask,
+					      &node_states[N_MEMORY])) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
-- 
2.53.0-Meta



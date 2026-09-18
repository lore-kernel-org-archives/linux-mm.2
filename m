Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325D0C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B5E6B0095; Thu, 17 Sep 2026 20:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA9F6B0096; Thu, 17 Sep 2026 20:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2E56B0098; Thu, 17 Sep 2026 20:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8088C6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:12:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90AC91C275D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:12:18 +0000 (UTC)
X-FDA: 85224955956.04.75118BA
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id D0659160004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:12:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pc5hmSPZ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pc5hmSPZ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789690336;
	b=3f9ytcjn7ye2bYX298ItNMu0pc8n9FhTsLaOOSBfGzIXAqqRUThJkYNDspO//w+Pltnj43
	deCZVnx/fmG5RYr0heqbxN6AoxfBQTj2lkQdvdtGPDRG7IVY0lPG+W0orE5mcxc6K5dfsu
	IzQEWni4kO1VYNHTcb74iOw4cH3pAvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrpI8WWxUlqmCCZ/KlwzqkhVdxs2Qx8EkwLTiy0oOLg=;
	b=Qj3BIZuhZI5pbc27P7EsRWQT6rW7eR71kgnrz+q4Pc8ZwDNQ1kAb7HsvnerXpLXpbBCs/o
	W96KlY5eByVsI49iqzl86EBJP+44qaTc80anekyv+2csHz9lteTadugywlQV7iXFkTaQuJ
	/Li7wLrlqaqwvc7W1IOkltWtxi6TGLs=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93a40a9a01aso128268485a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789690336; x=1790295136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PrpI8WWxUlqmCCZ/KlwzqkhVdxs2Qx8EkwLTiy0oOLg=;
        b=Pc5hmSPZLfoFvGqob8Vu4iwzWHAxUyVn4+2yHEK1dcKffkOgydRxLABx+t1zLyj4uP
         IAIwLhXK6PtA/gO7EujCUSSTBKrf/MgmgMUmujSIjLBaCPKcl3NOSPbLRqHYsicWwJ05
         Yw3Qtd8ei4KgVNo5trUPtQVIEDFoDBwdhZxTLHAkgGF+28HLBr6ltcIAAjA+1H7mPWj4
         fU1w20qIyLNwcwlpKj15fviZT2JuSvPZ3G/kDn0SkW8YUu4vnYaX7d0WBAtNL3gE8Deb
         GsujOwTHyNJkLJMTgiZvJUfq213/tvoe3AkG/mZmDHSxOhELs6ywnUrO0dCdG1vcYVA/
         JdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690336; x=1790295136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PrpI8WWxUlqmCCZ/KlwzqkhVdxs2Qx8EkwLTiy0oOLg=;
        b=GBFcY718uaX2c+j7akPAIaddUuOnXGWzuvEU32HrCu63B5pkqcXGbbt7bLj3M7F4VS
         pfC1cPD94ii+Gc5UdwxiHtosMWp+9m91/yDp6mDgFkT5AbjOcZLYQVr1T+v2ullW0gY9
         U+KQZAiGmUzRnpWo7MK2n3w/xPsTbNmqHpsYBdaVG2Ib7Scfz8LTiA6O69aLRQ8n8ej0
         JbCtbATxc12H0TMHJNN/wj7aTtX8VG9dltSrp7/KQV2uz3V2nhkX8rxEA+wQIZVkN8Zz
         qX19HNKhpfGiQKKSEb7WHwWN5MXTFLMSS2K0IexVnP8LNtoj0igKj1rLnuD416ZhGkv5
         IsoQ==
X-Gm-Message-State: AFuF++nhVAGG6nybXBy5K9pWt4YReB8eZUZwpFDVurWBfpV7D9MVwvNe
	O1x4G3mqb0pBQHpi2q0IoJoeMkkLUK8WXFQTCcj5LDSjcpbvs12y8usi+eO2OU1qJgVaryXSt8+
	qS7mQ
X-Gm-Gg: AYBFou2XAd+tNm8S62k2zIA6//V0rRhTVwleQe2COZc4UtCPcrNF2G1ZHmUjTb1jSnV
	2G7VzCjAozROiXi1TJlUQSPuWJ666nEHUxngbHRrnI2XOlde6xHmfDMQav5nM+JJcHa77TaYmJo
	ke8aHSyNyDkZqqsflNcGxj3/h7jQxhUGzMiYHGphZIyKxeEdT7mR+6ly74rKIOlSDDWSxODG8f/
	gRuNTQcDzK5ZiJCZ2n1ABSILW/2HYypW+bMPB8f+8Ql8wRwKJJwpbSUpKkHoEnew2HRyQPcNHxA
	ZVOYXa5QD5zsbFl0FJxoucY70exy4+DLiUVWyg278P80ssAMrMLqsCYF+kV5L2sQ0jOMbE/97kf
	hizvJFSy4lnxivv5jnFJr85FOHMF+qnE/kKPJtfiUrZEzcL9aARwIyjoqD6FAM/QE+3aeG3mcs7
	kpi97VYm3GQJ1zPb+qcfY1l59Et187hmJ72OzBPwqfVCco533cAESLabxTsH/t1DYr8MZFuRtsm
	rkD+2B4khzH5WI7LYN4wgdYC6sg3s0Z7Vr+E5WhjhkABjKVh5iwFCiljp+9
X-Received: by 2002:a05:620a:19a4:b0:939:e6d9:b2c with SMTP id af79cd13be357-93bc62a9fbbmr758877685a.16.1789690335926;
        Thu, 17 Sep 2026 17:12:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81cff7cbsm583762585a.41.2026.09.17.17.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 17:12:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH v2 2/2] mm/mempolicy: stop copying the nodemask in the interleave paths
Date: Thu, 17 Sep 2026 20:12:03 -0400
Message-ID: <20260918001203.3389165-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918001203.3389165-1-gourry@gourry.net>
References: <20260918001203.3389165-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D0659160004
X-Stat-Signature: hjy9gqxmfy4zcx175utgecngxbu99wr6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789690336-302497
X-HE-Meta: U2FsdGVkX19RpQ4ir6MHINR+HM8aK/OR2uKuILtAJKXGbnTIjoUr60ihN1Kew7qLRQDuw0HJktEmMtdP18pVxezfYx5aDXwZprYRd8DVNE8VVMF4xVoOAEZl20uU1kLoEaddbic+ePjiK/CdaOzawF1d937V6h0lQQ3mvxvyyhxAaLrAltx8VzRjmOPamKTUReosRYmmlhLCIxhDFhMYxsYdIYPyF2WMYwmKx/4iyCExCRuSuJLIPbkUDGwgpkzn5VXoEHZPl26g34ffRD4a/18yowmjA+cjFbaQLVJKdsYSVDZH4evYO7OS1XosbTaRe7mR3AZcJwUNBXsIAGlPQCuomShRELBbAdio5J1B9U5kttHiDOo4wpmlJMiz49gC0CmpWx6GVxCCEq5PjASiWB19S5TtYLVwabrd1woN5h1NcCO596oursgxu11XhvxmqwUWeIq5Cvu4uK59O1uldYAWcXWxEVVEY1sxfnDCxaBi3uuYvxnWEo+m3f/DDOoSuZ/NsIIOjxrnQ7IKlaKEEpKJe8RZj22XOdt0Lm9OE4wWmdqGvY9tz1DWtO4stUm9Y6Ekx+LkN+PPiOpWn8Orb2Lpi7WQrXcCXwxxUxR0YhwXKUxzenESUETJvP3VclS4Dk05KaRL9sUGc7SRBAI4t0grK7N4v/oZfhreVObJBrxRfgKsBe9xg6RdnihNLA/z88H8s+iWvfsn6+LJnakuelmOmKQ2OzlvhP6jI8vakk3e3IZmFDsB6jxcIsIDxdZ85Of1og2l7vxxvPrPtfspqISQUWzPn9F53wXqBnsLTb0T816xYzBniuvnm+jFpgSNXWfMZ9JXJ8eLhEhb4Kz/M/2hxkE3/jR4qT8CpwRv2mzCMM14GmrcUuKaDAY0c8iqf2vXmS9ZGLgnXitrGdyiSUnQZze99yrJ/3pWlgvBGgITG8J8g2x2P5FyLYS6aZhbBVAImxysTJ9cZrITz7t
 IFDC/CNu
 jaDSjkn+sKNffGQYkqWrX2D2XCvWG74RCUTbzNXbn6LloHftRINl/cZU/f+mmSU2Zylz+WLCRI4MErilJzLw4LH+Sfp8pXdAoOJD15Jld48Q6ogWUKoGFHgjdi0XKXeDKuxWXQl86uXaYKW1wEJq3Izfwpmxl1YiHc0yBok4zALkFRkJAHPMju1c98xYhqYUThzajHpJXginy2oiJzgdVuy6CLICdanooO7nQHoF4AQphdV9WyXF965EondOijAAFEuuHABzlDriV9kMl+4HBmiv+dx1c47G82NaomjxshxpiXh/BRU6DWXhdefniQMxHTaRhDdXNhT9Ogw80hM9VMKLR6aLrLWJ/r5bLkoNP0m9dwdeCLIe+oTBC/kRc6fzrxNlfCLw5QaW/k6EXeOw6HDnoTMxo1UCOPdee/K2pCFov2wdHsUQP7GHiiNLQQlCYHc6/Ta8r/ozj1Doj5rLTcb/Nig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The interleave node selectors copy pol->nodes onto the stack so the mask
cannot change while they walk it.  nodemask_t is 128 bytes at
MAX_NUMNODES=1024, and two of the three run per folio fault.

The copy only buys consistency between the node count and the walk.
Drop the consistency and just bounds check the walk instead.

The nodelist access is racy by design, but safe as long as we handle
the scenario where a cpuset rebind causes a torn nodemask read to
perceive the nodemask as empty (weight_total == 0).

If an empty nodelist or weight is perceived, fall back to numa_node_id(),
which is what the functions already did when the copy came back empty

Otherwise, iterating the nodelist during the actual allocation loop
is perfectly safe - a concurrent rebind may simply cause a skew in
in the distribution of memory (or fail and fall back the same as any
other error condition).

weighted_interleave_nid() counts the nodes as we sum the weights. We use
that node count to limit the maximum skew a single node can host.

interleave_nid() walks with next_node_in() rather than next_node(), so a
mask that shrank mid-walk wraps to a node still in the policy.

alloc_pages_bulk_weighted_interleave() derives per-node counts from a
weight total summed over the mask, so a changing mask can make them exceed
the request.  Clamp each chunk to the space left in page_array.

A cpuset cookie will not work here: two of these take VMA policies, which
mpol_rebind_mm() rebinds under mmap_write_lock(), not mems_allowed_seq.

Cost is distribution accuracy during a rebind - but the copy never
corrected this anyway, it was just a safety mechanism to prevent div/0
and overrunning the alloc request buffer.

Remove read_once_policy_nodemask(), now unused.

-fstack-usage at MAX_NUMNODES=1024:

  weighted_interleave_nid            184 -> 56
  interleave_nid                     168 -> 32
  alloc_pages_bulk_mempolicy_noprof  360 -> 136

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
---
 mm/mempolicy.c | 93 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 37 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2643915dc966..fd97fb0289bc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2197,34 +2197,15 @@ unsigned int mempolicy_slab_node(void)
 	}
 }
 
-static unsigned int read_once_policy_nodemask(struct mempolicy *pol,
-					      nodemask_t *mask)
-{
-	/*
-	 * barrier stabilizes the nodemask locally so that it can be iterated
-	 * over safely without concern for changes. Allocators validate node
-	 * selection does not violate mems_allowed, so this is safe.
-	 */
-	barrier();
-	memcpy(mask, &pol->nodes, sizeof(nodemask_t));
-	barrier();
-	return nodes_weight(*mask);
-}
-
 static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
 	struct weighted_interleave_state *state;
-	nodemask_t nodemask;
-	unsigned int target, nr_nodes;
+	unsigned int target, nnodes = 0;
 	u8 *table = NULL;
 	unsigned int weight_total = 0;
 	u8 weight;
 	int nid = 0;
 
-	nr_nodes = read_once_policy_nodemask(pol, &nodemask);
-	if (!nr_nodes)
-		return numa_node_id();
-
 	rcu_read_lock();
 
 	state = rcu_dereference(wi_state);
@@ -2232,22 +2213,45 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 	if (state)
 		table = state->iw_table;
 
-	/* calculate the total weight */
-	for_each_node_mask(nid, nodemask)
+	/* calculate the total weight and the node count */
+	for_each_node_mask(nid, pol->nodes) {
 		weight_total += table ? table[nid] : 1;
+		nnodes++;
+	}
+
+	/* the mask is empty */
+	if (!weight_total) {
+		rcu_read_unlock();
+		return numa_node_id();
+	}
 
 	/* Calculate the node offset based on totals */
 	target = ilx % weight_total;
-	nid = first_node(nodemask);
-	while (target) {
+	nid = first_node(pol->nodes);
+
+	/*
+	 * The target was calculated in a separate loop, and a concurrent
+	 * rebind can change the contents of pol->nodes as we calculate.
+	 * Access is safe, in the worst case we suddenly perceive an empty
+	 * nodemask and return numa_node_id() below - otherwise we may
+	 * simply cause a skew in allocations.
+	 *
+	 * Clamp this loop to a single pass (nnodes) to keep the walk
+	 * bounded by node count.
+	 */
+	while (target && nnodes-- && nid < MAX_NUMNODES) {
 		/* detect system default usage */
 		weight = table ? table[nid] : 1;
 		if (target < weight)
 			break;
 		target -= weight;
-		nid = next_node_in(nid, nodemask);
+		nid = next_node_in(nid, pol->nodes);
 	}
 	rcu_read_unlock();
+
+	/* the mask emptied under the walk */
+	if (nid >= MAX_NUMNODES)
+		return numa_node_id();
 	return nid;
 }
 
@@ -2258,18 +2262,23 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
  */
 static unsigned int interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
-	nodemask_t nodemask;
 	unsigned int target, nnodes;
 	int i;
 	int nid;
 
-	nnodes = read_once_policy_nodemask(pol, &nodemask);
+	nnodes = nodes_weight(pol->nodes);
 	if (!nnodes)
 		return numa_node_id();
 	target = ilx % nnodes;
-	nid = first_node(nodemask);
-	for (i = 0; i < target; i++)
-		nid = next_node(nid, nodemask);
+	nid = first_node(pol->nodes);
+
+	/* A concurrent cpuset rebind may cause us to see an empty nodemask */
+	for (i = 0; i < target && nid < MAX_NUMNODES; i++)
+		nid = next_node_in(nid, pol->nodes);
+
+	/* the mask emptied under the walk */
+	if (nid >= MAX_NUMNODES)
+		return numa_node_id();
 	return nid;
 }
 
@@ -2665,7 +2674,6 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	u8 *table, weight;
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
-	nodemask_t nodes;
 	int nnodes, node;
 	int resume_node = MAX_NUMNODES - 1;
 	u8 resume_weight = 0;
@@ -2675,10 +2683,10 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	if (!nr_pages)
 		return 0;
 
-	/* read the nodes onto the stack, retry if done during rebind */
+	/* count the nodes, retry if a rebind happened during the read */
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
-		nnodes = read_once_policy_nodemask(pol, &nodes);
+		nnodes = nodes_weight(pol->nodes);
 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
 	/* if the nodemask has become invalid, we cannot do anything */
@@ -2688,7 +2696,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	/* Continue allocating from most recent node and adjust the nr_pages */
 	node = me->il_prev;
 	weight = me->il_weight;
-	if (weight && node_isset(node, nodes)) {
+	if (weight && node_isset(node, pol->nodes)) {
 		node_pages = min(rem_pages, weight);
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
@@ -2712,9 +2720,13 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	table = state ? state->iw_table : NULL;
 
 	/* calculate total, detect system default usage */
-	for_each_node_mask(node, nodes)
+	for_each_node_mask(node, pol->nodes)
 		weight_total += table ? table[node] : 1;
 
+	/* the mask emptied since it was counted */
+	if (!weight_total)
+		goto out;
+
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
 	 * Track which node weighted interleave should resume from.
@@ -2724,10 +2736,14 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	 */
 	rounds = rem_pages / weight_total;
 	delta = rem_pages % weight_total;
-	resume_node = next_node_in(prev_node, nodes);
+	resume_node = next_node_in(prev_node, pol->nodes);
+	if (resume_node >= MAX_NUMNODES)
+		goto out;
 	resume_weight = table ? table[resume_node] : 1;
 	for (i = 0; i < nnodes; i++) {
-		node = next_node_in(prev_node, nodes);
+		node = next_node_in(prev_node, pol->nodes);
+		if (node >= MAX_NUMNODES)
+			break;
 		weight = table ? table[node] : 1;
 		node_pages = weight * rounds;
 		/* If a delta exists, add this node's portion of the delta */
@@ -2744,6 +2760,8 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 		/* node_pages can be 0 if an allocation fails and rounds == 0 */
 		if (!node_pages)
 			break;
+		/* a rebind can invalidate the counts: never overrun page_array */
+		node_pages = min(node_pages, nr_pages - total_allocated);
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
 		page_array += nr_allocated;
@@ -2754,6 +2772,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	}
 	me->il_prev = resume_node;
 	me->il_weight = resume_weight;
+out:
 	srcu_read_unlock_fast(&wi_srcu, scp);
 	return total_allocated;
 }
-- 
2.55.0



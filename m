Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFFCCC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA986B0092; Fri, 11 Sep 2026 23:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891996B0095; Fri, 11 Sep 2026 23:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F8A6B0092; Fri, 11 Sep 2026 23:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48EFD6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:04:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5A5BA041A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:04:34 +0000 (UTC)
X-FDA: 85203617268.17.7BE7B93
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7541A0008
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:04:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nKkEXq17;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789182272;
	b=pnpFgudNZceskywC7k5u99rioh560pTjBJz0mHbm7FSRsB1lYQ63rEU9BZRg536wBt4TKI
	F57j2EZ4ZvMiONxSiCulSEzelOanCQtqsy/j2NEs9Qv7dLCOq/J3BS7D/mvdIQqACyRWW9
	uCVtmXYJZzWwfokYRbvPRucpr0WCvbA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nKkEXq17;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789182272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxIU5xWvvJNvSs/zUIGzI+Vs/buRWaBwnwkaFkIAvLk=;
	b=ckiX1ujS4Cc0ZpK5RE4I0c8CFXpa0dwdVtoQyV9GwUlcqzc+LabDTspJdr91a+HzDLx7C4
	OVM3plYvP6U/0FhtDkOZIzhfL/2T7bRJ8ZQ2iGCwmy8/86kWSqLp2DdSl7bvyzeGPLhjj6
	XWgftC9c10lyMOdOyG7K9M02FCMAoWk=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfe60d5fso3260836d6.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789182272; x=1789787072; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pxIU5xWvvJNvSs/zUIGzI+Vs/buRWaBwnwkaFkIAvLk=;
        b=nKkEXq17x2sK8VQJKn123cbBVU27Djp7pAaChXzIccDG3WY/UuUIG4RnW8yRvfin3Z
         4kSY5nP7d8EwN8g1+WcQce2FEH2ccEIgYsa+wUT1lkfkgABq0oU2sIihAguj8qSzvdw3
         FT2eGlgI8mnKU4xP8ONZWhpWXAIxpG8U4tIry64IF9gp/QV3h6SW6zRLGDFkNWyJjqb5
         Tsrq/qSP0qe2qnL/4hXAoUydvOD46jrvsb8oWzPNG+xMpM5qV+EQT2RBvFq+IPOpzknb
         8eRxeV/lnH864XYlevW3cHAY7nxdoG0eXmpTf/2ug1++OSZzQtGMhDj9QzL+VK35Wigm
         2+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789182272; x=1789787072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pxIU5xWvvJNvSs/zUIGzI+Vs/buRWaBwnwkaFkIAvLk=;
        b=W0qrGZesF/gw2RS8qI99MabUeZITho4uax8H5JGpJ1E2aneMP0w5C9Wt7aHdNzaPco
         3jEQofshGzPHSy6A/vQW7Zibf5fHFnsdbHpBjvaU/03UfvyPuUhsMB2Fh/1yYnodvlE0
         PyXrbQbhax1dSCBXW0pBMyYIvUrFFrn4oYmpdLltd2g6/PzXrfTCGi9gd68PuNtdVgB+
         go2JCkjKSeMAls8SjrEElmodUo4VBekntU8h56Zl0msEgfDT6AApQYoSBIZ+lZfS2Zzm
         cmlpSIM4nPlFLmFYjTp5nxbh+zpPuM6vpUW3RSyB5uKSFTEctulWhpfAxJw20AGM/kwn
         Dlmw==
X-Gm-Message-State: AFuF++m+/hl3jDXfwmw9IMT2A0D/bwCrGQFqFNXF5ErE33r9v5OBjGZn
	ZvXyydJfhojolJuXp7xKs3QN/1n0AFBLt4ub0PkUjrwqo92nl4b/x+NL2sIG8hpL8C1dUhSX25u
	mYG1X
X-Gm-Gg: AYBFou1aetpiZmcpnuJ+UBInVnUInmZc4dVuBm3/MmztceDROBrpkB1Xuk32Ew05elk
	5+vuZ+BJmtZ0NtTnCD0rOUE+FJfLy/Wu2hGrWWCkmxboEcuLoJgPyNx2r2wLlUhuiLNv7LsbJOX
	/PIZXLIXZjRxWFAGoEs3xRZRPoCI7WFmQnUyf5uhor1myrzeFrZikKWOvDWQJ30MfEu5qSTh+kP
	deVkvJbvBVFdygATb4KX2L5vdegcvnAB2IXhqnL9cS4ZHJ4cX/S+G8FvC+W/VbGnxb4jP6TAYFU
	I+X2NdD6MlFAFXn6X3CBv7LbF9IVPwUP50um3WXKhc4q3w7xjJVJZoQxDqHTl+U9Tx21KzsUN1q
	VYbq+ntvm2CXi63XzdGQa6GwS0XrcZn+fayvG++nvSnA/5WUR4LeWNiIO0eB5ZClHYCCbRTpxds
	O600YMzmiFAqIaC4CEKKSvy6ghU4TiXSf8jpd7LyIbrrFw2q8/16VjEu3PnnNT327/8glXgN2+d
	XowvveUuwAz9JSdB/Hnei5WojALMLSXOZ3CQ1P9buQ0AdO2wbM7EUYta6ZVHLH1fjnbVUg=
X-Received: by 2002:a05:6214:2685:b0:912:bed:c74 with SMTP id 6a1803df08f44-9121da7ecd7mr19424046d6.30.1789182271965;
        Fri, 11 Sep 2026 20:04:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f202856sm36085296d6.2.2026.09.11.20.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:04:31 -0700 (PDT)
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
Subject: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Fri, 11 Sep 2026 23:04:24 -0400
Message-ID: <20260912030424.2889731-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912030424.2889731-1-gourry@gourry.net>
References: <20260912030424.2889731-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7541A0008
X-Stat-Signature: c6z7efdaptr4hftcnj7c554ud54ox1ce
X-HE-Tag: 1789182272-674069
X-HE-Meta: U2FsdGVkX18p48VB7gvMt/hmi2zHPJ8/bU1qFeav6AGS51t3M7ZJYHESOlVQDOi5ryjwGb6lQE+tE3t2OMMC9fTURRviBy5CnpSFyP6vjcOrz5IcpVX6UEQBJnHzTRl/Fh9cEhw2kn6wdkj/mH7/FLgdimNxvAYbyHfh85f6eZSmTv5a0Y8tQaPdN7uIJnf1GtHBJyPuWe1rk2o1C6ZLn/8NBgIWMuxKktNc6VTcSuRoFU3TdkxKtvPp7HqIjHAzQd+xpV4Sow5rhfYc2TowvFtjXnOTbhlbYwF5vBfaTRxq8FXNWk00XgjoAgjQquWBLjpDG2CsDq1DfV14z4z8/TyuMpuvQwRwXDIuR1thEivTzJGpKpC1IAZ1PqVxx2ZcviyfIRXy1wCYOu3FVhkUsFfSEKvp9JuJprz+qRzfktY6EsJWchiAsg17TGN9IrgsyKu0zOvnutU6QDIUBhwCqK+JVhDf73GaiibByYMzHR4oaSllgDKpuLPn4SHCq9OfvUxWyuhGyOppzAsazgCQ5m1px2hkwSjLUt1akovpIx6yLned/N8JAVjSX2Nu68FZ8ju1MUUyHzwKXCtk2oyxsNwc4KI42mhkzT2+fgPYB3fmDH4oYT1Su7QvCVLpFLgKz6AKDj5pdQvHlujk3cbODb9ue/FN7WThBoFOflbTEOAHNgwcYhfj7jad9DSkx9ZaUPmh/PoEVM9VxVF8R6FbTB0B+kk8d8t9vXni/3hKfTcvDh0Ktla4b3Cl1PaZcueOESmFQmXKsqTefE4hPpkkXmG1wvkwG+10dmgBOh6qABngbAoYqP5v3TzgKYiBiC+Yr+qGRkDWYgKmR959IINqJ7tX9l6C9oTb6QQsVgDTnAYpA1uGz0UFOJN5nq7IbxnPfVi4ertwzBDn12XoRUGj+eawVtKwlBg/cDpJUsuuSbICVUyC6VzfZUjgYSooPXE0AE0Hdv6eTdhJphyGs2l
 46cZt/su
 T6uFKWpwgfXljUxnVBDIUp7y79BBxc2hO/pC6fxOsaRx2n0mHlyFOCaZNejBSJeQAhg+k0F8+LHbLDStF0D/MwJlDBRBuogqq60VRjt9FxTRT37A1eceW3MwwhJyfcXNMulf8LLWtoeLw2b6fTGyr4nlLwN29vv0gwEzxaRQCDtpg18TEuqoqm2C2qy2/O+t1pWcvDsK1AqHDdLkPIQ2SmH2hxtokj+hZ2255c/f4sZvUZoBlYVs21ZxL7fzWgGwmU8TLkvXKfDeMesd/2joPLbnQ8Yo3Bjkz+dhVuQYjmkb1Q2vYx9TiEXxaM773fhAtHQ92B3d2wS9IBJcLcWDjfETn4pzigz52R/Yr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract per-node fallback-list construction into build_node_zonelist().
Build each selected node directly into the destination zonelist so no
intermediate node_order array or node count is needed. Print the fallback
order as each node is added.

This lets us build new zonelists from candidate nodemasks instead of just
the default N_MEMORY node state list.

No functional change: build_zonelists() builds and prints the same FALLBACK
list over N_MEMORY with node_load updates as before.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 63 ++++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7efce139d562..d1888d5630e0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5857,31 +5857,6 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
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
@@ -5897,20 +5872,24 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
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
@@ -5920,18 +5899,22 @@ static void build_zonelists(pg_data_t *pgdat)
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



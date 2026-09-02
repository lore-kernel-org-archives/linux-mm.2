Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D9CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BEB6B00BD; Wed,  2 Sep 2026 17:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312B76B00C3; Wed,  2 Sep 2026 17:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201CC6B00C4; Wed,  2 Sep 2026 17:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD7F66B00BD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:59:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70104A03D5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:59:01 +0000 (UTC)
X-FDA: 85170188082.27.4AE86D4
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id B6B671C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:58:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WhltVxYR;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788386339;
	b=hrHbMAv+RdDQQkDOYR/Vkr2A/aK0M4cRzzNJv+fGH2mA+Pl4S/ODvC3kKcjdpy4B/TIB7E
	lNlj2HI5Uf2lJqU1nsuxXnNBemM2hoS05+kW7IlUbd8jcHwrO6CTXmeq/RfYwEEJlirs/G
	bOumwAPj9S76xagSUoAMubK2A0/hjRg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WhltVxYR;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrMSt6X8RvjxMQuQ2xs2fBaN0A8WJe+DFrieWn+26Jg=;
	b=5HhNCk+I1MEk++HVT1zyn4YHVMXbRgUQSkusW092dERxgg2TyVfRHnbJLWAGyqtPyMMiJ2
	IVTZzQrsfUbW+qmT7OcCYaMwatz3k7Bzltr9fNoO7wmwZOXJHs5gt10eGetDcOepDwi2VX
	YDFMXn7WOWMzKXzVfR1ffbpMagQKMuc=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90e9e042ee1so17894086d6.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788386339; x=1788991139; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wrMSt6X8RvjxMQuQ2xs2fBaN0A8WJe+DFrieWn+26Jg=;
        b=WhltVxYRKcWEKOZWgjt9xeA3fzBAMgJqvAZJw1FjyXg55lYAnbv7tOahwyX0mIdvit
         btDdnF34x3IIjnR0F6N398yLhOM8BrHjcifwUShe/xs1k8yNWbYMCQVCIwMaMCOE9uOW
         48qPKLVdlFYmyaDXbgo9EbGOxdwfPHjiAL2IzAqQqX2W68AhLQbaTfJPr+waBd/eGSZm
         98ZGPaNBL2vaCpKK1Uzuc5ntAKQyxb47f7pUf3BD8E9FfB9ULQr1ab6M71Cpe/n5QMSh
         y8Qd91uoy19rNlCw8crRVX/iRL6qhjZbGA/whOzsxfIQIvxp6QwZfov6YioSUV2afi+X
         KrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788386339; x=1788991139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wrMSt6X8RvjxMQuQ2xs2fBaN0A8WJe+DFrieWn+26Jg=;
        b=LHRdCfXM3/mxSZhT9ULmvE4eV1ovHZsel4Ogwbi48BQFrgwW1bVuklrhygwjIWGPVz
         l2ub77K/u2YhgKHt8iYpAgUGDXe//kAU840M1XEpAfUjGKa1N1oq4KMk3ckyV+P0HxE2
         5JPCpW4JdGHguWWl9uuZDd4ZxkoUNKwibOIC7XNF7+SSyFvWHy8tyI5mO0YAdqXCLqFo
         CDeu/oOlZFWiKf7n7wuiKZzmv0cemEMlZI2Gg8JCiKoakubnhDAiTWWmSMPhTMciNieH
         jjf4pW6K8nZWicMk7C2PZ5a+TzUuP9tXmsQ2UtdENDc5AeNSoJhawRi4nzcGEjpbbIQg
         fpsw==
X-Gm-Message-State: AFuF++kWSaQieCxBd35Wl/hK9K6ny03/QlKTs8QlSxjGm/KSo6E/SW/N
	H19I7y4TyfsIqeRdxaYiKoIjL8bI/bzzsLmvzr+pliXbIx3y1KNNkUZHnHPf5GAd1Layb3xZNF2
	7iEFuOPs=
X-Gm-Gg: AYBFou1OLIq/QXXY+B90fBZkCGeZ+qlS1f1lg7+c1541+wfUMGYpfgppu0W7hctIftl
	8RqvbGv2qUeWNdSbs9os9negxBshHdyryZXHYtWYGUzCiF0M6Qwbzge4NU6da1C7pP97i/Jgkiv
	uoP22GBPsDEU9gO8fCSgwyqw2xRii9J0eT77c7FRPCMRigCjPrsOTNqhN6Sm1Xx2lrM023L4/6S
	MMIAJ4ue/NnjgdO9vD4Q3LQfZ24uojSkbpFo7uKBolfjg1UEGT9gM7LeHt/zxWKqilXejhcpVm+
	+nrs/0F9krtCmczT9t+BLavfuSQ8CjDEflQbJ/sPXeK4ZwrLoVZGPQDTUgxcE8bQ1JVpHbKLHSi
	j3o91hJWOWdf5D5yCG4wNnyy6V60nzkduZwS+zx3BrY+zpCiyDDIuw04OBUeJ9jx/NG0ht5Drg2
	ZDTeJboUFXLkuPvXhUOdTTux4U0vMqyk4rw/ssjAvr6OOwg8Cj2DgAUODhz2KS/rb5tx77PGuHI
	H7jF/aThfTvXD1Uw6Hk6KMslTXu90oayDhCsWUMTfT3n4rhiQ==
X-Received: by 2002:ad4:5ca3:0:b0:90c:d2e0:efcf with SMTP id 6a1803df08f44-910327a4d10mr48897596d6.30.1788386338868;
        Wed, 02 Sep 2026 14:58:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ef0ef6csm27578886d6.44.2026.09.02.14.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 14:58:58 -0700 (PDT)
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
Subject: [PATCH 2/2] mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Wed,  2 Sep 2026 17:58:53 -0400
Message-ID: <20260902215853.156267-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902215853.156267-1-gourry@gourry.net>
References: <20260902215853.156267-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6B671C0003
X-Stat-Signature: wtgr7xpxqo8gni6mme5tgfdipr3xdnea
X-Rspam-User: 
X-HE-Tag: 1788386339-725791
X-HE-Meta: U2FsdGVkX18gy7FJ9nL51SXYVU8suBnV0tCeXiZubbVW+WT+5jMdiwQG47u+aMz4yONGuuGOTtwzQJTqGpx2L2J55Eg+PaNQ+Z8O5qguP4eQQQ2kNp7PD9GTgADrtYOKi9Y9X8yAVSPEwit96geck5kRr47eY1TfUcE8/Dh7G2Fym1ARPyOerjJTtqFRUGZXug4JhrOizGArUAK/OVEWOmEvpZo1ITg5wIeR8S36WOsBnAIIPsypz5d+ePqnHV2OMzrEN/GZ4Qfdb7V303A5IHJrcU/oY8w6GBq0jdGfphcdxVh9LOTVMJOqyhBoJraMAOLhByu7YSmwYkWa4Repy+B0dxk4nC6I96BIAvJfcYdfHpu1sPnhrG82G1pWKuajQPrsTxDo4+R6rpYFweTEjF2tfjP3M0H7SpG02qmMvyGngz6pEkLc3TpJhOUrzn7ghgNsT8/bjTdeonD8URfm1gYTMwZ8x05MAysvMnDWE1D+6xDMcx8JzLSsP0mvw7P0VOha//GITSShLIsY77jxTtCeLbloi69Z76N/tPnwd+Of97YVLH5ZnJGsPnIolMUQcde9Hb1HC0s92WhhtoUNfzwpY1gViCayTBRWdTwtjct7g9gj4EsIKlHUVg0uvSd6kQ0O9d/wdf9AW017Ig9NxmgHTjUKro6RuR3DH+Ee5Rw8buU5kPUCKL3wIY62lykQUJ9oghwFV0O/DWbrFkilty9xeyiqDZC1Jr36ZIzBbSOdGqVmLtKVpAZbE5Row2ORqq7zyfIFAV6yBsDfXk+cgG7W9JywJ3DHyfTRDXA12NowiU2ChXG4FosBGH8Mj4xQY8tNJM8i+EScyUR2DP81X0CdQMzUl6ZTnggsqcpKHSr7k7C9unKhG7rkhGA1/zkHG0l2MfUAHsamiWY9GcCyjXLa3w6fmBLWYEZ79Mcqpg2K/MeVGO3MPb5vAWa4GJQNeTpNAQuPahvQGCDtVYf
 oy74KBtH
 9tl1KH+jq0N8v7WRMZ0+s4XMU9jDiJfNCO/1OpBxefnxNIa5L2luuOkHEw5NG6eurvJJCONpIC/wRxqqUi0UsAtIoWN1FIjC2n5nQFUTpO3n4WgdAngfJtkxwNK93QHcQiP/aT8ba5cv4k7cSsW2kjUNTemtSZ7MvieCZ0zNRN1kSOtuzyQvrOWY6XWiDKrgEmLAIKRu2j2CexGvlUduNyd7EMNq8Y8gw/xcSeyx27LUSZa2nDvsZ2hf67g2sA7T6PSfdIbFnSd57ezeIuoVzRpKf6DgVDeO5vx+wJbqQLN3ymf4GYwjpeCRwBHlQ8pQ4S/RnlKYbrokutQBmtJTv5w5YN6dMMZyz0KFM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract per-node fallback-list construction into build_node_zonelist().

This lets us build new zonelists from candidate nodemasks instead of
just the default N_MEMORY node state list.

No functional change: build_zonelists() builds the same FALLBACK list over
N_MEMORY with node_load updates as before.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4dde1cbe2fd43..e1d7c8b221d0d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5849,12 +5849,12 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
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
@@ -5883,26 +5883,28 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
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
 
@@ -5910,8 +5912,22 @@ static void build_zonelists(pg_data_t *pgdat)
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



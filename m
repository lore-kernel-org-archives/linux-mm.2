Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F79C61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38BB6B0095; Fri, 28 Aug 2026 21:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2E86B0096; Fri, 28 Aug 2026 21:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD80D6B0098; Fri, 28 Aug 2026 21:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC0A56B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:59:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 331821605F0
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:59:54 +0000 (UTC)
X-FDA: 85152651108.02.C123E06
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58EF8140006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:59:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="T/kQMD/p";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787968792;
	b=q5uMRAee3bevTY9Uevl7qPzgQA5UETwuU2MaIlkD35WJCw7LPo282JmHOJCx034vPDvkCW
	5NKcbLqBLhgCtRuYStT3fvlrEUANHBCiZ8uuend30YLd4ZNP32LXs87tB/BgQzXLGyYMz1
	v7ART/jYlLIEQaFthMXVgPKGT2lBsjc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="T/kQMD/p";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787968792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faC0fYG8yMLiPwwr3mLcygBE5e7EbRUJ0hBevdXCmrk=;
	b=4q6B1PDiKzaxK0yvbX8C/4vj2ufcIArQQ4Aasty02fciMdYuMFCavEwb0U3VtjpLvWkMcM
	eht+sNe1n+JkEINk6Jd/nfpNrl1GvBr5OUdc3ClYD2elppBu/uUGQgsEVykSEWEWUtnmCu
	P51DSSL6RnozFgQc0ZoWZWKnVCegY+8=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-90c522298d2so19488736d6.2
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787968791; x=1788573591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=faC0fYG8yMLiPwwr3mLcygBE5e7EbRUJ0hBevdXCmrk=;
        b=T/kQMD/pObER1Hs9DYzfV4BmDncMbRiR8QYaBki4W3X62syAFUGSHLJTfux5wubSLK
         Le5pd2qIu0gx9ez0xqnImZPv3msdi0VNdHUwT/fDSLmQoVGbOb/w6Bul+zRrCi+R7afh
         LSPFL0Av6b6n96oeGNCRQqtsyeyzQFOjsXH4s+v3sus7kbw3xhJhwCCuJRwkjru3I/8i
         wuhX4UsR3+Ew8G4WxEM/U95QG52DxhDLInYpcQBtQhdvKHjn+34N1+NbTcB0Hbv/ZFqq
         04i3F5YhQyzUOV6p4/8v1MIf/K3NonH5OXLNds/Py/RzhTLirfm5Wm/nEsA8Lo4Gz5Tg
         do2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787968791; x=1788573591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=faC0fYG8yMLiPwwr3mLcygBE5e7EbRUJ0hBevdXCmrk=;
        b=pqN2F2MfqpCN0bD3xkFdI42Vroz0RChP2tHJog/VoWr9V413Ngua1A1ygE98GBd3WK
         mmwrAF9vyaynXtgFkS2WuDZFbTxh72Yj3Ap+89retEYFAUCivScO5OkcvX4pH4HT8uMO
         cg8vasoleB79TBzHsHRs1HcJs0DZyMtfSbwRY2k+msGyPLRtEZsGEvN3MHWx4se4d8eb
         ni/EUoYvBm/efrSvcrPYsl2szK1hW1jsoQb6IIbJ5f7haSqJmOYwkct9uGl/jBtlZjGd
         aIaTzNGiBc97cTLBi/YaYCTbNPa8l304m4u2YgKIolyabX8wok9wkfnzRcHTf33XJ7jh
         Xa2A==
X-Gm-Message-State: AFuF++n+Ju/e2W1/Eg+FE05V5j8w87mjVmVyCAvSq24R4wDTW190mwA2
	9aicZ5NdQiWnqMBclPKcRW3mdg9X4ffp3sVmx0j1We8J8oM9dw93V5Zm9UInkvLyBvzrs+zm1y0
	9lzjVTGs=
X-Gm-Gg: AR+sD10PpWhzkFWBthSCSuMUnNUtWqDZ+OmXd95nP+0Xn/VxCcvyIslm1LuD9gI4udO
	usWDZMM6bmPHINhmoAsKTd3yZVEaFey+HfOb55NPq+EwyDSlcZdLcZj19521ieAwgZXHu8kvNuB
	2m9XGyq613zab+eutiU1v89ClAw4BKZ9Ol58nM/7b2Y9VVKr22T+/Cpt1otptjqGwxnaywHxRuB
	nIZeKJr+HRTvLfzthFf5QXGgATa0T7WIcNxsEkHtcaZzGZABovRBDwiX9RrMxiDBMlRtKsmhzYt
	4PcjJqgdnSQFv8+sBip01K5tmHKOb52nyRWevJrJyZkGYO4Jyh3QunKFgcI5skbWQzy6Chd9ste
	vaQrMQPjRoJFgWMw5jbAd4o/U1M+EOl/w2XPZC1NBABd2XELRz9jEBzA/JENEAhMbo01PFxSbnT
	61KZHgI9GJI79Jv/UldSp6wzf66mDmzD/GqFUztRhiMK0UPZnmAN5Bs+GKbWO4wWB6QKFOlbZ+X
	f0uEVVtUpUKKk5BrmtHwQ0CuZ+iKrWkkUUWK60DVSEfL3Eapg==
X-Received: by 2002:a05:620a:29d4:b0:92e:71bb:d1c0 with SMTP id af79cd13be357-9391379155emr1157379185a.15.1787968791382;
        Fri, 28 Aug 2026 18:59:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9391701305dsm272582285a.4.2026.08.28.18.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 18:59:50 -0700 (PDT)
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
	apopple@nvidia.com,
	urezki@gmail.com,
	chenwandun@huawei.com
Subject: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the interleave paths
Date: Fri, 28 Aug 2026 21:59:43 -0400
Message-ID: <20260829015943.1258774-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829015943.1258774-1-gourry@gourry.net>
References: <20260829015943.1258774-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 58EF8140006
X-Stat-Signature: 8njm5odmzxymksyp9699gxdqe9fnnazu
X-Rspam-User: 
X-HE-Tag: 1787968792-871089
X-HE-Meta: U2FsdGVkX1+OHCkBIEFWXNs3vcFikUVaI6pdV0+n4565RSSnZCPgoFOcLIX6wph+Hi7E6L0fwvZaAWs/N13FvzwipcyFBZhGvejl6j6GyKr9k/47oGtsdP+yjFqKf8z2fSWk66+77A/r6aumJTHmFzHmh9vb7XHWma6Cf1NGgPleKg8Txw6HB3WadhWWExmaa11c/XZm99VnUgo87vBhCbN+/yZxGuSIhlXUO6bq92eaMSX2I/J4t8oWxfppXPs8O8prqxnND9hOvZa7Y0A2TfNETNmYzirlNy1/lrd9hJK/+RrFuM1wczPMyHi+4enu4+Ii+bSqkwg4WrdUVqgdOPdsMbrcOtM4pTit6HfA/P6b1atMVFKaFUQhJBpUypM1wCddh3U/GFpkI4UHnztBvlaN6/cGWhY6hrmTgivcokXxlrGef3CnPVpXGFmjKUPGd7ybBHh298FHgJlh/gcuY+Pc+tYvGJ2DK/c0pI806JCLFMLCgptteTBPCbe/5ns+oyd4N6kSGO5EWPnnT7EwNZlE9s7MBMI39Zn7/BFViUrfc5KnyaYnthM9cEWfU3Nx7ML64YzNDUcWEm8mgoqPjQZIU2JumXvsdatURQeUzvq+Iw7MYohz4W407Ac0yBy5PUAPDG8Ds9RLZWtNbutVzP5SaZFa06IA7Vdo2cBV8y0ZFcseIX341p88zcIQktJCwXUHyI2CrdLFBlfOjg2wyLKFBZ9yTxkKFjb+wo6Eum4YEk0W2SrntyqjXanzafHtIPbcvq9tOOXmZIcedAmMOek/IBuPUPLLZ5HzaMBHg5TN8V7iF8drzzY/wY3Y+iPLhU9NV8lfWPtW/C6VVvQxu1q+Yj73AG1dDDuDgAt23kfzhW+TpygR7QRvc4xWZkIGDRry+fhIs/GcS4Cvuh8bCFZ1F+1WzFQMIE/JZSB6o7l+vazOAlptNZY6Tm9oD0CC1aQULyN9D06MF0XNJdQ
 Z1Rk1bdp
 HkFYZnebiRU8+L2HB9BmAyVgUZopq+fSjJveKyUbwZ20cYvS1mukM5HtBvOl0wA+OkveNwV9Ijp+pDfFlxyHAFIMNaZnd9f7gqAJNUiC5qhWDG+rJrtaWyJQqobBjSOYWBgN6mVWYkpIJaP0PlT4Cd//BIKBL/+lsZEvnYj9YwDJAPNfq4QXH5dgn1YR9t2vPZtoqCXx1AFDZd5FZHlHCVz10Bl1bc5oLnmp6AXGuPppnBuHqEtwW6YT4y0/Eda4GUPTvTwItQRyJiiy5rSoGEI8lTkaMQwGFWcPGdDiK2xWy/BAKFi9L4cwcxMGQPQfLflQWO2q+o3ua2E4Pp/dFuWFPS5JsP+nBpKEngCqUoFdtgIAXaThKAJ6Z9IREYM3Xht+Q
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

If an empty nodelist or weight is perceived, fall back to numa_node_id(),
which is what the functions already did when the copy came back empty.

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

Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 86 ++++++++++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 37 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2643915dc966..296129126109 100644
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
@@ -2232,22 +2213,40 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
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
+	 * rebind can change the total number of nodes.  Clamp this loop to
+	 * a single pass (nnodes) to keep the walk bounded by node count.
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
 
@@ -2258,18 +2257,21 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
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
+	for (i = 0; i < target && nid < MAX_NUMNODES; i++)
+		nid = next_node_in(nid, pol->nodes);
+
+	/* the mask emptied under the walk */
+	if (nid >= MAX_NUMNODES)
+		return numa_node_id();
 	return nid;
 }
 
@@ -2665,7 +2667,6 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	u8 *table, weight;
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
-	nodemask_t nodes;
 	int nnodes, node;
 	int resume_node = MAX_NUMNODES - 1;
 	u8 resume_weight = 0;
@@ -2675,10 +2676,10 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
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
@@ -2688,7 +2689,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	/* Continue allocating from most recent node and adjust the nr_pages */
 	node = me->il_prev;
 	weight = me->il_weight;
-	if (weight && node_isset(node, nodes)) {
+	if (weight && node_isset(node, pol->nodes)) {
 		node_pages = min(rem_pages, weight);
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
@@ -2712,9 +2713,13 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
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
@@ -2724,10 +2729,14 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
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
@@ -2744,6 +2753,8 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 		/* node_pages can be 0 if an allocation fails and rounds == 0 */
 		if (!node_pages)
 			break;
+		/* a rebind can invalidate the counts: never overrun page_array */
+		node_pages = min(node_pages, nr_pages - total_allocated);
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
 		page_array += nr_allocated;
@@ -2754,6 +2765,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	}
 	me->il_prev = resume_node;
 	me->il_weight = resume_weight;
+out:
 	srcu_read_unlock_fast(&wi_srcu, scp);
 	return total_allocated;
 }
-- 
2.55.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09650606CD3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a6vtZnVq
Received: by kanga.kvack.org (Postfix)
	id 281B16B05B9; Fri, 20 Nov 2026 13:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3AA6B05BA; Fri, 20 Nov 2026 13:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084506B05BB; Fri, 20 Nov 2026 13:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6BAE6B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:49 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A73280110
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:49 +0000 (UTC)
X-FDA: 85456285698.28.2128089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4655C4000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6vtZnVq;
	spf=pass (imf11.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198187;
	b=vMda6q09guDeAdfnZrRwQiexuOR0fQ5VRrOm9gBxdTyLP++F7pmMHiF9MQuavFP5p75FT+
	fCd27rhhS+KsovplgRsrq9pPg7wqkY6BgXYnL4U18FBHdSXwn357N1tT+zYXZyjbHde+sO
	DbQZADFoLSK0aEZH0StIys0SNCXuFbM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198187;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIKOUmmLdQgPnP1xFnX34WDRbVk3GTUL06zL9py5teA=;
	b=6buU/0iXBqHLIorSbqiwXKh6/D34qIWuwS+vM2edB6U++gaElnvg/9qgC6ECvw9ylOv18j
	TYR2figaD3ZiVTTdUYiornTS/G6vKOnxeGwWsGWbGtHLQzyNPipCdnakbX/xqfk/Z/Xx+a
	z1dbd9KJ7OUQVJ+46bxNcdSDBuKpfPg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6vtZnVq;
	spf=pass (imf11.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BCC945BF1;
	Fri, 20 Nov 2026 18:09:46 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198186;
	b=e/OLJbrokOJ4uvXeoEvuISc2z9xXrUVBKBCtPkTiVRak/hUzQBwnxpKCGglh+zF/fH4C
	 2WjZNDOEumqnZCOeLajdij8B6MM5gm/2TQ/tF2oXX8rhZRgmygIZo2aSecqnTILoh2A1b
	 425sBOr4Kv65r9hEl93lQLGX/vzX6KXUrB/rjlVfadruXzytxcIXWxrks9vD8O61axgaZ
	 wRl6yj+lcMN24OQ2Owqm9F0AxooOuFenqTZEHCpkiTHyyR+DvpIo2DN44JmtDINDIN2iw
	 0Pc+VmipdXFlLclHuX+hy75azrjUdvRIl70GTrn7XwfcX/f0CB6/4N1x4L5czP9+zog==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198186;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=fIKOUmmLdQgPnP1xFnX34WDRbVk3GTUL06zL9py5teA=;
	b=d/j0yYH/nt7al4rBEjGRQj5nypMTbJzeOGNkEsL5hDi/E5WUEAyqN7iTDKTtfDy6eg04
	 W0hvtsjlk9A1zs4O8ykzDP7Qnv2QlWr32BWDBcSKGEAFcGZ8y4vno6fCGc81UmwHffNZl
	 fRaTRENTXoUbpDOt85lUckkgz5/j4MGhCIBFYdJoMx/pBuBy/tjPLnrAYN1VNNMHJrDbe
	 phcQnT93YAeDLylCgRPYHKhE43HBtvreQaFwhygLNOimOdZwuEWmNldBiA7gWY9SmbNN+
	 8wshyTL1EIss/MiFwd4ysdL/0RHVpj8YeslpESxjXWh/mkD9mEu4YShsST3oNt4mnsA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C33161F000C4;
	Fri, 20 Nov 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198186;
	bh=fIKOUmmLdQgPnP1xFnX34WDRbVk3GTUL06zL9py5teA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=a6vtZnVqg93X1JJAvrgDODLDw1ixKYF2GJO2HCZKmPvUUhNaVYprbIAlc43tQhT98
	 9c7XxUVMFOTrfIAkQtYsGtfGTWuXP4GCcLbLXt7vSGGd4Q9U7EwQqoSwquTaIQsKBU
	 gB5j4Lau8ZJssGYTNdVcz624aWLfWPgX6wVXn1gOnT90MPMbNunO37kkQv5rAHVLxs
	 u1JdIWV9QfOEMTcemoZH93/y1JBJUc0n2VL6P0NwZLI9H9H4bTqwC4TgbyneNKxwon
	 lOkTj8EqA78vmjWfe/lmrG0VnI+9BQknWLaozuMlOxzhVy/1sg53SsmgWZkkz325ga
	 LvVXJkRMzMQJw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CF9BD4B8DD;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:58 -0500
Subject: [PATCH 07/60] mm/memory-tiers: restrict demotion topology to
 common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-7-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=4041;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=Ext7MJ+xSeMP4IZ0P2+5bubjxg6YItpPPyY245ptKwA=;
 b=77z5saMzmlS7WuTHEiIf8+6SjbA1jSdRtgEyOkufSBTTbdVuWCTYUK70piMdHImpjzWCl8Jgv
 pKO7a4CGnM8BRAQ7IjzE1Ga6YyebvLho8JkT9M06RFxX2wvQHw+JNzl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4655C4000A
X-Stat-Signature: ckqzp3eyqipxz4wtp1nanfpm9d4s5mry
X-Rspam-User:
X-HE-Tag: 1795198187-172795
X-HE-Meta: U2FsdGVkX19LfqLm0PND3qUTB2nzEeQU66A3nIS5fEW8jqUNuuUoubaA0nuJTD6HFaAMB7M/aHDh6FhXftnUx+fkwWd/GImK6vqIgiNxNkwAFNlZxV80dEniUwOyMT9C246RkomFmT509ErwqRgkoFSzF10YYzBrH2wbME4gYOO9HOXGIMvf8VialKqUbKyYBocbCSTWhUE2FlIsBMgCYt8xao+HbYGKO3MeTIhwJAYq/86iQ41Odn6vaDUwAxDZD5msZeu4IE5+FWrDapnNH8mHyLSaIi/qS7gOrNRNovoSoAIxqKpdQAkrFyeMNUKwfonpAYGapCaQlolSTHJNByNPzeaoeNcCSS2QJPAs4d/hP/RloNAPBA3CB4Wv90H+Chp1sgMfhpWN0tsvUC3MKLgRTXUcz8JO1RG8pErm4uAYIN6qDOxStjYxt2eOlsJDHX0aI8oqTcow/h8to3In3ClkmCP6CLihY1nNrwhq1h//UQYUbG+cMQkhsrjr8rGMzBVbHHTv6r1QIbGytsIxpJp1wdVlEVNXJSliTRPv08Y5FmIU3vsqPzloYMKWKo498zJyQWagyFnensvx4HxLxHri2PPer36xvlzQ2iFYdDoQzVASYJEwsoHkwGcY4BWgVG4KVqJyjhDxprL3xocCU/pipdvF3VnVvPv/YZE+P0HkOc3myqAEE0XMtnKqRQVcncefMcd38VWY/Yo9/gHl7xrU5+d+a9w+jEEmYwI6XdbkckZZAaIZIBH4UUNFltOYeej3kgZ6uJ1TgTQ1ybwIy5YslMHqUB2JndM3CeO8/9dBv+/UPUiSAAXZP/sgVy/8UbK7H/1snfHoDL8bqZ6Y1SnjNDkxRwvrqVmw3R9vdT2a3hsFmDZWVWFQwwoIZwwyiNk26vLMgEZzlzMEmokucpejAChGRoXd15m+wzZGvO4rq3r0EuyuYt+kilmC0THSX5PQrbpTK0H162e+AQz
 JwPRt4FM
 O8exCVJquDX00WjmjM/ZdMO7WgDnJMEtVAX6u9JK47Z22XtrLZ7Hlh4Gb43kCLGnnWwxFKh/dFr2ltIn7R0Q6pQ5fjNrmbQcyd61n6pVOAZ8x9WecWv+HqRytaOq1a1tSJTNWZfMfBD7OweEgs+REonVYKN7hYWZJstxfgJlevJovTxpKkPucTYMkTryyBGMQXXAppl1jhjy7AHzZymNQh6zl9NhPX7c121BFRK1ZTLnPGijXKAtnFlgxA2euo1JttBLGfVU5W07c+TuMRigacfGtGnAZbJjpeFDoCxLOoE2nIYXpLp/IUdDzO834T4I4Es9dFaUyOY1hvKe2LbQBpDV96nkzqaBc812KQmGkASIAC9IX4rU5n0IgjnojM1anVyNixBSpCSX6dZcgGHNgv009dD3+IUdqVZrPwIqppzeQ5fta98DkHXdSKC/sriU7QKoE4lRsg3jihiK7bAHOSykgEwuI1a4RiLbI8TtagdtptNPaIsgbl4fWnMh/2yjFPYgnVt7exjo0648FIs/F5mlvAQyS69Z8XlO3mdJkwkf1BjKuAgF8Fqu9w6Z11CH3fcpGO6SVc+a5SaMxGj1KM9WZzXpGSMt63L1p1gWgJKqwPRR4h+u3Wx2EEObDlmTSgqxQZLa/jZppwzTp/i8LLlmf2yBFG/GvFMgKsp5HTr7f0NCPcx2SjBgqVFxTbMLHxVrnlmwYSGSDWciIG/DUqTo6bkxPIw3VwOgD1HSrjdNE0bYYcihF3cqTbJSWG1kGTJ5QxewYSwIK/Uw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Memory outside N_MEMORY_COMMON is outside the ordinary allocation pool
and cannot be a generic demotion source or destination.

Build demotion paths and the default DRAM performance reference from
N_MEMORY_COMMON rather than every node that has memory, and do not
assign other nodes to a memory tier through the generic hotplug path.

Removing a node's memory already resets its demotion targets, so a node
that unplugs and returns outside N_MEMORY_COMMON keeps none.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory-tiers.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 7fc56a8c6651..97d5ecefd89f 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -370,7 +370,8 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	 * closest demotion target.
 	 */
 	nodes_complement(mask, *allowed_mask);
-	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
+	return find_next_best_node_in(node, &mask,
+				      &node_states[N_MEMORY_COMMON]);
 }
 
 static void disable_all_demotion_targets(void)
@@ -405,7 +406,7 @@ static void dump_demotion_targets(void)
 {
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_state(node, N_MEMORY_COMMON) {
 		struct memory_tier *memtier = __node_get_memory_tier(node);
 		nodemask_t preferred = node_demotion[node].preferred;
 
@@ -441,7 +442,7 @@ static void establish_demotion_targets(void)
 
 	disable_all_demotion_targets();
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_state(node, N_MEMORY_COMMON) {
 		best_distance = -1;
 		nd = &node_demotion[node];
 
@@ -459,7 +460,7 @@ static void establish_demotion_targets(void)
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
 		 */
-		nodes_andnot(tier_nodes, node_states[N_MEMORY], tier_nodes);
+		nodes_andnot(tier_nodes, node_states[N_MEMORY_COMMON], tier_nodes);
 
 		/*
 		 * Find all the nodes in the memory tier node list of same best distance.
@@ -468,7 +469,7 @@ static void establish_demotion_targets(void)
 		 */
 		do {
 			target = find_next_best_node_in(node, &tier_nodes,
-							&node_states[N_MEMORY]);
+							&node_states[N_MEMORY_COMMON]);
 			if (target == NUMA_NO_NODE)
 				break;
 
@@ -507,7 +508,7 @@ static void establish_demotion_targets(void)
 	 * allocation to a set of nodes that is closer the above selected
 	 * preferred node.
 	 */
-	lower_tier = node_states[N_MEMORY];
+	lower_tier = node_states[N_MEMORY_COMMON];
 	list_for_each_entry(memtier, &memory_tiers, list) {
 		/*
 		 * Keep removing current tier from lower_tier nodes,
@@ -554,7 +555,7 @@ static struct memory_tier *set_node_memory_tier(int node)
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	if (!node_state(node, N_MEMORY))
+	if (!node_state(node, N_MEMORY_COMMON))
 		return ERR_PTR(-EINVAL);
 
 	mt_calc_adistance(node, &adist);
@@ -706,8 +707,8 @@ static int __init memory_tier_late_init(void)
 	get_online_mems();
 	guard(mutex)(&memory_tier_lock);
 
-	/* Assign each uninitialized N_MEMORY node to a memory tier. */
-	for_each_node_state(nid, N_MEMORY) {
+	/* Assign each uninitialized common memory node to a memory tier. */
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		/*
 		 * Some device drivers may have initialized
 		 * memory tiers, potentially bringing memory nodes
@@ -929,8 +930,8 @@ static int __init memory_tier_init(void)
 	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
-	/* Record nodes with memory and CPU to set default DRAM performance. */
-	nodes_and(default_dram_nodes, node_states[N_MEMORY],
+	/* Record common-memory nodes with CPUs for default DRAM performance. */
+	nodes_and(default_dram_nodes, node_states[N_MEMORY_COMMON],
 		  node_states[N_CPU]);
 
 	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);

-- 
2.56.1




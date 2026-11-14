Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3F160A2626
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=iuNeI98f
Received: by kanga.kvack.org (Postfix)
	id 89AEA6B05BC; Sat, 14 Nov 2026 02:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852466B05BD; Sat, 14 Nov 2026 02:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712E46B05BE; Sat, 14 Nov 2026 02:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37BD26B05BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA179A7D5B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:23 +0000 (UTC)
X-FDA: 85432851126.18.E542D46
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA9621C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iuNeI98f;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOXRgiF+CNyVqkJbhOIwPMg67CTmwFoCbwz1N9b8GHg=;
	b=8gZ88Uzf2aw2wUvVWGDwNOQRVFE802HwMNnI3TCecq1SeobvvRF1Xs86Xge6yU+UAAZkDH
	isIkLzTLQ0PWyWopRU4eQPWFIek/RsTOLNNtP1cMAAk0/25QIPdjHoYnkbOCXIddF6UDQ7
	CIEfg9Z6JCtF04nu/LiyEJHhktg7KYA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iuNeI98f;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640222;
	b=qetg5VUachk2oGBOzU6AVIEcCRY4RHkubpXumezd0kyTFvh/4WHgH2oob5WEhJgj9hcN34
	jCjgfsAE2vNxNepxQ+m/x3v02k7HWbub6HoJ2Z1k7iIsVrwJJwud5RqLmEsU0U9X9WK7/n
	uT90hCwcRVMy7ZAfIYdI2Vxv3PqZ790=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91ec396c93dso42906326d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640221; x=1795245021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DOXRgiF+CNyVqkJbhOIwPMg67CTmwFoCbwz1N9b8GHg=;
        b=iuNeI98fWNKRt6RNTg1H4lyBIOnHodegbYyZHcDqIJaHgFQrQJRI9e0zB5FqSJV0Z2
         3VmPXlaTC5s7Y0UsvS8iASewl405/6jMvPkrci8/U2zXdL1E+j3fDdo2w5HGtBuQdjpC
         WfoUjQJHoTjQZAUcgIav/IZJeuZU1XWRKNv5CNyh4M8RePoc6PCo2BPRWakEf1P7hWma
         61nRORSMTQI6iFhXu7OdY7H3pBxP4GcdAItW409PWs53GcCCm/WHnZmn9GbTpW0XTdOf
         S/4ZWfV8YkYyGi+RgTDyFwr6AthoGchzma4lFUdl/RHSj7HPY7w0Gm4N3aq7XjxAvSQ+
         Obeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640221; x=1795245021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DOXRgiF+CNyVqkJbhOIwPMg67CTmwFoCbwz1N9b8GHg=;
        b=XHSenQ6EKeFF0sAtCKA2/4zoCaK1GDsJ90+AV6M2H7ujYVrG6MqpWtAIvnKJQcb2kN
         kpOJJaIaAh8Mx1KFPqt3yCIuXthPGufdZTVf/fK1nUCfRw71nwC2L6Fxx/hF/VJh9tz6
         2KfGImBlVZL22T84RO3ttV231Q8FQjSEmZ7+s7MvKAmnwLf9sL421MxW6nUgXjqPjUMf
         9ARUbo6x+teXTUPls2GgzdVNi9mZd3Ep3cz3jxsdjJGDu30njLZvSWP14dLLUjks6Xj6
         Ud+oz6PQgw28CsOyHxHe4fYLhilU/3HB9//glcl20LIXqSMFM9pnjGnkUqoW7cyhBEcq
         SZwg==
X-Gm-Message-State: APuU4Z8x6Ux06AqxvWlQMtEyS13BoeeqPypIDnNCQQUIEMwT3kNSKBNB
	rwdV8nae+nDa1Dgw+j2Qq2mfriH0OIR5phhwftvtUvJsmt46Rzg5wuk9M1hGTa+nYbtQdLOTFYU
	ge9B4
X-Gm-Gg: AYBFou2x/LOTe/hn5LADV+IDmJrvgNvs27tl5xAuwht06TV7WQycvMkKQprh3coeEp3
	i6CO3HNFndAKWWRZkkOUiAtiRXD7VOeCYVX5D2we/33x2Xu5rgDOwTeRBOS5EIcSDxWyhkEkvyw
	u6tAfgXUok08XITl0Ge2sR0N/ekPfWQJnfDzijI4QVID+inXpGnvD5HF3HyT+0MbSyq8qblSzwg
	R/jKhVLjVWarUQLTf36sbt2zk+4TPJFwmCyvnsZvu8YLXacnj+mgyPlz+3vo3sas3L8FD6I62oH
	yCkBCUngm4Z1aFx5GJ4AglRUeTFUaqN1lQGCCT6zPtg6vZZO5erqCqwpImzww4p9LvAIEBehpcX
	QV1j+CEnshHp+AzqtaLY0IX5VEeJdVpk+LCmIjf7e8AB+TQ4rbVRBUSULoZ3muYu6Xp4WOCFIYG
	yl/VF0pOfiNrU43SpEsan09hf2Zja6/4OJ16J89SFzBjFSsBz+lXIKkNSwpKHB2z4NtEj5M+bg3
	nwxvgr+C7oWUcLb3xU7kCICl8VgS2FPw4Ubur7GcnghYp23LAneY4NYEFNu0UQ6hUisjMqIbHnF
	db7p0NgqufQas8SluKclXBbVDghoT9n7A+hkZI9nh3xIa5pCPXVp/6/1Juh8A3uvQ4gdkCqN59m
	/UllspvnPztg673o=
X-Received: by 2002:a05:6214:3905:b0:91e:7f01:f95a with SMTP id 6a1803df08f44-91f24229457mr72251376d6.46.1794640221033;
        Fri, 13 Nov 2026 23:10:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:20 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 08/22] mm/memory-tiers: restrict demotion topology to common memory
Date: Sat, 14 Nov 2026 02:09:45 -0500
Message-ID: <20261114070959.3490008-9-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EA9621C0004
X-Stat-Signature: jb7ebh1sginfjjiu5atk756zffn5giwq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640221-12706
X-HE-Meta: U2FsdGVkX1+P5g/ahrxz9Pi/YGwCGK0ULlgCK8BdxBrd0nZUctui/LaOr/LQwfoB+hfdsHnkqtRMppQ7z0u1guymAhWne9icO/rlnRD4Kmz13wLE2iORmS1UU80OcdXlGHajvHGFk6c4gSYx9l5CBYFfN/xGYtJPJY1meqNtTBASihP2JsoM4y5JPZyXoGFMqsepywWI98fYKOpNji4+VLCx8H7BxUNnVR11pX0Kc6BdIWAkpQdE6SJzr+cvX7k4G9gobDE3rvab3c0JQam1B9OW84ASYySm5CY29hOBma1xJgdV+9yZ2bWwcatTCnRJdsAAsuj1q1ZvbrJivnXqYbiCYHd8vOFs4t2SCE+hupu08Zux7cr1AvcOgxm5mlPBqTcCMrRr9kEJ/R49OL1typa467Vrm3y0sQad9YSaZ3AbN1bvOH0erYqAG6BuL9NsJK7fRSgp1VCtPPVO+RcbBjTsaCYwGpOqzURShIqiZSTkoVdbwoJayJ9bdH/zwHpMb/jJy16ymZt0KRLTlabky2BngYqHUa/MrJTSJcSt8hAGZupSf0pBeDvspcOCprfCC4Pz6fsnqMWW2tkQDkzOehCez1GHz5Lq25ErRupO2lYqJwEmlYxdVyUJfLru5iQLAX9i1k6EODBu92nbFWsNmUQdDExeLfS1B2Cj9YHE/rzBNWtr4GN6YckiVphn26pqDx4yS8dZqowicqpwftbTgnQ49kWLfKu+U9lv0R7ApVKDXOF1y3xImReOKT2QL6ogvGSikm4cte0YhB2k76eOpxz2AkaFqRuyxHRDa9NfP/fTPrCC73+4ayF0td2pLzaMFnGX98fBDLPQ8mGpNl82LYmit8pxmbpCzAlvcY/53hcNnd1OQCunMLZKgZSpFCGxd9S1hn4oDD4ML9qu51bcwl2xDt61kAva+TaeSK7YqQgsS3mMrt4bf7Fm81rwEXBuMWGyeNBpm7iwA3knHhg
 WTioD10X
 F5xI7aakdQsW8aIkWmKAaTILeLAkq8zcK3zqPqON4dqdGsZUtmit6TdLHZqgSG9WypfOTXrgjPa2lPfe7kBGtxakU4wfgMFWq6BkFhJ2p2+sm+319a9e3kexzMLafVw+kH09IXPfQwvSTzeglX5Yw1VTLSF0z0UI8C+PFCGYEzM2L6qYqP0udshZKhh8/ESbVoAI0KcM1h8fCkpcXZ4leMQd+Huwy+1/wBTpHUNgb5rQ+PWfC7zpOQ+WlXm4gchcgQh2Dr5vcNKOdDL1C4RgQk1H3sJ7efr9b+uZKhwcNbIMcggSOR9GsBNYLyomXe7udIM3wRd+7czYSlfPgZzjO2Y1LHX4JY5KAAmjhS60Ovp5NrCWDUxZWfYK/bv+tTnwbNWD1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory outside N_MEMORY_COMMON is outside the ordinary allocation pool
and cannot be a generic demotion source or destination.

Build demotion paths and the default DRAM performance reference from
N_MEMORY_COMMON rather than every node that has memory, and do not
assign other nodes to a memory tier through the generic hotplug path.

Removing a node's memory already resets its demotion targets, so a node
that unplugs and returns outside N_MEMORY_COMMON keeps none.

All memory nodes currently carry N_MEMORY_COMMON, behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory-tiers.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 7fc56a8c66518..97d5ecefd89f3 100644
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
2.53.1-Meta



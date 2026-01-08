Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EC6D1489A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC4F6B0088; Wed,  7 Jan 2026 22:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2EE6B0092; Wed,  7 Jan 2026 22:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A79F6B0093; Wed,  7 Jan 2026 22:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 393396B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:32:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E961C13B290
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:32:53 +0000 (UTC)
X-FDA: 84307375026.14.A2E2179
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 24DAE4000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:32:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uh8zOdzg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3YiVfaQgKCHsahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3YiVfaQgKCHsahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767843172; a=rsa-sha256;
	cv=none;
	b=ChQRpJArI9cybJ+ihfMg+QaO67vx874YXFe3WQ7MCoJJ3K3aGMcVgbaMl7i/zfYlZrJwFL
	G9AC2Mb1PvuusArC+QhnvmD/mg8grH7ShxvL8pGbTCN8Ydv3pNetxN6Fl610OrdPA2P2Gp
	RV9G2bT+d+X51n7qynAR25nuu82AM1Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uh8zOdzg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3YiVfaQgKCHsahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3YiVfaQgKCHsahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767843172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9N2n/A/xFOqww0bLkR+BJFNf/bzifVLVBrJ3PRlBCJs=;
	b=dOZnvtFvHmdWB89dW1fw2Jg6K5tpqHfQNsUkRfWs+QCwwSEysUX8oU45v0c7n2xiZ5zbzc
	DMB24NO+TJ4vaUb0YGE1K7d4yTy54dQIIZQ/Gcco5iO8XNBpfGN/Hrd92HTioYNRK82rk3
	3f0qdPlJ3/7nBZ3y5TBbRo6LEh64lMA=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-11f3b54cfdeso2586372c88.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 19:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767843171; x=1768447971; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9N2n/A/xFOqww0bLkR+BJFNf/bzifVLVBrJ3PRlBCJs=;
        b=uh8zOdzg/K3rzsT0C3QtXn6my5TD5C63mgNTpPxNk7DFI2hnCJUpCMlDmUy17ij0Di
         05hwVC7IypcpxEYW9v/EnuneVSmlCZlYrAZp9yBsay/OAnDZLbE72Xsk48fAX0yaQJt+
         uSk/g/vpxCYr8Ru1Cuon/IRKFYd4Rv9VX6+U7S9RA1Ft2f5YR+B4iz+mUzMPrJCXR944
         xwAKtTp9QsXCgys2LFpjoJgdIDsAvyuj3qFdfygV8wYhRo31ZZEZP5UdXffgMfYzVsMY
         T5Bk4q7NagaIiy7ckQ+QVEi/lG2lBjazOuN6t7P8i4qlsv1nbGEqlGg6kkOgIbPLFOyU
         5Y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767843171; x=1768447971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9N2n/A/xFOqww0bLkR+BJFNf/bzifVLVBrJ3PRlBCJs=;
        b=SzNLKOj2Un6jfI5pe84TK0ggIJXlYTrVE2/ZjJQzOgUYleRyz5mZQkM/A5sSNUo9aA
         wNal2zvU22gdMpdZz8ucZCdxWcj0KAek6jHdHRGvhZXZfEICnVPxbf79Wuq3M3IvuzPL
         wyNAlOMiUWGBdTDOoJeJvAJD60wWsfQBkfLL3rkcffMKuBwBx+F/4Xa66YxpcDBpI/Tb
         94bz6oN4W8+q8N1JeLYknr6N7buo4M1nRAnKNTGt8rENoa9izzUZ4c7GoOIquNbAg06a
         2GlP0Mg8x1dNS80H88VpT/kDfhQ4MflQD+hIX/DANFQnpdzL2Us15NKUjVJJF1hy0ttl
         MCZw==
X-Gm-Message-State: AOJu0YzTp4XU+r+6w+3j9+2euVFxyywzfTVx37y3yRnyUuLQpH7H09Vj
	BDH38izBVXylkB5WWPjeGEezhwBW7vxS+ehteRjN8LKsFXQsDbuuT9j1VEIj4s3NBJ9wDY5LOwE
	orOsC3ZT9qMlj91/nkeQFasAycHkxaxNXRwTT9wcueg1ZlN7w3YvZxPM9x/KWB1UbcScBkBIl/1
	qZErGYCdvIIsvz9RI9ZlpQKqqBq/XnWxFOx1CMZAF3rA==
X-Google-Smtp-Source: AGHT+IET88LLYKot81//F0JV+NGuMdk/eaOIcylgr5aPKD6MRjRxkZFDdcQCJxhMMoo4KCWk6qJGUBI8WeDuhA==
X-Received: from dlbrs6.prod.google.com ([2002:a05:7022:f686:b0:11b:b064:f5dc])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:2089:20b0:11b:2138:4758 with SMTP id a92af1059eb24-121f8b2bc09mr3374643c88.21.1767843170786;
 Wed, 07 Jan 2026 19:32:50 -0800 (PST)
Date: Thu,  8 Jan 2026 03:32:46 +0000
In-Reply-To: <20260108033248.2791579-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260106075703.1420072-1-bingjiao@google.com> <20260108033248.2791579-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260108033248.2791579-2-bingjiao@google.com>
Subject: [PATCH v7 1/2] mm/vmscan: fix demotion targets checks in reclaim/demotion
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
X-Rspamd-Queue-Id: 24DAE4000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 3ewdptn74cd8wizeue4bqdtz9nwubhqs
X-Rspam-User: 
X-HE-Tag: 1767843171-488562
X-HE-Meta: U2FsdGVkX18uh6oBj04B85FWTgdfGu6vUa3a9Xtfmofp2eZX3PBrMvTngcmv9/Jgyxlpwtn7DzPYKx0+Z8MhWWrTd6J+PRGPXLMGGeTlnung70tz07nmfVsIUFn5wJe/ChuQCxHcYmL8I5fzqg9Z8mmjvn2sK3B4nyQKsDmBn/vwWh+KpcAmUy0+sqETOiGNU8gxd52TeEkGxxDSd5otzPct+E6Z6XwzLti7FW9nERAHqrOzX5dGPcaZ0BQRsxfZsK6Nga9yB3ZfBqDa4uq3Yle7a7j63evZM0fJ8kfA8fe0qfAQqJPD6sOQ4iGwHErB6vhr3AlBrYFlXYB6o6yu7/nAbOnkPDGSNylweCAfWOl+QzIbraDt/dAbSRA6JS06qCDRXH5YRhVZ66Q+WQlo7amc/Neergt7yatWUlSBu5ODmh6atz2XrUHvC2TJRRisI2ZCv53XhgR0/IILDd6ynyKvgq+Cq3tYYFDh3h+shc8gKQXUIuhAk6B/gJ3oOTIw1TuS31Gko16wVFZJ8SGUHFR8CSW+/6XFC2rT65t91D55iLRGJp8Asd0Bne5G6MOnQEUKwU9amAOHENTKBno3wOcHdVjroExI5s9y6qsx7xspvv4So6BJsRWxfASi43rDKyPSUOJoDDQoejyNchDHI3XXGxeqnT+FllbW1zUcuD13bGl+GXPfn4BtPBBbnbj3AqAMF2w44ftrJ93QE8Mgh3a6sfyh8l0iIAQmeeSN3CXaTT4kuiLRpctC8GPe5mWwXc+Y5A4rOa9yqVFhA5bB5LGfzW7QtaWkNs7v/dvei+zK2bLsXRER/3N7ZGuaHjvSikaALRsv0sAfEEyOX7yIsAOjVtZau/wLlZFY3EC+En0hlrTDeqMh0WTdhxzQF8JtspoSIZfQrmmWxuE9U/dNcQs3MWDNhQLNE9gchSb/EsWx0HQh9+VRj3+IBKf3rUP44erTSh83CNIq6SZdSzI
 mqJtmnh3
 qG/PCcsMeelOZH2KjsxTH+ZlESwhM61vCBmnqMnPmlhRP2E3byGZCQtRJ5r1bA+PHLrTbTvBMEplABglp/vgnS7+HWjaS+635GZ6Dgl9tnkrQsS5RNGrqyu2JLGvQ/Dx1vOyijk4C/eQDpY/UppC8d3VHSk6JofRQmtF4oOEp0WTOy8ylk+szoA9d6QYTCS6a83qIbjzU4R7fpy5vvAyAImAP/nxDF95vtjkaYvieE0CEjwfTv9KJmt9B29eUsLo440PYwazOd/I2hAG1eGH9StCWiTF71VUJ2NV+8Nm4KSGEl08VCUaeF/HGbP+Cro90ImkPlgQm07pRXdqmfdPJdvOLzu4xl4ODIxyjUV6z7V0//qVf+UVioE97hcj3Z3E2gBFH8i8oxbEywyfNG9G2JIi60bdHa6g/lY41zYHe/ajnungTNw1itR0FbfNtzIUNESMVErdTezs95RJbRl8s5rHAwaMeRkSGiyWSWLZOiNOljH72pQMFEE8FWywF0YV/SFVWkYjk7pEgbgsX/GJsrhgwE9tZWxleHpkD/u+cWlxgJ1akVueTZDoLJK4gj9KYIm4tr0uE4orVzk95YGKmUhSPEKIcIHmir9NMj6ISq58L4kOmAswzzbe0TbdNVhQ1FjcXwLV1zOWQTGEeFUledlD/RIsCYBmeM8B3MZA2BLZBUX8x9QRVeyLLKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two bugs in demote_folio_list() and can_demote() due to incorrect
demotion target checks in reclaim/demotion.

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to can_demote().
However:

  1. It does not apply this check in demote_folio_list(), which leads
     to situations where pages are demoted to nodes that are
     explicitly excluded from the task's cpuset.mems.

  2. It checks only the nodes in the immediate next demotion hierarchy
     and does not check all allowed demotion targets in can_demote().
     This can cause pages to never be demoted if the nodes in the next
     demotion hierarchy are not set in mems_effective.

These bugs break resource isolation provided by cpuset.mems.  This is
visible from userspace because pages can either fail to be demoted
entirely or are demoted to nodes that are not allowed in multi-tier memory
systems.

To address these bugs, update cpuset_node_allowed() to return
effective_mems and mem_cgroup_node_allowed() to filter out nodes
that are not set in effective_mems. Also update can_demote()
and demote_folio_list() accordingly.

Bug 1 reproduction:
  Assume a system with 4 nodes, where nodes 0-1 are top-tier and
  nodes 2-3 are far-tier memory. All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Should respect node 0-2 limit.
    # Observation: Node 3 shows significant allocation (MemFree drops)
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1

Bug 2 reproduction:
  Assume a system with 6 nodes, where nodes 0-2 are top-tier,
  node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
  All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Pages are demoted to Nodes 4-5
    # Observation: No pages are demoted before oom.
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2

Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Cc: <stable@vger.kernel.org>
---

v6 -> v7: fix buggy code in v6.

Specifically, next_demotion_node() may return NUMA_NO_NODE if nodes were
hot-unplugged. V6 directly checks node_isset(target_nid, allowed_mask),
which will cause out-of-boundary bug if target_nid is NUMA_NO_NODE (-1).

---
 include/linux/cpuset.h     |  6 ++---
 include/linux/memcontrol.h |  6 ++---
 kernel/cgroup/cpuset.c     | 54 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 16 +++++++++--
 mm/vmscan.c                | 28 +++++++++++++-------
 5 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..631577384677 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }

-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask);
 #else /* !CONFIG_CPUSETS */

 static inline bool cpusets_enabled(void) { return false; }
@@ -301,9 +301,9 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }

-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+static inline void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
-	return true;
+	nodes_copy(*mask, node_states[N_MEMORY]);
 }
 #endif /* !CONFIG_CPUSETS */

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..412db7663357 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1744,7 +1744,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 	rcu_read_unlock();
 }

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);

@@ -1815,9 +1815,9 @@ static inline ino_t page_cgroup_ino(struct page *page)
 	return 0;
 }

-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
+						  nodemask_t *mask)
 {
-	return true;
 }

 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..289fb1a72550 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4416,40 +4416,58 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	return allowed;
 }

-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+/**
+ * cpuset_nodes_allowed - return effective_mems mask from a cgroup cpuset.
+ * @cgroup: pointer to struct cgroup.
+ * @mask: pointer to struct nodemask_t to be returned.
+ *
+ * Returns effective_mems mask from a cgroup cpuset if it is cgroup v2 and
+ * has cpuset subsys. Otherwise, returns node_states[N_MEMORY].
+ *
+ * This function intentionally avoids taking the cpuset_mutex or callback_lock
+ * when accessing effective_mems. This is because the obtained effective_mems
+ * is stale immediately after the query anyway (e.g., effective_mems is updated
+ * immediately after releasing the lock but before returning).
+ *
+ * As a result, returned @mask may be empty because cs->effective_mems can be
+ * rebound during this call. Besides, nodes in @mask are not guaranteed to be
+ * online due to hot plugins. Callers should check the mask for validity on
+ * return based on its subsequent use.
+ **/
+void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	bool allowed;

 	/*
 	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
 	 * and mems_allowed is likely to be empty even if we could get to it,
-	 * so return true to avoid taking a global lock on the empty check.
+	 * so return directly to avoid taking a global lock on the empty check.
 	 */
-	if (!cpuset_v2())
-		return true;
+	if (!cgroup || !cpuset_v2()) {
+		nodes_copy(*mask, node_states[N_MEMORY]);
+		return;
+	}

 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
-	if (!css)
-		return true;
+	if (!css) {
+		nodes_copy(*mask, node_states[N_MEMORY]);
+		return;
+	}

 	/*
-	 * Normally, accessing effective_mems would require the cpuset_mutex
-	 * or callback_lock - but node_isset is atomic and the reference
-	 * taken via cgroup_get_e_css is sufficient to protect css.
-	 *
-	 * Since this interface is intended for use by migration paths, we
-	 * relax locking here to avoid taking global locks - while accepting
-	 * there may be rare scenarios where the result may be innaccurate.
+	 * The reference taken via cgroup_get_e_css is sufficient to
+	 * protect css, but it does not imply safe accesses to effective_mems.
 	 *
-	 * Reclaim and migration are subject to these same race conditions, and
-	 * cannot make strong isolation guarantees, so this is acceptable.
+	 * Normally, accessing effective_mems would require the cpuset_mutex
+	 * or callback_lock - but the correctness of this information is stale
+	 * immediately after the query anyway. We do not acquire the lock
+	 * during this process to save lock contention in exchange for racing
+	 * against mems_allowed rebinds.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
+	nodes_copy(*mask, cs->effective_mems);
 	css_put(css);
-	return allowed;
 }

 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..702c3db624a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5624,9 +5624,21 @@ subsys_initcall(mem_cgroup_swap_init);

 #endif /* CONFIG_SWAP */

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 {
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+	nodemask_t allowed;
+
+	if (!memcg)
+		return;
+
+	/*
+	 * Since this interface is intended for use by migration paths, and
+	 * reclaim and migration are subject to race conditions such as changes
+	 * in effective_mems and hot-unpluging of nodes, inaccurate allowed
+	 * mask is acceptable.
+	 */
+	cpuset_nodes_allowed(memcg->css.cgroup, &allowed);
+	nodes_and(*mask, *mask, allowed);
 }

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..94ff5aa7c4fb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -344,19 +344,21 @@ static void flush_reclaim_state(struct scan_control *sc)
 static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
-	int demotion_nid;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	nodemask_t allowed_mask;

-	if (!numa_demotion_enabled)
+	if (!pgdat || !numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;

-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return false;

-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	/* Filter out nodes that are not in cgroup's mems_allowed. */
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	return !nodes_empty(allowed_mask);
 }

 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
@@ -1019,7 +1021,8 @@ static struct folio *alloc_demote_folio(struct folio *src,
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
@@ -1033,7 +1036,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1042,9 +1044,17 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		return 0;

 	if (target_nid == NUMA_NO_NODE)
+		/* No lower-tier nodes or nodes were hot-unplugged. */
 		return 0;

 	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return 0;
+
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1566,7 +1576,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */

 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
--
2.52.0.457.g6b5491de43-goog



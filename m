Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A681CD3901A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41386B0089; Wed, 14 Jan 2026 15:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F3A6B008A; Wed, 14 Jan 2026 15:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAC76B008C; Wed, 14 Jan 2026 15:53:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83A016B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:53:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45C4214062E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:53:11 +0000 (UTC)
X-FDA: 84331769382.30.45852D3
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6BB158000F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:53:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RSwOY9+S;
	spf=pass (imf02.hostedemail.com: domain of 3NAJoaQgKCCsIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3NAJoaQgKCCsIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768423989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rx4GaMs2Q/4qfts+N5AuEA3y8Pe+7VCYzOqGGqst5P0=;
	b=miywZYOIoiDJBDbbn4QShnyKfhOlLhxnzG1SiSfv++w3uJESLOzlrjObE1Ip9BI8++yyrG
	yHRJWysiD/FLQA0bDAUK/25oHqJiAqFjV1YooRQI4PJglNPzzIqqErOxxNDxJW3iTTS23m
	zATd9inVqJ3+8vYhlO/j2SygW2FSn3I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RSwOY9+S;
	spf=pass (imf02.hostedemail.com: domain of 3NAJoaQgKCCsIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3NAJoaQgKCCsIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768423989; a=rsa-sha256;
	cv=none;
	b=Y3tnpijbnhR01B+w9h1f+FzVUAtTzGLmod85GDiJ1rg51JtOdXEmNo0Zfi6/wVNpYK8U/H
	qqCl0JuyJulkF/AWlMFhRO+mYkOcwtTLrtIcPj9BBrnYw2WZNJNYVkuwVJa9M+IoGMH1gG
	WEzjFn/c/IEKxRKIt00ZGO89Bvft7AY=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12337114f3fso285093c88.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768423988; x=1769028788; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rx4GaMs2Q/4qfts+N5AuEA3y8Pe+7VCYzOqGGqst5P0=;
        b=RSwOY9+SDXWGmeNURrVHoWjNicnxzGiiCgcgBU1Mw5d/46/7TBpv5LEwuWpLtxyT6j
         Ca6Hf04LlQz2YgMJjHCvoulqWr71NmMQM/jKSMUR1XUWxmsmnGHMWN0RIF4ABl5vH44W
         UBeZ6vu0SCeP6YO9wztPuCNPT98bek9/qxDFsVMrXmdkWxERqZJTnYpgc2z/+vp2il/d
         FViXQfGeBcbsbKSCRLxM0nlLBgCzac32zs9DYsIHm97LHb3cVSWPI4MwrYdb3JYfL7Tw
         f/6HHE+vMJzQn2PsvYxWD7blNjN7FMuwJdS1dCxbSN+FIEykXJS6jt9Mb0hsnSaVWQzo
         r8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768423988; x=1769028788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rx4GaMs2Q/4qfts+N5AuEA3y8Pe+7VCYzOqGGqst5P0=;
        b=JYP1T6tZrRUEdEwiehzB+yyWePmibcpBKNjNCTCBmzzs4wKY0Ja26n0tnZ3QuNuMI0
         q2k6LiTe/KYMNB7321xvls5yAkJmIkoOQjAwc8Mi5eaQiKnpnT+4m4V3x4ZQA2aFNE3y
         2miQDmw86VB1+3HHCzYmh74ty9M/aT+dSFJ/PpldRha+29+/gR9kdxB4O40lYQkW2xTs
         TVmYeV5+vsprDPcj2Yu7d6K4mkbVpXGAbSTZFmAxNe26Kkhzt48dV+Btn80/EQiKv7cJ
         4ldfRvQsKarCye4YRbptSmgxfZONo4m27BtbPbLKJ2FljLrysv68TB671m3+FEV6FjrG
         lxeQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4CKrKqER+TI3jntr4CRsIO71S731SoW7MAPwwB4DNW/4RAQzYrdDRIyM9gvLIwBth4XoJpuDjKg==@kvack.org
X-Gm-Message-State: AOJu0Yz4Kwc4bigcTLErSYiyngMFeRlIXmDoxVzUMMJAX/w4qsD5YYca
	dATj8iAHNEo75KUwqP14o6zjSaJEJlGaPAaJoHf86UBmqKeDd7BJyAkt9tL8pViDOZ8QiWgoZo1
	ApyilrP5MyOMCXg==
X-Received: from dlbtu14.prod.google.com ([2002:a05:7022:3c0e:b0:11f:30f6:ea10])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:418b:b0:11f:2c69:31 with SMTP id a92af1059eb24-123377660bfmr4150749c88.46.1768423988024;
 Wed, 14 Jan 2026 12:53:08 -0800 (PST)
Date: Wed, 14 Jan 2026 20:53:02 +0000
In-Reply-To: <20260114205305.2869796-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260114070053.2446770-1-bingjiao@google.com> <20260114205305.2869796-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114205305.2869796-2-bingjiao@google.com>
Subject: [PATCH v9 1/2] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	tj@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gywfcumpt9eo7bxuet9ne91to195si4s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BB158000F
X-Rspamd-Server: rspam08
X-HE-Tag: 1768423989-479743
X-HE-Meta: U2FsdGVkX18+iUwoNm6FwbG0VrbjbmwIJ9JrTCBEoFTh+5iuKbZyx1HdBdM8sjKU966c96+tH+G/BDY3mfB2fLvbG0bmUPuggIcAk/7fu1XXGdD+Rcq6ykJ0YD68/pGhofvSv+hSY5oO9fO7PWqFdUiuAja/gM8TzehFjrMKQqbFPI7xt4aZrvDxgDofbS95ZOFwIerc/s9VhSbsxnWBNccxL1YTxe2Y5quFOOxKdtJ/FzvhoUIHGOcOivncDxSKDqwF0YH0koOcHLdzwuZAI3KIFP7wraliSvP3UcY6tUi/n3vStSeqoce8+rI6vk8xNUR8PysPk6X4fhSBLqLo7S97WAiaztr071Y9k680blMDZ/36S++4h2Zhl8Bdnon9cg880g/i2wfwBWJab1t1HzOsPr7upp76KBVEu39yAf28xjojWNjMwJ1i++pJddEwJig9iElH8+GRx+X6OF/f6qrQmH2n9inJKh0RtmUqXKfIQWD/eNz3DGdTRlUF3+U8GBlufyA6foRPRUR/sTagJ8pBChdX7siz6GJRKTcf+NXcHiPaQP9S4OmTDKCBTXcUSfSxyLzRE6OJAXLDhlmsj9I1XmrYvY3GosBAFTDEkv49atZoPcUnSFIvOuDAOt1MZDWk8nehEt5f5wevoRZiHHvbaK4QxLlThyM/S0Uo5fQ0sAmXXTsRDeM8BwJEpKtjUwXIHZTxg+HjCh/CObG1KLibBjfdR1PA+xD7BXXie4YAJagSDP1ROedZcAKKnVHoeT0SayzgiLaox9QVV6ARSu9EN18eRgh5DmVTjJ0+a4jG9PkHC3OgKi0vOfTOT6RiIYmeURVymMaytFFcnfsTWwXfLMSDkk8QpOxl2iHJ1mXUBitTppn77JC3jtWZ1CMBlvxzrvy/cMTPKx+yUFw8Vehc72I4UQ1AeTfmftZ7gK+CtCXvI8qbhStKsQD/8ROZRYwkovNxzkVtc24m90B
 w+HrxRzA
 qjbPb5xKxCMWrHBLlUuV5oy8+CGFUFAgX8kEhivobbXBuoTFuqaypFtKHnBe3azLM0V7Icn+uchEF1hXiTnlxlIVDliiTMVRKfOYyLYi9/THBL6nLC9+af3rVNKaVgRAaTiCYuyStdlxNr2McoLsDdJdpfcWo5R3DnJFOqgb9PLuplO9ZOZDwcdgbAFX9PuLBYkPJV/+Sv5SZa4lRRuBYeuhNwa2pgTxdlKP9vomK3BOLPIEb2ehYp6RMVB85CKVDT3T9oD8+FRPaSoUaYefDUcgnMDl4DcGdyepibX1EMwH1GgNDIzwafuu5bY7gDd6JyQSQFPEIG+UbhCObt4JXipZSLFRBTZFvpS3tASXznckxxQ4P77dLPARCo4PQZqMWTs+wEPnOp5OfEyo6nfd+Yhp7LN2tzZAMu8zv/PnXuHzj3n3aEjV1UgGKWP98cIfriaJeYzWEPI06VrxxFz6MqODcR9jEevWE5lCetwVMl+fex/5UGpIYauA0U0MccJldAz1MgO8/y8Rrf1nVDMhFxKr581jFNnTfb7o6CHmzuur4bn6VJFDExfo08MDJEa7cuevgeqGrkifOefpHO+3BUgoCXTI6ZE6d3vXhA4sOnA4nYUSBeu/RkSvbORYABxjkDyQWm7oN3dcKlMCUYoZYOjFdLpdiBeBAcjuoLeQfjvwJld8o8rh8XbX7rLMqIPvsGhOEaAiLZo6rBqYHpPiLrnnjMHTWqTTWBqYmqrYtxbK5ecE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two bugs in demote_folio_list() and can_demote() due to incorrect
demotion target checks against cpuset.mems_effective in reclaim/demotion.

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

To address these bugs, update cpuset_node_allowed() and
mem_cgroup_node_allowed() to return effective_mems, allowing directly
logic-and operation against demotion targets.  Also update can_demote()
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
v7 -> v9:
Minor updates in demote_folio_list() for better code logic.

 include/linux/cpuset.h     |  6 ++---
 include/linux/memcontrol.h |  6 ++---
 kernel/cgroup/cpuset.c     | 54 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 16 +++++++++--
 mm/vmscan.c                | 34 +++++++++++++++---------
 5 files changed, 78 insertions(+), 38 deletions(-)

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
index 670fe9fae5ba..5ea1dd2b8cce 100644
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
@@ -1019,9 +1021,10 @@ static struct folio *alloc_demote_folio(struct folio *src,
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
-	int target_nid = next_demotion_node(pgdat->node_id);
+	int target_nid;
 	unsigned int nr_succeeded;
 	nodemask_t allowed_mask;

@@ -1033,7 +1036,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1041,10 +1043,18 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return 0;

-	node_get_allowed_targets(pgdat, &allowed_mask);
+	target_nid = next_demotion_node(pgdat->node_id);
+	if (target_nid == NUMA_NO_NODE)
+		/* No lower-tier nodes or nodes were hot-unplugged. */
+		return 0;
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



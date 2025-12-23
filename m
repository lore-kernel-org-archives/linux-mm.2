Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90AFFE6FE2F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72506B008A; Tue, 23 Dec 2025 16:20:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC2F6B0089; Tue, 23 Dec 2025 16:20:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA056B008A; Tue, 23 Dec 2025 16:20:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A77446B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:20:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52E7DB9E04
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:20:37 +0000 (UTC)
X-FDA: 84252004914.14.FAAFAC2
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86A11100003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:20:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ekXv6rHN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3oQdLaQgKCC4LSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3oQdLaQgKCC4LSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766524835; a=rsa-sha256;
	cv=none;
	b=Nl4oRkSMcKWF1fO3ilVTLbDNWur+K6sNz1LoTsolRtgdramYJjibFAPjrtga4EeivKUY2y
	PMrbgPJ/NXHJSeGns8FlmWh9503NM2sS57Yh30qFtPXmEp2rde5/ZdyjCHpR0WyXMrzSV6
	mctf/726ZAM/4NooqZk4qi3UeeKsAYo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ekXv6rHN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3oQdLaQgKCC4LSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3oQdLaQgKCC4LSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766524835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYfxavFypXvQWKTZ6bRnNlNx9q/hbXcZzoHeTM07X9Y=;
	b=TdbKZP3BDXbsVgD85RHG68WsCmxAySOnRvrMcEVcKhB6KFtAGIOtOVsnhS1+7tISDCMPf+
	8nkAKGlpp0+44b6orJFJppsqg1SffB5revsotBTPdJbg2XpbFj2sqSsERkzYny0ig7CbVW
	Kb5cqJ1r188zp9U6iwU6p1M0i7rbNCQ=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f26fc6476so86766765ad.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766524834; x=1767129634; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lYfxavFypXvQWKTZ6bRnNlNx9q/hbXcZzoHeTM07X9Y=;
        b=ekXv6rHNXbQNb9WYIO3oUxkSnotxiKPJdZ6Lbv0L4R+kPKEN0Nzfjvr/FKP+mtDBWG
         7veeFe7pYf8blh8gS4+XnV/xum/6SBbmEtA7JAdJMAc2qetYlllyrQ26cPs7Cv1A/S9x
         pzjY0JmfpCJ3NO0K6CwaY5+dQRNet29+EFKnBZWNji6T2rCWiCBuPRo6wzTrieRhmEqD
         YGXP/2CRMmNK+qPTOYR4LZK562C0mONV/BCsua1bdU2CmV0BKf45Lnz7D8UgvohfPe6p
         GTUgskrOowBQfH9pPEtU5UQi0CCJjrFY97O1Cx7tQhGlEu7RwrUzRi8oDiJ0GlY4AKqI
         7/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766524834; x=1767129634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYfxavFypXvQWKTZ6bRnNlNx9q/hbXcZzoHeTM07X9Y=;
        b=rmOXhF7tjZxxUsUbk14zWc0yRsacTaJ8qYzj166NAYTet7AKkmL+MV1SC0Q3apwqTW
         F55BrNAetA5zoyqhxfqa1a1SRcx9s6uah2xCTDA6hqvutKZS4sxQLqGYv6FOnbVT36M8
         mboUc1C2QboyJyI0qrqt1Tb+r7tg0kYoj+7WpyThhkgGfw5Toa62qMk3kDigi2cwDfIr
         17Mg0hU5VM3vIQ5uWSBIPS6ZJWKlXALf53GMH6U/j4IhFGztdFjZAf/9+XUxtI7lypD6
         wxMxHX3kj8RdJd7PaoHJ2Bz/h0ar4L/pkngt0KOd6KzFAuVEg13msPZBHNwoaT33uBQj
         x8qg==
X-Gm-Message-State: AOJu0YwnyzA+ZVSRaNkhbYqHvDiEIGdhgy2vRzA9lpuOY6UJTKwoiOof
	NxYqaW8FP9cXrp463GhpPg4e5fvONjttklq5A0WVYTOPyyrdfsgF/iiYD3T2XmUOHf7nTc3Zbcg
	kGgIoKMd2BJw3veT79CR22EqgrUVPtTwKVVZrilPdr3Hx30jhuAJvGWktLCoxSxS3CeSXAEu7G5
	aW8fx1aHXQsFRnjHqgIa/iGnRSpDKbDgsfgOYQEWj4+w==
X-Google-Smtp-Source: AGHT+IGXR/gpiuAps+7fq4OauW9eemy4cSM5YIpNWsP7dLBZO0ns7cPZXMjmRfT48tgS6uiqxUjYwDaT0P2F6A==
X-Received: from dlqq20.prod.google.com ([2002:a05:7022:6394:b0:11d:cf7a:5407])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2520:b0:11d:c04a:dc5b with SMTP id a92af1059eb24-121722e03camr15593882c88.30.1766524833960;
 Tue, 23 Dec 2025 13:20:33 -0800 (PST)
Date: Tue, 23 Dec 2025 21:19:59 +0000
In-Reply-To: <20251221233635.3761887-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20251221233635.3761887-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20251223212032.665731-1-bingjiao@google.com>
Subject: [PATCH v3] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gourry@gourry.net, 
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 86A11100003
X-Rspamd-Server: rspam10
X-Stat-Signature: g7m8fexssewnjfkj7kcgufr6or5foppd
X-HE-Tag: 1766524835-641468
X-HE-Meta: U2FsdGVkX1910W/QwpCxW6LdFGnYsyqNFhqDu5ZV02FMlznGHawO0Lo9KpYMk5xiOI2Qp0xGTZ5M3DNz4qBndpXGOq+SOmbfNLSXNAnlqwlrsUHQ0JFbhGpZpa6aJTUDtaLJkmqWQ9BH0jc4Pbw/B69/UpMa1BiKOlW2dD0WcIN5ZJMY/G1ZOyG1WnKiIZe6zHdiw89ApfPC5zzMPVTfw6k2ndOWmRBDg6eqL8KBgM4S7xpsh3O1l7X9axX2N1vKToonHoTgZDLUE5RMmmDRWDwFYFQIX4oFmAbvk2mJ0lh/QqaAhxuguWT1q/t2fsxsduAPQ7ArO2He0dyCHYEMAr4N6fDc01L8/NZlOJxmvmInItsTLtLTTTlr741yQJuARkC+DEio3Wd/VeRhw8C2vmRv4BmFge+pDZ4Xt9xu4w30myxAukcCbGv63aAsklXH1T0QGl6CiSHB5CpTZre1/Y9NyuT9X63qctX76nG3E5Nr+h68d6KwZE4wvmqI91sSJJ/2F+WYbEYdLb/vUch6dLA41Se9ouwKiuC9IOYFgAr04I8zZ1bcYYHFJiDSpRUrtCCYxqmQ+Mglzav+Wv1Iiu72rqEYFZugj8Y1b4iY4VY+MJaeeea4lxduBEAlk/JsmhITc7nbdseL4CFkoSFFeI3Jiplk33WpdI6rok9MBAF8sLsatyaxOXByzo8LQnYjKSewD7vqe2AXHFC9aStfTf1y+NrCUWUSth56O/tFpvQBqRnHvNOAWtnPxWY0NhWeO7/uHSJyBkm01GZ3mwLFtotjpZrFzcotGx/Ph9ZBkkfol1HkHFGn0FOz2UEqoOyndXcId7FPWNMRgbscV7ewmxKBV19yIWZS3fM8Wp7+nTblXPelRhWEVk/NTdt2YOWMmh5gvE1E+Axli5bChTVUdK1NSrLP65WXLEebH/OMF+BF72jr4ACNT0MytdPbxDo652UF4g85aPuiS7EWAH6
 Q29IXueL
 lZgVbc4DPVfHqWuSJrqWLuiqhKpLCIEizxiXhEN4WQUOJBfNgTTPLdxmpc8+i6yT9NZddvWPyaPfJZ3mNzVccKI7Qiw1zgTAsxjy4vN0klrpeVJCB+c5327VN620hBOvmPgMzsaTo2T+uoYzCByqTh9D+uIDreDi0gonVdu3oZMPImmEaChnYNFiiHLQ0hXU1JiQOFdXPvs3ncVOrKl4wEmZUwZsQNw97UlVkbDx5W0AJON9ZIBCMVzaBs6EPqr8uXbNCUcrQzMEOW/fdIHHFr8rP8Oa+rss+si3IqgvmfM2wisbfCR6VhkW50qiJZp76W7guzX1WNU28j9oued99rAZZmQGZV1YeVVHJ4b/1Z+cO+Dy6wMDFtk5l7ojgzj7VWRPjHVD40+tqlW8fQiEXCWw1BLMRnhqlXoAvGgOXz2KkwM/gkSyV9nvPnCSW7MqbkFMQl3iTJ96HaZIrxHWoo9HMTli8WIxukSKgtSFPFwUAT6Tedz0EREw//8EqskRZUk97MqgbMZSiYKNBdk8spwLZsC1OBrMrBXYU+DT6uyZJRcb/AYmMuQEzUWhgrTSwnEIRQhOi7dedGpxnsXpD57c4xOm5EOsYVjNzx/8jaYcJ/Fs=
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
introduces the cpuset.mems_effective check and applies it to
can_demote(). However:

  1. It does not apply this check in demote_folio_list(), which leads
     to situations where pages are demoted to nodes that are
     explicitly excluded from the task's cpuset.mems.

  2. It checks only the nodes in the immediate next demotion hierarchy
     and does not check all allowed demotion targets in can_demote().
     This can cause pages to never be demoted if the nodes in the next
     demotion hierarchy are not set in mems_effective.

These bugs break resource isolation provided by cpuset.mems.
This is visible from userspace because pages can either fail to be
demoted entirely or are demoted to nodes that are not allowed
in multi-tier memory systems.

To address these bugs, update cpuset_node_allowed() and
mem_cgroup_node_allowed() to return effective_mems, allowing directly
logic-and operation against demotion targets. Also update can_demote()
and demote_folio_list() accordingly.

Reproduct Bug 1:
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

Reproduct Bug 2:
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/cpuset.h     |  6 +++---
 include/linux/memcontrol.h |  6 +++---
 kernel/cgroup/cpuset.c     | 16 ++++++++--------
 mm/memcontrol.c            |  6 ++++--
 mm/vmscan.c                | 35 +++++++++++++++++++++++------------
 5 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..eb358c3aa9c0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }

-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup);
 #else /* !CONFIG_CPUSETS */

 static inline bool cpusets_enabled(void) { return false; }
@@ -301,9 +301,9 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }

-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+static inline nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
 {
-	return true;
+	return node_possible_map;
 }
 #endif /* !CONFIG_CPUSETS */

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fd400082313a..f9463d853bba 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1740,7 +1740,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 	rcu_read_unlock();
 }

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg);

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);

@@ -1811,9 +1811,9 @@ static inline ino_t page_cgroup_ino(struct page *page)
 	return 0;
 }

-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+static inline nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
 {
-	return true;
+	return node_possible_map;
 }

 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..abb9afb64205 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4416,23 +4416,23 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	return allowed;
 }

-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
 {
+	nodemask_t nodes = node_possible_map;
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
+	if (!cgroup || !cpuset_v2())
+		return nodes;

 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
 	if (!css)
-		return true;
+		return nodes;

 	/*
 	 * Normally, accessing effective_mems would require the cpuset_mutex
@@ -4447,9 +4447,9 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * cannot make strong isolation guarantees, so this is acceptable.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
+	nodes_copy(nodes, cs->effective_mems);
 	css_put(css);
-	return allowed;
+	return nodes;
 }

 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75fc22a33b28..c2f4ac50d5c2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5597,9 +5597,11 @@ subsys_initcall(mem_cgroup_swap_init);

 #endif /* CONFIG_SWAP */

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
 {
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+	if (memcg)
+		return cpuset_node_get_allowed(memcg->css.cgroup);
+	return node_possible_map;
 }

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a4b308a2f9ad..711a04baf258 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -345,18 +345,24 @@ static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
 	int demotion_nid;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	nodemask_t allowed_mask, allowed_mems;

-	if (!numa_demotion_enabled)
+	if (!pgdat || !numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;

-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	allowed_mems = mem_cgroup_node_get_allowed(memcg);
+	nodes_and(allowed_mask, allowed_mask, allowed_mems);
+	if (nodes_empty(allowed_mask))
 		return false;

-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
+	for_each_node_mask(demotion_nid, allowed_mask) {
 		int z;
 		struct zone *zone;
 		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
@@ -1029,11 +1035,12 @@ static struct folio *alloc_demote_folio(struct folio *src,
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
-	nodemask_t allowed_mask;
+	nodemask_t allowed_mask, allowed_mems;

 	struct migration_target_control mtc = {
 		/*
@@ -1043,7 +1050,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1051,10 +1057,15 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
+	allowed_mems = mem_cgroup_node_get_allowed(memcg);
+	nodes_and(allowed_mask, allowed_mask, allowed_mems);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	if (target_nid == NUMA_NO_NODE || !node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1576,7 +1587,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */

 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
--
2.52.0.358.g0dd7633a29-goog



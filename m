Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17479C47BC4
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 07:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC8A6B008A; Tue,  6 Jan 2026 02:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7478E6B0093; Tue,  6 Jan 2026 02:57:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611E36B0095; Tue,  6 Jan 2026 02:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51F196B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:57:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 056581A086B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:57:09 +0000 (UTC)
X-FDA: 84300783378.02.0002ABD
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6ACA61C0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:57:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TGKq5XzJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3UMBcaQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UMBcaQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767686227; a=rsa-sha256;
	cv=none;
	b=xP6wSrlXV0TEECGPy0KlnYVsJLk/r6wevVtygk/Tz5jXxJDv8Mu2HX83zlZBThHfffNc/m
	mJXLtAaXyTAgm+qxyg+tr29U4HfmjgeqD2c26RYbLMXFZn5eBHFaKlBqAd8F9QjxvY/KNs
	F+HabnHV+c3DGLdIEmo/7uZtlR9X2+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TGKq5XzJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3UMBcaQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UMBcaQgKCJU07C587zD5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767686227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8I6bzOiZH4+w7fk1UyXGwIl0mPtX/zFBIM7Y3VpSCZI=;
	b=IGJvmgC77UnwGOW/dZyd7kIxCV+fVpCq1r3Py7c58BdGBi1fMJk1CyW9bDlnvy3ZIA0zTz
	t0fplFBD8xOVlPzx3BI7LyNZby5ehBL7Trr3FV/0e3NlMxP9TEifMdWFiHuwaqgU7/ehRo
	ZWuzllpJ9+pGIaYoN+48y5PqGYm6d3Y=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c38781efcso1537526a91.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 23:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767686226; x=1768291026; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8I6bzOiZH4+w7fk1UyXGwIl0mPtX/zFBIM7Y3VpSCZI=;
        b=TGKq5XzJUO4OGWmb5ZcY4c3calqTRy1wRBfkCdONzVgrxuPniAzdGBjvdwnpc1T5eY
         4Tawzg+PafeSLwjCs6epK3jTW09iSgGGXptBfRWuQONqGMIT6OUJ7kdnIZ6C3bx7CiaM
         nM3cEyFgxptmwDaacRfX4L3svwhDJ2rszFLz1kS2CQS+rDDXXG7zTcncUxOM3KBMxWPj
         xV6LVcz9GfJJm+LKp2YenwUwLCAErP5WiO9cOOU2oMoT1GmJB5t6qh9XjtTyEp5BSJ6M
         j3BA2IPJfco9rKPWCeXpMONJIiEbdDPrvkjyVULOPOU8SNBc9QiVsitQ6ER6BdNrnmG9
         PurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767686226; x=1768291026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8I6bzOiZH4+w7fk1UyXGwIl0mPtX/zFBIM7Y3VpSCZI=;
        b=jKvZanJT2bphD06wa12cxUBLO5OQf8Dv+XLNV12wxb2XIIWap+UlcGcle8xnKPRf0Z
         K/Xa38fNXu3EXIVh4EXCH5dj6EkXNdQhGXVe4ER4YzSxVtP0CNGq0Cfd1059J9Vw35FL
         wKkHnstENcKoUQ7e1dk+wS0fEy2KRmpR5VV8tR7lN7DzpCg2g3djHlJjLvd04rpYebSj
         uPDzNki7cIpX887JZs3iDzwJURI0oLjhYNoaxb3WZ4Dm5P6OiRPMZZ+YS0beLXI/tXEI
         gXcV+NzAV6YjnjgYdEkG4TLdpFexydR3y9EaPVml7XwQBlGYOzrQ51Ss5EWRW9AnHIOb
         r0Zg==
X-Gm-Message-State: AOJu0YwAiU1e1tKyE4RBNs6sXRN1QYTCyBIdRp7LJvP2CCzqkrhiGfkU
	5efkkeJHTsu8YswzSRWioYEkTuDYAPcxcFNTogOFnvzBZEkUMmIpLG4h27DO2RVrzi0FVTqWw+I
	YvA97j/YhV+B2YYxTfVKHibQCis/Fz79xi07Pjg4LGMsoEGU+cRMeBWheulBDZAa8iEUlgArKmo
	qTiTxfrg3H4RNjyeIsewgX0NDj5DkuDWpht1l645v2Vw==
X-Google-Smtp-Source: AGHT+IEsez7L02Ecm55mebNOy139pmMQ67Zpq+N532AmtheEnH6D/NMtGA9FyhzzVtQwv8il5D1rSqZdgnGmtQ==
X-Received: from dlyy26.prod.google.com ([2002:a05:7022:69a:b0:11d:ccc4:4c98])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:799:b0:119:e569:fbb3 with SMTP id a92af1059eb24-121f18e96e6mr2251394c88.34.1767686224919;
 Mon, 05 Jan 2026 23:57:04 -0800 (PST)
Date: Tue,  6 Jan 2026 07:56:54 +0000
In-Reply-To: <20260105050203.328095-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260105050203.328095-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260106075703.1420072-1-bingjiao@google.com>
Subject: [PATCH v6] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gourry@gourry.net, 
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	cgroups@vger.kernel.org, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6ACA61C0005
X-Stat-Signature: j5xk84e3a7959a6tq4jamdu74mqnhosd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767686227-189072
X-HE-Meta: U2FsdGVkX1/b41BUd9hvTHoGIdwwdQvifi0OkQ8VbSOnnaRC+4qG/alKYZkuiPRrEksNdolwO6XN7K/L88/+vWjh3wYdMGM+ZhxD/a1CU6sYaMD4/YCE3bJAykQJ1eiENoe060rTFMS6S0eXNdDhk2HWqKEbGIc0Qi5K1WfNRVixYDkj8/UI5GLpjdopbqz2XZPBp8JvpwJ2SW1rvQ1jNW97z0eZ1aT3W9f1au2tq4no7nJUX34RhQmCS5HvCNCa2D2tWOt4ujhpf16tt34yRKv6Dh8B1P2UzCvkJT4CnIayOoJFsQzLgS6U9g6OuZr3q0cWUoNLIxtLLFd7flE2KeFK68WqKhqk9LhJjcOXwSS2nBTWtS1FVte7Z8GeYO9LXXXGhWpn9uLwi7wr58yvUHb44FSnx6EMwvgxYkjQf0Fpw7I+XDXZQAjW1fCPQx/OArzQf3VnEP4wBa7mysd/qufCkshnjjm2MK4mBDRP1rYH0/3ZgwJIWyXhdmBYrk4w1YcsMqQ00F1DiNRVh9j4V+/U5kGAmspoprQxcE9JllXJvXCdOFEdb5p3ye2p2+oFBBo4yj+56UljnWVCmFV/XxTQHmdjxTqK8Rc3Sqp3Jiyu1ZKfoRUZ2gN3OsXNAwUwHbpzNbQqVRkRJIwJ1K2jvvyf49qYS+DatQafKeKuKZbisAK3HMGfZSQuXYU87H3Gd7oNN3nXUp4ex1sKru7kGqFdfm806qk2UFtzXNfM80KLgZOdxAPdniqn/+CE0+1eTIs92Nj4TTpbOLS53gprt+gDF79mb9QKdShWWtgycgByT2XqvcpgocKUYjuXU3D9YHgL1zIfLOMKXHeeYdwYufamQw1YRPqFfb+tPtuwLw+iyNICklMcPG7RZ/hQyQaQGB5da4J5+L3sbPRawg6PcKExsK079NaYVrJx09wyKc8uwgCNuUx/hpBMHgJNH7f4HO2dlJeqmWa1YeQrWDu
 QseNeK0p
 T/dv2aJ3SywrrlE36bHzN0DVSZZg8SbQSPCRqNIiFYc9JiIF2P4w+sO+Klpu7JiMp+WvI8rhKCxE7IWw2J17RNMffuKuOfPXnn27CpuPhkkH2tQ3kZ0aF0co3QvyBtTnmYbKlsO6zSz5Xb890QMygpiwFWzmBBMxSvjfEx1ymCv5NsnSjHpF6lXNOqxsMOsX12NzMsMdUtdX9fc5+MG5lJjIEZN1P6bwWlk6dIKvrJDX7zmRShhejWIVgpoU6paDDt+j2O5/Clttta7m+OQ0DqGCzKitOISCDBoB6vT3L3WEsTrulWb1184wfXw==
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Bing Jiao <bingjiao@google.com>
---

Patch against the linux mainline.
Tested on the mainline and passed.
Tested on mm-everyting, after Akinobu Mita's series "mm: fix oom-killer
not being invoked when demotion is enabled v2", and passed.

v5 -> v6: update cpuset_nodes_allowed()'s comments; move some comments
from cpuset_nodes_allowed() to mem_cgroup_node_filter_allowed().

---
 include/linux/cpuset.h     |  6 ++---
 include/linux/memcontrol.h |  6 ++---
 kernel/cgroup/cpuset.c     | 54 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 16 +++++++++--
 mm/vmscan.c                | 30 ++++++++++++---------
 5 files changed, 74 insertions(+), 38 deletions(-)

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
index 3e8cc34d8d50..76d7d0fa8137 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4427,40 +4427,58 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
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
index 670fe9fae5ba..eed1becfcb34 100644
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
@@ -1041,10 +1043,14 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1566,7 +1572,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */

 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
--
2.52.0.358.g0dd7633a29-goog



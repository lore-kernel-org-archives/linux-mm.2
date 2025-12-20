Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69CFE6689E
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 06:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A636B0088; Sat, 20 Dec 2025 01:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12716B0089; Sat, 20 Dec 2025 01:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D110D6B008A; Sat, 20 Dec 2025 01:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B81076B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:10:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58FEA140431
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:10:36 +0000 (UTC)
X-FDA: 84238825272.08.5179428
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9935F1C000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:10:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZZKWLxS6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 32D1GaQgKCL0elqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=32D1GaQgKCL0elqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766211034; a=rsa-sha256;
	cv=none;
	b=2/Amvi/s9dA4ebqqEZfCxJHPxxH5546o9C7g9g+DqTzVSnj3SAsG5ulKVisSPk+djCpJUo
	5MhnOrZ54/2uXfOqkN0BDYuy15l7+7DbIHiWN+AQUth7D0PTHuXtcJBs1ADG/xRR6ovUrc
	f0O9NtBMficAFPjIwEBnKOFbEzCGe5Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZZKWLxS6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 32D1GaQgKCL0elqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=32D1GaQgKCL0elqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766211034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vKo946kZ9pVLWnQ/K49l7Ogi2e3nAydeRACLsVD0qOc=;
	b=q/3NxB6VjOONBV3xrkSCkUx7iD5KC8/z61Tc7/olDDopHUXx38rXSsWFyY343iS8JHeAvN
	MGCnQx5SveCVPLFnvqbALgz6NK8yNvdSS0+iYUyHh0YUtMgOhkLSys7ISf8N57lbx4v0L9
	GjY3UWLS4VyJiFA2O9l5dv0d29XxUio=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c213419f5so2312736a91.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766211033; x=1766815833; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vKo946kZ9pVLWnQ/K49l7Ogi2e3nAydeRACLsVD0qOc=;
        b=ZZKWLxS6mNbTD21U5zURiUpEcmD7rfTO9M0DabVRKPEWkkr8McM65O679RVK8mKWyd
         giX31Yxnv8yJ3tfCBbz0vqQCu5CCNZdvSZj+EZput5VkKKtU1G0qKUmtqgjU/jUV2No7
         h+fsyOHotWcFC4VuW0Wi411yFkkuEgNt4L82q7TWqw6mFRgZif9S+Q+DJ68p4ocPi4Nv
         QjHTylLRDFqeYnzkjBPkaMzsnPQ+XF45EtpldL1qrW+/pDHwz3t8G02jGZvvVbDmRcU0
         HXPpnIKTWDrRU6cWSmpeqvQyXJurHV1F8URz3wZbW+RGpakcr2OXFt3TH8YttPXg7aej
         0h5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766211033; x=1766815833;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vKo946kZ9pVLWnQ/K49l7Ogi2e3nAydeRACLsVD0qOc=;
        b=bM0lo0zVFUwlmCknDw4VtLgCB/RHBQzupo3DPRMFc4WX0APZaOuzKhn8EkfsvUxm/F
         wIF+54LrHKd3sJKHfVxBMk4nISkBxXiEcEdpl3i5RwvFuRbKajyxS0zen0HZ4+8O5Ppb
         qUb6I5pNQ+YSrKGI4MjhjXocuQWU4fUoerzAd0RGKZXv6B2Fq62/XHVGX3+3GIcx2Zha
         MP+U/QWPqlEIqwf/QY9BB/Y0KxY/ZlUgylQnShfln6qMmF/ALnt3S/ZJwrND14MjqZbG
         CLaOYuHBvs3wczG0eyUpJ+jkKMeVoSJy61MsrRETY6fK0GqweJL9+5hX9KinMKESeQLV
         bLFg==
X-Gm-Message-State: AOJu0Yxt9pKoaFqGORG23nBR41prUZfpin7ecPtMm9cMqgQDhT78pOix
	9yZNujtPU9jOwcnfliU9nvJIeyRkafTSFz/cHmfXJG8Vee7Qy/S75VOcY1DkTEwlM3sc+TwNA20
	lGV2dG2+wVZ8rRkviFMccdHuTSsVAimxXyZQYjgFi1DvK49HRdDYY639i8x7bJK+2JKdMUM9ALh
	uL+P+B+InkzuijQHIL4p3aPADeTgr7oRh0RGPrsEX3IA==
X-Google-Smtp-Source: AGHT+IFmLXO2Pg/zpC2Amug9pMikW3Q50qrP5JzCe6kGGASDSQr5U1AbfMqmNd+xCK0M7dFx9SfgRLK7MSzAmw==
X-Received: from dlbps14.prod.google.com ([2002:a05:7023:88e:b0:11e:64d:cd3b])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:ea50:b0:11b:65e:f2d with SMTP id a92af1059eb24-121722ab60amr4061084c88.10.1766211032987;
 Fri, 19 Dec 2025 22:10:32 -0800 (PST)
Date: Sat, 20 Dec 2025 06:10:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251220061022.2726028-1-bingjiao@google.com>
Subject: [PATCH] mm/vmscan: respect mems_effective in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: gourry@gourry.net, Bing Jiao <bingjiao@google.com>, 
	Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9935F1C000B
X-Rspamd-Server: rspam03
X-Stat-Signature: fwrchbdth74ysw7h8mtui6eradac4geb
X-Rspam-User: 
X-HE-Tag: 1766211034-792817
X-HE-Meta: U2FsdGVkX1+9Sc6HZ2dxZLmrBBqYhECW6EayVMhtnjgX+eVBcf9WRBW+7OnoeNme3QlLVqJ0c4GmIFrDKaS1MRArvBYbf1QArc+KO7gZm6LWjoS7FM8PRJzvOTqoxqLZaM8vh39ZFQsKCPoy1ikkZYH8JAMwnQHwkQ6UTC0qwc49c7vpBFv0GDvfyDNPbjQ3WEYTn49VYWKc1E6jjPOhVpKpDpRc/nmHUGxJyCW53nHJyIk7aUxrfgwW7MOxkH2NnFIMPVXKI8WmUVaz8yQuv9gPUTAj8NIe4IIYDQl6qKvvD28bRu9rr+hgIJq+hZsFmohufk420/P7VcmQahgKwx0QaFmgHCdxSG/xpahgohU5cl/7nsm8rW6TwxxjcH8wMFpHggrraAzv4WQ9c3XB/OeBhb78tfz15oddMtIJklBdgYFaGZXNI8HMM711C6uiGTNm0sayTmqMc/taPiU1NkqudOJuPjQMzEl0JThLzAgMOQ/cm7SgEOsAve7+N6n7QDNOreSNBVM+vFB52zzYRqmHTjkJv164gMOabtgzKA92UPcId3SyeJL0Vb2d2xEFTZWqqnJs9m3lbaL04rkT0ehMLu+7TnfYoi4/wJrBLuDB14eF1WA3yC9R1BkPcBzvpfxtttFEo763+Rl3QAONRmceUh4hdjzBgawDNOR2BAHw9XoryR/mbXgbKEv6/jmvsMlBkF0Gmr2o6D9kg6yE2ETBfP92tOSm2HK7WShl/+FAmr3GQD0kJwnjm7ST2j96t/cNv+4Hf33D3jgwJlB7u05JudDD2rjOx23ZDgcjjWAEDzSctlR+UiI+3EnT4w5oLBcg5p6gmDrGLA/xcBtT4qJd1/wfYzHpWlilOdWgf2z6jMQlu5KwEIgQ34Lvn+ca6vx1yXvHqgmM1ZYWK6pXG/NfR/g+99fk58aOUDDkmbH/olKpEODHyEHQz8g6bfCpLWAw/uly94WgipXpaTj
 aKs1dVLS
 ZPWRJbwWvNCsuC0hSDIcOBSTBz0t+rtBJoukf8K7T08DzkMLeCCu/+WEsKWRfB4Z7cH5VsAmyUT05wqS0z8UZSRm3bDHdlg9MzVEPTE2jCYr3jP02077IgyoSAYee1LfD87O3wDq3Vu0Razm0JNGnc86RtaF9trMnojIgEjXdmWreoFN3c4kd3cZpMG6QVaLZjZ5IgE0ond5qAjpYk2NH4XjNF1BRmDqiuCGi7ZcavDSTgRdW8ua+TJBtWzI+95v0x6jVMSyknpxaiiSPIXXeAo+1wdQn+Cze23g6s7KK4OSwI7i75638MwTBFVnJwsret4rqHG4pq1SFwVRidpHZZuI0PuLavKL9kM0P6Z0kxE+G++kRk5h+vION58zsx7R6UaWBti4HY4SdWKal8+MTkCgi5URGppox6Wq3/gRdjc6CyuR+Xwy3Tuk/RBP1PilAy3w1pOY3olMPvPruadkRWXYv8vfgdaSYT/28gwygR3yfXh8sNqblsqQ093G9tRgruQ8Bgg4q10FvnpHorC94HzzMYH3SpRaWw9G5if70oa/hzdwOoxrPJQqnjocd1j/98k2jIhLJg3zvpNBPbWX70ZrTXagjveRdMFarQbMIvyEawqwkaBWKzuwoL+1tNyjVyIy2uWZ00Zs1aSk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to
can_demote(). However, it does not apply this check in
demote_folio_list(), which leads to situations where pages are demoted
to nodes that are explicitly excluded from the task's cpuset.mems.

To address the issue that demotion targets do not respect
cpuset.mem_effective in demote_folio_list(), implement a new function
get_demotion_targets(), which returns a preferred demotion target
and all allowed (fallback) nodes against mems_effective,
and update demote_folio_list() and can_demote() accordingly to
use get_demotion_targets().

Furthermore, update some supporting functions:
  - Add a parameter for next_demotion_node() to return a copy of
    node_demotion[]->preferred, allowing get_demotion_targets()
    to select the next-best node for demotion.
  - Change the parameters for cpuset_node_allowed() and
    mem_cgroup_node_allowed() from nid to nodemask * to allow
    for direct logic-and operations with mems_effective.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/cpuset.h       |  5 +--
 include/linux/memcontrol.h   |  6 +--
 include/linux/memory-tiers.h |  6 +--
 kernel/cgroup/cpuset.c       | 14 +++----
 mm/memcontrol.c              |  5 ++-
 mm/memory-tiers.c            |  8 +++-
 mm/vmscan.c                  | 77 +++++++++++++++++++++++++++++-------
 7 files changed, 87 insertions(+), 34 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..27a0b6e9fb9d 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }

-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern void cpuset_node_allowed(struct cgroup *cgroup, nodemask_t *nodes);
 #else /* !CONFIG_CPUSETS */

 static inline bool cpusets_enabled(void) { return false; }
@@ -301,9 +301,8 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }

-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+static inline void cpuset_node_allowed(struct cgroup *cgroup, nodemask_t *nodes)
 {
-	return true;
 }
 #endif /* !CONFIG_CPUSETS */

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fd400082313a..a87f008b6600 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1740,7 +1740,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 	rcu_read_unlock();
 }

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+void mem_cgroup_node_allowed(struct mem_cgroup *memcg, nodemask_t *nodes);

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);

@@ -1811,9 +1811,9 @@ static inline ino_t page_cgroup_ino(struct page *page)
 	return 0;
 }

-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+static inline void mem_cgroup_node_allowed(struct mem_cgroup *memcg,
+					   nodemask_t *nodes)
 {
-	return true;
 }

 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..2706ebfa94b5 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -53,11 +53,11 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
-int next_demotion_node(int node);
+int next_demotion_node(int node, nodemask_t *mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
 #else
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, nodemask_t *mask)
 {
 	return NUMA_NO_NODE;
 }
@@ -101,7 +101,7 @@ static inline void clear_node_memory_type(int node, struct memory_dev_type *memt

 }

-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, nodemask_t *mask)
 {
 	return NUMA_NO_NODE;
 }
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..2d78cfde5911 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4416,11 +4416,10 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	return allowed;
 }

-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+void cpuset_node_allowed(struct cgroup *cgroup, nodemask_t *nodes)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	bool allowed;

 	/*
 	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
@@ -4428,16 +4427,16 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * so return true to avoid taking a global lock on the empty check.
 	 */
 	if (!cpuset_v2())
-		return true;
+		return;

 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
 	if (!css)
-		return true;
+		return;

 	/*
 	 * Normally, accessing effective_mems would require the cpuset_mutex
-	 * or callback_lock - but node_isset is atomic and the reference
-	 * taken via cgroup_get_e_css is sufficient to protect css.
+	 * or callback_lock - but the reference taken via cgroup_get_e_css
+	 * is sufficient to protect css.
 	 *
 	 * Since this interface is intended for use by migration paths, we
 	 * relax locking here to avoid taking global locks - while accepting
@@ -4447,9 +4446,8 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * cannot make strong isolation guarantees, so this is acceptable.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
+	nodes_and(*nodes, *nodes, cs->effective_mems);
 	css_put(css);
-	return allowed;
 }

 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75fc22a33b28..a62c75b136ef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5597,9 +5597,10 @@ subsys_initcall(mem_cgroup_swap_init);

 #endif /* CONFIG_SWAP */

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+void mem_cgroup_node_allowed(struct mem_cgroup *memcg, nodemask_t *nodes)
 {
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+	if (memcg)
+		cpuset_node_allowed(memcg->css.cgroup, nodes);
 }

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 20aab9c19c5e..ed0ee9c3ae70 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -320,13 +320,14 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
+ * @mask: The preferred nodemask copy to be returned
  *
  * Return: node id for next memory node in the demotion path hierarchy
  * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
  * @node online or guarantee that it *continues* to be the next demotion
  * target.
  */
-int next_demotion_node(int node)
+int next_demotion_node(int node, nodemask_t *mask)
 {
 	struct demotion_nodes *nd;
 	int target;
@@ -355,7 +356,12 @@ int next_demotion_node(int node)
 	 * last target node. Or introducing per-cpu data to avoid
 	 * caching issue, which seems more complicated. So selecting
 	 * target node randomly seems better until now.
+	 *
+	 * Copy preferred nodes as the fallback if the returned one
+	 * does not satisify some constraints like cpuset.
 	 */
+	if (mask)
+		nodes_copy(*mask, nd->preferred);
 	target = node_random(&nd->preferred);
 	rcu_read_unlock();

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8bdb1629b6eb..2ddbf5584af8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -341,22 +341,71 @@ static void flush_reclaim_state(struct scan_control *sc)
 	}
 }

+/*
+ * Returns a preferred demotion node and all allowed demotion @targets.
+ * Returns NUMA_NO_NODE and @targets is meaningless if no allowed nodes.
+ */
+static int get_demotion_targets(nodemask_t *targets, struct pglist_data *pgdat,
+				struct mem_cgroup *memcg)
+{
+	nodemask_t allowed_mask;
+	nodemask_t preferred_mask;
+	int preferred_node;
+
+	if (!pgdat)
+		return NUMA_NO_NODE;
+
+	preferred_node = next_demotion_node(pgdat->node_id, &preferred_mask);
+	if (preferred_node == NUMA_NO_NODE)
+		return NUMA_NO_NODE;
+
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return NUMA_NO_NODE;
+
+	if (targets)
+		nodes_copy(*targets, allowed_mask);
+
+	do {
+		if (node_isset(preferred_node, allowed_mask))
+			return preferred_node;
+
+		nodes_and(preferred_mask, preferred_mask, allowed_mask);
+		if (!nodes_empty(preferred_mask))
+			return node_random(&preferred_mask);
+
+		/*
+		 * Hop to the next tier of preferred nodes. Even if
+		 * preferred_node is not set in allowed_mask, still can use it
+		 * to query the nest-best demotion nodes.
+		 */
+		preferred_node = next_demotion_node(preferred_node,
+						    &preferred_mask);
+	} while (preferred_node != NUMA_NO_NODE);
+
+	/*
+	 * Should not reach here, as a non-empty allowed_mask ensures
+	 * there must have a target node for demotion.
+	 * Otherwise, it suggests something wrong in node_demotion[]->preferred,
+	 * where the same-tier nodes have different preferred targets.
+	 * E.g., if node 0 identifies both nodes 2 and 3 as preferred targets,
+	 * but nodes 2 and 3 themselves have different preferred nodes.
+	 */
+	WARN_ON_ONCE(1);
+	return node_random(&allowed_mask);
+}
+
 static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
-	int demotion_nid;
-
 	if (!numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;

-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
-		return false;
-
-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	return get_demotion_targets(NULL, NODE_DATA(nid), memcg) !=
+	       NUMA_NO_NODE;
 }

 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
@@ -1019,9 +1068,10 @@ static struct folio *alloc_demote_folio(struct folio *src,
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

@@ -1033,7 +1083,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1041,10 +1090,10 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

+	target_nid = get_demotion_targets(&allowed_mask, pgdat, memcg);
 	if (target_nid == NUMA_NO_NODE)
 		return 0;
-
-	node_get_allowed_targets(pgdat, &allowed_mask);
+	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1566,7 +1615,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */

 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
--
2.52.0.351.gbe84eed79e-goog



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6965E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2326B05B5; Wed, 28 Oct 2026 22:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9A16B05B6; Wed, 28 Oct 2026 22:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6F36B05B7; Wed, 28 Oct 2026 22:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC8F6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:27:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE5BA160264
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:27:04 +0000 (UTC)
X-FDA: 85374076368.20.31D5C5C
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf18.hostedemail.com (Postfix) with ESMTP id 70F081C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:27:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0potvkYEPRlBVs0JY9bGCY/Z9bEA7EZBxzgXkkqzVY=;
	b=LwMch0ekg0XS3EYRpLrKe5xLgP6PUbowvq0fyUSCYl24raJOBGLbcD85Fcuqa6h0q7gOiX
	lG9muV+wwRO29vPH5HSUwtnLWMtToIohjVLZEncCf0mfc9BpSgeYHzgLTCqVfLgsUxGjwv
	kgYe2PkR8nKSDKWk0HPaMTzIFTkBN+s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240823;
	b=ppI+gI4m0vShmBFjXu9g9UAzRz8yagV/d2W6OePa4k7aOuza/eY5h3ugi4RJ30mtOzEolb
	EVUCcAi+Be4/2SajMblycfe//LjKtcQ2F0vhkohsCwMgpD6MY69FFP6ZhATzR3ZKermVFR
	5uhf8DKizRzj+3P6WYZkLfPTXTmW1e0=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSmJ6wZ1z171YL;
	Thu, 29 Oct 2026 10:26:56 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSmH3wZqz171Yc;
	Thu, 29 Oct 2026 10:26:55 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 38BA2314AC01;
	Thu, 29 Oct 2026 10:26:32 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:26:54 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, <ljs@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: [RFC PATCH v3 01/17] sched/topology: Add llc_to_node() to translate LLC ID to NUMA node
Date: Thu, 29 Oct 2026 10:20:19 +0800
Message-ID: <20261029022036.4002331-2-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70F081C0002
X-Stat-Signature: znx1qgyedidd48z96iwuik6ro3554dxc
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793240820-233548
X-HE-Meta: U2FsdGVkX1//ZLSCZgasd37B4e1JsYz42UnRVtka3xB/wS/RA/PNhEk6APwH8+wky5+erNuRlCJPPwb84vEbNyly1Mx5YzIHX/0DMtaW9FVOBCwt9KKTer6LE20P0r4sx5Sj0ZB3MANVAslHFF+CP675DjQUD8PaAWPraaEcYI+meBGyfF8ed7Mk3yF/OoBVjdmE5DM6nrWYI/qpo8a8VMEQleH71eDlz+c/wquUBlyMAEkzrLDBkNTXaNKyZGFGazsyVd4X7eAKvfgYD74pm0WkwKzvvw2FCUu7MyIOvpnNA6wLy/iO2oyYlKRFsBS3RNvnpJZ5O7wfMdwm+IeywbiYXBNAyayfb4jzTVFRNJdWBzPVb4bUtU+wX1lA1tl7lPE0LJFeA1PJXTQklQsSOiu7Ju1bXbiqZiBmQRjLPXOcVWetkkSoTB2QYvl2PoRA9PxGg6jJkEunCfRHwfl+AFisCX4z6xv3TtdW89awQZQ7+E5+JpHe3J//ZO42GHmiZvolxEPlMgFtItYO+615UmT8vkMK6XiaV5pdIHdmJqWJV0YY1ep0V8NJNcP90SSaeIeoZOOy1nyxWyv06PRo0amUGRnkkcNcFh19+ycvLgScFbezYXoMmzlpRhrh6c2Ow1iWS2hTEau3rMEDGaSaAbvohn7BI9tgAc55hDSM1TOoPqjaoR9kvuyXyoXhjP0F7KfHUpN9QzrlGYhmJqO2Wkl2ZlXpKr3kOjyWQi/SI1uvsSBSvjvQqHzIBGqoZyZQD0n+zYp8Jz1IdC0EJ+THI87jWHFSl4m+O436FG9VMc2faofI7G6hqIIV2sBNJJHMAx8FG++xQhmebpRugniBM2SbR+ctHuhv+CKYBg4oeEfqaFublgap5/JNNyW6r1zoTrJSaQ2hlhqfCil7e6wkilEAYlrcfG336mwQK8A6munAFi7mOe3iV2DJr+pH2patTNZe67nREGFEFoBjCex
 xk+g5j8D
 ATM+tpYdaI245TriUT2/uDJ8wzopbQtioiwnJg2N0m6GugY7WW8bQHRBMqgStTX8BxE5bFX57diZVKTKkIkfrS3Xva+6r29e3pRUmH0Gls8Bvw+n6XZh+GJrcgS1F24Ol1km9nvgVgmgV+u2Y3fpyQlKCdFDNPtX3gK6VQBdYFW5YF69MgJlmiUVv/uCshxucP/Lm41TnsZqN78k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Building LLC affinity sequences requires knowing which NUMA node each
LLC belongs to. Add a per-LLC-ID NUMA-node map derived from possible
CPUs that currently hold an LLC ID, and expose it to the scheduler
through llc_to_node(). Unassigned IDs return NUMA_NO_NODE.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    |  1 +
 kernel/sched/topology.c | 93 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 56acf502ba26..4ee223416012 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4107,6 +4107,7 @@ static inline bool sched_cache_enabled(void)
 }
 
 extern void sched_cache_active_set(void);
+extern int llc_to_node(int llc);
 
 #endif
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 622e2e01974c..18171d2338fe 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -685,6 +685,24 @@ DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_cluster_active);
 
+#ifdef CONFIG_SCHED_CACHE
+/*
+ * LLC id to NUMA node map. The number of entries lives inside the
+ * RCU-protected allocation so that a reader bound-checks against the
+ * length of the very map it dereferenced. max_lid is updated by
+ * __sched_domains_alloc_llc_id() well before rebuild_llc_node_map()
+ * installs the matching map, so it must not be used as the bound.
+ */
+struct llc_node_map {
+	int nr_llc;
+	int node[];
+};
+
+static struct llc_node_map __rcu *llc_to_node_map;
+static void rebuild_llc_node_map(int size);
+
+#endif
+
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain_shared *sds = NULL;
@@ -856,6 +874,64 @@ DEFINE_STATIC_KEY_FALSE(sched_cache_active);
 /* user wants cache aware scheduling [0 or 1] */
 int sysctl_sched_cache_user = 1;
 
+int llc_to_node(int llc)
+{
+	struct llc_node_map *map;
+	int node = -1;
+
+	rcu_read_lock();
+	map = rcu_dereference(llc_to_node_map);
+	if (map && llc >= 0 && llc < map->nr_llc)
+		node = map->node[llc];
+	rcu_read_unlock();
+
+	return node;
+}
+
+static void rebuild_llc_node_map(int size)
+{
+	struct llc_node_map *new_map, *old_map;
+	int cpu, llc, node;
+
+	lockdep_assert_held(&sched_domains_mutex);
+	if (size <= 0)
+		goto fail;
+
+	new_map = kzalloc(struct_size(new_map, node, size), GFP_KERNEL);
+	if (!new_map)
+		goto fail;
+
+	new_map->nr_llc = size;
+	for (llc = 0; llc < size; llc++)
+		new_map->node[llc] = NUMA_NO_NODE;
+
+	/*
+	 * for_each_possible_cpu() revisits the same LLC non-consecutively
+	 * under SMT (each node's LLCs are walked once per thread), so
+	 * dedup by populated node entries, not by comparing against the
+	 * immediately preceding CPU's llc.
+	 */
+	for_each_possible_cpu(cpu) {
+		llc = per_cpu(sd_llc_id, cpu);
+		if (llc < 0 || llc >= size || new_map->node[llc] >= 0)
+			continue;
+		node = cpu_to_node(cpu);
+		if (node >= 0 && node < nr_node_ids && node_possible(node))
+			new_map->node[llc] = node;
+	}
+
+publish:
+	old_map = rcu_dereference_protected(llc_to_node_map,
+					    lockdep_is_held(&sched_domains_mutex));
+	rcu_assign_pointer(llc_to_node_map, new_map);
+	kfree_rcu_mightsleep(old_map);
+	return;
+
+fail:
+	new_map = NULL;
+	goto publish;
+}
+
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
  * can use. A CPU within a cpuset partition can only use a proportion
@@ -3040,7 +3116,8 @@ static int __sched_domains_alloc_llc_id(void)
 	return lid;
 }
 
-static void __sched_domains_free_llc_id(int cpu)
+/* Return true only when the last CPU releases the LLC ID. */
+static bool __sched_domains_free_llc_id(int cpu)
 {
 	int i, lid, max;
 
@@ -3048,14 +3125,14 @@ static void __sched_domains_free_llc_id(int cpu)
 
 	lid = per_cpu(sd_llc_id, cpu);
 	if (lid == -1 || lid >= nr_cpu_ids)
-		return;
+		return false;
 
 	per_cpu(sd_llc_id, cpu) = -1;
 
 	for_each_cpu(i, llc_mask(cpu)) {
 		/* An online CPU owns the llc_id. */
 		if (per_cpu(sd_llc_id, i) == lid)
-			return;
+			return false;
 	}
 
 	__cpumask_clear_cpu(lid, sched_domains_llc_id_allocmask);
@@ -3064,12 +3141,18 @@ static void __sched_domains_free_llc_id(int cpu)
 	/* shrink max lid to save memory */
 	if (max < max_lid)
 		max_lid = max;
+	return true;
 }
 
 void sched_domains_free_llc_id(int cpu)
 {
 	sched_domains_mutex_lock();
+#ifdef CONFIG_SCHED_CACHE
+	if (__sched_domains_free_llc_id(cpu))
+		rebuild_llc_node_map(max_lid + 1);
+#else
 	__sched_domains_free_llc_id(cpu);
+#endif
 	sched_domains_mutex_unlock();
 }
 
@@ -3139,6 +3222,10 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 		}
 	}
 
+#ifdef CONFIG_SCHED_CACHE
+	/* The map depends on assigned LLC IDs, not on sd_llc allocations. */
+	rebuild_llc_node_map(max_lid + 1);
+#endif
 	if (WARN_ON(!topology_span_sane(cpu_map)))
 		goto error;
 
-- 
2.34.1




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D012C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D506B0088; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B348F6B008A; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986AF6B0096; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73D746B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D03C3120415
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:16 +0000 (UTC)
X-FDA: 85146989592.13.F656ED3
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf04.hostedemail.com (Postfix) with ESMTP id D3E5740007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf04.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787833995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O20fwafbTtD7eyEU2l7Yz6aE3ha+HOnMBpFABUl0aT8=;
	b=aJKEN4XV3XZGx9EhUuvSAFIeTpKF42XW6cEBdlQcn4QN+GcxOAOSXcLkn60rcbMbPMh7Ft
	jT3TOJl7NZIExP/XW4A+7FpFNg6U9G9rii9ol9k8NZ7zGNPLaaIWbYH6rg1EnMM7YY4n0n
	wkyeDH3ZRowV0LkGn2oYwgTn0t5Rhws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787833995;
	b=UyNg7bnrEKFqPmL8+j2ccm5KicEZoWV9EfYrL5LB65RxMBOh9N+SlIY8wTYme8fAUwJhxq
	+rZygcuNSSMxczaa1TE5iSNyTWB+WHzbWXV1h8+nK/FQyT278FRVJZAXTVZKSFtCQqz5/i
	WCHETPQJQOhpq4HOJiqc1E8wYtpy3xc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf04.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bq0VzSz38T;
	Thu, 27 Aug 2026 20:33:07 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bm3NbqzBJY4k;
	Thu, 27 Aug 2026 20:33:04 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 10C1B78AD;
	Thu, 27 Aug 2026 20:32:57 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:02 +0800
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
 Hildenbrand <david@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>
Subject: [RFC PATCH v2 01/23] sched/topology: Add llc_to_node() to translate LLC id to NUMA node
Date: Thu, 27 Aug 2026 20:27:54 +0800
Message-ID: <20260827122816.756234-2-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D3E5740007
X-Stat-Signature: 4pdtdu764gmgc7xbcyxk7zyfbrotnnam
X-HE-Tag: 1787833993-969722
X-HE-Meta: U2FsdGVkX1980yIk4cDNZSRkufKexEpFS3+Ob0vNY1EJ25qGJnEnS5bNdNSMsMF6tk2FmurLIYG4aNwcOhgFu9vtztiiJaFbgroydMLKRYB6h/2mLkIRLlwh8Zw61HZnr25twWviSGoL4brNq4ZQDMridxQQlqlxQgRuU8Fl1PNMvqn9gcY6PfzzMV1g9YdILK+EIX4fBIKlwU2MMxbtZuSnlTBRsgAmLvF2JWY0H+XYuNxpPPnTF5Ll51lmq6nCJR6q+CtdLVSsBOVYXD6bWC9lARctmVPD5hPBdgrMfCZtrEZZX+5+gxKJNi5VzoHLApbs2Ya7/MmnbEeiqG07CWbqh055KjYMKPK3UlE350MUsEbRxwmkQd/jIJMwhEFH9nrwuYJTSN4Ypdom5DHIuFS4Xdmmf4xgEQqVL+M5nFs5P63LIg/OUv8cLd01eRPzdE/UWBw8llB3VA0pLCHG0up8dklE6xtR1Rex+tISYvF+J5CgsGX1/coWNooBpFC35NMgWJRmkacm8lUNasu0JLYSRpKjjo0/fJGFNTMU09acTPVkuo4LIDpM/yWeZCQfn1z0SLDRXQHNtol4x09A6DWOKQ+gyEb2YDZ6LW27TURKRtJr7Acpp6I++9TaoMgRTcZSZ2qzJZ5Nfn4F1Gjnhvnkw0qUuyFxJxDBIkG93RnRQpv4ikZGOCKIlquqw5owNwb6d4EhY0VdJCm0FieW+zvVn304yv5JmFYOPsVStjAATT4rRcNBcxk2w1JKDuDyEA9trwO20tIKlPYHst5ghSV8StK1eDU1wmrcATyGynFjexwfhU8riZtED2Y7FcVpBt7v+o/tULkBWxP/ENIyfvj/Pt25OoTKIZqda89NubJmBqI++oSOaGi26CNV/P1/FFDPgyOTUSHhLO0s995QuAcvPV8OVckb5MsqxkLeGDGanmYgwowSkg0J+X+TLx4riXy9KJ23D3UqJ6QYxpi
 5oWCRyFE
 zRFxFSAFpWh0IpLAREm3/iqWeervX0S0rlNc3SOb25ojL2dxw1/ZSkEHDYlvVroMQazaxVi/KsM59K+UBcYyoORxqujvfvFfS5kCd9zivUdYjH1g2irvEVX01s6orNT3Ub3MHxy9LRKgJjlo6G47UGD9HJFVAnnwmQHXfbofjblp7L3M10JNu9Ap/Av86IpXM4hYRxHKPeH1PwDNqfNKXVvNkMYB8nQKEleW8IjwgjbMy7CMB0UE8bANkDvwKRsB+SmNiB7jgMH/Kao/W436CZY/SkR+HiXK6zHSZngz3fbn2RW0IkBXa/gdwvADrVekgrNbXXB8YxSQNzKcUsx+KSYjKOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Building an LLC affinity/distance matrix requires knowing which NUMA
node each LLC belongs to. Add a per-LLC-id -> NUMA-node map
(llc_to_node_map) derived from the possible CPU set, and expose it
via llc_to_node().

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/topology.h |  4 +++
 kernel/sched/topology.c  | 56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 709a2dcf4c73..9967739a180c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -177,6 +177,10 @@ static inline int cpu_to_mem(int cpu)
 
 #endif	/* [!]CONFIG_HAVE_MEMORYLESS_NODES */
 
+#ifdef CONFIG_SCHED_CACHE
+int llc_to_node(int llc);
+#endif
+
 #if defined(topology_die_id) && defined(topology_die_cpumask)
 #define TOPOLOGY_DIE_SYSFS
 #endif
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 622e2e01974c..c6928c6b17b6 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -685,6 +685,11 @@ DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_cluster_active);
 
+#ifdef CONFIG_SCHED_CACHE
+static int __rcu *llc_to_node_map;
+static void rebuild_llc_node_map(int size);
+#endif
+
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain_shared *sds = NULL;
@@ -856,6 +861,56 @@ DEFINE_STATIC_KEY_FALSE(sched_cache_active);
 /* user wants cache aware scheduling [0 or 1] */
 int sysctl_sched_cache_user = 1;
 
+int llc_to_node(int llc)
+{
+	int node = -1;
+	int *map = NULL;
+
+	rcu_read_lock();
+	map = rcu_dereference(llc_to_node_map);
+	if (map && llc >= 0 && llc <= max_lid)
+		node = map[llc];
+	rcu_read_unlock();
+
+	return node;
+}
+
+static void rebuild_llc_node_map(int size)
+{
+	int *new_map, *old_map;
+	u8 *seen_llc;
+	int cpu, llc;
+
+	new_map = kcalloc(size, sizeof(int), GFP_KERNEL);
+	if (!new_map)
+		return;
+	seen_llc = kcalloc(size, sizeof(*seen_llc), GFP_KERNEL);
+	if (!seen_llc) {
+		kfree(new_map);
+		return;
+	}
+
+	/*
+	 * for_each_possible_cpu() revisits the same LLC non-consecutively
+	 * under SMT (each node's LLCs are walked once per thread), so
+	 * dedup by llc id via seen_llc[], not by comparing against the
+	 * immediately preceding CPU's llc.
+	 */
+	for_each_possible_cpu(cpu) {
+		llc = per_cpu(sd_llc_id, cpu);
+		if (llc < 0 || llc >= size || seen_llc[llc])
+			continue;
+		seen_llc[llc] = 1;
+		new_map[llc] = cpu_to_node(cpu);
+	}
+	kfree(seen_llc);
+
+	old_map = rcu_dereference_protected(llc_to_node_map, true);
+	rcu_assign_pointer(llc_to_node_map, new_map);
+	synchronize_rcu();
+	kfree(old_map);
+}
+
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
  * can use. A CPU within a cpuset partition can only use a proportion
@@ -925,6 +980,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 		}
 	}
 
+	rebuild_llc_node_map(max_lid + 1);
 	return true;
 err:
 	for_each_cpu(i, cpu_map) {
-- 
2.34.1




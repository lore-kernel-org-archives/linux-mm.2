Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD1F3C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD926B009B; Thu, 27 Aug 2026 08:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92686B009D; Thu, 27 Aug 2026 08:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B355E6B009E; Thu, 27 Aug 2026 08:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3456B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15097403FD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:30 +0000 (UTC)
X-FDA: 85146990180.23.FD449E5
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E6C6C0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NixYqK+UNHhNKunEOuc8sDUzxpc5Rigw6Jx4xIW6oQY=;
	b=jiXm2AaxO5dL+Xe05/b4FKDUon/d2f0E8QERwRl0bX0db+dHTVIpVqDytSSdEM15P2eLLX
	4s5Rx/+R1AnaLGs0VXB2YEeylIMgJ/La4hJ7HiC0VvapP5oIRdpXpy1dqWQpz+ZZk+yk2o
	ipQVRV0icaityVTbVsvPJxHwndRsWZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834008;
	b=duT8/plv43++v16g6gEHNuMPW+Wbu7y80Rf9q8BntVu+uUI7krMY/QZoS9rXprdgWqvOeT
	LD7mvmLJaZ75ArztDq4Xbu1CnOdWFf4Wz/4Gl/4aY5gyCFPUNBM2NWfPH7TcWxmTyz2oAO
	U2MPk5/0NKK1kwn0oX0G32UPurmKEoo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C90WT9zBJb6j;
	Thu, 27 Aug 2026 20:33:25 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C757JlzBJb6f;
	Thu, 27 Aug 2026 20:33:23 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 8184F36F1F84;
	Thu, 27 Aug 2026 20:29:41 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:21 +0800
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
Subject: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU tasks NUMA preferred counter
Date: Thu, 27 Aug 2026 20:28:01 +0800
Message-ID: <20260827122816.756234-9-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E6C6C0008
X-Stat-Signature: frboi7teesmfzjynyub1a91rqy6mb86m
X-Rspam-User: 
X-HE-Tag: 1787834007-177013
X-HE-Meta: U2FsdGVkX1/JUvU8RiILuiRv8BcJVQuJiIchrhP/JVLgQ84VI4qTvbBNINhmOcat+VX/FmjBb9jglFpLQdAq309PqEJww8xHO7K0qltYQI8vVvqKoSR9SibvU7JbfE59NqmgUoXqJ3YmKlSXwwUoeT5YEG8UX9HZsxDmnySiwevM8X5SfbWFa1UILTi74Q8z81Nw0MpiNOVreBUkRYVRocSMHIPpZ5QrtA6AmntqFoDZo9BgSSdAFLjcgnx00xrlyQlEiL/CBQbz/ZJiBqFaFiEpqSnWBKy8MLDJwL9ishfIGzm1wUgDOD750sLfAWvCbWZ2grH0n/Wiby7N5irEgwo19JvdwAfqBDTZX53X7M6DaANWZPpBeGgd/RJQ2j4QOptRglnZYBuP6RL1htyeS8y7ukml2mdFS+0jT3AM/R/g00Un7SYZ0pql0Xb9r8GhtJkubtTaOB7372eHGSrsExb+wk2b7+Q5B5W13mrrXrXuZ866Epsg6RQ8fLYXlLTi4G1XC0zEvry5V/fQ2TpZ63cjljv1a36EmJ1bNcuj8r+gBTAyMvu4LzHrwvj/4eeREAA/+L8jlFlk4mpK873fLMtfxceQgyLrfE+s1vX23ZZrSJj3WMvA2YQ/DAXSJyJeXhPgi/BmDPsp6QkVxXIp7PbhKVoFMPhRCXZaNtPpjmqRBMEuobyLmAPFdA6n29RpyhRwal5ZpW+OfwtBS3J4TmQo4NNiT53hnjruy10Mt1OkAhtB7FcVJmkLuYTeT9rEN5va2pG+pbkaSOe4ZrTlmCNXarWsd4oPZXjp6Tx630An9EBIi2McAqMHB9qbnKt40/JKOZ1NYi6CQcw3QWYuEoEUyo8bUbOBDaxJXfZov6wKrBLHqJgWbkARzD9e/QS4RfHm2+jbFLFCqmBSe799l3y6HkS3UI26JJKnBbVTazYHlFB/8dfxbSy3M5GhSmf6M3Oo844MJcc969SjZm7
 6u3Lump7
 soBhmHHH9H+6+50JVKPzaB0T9tZLba+o1ipAFR+7GW2quJyed1QQL+MnvYlT6ElPA9dxp1/wRe5LNC051ZTS09QkNXcgGdrzkHLiSgKWhAfjWzQYBH8vEOuD6oZ6NNoY3qc6s26hIcl33M7z42jbsBE3knLGf0Fmz2zrI9tXEYZcgCnvswC8Kqc6gegS4Ze7KVQmyDTrJZJKT1KUaol8pzdvStZRfGjEf5KcyNfllJ63q1a+bNWmcm8qvoB9k3j9O1yj9xQH9jqaVA2G4CQFbL74p4wGm6I9pqPqy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Like the existed task LLC preferred counter, sd->llc_counts, introduce
sd->numa_counts to denotes the task number that prefer each NUMA node in
a certain rq.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/sched/topology.h |  1 +
 kernel/sched/topology.c        | 33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index b5d9d7c2b8ad..b31d2cf16592 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -121,6 +121,7 @@ struct sched_domain {
 	unsigned int llc_max;
 	unsigned int *llc_counts __counted_by_ptr(llc_max);
 	unsigned long llc_bytes;
+	unsigned int *numa_counts;
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 46ae1f94e9f5..901e593e70d7 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -641,8 +641,9 @@ static void destroy_sched_domain(struct sched_domain *sd)
 	free_sched_domain_shared(sd->shared);
 
 #ifdef CONFIG_SCHED_CACHE
-	/* only the bottom sd has llc_counts array */
+	/* only the bottom sd has llc_counts/numa_counts array */
 	kfree(sd->llc_counts);
+	kfree(sd->numa_counts);
 #endif
 	kfree(sd);
 }
@@ -853,10 +854,12 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			sd->llc_counts = tmp->llc_counts;
 			sd->llc_max = tmp->llc_max;
 			sd->llc_bytes = tmp->llc_bytes;
+			sd->numa_counts = tmp->numa_counts;
 			/* make sure destroy_sched_domain() does not free it */
 			tmp->llc_counts = NULL;
 			tmp->llc_max = 0;
 			tmp->llc_bytes = 0;
+			tmp->numa_counts = NULL;
 #endif
 			/*
 			 * sched groups hold the flags of the child sched
@@ -1434,7 +1437,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 			 struct s_data *d)
 {
 	struct sched_domain *sd, *top_llc, *parent;
-	unsigned int *p;
+	unsigned int *p_llc, *p_node;
 	int i;
 
 	for_each_cpu(i, cpu_map) {
@@ -1442,9 +1445,13 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 		if (!sd)
 			goto err;
 
-		p = kcalloc_node(max_lid + 1, sizeof(unsigned int),
+		p_llc = kcalloc_node(max_lid + 1, sizeof(unsigned int),
 				 GFP_KERNEL, cpu_to_node(i));
-		if (!p)
+
+		p_node = kcalloc_node(nr_node_ids, sizeof(unsigned int),
+				 GFP_KERNEL, cpu_to_node(i));
+
+		if (!p_llc || !p_node)
 			goto err;
 
 		top_llc = sd;
@@ -1459,12 +1466,25 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 
 		if (top_llc->flags & SD_SHARE_LLC) {
 			sd->llc_max = max_lid + 1;
-			sd->llc_counts = p;
+			sd->llc_counts = p_llc;
 			sd->llc_bytes = get_effective_llc_bytes(i, top_llc);
 		} else {
 			/* avoid memory leak */
-			kfree(p);
+			kfree(p_llc);
+		}
+
+		parent = top_llc;
+		/* Like above, find the lowest SD_NUMA domain */
+		for (parent = rcu_dereference_protected(top_llc->parent, true);
+		     parent; parent = rcu_dereference_protected(parent->parent, true)) {
+			if (parent->flags & SD_NUMA)
+				break;
 		}
+
+		if (parent)
+			sd->numa_counts = p_node;
+		else
+			kfree(p_node);
 	}
 
 	rebuild_llc_node_map(max_lid + 1);
@@ -1481,6 +1501,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 			sd->llc_counts = NULL;
 			sd->llc_max = 0;
 			sd->llc_bytes = 0;
+			sd->numa_counts = NULL;
 		}
 	}
 
-- 
2.34.1




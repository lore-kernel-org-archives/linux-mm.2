Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6E7606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F836B05B1; Wed, 28 Oct 2026 22:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07896B05BC; Wed, 28 Oct 2026 22:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CD46B05BD; Wed, 28 Oct 2026 22:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7376B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:31:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CACE31602A7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:31:11 +0000 (UTC)
X-FDA: 85374086742.22.FF59B05
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf21.hostedemail.com (Postfix) with ESMTP id 774111C0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:31:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf21.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pb+6LSg1e/mt5m4hjS2N4unf/Tq+5ITpN7ZF/2tjmpY=;
	b=B5D0Pbo9/wDqNmZYrNgTqv1WtD6gbIi34/7o7J8tHAtnKsTpR7BAnpGjUSju6MZjIQqlAh
	nRCNKtVOuee510dCTetFYZPGf6hzoeH3+UtL21D/uXFyer6eFsa39Vy4GAX5FeaFq8tcja
	mzd1jSrgLnIEY5f4N1nwz2w7L924Z70=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf21.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241069;
	b=K8S26aWqT6LXjgWHjYOZLkuuKubW0MPA9ffN0ntQGI6+W/bZiLSgtrLwW53pAMeNBfOkam
	c/HMQJHf6hEhi0miNWR7vW0rmNmTEsTpFs+S1uwRRR68KjFH7OfAVzmcnSjyL6z41KF5IB
	u01LXpjpaI/B0CKOZ5gnBjN5FTNbNQ8=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSs705LZz171Yk;
	Thu, 29 Oct 2026 10:31:07 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSs66k2Lz171Yk;
	Thu, 29 Oct 2026 10:31:06 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1B9D75943;
	Thu, 29 Oct 2026 10:30:59 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:31:03 +0800
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
Subject: [RFC PATCH v3 07/17] sched/topology: Add per-sd scratch for cache-aware load balancing
Date: Thu, 29 Oct 2026 10:20:25 +0800
Message-ID: <20261029022036.4002331-8-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 774111C0004
X-Stat-Signature: tdxwbfzsqp3eubdnkns4zyt34cs6oadz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793241069-627864
X-HE-Meta: U2FsdGVkX1+ao7WdH7iAEGqM5IdB84/p70O6j6PKgys3aAgH+pyStJ4S23w+64z3/lxSHVKu3yXJJNG42UZu3c/8PGjs1oi7MUjqsLulr5HgeB1xkJYIc3ikj/kKbsE1cfulpllk2aYwEaHIE/bOsCuRcY5ylZ+wgWjsZiG60wbWXjk9zDIvOvJwGKDNgwoMQRotb0tlslrDFMwy9bVR8w/YgPozk3TqbUE/pMURJNGW0hDguh5s9qfG7uTScVrzI/0aEiRXmmABVatxzt1CTmF1K8a3BA+chWTpU/x/Fiegop3SuGzx7TwYvz3Z+wKv5DmeJXRggaHOCf42xkWI/RBbkNQOuBtDYxuu1rhEKENKtq13PIVh3gYJPX/t9LkIve3JPCvQsR4SPUbJwx9mVJHHL3XVpxH2ppwUliA+44Dsz1Mxu2BDtQie1Chmn8AWmqg/j4q0O2ojxJR+AG5/acM5bu1BYa02wEx6UzSpqw+CeRpf/ScuSWp0mvVxAMWkmk0BYcBIeE56ceEjnOuUD9gSYApJJXCOTGvIdBicmItiUT2qmoh+KiVlgmKorJU6gVq70coYTNZRQxiwiZuSP32qI/p4EPFQ1Bj8q6cCjZgmrQv9RNWvFeBGfJp1K6tZBRvuDq+QCbLyvSNAN3+OSIwCZYXksMdIzsJkL2+tucA3QXWwz8ECKFqINPRDkwf2nfm6TFnD6IppwBQqC5sBPHrGdg5e5geWJRLssLUcmaJnxn3Ycclszt0fuqnPtoEAvbGGEXLo4moVR5z2geVNZbLGprkeEdNJMOy68ykaGWbrVyhHbgX3T7SpGQxiqIrmxExEv2DuI+QhKpbGrFzlWPNfLpLCz4J2/fZM8SsK1vIhvlCdSysz3/HTxcLpAHiPq8bRZvqYwJzpruO+kJnUHiIq/zb8lg2aXvkIKOoXLmRFncR7pG2X5TRx5PgW8dVlEyv4zcycfUUjnZel8yk
 sgmBEqKA
 sbNpxFUHZeBIwLMkLd5p+HzuYLDpcq4RhhumATlZV0qzOY4ufai+JGRA6bzmEA8x+X5MgkxLVaBUNOqh6k2TqV3zt4FueBhFZ/xCDnwqpET8lmOBUbH3ZLz/nBD8Liy18XOBrvjv0aKBRgxoKv7cT/Tipeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cache-aware load balancing needs arrays of eligible LLC/node IDs and
affinity weights when scoring candidate runqueues. Selecting a source
runqueue by LLC load also needs a temporary CPU mask to avoid sampling
the same LLC more than once.

Allocate these buffers on the bottom sched domain of each CPU, next to
llc_counts, rather than allocating memory in the load balance path.
Size both affinity arrays by llc_max and the independent statistics mask
by cpumask_size().

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/sched/topology.h |  7 +++++++
 kernel/sched/topology.c        | 37 +++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index b5d9d7c2b8ad..e41fc64391c3 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -121,6 +121,13 @@ struct sched_domain {
 	unsigned int llc_max;
 	unsigned int *llc_counts __counted_by_ptr(llc_max);
 	unsigned long llc_bytes;
+	/*
+	 * Scratch for the load balance affinity score, llc_max entries each.
+	 * Only the bottom sd owns them, like llc_counts above.
+	 */
+	int *affi_ids __counted_by_ptr(llc_max);
+	int *affi_weights __counted_by_ptr(llc_max);
+	struct cpumask *llc_stats_mask;
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 37f1eeae9b7b..7d65a4d7b0dd 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -643,6 +643,9 @@ static void destroy_sched_domain(struct sched_domain *sd)
 #ifdef CONFIG_SCHED_CACHE
 	/* only the bottom sd has llc_counts array */
 	kfree(sd->llc_counts);
+	kfree(sd->affi_ids);
+	kfree(sd->affi_weights);
+	kfree(sd->llc_stats_mask);
 #endif
 	kfree(sd);
 }
@@ -846,10 +849,16 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			sd->llc_counts = tmp->llc_counts;
 			sd->llc_max = tmp->llc_max;
 			sd->llc_bytes = tmp->llc_bytes;
+			sd->affi_ids = tmp->affi_ids;
+			sd->affi_weights = tmp->affi_weights;
+			sd->llc_stats_mask = tmp->llc_stats_mask;
 			/* make sure destroy_sched_domain() does not free it */
 			tmp->llc_counts = NULL;
 			tmp->llc_max = 0;
 			tmp->llc_bytes = 0;
+			tmp->affi_ids = NULL;
+			tmp->affi_weights = NULL;
+			tmp->llc_stats_mask = NULL;
 #endif
 			/*
 			 * sched groups hold the flags of the child sched
@@ -1307,6 +1316,8 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 {
 	struct sched_domain *sd, *top_llc, *parent;
 	unsigned int *p;
+	int *p_ids, *p_w;
+	struct cpumask *stats_mask;
 	int i;
 
 	for_each_cpu(i, cpu_map) {
@@ -1316,8 +1327,20 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 
 		p = kcalloc_node(max_lid + 1, sizeof(unsigned int),
 				 GFP_KERNEL, cpu_to_node(i));
-		if (!p)
+		/* Scratch for the load balance affinity score. */
+		p_ids = kcalloc_node(max_lid + 1, sizeof(int),
+				     GFP_KERNEL, cpu_to_node(i));
+		p_w = kcalloc_node(max_lid + 1, sizeof(int),
+				   GFP_KERNEL, cpu_to_node(i));
+		stats_mask = kmalloc_node(cpumask_size(), GFP_KERNEL,
+					 cpu_to_node(i));
+		if (!p || !p_ids || !p_w || !stats_mask) {
+			kfree(p);
+			kfree(p_ids);
+			kfree(p_w);
+			kfree(stats_mask);
 			goto err;
+		}
 
 		top_llc = sd;
 		/*
@@ -1333,9 +1356,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 			sd->llc_max = max_lid + 1;
 			sd->llc_counts = p;
 			sd->llc_bytes = get_effective_llc_bytes(i, top_llc);
+			sd->affi_ids = p_ids;
+			sd->affi_weights = p_w;
+			sd->llc_stats_mask = stats_mask;
 		} else {
 			/* avoid memory leak */
 			kfree(p);
+			kfree(p_ids);
+			kfree(p_w);
+			kfree(stats_mask);
 		}
 	}
 
@@ -1345,9 +1374,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 		sd = *per_cpu_ptr(d->sd, i);
 		if (sd) {
 			kfree(sd->llc_counts);
+			kfree(sd->affi_ids);
+			kfree(sd->affi_weights);
+			kfree(sd->llc_stats_mask);
 			sd->llc_counts = NULL;
 			sd->llc_max = 0;
 			sd->llc_bytes = 0;
+			sd->affi_ids = NULL;
+			sd->affi_weights = NULL;
+			sd->llc_stats_mask = NULL;
 		}
 	}
 
-- 
2.34.1




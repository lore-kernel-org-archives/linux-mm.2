Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE7DC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FD3B6B009E; Thu, 27 Aug 2026 08:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D54D6B009F; Thu, 27 Aug 2026 08:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06636B00A0; Thu, 27 Aug 2026 08:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5C576B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 651F2A3B03
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:36 +0000 (UTC)
X-FDA: 85146990432.05.5313F8F
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf29.hostedemail.com (Postfix) with ESMTP id 639F7120007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf29.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3KmBC4V0eyglbpWsC+66GLLxbXwhLdRisUMp2Z2fPRA=;
	b=5qwr51ot+pLspyqvpCY5at19gH8QrN1DDdSuxh/KzPKvUn8fBqov4KlmdGeg0wgabdoz6t
	7MbP1ilzFY+A1Kw/7rDKV0IAD4tkQ8GGGisjEQmfq/dCbguUxIDEcOuUrb4oyw7uqzDHV7
	xo3mxm0YmaiWS0Q7jv1ASheKO9bK0lw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834014;
	b=4p8mtak+LXhG42hmsjxNpuaIc/ywCnuev5mYDRsr5zAWmhKHiRRJh3th7uoIcm3sa8tPdy
	hoN7PG1YkwPYAveQI0l5Hw3jOMO9B2eGN4Q77ilyXwu8rFoTZrTv4PGEBGP109bLXHRcrD
	+ta6PQEfRcr9/wDu0Bujqqi1lx7FvGc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf29.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CH0Wc3zBJb6p;
	Thu, 27 Aug 2026 20:33:31 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CD5j8MzBJb6l;
	Thu, 27 Aug 2026 20:33:28 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 9464936F1F84;
	Thu, 27 Aug 2026 20:29:46 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:27 +0800
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
Subject: [RFC PATCH v2 10/23] sched/topology: Add per-sd scratch for the load balance affinity score
Date: Thu, 27 Aug 2026 20:28:03 +0800
Message-ID: <20260827122816.756234-11-wujianyong@hygon.cn>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 639F7120007
X-Stat-Signature: wdhe4aakg5ofuiifsen5nskkhubb1wat
X-HE-Tag: 1787834014-150658
X-HE-Meta: U2FsdGVkX18dAw0ZqfFyW6srhA1xshoOyMsAqN5j40AXZQd7xruZdEfzmXEnvu1jA2KY0wi6ed10bgmkcUotIbNrBMG2q7bIE9xoYZRGASXGwEbkP+wH8maY89Rm9iSV5IZ5F+b2nk2Q//wkSm5f1Yf+N1U0OmnxpBm/iQSswVKVJmxoXB+9odpF2d3hHEhySlJWLINV/QiDAQS3857N9omyG/DUf5NPsWLTvIkv+QXV0QgtI5ujYnJGRSJsQrzuFWhIc537HQgQz8C+bcZI9IiMgIRDqFYkMNyuNs9obIBWpiYOYdtOZhwDsq92Iz+GCmPza2nIk7H5yzUvultLwO4d8RLspXSWoMUmOxa5nPc69WdDTb5JBzQIY3TGwLvFRokWnqWGeTAlviS28v4G6kqZCCexDZN4lBL7jGev6JXUIssgMav2Z7rtm7XQw5OWpNLVW2HbzAUuXRWrZhnl57jqXAGEVd9NLQAUCp/35UV7+Je3MnZ3FagvJyhfD7WfuCkBDA1vlSW3s5VNnhkMa0wz4g9qOUHEAwZGcYngRIupPYsoH7IE65ngMRZInWQ/F/xgZJtwdNuBSINKNYlh2kNWuHGnJuDu4ZSDosJ2IDYmnneYzo4ITs2yFSxhcbbTC6ETMuGhqG4+MglD+n/pgKDH9VznC6XN/1DJgcix503+34mZ7l37v4+4R5d102v1bV3IOZ5p+Xcu1G9Ywttf170Lm7LHMj3lo+zKoLoBvD8jyaWhxDRJBtAnuXQ3h6qsdUfeDCVFIjXyL+VreYUplP2cTRBqvf0Q53ZfL31vpZ22xtFGEPM4cqHmGC9VGkkKVFieaD9Yqju4C45xmMxD3Ls3zCGgbX/AIlqB6tCpnA3SkTMYN8653b6w1x2nPwjC41EJ5ymwyHq0r4ReVkjELBarj4Wl3hVoAnN9sOmYmrgF26g0ZTVz8S16L9mq2RjZHoKm2V6lPH6aaeaX829
 GDFYFT0R
 z7WntMXAgQ785tMPEwX1hcVERexzAYp7jK4Guo7hzrS7H35BAJq5YvEhBcnPeLLWjVRjmhMIk1hcHMWgF3F+mcnl/bKzmLr7Okcblixp7jKleB7Cwq/0DIGEpC7YqlRB53DmxI6BL/wbq7CJNnCeMEC7Z8KT4lrKhzMJxFYKfiJeCKkJEBS9IVR2sIRADYOLmKmwddYoBogKMjBzyARMqW96ovkP9ceDKn6sEKUEjh79pUaW/eAXzd3ELPxv3uIXl+H11ZnIMrJCJNwc57TQJULTffXPCliW5Uav2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The affinity score computed during load balancing needs two small arrays,
one entry per LLC: the LLCs that sit closer to the balance destination than
to the source, and the weight of each. Their size is only known once the
sched domains have been built, which is why the load balancer currently has
to allocate them on every call.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/sched/topology.h |  6 ++++++
 kernel/sched/topology.c        | 28 +++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index b31d2cf16592..569ff562dbdb 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -122,6 +122,12 @@ struct sched_domain {
 	unsigned int *llc_counts __counted_by_ptr(llc_max);
 	unsigned long llc_bytes;
 	unsigned int *numa_counts;
+	/*
+	 * Scratch for the load balance affinity score, llc_max entries each.
+	 * Only the bottom sd owns them, like llc_counts above.
+	 */
+	int *affi_ids;
+	int *affi_weights;
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 901e593e70d7..73d0c44dea92 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -644,6 +644,8 @@ static void destroy_sched_domain(struct sched_domain *sd)
 	/* only the bottom sd has llc_counts/numa_counts array */
 	kfree(sd->llc_counts);
 	kfree(sd->numa_counts);
+	kfree(sd->affi_ids);
+	kfree(sd->affi_weights);
 #endif
 	kfree(sd);
 }
@@ -855,11 +857,15 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			sd->llc_max = tmp->llc_max;
 			sd->llc_bytes = tmp->llc_bytes;
 			sd->numa_counts = tmp->numa_counts;
+			sd->affi_ids = tmp->affi_ids;
+			sd->affi_weights = tmp->affi_weights;
 			/* make sure destroy_sched_domain() does not free it */
 			tmp->llc_counts = NULL;
 			tmp->llc_max = 0;
 			tmp->llc_bytes = 0;
 			tmp->numa_counts = NULL;
+			tmp->affi_ids = NULL;
+			tmp->affi_weights = NULL;
 #endif
 			/*
 			 * sched groups hold the flags of the child sched
@@ -1438,6 +1444,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 {
 	struct sched_domain *sd, *top_llc, *parent;
 	unsigned int *p_llc, *p_node;
+	int *p_ids, *p_w;
 	int i;
 
 	for_each_cpu(i, cpu_map) {
@@ -1451,8 +1458,22 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 		p_node = kcalloc_node(nr_node_ids, sizeof(unsigned int),
 				 GFP_KERNEL, cpu_to_node(i));
 
-		if (!p_llc || !p_node)
+		/* Scratch for the affinity score, see cal_affinity_score(). */
+		p_ids = kcalloc_node(max_lid + 1, sizeof(int),
+				 GFP_KERNEL, cpu_to_node(i));
+		p_w = kcalloc_node(max_lid + 1, sizeof(int),
+				 GFP_KERNEL, cpu_to_node(i));
+
+		if (!p_llc || !p_node || !p_ids || !p_w) {
+			kfree(p_llc);
+			kfree(p_node);
+			kfree(p_ids);
+			kfree(p_w);
 			goto err;
+		}
+
+		sd->affi_ids = p_ids;
+		sd->affi_weights = p_w;
 
 		top_llc = sd;
 		/*
@@ -1498,10 +1519,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 		sd = *per_cpu_ptr(d->sd, i);
 		if (sd) {
 			kfree(sd->llc_counts);
+			kfree(sd->numa_counts);
+			kfree(sd->affi_ids);
+			kfree(sd->affi_weights);
 			sd->llc_counts = NULL;
 			sd->llc_max = 0;
 			sd->llc_bytes = 0;
 			sd->numa_counts = NULL;
+			sd->affi_ids = NULL;
+			sd->affi_weights = NULL;
 		}
 	}
 
-- 
2.34.1




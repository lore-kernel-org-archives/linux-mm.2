Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587CFC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639EC6B0092; Thu, 27 Aug 2026 22:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610B86B0099; Thu, 27 Aug 2026 22:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5270A6B009B; Thu, 27 Aug 2026 22:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB176B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:14:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADBA4C021F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:14:37 +0000 (UTC)
X-FDA: 85149059394.17.5E4C9F7
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf01.hostedemail.com (Postfix) with ESMTP id F084840006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:14:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf01.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y5IKZM/D0Go6E+hd+9rcF3CzdcepiuEgLpGV6B0aPzU=;
	b=TFSEMxU4x9NqLd5rQENNx3xNeBmGOlWJ4B7F/W164ndRQxUSYrSiNtorVYO6yU2JM53rlV
	kqH6c8AUfUHRaEVkFnrtnruEG8cpayCFuYzbl9ihhqWR9q4d/C/bkWRupSchNg/IlbIUrQ
	YODa3Zxzv4JLPT5Esl/i3WaxfsnJyNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883275;
	b=5S1pP7NhcGTJP2P1j1tNdOBFchfvQHJ+Q6B6FL1o8paHu7C0WyX8nxSOrjQWeEfYuNsUQp
	exhfIxnjCo94d6IkOX/1Sibeptff2RcMHScynpKsOQsXautGETA91OlEHev/XYAyVvCOkl
	XCdRprWDeZof2k1LW4H2jTYa/gD1EF0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf01.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMQc0h1Vz34Dg;
	Fri, 28 Aug 2026 10:14:32 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMQY4RBYz34Dg;
	Fri, 28 Aug 2026 10:14:29 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 60CDE7889;
	Fri, 28 Aug 2026 10:14:21 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:14:28 +0800
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
Subject: [RFC PATCH v2 19/23] sched/cache: Remove preferred LLC/node check no longer needed
Date: Fri, 28 Aug 2026 10:10:32 +0800
Message-ID: <20260828021032.785642-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F084840006
X-Stat-Signature: p75sajd7t1z9rrf19uwnbmr53mmikbgz
X-Rspam-User: 
X-HE-Tag: 1787883274-296099
X-HE-Meta: U2FsdGVkX1/8/78Lf+RrEPfOmQsj3i1yH0QT2GYZGrki+f71EkuTBwujYsic3D1SwqL2jBu6QGULgfQXHGK3TcVV/wMunxjL9S5Ovb7aeOujRwu+33yDRyH8DbTRIBMKHtUyEnWoLIrCTMYFcp8wsf4mHI5B4fKU7dClMYhQ9gkPlcRUgwzbD7t2zE3Ni0Jq4GKgPuCv6GVFvd1PngJMUeYFpcyy2HCg2AJzo4Sq7NFNQH3zCKejWxoL/+bkFOjxUOOZHzsIwPmKMMlOm6bHb9XWNLV6spwsyYkoqDmJGNzlKLXcfIFhwyF9gMlNaC98FQHXPaJoEszWqKQQ3Vf3DlTjPTJB0Y9K63baRIxQBAIAbac4ooeWzVYlaaMQAal/yOHTdN28U46DCm3Rg9tyENh215HcBupOlHuyWCKrHGPMss7x+Oo7TMV0q8tMqkatkgFejP4/GTv7QkjZRu8protO6uxBnjFbNB18K/7qPxzPEJ4iFulXEQK1O0cPKGnAsHv7XR9B3sth6n6ilCozBgUoyLvnytLNexQJ5eBk7eIGAmUXyqqoMnxMyjWB7yvtm+YF8gwjNyR7i/JjxrpK5Tl67MKOXPGfjc1RBjLhvOJoLJ5KgjrQbxzb1h3iHzQd3mA27doAUIHrq8BwVArHGUcjUGuaOIPAinLOq0WSlhYCiGO4OcllMSwKASg5OvL2ofwLNPj0BwpRFTQwyr3pbM3R1ShCmHnSKJP1H106dVdtGs1+uqWsqTQkd62HRJI//KsP5cW4H+LaTIYw3fugb/ognxdb2fywjfF9MioOni4W53BJWx2KIUjQfW/R1S+P5iokSlyIM1uZqmpYsliolu7ANBhk06Hq4X/xenLsyzHIX4EHsKvou8EhNX7E9ezpjtiz8EF4ot2FGTfrSIon3yfGh4YJkRjkWOY7Pw9wBQF9Xo2sc9u1Wx6r2jOeN1p9cbd19TrD6Zjn66zutGt
 8eDy3C9f
 FCSkRgLVN5h2bxHWDhm2WFbVX6VVLPYEJrOrSGaeKLW+BHFdOEsrAuRfUbjEv9tWA722LqIaNO2JFfPTEys3wNhyQU/rh1qtcZQJlh+BPrLQINWk3qhiWL1SyY0oCfDCC8uHIZiduq6SwByIY7jFXPfUuzF7tCUsyX89RKCM3MepuzOquMSAOFgE4EorNzo/aImLdGReuVEpuGEPK/NWl0FrHtpx8D1Qc+QZlBIOXI+WZBmiC+lrRBm8BEprjzmneqkHXX9SHfNuGr0D9lJ6zIADLTyrab3aaUp34
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CAS extends to the whole system, preferred LLC may not locate inside
preferred node of a certain thread and migration can happen to move to a
destination cpu that is not thread group's preferred LLC. So, all of these
check should be removed.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 27cb05373a1d..45dd3e5e0a86 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1680,27 +1680,9 @@ static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
 		return -1;
 
 	mm_sched_cpu = READ_ONCE(mm->sc_stat.cpu);
-	if (mm_sched_cpu != -1) {
+	if (mm_sched_cpu != -1)
 		mm_sched_llc = llc_id(mm_sched_cpu);
 
-#ifdef CONFIG_NUMA_BALANCING
-		/*
-		 * Don't assign preferred LLC if it
-		 * conflicts with NUMA balancing.
-		 * This can happen when sched_setnuma() gets
-		 * called, however it is not much of an issue
-		 * because we expect account_mm_sched() to get
-		 * called fairly regularly -- at a higher rate
-		 * than sched_setnuma() at least -- and thus the
-		 * conflict only exists for a short period of time.
-		 */
-		if (static_branch_likely(&sched_numa_balancing) &&
-		    p->numa_preferred_nid >= 0 &&
-		    cpu_to_node(mm_sched_cpu) != p->numa_preferred_nid)
-			mm_sched_llc = -1;
-#endif
-	}
-
 	return mm_sched_llc;
 }
 
@@ -10917,15 +10899,6 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	if (env->sd->nr_balance_failed >= env->sd->cache_nice_tries + 1)
 		return false;
 
-	/*
-	 * We know the env->src_cpu has some tasks prefer to
-	 * run on env->dst_cpu, skip the tasks do not prefer
-	 * env->dst_cpu, and find the one that prefers.
-	 */
-	if (env->migration_type == migrate_llc_task &&
-	    READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu))
-		return true;
-
 	if (can_migrate_llc_task(env->src_cpu,
 				 env->dst_cpu, p) != mig_forbid)
 		return false;
-- 
2.34.1




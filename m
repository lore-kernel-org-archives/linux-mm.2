Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C75606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084E46B05B7; Wed, 28 Oct 2026 23:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BC16B05C2; Wed, 28 Oct 2026 23:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4B76B05C3; Wed, 28 Oct 2026 23:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4C636B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:03:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55B541A018C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:03:13 +0000 (UTC)
X-FDA: 85374167466.30.9DCC020
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf19.hostedemail.com (Postfix) with ESMTP id 842601A000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:03:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf19.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242991;
	b=UG/Kl89zvUlbongWmH5kbUGq3W0AyRqDw4VRkmHc49yRn4wUNkbjfKRlL+1esobtYixQgp
	45uc/DeNko1jLe25xKsCNJFG7npUctTcSDU4xe9vKUHfzam6GconCuR1Sab4ZzaAsTPLzW
	5Mw4QKYjj6P6U78v93EyaHvIUgTXVJ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf19.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKF5wqMFzUCUVxGDoC2rEk2wPVNMUgCMUrf0EZTo9Bc=;
	b=KkuJ7TA6E9cl4TUlnCw8urBEXPBoLRcFnLKx1PeOFT5aIivXobP5bkzShp9snOum0VgDeJ
	WSQRrGhgj5Ej45RHYvDIkzD7PLR994F0o1IbVlxAn9QhVSyMAYNLoQ+lvVHp9fA6mnvwpZ
	PmUDfB1f7yS/A6q9do2nyQjc27YHzIU=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTZ21MrTz171Z8;
	Thu, 29 Oct 2026 11:03:06 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTYz2b9Qz171Z8;
	Thu, 29 Oct 2026 11:03:03 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id EE91F314AC01;
	Thu, 29 Oct 2026 11:02:39 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 11:03:01 +0800
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
Subject: [RFC PATCH v3 16/17] sched/cache: Drop stale preferred LLC checks
Date: Thu, 29 Oct 2026 10:58:28 +0800
Message-ID: <20261029025829.4005192-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Queue-Id: 842601A000A
X-Stat-Signature: iwk1q7i4gb96jmxng7dujaupbudakza3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793242989-522550
X-HE-Meta: U2FsdGVkX18vdCX7xNk0/uUt+UgIzyTNYC4DTQtM7B4bzIAZYe4CQo/adIqtboqm0uM8HP29/oZfR9y0OWLd9raQVz34g4+lfHSEFieDEdiSLEtQeBDN5vWfVV3Regjsh+lgsZEAeMC7CPyT4GtApCv0KIOYBJ+igVhfEsddDTMTDU7PeV79QIhznkcQ41VBfb+qEA/Qa8uACDCPWpFbjtM9L31ckvwC4sIPmLX0pvZ1U7BsKzcVj/KwY2MF7wwcfO55GXj34AI7gcbIsrvd9tuaUy+VNqwGsHBqTUlI3Y8svFRyfcsDnDsnhvNoZhkZHNfj02z9wbO4ARkK17qlLPmb5csiGWA6HFVu0dS4PVC8uDIMqyEk/NXuMCiO57soYs0iZQRhPTkI0SxNlrlhaQgfkEoQgjB+r7ve5oYpeNxn7Bd8QaicIRoqYWQdshhDp13Joh3p7BylqdX2YVAd1LdxhTSnxEtqGZUsoAI/ugG1dgV4Qw5jWPPJ2W7kAjGcnwDqsAvaRVFzEVmYYex8AQhO0Wg9VsCPPdG1S8oU1HclaU9RPtWLFzsOIk6JkJgkc9TnWtnxTiSo894ABlaHL2IvxewFW62lUia1Sn6rKRyiYyVbfHKgqtBQWTO/qs7m94uYR2n0//HTrqhfM29DaEkdRVzdzOLOFX5eRPA7jIPDUtsicbqETx38tWRXK3Vhcmy4LBosSOiAhELDQYWBkxB/QykG1DcdPAGbLUXbJODfda0icKNS1SemxtsDubXSBigz1wI6nDqy/MBIkZRDGczoiMp230vcBPgnvjHN1tHiyeCkMMngDe+mlQptSrq0B1XUUzYmIfB7P5xnqIjOEOUPKP7wvHQtIZsXMPdfZjFBJadCa6tZZiYBKdUmCX4r3RVzW6OMT6UjIPGjxut/c2v1dvbschVvsAoFwBAacIOqSRoZCR/wG6G/5Io3XeahULqu5mbIi+Gqqeybm6D
 QrvrKt5z
 CdgpBI2pFkeqIfoeT9ga1Q+PgdGJiVOvRi78x1he4AIV6CnZq2Pd+PuPtwXUkzbk7q/QtvhJvxgcVq4DLM92P1dlQtHrHHNoNCIzTPpv99dIAWPnRgxsrn9+W+ajr+HHV2hZmyGXvnqzrTIw4UiSE5tMuXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With multi-LLC aggregation, an mm's preferred LLC can be
outside a task's preferred NUMA node. Do not discard that LLC when
calculating the task's preference.

Likewise, an LLC migration may select a destination other than the
task's preferred LLC. Let can_migrate_llc_task() decide whether the
migration is allowed instead of rejecting the task based on an exact
preferred-LLC match.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b93b6e6c9dea..5d11f9b7f685 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1669,27 +1669,9 @@ static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
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
 
@@ -10898,15 +10880,6 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
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




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D74C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FC36B0095; Fri, 11 Sep 2026 03:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0A86B0096; Fri, 11 Sep 2026 03:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8E66B0098; Fri, 11 Sep 2026 03:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5596B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:58:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAFE916012F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:53 +0000 (UTC)
X-FDA: 85200730146.03.6F44B29
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8F6AC000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="g/N/a6wE";
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113532;
	b=SBtKpmUpEs36H3xvAlONNoYuKJmNXGZmMtc6t5Sieqe5VnPKQHdcFjDZHa8Ni2gY/SGti4
	Y1ps8xEQdDXW6Po2z4BIzyTvkuLL4cIlXNlsbrulum775JCrfaFkzyylTAezmcrcQv7skb
	P5S9nbJMRUf/8BRkrRJj/jYIQiayaZM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="g/N/a6wE";
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORlx2vOsah4MozoblyfLQ6bCWu3BG+8Hu7FVn2KeHp8=;
	b=lIt6Vmgav1Cmznk9iC6wRvgQE81KE0P/Y7aOfi8QJVH3XSsLkAAR1NaCJdo211KsoNamdp
	1arWMZBnE+ahz+ei/lBnKgm0dYjEMo7gRpLDTXE493DvgYeXZTChSTUnAmaUdbQZX6j3ZW
	q0glj8SnBT+IifAbwy+3Yo1Co3yEFxk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZzvApGiwGsUs4MczJymZslP+9Pni4p9V/rT4UlhT+jA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113530; v=1; x=1789718330;
 b=g/N/a6wEWW1JgQaQextQ6/VTXs8j7sxSClSluCc0Z8w9fyHpPjuwVISX4Jzbq1YHxOTjn2mB
 keyopv/53ltGIoG1L0JfzLAStmQABybqjvFWHQhfPVnKvHWSuuJy1gfwWaOgAx2nTiy1xzxd8Zl
 lFp8mAFppfFXLA5wkO1Pd9dk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6843b9e642dbf692;
	Fri, 11 Sep 2026 07:58:50 +0000
X-Mizu-Trace-ID: 6843b9e642dbf692
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 02/15] mm/oom_kill: convert process/thread iterators to for_each_*_rculock
Date: Fri, 11 Sep 2026 15:57:47 +0800
Message-Id: <20260911075800.491472-3-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8F6AC000B
X-Rspam-User: 
X-Stat-Signature: hq3i5gfte7jerqhjur84wfsq1bm1utyr
X-HE-Tag: 1789113531-420465
X-HE-Meta: U2FsdGVkX1+DGXSwlBTFM0Dtj4jONP7yB8/HVuoUc5+GHSRoui0vlA0pEC/ZIGSvzGNb2wB7BkOkvcypGMoV18phvgc6BwHa8ETW8LuIw1hqSP+OcqO3CIt+lIB064QSZSPKKjrvVvAOSmHD0LDD4dugKRulYySi87yMXxIH8AWbSS4UC7dU24/y4EoUThX0ljNs+wY3zGwE0j5pc1SbIiTGWPWeLAhfRAiHCi95Y+hZXOeinfRDiqsZxwTaXmMEhsyI1/r94soyqbVBuzpgzB9poOhPOMDmloYcEsgeR5RV70RWhsPxN0z2pTkFW0811PhQpefn9IV1Bx8aa1jPjRIgLBcD6as3HrZXqyN+Ru7zmqx1HL42UZvnGq3GIcRPCv+eH5DNGDzAyN861nDecMa7XWM19IuUUJe/YELGjVkNLRTODfvMqQbtICvydzPiOWictQ8dSKVX6jho1MLPKF0QDI3p4qFOsy957WmQEeyi70pA69gI2C9smovMc0iwwBKBDfL/kDE1HSJ+ngFdzUzF1wsven/7mlPeunPTDtv2GjuN5StNEB6OcoAYqjPsxi1yX7/0Sg0cfnLMngjR9pdSHIbGTmnLiQAkGTw7jIlgYeeZjZ7VsQdnnM1CxPL0BJuCVarf390aXC/LuwLFObQZVEyUxewkvYny+LvdO4QcYfBLrmbaWqcgi/luQsM5qZ/jMlkZcAA0IoW9Uiem5c9oEvbHi7M/kl9kcAEiMmsZ/82w15QkcswDOFc8HIeg5kfzcBKZ+xLqct1qs6gVPA/MGSCvK1sVzYlafnrfW9akAcDo3Ufn4L3vX35g/1/y68/KTLb7uPAopLRr6OQzdOIiEQ5eANoz55wHb62VLCSbQ6MmbsCRzriU655EYfam62nqcPIzsEvEuR10Z0Be9sJ9T9Wn2Lm2NGYR0uyeI15wXq46vyFewPeMtOrE+TTuKl3cNYPHSa46gYKxUp/
 1jIKbIpn
 pAU5leoEDTelZsbMk7QCPbDeKzCk7oUbzMWwW44ucEJukYYBxOlhYsJbRMAmwmioInvs6/d6L6jk+giurFSK7ORMkQ7BN9eo7ar765N0I4nvaPPuOGyGQnYNKrQPWLXBb8IxloyveuWeJeVllv8BSP1EnYDN9qZG0sy2Kl78jiqjvFzHyllyBgyScywndCh6e8ZRhQeZPLm59aoOiAcvrxVwqZmIDzFhz87BArYEyyf54qSbGUDDy6kqrKA5MfGBBBkJFuEQIZz1qANLZlHMs0O6Qdao6p488Iy6Ygsn4iPAQK9EondpGhojRSbhlDzYdKzx5Daja6//UKRUMA5hbe4G2HlsoPLmWhco790fxttTc2Ol9W4Cld5uZ0Iinik2wK0OUbrpHqwQANcGsgpjpRoalxxPnh6siJmTuEDub7B8b/S2RlkoiAgVSSmeqDwZVWty9gpcgYHd/tjP+HkK8Pl9vCVkXFpuUup+4XOGyYTplpeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
for_each_process()/for_each_thread() loops with for_each_process_rculock()
and for_each_thread_rculock(), which scope the RCU read lock to the
loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Changes in v2:
  - Rename *_rcu to *_rculock
 mm/oom_kill.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..ef2e1c423c1d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -94,8 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	rcu_read_lock();
-	for_each_thread(start, tsk) {
+	for_each_thread_rculock(start, tsk) {
 		if (mask) {
 			/*
 			 * If this is a mempolicy constrained oom, tsk's
@@ -114,7 +113,6 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 		if (ret)
 			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -368,11 +366,9 @@ static void select_bad_process(struct oom_control *oc)
 	else {
 		struct task_struct *p;
 
-		rcu_read_lock();
-		for_each_process(p)
+		for_each_process_rculock(p)
 			if (oom_evaluate_task(p, oc))
 				break;
-		rcu_read_unlock();
 	}
 }
 
@@ -430,14 +426,12 @@ static void dump_tasks(struct oom_control *oc)
 		struct task_struct *p;
 		int i = 0;
 
-		rcu_read_lock();
-		for_each_process(p) {
+		for_each_process_rculock(p) {
 			/* Avoid potential softlockup warning */
 			if ((++i & 1023) == 0)
 				touch_softlockup_watchdog();
 			dump_task(p, oc);
 		}
-		rcu_read_unlock();
 	}
 }
 
@@ -894,8 +888,7 @@ static bool task_will_free_mem(struct task_struct *task)
 	 * are dying as well to make sure that a) nobody pins its mm and
 	 * b) the task is also reapable by the oom reaper.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		if (!process_shares_mm(p, mm))
 			continue;
 		if (same_thread_group(task, p))
@@ -904,7 +897,6 @@ static bool task_will_free_mem(struct task_struct *task)
 		if (!ret)
 			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -960,8 +952,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		if (!process_shares_mm(p, mm))
 			continue;
 		if (same_thread_group(p, victim))
@@ -982,7 +973,6 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 	}
-	rcu_read_unlock();
 
 	if (can_oom_reap)
 		queue_oom_reaper(victim);
-- 
2.25.1



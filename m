Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968D7C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF4A6B009F; Mon,  7 Sep 2026 04:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7684E6B00A0; Mon,  7 Sep 2026 04:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B6B6B00A1; Mon,  7 Sep 2026 04:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 286B26B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:14:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79649A06B2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:20 +0000 (UTC)
X-FDA: 85186253880.30.BE78CCB
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 644E61A0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PkoZv9VB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JX9pz/iKnxiodB/9R1jM9tJEhGQeWy3SEA8tnCDJCWA=;
	b=zaoPvJxKOjwPn2CiS0KO+d1yxnMV8b/yKVjYYkGjiM4rAJyYJnXEADF1x8vCI4UeZYKNF7
	wI3hT83ELdyflesDkqp9UXi3/chWFP/tlD/F0i4Z0roJ8P8itpA60PvDRFdplpA/ypWyGr
	sOHS8kX7SSuoruVCHi0+iLJY0+hf45U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PkoZv9VB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768858;
	b=RFSAvFzOky1iimjCof1GdZLSNDn5yRCn9pzY5NbmWUKMkiGZoo3dw5d6BQBvmXQygB55Xt
	OaRyurJg5LcHRiCj1NGa/uvT8YIzNR0AcDx+x1mx5KmwwwV82hgXri1AQ3qGOLkoIfOi1S
	KAHyH6ki+qgjKWa4uK4ZOplx2+/vKAA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ASmH7PI5FjNsmJJfvtLeEl3jMhKoYtXHiDpYlixm7NE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768857; v=1; x=1789373657;
 b=PkoZv9VByCYw+CljyqOF9vhxvVFtrnkwU1ESoTtbbzZMX+REPxlmCfAl3qLoVoYKZPvAzwyh
 +1BeCydxCCbXVJCnECU0fqJmK8b9xDXFZiRik0vgS6hFllrBdVgmpVU9EDMs9z6FOcnl8W+AaKl
 pj4TF64ee11t915IW3tj1a7M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id be9bc340ab630053;
	Mon, 07 Sep 2026 08:14:16 +0000
X-Mizu-Trace-ID: be9bc340ab630053
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	SJ Park <sj@kernel.org>,
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
	ljs@kernel.org,
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
Subject: [PATCH v2 2/8] mm/oom_kill: convert process/thread iterators to for_each_*_rculock
Date: Mon,  7 Sep 2026 16:13:28 +0800
Message-Id: <20260907081334.1152889-3-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zrua4u7f5jdyricqhia6hiqzufiomr96
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 644E61A0009
X-Rspam-User: 
X-HE-Tag: 1788768858-478302
X-HE-Meta: U2FsdGVkX1/K+ftby2FT0wymYtXaB4pKkedlsVcvvOdhfawE6kcAtnCJ6LXWM18kL7EbBXFA6nWoD9nV60LadsgGUJiVd4JBAOpNvWwKXFP71QNMWmFr9EHZEIGli/Qdobr4wXCT9ZPf0vtvpjPEmbdFrjcsqSwvrzOvTxKtcywmafL3FCsyJ0hdIREyRdY532wmewkKgMJGB/gEBdUGIRljNL+BxxDbu4pyvxuYREZ1G4uOEMSmkOaVXe0ESpc5WQ6T03BSYs77tISCoS9YFjs8XQyKQlj0CLQzSwjlxKBtFnTi/rc4iBR44hP88LbqdmyI2xyq8C3h1+jVAtZTzxEYo5taVEIf+nbFtrdazJM5x8lanPRikzZVqj8zsrHy4ZXIWtOOIx7x1PfDdaDPxRe59XohDfGn8OJoHH3Th2ONdESIBq6uN351bG1N1lckdNbI5irlVsYhAurrEYqbvkCEuSuZ2A9uFElyhlXa7ziQXyt5At7OUKzvNcfQCNFU1uzf6EjjQiePzXrN4g/IbMrfEGtVC4pb8Y3CCSf5sBE0gNJD1Qi6hT1dSFI6BVBXhfLHvNdIJIQxo1MdiAYOQlVLn2c1RR0i2555hk/oEJq/fpjHGDMXnyc5pEy5GCWS7UjQNw8oQID70tF6pj+jHDwKpDrs5aLPOSdqxWSkgiNMGAWzKLY/pOE77Z3rCc5upxgYXDvm+d3gzk/6oawFeM14hWWW7SmoleYu+ny0vcjqHPUch0Rmw8scQ0Q7D3p/Otx/LQoHbhAvSXxf9teZeEugj9Z6JcHiddRaL6V5F0wM82tYj/vyT0XhmxEZIzhfHPd0N4nI3GsZ7ihXMuA62RbxiavlIE7y3GTZ5uckazA0BSDBSn0jgWbOREGsyRiKLPEHSJZr1OsUAEHLn1sujfKOY2u9mGB7LUrgVawbjFizZm2xdPco+vvgoyTVGxHQbjFM2zRkxWfODwQbbU7
 g7uUa7sG
 iMEsEGShsVTvQQPnWBo8zkQYXHkeOdj4hiaY/jtEF5xf1nKRaPa9D7whPsL70iATzsyBUy2SYye0HWZG9DlB70P/TOYtc0zT0ET8pcpn8VwD3gMtBTfiixFlbUJDH5pmO16eBnoDcX9d6axLr8W5NgE0TXY88FTSa8eASbYfEQoKK8pFV4SCuw/JfkMBtFjB8aJe3zlUNwBfFNIhYxOcHUBE2+GMqI4VJ8Qt06DE0+XYdlAqz5x1hXTaZ+N/VfEpN2tuFNgisXjDz8bZNf2pvD+GTgtjApr3+mGRgWTXbnQx/WhT5kuRJB/CbiBhEHnzDQ/MmtHDfh2/O8gWltWL37MVENnUMujVGj/zogFsFaC0UMriG6XL0cYysDKE/do4lu772EgCvC2Cj5NADfRADY/R/QY6hGY0LSMEvC3WfGp3f84/13eEwYcXb4g==
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



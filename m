Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDDFC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1EC48E0007; Fri,  1 Aug 2025 11:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7DE8E0001; Fri,  1 Aug 2025 11:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34A98E0007; Fri,  1 Aug 2025 11:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D38CA8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:37:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1D0216026D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:37:05 +0000 (UTC)
X-FDA: 83728592010.29.41CF0F2
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 876BD20013
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:37:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf03.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n9oRZlgHbtk/T2xlG4YVh+ztghg44s6g9GUildLhGkA=;
	b=1UbxHe/RKneFbNM7ew/uLJayzMCQIIA5d1T0lf9Jin+qTdw2VAlAeenBMywJ6xNgzje8Ed
	z8nFhkLh+NtVhitiPskPcEe08HBy9I5GEXz72XAvZWDN3ckyRnuWlvUWmz2RVZKzW2tpW2
	TcE5VG2TZ/tQByrkrn7cvUWXlaXEuIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062623; a=rsa-sha256;
	cv=none;
	b=XSVqLr5/uiow9E0eeAZQdcYkZWpdVDCzsKLroB1kUI8hvTozuYGDuBn3Z59En7b6fFAATI
	Kkii8fc5A2AAy+dD0YYHiKhyz5+k38ChprBDbx4zP6wrGGu+whuXvwfv/K1wbccCKIdcDr
	t1vQoeBgqrfP+IZMSf1HwxTRCh1pp3k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf03.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4btqjv6SPqzYmG8V;
	Fri,  1 Aug 2025 23:33:55 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 23:36:54 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 23:36:53 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liulu.liu@honor.com>, <feng.han@honor.com>
Subject: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes using robust futex
Date: Fri, 1 Aug 2025 23:36:49 +0800
Message-ID: <20250801153649.23244-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250801153649.23244-1-zhongjinji@honor.com>
References: <20250801153649.23244-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: 5g3cuu55maqgg1nsobcby85cc69eaygc
X-Rspamd-Queue-Id: 876BD20013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754062622-568685
X-HE-Meta: U2FsdGVkX191bZM7FD3RvXmB1cl0+wAT3cfSSRgzL20EfRnYEPfmlhz/0EH2+FNa7RqZPpSjppcAo6SXnIswl2G6M0QRJ7rkTEA8TvVz/Apu7+q3Nwhlhtdz/M5JgqO4JK8eizN823gEsZwKRRYuSb/ZoPIrrK/+1IseKOmXGuFwsf9fbQaDUW1Q2Vry9eTj9s2Vo75EtapJDUjUKInLep3VuQ5hAVminToy+r0zmW7hDFQQ31R/TPcDioxzqrTGW9PPzoxwM4m8jYPws+YtRMyvxSQqSVliJTMQ9CZ3ukXh1mXykl1GELo5o6pqYESjowRUTIb3ZTuW3T/NUydG5MGusltzdRG0O3q5W6SuUE4Lknxl7ZY5W9B3OXZQYZj8ab5r4+NByz9KI2H62D9J9kI+IAmyRqrejCEaYrhl96RcBBELruQUk1O9Z4tzm3CXcB3hEuGiP7dST+4R834ibtKI0T64BL1JIVR+3ES0eT4OZ29YZ9g6YKs11AGjciNiG58IfRm8M+vITxHpz7dJeiCs/qEq3k5OV401lg8vMjLtkKtPOIDTT51jpBESGSwv7965+DT+Au+33zZ3KL//7kMchH2dj8e8XI4dkoTZjNZTNHYchnAQQesGYi3GQuP/R2P1MKBO6glQzpDAKbmzJmS6wr13KlFaKKHKZj/l6KX0DSugJs+FGk5Q3PXvS4MnpffGOOy0u6rV5zLqCeBQH8yX5VMf4lrme8ZfVkkWyWYFoPKeV8rvLbpR6GwKXTikILJ/0Dva/0RQsiI24XlKOQZp0ro4/RIq241t6Tic80K9qJoN7KSwKiA9Kstu//PTru197wiRwqrOsFivej+EU9qmNm2ZYiJk/BqUp8k9c8ndTkmjnyYWuSOlQ/79EBBk+Plpdk+a+rel2Mx3I17bKmKd+7XgokGEML2dt2l1IEvLnWjaVyYgSTCsBYDaGZBdNDlxWK11UKx7zGwo1Fx
 4EzqGNJt
 VBgsUz/M8yaQUzP9mPXpYf8kt+h8iaui5tvWAZq66l1ZVj59pZEXFr3xE8OX3900+R7PRgbw3h7Vu7XSsF6o7wLvDkBSj1nTaR1eRO+1ULJzyeRqeJwHoOrVc0OSuiIk/6r29+1MKdNOSJMXPGYFvI9KMdnVmqIjTZWaA2yxkWDfxjU2OvfC0nxkraoqc14yA2Zj9s8t3A67H8Dcq5BebMnEs046j5UGSkZpJarOv3TTdtg7/fIgIot9j0IoTU2s/Epem
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhongjinji <zhongjinji@honor.com>

After merging the patch
https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
the OOM reaper runs less frequently because many processes exit within 2 seconds.

However, when a process is killed, timely handling by the OOM reaper allows
its memory to be freed faster.

Since relatively few processes use robust futex, delaying the OOM reaper for
all processes is undesirable, as many killed processes cannot release memory
more quickly.

This patch modifies the behavior so that only processes using robust futex
are delayed by the OOM reaper, allowing the OOM reaper to handle more
processes in a timely manner.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..3ecb21a1c870 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -30,6 +30,7 @@
 #include <linux/syscalls.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
+#include <linux/futex.h>
 #include <linux/cpuset.h>
 #include <linux/export.h>
 #include <linux/notifier.h>
@@ -692,7 +693,7 @@ static void wake_oom_reaper(struct timer_list *timer)
  * before the exit path is able to wake the futex waiters.
  */
 #define OOM_REAPER_DELAY (2*HZ)
-static void queue_oom_reaper(struct task_struct *tsk)
+static void queue_oom_reaper(struct task_struct *tsk, bool delay)
 {
 	/* mm is already queued? */
 	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
@@ -700,7 +701,7 @@ static void queue_oom_reaper(struct task_struct *tsk)
 
 	get_task_struct(tsk);
 	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
-	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
+	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);
 	add_timer(&tsk->oom_reaper_timer);
 }
 
@@ -742,7 +743,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static inline void queue_oom_reaper(struct task_struct *tsk)
+static inline void queue_oom_reaper(struct task_struct *tsk, bool delay)
 {
 }
 #endif /* CONFIG_MMU */
@@ -871,11 +872,12 @@ static inline bool __task_will_free_mem(struct task_struct *task)
  * Caller has to make sure that task->mm is stable (hold task_lock or
  * it operates on the current).
  */
-static bool task_will_free_mem(struct task_struct *task)
+static bool task_will_free_mem(struct task_struct *task, bool *delay_reap)
 {
 	struct mm_struct *mm = task->mm;
 	struct task_struct *p;
 	bool ret = true;
+	bool has_robust = !delay_reap;
 
 	/*
 	 * Skip tasks without mm because it might have passed its exit_mm and
@@ -888,6 +890,15 @@ static bool task_will_free_mem(struct task_struct *task)
 	if (!__task_will_free_mem(task))
 		return false;
 
+	/*
+	 * Check if a process is using robust futexes. If so, delay its handling by the
+	 * OOM reaper. The reason is that if the owner of a robust futex lock is killed
+	 * while waiters are still alive, the OOM reaper might free the robust futex
+	 * resources before futex_cleanup runs, causing the waiters to wait indefinitely.
+	 */
+	if (!has_robust)
+		has_robust = check_robust_futex(task);
+
 	/*
 	 * This task has already been drained by the oom reaper so there are
 	 * only small chances it will free some more
@@ -912,8 +923,12 @@ static bool task_will_free_mem(struct task_struct *task)
 		ret = __task_will_free_mem(p);
 		if (!ret)
 			break;
+		if (!has_robust)
+			has_robust = __check_robust_futex(p);
 	}
 	rcu_read_unlock();
+	if (delay_reap)
+		*delay_reap = has_robust;
 
 	return ret;
 }
@@ -923,6 +938,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	struct task_struct *p;
 	struct mm_struct *mm;
 	bool can_oom_reap = true;
+	bool delay_reap;
 
 	p = find_lock_task_mm(victim);
 	if (!p) {
@@ -950,6 +966,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * reserves from the user space under its control.
 	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
+	delay_reap = check_robust_futex(victim);
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
@@ -990,11 +1007,13 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
+		if (!delay_reap)
+			delay_reap = __check_robust_futex(p);
 	}
 	rcu_read_unlock();
 
 	if (can_oom_reap)
-		queue_oom_reaper(victim);
+		queue_oom_reaper(victim, delay_reap);
 
 	mmdrop(mm);
 	put_task_struct(victim);
@@ -1020,6 +1039,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	struct mem_cgroup *oom_group;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
+	bool delay_reap = false;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -1027,9 +1047,9 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	 * so it can die quickly
 	 */
 	task_lock(victim);
-	if (task_will_free_mem(victim)) {
+	if (task_will_free_mem(victim, &delay_reap)) {
 		mark_oom_victim(victim);
-		queue_oom_reaper(victim);
+		queue_oom_reaper(victim, delay_reap);
 		task_unlock(victim);
 		put_task_struct(victim);
 		return;
@@ -1112,6 +1132,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
+	bool delay_reap = false;
 
 	if (oom_killer_disabled)
 		return false;
@@ -1128,9 +1149,9 @@ bool out_of_memory(struct oom_control *oc)
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (task_will_free_mem(current)) {
+	if (task_will_free_mem(current, &delay_reap)) {
 		mark_oom_victim(current);
-		queue_oom_reaper(current);
+		queue_oom_reaper(current, delay_reap);
 		return true;
 	}
 
@@ -1231,7 +1252,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	mm = p->mm;
 	mmgrab(mm);
 
-	if (task_will_free_mem(p))
+	if (task_will_free_mem(p, NULL))
 		reap = true;
 	else {
 		/* Error only if the work has not been done already */
-- 
2.17.1



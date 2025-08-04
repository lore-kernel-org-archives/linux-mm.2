Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C22C87FCA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 03:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20EA6B007B; Sun,  3 Aug 2025 23:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5216B0088; Sun,  3 Aug 2025 23:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7356B0089; Sun,  3 Aug 2025 23:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4936B007B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 23:03:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCB615D9DE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:03:52 +0000 (UTC)
X-FDA: 83737580304.11.8E97DDE
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49B17180006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:03:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754276631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVyIy9ubDHMjLTe8IwGPt0/4tHw3SaDlAbHdWmMDAEs=;
	b=o62mewJS8K4mazJKCXu1q2qzhDAKb+TJbRjsupkpias1RMIE+0oeI+aib4V0FaUUb9PGdA
	006iPH7pwjXeRghi77coJy6QY4C7SGtGr0GZjUKXh9v8IMkU/1KZRyUVgHkQDh9ZNu9eYd
	VzckppXmKSPDJtPn0S7vCHJqjylX/sM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754276631; a=rsa-sha256;
	cv=none;
	b=S2P2F0a7d9S/57veV/Uf6dRk3tssG+UlwLwYgKFkuEUFiNijLq2nkMBKDhYaEj2ZeO+kyF
	nOLiNDY84ZTd5M2sLkFqGmdoYuI2cSzQ+hVN3NDve/m8Bgvm735ft4joPuwoK8oenZ4kOM
	ftJkPwF4fLBzwVR72MT79LVozMoW270=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4bwLsn1NV6zYkxhP;
	Mon,  4 Aug 2025 11:01:01 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 4 Aug
 2025 11:03:46 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 4 Aug
 2025 11:03:45 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liulu.liu@honor.com>, <feng.han@honor.com>
Subject: [PATCH v3 2/2] mm/oom_kill: Only delay OOM reaper for processes using robust futex
Date: Mon, 4 Aug 2025 11:03:41 +0800
Message-ID: <20250804030341.18619-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250804030341.18619-1-zhongjinji@honor.com>
References: <20250804030341.18619-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Queue-Id: 49B17180006
X-Rspamd-Server: rspam06
X-Stat-Signature: tgjuw33rgu88skznfp76bb5oo3m116ky
X-HE-Tag: 1754276629-518038
X-HE-Meta: U2FsdGVkX1/fwq3WjfW5VvaryZ2L+TiEZ8cJRJCModaNTCz3sCRhP03s0jvRj05LyizQwTyXK1eykznrhe1IBW5H4h1NQ5a1FofcfL0kcJDIfDYADcWNO5O0VlyelOk4iVuw0pNJ6RIcBCPktzvaU9tdtLjCcDKHKBkGUg2wP5dTheCDqohCrbZ3hQbkVXsYTgIPlcxprVZkbn4jq26I49D/1pe6fDTYjuwVo8/0xpg7o1dPPtX7bkJdXb3SueVzj+k3Wh6dorVYjkZWzcS+bea4iDpVKKmWWKyYCxfYGK52T9BNcO27TNyF09hdiVW3uZ2DVaOn1P0p+xiD0vp3dpVNWiJlD0hZ/Kstk+GNKrozh7ohZsyqbTRgdMNgXy/W6dWrXVafUMlVlipuUNjRhXd6rD3Bea9D1eqytJqQfuDhvWNR3+wKKM6xbxzB6ISVkhxsRx43QFsABLcGw3lQChd+HxQXDd3IQBsScexL4kn6fAKTZ1P9kqYmINpq671JarAT0Sxa2ENnVhs2xjL+9h14h/3amMUlvOLyZ3IasMqEksbayIbS38Q7YfZBTGh7pZnPQJUa0FrLdTP8mJEsCR4Lzj28Mlj5IdIyajimAUlY1C4G9WjVWfvI7C+gxyOZyiYiAB9lPlAZejp/9h8TeWmAVFSwPWenUw/A+JfYMWzvWBBZ4eEScx1aFK2k5+LMk2xycc1WYMOWMyt+9ols6u51FexMKvWkMy3rgtz8ngmfdnz5FBJQv7TlZNf0jEAY1N5Zul9U+QDc260jj3NCoS20o152gISGT4WDeXkghdVKHxLrBx54lQQ/YDmbSECsPSDSV29skma6LSEMFT6GrM47lZ3nd1JbpkFohvRNrtcTC+IUV3vKWS7xr1M9kOc2OrN4XsoL9E1mornawkwdNJgt5sxd4Hhfi1g9CmlD4eKmP6ogqmpuRTeVyFh0fNmrguN4cvH5fFe2F8wNaj4
 XAwRH8+w
 tFI5BQw7m4RNEA/w8PaX468IjYthcZCQzkap+78gDW9mxZjCNxjsg5ILoqzY21vK7hGN8DfvI5WM9AwgDHfkybPz2q/fXmomvF6nKMcOnCZDHmSajNZ0Lb36BuT9ViRoBNs0+sKOMABzFyOoKRltKYdzz6U0f7dJwNH/af6p8v4itroFjMVpLHHNiHSwCBiG6J0mRbdG0INWdK5zHwQ8NJB+Bpw0gzcwN45h3GXmHanXCAdPa8N2B/uD2uoNvXpAxdDCFB7DMyiBGBo6PO+x28uVa1zRLQ0bQvKTDYNvMX7zyet4=
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
index 25923cfec9c6..c558ac93ae7d 100644
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
+		has_robust = check_robust_futex_rcu(task);
+
 	/*
 	 * This task has already been drained by the oom reaper so there are
 	 * only small chances it will free some more
@@ -912,8 +923,12 @@ static bool task_will_free_mem(struct task_struct *task)
 		ret = __task_will_free_mem(p);
 		if (!ret)
 			break;
+		if (!has_robust)
+			has_robust = check_robust_futex(p);
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
+	delay_reap = check_robust_futex_rcu(victim);
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
@@ -990,11 +1007,13 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
+		if (!delay_reap)
+			delay_reap = check_robust_futex(p);
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



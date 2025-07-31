Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31BBC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 10:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FF86B008A; Thu, 31 Jul 2025 06:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7507A6B008C; Thu, 31 Jul 2025 06:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6668E6B0092; Thu, 31 Jul 2025 06:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52A386B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:29:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7ECF5A8E1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:29:15 +0000 (UTC)
X-FDA: 83724187470.21.A927FA9
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C6588000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:29:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf30.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753957754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=b3pEOMzJ8pGqnPhaX1WnMkWLwQfHUY9HFc/1uVAGeQs=;
	b=VTsct77NzcIVLVCVn27IfuilHZ3mjLMJO0cGoxmbUXmEEqD1J3QsASAsBPZErPiQAaJfcZ
	wTjG3DQm8To9NNfl06scSwaZPITfT0Ik+lNrGgjezAtvqfHTainTHhEGgYu9RrrSM81fdk
	ZwlbOOvzfuYtxjTVCroXkJaVKCbfqRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753957754; a=rsa-sha256;
	cv=none;
	b=5qbZPYqw3Nrh5FjJtUYhI9QAa5ne/n1bJVKczajNQIMr9wYbxT3WBkWmgwZimxBkVr7ASc
	wZn0GBp5f//g24uTiwkqA9kf1+uf0itHSGqna9rfbwtFtlWlyCltr1n5UfzC2hPIHRQOX7
	e4QOgPMH5i4iOVn89CEIBEtpzGOuSPE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf30.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4bt4xZ1knMzYm1Z0;
	Thu, 31 Jul 2025 18:26:26 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 31 Jul
 2025 18:29:08 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 31 Jul
 2025 18:29:08 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>, <liulu.liu@honor.com>,
	<feng.han@honor.com>
Subject: [PATCH] mm: delay oom_reaper only for the process using robust-futex
Date: Thu, 31 Jul 2025 18:29:04 +0800
Message-ID: <20250731102904.8615-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w001.hihonor.com (10.68.25.235) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 7C6588000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ghsgmjfnpd9kbfz1593szja5sjkwfn94
X-HE-Tag: 1753957753-71990
X-HE-Meta: U2FsdGVkX1+PNhzsjsDLtWSqzqlm9d8qtuqsEwlDKhMSIIuQn1UiokaAJ4f2aU+u92YfXfkfC+83w4nIfNPZGAlmC6Wa1xyMpX9NAZNX6MMlFR67f9SEzW3BM8cJVqJvqLj8SITt7+R5dzKEwikp5PZnv/EDzA94TTBDrIUQMg35iJvUFv0g85PWaHvs+5YgiuDxF6TEqtIj4fJ1F+oShwaeDytXHRqK6OtzsfMFX4pL7cdxFSl67xycWpa0oCTPcFfFVnSAulu+wnv42if5+QudZcDxyBRZsphY9jqgjsL6xKR1nN8j/Ebwhi0v6hMxicdzATF3FfTuKxU1D7OfnN7r6HzRSys7aO0SkczOsaHHBO7ynmVbE4/D6XVCyf1jXBUlMpg+Sqh5AOY64ipfbdoefeDKmyEPJiCcIUl4ixdhK1j0qZhmv6pQaBdZrSZn5cgcVHh113FPw+Ss1/8Vl0MZCIgNIPSzBJXVnS6tat21/7UwZz9/P5+AAhQdC8vj9+w+VGMic+L7ZZJGlOwlRBD+d0lftcrcen0uWM8V76TVMmg8+C4NwVkjP+YBreU6mBRMbNtCz3m4qU24bRfsWaaK0ng6SVI79lJFciitdntoXeJ1E10ADMkYwizkMhmJrrjA+9Du6+n4QILXQEfB7maTn8CWInvRnSApXOQb7BTkikiLaJD7tr33fI6uQgEwBDsz4/EvS0OiqTuXJRizwj7c1nJ/AG+q/kBVmhWA5cmvQivgXUqEWpMJt4JG98S/hrsQIuWi91Tn/wz5lP9fAB8ZRVyiKTbmZzFQ1FmAu9VidiDkQEyiA19+MmEExzForeWfUvv9HSbmiuTSRmwjOuBzKixlvqKuHAWDbYJ93Sexoty883E+SRB1B7mJ8nCKq6HQjIjBg6XK3TBXzVOh0C4SDp6sB4CR7ZiQIxns0TeegbHkify0DTvrqlghjxduf/oio8SQ488vzeYqIwC
 4lyW04KU
 fxJJZ9ZbfKEJbEo9LxnwAUSpt2ZSnS0qT8GDPDzPacYuRxfQNelOZ+z3qnxNEtdGPNHCzsNaWHMzgG6h1r7Lkxr9fTgS2ytpwH2dotFmbfqDD2jWkT0zTR0Js4WkTe5GYSCqH3VseN4VTNF76+vI9kfbT4KqAMiBXt86vcycE/U9RVSRtFkriYHa+17qAsTtO65BZC6h9UwMKWBo2U7X57+VWLfpG2S7pNUtjy9njnAk5t8AeU0rukyEqYDV5RV/VoBCZytqBGMs8og89aZDmuZmSP+FibOUkerUe2yOSSuXzV8LENOlt0NIURM/BgBIyFc6rO/DWEh37gP6kzcX484aR2CoEp2dM59VZaI/xtLpEFM4hbCiQD0uMvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhongjinji <zhongjinji@honor.com>

After the patch here:
https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
was merged, the oom_reaper almost stops working.

But I noticed that many processes do not use robust-futex, so they don’t
access user-space memory during do_exit and don’t run into the problem
mentioned in that patch.

So, this change delays the oom_reaper only when the process uses
robust-futex, letting the oom_reaper work properly in more cases.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..7e74dc0ac2a6 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -692,15 +692,18 @@ static void wake_oom_reaper(struct timer_list *timer)
  * before the exit path is able to wake the futex waiters.
  */
 #define OOM_REAPER_DELAY (2*HZ)
-static void queue_oom_reaper(struct task_struct *tsk)
+static void queue_oom_reaper(struct task_struct *tsk, bool may_access_user)
 {
+	unsigned long reaper_delay = 0;
+
 	/* mm is already queued? */
 	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
 		return;
-
+	if (may_access_user)
+		reaper_delay = OOM_REAPER_DELAY;
 	get_task_struct(tsk);
 	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
-	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
+	tsk->oom_reaper_timer.expires = jiffies + reaper_delay;
 	add_timer(&tsk->oom_reaper_timer);
 }
 
@@ -742,7 +745,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static inline void queue_oom_reaper(struct task_struct *tsk)
+static inline void queue_oom_reaper(struct task_struct *tsk, bool may_access_user)
 {
 }
 #endif /* CONFIG_MMU */
@@ -864,6 +867,11 @@ static inline bool __task_will_free_mem(struct task_struct *task)
 	return false;
 }
 
+static inline bool exit_may_access_user(struct task_struct *task)
+{
+	return task->robust_list || task->compat_robust_list;
+}
+
 /*
  * Checks whether the given task is dying or exiting and likely to
  * release its address space. This means that all threads and processes
@@ -871,11 +879,12 @@ static inline bool __task_will_free_mem(struct task_struct *task)
  * Caller has to make sure that task->mm is stable (hold task_lock or
  * it operates on the current).
  */
-static bool task_will_free_mem(struct task_struct *task)
+static bool task_will_free_mem(struct task_struct *task, bool *may_access_user)
 {
 	struct mm_struct *mm = task->mm;
 	struct task_struct *p;
 	bool ret = true;
+	bool access = false;
 
 	/*
 	 * Skip tasks without mm because it might have passed its exit_mm and
@@ -888,6 +897,8 @@ static bool task_will_free_mem(struct task_struct *task)
 	if (!__task_will_free_mem(task))
 		return false;
 
+	access |= exit_may_access_user(task);
+
 	/*
 	 * This task has already been drained by the oom reaper so there are
 	 * only small chances it will free some more
@@ -912,8 +923,11 @@ static bool task_will_free_mem(struct task_struct *task)
 		ret = __task_will_free_mem(p);
 		if (!ret)
 			break;
+		access |= exit_may_access_user(p);
 	}
 	rcu_read_unlock();
+	if (may_access_user)
+		*may_access_user = access;
 
 	return ret;
 }
@@ -923,6 +937,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	struct task_struct *p;
 	struct mm_struct *mm;
 	bool can_oom_reap = true;
+	bool may_access_user = false;
 
 	p = find_lock_task_mm(victim);
 	if (!p) {
@@ -950,6 +965,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * reserves from the user space under its control.
 	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
+	may_access_user |= exit_may_access_user(victim);
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
@@ -990,11 +1006,12 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
+		may_access_user |= exit_may_access_user(p);
 	}
 	rcu_read_unlock();
 
 	if (can_oom_reap)
-		queue_oom_reaper(victim);
+		queue_oom_reaper(victim, may_access_user);
 
 	mmdrop(mm);
 	put_task_struct(victim);
@@ -1020,6 +1037,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	struct mem_cgroup *oom_group;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
+	bool may_access_user = false;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -1027,9 +1045,9 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	 * so it can die quickly
 	 */
 	task_lock(victim);
-	if (task_will_free_mem(victim)) {
+	if (task_will_free_mem(victim, &may_access_user)) {
 		mark_oom_victim(victim);
-		queue_oom_reaper(victim);
+		queue_oom_reaper(victim, may_access_user);
 		task_unlock(victim);
 		put_task_struct(victim);
 		return;
@@ -1112,6 +1130,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
+	bool may_access_user = false;
 
 	if (oom_killer_disabled)
 		return false;
@@ -1128,9 +1147,9 @@ bool out_of_memory(struct oom_control *oc)
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (task_will_free_mem(current)) {
+	if (task_will_free_mem(current, &may_access_user)) {
 		mark_oom_victim(current);
-		queue_oom_reaper(current);
+		queue_oom_reaper(current, may_access_user);
 		return true;
 	}
 
@@ -1231,7 +1250,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	mm = p->mm;
 	mmgrab(mm);
 
-	if (task_will_free_mem(p))
+	if (task_will_free_mem(p, NULL))
 		reap = true;
 	else {
 		/* Error only if the work has not been done already */
-- 
2.17.1



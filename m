Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5701BCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14BB8E0020; Wed, 10 Sep 2025 10:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4078E0015; Wed, 10 Sep 2025 10:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3408E0020; Wed, 10 Sep 2025 10:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5D108E0015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:37:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FDA9BC19F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:37:42 +0000 (UTC)
X-FDA: 83873594364.11.6D79EC1
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3F4510000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:37:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qsDd3X1VbqEOssNB14r0ryAunwDpekNzycaC3UAaxXE=;
	b=t6v+lBq0xEHOXKvkpBDukJolALcc8KX+1t6qA5ZgKIHEWYf4kJsZciew0GjQoE3mT+F1sv
	b41hSwd5CX5Ld1UOWVvBoeicHtIMDjppSMJvYLepdszCsmIlV+GcivPUAbMBjYzhcdlE8H
	+Fw8sJegBk51/LfpLdMm+5Dh8N1Og/Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515060; a=rsa-sha256;
	cv=none;
	b=8hTkb9X1LMcn/n0Wr1u1zzRSfrcaDz/JuC9WKVsa9/AtyTHeiocyjMwnqN/F2sV9IG97/j
	Hl4144gT9lOsWmS8miAmRVVBA9iHBysM6Ib82ruAVTqLNmY5b37bwf2icxyO4E0Nc8RENv
	P2kLmZEYEoeYpz2FpgLk7MQDifKGgVY=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cMNYs4L9jzYlL4Q;
	Wed, 10 Sep 2025 22:37:05 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 22:37:31 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 22:37:31 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v9 1/2] mm/oom_kill: Thaw the entire OOM victim process
Date: Wed, 10 Sep 2025 22:37:25 +0800
Message-ID: <20250910143726.19905-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250910143726.19905-1-zhongjinji@honor.com>
References: <20250910143726.19905-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3F4510000A
X-Stat-Signature: zdmakncighzkrt11khajr3y6tytc5qa8
X-HE-Tag: 1757515059-930925
X-HE-Meta: U2FsdGVkX19K17GFVulnRU84b29HcXsCeIh8VAC2yoCH1VorNDlhzoWIbcZA+G1i56vfSzUvZ1h5A+KAoVb9prS9eZBsUFjAmIZ2iu+Z0bjoV/DtsSkIeopvjntYPH2C3TbDtGUd+bABYR/8wWAOgv+J1XkVXzj13tTZM4NNo2qLVetLgDpD1lNdrC252pg7D81Tem+2cMmHy3xXYLA49Q4r2+4AhUT7r8qvglbU0fhuPJ3IsFPo3n0jRx0WZoHwEjlj6u6HJGopT9xqYZcvoWD32luK2OC1JYiwIRfiI4m2ycZusNiwWZnM/Rxg7kbyZfEWcFxed85nhZp0nzkTANDLOGt45b8ZKlj+ejIVhqycttWfH1hVGGGRTJpN2AE+sy8mxVTfHdn4PfFAyxa+erISAbOKa/+TQBPDdjY1E1hsk9H01RWtL0NLMIpF4R5ea3Rk77L2fO7XgDRyA3KOCTuioxbERl2pAIhujwLTcxfIxhJF5xDKGkn7sM40KSIpZVgGFraPti7N1smBWriXmYL26G6i0xjDd4nW9x5r/p2Y0S65pBmfXskOfrrrGRXJ8Mmioa7Wol1XPrP7b72nopjI/QUl8a91JynrzLS3KTI5Sjb974yQ9aPiMGqgxTwrcW8bR0IfP+CyOypnT0bchhpsWmSRJyNWRUj/T2I2oNwtjEtH20pjebeBF8xXNeF/8LGF7nVdBcIXEEFHqZqW4XTQV25oD1s3JIVxrKnel3ebCZdu46as+J64fuCUXYtTL1Xc6f6C5ikAfAENzObejaBtmkJcW2tp2cEPhOySAZ2rAh7i7tb2SzIjq1OcIobmQVWfgU4OSFrcZ69kviuGc4S9fxLgDe5UUxPyNG189clXqIWsiknKjnaM/72q22D2e0ESEfNEY95u9inXHKA8einx8TpTYGaE5MplucZ1lKwGLi1HPfGH6YpoM5E4hvjXpk75TcsQIlYkJ9xSfgv
 HWoH3Sze
 LnZDSvBAQjbRAvGpuy7B9fPMunWbXjY1xrElgqQaSbhFW3mFOKEAfu6wKEwC/5U4PbXnUD0WujE3QssuTa58HQ5/SSJ+aRQn4YSLMzAxlKadYIY9zM31BClZrPwSaVyGlRmBMfdroeoKIQZD+iMmVR4vQGM0/ZAOCKdmJH5fRyQ2pTHo5ykuca7eSye+K/HioP8tEeTAQSHRxXKyKanXO0pgzeWF/QSbjuKX5FnTnyJ+N3xHGcmKM+C4MY6vMY4F2ZAbpofON2OvW23ilKley6f/9Y5qgsVlQNU2kw5EO4aMVjt0NwZWz91jZD6vvAYnKCGvy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OOM killer is a mechanism that selects and kills processes when the system
runs out of memory to reclaim resources and keep the system stable. But the
oom victim cannot terminate on its own when it is frozen, even if the OOM
victim task is thawed through __thaw_task(). This is because __thaw_task() can
only thaw a single OOM victim thread, and cannot thaw the entire OOM victim
process.

Also, freezing_slow_path() decides whether a task is an OOM victim by checking
the task's TIF_MEMDIE flag. When a task is thawed, the freezer bypasses PM
freezing and cgroup freezing states to thaw it. But TIF_MEMDIE is not a thread
group shared flag, and only one thread is marked with TIF_MEMDIE. If other
threads are thawed, they may still remain frozen due to PM freezing and cgroup
freezing states.

To solve this, thaw_process() is introduced to thaw all threads of the victim,
ensuring every thread in the victim process can be thawed. The freezer uses
tsk_is_oom_victim() to determine whether a task is an OOM victim, because
tsk->signal->oom_mm is data shared by all threads. This allows all victim threads
to rely on it to be thawed.

This change will thaw the entire victim process when OOM occurs,
ensuring that the oom victim can terminate on its own.

Signed-off-by: zhongjinji <zhongjinji@honor.com>

Acked-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/freezer.h |  2 ++
 kernel/freezer.c        | 20 +++++++++++++++++++-
 mm/oom_kill.c           | 10 +++++-----
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index b303472255be..32884c9721e5 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -47,6 +47,7 @@ extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
 extern void thaw_kernel_threads(void);
+extern void thaw_process(struct task_struct *p);
 
 static inline bool try_to_freeze(void)
 {
@@ -80,6 +81,7 @@ static inline int freeze_processes(void) { return -ENOSYS; }
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
 static inline void thaw_kernel_threads(void) {}
+static inline void thaw_process(struct task_struct *p) {}
 
 static inline bool try_to_freeze(void) { return false; }
 
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 6a96149aede9..ddc11a8bd2ea 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/oom.h>
 #include <linux/kthread.h>
 
 /* total number of freezing conditions in effect */
@@ -40,7 +41,7 @@ bool freezing_slow_path(struct task_struct *p)
 	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
-	if (test_tsk_thread_flag(p, TIF_MEMDIE))
+	if (tsk_is_oom_victim(p))
 		return false;
 
 	if (pm_nosig_freezing || cgroup_freezing(p))
@@ -206,6 +207,23 @@ void __thaw_task(struct task_struct *p)
 		wake_up_state(p, TASK_FROZEN);
 }
 
+/*
+ * thaw_process - Thaw a frozen process
+ * @p: the process to be thawed
+ *
+ * Iterate over all threads of @p and call __thaw_task() on each.
+ */
+void thaw_process(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	rcu_read_lock();
+	for_each_thread(p, t) {
+		__thaw_task(t);
+	}
+	rcu_read_unlock();
+}
+
 /**
  * set_freezable - make %current freezable
  *
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..88356b66cc35 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -772,12 +772,12 @@ static void mark_oom_victim(struct task_struct *tsk)
 		mmgrab(tsk->signal->oom_mm);
 
 	/*
-	 * Make sure that the task is woken up from uninterruptible sleep
-	 * if it is frozen because OOM killer wouldn't be able to free
-	 * any memory and livelock. freezing_slow_path will tell the freezer
-	 * that TIF_MEMDIE tasks should be ignored.
+	 * Make sure that the process is woken up from uninterruptible sleep
+	 * if it is frozen because OOM killer wouldn't be able to free any
+	 * memory and livelock. The freezer will thaw the tasks that are OOM
+	 * victims regardless of the PM freezing and cgroup freezing states.
 	 */
-	__thaw_task(tsk);
+	thaw_process(tsk);
 	atomic_inc(&oom_victims);
 	cred = get_task_cred(tsk);
 	trace_mark_victim(tsk, cred->uid.val);
-- 
2.17.1



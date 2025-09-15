Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67F3CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD268E0008; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EDC8E0001; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C4A8E0008; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2D068E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:29:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 985DB1A066D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:29:59 +0000 (UTC)
X-FDA: 83892021318.22.67855BD
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 364F6180004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:29:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/cMG/iz4N/CO/EcOGE0r6lc73EaPdIOSwJkwvrSTw4=;
	b=FBMFczUTpkjTjtRMvzzShvzXgwYYr4VEto72IR3ROGd0MuD/yQnmZ3CruB6xhGd5uPFXf8
	ma2A5Gim8b0r4stEwvihq6UIi8lMRNuBXbWLrdHNLE0Jo6GCzQhxjuZs53zTMcySKxjkCX
	tf7oNd8Iuh6UGckcj+PM9lov7UpAyP0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953796; a=rsa-sha256;
	cv=none;
	b=QfsaXJTHMWvguh5GpyAPhOABxGopdnKhrVS1dxpYHphw9kJYG5n67N2xl+uVSGBq4DxcrQ
	CH1KkZPapS9rPdt3cpElDEEnqJmpf+XJMiJMVl0LGJUREej5QS8Il7LwxWS9mNmGJLfw0J
	2+5mhEE8N5GldF1h565kjXekRFuqEA0=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cQVq546x0zYkxsl;
	Tue, 16 Sep 2025 00:29:21 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Sep
 2025 00:29:51 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Sep
 2025 00:29:50 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v10 1/2] mm/oom_kill: Thaw the entire OOM victim process
Date: Tue, 16 Sep 2025 00:29:45 +0800
Message-ID: <20250915162946.5515-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250915162946.5515-1-zhongjinji@honor.com>
References: <20250915162946.5515-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 364F6180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cn6od9qzhg4tssnjzpw3noouhrm9f1ti
X-HE-Tag: 1757953795-761983
X-HE-Meta: U2FsdGVkX18LW93HgrlkFO60N7xre0olM4mpe9i3h5g6loytIuLIz8Yfpxa/QGY95VhDAGUcfxovMgbgyigJglbck9WmH4inRXMo85Ypr26vFBeF6haTFsZc5Z9OveEppmuGeF5nJUhywkfYYNcAxM5JWEdoWt1ymZnpDxlDSqBDTUksLtjNm5g3qnVEW1VbcblHLZitUtbXRVSzSDbQxyO9gG9y94b37+ioW2XGgDs6RH7i5fHuql/j+Ivs22YsNcHpiL4C0z2dK4DD6rHD94r3NWWamlkGHK3OSAlLooI9mIPchSim7JYbRG1VUafTrFjxZJoV9nBAlIR/1odQrocZD8VjG/rXMS841jQ1UdUbAax8ak7SvPo26VQLKyLL8VNQZ811e5nzvL+NbH7N1Ne23wKV2fvZxV+FlGLWgYFm/HYAY8myXvLwv6eLCYZh6LD+7z+jBqiuIG3+HkMJftCh1aI/9IbwxgzbEl4GjWqVB5yjWkJbVGgDxihU8MzlljvPa7hc6PGl/bDxO6tqD8KGfHAj/2T9fMIt4syFc6v8zl5DpEsk7VoqzaqfEEP0S8/el7oDjwk7NhOhtV4rj+dBeDJe9NGqrhHbLeKcE1V84UYb6yEV4rDTauCSbePay+mzMjNrNIvWrEkLuGeh82hbSV5cbxPB5xmZ0DHMNDHbkJLC4r07Omg8BfKXKjTH5BBhh8r5Zv+QVlc0vUcFHfNE3JrFZR4AVP7yk7l9nRUqSOrjLsofzXBpPTOwkqIEnIKF6f4NWLHj5xjfuRYuZu9EaiPN7vBCnPsaQqnf2PGpMQ4/NDX5GXHJVhpDFg3hPXiyEoggZ2p37olC9VnxPTaGvDNNV81Fab4TAtjiSCt1pGhwCGmqctxw70p4caGTNVVRj3W6P2WlRK22RYe3/6n1iRejWmiF2Wme9PQjYLqZzcwwnN84sFr1ct1m7LZAc6fn8N9sM/9nqVo4HnI
 2BeUqyAk
 cFqtz4u0MYQH/q5KTjiFmJoBO0oA/giNkNBHa27Y9PhYXsFBMVP1M7KcSuUjjkruyBK5cThqdWuc3JOFhHr5OsoNmnvZN6xD1nO6kcQoqh/Z/SM/1HnROy82aibaTBaZqL4jeES5K7z7mcuP277oSqzRkVDALEwoUuidT9dc92XsrEYb8dVHlfMkV7kAIa9tZC2wGIio2fQwRifyG9XhaVnrtMzdH0tcG41b6k2ZwhX95O7HuqXIyvZO2DaPc9g70kxQFe17ThcaN1gMRRe3v8suV9Pn3aLEtDc3pLKPTTFuJMHw4zXem/YCx7YHh9gm1De4hTZaFzyibq00D1m+sJmREAg6d4RuYJOSdiujv2LIPQXqVQBUKxbYEXbxiWBKI5oy96Sv5tZRXx6Gpf7/nczYUjfY8YVUsplBl
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

In addition, freezing_slow_path() determines whether a task is an OOM victim
by checking the task’s TIF_MEMDIE flag. When a task is identified as an OOM
victim, the freezer bypasses both PM freezing and cgroup freezing states to
thaw it.

Historically, TIF_MEMDIE was a "this is the oom victim & it has access to
memory reserves" flag in the past. It has that thread vs. process problems
and tsk_is_oom_victim was introduced later to get rid of them and other
issues as well as the guarantee that we can identify the oom victim's mm
reliably for other oom_reaper.

Therefore, thaw_process() is introduced to unfreeze all threads within the
OOM victim process, ensuring that every thread is properly thawed. The freezer
now uses tsk_is_oom_victim() to determine OOM victim status, allowing all
victim threads to be unfrozen as necessary.

With this change, the entire OOM victim process will be thawed when an OOM
event occurs, ensuring that the victim can terminate on its own.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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



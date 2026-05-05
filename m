Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA65FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79C5C6B00A1; Tue,  5 May 2026 13:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774546B00A2; Tue,  5 May 2026 13:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0CE6B00A3; Tue,  5 May 2026 13:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0376B00A1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:59:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E568640597
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:59:47 +0000 (UTC)
X-FDA: 84734129214.12.C792135
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DEBFA0008
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:59:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xw0GIQOe;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778003986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfoloV9tLW7+0Qi2pyB+tm34tWDnKOZO7agHuLiDDcU=;
	b=5g1iyLeoTtfsOzR87WYRRB+dSxasXMhfQXZ1NqX4EuqZz3NjYpIbHVzVezrRSFnnDMYbdk
	UijXMzOhawFIIBAlkzbI3PGOyHsjAkiBwi7wJBc/CF6kT7O/XQAHxcHgpGu11dXBeHiLdn
	6Ujc0ikXPmKfUZwawoAifYUdJdvQiTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778003986; a=rsa-sha256;
	cv=none;
	b=URqovitnFcq/9Ny05QXTVXKJtYrJ2LJwO38p1lUKt1Ufg+MBgJOaGmPw9cKe5hkEYlmQI6
	7JqxPv1IVFuHJjJ/ond9CoOqHnj61G6xsPDU6buPH0XnyQvECybDdIbLmz7oW8LXrIw6TK
	v2f5zYydSXvu2oiB8hH6e5fy094Ty7c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xw0GIQOe;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E641D401D8;
	Tue,  5 May 2026 17:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9ADC2BCB4;
	Tue,  5 May 2026 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778003984;
	bh=gD66kznneqSBjDfNvHtEYbGQhZNTMG6YArmooZ1UIok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xw0GIQOeVJKuVxm/2obhNmP0Vzf5X+/XEAP8lLR4hlRrx3FpBBW9jCg5g1Nz1ljQg
	 ZSSGhSTdPgxrL2FHsrG/90MDiyFJqmtPow98ZEkYG+ro8XHrCv9IBe55HfvhscA7jg
	 J1izjdeeyzPa6wbLYR+zkVuV6grokvRZWzW7GXZrL+xyVyrYWhjnixGz76owSb4B1k
	 iLOSg2oI9w5xOKFrlnSypJOm1mnq0/xbq/ZTKv7gTMMx/h+ksmMnAFOFD7k171Uwf7
	 ARwaiPcufZNhHDU52c2nxtyVa7ULIMrAJMxY8n4UkldNV9I4j1WCpc0AHT4DiUpAD0
	 cXZ58NVo+3aVw==
Date: Tue, 5 May 2026 10:59:43 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afowD31YsGVdVUBP@google.com>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
 <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
 <afoUt3te1k2TNao-@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afoUt3te1k2TNao-@tiehlicka>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2DEBFA0008
X-Stat-Signature: 8o97uphs9m6swecdawyg6nrnhao7b38q
X-Rspam-User: 
X-HE-Tag: 1778003985-523057
X-HE-Meta: U2FsdGVkX18XGm7Gg7lKyltbgK43GHTg2V5GR68/FZQuz/o0ZvKif0UmE153hEedubVsqBg+podRD84u12yhfqQTeVUYSHWNpkRfKvqgVzAS5Ym1lQaXvx3vztl27yY//7nnHqw2Ut7q/law4pfPMFNeu1wTOEhYvUKGixUJo1GB91FS0hxcplo2uQPFIiphC5++RgkMHzcPz9/H1iSyY8T22YwtbKmQvkjVpFCxA6hnfI/fSUMaUwYOhzomt2XML7Z6qluyuotCG32OuQ4tk/o9jzZ1JlQ/0hSI3KdTKgN7YcFgThAiaqdUUX6QmjGRfPmhsANcZOjm4v6knM7wJt/dE5MCy+rlFuBx/dZft2nLc6ewmIXxMuAUpCBpV5aaVt4l0+15H+yn3M5hRAzhh9XAPpfmrCZC+X0PCpq/NwtNm7kjLJ2/ppmxQELBUGJiCfjKBoY184aAG+3B8Eg+am84kn4trvRssXJtEdWc59Uut394XRkHYMTGUW+g/xM0RXcQpGUO8+BGS7QR3dzTWnEF4yAqnaoXtZAt0POc7oN+hpYCPTNhMBMJBDLw/6dA77K9usby4hAyD6MSvIFXWyIikDkSGZvSzosIy7wgDv/n/VnH+KdgI9DYWJkbbmYI2qxI0RIl43U5V1+j288uyZcc6AchLcZyLQQ25AEgjKCnL47veuOMSXPP5dy9lHH7d9sQjn1vmWRktOTnZ4RY06V18TwNUYL9qKRh67WzDiebXyyLpR69qCO56wHBODoaF7A54nGU5w0CcAZxIBNKyr9PBF0DZEYEEIY044xs6PHOw3kBby8sPqZUGbScUPF7GRk50INx2bq0xcMaSy+RhROy7GzOaeZg85wQi49FsfqQayb4T5h4b7rVOY4V6/FMKwvamZUrtqWDFbv528T1fj4aal1691/5+6f5sMxPty+h+dDI1AIqOkzf2KQG9nSa2F2QKhyAmcp3vr/NYKS
 aH48CdDg
 C2GWqSHrbDoUy2tuKuvF5h8eAK4l/QdicY4Kf2w+mFpwSAGwlfNOjdXXqpWGOemFOGWeOJLyWSwSUEod/PjfAv+YTjRInQASXibilMwC/mBuLKulifniKE81c5xTPTt2pPIBSvOG4aQ4UOln022KZiHNFLwNWBa0lIF8tnDdN+9+i3qXnYnsTwBhTsZRKWbHmEke41JvOi9QdcOf7P88fqyaB9EIL09rQdZjm3QmFHN6v81VB8jh/gPACdS60iJXcnV8GTg82FpC7OQSthHcLjMlRo/LKIfvnTls1BxgKkLny6FmHMqBldYnaHOscvmqyh6X6YcM7idl1WNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 06:03:03PM +0200, Michal Hocko wrote:
> On Tue 05-05-26 11:30:22, Christian Brauner wrote:
> > IIUC, then the OOM kill if invoked from the kernel just takes down
> > without permission checking what it wants to take down. That makes a lot
> > of sense and is mostly safe - after all it is the kernel that initiates
> > the kill.
> > 
> > However, when userspace initiates the kill we need at least the
> > semantics you proposed, Michal. You can only kill processes that you
> > have the necessary privileges over otherwise you end up allowing to
> > SIGKILL setuid binaries over which you hold no privileged possibly
> > generating information leaks or worse.
> 
> Agreed!
> 
> > The other thing to keep in mind is that currently pidfds explicitly do
> > not to allow to signal taks that are outside of their pid namespace
> > hierarchy - see pidfd_send_signal()'s permission checking. I don't want
> > to break these semantics - it's just very bad api design if signaling
> > suddenly behaves differently and pidfd suddenly convey the ability to
> > do a very wide signal scope.
> 
> Agreed!
> 
> > The other thing is that pidfds are handles that can be sent around using
> > SCM_RIGHTS which means they could be forwarded to a container or another
> > privileged user that then initiates kill semantics.
> > 
> > The other thing is that the type of pidfd selects the scope of the
> > signaling operation:
> > 
> > * If the pidfd was created via PIDFD_THREAD then the scope of the signal
> >   is by default the individual thread - unless the signal itself is
> >   thread-group oriented ofc.
> > 
> > * If the pidfd was created wihout PIDFD_THREAD then the scope of the
> >   signal is by default the thread-group.
> > 
> > * pidfd_send_signal() provides explicitly scope overrides:
> > 
> >   (1) PIDFD_SIGNAL_THREAD
> >   (2) PIDFD_SIGNAL_THREAD_GROUP
> >   (3) PIDFD_SIGNAL_PROCESS_GROUP
> > 
> >   The flags should be mostly self-explanatory.
> > 
> >   So I really dislike the idea of now letting the pidfd passed to
> >   process_mrelease() to have an implicit scope suddenly. The problem is
> >   that this is very opaque to userspace and introduces another way to
> >   signal a group of processes.
> 
> I do see your point. Unfortunately the whole concept of mm shared
> across thread (signal) groups is not fitting well into the overall
> model. For the most usecases this is not a big problem. But oom handlers
> do care. If you do not kill all owners of the mm you are not releasing
> any memory.
> 
> > IOW, I still dislike the fact that process_mrelease() is suddenly turned
> > into a signal sending syscall and I really dislike the fact that it
> > implies a "kill everything with that mm and cross other thread-groups".
> > 
> > I wonder if you couldn't just add PIDFD_SIGNAL_MM_GROUP or something to
> > pidfd_send_signal() instead.
> 
> That would be a clean interface for sure. The thing we are struggling
> here is not just the killing side of things but also grabbing the mm
> before it disappears which is the primary reason why process_mrelease is
> turning into signal sending syscall (which you seem to be not in favor
> of).
> 
> So I can see these options on the table
> 1) keep process_mrelease as is and live with the race. This sucks
> because it makes userspace low memory (oom) killers harder to predict.
> 2) we add the proposed option to kill&release into process_mrelease that
> is not aware of shared mm case. This sucks because it creates an easy
> way to evade from the said oom killer
> 3) same as 2 but add PIDFD_SIGNAL_MM_GROUP that would do the right thing
> on the signal handling side. You seem to like the idea from the
> pidfd_send_signal POV but I am not sure you are OK with that being
> implanted into process_mrelease.

For 3, maybe something likle this?
(Just to show the concept for further discussion)

---
 include/linux/signal.h    |  4 +++
 include/uapi/linux/mman.h |  4 +++
 kernel/signal.c           | 29 ++++++++++++++++++---
 mm/oom_kill.c             | 55 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index f19816832f05..bdbe6b3addec 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -276,6 +276,8 @@ static inline int valid_signal(unsigned long sig)
 
 struct timespec;
 struct pt_regs;
+struct mm_struct;
+struct pid;
 enum pid_type;
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
@@ -283,6 +285,8 @@ extern int do_send_sig_info(int sig, struct kernel_siginfo *info,
 				struct task_struct *p, enum pid_type type);
 extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
 			       struct task_struct *p, enum pid_type type);
+extern int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
+				      siginfo_t __user *info, unsigned int flags);
 extern int send_signal_locked(int sig, struct kernel_siginfo *info,
 			      struct task_struct *p, enum pid_type type);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
index e89d00528f2f..4266976b45ad 100644
--- a/include/uapi/linux/mman.h
+++ b/include/uapi/linux/mman.h
@@ -56,4 +56,8 @@ struct cachestat {
 	__u64 nr_recently_evicted;
 };
 
+/* Flags for process_mrelease */
+#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
+#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
+
 #endif /* _UAPI_LINUX_MMAN_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index d65d0fe24bfb..b2dc08a9bdd3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4046,6 +4046,30 @@ static int do_pidfd_send_signal(struct pid *pid, int sig, enum pid_type type,
 	return kill_pid_info_type(sig, &kinfo, pid, type);
 }
 
+/**
+ * do_pidfd_send_signal_pidns - Send a signal to a process via its struct pid
+ *                              while validating PID namespace hierarchy.
+ * @pid:   the struct pid of the target process
+ * @sig:   signal to send
+ * @type:  scope of the signal (e.g. PIDTYPE_TGID)
+ * @info:  signal info payload
+ * @flags: signaling flags
+ *
+ * Verify that the target pid resides inside the caller's PID namespace
+ * hierarchy prior to signal delivery.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
+			       siginfo_t __user *info, unsigned int flags)
+{
+	/* Enforce PID namespace hierarchy boundary */
+	if (!access_pidfd_pidns(pid))
+		return -EINVAL;
+
+	return do_pidfd_send_signal(pid, sig, type, info, flags);
+}
+
 /**
  * sys_pidfd_send_signal - Signal a process through a pidfd
  * @pidfd:  file descriptor of the process
@@ -4094,16 +4118,13 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 		if (IS_ERR(pid))
 			return PTR_ERR(pid);
 
-		if (!access_pidfd_pidns(pid))
-			return -EINVAL;
-
 		/* Infer scope from the type of pidfd. */
 		if (fd_file(f)->f_flags & PIDFD_THREAD)
 			type = PIDTYPE_PID;
 		else
 			type = PIDTYPE_TGID;
 
-		return do_pidfd_send_signal(pid, sig, type, info, flags);
+		return do_pidfd_send_signal_pidns(pid, sig, type, info, flags);
 	}
 	}
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..253aa80770f2 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -20,6 +20,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -925,6 +926,39 @@ static bool task_will_free_mem(struct task_struct *task)
 	return ret;
 }
 
+/*
+ * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
+ * @victim: the targeted OOM process group leader
+ * @mm:     the virtual memory space being reaped
+ *
+ * Traverse all threads globally and signal any user processes sharing the identical
+ * mm footprints, ensuring no concurrent users pin the memory. Skips the system
+ * global init and kernel worker threads.
+ */
+static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
+{
+	struct task_struct *p;
+	bool failed = false;
+
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (is_global_init(p)) {
+			failed = true;
+			continue;
+		}
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+
+		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
+			failed = true;
+	}
+	rcu_read_unlock();
+
+	return failed ? -EBUSY : 0;
+}
+
 static void __oom_kill_process(struct task_struct *victim, const char *message)
 {
 	struct task_struct *p;
@@ -1217,9 +1251,11 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	unsigned int f_flags;
 	bool reap = false;
 	long ret = 0;
+	bool reap_kill;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
+	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
 
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task))
@@ -1236,19 +1272,24 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	}
 
 	mm = p->mm;
-	mmgrab(mm);
 
-	if (task_will_free_mem(p))
-		reap = true;
-	else {
+	reap = reap_kill || task_will_free_mem(p);
+	if (!reap) {
 		/* Error only if the work has not been done already */
 		if (!mm_flags_test(MMF_OOM_SKIP, mm))
 			ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
 	}
+
+	mmgrab(mm);
 	task_unlock(p);
 
-	if (!reap)
-		goto drop_mm;
+	if (reap_kill) {
+		ret = kill_all_shared_mm(task, mm);
+		if (ret)
+			goto drop_mm;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		ret = -EINTR;
-- 
2.54.0.545.g6539524ca2-goog





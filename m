Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A117CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86CBB6B00AC; Mon, 11 May 2026 17:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843E46B00AD; Mon, 11 May 2026 17:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732CF6B00B4; Mon, 11 May 2026 17:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E31E6B00AC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:42:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2EBE8BD83
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:42:36 +0000 (UTC)
X-FDA: 84756463512.01.2B815BE
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 11C2480005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:42:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X073l8fv;
	spf=pass (imf02.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535755;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=d+UgRnX2o/IheCI05ApznuIAinSPW5zogwfT5DaF5pU=;
	b=F1WnFF0yjO/5eRxMrL764BQJqRdixG2RWqGgZfwp/Xlunn4+b2IQyXnLf+It9BTK8mGQls
	YVJ8+aM4X/4f7CkpiN/oiCH0M0sthmLqMpEdTzTCWQXr0Z0wJniX5pTFCLbHVQB4d5PsgP
	aoQbDFKsz1yJQTZkd4cAL5pepNi2NUA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X073l8fv;
	spf=pass (imf02.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778535755; a=rsa-sha256;
	cv=none;
	b=8SNMnVeXCUDHffUSwq715BUM6gum4LHAuUJg49NRzxTDhqgc/ZUBvqCbqKlbdbFamN8haQ
	lXPCQLhlrlRX54gRjU9862LzPR1ZTXYOooqLBc9RzAE0uBI0qzL0ESvDmTbES2q0uxwBNu
	bnXWI4t/12RuTrnqoxsZoBTiDiamxE4=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2ecf9e398f4so13065919eec.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778535754; x=1779140554; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=d+UgRnX2o/IheCI05ApznuIAinSPW5zogwfT5DaF5pU=;
        b=X073l8fvzf1eN5pRhXyvCzN4ywOPj3eyRN2wwTiKW/c9H+RLfU2h6WXDbEBVLMg9ac
         hdVNeZguFcLFw5w2TBVivq4Cf8HgN22M7BiIsSDNcxlT8vkANvUXRKzmFUb8hMXZTAL6
         5GVL+uLS4gu7DBQ9tUz1LYgYzg0UQAHc7R5cefjlxK2PiTUK+H1w2IlzSmlKyYjkV+YG
         pcjvxErwB8kG1bxNPSSZL+7KMfMruoTMTVS0VCijlF6TvHR3JbmpCi72Fnm9PD28HxTV
         wF+CXZHj5zvt6sxUvq3tSMtL56CSL2phI+smCRWt+IY8xaxWt4GrV3kFEVZuNscLDidE
         kYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535754; x=1779140554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+UgRnX2o/IheCI05ApznuIAinSPW5zogwfT5DaF5pU=;
        b=AJoyCGZoYLONtZ3213WRh80Dyy3iI3ki3iYM7wmKlgqHpKvDw1H6nF41u3JI4+8ntJ
         iyquT9Y0JiXoM/LtcugXu8F+8Q40lu/qv9wvtjJqsJKgZKCLdFXeqJhjw6fDzF21M9nd
         f3CM2d85V86/F96XZix/FIpxTsggC3rNM4iUL7j4OjcYzuvOdtLp7vGaYVcHEouoNEb+
         /UB02cMRM6WbupZj3zn9Eb5lnearswJvC7IRSkz1KlqRocOVd6t305RxRtixs+HbYiQY
         oklRW1A8ud0BdG4t4guVGjwwVByOQv/iaUEW/qA0g1jHVqOt5Ky6Mb3AQgWex7fTV38P
         qWtw==
X-Forwarded-Encrypted: i=1; AFNElJ9udlHcmlc3UzQX2n9TkEJh9+7zX9MLYAGpeU0toI5jKdl6LPPnc2ZfdPo+il2nCNRmZEsi/Tjkfg==@kvack.org
X-Gm-Message-State: AOJu0Yw8QzX5XynDOumxUJVuPRO7ZiH4Iftht17GHQAi2xmYyiYiO1YY
	Bv6VBgOTBC3JcRpgYuUY5pn4L6p854TEmbLVgcH3kJNJ8SPOtmvBjPB3
X-Gm-Gg: Acq92OHoiOMzmhRIDL+Cg1odUiLkxFN0XfDSiQidyaL01fPvhX4H+1kANhr+d8Tz0d/
	dBSXric8xhDNer8QrSr674UXSU0ia+t61+CYDvbNIxOGJpPl/btLUV9iS/T1eMZdVGVEi/NU5qG
	QAN/LQVGZNnNMInDPAzGknZc3Cfcktqp9DcGbYAeapCQtnlxtdt1MNQN+wQNJpb6BdIPkI0J8fg
	e68kWwieAyGRqPOgGT5bNyOTx3HgRi/ok9EqsvvD3l9EzM+GTHmXHnwqVbnGE+trd8goG00Ux7P
	eOMVfJXGUF6K+oJYVqHiIvcl6fmVJ8T9EKP1JgzdAizqwX6w3RJLd3kumnv8pvAwHEs1LwMpagF
	IBzNqQqs+fKW4w06ZXa8jhFudUfCSCt3U0O47747t4kcelYvHDwhOMKBKzphYChREeEgTc2g3QB
	v6C1FVLjV4x/7GmplKT23pukUvnHvtHhMRb0D5DRCGe6dlsbKvCIx5vMnpMUpxVxWpqwQiNGQA0
	meP
X-Received: by 2002:a05:7300:641d:b0:2e6:e868:4f38 with SMTP id 5a478bee46e88-2f54ad7251fmr13440980eec.3.1778535753506;
        Mon, 11 May 2026 14:42:33 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:9727:409b:8acc:c2d2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eafacsm15057543eec.1.2026.05.11.14.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:42:32 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: hca@linux.ibm.com,
	linux-s390@vger.kernel.org,
	david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Date: Mon, 11 May 2026 14:42:26 -0700
Message-ID: <20260511214226.937793-1-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11C2480005
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Stat-Signature: rkbtp8fxkojhn4u7kdwyis5igwggchc7
X-Rspam: Yes
X-HE-Tag: 1778535754-809375
X-HE-Meta: U2FsdGVkX19qByem4ca/jH+7/q2mY33mGHACI611zwtbMCnd8rKRtbbkqlvONZAX9ZMXjRKU9yFgsG4+ADUUxWcY+k0qwEateEnuklJQV0h1N/Pz+yIuO1P4Rl7Jwt2cMjeV7kXT5UB5L5tYkfbgfCeXSZgH/Q/2hJ9EPIvT79Zd+LbUWkOi2sJh/S7MFEk/V2qvcP6rxdggIKeGs3kjEjTwGptjgoyp65umuLGExrdV6FuHrWSRjE/upeD6PjkRjKRaMdPVtJnXtSX39z77IW/Rp1NX4ybxscT1XIy9xiXiR4nVCCtk2dxBMHMYGJ0pGaB5+bSNxYE941lTitaKMJWJLWPRvDcSrCCCs9xKvvm5mDdBeYeDA7Je6AlQfA7gnrPXWOJWDgo5T3JxQQ7xSRS0OStByWz1IYkDx1bOoMlFwBz3Co282i24y8SCD0y7/CNFW40d/or/7OAzdDY++NgWzohW9DI2N7zrPY6jPhR6X3Ft4lyI+LiKewvSix7hM2aGYNlCrmaqbt6ZTnNtmOSK0pS9Rwc6W5/6mnVapuuI3zGODDrKGYiz1Uy5lsu0VpeetTpBEyp3BdQTsZ5GmyKlP2p4dBCEzfOK8oxrLm/S+sFCEFVgIJRJjJy7jF/qPvEZyCPOGyusqJtIWESUi0vqZj/UctemGmL0z2YHvWeGk/ztk+dst0x9CsbDpP0Ip4fu0TGSXhrfUBEuuaRVddXnWlK8Lok4ZI0UQoBAOFRutexkkKmdbbPMwH7uN8ZVnQC1/dYhsL1Xv+9giFlk1ZhbGZOTiZBKub2um/2VeFAdnWMp+xk63++5pDzsxxme/uY9ksknGF8lrIT9B6BA7tBWUjnMByiC2pdeLrlgdR9oVRv337DXiCMI7LBYq8pDBz0BEJG77Z6hGDXOijbw+JBKbxAugk6De9r4TClU5HrYHV1PEvPV3M4xHdUNxCctAzu4Y9DD+kOpdny3pbN
 Lev195Lp
 MZMCLxDq8OrDShvWwdZKuj2HgBcv943yl1IAqDAImu7kXvqPq8UqJRYc+mIipvGBqz6PdtGfWtxxmEdBfa9G5myQ/pijVtP7WLjUu4fJt+taZ4buGCOiJ9saHLl1ofRJs2m4PRBAKkg+FWFc0hpt5yejcNwVDVa9jZ89Kj3+8seCsTiGks4ukQnB6zXWBmTZ0p16C2sdK+1HTSLxyt6F1yfRK/Jtk78obt4uFH9OMWyKGU1zE0d7iTnzSp0DXB8XJ765db7EF4LiSDijwhsKit4ojZd0xgOxhJyncHvQ99D9jaLR9erbvwv8N1VjVJA+u3Fa25jvMZwZleN2pt+tQYk54cAcUVWgljWeoihV5jVJsJV2RBH7SgIWhVekgvqQbLz9yqhFE68xvcUK5r/aKV1LYMN1vb5Nu28sEWUAYVx+sOiaSG+GzNd7xDwxWhofa9cT3ECUaxopKmLEghRTj8SaIxIuHth77vTDPyD4edgKXz+8BLCYYXLiqRwv2Pj8tx+Xxx3acX4NCReik+xH3YQThX865ClGdvCHnWGywM3pX3U/+5u8ykmEzxcjSX7qlKmJfpfsd7YxdBdfSLASlrF8mWmD3H7fkUOZNoqFMWEh/dfN4ZSkmBjfp8ESUBhrf+SmjKtsfizWAbpBMgMf5879zj8cYf/XRX/ZQdAg/nI850CeGK8RpEWI7nk8UJ27daYLhdnD1wGGRT4ZBjowNif7jNoFjS0io7XA4YaBG+3TEa738ORLQo3L0Uh8LuNeDMaKyLRGDKgCNf+lVI0gQS2y5BZw4DeVh99/qtv+IDL05vToLq65jIZxU4e25mNtJKa1c3cTFjMCl0gos9EAOW71bzUvC/NyxaeAqGkrBLmlIyhNn97V82q59sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to invocation. This separation introduces a scheduling race window
where the victim task may receive the signal and enter the exit path
before the reaper can invoke process_mrelease().

When the victim enters the exit path (do_exit -> exit_mm), it clears its
task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
leaving the actual address space teardown (exit_mmap) to be deferred until
the mm's reference count drops to zero. In the field (e.g., Android),
arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
remote VM accesses) frequently delay this teardown indefinitely,
defeating the purpose of expedited reclamation.

In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
the system to unnecessarily kill additional innocent background apps before
the memory from the first victim is recovered.

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode. When specified, process_mrelease() directly
injects a SIGKILL into the target task after finding its mm.

To solve the race condition, we grab the mm reference via mmgrab() before
sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
it will free its memory and proceed with reaping, making the logic as simple
as reap = reap_kill || task_will_free_mem(p).

To handle shared address spaces, we deliver SIGKILL to all processes sharing
the same address space using do_pidfd_send_signal_pidns(). This ensures the
target pid resides inside the caller's PID namespace hierarchy prior to
signal delivery. We iterate over all processes sharing the mm and deliver
SIGKILL to each. If delivering the signal to any of the sharing processes
fails, we return an error. Note that this approach may leave partial
side-effects if some processes are killed successfully before a failure occurs.

Cc: Christian Brauner <brauner@kernel.org>
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
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
2.54.0.563.g4f69b47b94-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D77AECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC6C6B0098; Wed, 14 Oct 2026 04:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E5A6B0099; Wed, 14 Oct 2026 04:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C1C6B009B; Wed, 14 Oct 2026 04:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C93A6B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:54:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F83FC047B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:54:41 +0000 (UTC)
X-FDA: 85320621162.06.C0BC890
Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3081180003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:54:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zbapy0FX;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791968078;
	b=d3XNCUEzmUL7/Vf6AKzAZ7miH8jGAmwh5zpY2WVA4MhCcUYxoeFFBVjcVqpfhTT0nLeLpA
	bIlC8clHDZFwf7tPCRLEns68GrbCUXD67x9Xjdo8dQAap4tDGMDjlRm9qR7+EkttpHP6xe
	RSc0JKWCRVcp4kSCdf7ig/OuGtJKkAU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zbapy0FX;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791968078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e6tlT+CdkybsEahHSkyHFizOmV7XFLVnNHALBZftthc=;
	b=qZeeDNvB4tNYtvqNihi4Zb9xWw+28uqS4dYSoNyJDDj9Qql5/e9zBn9yjI3j9sJOozAk2G
	Vzs1+KhgGImRHDpXgG8zJTbQfpKDAM4p/1smizfKPMPWDpMKeE0dAcNpwo9gxNI0EkxNnP
	bRHdh05LtcawYdbeVxK1vSKevsqn1dI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=loRjuuwluUPBJRl/tOlkBshetBDq31ySMcEEeTZP1FA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791968073; v=1; x=1792572873;
 b=Zbapy0FXo63YHbXZxPXfgu7DtrC4zljrj2a+j7cGiY0Q9FVDLJSaYfl3u8yNCTTl7GOMNAXv
 ud1BWk5ThN8GagiEjr1mv13BtobKPeHirxi5T2ZE/diuHcJ+v47r62hdh8mojno5iBJNZwFVghf
 SR1MDmB/GzGtntz52BYR9juc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7b09edecf1889c5b;
	Wed, 14 Oct 2026 08:54:33 +0000
X-Mizu-Trace-ID: 7b09edecf1889c5b
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 14 Oct 2026 16:54:12 +0800
Subject: [PATCH] proc: Move OOM-related procfs code to fs/proc/oom.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-oom_procfs-v1-1-f2d75e73571e@linux.dev>
X-B4-Tracking: v=1; b=H4sIADNDz2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0MT3fz83PiCovzktGLdNHOTREsjozRz4zRDJaCGgqLUtMwKsGHRsRB
 +cWlSVmpyCcgEpdpaAJ+s1EtuAAAA
X-Change-ID: 20261014-oom_procfs-f74a922f73f1
To: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Stat-Signature: jatzji79wsxwatb49ujfyz74weexjzhb
X-Rspamd-Queue-Id: D3081180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791968077-271992
X-HE-Meta: U2FsdGVkX1+NHC/WQ6bdhbj0iS6+4IbHfB8JA/5ZP//1Lx6bvJZS3rTQBcrdnYrwEpxH+eVbIKYrPnHJiBdLlquyD1pJPamPDFLgFoDRX8mqym8Txc78S+TRRitjGUj86kLsMToTXvMNXJT4AAvqj3LvMH+qkcII8ADtlhNZJLRNSrpZiGGowZ0d9HO+kJG+dfB4Bax34K72XzfNxJDS3ioHPINEelXM8fV11WLNAx0WVaKd3eWS/SFSSnBinMUHCbXJXiSsth9oOEO8tlsMwarnShoD7Dueq4tEwWCtBgqkLmPUmZcQSYDZJdJV6JL0RPEO21LydTOjHOLhEd6Z9BtK1pbC9tdx+AkWX/WC8BOtb1HHt8mwkC1P5iDRQRuNvDJHJP0kXXPjgFMmDT5mLu75bDvdvGZYRBfuACongYwf13B+VfXhf/rKc+SM+8jSpBGkVW4KX21IxeYN9h5qDEg97C6ay1XzmhZGN/InY3PHGeqyAMi5c2K+hzbAfyTdUtRNtdo24Fl9yuYrOi10/HLcaEq50vydZrBPN5rLrwENJjFpqyefxm/RKb6Lz2GQ0dyyoXg5BgROgcTXO3Mp2dGl00ILavFecPM9/o5/I5U3alcfQPsuyxleqYuL8h9b0hLe/c3TrnFV4v+I3t9+okcdt8gPd8sVfnRZbGy6kyd6DYjsXaDybxRNvrE4hblOV6HbTEj2xnHzjbyEgCLjuXs5cCU7FnZ3ew1UskYP9lKYtMkZ+cG4JEfyltYTg8g2Y2eiElCtk6O6ebSrKwi/ZSxnv4kY1IzkWAW6Loo9w07ycsEzSpBvr7W3EUTDahvoJkJ5D7KcNnJalqVVj7C6U+BPzhIFXrJOmLz3d4YNrD2jXvG9U7wM2urb8ogxOi+G88edhoAeoU5ddvpZwP53hucgffk6ov8/0e/2CNLM0ddBNiUBFLlNskjVYxM2fdko7+Q1A0PcpWU5f46SYuA
 1bxKmIPR
 pO8xgNUOOhXFkpxqNfrpLQRfYdZeuDBuLMA7bhUD35yQZgQcDb0AAFT2pz7q1mVeA7wjjYwixYCkrhDNxL/3UttqDfpvP4GT1yajy+UKvPxPZfXLxiTvpJh0E+Ztf3Psr4cubduqA5pdWDvekhBO3Y3bjLgZnuB2LU6Vh8KZPle1GuL9ZmAOivQJ92tFsfCfyM4ppWqtgg+NdgHJYu0nNGt8A7qgkXuvUHpo8PH8tL6238US6FVYT2Jmo3x+75irHj2MdPegyRPotka67s7LDegNqXCyli2zIo74Fg98udn0u88jHQlfgmwHDeXQHP+6KDjzF/4YRwCM4alUkr1DiRKR0hA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

fs/proc/base.c is a large file (~3700 lines) handling all per-process
procfs entries. The OOM score, oom_adj, and oom_score_adj interface
code is self-contained and has no dependencies on other parts of
base.c, so move it into a dedicated fs/proc/oom.c following the same
pattern as fs/proc/fd.c and fs/proc/task_mmu.c.

This makes both files easier to read and keeps OOM-related procfs
entries together in one place.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 MAINTAINERS        |   1 +
 fs/proc/Makefile   |   1 +
 fs/proc/base.c     | 232 -------------------------------------------------
 fs/proc/internal.h |   8 ++
 fs/proc/oom.c      | 249 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 259 insertions(+), 232 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1da3623e77ce..4b1c13a65136 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17676,6 +17676,7 @@ R:	David Rientjes <rientjes@google.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	fs/proc/oom.c
 F:	include/linux/oom.h
 F:	include/trace/events/oom.h
 F:	include/uapi/linux/oom.h
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 27e2b26b2d42..68e65866b5df 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -21,6 +21,7 @@ proc-y += interrupts.o
 endif
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
+proc-y	+= oom.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= util.o
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8c04fcd436d2..26ccc05a50ff 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -80,7 +80,6 @@
 #include <linux/audit.h>
 #include <linux/poll.h>
 #include <linux/nsproxy.h>
-#include <linux/oom.h>
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
@@ -99,7 +98,6 @@
 #include <linux/cn_proc.h>
 #include <linux/ksm.h>
 #include <uapi/linux/lsm.h>
-#include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
 
@@ -580,28 +578,6 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
-static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
-			  struct pid *pid, struct task_struct *task)
-{
-	unsigned long totalpages = totalram_pages() + total_swap_pages;
-	unsigned long points = 0;
-	long badness;
-
-	badness = oom_badness(task, totalpages);
-	/*
-	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
-	 * badness value into [0, 2000] range which we have been
-	 * exporting for a long time so userspace might depend on it.
-	 */
-	if (badness != LONG_MIN)
-		points = (OOM_SCORE_ADJ_MAX +
-			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
-
-	seq_printf(m, "%lu\n", points);
-
-	return 0;
-}
-
 struct limit_names {
 	const char *name;
 	const char *unit;
@@ -1115,214 +1091,6 @@ static const struct file_operations proc_auxv_operations = {
 	.release	= mem_release,
 };
 
-static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
-			    loff_t *ppos)
-{
-	struct task_struct *task = get_proc_task(file_inode(file));
-	char buffer[PROC_NUMBUF];
-	int oom_adj = OOM_ADJUST_MIN;
-	size_t len;
-
-	if (!task)
-		return -ESRCH;
-	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
-		oom_adj = OOM_ADJUST_MAX;
-	else
-		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
-			  OOM_SCORE_ADJ_MAX;
-	put_task_struct(task);
-	if (oom_adj > OOM_ADJUST_MAX)
-		oom_adj = OOM_ADJUST_MAX;
-	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
-	return simple_read_from_buffer(buf, count, ppos, buffer, len);
-}
-
-static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
-{
-	struct mm_struct *mm = NULL;
-	struct task_struct *task;
-	int err = 0;
-
-	task = get_proc_task(file_inode(file));
-	if (!task)
-		return -ESRCH;
-
-	mutex_lock(&oom_adj_mutex);
-	if (legacy) {
-		if (oom_adj < task->signal->oom_score_adj &&
-				!capable(CAP_SYS_RESOURCE)) {
-			err = -EACCES;
-			goto err_unlock;
-		}
-		/*
-		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
-		 * /proc/pid/oom_score_adj instead.
-		 */
-		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
-			  current->comm, task_pid_nr(current), task_pid_nr(task),
-			  task_pid_nr(task));
-	} else {
-		if ((short)oom_adj < task->signal->oom_score_adj_min &&
-				!capable(CAP_SYS_RESOURCE)) {
-			err = -EACCES;
-			goto err_unlock;
-		}
-	}
-
-	/*
-	 * Make sure we will check other processes sharing the mm if this is
-	 * not vfrok which wants its own oom_score_adj.
-	 * pin the mm so it doesn't go away and get reused after task_unlock
-	 */
-	if (!task->vfork_done) {
-		struct task_struct *p = find_lock_task_mm(task);
-
-		if (p) {
-			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
-				mm = p->mm;
-				mmgrab(mm);
-			}
-			task_unlock(p);
-		}
-	}
-
-	task->signal->oom_score_adj = oom_adj;
-	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
-		task->signal->oom_score_adj_min = (short)oom_adj;
-	trace_oom_score_adj_update(task);
-
-	if (mm) {
-		struct task_struct *p;
-
-		rcu_read_lock();
-		for_each_process(p) {
-			if (same_thread_group(task, p))
-				continue;
-
-			/* do not touch kernel threads or the global init */
-			if (p->flags & PF_KTHREAD || is_global_init(p))
-				continue;
-
-			task_lock(p);
-			if (!p->vfork_done && process_shares_mm(p, mm)) {
-				p->signal->oom_score_adj = oom_adj;
-				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
-					p->signal->oom_score_adj_min = (short)oom_adj;
-			}
-			task_unlock(p);
-		}
-		rcu_read_unlock();
-		mmdrop(mm);
-	}
-err_unlock:
-	mutex_unlock(&oom_adj_mutex);
-	put_task_struct(task);
-	return err;
-}
-
-/*
- * /proc/pid/oom_adj exists solely for backwards compatibility with previous
- * kernels.  The effective policy is defined by oom_score_adj, which has a
- * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
- * Values written to oom_adj are simply mapped linearly to oom_score_adj.
- * Processes that become oom disabled via oom_adj will still be oom disabled
- * with this implementation.
- *
- * oom_adj cannot be removed since existing userspace binaries use it.
- */
-static ssize_t oom_adj_write(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
-{
-	char buffer[PROC_NUMBUF] = {};
-	int oom_adj;
-	int err;
-
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count)) {
-		err = -EFAULT;
-		goto out;
-	}
-
-	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
-	if (err)
-		goto out;
-	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
-	     oom_adj != OOM_DISABLE) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	/*
-	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
-	 * value is always attainable.
-	 */
-	if (oom_adj == OOM_ADJUST_MAX)
-		oom_adj = OOM_SCORE_ADJ_MAX;
-	else
-		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
-
-	err = __set_oom_adj(file, oom_adj, true);
-out:
-	return err < 0 ? err : count;
-}
-
-static const struct file_operations proc_oom_adj_operations = {
-	.read		= oom_adj_read,
-	.write		= oom_adj_write,
-	.llseek		= generic_file_llseek,
-};
-
-static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
-					size_t count, loff_t *ppos)
-{
-	struct task_struct *task = get_proc_task(file_inode(file));
-	char buffer[PROC_NUMBUF];
-	short oom_score_adj = OOM_SCORE_ADJ_MIN;
-	size_t len;
-
-	if (!task)
-		return -ESRCH;
-	oom_score_adj = task->signal->oom_score_adj;
-	put_task_struct(task);
-	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
-	return simple_read_from_buffer(buf, count, ppos, buffer, len);
-}
-
-static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
-					size_t count, loff_t *ppos)
-{
-	char buffer[PROC_NUMBUF] = {};
-	int oom_score_adj;
-	int err;
-
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count)) {
-		err = -EFAULT;
-		goto out;
-	}
-
-	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
-	if (err)
-		goto out;
-	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
-			oom_score_adj > OOM_SCORE_ADJ_MAX) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	err = __set_oom_adj(file, oom_score_adj, false);
-out:
-	return err < 0 ? err : count;
-}
-
-static const struct file_operations proc_oom_score_adj_operations = {
-	.read		= oom_score_adj_read,
-	.write		= oom_score_adj_write,
-	.llseek		= default_llseek,
-};
-
 #ifdef CONFIG_AUDIT
 #define TMPBUFLEN 11
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index df873df9afc5..b72a2bd604ed 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -238,6 +238,14 @@ static inline int folio_average_page_mapcount(struct folio *folio)
 	/* ... but return at least 1. */
 	return max_t(int, avg + entire_mapcount, 1);
 }
+/*
+ * oom.c
+ */
+int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
+		   struct pid *pid, struct task_struct *task);
+extern const struct file_operations proc_oom_adj_operations;
+extern const struct file_operations proc_oom_score_adj_operations;
+
 /*
  * array.c
  */
diff --git a/fs/proc/oom.c b/fs/proc/oom.c
new file mode 100644
index 000000000000..5f22ec4a4a6e
--- /dev/null
+++ b/fs/proc/oom.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * OOM-related procfs entries
+ *
+ * This file handles the OOM score, oom_adj, and oom_score_adj interfaces
+ * in /proc/<pid>/.
+ */
+
+#include <linux/proc_fs.h>
+#include <linux/oom.h>
+#include <linux/seq_file.h>
+#include <linux/capability.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/sched/signal.h>
+#include <linux/pid_namespace.h>
+#include <trace/events/oom.h>
+
+#include "internal.h"
+
+int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
+		   struct pid *pid, struct task_struct *task)
+{
+	unsigned long totalpages = totalram_pages() + total_swap_pages;
+	unsigned long points = 0;
+	long badness;
+
+	badness = oom_badness(task, totalpages);
+	/*
+	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
+	 * badness value into [0, 2000] range which we have been
+	 * exporting for a long time so userspace might depend on it.
+	 */
+	if (badness != LONG_MIN)
+		points = (OOM_SCORE_ADJ_MAX +
+			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
+
+	seq_printf(m, "%lu\n", points);
+
+	return 0;
+}
+
+static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file_inode(file));
+	char buffer[PROC_NUMBUF];
+	int oom_adj = OOM_ADJUST_MIN;
+	size_t len;
+
+	if (!task)
+		return -ESRCH;
+	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
+		oom_adj = OOM_ADJUST_MAX;
+	else
+		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
+			  OOM_SCORE_ADJ_MAX;
+	put_task_struct(task);
+	if (oom_adj > OOM_ADJUST_MAX)
+		oom_adj = OOM_ADJUST_MAX;
+	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
+{
+	struct mm_struct *mm = NULL;
+	struct task_struct *task;
+	int err = 0;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	mutex_lock(&oom_adj_mutex);
+	if (legacy) {
+		if (oom_adj < task->signal->oom_score_adj &&
+				!capable(CAP_SYS_RESOURCE)) {
+			err = -EACCES;
+			goto err_unlock;
+		}
+		/*
+		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
+		 * /proc/pid/oom_score_adj instead.
+		 */
+		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
+			  current->comm, task_pid_nr(current), task_pid_nr(task),
+			  task_pid_nr(task));
+	} else {
+		if ((short)oom_adj < task->signal->oom_score_adj_min &&
+				!capable(CAP_SYS_RESOURCE)) {
+			err = -EACCES;
+			goto err_unlock;
+		}
+	}
+
+	/*
+	 * Make sure we will check other processes sharing the mm if this is
+	 * not vfrok which wants its own oom_score_adj.
+	 * pin the mm so it doesn't go away and get reused after task_unlock
+	 */
+	if (!task->vfork_done) {
+		struct task_struct *p = find_lock_task_mm(task);
+
+		if (p) {
+			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
+				mm = p->mm;
+				mmgrab(mm);
+			}
+			task_unlock(p);
+		}
+	}
+
+	task->signal->oom_score_adj = oom_adj;
+	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
+		task->signal->oom_score_adj_min = (short)oom_adj;
+	trace_oom_score_adj_update(task);
+
+	if (mm) {
+		struct task_struct *p;
+
+		rcu_read_lock();
+		for_each_process(p) {
+			if (same_thread_group(task, p))
+				continue;
+
+			/* do not touch kernel threads or the global init */
+			if (p->flags & PF_KTHREAD || is_global_init(p))
+				continue;
+
+			task_lock(p);
+			if (!p->vfork_done && process_shares_mm(p, mm)) {
+				p->signal->oom_score_adj = oom_adj;
+				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
+					p->signal->oom_score_adj_min = (short)oom_adj;
+			}
+			task_unlock(p);
+		}
+		rcu_read_unlock();
+		mmdrop(mm);
+	}
+err_unlock:
+	mutex_unlock(&oom_adj_mutex);
+	put_task_struct(task);
+	return err;
+}
+
+/*
+ * /proc/pid/oom_adj exists solely for backwards compatibility with previous
+ * kernels.  The effective policy is defined by oom_score_adj, which has a
+ * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
+ * Values written to oom_adj are simply mapped linearly to oom_score_adj.
+ * Processes that become oom disabled via oom_adj will still be oom disabled
+ * with this implementation.
+ *
+ * oom_adj cannot be removed since existing userspace binaries use it.
+ */
+static ssize_t oom_adj_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	char buffer[PROC_NUMBUF] = {};
+	int oom_adj;
+	int err;
+
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
+	if (err)
+		goto out;
+	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
+	     oom_adj != OOM_DISABLE) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
+	 * value is always attainable.
+	 */
+	if (oom_adj == OOM_ADJUST_MAX)
+		oom_adj = OOM_SCORE_ADJ_MAX;
+	else
+		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
+
+	err = __set_oom_adj(file, oom_adj, true);
+out:
+	return err < 0 ? err : count;
+}
+
+const struct file_operations proc_oom_adj_operations = {
+	.read		= oom_adj_read,
+	.write		= oom_adj_write,
+	.llseek		= generic_file_llseek,
+};
+
+static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file_inode(file));
+	char buffer[PROC_NUMBUF];
+	short oom_score_adj = OOM_SCORE_ADJ_MIN;
+	size_t len;
+
+	if (!task)
+		return -ESRCH;
+	oom_score_adj = task->signal->oom_score_adj;
+	put_task_struct(task);
+	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	char buffer[PROC_NUMBUF] = {};
+	int oom_score_adj;
+	int err;
+
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
+	if (err)
+		goto out;
+	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
+			oom_score_adj > OOM_SCORE_ADJ_MAX) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = __set_oom_adj(file, oom_score_adj, false);
+out:
+	return err < 0 ? err : count;
+}
+
+const struct file_operations proc_oom_score_adj_operations = {
+	.read		= oom_score_adj_read,
+	.write		= oom_score_adj_write,
+	.llseek		= default_llseek,
+};

---
base-commit: 1fffefb00cc0b0da1f2ae24e3d33364530ea6515
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
change-id: 20261014-oom_procfs-f74a922f73f1

Best regards,
--  
Ye Liu <ye.liu@linux.dev>



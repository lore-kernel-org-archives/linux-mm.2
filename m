Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A63CBC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5C36B0088; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD496B008C; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9F36B0092; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 477E46B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3FEE11C21B2
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:43 +0000 (UTC)
X-FDA: 85203365646.03.7B1494C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46F95C0005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MFxAtyQK;
	spf=pass (imf10.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GE5dqFCRfhDnsmo5yolvaw9ftDQ/csziSMnxWGU7Wkk=;
	b=5NavgM1qakUk+47uQBAdBRAyKwW5F6yvHUh3ku3bNkQXkRn8k3Ljpaw0IbslcolZWskCAT
	CuF9aACFni0qSswPiLmGtcCDenFcrDCByj5OZPTbZRuKh3cFgNg8WpEhkReZ/87lDRZ+gm
	zOvA/evOon0+AUnHe91dYS0mDHRzH7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176281;
	b=Q6DUkEXLYMK9YSxMBhxR5g97jmlLHkui2fTPF38YTBKXNtUvgL7dso7trVPiAxRtdyb/xY
	GZywS0rYFswT91Ic7j++dkwYD6TW6t5HK9VU/ShEnBoeGcYBMb9w48OwAhcxM/ir3q7UGc
	76zEnuZY8rv/4MfXBL5NpcydjqxqiDs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MFxAtyQK;
	spf=pass (imf10.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=GE5dqFCRfhDnsmo5yolvaw9ftDQ/csziSMnxWGU7Wkk=; b=MFxAtyQK+HYzxeUn+EYc1igESr
	5KdtxtpNN2o0qNoUBnSkHv0ipyFc7G1wZr0o6XoIrqBOqyCa8ukWL1KMcroSLvGe+zBxOBialLLq0
	+5oFYAN97G357Gqd8kAfd6uTbAErlZqsHEiakrU8mGBNwJf6hXddjElYECoNVrceiJ6UlFNIBV3KH
	DF3q0A2TMmdwSms0lJDuq86HNzddZRDILak3iKVEjH2gM0HEN3xtjd/FFC7oAm6pv8JiGr+1v76om
	5hvZKY+sY+BOsYLuGjc77D9IGnXLiPCxOiCgveoSqSLHJGXtvSesTvfLlxJbuTeV18ZnrLJk/bmkS
	cNCQeuhA==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CTj-000xjI-RM; Sat, 12 Sep 2026 03:24:27 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:23:59 -0300
Subject: [PATCH v7 2/6] treewide: Replace memcpy(..., current->comm) with
 copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-2-34e1ee1564ae@igalia.com>
References: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
In-Reply-To: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46F95C0005
X-Stat-Signature: m67ah36et9qqkigzb9iwb65ssf6wfg55
X-Rspam-User: 
X-HE-Tag: 1789176281-490509
X-HE-Meta: U2FsdGVkX1/cy4eSeBzPdkNp7LQKYvTyact99lxXe6S5K2riIUoqvVRhFeHyVeMyicdzGBd91UN/fDoLpqt8tDKSg3jKEw2hn7d8zl4b9QgeXakqQM3s/4ifbgplqoLwmPxFINIYMKHaoMuoQZurgv66qUxCRr6vis54o8/stSSzdJVpDeggc1YtdfgAUUc6zLZQOWyBsnJjztlxuIJy4edhYVSjmcX4mlmh6cvzA3zYYsfaJpglSqwD40qm/gD6RcC6JH1CwrIbPRFYLUFSmZVxS45tZ9n/6Y5aSrzv2c5UEeixqY7JJdJB20WwZJA81zCHDpPfeNYH4qoklEDs5EkktS9QzFiS+l7y114U9ZExbomGFKoSrku0T8TInzvdX33twMd3ugjdMYFdP3u/m+2i+1YFkpecRLPpwbyEDe1JLZ8G29EU3qSCi4zvQ+zROPydBY0t6u+xltMrF3B3O77izyW7ngvC+WW26SxFxsn59zlO3wOhr+9j+eyHx2GDDEFwXIoDebqD53jG/5vrwEWqe1wZVwdA95El0e4jjoH2ZsnxfKH9+ZtDofRubwoMw8Wul1+0h+jBFWO9LB1EJnMznsj9RO9IGSDdJsT/IvsBulF8SAGJpkuo4PdT7j6lyOAVo/TP5hgknPTIXJItE2tUCrpkD6O7mmLp2/F0NdkJ0RA0s5kYcQCt04XEUN2UJpUxqS1sYAAT0LHdyapAohywiF3RW270yehqNJ4B+H6LCHHi2S5/pX1nl4Z0b1eC1kpCG6beeUfQIIXIaaNFxXk5D+m+u5nU7hrQEHHrC4QZrxHrU+2ir19O8V6w3ROYolbY6uvR7bLgWbqA8TLNbhrHvILKBfRWU/POdnbGUvmULm4kDNUpIic/4Yl7mvy5d11F8aafHqVUNf4M81BTYX56Gd/pxaUpnTHlWX0ksbA0je/w4iE2EXoksLLvkvuQZ3iIe0HIfImzG7R7Q3U
 cFxV2a9H
 ky60YxeiME+iOkxRT3WzsffJpbMrZizOPXGJcknjWO/C22r7SnlEjG0KggyA753w0YLtqSDiJwCi98gC5nkYvAgzuh/jf2N9p+rwjXnQPkQGL7DmZgvUpEj+1mamGxI6RGbtKHfoJ8EcYZsG88LZi01LbDfJRHWrmmfkwRMJxDdllzxUeAjV9O/eZHsucoA61bEZORVEYdJXEyblJMD5vzJd4AX6ag9Zc5LbjyMXW06GyQRrUBZjx55uy8bjaw2pHzoZKQ+3fe6DvXpQla5nT2M2bTa2ZH6PEeYs0lEx2FswkTEH6vKDu0+YHaHJGGG/ON8f4OJl3Wvym3D83ELmrrJzBDOx0V+M7lN45VefRGfmzdj2o8BxpiHiCHmOCfUdo9Q2Bo7BVnbf854wE6SZhmp5lom8bWDD36l3wrL9C6WpOmf1N1LCsXyll/IjBLxy1qwPLgdGs37koY7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to increase the size of current->comm[] and to avoid breaking any
existing code, replace memcpy() with copy_task_comm(). This new function
makes sure that the copy is NUL terminated. This is crucial given that the
source buffer might be larger than the destination buffer and could
truncate the NUL character out of it.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes from v4:
 - Remove copy_task_comm() calls for structs other than struct task_struct
 - Add checks for len > TASK_COMM_LEN and len < 0

Changes from v3:
 - Simplify copy_task_comm() to a memcpy + NUL char at the end of buffer

Changes from v2:
 - Bring back custom function.

Changes from v1:
 - New patch, dropped strtostr() from last version
---
 include/linux/coredump.h                                  |  2 +-
 include/linux/sched.h                                     | 15 +++++++++++++++
 include/linux/tracepoint.h                                |  4 ++--
 include/trace/events/block.h                              | 10 +++++-----
 include/trace/events/coredump.h                           |  2 +-
 include/trace/events/f2fs.h                               |  4 ++--
 include/trace/events/oom.h                                |  2 +-
 include/trace/events/osnoise.h                            |  2 +-
 include/trace/events/sched.h                              | 10 +++++-----
 include/trace/events/signal.h                             |  2 +-
 include/trace/events/task.h                               |  4 ++--
 .../testing/selftests/bpf/test_kmods/bpf_testmod-events.h |  2 +-
 12 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 7b38ee2e7913..dee82e3c350a 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -58,7 +58,7 @@ extern void vfs_coredump(const kernel_siginfo_t *siginfo);
 	do {	\
 		char comm[TASK_COMM_LEN];	\
 		/* This will always be NUL terminated. */ \
-		memcpy(comm, current->comm, sizeof(comm)); \
+		copy_task_comm(comm, current, sizeof(comm)); \
 		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
 			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
 	} while (0)	\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d7d3bbb205c9..ba2040566424 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2036,6 +2036,21 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 	__set_task_comm(tsk, from, false);		\
 })
 
+/*
+ * Copy task name to a buffer. Final result is always a NUL-terminated string.
+ */
+static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
+{
+	const char *_src = tsk->comm;
+	size_t _len = min(len, TASK_COMM_LEN);
+
+	if (!_len)
+		return;
+
+	memcpy(dst, _src, _len);
+	dst[_len - 1] = '\0';
+}
+
 static __always_inline void scheduler_ipi(void)
 {
 	/*
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index e0d838c9ce93..9b0094fa44c6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -637,10 +637,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  *	*
  *
  *	TP_fast_assign(
- *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+ *		copy_task_comm(__entry->next_comm, next, TASK_COMM_LEN);
  *		__entry->prev_pid	= prev->pid;
  *		__entry->prev_prio	= prev->prio;
- *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+ *		copy_task_comm(__entry->prev_comm, prev, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
  *	),
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 9c97a16850b9..1e3a9ded03bd 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -213,7 +213,7 @@ DECLARE_EVENT_CLASS(block_rq,
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
 	),
 
 	TP_printk("%d,%d %s %u (%s) %llu + %u %s,%u,%u [%s]",
@@ -410,7 +410,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
@@ -493,7 +493,7 @@ TRACE_EVENT(block_plug,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
 	),
 
 	TP_printk("[%s]", __entry->comm)
@@ -512,7 +512,7 @@ DECLARE_EVENT_CLASS(block_unplug,
 
 	TP_fast_assign(
 		__entry->nr_rq = depth;
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
 	),
 
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
@@ -563,7 +563,7 @@ TRACE_EVENT(block_split,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->new_sector	= new_sector;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
 	),
 
 	TP_printk("%d,%d %s %llu / %llu [%s]",
diff --git a/include/trace/events/coredump.h b/include/trace/events/coredump.h
index c7b9c53fc498..fdd20bc46bb0 100644
--- a/include/trace/events/coredump.h
+++ b/include/trace/events/coredump.h
@@ -32,7 +32,7 @@ TRACE_EVENT(coredump,
 
 	TP_fast_assign(
 		__entry->sig = sig;
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
 	),
 
 	TP_printk("sig=%d comm=%s",
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index d53be932df01..faabc15b4a11 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -2518,7 +2518,7 @@ TRACE_EVENT(f2fs_lock_elapsed_time,
 
 	TP_fast_assign(
 		__entry->dev		= sbi->sb->s_dev;
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->ioprio_class	= IOPRIO_PRIO_CLASS(ioprio);
@@ -2571,7 +2571,7 @@ DECLARE_EVENT_CLASS(f2fs_priority_update,
 
 	TP_fast_assign(
 		__entry->dev		= sbi->sb->s_dev;
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->lock_name	= lock_name;
 		__entry->is_write	= is_write;
diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c4..8bcdc4ffc8d3 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -23,7 +23,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnoise.h
index 3f4273623801..2cf047bb9fb7 100644
--- a/include/trace/events/osnoise.h
+++ b/include/trace/events/osnoise.h
@@ -116,7 +116,7 @@ TRACE_EVENT(thread_noise,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, t, TASK_COMM_LEN);
 		__entry->pid = t->pid;
 		__entry->start = start;
 		__entry->duration = duration;
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 535860581f15..afb24e9dac91 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
 		__entry->target_cpu	= task_cpu(p);
@@ -237,11 +237,11 @@ TRACE_EVENT(sched_switch,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->prev_comm, prev, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
 		__entry->prev_state	= __trace_sched_switch_state(preempt, prev_state, prev);
-		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->next_comm, next, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
 		/* XXX SCHED_DEADLINE */
@@ -346,7 +346,7 @@ TRACE_EVENT(sched_process_exit,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
 		__entry->group_dead	= group_dead;
@@ -787,7 +787,7 @@ TRACE_EVENT(sched_skip_cpuset_numa,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, tsk, TASK_COMM_LEN);
 		__entry->pid		 = task_pid_nr(tsk);
 		__entry->tgid		 = task_tgid_nr(tsk);
 		__entry->ngid		 = task_numa_group_id(tsk);
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 1db7e4b07c01..8fffe6d9bdcc 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -67,7 +67,7 @@ TRACE_EVENT(signal_generate,
 	TP_fast_assign(
 		__entry->sig	= sig;
 		TP_STORE_SIGINFO(__entry, info);
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
 		__entry->pid	= task->pid;
 		__entry->group	= group;
 		__entry->result	= result;
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index b9a129eb54d9..e3faaeb997ef 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -21,7 +21,7 @@ TRACE_EVENT(task_newtask,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
 		__entry->clone_flags = clone_flags;
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
@@ -46,7 +46,7 @@ TRACE_EVENT(task_rename,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
+		copy_task_comm(entry->oldcomm, task, TASK_COMM_LEN);
 		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
index 45a5e41f3a92..a197622e113c 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
@@ -20,7 +20,7 @@ TRACE_EVENT(bpf_testmod_test_read,
 	),
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
 		__entry->off = ctx->off;
 		__entry->len = ctx->len;
 	),

-- 
2.55.0



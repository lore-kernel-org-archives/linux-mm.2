Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCE4C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CCB86B008C; Thu, 27 Aug 2026 14:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2570D6B0092; Thu, 27 Aug 2026 14:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6B56B0095; Thu, 27 Aug 2026 14:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2F96B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:23:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C934140152
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:37 +0000 (UTC)
X-FDA: 85147872474.11.8F08947
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 42D891C0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XUaQWY3i;
	spf=pass (imf18.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787855015;
	b=QlCDRVvTKxy9u3LXjN/YYq8VPC8r8ZeMOdPQsGiEgIb3FNTLeFEIBf1k1htHCokTpHIiX9
	BDHoXip/GmlbTBeOJBz1+AVLhn0wouaiYVKFs+ne0etSvtBywji1P6AqNTuYK6+Ln/O+rz
	gtNMjKuY4gSOSFeZhJnJD55oKjj30Ww=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XUaQWY3i;
	spf=pass (imf18.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787855015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3aZuaPxyQ3qJ7cxmWu2u1Tvfp/nl8wps1rzhSRIVQk=;
	b=AKnSvvrMSOmzLX8Briu4N4Y4cxuF7QGVnvoljNlPLrNHx4ZYzjkT8uEM818qo7tXPmFQui
	zLnQVw9SgQYqeGAz/lVXYmfBdza32wmENPmBLBoVs84lvsGngjN3pklQi1PfCb3JkV2b91
	A14RD8yKIljCkHZ6VBUjfkDHFtCdavc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=W3aZuaPxyQ3qJ7cxmWu2u1Tvfp/nl8wps1rzhSRIVQk=; b=XUaQWY3iD192sB911EbwQN5LPn
	RmKd74MYbPK7H6mc40SrfG/iU4RXnWOPEB60JdJ7gZlaj7ZlI/RCaMrrbfwzHRxy+5NBcOLJmOv31
	HBmaM4IPlFTKGTvU5h2jD36NqoXNDAy+9dxCIIzo1jGmh7cMjuw0eN+1bYb6npDGgNYhvkSe+ZRTJ
	7wPzHWIru7wT7HiqAQuUbDtSRgJxFpXiIJ8ZLRkPVR8N6nZ6n4LNqiuhQUzJgrzeYIFlPPntALKpQ
	5WunxUGgs8cCR4d/CTL/sXtNDN4vOKjjO65jl5+hgVpbR75+qFsYfE5aYNAdwLrYCxCLzY83BbaRX
	wyKHswRA==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzel7-00AOUg-AK; Thu, 27 Aug 2026 20:23:29 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 27 Aug 2026 15:23:01 -0300
Subject: [PATCH v5 2/6] treewide: Replace memcpy(..., current->comm) with
 copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-tonyk-long_name-v5-2-5fa843782a00@igalia.com>
References: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
In-Reply-To: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42D891C0003
X-Stat-Signature: apqfejyw4oborh4cia5i63ngb74zniuj
X-HE-Tag: 1787855015-698197
X-HE-Meta: U2FsdGVkX1+Tx/UFuaoWVruaRQOMuSoimVP5cwEbpIMqTmngOIZ42T/9TZXpC8eGA6KbPyBibeW8IHTgVrgoSBVhN2ACMoywYFXLTwDe8YTBrbp1zjeViT0cAEvYxo0UKW+UwmwPoFdrNZ4lBRA5JaHOL5gfWZQQqvv5gZWdqAM23DF80Mk2ylebIU+kqcgybmyICw5gz5yH5N/mUPkwIKOYGJwL6GUtMm6VwdTdemmtHyn18fOBluyVJsPkRrLzzPBar9lwIvwq5QpKn5vaCBOiXxm3Jr4Dcbhn0l6gW+aQjZ4Jjy6qMjH/qxPpFfSW7JIc0UaMk0TC9c080iZhXL/KE7Id/vzJm2hTKlDHJhkAujIvGQVcn7f8QezRRhfiXS6NCVPtfu58TwZbzMiVpnvTJ04cdEetkn0ZZ+Z7seBDfuFrVhpnXTvRNvPFmdUvphUvS1PDTCQeo6pZFYcswhKV77bjjrc4Q2QZK69QHCSsx/0AkjTrxByuRj8nedvD/rRMIigwmXW8o9D+GgvrrRnPQfdHhFWo5GSLN2eCqI88ymSnP2Mn27aFxxwyucfR4c4ruVWVv6kTmzo+SKDqn1qes6aM0qUukKqBbywuOMtkk4A5CzABGV8Nj2AaySbpkeGZQG+Zv9yv1Ce+TfcfyHEgvCymMUdJAPQY5i684VYIkQTzpUkB9OXUjYoLgecLgxaytjhnqBSBme8u7QBf//je0pnO2SSsbQvaK85yjdsqIVUugRfejpMj7cu4oZMggbf8Ktk+Mb/3zE/m2zUIdaEa5J96KUJK5+7wu8eaVQEvbBJ37DujpcCad82gXVEZYcuQ8TcUX//y0tFY56//Vj5oBO8M4mO9gicNMbQNFFbrDApT7AayufFXt/kKI+n6+pIWggsVekX1uNSDq3Nbwi+MxvdBlNIb5RRYLxAirWKRD9PIAq5z1J3rl3GyK7oCYzHo1iYQ9jWrQHABG9L
 id0ayIyo
 r7sM8HfE3basgL0hviw1b8vztz6fVooikAg1mdq7a9pdAsEBOrhfKZfpBdgapRA2dr+Q1UD3kP2a5s+vwwbbD3CKZ7K+1GTfoQEvUrxg5uuFBgA6Y8+kmbYClSFnpELzuDEhyCiKc2jIERXLFjWFWQH4KNQbbfAEx74Zy6BGhmAJp1PCiCjO+klA0PaBNPY6ISKYl27oWgwo5UZFTts5dU7ip/LEu4yjkKm2MtfHyABwIwDoIvUBsBZbz0AZyY/SLS1Zs9j1aiTPveRaoAmVNDbPqBKQ42luv8SHGfnJ0WABvL+kqx01LOG6whulJXifezCJdw6udQaW+X9elNYTw1wBpcEkouSftmRamfAFvVhRESL4Oxvp3txTj39FeqshZLMaT1LZa7Jz41rtLc8shxqx+2QcmZ2PM7jSjmxpNIUjxveIAb6lJ4/yZ3nNlxk0X8uWJXz0/mhSITLM=
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
 include/linux/coredump.h        |  2 +-
 include/linux/sched.h           | 15 +++++++++++++++
 include/linux/tracepoint.h      |  4 ++--
 include/trace/events/block.h    | 10 +++++-----
 include/trace/events/coredump.h |  2 +-
 include/trace/events/f2fs.h     |  4 ++--
 include/trace/events/oom.h      |  2 +-
 include/trace/events/osnoise.h  |  2 +-
 include/trace/events/sched.h    | 10 +++++-----
 include/trace/events/signal.h   |  2 +-
 include/trace/events/task.h     |  4 ++--
 11 files changed, 36 insertions(+), 21 deletions(-)

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
index 474ca86ec105..8d2355e41619 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2035,6 +2035,21 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
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
index 270c1a2c24c4..7d22650b4c78 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -2505,7 +2505,7 @@ TRACE_EVENT(f2fs_lock_elapsed_time,
 
 	TP_fast_assign(
 		__entry->dev		= sbi->sb->s_dev;
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->ioprio_class	= IOPRIO_PRIO_CLASS(ioprio);
@@ -2558,7 +2558,7 @@ DECLARE_EVENT_CLASS(f2fs_priority_update,
 
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

-- 
2.55.0



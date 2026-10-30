Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4DE606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=oPuIW3UW
Received: by kanga.kvack.org (Postfix)
	id 025FF6B05BF; Fri, 30 Oct 2026 17:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BA06B05C0; Fri, 30 Oct 2026 17:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19E96B05C1; Fri, 30 Oct 2026 17:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5D26B05BF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:39:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2841D408A5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:11 +0000 (UTC)
X-FDA: 85380608502.22.200EF4F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4A584A0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oPuIW3UW;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEYFc7L+y1cssea63GFqk1TJidenVlAlQUWIPnGKOzM=;
	b=rlB3xhGDTYxYZ8hxeXUC6y/GBH4MfM2ARe2xzgcyOVTPt5fZukZQw5ASsJ+swaArYKwE+k
	B3ybQGY7FDNGsylBy9r1PP9okHx+Xa7mdyYeol0oZXMA98V00UiDmSHUrdCsiIKePGqYKI
	1UOPX1pHTSebtUeM25X59niwyMm37QY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oPuIW3UW;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396349;
	b=J1RjTjDRd90ZVh07FZJj+UZzERR/mn45ucOsY8pUBxg0tWbFFMcc5EVhfBxwTy6zWrq09R
	Pb2BVn++rquitAD7W+VFbdShTcMmEB7sgUZqUKHW+/E8O6uzpTccuqtkoj+fLhAAbx84cs
	iAMJNwa50AiZMEJ4/i2cQh54xjGKw1w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=aEYFc7L+y1cssea63GFqk1TJidenVlAlQUWIPnGKOzM=; b=oPuIW3UWrgUHShMbUmsDqfiSIF
	MVDHTQZaDB0m+XcGoGQq7zgxL6vGJ+ZBzlHI9MCcRz79QfU5Fzhevxoz5XepMoZBTTl+yAxV5/e8U
	n7jfj46MiLtiQUDMRMCpUOcDTx+smx0j4eRP99AjN8uPEcLacv5r9wygcYTanCfOSth9izqofcr4U
	kNSyFcY/PapeJDPXasDMqyCOdm3UQPkVj9x/x8ol5Pu0MPOmiuon/SmY1XAuZYoM77yVDAyYRXDpT
	hDwHIkZoF+dB1I0lgmbYZ4mylsLEQmTunOCmn6tgx/UuJxGUS97Vmzl6SyE+rD1hK6M5Ywqd858vb
	F7UznqzA==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJJ-00FNmU-PQ; Fri, 30 Oct 2026 22:38:54 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:33 -0300
Subject: [PATCH v8 2/6] treewide: Replace memcpy(..., current->comm) with
 copy_task_comm()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
In-Reply-To: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
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
X-Rspamd-Queue-Id: 4A584A0006
X-Stat-Signature: qtoaqjytmx9emyyts85hpsyabpm7etq1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793396349-667466
X-HE-Meta: U2FsdGVkX19GLTnrP2zWE7QTEEINc06ffJYhLiFD90cgQ9lGz6un9LAn2hEnxPeTzjdLtgfI22FlqWUE3vcVWDdOyxs36hQSWRxEgGFV/pQMM/eoZOSypgXwas4c5avibn8RmXQsBqcXGGUoVlMXfSRck/Hyyz2ZfAWRNel/g6nACFCYZjjufiDH2LwXzhj4L8fOkGVYC4k/BZIeuwhtYPcIShzIiD2ubbdEUWPk7fXqpeWmRsjBAzhf0u6P37AlhQZbSxTw/aZisNOzuRtitvgtFjx9OprpKkNwBgDhrg60X/1wueINP1s0r29Ufn+TY7EkkI4vQuCjNGy+yrLdcW8fpW6GSQBsyjfjmFasEut4R+inMjzGJB5tSz5SQH+ad1ci14KxxuHk88A5T3LidAEpowqH4FQeRwSYxU6Q4gdWSJzy680MV9zJ3f2+4b4XrIOj2wM5b+tTGBgvQyk0EpctSBaa4AdlrDdwBzgxqdxqZFehr8EKHOAYlD/HeB1qD/UMIEma9GqMSO9WWY79RebLFjnoxcdhNb2TG1Yf89ygbV1JAG0lUj6zdkNucl2lGqPoFf1JDo4t5qs2E6DmJ7gQ+F9I4ZFPVJv6bFrRCo6RZSHU5s9zrhFyn4p3uj035tTvizCHIg9FIaeVodBbRxgo6OK9ndqDWcvt/UrfGQnVjWsMKy+0Bw4Qi81OxK/2SX10FbOTp4UJeW25vwWmJf6nj3dBWTEBT6DFBYlzZVa8+nPX1MGeZot7q9TYlRKHE3Z6x0or6kGxfPYnfu1UdC6lqV5T5Lxx7ItlSqZ2dLpJICBfyTgRbPriNYy35dykkNJB1MUETluq/7VQ5r263ac/Kmb858wQZ+iuGXbYjSDBR4UTutwq/a4FFG0vr5VPZERPOpFeqkFhm1cA0q9tvOnUIhU/wZ+H5wHlEK0nYXPv/M68ISrVx08x+SSUtBm8021yADvQJRqZoWB8JZI
 xVTl/Kvg
 hcS8JXwBkuhIDzqXn2RujkwjydhXhD37W0ik0xYJT6n/gQ13zP1tyIl8TTmCz9HczFPTG633qRSWvqsr/XsQVPE9cTcI+f/W/b0J9YbhQHjhOncA3Ru22i2LqSgWMj+qVQgYY09VDVo8qWcq1fXbSMv/ihmz+Ha1tnz6ozX2dba2mA2WM4pl8mcDIHiqj9Y3XiSNDS+zijaIz2/iOTBZCi9eeqzzUpB5brz8y48CsKr63H+MTcomQNLDfqhYYzUxmLd2RuctV188CdTxOLFh2Gocg0I3GZTnZw8gfAWYHL+y39kgj6647ktIj+GvLGyLHKMF32VUk1eWaBxXUiFBXk+QpV82sa3bBGpQIbsxBiuInIyn9MToFl3qGqtV57nLiup2fM9cxyRuo/oSQO24OuLAICSmjdBYN5zunZDAbcocONBdDyxf+GnX+wSU0z/35GYNNyc2S4EuF0tEr3LrSHAcnvKi2cKcOkGe20OFrZDtuHuJI8FSQw/ORaaFTmbxSdr5+QAVgWue1/lA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In order to increase the size of current->comm[] and to avoid breaking any
existing code, replace memcpy() with copy_task_comm(). This new function
makes sure that the copy is NUL terminated. This is crucial given that the
source buffer might be larger than the destination buffer and could
truncate the NUL character out of it.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
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
index 8e857770dd21..c3009edc2595 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -79,7 +79,7 @@ void vfs_coredump(const kernel_siginfo_t *siginfo);
 	do {	\
 		char comm[TASK_COMM_LEN];	\
 		/* This will always be NUL terminated. */ \
-		memcpy(comm, current->comm, sizeof(comm)); \
+		copy_task_comm(comm, current, sizeof(comm)); \
 		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
 			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
 	} while (0)	\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0564aabb1393..db529a93525d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2042,6 +2042,21 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
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
index df4cd346ae72..e3f2047f9de8 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -2589,7 +2589,7 @@ TRACE_EVENT(f2fs_lock_elapsed_time,
 
 	TP_fast_assign(
 		__entry->dev		= sbi->sb->s_dev;
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->ioprio_class	= IOPRIO_PRIO_CLASS(ioprio);
@@ -2642,7 +2642,7 @@ DECLARE_EVENT_CLASS(f2fs_priority_update,
 
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
2.56.0



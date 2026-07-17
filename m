Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4A4C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DB16B00B1; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1BA16B00B3; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19066B00B4; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE466B00B1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1950AA0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:16 +0000 (UTC)
X-FDA: 84998415432.14.D952E1C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 477B140006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Ad9WYEbJ;
	spf=pass (imf12.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296514;
	b=P6A3IFn5nbTIBErZTRAnPWzWBL5HXQwiM9zAJn4LtTMuXfFGWmESywaWP8LCQ3/UtBKQvw
	6b3Vp+r86EvbJuOZAXAzDGFkcWl3SFA9SQct3jyzoY/Pg9bSG/rC0VezxYxJdalQy9a9bX
	2VOklUpIkqBwHk2ztF2Ndo2ufH5eTww=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Ad9WYEbJ;
	spf=pass (imf12.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmJjuYl2j0CbtQpSnLCIuzFXwD7CgwyZsosTltumPjw=;
	b=G+2ZK9pr41fH9qVfqyTjl7UGF3JO9NWYOgB/a/FGuHSA0yMMslC5mMrTnmTsbmXke+iHLx
	CYNeDazwW8nL5I9hP4thNBHzPnC5PdK4gMf5y7Y+PbDhNO8gza/HAuQKgiMNj8UcF8jGiD
	zBPAYKElBQMseRbcvTAtNj7d3q8vnis=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=mmJjuYl2j0CbtQpSnLCIuzFXwD7CgwyZsosTltumPjw=; b=Ad9WYEbJuyTDKIVqp56M2+AS+h
	AG5dvsDJ5vvcyu5w01d6aqHS3ois0lhqDaTgeiVSHSnwFFXwC7jV2mxHAnQ1qRvQmHGRSV0AL2it/
	6R6qoBkzYQncyUlZ9hGqGeJzXE34KeJtKiLaUe93UAVbMC5skN42+jhggNev7XlfiDkApYsQDeaXO
	D9jRzsdJDXJOdHIgFaSKRSzfskvuhySed3G/i8Bz9ifvIbkwjEteewVnVagxwBZ1vB1gVvu6XJf+Q
	KH0gX7IPd4Wh539K+Dlqx3IgUfDnEhUQjSfiL4JH4w0hwDN550K1cr4tiR0qsBh5+DFxbRuKFpdB3
	rztoL1Eg==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj1v-00GXeM-Bh; Fri, 17 Jul 2026 15:55:07 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 17 Jul 2026 10:54:35 -0300
Subject: [PATCH v4 2/6] treewide: Replace memcpy(..., current->comm) with
 copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260717-tonyk-long_name-v4-2-1fedfc870d21@igalia.com>
References: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
In-Reply-To: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
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
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 477B140006
X-Stat-Signature: ytjr5iibfu4ttjnqeh15s6ndf5ru175o
X-HE-Tag: 1784296514-662405
X-HE-Meta: U2FsdGVkX1+W5oauR/XHo5PnUMWd8greyOS9QyDGCpZtv+ivWVu3eJZt/2lMjQRp90lzTKa9Wz4gWR0eNlLjCjHB2cTHPDdu0MibxkfSXcjKFlt72R+Npy4hi3b/IjSLljJefUaHGD6s/45sSCcYQDJJBHe/f5G/7F5J9s7EKlQgvblC+0svuyQbdl4ne3E7vBREwEFNuFcOgMKXA3uugEKNRiG8LHQg1nwsRBrDbNk16vTnioI4I6aQ4cfSrYRUjiaxKr7zEj1LhbAzSuDTz7JENEL/0seenjSb893OkKKlZLy+duPzoa//IAIiXRXtc+TMkwboJYJ08ttND/9HcJeOln1UTEhd1Gfe3A7AsV7GhWHjQTq1vVBmC3LRYLshD+awzvysJAx3Dq5ZDhCkg+wgWmFPsQGjhzc0tN9sBETOqEByhyP6/PRSNSngJOvFw/3frqaAT8SPij2FbrAJsjKphLNa80y0WXgM8Sk/0J3MMLRtlRvhMlG81FEBUBoPiuwqILaUDgQep9ptPOHLt/gcxhZItesGM47vLIf0ug9GEtsNmvTX9VuYAN4SfO/hmtcS9tnilMy28iaEsoyHE7Y4ISTT8GZeXorNq80MASVnbtsrJvIBNEsFqDHcPbLFrHDnu2NNGwXtPR2lbpnpFk4SgY2CnEGYM1KE1eE+3+xNW1AaMuUp/MSFhEz/vawSJEkNdbuLW6KU3JeGcSIOKLm9LG1SzHLtlxFJc1RtiFHh1ixH5L77KEYcXQ6PhHubzic3jsx8erz9feamkQsyGdELhlnrcfuTvA7g/NBFBQXdGgWiSLoetm4c53vBiVAMg4/BkygSxwU9dmvnIt0fbjs96aZuTZGNSgU0ZNjkTi5JwCc4u/wwjU0PTPqgn4P6ms82ks6bo7e8frXeCMpeHrD9SAP7U1VgPRkrnG91TwaiAl7zeWrUIG+8g+5CwDt3/RbrNQEz9R9RgNnARb6
 YPbPloSZ
 94A6sIQivxdlP0uVdMuh9QzkrJOcHxdvRQctKH31y2p1/+eIGBrCExpHpm41vApSud+ysM6bn/pDJ2iAcYk9fCVNqep8ETKTBGvt9zH37FXqmfmCzhfK6eI59gTNmyWzO/VwoHlzprYl0N+q0TkTUEtbrGz/v8oCgNjhx0qpZLaDEhhYo8wZs0K8jYhNTgbuk7JQ3JZWwajrYFZHXqSaQGgSc5mLCggZ9rYhehN69CJKjgZ+UZl5JbV6WW0JH9h1Bwcuqt7FCQQ7nS11sJKPppCoLdB56q8W/DGGj1yHCQhWx55QsSjTosQMiGj1qbHlS0PnEvbt4cWrIb5bDAKc8ja+/yb4ZElU7E9Rh46PaD8pW2Gmw3/6/zsn9w8zLmbyu5eOfLfXo7T+gJJKTU1nabVym0F89EulI4pZIe5lWlq0cg/1GZVXOgjh1KBJMNvJt91K3dQkrAyIbMSs=
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
Changes from v3:
 - Simplify copy_task_comm() to a memcpy + NUL char at the end of buffer

Changes from v2:
 - Bring back custom function.

Changes from v1:
 - New patch, dropped strtostr() from last version
---
 include/linux/coredump.h        |  2 +-
 include/linux/sched.h           | 11 +++++++++++
 include/linux/tracepoint.h      |  4 ++--
 include/trace/events/block.h    | 10 +++++-----
 include/trace/events/coredump.h |  2 +-
 include/trace/events/f2fs.h     |  4 ++--
 include/trace/events/oom.h      |  2 +-
 include/trace/events/osnoise.h  |  2 +-
 include/trace/events/sched.h    | 10 +++++-----
 include/trace/events/signal.h   |  2 +-
 include/trace/events/task.h     |  7 ++++---
 kernel/printk/nbcon.c           |  2 +-
 kernel/printk/printk.c          |  2 +-
 13 files changed, 36 insertions(+), 24 deletions(-)

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
index 2714c81bc708..9b6a413f6618 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2021,6 +2021,17 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 	__set_task_comm(tsk, from, false);		\
 })
 
+/*
+ * Copy task name to a buffer. Final result is always a NUL-terminated string.
+ */
+static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
+{
+	const char *_src = tsk->comm;
+
+	memcpy(dst, _src, len);
+	dst[len - 1] = '\0';
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
index b9a129eb54d9..62b7df4d22d0 100644
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
@@ -46,8 +46,9 @@ TRACE_EVENT(task_rename,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
-		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
+		copy_task_comm(entry->oldcomm, task, TASK_COMM_LEN);
+		memcpy(entry->newcomm, comm, TASK_COMM_LEN);
+		entry->newcomm[TASK_COMM_LEN - 1] = '\0';
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index 4b03b019cd5e..f4c5ae8a3530 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -952,7 +952,7 @@ static void wctxt_load_execution_ctx(struct nbcon_write_context *wctxt,
 {
 	wctxt->cpu = pmsg->cpu;
 	wctxt->pid = pmsg->pid;
-	memcpy(wctxt->comm, pmsg->comm, sizeof(wctxt->comm));
+	copy_task_comm(wctxt->comm, pmsg, sizeof(wctxt->comm));
 	static_assert(sizeof(wctxt->comm) == sizeof(pmsg->comm));
 }
 #else
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 019b11de262c..ec0c6734bbe1 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2255,7 +2255,7 @@ static void pmsg_load_execution_ctx(struct printk_message *pmsg,
 {
 	pmsg->cpu = printk_info_get_cpu(info);
 	pmsg->pid = printk_info_get_pid(info);
-	memcpy(pmsg->comm, info->comm, sizeof(pmsg->comm));
+	copy_task_comm(pmsg->comm, info, sizeof(pmsg->comm));
 	static_assert(sizeof(pmsg->comm) == sizeof(info->comm));
 }
 #else

-- 
2.55.0



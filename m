Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FE9CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 22:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8416B0098; Sun, 24 May 2026 18:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E623F6B0099; Sun, 24 May 2026 18:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E726B009B; Sun, 24 May 2026 18:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD7B76B0098
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:40:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 521F9C3CB5
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:11 +0000 (UTC)
X-FDA: 84803783022.22.57FB009
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9584E140008
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=OSnNTHFg;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779662409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=di2bf8D5HuujSZiLvfDBOQKQvMCs8zL1m04Xrs4azQo=;
	b=jQhKB+g6+54+MIBiI/52W8Ze+ygQ1B4oi9Pg1jH2OH26J5YpY5JhQMxUdlj5eBjOJhGwt4
	o0MdyOmvexZJ4ncrZJ+k1LFk9//RCWB6BudKpsxsIysUlKWaaAqpFgcN3SCrjF4DtJlotZ
	1ayc9XmsB2Uu2i4Adsj4ZX5qZ3E0Gy8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=OSnNTHFg;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779662409; a=rsa-sha256;
	cv=none;
	b=Zb1F3gC8+Erh4RgiBhV6IpGskJiXhb/MfQAC4ywKCCw1Vy4yi0b76Qiy3/oJf8VkXFtL4Y
	CB9W5jOb9zl17mUios5/a1XiXctgKq2J/uzW+4DNTRKPy1PBEhSHjyIz5qvGvjs05nVIoe
	nXdH4YfAmNtRo/eFl4iNkPajDQb/BmU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=di2bf8D5HuujSZiLvfDBOQKQvMCs8zL1m04Xrs4azQo=; b=OSnNTHFgckEkKiZBDIO1sajPYS
	rUcCcqyXgwQrIC6MH0GLzvHnwVR3Bf2L5IVU6pk3UstVE3RXTQDqutk2uhmkOqdpM16RlQIhcSF+7
	E/hK8D/li/RJKxlVDkDW7Nu0x8f9LYmg9ftynRN2cLLWf/JLSRfJI10apBEpXJfvxtXgH/ug/Kcry
	x889ppbvDXv9bq4h48ZzelBZ7LAMiZa0iD/90htRl6tftGYEL96iQQUlMG6urDyB1xiaXpaL4ViAZ
	WcYG4WRcQCIBNj3sYERkt5+kWlW9Gg4IcfN8qcqBFCFjQfnk7A6cQAf8h2qxw/kk9mNlboi4y+SU6
	FoBU68mQ==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wRHUC-007fJn-U9; Mon, 25 May 2026 00:39:57 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 24 May 2026 19:38:53 -0300
Subject: [PATCH v2 3/6] treewide: Replace memcpy(..., current->comm) with
 strscpy()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260524-tonyk-long_name-v2-3-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
In-Reply-To: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9584E140008
X-Stat-Signature: pomu95eorz4mntyoipe8omiwr6x633ts
X-Rspam-User: 
X-HE-Tag: 1779662409-365156
X-HE-Meta: U2FsdGVkX18LtPQoIpfcOa3z67IJcZj1l8lxJkXMvDEKw/3XBtfi7xXFi/KG9OzEPGZMOradGach38iDTKfl096Ay5AlyY/S1Ssvosd3n/ElD2nhzMD6ACb/fyiUu9llVjUu+jpFT3KlQyRZobVXIlhJAxSI7tthymTLFVVvk19RLz5xUbNC8S58f59+cAkW9F2IVo9WTYQqVm8PW2piYUPiraGeE3uLQPM9vT78vzalHKtUXvLMnclWO8gIqkDuS/QPifISd3v1ZYPnEhP1bIeApTqifgCB8gylpO06dcOlWyj4BfNusjpOldjzT2/mgOuk2Ti6fkLtf8yxxo4EBrtgS9/pmQV9nvAQjX7bM5t2yzwXT3lGR+wyPIbhR7wh66XoWxhAK+NlXF5DPcIV7+1uPIHP3L02M0jz5Q9hUJ/NfeJXpPJ4g6FqntH8iHKMpsMkdWyC5HfBofyNgJLxGVm7qC6X+WSO+mQwV0+ByRz1Ptxl9f+xmSpZJtliqO7CRlFrjN8Tw/Vk/mn5BPYqHcX1ALW365Okg0Us6ry6W2j0iMtXmcKe8P4GjuZ1JVrdQh5QmMk2usfyajas66qvw4BTLeWq+C0Nyd7YzywLnaFoKokjFnZ8MJAcJ/XuU4lsu09Vopzxj5uwvNEDWuJAFiam229G90kxZMb6rD2jHh1PHKpYAOjWNptb2JsI75y5J+AhZh3++EQbODyfZRc9Tf1W8taAbRxICi25kFkOwL9a8aORV4TzjElBX5AmZY7zPOHZrYMyA75ZzDG/tA828ew5RXatXFn9YoAppBKIp4s33RmpN2zRbK5EOtNOFw3KfaJOeE7tq+HaXBpkVvKXEVN0Wq2MA5eEktMl4vlnEjA5zvEhsXiTxZo2wE/3HOKwuuCHifq7mIxYvNSFIOuYMSv9Nah2IkRBTGmrJ+0RLQ3aIiWdL4/5BVrWovvx3WAlwrhsOK8PBUQPTEPkiPo
 yKzbzQUS
 EcWOJgpMHSfLiD/Ea2ufmPoK5s7UY+rDvjsyNO8ChpRgpWAFDfFbhJMtWV8bn10b4w4g58QGprv9XMowQ3TkaHD8u8dftFf7hAcO7QEJR8hKnrtyv6bz2ETK66N2LJPPhadw58lfMwebZZGW5485rGZDrd9pUECWh9eHwez6PkCfBVXcuF9JCl8+PoSnyW/CYssTxLDlUon0fgg+bDi2T3fP5AVmdKOXymwu6D28Xzn/bmit5cAzGAirhLoWL2mqDWvHFE8Cls9NiCN1iyLa7d3iO6f36DvSMyKBkB6XKN1q5D8w4tTMdftqv9taR2IB1hlOSmvqHgWxg/wp5OIyqNPIfWT8F2tKPqQ6LjYlbYDCLjmVQrTBYExHJBo0LWO0TvXtcKyOurODQMKJtuV0+3JHkBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to increase the size of current->comm[] and to avoid breaking any
existing code, replace memcpy() with strscpy(). The later function makes
sure that the copy is NUL terminated. This is crucial given that the
source buffer might be larger than the destination buffer and could
truncate the NUL character out of it.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes from v2:
 - New patch, dropped strtostr() from last version
---
 include/linux/coredump.h        |  2 +-
 include/linux/tracepoint.h      |  4 ++--
 include/trace/events/block.h    | 10 +++++-----
 include/trace/events/coredump.h |  2 +-
 include/trace/events/f2fs.h     |  4 ++--
 include/trace/events/oom.h      |  2 +-
 include/trace/events/osnoise.h  |  2 +-
 include/trace/events/sched.h    | 10 +++++-----
 include/trace/events/signal.h   |  2 +-
 include/trace/events/task.h     |  4 ++--
 kernel/printk/nbcon.c           |  2 +-
 kernel/printk/printk.c          |  2 +-
 12 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 68861da4cf7c..45cd55114120 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -54,7 +54,7 @@ extern void vfs_coredump(const kernel_siginfo_t *siginfo);
 	do {	\
 		char comm[TASK_COMM_LEN];	\
 		/* This will always be NUL terminated. */ \
-		memcpy(comm, current->comm, sizeof(comm)); \
+		strscpy(comm, current->comm, sizeof(comm)); \
 		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
 			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
 	} while (0)	\
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 763eea4d80d8..90fd9109210c 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -615,10 +615,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  *	*
  *
  *	TP_fast_assign(
- *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+ *		strscpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
  *		__entry->prev_pid	= prev->pid;
  *		__entry->prev_prio	= prev->prio;
- *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+ *		strscpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
  *	),
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 6aa79e2d799c..73db3713b967 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -213,7 +213,7 @@ DECLARE_EVENT_CLASS(block_rq,
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
 	TP_printk("%d,%d %s %u (%s) %llu + %u %s,%u,%u [%s]",
@@ -351,7 +351,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
@@ -434,7 +434,7 @@ TRACE_EVENT(block_plug,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
 	TP_printk("[%s]", __entry->comm)
@@ -453,7 +453,7 @@ DECLARE_EVENT_CLASS(block_unplug,
 
 	TP_fast_assign(
 		__entry->nr_rq = depth;
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
@@ -504,7 +504,7 @@ TRACE_EVENT(block_split,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->new_sector	= new_sector;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
 	TP_printk("%d,%d %s %llu / %llu [%s]",
diff --git a/include/trace/events/coredump.h b/include/trace/events/coredump.h
index c7b9c53fc498..dc21ec89a4fb 100644
--- a/include/trace/events/coredump.h
+++ b/include/trace/events/coredump.h
@@ -32,7 +32,7 @@ TRACE_EVENT(coredump,
 
 	TP_fast_assign(
 		__entry->sig = sig;
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
 	TP_printk("sig=%d comm=%s",
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index b5188d2671d7..1e56e448268c 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -2505,7 +2505,7 @@ TRACE_EVENT(f2fs_lock_elapsed_time,
 
 	TP_fast_assign(
 		__entry->dev		= sbi->sb->s_dev;
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->ioprio_class	= IOPRIO_PRIO_CLASS(ioprio);
@@ -2558,7 +2558,7 @@ DECLARE_EVENT_CLASS(f2fs_priority_update,
 
 	TP_fast_assign(
 		__entry->dev		= sbi->sb->s_dev;
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->lock_name	= lock_name;
 		__entry->is_write	= is_write;
diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c4..172278a7e20a 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -23,7 +23,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, task->comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnoise.h
index 3f4273623801..4db90931e897 100644
--- a/include/trace/events/osnoise.h
+++ b/include/trace/events/osnoise.h
@@ -116,7 +116,7 @@ TRACE_EVENT(thread_noise,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, t->comm, TASK_COMM_LEN);
 		__entry->pid = t->pid;
 		__entry->start = start;
 		__entry->duration = duration;
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 535860581f15..a932f443f327 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
 		__entry->target_cpu	= task_cpu(p);
@@ -237,11 +237,11 @@ TRACE_EVENT(sched_switch,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		strscpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
 		__entry->prev_state	= __trace_sched_switch_state(preempt, prev_state, prev);
-		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		strscpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
 		/* XXX SCHED_DEADLINE */
@@ -346,7 +346,7 @@ TRACE_EVENT(sched_process_exit,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
 		__entry->group_dead	= group_dead;
@@ -787,7 +787,7 @@ TRACE_EVENT(sched_skip_cpuset_numa,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
 		__entry->pid		 = task_pid_nr(tsk);
 		__entry->tgid		 = task_tgid_nr(tsk);
 		__entry->ngid		 = task_numa_group_id(tsk);
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 1db7e4b07c01..6aa7d1123f04 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -67,7 +67,7 @@ TRACE_EVENT(signal_generate,
 	TP_fast_assign(
 		__entry->sig	= sig;
 		TP_STORE_SIGINFO(__entry, info);
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, task->comm, TASK_COMM_LEN);
 		__entry->pid	= task->pid;
 		__entry->group	= group;
 		__entry->result	= result;
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index b9a129eb54d9..f75dbf20fe02 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -21,7 +21,7 @@ TRACE_EVENT(task_newtask,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		strscpy(__entry->comm, task->comm, TASK_COMM_LEN);
 		__entry->clone_flags = clone_flags;
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
@@ -46,7 +46,7 @@ TRACE_EVENT(task_rename,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
+		strscpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
 		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index d7044a7a214b..7625adc0a2e1 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -952,7 +952,7 @@ static void wctxt_load_execution_ctx(struct nbcon_write_context *wctxt,
 {
 	wctxt->cpu = pmsg->cpu;
 	wctxt->pid = pmsg->pid;
-	memcpy(wctxt->comm, pmsg->comm, sizeof(wctxt->comm));
+	strscpy(wctxt->comm, pmsg->comm, sizeof(wctxt->comm));
 	static_assert(sizeof(wctxt->comm) == sizeof(pmsg->comm));
 }
 #else
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1f04e753ca02..eaf8b7b930df 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2255,7 +2255,7 @@ static void pmsg_load_execution_ctx(struct printk_message *pmsg,
 {
 	pmsg->cpu = printk_info_get_cpu(info);
 	pmsg->pid = printk_info_get_pid(info);
-	memcpy(pmsg->comm, info->comm, sizeof(pmsg->comm));
+	strscpy(pmsg->comm, info->comm, sizeof(pmsg->comm));
 	static_assert(sizeof(pmsg->comm) == sizeof(info->comm));
 }
 #else

-- 
2.54.0



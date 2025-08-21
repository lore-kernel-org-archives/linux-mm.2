Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB87CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4228E000A; Thu, 21 Aug 2025 06:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B9D8E0003; Thu, 21 Aug 2025 06:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A988E000A; Thu, 21 Aug 2025 06:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 141C68E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:22:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5370140357
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:32 +0000 (UTC)
X-FDA: 83800375344.09.FF79459
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id D13A9120003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=W6WtSgol;
	spf=pass (imf29.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqsTTNFtY7sLvLfKdk5uavi6kBouFmYvW/0kXiCyJt4=;
	b=2EjDKPqXLyQsjQFKs2vyJ1epD6VdGUJBL0FAnIdJmRisDFcOMBNThvzkCuJXyaUUOXZ4I+
	N+t94hln0DRfWY9d4kzao+VSIulLaWQ/FoFp3B5w0DVsCxYWSG0TCjaVFNC8XVV85YjZMI
	PgctN0xineeFpBtxG48DY/bDDFAJWcs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=W6WtSgol;
	spf=pass (imf29.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755771751; a=rsa-sha256;
	cv=none;
	b=Du0nNbgWopkFOJS2WNWia+g/fcyIkJWbiM/RjOI2gE+zLdN7dqfTro5s4be2WLSgrCyI2F
	JnbhBYKuG+DW6QO+3N/jd7lFPtvzsCZFh3564vn6yewBLByXuUyKKPA9yxAyqwJ5T2TL7T
	e4Q/Okn2WP9eQjJPOPAC8Zfl06IL+0Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YqsTTNFtY7sLvLfKdk5uavi6kBouFmYvW/0kXiCyJt4=; b=W6WtSgol1JRfHGdppK4TBaac2y
	zESPO8TRh6da6tbLe5VfFj/fBPNoIIpPUXmPWY9lvhvveGLlhPO8MGnehRVf4CS9qAftCF6bkMWdX
	nnDlAGFKvj6iyJOACpXGkSQJ6CBj0HF0d9bOvdFdOYc7rZOjUM3TqdNcLRTYVwf39yJJW8t1395DD
	1+1/RUVpCBtUFllgAkDx+RaUMUEDPl2hzWZueJense77c5lj+C2oDZXjngbW0H260c94Mds4Wa/kB
	wbW0Gvvzm92oa1U8tcYff7QHHrrbjlY3ZZI2nILwQOSNxWAyA9f2x+/HLAQcl6gx0GUcUgQRDJwiq
	l2dzavfA==;
Received: from [223.233.68.152] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1up2R7-00HBmV-Np; Thu, 21 Aug 2025 12:22:26 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v8 4/5] treewide: Switch memcpy() users of 'task->comm' to a more safer implementation
Date: Thu, 21 Aug 2025 15:51:51 +0530
Message-Id: <20250821102152.323367-5-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250821102152.323367-1-bhupesh@igalia.com>
References: <20250821102152.323367-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D13A9120003
X-Stat-Signature: p33o6h6axz8mn9n6yw7ozszktir7sa6b
X-Rspam-User: 
X-HE-Tag: 1755771750-459497
X-HE-Meta: U2FsdGVkX1/A0c80rOB1Yp2ICMzaq5Amiy1+LHgGCGwy5nNjKu/GNh/CvfsdNnc2FExw0/W4Vuxw0XvaIK+QK0kfH50omv9aba8YsDnH4R9/UHcjnMe3Oi+DBOw7irJ82g62oFocxkAxD+OBwxEmJZWKOVjsstwDo6QZrQudUNnnf9GzqKNe7XfdNNCEG4YumP1zTdMNlqsAYoWMltUtCgEaayH2GFcscUe82R28u8/D9H08jhUkHXFW+4KPM2Pc+DP96hAakrE2BrJw3sSQG6KiTHgdDstafTz6EhV24ZDKE/EyWgefaeHOf6JpqHGo0HZ+2+Fu+XUsOEgRDKOcSpWYuW9NF+UD2LlwfhtWfiFhAFzo+yHBxQZX2UvESEtlA0SJ0sG6NGUhudeh9qCPzD7YZrHqhn8wrjffF8PDNd+p1y96SNTXQZ48uhUwjtjd3e9+37636zCTQw+ikFknnDmfUPWAA0t+V0odXhegvc2MZlSx70WiPVPlL3QVdp4A8Ap6mUT2lQiRLeP3p0sbSCzSc9DER+a+/E2Eptq/uTaIzHFcJr2fSkRxwt0DB21aiEty3Bkjc8oMsXMSBZa84S2Rd+saT3FhGUDT8gny135vmj8XkMXZkDRnKPV2nBv5UeSuJuKCsgESvYWt3+MxTB/agdqie+PWOmx30b5JlmyG++i3tq/y0n7y++w76yVnOsP2n55kFzT8rj7op3S92m9bGGJiz3iN2qYrUtYFTe5AKeEIo6mLjUdQ+PbJPiB5MXHp+XN4T6QwKEzHzXICIBgCGMNNSYGJoJBwFd3A2PrZBk7/IiAeO87E4Ydeell2ipxVLraIo4AOrEdXmklWwChrh1F+QclU3ITFf2vNuAVyNxt7R9FIvniNg48pgB9xC2k0GHdcxBxhnPzuB6nxIvOhlOrkBWA3xGzK3dJsI/4cm6rFyyohZn3NeN3gEULeXI+yZC8k9yKjiAkpIwV
 C7JkoapK
 +FjJChBk+TctUJLVyV/vgRomeZVgXkn28h2PJzDEWb5MPLiutkNAU8U6Z4iYrSSXN+O1sjx92dq6gyV7Q3zmKMz5chu0N/n4PGiK83zIfrPkV25qwUNtaBtdLPp7TSmjAUoTow+K2yDktTn3Yy8fcx83p6kYhJyNaPHk6qVjOSaXkBFjGU2nO/TWnFAS5DZEOv16uyO/tfBlYwSnSnPcKHzu2uDc6XHb/3HsaWmtp6Ogi9whpM4D/2vkmqjejAmFbb05DcFXhY8QF6jbTvQj+Z7Uhn4Vzdq2vUdmmOMDbYWxP/XMBSf9xrnYy5kbwokgsHm440S2+XYs4cpMcM9ZZawack1g+Zt2U1N+SlL9wYKy2wookqF8IWfowhogj+6G7GS50fGuo1goJM/P2aVAn0FbsEIF7wfh+5Rbl+GuYLrbKbQg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As Linus mentioned in [1], currently we have several memcpy() use-cases
which use 'current->comm' to copy the task name over to local copies.
For an example:

 ...
 char comm[TASK_COMM_LEN];
 memcpy(comm, current->comm, TASK_COMM_LEN);
 ...

These should be rather calling a wrappper like "get_task_array()",
which is implemented as:

   static __always_inline void
       __cstr_array_copy(char *dst,
            const char *src, __kernel_size_t size)
   {
        memcpy(dst, src, size);
        dst[size] = 0;
   }

   #define get_task_array(dst,src) \
      __cstr_array_copy(dst, src, __must_be_array(dst))

The relevant 'memcpy()' users were identified using the following search
pattern:
 $ git grep 'memcpy.*->comm\>'

Link: https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/ #1

Signed-off-by: Bhupesh <bhupesh@igalia.com>
---
 include/linux/coredump.h                      |  2 +-
 include/linux/sched.h                         | 32 +++++++++++++++++++
 include/linux/tracepoint.h                    |  4 +--
 include/trace/events/block.h                  | 10 +++---
 include/trace/events/oom.h                    |  2 +-
 include/trace/events/osnoise.h                |  2 +-
 include/trace/events/sched.h                  | 13 ++++----
 include/trace/events/signal.h                 |  2 +-
 include/trace/events/task.h                   |  4 +--
 tools/bpf/bpftool/pids.c                      |  6 ++--
 .../bpf/test_kmods/bpf_testmod-events.h       |  2 +-
 11 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 68861da4cf7c..bcee0afc5eaf 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -54,7 +54,7 @@ extern void vfs_coredump(const kernel_siginfo_t *siginfo);
 	do {	\
 		char comm[TASK_COMM_LEN];	\
 		/* This will always be NUL terminated. */ \
-		memcpy(comm, current->comm, sizeof(comm)); \
+		get_task_array(comm, current->comm); \
 		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
 			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
 	} while (0)	\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a58c1270474..d26d1dfb9904 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1960,12 +1960,44 @@ extern void wake_up_new_task(struct task_struct *tsk);
 
 extern void kick_process(struct task_struct *tsk);
 
+/*
+ * - Why not use task_lock()?
+ *   User space can randomly change their names anyway, so locking for readers
+ *   doesn't make sense. For writers, locking is probably necessary, as a race
+ *   condition could lead to long-term mixed results.
+ *   The logic inside __set_task_comm() should ensure that the task comm is
+ *   always NUL-terminated and zero-padded. Therefore the race condition between
+ *   reader and writer is not an issue.
+ */
+
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 #define set_task_comm(tsk, from) ({			\
 	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
 	__set_task_comm(tsk, from, false);		\
 })
 
+/*
+ * 'get_task_array' can be 'data-racy' in the destination and
+ * should not be used for cases where a 'stable NUL at the end'
+ * is needed. Its better to use strscpy and friends for such
+ * use-cases.
+ *
+ * It is suited mainly for a 'just copy comm to a constant-sized
+ * array' case - especially in performance sensitive use-cases,
+ * like tracing.
+ */
+
+static __always_inline void
+	__cstr_array_copy(char *dst, const char *src,
+			  __kernel_size_t size)
+{
+	memcpy(dst, src, size);
+	dst[size] = 0;
+}
+
+#define get_task_array(dst, src) \
+	__cstr_array_copy(dst, src, __must_be_array(dst))
+
 static __always_inline void scheduler_ipi(void)
 {
 	/*
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 826ce3f8e1f8..40e04cb660ce 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -570,10 +570,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  *	*
  *
  *	TP_fast_assign(
- *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+ *		get_task_array(__entry->next_comm, next->comm);
  *		__entry->prev_pid	= prev->pid;
  *		__entry->prev_prio	= prev->prio;
- *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+ *		get_task_array(__entry->prev_comm, prev->comm);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
  *	),
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 6aa79e2d799c..de1fe35333fc 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -213,7 +213,7 @@ DECLARE_EVENT_CLASS(block_rq,
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, current->comm);
 	),
 
 	TP_printk("%d,%d %s %u (%s) %llu + %u %s,%u,%u [%s]",
@@ -351,7 +351,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, current->comm);
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
@@ -434,7 +434,7 @@ TRACE_EVENT(block_plug,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, current->comm);
 	),
 
 	TP_printk("[%s]", __entry->comm)
@@ -453,7 +453,7 @@ DECLARE_EVENT_CLASS(block_unplug,
 
 	TP_fast_assign(
 		__entry->nr_rq = depth;
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, current->comm);
 	),
 
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
@@ -504,7 +504,7 @@ TRACE_EVENT(block_split,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->new_sector	= new_sector;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, current->comm);
 	),
 
 	TP_printk("%d,%d %s %llu / %llu [%s]",
diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c4..31e5b7295188 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -23,7 +23,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, task->comm);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnoise.h
index 3f4273623801..f67f8b5eca75 100644
--- a/include/trace/events/osnoise.h
+++ b/include/trace/events/osnoise.h
@@ -116,7 +116,7 @@ TRACE_EVENT(thread_noise,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, t->comm);
 		__entry->pid = t->pid;
 		__entry->start = start;
 		__entry->duration = duration;
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 7b2645b50e78..66fe808f2654 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, p->comm);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
 		__entry->target_cpu	= task_cpu(p);
@@ -237,11 +237,11 @@ TRACE_EVENT(sched_switch,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		get_task_array(__entry->prev_comm, prev->comm);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
 		__entry->prev_state	= __trace_sched_switch_state(preempt, prev_state, prev);
-		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		get_task_array(__entry->next_comm, next->comm);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
 		/* XXX SCHED_DEADLINE */
@@ -346,7 +346,7 @@ TRACE_EVENT(sched_process_exit,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, p->comm);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
 		__entry->group_dead	= group_dead;
@@ -787,14 +787,13 @@ TRACE_EVENT(sched_skip_cpuset_numa,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, tsk->comm);
 		__entry->pid		 = task_pid_nr(tsk);
 		__entry->tgid		 = task_tgid_nr(tsk);
 		__entry->ngid		 = task_numa_group_id(tsk);
 		BUILD_BUG_ON(sizeof(nodemask_t) != \
 			     BITS_TO_LONGS(MAX_NUMNODES) * sizeof(long));
-		memcpy(__entry->mem_allowed, mem_allowed_ptr->bits,
-		       sizeof(__entry->mem_allowed));
+		get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
 	),
 
 	TP_printk("comm=%s pid=%d tgid=%d ngid=%d mem_nodes_allowed=%*pbl",
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 1db7e4b07c01..0681dc5ab1de 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -67,7 +67,7 @@ TRACE_EVENT(signal_generate,
 	TP_fast_assign(
 		__entry->sig	= sig;
 		TP_STORE_SIGINFO(__entry, info);
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, task->comm);
 		__entry->pid	= task->pid;
 		__entry->group	= group;
 		__entry->result	= result;
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index af535b053033..9553946943a6 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -21,7 +21,7 @@ TRACE_EVENT(task_newtask,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, task->comm);
 		__entry->clone_flags = clone_flags;
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
@@ -44,7 +44,7 @@ TRACE_EVENT(task_rename,
 	),
 
 	TP_fast_assign(
-		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
+		get_task_array(entry->oldcomm, task->comm);
 		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 23f488cf1740..a5d339cb8ca3 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -53,8 +53,7 @@ static void add_ref(struct hashmap *map, struct pid_iter_entry *e)
 		refs->refs = tmp;
 		ref = &refs->refs[refs->ref_cnt];
 		ref->pid = e->pid;
-		memcpy(ref->comm, e->comm, sizeof(ref->comm));
-		ref->comm[sizeof(ref->comm) - 1] = '\0';
+		get_task_array(ref->comm, e->comm);
 		refs->ref_cnt++;
 
 		return;
@@ -77,8 +76,7 @@ static void add_ref(struct hashmap *map, struct pid_iter_entry *e)
 	}
 	ref = &refs->refs[0];
 	ref->pid = e->pid;
-	memcpy(ref->comm, e->comm, sizeof(ref->comm));
-	ref->comm[sizeof(ref->comm) - 1] = '\0';
+	get_task_array(ref->comm, e->comm);
 	refs->ref_cnt = 1;
 	refs->has_bpf_cookie = e->has_bpf_cookie;
 	refs->bpf_cookie = e->bpf_cookie;
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
index aeef86b3da74..81880748550f 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
@@ -20,7 +20,7 @@ TRACE_EVENT(bpf_testmod_test_read,
 	),
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		get_task_array(__entry->comm, task->comm);
 		__entry->off = ctx->off;
 		__entry->len = ctx->len;
 	),
-- 
2.38.1



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B765C606A333
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ri/17j1R
Received: by kanga.kvack.org (Postfix)
	id 51CC96B087D; Tue, 24 Nov 2026 17:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EFF6B087F; Tue, 24 Nov 2026 17:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DD26B0880; Tue, 24 Nov 2026 17:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01AEC6B087D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:59:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A9C1C0D60
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:44 +0000 (UTC)
X-FDA: 85471531488.30.9809F90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85FFC140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ri/17j1R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561182;
	b=cDj2g4Yfi1CR+8rlQGO3hfLN0tqH5MeVwr25X0EDzTXK3UQUyptHEh5Vjnqz9elxMuAnZr
	9MWFryNuDyGaI+/yHIsCZc5fSn3/husADhairwHNZ6hR+NrGbsxAyXW/aha7gHb1aiW7FJ
	dAKNygn0lC6We8d/9WAVFavPGF21WH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=We7g4rjlDEvC14Rt3aeSkNWIUyaxM8r0Z8+EijuZ/qU=;
	b=YyVlAKMy4kZ1lJC2VWKedynoOB71kQYcJKoZ8s6ZQu6e0M/qtsyYGiyl1fFpvL8NccMzzJ
	79kVWC0gWW37QI28I1VsU1G4y2pBJmd6OQ7n3SHE3RB/TalKX2a9iwHaVj+ex/x6yADsYd
	pNsYZJjYGTBrFCZQRfZ5VJalyytuj+k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ri/17j1R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B204241711;
	Tue, 24 Nov 2026 22:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83301F000EC;
	Tue, 24 Nov 2026 22:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561181;
	bh=We7g4rjlDEvC14Rt3aeSkNWIUyaxM8r0Z8+EijuZ/qU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ri/17j1Rt5RKcLJGc3pX2deQYRZ+LZ+G1bAtYDCVYKtkC1Zy5A/Z5GdnbhjahIGwy
	 wr9Ad+6N8dCt7b6yCsWdI431ikhDYv0G/k5QQdEHmX/FhNTxKFwMCYadUzmRnFLJU3
	 5hj4kv5olhynXTApByY3rhShBCwcPUNgHwBISSz1esbVTSAfsjpt81sHNdGMj2Is0Y
	 23kfqQE862hULGihGBIz83ALL46EiiZjaBylYJxDDfQhlasNrzlbNQmnCCqKfwiOT9
	 qk34Wbyf4zVQxAhuXG4ioOz0nYi28zS1qcw2gMw/HSnF1EbYstxQ8uTWXvwQxANjCc
	 RR2nzSPZOEt6A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:26 +0100
Subject: [PATCH RFC 03/19] perf: copy counter values after dropping
 ctx->mutex
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-3-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=6259; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rc/rAON3FyLKLA9sJD24e24XLxM38HdsZD8TQYVeAlE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSzie1QVTh+4/ME7u4/7/zrpW8dV3CSakh0OF8TxXbyg
 vpf/ZpdHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5soXhn/V3+YtrBRPOqi19
 dpmra5bp3WuC+R2+Hpxn8rbLqG1r+M3I8OquE/PHx1OK6gotRabXL7ntKHmrszRUJuT1rxUXbQT
 tGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7rkxeyhupnp9pxgpj1qg1smm4zfy88ks
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 85FFC140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1795561182-553309
X-HE-Meta: U2FsdGVkX1+1h2KnqkBaOt4mQDAdN2SRfDD1F7LymydFovXZIa6bJZF7NOA4Kbt21aGdCdHmlJwkAxHi+5X6MazLFUubYkndshiO3+FVEgwbcg+2UhgtECCOBsuXlyyZEwu4NmHbqnCOUPyl63CDK+u4MVPLcUmMKAXLENpNp5Vfzo6jqA8aGg9y59DXzpK7IZKpjbTEnXEXYVTEJTvvoMp9LEKdQRuP+VtOKhnDB6pWz6G8iX9v7Snzy0oEXPe67AfgJw14byQr9c/464kZCv5NxS9UIhlbTnyuzzh+AjZ8gc2YQaJMpLL1TEx7kwnKk+B7coxvkjRNiOV7OzufSmI4Cg2GsfZeCN/Qxd6+QqIWgo8zR0c5ORRSkFd+7/Lv0xXbnUd6hvcpoal4kBePWI2iqqlKbNtWIT8B5DE++ITSgC/rzlbfBh+zd/ww7/NBsqj1GwECG3e42HY+/0Mrh9y/4TYNVN9gvhGwdct6IKikdEKKG++jc4kSFBd4Ybp9DVqK+xRFdsHkxMJYHFj0oCjvylnDTiqZzY46KdKnM3Y1XdMz3eDnTXiqkY8YYE5Dsf90kf3GL5T1g96y9XxhSQ3Lapao3skMGeqqHLOOVa4QzQYMPkdSRsmoSJ4K38S6weMiXvW6Gb3EeLGzIQQo/uk00v17rn+Ls7R4qaxOt/Pj+Q9PQ/FKmPg+Z4OWk4+7MXPHv2O4T71ivfQbq2OYppKqkcDErxT0pU2LJPuTKo+57DOCTsI1RyLQzHWVnnpDTfODKk8NSPLl3EkrZ0dEHNp/maugZJywxhdoMUs7k6tlyjeLILrAgN5OJUdiqcurHi0+I69sLZq5uwIkvZJJlUYPAHjGHJNh/f9v3CFStLsVqo6Ce2khoLRZQIAa3FQN1oIVB1R6xUWtJu9YLtCfSPQOW8l0a+7ZYBZPeAfT3jutc+PiJ1H6vnshmgVR2XuIDq71aaMMdYdTsKC2tTD
 8NiGKK7S
 EsKCUZUyaXURe3qNSrCX1fQcNi73xFDu/z2BFdtGaSQaLlONSK3emJrMr9XYa9Q7y5nqZv1lcs2S7ckrhWfEt4aVYB2Y5tg85V1tDZcukKE1BlRzeDESq/MvHbvnqQwBxN6aZ6jdf8xGe+1StQwMKm8l9O7Z1oyNpC2Pl6lEebJ1yF69AaiTCi5/97+qbfn8O3fAqVVViZ3YU1EAV1TE/pVq8eGzDRy1m1ASe8xDN4uyEVeZTRL9Q+wQKpucUiOkxsMYAOdATUhGUwKYgmp652G5yYJp1sxWwY93oekIzy3D5UXpgiFKhd4NKmWd+TY8GW/YcBEdLzxKnyfJpYX69kWh28d/ujgT7H8okBkNF3JoSxSOAScbx1Pqyd+mOxulJlX4j+4JL4d09slcWXN8vtGCXiaadBlINUmIXqlyefOjjHFTwX6PYJel9HbN5005TvrlrfHU330LjJvUzdzyqNmFWzT60CKVSpLtgaQH8Ybp8lFFWajiIVbwuHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

perf_read() copies the values to userspace with the mutex of the
event's context held. If that faults the mutex is held for as long as
the fault takes. With a buffer in a mapping of a file on a FUSE
filesystem or in a range registered with userfaultfd it's the caller who
decides how long that is:

  locks held by perf-reader/212:
   #0: (&ctx->mutex){+.+.}-{4:4}, at: perf_event_ctx_lock_nested+0x18f/0x360

Since commit 2e498d0a74e5 ("perf: Add support for event removal on
exec") perf_event_exec() takes that mutex whenever the task has a perf
context. And begin_new_exec() calls it with exec_update_lock held. So an
exec of the task the event counts for hangs past the point of no return
until the fault is resolved. It can't be killed either:

  locks held by exec-task/211:
   #0: (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb7/0x1400
   #1: (&sig->exec_update_lock){++++}-{4:4}, at: begin_new_exec+0xa4b/0x2df0
   #2: (&ctx->mutex){+.+.}-{4:4}, at: perf_event_exec+0x17e/0xe40

  task:exec-task       state:D pid:211
  Call Trace:
   __schedule+0x1691/0x4b00
   schedule+0xe0/0x2e0
   schedule_preempt_disabled+0x11/0x20
   __mutex_lock+0x6d7/0x2700
   perf_event_exec+0x17e/0xe40
   begin_new_exec+0x1c1e/0x2df0
   load_elf_binary+0x340/0x4af0
   bprm_execve+0x772/0x1400
   do_execveat_common.isra.0+0x3d9/0x540
   __x64_sys_execve+0x8c/0xc0
   do_syscall_64+0x110/0x600
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

And everyone who needs the exec_update_lock of the task waits with it.
Since commit 6650527444da ("proc: protect ptrace_may_access() with
exec_update_lock (part 1)") that includes a read of /proc/<pid>/stat:

  task:stat-reader     state:D pid:214
  Call Trace:
   __schedule+0x1691/0x4b00
   schedule+0xe0/0x2e0
   schedule_preempt_disabled+0x11/0x20
   rwsem_down_read_slowpath+0x5cc/0x10c0
   down_read_killable+0xf1/0x5f0
   do_task_stat+0x13b/0x2870
   proc_single_show+0x110/0x1d0
   seq_read_iter+0x2e4/0x1280
   seq_read+0x29b/0x550
   vfs_read+0x171/0xb20
   ksys_read+0x111/0x250
   do_syscall_64+0x110/0x600
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

The values are gathered in a kernel buffer anyway. So hand that buffer
to perf_read() and copy it out after the mutex has been dropped. What a
read returns goes into a struct on the stack of perf_read() that the
helpers fill in.

Fixes: 2e498d0a74e5 ("perf: Add support for event removal on exec")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/events/core.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e870f12c3ad81..f00eeded212c4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6188,8 +6188,15 @@ static int __perf_read_group_add(struct perf_event *leader,
 	return ret;
 }
 
-static int perf_read_group(struct perf_event *event,
-				   u64 read_format, char __user *buf)
+/* What a read of an event returns, filled in with ctx->mutex held. */
+struct perf_read_buf {
+	size_t	count;		/* room in the buffer of the reader */
+	u64	values[5];	/* a single event */
+	u64	*group_values;	/* PERF_FORMAT_GROUP, allocated */
+};
+
+static int perf_read_group(struct perf_event *event, u64 read_format,
+			   struct perf_read_buf *rb)
 {
 	struct perf_event *leader = event->group_leader, *child;
 	struct perf_event_context *ctx = leader->ctx;
@@ -6218,23 +6225,20 @@ static int perf_read_group(struct perf_event *event,
 
 	mutex_unlock(&leader->child_mutex);
 
-	ret = event->read_size;
-	if (copy_to_user(buf, values, event->read_size))
-		ret = -EFAULT;
-	goto out;
+	rb->group_values = values;
+	return event->read_size;
 
 unlock:
 	mutex_unlock(&leader->child_mutex);
-out:
 	kfree(values);
 	return ret;
 }
 
-static int perf_read_one(struct perf_event *event,
-				 u64 read_format, char __user *buf)
+static int perf_read_one(struct perf_event *event, u64 read_format,
+			 struct perf_read_buf *rb)
 {
 	u64 enabled, running;
-	u64 values[5];
+	u64 *values = rb->values;
 	int n = 0;
 
 	values[n++] = __perf_event_read_value(event, &enabled, &running);
@@ -6247,9 +6251,6 @@ static int perf_read_one(struct perf_event *event,
 	if (read_format & PERF_FORMAT_LOST)
 		values[n++] = atomic64_read(&event->lost_samples);
 
-	if (copy_to_user(buf, values, n * sizeof(u64)))
-		return -EFAULT;
-
 	return n * sizeof(u64);
 }
 
@@ -6270,7 +6271,7 @@ static bool is_event_hup(struct perf_event *event)
  * Read the performance event - simple non blocking version for now
  */
 static ssize_t
-__perf_read(struct perf_event *event, char __user *buf, size_t count)
+__perf_read(struct perf_event *event, struct perf_read_buf *rb)
 {
 	u64 read_format = event->attr.read_format;
 	int ret;
@@ -6283,14 +6284,14 @@ __perf_read(struct perf_event *event, char __user *buf, size_t count)
 	if (event->state == PERF_EVENT_STATE_ERROR)
 		return 0;
 
-	if (count < event->read_size)
+	if (rb->count < event->read_size)
 		return -ENOSPC;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	if (read_format & PERF_FORMAT_GROUP)
-		ret = perf_read_group(event, read_format, buf);
+		ret = perf_read_group(event, read_format, rb);
 	else
-		ret = perf_read_one(event, read_format, buf);
+		ret = perf_read_one(event, read_format, rb);
 
 	return ret;
 }
@@ -6299,6 +6300,7 @@ static ssize_t
 perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct perf_event *event = file->private_data;
+	struct perf_read_buf rb = { .count = count };
 	struct perf_event_context *ctx;
 	int ret;
 
@@ -6307,9 +6309,14 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		return ret;
 
 	ctx = perf_event_ctx_lock(event);
-	ret = __perf_read(event, buf, count);
+	ret = __perf_read(event, &rb);
 	perf_event_ctx_unlock(event, ctx);
 
+	/* The copy can sleep in a page fault. Don't hold ctx->mutex for it. */
+	if (ret > 0 && copy_to_user(buf, rb.group_values ?: rb.values, ret))
+		ret = -EFAULT;
+
+	kfree(rb.group_values);
 	return ret;
 }
 

-- 
2.53.0



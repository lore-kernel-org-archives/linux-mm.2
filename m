Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C330C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F286B0096; Thu, 10 Sep 2026 12:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036576B0098; Thu, 10 Sep 2026 12:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19996B0099; Thu, 10 Sep 2026 12:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF4706B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:49:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 430A5A4B1D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:56 +0000 (UTC)
X-FDA: 85198439592.28.5E96CFD
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7464B1A000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=pQz1zxlQ;
	spf=pass (imf19.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MfA022lMI6eopMpnYm97azulYzjdx+Jco4w94leDiw=;
	b=jkrjM8k/7ZQ+ADARIotjQhZaLfJNIFbzL83gaBMY6bnX4Z+68zXl0miWQLIpiJ6x12DRdH
	/LKifDmp/+Vo+dNXRffWjrujrrQBcHMDJ/Ns7cBOZ7cEgqgEDWn3ZU0tZt3BiUXA2Qkcx3
	mIrWJZe8LPNbyv//VThZixkquJwwUHQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=pQz1zxlQ;
	spf=pass (imf19.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058994;
	b=KzzqRK6yxFHYfOQKBSZFhXyB5LLAiMYSlPm2Q3dUe788qAiOzRF+FtZtZ0xkHsuWokw8Oi
	Nqe67egih6tNf4Z6GNI72VoQibhOui8JPmz1ph5V5+XxZDRnIVCTdndL6UpRiP16EpqTTF
	/HBl65y9wLXnoKAT+4R/T9QL6NCQfV4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=1MfA022lMI6eopMpnYm97azulYzjdx+Jco4w94leDiw=; b=pQz1zxlQD+em6o0ikC/F+rt/mg
	8NXjQxCOgce50tHZiWLUMta/2epDzYxoQ8oVrtmJTr8D/LBx2bQYxbayey2kXk0hAs2ZyzQAZi5pJ
	eT6J4LeHoemYJKnzgdPh1KeJO0kJ6cPN3zp7IRbSwgcKs5zWku+BdzcTz+8NT4qdUZsovN/FafTPe
	6w6azMQNwkXTKzFbumEdbrBgLH8QOzcPK+SasJENgwxOMfgRNUk8SofwCzUaHydkVhPn1OL0yLhEJ
	/gFNjqk+BhSaEQW8drUOWuE9EVZ41ZthDrbmqi+0Nz6uxle+TACTUwvSemat8D6jqTc7F+KuNDZjH
	4UScT3Ag==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x4hyD-000GV1-0v; Thu, 10 Sep 2026 18:49:52 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 10 Sep 2026 13:49:26 -0300
Subject: [PATCH v6 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260910-tonyk-long_name-v6-4-d70afbf194c5@igalia.com>
References: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
In-Reply-To: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
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
X-Stat-Signature: 6p1wicpu6or6axpfuby3kihic8ugt3un
X-Rspamd-Queue-Id: 7464B1A000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789058994-213523
X-HE-Meta: U2FsdGVkX18z0KC5OgvZwA1Hiliz2TDKCDO8oFVQxtXw3Eki6W5z/d1IDMtCx4iYkiuLhaZBkxOWR0XDJ1G/bu+8NqeynFj3zFAY1Y38+GEORiFhCZhSfIrVoUzLwsecVgSOSpy04LWgbyAjGrlk7uGhjRkWIgxEe6Ert19TGQaPQ45KLERA3uzY/VPZ8DcG2tXXDUUmTDrMgFet3ewlV5cVa4ufAj7Ji61b5KhsoUEVw0Znp+Yl5zAOwBWupBYd0Cs4qRzCjXZBC59E0+4Ab+Bt+G3jlfM3lqsj+9GqjaOwv4ETxII7qiGLDk90DCi2mHrbrUWB34pXiBPVRNlfOyHQQs7oWN8pL8XG5cpiFxMosFgPmxKmFmbgdvmZSB0wZNqtDKLjqw6m5JLOXI5uiPISU+8iwlYa7bG/UFLy2qEMM0MiFwQOKWrluEM7og27yvj8fGysWEqbOoK495CNsa8z/4KjB9c8ru9qoW/qsXq+bCXtbVNHAkX7L708eTIe5MazkymEIoVHx0UpYcjCIl5VVo+cJzB3fxUh7Vt2RhKuERW5b7wpktwSuqdgQlR8GCXns09mcJ6vR+l6iOF0YHPqV3qNFzoz+84F66dImIOP+i6TnrX2Fxcryr9XaIpm9KOGPGjxOFZM3cHnK0fqklV8ks1bZTl+MikzqGIaZ4fUxNdv/B3a2Wl4yFkXrLkl9P+MPYz3YA8tNA/YozqjhpKW/JTI5lrVIlztQWWu9132FnSrWJ3riTZKAM+cZhRz1MyPxxzXOeLZ+XZvX2m9U9o4lDEgBirrP9m2AtvJb1z0/ilbT3JG7OWmKfcMpCJFJ2CP6qYEa6vUxd7gUUmEvmoVhfI0YYhOccp0i45MOs+Y9mIODnaWoVfmU+635JhWXFOgafglG7xWoFxeKBLilwrvNm8wwtC3iVPuOLibBtp+pMzs/YvNrZe8Yza/jtXYvZ4tIaofJ0El/CEBOrU
 1ujAGgF9
 8lrx+oZzp2SDzhfxAuAXsUxu+EIzV+pbRmmUyEgH6zMS7GKViHhGdRXDkvSCZ6Cz5pRXSCHptYtklOz0ubaKIooir1e81ryDshRMdOr6tc/FTq1xbnw2OBS09J3tdm3pQIJhmuGVU0O5EOBPONn2zpFrQixq8ySkIktBZx1PMlUU9wwXx2DwhYK/Cb+tgDVc0UIA1YFA3NdX4rEckks3jhanALsBc7i5QV7TUlK3mYCQCjNiegyW3TAKAdbAqfOJ4i71R8G410CHQjhckNiEOm2/ZFFdESIzsv78sKO9ad9uSVgpHXSc/oK6SxJ9ZG/KoZFBQlTsxZ6DehrAAV2A9EVe4gWAxkdU5gifAoBgdrpIFje2m6csNtFktdt9w7J1cN4ui+UKprwlcia0PGEPaBBWWTMRqdYgdYmUQzBoaQ67fj8H4M2/OYMyVEKNKavcTlHv050EVqS8G/KA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Command name has been restrict to only 16 bytes, which is too limiting,
specially when debugging and tracing complex software with thousands of
threads and the need to differentiate them.

Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
long names for userspace threads as well.

To avoid buffer overflows, cap all existing userspace APIs to
TASK_COMM_LEN, and leave the full extended name for a new interface.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes from v5:
 - Fix blktrace buffer size
 - Fix i915 buffer size
---
 drivers/gpu/drm/i915/display/intel_display_driver.c |  4 ++--
 drivers/gpu/drm/i915/gem/i915_gem_context.c         |  4 ++--
 fs/proc/array.c                                     |  2 +-
 include/linux/sched.h                               |  5 +++--
 kernel/sys.c                                        | 10 +++++-----
 kernel/trace/blktrace.c                             |  6 ++++--
 6 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
index 70d112fd4287..e2b19b064722 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -435,8 +435,8 @@ void intel_display_driver_resume_access(struct intel_display *display)
  */
 bool intel_display_driver_check_access(struct intel_display *display)
 {
-	char current_task[TASK_COMM_LEN + 16];
-	char allowed_task[TASK_COMM_LEN + 16] = "none";
+	char current_task[TASK_COMM_EXT_LEN + 16];
+	char allowed_task[TASK_COMM_EXT_LEN + 16] = "none";
 
 	if (display->access.any_task_allowed ||
 	    display->access.allowed_task == current)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index c58ffa5a8fa6..b62b82c6de04 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1730,8 +1730,8 @@ static void gem_context_register(struct i915_gem_context *ctx,
 	ctx->pid = get_task_pid(current, PIDTYPE_PID);
 	ctx->client = i915_drm_client_get(fpriv->client);
 
-	snprintf(ctx->name, sizeof(ctx->name), "%s[%d]",
-		 current->comm, pid_nr(ctx->pid));
+	snprintf(ctx->name, sizeof(ctx->name), "%.*s[%d]",
+		 TASK_COMM_LEN - 1, current->comm, pid_nr(ctx->pid));
 
 	spin_lock(&ctx->client->ctx_lock);
 	list_add_tail_rcu(&ctx->client_link, &ctx->client->ctx_list);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 8ebb7cf1a7b0..0d70b21c803c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		strscpy_pad(tcomm, p->comm);
+		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ba2040566424..c4e0104e7ae9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1187,7 +1188,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -2042,7 +2043,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
 {
 	const char *_src = tsk->comm;
-	size_t _len = min(len, TASK_COMM_LEN);
+	size_t _len = min(len, TASK_COMM_EXT_LEN);
 
 	if (!_len)
 		return;
diff --git a/kernel/sys.c b/kernel/sys.c
index 97df708c11a0..5ebd3c1dfddf 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[sizeof(me->comm)];
+	unsigned char comm[TASK_COMM_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = -EINVAL;
 		break;
 	case PR_SET_NAME:
-		comm[sizeof(me->comm) - 1] = 0;
+		comm[TASK_COMM_LEN - 1] = 0;
 		if (strncpy_from_user(comm, (char __user *)arg2,
-				      sizeof(me->comm) - 1) < 0)
+				      TASK_COMM_LEN - 1) < 0)
 			return -EFAULT;
 		set_task_comm(me, comm);
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		strscpy_pad(comm, me->comm);
-		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
+		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
 	case PR_GET_ENDIAN:
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8cd2520b4c99..edc1377c3e3c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -214,12 +214,14 @@ static void trace_note_tsk(struct task_struct *tsk)
 {
 	unsigned long flags;
 	struct blk_trace *bt;
+	char comm[TASK_COMM_LEN];
 
 	tsk->btrace_seq = blktrace_seq;
 	raw_spin_lock_irqsave(&running_trace_lock, flags);
 	list_for_each_entry(bt, &running_trace_list, running_list) {
-		trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm,
-			   sizeof(tsk->comm), 0);
+		strscpy_pad(comm, tsk->comm);
+		trace_note(bt, tsk->pid, BLK_TN_PROCESS, comm,
+			   sizeof(comm), 0);
 	}
 	raw_spin_unlock_irqrestore(&running_trace_lock, flags);
 }

-- 
2.55.0



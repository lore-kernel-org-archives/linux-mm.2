Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0AAC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D816B0098; Fri, 11 Sep 2026 21:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF446B0099; Fri, 11 Sep 2026 21:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B776B009B; Fri, 11 Sep 2026 21:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B539F6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:24:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB50A1A03F4
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:52 +0000 (UTC)
X-FDA: 85203366024.24.E26C58C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3225A80005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="BK/GL7eD";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf02.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MfA022lMI6eopMpnYm97azulYzjdx+Jco4w94leDiw=;
	b=W0dvNmtt5gQp63xhP2r4slnDLZlxQBOxOYH2W0aderFTxY4IjIpH7xvPYQqNnJpBjkCAt5
	T+d/Hv6fbLE1Fv3FkNuP0sIY05F3Y25l8CCpkhzOuu8HJthn9yoUidX2u5jLXxIg7uLwKd
	WOpQoHM+A11qFueWsJETbOAZbmd31mA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176291;
	b=p5/H5q1Ee22/rBP26uVZ5ZnRja8rjhfyQ4Y1pQF7b9GuRvsDlwp/h04uVPxnAITGKEZmcE
	g3BLLh+MBnfxoNWuBuKR5v8qI2feP6aF5qcOS8Rhf/vw1GhDHZc/cEW6qCFXvbuxo1RTUu
	Ddt0OrhOv+a7TEUuiFnF46ByagCXXxI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="BK/GL7eD";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf02.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=1MfA022lMI6eopMpnYm97azulYzjdx+Jco4w94leDiw=; b=BK/GL7eD55uDTKsAow65LWzn6a
	XmUybhNhEKTSQfQiHaDzYluqMs125itTSVMDmTe4MZNORS3pDsjgWmoWWxmjzhW0anYFg91p0u0GZ
	O03UrpFPRpZMT3jhZUlL3LIJq1jGPABk4/oo//jF1K9/ogbaZJtQtW7JlTuURB0EjI2WFP0D9mCxi
	VeEI0NaS/jgQLSE1AErdw6bA+4j0sCd08Wx+0S2uQJ0LFrBa11V9NuVGDQYACC8QJZ9dsskd7LeLO
	3+F6ZnkBMl41pF4FPt/dez8r29mO9c/1F6NDHwKTVgTngYJxQ6bStUUiitf8YYbZsVmYNHu9VXRXF
	3aG4oACg==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CTu-000xjI-FN; Sat, 12 Sep 2026 03:24:38 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:24:01 -0300
Subject: [PATCH v7 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-4-34e1ee1564ae@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3225A80005
X-Stat-Signature: 6xj18ixq8w7wadu75aokach8awqr19hu
X-HE-Tag: 1789176291-635777
X-HE-Meta: U2FsdGVkX19T0IF8goqXfZAVhkVs9/3sKC1iacLuxg55RuNqK+lU/FoNKEAdejQI0gd4LVX+aC5IAW+cfXPISWFefDKPnfJwKZBjjrDv/R8OEAUNFdI+788SObSl+v6Qm3kgA7jVwF3Fq65nPqR+jWNZ9uxmQJxDMFEOce9kNpLlLaHcBA7akBqtMb3+yvPe1DjcsYbZWxjy+dog9DS2TvIS3SPNio2eYo4uVe9yX1NziKXayKzuu5rGtuAhZVn23kw/oHC0eb9BYZ2HP5SfwLUFhMkmHda9l6tgBbCbE8wCig9pCx1r47aREpVwiirxcjNmIv5LxuuQtRYJBdGpNSfND8+Xn4Q6qu7czdXoQa+zIEXWFJo5snN099KU/KmzReuDyE1YedccBIvQV2TbVcjNv2av1wBx0HOz72mAt7aJO6yHxCnV4X8wl0pbn7d66AZx0OtP+4X7nWPdTthWGxf/aqZ0Wie2RTmsQHBRqw8ze9taBEEUhaGs/wgn7P2F1d2kbdkrxLtvH6BF8qaO1ixkKPYO+HCXIcUxnctihzGzATgJ4NuFEGpM2VvCitjsje/f4CkQ+8ouK7hg62QDgxmoVW2Uc49HstcuX664KKXaaGAsHRjLF0Q0eX2hywBZE/OIEzoWmzDa6TUHtEx0AwSE2KHHWFpl2QH3f17sdg+abwZkylqmbekVOO0JGdhchmPngL61hLb69w/0fPSevklJ8FAvhfdDhf3xCYCN5opAZbwF5eo6uytFyfa5FcnO+Fw9QOYY9t68n3fOFt/SGEs9ni38eNVM+ht4qvLdwwYJDVDhUzAoY2K/5M/HtEuJ0fj/e9F/S8ivpSmfUbWKQKplKZQAGXfakyaed40ficRbDx3OTm3mgcMalmC2SAMJaXFkSTkCO2yg3QC1i/PDauqFQpnmLfEsJ2Qk6e8N8kN8kbceLsKv0gqR2B28iMHPtUVZaXa/BojdzE35RUD
 vWKa+uj/
 LJs3gklJgt5NXhYuaNKDeSRvDupwS/YpopvRrMhR0ncCqNrdX19qssnFTGWihAqqG6nAZs9kcVLQqsYirEKceeFzfNe9x+8E4Ckdnz8Z19GtEiyvovG6ICYg0DYCNgwBvB9inuUhbZnU0bXFizXoHgzlK/ZPEDxtU6ZrcJfXeP11Z6vVkNdYYHpxAirfbdEL6QIIXOJT3+5oJ2t1+qBBBMU4b7fAIu7hKPT+p+Wp5qvzaJYqE8G0AMCRGpvqLIKYgclk7farK81Dsbo1SfT/C2mskWjauWvYIuT27tVItJ0EyyPKIN15HyINgC8MT7ZtDutOYPN+EiU+VI7PZCJ8+uWaQn1UpeOsHWFFqdzWyF1W6/M5zCVst3yNY4YaY+nYyqsjudzVvYgjdblqFAcUQGfr1o5c/JI4mQH+Q4ClMQjjexpH3udmGUCzQMTiCFIBE3JO8CVXRQGB+yDk=
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



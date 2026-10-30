Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7066C60A2603
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=gOZPcHBA
Received: by kanga.kvack.org (Postfix)
	id 15E146B05C3; Fri, 30 Oct 2026 17:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136E16B05C4; Fri, 30 Oct 2026 17:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024276B05C5; Fri, 30 Oct 2026 17:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDC466B05C3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:39:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 602BCA851F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:20 +0000 (UTC)
X-FDA: 85380608880.29.CD6A1B8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id B128C120002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=gOZPcHBA;
	spf=pass (imf29.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396358;
	b=mIyX7CNNINvlo/PZf4wQBvu7MokBCKolKnYn0ymn0GX5gH+X8CD8HWiI2dm8n5VoB3QhS8
	OVkz6OOfQCCXEIDzhRmViJnRd+6biK5H+OEZNk7EwCXttbbeO6YYgGNFhKzQJnIhOvt1dQ
	VU1il2JA8PHz3fOlnFL0KHu1RCJPqXk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=gOZPcHBA;
	spf=pass (imf29.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL0oajrIor40Tumyg9DVNT4+Fp/oWhQLNDdG08AQUCA=;
	b=LTVYm6LNgt9kj+kBBFZwaEkfhDBq5GIc9kq1OJ3hwKbiUwjzDCBkaDhSr3+4gX0NKeeE88
	n2Hfshkoyp3ZAAtFJqslDdhJCGmtEWPWrzgyOiztjst1eOveATlIlePd1D1OlHJrHu8MA4
	hvvVCLN/YafLlVNARAs4zw9B3Q5+DQs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=XL0oajrIor40Tumyg9DVNT4+Fp/oWhQLNDdG08AQUCA=; b=gOZPcHBAlTsFSP+yRPhkcV8HY2
	bOdIPRqoZYeEeC0AGJgeM8c+8e9tRrvJTfbDRSLwi6uLQqANWIBNuGx3K/HmWegj2Ko4NN/sbi9p1
	InJ14TbY7rVi13VNyAqjV89W/qHdDTxnYNf6fePDSUX8VA+aAB24c7QvMaalP2jzvWkBu6zmw7iG4
	temkDyMpkdDMSUvsu3Jj17IwHF7PliscVxW1LZ6LbG6pybbktNJ3kPBJwVewhpuqrz9jDOgu3L5FP
	3efdzA72ixtz0nX+gnwdbsElYusQbJ1Tp8oRYy2AeWNAhmWRUEIF9mbZva0W8WosyzxGtzydMCnMc
	Bz7Se7tA==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJU-00FNmU-EA; Fri, 30 Oct 2026 22:39:04 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:35 -0300
Subject: [PATCH v8 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: B128C120002
X-Stat-Signature: xsiswrr1edznbp8fn3tarjcf11enscuu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396358-10739
X-HE-Meta: U2FsdGVkX19005jwSuU+Y4cliDUUPbCNJ7lKCbZy20uE8mB7Rf6u2h9fEHwkpLVewkXlTor1WkKkiq47uUEwsuCN+T4gmoZs6w+nyR0JIZycRBsoECrBUAk6KGb2hdOy4Zks1ozHknBLY5Q+zqEyFn8I1F8MP2x69VBoyDdp3ADQJt8yguk2JTVCnqicZOI6/8u4MhlIH+oRAZsciExDGYT/2yq1F+5eKg6oS9A7SvHfoQo+7uAdU9R/e5sk40t7BLLYvo8iOmbA7lMgsbMICmGVYk28XUJHCyH7Y62Txz/qdcVMG9oDRhhyJfiFJ+cGZX97epdfcSLFGUsjWnXjD3bhpLzIeYqtCZl8HCKUm4PNecVIzhHiFiaxz+UGsXC7l6riXNr08Q0RhKIBMfzaLIKzNFHfjCIHLlnMz6cgG8Yban+SCTpNbaRdNqjJsPbWNgnyLTxALjFgpiFZOtYOscaGDqb9vpbv4xqf7uJNFzVNyPV71NxwmKzTJVYSDPwZPgLohfVmHvN53uaRFvHdQwCcX+1zp/oswiZHj0hwprZtmvCFjMXtvgsltagSqQ2+c36mElXoF0SL1NvX3+fjWxjaed7UrJRL56UUIfboZTD6jqwFyTTVoDi9t8uyABwIq/sQv5/mPUYl5JVxVAw9BYw8JbV8229nU7/jd/HbErkyEwthjmbj0eSb3CnDRH4xuX5kshQ+5T0zEnCaJ0aLYCEySnVze+7byNIoD0nq45NFh/HZSNNirzwPpLMOvE3ovgjQEQsdseJxgm0MuocRh0Z33ETXJnCtbCMcLCLmMAAwodQ0J1l5EKiA4q4e3GSODnEX1xrKDBWrFmXHNqyvZRgc3ow7KAwoI+sGZj0c4EkQf2zMqChsg1erISN17WjlZxKCXeHOnKNaP4ZTpypsWIgf9jivXxzqHryPJkTF8h/8+qdlfBKItgN2GCplno7U1vbcTUCi8FK8CVZ61BV
 peBYEadt
 Ii/kuthIn+WHWaM4j/LYzY7WJYclJb1SFf5fNbB0EuwzCC0M05NZJC3R47QE+K3RHatWhO93S54tx491GGREqb/VrIM694hE5M6MD6+GFcRQabxjFq2wqPknaarPi4Pa/fmyxU5HOZG2FWwIeLq6tIINi5QAVFUrAeHOx7UXPrMvXPrJ5LRhxCcWYJGcIRd+T3yFyFKsK+AM6EWZ3Ry8mGDHjgpoeYEBN1a0oQwfDWDY3dUTfNOmnMNOkHCbDW2aKJuFMeAMVX5P+mp2ItMM22p69jzO362qShs9EMAZibGxKqhUTcsfm3e8oFL4DQLbuYOaZC5tKcnTvBqVx/hsBDfZL/mrrskc6jaQBZzTbcUIPaeN5p1q+dGuEgHDkUjHSWyJO9Hxo11YXjPije1chI939sgd9kdf/3/jsFnz6X54R1YDFW/hU8ONRQz/WR0osX7eBPN92oJyGcqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Command name has been restrict to only 16 bytes, which is too limiting,
specially when debugging and tracing complex software with thousands of
threads and the need to differentiate them.

Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
long names for userspace threads as well.

To avoid buffer overflows, cap all existing userspace APIs to
TASK_COMM_LEN, and leave the full extended name for a new interface.

Callers of set_task_comm() are responsible of having a valid string in
their argument buffers. A caller of set_task_comm() that passes a string
shorter than TASK_COMM_EXT_LEN without a null terminator will cause a
out-of-bounds read in set_task_comm().

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
index 204810a11e46..005c49902259 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -436,8 +436,8 @@ void intel_display_driver_resume_access(struct intel_display *display)
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
index db529a93525d..5e02bce749b8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1192,7 +1193,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -2048,7 +2049,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
 {
 	const char *_src = tsk->comm;
-	size_t _len = min(len, TASK_COMM_LEN);
+	size_t _len = min(len, TASK_COMM_EXT_LEN);
 
 	if (!_len)
 		return;
diff --git a/kernel/sys.c b/kernel/sys.c
index 31eef656dbd6..6a72c7e644e7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2538,7 +2538,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[sizeof(me->comm)];
+	unsigned char comm[TASK_COMM_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2604,16 +2604,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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
2.56.0



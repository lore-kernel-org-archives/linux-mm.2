Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5F6C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186B86B00AB; Tue, 15 Sep 2026 07:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15EE26B00AC; Tue, 15 Sep 2026 07:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D4C6B00AD; Tue, 15 Sep 2026 07:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9FC26B00AB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 668D1803C3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:18 +0000 (UTC)
X-FDA: 85215785676.02.5E4F937
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0D6310000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahFaO1Ef;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxC9gcnyDcUdFgs3BFwtpBJTgH6vRdY/SXD7WnErgiA=;
	b=U49w/MN6sRijat7QF3uQ8zOU4jbFZTK0FJ4UKJyurGDCuYJ373Nc9wwuC92Q6Kmx2pFS1A
	KKu8wvpAkc1sqO5LUumVmERhTV7NUoY9yFwP/haTVtBnLirvSG45NGmlVclerlBAQK6gyt
	JCVhAHuYjyejRdBiCSBNkvj5eKJuEGw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahFaO1Ef;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471996;
	b=xUqQ2V1vm/8DYKJ39u6PkVmVcRVi2C9P49qBKflERkCy6sxuSIGu/oLCGcAqDBp+3RhIgg
	bkgvlKdsq/EoDmYpMUxwJMnm2xpGcn4hIb9XAARuNq4yxrvI1mKJDS8SuC6C8T0ZUeyKl3
	BKJiZmDAbVN0eGqkhWBB0zpvyflSDpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CC03600D1;
	Tue, 15 Sep 2026 11:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C925A1F000FF;
	Tue, 15 Sep 2026 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471996;
	bh=kxC9gcnyDcUdFgs3BFwtpBJTgH6vRdY/SXD7WnErgiA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ahFaO1Ef44833cAg/ipYrlljR/L9kqnoccr/DtSi2ZpktkAECstbBuUB4GsshEh2o
	 37/q8m87cD/I7tX9ntbegeSKXsEeXv4Fw9pAQ1PmC8L6I9T3UsC/XkGoMHM498NGhQ
	 FxRqxgdQFODLQ/81upkVsZx/cPJJi/WMcnG+dRajxR0jt8M9VdkFbun0aNVMyEwUQ5
	 XtHO0iVATJ50fn1gpeGdm9Z7iWnBGgBM5hv58to7WQYb3XmbmM+8rmfsCFxIh4aLfu
	 N9c2Ol8XHEuDPz5itF2eetj1K0aBSEdfHdO3T/ovrf08suZa/vYreTr9DEievxGy1D
	 i2Yzc/LALmn9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:01 +0200
Subject: [PATCH RFC POC 15/50] sh: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-15-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3805; i=brauner@kernel.org;
 h=from:subject:message-id; bh=D2omDG7mr0KTxlJ4GQ7QAZA4OxsIde5l5dfPMzqmPuo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KnNWsrlUHjqoaue3sF7yYL+Gfs/u112TbkevtDom
 Y/vkpZJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZeo2R4c+KV9OZba12svrO
 2S4zjzHAJMO9lPWUn8uRKZu3i0VMOM3I8DSgLigic8O6rYs7ON2+9ysf4gu88um/5/1vyUeDwxn
 92QA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: 376fhyfpby6hfuu9jtnpry9b7unfewr3
X-Rspamd-Queue-Id: B0D6310000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789471996-763027
X-HE-Meta: U2FsdGVkX1/LIpqWbMxw7MNoR74sd7S3Ou/i0Da78asrdE9XMevKbL1j2JVP5anbxOjsOgyXiIc+qtmLje8LUo26+9lITcBCoFp5XXzYo3i3EJ9Nf1NN8N42aSDIwkc2bwQVmpakI52+j1Z2T9NMOYQzs3Z6PjcWAnITLb3Ac8eEcYuL4vTliiLikAXrsJahAf44bz3uqANqgU9POk51xUt840n8J8wMKlqhqoQ924eMp70pH/NMwXguPUw129/gv7GBlGsfHAmmJcdP0/fiPODaq0h+c/wLbuCOkAjI47Gaq/fxawutt9PUVYn6yF00PFJEiyknvtCFvq5d3BCCL7IMtWZ/jIRDj9Ie/0t9//izCghzt4oKzAvIQ6inI275RNEeU9B6EiENLZyc7Qoif/ARLOYhU/I2KdtwdrcW+N4Y55Cx7zhPlDwrw2yL/7PBqGrPpcSXL6tXGqHoHdUn+NyKW0p6oq2WexR3yGe0UL7+iCmKrF9a3HLldk+0wHMRox423pb12DKSi8adK8I4wnWY0ElRDWHyx0utWsiM9r6Xx9pAVHizGEwOjifb1XnOvTL5aF1Cvn14JOfT7jg6OFOyQY5YGpKq5oMVUvvwVqxNi4CDx4fEBTQr0ddbrQUgPtLCOEkjJu+3Foi+U2Tia6i/CmFRuF0j32y92IiK4qO1hupEYeVwVFC+NNMkA641Gy65TEzD6zf0CEX7wZt4+npyutbjHYFZwxzos+dNaKrUmV6dtRDDayeWqVB5wLYtK4kmPonKyCY7eGKqUTIx40uy7SDHaSs31mMrOY9yEhOrIGZlw1RQfK5RFn33win8m98Ix4r7fqLwt2SnvuFqspACk/drn6buoyvdixb5YutdRzLv+D8wT2YblgakpKz1paqChuazxyGXXMx8GKClMLrZKO0Nc7xbDACONgW3Inv4lLnjkTmtxcCUMlxaiuCqAxfi8lHuSFHLHHekBcF
 YaehGm7c
 6b/IFuDH7jMJxcraADOh4Zs9uru1vpRegHc8eRJTei9DdKzyiWGupxvDBY3jkGrr5OB0AwDu0xuog1ua4WYSMXaJHcTEc8u/zDfiH3f6HYgk7pl82CKskxa/8L/XE+C32ZX1lPx/QVulF69tN5n0jL0I+rw2yJaa4E69L3lpX5LQCBoN6/wbTlGG966LMbOHAdGEJw5BFlJGRnokH/45fw0A8WPWLL4/UHvRXKIWdlWEyZYpTA8JJe0Fz3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS to the syscall work mask. syscall_exit rereads the
flags after the system call and goes to syscall_exit_work for any bit
in the all-work mask, but hands over a copy shifted right by eight
when the bit was in the upper byte. Reload the flags there and test
the full mask, so that the bit reaches do_syscall_trace_leave().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/sh/include/asm/thread_info.h | 10 +++++++---
 arch/sh/kernel/entry-common.S     |  8 ++++++--
 arch/sh/kernel/ptrace_32.c        |  4 ++++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 471db5173036..d976cf21f346 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -106,6 +106,7 @@ extern void init_thread_xstate(void);
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
 #define TIF_SYSCALL_TRACEPOINT	8	/* for ftrace syscall instrumentation */
+#define TIF_FD_SLOTS		9	/* syscall prepared descriptors */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 
@@ -118,22 +119,25 @@ extern void init_thread_xstate(void);
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 
 /* work to do in syscall trace */
 #define _TIF_WORK_SYSCALL_MASK	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
 				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP    | \
-				 _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SYSCALL_TRACEPOINT | _TIF_FD_SLOTS)
 
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
 				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
 				 _TIF_SINGLESTEP    | _TIF_NOTIFY_RESUME   | \
-				 _TIF_SYSCALL_TRACEPOINT | _TIF_NOTIFY_SIGNAL)
+				 _TIF_SYSCALL_TRACEPOINT | _TIF_NOTIFY_SIGNAL | \
+				 _TIF_FD_SLOTS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
-				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
+				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP | \
+				 _TIF_FD_SLOTS))
 
 /*
  * Thread-synchronous status.
diff --git a/arch/sh/kernel/entry-common.S b/arch/sh/kernel/entry-common.S
index 91ab2607a1ff..593a482e85f5 100644
--- a/arch/sh/kernel/entry-common.S
+++ b/arch/sh/kernel/entry-common.S
@@ -164,9 +164,13 @@ work_resched:
 
 	.align	2
 syscall_exit_work:
-	! r0: current_thread_info->flags
 	! r8: current_thread_info
-	tst	#(_TIF_WORK_SYSCALL_MASK & 0xff), r0
+	mov.l	@(TI_FLAGS,r8), r0		! current_thread_info->flags
+	mov	#(_TIF_WORK_SYSCALL_MASK & 0xff), r1
+	mov	#(_TIF_WORK_SYSCALL_MASK >> 8), r2
+	shll8	r2
+	or	r2, r1
+	tst	r1, r0
 	bt/s	work_pending
 	 tst	#_TIF_NEED_RESCHED, r0
 	TRACE_IRQS_ON
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 8794081483fb..3deadd71f464 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -8,6 +8,7 @@
  * Audit support by Yuichi Nakamura <ynakam@hitachisoft.jp>
  */
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/mm.h>
@@ -476,6 +477,9 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 {
 	int step;
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))

-- 
2.53.0



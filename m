Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C529C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 778F96B00AC; Tue, 15 Sep 2026 07:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7544A6B00AE; Tue, 15 Sep 2026 07:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DE66B00AC; Tue, 15 Sep 2026 07:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E05176B00AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00B0D1203E0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:25 +0000 (UTC)
X-FDA: 85215786012.12.84E2A2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 48D6C40008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3o4Ofqw;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pDTYibtotoJl0CfBpt6utVDR2mfl4I4vpQdvs8YOz4=;
	b=kilZrTQoo2fsPc3O7cITItxRGN1uRat/zg//alM0Bb0+YIhC1taxG7FhllR8s4LzhmngPR
	1cqh59O7i2lG6lm9vZ6oJOZGQX6PiwibtOJ5OFYVqMQ6seZnloPeqmI1Uqm3O98TGgBn4y
	wGLD6xhXwy6j2ukCiJkdUKX4vox3Hgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472004;
	b=evmsvn0jqLfJIVA2IgphLteHJhggrz6lgC9ufjIJZxGUXJgUiT3hYgfXM3QRl8PBTSVTuD
	jRvuuq+I/9GfuTZHVxLjPXyzco4DQrtYvhc3BevufyGngbZvPS022fx33dR+NtW2jWYskO
	T7uxFfzICsQt9fRnAO/74g7+oJsOcHY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3o4Ofqw;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7EE2602C4;
	Tue, 15 Sep 2026 11:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E0B1F00893;
	Tue, 15 Sep 2026 11:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472003;
	bh=5pDTYibtotoJl0CfBpt6utVDR2mfl4I4vpQdvs8YOz4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b3o4OfqwaaazxAeRj/9Gk+rfkrUg7U0vI6JKs41UHHO10m4El4MPR0Sa+EE2Gn36Z
	 JbZmIMb8qLAtadMRwVadqK0bIP8UDUY4u9lCU6f1ugKbhwheYaNkZU/jT+i4Dv1Jl9
	 iSky0rNqGXpj8pMhwujZIwbQHG7ClelfVDOe+So8VfCSthJENcXqjh0059JfLailqW
	 emN+KAXu8UUFnpvYfDn0atcumjm+ShG8MC7FrqvcAxOpAeul4vea+zYnk6otK0pmNa
	 VCFcB52eVERu7FbBBcw9uj72b8Lk1KHXA5mpSreLxYJMokQq6XzH3u5VGfdEMuIA0u
	 VKtgipEWo0wug==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:02 +0200
Subject: [PATCH RFC POC 16/50] sparc: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-16-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6251; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pmbItuaGjYhqGPqyFZ/vQ3bw6O4Agi1po5EvnXuKgAA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmNrfkT+/ZOoMD81otBR7+qPEnjKjXl+DDvernoB
 8aVLipdHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPRrmH4Z/WrKjlPiWfpjeMh
 +/UOr9OUYuVN+MrcGf8r+7t7cIlFMyPD/eNVJ7U/2tpNS1Kb+nTNq0L7h/NS/upwScjx8VlbzD3
 GAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48D6C40008
X-Stat-Signature: risjnhoqpunyxz7zd8c44zrck3zhotzf
X-Rspam-User: 
X-HE-Tag: 1789472004-126386
X-HE-Meta: U2FsdGVkX18l4NEf6Z/nuZ+uLqRvAiW1ahl1w+EpuuDEPpDclSV+gjdfD2LtEO54kSUhiVPaj8h6yEK10xYoC1Zsn7DjyzANDU/x7PhN1zLj41mjlnW7lgmsFqoe8TBAl9vwSa/WKLNpLc4NNMHWm7+FA+ZLrUhd4DnUHQ6gNdzfThmQIz9aSpwqasRFBy4Z7c6ircsoQrRYMTZ7SkFOBm1J/jvSFyr5t4711vo4GGglhImF0aiq+A+dY1khbCYNsItJcVx6rwBj2zKacUcXrj5pr1qWRnACVHkrrr7ZwcBw28C2unQItprsWs0IYvklpMIp5Bdbt5lXfd268y+bjwZLJYGd/IfJ5PQOFjkJiEArX6wA4Pc0iYAJWb1EdAz8hN29Acp0JGagjU2ABiT6QBdaH/fUC1QICDZAS01+6kFgb9dACcYnZnn09YVDGmWQXfUcK+IWfztBUYTb8lnFldZpk8DuSYfICoq/FOYEXBIJ4WHrvCcdsq9OzFpd6+0ZaTjXb+JCbaBcIS5+uy3UuyestPJ36B45llDFZxeg3GD5I2VAY6jU5IkY4t06Ax8qcFQGaQ3IW5Ithy3WJXV3KVUfq8jBX4hx/JXKzB+UYDxKQ+ZnU7vGl/jmopZgIIM+CPgKwzwUfteR9g5Ezj/neoIP1EZQuZmSw8yrSJCv2CYMLTe1TElyTBE+ZuNCGeDsLdQex1AgOWAnjwuWfO5JH/aZzlKx9muGMAt/OZKqBdmiHzM+8/0oGjBCM+boTy4ns6MFbL3NP0XJM6l5ne+4z9h93Vt1NbDFk8EhTJz4tV3Rj9h5YFjvhBk0nSC3p/Y8HBJWdvUKxPXyzAaP5sZI1JLswfEqo46odXtNqu333rBJYVYYYyVs04IgEId8oMk8FOw0Ob+wPuqTYIq9vOYJ3jmjf1IlOk51XamNXl/iwcV+aSYlklVH/1Yif7doqma+ZAOZzmZxRXdTb4Bva25
 tL9n11+h
 4MadS7kQYGsCZLF4UR8panr/2n5dwZPnEkSqWRxhP4+HUzXJRGZQoT7APUHiFO2N2WXvNS7uilzSiQPDCLR/2E2fHfGxkMh2olUrAvvHyh/RynQGUy8e1MeHTZutrsbQHluLpoTNiLmtKqjdZ+f7um4LcnJJAA875Jrb+9gh2vvTaeB8f1iBTj9i0GG2nns63vOQk7A3sDUCvzqRVLTKFtYzx5A1xDtM1D3nQ43P1pKD6oCnJfcZl9qCpoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it together with the other syscall exit
work on the way out of a system call. A task that reserved
descriptors calls syscall_trace() on sparc32 and syscall_trace_leave()
on sparc64.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/sparc/include/asm/thread_info_32.h | 2 ++
 arch/sparc/include/asm/thread_info_64.h | 9 ++++++++-
 arch/sparc/kernel/entry.S               | 2 +-
 arch/sparc/kernel/ptrace_32.c           | 4 ++++
 arch/sparc/kernel/ptrace_64.c           | 4 ++++
 arch/sparc/kernel/syscalls.S            | 4 +++-
 6 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index fdaf7b171e0a..fbd7af6bb427 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -105,6 +105,7 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
+#define TIF_FD_SLOTS		6	/* syscall prepared descriptors */
 #define TIF_USEDFPU		8	/* FPU was used by this task
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
@@ -117,6 +118,7 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index c8a73dff27f8..890ee65d9029 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -180,7 +180,7 @@ extern struct thread_info *current_thread_info(void);
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_NOTIFY_SIGNAL	4	/* signal notifications exist */
-#define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
+#define TIF_FD_SLOTS		5	/* syscall prepared descriptors */
 #define TIF_UPROBE		6	/* breakpointed or singlestepped */
 #define TIF_32BIT		7	/* 32-bit binary */
 #define TIF_NOHZ		8	/* in adaptive nohz mode */
@@ -194,12 +194,14 @@ extern struct thread_info *current_thread_info(void);
 #define TIF_MCDPER		12	/* Precise MCD exception */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	14
+#define TIF_UNALIGNED		15	/* allowed to do unaligned accesses */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
 #define _TIF_UPROBE		(1<<TIF_UPROBE)
 #define _TIF_32BIT		(1<<TIF_32BIT)
@@ -209,6 +211,11 @@ extern struct thread_info *current_thread_info(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
+/* work to do in syscall_trace_leave() */
+#define _TIF_SYSCALL_EXIT_WORK	(_TIF_SYSCALL_TRACE | _TIF_SECCOMP | \
+				 _TIF_SYSCALL_AUDIT | _TIF_SYSCALL_TRACEPOINT | \
+				 _TIF_NOHZ | _TIF_FD_SLOTS)
+
 #define _TIF_USER_WORK_MASK	((0xff << TI_FLAG_WSAVED_SHIFT) | \
 				 _TIF_DO_NOTIFY_RESUME_MASK | \
 				 _TIF_NEED_RESCHED)
diff --git a/arch/sparc/kernel/entry.S b/arch/sparc/kernel/entry.S
index ea51ef52c952..d2023b84db9e 100644
--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -1023,7 +1023,7 @@ ret_sys_call:
 	ld	[%sp + STACKFRAME_SZ + PT_PSR], %g3
 	set	PSR_C, %g2
 	bgeu	1f
-	 andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	 andcc	%l5, (_TIF_SYSCALL_TRACE | _TIF_FD_SLOTS), %g0
 
 	/* System call success, clear Carry condition code. */
 	andn	%g3, %g2, %g3
diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index 5991b1731fee..042e60685418 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
@@ -437,6 +438,9 @@ asmlinkage int syscall_trace(struct pt_regs *regs, int syscall_exit_p)
 {
 	int ret = 0;
 
+	if (syscall_exit_p && test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
 		if (syscall_exit_p)
 			ptrace_report_syscall_exit(regs, 0);
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 825ddf55fece..499b30c505fd 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/mm.h>
@@ -1110,6 +1111,9 @@ asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 	if (test_thread_flag(TIF_NOHZ))
 		user_exit();
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 96fe8763d70c..086fb8eaf133 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -269,10 +269,12 @@ ret_sys_call:
 	ldx	[%sp + PTREGS_OFF + PT_V9_TSTATE], %g3
 	mov	%ulo(TSTATE_XCARRY | TSTATE_ICARRY), %g2
 	sllx	%g2, 32, %g2
+	/* Reload the flags, the syscall may have set TIF_FD_SLOTS. */
+	ldx	[%g6 + TI_FLAGS], %l0
 
 	cmp	%o0, -ERESTART_RESTARTBLOCK
 	bgeu,pn	%xcc, 1f
-	 andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT|_TIF_NOHZ), %g0
+	 andcc	%l0, _TIF_SYSCALL_EXIT_WORK, %g0
 	ldx	[%sp + PTREGS_OFF + PT_V9_TNPC], %l1 ! pc = npc
 
 2:

-- 
2.53.0



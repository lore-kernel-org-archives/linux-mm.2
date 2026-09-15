Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4E7C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5C16B00A9; Tue, 15 Sep 2026 07:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E1B6B00AA; Tue, 15 Sep 2026 07:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93906B00AB; Tue, 15 Sep 2026 07:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B76496B00A9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DBFD1203B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:11 +0000 (UTC)
X-FDA: 85215785382.07.AF68E8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39F7D160007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIre7IPO;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6C1meFw3vaAeYs/vq+sJtwpKCB4NBzs9iQTrTMdIhys=;
	b=f0yoghHzb8imOwXgbUnokGDxy1+oZd849uX+yljudBNNxH7vq361NqjJqoWGPjIBEk0FNS
	SY+XnLDcixVKm92bUwXEGNgs2tDdeHELA5RFUt3ZY/CHjYC7rdnvZr2qxy7HOlCF5AUgyQ
	uG0cn0JXCOfCMCu//8HwVEuXgtHA+PE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIre7IPO;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471989;
	b=m1Hm6QMilMwyQrqYdLYn2E1nnHYKiF/WjcXfKl9cBVsjEBVbRQmQMWey11iTJe9YHtraSH
	MTZG3K/YwyT8xda6xXMJBG+/aujUPh2RCJ0cwROZsyfjtRWjqaQwPSZhklEDuopbWiYzjJ
	RqHHWNfSyDePweXsWaC1+3SAKiytqD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7255D43DFD;
	Tue, 15 Sep 2026 11:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365EA1F00893;
	Tue, 15 Sep 2026 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471988;
	bh=6C1meFw3vaAeYs/vq+sJtwpKCB4NBzs9iQTrTMdIhys=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FIre7IPObUwSzXf3O2sx48t2Z4H5e1F4uGdxGhRX7VJFjXC2A06It6HiWigcBBMAA
	 8Vra7vVQTvHialB8SqOPb2eU66kL4TJRssBUy55uhNbh7Fx5LNe7AZKu6GLyBUfsD6
	 gvQWFBQP1xhLlrZ1husySN/1kg49H9IBp7PQSW5R20QShWAwc1I1rkhE5a8gn/MPIL
	 K1rfYqLjcpreBV4aXozkph6wt+CPhATz8dRKVe/qhoxpxLlAiPlvfFlTEM17EJsySw
	 IAUl5j4U2w/1V7oWGu6C8lLy1GXU5KsBKij6oQvNp9K/WGJ/hy1wm8Um42Z4sZZvVR
	 5URNgqeCv80NA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:00 +0200
Subject: [PATCH RFC POC 14/50] parisc: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-14-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=u9Db1ViJfwYuzioCFI+Ic9SCMW7ME/y8i4wAOxFSJrA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kl9v0DgirDZt09b9j68fGdbuw7L0fhlLFrRRy8y8
 rKpH2YS7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIzTeGvxJCRtXLj2eFi4bc
 rj56m0FOYPZfpoLaW1crUibKsk2wd2Zk+BO9OoZ7Whbr1/StJ2JZ1nLsCE4I1fn9/7LOIUMGzZM
 FfAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: 89gb68rqu1aca643moupnb8o1p6f4rth
X-Rspamd-Queue-Id: 39F7D160007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789471989-604317
X-HE-Meta: U2FsdGVkX1/Ug5qmQ83p7x3U77vI+YGLKxYI7yY76BT16HU2o4l3oL8S0Nm30yiBtmN6/ZPIonY2pWYoI/H9sh7+/cZOSSqVpo7AKqx7Yg1X/FBHptmB9nNAW0zA8n/KtE1iq2cUkIVMmqBaOr28Y0GBShwC73DNMU7pEjMa2S+9Awfp2QcySTyCtYUmRG8Q4EnggabR1hDu3P80YdU6Bp8b3TpzNVt4iv0nxnAz64H2pgaJQwohcOVNs0nPMVlREi86YSxglBfnmtr/ueGjKyqRrb8A3VbDmrmu4zLqRBZJllCYiRdvUKy+fkn0ENM3rRkPDMm5s61Ac9gv7JiHoVnzH81EAQoNZXWy6mHp6w3v+QjOwXZpaWNzuDsOkSz8xjRYu6WMyTcSPjxGcXs8tzaG1sOoZpXooMQF4Q9CftGmDBYwaNB6z9ZiTuCoFoA9az4FYyo7f1fYX56Keg5gnyii+Y7Gx2KqA2MffEEy8XJ9As8/40LrxnARm/OlfPQKrJEOLuZC1eGCEM7CfAbBnmSkQpKjgQkKPWJ/XzpNiBRSOiaj86+4sVUm1bXq3pxM2Y5K54HcMFpF0/sN2ScR8gUkAXMW+OK+TqjwvVjzLRGFnj9eqQaATQNBeu4QB9Rbdnvs+Tm8jpdW/pv7hTwGNcONU0Hp4TsP6rr2vKt4oUZBxZGWAhN2dSoPC0QmEE2UM6dO4b08eMvrFvxSNBWFIevfNMp1Djarr6+a+YDmv0WnfUOUbZNn5s5HvcKmrYK2vOsddk0/E3lVYB7CsCG0NMQYMJyYnsyGUU5i8c8U2rJH/ePe8uRlU1tUtE5+EMb9qjU+b28RkMKXcu9+h8Hanq5cafSqqSUnb+y9UuExksTJv1BMkeDyvtJABPb730r7o8WfqHsJwnokvzpKlsxX1URjWt9FrZV4iQUBNarExGIIKeXUu40c4kFyZtBgxQwuAVsmJ8CWUtq95DNysyL
 YaMiE514
 pLGc7m+Cav3TECKx9rJu4CYrY+MIb4cXO9e81xGfP3AnnOIMQgb7Bi9d4RGaSte6mmzCFe+kaLb1nH9pLhIS2K0szkEhgO1u123D+oIgyHNqqaQXAgA3l7v4eRFd0E1ARYSc6i10YKl00DN/yuZ2Lag/pa3UBA7q1AHpf7V27Bw478rK7alJrlZzH1vY2iiBD+olnT5vp7eWfVJFmJm1PkFiS20ulKXKPEy3zW5tqIWgBDgRK4FIekR0OeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it in syscall_exit once the return value
has been saved to pt_regs. A task that reserved descriptors calls
do_syscall_trace_exit() and then continues with the usual reschedule and
signal checks. The traced path already ends up there.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/parisc/include/asm/thread_info.h |  2 ++
 arch/parisc/kernel/entry.S            | 12 ++++++++++++
 arch/parisc/kernel/ptrace.c           |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index b283738bb6da..14a40c53689f 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -52,6 +52,7 @@ struct thread_info {
 #define TIF_SECCOMP		11	/* secure computing */
 #define TIF_SYSCALL_TRACEPOINT	12	/* syscall tracepoint instrumentation */
 #define TIF_NONBLOCK_WARNING	13	/* warned about wrong O_NONBLOCK usage */
+#define TIF_FD_SLOTS		14	/* syscall prepared descriptors */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -65,6 +66,7 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | \
                                  _TIF_NEED_RESCHED | _TIF_NOTIFY_SIGNAL)
diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index e04c5d806c10..c5807cf6fbd8 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1732,6 +1732,8 @@ syscall_check_resched:
 	/* check for reschedule */
 	mfctl	%cr30,%r19
 	LDREG	TASK_TI_FLAGS(%r19),%r19	/* long */
+	/* descriptors reserved by the syscall are committed in do_syscall_trace_exit */
+	bb,<,n	%r19, 31-TIF_FD_SLOTS, syscall_do_fd_slots /* forward */
 	bb,<,n	%r19, 31-TIF_NEED_RESCHED, syscall_do_resched /* forward */
 
 	.import do_signal,code
@@ -1765,6 +1767,16 @@ syscall_do_signal:
 
 	b,n     syscall_check_sig
 
+syscall_do_fd_slots:
+	mfctl	%cr30,%r1
+#ifdef CONFIG_64BIT
+	ldo	-16(%r30),%r29			/* Reference param save area */
+#endif
+	ldo	TASK_REGS(%r1),%r26		/* struct pt_regs *regs */
+	BL	do_syscall_trace_exit,%r2
+	nop
+	b,n	syscall_check_resched
+
 syscall_restore:
 	mfctl	%cr30,%r1
 
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 1d9e210702e1..f142766792af 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -381,6 +382,9 @@ void do_syscall_trace_exit(struct pt_regs *regs)
 	int stepping = test_thread_flag(TIF_SINGLESTEP) ||
 		test_thread_flag(TIF_BLOCKSTEP);
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS

-- 
2.53.0



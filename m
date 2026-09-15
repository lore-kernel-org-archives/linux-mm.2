Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D530C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D956B00A6; Tue, 15 Sep 2026 07:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556D86B00A7; Tue, 15 Sep 2026 07:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D066B00A9; Tue, 15 Sep 2026 07:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23EFF6B00A6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67C4E1A03A8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:03 +0000 (UTC)
X-FDA: 85215785046.03.9C862D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8038C40006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lW4XDrSS;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieBZ+PGa/U2dHjvXYIOcBUNNdmn+mkwIOuOFCXOxPNU=;
	b=Ksv9us9V3X+QnL/FfAQCli8kUc7Mhe0T1w1Tq/OACQtVPkre5kBkcRKZiWTQ0m8gHl5cVt
	A+8f4lDmch0LRSz2swcRKt+gWjiWV7fU4hMjOQKvEV0Si95GDo/PeehrDPyOGiDXni/fZs
	/z1SFTkQ4q5MOSrqg+HaeSeisBBwhQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471981;
	b=P3xa7q4myZ+Quryc+O5aOVb6+6V6awJrhny8u/J+ItArVJ1jXbYXXqy1/dmtAtmKYbssvT
	Bj5etNkiiWYKgv24H7WKmFFLLy6Egmc+f8NlTIsX8gpinBrx2Q+SvbiXbsG+HvoDsaZRjo
	yDlznmXcUR26l5wp3PuVLBclgJxgjTM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lW4XDrSS;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4555415D0;
	Tue, 15 Sep 2026 11:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C55A1F000FF;
	Tue, 15 Sep 2026 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471980;
	bh=ieBZ+PGa/U2dHjvXYIOcBUNNdmn+mkwIOuOFCXOxPNU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lW4XDrSSE4zqGk0C0CruQFmX6so8N2FOL23Fl09c5bnPSxQl0BFCz51k8cI+0dFfJ
	 dXQThH7z1OdW1butHdlIf/Qob4isTZGHfU/nhc+unhvj37uVwPwqTZHeYk/FuGa0RN
	 aDMtnc4VxYzhvYriaex23gOScyvu/sWWOUrxEFEJ+nQmrms5SkE4/CUmg2GfphSCuj
	 JXVFYRknoQ6WmHDbHxR3xnX/Fm8hP0qkS8zTMO9w9Kxgckeg/VeZIeJThmFkiQBpT6
	 FVu61jYIIv6ceWPTvf1QMFe5gj978J8MMjetxPLjPfZjoZhoGLBPKY5OnkDnZixiDS
	 91SUSK7z6ECBg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:59 +0200
Subject: [PATCH RFC POC 13/50] openrisc: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-13-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3299; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WIP/DigF70AMhhxkwNBY6vdiLcTH+iv+tPMUDAZ9Ays=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kn9GjAhwFHx+sY/XeefqrdOfq2R3HC8f2v+1Q5lg
 UcXTzCZdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkAiMjw2k/PoanKkdD5bZf
 KxfaVXVqje/CGY+/+MbO+vL4QxvPmgRGhoe1GR3WZn18c8xOi7JUnRHY2W96ZGnXoxWdvoqFr4M
 SOQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 4r4ecczftnq7sunb3hmqck7nct59qi7c
X-Rspam-User: 
X-Rspamd-Queue-Id: 8038C40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789471981-695708
X-HE-Meta: U2FsdGVkX19oNJUQQdMI5fks7wxiL2j4WcnakGB4Jymg+TpJiEI+AavBAC1PbL0h7i7qHK6QnygyUiyagDhL8RmdRdwnHuWblve7vs5knWlw0ouXzrFmAr56NvusdbQYFwTwffHtaDxP88IoozY05FwzIkIN/CtV079ZICYW08qhu2TAOaOMYPYffKVQm6PqWspPwwd/SF1pXDXriKsH+4NQEtohsRL1AZVKiES8F6zTqb9T7NOOW9SFINDDAsitv39G8gqRG6jaa9tE7gmqxHRM2iEvH5CMqZAL0gmxUqiaJ7Z2DnE0im8GA7s1XycSSc2O1rtvze3uVDVqwEP1QZmbTsJPFvbJbMxjsqMPH6gLhkebyMGyB8hX7Vf4hhOlA5U5JPrMw8YGOQvNI8Tjko5oFUruas95x2BYZk14ik665vFRcPvDnP01Z3ky3GG3JF07JU+e2jcD2UznamxujKVmdurTDxvC4GHq7ePGUpPzIrBGxJ8E1Ssi4b/Cp/oY/0zlKnn5MAWL08WvK3BY/Fjs6H+dLhcTV9ct5Wa7SC3PZ2XnySx0mxpS7NSAhAkCNAVHk3W/j3aU2g1DSJdpW8soYLihH2S+duBMBR+xJRVHW7agex/kcYGcg0aLxYJeYhtNPGJJATzOw+p7cWj3HtUT/uSTgtjTaeZRz51fOYkt7BSo1G5Nk0M24B3nqsMR+ScYZ28Sgs/LT9PtBINMpYbIOaYneMjsqOFDqLguTUbpJJuYGnHjHAaDG3ASAVzEyc4qru3QVgO3U4ncWwiMG74YmYkmRGhQUvFbobc7GkLxve7hUvA3NjewXwhuTpIPGext7BFFFKc2bObVmoLJX9sGrbOLXKNI5SlRK2Yzp2bKp5+y0ryEKOKgxuDLDT/UaUQ4KDhpX9vki/KcxpI584Mw5kwN76OVXMsXuhZazBmdyrzSQpNy8sata36jQV83apZrmL8ER9hNmpXEV7M
 E0mFzYtO
 ofUJV+BQXAILv4y9bRRWsyVFH4LSOD9dRGFPlTK4dHSpr0bHWilCyvTowlrhinFOqKJOm6OQmMDLGUff29Zy6wQr4c3tcDnvKEnHILt1nDJ1XbD8qlswICC0L/RDYUqOpOfGJkys4xR1HW/TZkvFkvN/bsXgS/l2ZuzLUe1miKTGFlIZsLrTQALThVVv/+RPf4on24sObM3jdbWUl7MWa0ktgEhLNG1BCC/usDtsHk5j17OCl6bN+Z//E3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it together with TIF_SYSCALL_TRACE on the
way out of a system call. The check used to rely on the flags r30 had
been loaded with before the call. Reload them. The syscall may have set
the new bit. A task that reserved descriptors calls
do_syscall_trace_leave() which commits them before audit and the ptrace
exit stop.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/openrisc/include/asm/thread_info.h | 5 ++++-
 arch/openrisc/kernel/entry.S            | 5 +++--
 arch/openrisc/kernel/ptrace.c           | 4 ++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index e338fff7efb0..3d8a710a809d 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -92,6 +92,7 @@ register struct thread_info *current_thread_info_reg asm("r10");
 					 * mode
 					 */
 #define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
+#define TIF_FD_SLOTS		6	/* syscall prepared descriptors */
 #define TIF_SYSCALL_TRACEPOINT  8       /* for ftrace syscall instrumentation */
 #define TIF_RESTORE_SIGMASK     9
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling						 * TIF_NEED_RESCHED
@@ -104,12 +105,14 @@ register struct thread_info *current_thread_info_reg asm("r10");
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 
 /* Work to do when returning from interrupt/exception */
 /* For OpenRISC, this is anything in the LSW other than syscall trace */
-#define _TIF_WORK_MASK (0xff & ~(_TIF_SYSCALL_TRACE|_TIF_SINGLESTEP))
+#define _TIF_WORK_MASK (0xff & ~(_TIF_SYSCALL_TRACE|_TIF_SINGLESTEP| \
+				 _TIF_FD_SLOTS))
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 18e68680471e..c70265c4fe55 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -701,10 +701,11 @@ _syscall_show_regs:
 #endif
 
 _syscall_check_trace_leave:
-	/* r30 is a callee-saved register so this should still hold the
-	 * _TIF_SYSCALL_TRACE flag from _syscall_check_trace_enter above...
+	/* Reload the flags, the syscall may have set TIF_FD_SLOTS.
 	 * _syscall_trace_leave expects syscall result to be in pt_regs->r11.
 	 */
+	l.lwz	r30,TI_FLAGS(r10)
+	l.andi	r30,r30,(_TIF_SYSCALL_TRACE|_TIF_FD_SLOTS)
 	l.sfne	r30,r0
 	l.bf	_syscall_trace_leave
 	 l.nop
diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
index 287a9718f0c6..71614b36e516 100644
--- a/arch/openrisc/kernel/ptrace.c
+++ b/arch/openrisc/kernel/ptrace.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/string.h>
@@ -311,6 +312,9 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 {
 	int step;
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	step = test_thread_flag(TIF_SINGLESTEP);

-- 
2.53.0



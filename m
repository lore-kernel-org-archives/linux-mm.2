Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA068C982C5
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E696B0093; Tue, 15 Sep 2026 07:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8A06B0095; Tue, 15 Sep 2026 07:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF626B0096; Tue, 15 Sep 2026 07:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C11D36B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:31:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35BCB1C22AB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:46 +0000 (UTC)
X-FDA: 85215781812.08.983A096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C8D2180002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7x382Hn;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMEKWie9jF24t7TYFlO7sbFAQBsdl6e/pxJpNAPN2Sg=;
	b=vw0qf4BV4XWwbT8eGI95LoAhU7ztRt1NfYtwoYDDkvgKuZSErR+r+uis1MNEDWrBb8JLrq
	qIxqvBcP7BkWOlTXxrCCoRinq6HL3vb1e78yAnF0LempKOTwyUiTiYzJfW5V7P6sDNkZUG
	PlT9jHk5LJd/BexEIZ/aqPVt0YUPUks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7x382Hn;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471904;
	b=QMGa2+9wGs7Y/0yyHqvH+cSGyR226ALOzVnEeESeyNmIajQIZQV/OVBmW89UvYkfO0EWxY
	8wUyvfNxF/Mjxek6UtGcAOThFKeQe3BNPdZ1ODsnflEKv1pYuf/3J0bZxoPdbUzh5W+2r0
	5NBpqqr37MwaJ26g2xmfuxAW/0sAQjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C4AA602BE;
	Tue, 15 Sep 2026 11:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38BA1F000FF;
	Tue, 15 Sep 2026 11:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471903;
	bh=XMEKWie9jF24t7TYFlO7sbFAQBsdl6e/pxJpNAPN2Sg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i7x382Hnnkl9/28oqzb0mWvS6zSI4aiPrUmgqyFCmzCN9moF5QbSnsvMPDmf6jsFE
	 20sY8viNkieJZbQC/m/uoRnsZDoZFxiObsIH/1onHcojg8Na5KA8WBmzAnwM4xe7nv
	 cWuvmngGAmVYJETI1rRmztQmkMvwsRgO4LmnzxxzIad+JvmPwmUPG7wVIXCYGBiA0I
	 mqlaXmYHiuxvamjCZ59B9hIoZAdp2d3/z0azbHRAvvW4HC6KY9c6HyzfMGBsxUC5KA
	 wQsLl2gTta2JoSnUidFFvBDUQCl+fjxiaYkM5A0OZHt6XgJeW93tAdk20XFiFzz/9p
	 9i6uz6bpnbytg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:49 +0200
Subject: [PATCH RFC POC 03/50] alpha: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-3-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3840; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RHaKINpzdp/l9rjcdl2huzzYgE91Xjm8KSEi0tjemx0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KnZvvtgiPkBlSLl5w330l/eiLM07dLKTdyvJ/x9U
 swK10XpHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5uouRobnvtNDzWTUxee+k
 GNbq6gjNkn34863ehHMFswpYD6708Gb47zR1+f3CeV+t1HumyzefFry5dVXvk12PN5yNOaLxR90
 pnAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C8D2180002
X-Stat-Signature: 5x86bzd1ae8c4u6teg9xo957rfpwoong
X-Rspam-User: 
X-HE-Tag: 1789471904-472859
X-HE-Meta: U2FsdGVkX1/W0ZadCdnoTGyRA4D8tToXbhDrtxVnKBWynaFZDrxQ0qU48WZ+sXwUPWBGEofRY75WuDSJPIJ+uxJAmYfILq4RLo8W1TLv8EzZGcsp8GSZFGl814FQA8UiwEhGOEg70Q4a/iSIaKvSFVZb53glnAvdYFPkSXmUcjA5xHK0EEoBF6gQ08wIir6OXR/PZtLmzug+PJjhtahJSx+x8IVX6q6MTgJcS53IHJQa4af3HZZB36cDmM+gHRMdII4PbDbA0RawoLJLV07O3qCe8gPbqHyP7DfGdzXxTX5PTsFbmtbg6eOgDMXEcaye9krApWhxMpEWznejQeBGdeT/jxilKr6tF4cHek9+qtPeYLSToLaPRS4PmZGSzWxhcIzqWotmhxG/RrgIv/WRpxA6GZFRsS2e8Fn931O9d5LpOvfBOiQ0ruTi9tCF8tkgT9HjoQ1EnQGLWXM5NndODjLCUTLdME4TJOPGdfCGrdKEgxqyXWno5P195Q9Sg53+rFV6O0aV9F/6U78HBxANj2SwKNi+YJtdYHAOWs7xR1ZxVagjHTYzeoMUcWMhhzmKVDzBZ0FYHvCzDutcSKaHAV14H0P1IjTiBPjLjvWlWHEP4RxvCsUs9xY+rxgWq/xco1muov0K+S1aI+VR6J25hogvG4lZM9BbcyQRUlzEDc1aqZr1QmDrraII8RcFVYqzBU+lRC9EPKMHql/sCHDRlVY7aanYho3J5/0cwEY/H5kx7vGH8iOZ+mwCBNHdT/CvDPa+zuVS1eFghz2okJHe5SfFNQmzoUapP99A8jfp13DH/WVpt3UjRkiuVkXVooYf4xHEfPAanvvVKJwj+f9dIGnbWC+vTyyvY8Tm9xCKAfzkwk/8M/hZRlxwcfwJMMoIEhxAqq33dOREa7ETVIp0v1eJ0fvIpMj07ufREe/0H5Rc4Dx81++bX8FrFJydJarMH1KJdDAtzdf2gBbWuxg
 ZwObrTGz
 kXe58zEiN8egmcDuqNZNq4gWapgo/m0tG6UJ079EC4w7Ms+tdYyaKq+yga7ecny8xBpXVhls8tN8dYh6Wh5d9fE2xIeNH7J92tZjzy3GIen4n8qywAIMMYd6mQKmBP2mpCcFqCHF4RHOitTjrcnJbVKmINZd+Ni5fvMr80ZqiKttek2qLL+8NgfOEPYTMqjTRXDjVT54TUXctrCGQ41/3CE5NcTuHS7+r8WIFuzFRWdxEV/1zGDHvjDFQ0bGAfp5/9mqVSZVTEFY0cbO4SPFpC5Ky1Qzajb0YbdkdtPvFn7Rnf8LMLAtOqJoXKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it once the untraced system call has stored
its result. A task that reserved descriptors calls syscall_trace_leave()
and joins ret_from_sys_call with the flag gone.

We mirror the traced error path where the switch stack is set up and the
return address and the syscall restart state are placed in callee-saved
registers.

Btw, let's remove alpha... It's a pain.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/alpha/include/asm/thread_info.h |  2 ++
 arch/alpha/kernel/entry.S            | 24 +++++++++++++++++++++++-
 arch/alpha/kernel/ptrace.c           |  3 +++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 1552ecca8520..db8465f5fabb 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -67,6 +67,7 @@ register unsigned long *current_stack_pointer __asm__ ("$30");
 #define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_SECCOMP		6	/* seccomp syscall filtering active */
 #define	TIF_SYSCALL_TRACEPOINT	7	/* syscall tracepoint instrumentation */
+#define TIF_FD_SLOTS		8	/* syscall prepared descriptors */
 #define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	14	/* idle is polling for TIF_NEED_RESCHED */
@@ -80,6 +81,7 @@ register unsigned long *current_stack_pointer __asm__ ("$30");
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 
 /*
  * Work to do on syscall entry (in entry.S).
diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 9f2608de2544..20372e926359 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -569,6 +569,13 @@ entSys:
 $ret_success:
 	stq	$0, 0($sp)
 	stq	$31, 72($sp)		/* a3=0 => no error */
+$syscall_exit:
+	/* Descriptors reserved by the syscall are committed in
+	   syscall_trace_leave, off the return path interrupts share.  */
+	ldl	$17, TI_FLAGS($8)
+	lda	$2, _TIF_FD_SLOTS
+	and	$17, $2, $2
+	bne	$2, $fd_slots_exit
 
 	.align	4
 	.globl	ret_from_sys_call
@@ -612,7 +619,7 @@ $syscall_error:
 	stq	$0, 0($sp)
 	mov	$31, $26	/* tell "ret_from_sys_call" we can restart */
 	stq	$1, 72($sp)	/* a3 for return */
-	br	ret_from_sys_call
+	br	$syscall_exit
 
 /*
  * Do all cleanup when returning from all interrupts and system calls.
@@ -648,6 +655,21 @@ $work_notifysig:
 	UNDO_SWITCH_STACK
 	br	restore_all
 
+	.align	4
+$fd_slots_exit:
+	/* Keep the return address and the syscall restart state in
+	   $26/$18/$19 across the call.  */
+	DO_SWITCH_STACK
+	mov	$26, $9
+	mov	$18, $10
+	mov	$19, $11
+	jsr	$26, syscall_trace_leave
+	mov	$9, $26
+	mov	$10, $18
+	mov	$11, $19
+	UNDO_SWITCH_STACK
+	br	ret_from_sys_call
+
 /*
  * PTRACE syscall handler
  */
diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index fc8f6cedbb28..736218b34601 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -6,6 +6,7 @@
 /* more mutilation by David Mosberger (davidm@azstarnet.com) */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/mm.h>
@@ -507,6 +508,8 @@ asmlinkage unsigned long syscall_trace_enter(void)
 asmlinkage void
 syscall_trace_leave(void)
 {
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(current_pt_regs());
 	audit_syscall_exit(current_pt_regs());
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ptrace_report_syscall_exit(current_pt_regs(), 0);

-- 
2.53.0



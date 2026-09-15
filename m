Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D3BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38676B00A3; Tue, 15 Sep 2026 07:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8856B00A4; Tue, 15 Sep 2026 07:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE796B00A5; Tue, 15 Sep 2026 07:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7466B00A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:32:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 027531203ED
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:47 +0000 (UTC)
X-FDA: 85215784416.28.C0B4FE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D20820009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dCq0TREx;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhrRWmW1jhLpY0b4T+pXdyq2K6/6Lw3I7Dd8oxsFe60=;
	b=c1LVR/Hq7vSkXRn19S6EDHzkK+5daVexTw3BA7n4A7WXInsoJqpEahe1IqJAACISjjGuYA
	K2oWbdUswHJq3uoStDgCYK6r3bvijaBgaMu1pZP7hOIQIYDI6nmMAWRedIqWNorOIed5xq
	sFQXsECM6cp6xfZ8+GajvQpzjGP6j/Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dCq0TREx;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471966;
	b=BrjGHjYJQAHE4GmCLnyEqwP9hdvV1QkVJRJeSpNx/c7jl0hJ6+ErAYBlQiRelD5Uw5V6GQ
	FEYlE++ec38adykiDal8UwwhoAb4zUTibUnFYRBvXhzop3d+Vy1wLyjm21ooCAX5WMg7rj
	9WmDI3ChYX4pFzExLMgltGlyOztuu9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 954BE602C4;
	Tue, 15 Sep 2026 11:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A7F1F000FF;
	Tue, 15 Sep 2026 11:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471965;
	bh=lhrRWmW1jhLpY0b4T+pXdyq2K6/6Lw3I7Dd8oxsFe60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dCq0TRExcU+BlQDM8hy6Cs9E6uwVSlfYujcFmaPmD6BlHGcwf1zlVdOj4iekia6nX
	 al4ANJBJ1tX6VX0/MptbgzlPojdMZvifh4Xr1Iux25MunfDMJ0ZdADzgOLF+MDBHzN
	 VJjSchXj7ycWNCGrw0+tgXtNpK5YAPLTUsheMDknEO+8eH1b0rnpbuY1zSztCCnVfA
	 GRrWZUAcC9RH0jbS0xHcc8vRlak+IYa8EXS78G0mBcqGwylEICLDemOC/lzCP+aOI8
	 4k5cX3F/404vMcxuo7rNpXN7ULTgziEBKlCxV3cgzN4zcwdBCL7BCfVwLs7N1a0luj
	 JpfRAWBOJ7VYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:57 +0200
Subject: [PATCH RFC POC 11/50] MIPS: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-11-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2696; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O2Sy8b10JPTSM3T8FMxCg3yxJ2yYFrKaQgz1RZTqrDM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmVfhLzX2amjpDLni+t5iy5HyJ8fnfYuQs5t239d
 4fnocLijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImcVGP4H7v0ThyX7L2OzssZ
 Dg/usvC4O0iFJConhHNZcXS9mtKnwfBPb1pj+VPfVuVgW/nrzUqNt57OOi2ptdSndP/0CbwHHU/
 xAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3D20820009
X-Stat-Signature: 331a88ycekwj1dqo9q6qmqu6bu8h1ogk
X-Rspam-User: 
X-HE-Tag: 1789471966-967329
X-HE-Meta: U2FsdGVkX188V3AzGqWkdt+7HOO4NF7ct5vGrKeb9sCSyLl8v+2FOotMe8QIKsTmTiiGo64LCOZGczDm9Li5u3YubqPtCc5/w50wDwIjpuOYF/PBBcJ6xBqbYTHM9LitERQ5wbJivi6A8VFyWqLCrdgjejk5ydJPnNxVCugFqs3i2vTX3qrVYbjOZtys2NuYlAtXGaHvB+gbYIrJ/nxp5Fiylpm6Rs0YBa9XAJPYXYlYHOk+cFMcNQWPzUxumi1/4BnQss2jmWIpyfZIkH8lmK6HRG2n4W7IDzvEANNW0eV2t3wP+yt/kUoJIejK1E4+Ecdp/zl9tfzS2CPbTvwEIDXDUrqKu2BlVpZ5SGvNEbh+WyFdyDvbmVdilGz4gTMTpVOQ5TGMd+IMtpwV/1s9VJ3aw6Hqfuy1suGiz5s3SNCpdXu6RBB29ZmeX0a4JFa9vawQAztD+rpt4z3GYyg25r7/55PxqQyU1M60yPnB9mPCxVG4lJGa4AWTf9bcNNbu4+oIjo5C7CP2v6fWVdFSzHG/lxkQwE1T6Du9X8srn5SHWQIfhMsNa9CiKG+QpziyAdGNfqE5HTM85wMdP5Yl0mb28Anj2T4NF2hTuV/ym9uKeuPkDlRipIYJpzH35WeTRtzYsF5rNSEGPMSQcrvrqw51lNzqjQqY5W7LEenUxIxpSWEgLrnfZLT6mAVA8/P/iyand4ElFd0UUzXUuET2tynGkoYSXQpWYsDQk5ME6YvsQtIUI+EXtZ1zRVNk9KejBvx9ckcUE8mH3/Ugu23FnUZ7JeGumpWUVfBUKHclk6cMtB5aZcVmj7+7sLpFarH0+nKfAm9G6FF0YHxr5GszglQF6LGH9NjDt8+RIW4Dkd6wm3uTHLQfj9o+nJ22a+Dv26+bCfQ5hTBSXAuvctnIaED03nSZ6hvwApLWjDngR3UTpySKTfTrumAdEozlmsHmCz55rwboU4YqJJ69EpM
 eoVuhNcY
 U4SYgUMp65au2Lbf3w7qwTkv7qh01RYotibriGy1BPXgu18HrM6TUUOYro0xr9xKzh28lUJlZj33RNFEZkrfT2aSByrWJ/wZ37ZHWQntgeHzDkqMQzPYkl8nh1fy23Ur3QTQZnTulTYwAzhToVV6XzlSkp2HBDVwVmcbdMZP6XT9MEhw9XG7IkifpcnGxKprwFp6nWmyI2XVVd69HQ0yO15Bq+iS4EThw+TRwei0MjDnG5HFBDS3S+EkE5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS to the syscall exit work. The return path rereads
the flags after the system call and calls syscall_trace_leave() for
any of the exit work bits which commits the reservations before audit
and the ptrace exit stop.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/mips/include/asm/thread_info.h | 5 ++++-
 arch/mips/kernel/ptrace.c           | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 2707dad260dd..79c81696e9c1 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -114,6 +114,7 @@ register unsigned long current_stack_pointer __asm__("sp");
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_UPROBE		6	/* breakpointed or singlestepping */
 #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
+#define TIF_FD_SLOTS		8	/* syscall prepared descriptors */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -152,6 +153,7 @@ register unsigned long current_stack_pointer __asm__("sp");
 #define _TIF_USEDMSA		(1<<TIF_USEDMSA)
 #define _TIF_MSA_CTX_LIVE	(1<<TIF_MSA_CTX_LIVE)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 
 #define _TIF_WORK_SYSCALL_ENTRY	(_TIF_NOHZ | _TIF_SYSCALL_TRACE |	\
 				 _TIF_SYSCALL_AUDIT | \
@@ -159,7 +161,8 @@ register unsigned long current_stack_pointer __asm__("sp");
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	(_TIF_NOHZ | _TIF_SYSCALL_TRACE |	\
-				 _TIF_SYSCALL_AUDIT | _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SYSCALL_AUDIT | _TIF_SYSCALL_TRACEPOINT | \
+				 _TIF_FD_SLOTS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		\
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 17dc7249b8ca..d68eab59bcc2 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -17,6 +17,7 @@
 #include <linux/compiler.h>
 #include <linux/context_tracking.h>
 #include <linux/elf.h>
+#include <linux/file.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
@@ -1364,6 +1365,9 @@ asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 	 */
 	user_exit();
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))

-- 
2.53.0



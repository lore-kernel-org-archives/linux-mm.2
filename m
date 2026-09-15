Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3EEC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862256B0095; Tue, 15 Sep 2026 07:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837E46B0096; Tue, 15 Sep 2026 07:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729AC6B0098; Tue, 15 Sep 2026 07:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0246B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:31:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFC2C403C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:53 +0000 (UTC)
X-FDA: 85215782106.03.C506C69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E88540004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjTiEaV3;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOANy+Z4EJ+6nqoqN6kMNeWMX83pxCR/f2oFPELw6+I=;
	b=ndovoEPiLibjY1Gq6T/pWl0mW90U2VjhYNx3rdByLTakdrzeCt4JEBS1LtL7A8x9WMxrmV
	QS3fWr5d96/eSEwpulOD2oViI699Be1gHhm4Ggu+uA36DyvWGqOt5+/w7/nE5/HXDCin0X
	oE53V5TXo/shth9sCAtYLlLUNDcF8YQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471912;
	b=cIxLUVEspGhCxhIDn3hngxhCBwnFK06ZKMDVNeByl2kT0KF7+U0dxttdnz6PuomH1WBUIo
	wI/lZkvSjPKFEs398uoOHqMBFF9T4iOhUifWpPK10FF7/L0HNKc5xJIypCutIUl6a28T5h
	ztCfr+YMe9REW+QYCnCY87+Y3D4wOeM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjTiEaV3;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0A5E6025F;
	Tue, 15 Sep 2026 11:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BA31F00893;
	Tue, 15 Sep 2026 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471911;
	bh=FOANy+Z4EJ+6nqoqN6kMNeWMX83pxCR/f2oFPELw6+I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NjTiEaV3ZaSoS1ZK+2F2vFiHjAl7mkp0G3MbSEUlep66TuNm80zD11hu1nBRrXxYn
	 jBTgv2BJxRFDL61U3EX8wu6faVIGU3bVeFZLIy90XxwIrdrOUrOsKYX977rOTgZ/8I
	 4thUe5a8WqKasgzR8NxRqDgxbn2ffdmAsbyPzlk/nLtbznCt3T36AhEWcTJxWAK16P
	 +oX6GAj1A666bKWBCHBVyXFcgtj42qkim8vnDO1heVDCubdQ6sDhUxhnwBvgcIFp3b
	 tNoelVNVV3FSdtQiheYIa3QaDhiMkmI4KN1O3BjQkmw4KGESv+pMI5iwydQ3oXYyV8
	 m6gLuAfE4lcLg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:50 +0200
Subject: [PATCH RFC POC 04/50] ARC: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-4-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2822; i=brauner@kernel.org;
 h=from:subject:message-id; bh=evSE6cJdnuFzZXNcFgM0f0Wtj2vW8xSJVidsgxr0vnY=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqpLHyhtTAYRmbLzGwRwqcyv1G19KV/PkIkpZzswA8hR9xFL
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqpLHwACgkQkcYbwGV43KJF2gD/fYHy
 46GYN1jNxZvG5+E3C415n+5O5q2AJF3BkQjO7yQA/1hW7xKAHZiI3T6na5l1kqSbVvDkaRah45d
 KjuZmRA8O
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qqcc15oqju9uhfna3qa79opa9qm1rb18
X-Rspamd-Queue-Id: 1E88540004
X-HE-Tag: 1789471911-363852
X-HE-Meta: U2FsdGVkX19e7jYur3F/kdYh5Bt1OuRdro2E9juBJmetmvYVzlR8NEn8cibOXT18kjiWL6wi0pLXfsk4eyfAKVzRipNk8SnCtaKv74h01fmcxkFs0sL1jvkwPrjDHmnLrRfdFBcmwZhmmUc/Lkif9IDciGV//z2yxcGUSkJuv2hAv1uwgefn8WHBSWylrWUpbe3Q+DnE19qtqBcWxdSXbz+L7QqeP03HW8Y3Un+jhkn2sUGFST0+QBZ/EUSbr98smUTqIqu+ZLVqEAII4AemPdXvLxpCZqilgtaToovk56u3xlzlU9QwrWq0/AQvkk6Y219Qs+03StHp+6Iic2wZIvbmZbA+cj+YRPp12ynVt27ce2DelnhgWGYqEwbi2SRtJITah1ITlIU3HaNm6pjUCQcJrEeowMw/5vaIQJvHlBCqd+kT9JISJtNa6WS43kir9BTVb5aqHDvwcI5ZcVLwPQsB7O9iKxT41WTDvsV1OvQUrg/qmrO1TJFlLAx+mJ9KP6WTFgKGwbKTB0CLba0TaDPnHHDe8ehHEY4L+Ih435oJXyY46GEbLnIUjrFh59Cvn26eq+BVHqi3vUi5iu3fydv+9285ohqILL1OJYhDk7WK6dQFtocylplfP0g9t4kRNHtYqUFed9NZO7DO2NgP8a8P50KCGz285/99OjyGDiDXFzyL54SqYoSaLb7Q9xG6WQmVHYARxza5tyCgyw0KPWxHD4fYumqCRY09+nXF1rhVwrDYKPpcpwW4FOc7eWuvK/aRx29NUEJohrdZw+gk8wPAUz2cvjMabTYq8giN2Qvu+Qk4vHXrTvjEyNOAZffjfm+B83hL63Setifi5O9w/PbNKINw5oi5dJV3luJ20sC/LxXrGOVSz9KyB7Gz7npXl/p/dcsd5S6ZXDq5RdKz3jdUCIRNObmUV0FmbFutOgrKdVrlpB+blSgRCuGebRVcRXOLGJIDo0ZSF6JuW1q
 uiQTSvb0
 hGqaypNc6LDf2GCMHPSuELGGP63d/kpXYxOlOQ3B4N+dI8etofabOokM1NHooglhuEeYqcUowqaVhpCBJpbbpDks/wVAMTVWJwJ81XC8jBwOrTDU7N4Y0YE4Bo2LCI5/nEh4kxmE5xnJbYIEJqR/KP3shiZIc885Ih2v/YhDgGPjmDibqShv0oLv/bJOJ1aw9o78WqTv02Oijn7Wd4zgOPbGLrE7aW0/wP+Uv1FXepqECNFalKOiwRgosh+DZVyG8rLE8vbv1CpYyat0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it on the untraced return from a system
call. A task that reserved descriptors takes the tracesys_exit path,
where syscall_trace_exit() commits them before the ptrace exit stop.
The traced path already ends up there.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/arc/include/asm/thread_info.h | 2 ++
 arch/arc/kernel/entry.S            | 5 +++++
 arch/arc/kernel/ptrace.c           | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
index 255d2c774219..4c67d4eb434b 100644
--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -77,6 +77,7 @@ static inline __attribute_const__ struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
 #define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
+#define TIF_FD_SLOTS		6	/* syscall prepared descriptors */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		16
@@ -88,6 +89,7 @@ static inline __attribute_const__ struct thread_info *current_thread_info(void)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 3c7e74aba679..f436391526e1 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -241,6 +241,11 @@ ENTRY(EV_Trap)
 	jl      [r9]
 
 .Lret_from_system_call:
+	; descriptors reserved by the syscall are committed in syscall_trace_exit()
+	GET_CURR_THR_INFO_FLAGS   r10
+	and.f 0, r10, _TIF_FD_SLOTS
+	bnz   tracesys_exit
+
 	st  r0, [sp, PT_r0]     ; sys call return value in pt_regs
 
 	; fall through to ret_from_exception
diff --git a/arch/arc/kernel/ptrace.c b/arch/arc/kernel/ptrace.c
index fe2b6572e919..0a0d74b9c7c4 100644
--- a/arch/arc/kernel/ptrace.c
+++ b/arch/arc/kernel/ptrace.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
  */
 
+#include <linux/file.h>
 #include <linux/ptrace.h>
 #include <linux/sched/task_stack.h>
 #include <linux/regset.h>
@@ -355,6 +356,9 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ptrace_report_syscall_exit(regs, 0);
 

-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F6AC982C7
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB386B00A1; Tue, 15 Sep 2026 07:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0B56B00A2; Tue, 15 Sep 2026 07:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C09C6B00A3; Tue, 15 Sep 2026 07:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC976B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:32:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70E8A803BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:40 +0000 (UTC)
X-FDA: 85215784080.20.2825F7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AA7DC4000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOdqCs6F;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg5h99+rXwPUOCpAK+cpKxSGhPsqw2qIAApb6RMTrZY=;
	b=4A7UH/7hR/EFYsYlgpbRfhI7/uzSZr9DiH/tf5hJagKGdt/puXqIPzPG+Xh12A5m/wabsw
	o6QNUC6Tv17XbDAELDRRiOsNMVKXEyxnfWN2t7Nmao7dcD7AC6qY+q+xbKHEy16ot4MWxh
	X0q9Rf0VOMpJvgH+cwyfqbnYbTGQBbo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOdqCs6F;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471958;
	b=lHMxciSdf6UMFZQypZQQyVF6aexrXxWZNZ223Znq1U26bJ7PDwaC2gQUygUiovFBBIVzEG
	9oM07ufcKbIdg8oQfEFXMYMEr3BvMxXdIQMNnqksRxhIeB9pYCv9rZCdNbSGCUbElgLfSd
	hFwsil3n0M+v0V7LBWYkYko4WrOEXSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D114043CB1;
	Tue, 15 Sep 2026 11:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726AF1F00898;
	Tue, 15 Sep 2026 11:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471957;
	bh=tg5h99+rXwPUOCpAK+cpKxSGhPsqw2qIAApb6RMTrZY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SOdqCs6FFc+m85zKG65RFoiI3OX0TKhMSKuOGs5mjQ4eozA6DlIsvYCrD/FPZMCya
	 K5qpA/W9zCpRVyaXCWr3ds/VJdxhjZpyZLD3Mkij4zr7pNA3EzYnKrukqu7tQxRSqi
	 awcZPh3/KgPK/8y13mc/r6QIcT0xahYOLE6UWC72R99aPngllw7ccPTc2jgUwYcOi7
	 U74GTjJbNoQ41gpF7hzYmntvuz0kqC5olR/d01x9OdjbXM1vPyPMxQK1LCxZgEa3FG
	 WTQ0xmcaX8BwZ3dvqAm6+xxz2psYUrOreD8islOMqgvBbrNJc0rwt/o9saf69osrsb
	 1/GNM2HBy3hbw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:56 +0200
Subject: [PATCH RFC POC 10/50] microblaze: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-10-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2340; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nXh3DWWigUzaDKpK2QrpbR3RoNJlzLOS8WiJE98yT14=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KnZ7yrddCzxyY2/Tpa2vz6x/Nq//Y/DVseZ581KJ
 U5sMTtwtaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiZXcYGfaG5Cl1dp6Z4vGN
 heGfRKcz571g7fAA9V1NlYVnC00jGBkZbjv+T3n9aZpP9I+Lez8pxBz2mPT/3UPhvvRP08XYkut
 MuAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA7DC4000B
X-Stat-Signature: kdssy6irydi6mj36i189qajzdp9q6by8
X-Rspam-User: 
X-HE-Tag: 1789471958-968025
X-HE-Meta: U2FsdGVkX1+qk0PTZFfHNb28G7w4Fkie7OIWahheF5m+ylZmO+cIfcrHpbL1khZD6ohrNGpOh01zH3Kz+0JTcN7QoJbWIEVeRYUj7AsdaAAXx33DURiOwvep3WDPlSTa+XQbrgFw5sWNN4WAfwNOT9Gf++zTy8rzMXWzaEox5gyxMiW5tnTE/CeKp+5uQihmDVPcyPW2wG21PrVh2SFs0iUlvEl7fXSPLb8ZzVWkfYR9AHkXys2PUugZzgac8rz+e3ebVADxmepvJnYFSFab3au4R/1cVMV2QmdgxMhmEgFiXaF6KIUJ/v26xv3yHVfhPtPZKe2p6p5lVJ5R2ipzcK3ByFrdL7hV23FN+2c4peP6MXfpEA8f5u2mr6QUqg4TmXaauupslQJnNitAIwoVrtIQ6gvrB5eEuxj+/ciEdpNv4c6esE/Rb+GwW3jhrlYFwQC/MJfnxjB7Wq0BlaF1S7UeLSwbBkQrqEGYC8akT7NkjfVBXYSOUlp+uJ3DHV3ZXPyaUXTWen3xiFb4Yc2uUATh/p1rUJUyeja45dz+sTErG67NYM3rduZuOEdVo2PbycJ/AURPsXMukSUWfX2Y+mdSyMv65LuLPvYVccg/TZAKwDGJzYaKmVoizcAGc2rSXdH7epvY4Mz8h+7jG4fbW02uJWmEk/kUm4hBZA369wbFOrd9jcDUv2euakNWgOYE7tRKvNCEH1QzyhhrTnuHQiMhD0IjlwF3FHF/ZZKOOQUv7iO2wTfa/VJsxQZRP4+8Cxg2RFYFQB3LbH/zL3txvgF2PEpIRE6rHGlsxxV71I/lvZTJOv+ZEIYKwRjkqOGDmb1fid5MnIE5qS3um2rIWunciUvbzypJHB4Y+CvwzH0rArhFpfFLCc+IXK0+jA1r96Y3dP4S7HlJY+ZHaCTCTZR/1iZI156dQa+UDXLjKp1/2ewi/yEkzCXrh8gYMGLlY2b2jdw49TqxDrBjPMk
 /18rZ/sN
 jvSL4eOgQdvWO67jiGpUGKB7NdMS74ySZEiMEuq8yOAO1qJmz6RMWcdJPOkFpEJdbvi1Bcm2U0VH+RIIkXuUMPIauNRhcxfCiyxxq+rDxIEvzNdhsmxig+qa6CZJ9bs7AHFS7Lfbh9BGug843ONMsW4go0MOEYLnsodevk5Gf1rxNHi8pOpqZEvHD/324hyDBcx6bGgFm9Xl4roL3sEqW7rYXaxTmQpRDpB3O7fDGPKHwhax0dc+ZoYvqnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS to the syscall work mask. The return path rereads
the flags after the system call and calls do_syscall_trace_leave()
for any of them which commits the reservations before audit and the
ptrace exit stop.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/microblaze/include/asm/thread_info.h | 5 ++++-
 arch/microblaze/kernel/ptrace.c           | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index 0153f7c2717c..ee2f76589696 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -103,6 +103,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SINGLESTEP		4
 #define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_MEMDIE		6	/* is terminating due to OOM killer */
+#define TIF_FD_SLOTS		7	/* syscall prepared descriptors */
 #define TIF_SYSCALL_AUDIT	9       /* syscall auditing active */
 #define TIF_SECCOMP		10      /* secure computing */
 
@@ -118,10 +119,12 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 
 /* work to do in syscall trace */
 #define _TIF_WORK_SYSCALL_MASK  (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
-				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
+				 _TIF_FD_SLOTS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		0x0000FFFE
diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index 236264e932d6..e6951fea8593 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
@@ -156,6 +157,9 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 {
 	int step;
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	step = test_thread_flag(TIF_SINGLESTEP);

-- 
2.53.0



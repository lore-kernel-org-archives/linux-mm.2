Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A133C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9E66B00AD; Tue, 15 Sep 2026 07:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492F76B00AE; Tue, 15 Sep 2026 07:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA566B00AF; Tue, 15 Sep 2026 07:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8366B00AD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9163C03E9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:33 +0000 (UTC)
X-FDA: 85215786306.19.B1CE14A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E294E100007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUmSavNi;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsNpEFA01NMLmoDGH+WQ2k5w2caYKI3aFXCKnW6fq4M=;
	b=oDJTJ1PjduOCAkcttqqZLBcVQS5gmb9rpqVDXLBxgrEJ5zN86cR6u6TxudXT9QNWKLl5rH
	uZpzWa3qL0XaoJ2aDBZHVCG9o8y4+H8P9/CDO95s+U9zuyqGGIDHUDY7dAd6+KlSHGaVZI
	zj/V2gQc7ybDba+yrAi6g2d8OnOn4ws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472012;
	b=Z7wLC2Z5+qKtg4+HnoV9ABkVfR6eJAUQgDc/PisZQ7bJVPyA/w2BCYUR0H7TTRoXJ1pWhp
	vGDYbjyRHltWbDqcEkR3GeYep2zzdwHV5ePm8oUyv0DSTUKfl05yXygcj1BgzCxueEm4Pq
	mL6mI6GKQgbSA8qUCjG1xAFcmDl7NhI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUmSavNi;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 432C0437CE;
	Tue, 15 Sep 2026 11:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8D71F00898;
	Tue, 15 Sep 2026 11:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472011;
	bh=LsNpEFA01NMLmoDGH+WQ2k5w2caYKI3aFXCKnW6fq4M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jUmSavNiamqp7sEiSGUpt1XZfKBJkPkcG/PFCGuuE8ULC/JC+9Uv/jivWwgpx6a/O
	 ndFuFYQRnEyeD6+NTxQCHA1WQfYk7Jmw39axkxPneZ0ZlWHflWnPtQntegHAjSQOHr
	 qvPuy2KIMTAU8QpGMIZajMcBNJZLx1KDydcGwu/7Fq4Sm2suht1GMp/5OShBghjByJ
	 Wo0vc/D/MORpmKTNOKDNlY4+TTriFUPTu4Y02yC+j0UyASaEIruvlKlSwBV+MXdIZL
	 vi9GUupn2o56nWtYus7diY/kBIvVMBlvyHSKLH2hV7NTFX1VBgWRv0lAAGJXCHoiGT
	 eaCHwlU6HAvXg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:03 +0200
Subject: [PATCH RFC POC 17/50] um: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-17-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1865; i=brauner@kernel.org;
 h=from:subject:message-id; bh=S9sXo+/yQO9aORTIGU5zP9aw99mbVPSatnA1JIW5H/M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KldP/NzGWPyQ7vZ1w8Z91Y4Xry4dOW/w5ekHD1Nn
 i1f3lHo1FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRnzMY/tdevWsc17Pol1js
 drW1Ndl3Uj4rJ6jNqM1Qvbkzdcr/kFkM//PT/U4ukVght9Iz6NLyeqmVG29b1dz/x+3x4GR56M6
 Uan4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E294E100007
X-Stat-Signature: inekbjsskqrcy4e4okadhzi5fxzrgwrr
X-Rspam-User: 
X-HE-Tag: 1789472011-437883
X-HE-Meta: U2FsdGVkX1//fv7YjjvKdhaLd0dh1qx48toOCv6ZzuGiUkuP/7TJi2M5MM0zJR6ceTAwJ8cAbZY0kwvn3Z8KM+io5pzncmWwEnxsGXXUqwH7gXwThQuUMxGVqV8gBXyeY6w5fHAOFdeczSYtq4fzZ15pgL8aCkW1S7ckEz12qDoTy/4E5hY8cwo1/z4xIQzBZmKV/Vw07RDUvjGw3OanmF77ljWVFS+tYy2Rhw3/c/P0WRsKtCxvRPJEibDsDYnL5+9mYCLt3o1ulOBPDFBa8E1yOS7ysArPwcnbiBp1zEw7RlBY7po598nwdBqXw5cHyWEn5vkJLEPhH+AyJC+lH4mWK4s4HTUReXXZGGB7PL2JT/N80qT/42N5Bx4h1YqOBCm+1ALNimolMMxtufkAzZLfTlJWa6kRlrRGktQN/XzDhD7tZgGWdmX2VnDvOJmXKUC0GrB0qgXcPAk7pEPOM1DGPTfEz7Dk429H1TLxZ/kPjVtcvPcpOuhBp5svXO91uSpw1czglwNoq7OmfrhGG08w9/7avuBBM9vPn1PSxBmUyv5wnM357CryAize8k9XsI0PJ7YOTa0cv5nGto49jYzceAniniRC1rim4Yid/EB7u8KJfxSMscG3W4AsJuspNb9VAe37KLAyVVQgUoDDJeUH6s+gMdTvI65fto1cqgY7y91rqHHp9fZno9L9Bq8NkOfuK1kngIsqW4AMFtw+mA62seMRUaSP4JdNFC9LzVGvfF5ydQ82SmJcT1f7NZit78HKxB26Inl0IuXW79RXtzD8saXffMNE/HO0CSuIwiSehmHsM9vV+DOLxIVGTYLJ6YZfKZsA754QHj94vOjEUm3KfveQ4ptQR1lyK5LGk+ALSuKq6+hm+1lDBP+s2NEipP3h7hfon23V8x65HQ8h4exzKbcX9JlYWGDreehjlEf+3QdWjufQWUJhP73/aKwVGVD1Oa7gWg9Yflp8Ddy
 bzhZawvx
 jk4iFbE5ulkb5dal9j1tlJ7UVuh6+tYmRgOI6HWjaPvs5w67XqNX1qkHVtH9GtYnzi6HV2IS1HuuxXZje0r3iHd4vvxXeeQgWDSJqdnqc4PZglYzlay+wzTo8Bxgj4rleR7jhpgDU8vwUp3lQPhX/dfuvpBwN8kLx7EDpuCIqbKdqohOhVP6b1pjF2242aFLb7lsvwUAJeRT9L6CXQOtsFjKODsfFtbtAAUm597FbJmtYOW4WtRhqbDQXpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS. handle_syscall() calls syscall_trace_leave() after
every system call, so test the flag there and commit the reservations
before audit and the ptrace exit stop.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/um/include/asm/thread_info.h | 2 ++
 arch/um/kernel/ptrace.c           | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 7a6f4dc99fa1..7140516ee0b6 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -44,6 +44,7 @@ struct thread_info {
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SINGLESTEP		10	/* single stepping userspace */
 #define TIF_SYSCALL_TRACEPOINT	11	/* syscall tracepoint instrumentation */
+#define TIF_FD_SLOTS		12	/* syscall prepared descriptors */
 
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -55,6 +56,7 @@ struct thread_info {
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL | \
 				 _TIF_NOTIFY_RESUME)
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 7da0a5223aa6..f1f89181fb7e 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/audit.h>
+#include <linux/file.h>
 #include <linux/ptrace.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
@@ -142,6 +143,9 @@ void syscall_trace_leave(struct pt_regs *regs)
 {
 	int ptraced = current->ptrace;
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	/* Fake a debug trap */

-- 
2.53.0



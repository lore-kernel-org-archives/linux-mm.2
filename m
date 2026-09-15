Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0898C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31F76B0092; Tue, 15 Sep 2026 07:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F9B6B0093; Tue, 15 Sep 2026 07:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F046B0095; Tue, 15 Sep 2026 07:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 884E46B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:31:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF02EA03B9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:38 +0000 (UTC)
X-FDA: 85215781476.08.1A6EA60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 114E91C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FA99JUjo;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/Q2uFiWqDBb8xqHpNo0BQBrMpfRMKZw5TP1oZm+kmg=;
	b=ln8dUWNY6x/zNsA6RG9gii6LOaIrrgk8c4h9EbqnngmIsQ8T86vl/QgkoaiSGOMuI7jf8e
	gqiFLbo8X4hDPvwewW2V7XS2iH/KYnRzBJEJWeELPsRGWpuYKyb7i+PBZdeJ9n1L3WVMqG
	+uHbFo+135QbjoDDAiyn6EBxV4GmZU8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FA99JUjo;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471897;
	b=elQ71JBTZ7tbfaKpF/lDVCkBKpgaNOXCT0HvOmaecNXi0iRfBkOJvWJ004+08ZTVmcRMlu
	SBZ+TiU+vpQwgE+Rx/x+otCwXs0kHSE7drrI0BxD5qRxXWpoIaezRlIt3TcOgiVIGB0F+0
	9E88+yDKZn8RAmFZ6Ock+CKM0wQsXnQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CA8843C41;
	Tue, 15 Sep 2026 11:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D9E1F00898;
	Tue, 15 Sep 2026 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471896;
	bh=H/Q2uFiWqDBb8xqHpNo0BQBrMpfRMKZw5TP1oZm+kmg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FA99JUjog1yV1DbWoG2ziqsNO+0sw6EHhtLDfJByBVRaUjyRjJwu1VFldCsris1pZ
	 e2wCrK7C66Yw9jz989T8vHtdcQycYZY1aOUXtThwXFvZsxHJJ78r7g7qoZrOOkMU/s
	 lj0gTkb4Mh3TKCRQmb0rlBwKhGV75TJbATZem6Sjbrdch9yj+/sxhbvRUPzaeynzTg
	 lmZfZ3Gj1rUe2RlV3+OteWTMGEeRJFR//N1tZnHmdQHnT01ZVBDm1L4xmKQwmCU+jR
	 umSCRuNroMIzP8zt6GPqOvmEIb6PE+fF3iEwa5/6zDnWWP2+oNJbKhA8JiapM5A8Pv
	 P/GWj9Gp89ypA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:48 +0200
Subject: [PATCH RFC POC 02/50] entry: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-2-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5066; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NtpqRPTNAZlEeaPhe0rYOorWsOpjpNCIyBf0GHcmRWk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KnJVo3fvV5S5/Sii+rtiZfVW3bllXHI7rc8Ks4gk
 ree7ZZuRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQusDD8Lz+/bproy5BneSeO
 7On6+Fbpk7eF5doft2tsDJMENZ0vdjP89zl45Kb3WpH+yPBZEx9N/6r6VywwdGaxQ76IV1yGifk
 iNgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 114E91C0004
X-Stat-Signature: i11ufxegbsq75xnzgyh7afzapizenfox
X-Rspam-User: 
X-HE-Tag: 1789471896-419309
X-HE-Meta: U2FsdGVkX18scEbJ4y51DpkpI+KXMZ5bSRf5QmYKrcx4iBO71UImt/CSyZEaFbLupxFopec3GDc7iZDmDEvva+z5Di1vOnbpZYaqitkVptZKXQGDv6KhyBFLLa2zZMfFZkxeRCHjzDYQAhfNGRJlp1XwIrcZXgPGFH/ezLPWfGseANOONQpbrBcJklu1kT7eCfr7YD+jiKFRHzekeU0UG9FfO9ydDPILjUyTCfKXinQDsH3jO9yCWFRi8dnyzAZxJioBYSg1hdOLk27tAXU1szu+/pGvVKlUn0jLrf41X/QH+BlzSm3eyE346oFQ00pSiCHZG4CEhCu2Uq8pkE1TO491OLuOE1rgtYbXjDreiJBpcMr725SiTtn30UKqgdpba8cR+lGrUvs77WagYV/mwnvAdPu2wIldnShs5fZ8/K3GDYZR7eIiPvCVVpN5Q97fexT9AOu/4dZXVB0mX8K4VM23KdKw+EqKN0BlILeV5NOvLssSe4H5syhi4PXKEDUKiIBrpSlSa9nClp2B1a7lLukyv10RoqSzLHm7xEFxArzf2WJmySt7oKS1EnQUc03GcLknh+0z1CgT8skDzBmMKYqVaAjSaytbUaTk3mnl6HYdbc3YKb0E1VX1VJe8xxnGUTiAjx1sl6EB9MAE9e2Orp3AMuVZhX3m4msMCv/Fxcn/qa5UZUwiUv8+LZZX8Dnb9dJY+oBDa28T6ioQU7rYMoqHRcgDvQVhZqww9VSOdh1+NYgjKo9H5gKxlyfISt52FNZJdEgHthLr0XVbczurN66BAzQbRkLkhHfkk/ErJ5Bt8k+JEZgjWQ8SwgVhDPISqzJfdCfbiuy3/EJarrCqiZ9VOOJ//+kyb1YMKCMaXyOsEpfzMrYwsG81UBlWcq4Knf/MJAvIFn7yFNfTLkcGgIQ05XULPWpsGZg31lFaQaOfkkjbpKOVS6Wcmp83+n6MImjoHuRKcKUaMaG+Es8
 w4WzPF5w
 9dTvKWTKOwUmrMEk27cJ42RXzXl4UyJrBCLxpkc6xRfYv4vT3HRTlqblH+ghS0z0WsAyljn6x2sSW3psmfvLslzQ3JFS5Hysvg+GU5msCl/FlEzr46qaxoSsmNKr7WDVg8ru3MZswWLbeBZsH67veG2HeVcdJFRaX6usOIIF70yX03M6poZ/XgB/sJ6pi3k/Laidiz2ia1jX7QdKfNt8mvHJ6K9LJFXqjl4Iny+qivPAF543iV1g+4I5xbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reserving a descriptor with fd_prepare() marks the task with
SYSCALL_WORK_FD_SLOTS. The syscall exit path already tests the
syscall work bits so a syscall that deferred nothing pays nothing new
and one that did takes the slow path. syscall_exit_work() commits the
reservations before audit and ptrace.

Architectures without the generic entry code grow TIF_FD_SLOTS bit in
their syscall exit work in the following patches.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/file.c                    | 24 ++++++++++++++++++++++++
 include/linux/entry-common.h |  8 +++++++-
 include/linux/file.h         |  2 ++
 include/linux/thread_info.h  |  2 ++
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 90351241bb07..6fa481d63dcf 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -23,6 +23,7 @@
 #include <linux/file_ref.h>
 #include <net/sock.h>
 #include <linux/init_task.h>
+#include <asm/syscall.h>
 
 #include "internal.h"
 
@@ -643,6 +644,19 @@ static void fd_release(unsigned int fd)
 /* Enough for SCM_MAX_FD, and a page of slots on 4K pages. */
 #define FD_SLOTS_SPILL_MIN	256
 
+/* Make the syscall exit path call fd_slots_commit(). */
+#if defined(CONFIG_GENERIC_ENTRY)
+#define fd_slots_set_work()	set_syscall_work(FD_SLOTS)
+#define fd_slots_clear_work()	clear_syscall_work(FD_SLOTS)
+#elif defined(TIF_FD_SLOTS)
+#define fd_slots_set_work()	set_thread_flag(TIF_FD_SLOTS)
+#define fd_slots_clear_work()	clear_thread_flag(TIF_FD_SLOTS)
+#else
+/* Nothing commits until the architecture provides the flag. */
+#define fd_slots_set_work()	do { } while (0)
+#define fd_slots_clear_work()	do { } while (0)
+#endif
+
 static struct fd_slot *fd_slot(struct fd_slots *slots, unsigned int idx)
 {
 	if (idx < FD_SLOTS_INLINE)
@@ -690,6 +704,8 @@ static struct fd_slot *fd_slot_record(int fd)
 	}
 	ACCESS_PRIVATE(slot, fd) = fd;
 	ACCESS_PRIVATE(slot, file) = NULL;
+	if (!idx)
+		fd_slots_set_work();
 	slots->nr = idx + 1;
 	return slot;
 }
@@ -809,6 +825,14 @@ static __always_inline void fd_slots_finish(struct fd_slots *slots, bool failed)
 	else
 		fd_slots_drop(slots);
 	slots->nr = 0;
+	fd_slots_clear_work();
+}
+
+/* Syscall exit hook, keyed on the return value the caller will see. */
+void fd_slots_commit(struct pt_regs *regs)
+{
+	fd_slots_finish(&current->fd_slots,
+			syscall_get_error(current, regs) != 0);
 }
 
 /* Install or drop the prepared descriptors based on @ret. */
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index 6574b7183c01..2da30e50cf59 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -3,6 +3,7 @@
 #define __LINUX_ENTRYCOMMON_H
 
 #include <linux/audit.h>
+#include <linux/file.h>
 #include <linux/irq-entry-common.h>
 #include <linux/livepatch.h>
 #include <linux/ptrace.h>
@@ -36,7 +37,8 @@
 				 SYSCALL_WORK_SYSCALL_TRACE |		\
 				 SYSCALL_WORK_SYSCALL_AUDIT |		\
 				 SYSCALL_WORK_SYSCALL_USER_DISPATCH |	\
-				 SYSCALL_WORK_SYSCALL_EXIT_TRAP)
+				 SYSCALL_WORK_SYSCALL_EXIT_TRAP |	\
+				 SYSCALL_WORK_FD_SLOTS)
 
 /**
  * arch_ptrace_report_syscall_permit_entry - Architecture specific wrapper for
@@ -245,6 +247,10 @@ static __always_inline void syscall_exit_work(struct pt_regs *regs, unsigned lon
 {
 	bool step;
 
+	/* Install or drop the descriptors the syscall prepared. */
+	if (work & SYSCALL_WORK_FD_SLOTS)
+		fd_slots_commit(regs);
+
 	/*
 	 * If the syscall was rolled back due to syscall user dispatching,
 	 * then the tracers below are not invoked for the same reason as
diff --git a/include/linux/file.h b/include/linux/file.h
index fe2893eea945..04dd85cdd9bf 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -92,6 +92,8 @@ extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
 void __fd_slots_commit(long ret);
+struct pt_regs;
+void fd_slots_commit(struct pt_regs *regs);
 void exit_fd_slots(void);
 
 DEFINE_CLASS(get_unused_fd, int, if (_T >= 0) put_unused_fd(_T),
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 307b8390fc67..c80a87444286 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -47,6 +47,7 @@ enum syscall_work_bit {
 	SYSCALL_WORK_BIT_SYSCALL_USER_DISPATCH,
 	SYSCALL_WORK_BIT_SYSCALL_EXIT_TRAP,
 	SYSCALL_WORK_BIT_SYSCALL_RSEQ_SLICE,
+	SYSCALL_WORK_BIT_FD_SLOTS,
 };
 
 #define SYSCALL_WORK_SECCOMP			BIT(SYSCALL_WORK_BIT_SECCOMP)
@@ -57,6 +58,7 @@ enum syscall_work_bit {
 #define SYSCALL_WORK_SYSCALL_USER_DISPATCH	BIT(SYSCALL_WORK_BIT_SYSCALL_USER_DISPATCH)
 #define SYSCALL_WORK_SYSCALL_EXIT_TRAP		BIT(SYSCALL_WORK_BIT_SYSCALL_EXIT_TRAP)
 #define SYSCALL_WORK_SYSCALL_RSEQ_SLICE		BIT(SYSCALL_WORK_BIT_SYSCALL_RSEQ_SLICE)
+#define SYSCALL_WORK_FD_SLOTS			BIT(SYSCALL_WORK_BIT_FD_SLOTS)
 #endif
 
 #include <asm/thread_info.h>

-- 
2.53.0



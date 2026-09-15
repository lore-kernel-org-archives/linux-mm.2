Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6573AC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A756B009F; Tue, 15 Sep 2026 07:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7032A6B00A0; Tue, 15 Sep 2026 07:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618076B00A1; Tue, 15 Sep 2026 07:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4D86B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:32:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DE93403C7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:32 +0000 (UTC)
X-FDA: 85215783744.14.8DD8A7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3026A0010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m+K2QXP/";
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7wVyaLFDwSh4RsQ7x/yFwVaLvEj62at9uwFUzmPLMc=;
	b=WjZyCfhAyNsz9wKQjz4faiQ1RkYVrKZmbogIq75bCfhDSABgRQQLWyarp6ENqaEvdxGOr6
	zgqVoI8SILv+vYbgUaBdMlKPHBVfmQqlxlWtXg26hzJVkndqSL8n4BoUTd5uG/XqYdR6ER
	sFxNypDQZ+bWws1MSz9kB+WZT6NwhyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471950;
	b=54uEd8BiJlzRVzs4oXP/AFaWdp3dF6Qe4j/tc6gFsYIH24KwWNwuUg3diUbXNT/ymDibrK
	IIPHp42TlnO/o1TG+tkpflIMkThficyDIg69wZaTVBHwUoBYXHNJW66CnZrYgLgFIYFjYY
	iqsHQn4xZRAKrOyD/L5s307Znb1qxZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m+K2QXP/";
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49224600D1;
	Tue, 15 Sep 2026 11:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80221F000FF;
	Tue, 15 Sep 2026 11:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471950;
	bh=i7wVyaLFDwSh4RsQ7x/yFwVaLvEj62at9uwFUzmPLMc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m+K2QXP/zbRGzsTYOiazh6maQXF3AuGZOI8kte5zBpS/uMcEZtnwlKYDvWPSx21mx
	 7TGqdB2C/asSsMklDxBThdjFd165iUvhBszGEb7vDKiAwqKwu88ALg4R3OQntDPmSy
	 pL009b1opBUWgVeuBuk7lGh4yrLHaVwvTc34V6si7vaZd9pMcP+QTIh2EpkZPCrPHa
	 roLy/D8FmA6vUFej8GssEIMuVEW8Xxbjc55QWU2ylDQo6Q1WZPwq27fmmdRMZbmLVP
	 oJ72BLK/Gp1V/aWXjwbp1rJsiSD2B/wSlHgBuF1q53c4nr7kcTHLIyN7mofScYlI7c
	 A/WVLIvzUUtlw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:55 +0200
Subject: [PATCH RFC POC 09/50] m68k: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-9-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4471; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vs7iz3bKLJG7CXsTvZEBdGx9Li08YdT/8Wd/px3d4TY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KnprokIqSkKVD/KZ/524Xdnh56o/lnaM35m5YhWv
 xThf2beUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJG4VkaGBu1Lkfsvr6ti2m+Q
 0zx3V73WWh1tb5Pp3pZGNvef1XwNY2Q4/KqPv1PzYdm70LqORZH7stbOZDNYK+obXGf+cLdIFAc
 jAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3026A0010
X-Stat-Signature: zt6sqmpw8dxh71hyyac6ybh9akrsikh6
X-Rspam-User: 
X-HE-Tag: 1789471950-924861
X-HE-Meta: U2FsdGVkX19+8CaTDNvmviMm67uCnuosMgMBcL/KrEUcTyMak5D998U5aJPMtDItZPkEtK7aj/0armhKll7NpuhYpB/F22ji5RyISo3h5cqH5+77iCuyJy3i2+NpU8OAZ6k/H+j1K1EypCli20fyt43SPbn4jaZervjnt6S9mNq+G/lUduHzwTK4tfzP0KPTuSa2An2sWcqLhsftZmtXr9ipNiZKSPDmLuREzXXj7RnEEG6Or1wBSv5VsWF1EXJTRATNgvjGVDsiC6TqxZQDI+ZmVE4rH1HFS99ZFkOxqjQ4BRkv2XK4HE8jGBlY0pF++9e1/kqbCoUoKXaPp4oQaLZxiX+LgRI4aNbxWznv7UdkEsYgvd6u+StL8ufGk5VJWit1AL7AXDTtAsG9ttkMvLqgs8drMIix0NJUbAnjFh174z0v/bf3GK44YphuyTSxy3qlXe6FY7NNUccmmJaxRXuEuwXg49V4mp4RHnQ5oAy/7S7NB7RD2mMII5Hu0fUxLHhpXAaB3UZaGkMgimkr9/4Skap9pBeZp46xcvFZeTsBNF4x8j2uz1ky2+vOAzyHD4JP5llI5WOjpbqmS75HmVSAD4UTuXdrKXK2yi+7yX0FUtNMyJkMC3CnBefwkUk/oCutrolmHAmDE9KWP/eOeGwfeRKo5ET6DYhlq4JxGd3Uw2P2m+Y+hPsHZN/VjPn7pMD6RSjzdUfreHQFORQNlfAAkNFp1HoSpGbemNIp1MNRj3yPcAG1sYHx7AqRnhy+/vwHA3brmh1CEmiu46ww9muY6bedPxSs0eJTcWQm/JovMkw+uX5cRTYKrDSgMvh8r5jddIpu3Y7hkK7gIKNNRtRat7+j60QhJaMwvcoc7A4ES0++Tyo3gGRQJUJoYLNBKmuTbnU9jI8B4iERyj3+cv1c36dPEcPsaiNLnH+JZ98FwVFZujwAaRNY5IZsFGGAyjugd7BsOckGHFe3KQn
 eMRXVXQC
 qO9Pq6ShGD2A9CBRoItJLss1cauQU7Mrj4aDAOylU/yaMa42yN9ml3uGV7O6XtqQt1T9UOxGjY7wsRtn938lKnoKAoHKB9AiuSj1+r7+8zWtv1puOrNypnwKwKr40N+C92dvHe3U+8XLZNHTVwrcKJNoHWOM24zVKn75Hjll+hOFzBQKF/H5IEl9FUd31SIbNkxuE9Q693HTqz3OiAORLN9OIiK0cnjIvM8hZAyWG5TSjgxl87bf6skLyvijw+DJeRG3q97y6PDvtWkowMQvfaVl5aebLy/uLLw0j03KBUylol/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it on the untraced return from a system
call in all three entry paths. A task that reserved descriptors calls
syscall_trace_leave(), which commits them before the ptrace exit stop.
The traced paths already end up there.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/m68k/68000/entry.S             | 10 ++++++++++
 arch/m68k/coldfire/entry.S          | 12 ++++++++++++
 arch/m68k/include/asm/thread_info.h |  2 ++
 arch/m68k/kernel/entry.S            |  2 ++
 arch/m68k/kernel/ptrace.c           |  3 +++
 5 files changed, 29 insertions(+)

diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index c257cc415c47..479032af2f2f 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -89,6 +89,16 @@ ENTRY(system_call)
 	jbsr	%a0@
 	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value*/
 
+	/* descriptors reserved by the syscall are committed in syscall_trace_leave */
+	getthreadinfo
+	btst	#(TIF_FD_SLOTS%8),%a2@(TINFO_FLAGS+(31-TIF_FD_SLOTS)/8)
+	jeq	ret_from_exception
+	subql	#4,%sp			/* dummy return address */
+	SAVE_SWITCH_STACK
+	jbsr	syscall_trace_leave
+	RESTORE_SWITCH_STACK
+	addql	#4,%sp
+
 ret_from_exception:
 	btst	#5,%sp@(PT_OFF_SR)	/* check if returning to kernel*/
 	jeq	Luser_return		/* if so, skip resched, signals*/
diff --git a/arch/m68k/coldfire/entry.S b/arch/m68k/coldfire/entry.S
index 4ea08336e2fb..43e47d4c0018 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -78,6 +78,18 @@ ENTRY(system_call)
 	movel	%d3,%a0
 	jbsr	%a0@
 	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value */
+
+	/* descriptors reserved by the syscall are committed in syscall_trace_leave */
+	movel	%sp,%d2			/* get thread_info pointer */
+	andl	#-THREAD_SIZE,%d2	/* at start of kernel stack */
+	movel	%d2,%a0
+	btst	#(TIF_FD_SLOTS%8),%a0@(TINFO_FLAGS+(31-TIF_FD_SLOTS)/8)
+	jeq	ret_from_exception
+	subql	#4,%sp			/* dummy return address */
+	SAVE_SWITCH_STACK
+	jbsr	syscall_trace_leave
+	RESTORE_SWITCH_STACK
+	addql	#4,%sp
 	jra	ret_from_exception
 1:
 	movel	#-ENOSYS,%d2		/* strace needs -ENOSYS in PT_OFF_D0 */
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index 5cb3ace55622..861b6f523bda 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -62,6 +62,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_SIGPENDING		6	/* signal pending */
 #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
+#define TIF_FD_SLOTS		12	/* syscall prepared descriptors */
 #define TIF_SECCOMP		13	/* seccomp syscall filtering active */
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
@@ -71,6 +72,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_DELAYED_TRACE	(1 << TIF_DELAYED_TRACE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 338b474910f7..9e4471f68165 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -229,6 +229,8 @@ ret_from_syscall:
 syscall_exit_work:
 	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
 	bnes	1b			| if so, skip resched, signals
+	btst	#4,%a1@(TINFO_FLAGS+2)	| TIF_FD_SLOTS: commit descriptors
+	jne	do_trace_exit
 	lslw	#1,%d0
 	jcs	do_trace_exit
 	jmi	do_delayed_trace
diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 4575f6487a9a..07103e6ddeb0 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/mm.h>
@@ -289,6 +290,8 @@ asmlinkage int syscall_trace_enter(void)
 
 asmlinkage void syscall_trace_leave(void)
 {
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(task_pt_regs(current));
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ptrace_report_syscall_exit(task_pt_regs(current), 0);
 }

-- 
2.53.0



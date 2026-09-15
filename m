Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765D3C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A6B6B009D; Tue, 15 Sep 2026 07:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860456B009E; Tue, 15 Sep 2026 07:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7789A6B009F; Tue, 15 Sep 2026 07:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47B346B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:32:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9EF21403DE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:16 +0000 (UTC)
X-FDA: 85215783072.05.F05E1A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 127701C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUEfB7kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUEfB7kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471935;
	b=Bigzo8Hx8Omj7FcIamDcCnMe3HNqSw259v+ud2w3WOkAP/RNJz7IXB+5mEOjERks8IGkoi
	53d2wg06UeEcvJ1mpuFTU6m5Z44VNrVxNVaC8Zng4aeXEMFsv4LfkxzUTrw0PxKOmhahWy
	MPG5jpzllxuQEkrbkbZ9f95wFDba9RI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/WcE2lGsMFSob/cBMgO+hea6aPl2xaxNOKxSHdhki0=;
	b=rITjEVPxTFyiHNuUFuEn0qv2yM9XNxQhwFPekAWLsyl2AmMo12Vv73B8QbsBNRmh9OviDr
	KCmeH79YUWxiqBfVb23IQUddx5szvvE3sUM+w1c1f042Kmcc2K/j8HXfINwsZAgyqPcZTN
	L757XSkA7DJRz4GYl1Rks5vRctBILm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FF69602A8;
	Tue, 15 Sep 2026 11:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD8B1F000FF;
	Tue, 15 Sep 2026 11:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471934;
	bh=E/WcE2lGsMFSob/cBMgO+hea6aPl2xaxNOKxSHdhki0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GUEfB7kz965znZtfpHqb8eIiCiLO6486hnBmkQwRyzaxNwEFt42WOgfKGny2AO9jY
	 DpqE0IKoYZQ3CDqUbNbcjMdJnHniI4Fwuvms6GgbMB9wf1VAHv7229/U9I1vFe9NJ2
	 qY36omvqqIoX9NFkJOdvBvJQPo9mZFT+l30lGkj4F5tMWGVWdBHQTO1lqNMxuFrqVO
	 OfO8kqQ7j1k9tC1TlYJ8bqUqsF+G/mO7jEhf7l0Ip9oOnDoxcn+y9v2WqMllKuuodC
	 iV25Lg90bMELqmrBnnnzxEgH4HOX9MN+zPjb9ZEZ2BQQYFgld28sSUlqTUgIhK2Mo5
	 y/yD7KaWeZ/WQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:53 +0200
Subject: [PATCH RFC POC 07/50] csky: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-7-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2976; i=brauner@kernel.org;
 h=from:subject:message-id; bh=a9znqAkO+hvOtZefxwIBQ5T2UBtQYyo8n09NKXNA7dw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmReJL5+9/LafuaZn07vvD2NNsTS/r9pju0zTneI
 MsZ4PDocUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE4p0Z/vsI/l1WJ+2YWb1+
 rv5bmZs79nw5b7JPKv5J5eJeHt8sXQeG/zUtrlyha6a8POM74Rhn8++6CEYXZZkjm45o/epqCbm
 3lRkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 127701C0003
X-Stat-Signature: 6ibfuapdehpoyrc7hp4qa5nxjgzp3j61
X-Rspamd-Server: rspam01
X-HE-Tag: 1789471934-470801
X-HE-Meta: U2FsdGVkX18s6jO2Tu6vb9uCrqQeap1Sad7Z/8bcdJH6h483bOIzjyd4RqKoQ+T9jgQU+sDihDl+okSdSFmNtlwY3g1PcqokYj6trq4Rz3jlhh04PSXlq96cNoQmfioMwA4OF0fJYBMAE3vU41O1cFd+XLsHElIhyKiVtc+M8JHWlkrmQ8Sye5dWlNiGvQgtH0ePn/I3silg0wJUrrNPpVrA+k7vAqiRiBBtjOQDwwT3eKtG12HVBTpS+z8PjA6FTcKYo2lBH/ma+VU3BJnLZZvLORiihP09J9w37E8Z+hHuhF6w/bEB969jhsQSe2LJajfqais/hG/6j1dD1U/R+sB7xbYcUCXfEVmiiOmFCBxm1qIO6WEb2A7YBTZFSdnfDT4kLUswJAxuRXloDstXiC83OvKLrVW71hHKStCZLuPCe7VAgm/VJqvSnBdxfG0Gaho2PM10Q+jmNaDNEhGjYxI/pHn2f7qqq33TTyG8UjXADXpx9kHdO+rLFXHbsM9Q3vhKjA5Nk2Jv684xOaD9mVeglJZRk7AAX8QY8VywJRB8/4380Z4RM7tNST1ygfoKN3CeKWUUrNn0VO2S353FMTacUe8b/f/W/L8bweyuWhDf18hWXXCdEt7TNs3pkKEI+yaOocQ3Ez0LJlR38wxplTaK0S2ode75vsJNpPjGVaqHx5SqWsqWU35SO4pfAPczmz7hGBnli/r524k3JfDXpBSrqAf7byFirbf0j9+j3qwpt5lZJBlIiqZjp/xyJqdtjI3Kq7pHQa2bgt6NwTrXlzEgYsSc3mWG9h+blBJPaYUuq4P+hN4MMGeXiJmkC7PHNgn5GwVDRL7crzK2c6wat2DAWOvwfKa9TXLW6TRpWv+tyeGKaR+Jc2sa33ymc8xRZTXtgcDyML5WJl0Uz0JTI8N27jWXpxFmc+ZXbhSuqgcjvZcTPm1q37DFojI59SVc1PqLihy+CvU6riZxae7
 S/hajQUG
 KaVCSQDumUxt+JWyr5KwS+96QVZbs8tKZ5XYmeeX3tnrCno9sWn5dChCr1LHzzSotLIjRzOltCjqTtNgZB4ypdrJWhRqowMutbUaO0D3VUpAOU9icvqt/bEPx+r6mr80KNupoVaAVD/OzqX5/WBefrlG4d/2AkINnvxFKJyubTay4n1+dwaO07YC2YVR6fmB5RIYZ8zTlnqyzVgvS9YuEd+treMdhQJkeHq9hMXmVKhCcxej0SgI397bf6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it after the untraced system call has
stored its return value. A task that reserved descriptors joins the
traced path, where syscall_trace_exit() commits them before audit and
the ptrace exit stop.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/csky/include/asm/thread_info.h | 2 ++
 arch/csky/kernel/entry.S            | 9 +++++++++
 arch/csky/kernel/ptrace.c           | 4 ++++
 3 files changed, 15 insertions(+)

diff --git a/arch/csky/include/asm/thread_info.h b/arch/csky/include/asm/thread_info.h
index fdd4f8ad45ac..59109ce64695 100644
--- a/arch/csky/include/asm/thread_info.h
+++ b/arch/csky/include/asm/thread_info.h
@@ -61,6 +61,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACEPOINT	5       /* syscall tracepoint instrumentation */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing */
 #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
+#define TIF_FD_SLOTS		8	/* syscall prepared descriptors */
 #define TIF_POLLING_NRFLAG	16	/* poll_idle() is TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18      /* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
@@ -73,6 +74,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
diff --git a/arch/csky/kernel/entry.S b/arch/csky/kernel/entry.S
index 3261f46f2244..6ff3074b9787 100644
--- a/arch/csky/kernel/entry.S
+++ b/arch/csky/kernel/entry.S
@@ -80,6 +80,15 @@ ENTRY(csky_systemcall)
 	jsr     syscallid
 #endif
 	stw     a0, (sp, LSAVE_A0)      /* Save return value */
+	/* descriptors reserved by the syscall are committed in syscall_trace_exit() */
+	mov     r9, sp
+	bmaski  r10, THREAD_SHIFT
+	andn    r9, r10
+	ldw     r10, (r9, TINFO_FLAGS)
+	lrw	r9, _TIF_FD_SLOTS
+	and	r10, r9
+	cmpnei	r10, 0
+	bt      1f
 	jmpi    ret_from_exception
 
 csky_syscall_trace:
diff --git a/arch/csky/kernel/ptrace.c b/arch/csky/kernel/ptrace.c
index ee2867a1576e..b19fef9d396d 100644
--- a/arch/csky/kernel/ptrace.c
+++ b/arch/csky/kernel/ptrace.c
@@ -4,6 +4,7 @@
 #include <linux/audit.h>
 #include <linux/elf.h>
 #include <linux/errno.h>
+#include <linux/file.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/ptrace.h>
@@ -335,6 +336,9 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))

-- 
2.53.0



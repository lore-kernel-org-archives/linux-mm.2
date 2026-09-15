Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE16C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34686B00AE; Tue, 15 Sep 2026 07:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DE56B00AF; Tue, 15 Sep 2026 07:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5FC6B00B0; Tue, 15 Sep 2026 07:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD696B00AE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22CB5803BF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:41 +0000 (UTC)
X-FDA: 85215786642.22.1F4DB62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 690A640007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m6JS+1os;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472019;
	b=gVbu414PtI8LowDSGo4IjjXicPeO1+/eyBcK/p3lkbY0t9onvI4NBNC1ldRNwgjbNSMzzL
	1kgQqGw8Ed7mGlsWNH0/2G7GOH4qgMio6dC83Dk2n6vVxkreQmuqLyK4GFa9x8n0kLCc7r
	svZD/eDyLRYP9iTeuFYPsb8fZwLhS2Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m6JS+1os;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Opabrir2qKnajEOx/bmqQ0vFOOuJF5mcXpUx8QfYgRo=;
	b=yfUA08Fq6QMzocWWgskA7wrFMVL2bATvZJ9ED8i9HfwJkaZ2O6Y/2Unxp2QGo+0wO/clHK
	8fvMjw7CZIpgTLJovpMf3AUIMDKwRhd86i+VSVUakA6W8fzIZ2/QpPpcWqV+WGre/OQOz8
	AHOdvh9WouieQFhpynRjnSE+cl1stjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A7A3602CA;
	Tue, 15 Sep 2026 11:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A06C1F000FF;
	Tue, 15 Sep 2026 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472018;
	bh=Opabrir2qKnajEOx/bmqQ0vFOOuJF5mcXpUx8QfYgRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m6JS+1osV+HHQ3+stbRMi1nG57ukYiJTEcH35bNEsuFkz3EDpaPqRCxptR5myI3CQ
	 DrVL3ticaSsEmHs4hzrQOkVHuI+pRvmExpm7hSTVT1Fy4ahKbV0yxhDmvASrd6aMLO
	 kfyvZnG8hPY/OSMfxVk2m1KEfL0A4tlDKieBNoYaPaJt6kinrooutLXDgSWdlzJaI4
	 Qyu0CqnjMLHGESZU0vH6Xh9zHueNHEtLJB7dyoK2455umDXJ25s2IeNCaoYNiPSyj5
	 BtthgxR3vTZnXL/kG06SW2wMzb3uuLV+YqWCArv2R8bMdgvjWU+Ck1onWTajB/my7G
	 f4cwtNsAzJb3g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:04 +0200
Subject: [PATCH RFC POC 18/50] xtensa: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-18-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2590; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ob3PjpQ/cxpLv/3i+RPAC4oxtU+7SyXGKknKtjIi6uA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Km1PCQWPOf+dN42p7eiixMDrC8oHl3XfDxb8HXeu
 Q8v17M86ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIlRQjwxxl+ehP3JqHnz5Z
 rnHMf3GFlcCby16MDPn/pqho/776ZA8jwwxuu0Z35YDFs7a2ZE2t16lXXVd42bXR6lPXzm5Ltrk
 6jAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 690A640007
X-Stat-Signature: dhfwffjkan65qc1k7hwfsrrjjuzd8kou
X-HE-Tag: 1789472019-446137
X-HE-Meta: U2FsdGVkX18bvbVLrGD/cyivYtNXKGfw1bpv8lTezrUAfjJHjXDict98fi0l17zq9DIWNCAq+LkPfYA1Mcw+XPivl5q4faltpvisPTXO5ztOHw4WE8SgIlzB7JHY3WUx24hlyfO+F4zaclCnFyaOENaip90fcXIR1EGfH3InBei7QnqOJWmsvlf47IxNSelkLwO46lL2dnuD1n1vy4gb5c0fz5QeNLl6M+pBGZbiuybelKic+vHY5TocWIpP6tjUOLZFRs4OCknn7YwbPL2uDkYNuxHlag+hY+uwuvM9Fssftwo2R4Gdzu+V39BDLJybljACuayfrWDFKQjIX+ti7ItcCtBIU0ZPGWOdfk0tXzYWIuDq7+MtIe9irgedw8xA1nMj5nlRAFDfX5t6ulqhbpgMX7Z9+PTqgJ+EYSqwlRQzLurIOEN8eZaCXADuJWo33FXFrO+Jq3v/xPxY97BjeY49+BYnEKF27YBN/uf51DDjwp1xBHMhHZta+df27ZoGTc8TQdS/S/6qOWnKtavVETrCuBOcGRNbpW6cxFJqXD2LNevGyT7G+y+xVLYd21WHZKnfZENzMzLX1jxTrL0INuv+8qRJ1avy6TvxxfP/L4DkNi9latc8silo1ldL4ol2FpzzuKGweJRcn10OhGtL6fclVU1cc4evz97kaz2fit9qGZ29P88q7B8IcZhqqkM7iLVKgPi4ePffXcYe2DSG0orjSkad01D6eUDk+4+Zgbx1/x9yUVlFHlMMJM8N3IsSA1MNKprkT+hyXTLAitiQxazJlgwc63oSWVVbGtGlZE15aZbDERUJHXjhXgWlZKMHWha33lER+p1bOIMvXthBTcHhHaiQMQwpKBs2Y/P2bsp2SKiJK7+VC5MtdAt4TI+KMcr2XsgUhsdVqhvlDqIvfbkv8PbgoPOO4l/v3UYuuBEY7YxhuGz/Vxpf63zALlNgdnE/rJn7Dch/+SK+MXv
 h9uuTf5d
 5KXPjXD1snrufEgj2jXe3dQl/B/ZSUVEZUuLArBIEslJtjpC+mk+MTHjLfy06Fb4oUN0dQIvmVSCoowZPY1QqL8P6FaulWxsQRQpjCKohlamdQr+N20OP0sVjoHMfTyFYutqdFdFVOR6RgxbfZjsQPAlfGQ48nZfP9CIbJIGVifQ1Cq13NCwBVQ1UBxbYNDSC4zAB0LLPyaBEtKqBIL2SusT4N9gn0ZzziIDZBGTDVLyUG/0Ow0onKI5ZIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it once the system call has stored its
return value. A task that reserved descriptors uses the traced path.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/include/asm/thread_info.h | 2 ++
 arch/xtensa/kernel/entry.S            | 5 +++++
 arch/xtensa/kernel/ptrace.c           | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 5b74dfc35ef9..0c8eb5dc8398 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -124,6 +124,7 @@ static __always_inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_MEMDIE		11	/* is terminating due to OOM killer */
+#define TIF_FD_SLOTS		12	/* syscall prepared descriptors */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -134,6 +135,7 @@ static __always_inline struct thread_info *current_thread_info(void)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
+#define _TIF_FD_SLOTS		(1<<TIF_FD_SLOTS)
 
 #define _TIF_WORK_MASK		(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
 				 _TIF_SYSCALL_TRACEPOINT | \
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 272fff587907..4b95f48736e6 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1976,6 +1976,11 @@ ENTRY(system_call)
 1:	/* regs->areg[2] = return_value */
 
 	s32i	abi_rv, abi_saved0, PT_AREG2
+
+	/* descriptors reserved by the syscall are committed in do_syscall_trace_leave */
+	GET_THREAD_INFO(a4, a1)
+	l32i	a4, a4, TI_FLAGS
+	bbsi.l	a4, TIF_FD_SLOTS, 1f
 	bnez	abi_saved1, 1f
 .Lsyscall_exit:
 #if defined(__XTENSA_WINDOWED_ABI__)
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 364e4fdabb00..d44d62a56b85 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/audit.h>
+#include <linux/file.h>
 #include <linux/errno.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/kernel.h>
@@ -571,6 +572,9 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 {
 	int step;
 
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	audit_syscall_exit(regs);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))

-- 
2.53.0



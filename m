Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 566A6C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666506B009E; Tue, 15 Sep 2026 07:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F2A6B009F; Tue, 15 Sep 2026 07:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555676B00A0; Tue, 15 Sep 2026 07:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 336F06B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:32:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF9D7C03E7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:24 +0000 (UTC)
X-FDA: 85215783408.30.00DF3B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EF12C4000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KsZ0YSeM;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471943;
	b=XLTt0yhDAJdhhlzuc/Q1ecWS5h1nr0TQmpB1OiUFp18YwsjmMt/JgLmCjgth1f+ICmE2+6
	jmR0b3+rNHxoQcsqmcrzA2TErOvQWr6RyKJlcXYtnS7bWsyLO62JLuE5vXs6bnn6+45rIM
	tj+/6B7uxTdt7BGTGVVUlpnnF5qi+ZY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KsZ0YSeM;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sj/TXeU8lbnq/VrgmP1w7bpiu8kxbau6iQA5smJm308=;
	b=v7IiHWuFSc/bWt0V5REWzOKKU2a/5LGftOkKYXVeJiHp1Od9Dztug5X3+6LU3WAJtQ6chg
	vtTQS/juafQQ+AU+ARo8QEeRitOcoAPfIEosnTp5TvgSGTfcqiFl5hAQ8g13b5GP0XOOF8
	D+f3qtWIbPlXygzYKFgpePUCshGW1Jg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 510B242A92;
	Tue, 15 Sep 2026 11:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D2C1F00898;
	Tue, 15 Sep 2026 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471942;
	bh=sj/TXeU8lbnq/VrgmP1w7bpiu8kxbau6iQA5smJm308=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KsZ0YSeM3U31KwXzuSOBPVbLhE9vK4Yxa17kxnYE4VLLcBpXFBViJ7MpY18d0q6fg
	 Dlkn+mjs3MbZWkyHFiqCn2El/got/SWIrC3Q6gwcviuJR1/ai315fCDOEzDtjnFUA+
	 ERro30MRjCev/KMJgcrZtL2o1gUZZKhbA8HyLbu41oPLd1EatgWYME4stynmbpZ0mz
	 K2X3JgB7AebymzKvLiHCEwmgdxwueAGGvA/T8oKFv3D8nL35LXrTyGPgC1/a4X9Lk0
	 vYiOSTed74edj4byJ8eheDQrzWMKeMINNC4B6wsUI+361fX0pdzSzZSfMUdSTok96o
	 JldIOwL5KHMLA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:54 +0200
Subject: [PATCH RFC POC 08/50] hexagon: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-8-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2326; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Bf/Nt9MIp5BYByx3VQiEgkxrXuUu+w3TElLZR1b5xXU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KlxSfoWG7jlfrZ0K0tn4qOUcP+ecLZEh3DTGxwiP
 //KiUzqKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMieN4wMd9vcWj+ZhdjGz730
 0Td4Qozfzkm7T2q1yV5i3fu0zPsfNyPDAc8V881XLgs7f0Ke7TKroLtaVRyno/+PV+zTfzPk3mr
 iBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF12C4000E
X-Rspam-User: 
X-Stat-Signature: x7fidgp9ibe7hurxxyrxrk3oun68kgck
X-HE-Tag: 1789471942-183436
X-HE-Meta: U2FsdGVkX187l+sGja2a4wGQ3LibSfwYtEUN8Rxt/jjVCfGdxSz5VM2Xwe09M6+LdtnLHYR2FTTdlg3+A8dKdS8AjoqpSotqaukwkv5Q6nOZWPnBJMs2T3mm/rBou8lhPRp8SHXjZyf7P+YmiqTnbvBJzR8Ikps1vgqkWLvVkhSu4QPzNyocs5jVoImVajUw/EUfeRHFg0HQZCvsstF5N/OqEVhaocXsICBx42FhGWuz4ibE5xqk3g+nBz9/bxdwzhw6WM143RsnJQujhpzG4eEYm4/guu8n+QTUUaAO476/ocaxFQIdsCgTzp8YD0XLWWI0vt6bl08/WDjTEuWohbC9IlEFNCMz//QmWk9/lKuHDrubWa5O5pTIY1N3fBmP46KTV1DbrnnEYhWC4ydEkoflKwKUSnPQ1q3W67ZNyhNm3mwlcOi491zugpcQ4CEV0c/bUAM7JAUjszi4IJfYmlNr9yexPFjbNOxuVdPmId6JOsyVl+8QdWMCDbJRzCbUInf0csvMkpzT3zPmBKKr04CIBGxYwc9LgtBonrzB+qYBBDR5bX8cvpviioVBiIfHrCNlfqWE8bdSCuULDkpxx1wfdE73VGWnqSacl+lNDTl7sPeOtj6McQ0gQ7SPT+6pI9p1ZnYvmxSNxkaN2SPyT1AxYyLlJi02P4wDD3FcUNxeR49+XgZTJwlm6oB14OlJGhEV0YxtwuZVe/i8voOTpxkpTC0pEf6DC0tNF4V8o5kmWIJFYv/1GoYRm7idbdTMgY9lJB9D9IBdoycVl7pXBQs81TZ476b1DysLbPO8CSPiBpmVret4moXSC8VIBA0rHQzgHyf0O+Ixx9HlOdrKvzI5yFa0+KyjPw3PIv5X+9Cz40s8pZp+E4XKS03WeDbnQCPsSyZTi4OuYR2wkA9H8vpFwTfudsHaGTnWdM2HizLzXBmE9SUVsJdolj48pxCER/xujpHG9/MJnSFbTpu
 chRj0NDj
 Rrj8Tgt044oDk3nX53+FzSoiKX/nSMgHkFw3GWPxaxEVb2H8YhGuKGdS5UMxrSORDNqHjxwM2CROTk9AKckUwnWn4p5mC8qGSBDZUQ6elpY3Mhj6PmGdIdGER4upaK/Je00QH+Ayiyoh7QULirnfg/BLZZQ1g1XXQyb5zOj245iF5F/kb6c0DBNlizWDxRx2rXKMu+Nxc8iu2OMhPKNHw4J/WURxB6u86C45KLMB4BYpS7VM5BHF0pCFROg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it in do_trap0() once the system call has
returned, before the ptrace exit stop gets to see the result.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/hexagon/include/asm/thread_info.h | 2 ++
 arch/hexagon/kernel/traps.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index e90f280b9ce3..8558d2d147f8 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -88,6 +88,7 @@ register struct thread_info *__current_thread_info asm(QUOTED_THREADINFO_REG);
 #define TIF_SIGPENDING          2       /* signal pending */
 #define TIF_NEED_RESCHED        3       /* rescheduling necessary */
 #define TIF_SINGLESTEP          4       /* restore ss @ return to usr mode */
+#define TIF_FD_SLOTS          5       /* syscall prepared descriptors */
 #define TIF_RESTORE_SIGMASK     6       /* restore sig mask in do_signal() */
 #define TIF_NOTIFY_SIGNAL	7       /* signal notifications exist */
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
@@ -98,6 +99,7 @@ register struct thread_info *__current_thread_info asm(QUOTED_THREADINFO_REG);
 #define _TIF_SIGPENDING         (1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED       (1 << TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP         (1 << TIF_SINGLESTEP)
+#define _TIF_FD_SLOTS         (1 << TIF_FD_SLOTS)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 
 /* work to do on interrupt/exception return - All but TIF_SYSCALL_TRACE */
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 6fe0c1b62c1b..4d15c5212fd7 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/file.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
@@ -381,6 +382,9 @@ void do_trap0(struct pt_regs *regs)
 				   regs->r04, regs->r05);
 		}
 
+		if (unlikely(test_thread_flag(TIF_FD_SLOTS)))
+			fd_slots_commit(regs);
+
 		/* allow strace to get the syscall return state  */
 		if (unlikely(test_thread_flag(TIF_SYSCALL_TRACE)))
 			ptrace_report_syscall_exit(regs, 0);

-- 
2.53.0



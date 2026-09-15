Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1393DC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295B46B0098; Tue, 15 Sep 2026 07:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DCA6B0099; Tue, 15 Sep 2026 07:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184D86B009B; Tue, 15 Sep 2026 07:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E88A46B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:32:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A3CA803BC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:32:01 +0000 (UTC)
X-FDA: 85215782442.09.96A93EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BD70540006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOznBN+U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471919;
	b=OTCmpqR6qtfOobBE7PiK9LSAgr4h2FAO2sn6kN4efOVB/4CksyoaCz8HyBnuE51vCC8JSH
	vLwRmtllQj6wn7h/eGMfGfEzoXz3D5HitBMwLPMhdYXss5CnMiTPh1SZOBSStTe8tAp59X
	Z0Hojz1mu8vFSlUBvYTWLeoHTMkupjM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOznBN+U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bga1xdIPGJRsO6QHWVzlP+RWmBvnPkf9+o3GDcABEos=;
	b=Dw6TynrNjzXpTVbSLCvSLQ1SgR84xQ07uHnTgfL0uma+3DwUToBt5dmRCA18Fn7AJevUCo
	3ws6y9rDUsY4nsXSenECtEMoOS5HLsLA8FOocKzIGagUGbDx4j91ItRs8eEqjDtck9lM4T
	LVhle5cRms4rfAb7Q4FNR3M7egFdHME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F429602C2;
	Tue, 15 Sep 2026 11:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4E41F000FF;
	Tue, 15 Sep 2026 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471919;
	bh=bga1xdIPGJRsO6QHWVzlP+RWmBvnPkf9+o3GDcABEos=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OOznBN+Uf6IkiE8I3kD7TX7An2UpW0UjMLCLWj0BehlzG79yWV8en/tlA/s8DbCrh
	 gWRF74c5iDgkaUKo3rLCkI06/mmx8PwQrzIzKtgKISnzxu+yTiJJLaPHivmCUb4yet
	 gsRSlrguCJTnrR6nfgasLlAJM/1CI/n29XMPtqVvwFxiyrAy2oSTUsfReKdzSibjFi
	 5eiTmh3x1iddDiLDSAh8Q8A5d5+aZVRA3lVTsp8ZS34IsIv2CrR/Nnb2p9GmOr9yTL
	 OCrvlFBZq7VekXjV8m8ckamzk+StbMN2Ma1rK0MuqF7AWmaoazDWObNjYBOIBY0W/z
	 h3FYCx98O7b3Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:30:51 +0200
Subject: [PATCH RFC POC 05/50] ARM: commit fds on syscall exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-5-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2837; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VK90OItgH7MXKBBbqC1mLihQj+HZYKN65ZEaMtX+9Ng=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmZbrpIOHqtq7zi6WwlNR3r5y5nTvJML3y6vyFW/
 qkM8+m/HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5I8fwP+zW1CD2pQbsZaa6
 tgaTGX+ejU8rUZFb+L5V587bxX43/BkZ9r6dbPjsAn/5JEu7vPbfq3cc+M++af5MlaWxDNouzVe
 7mQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD70540006
X-Stat-Signature: yxyayakhkjtqdwgr1dbakqgasi413ijr
X-HE-Tag: 1789471919-953143
X-HE-Meta: U2FsdGVkX19ndVuDh2Dy0FYqDhZMIXPq3W/K9JJtoTSOQCz9oOvMcnhYnmwqFNv11U+2Ik3aiJ58AnbRjeQxsBjyh4vkHjHu3rVvi80HP4ieQwTUoG2Gsq4OEumrWfChC+3N21cOA4VYAKo2YvLWt4G5X30258i8uPWb8t38/tlPnh2iC8BeRdcU3A2Qv85w+yKplJvDCgihIWHmBkq2cskR1Cl7654quuIyEvyscpA0L53B+Vlr46dzXqxCj/lQhV5k8CXSW+2BNW7T179RvBt/0vBF+36SVAktLgHC9qAhmFWNb08jSPvJPprY3k+oAOtDdjNAgkvX/fjMog/u1NMcsi00DClzkvhJLh1KsWaDJeYxhTuLz68B9UyWIBBb3FN5S/FLyntFBY1jOZurVCdCuZFD+5D2cwDLHWBgx5uYsh8NjIeuYG3yBig7vbZYqyoP2n2Sv50883s2zLby9GClk75aK8dAWO0j64iNahxjGxRRAjy02DiDyDxTIi///MOZ1wdpbNuNnEWCjMilqol6CdDL5BRGIZ1sgVb7RFFTSK+Fd9MwYdJqp3ffNcsJs6p8tsGHWwNC+/ErHqYU8W3vNItEBeincmGVh2SGaqorVsTaBXfrJIrPsO51DVmUVeF5s0ZYPN2lpcTTrZrPBDg0zuF143oHufKJ/YNXyRY58y6is8xyWnc/I1UwmeMZKKP3jnlf8Y6nJXTulp3BwHeDFRQSB0itR9PQbP5wMmmvpkTNFe9NJm7zLFhzBWx/++sIm4Z2jI8ZV8mN2hrK5SgRKqVlTafkZyeRM5z2oqunEuPJhheVSLn7OOA/idtr/EB0ED+kByE+2xHEiFFkD/0dvc4dsqrJMJLF3Jg3S3WF84BrnFTg9zOC6OhuGYYSj4gjbcoHykZoFiJ5tVzcYw27LymWlJt8l7KXBuiSXyOk7iP6cU2v0pQtUfuxo9IGoRdjF8TGw19XP/DL0X/
 efVuOY7T
 x8NytGt2iLBL+R3EI/mXR1V5g3GvdV9d/HoE45e6bGhyM0FoSlArjKCfPDAmMLLcIjBZGMhETD1SOtkCg50OZdCohNfuCbtVfusgUnvv3TNzR5TusjlIXoFpi4Rq5dbQmEPRq1xje7vVgmAiHIOvr6zLoKSD4bn23fq6hgV+gr5W7nT0iS6wsSAVCWNEcQIHaCf0mz6ZteM3oY+HReb2O14TknatnlKL6rUJTQjQzniQ+coSj96MWOleLjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add TIF_FD_SLOTS and test it where the syscall return path decides
between the syscall work and the plain work pending slow path. A task
that reserved descriptors goes through __sys_trace_return_nosave
where syscall_trace_exit() commits them before audit and the ptrace
exit stop. The traced path already ends up there.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/arm/include/asm/thread_info.h | 2 ++
 arch/arm/kernel/entry-common.S     | 2 ++
 arch/arm/kernel/ptrace.c           | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 943ffcf069d2..5337449e8409 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -144,6 +144,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp *,
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_UPROBE		3	/* breakpointed or singlestepping */
 #define TIF_NOTIFY_SIGNAL	4	/* signal notifications exist */
+#define TIF_FD_SLOTS		5	/* syscall prepared descriptors, entry-common.S needs it below 16 */
 
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -163,6 +164,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp *,
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
+#define _TIF_FD_SLOTS		(1 << TIF_FD_SLOTS)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 
 /* Checks for any syscall work in entry-common.S */
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 88336a1292bb..59a70d90b0b6 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -83,6 +83,8 @@ ENDPROC(ret_fast_syscall)
 
 	tst	r1, #_TIF_SYSCALL_WORK
 	bne	__sys_trace_return_nosave
+	tst	r1, #(_TIF_FD_SLOTS << 16)	@ r1 holds TI_FLAGS << 16
+	bne	__sys_trace_return_nosave
 slow_work_pending:
 	mov	r0, sp				@ 'regs'
 	mov	r2, why				@ 'syscall'
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index ed7a2a87a670..75fe26012fcb 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -11,6 +11,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/mm.h>
 #include <linux/elf.h>
+#include <linux/file.h>
 #include <linux/smp.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
@@ -876,6 +877,9 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
+	if (test_thread_flag(TIF_FD_SLOTS))
+		fd_slots_commit(regs);
+
 	/*
 	 * Audit the syscall before anything else, as a debugger may
 	 * come in and change the current registers.

-- 
2.53.0



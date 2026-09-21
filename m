Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1A6C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31EE86B0096; Mon, 21 Sep 2026 17:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF1A6B0098; Mon, 21 Sep 2026 17:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197486B0099; Mon, 21 Sep 2026 17:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCA696B0096
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:00:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D012A02E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:52 +0000 (UTC)
X-FDA: 85238988744.14.BF03295
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FCC74000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=f3k9OjpZ;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790024450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dqs3u8rw3iSD+q7sDNmdGaZSDb+sElYZHHxIFq5uRQ=;
	b=qG5qBhnXEZ0f63iNhB+EXtFYZMPIv4FCsKjyR3xP4PT2EdDuZ6cZvp4zgAjdTICNZ8l5pu
	D8w3B8wKqFURWyaKeHSPV5iVmHWgb2Yl2SUlb9ndZMIpAUvWDFbArDEVehZtSo3pz8q5q2
	zrKOk01K8RNT5cNUUh/+ss5S9RSKPKI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=f3k9OjpZ;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790024450;
	b=ry0dDpEAG1zzqQuYe4WioQv0A5A7nOlFRT5u59OFfY7ipoLSi40ClWHYkcBi/4ef368fMd
	mKrm1/zb26xvam3Hxlb/a7KRdZjiWZSFKRf0eYCRaWqjy7Gq4QM0BcRZr/1LPxTekr1kVp
	fRcklCFhqJUazElGayXnNvmAoYPdd44=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43f9b120so32889787b3.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024449; x=1790629249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4dqs3u8rw3iSD+q7sDNmdGaZSDb+sElYZHHxIFq5uRQ=;
        b=f3k9OjpZkZG2/oOPtRjUNIGzvFV1Vqdz30MMFPnjlj6iZKaf8wP27+ACFSVinNY1wB
         +xRXmYjvkxjlnSEQjRKN0NlpeqhILEIO7G308szfyYtGxMbdCA05w5CYn02DFFHDyPxT
         WbeFfZOnZp8ChNreNuW6mKzZirwpFuqokpbhM82ATNXtxp5r9MnibF8rMnW5JF0JK3xx
         xMNrR8WTbDFmJ9hzkYleMW9fAYMEZk5C8CZI/Cwf7zOg4H01GGaoMFcYy0yEcA5NPtgk
         ES+Sq/l9tRundCzsxHZZ6Ne6r+TzEwRR2tei4zTbdFgLo5/4OPbaiDLHLK+Jq1IdezFe
         hlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024449; x=1790629249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4dqs3u8rw3iSD+q7sDNmdGaZSDb+sElYZHHxIFq5uRQ=;
        b=tTgCoGgkV63oSUzisArXRSLr/YaLVPjw6x1y0zZjbCQnmeqUZCW+HgSvVGqWFz2V1v
         9aKbgK82W2J2nhPL+11/Wgew8edVFFOmn8QJ5w6Fo2dV+oeNSsuEvJHewfUil/CHgBwN
         3YWTIyYt4lB4F25aLmu0ETGazjyN9ZPy3uCZPzvfygctcbC5pm14QjwTq8CgkPSPugDA
         sD7HqZzjpNtzjhuHTLILHyjy0hiZ8aLemR9EjQU68u0xcBY9R74xv1EKY5fTGM4FX0lw
         7wfwCYTGRqi0HaDftlZklewPchCVZjIPICKieJsAGRHILYV/suVZMcqGe+3kVz3Y/2cs
         Nskw==
X-Forwarded-Encrypted: i=1; AKwUvBy9kniWIH3rAEZdFN70PowPAFvn35aaOznzMGyILwq170nivHYHKiNqXzYZ/qNb7zr4chU9wjeHUw==@kvack.org
X-Gm-Message-State: AFuF++l5GVM9Qq5Pzgx091AyCePtu6b+wiWgqWNZ64ej1TGCBWIVpysA
	OrgbJVt6392FUBn4oba4jPyRygNfb4omOQybGjI0XbXHRpyCc2wjW+4mcPICe0QmaI0=
X-Gm-Gg: AYBFou0OQJg9tfZcUQxmqSGnhOTAc8Ukm+tZq5cUYRNAqTfqIVCbGry+7Oc5r1yaw+W
	aNGjMBU9OBybyiaOR7SVW88y3lX0CfYsRw5OxtA1xbAiY8bQfOFQEYc8KKJT6eck9n/OpvpTigl
	WdLKRZiAoqrX4/9m3hRMjBqhT03kRy0H5vBGqtzogXYK3k1gbu+dZx4IquEAig6pLQczJ4Q9/sN
	3cvkeVBCK3s9qcIMHZSqEQAWOO0DwuuyFUYQpuxEqK2mI5ykNJXbj3BfCsoXZGcf/TR7N6F8jxa
	Hks4VYbZpFxoDoiujpbOY7lQhLZTD62ipgIynt+HGgQEZEMCpXVsNRFFtmBJ2HCiVEwC25FHai5
	8mf6TNajskDBkdDXKv4Qe1BxlD+6pT+bm65ddFPXMVYScu8xjPKSgPa8Mg153eOQgVJVl+br/os
	zmrbOUWMnYX0PNasW/3O1QXUkvDY6k+YoDtO1GB+vlNq5UvKr0x9zxUeYdS3WP7Zr7cqtv88H3z
	Bdq8BuucO9/K+pnbvPH9wfcvSbmPlvc8IVyyvdEa5XroyFpeRYt+COBcGzbG9DjQIviPH5lyOvj
	19cW6MEkdJihNkzXjSU=
X-Received: by 2002:a05:690c:39b:b0:89a:63da:fa95 with SMTP id 00721157ae682-89a63db043amr28878177b3.80.1790024449272;
        Mon, 21 Sep 2026 14:00:49 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 43/46] KVM: arm64: Add Caretaker EL2 exception vectors and guest entry/exit assembly
Date: Mon, 21 Sep 2026 17:00:31 -0400
Message-ID: <20260921210034.180424-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fbnign1frf3dbod3hh1ujeactn6ezy7j
X-Rspamd-Queue-Id: 3FCC74000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1790024450-516173
X-HE-Meta: U2FsdGVkX1+m97XSgW80qXrvGf5veOzBkrfSxZhJBoC0ro0aoLp8xfH4Z4q0DL4C524L0vHi8UFSxolURctA0vJzOk03WI55z6tuGMcEau4zQc+5IDDdJ8oB5MISrUp6FbuborNjbVCwWffdk9n1dTFzadcNe/Gsp0mGCPZU/XQMSdassLQcmRPN0E4x+p2uk5mPWNBbLiTyi/svpymSeP52m2XorOiB/EJs20e8i/3JF2tEGYNWHXv5kulGp5Iwge5lnOf1+mHJxjevTJxrT5uFt3Sy2dnIriQZmENbHpJ52FW8w2+cl35xBh7WoSn73e5HDzwpQV8iH5jcpuhV97rk2I4VqKL7PnHdAZ5xX5pCHqLDQ4r3S03YFYuvy0ahSt1fuLV9emjxGH5CLBXcs6ylTIGzpVduOJskgHNX2XMEVXldREYDjO1d5jtCgNa+5rHGIR+s4kWETUNZeQQyVn2Wof4V08u42vPS8Tk3ir1yG+M+yfmJmIL6Lwv6PpAxPTnvL+no7kL/KuNBTthC3uzSJb6WIkm/KqSs1XHHSA0yoah/8DibgdKnPl3Uo6HtGyX9YYFhGwZYVD0CEpmSSO+9VgCnaEXtuuNN/8xVuIG7kq4XyNWZ2UV4K3FozVsNXjUuj6MBQtI4u8dQVbKQcqexiu+pbe2v5WfHW5FuqziZZi7+CiZUidD4EAihwZiv4TMpp51bAb6QV+kKyeoVE1pekKjA97ttYDP6yQBm5JXi06Aq6OFakXI1cTSFcZfKZVwQPMPMbimbp5nL1I9dPRxlLhGT63jtrcvecDs8cLTOXsUcqz4iWp89n8qXD2SB7GgzGMPGx6u4w3Se+0yiIYhFbjkEOw0UZ6oNSwnT8OSMV6+1yRDEVWtLxL4WF3Mduit+pCEgusaqd6fdDywHtS1PKnXEiBAzuazZ9BUpGoRidcY0hQHjcVFWGhg1JUlPb90Wvxb9cZaoJf3b66Z
 sKei/WWO
 2gY5qsDA0+0rwkU6H/Mls9oOL1fXpwBTNHHnNTfupDGQIp5q6txHn0NUzbvQ8pHSonM0+cq9oXi//BeWhP2DPA4al8b8qjB4m+UGxdcK7tbSZfvVf1mNTMsreYGqbCIpCfiZ0zpPl+n+UYEUyR8pYiO83YdxhjNx17CuFdr/HX11siP7mpz4C+YDTXdDUYx5P/GbxypaS2lDF4wmrLRtTotHakLeh/+KKhMC23At8s+9zV6Rd3MoBLFKOH6wvoZ6XCkt1khD37fvm9t6JA7ktGcSxAnR/EvBLkwOsODPT6cqywnWGSz1UERsT19fbznHQVMLeNWvC0pogLtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch/arm64/kvm/caretaker_vmenter.S for standalone VHE EL2 guest
entry/exit world switch and exception vector dispatch on preserved cores.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/caretaker_vmenter.S | 248 +++++++++++++++++++++++++++++
 1 file changed, 248 insertions(+)
 create mode 100644 arch/arm64/kvm/caretaker_vmenter.S

diff --git a/arch/arm64/kvm/caretaker_vmenter.S b/arch/arm64/kvm/caretaker_vmenter.S
new file mode 100644
index 000000000000..6dff9fbe931f
--- /dev/null
+++ b/arch/arm64/kvm/caretaker_vmenter.S
@@ -0,0 +1,248 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Caretaker low-level guest entry/exit and vector table for ARM64 VHE.
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <asm/sysreg.h>
+#include "caretaker.h"
+
+	.pushsection ".text.cpu_preserved", "ax"
+
+.macro cventry target
+	.align 7
+	stp	x0, x1, [sp, #-16]!
+	b	\target
+.endm
+
+	.align 11
+SYM_CODE_START(caretaker_hyp_vector)
+	/* Current EL with SP0 */
+	cventry	caretaker_invalid
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_invalid
+
+	/* Current EL with SPx (EL2h) */
+	cventry	caretaker_invalid
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_el2h_irq
+	cventry	caretaker_invalid
+
+	/* Lower EL using AArch64 (Guest EL1/EL0) */
+	cventry	caretaker_el1_sync
+	cventry	caretaker_el1_irq
+	cventry	caretaker_el1_fiq
+	cventry	caretaker_el1_error
+
+	/* Lower EL using AArch32 */
+	cventry	caretaker_el1_sync
+	cventry	caretaker_el1_irq
+	cventry	caretaker_el1_fiq
+	cventry	caretaker_el1_error
+SYM_CODE_END(caretaker_hyp_vector)
+
+SYM_CODE_START_LOCAL(caretaker_invalid)
+	mrs	x0, elr_el2
+	mrs	x1, esr_el2
+	mrs	x2, far_el2
+	b	arm64_caretaker_handle_invalid
+SYM_CODE_END(caretaker_invalid)
+
+SYM_CODE_START_LOCAL(caretaker_el2h_irq)
+	stp	x2, x3,   [sp, #-16]!
+	stp	x4, x5,   [sp, #-16]!
+	stp	x6, x7,   [sp, #-16]!
+	stp	x8, x9,   [sp, #-16]!
+	stp	x10, x11, [sp, #-16]!
+	stp	x12, x13, [sp, #-16]!
+	stp	x14, x15, [sp, #-16]!
+	stp	x16, x17, [sp, #-16]!
+	stp	x29, x30, [sp, #-16]!
+
+	mrs_s	x0, SYS_ICC_IAR1_EL1
+	cmp	x0, #GIC_SPECIAL_INTID_START
+	b.ge	1f
+	msr_s	SYS_ICC_EOIR1_EL1, x0
+	msr_s	SYS_ICC_DIR_EL1, x0
+1:
+	/*
+	 * Silence the EL2 physical timer before returning.
+	 *
+	 * It is the only EL2 interrupt source the Caretaker arms
+	 * (arm64_caretaker_op_arm_timer() writes CNTHP_CTL_EL2.ENABLE to
+	 * drive the on-core quantum), and it is level-triggered off
+	 * CNTHP_CTL_EL2.ISTATUS.  Neither EOIR1 nor DIR clears ISTATUS, so
+	 * without disabling ENABLE here the line re-asserts the instant we
+	 * eret and the core live-locks taking the same interrupt forever --
+	 * it never reaches the run loop, which means it can never observe a
+	 * detach request and can never be reclaimed.
+	 *
+	 * This is done on the special-INTID path too: a spurious read of
+	 * IAR1 does not mean the timer has stopped asserting.  The run loop
+	 * re-arms the timer for each new quantum, so dropping it here costs
+	 * at most the remainder of the current one.
+	 */
+	msr_s	SYS_CNTHP_CTL_EL2, xzr
+	isb
+
+	ldp	x29, x30, [sp], #16
+	ldp	x16, x17, [sp], #16
+	ldp	x14, x15, [sp], #16
+	ldp	x12, x13, [sp], #16
+	ldp	x10, x11, [sp], #16
+	ldp	x8, x9,   [sp], #16
+	ldp	x6, x7,   [sp], #16
+	ldp	x4, x5,   [sp], #16
+	ldp	x2, x3,   [sp], #16
+	ldp	x0, x1,   [sp], #16
+	eret
+	sb
+SYM_CODE_END(caretaker_el2h_irq)
+
+SYM_CODE_START_LOCAL(caretaker_el1_sync)
+	mov	x0, #ARM_EXCEPTION_TRAP
+	b	caretaker_guest_exit
+SYM_CODE_END(caretaker_el1_sync)
+
+SYM_CODE_START_LOCAL(caretaker_el1_irq)
+SYM_CODE_START_LOCAL(caretaker_el1_fiq)
+	mov	x0, #ARM_EXCEPTION_IRQ
+	b	caretaker_guest_exit
+SYM_CODE_END(caretaker_el1_fiq)
+SYM_CODE_END(caretaker_el1_irq)
+
+SYM_CODE_START_LOCAL(caretaker_el1_error)
+	mov	x0, #ARM_EXCEPTION_EL1_SERROR
+	b	caretaker_guest_exit
+SYM_CODE_END(caretaker_el1_error)
+
+/*
+ * u64 caretaker_guest_enter(struct kvm_vcpu *vcpu);
+ *   x0: vcpu pointer
+ * Returns exit code in x0.
+ */
+SYM_FUNC_START(caretaker_guest_enter)
+	// Save host callee-saved registers on stack
+	stp	x19, x20, [sp, #-112]!
+	stp	x21, x22, [sp, #16]
+	stp	x23, x24, [sp, #32]
+	stp	x25, x26, [sp, #48]
+	stp	x27, x28, [sp, #64]
+	stp	x29, x30, [sp, #80]
+	str	x0, [sp, #96]			// Save vcpu pointer on host stack
+	mrs	x1, sp_el0
+	str	x1, [sp, #104]			// Save host sp_el0 (current task)
+
+	// Install caretaker vectors
+	adr_l	x1, caretaker_hyp_vector
+	msr	vbar_el1, x1
+	msr	vbar_el2, x1
+	isb
+
+	// Restore guest context from ctx->ctxt
+	add	x29, x0, #CAP_CTXT_OFFSET
+
+	ldr	x1, [x29, #CPU_XREG_OFFSET(32)]	// regs.pc
+	msr	elr_el2, x1
+	ldr	x1, [x29, #CPU_XREG_OFFSET(33)]	// regs.pstate
+	msr	spsr_el2, x1
+	ldr	x1, [x29, #CPU_XREG_OFFSET(31)]	// regs.sp
+	msr	sp_el0, x1
+
+	// Restore guest GPRs x0-x28, lr (x30)
+	ldp	x0, x1, [x29, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3, [x29, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5, [x29, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7, [x29, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9, [x29, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
+	ldp	x18, x19, [x29, #CPU_XREG_OFFSET(18)]
+	ldp	x20, x21, [x29, #CPU_XREG_OFFSET(20)]
+	ldp	x22, x23, [x29, #CPU_XREG_OFFSET(22)]
+	ldp	x24, x25, [x29, #CPU_XREG_OFFSET(24)]
+	ldp	x26, x27, [x29, #CPU_XREG_OFFSET(26)]
+	ldr	x30,      [x29, #CPU_XREG_OFFSET(30)]
+	ldp	x28, x29, [x29, #CPU_XREG_OFFSET(28)]
+
+	eret
+	sb
+SYM_FUNC_END(caretaker_guest_enter)
+
+SYM_CODE_START_LOCAL(caretaker_guest_exit)
+	// Save exception code in x0 temporarily
+	str	x0, [sp, #-16]!
+
+	// Retrieve ctx pointer from host stack
+	ldr	x0, [sp, #128]
+	add	x1, x0, #CAP_CTXT_OFFSET
+
+	// Save guest GPRs x2-x29, lr (x30)
+	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
+	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
+	stp	x18, x19, [x1, #CPU_XREG_OFFSET(18)]
+	stp	x20, x21, [x1, #CPU_XREG_OFFSET(20)]
+	stp	x22, x23, [x1, #CPU_XREG_OFFSET(22)]
+	stp	x24, x25, [x1, #CPU_XREG_OFFSET(24)]
+	stp	x26, x27, [x1, #CPU_XREG_OFFSET(26)]
+	stp	x28, x29, [x1, #CPU_XREG_OFFSET(28)]
+	str	x30,      [x1, #CPU_XREG_OFFSET(30)]
+
+	// Clear Branch History Buffer (Spectre-BHB mitigation) across EL1->EL2 exit
+	mov	x2, #32
+1:	b	2f
+2:	subs	x2, x2, #1
+	b.ne	1b
+	isb
+
+	// Retrieve and save guest x0, x1 (from vector entry on stack)
+	ldp	x2, x3, [sp, #16]
+	stp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
+
+	// Save guest system registers
+	mrs	x2, elr_el2
+	str	x2, [x1, #CPU_XREG_OFFSET(32)]	// regs.pc
+	mrs	x2, spsr_el2
+	str	x2, [x1, #CPU_XREG_OFFSET(33)]	// regs.pstate
+	mrs	x2, sp_el0
+	str	x2, [x1, #CPU_XREG_OFFSET(31)]	// regs.sp
+	mrs	x2, esr_el2
+	str	x2, [x0, #CAP_FAULT_ESR]
+	mrs	x2, far_el2
+	str	x2, [x0, #CAP_FAULT_FAR]
+	mrs	x2, hpfar_el2
+	str	x2, [x0, #CAP_FAULT_HPFAR]
+
+	// Restore return value (exception code) in x0
+	ldr	x0, [sp], #32			// pops exception code + saved x0,x1
+
+	// Restore host callee-saved registers
+	ldp	x19, x20, [sp, #0]
+	ldp	x21, x22, [sp, #16]
+	ldp	x23, x24, [sp, #32]
+	ldp	x25, x26, [sp, #48]
+	ldp	x27, x28, [sp, #64]
+	ldp	x29, x30, [sp, #80]
+	ldr	x1, [sp, #104]
+	msr	sp_el0, x1
+	add	sp, sp, #112
+
+	ret
+SYM_CODE_END(caretaker_guest_exit)
+
+	.popsection
-- 
2.55.0.1082.g2b9226bbc0-goog



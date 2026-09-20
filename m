Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9D7C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1CE6B00B8; Sun, 20 Sep 2026 15:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598F26B00B9; Sun, 20 Sep 2026 15:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4609B6B00BA; Sun, 20 Sep 2026 15:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFF56B00B8
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 544B2A04C5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:50 +0000 (UTC)
X-FDA: 85235153220.27.BDBE350
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98D67C0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VjSIX3bJ;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQwtMjDkRZvOK0KEqWuda0aT7+Kg50uVl9w6x/heTIA=;
	b=h82v9ZFdKZn5C4//73cBb5A40wZzIv5EA2h1PrmvoS2h6nCmdnmE+rO7ftuBazIbBfVdxr
	zdD9GqGgekP9KMnh1IFBS/nz0Ym9vbJtaZP9zlf7zkFLKmqlvA4Ez5+FBejqxCqF5MEiw0
	zu7JG4wIb4dAJtGu8sL+WJRsZUz3FwM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VjSIX3bJ;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933128;
	b=sfxNZu/nwhBnEiq4bmZSE0/TgmpvEgNxGs71GAduGiD/JM9rttefzgUSBG7imqGcKvZJgo
	nQKA+DOKmIB1C/pGdJXcAskDw2m0ycVc2sOONDTmsQTAj5sBXvrxonWJ8DEhAEI55700Tx
	I2UV1k3PQhUxpdLjwYt+z2XTnY0dQNU=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895eaf30817so23274647b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933128; x=1790537928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fQwtMjDkRZvOK0KEqWuda0aT7+Kg50uVl9w6x/heTIA=;
        b=VjSIX3bJlGc8Z8zTANBAoE4+DpSpH04cRwdyoKLCeGNry4uZoBZ8KyI3P78rp2Rzft
         HEcEzZQT62rgACtRICNCTupngteF1QOtzACp0Xj62DwOGnZRTDVenmcNnGDMzEqVjTub
         p6TDUyv4vbRXwAyEAfS/T2OrwcyhZbi/E+IkfW4KXnvehLZQr2XrhkZ8+OSjiS79eMrf
         H3BEqjyrPkKueCa/Ul3iKXWiXj9a6oWhcrrxCHcJzcaOIVE04NeZh6C9TpU5fKA/Uq/k
         iF6OXMFHIn3tRoml/fnLWcU4BWXKwPXsXpauTiOOv0C4u21k/8yUf/t5MnoAuJ4F0q/P
         1D1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933128; x=1790537928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fQwtMjDkRZvOK0KEqWuda0aT7+Kg50uVl9w6x/heTIA=;
        b=1YZRCc8A/SxVboZ8gi6tPaCqq25HJrk6yUWpQoRoj4mJMlMHhWoq4tI4QN6XvoeN0W
         IMqkN1QU/8xz6Lojp8ec/nLfSiPsL4JoUz0lm7as/VVysou+BLd4jMb3kKjGmIFlMwul
         2i19IA4fEGFnOhTrMHks2Q00xc7crcRjipa7JztzXB2pEtc+b9F7Faa3dzA7pA4kaK9u
         LxPaHUg+a7lzsrpLemtCXwE4nBWHJpS3BVYknCzw4pn0ykIwEVXBmJ4ObYYnU3Bc5H8t
         qitOKp5DiPz4Zehl8+8CaqT3zIKsb8jyLZkDQ890lxrosJ0dCIVBbaYKgsDVOF0Tg0WJ
         884w==
X-Forwarded-Encrypted: i=1; AKwUvBxkqxM2RQm5nRpC/6gRJLy6mRpbsrdHvvua8UdR+JJpaAjJJG0uGziTIaSNSNG2fVEn9sHUUkEBqQ==@kvack.org
X-Gm-Message-State: AFuF++nRHjJ3P0TLZeDhRWjtOwK/+RCkvOcGsOCbm0uKGooCbpYkoT/B
	pbW7EeLHhWAXs8sL61KhF+2rF9fjIaJex/+2VTQCerIjhhDyF+HWomKLdxulI9ll+78=
X-Gm-Gg: AYBFou3B6pS28o9vQZrcVnx1RQoB3r3OwMoJjkLPQi9ihjyDHXDPJPygCvJTA3Pvs4W
	983pwvGP7Qd0dm3O+GfWK3VvBqoF3WqfB3tz5xTQjqYFfXkESyaXuj9jA/JaO7UCe3qCehIu2ft
	GpdjcwbqCOj1YQzlZMu60Y+cD/2p3hFcHHKIawm4Y12/J0/ABzR+xWBv8yDEL98QsR6W58NVwTK
	AMOwXvMLy/KO+ll6RHQ3rbQ/lDFhkobSHv2Xp64Zg28AU8xQbgq/5u4rZMoQANmkY+olZdJLyJ/
	GW40EUtlXZEl1744lIyBdD4bWfalcc8AFJ//1F26OuBsgDQprXc3AoN674MuCozYnPBy5bdvUwM
	+sEzBxAjX5Y4k1IEPmOLwtvuSkh1Cndgo+Pwf6YxE4TX/8LI7tblvdcVuykS/Ggjo1U3UK2Xp2t
	bpwgXY1UWAa8YblJjUXAtQRiObaNqXZY6bzZC41iSemFC3lCjuFyTZolIEvh/zvjOxFbyZzFRHJ
	IAb13lION7DAeTSqYSmU4RALYgj/4JYwrFfm94HlRZMpdvmiQCLWZ1kiJNjLovMCO9zD84W87ah
	KFDUtfCvyk1B3pyUS4s=
X-Received: by 2002:a05:690c:d8a:b0:882:309e:fcaa with SMTP id 00721157ae682-89733726012mr21472487b3.15.1789933127683;
        Sun, 20 Sep 2026 12:38:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a46c43cecsm19037957b3.22.2026.09.20.12.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:46 -0700 (PDT)
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
Subject: [RFC PATCH 19/46] x86: liveupdate: Add low-level physical CPU preservation assembly
Date: Sun, 20 Sep 2026 15:36:23 -0400
Message-ID: <20260920193650.3373435-20-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98D67C0008
X-Stat-Signature: toq83i3fhyhsrjkha1p9ka5ffcdpnzqu
X-Rspam-User: 
X-HE-Tag: 1789933128-782619
X-HE-Meta: U2FsdGVkX18BLQyZ7SKy6v0Np/PkgBqqugq02T2QQGQvtfugs4e2UHStrycoXYjhaABH+b/cqEh7gQGxatFE5qkD2JwR7ilp7U4+Ilmst1WZ0ClL8cHanwyCd7QIIOAr7am+Ts7a+4r7T5R8A2cZCuLBOBFnh6f0UML1tQpoJJvFcsp6vY2jtRBI31FRrMcZyeI2x/x3Bd59QBbvpWWWQpBYcD5ZlB5ECAOqz1uaPCNdcRz5wlrfY16/hMNBJO+l7C9Njm7QKaUFipLL715EXFnSkE+2ZReLRyLpECsU9GyEAGmazAtzI1oMtgpcUCTX89HO694aOq1by7VvcULKWsk2J6PgOcl5mzsToxldus6H2GcUuaKgRgIqYv4KKc5EuDyjFSnRQoXQad6lhPU6eLt98VOuz0+6jZEk9kcOjBhTVaMQWIsUquxdo+F7QOTUMQMhEGI5pz79iDw5hWPJ4kRV/jEgjouzUl2d4tkTtt+wun9/ShpvB2yzdbid1xt/mn2dKtEAjZKy5Hwk7y6fr12OoXG09XRXWM9ic+oIlCI/bBFe792jBk0fKw0d0qDxJQprk8iRy3V1+La6ah+0HJWeIl9oZb1UPVG+tZPfn/VIXX8fOiW4ynPnxz7c/uoU8wPWHwGetBg9YXVtbxBR+8HcHTIkQ4Sl7zXRq6HE1vUczTzWyZV1BON34M9EgguA9/zYijaoqEvQ5DF3UQk971HLRe4GXLyfBhR6YfV0EvHi5ITGJV5RFskhkhTLQxkbwnWcRGFRjs549d0mSfkJTh2lcBgdZACBHsox8oZS3tqs7prpIj/gA2GwEPEFFLig2lVzTyADOjF7E7b8JW6NCWMx1n+Fmcg5VaixflaMsESSclIX0XgavSBprKmteX+/Q6X/GPFcZLUhQJEP6I13fEMWR7q1fbNrrnv7KdytNzQZK5GKaFdk/+pblfrzYdCzhfgEEJQr/WEKVadray6
 /LuNv5nd
 JzmngMTHbJYiZggNzQy30a9NNLH8BPi8TRiXhPaqIkJaZk8rod14ALbELHw4OkhZnlZgKg8WG1jt3zyO1Y7E8EvqoR0hqtsArpfxv9zPnRiVkAhbl82CiePKr8TZmjPH6xI0iZQsUpSbrv2sprxQsDTU2XiR8uuhe0ZD74eLdmVvPQvWIsioqd9uIntMGUkBBQWvWMj/wRm0SXuoPzfdXXr/lOM0DozN82QfFmlvTTyNs3DSWDkh62UecvBSo4IwQWsmFiDBACpQoxsQtSyOCJu8EjkMA9G/Bf9wJD7fau4EoCZbAI/MMrTr94Pc4F6JeCQSdk40Od+C1hLxVVW1dANelZgc4cd2563Xu+EsGlFvCgU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch/x86/kernel/preserve_cpu.S stack switch routine, preserved linker
sections in vmlinux.lds.S, and SMP stop exclusion for preserved cores.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/include/asm/cpu_preserve.h | 31 +++++++++++++++
 arch/x86/kernel/preserve_cpu.S      | 62 +++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S       |  2 +
 3 files changed, 95 insertions(+)
 create mode 100644 arch/x86/include/asm/cpu_preserve.h
 create mode 100644 arch/x86/kernel/preserve_cpu.S

diff --git a/arch/x86/include/asm/cpu_preserve.h b/arch/x86/include/asm/cpu_preserve.h
new file mode 100644
index 000000000000..969903eb70cb
--- /dev/null
+++ b/arch/x86/include/asm/cpu_preserve.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __ASM_X86_CPU_PRESERVE_H
+#define __ASM_X86_CPU_PRESERVE_H
+
+#include <asm/page_types.h>
+
+#define ARCH_CPU_PRESERVED_STACK_ORDER	THREAD_SIZE_ORDER
+
+#ifdef CONFIG_CC_IS_GCC
+#define ARCH_CPU_PRESERVED_TEXT \
+	__attribute__((indirect_branch("keep"), function_return("keep")))
+#else
+#define ARCH_CPU_PRESERVED_TEXT
+#endif
+
+#ifdef CONFIG_LIVEUPDATE_CPU
+void arch_cpu_preserved_load_desc(void);
+bool arch_cpu_preserved_is_active(void);
+void x86_preserved_iret_stub(void);
+void x86_preserved_iret_err_stub(void);
+void x86_preserved_apic_eoi_stub(void);
+#else
+static inline void arch_cpu_preserved_load_desc(void) {}
+static inline bool arch_cpu_preserved_is_active(void) { return false; }
+#endif
+
+#endif /* __ASM_X86_CPU_PRESERVE_H */
diff --git a/arch/x86/kernel/preserve_cpu.S b/arch/x86/kernel/preserve_cpu.S
new file mode 100644
index 000000000000..8acb98d46f90
--- /dev/null
+++ b/arch/x86/kernel/preserve_cpu.S
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/linkage.h>
+#include <asm/nospec-branch.h>
+#include <asm/unwind_hints.h>
+
+	.section .text.cpu_preserved, "ax"
+
+SYM_CODE_START(x86_preserved_iret_err_stub)
+	UNWIND_HINT_IRET_REGS
+	ENDBR
+	addq	$8, %rsp
+	iretq
+SYM_CODE_END(x86_preserved_iret_err_stub)
+
+SYM_CODE_START(x86_preserved_iret_stub)
+	UNWIND_HINT_IRET_REGS
+	ENDBR
+	iretq
+SYM_CODE_END(x86_preserved_iret_stub)
+
+SYM_CODE_START(x86_preserved_apic_eoi_stub)
+	UNWIND_HINT_IRET_REGS
+	ENDBR
+	pushq	%rax
+	pushq	%rcx
+	pushq	%rdx
+	/* x2APIC mode: MSR 0x80b (APIC_EOI) = 0 */
+	movl	$0x80b, %ecx
+	xorl	%eax, %eax
+	xorl	%edx, %edx
+	wrmsr
+	popq	%rdx
+	popq	%rcx
+	popq	%rax
+	iretq
+SYM_CODE_END(x86_preserved_apic_eoi_stub)
+
+/*
+ * arch_cpu_preserved_call_on_stack - Switch stack and call function
+ * @cpu: CPU ID (%rdi)
+ * @stack: Target stack top (%rsi)
+ * @fn: Function pointer to invoke (%rdx)
+ */
+SYM_CODE_START(arch_cpu_preserved_call_on_stack)
+	pushq	%rbp
+	movq	%rsp, %rbp
+	pushq	%r12
+
+	movq	%rsp, %r12	/* save old stack pointer */
+	movq	%rsi, %rsp	/* switch to target stack */
+
+	call	*%rdx		/* call fn(cpu) */
+
+	movq	%r12, %rsp	/* restore old stack pointer */
+	popq	%r12
+	leave
+	ret
+SYM_CODE_END(arch_cpu_preserved_call_on_stack)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 2438b89a4620..9b8b70057bcf 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -155,6 +155,7 @@ SECTIONS
 #endif
 		ALIGN_ENTRY_TEXT_END
 
+		CPU_PRESERVED_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -194,6 +195,7 @@ SECTIONS
 #endif
 
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
+		CPU_PRESERVED_DATA
 
 		CACHE_HOT_DATA(L1_CACHE_BYTES)
 
-- 
2.55.0.1082.g2b9226bbc0-goog



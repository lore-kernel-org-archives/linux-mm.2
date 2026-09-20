Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD01C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0FE6B00D4; Sun, 20 Sep 2026 15:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8716B00D5; Sun, 20 Sep 2026 15:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797E76B00D6; Sun, 20 Sep 2026 15:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49D816B00D4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86C8C8043C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:13 +0000 (UTC)
X-FDA: 85235156706.20.496F809
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id D167820004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Q8oLOM/g";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3S9IGIpx1XukM5+85xEy/xAAQOziOyf4VtS5J9WTu4=;
	b=Y2eYChwnh6eIl3xo2qVNRrzxXmJ2B0byJ3ojnmE1b1s7dM8ICicb2R8bTWEQOWO6UNkU7l
	mKCzEm3ubaNHMu35N1PoOThK9mtf9YPjRrg7UeaUy3mSG4ohHij4pSZ4le0u5n22yOppYQ
	FPBESACJcloMPxfbQpytDE/c1LcAWFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933211;
	b=q7iQFba35sregqIBnk6Kqc+QVIprGyCgUr8574EwIafiLC5wiO8GWchcKI4yLpMY+ukzTY
	L/g12jTMlxpjtLixa0gdNzMwYW/SXqd4Q20Giw91+7B+dYbU1g2AZla6rpZmA14ZZmuFvh
	PbZP1E6V4Dy7HqB3edvlwBjymc153Hk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Q8oLOM/g";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab20a33so2153030d50.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933211; x=1790538011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=W3S9IGIpx1XukM5+85xEy/xAAQOziOyf4VtS5J9WTu4=;
        b=Q8oLOM/ggCWaLgcpVOn1B8OEiwaIVKyO0KcGHg86kvkzx6e5wYLQEz++8VQtXSYoF4
         C/8/IRUl83hbmtHVvwVU9QY4W7ejBv7RBMz5dWzvai3Q368mbkZDVCdX7GWH3VU+v7sy
         Y1rze5X1MhMlktPKtihljcGM2t5Dio/QK4ZG17sWFoxO+fJ73JX/C7SOUjM53h/lSAoD
         6NjQuOKS4ZsETVkwOKXYxls5v3ppTHv8qjYvuT2LecS0CbmhFFddT8baOzIg0b9OVHV9
         zgBS9ENWZ7DLUYm5pwpMjxLfYG2GWUBJbhwrho8h5AfMvA7y24pWBN20Cl7vOq9yyyrV
         3qCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933211; x=1790538011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=W3S9IGIpx1XukM5+85xEy/xAAQOziOyf4VtS5J9WTu4=;
        b=Wy0ECUbwGPjBdLXN3Q57jETzxcEtN55D2d/6zaPj03Ro6DJs+armmBmL+7N4Yqi7WD
         zlqBiTuWc+jtIXbDfc5LFM1HUJrrFQabzNWj+AZNAods5aJikicRL74geD9+ItlP964T
         aVl/jwbPhrlWjnqVFlDs3419eDTYCmcgaZZYK+ikGEJPGs9rAIVec+HiA7JAUntnVeYa
         b9Nzccu9UrfuXNjAmJDv688LK/Sdwxzr9EUjYp0vixcZhjO+kSpogQPsYbEeUeGLMiAk
         OKunGYyX2dGjgJaWM6BPIjn95rI6mJL0DdhMzlzAaBOKFtAaNTBkDLtm4HxPl5ZjFZ1E
         xlsA==
X-Forwarded-Encrypted: i=1; AKwUvBwQKw+aUObsBhZUvHCYVwvwFr5zarjkP/3RxpI5TqAfkHQkSF6ZRkvXfh6jYh+0PuIYxwLmU5P9wg==@kvack.org
X-Gm-Message-State: AFuF++meUb4j7YqgIw0S3Pfwzp+9MLRZN54fDqH/gxf89kNiwuAjLS09
	DxUz4PgYyNPmjl7fCoo5uD5tcBnnD7R6MkAz8uWiDjp6+DPSgzBezfIddz6rdIM63/c=
X-Gm-Gg: AYBFou1a17D09RFt+YeoXjNQbcNkDrVtUaYbvkffdcM1ydyDDKEhPCf7Kr+Zft4kMvx
	XVh0BjU0+pNH2P5xDGxxn3tKJ42/X0FzOj3tk1IHS1Yh5Dv+gDqWDFJQ5BrCdD+vU/+Yomu8Qxm
	Wrh58E0DAkPPdXapWcDWuC39bCyMNcfxC+xkDvzAdcxUineRvk8uW5e9kuFb++poye3YRCB+YeF
	vs1/39vmMMMak4/f9bLm9g2yfLnVBfurSNngEXqQNU2K4jzl2m3RxmOt046rQnYry4Olx65150t
	Ovlq6AG35L5lt+MxqQuDk9qi3tA+Q9T7EgSouvyutNAqipUj3MAtedP2ex7WeJdq6ov2xktAMr3
	WsYxyfUb/u6XGZy/L9oq8A+MAtbah3Y4HghpvObUu5q7jdwrBZwUYzwXK3yHHPToGjxrNTbDdjo
	u1VzwnHKBaCGyEc4/lc6h5CiZLvuLFzXQZAr30KfWWvSr5HTFPsZ4vtLFJ/9TXnPfd7Iex9s2SL
	wh5Mn7WpnABkb/6pq6Ne92NcYBUGe8+LtOYdChPminQ0qzjraWBg9liDuQtemLDh/4k2NjCgYgW
	xJG6zuGs0hWU7UT5kOc=
X-Received: by 2002:a05:690e:e8f:b0:671:33f6:721e with SMTP id 956f58d0204a3-6717fdb0525mr2627775d50.54.1789933210857;
        Sun, 20 Sep 2026 12:40:10 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67299071d4dsm2603228d50.4.2026.09.20.12.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:10 -0700 (PDT)
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
Subject: [RFC PATCH 33/46] KVM: x86: Add Caretaker x86 KHO ABI and runtime context headers
Date: Sun, 20 Sep 2026 15:36:37 -0400
Message-ID: <20260920193650.3373435-34-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D167820004
X-Stat-Signature: ag7t9gm5zn3i7ce6okyxb8zxgi975yxi
X-Rspam-User: 
X-HE-Tag: 1789933211-588536
X-HE-Meta: U2FsdGVkX1+/4kwa1/0S0lYu9m23zJBA1hecXtZ2kNRDuPhnphviuOEzFQjzfD8yEFmMRyv81HcfwJsUeMhm6V27nkfwTLCZh0QvERIRaMDiJWUZDXdVPHC4q5Qa8Hg+za7X9A8tqBF62ada/z9Zi3GbSfITwLi0+YoJfCIMWuQVw+q9C0SXyb9qxfWgDFNzd3A1b4TZN+WzA40YIHXD9C70G5bffCmPqPdUlptjAfQ3GDU98ElG4WKMaMvcyJ0ho2peBBCaQpmMj7XQbCXmW0AzZsuBS0dOuIQYBBtOrx9DumHi0kxpPSi6XOCTVPWZjj1/fPsUUd7PQJjRtrawvzxBBZ4kRv0aS95r5fdQSzwa2MTIRywgSZMjTfMAYzf8sgo8spRaxqs6dW1XxGkVDRaJmVpuKUZdMv71v6iMjmDWoz6ycSI4ksaR65jB3QDgmgRxTW9mj/S7SvkmmPLqfnnFdiT6Lvbjj8h0MP9BdSxtE3mxlS9lYiXIGBsq4NZ740uO3xTSxR0dMVb8WKDL4Ja/HWxey1InpJ/JJUiWwyoFms8/PT3+WebjvLXtAjc4th6oy8d5yExOL6KtT+6e8v8XH52MrtZokp8QO8H/Y8Xhc3FAcF2GlJbrRH9qZulIQ4c5RLsFqlIvwpXSkLwLyNrQ9a8Ql1p/yX0KqvfjY2eWqLn9BhB942TSfr0+xyewCTeMsrvlEbOiANu0RotsfGC2/5+CETTv+jsjcJF810W9vmzR25Tqu9WMbFaivhVxHetI6dWQsrss9OIIGiagbYX6dzS3E4jVgSWRIpXXu/OX+QbnJNtyiW3nlOnVByejTb6/7/T8wz6gypXvlqQyt5fFFCBGMR1XjETICfRg+LrsUqjPNCiUCxPeUUVGhTVVb81wPFWoRJWs8rXohI+Q3ujgW4lzBJar1RClsvvCxyUTJmwJqbDa98EHFCkzNgIJnXTz8FFiIfSnrHfr1Pw
 0FDKntCV
 MqmGyJjXDKLDDP/sV7XTL+sK/2jicEZ9yQLKY6r0KEMIha7aYybK5JtXPBgSJqRCYyA1GnWthmdFnjK6zBvWIl+nfjKIkhvkMxFt0VCCObsRmFu0oOku1nIA9ya+RFH18jAkxVoyqYdBsoj4gqElLa8A4rg9/Y28PlLzd/Da32CR0UWaSeXb5V2nAvfw7XQ/QNruK9SsHHNe3LMvMKsyQRA6HmS4jUNijvf1r+5BAtxUmtTf0WbuYGGzsTQA6w5njtjDCQP4Y7NKti+fLXkBQqmzII9QhK62MmxGnECIxP6//PPXCqh065KosVOkCSQoalI2yzLrKpXRejzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add struct kvm_caretaker_arch_ser, x86 Caretaker runtime context headers,
and generated assembly offsets for Caretaker guest entry/exit.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/caretaker.h        | 230 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/caretaker_asm.h    | 117 ++++++++++++++++
 arch/x86/kvm/kvm-asm-offsets.c  |  32 +++++
 include/linux/kho/abi/kvm_x86.h |  22 +++
 4 files changed, 401 insertions(+)
 create mode 100644 arch/x86/kvm/caretaker.h
 create mode 100644 arch/x86/kvm/caretaker_asm.h

diff --git a/arch/x86/kvm/caretaker.h b/arch/x86/kvm/caretaker.h
new file mode 100644
index 000000000000..9dd8815d414b
--- /dev/null
+++ b/arch/x86/kvm/caretaker.h
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Header for x86 KVM Caretaker common C execution engine and helpers.
+ */
+#ifndef __ARCH_X86_KVM_CARETAKER_H
+#define __ARCH_X86_KVM_CARETAKER_H
+
+/*
+ * Size of the caretaker's standalone VMX exit and IST stack in the upper half
+ * of struct caretaker_x86_page ([2048..4096)).
+ */
+#define CXP_STACK_SIZE		2048
+
+/* COM1 serial port range intercepted by Caretaker */
+#define COM1_PORT_BASE		0x3f8
+#define COM1_PORT_END		0x3ff
+
+/* Number of x2APIC MSRs (0x800 - 0x83f) */
+#define X2APIC_MSR_COUNT	0x40
+
+/* Caretaker APIC version: 6 LVT entries (max index 5), version 0x14 */
+#define CARETAKER_APIC_LVR	((5 << 16) | 0x14)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/oncore.h>
+#include <linux/kho/abi/kvm_x86.h>
+#include <linux/kvm_caretaker.h>
+
+/* Architecture-specific VM exit types for x86 */
+#define KVM_CARETAKER_EXIT_CPUID \
+	((enum kvm_caretaker_exit_type)(KVM_CARETAKER_EXIT_ARCH + 1))
+#define KVM_CARETAKER_EXIT_MSR \
+	((enum kvm_caretaker_exit_type)(KVM_CARETAKER_EXIT_ARCH + 2))
+#define KVM_CARETAKER_EXIT_RDTSC \
+	((enum kvm_caretaker_exit_type)(KVM_CARETAKER_EXIT_ARCH + 3))
+
+/* 8250 UART register state for guest early printk emulation */
+struct caretaker_uart {
+	u8 lcr;
+	u8 ier;
+	u8 mcr;
+	u8 scr;
+	u8 dll;
+	u8 dlm;
+};
+
+#include <linux/processor.h>
+#include <asm/desc.h>
+#include <asm/page.h>
+
+static inline void caretaker_set_tss_desc(struct desc_struct *gdt,
+					  unsigned long addr, unsigned int size)
+{
+	struct ldttss_desc *desc = (struct ldttss_desc *)&gdt[GDT_ENTRY_TSS];
+
+	memset(desc, 0, sizeof(*desc));
+	desc->limit0 = (u16)size;
+	desc->base0 = (u16)addr;
+	desc->base1 = (addr >> 16) & 0xFF;
+	desc->type = DESC_TSS;
+	desc->p = 1;
+	desc->limit1 = (size >> 16) & 0xF;
+	desc->base2 = (addr >> 24) & 0xFF;
+	desc->base3 = (u32)(addr >> 32);
+}
+
+struct kvm_vcpu;
+struct kvm_caretaker_exit;
+
+/**
+ * struct caretaker_x86_page - Vendor-common x86 Caretaker runtime page (4 KB)
+ * @abi:              Cross-kexec KHO ABI header (must remain at offset 0).
+ * @vcpu:             Common Caretaker vCPU execution engine descriptor.
+ * @arch_state:       Pointer to KHO-preserved vCPU architectural state buffer.
+ * @stack_orig:       Saved caller %rsp across vmx_caretaker_enter() guest entry.
+ * @rax:              Guest RAX switched in caretaker_vmenter.S.
+ * @rbx:              Guest RBX switched in caretaker_vmenter.S.
+ * @rcx:              Guest RCX switched in caretaker_vmenter.S.
+ * @rdx:              Guest RDX switched in caretaker_vmenter.S.
+ * @rsi:              Guest RSI switched in caretaker_vmenter.S.
+ * @rdi:              Guest RDI switched in caretaker_vmenter.S.
+ * @rbp:              Guest RBP switched in caretaker_vmenter.S.
+ * @r8:               Guest R8 switched in caretaker_vmenter.S.
+ * @r9:               Guest R9 switched in caretaker_vmenter.S.
+ * @r10:              Guest R10 switched in caretaker_vmenter.S.
+ * @r11:              Guest R11 switched in caretaker_vmenter.S.
+ * @r12:              Guest R12 switched in caretaker_vmenter.S.
+ * @r13:              Guest R13 switched in caretaker_vmenter.S.
+ * @r14:              Guest R14 switched in caretaker_vmenter.S.
+ * @r15:              Guest R15 switched in caretaker_vmenter.S.
+ * @last_exit_rip:    Guest RIP captured on VM exit and updated on instruction skip.
+ * @last_exit_rsp:    Guest RSP captured on VM exit.
+ * @last_exit_rflags: Guest RFLAGS captured on VM exit.
+ * @host_cr3:         Isolated Caretaker page table root PA loaded during run.
+ * @cr3:              Guest CR3 shadow value captured on VM exit.
+ * @cr0:              Guest CR0 shadow value captured on VM exit.
+ * @cr4:              Guest CR4 shadow value captured on VM exit.
+ * @efer:             Guest EFER shadow value captured on VM exit.
+ * @kernel_gs_base:   Guest MSR_KERNEL_GS_BASE switched across VMX entry/exit.
+ * @uart:             Emulated 8250 UART register state for early guest console.
+ * @save_guest_fpu:   True if guest FPU state can be captured via XSAVE at detach.
+ * @gdt:              Per-vCPU preserved GDT containing the active Caretaker TSS.
+ * @tss:              Per-vCPU hardware TSS whose SP0/IST point to @stack.
+ * @stack:            2 KB standalone host stack occupying the upper half of the
+ *                    page ([2048..4096)).  VMX sets HOST_RSP to the top of this
+ *                    page so vmx_caretaker_exit_handler can recover the base
+ *                    address of struct caretaker_x86_page via (%rsp & PAGE_MASK).
+ *
+ * Cross-kexec invariant: Only @abi (and @arch_state) may be dereferenced by the
+ * incoming kernel.  All remaining fields are private to the preserved Caretaker
+ * text executing on the isolated physical CPU during the kexec handover window.
+ */
+struct caretaker_x86_page {
+	/* KHO ABI prefix (offset 0) and common scheduler descriptor */
+	struct kvm_caretaker_arch_ser abi;
+	struct kvm_caretaker_vcpu vcpu;
+
+	struct kvm_vcpu_arch_ser *arch_state;
+	u64 stack_orig;
+
+	/* Guest GPRs switched in caretaker_vmenter.S */
+	u64 rax, rbx, rcx, rdx, rsi, rdi, rbp;
+	u64 r8, r9, r10, r11, r12, r13, r14, r15;
+
+	/* Guest instruction/stack pointers and control registers at VM exit */
+	u64 last_exit_rip;
+	u64 last_exit_rsp;
+	u64 last_exit_rflags;
+	u64 host_cr3;
+	u64 cr3;
+	u64 cr0;
+	u64 cr4;
+	u64 efer;
+	u64 kernel_gs_base;
+
+	/* Emulated UART and FPU capability state */
+	struct caretaker_uart uart;
+	bool save_guest_fpu;
+
+	/* Isolated host descriptors loaded while Caretaker owns the pCPU */
+	struct desc_struct gdt[GDT_ENTRIES] __aligned(16);
+	struct x86_hw_tss tss __aligned(16);
+
+	/* Upper half of Page 0 (2 KB): standalone VMX exit and IST stack */
+	u8 stack[CXP_STACK_SIZE] __aligned(CXP_STACK_SIZE);
+} __aligned(PAGE_SIZE);
+
+static_assert(offsetof(struct caretaker_x86_page, abi) == 0);
+static_assert(offsetof(struct caretaker_x86_page, abi.cb) == 0);
+static_assert(offsetof(struct caretaker_x86_page, stack) == CXP_STACK_SIZE);
+static_assert(sizeof(struct caretaker_x86_page) == PAGE_SIZE);
+
+int kvm_x86_caretaker_preserve_page(struct kvm_caretaker_arch_ser *abi,
+				    struct page *page);
+void kvm_x86_caretaker_unpreserve_pages(struct kvm_caretaker_arch_ser *abi);
+
+/* Shared page table, IDT, and GPR helpers */
+extern gate_desc caretaker_x86_idt[IDT_ENTRIES];
+#ifdef CONFIG_LIVEUPDATE_CPU
+extern phys_addr_t x86_caretaker_pgd_pa;
+#else
+#define x86_caretaker_pgd_pa 0ULL
+#endif
+
+int kvm_x86_caretaker_init_common_page(struct caretaker_x86_page *cxp,
+				       struct kvm_vcpu *vcpu,
+				       size_t full_page_size);
+
+void kvm_x86_caretaker_sync_vcpu_common(struct kvm_vcpu *vcpu);
+__caretaker_text void
+kvm_x86_caretaker_detach_serialize_common(struct caretaker_x86_page *cxp,
+					  struct kvm_vcpu_arch_ser *state);
+__caretaker_text void
+kvm_x86_caretaker_update_msr(struct kvm_vcpu_arch_ser *state,
+			     u32 msr, u64 val);
+__caretaker_text bool
+kvm_x86_caretaker_handle_exit(void *data, struct kvm_caretaker_exit *exit);
+
+void x86_preserved_iret_stub(void);
+void x86_preserved_iret_err_stub(void);
+void x86_preserved_apic_eoi_stub(void);
+__caretaker_text void kvm_x86_caretaker_arm_timer(u64 deadline_ticks);
+__caretaker_text void kvm_x86_caretaker_disarm_timer(void);
+
+/**
+ * struct kvm_x86_caretaker_runtime_ops - Preserved runtime vectors for x86 Caretaker
+ * @detach_serialize: Serialize live vendor guest state into struct kvm_vcpu_arch_ser.
+ * @common:           Common Caretaker operations table (enter_guest, decode_exit, etc.).
+ */
+struct kvm_x86_caretaker_runtime_ops {
+	void (*detach_serialize)(void *page, struct kvm_vcpu_arch_ser *state);
+	struct kvm_caretaker_ops common;
+};
+
+/**
+ * struct kvm_x86_caretaker_ops - Vendor virtualization vectors for Caretaker
+ * @name:      Vendor name identifier ("vmx" or "svm").
+ * @init:      Initialize vendor-specific Caretaker page and hardware state for vCPU.
+ * @sync_vcpu: Synchronize preserved hardware state back into @vcpu during attach.
+ * @runtime:   Preserved runtime operations table placed in __cpu_preserved_data.
+ */
+struct kvm_x86_caretaker_ops {
+	const char *name;
+	void (*init)(struct kvm_vcpu *vcpu);
+	void (*sync_vcpu)(struct kvm_vcpu *vcpu, void *vcpu_data);
+	const struct kvm_x86_caretaker_runtime_ops *runtime;
+};
+
+void kvm_x86_caretaker_register_ops(const struct kvm_x86_caretaker_ops *ops);
+void kvm_x86_caretaker_unregister_ops(const struct kvm_x86_caretaker_ops *ops);
+
+struct kvm_vcpu_ser;
+
+#ifdef CONFIG_KVM_CARETAKER
+void kvm_arch_vcpu_caretaker_init(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_caretaker_unpreserve(struct kvm_vcpu_ser *ser);
+void kvm_arch_vcpu_caretaker_finish(struct kvm_vcpu_ser *ser);
+#else
+static inline void kvm_arch_vcpu_caretaker_init(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_caretaker_unpreserve(struct kvm_vcpu_ser *ser) {}
+static inline void kvm_arch_vcpu_caretaker_finish(struct kvm_vcpu_ser *ser) {}
+#endif
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ARCH_X86_KVM_CARETAKER_H */
diff --git a/arch/x86/kvm/caretaker_asm.h b/arch/x86/kvm/caretaker_asm.h
new file mode 100644
index 000000000000..8bae9bf07e16
--- /dev/null
+++ b/arch/x86/kvm/caretaker_asm.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Assembly macros for x86 Caretaker host context switch and guest GPRs.
+ */
+#ifndef __ARCH_X86_KVM_CARETAKER_ASM_H
+#define __ARCH_X86_KVM_CARETAKER_ASM_H
+
+#include <linux/objtool.h>
+#include <asm/segment.h>
+#include "caretaker.h"
+#include "kvm-asm-offsets.h"
+
+/* Save host callee-saved registers to caller stack */
+.macro CARETAKER_PUSH_HOST_REGS
+	pushq %rbp
+	movq %rsp, %rbp
+	pushq %rbx
+	pushq %r12
+	pushq %r13
+	pushq %r14
+	pushq %r15
+.endm
+
+/* Restore host callee-saved registers from caller stack */
+.macro CARETAKER_POP_HOST_REGS
+	popq %r15
+	popq %r14
+	popq %r13
+	popq %r12
+	popq %rbx
+	popq %rbp
+.endm
+
+/* Restore guest GPRs (RBX..R15) from preserved page structure */
+.macro CARETAKER_RESTORE_GPRS_NO_RAX base:req
+	movq CXP_REG_RBX(\base), %rbx
+	movq CXP_REG_RCX(\base), %rcx
+	movq CXP_REG_RDX(\base), %rdx
+	movq CXP_REG_RSI(\base), %rsi
+	movq CXP_REG_RBP(\base), %rbp
+	movq CXP_REG_R8(\base),  %r8
+	movq CXP_REG_R9(\base),  %r9
+	movq CXP_REG_R10(\base), %r10
+	movq CXP_REG_R11(\base), %r11
+	movq CXP_REG_R12(\base), %r12
+	movq CXP_REG_R13(\base), %r13
+	movq CXP_REG_R14(\base), %r14
+	movq CXP_REG_R15(\base), %r15
+.endm
+
+/* Restore guest GPRs including RAX from preserved page structure */
+.macro CARETAKER_RESTORE_GPRS base:req
+	movq CXP_REG_RAX(\base), %rax
+	CARETAKER_RESTORE_GPRS_NO_RAX \base
+.endm
+
+/* Save guest GPRs (RBX..R15) to preserved page structure */
+.macro CARETAKER_SAVE_GPRS_NO_RAX base:req
+	movq %rbx, CXP_REG_RBX(\base)
+	movq %rcx, CXP_REG_RCX(\base)
+	movq %rdx, CXP_REG_RDX(\base)
+	movq %rsi, CXP_REG_RSI(\base)
+	movq %rbp, CXP_REG_RBP(\base)
+	movq %r8,  CXP_REG_R8(\base)
+	movq %r9,  CXP_REG_R9(\base)
+	movq %r10, CXP_REG_R10(\base)
+	movq %r11, CXP_REG_R11(\base)
+	movq %r12, CXP_REG_R12(\base)
+	movq %r13, CXP_REG_R13(\base)
+	movq %r14, CXP_REG_R14(\base)
+	movq %r15, CXP_REG_R15(\base)
+.endm
+
+/* Save guest GPRs including RAX to preserved page structure */
+.macro CARETAKER_SAVE_GPRS base:req
+	movq %rax, CXP_REG_RAX(\base)
+	CARETAKER_SAVE_GPRS_NO_RAX \base
+.endm
+
+/*
+ * Clear CPU microarchitectural buffers (MDS/TAA/MMIO Stale Data/RFDS) via VERW
+ * before entering guest mode, using a selector stored in .data.cpu_preserved.
+ */
+.macro CARETAKER_CLEAR_CPU_BUFFERS
+	.pushsection .data.cpu_preserved, "aw"
+	.align 2
+.Lcaretaker_verw_sel\@:
+	.word __KERNEL_DS
+	.popsection
+	verw .Lcaretaker_verw_sel\@(%rip)
+.endm
+
+/*
+ * Stuff the 32-entry hardware Return Stack Buffer (RSB) on VM-exit without
+ * referencing external thunks or unmapped per-CPU call-depth variables.
+ */
+.macro CARETAKER_FILL_RETURN_BUFFER reg:req
+	mov	$(RSB_CLEAR_LOOPS / 2), \reg
+.Lrsb_loop\@:
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call	.Lrsb_1\@
+	int3
+.Lrsb_1\@:
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call	.Lrsb_2\@
+	int3
+.Lrsb_2\@:
+	add	$16, %rsp
+	dec	\reg
+	jnz	.Lrsb_loop\@
+	lfence
+.endm
+
+#endif /* __ARCH_X86_KVM_CARETAKER_ASM_H */
diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index 36ac61724dd7..e743ddae255b 100644
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -9,6 +9,9 @@
 #include <linux/kbuild.h>
 #include "vmx/vmx.h"
 #include "svm/svm.h"
+#ifdef CONFIG_KVM_CARETAKER
+#include "caretaker.h"
+#endif
 
 static void __used common(void)
 {
@@ -27,4 +30,33 @@ static void __used common(void)
 		OFFSET(VMX_vcpu_arch_regs, vcpu_vmx, vcpu.arch.regs);
 		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
 	}
+
+#ifdef CONFIG_KVM_CARETAKER
+	/*
+	 * Offsets into the caretaker page used by the on-core guest entry and
+	 * exit paths in {vmx,svm}/caretaker_vmenter.S.  These used to be a
+	 * hand-maintained table of literals in caretaker.h.
+	 */
+	BLANK();
+	OFFSET(CXP_VMCS_PA, caretaker_x86_page, abi.vmcs_pa);
+	OFFSET(CXP_STACK_ORIG, caretaker_x86_page, stack_orig);
+	OFFSET(CXP_KERNEL_GS_BASE, caretaker_x86_page, kernel_gs_base);
+
+	BLANK();
+	OFFSET(CXP_REG_RAX, caretaker_x86_page, rax);
+	OFFSET(CXP_REG_RBX, caretaker_x86_page, rbx);
+	OFFSET(CXP_REG_RCX, caretaker_x86_page, rcx);
+	OFFSET(CXP_REG_RDX, caretaker_x86_page, rdx);
+	OFFSET(CXP_REG_RSI, caretaker_x86_page, rsi);
+	OFFSET(CXP_REG_RDI, caretaker_x86_page, rdi);
+	OFFSET(CXP_REG_RBP, caretaker_x86_page, rbp);
+	OFFSET(CXP_REG_R8, caretaker_x86_page, r8);
+	OFFSET(CXP_REG_R9, caretaker_x86_page, r9);
+	OFFSET(CXP_REG_R10, caretaker_x86_page, r10);
+	OFFSET(CXP_REG_R11, caretaker_x86_page, r11);
+	OFFSET(CXP_REG_R12, caretaker_x86_page, r12);
+	OFFSET(CXP_REG_R13, caretaker_x86_page, r13);
+	OFFSET(CXP_REG_R14, caretaker_x86_page, r14);
+	OFFSET(CXP_REG_R15, caretaker_x86_page, r15);
+#endif
 }
diff --git a/include/linux/kho/abi/kvm_x86.h b/include/linux/kho/abi/kvm_x86.h
index 316250482db5..72038ca65b0f 100644
--- a/include/linux/kho/abi/kvm_x86.h
+++ b/include/linux/kho/abi/kvm_x86.h
@@ -79,6 +79,28 @@ static_assert(offsetof(struct kvm_vcpu_arch_ser, msrs) % sizeof(u64) == 0,
 static_assert(offsetof(struct kvm_vcpu_arch_ser, xsave) % 64 == 0,
 	      "xsave must be 64-byte aligned to be XSAVE-able in place");
 
+#define KVM_X86_CARETAKER_MAX_PAGES	5
+
+/**
+ * struct kvm_caretaker_arch_ser - x86-specific Caretaker control block ABI
+ * @cb:                 Common Caretaker control block header (must be at offset 0).
+ * @apic_id:            Hardware APIC ID of the preserved core, used by the incoming
+ *                      kernel to deliver the attach-signal IPI.
+ * @nr_preserved_pages: Number of valid physical addresses in @preserved_pages_pa.
+ * @vmcs_pa:            Physical address of the VMCS the Caretaker ran the vCPU on
+ *                      (Intel VMX), used by the incoming kernel to VMCLEAR and
+ *                      flush the VMCS after the vCPU stops.
+ * @preserved_pages_pa: Physical addresses of per-vCPU hardware control pages
+ *                      preserved via kho_preserve_pages().
+ */
+struct kvm_caretaker_arch_ser {
+	struct kvm_caretaker_cb_ser cb;
+	u32 apic_id;
+	u32 nr_preserved_pages;
+	u64 vmcs_pa;
+	u64 preserved_pages_pa[KVM_X86_CARETAKER_MAX_PAGES];
+} __packed;
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* _LINUX_KHO_ABI_KVM_X86_H */
-- 
2.55.0.1082.g2b9226bbc0-goog



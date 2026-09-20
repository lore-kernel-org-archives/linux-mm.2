Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D843EC982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01BB6B00DC; Sun, 20 Sep 2026 15:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA126B00DD; Sun, 20 Sep 2026 15:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8EF6B00DE; Sun, 20 Sep 2026 15:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A30496B00DC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A3ADC04C1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:40 +0000 (UTC)
X-FDA: 85235157840.14.F635286
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4820D80007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JSrPRlPk;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5wqvR/8Rgbn3Q8wmCLu7MA68JCRgtXzVIxWF4pI6Mc=;
	b=4tN3BX85w4Vc97pbf0tpie1uTbui4y2lNFPxaOxfFqk2FibXwUkPpZVYodUTBbDhiKMD0p
	zoWn1VNS2PMYb+69EQfhGTgjna/SmwamQLhzHz4OtdaIKNwKVEyoBpVuAnpGXrhJZXLxB2
	zeMFcJLOWuafK6s4K2lcYtsik+i7AL4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JSrPRlPk;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933238;
	b=oU/H6CJrVN5r1BMoVCMrasZWRnKY/XiJrY+YGIS1bqNtg+kuVk5jfv4AKOhHsEvQJK5/Xk
	Qo2F6Z0wERkyY1NoauxZWezzcbcpzhTrR88TuCiGEYzhe2VHUy4W7CQPY1+kD2ScCwRGRW
	Iv1P5MLpNp4ILqmoUvKvVfo75pYmOd0=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201ebso1605831d50.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933237; x=1790538037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y5wqvR/8Rgbn3Q8wmCLu7MA68JCRgtXzVIxWF4pI6Mc=;
        b=JSrPRlPkV/vUE8QezM2aZZ7wHx8b3Kkf+sBLOly0hvvLxnufdT2fpC7uhlYcelFPyi
         u0p6qa4rGP4BY+z7L1wOiGduRY9lv8tJdbgxabibFqHisOw8SSR3W1q3fR4IxkmxZq8T
         Rtd6Vi8zTCNdVxiTfOYtVuMe453hyub/r7Uzp1tYRc4G0DRqi7bSLvqNaDAZNeFHoBNS
         w6ZUFAIWkYZRVyDUU34ZzFAyRfSwUJE8DVBhU9T/BJ3aQ++YdKctkGWVNtzQ19PTkoQr
         RRuVTPPu508c1USZoZVKn3zB5UG6XioKLBRp8+2+ZR2rxTxDm1knEaTSYapkrpw47hIp
         /slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933237; x=1790538037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Y5wqvR/8Rgbn3Q8wmCLu7MA68JCRgtXzVIxWF4pI6Mc=;
        b=bLEexfRsBGF2rIvwIVARoXgbWg1o+t954glxD0Pqv2FBEIEe1rTAZcEmnuvndEmv7w
         +UTEgkd8Zzh5YwrGoTZwJ/6y2bgvTN2JjJC8bFh2tipLubYgfQFh/VbqcQ/mke8+evsn
         9wo+P1crpkiaPJZBEnt2AIpcDnHFntrXLfAuO1iDRkce7YlRjupxdT138yRhdqcxSPUQ
         9rZ4o26Fv0IXaECOmMQUH39H1RGmRdqQJRWxEBAQ87JvYxa29CmlA5ITefKiYXXHozM7
         yut3jPsegPYdFCwWnV45fiiV8aGa79sX8gjeEYrPGsuFZwzBnt1Zq9RK+mj2sdmIn31A
         ORDA==
X-Forwarded-Encrypted: i=1; AKwUvBzQyjcu5wbJ/rZgKn2pj7Mvf2BAkDcX9qrtvCZy6Gdz4UpsgL9bMGh4pHgAgkhjcZ5U40V4BdHxZg==@kvack.org
X-Gm-Message-State: AFuF++kHy/M2G5etuZrjtuB0X2TiNMyxVma2vyJa7g8KxUnT+JVK5Y+y
	J6PFTMwEbLG1fg5nt31g5N8eks8VyLC8SL3Ofum0UUsH54L6O/AYwoKlpHI87aDw+tQ=
X-Gm-Gg: AYBFou1hFIR2hIJXfxDqMEgPX2IAhMBWFxWFUbhbxBL/LbgoeBAOBrw0TgYrTHTK0PZ
	RpUa5GpvOJe8Ofr0nN0xMPoPpstymGy4Kkscdt0svPnoLlwY7W52pL8koUH6PVe2YoM0WAkSw9D
	EODmmC12J7mqvGOn1NlKC0kMCsaVGdjl38snGJk183E12YeDmP17dsy6B3JpIs7cSJ7JRH+Efn1
	h5ddF3q+h3U47P1LSDikdt5ejRG1je8hnpoIFOKhjxlC6slQUEc9mgrAMRCjagYPIztC5g2VXhF
	HVKHfQEskLfj4xLweLdMYBd6olwXDtWDIRhQNp96YqVgLgVsKzIdn6T6PePAtyNXHwEwzgF+8hu
	3Wvr7pCgAPbj0O1odsOetwklLceYsY4izTO+Hi2j7GMWYO96xYlexM+jsn84KSL0fk6IMX6od7P
	moDxq4OaSlAy7n1NI9HVFuDx/UcHmUddxldrexTEG5idMuK5dFxwoHPL1a40JgQHJLCCPE9AZYX
	c5G436rPYCcF1ybkraaDppIjVB+41hFUDgQF5nc5L8m7O6dWMaORvFrUvPzIV+ACG8iIGRiXYGz
	UlFwjAv1AHdmB5KZld7L
X-Received: by 2002:a05:690e:4854:20b0:672:99e1:11f2 with SMTP id 956f58d0204a3-67299e11844mr878861d50.143.1789933237384;
        Sun, 20 Sep 2026 12:40:37 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672990aada0sm2671022d50.9.2026.09.20.12.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:36 -0700 (PDT)
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
Subject: [RFC PATCH 37/46] KVM: VMX: Add Caretaker VMX assembly guest entry/exit routine and helpers
Date: Sun, 20 Sep 2026 15:36:41 -0400
Message-ID: <20260920193650.3373435-38-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gcen7wpixuw8z4cns3g5xrsqrnuuj48h
X-Rspamd-Queue-Id: 4820D80007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789933238-291684
X-HE-Meta: U2FsdGVkX18PvrQEcQAGtmcNS92Dysf56sBfjEgXyLjCG6gDPG/F5XmEhJUZ51uA01nVEKusQqlrjF/nwXgvYOo+BZJ48zXSwwn18/Gz0LDExJ324uKODn1dZ2vXP55JY0jv7tD5oJCjQv88mK7nAh2DAQozeLn/OwuUkRn0BH84Uvixr0OO/nVW6lYfhTxgS+x9s6pGtAt6uz5QhVN7Pc7gdooxeuVUZOiYKDYRJOiIZ450f8742crGICTSZGTONyfnhiGWeF0jH9EgVWeRCXkbJwmqKU7p6o8SlRvQiRRW0G1ZZiXfNIKc3bFuJEc53TBwU80DTkAu81+I3WGfbI1MIrHIvUXig950zE5C33Enh82QHK/tFL1MneQQIhMW29eWfrIGOLnfscXPBOSrmJNO3MeI8JAp2E5WsMeBmm5ZBZbXVhRWXpKZlB4VGh6z7tjkkRWvmFr+GW8KXsEUzH4z8Sj8esR+Pk0ShFNe84bgS4D8jCwR7tGfYTimcl2bA/V68upqE+JZxixKxwZlzGz2ngqg7fi/M1BZ1sJLJensgsBBCJ81hMRpgRvFG3ZgiRXaXyd4XEUEnDA97c813GvDvZg45Yy+Ggz4xb1mbRMySX72r4VYLudurQTThSZLmt276WgYnzN9/ydubs3ZvqsmDm27r0utxnD05vd2iNiLsH/9HegHQM4X8dbEazGHREY9EfGyut6mRGDgEPoTCYp0oUCcA/f2bQOj34y24i5NAZ3zk7wBxfjKfXREnCm2MDm5x+gsx6u3Dr8JCOKrPrXTIxfUd/uy57WZaVOUK5wL5XMU3PcVn9VzdKwzAVwBZimMYalsZMPXSo43whouUZ4/tfzER2CUggHTVF33Hfrhy/qCDCnNgHjIBBOL4gkwx0kxK2jdRDXPoBTIBDZko/Z3pglYq6VQNjdw8HiTW8D7HTFhTVyiyb7U6z6zrSYThf7k+GUNjmZ7WveBrGG
 LGKxCeeO
 L0UesBRjTOBf72DTeF35XB3NekdXoH4EIJBhDAa8BAgXfsvWi4nZGIBhGpei/09auZz9CxpBwYHun4aXTLGjkcDb69Gf/tVNeSdyotBc0gGWsgxPRrZi8LhvUN/uXS+3inFkpzMgcBX8QP2VItyqrFqad9Wp5iBW9p1vhyCTWFCSFwCIJgdBchLXzqOgwFVj2HHiLUlpkkoTUyPuTylb07RHLUFHRGbwEQEIyaVi5+RmUpKdxxR75Oyar7sAQrD3WidwQu9PXZ7sElw+VY1jLOP2+9BYsd0zVG0CtGJzm3LwHcRDKnekxiXgVLuGvfpe/3Q3Opu6VBfpXcMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch/x86/kvm/vmx/caretaker_vmenter.S and caretaker.h for standalone
Intel VMX VMLAUNCH/VMRESUME world switch on preserved physical cores.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/msrs.c                  |   2 +
 arch/x86/kvm/vmx/caretaker.h         |  78 +++++++++++++++++++
 arch/x86/kvm/vmx/caretaker_vmenter.S | 112 +++++++++++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/caretaker.h
 create mode 100644 arch/x86/kvm/vmx/caretaker_vmenter.S

diff --git a/arch/x86/kvm/msrs.c b/arch/x86/kvm/msrs.c
index ae849e0b7d14..536c8d1959dc 100644
--- a/arch/x86/kvm/msrs.c
+++ b/arch/x86/kvm/msrs.c
@@ -882,11 +882,13 @@ int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	return __kvm_set_msr(vcpu, index, data, true);
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_msr_write);
 
 int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	return __kvm_get_msr(vcpu, index, data, true);
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_msr_read);
 
 int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
diff --git a/arch/x86/kvm/vmx/caretaker.h b/arch/x86/kvm/vmx/caretaker.h
new file mode 100644
index 000000000000..d4272e202e73
--- /dev/null
+++ b/arch/x86/kvm/vmx/caretaker.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __VMX_CARETAKER_H
+#define __VMX_CARETAKER_H
+
+#define VMCS_VM_INSTRUCTION_ERROR	0x4400
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/kvm_host.h>
+#include <linux/oncore.h>
+#include <asm/vmx.h>
+#endif
+
+#include "../caretaker.h"
+
+#ifndef __ASSEMBLY__
+#include <asm/desc.h>
+#include <linux/processor.h>
+
+/* Length of instructions */
+#define PAUSE_INSN_LEN			2
+#define VMCALL_INSN_LEN			3
+
+/* Exit qualification bitfields for I/O instructions (Intel SDM Vol 3C) */
+#define VMX_IO_SIZE_MASK		0x7
+#define VMX_IO_DIRECTION_BIT		BIT(3)
+#define VMX_IO_PORT_SHIFT		16
+
+/* Default VMX preemption timer shift (counts down every 2^5 TSC ticks) */
+#define VMX_PREEMPTION_TIMER_SHIFT	5
+
+struct caretaker_vmx_page {
+	struct caretaker_x86_page common;
+	/* Guest syscall state not automatically switched by VMCS */
+	u64 star;
+	u64 lstar;
+	u64 fmask;
+	u64 vmxon_pa;
+	u32 timer_shift;
+	u32 ple_supported;
+	u8 vmxon_area[PAGE_SIZE] __aligned(PAGE_SIZE);
+} __aligned(PAGE_SIZE);
+
+static inline unsigned long vmx_vmread(unsigned long field)
+{
+	unsigned long val;
+
+	asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
+	return val;
+}
+
+static inline void vmx_vmwrite(unsigned long field, unsigned long val)
+{
+	asm volatile("vmwrite %1, %0" : : "r" (field), "r" (val) : "cc");
+}
+
+#ifdef CONFIG_KVM_CARETAKER
+int vmx_caretaker_enter(void *page);
+void vmx_caretaker_exit_handler(void);
+void vmx_caretaker_register(void);
+void vmx_caretaker_unregister(void);
+void vmx_caretaker_decode_exit(void *page,
+			       struct kvm_caretaker_exit *exit);
+void vmx_caretaker_init_host_vmcs(struct caretaker_vmx_page *cvp);
+void vmx_caretaker_init(struct kvm_vcpu *vcpu);
+#else
+static inline void vmx_caretaker_register(void) {}
+static inline void vmx_caretaker_unregister(void) {}
+static inline void vmx_caretaker_init(struct kvm_vcpu *vcpu) {}
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __VMX_CARETAKER_H */
diff --git a/arch/x86/kvm/vmx/caretaker_vmenter.S b/arch/x86/kvm/vmx/caretaker_vmenter.S
new file mode 100644
index 000000000000..ff135cba854d
--- /dev/null
+++ b/arch/x86/kvm/vmx/caretaker_vmenter.S
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/linkage.h>
+#include <linux/cfi_types.h>
+#include <linux/objtool.h>
+#include <asm/asm.h>
+#include <asm/bitsperlong.h>
+#include <asm/kvm_vcpu_regs.h>
+#include <asm/nospec-branch.h>
+#include <asm/msr-index.h>
+#include <asm/page_types.h>
+#include "caretaker.h"
+#include "../caretaker_asm.h"
+
+.section .text.cpu_preserved, "ax"
+
+/**
+ * vmx_caretaker_enter - Low-level transition to VMX guest mode and back
+ * @cvp: Pointer to struct caretaker_vmx_page (%rdi)
+ */
+SYM_TYPED_FUNC_START(vmx_caretaker_enter)
+	ENDBR
+	CARETAKER_PUSH_HOST_REGS
+	movq %rsp, CXP_STACK_ORIG(%rdi)
+
+	/* Switch to private preserved stack */
+	movq CXP_STACK_TOP(%rdi), %rsp
+
+	/* Activate VMCS on this pCPU */
+	vmptrld CXP_VMCS_PA(%rdi)
+
+	/* Restore guest MSR_KERNEL_GS_BASE if valid/canonical */
+	movq CXP_KERNEL_GS_BASE(%rdi), %rax
+	movq %rax, %rdx
+	sarq $56, %rdx
+	incq %rdx
+	cmpq $1, %rdx
+	ja 2f
+	movl $MSR_KERNEL_GS_BASE, %ecx
+	movq CXP_KERNEL_GS_BASE(%rdi), %rax
+	movq %rax, %rdx
+	shrq $32, %rdx
+1:	wrmsr
+2:
+	_ASM_EXTABLE(1b, 2b)
+
+	/* Restore guest GPRs */
+	CARETAKER_RESTORE_GPRS %rdi
+
+	pushq %rdi
+	movq CXP_REG_RDI(%rdi), %rdi
+
+	/* Clear CPU microarchitectural buffers before guest entry */
+	CARETAKER_CLEAR_CPU_BUFFERS
+
+	/* Launch or resume */
+	vmresume
+	vmlaunch
+
+	/* If both fail, record error and return */
+	popq %rdi
+	mov $VMCS_VM_INSTRUCTION_ERROR, %eax
+	vmread %rax, %rax
+	movq %rax, CXP_LAST_EXIT_CODE(%rdi)
+	btsq $31, %rax
+	jmp .Lvmx_ret
+SYM_FUNC_END(vmx_caretaker_enter)
+
+SYM_FUNC_START(vmx_caretaker_exit_handler)
+	ENDBR
+	/*
+	 * Hardware jumps here on VM-Exit with:
+	 * RSP = HOST_RSP (CXP_STACK_TOP)
+	 * CR3 = HOST_CR3
+	 */
+	pushq %rdi
+
+	/* Recompute CVP pointer from RSP: CVP = (RSP & PAGE_MASK) - CXP_STACK_OFFSET */
+	movq %rsp, %rdi
+	andq $PAGE_MASK, %rdi
+	subq $CXP_STACK_OFFSET, %rdi
+
+	/* Save guest GPRs into CVP */
+	CARETAKER_SAVE_GPRS %rdi
+	popq CXP_REG_RDI(%rdi)
+
+	/* Stuff Return Stack Buffer to prevent guest RSB poisoning */
+	CARETAKER_FILL_RETURN_BUFFER %rax
+
+	/* Read guest MSR_KERNEL_GS_BASE */
+	movl $MSR_KERNEL_GS_BASE, %ecx
+	rdmsr
+	shlq $32, %rdx
+	orq %rax, %rdx
+	movq %rdx, CXP_KERNEL_GS_BASE(%rdi)
+
+	xorq %rax, %rax
+	jmp .Lvmx_ret
+
+.Lvmx_ret:
+	/* Restore caller stack */
+	movq CXP_STACK_ORIG(%rdi), %rsp
+
+	/* Restore host callee-saved registers */
+	CARETAKER_POP_HOST_REGS
+	ret
+SYM_FUNC_END(vmx_caretaker_exit_handler)
+STACK_FRAME_NON_STANDARD(vmx_caretaker_enter)
+STACK_FRAME_NON_STANDARD(vmx_caretaker_exit_handler)
-- 
2.55.0.1082.g2b9226bbc0-goog



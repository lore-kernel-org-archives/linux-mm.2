Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49889C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46AA6B008A; Mon, 21 Sep 2026 17:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DB86B008C; Mon, 21 Sep 2026 17:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5BC6B0092; Mon, 21 Sep 2026 17:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82CDC6B008A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:00:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A1701202A0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:46 +0000 (UTC)
X-FDA: 85238988492.28.5F2A180
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B0AA160005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EzgAwxul;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790024444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyT1gPJmowaA4BnBpSt/USFny02ugqagur5yRQ9/hu4=;
	b=dhtpBrx1j+UdiPIFCuBvmKnhTHPldj1aURqiqUkd9TB9OnRcyMqgxlALEhLSxjXKnuPYtF
	7C7TXrVfaA7svdwziuCiIJD8IVMC0gpkHaHdTfA6ZVq+g9Mr1D3lkSiV5BpTICAXCQNct3
	Tkamgd9XwLL+MQBfdkqGWAgS0vo8pJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790024444;
	b=BQVG+Gp53jzN51AcBFfocoYYFDLTZZiJyM0DG9LEFXi033yad0HvO2z45GYnBsFcEdy6cf
	w264gE7a5x75VsyEvf7xpstH3Y80zXrZAx5nMOpsKoUUSAMfYp+6/s6zDxJfslBPAQsV11
	6AtY4dnkxs+8wD75zVTh7CZgtXyzO3w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EzgAwxul;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d46e4cdccso22256147b3.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024443; x=1790629243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LyT1gPJmowaA4BnBpSt/USFny02ugqagur5yRQ9/hu4=;
        b=EzgAwxulToheJvNt6vMXahCUe3KBAfg0dqjSL9st1rbbzQJsqgrwHXjH5xbcsZ5y3d
         dGhfykLJI+UmVckbakRBR3xJloELxE19ALuuYGlLgs8qaiaGAA0a65vnFUZ3qlQDHswA
         IrM7Y2nHvBwbXQuKhzBYzpd8rQ7Q4AlmJsgP1aWZhb2O3Wh/lL1o9Nbjz0q2k0sDQ5DB
         Y+6FUJ1BZKD2UE8LMRdoWQESXz0TmkjWqBoTgkBk3qAdR8pChWbBQJz9TwyhbKHHNqmN
         lueD/kdfOck6KseiI+uMs6Z1hPsR1WRJVUHpY4U2zvDHV+hOgK3t85RaE0lO78Wm7I8N
         62Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024443; x=1790629243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LyT1gPJmowaA4BnBpSt/USFny02ugqagur5yRQ9/hu4=;
        b=yNcLjJGpd3qkjViTwcyM9ePhLy3tszdybbTGVMDywqzzyQPzhAb3r8ChWV9Sg7+iwx
         Zd6EtlOCgGq7PwofZ7P07YLwVG7pl1AtiFi+/zAxlZjasRv1sQLW+HkIe5iWZK8D9QT4
         zhLzNYt2KnRNWXTzrSStpbSWE2yMrvhaXqSkjH7DLmXQq2NaHk5DQzqy0+YIv61XDs4e
         sG0MDsrQO6ChgzDEu0bDrY2KbPVnF2sPm9Es8FPDpKCD3ybCxn2kc/UGPFI+u6FE1kpJ
         /Drj3mLXxKGzZf55VCC35jLjjel8fShYoECYvtzBM83GpDBPS4YFEl5xOb4LOIfQebBF
         0xUw==
X-Forwarded-Encrypted: i=1; AKwUvBybEflUcdPSOZuXhhyrfsfRijVYcVDaZFklIL8PCJRjtg7l4eQBiO953eoBPuL5NLdJnjcDPIqKLQ==@kvack.org
X-Gm-Message-State: AFuF++lulKB4x4058nWUtw6E/H0PhtSrm8+LptdfE/ovlniXd8sw+DUd
	JBvK4HQfkqicgtp4PJ4AIFi3sDWpOX+36kavqD62IwDnp7AyE9wd4IQZgtWli419Eo4=
X-Gm-Gg: AYBFou2CqC0ztPyVw7ndH3BY8I1qHYnPJVrmIVTtbSndsNh0DDnGC5kzPwyEei7IGp3
	2R2jfc7FC31Rf1/Tydo+OLTrjwbll8jxm/GTdLBTMmnEz1TbYTcEcQr05RNJ1eJ5iA4AzWMmWbK
	iYvmu5HD/GRQWpQ4dO/toKvEOfwCyZIH2E/bIjfekMTY+a838q9BjSumuJ9P+boKCWoYtLXv1Ze
	KTaapQfasmCRUZP8idxZHt89gWP8ns7Jw8aCHUOYrGuXDohUFkVhy7PSm2XnXCu8XNUCZkbUIwZ
	Q2hlB1gmZLpWl7WDziDgvWZ5sBrp3wyPm68Iimplf79UvjSp4OARZrsNkzvxlm5mHJDQQ1s0Euz
	aTPYiuIKIVLiQUDB3nwCK9yeu0xN8B2DF4ZMgU9LTST1xa+5YFYZ9LozdUyUoR5KW0kWGeIMbda
	LAzVCvVjOaYo69sAi1UscVSudWQGYAUEMdyUhj/Ix86fpg3xtB3VqOiymktu8NOPy3YP1LhT6vW
	/QgBtZjGchAz+p9bTgGzz1jSBVMWd0NAFZLdN0LRvsntI32Hrja0E1J1rOoMKUx9wd631NF/EX3
	6EJF2SlTpqvKvfWrvzE=
X-Received: by 2002:a05:690c:6606:b0:85b:f1ba:b111 with SMTP id 00721157ae682-89735d833a0mr60441177b3.26.1790024441836;
        Mon, 21 Sep 2026 14:00:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:41 -0700 (PDT)
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
Subject: [RFC PATCH 40/46] KVM: SVM: Add Caretaker SVM assembly guest entry/exit routine
Date: Mon, 21 Sep 2026 17:00:28 -0400
Message-ID: <20260921210034.180424-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: epxnxj93wm7shgjrxq3nm3raoy9pwngq
X-Rspamd-Queue-Id: 6B0AA160005
X-HE-Tag: 1790024444-903142
X-HE-Meta: U2FsdGVkX1/T7N2xJtrWozRjC72B46RxVs7yOxlYR6cpHfm6z1fnP2Jcd1qmx3qqU+KckYJ03FHYxYIioVGSUdbAyssvrfJ6uCx/X4xG6UhZnDPOKS9JUPHgRmrT1f++x4KFhbJYZo9qOabA+lEuaUBiDNQDwBGKK1WBbE7dxO/AamsqsAq+bf+37E+3pXGM5HEIpAYCx+riXZ/iZbCEpfI/Oymi7usT5ZbTSGfmyMX1uj71vkiz5wkPMWWRSasDVpvbpmBbKscYGRziOWFgxMSPkP26c1lDM7GiOCR4JsX5ZO0Va48L/kiUK8BpJ2V/HTdfwkDaGYD/r2FpydR7w6IL3qb5b42klMf/NMpqerCehjltt4iqnpnEmshJn+CDMow6/FJnB0LqZnRjBV7xNj4KegA3GwU94zgENLQLqyeaWrYsBFty81hC3VsEz2lS5KF9iEx6TVAKKG6VXKcVSakrOyAHKZ7EBhYHmFZs3+EMQdHLGcQUMyd1kMzrodz4fTIcjUJUZZmRz+eagb4AUBQqmKpHzaTZgWcg6njBFurzvcxZdSUY5mzhxkNMdHAE02/HomijofJ6yvCyfkau6sEt/N/dEK2xxyiJTsAT+07Vo5ZE94a57FsfBVyART6OhEfCxI33kJ5TWJCRIvb5574Hg4qWvvLMHfWwJ+0uc1s86BMbwT1WKatmS17nunkqAAQG6ZThMRYPwQnVvifMjBgvKvibWn8k3GPfDrnVGjM22QidFQB9ctc+DpDX00gHd0ZSqoT0sWzvXUzTViuuaQGo1c4iaUSDRHS7RCzplA0vpGe0+QWd7H1iLm9F15Z5qtQG8wZTzWbDbiC0i6MqVs8XobBLlJhB4NSa1AaBjPxgTkwDUkzzfXrqI2TStruXwJOlcF+LQZ23qXTzoNI10VVwF94bVc682KhL9wa1lH36IL9ceXUcXLXNTHSrmqVw9rAJqXwrLMvwF5/KAh1
 2H9XSMwq
 epgirBbUlSjVv2d/tWcRmmNxZb0H0IKaaRENbH29V6jsEFXFpJmHwFesZhQ3lfSxOv8HYjHGzLo11UByb16D04+ZuFz6Ffu2fOVIhOv4FkP+ZePNFTB45KlYIp/c+98DZOLOfUv4BsoB1GtWNu01YCJDdAv6fhE92rMvQWWldwj5B06EeE0p7c/zEv+QVznkz+KhIE93HcVBT4FvtwVVjue2eaBdYYECR9BkmroT9E/eigpBAnAKrJJK2zpHElUtf3gSUG5klUywq8sWRlmpI0LgaiGoWlpxKxDpWMqQaoluiKcXoTvhz0KNWPGFNMF1okgs7dkBZ1IDCyE/1gzsNwByAKrtVgqpJOWYSC489zVt+QEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch/x86/kvm/svm/caretaker_vmenter.S and caretaker.h for standalone
AMD SVM VMRUN world switch on preserved physical cores.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/svm/caretaker.h         | 63 +++++++++++++++++++
 arch/x86/kvm/svm/caretaker_vmenter.S | 91 ++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)
 create mode 100644 arch/x86/kvm/svm/caretaker.h
 create mode 100644 arch/x86/kvm/svm/caretaker_vmenter.S

diff --git a/arch/x86/kvm/svm/caretaker.h b/arch/x86/kvm/svm/caretaker.h
new file mode 100644
index 000000000000..54a0673cb1ea
--- /dev/null
+++ b/arch/x86/kvm/svm/caretaker.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __SVM_CARETAKER_H
+#define __SVM_CARETAKER_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/kvm_host.h>
+#include <linux/oncore.h>
+#include "svm.h"
+#endif
+
+#include "../caretaker.h"
+
+#define CSP_VMCB_OFFSET		0x1000
+#define CSP_HSAVE_PA_OFFSET	0x3000
+#define CSP_VMCB_PA_OFFSET	0x3010
+#define VMCB_RAX_OFFSET		0x5f8
+
+#ifndef __ASSEMBLY__
+
+struct caretaker_svm_page {
+	struct caretaker_x86_page common;
+
+	/* Page 1 (4KB): Preserved VMCB */
+	struct vmcb vmcb __aligned(PAGE_SIZE);
+
+	/* Page 2 (4KB): Preserved HSAVE area */
+	u8 hsave_area[PAGE_SIZE] __aligned(PAGE_SIZE);
+	u64 hsave_pa;
+	u64 orig_hsave_pa;
+	u64 vmcb_pa;
+	u64 orig_efer;
+
+	/* Preserved MSR and I/O permission bitmaps referenced by VMCB */
+	u8 msrpm[MSRPM_SIZE] __aligned(PAGE_SIZE);
+	u8 iopm[IOPM_SIZE] __aligned(PAGE_SIZE);
+} __aligned(PAGE_SIZE);
+
+static_assert(offsetof(struct caretaker_svm_page, vmcb) == CSP_VMCB_OFFSET);
+static_assert(offsetof(struct caretaker_svm_page, hsave_pa) == CSP_HSAVE_PA_OFFSET);
+static_assert(offsetof(struct caretaker_svm_page, vmcb_pa) == CSP_VMCB_PA_OFFSET);
+
+void svm_recalc_intercepts(struct kvm_vcpu *vcpu);
+
+#ifdef CONFIG_KVM_CARETAKER
+int svm_caretaker_enter(void *page);
+void svm_caretaker_decode_exit(void *page, struct kvm_caretaker_exit *exit);
+void svm_caretaker_register(void);
+void svm_caretaker_unregister(void);
+void svm_caretaker_init(struct kvm_vcpu *vcpu);
+#else
+static inline void svm_caretaker_register(void) {}
+static inline void svm_caretaker_unregister(void) {}
+static inline void svm_caretaker_init(struct kvm_vcpu *vcpu) {}
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __SVM_CARETAKER_H */
diff --git a/arch/x86/kvm/svm/caretaker_vmenter.S b/arch/x86/kvm/svm/caretaker_vmenter.S
new file mode 100644
index 000000000000..e0276a34403e
--- /dev/null
+++ b/arch/x86/kvm/svm/caretaker_vmenter.S
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/linkage.h>
+#include <linux/cfi_types.h>
+#include <asm/asm.h>
+#include <asm/bitsperlong.h>
+#include <asm/nospec-branch.h>
+#include "caretaker.h"
+#include "../caretaker_asm.h"
+
+.section .text.cpu_preserved, "ax"
+
+/**
+ * svm_caretaker_enter - Low-level transition to SVM guest mode and back
+ * @csp: Pointer to struct caretaker_svm_page (%rdi)
+ */
+SYM_TYPED_FUNC_START(svm_caretaker_enter)
+	ENDBR
+	CARETAKER_PUSH_HOST_REGS
+	movq %cr3, %rax
+	pushq %rax                  /* saved_cr3 */
+
+	clgi
+	sti
+
+	/* 0. Save host VMCB state (FS, GS, TR, LDTR) to host save area */
+	movq CXP_HSAVE_PA(%rdi), %rax
+	testq %rax, %rax
+	jz 10f
+	vmsave %rax
+10:
+
+	/* 1. Sync guest RAX to VMCB and load guest state (FS, GS, TR, LDTR) */
+	leaq CSP_VMCB_OFFSET(%rdi), %rax
+	movq CXP_REG_RAX(%rdi), %rbx
+	movq %rbx, VMCB_RAX_OFFSET(%rax)
+	movq CSP_VMCB_PA_OFFSET(%rdi), %rax
+	vmload %rax
+
+	/* 2. Restore guest GPRs */
+	CARETAKER_RESTORE_GPRS_NO_RAX %rdi
+
+	/* 3. Run guest */
+	pushq %rdi
+	movq CXP_REG_RDI(%rdi), %rdi
+	movq (%rsp), %rax
+	movq CSP_VMCB_PA_OFFSET(%rax), %rax
+	CARETAKER_CLEAR_CPU_BUFFERS
+	vmrun %rax
+	cli
+
+	/* 4. Guest exited: Save guest GPRs */
+	xchgq %rdi, (%rsp)          /* rdi = csp, stack = guest rdi */
+	popq CXP_REG_RDI(%rdi)
+
+	CARETAKER_SAVE_GPRS_NO_RAX %rdi
+
+	/* Stuff Return Stack Buffer to prevent guest RSB poisoning */
+	CARETAKER_FILL_RETURN_BUFFER %rax
+
+	/* 5. Save guest state to VMCB */
+	movq CSP_VMCB_PA_OFFSET(%rdi), %rax
+	vmsave %rax
+	leaq CSP_VMCB_OFFSET(%rdi), %rax
+	movq VMCB_RAX_OFFSET(%rax), %rbx      /* save.rax */
+	movq %rbx, CXP_REG_RAX(%rdi)
+
+	/* 5a. Restore host VMCB state (FS, GS, TR, LDTR) from HSAVE */
+	movq CXP_HSAVE_PA(%rdi), %rax
+	testq %rax, %rax
+	jz 40f
+	vmload %rax
+40:
+
+	/* 5b. Restore host CR3 if clobbered */
+	popq %rbx                   /* saved_cr3 */
+	movq %cr3, %rcx
+	cmpq %rbx, %rcx
+	je 50f
+	movq %rbx, %cr3
+50:
+	stgi
+
+	/* 6. Restore host callee-saved registers & return to C */
+	CARETAKER_POP_HOST_REGS
+	xorq %rax, %rax
+	ret
+SYM_FUNC_END(svm_caretaker_enter)
-- 
2.55.0.1082.g2b9226bbc0-goog



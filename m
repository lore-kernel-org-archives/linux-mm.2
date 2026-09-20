Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73670C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830B86B00A5; Sun, 20 Sep 2026 15:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2506B00A6; Sun, 20 Sep 2026 15:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A94D6B00A7; Sun, 20 Sep 2026 15:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 437266B00A5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D72111204E8
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:56 +0000 (UTC)
X-FDA: 85235150952.20.A7B0122
Received: from mail-yx2-f36.google.com (mail-yx2-f36.google.com [74.125.224.164])
	by imf16.hostedemail.com (Postfix) with ESMTP id 26D91180004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CEtBy9g/";
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.164 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933075;
	b=QH98+M9q9R7tkvz6YNe8oG9wPWIT3jX/5cYthGhbmpHGhg0KvPkZncXeneKeufAS+cn6gN
	svkumZ/GhsKCMoCaDlrExvOw18YGbWS+x/anATzOw5e/QV6NXcStGoZQ6NmLTxierFG4lo
	P333cIqUzFsrkXlZx2bfq6TdK8+cpiw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CEtBy9g/";
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.164 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TISPcN17siKpndLz83tiaGlQU7pN0QJXl7jCDX0Mj3w=;
	b=yhdeO6VJUNPvHnrkWOX+bniLj4S5sHJO2ToUAqu+FxjXbvcQ8boI6hTu9Ub8N+QQfj4Hx6
	wQC/j7Gfg2dm+WL8Hw++mkjwd6dirGXWFT/QH8+GMHKh6B7iD0NUbpQ9vcAADH7vO059GZ
	rfsfrrIRQ6epfl8DKheyOUOD0eWxZlw=
Received: by mail-yx2-f36.google.com with SMTP id 956f58d0204a3-66e4aaf2ecfso1831366d50.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933074; x=1790537874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TISPcN17siKpndLz83tiaGlQU7pN0QJXl7jCDX0Mj3w=;
        b=CEtBy9g/Dm6H99dwq4lP6HaCBvsKy0XwuGQN1e0eKW8vNWKoFezBktiPUP+6p+q4/S
         lqf7duo6OZg4PLEImNAGWYnU4Vczf9EmEJNJWtWf1gqLJBZbdIsBYXikjtrwPgeGrEh0
         OsQmuZJZg4kgDibDifjJOV4LQuu1OYhBGSNbBNoZRjZge5/lTNtb4SbFcx6bJJt5xwpU
         Tg42Oab9mZoKOhvfQ7sSnik7ZQ32GA7Kp+Lv6wfaQmmv217o29gNa90T9XyNpXEGFe/I
         nQ5m86CKOlGppVyW//0WBmeUc40kyNApJ0KE+uFKnogYNcuY2yvTZiBBYfJsSEaSrDLB
         2zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933074; x=1790537874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TISPcN17siKpndLz83tiaGlQU7pN0QJXl7jCDX0Mj3w=;
        b=KNHB1X1BX0ZT7z5WYB+qzGF7r5rmFxTSr6aExB+LWZOxoxqMNxoFMvdurYnofJLO9l
         0iKN0swTMsarczdCaA5RktVBj81YOTjVXn2vwND+UBXHla9bb7LPYc8UfN5WngYPUocv
         oHd8bkKOpi/h4MDvXBJGZVfVZHIrz7oVkMVyZlRojWx4TKxBpLy6OvbiPi8TYsUSxGrQ
         xSuPKe9hvmrLqK7lzVFse2O2OLcWmuh8zF/JZTvD/PsJFLv3g2m43G9f+gYYbqOaPfEs
         WddRmlPQnVgoqCuxTpqLOdJ/w8lhpaJbjk3nJ5umzn6vP3pwsYZcFDhXkTHRivkaC8WT
         7aYA==
X-Forwarded-Encrypted: i=1; AKwUvBxibkFDe7c0OUO+mStSWbPTO6qbkIB33jgOQ4XB++jiP84Gc1AsgFcxWAPEsho6MLcoRUHdGt6bKA==@kvack.org
X-Gm-Message-State: AFuF++lg8GMw3DCcs9n6zTnWQCAqCl4R/yCN1shQviGF48MvP1mA+Di1
	qcFXI+DD4etQUgeXg8jUyc70PE8A1Hw5Yy96bQQveDOjmPJHzV0MAM657thaZ+GQXYI=
X-Gm-Gg: AYBFou0bJ24kY0j7NpkpCVZax+xP9nYsIfSuufafMO4b94ShCicOD1Z3gvA0I+guDfQ
	sob6YjZEElPvaJyXRtswPP3/u16bF0vIcwCZTO/GE1UEr63Q8g3/WhFAq0yLAiml8PLDNuuyhHI
	Dbj1SZAKak1of9yzRM+OG4VmVGO2Nf25W5eUNRauEo7uk1Z/bSdohI4YzTJo5LlSvTcGJx/V9z6
	7c7Sg6b3sEJ202dGyN5QzonXCPGJniJnlpXnmtZFH1L9paqnGtcL9tkuZ20ni8O4lyNpC9cJUlh
	mYWNRKb7bnfgdd4HHpuMvwxmBB8ob4IvaVBe0n4CGoEYj9ZiI5K/PeniGm9jPGQ6KP4LPGWFx7M
	euecTmvNsdotfTN9eliTggY7GlhE6T4ZWYegHGfw2TXcsz7rvdSEyPhwOE60RCpJ24zGb7Gr90Y
	3kRy5hBCOwV81qMs59W3MFun4EQWnh+XMZtXBoH/GRMG5sKIlqgDbQ5r4rrxvhliAA8Tr+6URVH
	QNG+WAPs+KuF/kX3mH6esZMHUjZ605VOGCwq8O2s0ux4a+nPQrmfAZvKSii574Uj09OLPzRtITN
	HhGC5EgQOJjc6A/Igzs=
X-Received: by 2002:a05:690e:4505:20b0:671:1490:8e67 with SMTP id 956f58d0204a3-6717fdc19eamr2004447d50.72.1789933074089;
        Sun, 20 Sep 2026 12:37:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6729910a52dsm2550544d50.16.2026.09.20.12.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:53 -0700 (PDT)
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
Subject: [RFC PATCH 10/46] KVM: arm64: Implement architectural vCPU state preservation via LUO
Date: Sun, 20 Sep 2026 15:36:14 -0400
Message-ID: <20260920193650.3373435-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26D91180004
X-Stat-Signature: tqib4owqxzw3p1qgcqi7pehb6xmyhm9h
X-Rspam-User: 
X-HE-Tag: 1789933074-162868
X-HE-Meta: U2FsdGVkX1/uoYu/jLiqYxbIuBR5Q47OulMhTf7g8u7w1Ty3t7Fj9FmABw7+5xF5zibqEsVLAIglVVrGutIJuixR1jjm024nvmjZdyGDwMun/1Hs+XBZeXoF8o4hc5T6HMXzuHTGiSmD1R1faLHMZ3ldoRj9aRVyQRj4Xtx5m5kSsD4jNY2djrZdq7noRvGVsexu1T1SCQcR9v368qDwKowkJlyYzzv3mJBb4rSWK/BnwqIWjk9Z3sVjGz8w7sk4QwFkFaxDWKyrWyBiwatuP7xtoVBYEJqgefI8shHr+8BEnHmGjbRbt0MErQ9gSLhsJcYDsfh/lUfzIRSDnCl0uhHZG//uDtNoRXq/ZMyHcx6jywlyHGbjoigvarm53Kt+pA+/Gw5APfa+wuhjw2phicNqC0TgOe/IGmjZL4aLKqrPRk/hoamGfQY+BJlHYjGviBm5ZWtZ/J7X8DtcQm+TcyuH6FHuZ0sIM65PkasC/RkJ7NS//vhP7ElTxGgx1t7ALlXNhLSMc544OkB3dnhlsmHZR2MZJATY3xdKFfTqP609ijh+cqHNRUtldw5HspsU3XLDMb/UUQkn3bXzbSA5YncwaWC4efn1XmD/c0N8HmmkQKR42HVNksmY16y1WFQNTsiW/9zIHbHlSp+E6rWslwCabmyTzBfd2pQXbmYrLybY5QhyS4+aAEorwSJi79L9bBfF5meRKbd8gxa8EjMQX92K9w7FtoIeBE4yLJaKGWc42oKAqOBrBbh2ApC/ieO2KfdgDNbcHsKoZgl7jr5NPdGQoiOet39b/pVhsEFqkSop3nZ0ujl/Iy1r6zCw0aLBeDSO32R+khu6SImIKI76l8el75mQtuAhnBxvdaRhD/gGBFmTnzpbgNkIaKnD5nPc6xd9M6liyGVKr6CK4i/ITMGtRa8Ob7NHEhkM8NukXqPXf0DGf7o98JDAhK2A/Rspcf1yVuAIJZG9wwOt2E/
 3/W8qESa
 UdktZ9z8hP1W2xJxBkTozae90zYpkeiOpkKccXJrQBhax/knHlaxOwQ8x+EtsvaspURUYQ9WdJkMuOkXp09qXjWDJAgScFpsZCI05BM+//lvBp6XL0ICDgGukpTeqXVtuqrYAZYRM5C8XjQ1HN/7qlwSdGcDKvqqWbewheFA+ZRIwd+yuyIMSROJv+7G5tnvC+yR/c/tlYXhchKmIl84Y3WnAV3gxFrGohXG7uJsq/y9kOpxJLhajs0kO27Kn7j1Tfl5h7fE7G65tDd8glXYYvEkFZHGvqu7gMj/pRq3j4vpxBQJ+d4laCLRHWcOCt9aiyWpBNWes7KBwFP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement ARM64 architectural vCPU state preservation and retrieval
handlers over LUO using struct kvm_vcpu_arch_ser in
include/linux/kho/abi/kvm_arm64.h.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/Kconfig            |   1 +
 arch/arm64/kvm/Makefile           |   2 +
 arch/arm64/kvm/kvm_luo.c          | 201 ++++++++++++++++++++++++++++++
 include/linux/kho/abi/kvm_arm64.h |  61 +++++++++
 4 files changed, 265 insertions(+)
 create mode 100644 arch/arm64/kvm/kvm_luo.c
 create mode 100644 include/linux/kho/abi/kvm_arm64.h

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..fd25b3c0d8ca 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
+	select HAVE_KVM_ARCH_VCPU_PRESERVE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..d5e888d1bd50 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -47,3 +47,5 @@ $(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
 
 obj-kvm := $(addprefix $(obj)/, $(kvm-y))
 $(obj-kvm): $(obj)/hyp_constants.h
+
+kvm-y += kvm_luo.o
diff --git a/arch/arm64/kvm/kvm_luo.c b/arch/arm64/kvm/kvm_luo.c
new file mode 100644
index 000000000000..59c56836cda8
--- /dev/null
+++ b/arch/arm64/kvm/kvm_luo.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * ARM64 KVM LUO preservation and retrieval handlers.
+ */
+
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kvm_arm64.h>
+#include <linux/kvm_host.h>
+#include <linux/sched.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
+
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "sys_regs.h"
+#include "vgic/vgic.h"
+
+int kvm_arch_vm_luo_preserve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+	ser->type = kvm_phys_shift(&kvm->arch.mmu);
+	if (kvm_vm_is_protected(kvm))
+		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
+
+	return 0;
+}
+
+int kvm_arch_vm_luo_retrieve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+	return 0;
+}
+
+void kvm_arch_vm_luo_unpreserve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+}
+
+void kvm_arch_vm_luo_finish(struct kvm_luo_ser *ser)
+{
+}
+
+static void kvm_arm_luo_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	regs->regs = vcpu->arch.ctxt.regs;
+	regs->sp_el1 = ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
+	regs->elr_el1 = ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
+	regs->spsr[KVM_SPSR_EL1] = ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
+	regs->spsr[KVM_SPSR_ABT] = vcpu->arch.ctxt.spsr_abt;
+	regs->spsr[KVM_SPSR_UND] = vcpu->arch.ctxt.spsr_und;
+	regs->spsr[KVM_SPSR_IRQ] = vcpu->arch.ctxt.spsr_irq;
+	regs->spsr[KVM_SPSR_FIQ] = vcpu->arch.ctxt.spsr_fiq;
+	regs->fp_regs = vcpu->arch.ctxt.fp_regs;
+}
+
+static void kvm_arm_luo_set_regs(struct kvm_vcpu *vcpu, const struct kvm_regs *regs)
+{
+	vcpu->arch.ctxt.regs = regs->regs;
+	ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1) = regs->sp_el1;
+	ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1) = regs->elr_el1;
+	ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1) = regs->spsr[KVM_SPSR_EL1];
+	vcpu->arch.ctxt.spsr_abt = regs->spsr[KVM_SPSR_ABT];
+	vcpu->arch.ctxt.spsr_und = regs->spsr[KVM_SPSR_UND];
+	vcpu->arch.ctxt.spsr_irq = regs->spsr[KVM_SPSR_IRQ];
+	vcpu->arch.ctxt.spsr_fiq = regs->spsr[KVM_SPSR_FIQ];
+	vcpu->arch.ctxt.fp_regs = regs->fp_regs;
+}
+
+int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
+{
+	struct kvm_vcpu_arch_ser *state;
+	int num_sysregs;
+	u64 *indices;
+	size_t size;
+	int i;
+
+	num_sysregs = kvm_arm_get_sys_reg_indices(vcpu, NULL);
+	indices = kmalloc_array(num_sysregs, sizeof(u64), GFP_KERNEL);
+	if (!indices)
+		return -ENOMEM;
+	num_sysregs = kvm_arm_get_sys_reg_indices(vcpu, indices);
+
+	size = struct_size(state, sysregs, num_sysregs);
+	state = kho_alloc_preserve(size);
+	if (IS_ERR(state)) {
+		kfree(indices);
+		return PTR_ERR(state);
+	}
+
+	/* Core register state (uAPI struct kvm_regs) */
+	kvm_arm_luo_get_regs(vcpu, &state->regs);
+
+	/* Multiprocessor execution state (uAPI struct kvm_mp_state) */
+	kvm_arch_vcpu_ioctl_get_mpstate(vcpu, &state->mp_state);
+	state->pad = 0;
+
+	/* Exception / SError injection events (uAPI struct kvm_vcpu_events) */
+	__kvm_arm_vcpu_get_events(vcpu, &state->events);
+
+	/* CPU target and feature configuration (uAPI struct kvm_vcpu_init) */
+	state->init.target = KVM_ARM_TARGET_GENERIC_V8;
+	bitmap_to_arr32(state->init.features, vcpu->kvm->arch.vcpu_features,
+			KVM_VCPU_MAX_FEATURES);
+
+	/* System registers (uAPI struct kvm_one_reg array) */
+	state->num_sysregs = 0;
+	state->reserved = 0;
+	for (i = 0; i < num_sysregs; i++) {
+		u64 val;
+
+		if (kvm_arm_sys_reg_read(vcpu, indices[i], &val) == 0) {
+			state->sysregs[state->num_sysregs].id = indices[i];
+			state->sysregs[state->num_sysregs].addr = val;
+			state->num_sysregs++;
+		}
+	}
+	kfree(indices);
+
+	KHOSER_STORE_PTR(ser->arch_state, state);
+	return 0;
+}
+
+int kvm_arch_vcpu_luo_retrieve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
+{
+	struct kvm_vcpu_arch_ser *state;
+	int i;
+
+	if (!ser->arch_state.phys)
+		return 0;
+
+	state = KHOSER_LOAD_PTR(ser->arch_state);
+
+	/* Restore vCPU features */
+	bitmap_from_arr32(vcpu->kvm->arch.vcpu_features, state->init.features,
+			  KVM_VCPU_MAX_FEATURES);
+	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &vcpu->kvm->arch.flags);
+	kvm_reset_vcpu(vcpu);
+	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
+
+	vcpu_reset_hcr(vcpu);
+
+	/* Restore core registers */
+	kvm_arm_luo_set_regs(vcpu, &state->regs);
+
+	if (irqchip_in_kernel(vcpu->kvm) &&
+	    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		vgic_v3_reset(vcpu);
+	}
+
+	/* Restore system registers */
+	for (i = 0; i < state->num_sysregs; i++)
+		kvm_arm_sys_reg_write(vcpu, state->sysregs[i].id, state->sysregs[i].addr);
+
+	/* Restore multiprocessor execution state */
+	kvm_arch_vcpu_ioctl_set_mpstate(vcpu, &state->mp_state);
+
+	/* Restore exception / SError injection events */
+	__kvm_arm_vcpu_set_events(vcpu, &state->events);
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		struct vgic_irq *irq;
+		unsigned long flags;
+
+		vcpu->kvm->arch.vgic.enabled = true;
+
+		irq = vgic_get_vcpu_irq(vcpu, timer_irq(vcpu_vtimer(vcpu)));
+		if (irq) {
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+			irq->enabled = true;
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+		irq = vgic_get_vcpu_irq(vcpu, timer_irq(vcpu_ptimer(vcpu)));
+		if (irq) {
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+			irq->enabled = true;
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+
+	return 0;
+}
+
+void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser)
+{
+	if (ser->arch_state.phys) {
+		kho_unpreserve_free(phys_to_virt(ser->arch_state.phys));
+		ser->arch_state.phys = 0;
+	}
+}
+
+void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser)
+{
+	if (ser->arch_state.phys) {
+		kho_restore_free(phys_to_virt(ser->arch_state.phys));
+		ser->arch_state.phys = 0;
+	}
+}
diff --git a/include/linux/kho/abi/kvm_arm64.h b/include/linux/kho/abi/kvm_arm64.h
new file mode 100644
index 000000000000..dc121224a177
--- /dev/null
+++ b/include/linux/kho/abi/kvm_arm64.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_KHO_ABI_KVM_ARM64_H
+#define _LINUX_KHO_ABI_KVM_ARM64_H
+
+#ifdef CONFIG_ARM64
+
+#include <linux/build_bug.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/kho/abi/kvm.h>
+#include <uapi/linux/kvm.h>
+#include <uapi/asm/kvm.h>
+
+/**
+ * DOC: arm64 KVM vCPU Live Update ABI
+ *
+ * arm64 KVM uses the ABI defined below for preserving architectural vCPU state
+ * across a kexec reboot using LUO.
+ *
+ * The state is serialized into a packed structure `struct kvm_vcpu_arch_ser`
+ * which is handed over to the next kernel via KHO.
+ *
+ * The core register structure (struct kvm_regs) is a uAPI contract.
+ *
+ * This interface is a contract. Any modification to the structure layout
+ * constitutes a breaking change. Such changes require incrementing the version
+ * number in the KVM_VCPU_LUO_FH_COMPATIBLE string.
+ */
+
+/**
+ * struct kvm_vcpu_arch_ser - Preserved arm64 architectural vCPU state in RAM.
+ * @regs:        Core general-purpose and floating-point registers (uAPI struct kvm_regs).
+ * @mp_state:    Multiprocessor execution state (uAPI struct kvm_mp_state).
+ * @pad:         Padding to maintain 64-bit alignment after mp_state.
+ * @events:      Exception and SError injection state (uAPI struct kvm_vcpu_events).
+ * @init:        Target CPU and vCPU feature bitmap (uAPI struct kvm_vcpu_init).
+ * @num_sysregs: Number of serialized system registers in sysregs array.
+ * @reserved:    Reserved padding for 64-bit alignment.
+ * @sysregs:     Guest architectural system registers (uAPI struct kvm_one_reg array).
+ */
+struct kvm_vcpu_arch_ser {
+	struct kvm_regs regs;
+	struct kvm_mp_state mp_state;
+	u32 pad;
+	struct kvm_vcpu_events events;
+	struct kvm_vcpu_init init;
+	u32 num_sysregs;
+	u32 reserved;
+	struct kvm_one_reg sysregs[];
+} __packed;
+
+static_assert(offsetof(struct kvm_vcpu_arch_ser, sysregs) % sizeof(u64) == 0,
+	      "sysregs must be 64-bit aligned");
+
+#endif /* CONFIG_ARM64 */
+
+#endif /* _LINUX_KHO_ABI_KVM_ARM64_H */
-- 
2.55.0.1082.g2b9226bbc0-goog



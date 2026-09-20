Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487A9C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411D06B00A2; Sun, 20 Sep 2026 15:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E96A6B00A4; Sun, 20 Sep 2026 15:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0F76B00A5; Sun, 20 Sep 2026 15:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E786B6B00A2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08BEDA04C1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:50 +0000 (UTC)
X-FDA: 85235150700.30.CE1C21E
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4C427180003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AciG6lYu;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6OOWCWEEAyOAI2czqhsadBOOeWenJ+qCpBEvpM8s14=;
	b=bUrUbId4pNtU0xxvU6NzOYBtlyrh79J8esGe+MQMe0XIt6ocpSl3r78dCv5Y20d5wf+y35
	R4DGTWk6ruBJviYs2WAbzbdoHg7TrybkX9MM88Li+1xNUeAVas8TyjEFevJ1BqZlY74MDC
	a6n3pvUm9tgXB9dnN4M3IPZyfKNNnFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933068;
	b=uVwPaqa+WXoOBinlHX45c8Hu1w6ITHFSEWv+3aX+Asa9URVzJe7lrOo1onNi89NTLTMZAI
	rAojsGaOmS7gJoia7RMVf0FKzrS13LirAXDQ4OPnwgN17I3hVDRTKbC0RGmg6CseLmrcp8
	hgvih1LyjxuVxL1P+bcYgVr97I+JIHg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AciG6lYu;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab20f4bso2223015d50.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933067; x=1790537867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/6OOWCWEEAyOAI2czqhsadBOOeWenJ+qCpBEvpM8s14=;
        b=AciG6lYuj0wps01r8CDopiw5qjO0i5whEPiWMpWt1SNRCZBRdrUiRx2uOQMblO1A3O
         laZv1mncXJzhp4RO+xkAqc9KVLLO6watpz2XwKe2hUNkOOr9loVEhRdKSfAdbLWRFqNU
         64rcrV51HIY3w7PuxyM6U/i+BZolTbILLuEFYeDLeHgSE4K36hG/hLGIdFxbq+6OtuVo
         pwf5vKqQ/OROlfwIko9IEmeteVxt62XYlEo1k1houdW36elH0epjVWrOGx4ohw39iuS2
         hxgTSUMBphN72UM9dJYh04YYKtBAxwRBC0CWnk7R2fdeLwtWJ58WFaHRWjgrET1UY6ab
         Qo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933067; x=1790537867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/6OOWCWEEAyOAI2czqhsadBOOeWenJ+qCpBEvpM8s14=;
        b=1AA0S1kL5TrT33JPfmwoqm4+xcgPkfho4/bsdVhPKKt/vS/UVwH8uVvSIo46qwwT1D
         jgq4x+POILQgXAJHoUGbIKigAjIUfnXSx8R5vShBv+NOg2TRJfCncZYpqlUPnYlPu7qB
         cvErWdrvOR1dyMTixXe8gLBMs2xedIYiFE0YqlJqtam/LDXQMlAkHZOHhpNaM2h6LWXo
         8RGveLIvZXElbfPeIybeRW+0H0wjSMP3gjZwiD/K83G4w0bxVEHG8M+gAk8k6Phgp5Fx
         eUrxmgBGRL7OO/SR6Fiba8lQLDWKzvtikH2yw8VI0S06IkxItsqEpz97J7u8BWljz4+z
         Cwug==
X-Forwarded-Encrypted: i=1; AKwUvBzcxSKTA1fXgIvzvpzmGEgryMoMP1z9oorXahk/lq28lks7Ma0v3d/5sROqj1XJcDyCWniQAD33ag==@kvack.org
X-Gm-Message-State: AFuF++l7rXcZb+Wj+TzuVX9Y8U3WHcWyWWVMRiq+Tylym4PPAsvAnauc
	tmARMQnNh1nHPbfzPPF/gZsLQg8tbE754byzh7NxmVJSv2H0GSmNIWGpb7B/VIfdD8E=
X-Gm-Gg: AYBFou2zmjwLA0S0l1alf3qrHcD2BGLlopRPFfKNExyuQZly7GP/MnwIt5iwcZdGSOc
	0Q/1qFgW3DBmwhKoXKbCIRk4MjgYKKd8HcadrZPt4msk73kGj7Io5ORx/S4bKCSUsxsqbLGdCM2
	9JYPKMplbwI/Y+7fVjsmrRbRRMRfp4x7DSRImYfsp/2h2cWQ6k/RDoyirHaengKjaen88vSyfWZ
	QxHgUd5VFWnD26zcgNq7GsY2tkqPJ5V4CLmmnTkpX1rEBxBXvkpFUGpyW6gWXr7StuUB2qp2QwR
	8Ip7/8UlffOdW6CKTxKfulhhumT2b/8AopesYxBf82u2l37ZDiRmT0BUGnDbquHOXVToSi5Fg5r
	YHQcIywfU4p6NWmobaGZTmPq7uABaJtXCLjTw+/m2mv9pGChnFMpHNJrzWFaIXgmM5cQTg9pVNI
	pUv60GGPyF4c5UMDw+OVFy+a0URMP98S+oRd6ot8RoKzzvauUFfZHX35NpqJRhSBKpNnONdczCu
	4OsfU8Dy2SQ7TL6GbzxrXGc8zmpUL6XyB+JnVW/1IwxD1L8bAVbprPCUKvHjSsphsHg5pqSc6lw
	CYZWWks1+IERFDlQGJg=
X-Received: by 2002:a05:690e:c47:b0:672:99e0:ebe7 with SMTP id 956f58d0204a3-67299e0f010mr1414888d50.127.1789933067305;
        Sun, 20 Sep 2026 12:37:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47af7bfbsm18831487b3.33.2026.09.20.12.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:46 -0700 (PDT)
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
Subject: [RFC PATCH 09/46] KVM: x86: Implement architectural vCPU state preservation via LUO
Date: Sun, 20 Sep 2026 15:36:13 -0400
Message-ID: <20260920193650.3373435-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7csz4m1ffpr67z5ot6cz8ngsp7uw4h71
X-Rspamd-Queue-Id: 4C427180003
X-HE-Tag: 1789933068-248600
X-HE-Meta: U2FsdGVkX1/NQbIORkJTqyrct7q/haPNSqBluhGJfZF3qAURMsbzkOW5JDKZObozFcKR4ucMhCO+lJ8I7F5zX2Lj/ksl0k2PUJno0hblcTXTntfiNxRoaSR5XjRe0rg22EcnylCRfM9qTXrGmPi3lkQC2bLIYhm0yCq3ewRHOvjatplYBTLruJMl60gzfahbWYV8J/i37pAFCRvRTe/V/4NeMjSGru1k1l9Y5JmOKGyWU7jTSM7nTD8gT4KXJIlICNcpmgAQzjBX3YjczRqg8fx2r/BtQ6fDAsXHodbWT99jU/OVJT14OdFZFTFzVJUsueoLwaJn2FgVyW3wQfiR6mi1dqt66RFqi9Ic8w1J9V3YB54I3Daqo37dmz7T3pKzymSMTAXR/RITEXKGNkjfLtVzt1rJKmi7dJKa3aZjI7W5mZFeO/HA6uDeL+56Y+uodchwrROv6huyokanDtx+yrOJ+v7I4Ilp0cOKshLNua0GJYah63Oal9fscdYyn63ObDarFQSBCnm4siCYWz1ibzGqJXjdpZAs/FDhzc8hkUx87PcnPw96l3caykutHyOblQIsUE7+Ha+rS3faAWXcS9SWsugnOeyU+KSANUVAsPCF/Nog0HIx5ebJYUbuZ1vt6ml2EHQWgX0XUZq93so8dmDoSUGM0y4Tj1MxaO7VVsHnesKOHnlMLVlff96M6PLv5YqXBslebp0gi6iU2Kave7t1NT6k7d5tGygoJAuWFB+iNqw2bde5JC8nLIuHzrcSuJQR4GvnRQzvL/urbu4ZvzIxcXqdkF/cqBYg5ggJ7FxgnoBQoPU5X0RlFUyaGuLxYct665zbZudlLeiloovMOCf2rW3EVfuVPItF9n/yix5gui5zLRPNgtWPWdf18IDEU2ZJ3znGz8vdqhmKkNfFYKaDfVergRXdd9ESDKimFYS9M51DIfJ/C/lSDiNiHA4iLZGBAPNSPjBHV4uPWOd
 2xvELTsU
 04M8UP4ldVtvWvOXXNdvKKiItygJBBYPJ9F6JJ7AYKWHf+/YItVuGt9877VgCQ8maPYhxkml8w8UaT4KdmHi13TtgUH2dh+S8RmoT51zh1iOTrgIgpb8LWzQ/c+AdUnXbp2HDjb8eqg0ig0Nvj62IxbDcsA4fp33IJDPXaTyN7KFcVWGzp6MyfJURiJQKe5uuLTeGCblqjKUSWB/vVspXkLikLfgHlIcyv69gsJkCt46uuRmIRpBHE9pcZh6xHIyg3+/xLH3DI/gcDnMen4RzHUgWJSScLQXGteCNnfGPnAK9l7moQjfmk4FVPrM5yecCfDOtYkssQyrWYTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement x86 KVM vCPU state preservation and restoration handlers for
LUO in arch/x86/kvm/kvm_luo.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/Kconfig   |   1 +
 arch/x86/kvm/Makefile  |   1 +
 arch/x86/kvm/kvm_luo.c | 338 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 340 insertions(+)
 create mode 100644 arch/x86/kvm/kvm_luo.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 538ed1e80332..bae79fded6ff 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM_X86
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
 	select KVM_GUEST_MEMFD if X86_64
+	select HAVE_KVM_ARCH_VCPU_PRESERVE
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 0474604ab8a1..2cf0f1f2a59b 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,6 +7,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 
 kvm-y			+= x86.o emulate.o irq.o lapic.o cpuid.o msrs.o pmu.o regs.o \
 			   mtrr.o debugfs.o mmu/mmu.o mmu/page_track.o mmu/spte.o
+kvm-$(CONFIG_LIVEUPDATE) += kvm_luo.o
 
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_IOAPIC) += i8259.o i8254.o ioapic.o
diff --git a/arch/x86/kvm/kvm_luo.c b/arch/x86/kvm/kvm_luo.c
new file mode 100644
index 000000000000..899b193812bb
--- /dev/null
+++ b/arch/x86/kvm/kvm_luo.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * x86 KVM LUO architectural preservation and retrieval handlers.
+ */
+
+#include <linux/cpu.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kvm_x86.h>
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include <asm/fpu/api.h>
+#include <asm/fpu/xcr.h>
+#include <linux/kvm_host.h>
+#include <linux/mem_encrypt.h>
+#include <asm/virt.h>
+
+#include "cpuid.h"
+#include "fpu.h"
+#include "lapic.h"
+#include "msrs.h"
+#include "pmu.h"
+#include "regs.h"
+#include "x86.h"
+
+int kvm_arch_vm_luo_preserve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+	ser->type = kvm->arch.vm_type;
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vm_luo_preserve);
+
+int kvm_arch_vm_luo_retrieve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vm_luo_retrieve);
+
+void kvm_arch_vm_luo_unpreserve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vm_luo_unpreserve);
+
+void kvm_arch_vm_luo_finish(struct kvm_luo_ser *ser)
+{
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vm_luo_finish);
+
+int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
+{
+	struct kvm_vcpu_arch_ser *state;
+	bool fpu_loaded = false;
+	unsigned int max_msrs;
+	u32 nent;
+	size_t size;
+	int i;
+
+	/*
+	 * The guest FPU state travels in @xsave, which can only be filled in if
+	 * the host has XSAVE.  There is no second copy to fall back on, so fail
+	 * the preserve rather than silently dropping the guest's FPU registers.
+	 * A confidential guest keeps its FPU state in the VMSA, where KVM can
+	 * neither read nor restore it, so it needs nothing from us.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_XSAVE) &&
+	    !fpstate_is_confidential(&vcpu->arch.guest_fpu))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Nested virtualisation state does not survive the handover.
+	 * arm64 already refuses vcpu_has_nv() outright; do the same here.
+	 */
+	if (is_guest_mode(vcpu))
+		return -EOPNOTSUPP;
+
+	if (kvm_nested_ops.enabled && kvm_nested_ops.get_state) {
+		int nested_size = kvm_nested_ops.get_state(vcpu, NULL, 0);
+
+		if (nested_size < 0)
+			return nested_size;
+		if (nested_size > sizeof(struct kvm_nested_state))
+			return -EOPNOTSUPP;
+	}
+
+	/*
+	 * @xsave is a fixed-size struct kvm_xsave.  A guest whose XSAVE area
+	 * outgrows it -- AMX today -- needs KVM_GET_XSAVE2 and would otherwise
+	 * be truncated silently by fpu_copy_guest_fpstate_to_uabi() below.
+	 * This mirrors the check kvm_arch_vcpu_ioctl() makes for KVM_GET_XSAVE.
+	 */
+	if (vcpu->arch.guest_fpu.uabi_size > sizeof(struct kvm_xsave))
+		return -EOPNOTSUPP;
+
+	max_msrs = kvm_num_msrs_to_save();
+	nent = vcpu->arch.cpuid_entries ? vcpu->arch.cpuid_nent : 0;
+	size = sizeof(*state) + max_msrs * sizeof(struct kvm_msr_entry) +
+	       nent * sizeof(struct kvm_cpuid_entry2);
+	state = kho_alloc_preserve(size);
+	if (IS_ERR(state))
+		return PTR_ERR(state);
+
+	/*
+	 * kvm_arch_vcpu_ioctl_{get,set}_mpstate() take the vCPU themselves, so
+	 * they have to be called outside the vcpu_load() region below:
+	 * vcpu_load() registers a preempt notifier and is not reentrant.
+	 */
+	kvm_arch_vcpu_ioctl_get_mpstate(vcpu, &state->mp_state);
+	state->pad = 0;
+
+	vcpu_load(vcpu);
+
+	__get_regs(vcpu, &state->regs);
+	__get_sregs(vcpu, &state->sregs);
+	state->xcrs.nr_xcrs = 1;
+	state->xcrs.flags = 0;
+	state->xcrs.xcrs[0].xcr = XCR_XFEATURE_ENABLED_MASK;
+	state->xcrs.xcrs[0].value = vcpu->arch.xcr0;
+
+	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
+	    !fpstate_is_confidential(&vcpu->arch.guest_fpu)) {
+		u64 supported_xcr0 = vcpu->arch.guest_supported_xcr0 |
+				     XFEATURE_MASK_FPSSE;
+
+		fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
+					       state->xsave.region,
+					       sizeof(state->xsave.region),
+					       supported_xcr0,
+					       vcpu->arch.pkru);
+	}
+
+	kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &state->debugregs);
+
+	/*
+	 * A hardware maskable interrupt can only be queued for injection when
+	 * RFLAGS.IF is set.  If RFLAGS.IF is already clear, the interrupt gate
+	 * delivery has already completed (e.g., under QEMU TCG where
+	 * exit_int_info can remain set across the first instruction of the
+	 * handler), so clear any stale injected flag to avoid delivering the
+	 * same interrupt a second time with RFLAGS.IF == 0 before SWAPGS.
+	 */
+	if (vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft &&
+	    !(state->regs.rflags & X86_EFLAGS_IF))
+		vcpu->arch.interrupt.injected = false;
+
+	kvm_vcpu_ioctl_x86_get_vcpu_events(vcpu, &state->events);
+
+	if (lapic_in_kernel(vcpu))
+		kvm_apic_get_state(vcpu, &state->lapic);
+
+	if (!vcpu->arch.guest_fpu.fpstate->in_use) {
+		kvm_load_guest_fpu(vcpu);
+		fpu_loaded = true;
+	}
+
+	state->num_msrs = 0;
+	for (i = 0; i < max_msrs; i++) {
+		u32 msr = kvm_get_msr_to_save_index(i);
+		u64 val = 0;
+
+		if (kvm_msr_read(vcpu, msr, &val) == 0) {
+			state->msrs[state->num_msrs].index = msr;
+			state->msrs[state->num_msrs].reserved = 0;
+			state->msrs[state->num_msrs].data = val;
+			state->num_msrs++;
+		}
+	}
+
+	state->cpuid_nent = nent;
+	if (nent) {
+		struct kvm_cpuid_entry2 *cpuid_dst =
+			(void *)&state->msrs[state->num_msrs];
+
+		memcpy(cpuid_dst, vcpu->arch.cpuid_entries,
+		       nent * sizeof(*cpuid_dst));
+	}
+
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
+
+	vcpu_put(vcpu);
+
+	KHOSER_STORE_PTR(ser->arch_state, state);
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_preserve);
+
+int kvm_arch_vcpu_luo_retrieve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
+{
+	struct kvm_vcpu_arch_ser *state;
+	bool fpu_loaded = false;
+	int ret, i;
+
+	if (!ser->arch_state.phys)
+		return 0;
+
+	state = KHOSER_LOAD_PTR(ser->arch_state);
+
+	vcpu_load(vcpu);
+
+	if (state->cpuid_nent > 0) {
+		struct kvm_cpuid_entry2 *cpuid_src =
+			(void *)&state->msrs[state->num_msrs];
+		struct kvm_cpuid_entry2 *entries;
+
+		entries = kmemdup(cpuid_src,
+				  state->cpuid_nent * sizeof(*entries),
+				  GFP_KERNEL);
+		if (!entries) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = kvm_set_cpuid(vcpu, entries, state->cpuid_nent);
+		if (ret) {
+			kvfree(entries);
+			goto out;
+		}
+	}
+
+	ret = __set_sregs(vcpu, &state->sregs);
+	if (ret)
+		goto out;
+
+	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
+		__kvm_set_xcr(vcpu, state->xcrs.xcrs[0].xcr,
+			      state->xcrs.xcrs[0].value);
+	}
+
+	for (i = 0; i < state->num_msrs; i++) {
+		if (state->msrs[i].index == MSR_IA32_XFD ||
+		    state->msrs[i].index == MSR_IA32_XFD_ERR ||
+		    state->msrs[i].index == MSR_IA32_XSS) {
+			kvm_msr_write(vcpu, state->msrs[i].index, state->msrs[i].data);
+		}
+	}
+
+	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
+	    !fpstate_is_confidential(&vcpu->arch.guest_fpu)) {
+		union fpregs_state *xstate = (union fpregs_state *)state->xsave.region;
+
+		xstate->xsave.header.xfeatures &= ~vcpu->arch.guest_fpu.fpstate->xfd;
+		ret = fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
+						     state->xsave.region,
+						     kvm_caps.supported_xcr0,
+						     &vcpu->arch.pkru);
+		if (ret)
+			goto out;
+	}
+
+	ret = kvm_vcpu_ioctl_x86_set_debugregs(vcpu, &state->debugregs);
+	if (ret)
+		goto out;
+
+	if (kvm_nested_ops.enabled)
+		kvm_leave_nested(vcpu);
+
+	if (!(ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER)) {
+		ret = kvm_vcpu_ioctl_x86_set_vcpu_events(vcpu, &state->events);
+		if (ret)
+			goto out;
+	}
+
+	if (lapic_in_kernel(vcpu)) {
+		if (ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) {
+			struct kvm_lapic_state lapic;
+			int k;
+
+			memcpy(&lapic, &state->lapic, sizeof(lapic));
+			for (k = 0; k < 8; k++) {
+				*(u32 *)(lapic.regs + APIC_ISR + 0x10 * k) = 0;
+				*(u32 *)(lapic.regs + APIC_IRR + 0x10 * k) = 0;
+			}
+			ret = kvm_apic_set_state(vcpu, &lapic);
+		} else {
+			ret = kvm_apic_set_state(vcpu, &state->lapic);
+		}
+		if (ret)
+			goto out;
+	}
+
+	if (!vcpu->arch.guest_fpu.fpstate->in_use) {
+		kvm_load_guest_fpu(vcpu);
+		fpu_loaded = true;
+	}
+
+	for (i = 0; i < state->num_msrs; i++) {
+		if ((ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) &&
+		    (state->msrs[i].index == MSR_IA32_TSC ||
+		     state->msrs[i].index == MSR_IA32_TSC_ADJUST)) {
+			continue;
+		}
+		kvm_msr_write(vcpu, state->msrs[i].index, state->msrs[i].data);
+	}
+
+	__set_regs(vcpu, &state->regs);
+
+	ret = 0;
+out:
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
+	vcpu_put(vcpu);
+
+	/* Takes the vCPU itself; see the comment in the preserve path. */
+	if (!ret)
+		ret = kvm_arch_vcpu_ioctl_set_mpstate(vcpu, &state->mp_state);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_retrieve);
+
+void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser)
+{
+	if (ser->arch_state.phys) {
+		struct kvm_vcpu_arch_ser *state =
+			phys_to_virt(__sme_clr(ser->arch_state.phys));
+
+		kho_unpreserve_free(state);
+		ser->arch_state.phys = 0;
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_unpreserve);
+
+void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser)
+{
+	if (ser->arch_state.phys) {
+		struct kvm_vcpu_arch_ser *state =
+			phys_to_virt(__sme_clr(ser->arch_state.phys));
+
+		kho_restore_free(state);
+		ser->arch_state.phys = 0;
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_finish);
-- 
2.55.0.1082.g2b9226bbc0-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A03CC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6612D6B00DE; Sun, 20 Sep 2026 15:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638AF6B00DF; Sun, 20 Sep 2026 15:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5273C6B00E0; Sun, 20 Sep 2026 15:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 279B66B00DE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68213804C1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:45 +0000 (UTC)
X-FDA: 85235158050.13.747038E
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3CEBC0004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UUq5taT7;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933243;
	b=UyL1zrR1f+9z+1LfMbabSOasiQK2PTuUPrSnDiXX7LaOas0lR8kw/IGdhIixUIOHtbABja
	/Vamk+ge76YAIujarHHQMWk9Z1/RizsnbqZU6y+ACBI1FKVSCmyDfhce9E4kcfj4nkJenu
	xxok7LNEC5mAwhj1WKYhS0H+fmWM2vU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UUq5taT7;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AnhgWYPBDTyEtljyN9gDdKnSFvI32a3E+pDg291Dw4=;
	b=hCGQHexjuh8rRsbHw/c3Ji2TcVuZwLGktyjjWKtq+x57GEKJCTdTJ3PNLMqwQyv4MCsVG+
	ISuQyOCFZ87RNl7ODN8nf1K65jiR510e3qrSwI0rHEh/IhkEV/rnRe0V1F8vF/teEADNbt
	b0hO8NXd5fBoTbny4GgHZT3lig1h8S0=
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d440939efso18022747b3.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933243; x=1790538043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8AnhgWYPBDTyEtljyN9gDdKnSFvI32a3E+pDg291Dw4=;
        b=UUq5taT7HiofgszZ6NRtfpGn40T6LI1tzRC4pumzKwxhgJsTz1BHnpj1FMK/0AyGU5
         K13c0784CFq7NlElO1Xb6PqgV2RbdxCIRInwK8tNesbqRj4nxa0+dZZY69+H5bLm8CVJ
         hnuInJ4naq+u/ogQrnGu4KB7GOJZO5crsheX07KzoQwL8uD23k8ro+GgUq9Sdn/Wlqdb
         ZMre49GxQEXqg3b2k1fdyTzls2WYzixe94DakW5gC5mP7GD5h19ozhugO5MACZJC0o3h
         xqnWQvFI/n3fZWSQT7YClP5vgnXNNYAKUYdZlRg4+DH4yKHw4Ni2uW1y+8HAbMEvbtLb
         lkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933243; x=1790538043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8AnhgWYPBDTyEtljyN9gDdKnSFvI32a3E+pDg291Dw4=;
        b=IYePTUM87omzfcdLuaZki9w1tTdiwAj44jNQnUPt9PXHFClgPQILAp13nHzz9V97Sy
         EkyXU4nBOGSxmbno0pY+0W5CLCYBWHwOjG2tetYE6pgN1QR3Cn5JK/xZoro+NDN0c3TY
         wjDwytcpq/IFtIDdc/oB8g+Hem2g0gJwd/NRhE587fOgEpkTcb3RDazDUO2Li5SS/R6W
         6loFDGGkV72TkGiApZC/b2NSJOyhcprKJw2rT9dMRwnG/v4p8+jDFVztdId8iZzbZE3h
         gTWOOBDD3k0+/ocVA+buItKwr6DmDmrwWHnirEfPavKtf3bKIo4OjndT8kFdX279Arwf
         5LcQ==
X-Forwarded-Encrypted: i=1; AKwUvByW/Ow2ck66GqKyq9At91/Kcgtn0oofFN4ObaR0YZDSxQfMU0vQsXyX0j8G0v5oqpzBTspLSlrgZg==@kvack.org
X-Gm-Message-State: AFuF++mgbBZUtwNZRuIRc+oUxBGaGT2rldq7lMzoh0/Pg+HuLIUTW4L2
	HfEpD+bTsO97gF4xzNoFp1+pbpx9BQ0r6XS0EFekSO0zIFsUu8+LEHD4ubQUVdRurW4=
X-Gm-Gg: AYBFou1Pr0+3WKPqGmx1HIQb/l3yJ6WbBfBeIb2SxQ858GSM4poTRddrgxlgaY/dBHk
	8NzuAqMhvSgEzWRGCrB7z/Ae/sKnw9CkA17R+gZZaJFhE0e3l170i6zktoECVG5izejOTZU3hnq
	OfYI/x3EfzTvPu3YVkaDvyU5wSN2OTM5czWursaJbTa90gXaPOGUrnhfAz+/bQLaCHjNgdtf3pF
	au6W89VSkpD+DDoRJqYxsGhZiKIyrilGxRYA6Vp438T/sfOhsFuUhlTF6VmdPrBY8DKDnxFco6h
	kyFg/+CJfheBZ3Nlh9jrcSSNUiMtIqA/nDEwTiCj21oo8M+jYo0CzNlwb/9PZT7HMnhGLtf2zag
	QRaugI7oSyYmPB5BWNMTgkT2MZ3MhcXZP8WGxIJf8tHZC3WCtDapJh7ZpNzD2ItI8lHZAiO3Wwf
	YY5qLcSHt9+ocLZp3zXlK+8AcRKiCjJRwgQDzme3vRnXb5wTJpGX6vMHveY3ZLlZGAXo2tDIe6Y
	IRzX7sTQlvv1U33xGhzS+Ji5YrxTbu1m0uwkUwDu/BhMgnJVnRQFY9FlKxafYacGzvYRWgBhBEo
	YXPDHhYtP5iSnqL246I=
X-Received: by 2002:a05:690e:b88:b0:671:1a19:2dc with SMTP id 956f58d0204a3-6717fc6196emr2697319d50.11.1789933242627;
        Sun, 20 Sep 2026 12:40:42 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672991445desm2616083d50.20.2026.09.20.12.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:42 -0700 (PDT)
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
Subject: [RFC PATCH 38/46] KVM: VMX: Implement Caretaker VMX VMCS lifecycle and exit dispatch
Date: Sun, 20 Sep 2026 15:36:42 -0400
Message-ID: <20260920193650.3373435-39-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3CEBC0004
X-Stat-Signature: nrb6rr7ktfqnegyzitbparsfqt8op9xa
X-Rspam-User: 
X-HE-Tag: 1789933243-712839
X-HE-Meta: U2FsdGVkX19bK3WJVTDDkLyUllvJvGbY9hRl5l8qqR4zk8wFG5KuN3pwZh4ldZIijHQx4L/el9T1ZUJafaB5N9QSHczU8gFR3t7JwzZm2Hz2UCLeR91xWQr2Pj6wS7tQqliva7bBzRX4YmaVxzicAbeqJSuMvsumC071lYpBULUFR16LD/E4AuiHJk4Q82mUjZffrJVzqlsbXvcCCbRnLVhUss3C1hiNI4iNujPG48rRY1XA0oydQSduqIOiINWEp7mRFYsJqNukcdOPBozQmV/zamnx1Mjw4MfwG9VZWjhWxB8V7QafP+7aIul1/CX2msBNhw6PG16EMwmaoJV6q37NHOYVDg+BEFXKl7ZQ+IcCF+fxH8KZM42E52zrLoxesjL2Wh4ZMgoqss4FyR1FdGAzHq9U8+OZ+jrLhzpvyPy0Nc9Zcv8cn1R5P46KcDxiiFAX9uY06b/M5Z1i3kNMizCfEtaCNgvhTjGSKxMjSQfHqHg7KVRFY0J0cNWhs1eFHA/jYro3IIMCZDBFNgSi/F64CmEUOxtDWABYR6pkgKDngdW3Z6npCg8iWgfmFILZSay1CsbIYPdBPW5rFWsTa2QmpaxqYzWovmyW15LAkOxutvEnsap0K+P4YIEI1z4D2Lryj5mJlqgxFHeHOem0lPm6awrhw3OnItpbrYNVVSoTS+DOvHk66PL8hXNpmC3NcTo7Y667vDW2EbrQ3gqm5Evc5dGgji2arOrUIVH+ffjoafXoVL5zJvNzlMXKOhf9TK0zk/WIu/Ttt+EOHkvCHSRsQp9S3JxGkYSBnBVl0z+ONN6EHxhVT0UMepQNDvfR72wWNsZ4qlosQy2XcVW0R9PLWpIoMyM3myGHDREQe9r5XwULNN68xOrtqeGfdpcvO5TwXzUWKEj5g/QQEa4rwJnNU/EcKGZSqWsjWdqdqoXqHnuax9zn5p0Ajym7qU8PHqafKG6dLiDi0vFAIr+
 A6UbqYaz
 nY/RXSjGjw7zc5Z87ay32nf0mdgP6IvIae7vaycHfgLGU2QcTWU0c3amWsiWWxXKCBhvs1bFaKuHicPMxliJkOOpxrQ8vHBj4ztujSfv/esuOERb9oklEp5zNlHWCEDnqoZktLWxLX+6pvRY+TMTzDh1Yo2vwrjEOLkRdMvwpYPX8/iTdhXNvHcbHC+12/Sqoa46zcImLbNhpiAR2tAp9mTFe33bSYTNmC8k/5pHzSZuTyfnvI30QplVbsHL72J8/1/vFguOPIWN37+jGtNtFYxZ9eAKF+SrpqTqUUB+/WLxR7AdOblzFxRXWm8jmnHWzmJiBYgYPskkIHME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement Intel VMX Caretaker VMCS setup, exit decoding, and guest
entry/exit loop in arch/x86/kvm/vmx/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/vmx/caretaker.c         | 340 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/caretaker_vmenter.S |  12 +-
 arch/x86/kvm/vmx/vmx.c               |   2 +-
 arch/x86/kvm/vmx/vmx.h               |   1 +
 4 files changed, 347 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/caretaker.c

diff --git a/arch/x86/kvm/vmx/caretaker.c b/arch/x86/kvm/vmx/caretaker.c
new file mode 100644
index 000000000000..47b4743650e5
--- /dev/null
+++ b/arch/x86/kvm/vmx/caretaker.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Intel VMX Caretaker Standalone Execution Engine
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Runs the Intel VMX guest execution loop in an isolated, KHO-preserved memory
+ * page that remains alive and executing across kexec relocation and
+ * kernel handover.
+ */
+
+#include <linux/cleanup.h>
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/kvm_host.h>
+#include <linux/objtool.h>
+#include <linux/oncore.h>
+
+#include <asm/apic.h>
+#include <asm/cpu_entry_area.h>
+#include <asm/desc.h>
+#include <asm/fixmap.h>
+#include <linux/pgtable.h>
+#include <linux/processor.h>
+#include <asm/segment.h>
+#include <asm/set_memory.h>
+#include <asm/virt.h>
+#include <asm/vmx.h>
+
+#include "../caretaker.h"
+#include "caretaker.h"
+#include "vmx.h"
+#include "vmx_ops.h"
+#include "x86.h"
+#include "x86_ops.h"
+
+static int vmx_caretaker_init_page(struct caretaker_vmx_page *cvp,
+				   struct kvm_vcpu *vcpu);
+STACK_FRAME_NON_STANDARD(vmx_caretaker_init_page);
+
+static int vmx_caretaker_init_page(struct caretaker_vmx_page *cvp,
+				   struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 basic_msr, misc_msr;
+	int ret;
+
+	if (!vmx->vmcs01.vmcs)
+		return -EINVAL;
+
+	ret = kvm_x86_caretaker_init_common_page(&cvp->common, vcpu, sizeof(*cvp));
+	if (ret)
+		return ret;
+	cvp->common.abi.vmcs_pa = virt_to_phys(vmx->vmcs01.vmcs);
+	cvp->vmxon_pa = virt_to_phys(cvp->vmxon_area);
+
+	memset(cvp->vmxon_area, 0, PAGE_SIZE);
+	basic_msr = native_rdmsrq(MSR_IA32_VMX_BASIC);
+	*(u32 *)cvp->vmxon_area = vmx_basic_vmcs_revision_id(basic_msr);
+
+	if (!rdmsrq_safe(MSR_IA32_VMX_MISC, &misc_msr))
+		cvp->timer_shift = vmx_misc_preemption_timer_rate(misc_msr);
+	else
+		cvp->timer_shift = VMX_PREEMPTION_TIMER_SHIFT;
+
+	cvp->ple_supported = cpu_has_vmx_ple();
+
+	vcpu_load(vcpu);
+
+	cvp->common.kernel_gs_base = vmx->msr_guest_kernel_gs_base;
+	kvm_msr_read(vcpu, MSR_STAR, &cvp->star);
+	kvm_msr_read(vcpu, MSR_LSTAR, &cvp->lstar);
+	kvm_msr_read(vcpu, MSR_SYSCALL_MASK, &cvp->fmask);
+
+	/* Save current guest control registers from KVM */
+	cvp->common.cr0 = kvm_read_cr0(vcpu);
+	cvp->common.cr3 = kvm_read_cr3(vcpu);
+	cvp->common.cr4 = kvm_read_cr4(vcpu);
+	cvp->common.efer = vcpu->arch.efer;
+
+	cvp->common.last_exit_rip = kvm_rip_read(vcpu);
+	cvp->common.last_exit_rsp = kvm_rsp_read(vcpu);
+	cvp->common.last_exit_rflags = kvm_get_rflags(vcpu);
+
+	if (kvm_host.efer & EFER_NX)
+		cvp->common.efer |= EFER_NX;
+
+	vcpu_put(vcpu);
+
+	if (vmx->loaded_vmcs)
+		loaded_vmcs_clear(vmx->loaded_vmcs);
+
+	return 0;
+}
+
+void vmx_caretaker_init(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct caretaker_vmx_page *cvp;
+	struct kvm_caretaker_arch_ser *abi;
+
+	cvp = kho_alloc_preserve(sizeof(*cvp));
+	if (IS_ERR(cvp)) {
+		pr_err("caretaker vmx: failed to allocate preserved page\n");
+		return;
+	}
+
+	if (vmx_caretaker_init_page(cvp, vcpu))
+		goto err_free;
+
+	abi = &cvp->common.abi;
+	if (vmx->vmcs01.vmcs &&
+	    kvm_x86_caretaker_preserve_page(abi, virt_to_page(vmx->vmcs01.vmcs)))
+		goto err_free;
+	if (vmx->vmcs01.msr_bitmap &&
+	    kvm_x86_caretaker_preserve_page(abi, virt_to_page(vmx->vmcs01.msr_bitmap)))
+		goto err_free;
+	if (vmx->pml_pg &&
+	    kvm_x86_caretaker_preserve_page(abi, vmx->pml_pg))
+		goto err_free;
+	if (vmx->ve_info &&
+	    kvm_x86_caretaker_preserve_page(abi, virt_to_page(vmx->ve_info)))
+		goto err_free;
+
+	return;
+
+err_free:
+	kvm_x86_caretaker_unpreserve_pages(&cvp->common.abi);
+	vcpu->caretaker.cb = NULL;
+	kho_unpreserve_free(cvp);
+}
+
+static __cpu_preserved_text void vmx_caretaker_disarm_timer(void *page)
+{
+	u32 pin = (u32)vmx_vmread(PIN_BASED_VM_EXEC_CONTROL);
+
+	if (pin & PIN_BASED_VMX_PREEMPTION_TIMER) {
+		vmx_vmwrite(PIN_BASED_VM_EXEC_CONTROL,
+			    pin & ~PIN_BASED_VMX_PREEMPTION_TIMER);
+	}
+}
+
+static inline unsigned long vmx_caretaker_read_cr0(void)
+{
+	unsigned long mask = vmx_vmread(CR0_GUEST_HOST_MASK);
+
+	return (vmx_vmread(CR0_READ_SHADOW) & mask) |
+	       (vmx_vmread(GUEST_CR0) & ~mask);
+}
+
+static inline unsigned long vmx_caretaker_read_cr4(void)
+{
+	unsigned long mask = vmx_vmread(CR4_GUEST_HOST_MASK);
+
+	return (vmx_vmread(CR4_READ_SHADOW) & mask) |
+	       (vmx_vmread(GUEST_CR4) & ~mask);
+}
+
+static inline u64 vmx_caretaker_read_efer(void)
+{
+	u64 efer = vmx_vmread(GUEST_IA32_EFER);
+
+	if (!efer)
+		efer = native_rdmsrq(MSR_EFER);
+	if (vmx_vmread(VM_ENTRY_CONTROLS) & VM_ENTRY_IA32E_MODE)
+		efer |= EFER_LMA | EFER_LME;
+	return efer;
+}
+
+void __cpu_preserved_text
+vmx_caretaker_decode_exit(void *page,
+			  struct kvm_caretaker_exit *exit)
+{
+	struct caretaker_vmx_page *cvp = page;
+	u32 insn_len = (u32)vmx_vmread(VM_EXIT_INSTRUCTION_LEN);
+	u16 exit_reason = (u16)vmx_vmread(VM_EXIT_REASON);
+	u64 qual = vmx_vmread(EXIT_QUALIFICATION);
+	u64 rip = vmx_vmread(GUEST_RIP);
+
+	cvp->common.last_exit_rip = rip;
+	cvp->common.last_exit_rsp = vmx_vmread(GUEST_RSP);
+	cvp->common.last_exit_rflags = vmx_vmread(GUEST_RFLAGS);
+	cvp->common.cr3 = vmx_vmread(GUEST_CR3);
+	cvp->common.cr0 = vmx_caretaker_read_cr0();
+	cvp->common.cr4 = vmx_caretaker_read_cr4();
+
+	exit->rip = rip;
+	exit->insn_len = insn_len;
+	exit->raw_reason = exit_reason;
+	exit->type = KVM_CARETAKER_EXIT_ARCH;
+
+	switch (exit_reason) {
+	case EXIT_REASON_IO_INSTRUCTION: {
+		u16 port = (u16)(qual >> VMX_IO_PORT_SHIFT);
+
+		if (port >= COM1_PORT_BASE && port <= COM1_PORT_END) {
+			exit->type = KVM_CARETAKER_EXIT_CONSOLE;
+			exit->mmio_io.addr = port;
+			exit->mmio_io.is_write = !(qual & VMX_IO_DIRECTION_BIT);
+			exit->mmio_io.size = (u8)((qual & VMX_IO_SIZE_MASK) + 1);
+			exit->mmio_io.is_mmio = false;
+			exit->mmio_io.val_ptr = &cvp->common.rax;
+		}
+		break;
+	}
+	case EXIT_REASON_HLT:
+		exit->type = KVM_CARETAKER_EXIT_IDLE;
+		break;
+	case EXIT_REASON_PAUSE_INSTRUCTION:
+		exit->type = KVM_CARETAKER_EXIT_IDLE;
+		exit->insn_len = insn_len ? insn_len : PAUSE_INSN_LEN;
+		break;
+	case EXIT_REASON_CPUID:
+		exit->type = KVM_CARETAKER_EXIT_CPUID;
+		break;
+	case EXIT_REASON_VMCALL:
+		/*
+		 * Do not write a return value.  The Caretaker cannot run the
+		 * hypercall, and reporting success for something like
+		 * KVM_HC_SEND_IPI or a PV TLB flush is worse than not
+		 * answering at all.  CROSS_VCPU now stalls, so the guest
+		 * stays parked on the VMCALL with RAX untouched until the
+		 * incoming kernel services it.
+		 */
+		exit->type = KVM_CARETAKER_EXIT_CROSS_VCPU;
+		exit->insn_len = insn_len ? insn_len : VMCALL_INSN_LEN;
+		break;
+	case EXIT_REASON_MSR_READ:
+		exit->type = KVM_CARETAKER_EXIT_MSR;
+		exit->msr.msr = (u32)cvp->common.rcx;
+		exit->msr.is_write = false;
+		break;
+	case EXIT_REASON_MSR_WRITE:
+		exit->type = KVM_CARETAKER_EXIT_MSR;
+		exit->msr.msr = (u32)cvp->common.rcx;
+		exit->msr.is_write = true;
+		break;
+	case EXIT_REASON_RDTSC:
+		exit->type = KVM_CARETAKER_EXIT_RDTSC;
+		break;
+	case EXIT_REASON_EPT_VIOLATION:
+		exit->type = KVM_CARETAKER_EXIT_UNHANDLED;
+		break;
+	case EXIT_REASON_PREEMPTION_TIMER:
+		exit->type = KVM_CARETAKER_EXIT_PREEMPT_TIMER;
+		exit->insn_len = 0;
+		vmx_caretaker_disarm_timer(cvp);
+		break;
+	case EXIT_REASON_EOI_INDUCED:
+	case EXIT_REASON_APIC_WRITE:
+	case EXIT_REASON_APIC_ACCESS:
+	case EXIT_REASON_INTERRUPT_WINDOW:
+		exit->type = KVM_CARETAKER_EXIT_CROSS_VCPU;
+		exit->insn_len = 0;
+		break;
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+	case EXIT_REASON_EXCEPTION_NMI:
+	case EXIT_REASON_INIT_SIGNAL:
+	case EXIT_REASON_SIPI_SIGNAL:
+		exit->type = KVM_CARETAKER_EXIT_PREEMPT_TIMER;
+		exit->insn_len = 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void __cpu_preserved_text
+vmx_caretaker_init_host_vmcs(struct caretaker_vmx_page *cvp)
+{
+	u64 fs_base = 0, gs_base = 0;
+	unsigned long pin, cpu_ctl;
+
+	phys_addr_t host_cr3 = cvp->common.host_cr3;
+
+	/* Configure Host Controls */
+	vmx_vmwrite(HOST_CR0, read_cr0());
+	vmx_vmwrite(HOST_CR4, __read_cr4());
+	if (!host_cr3) {
+		struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+
+		if (sctx && sctx->session_pgd_pa)
+			host_cr3 = sctx->session_pgd_pa;
+		else
+			host_cr3 = x86_caretaker_pgd_pa;
+	}
+	if (host_cr3)
+		vmx_vmwrite(HOST_CR3, host_cr3);
+	vmx_vmwrite(HOST_RSP, (unsigned long)&cvp->common.stack[CXP_STACK_SIZE]);
+	vmx_vmwrite(HOST_RIP, (unsigned long)&vmx_caretaker_exit_handler);
+
+	/* Configure Host Selectors */
+	vmx_vmwrite(HOST_CS_SELECTOR, __KERNEL_CS);
+	vmx_vmwrite(HOST_SS_SELECTOR, __KERNEL_DS);
+	vmx_vmwrite(HOST_DS_SELECTOR, __KERNEL_DS);
+	vmx_vmwrite(HOST_ES_SELECTOR, __KERNEL_DS);
+	vmx_vmwrite(HOST_FS_SELECTOR, 0);
+	vmx_vmwrite(HOST_GS_SELECTOR, 0);
+	vmx_vmwrite(HOST_TR_SELECTOR, GDT_ENTRY_TSS * 8);
+
+	/* Configure Host Bases */
+	fs_base = native_rdmsrq(MSR_FS_BASE);
+	gs_base = native_rdmsrq(MSR_GS_BASE);
+	vmx_vmwrite(HOST_FS_BASE, fs_base);
+	vmx_vmwrite(HOST_GS_BASE, gs_base);
+	vmx_vmwrite(HOST_TR_BASE, (unsigned long)&cvp->common.tss);
+	vmx_vmwrite(HOST_GDTR_BASE, (unsigned long)&cvp->common.gdt[0]);
+	vmx_vmwrite(HOST_IDTR_BASE, (unsigned long)&caretaker_x86_idt[0]);
+
+	/* Configure PIN and CPU execution controls */
+	pin = vmx_vmread(PIN_BASED_VM_EXEC_CONTROL);
+	pin |= (PIN_BASED_EXT_INTR_MASK | PIN_BASED_NMI_EXITING);
+	pin &= ~(PIN_BASED_VMX_PREEMPTION_TIMER | PIN_BASED_POSTED_INTR);
+	vmx_vmwrite(PIN_BASED_VM_EXEC_CONTROL, pin);
+
+	cpu_ctl = vmx_vmread(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_ctl &= ~(CPU_BASED_INTR_WINDOW_EXITING |
+		     CPU_BASED_NMI_WINDOW_EXITING);
+	cpu_ctl |= (CPU_BASED_HLT_EXITING |
+		    CPU_BASED_PAUSE_EXITING |
+		    CPU_BASED_MWAIT_EXITING |
+		    CPU_BASED_MONITOR_EXITING |
+		    CPU_BASED_UNCOND_IO_EXITING);
+
+	if (cvp && cvp->ple_supported &&
+	    (cpu_ctl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
+		unsigned long sec_ctl = vmx_vmread(SECONDARY_VM_EXEC_CONTROL);
+
+		sec_ctl |= SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+		vmx_vmwrite(SECONDARY_VM_EXEC_CONTROL, sec_ctl);
+		vmx_vmwrite(PLE_GAP, 4096);
+		vmx_vmwrite(PLE_WINDOW, 4096);
+	}
+	vmx_vmwrite(CPU_BASED_VM_EXEC_CONTROL, cpu_ctl);
+}
+
diff --git a/arch/x86/kvm/vmx/caretaker_vmenter.S b/arch/x86/kvm/vmx/caretaker_vmenter.S
index ff135cba854d..51781e3e61e2 100644
--- a/arch/x86/kvm/vmx/caretaker_vmenter.S
+++ b/arch/x86/kvm/vmx/caretaker_vmenter.S
@@ -26,8 +26,8 @@ SYM_TYPED_FUNC_START(vmx_caretaker_enter)
 	CARETAKER_PUSH_HOST_REGS
 	movq %rsp, CXP_STACK_ORIG(%rdi)
 
-	/* Switch to private preserved stack */
-	movq CXP_STACK_TOP(%rdi), %rsp
+	/* Switch to private preserved stack at top of caretaker_x86_page */
+	leaq PAGE_SIZE(%rdi), %rsp
 
 	/* Activate VMCS on this pCPU */
 	vmptrld CXP_VMCS_PA(%rdi)
@@ -60,11 +60,10 @@ SYM_TYPED_FUNC_START(vmx_caretaker_enter)
 	vmresume
 	vmlaunch
 
-	/* If both fail, record error and return */
+	/* If both fail, return error in %rax */
 	popq %rdi
 	mov $VMCS_VM_INSTRUCTION_ERROR, %eax
 	vmread %rax, %rax
-	movq %rax, CXP_LAST_EXIT_CODE(%rdi)
 	btsq $31, %rax
 	jmp .Lvmx_ret
 SYM_FUNC_END(vmx_caretaker_enter)
@@ -73,15 +72,14 @@ SYM_FUNC_START(vmx_caretaker_exit_handler)
 	ENDBR
 	/*
 	 * Hardware jumps here on VM-Exit with:
-	 * RSP = HOST_RSP (CXP_STACK_TOP)
+	 * RSP = HOST_RSP (top of 4 KB struct caretaker_x86_page)
 	 * CR3 = HOST_CR3
 	 */
 	pushq %rdi
 
-	/* Recompute CVP pointer from RSP: CVP = (RSP & PAGE_MASK) - CXP_STACK_OFFSET */
+	/* Recover CVP base from RSP: stack lives in the upper half of page 0 */
 	movq %rsp, %rdi
 	andq $PAGE_MASK, %rdi
-	subq $CXP_STACK_OFFSET, %rdi
 
 	/* Save guest GPRs into CVP */
 	CARETAKER_SAVE_GPRS %rdi
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 612ab07d4100..48b6e69f99bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -839,7 +839,7 @@ static void __loaded_vmcs_clear(void *arg)
 	loaded_vmcs->launched = 0;
 }
 
-static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
+void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 {
 	int cpu = loaded_vmcs->cpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index dc8517f15bc4..5cb64ae4c8ee 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -342,6 +342,7 @@ static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 }
 
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
+void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
-- 
2.55.0.1082.g2b9226bbc0-goog



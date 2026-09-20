Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DC5C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37AF36B00D8; Sun, 20 Sep 2026 15:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AAD6B00D9; Sun, 20 Sep 2026 15:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A486B00DA; Sun, 20 Sep 2026 15:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3B416B00D8
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FE2B1A04F1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:27 +0000 (UTC)
X-FDA: 85235157294.06.39CC28E
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA8B31A0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cKtlLqYS;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWkA9vhMZ3eDi8wOrToSquxZz2LpFkjbEEG2BMmzAhs=;
	b=k1muJVBBeYm6WbvRMJrIX7IjXbtSlgYS/0M8LtXmBWrmva9EDlX31oJ7Sz6AvIlYvoCYVm
	IRTT0wz6gQX/ZjhVzgvwUZm4+84868HnrMbgNXj1scVHdMM0lJJHz6NQj73MIZsjae8Lnm
	ngOfFyYGs7X5ZF5hZE0vAAzrdpt2UxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933225;
	b=5dXrZZNvXKOBVU7ZwyA3dNZND5w6X4OQNjBaOzEsGuw43rpyccY97dVNhVJ/YPbajnwTBy
	lC4mgvdL0Rk08fdyJiZYnZX4PAlYps8sIVe8L6Oxx9jfVUcBmECPjqvp/dWJnhvQhgudew
	Qd3mCIz8RREGZol5Ya1S6h4KQQbmQqk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cKtlLqYS;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d4ddd1d91so15245767b3.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933225; x=1790538025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VWkA9vhMZ3eDi8wOrToSquxZz2LpFkjbEEG2BMmzAhs=;
        b=cKtlLqYSO1Kz4S1sLCPBoLf/x/S8LazhbBObtvZsG4iaD993eT32MHF7Z0M8fUlKqV
         tdMzr7/1buEIjAab/ChXbRmQKaUGsdZQIDgNa0Nfh1bJV8Ba6KxMfO/757+4WnoadPve
         lyhMh/U2jlVvfSasN1xxhGiog1Gfkz3A4pSWruVmucEfzTSFZ2JRCxoGQlBZKh4MbedR
         qnAfL+PZUh6ZAvcjd10gRQswFm7kj9Vs5HUr5LEZXBn4r/6oLm0xJMxWraaEp+KfHRsi
         DyoIKxbPK87HRTAa+0vbAEcnvM80EvB3RKI3VW7qCtM5e9HIJWfpqzM5pQyiWXOzA5Gi
         U3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933225; x=1790538025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VWkA9vhMZ3eDi8wOrToSquxZz2LpFkjbEEG2BMmzAhs=;
        b=GhoEH1ak4OIkM/zIZshJq8I+xKCo3k2JyUsZfSm1fF28ZY9egqGqsKuMbrAP8JueFb
         C4uhnmlXi8E0exRgoTYKuTHmTmyPqnFYlkN+WmshHbTeSO5Worj9y55BvXKfBqLSNqsU
         +QxOKhveG6pEHH9IlVMAPGqEUiS8jbGQlG/oKh5bZVZbLo8snaqLaF4hbjeQPsC1vDxK
         z9WWhzfBZG7xAPOhtnxvTdO5ne22WiTpR25M3LzOcMn0K9CldtN/2J4N+z0ddBCzoSH+
         V5AwjCzAlu+WjNkWQ/j+vd9B7Mn+RTU1lybwDvF7LrSZzo4wZj0bInveg63Z3eXwA9h7
         3hsQ==
X-Forwarded-Encrypted: i=1; AKwUvBxEfkeLhfGz/CiEWnGy4HMvKHehwOLLv2JjhPFRtrH2BVMEh36grltFrkIh6ec7SPaq/SeWm4o4yQ==@kvack.org
X-Gm-Message-State: AFuF++lUcH9Km98pefSynI/LYn1PGPy2boG5RifLxEm0H8iWyXXGH47C
	+48xVMKKpVoA8A2LoOk5WiWGl3zWcWQCZDGQqD+SWsawib46eKFZPlCLmOizLMhMEOI=
X-Gm-Gg: AYBFou0uImsRFgQyRdDE5Ibpid/bQhhRwNJEa1UtAdQF3mQP3OKRfIiS54eExGROCob
	LBpk14EmLie854V2lZoF8RxTauPSpJXpxIoSod662FxV60mWSKImJpPJcv9Pst1+7/uuw4eILrr
	ZQOX4NHL9UNTOU9d46pw0DOi+/sZK8V4llX2Pwsr4kbw2gGTl2c6jvxlQ2dId9wvcJQEf+VStKp
	xT4iTwHf1tzXs22yYsVfo2ArDs8TM4uPkRaHEJQTctxy/3UUJYDvEXBSyVh8pOGNq+MT7XEfWBN
	E4+osIxq9Foo9kOGDKDfbu97NIor/m2okPS9MtkK8naSEb1wRf7Kdwajz513p4kUAnMzztlR5X3
	9lfxlthObKGwQbfmpm+uSZKMsQnuCvtjw1a0PmFBfOGznvkww5Rbn4o+YBuw+e3IkYowZZ3ufjs
	NegcwimwlL2qgJu2BA4IEbNuDLHecUUnQZdXEDgsxbbqy2ltyu6kJfrea4tZ2wVFJ3BTZOrKlox
	wqdwp4Ae0U2LhgXvhsbFIxB+X291HQAH2SqDSTMPQzfNoykdnTSH8X3r6zrEN7OK2jLBSwz3+dc
	JrtZ4fCOv2KwSB4c6UU=
X-Received: by 2002:a05:690c:c622:b0:89a:63da:cbeb with SMTP id 00721157ae682-89a63dacd09mr12701467b3.49.1789933224682;
        Sun, 20 Sep 2026 12:40:24 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a46e4f919sm18972057b3.24.2026.09.20.12.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:23 -0700 (PDT)
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
Subject: [RFC PATCH 35/46] KVM: x86: Implement Caretaker VM-exit dispatch and instruction decoders
Date: Sun, 20 Sep 2026 15:36:39 -0400
Message-ID: <20260920193650.3373435-36-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA8B31A0002
X-Stat-Signature: hodymrmde459r75ye6395rne6ut1totq
X-Rspam-User: 
X-HE-Tag: 1789933225-334175
X-HE-Meta: U2FsdGVkX1+P2i5LcH4hncqWn4CvEPKfVZuDQEZljkt2laSscIG8OwrKrXzSTYlClxQIi6uRo9SYkq1T4e/TPZhPYXxatQIlGJpB/wlHuCwRcXDlqkCeYNvOSpNXmonx8nOXgzsHaRK+/oy34xgjTXy5YMi4Cb5YvOBXqy5KIQGR+0mUzLHVNKYXwmOLJ539jMSp4KQdF0eLJH0YC0FIFLOC/qlYPrQFlrQh477rtZWsglpATul8yjf2yIopM0bywE0vGP/ZAD3jrIO6srUZv6pjvmzBZkNzmpw6y1wD4M+rm2Y6RuagvDvHD5SC7eP0K+KPPPXQ2Fp6tnYyCzWK4suB7vNaB6T6cVnLH+BHgTURrssIfTwbZIJOMj+54Y3B3rjF6L18wY2yIjZ1RAzvT34UTstSIKGisHSbeSrrRkKLNhCEwDFY7hCQt4vMN0RLP9PvruFL3QnwtA+onDp6UN6TUq1JtSDr8fcSeZqbn63aRNFvuBsBuWrIqwpwwvLwQaH0Yl0ngRv43ihoj+tA4q7IeFdj/atD7qFubSv+i6h37too7b2tLqplV+nEGC0yA/40tekqeyuD1vW3laNiUQFmxmlUR6hGn11zBVrSYy/mhkVoSltcn0yFYLP0lDjByxdnjTN3xLYY5XqU6zvUVknirdH5KFbQVnEBYiPMid69FcnAsfWNqMyyZYBg1U2pSqrqYrIYWtDXrZ1YK7aiRooxGGDqYh0mqMX23GQG2ljkiznZdIzfgX3B2MGds3iakyM8o5YPic4BhRqDfxsaYtpLh8hsbGe47uxSWg5WombLCGr0dS5JNAMX/lIb0javq2/GFH/FyP3MLOg+2onCbNJhCmr3Gw9TPuGeTL3vT8San/djNInTJ28sVvzpT1FgF1sXgNUNIoXm9ND1+qo1cPTG1S2pcmMC/mNQu0Rsvd5KsrzCfh6+ofyG8XV04u6mG9a24sb3D6kHAi/RDFq
 yuFtPW9D
 0jIRDr4uR/Plj704/shEFnTKmcHE+JtX0hrDsd2g4Wte4xlQvnn0Tlz2ZzgBi079bWjlaJGath12fiQy1NWMvEq6Kl0pEKULuN3nZENEJUWIuAkwbuJpc/4eMHUUffYhdMTt+zbSV1FzWmsaxm36Cj1rAGghyYhA22KiH3w08LV/LdMWTqZavVlxTzzCK3usNOwzkDHIdw5aRKHuc1m1N2ZeAd0iiSVQZmTpsjcdS1njJrZFKqs9WlGIPFYF5B2BiavU5666F3dEUikSFNOsU38Q1EbxWqDD//8nnryewaorAub+ug2OO6WgpbskYaOjqT6l9jYhaxG0SxC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement standalone Caretaker VM-exit decoding, MSR/CPUID handling,
and I/O port emulation in arch/x86/kvm/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/caretaker.c | 593 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 593 insertions(+)

diff --git a/arch/x86/kvm/caretaker.c b/arch/x86/kvm/caretaker.c
index 9e0f20cbb137..dd2b2d582b69 100644
--- a/arch/x86/kvm/caretaker.c
+++ b/arch/x86/kvm/caretaker.c
@@ -260,6 +260,599 @@ static void kvm_x86_caretaker_init_gdt_tss(struct desc_struct *gdt,
 	caretaker_set_tss_desc(gdt, (unsigned long)tss, sizeof(struct x86_hw_tss) - 1);
 }
 
+static void __cpu_preserved_text
+kvm_x86_caretaker_load_desc(struct desc_struct *gdt, size_t gdt_size,
+			    gate_desc *idt, size_t idt_size,
+			    void *tss)
+{
+	struct desc_ptr gdt_desc = {
+		.size = gdt_size - 1,
+		.address = (unsigned long)gdt,
+	};
+	struct desc_ptr idt_desc = {
+		.size = idt_size - 1,
+		.address = (unsigned long)idt,
+	};
+
+	caretaker_set_tss_desc(gdt, (unsigned long)tss, sizeof(struct x86_hw_tss) - 1);
+	load_gdt(&gdt_desc);
+	native_load_idt(&idt_desc);
+	asm volatile("ltr %w0" : : "q" ((u16)(GDT_ENTRY_TSS * 8)));
+}
+
+static __caretaker_text void
+kvm_x86_caretaker_save_host_state(struct caretaker_x86_host_state *host,
+				  struct caretaker_x86_page *cxp)
+{
+	struct cpu_preserved_stack_context *sctx;
+	u64 apic_base;
+
+	store_idt(&host->orig_idt);
+	host->orig_cr2 = native_read_cr2();
+	/*
+	 * MSR_FS_BASE is in the guest-writable passthrough set below, so it
+	 * has to be saved here or a guest WRMSR to it survives the run and
+	 * corrupts the host's FS base.
+	 */
+	host->orig_fs_base = native_rdmsrq(MSR_FS_BASE);
+	host->orig_gs_base = native_rdmsrq(MSR_GS_BASE);
+	host->orig_kernel_gs_base = native_rdmsrq(MSR_KERNEL_GS_BASE);
+	host->orig_star = native_rdmsrq(MSR_STAR);
+	host->orig_lstar = native_rdmsrq(MSR_LSTAR);
+	host->orig_fmask = native_rdmsrq(MSR_SYSCALL_MASK);
+
+	/* Ensure Local APIC is software enabled */
+	apic_base = native_rdmsrq(MSR_IA32_APICBASE);
+	if (!(apic_base & MSR_IA32_APICBASE_ENABLE))
+		native_wrmsrq(MSR_IA32_APICBASE,
+			      apic_base | MSR_IA32_APICBASE_ENABLE);
+
+	/* Switch to self-contained Caretaker GDT, IDT, and TSS before CR3 switch */
+	kvm_x86_caretaker_load_desc(cxp->gdt, sizeof(cxp->gdt),
+				    caretaker_x86_idt, sizeof(caretaker_x86_idt),
+				    &cxp->tss);
+
+	/* Switch to preserved CR3 if specified */
+	sctx = cpu_preserved_get_stack_context();
+	if (sctx && sctx->session_pgd_pa)
+		cxp->host_cr3 = sctx->session_pgd_pa;
+	else if (!cxp->host_cr3 && x86_caretaker_pgd_pa)
+		cxp->host_cr3 = x86_caretaker_pgd_pa;
+	if (cxp->host_cr3 && __read_cr3() != cxp->host_cr3)
+		write_cr3(cxp->host_cr3);
+
+	raw_local_irq_disable();
+}
+
+static __caretaker_text void
+kvm_x86_caretaker_restore_host_state(const struct caretaker_x86_host_state *host,
+				     int pcpu)
+{
+	/*
+	 * Restore unconditionally.  These are all in the guest-writable
+	 * passthrough set, so skipping the write when the saved value happens
+	 * to be zero leaves the *guest's* value live in the host MSR.
+	 */
+	native_write_cr2(host->orig_cr2);
+	native_wrmsrq(MSR_FS_BASE, host->orig_fs_base);
+	native_wrmsrq(MSR_GS_BASE, host->orig_gs_base);
+	native_wrmsrq(MSR_KERNEL_GS_BASE, host->orig_kernel_gs_base);
+	native_wrmsrq(MSR_LSTAR, host->orig_lstar);
+	native_wrmsrq(MSR_STAR, host->orig_star);
+	native_wrmsrq(MSR_SYSCALL_MASK, host->orig_fmask);
+
+	if (cpu_is_preserved(pcpu))
+		arch_cpu_preserved_load_desc();
+	else if (host->orig_idt.size)
+		native_load_idt(&host->orig_idt);
+}
+
+__caretaker_text void
+kvm_x86_caretaker_update_msr(struct kvm_vcpu_arch_ser *state,
+			     u32 msr, u64 val)
+{
+	u32 i;
+
+	if (!state)
+		return;
+
+	for (i = 0; i < state->num_msrs; i++) {
+		if (state->msrs[i].index == msr) {
+			state->msrs[i].data = val;
+			return;
+		}
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_update_msr);
+
+static __caretaker_text bool
+kvm_x86_caretaker_read_msr(const struct kvm_vcpu_arch_ser *state,
+			   u32 msr, u64 *val)
+{
+	u32 i;
+
+	if (!state)
+		return false;
+
+	for (i = 0; i < state->num_msrs; i++) {
+		if (state->msrs[i].index == msr) {
+			*val = state->msrs[i].data;
+			return true;
+		}
+	}
+	return false;
+}
+
+/*
+ * Capture the guest FPU registers into the LUO ABI buffer.
+ *
+ * The Caretaker runs the guest with the guest's FPU state live in hardware,
+ * restoring it via XRSTOR64 at the start of each quantum and saving it via
+ * XSAVE64 at the end of each quantum and upon detach.
+ *
+ * XSAVE -- as opposed to XSAVES -- writes the standard, non-compacted layout,
+ * which is bit-for-bit the uAPI struct kvm_xsave layout that the incoming
+ * kernel feeds to fpu_copy_uabi_to_guest_fpstate().  No format conversion is
+ * needed and the ABI stays uAPI.
+ *
+ * The requested-feature bitmap comes from the XCR0 recorded at preserve time
+ * rather than from XGETBV, because XGETBV requires CR4.OSXSAVE and the guest
+ * is free to clear it.  The recorded value cannot have gone stale: the
+ * Caretaker never emulates XSETBV, so the guest cannot change XCR0 while it
+ * runs here.
+ *
+ * The destination cannot overflow: kvm_arch_vcpu_luo_preserve() refuses the
+ * preserve when guest_fpu.uabi_size exceeds sizeof(struct kvm_xsave), and
+ * RFBM is a subset of guest_supported_xcr0, which is what uabi_size sizes.
+ */
+__caretaker_text static void
+caretaker_save_guest_fpu(struct caretaker_x86_page *cxp,
+			 struct kvm_vcpu_arch_ser *state)
+{
+	union fpregs_state *xstate = (union fpregs_state *)state->xsave.region;
+	u64 rfbm = state->xcrs.xcrs[0].value | XFEATURE_MASK_FPSSE;
+
+	if (!cxp->save_guest_fpu)
+		return;
+
+	if (native_read_cr0() & X86_CR0_TS)
+		asm volatile("clts" : : : "memory");
+
+	/*
+	 * XSAVE leaves XSTATE_BV bits for components outside RFBM untouched,
+	 * so the preserve-time header would survive and advertise stale
+	 * component data.  Clear it and let XSAVE set only what it writes.
+	 */
+	cpu_preserved_memset(&xstate->xsave.header, 0,
+			     sizeof(xstate->xsave.header));
+
+	asm volatile("1: xsave64 %[buf]\n\t"
+		     "2:\n\t"
+		     _ASM_EXTABLE(1b, 2b)
+		     : [buf] "+m" (*xstate)
+		     : "a" ((u32)rfbm), "d" ((u32)(rfbm >> 32))
+		     : "memory");
+}
+
+__caretaker_text void
+kvm_x86_caretaker_detach_serialize_common(struct caretaker_x86_page *cxp,
+					  struct kvm_vcpu_arch_ser *state)
+{
+	if (!cxp || !state)
+		return;
+
+	state->regs.rax = cxp->rax;
+	state->regs.rbx = cxp->rbx;
+	state->regs.rcx = cxp->rcx;
+	state->regs.rdx = cxp->rdx;
+	state->regs.rsi = cxp->rsi;
+	state->regs.rdi = cxp->rdi;
+	state->regs.rbp = cxp->rbp;
+	state->regs.r8  = cxp->r8;
+	state->regs.r9  = cxp->r9;
+	state->regs.r10 = cxp->r10;
+	state->regs.r11 = cxp->r11;
+	state->regs.r12 = cxp->r12;
+	state->regs.r13 = cxp->r13;
+	state->regs.r14 = cxp->r14;
+	state->regs.r15 = cxp->r15;
+
+	if (cxp->last_exit_rip)
+		state->regs.rip = cxp->last_exit_rip;
+	if (cxp->last_exit_rsp)
+		state->regs.rsp = cxp->last_exit_rsp;
+	if (cxp->last_exit_rflags)
+		state->regs.rflags = cxp->last_exit_rflags;
+
+	if (cxp->cr0)
+		state->sregs.cr0 = cxp->cr0;
+	if (cxp->cr3)
+		state->sregs.cr3 = cxp->cr3;
+	if (cxp->cr4)
+		state->sregs.cr4 = cxp->cr4;
+	if (cxp->efer)
+		state->sregs.efer = cxp->efer;
+
+	state->events.exception.injected = 0;
+	state->events.interrupt.injected = 0;
+
+	caretaker_save_guest_fpu(cxp, state);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_detach_serialize_common);
+
+void kvm_x86_caretaker_sync_vcpu_common(struct kvm_vcpu *vcpu)
+{
+	kvm_register_mark_dirty(vcpu, VCPU_REG_CR3);
+	kvm_clear_interrupt_queue(vcpu);
+	kvm_clear_exception_queue(vcpu);
+
+	vcpu->cpu = -1;
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_sync_vcpu_common);
+
+static __caretaker_text void kvm_caretaker_emulate_cpuid(u64 *rax,
+							 u64 *rbx,
+							 u64 *rcx,
+							 u64 *rdx)
+{
+	unsigned int a = (unsigned int)*rax;
+	unsigned int b = (unsigned int)*rbx;
+	unsigned int c = (unsigned int)*rcx;
+	unsigned int d = (unsigned int)*rdx;
+
+	asm volatile("cpuid"
+		     : "=a" (a), "=b" (b), "=c" (c), "=d" (d)
+		     : "0" (a), "2" (c));
+
+	*rax = a;
+	*rbx = b;
+	*rcx = c;
+	*rdx = d;
+}
+
+static __caretaker_text bool kvm_caretaker_emulate_msr(struct caretaker_x86_page *cxp,
+						       u32 msr, bool write,
+						       u64 *rax,
+						       u64 *rdx)
+{
+	bool x2apic = msr >= APIC_BASE_MSR &&
+		      msr < APIC_BASE_MSR + X2APIC_MSR_COUNT;
+	u32 apic_id = cxp ? cxp->abi.cb.vcpu_id : 0;
+	u64 val;
+
+	if (write) {
+		val = (u32)(*rax) | ((*rdx) << 32);
+
+		/*
+		 * Guest x2APIC writes are not emulated.  ICR would send an
+		 * IPI, TMICT would arm the APIC timer, and the LVT and TPR
+		 * registers reprogram delivery.  The caretaker implements
+		 * none of that, so absorbing the write promises the guest an
+		 * interrupt that will never arrive -- it wedges rather than
+		 * stalls, and it cannot tell the difference.
+		 *
+		 * Park instead, and let the incoming kernel's full KVM apply
+		 * the write to the emulated LAPIC when it reclaims the vCPU.
+		 *
+		 * Exception: APIC_EOI (0x80b).  If a vCPU was caught inside an
+		 * interrupt handler when detached, acknowledging EOI lets it
+		 * finish the ISR and IRETQ back to user space; kvm_luo clears
+		 * APIC_ISR on retrieve anyway.
+		 */
+		if (x2apic) {
+			if (msr == APIC_BASE_MSR + (APIC_EOI >> 4))
+				return true;
+			return false;
+		}
+
+		switch (msr) {
+		case MSR_IA32_SPEC_CTRL:
+		case MSR_IA32_PRED_CMD:
+			/*
+			 * The guest is arming a speculation mitigation
+			 * (IBRS/STIBP/SSBD, or an IBPB barrier).  The
+			 * caretaker does not apply these, so acknowledging
+			 * the write would leave the guest believing it is
+			 * protected when it is not -- a security downgrade
+			 * the guest cannot observe.
+			 *
+			 * Refuse the exit instead: the vCPU parks here and
+			 * the incoming kernel's KVM applies the write for
+			 * real when it reclaims the vCPU.
+			 */
+			return false;
+		case MSR_IA32_TSC_DEADLINE:
+			/*
+			 * Record the guest's next timer deadline in preserved
+			 * arch_state so full KVM restores and arms it upon
+			 * reclaiming the vCPU, while allowing a guest caught
+			 * in its timer ISR to return to user space.
+			 */
+			if (cxp && cxp->arch_state)
+				kvm_x86_caretaker_update_msr(cxp->arch_state,
+							     MSR_IA32_TSC_DEADLINE,
+							     val);
+			return true;
+		case MSR_IA32_TSC:
+		case MSR_IA32_TSC_ADJUST:
+			/*
+			 * Discarding these silently rewrites the guest's view of
+			 * time.
+			 */
+			return false;
+		case MSR_KERNEL_GS_BASE:
+			/* Also cached, so the read side can answer without an rdmsr. */
+			if (cxp)
+				cxp->kernel_gs_base = val;
+			fallthrough;
+		case MSR_FS_BASE:
+		case MSR_GS_BASE:
+		case MSR_LSTAR:
+		case MSR_STAR:
+		case MSR_SYSCALL_MASK:
+			native_wrmsrq(msr, val);
+			return true;
+		case MSR_IA32_APICBASE:
+			/*
+			 * This used to be passed through to native_wrmsrq(),
+			 * which let the guest relocate or disable the *physical*
+			 * APIC of the CPU the caretaker is running on.  Nothing
+			 * saved or restored it around the run, so the damage
+			 * outlived the guest: on the "staying in this kernel"
+			 * path there is no INIT-SIPI-SIPI to clean up after.
+			 *
+			 * APIC base is host state here.  Refuse the write.
+			 */
+			return false;
+		}
+		return false;
+	}
+
+	if (x2apic) {
+		switch ((msr - APIC_BASE_MSR) << 4) {
+		case APIC_ID:
+			val = apic_id;
+			break;
+		case APIC_LVR:
+			val = CARETAKER_APIC_LVR;
+			break;
+		case APIC_SPIV:
+			val = APIC_SPIV_APIC_ENABLED | APIC_VECTOR_MASK;
+			break;
+		case APIC_LDR:
+			val = ((apic_id >> 4) << 16) | (1U << (apic_id & 0xf));
+			break;
+		default:
+			/*
+			 * ICR, IRR, ISR, TMCCT and friends.  Zero reads as
+			 * "nothing pending" or "timer already expired", which
+			 * the guest cannot distinguish from the truth.  The four
+			 * cases above are answered because they are static
+			 * identity registers whose values really are known.
+			 */
+			return false;
+		}
+		goto out;
+	}
+
+	switch (msr) {
+	case MSR_IA32_SPEC_CTRL:
+		/*
+		 * Returning 0 here would tell the guest its speculation
+		 * mitigations are disabled, which is both wrong and
+		 * unobservable.  Park instead; see the write path above.
+		 */
+		return false;
+	case MSR_IA32_TSC:
+		val = rdtsc();
+		break;
+	case MSR_IA32_TSC_DEADLINE:
+		if (cxp && kvm_x86_caretaker_read_msr(cxp->arch_state,
+						      MSR_IA32_TSC_DEADLINE,
+						      &val))
+			break;
+		return false;
+	case MSR_IA32_TSC_ADJUST:
+		return false;
+	case MSR_KERNEL_GS_BASE:
+		if (cxp && cxp->kernel_gs_base)
+			val = cxp->kernel_gs_base;
+		else
+			val = native_rdmsrq(MSR_KERNEL_GS_BASE);
+		break;
+	case MSR_IA32_APICBASE:
+		val = native_rdmsrq(MSR_IA32_APICBASE);
+		if (!val)
+			val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
+		if (cxp && apic_id == 0)
+			val |= MSR_IA32_APICBASE_BSP;
+		else
+			val &= ~MSR_IA32_APICBASE_BSP;
+		break;
+	case MSR_FS_BASE:
+	case MSR_GS_BASE:
+	case MSR_LSTAR:
+	case MSR_STAR:
+	case MSR_SYSCALL_MASK:
+		val = native_rdmsrq(msr);
+		break;
+	default:
+		return false;
+	}
+
+out:
+	*rax = (u32)val;
+	*rdx = (u32)(val >> 32);
+	return true;
+}
+
+static bool __cpu_preserved_text
+kvm_x86_caretaker_emulate_uart8250(struct caretaker_uart *uart,
+				   u16 port, int in, int size,
+				   unsigned long *rax)
+{
+	u8 offset;
+
+	if (port < COM1_PORT_BASE || port > COM1_PORT_END)
+		return false;
+
+	offset = port - COM1_PORT_BASE;
+
+	if (in) {
+		unsigned long val = 0;
+
+		switch (offset) {
+		case UART_RX:
+			val = (uart && (uart->lcr & UART_LCR_DLAB)) ? uart->dll : 0;
+			break;
+		case UART_IER:
+			val = (uart && (uart->lcr & UART_LCR_DLAB)) ? uart->dlm :
+				(uart ? uart->ier : 0);
+			break;
+		case UART_IIR:
+			val = UART_IIR_NO_INT;
+			break;
+		case UART_LCR:
+			val = uart ? uart->lcr : UART_LCR_WLEN8;
+			break;
+		case UART_MCR:
+			val = uart ? uart->mcr : (UART_MCR_DTR | UART_MCR_RTS);
+			break;
+		case UART_LSR:
+			val = UART_LSR_TEMT | UART_LSR_THRE;
+			break;
+		case UART_MSR:
+			val = UART_MSR_DCD | UART_MSR_DSR | UART_MSR_CTS;
+			break;
+		case UART_SCR:
+			val = uart ? uart->scr : 0;
+			break;
+		}
+
+		if (size < (int)sizeof(unsigned long)) {
+			unsigned long mask = (1UL << (size * 8)) - 1;
+			*rax = (*rax & ~mask) | (val & mask);
+		} else {
+			*rax = val;
+		}
+	} else {
+		u8 out_val = (u8)*rax;
+
+		if (uart) {
+			switch (offset) {
+			case UART_TX:
+				if (uart->lcr & UART_LCR_DLAB)
+					uart->dll = out_val;
+				break;
+			case UART_IER:
+				if (uart->lcr & UART_LCR_DLAB)
+					uart->dlm = out_val;
+				else
+					uart->ier = out_val;
+				break;
+			case UART_LCR:
+				uart->lcr = out_val;
+				break;
+			case UART_MCR:
+				uart->mcr = out_val;
+				break;
+			case UART_SCR:
+				uart->scr = out_val;
+				break;
+			}
+		}
+	}
+
+	return true;
+}
+STACK_FRAME_NON_STANDARD(kvm_x86_caretaker_emulate_uart8250);
+
+__caretaker_text bool
+kvm_x86_caretaker_handle_exit(void *data, struct kvm_caretaker_exit *exit)
+{
+	struct caretaker_x86_page *cxp = data;
+	bool handled = false;
+
+	if (exit->type == KVM_CARETAKER_EXIT_CROSS_VCPU) {
+		/*
+		 * x86 has no cross-vCPU emulation.  The decoders route
+		 * VMCALL, APIC_ACCESS, APIC_WRITE, EOI_INDUCED and
+		 * INTERRUPT_WINDOW here, and every one of them has a
+		 * guest-visible effect the Caretaker cannot produce: a
+		 * hypercall it cannot service, an APIC register write it
+		 * cannot apply, an EOI it cannot retire, an IPI it cannot
+		 * deliver to a vCPU parked on another core.
+		 *
+		 * Returning true absorbed all of it.  Worse, nothing
+		 * advanced RIP afterwards, so VMCALL re-executed forever.
+		 *
+		 * Stall instead.  The vCPU parks on the instruction and the
+		 * incoming kernel's full KVM emulates it properly.  arm64
+		 * does handle its CROSS_VCPU case (SGI delivery) and keeps
+		 * returning true.
+		 */
+		return false;
+	}
+
+	switch ((int)exit->type) {
+	case KVM_CARETAKER_EXIT_CONSOLE: {
+		unsigned long *target = exit->mmio_io.val_ptr ?
+					(unsigned long *)exit->mmio_io.val_ptr :
+					(unsigned long *)&exit->mmio_io.val;
+
+		handled = kvm_x86_caretaker_emulate_uart8250(&cxp->uart,
+							     (u16)exit->mmio_io.addr,
+							     !exit->mmio_io.is_write,
+							     exit->mmio_io.size,
+							     target);
+		break;
+	}
+	case KVM_CARETAKER_EXIT_CPUID:
+		kvm_caretaker_emulate_cpuid(&cxp->rax, &cxp->rbx, &cxp->rcx, &cxp->rdx);
+		handled = true;
+		break;
+	case KVM_CARETAKER_EXIT_MSR:
+		handled = kvm_caretaker_emulate_msr(cxp, exit->msr.msr, exit->msr.is_write,
+						    &cxp->rax, &cxp->rdx);
+		break;
+	case KVM_CARETAKER_EXIT_RDTSC: {
+		u64 tsc = rdtsc();
+
+		cxp->rax = (u32)tsc;
+		cxp->rdx = (u32)(tsc >> 32);
+		handled = true;
+		break;
+	}
+	case KVM_CARETAKER_EXIT_INSN_STEP:
+		handled = true;
+		break;
+	case KVM_CARETAKER_EXIT_ARCH:
+	default:
+		/*
+		 * Nothing above recognised this exit, so nothing emulated it.
+		 * Advancing RIP here would step over an instruction whose
+		 * architectural effect never happened (MOV to CRn, XSETBV,
+		 * INVLPG, WBINVD, RDPMC, ...), leaving the guest running on
+		 * silently wrong state with no way to detect it.
+		 *
+		 * Report the exit as unhandled instead.  The caretaker run
+		 * loop stops re-entering the guest and the vCPU stays parked
+		 * on this instruction until the incoming kernel reclaims it
+		 * and full KVM emulates the exit properly.
+		 */
+		return false;
+	}
+
+	if (handled)
+		exit->rip += exit->insn_len;
+
+	return handled;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_handle_exit);
+
 __caretaker_text void kvm_x86_caretaker_arm_timer(u64 deadline_ticks)
 {
 	if (!deadline_ticks)
-- 
2.55.0.1082.g2b9226bbc0-goog



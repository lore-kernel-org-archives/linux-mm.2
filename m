Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA97C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122406B0088; Mon, 21 Sep 2026 17:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4696B008A; Mon, 21 Sep 2026 17:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD836B008C; Mon, 21 Sep 2026 17:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE4EE6B0088
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:00:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CAD0C02CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:42 +0000 (UTC)
X-FDA: 85238988324.29.477A2FC
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 931FC140017
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WN9ZwG/i";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790024440;
	b=lvDK7tKY2lSF4813ugbFeCa6Lds+WoWM29zTDa3fUcqi3lbj5HJ5zQSsb5qSZzFycU36b3
	M0pVsVGaTV269pPzBkF4i35uQe7jerJuM1AwKK+Fg1spPZdu3+Os60zeIKWBQtagaLpSEu
	zINw7Rh1uwaf4V8MJS5kex3AkDQ91ss=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WN9ZwG/i";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790024440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5hDLFKTi0Cs1ZiX/XYeG+c49YMslw+nL6Py3nD0h7s=;
	b=5pBqIyUp9KdhPhPujwq9bQL+c71aKp1emLBpdU+5f51empiC8mGDcY/XqM5Cgaiotp5zlI
	FdfAtaaBIkrtTd8CTNwdJ6UUK966EXaviY2T1s79C2bk5ze85zC2PjQndDxyRyno70WXec
	0tBU/GDIsvesyx0A3Aau1R1siIN5+zk=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43f9b120so32888167b3.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024439; x=1790629239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=k5hDLFKTi0Cs1ZiX/XYeG+c49YMslw+nL6Py3nD0h7s=;
        b=WN9ZwG/ih/Sbwsk7muwaE0ruqxp9bqVRHx8rxIL6fg4/lTUrlFk12qdt1B9fy7UYQq
         ndJtAAbPCjDzkhdQCoyEN43juq2qIhUAvZSniPDp6N/+W0NDOR5nLG96iHtnVr2nx894
         O2ZvgHWdeXJ6yfu/00FtDqp2K+7RpsveXwec+FDIPBMh7nMXNsKaHMOodfgkBTK5dksI
         OJ2QJeedzgBYNuBSdkKq1ZZwFmkioH5kSjqNtGBj/BkbyBKs8j2hPdnWYcSXonYnTFro
         9Ls+0kWJbUQBTQLe6GBD0hTjPypQLVV4OMJmlI7bJLrOD+NcTNSXk0onQiOTspOJM/ZD
         gudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024439; x=1790629239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k5hDLFKTi0Cs1ZiX/XYeG+c49YMslw+nL6Py3nD0h7s=;
        b=E4IuQ8IrPNPeSJimrOfAZ/wwQsmcOIQHXaqz1Ne6Yw79pXv+CAtZDH/s0Lgr6BE+9z
         65OUIA293ys2InNRwobu5y+ulygGvgYdcBwaK8bVX+k0AMByGWw26aH0K4k4+BNWJuv+
         uipGwseSbOv/2arxsPU2P2OwgepNmAusdIenFhgxvq0lfTJiHR7QaGrheZGJ+D8plBKT
         kKeA6SPVvBfns4aoBgYa0pFd+TLMAZBSAIlwDl38zLwrBhc+ekrxNtgBHKVr+tApXGbO
         2LqTIoiCx416/N1U8mhA4cXY/Ypdlb4d/rNRF/vUsUnNp5qXIjvNEbI8t3w9gLpvd2VJ
         MpdA==
X-Forwarded-Encrypted: i=1; AKwUvBy/5EHIvhKa67ibR/SZzhFIlz80NNTJ3I2+nIZW6Ccll2Slggw2CV7InDpXjh5r0/g+jxKfzLWzJg==@kvack.org
X-Gm-Message-State: AFuF++nKeWmVZHheIb4+ErOte+NLnz4frAIa0CKNv6ga6ZChGYVigAZr
	cHicuqpaZAChQAafJgISAw0cZAY98CWnuJPYxpOtkPofGoS6OwoRRmz+74Y686FMnMg=
X-Gm-Gg: AYBFou38rBIGLIf551Kr4Bu3lqsa1i1EvYjWCI6hRlFUXNfbdCqEQwyV+cl1NlhAmsh
	BH1wfxM8BeYMK+gFvWaIqW4f440Jg5ptLa5mokQL6BldPq3d/iWaKI7jMJCicJtcwvh24x136e7
	kzm1JCtKB64z3m0F5+xvmU3Uwl70w52aYfvUfxhix81rBdDmpX+H/NVAH3XJ74L0ZpswHdBfut5
	ptZ+QO0G0mMX9cM3/XX1ZGxOSdtWlTicP/EmukCjHuMu7+1cq+SaSMOKiSIjQhbFfyQ9LOsbFkc
	fnFfEyPeZMAuX+ivqwRnN/R7IJz2LHrDtBZ7cL4EJy9/cHQbfy453oh0BZtj84ZFrloUBy1DPf9
	Gw8GI1ol6nv/0UMsFRU2G3cn3tiFx/rw3aiiudnqsbnavxw13F9EdmzwccT4FeQ9XNuJ/LqnNLJ
	5e+Er8Ra3aiA1NfpXxoMG8J6Kqv/Mhv8qPLiD/q8Zrf1ilumUGlC/cIdqBa+ACYJVA4ZG+zALTn
	wOeYO9+GhMTvssunz7GZlFs+Vk5OH3yuTknhEUbbqYuW0QNcNrWGswbkRnFhBsbPLwQju9w/o0i
	0lSeKu8swiYhOXINWEg=
X-Received: by 2002:a05:690c:f09:b0:873:5ddf:d869 with SMTP id 00721157ae682-8973579a302mr37560587b3.52.1790024439501;
        Mon, 21 Sep 2026 14:00:39 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:39 -0700 (PDT)
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
Subject: [RFC PATCH 39/46] KVM: VMX: Integrate Caretaker VMX detach serialization and KVM registration
Date: Mon, 21 Sep 2026 17:00:27 -0400
Message-ID: <20260921210034.180424-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 931FC140017
X-Stat-Signature: wrc4qta3n6xkbda6q4jtwcskj1pt7sqp
X-HE-Tag: 1790024440-311334
X-HE-Meta: U2FsdGVkX18MGcjWsGYTNphJ66rtP8hjE1GXGtRA7KTVFiMcd39rqvVdpwBsg90px8qAgk3QK4/RJhy6DDgftT0NZ0gGiBlEzi7jmX6ewjRSBFOHrcmPkWeyJo6pO+uUu10otl6uAutBZ34RzfJWSytiaWT/p/pKBTzsVaKcNh5DgJGAuwNlmQLoK7DxwRY06sEQckMwQ+Wla9W9oLezBPLlbhYj+BkvnPI5GdQLP/pwwLagbcIIVk+us6F/i+bikRNhFMDh4GKDzgTPHI5uZsGbBTMVoGhAwdpg5TdmFH/DjAyRqm18IeqiGe/NpQEL9IM6yqggvVcte7unE76gc/OSNXZvCFz/tGs58wnfsV0FAx933En1m5HQmMZ6t7P5MlmLNkhyAKn+1p5KPN2uhyFXGjfI4px7ikiloWi5AiC/SVJsL+/0MAV68PicsTHND9AEeLF+3PZzCX+RN0WX5i0Q5usUfWs33FHOEBAcIuVXqWXeDlPNDH0unomPNcWOyVbCF48HyfAefJS2usNmsTpXoAxlyEBKe7FmruiI0AUxhZCxC8XHgICfwG0HTJWUljm77rRCuBUECZcF88cDA+gZlK98ddfItloA5FKqodExxpKM/SpmaItQ7LH7+ziuYSbAu80TaggEh2LDpwhkiZdfRc+Ht2NDUinyU8uQuZZ7jNP8YhD0N5fmWqy9jtbcruNYzG0sexsigZI0CQd6cssba7Y6CtqYNGS9+QqLPuIf/Jish+bzK8o0xrWC6eM+xdQ7o+PsTubAOLFeG2o3oTMWFn3CuS+FmnT49CR7hZ7lO4TAlXIWablOGasfjNsGagJi7fXg4Iu2uAz1rKmp20KWOfqWCyW7JWbwOanp2Fa2ucRfM7Kg67nVz81PtzdLM6iEDCxn7l1MtTmYIr+ajCPVuD3ezgkZD5UHF+6tI7jNIjbSg098fB8EhkcqF9vUMrKnOEMtx326EtE4KJl
 tt3mQGJh
 UtFOY6COwfk2vyiyjullcs+f0h/fblu8AchMcA5NfSwfn31LrrXQsIhGiFFcxxvQpZs4OEbGIkOFwevxAYTBAuxNVL7zFBogqUZJdxDg8RZp2RTB1XwLU8uRwmvpR7WQB6NrDYXdR8iKZjkb1eozhtXjTqvuya+E/DoHRaEoQyaNhmpihfybImcnQwGWn4QCpYZcvN3smPzI/WsNAkYgq1ETYrijqfay7vxAc5xvHrSxTGZ5bBBzfgvz5i222uHbcxUNTPeQuA5epd2VIFNfZ6CFgkRUpAMGG6poqp7zI1c7SqTvlVD36DFvKXn9CJwmEHmY+7v2xMvPU87k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Complete Intel VMX Caretaker detach-time serialization, vCPU sync,
and ops registration in arch/x86/kvm/vmx/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/Makefile        |   9 +
 arch/x86/kvm/vmx/caretaker.c | 322 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c       |   4 +
 3 files changed, 333 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 11e67c072258..b550a3fd0708 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -18,6 +18,8 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/nested.o vmx/posted_intr.o vmx/main.o
+kvm-intel-$(CONFIG_KVM_CARETAKER) += vmx/caretaker.o vmx/caretaker_vmenter.o
+
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
@@ -44,6 +46,13 @@ $(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
 AFLAGS_vmx/vmenter.o    := -iquote $(obj)
 $(obj)/vmx/vmenter.o: $(obj)/kvm-asm-offsets.h
 
+AFLAGS_vmx/caretaker_vmenter.o := -iquote $(obj)
+$(obj)/vmx/caretaker_vmenter.o: $(obj)/kvm-asm-offsets.h
+
+CFLAGS_REMOVE_vmx/caretaker.o = $(CC_FLAGS_FTRACE)
+CFLAGS_vmx/caretaker.o := -fno-stack-protector
+
+
 $(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
 	$(call filechk,offsets,__KVM_ASM_OFFSETS_H__)
 
diff --git a/arch/x86/kvm/vmx/caretaker.c b/arch/x86/kvm/vmx/caretaker.c
index 47b4743650e5..efef1c30c0d1 100644
--- a/arch/x86/kvm/vmx/caretaker.c
+++ b/arch/x86/kvm/vmx/caretaker.c
@@ -49,8 +49,8 @@ static int vmx_caretaker_init_page(struct caretaker_vmx_page *cvp,
 	u64 basic_msr, misc_msr;
 	int ret;
 
-	if (!vmx->vmcs01.vmcs)
-		return -EINVAL;
+	if (!vmx->vmcs01.vmcs || is_guest_mode(vcpu))
+		return -EOPNOTSUPP;
 
 	ret = kvm_x86_caretaker_init_common_page(&cvp->common, vcpu, sizeof(*cvp));
 	if (ret)
@@ -336,5 +336,323 @@ vmx_caretaker_init_host_vmcs(struct caretaker_vmx_page *cvp)
 		vmx_vmwrite(PLE_WINDOW, 4096);
 	}
 	vmx_vmwrite(CPU_BASED_VM_EXEC_CONTROL, cpu_ctl);
+
+	/*
+	 * Disable hardware MSR autoload lists while running in Caretaker so
+	 * VM-entry/VM-exit do not dereference unpreserved host vmx->msr_autoload
+	 * memory after kexec.
+	 */
+	vmx_vmwrite(VM_EXIT_MSR_LOAD_COUNT, 0);
+	vmx_vmwrite(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmx_vmwrite(VM_ENTRY_MSR_LOAD_COUNT, 0);
+}
+
+/*
+ * Guest-visible VMCS fields carried from the VMCS the caretaker ran the vCPU
+ * on to the VMCS the new kernel allocated for it.
+ *
+ * The new kernel does not adopt the old VMCS: it belongs to the previous
+ * kernel's struct loaded_vmcs, whose layout is not part of any handover ABI,
+ * and the VMCS region itself is opaque and implementation defined.  So the
+ * architecturally defined guest state is copied field by field instead.
+ *
+ * GUEST_IA32_EFER is handled separately because it is only written back when
+ * the caretaker actually recorded a value for it.
+ */
+static const u16 vmx_caretaker_guest_fields[] = {
+	GUEST_CS_SELECTOR,	GUEST_CS_LIMIT,
+	GUEST_CS_AR_BYTES,	GUEST_CS_BASE,
+	GUEST_SS_SELECTOR,	GUEST_SS_LIMIT,
+	GUEST_SS_AR_BYTES,	GUEST_SS_BASE,
+	GUEST_DS_SELECTOR,	GUEST_DS_LIMIT,
+	GUEST_DS_AR_BYTES,	GUEST_DS_BASE,
+	GUEST_ES_SELECTOR,	GUEST_ES_LIMIT,
+	GUEST_ES_AR_BYTES,	GUEST_ES_BASE,
+	GUEST_FS_SELECTOR,	GUEST_FS_LIMIT,
+	GUEST_FS_AR_BYTES,	GUEST_FS_BASE,
+	GUEST_GS_SELECTOR,	GUEST_GS_LIMIT,
+	GUEST_GS_AR_BYTES,	GUEST_GS_BASE,
+	GUEST_TR_SELECTOR,	GUEST_TR_LIMIT,
+	GUEST_TR_AR_BYTES,	GUEST_TR_BASE,
+	GUEST_LDTR_SELECTOR,	GUEST_LDTR_LIMIT,
+	GUEST_LDTR_AR_BYTES,	GUEST_LDTR_BASE,
+	GUEST_GDTR_LIMIT,	GUEST_GDTR_BASE,
+	GUEST_IDTR_LIMIT,	GUEST_IDTR_BASE,
+	GUEST_INTERRUPTIBILITY_INFO,
+	GUEST_ACTIVITY_STATE,
+	GUEST_IA32_DEBUGCTL,
+	GUEST_SYSENTER_CS,
+	GUEST_SYSENTER_ESP,
+	GUEST_SYSENTER_EIP,
+};
+
+static void
+vmx_caretaker_sync_vcpu(struct kvm_vcpu *vcpu, void *vcpu_data)
+{
+	struct kvm_caretaker_arch_ser *abi = vcpu_data;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	phys_addr_t cur_vmcs_pa = vmx->loaded_vmcs ? virt_to_phys(vmx->loaded_vmcs->vmcs) : 0;
+	struct vmcs *prev_vmcs;
+
+	guard(preempt)();
+	prev_vmcs = this_cpu_read(current_vmcs);
+
+	if (abi->vmcs_pa && cur_vmcs_pa && abi->vmcs_pa != cur_vmcs_pa) {
+		/* 42 * 8 bytes; this runs on the host stack, not a preserved one. */
+		unsigned long val[ARRAY_SIZE(vmx_caretaker_guest_fields)];
+		unsigned long guest_efer;
+		int i;
+
+		asm volatile("vmptrld %0" : : "m" (abi->vmcs_pa) : "memory", "cc");
+
+		for (i = 0; i < ARRAY_SIZE(vmx_caretaker_guest_fields); i++)
+			val[i] = vmx_vmread(vmx_caretaker_guest_fields[i]);
+		guest_efer = vmx_caretaker_read_efer();
+
+		asm volatile("vmclear %0" : : "m" (abi->vmcs_pa) : "memory", "cc");
+		asm volatile("vmptrld %0" : : "m" (cur_vmcs_pa) : "memory", "cc");
+
+		for (i = 0; i < ARRAY_SIZE(vmx_caretaker_guest_fields); i++)
+			vmx_vmwrite(vmx_caretaker_guest_fields[i], val[i]);
+		if (guest_efer)
+			vmx_vmwrite(GUEST_IA32_EFER, guest_efer);
+
+		abi->vmcs_pa = cur_vmcs_pa;
+	} else if (cur_vmcs_pa) {
+		asm volatile("vmptrld %0" : : "m" (cur_vmcs_pa) : "memory", "cc");
+	}
+
+	kvm_x86_caretaker_sync_vcpu_common(vcpu);
+
+	if (vmx->loaded_vmcs) {
+		pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
+		vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, pin_controls_get(vmx));
+		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, exec_controls_get(vmx));
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
+		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
+		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
+		memset(&vmx->loaded_vmcs->host_state, 0,
+		       sizeof(struct vmcs_host_state));
+		list_del_init(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link);
+		vmx->loaded_vmcs->cpu = -1;
+		vmx->loaded_vmcs->launched = 0;
+	}
+	vmx_segment_cache_clear(vmx);
+	vmx->vt.guest_state_loaded = false;
+	vmx->guest_uret_msrs_loaded = false;
+
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
+	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
+	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
+	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
+
+	vmcs_writel(GUEST_RIP, kvm_rip_read(vcpu));
+	vmcs_writel(GUEST_RSP, kvm_rsp_read(vcpu));
+	vmcs_writel(GUEST_RFLAGS, kvm_get_rflags(vcpu));
+	vmx_set_cr0(vcpu, vcpu->arch.cr0);
+	vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
+	vmx_set_cr4(vcpu, vcpu->arch.cr4);
+	vmx_set_efer(vcpu, vcpu->arch.efer);
+
+	if (vmx->loaded_vmcs)
+		vmx_set_constant_host_state(vmx);
+
+	if (cur_vmcs_pa)
+		asm volatile("vmclear %0" : : "m" (cur_vmcs_pa) : "memory", "cc");
+
+	if (prev_vmcs && (!vmx->loaded_vmcs || prev_vmcs != vmx->loaded_vmcs->vmcs)) {
+		vmcs_load(prev_vmcs);
+		this_cpu_write(current_vmcs, prev_vmcs);
+	} else {
+		this_cpu_write(current_vmcs, NULL);
+	}
+}
+
+static __cpu_preserved_text void
+vmx_caretaker_detach_serialize(void *page, struct kvm_vcpu_arch_ser *state)
+{
+	struct caretaker_vmx_page *cvp = page;
+
+	kvm_x86_caretaker_detach_serialize_common(&cvp->common, state);
+	kvm_x86_caretaker_update_msr(state, MSR_STAR, cvp->star);
+	kvm_x86_caretaker_update_msr(state, MSR_LSTAR, cvp->lstar);
+	kvm_x86_caretaker_update_msr(state, MSR_SYSCALL_MASK, cvp->fmask);
+	kvm_x86_caretaker_update_msr(state, MSR_KERNEL_GS_BASE,
+				     cvp->common.kernel_gs_base);
+}
+
+static __cpu_preserved_text void vmx_caretaker_arm_timer(void *page, u64 deadline_ticks)
+{
+	struct caretaker_vmx_page *cvp = page;
+	u32 shift = (cvp && cvp->timer_shift) ? cvp->timer_shift : VMX_PREEMPTION_TIMER_SHIFT;
+	u32 timer_value = 0;
+	u32 pin;
+
+	if (deadline_ticks) {
+		u64 now = arch_oncore_read_counter();
+
+		if (deadline_ticks > now) {
+			u64 remaining = deadline_ticks - now;
+
+			timer_value = (u32)(remaining >> shift);
+			if (timer_value == 0)
+				timer_value = 1;
+		} else {
+			timer_value = 1;
+		}
+	}
+
+	if (timer_value > 0) {
+		vmx_vmwrite(VMX_PREEMPTION_TIMER_VALUE, timer_value);
+		pin = (u32)vmx_vmread(PIN_BASED_VM_EXEC_CONTROL);
+		pin |= PIN_BASED_VMX_PREEMPTION_TIMER;
+		vmx_vmwrite(PIN_BASED_VM_EXEC_CONTROL, pin);
+	} else {
+		vmx_caretaker_disarm_timer(page);
+	}
 }
 
+static __cpu_preserved_text void
+vmx_caretaker_advance_rip(void *page, u64 rip)
+{
+	struct caretaker_vmx_page *cvp = page;
+
+	cvp->common.last_exit_rip = rip;
+	vmx_vmwrite(GUEST_RIP, rip);
+}
+
+static __cpu_preserved_text void vmx_caretaker_pre_enter(void *page)
+{
+	struct caretaker_vmx_page *cvp = page;
+
+	/* Ensure VMX is active on this core */
+	if (!(__read_cr4() & X86_CR4_VMXE)) {
+		asm volatile("mov %0, %%cr4" : : "r" (__read_cr4() | X86_CR4_VMXE) : "memory");
+		if (cvp->vmxon_pa) {
+			asm volatile("1: vmxon %[vmxon_pa]\n\t"
+				     "2:\n\t"
+				     _ASM_EXTABLE(1b, 2b)
+				     : : [vmxon_pa] "m" (cvp->vmxon_pa)
+				     : "memory", "cc");
+		}
+	}
+
+	/* Activate VMCS on this pCPU */
+	asm volatile("vmptrld %0" : : "m" (cvp->common.abi.vmcs_pa) : "memory", "cc");
+
+	/* Configure Caretaker host VMCS */
+	vmx_caretaker_init_host_vmcs(cvp);
+
+	if (cvp->common.arch_state)
+		native_write_cr2(cvp->common.arch_state->sregs.cr2);
+
+	native_wrmsrq(MSR_STAR, cvp->star);
+	native_wrmsrq(MSR_LSTAR, cvp->lstar);
+	native_wrmsrq(MSR_SYSCALL_MASK, cvp->fmask);
+}
+
+static __cpu_preserved_text void
+vmx_caretaker_read_seg(struct kvm_segment *var, u16 sel_field,
+		       u16 base_field, u16 limit_field, u16 ar_field)
+{
+	u32 ar = (u32)vmx_vmread(ar_field);
+
+	var->base = vmx_vmread(base_field);
+	var->limit = (u32)vmx_vmread(limit_field);
+	var->selector = (u16)vmx_vmread(sel_field);
+	var->unusable = (ar >> 16) & 1;
+	var->type = ar & 15;
+	var->s = (ar >> 4) & 1;
+	var->dpl = (ar >> 5) & 3;
+	var->present = !var->unusable;
+	var->avl = (ar >> 12) & 1;
+	var->l = (ar >> 13) & 1;
+	var->db = (ar >> 14) & 1;
+	var->g = (ar >> 15) & 1;
+}
+
+static __cpu_preserved_text void vmx_caretaker_post_exit(void *page)
+{
+	struct caretaker_vmx_page *cvp = page;
+	struct kvm_vcpu_arch_ser *state = cvp->common.arch_state;
+	u64 efer;
+
+	cvp->star = native_rdmsrq(MSR_STAR);
+	cvp->lstar = native_rdmsrq(MSR_LSTAR);
+	cvp->fmask = native_rdmsrq(MSR_SYSCALL_MASK);
+
+	cvp->common.cr0 = vmx_caretaker_read_cr0();
+	cvp->common.cr3 = vmx_vmread(GUEST_CR3);
+	cvp->common.cr4 = vmx_caretaker_read_cr4();
+	efer = vmx_caretaker_read_efer();
+	if (efer)
+		cvp->common.efer = efer;
+	cvp->common.last_exit_rip = vmx_vmread(GUEST_RIP);
+	cvp->common.last_exit_rsp = vmx_vmread(GUEST_RSP);
+	cvp->common.last_exit_rflags = vmx_vmread(GUEST_RFLAGS);
+
+	if (state) {
+		state->sregs.cr2 = native_read_cr2();
+		vmx_caretaker_read_seg(&state->sregs.cs, GUEST_CS_SELECTOR,
+				       GUEST_CS_BASE, GUEST_CS_LIMIT, GUEST_CS_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.ds, GUEST_DS_SELECTOR,
+				       GUEST_DS_BASE, GUEST_DS_LIMIT, GUEST_DS_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.es, GUEST_ES_SELECTOR,
+				       GUEST_ES_BASE, GUEST_ES_LIMIT, GUEST_ES_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.fs, GUEST_FS_SELECTOR,
+				       GUEST_FS_BASE, GUEST_FS_LIMIT, GUEST_FS_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.gs, GUEST_GS_SELECTOR,
+				       GUEST_GS_BASE, GUEST_GS_LIMIT, GUEST_GS_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.ss, GUEST_SS_SELECTOR,
+				       GUEST_SS_BASE, GUEST_SS_LIMIT, GUEST_SS_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.tr, GUEST_TR_SELECTOR,
+				       GUEST_TR_BASE, GUEST_TR_LIMIT, GUEST_TR_AR_BYTES);
+		vmx_caretaker_read_seg(&state->sregs.ldt, GUEST_LDTR_SELECTOR,
+				       GUEST_LDTR_BASE, GUEST_LDTR_LIMIT, GUEST_LDTR_AR_BYTES);
+		state->sregs.gdt.base = vmx_vmread(GUEST_GDTR_BASE);
+		state->sregs.gdt.limit = (u16)vmx_vmread(GUEST_GDTR_LIMIT);
+		state->sregs.idt.base = vmx_vmread(GUEST_IDTR_BASE);
+		state->sregs.idt.limit = (u16)vmx_vmread(GUEST_IDTR_LIMIT);
+
+		kvm_x86_caretaker_update_msr(state, MSR_IA32_SYSENTER_CS,
+					     vmx_vmread(GUEST_SYSENTER_CS));
+		kvm_x86_caretaker_update_msr(state, MSR_IA32_SYSENTER_ESP,
+					     vmx_vmread(GUEST_SYSENTER_ESP));
+		kvm_x86_caretaker_update_msr(state, MSR_IA32_SYSENTER_EIP,
+					     vmx_vmread(GUEST_SYSENTER_EIP));
+	}
+
+	/* Flush VMCS cache so host and incoming kernel see latest guest state */
+	asm volatile("vmclear %0" : : "m" (cvp->common.abi.vmcs_pa) : "memory", "cc");
+}
+
+static const struct kvm_x86_caretaker_runtime_ops vmx_caretaker_runtime_ops __cpu_preserved_data = {
+	.detach_serialize = vmx_caretaker_detach_serialize,
+	.common = {
+		.enter_guest = vmx_caretaker_enter,
+		.decode_exit = vmx_caretaker_decode_exit,
+		.handle_arch_exit = kvm_x86_caretaker_handle_exit,
+		.advance_rip = vmx_caretaker_advance_rip,
+		.arm_timer = vmx_caretaker_arm_timer,
+		.disarm_timer = vmx_caretaker_disarm_timer,
+		.pre_run = vmx_caretaker_pre_enter,
+		.post_run = vmx_caretaker_post_exit,
+	},
+};
+
+static const struct kvm_x86_caretaker_ops vmx_caretaker_ops = {
+	.name = "vmx",
+	.init = vmx_caretaker_init,
+	.sync_vcpu = vmx_caretaker_sync_vcpu,
+	.runtime = &vmx_caretaker_runtime_ops,
+};
+
+void vmx_caretaker_register(void)
+{
+	kvm_x86_caretaker_register_ops(&vmx_caretaker_ops);
+}
+
+void vmx_caretaker_unregister(void)
+{
+	kvm_x86_caretaker_unregister_ops(&vmx_caretaker_ops);
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 48b6e69f99bf..817623f7429a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -54,6 +54,7 @@
 #include <trace/events/ipi.h>
 
 #include "capabilities.h"
+#include "caretaker.h"
 #include "common.h"
 #include "cpuid.h"
 #include "hyperv.h"
@@ -8548,6 +8549,7 @@ void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 void vmx_hardware_unsetup(void)
 {
+	vmx_caretaker_unregister();
 	kvm_set_posted_intr_wakeup_handler(NULL);
 
 	if (nested)
@@ -8855,6 +8857,8 @@ __init int vmx_hardware_setup(void)
 
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
+	vmx_caretaker_register();
+
 	return 0;
 }
 
-- 
2.55.0.1082.g2b9226bbc0-goog



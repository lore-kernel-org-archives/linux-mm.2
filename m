Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BCCC982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02436B00E0; Sun, 20 Sep 2026 15:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9E06B00E1; Sun, 20 Sep 2026 15:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B426B00E2; Sun, 20 Sep 2026 15:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0C136B00E0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 318A8A04C1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:52 +0000 (UTC)
X-FDA: 85235158344.04.DBE709D
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D12380007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CkPZ+I8d;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933250;
	b=IsyqB6at+LUkze9Ru8N4poKFHLC5v++x16I2lDSvsbKwPoGiyecUvxrC7UW19Q86EU0SsW
	COC0dpbhQFITh1yF3BQCWKLC58puB7L+PWxYxg45gBEV+ODW4Yf/m3L7/IKw4VC735Jy12
	d1SzJPjojjR9wmqIk2pXhSuokiPdDhA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CkPZ+I8d;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5hDLFKTi0Cs1ZiX/XYeG+c49YMslw+nL6Py3nD0h7s=;
	b=v8twyeWYXTvWWmaS8OVRh7kLY4Ji0DaD8X9+JTQZwiqNbg8mgb4Sh8osR6cfmqXGrVlHdF
	UZ1Hr4JvEZ4ULR4TTh8cEFsiqpkSLN0cxCPIFLmBCtrmORuO7JzH46lPcdCbhot1ptf1mQ
	bZhUFcCXaqAiTAtKuHvdyotFM4oZSmM=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d881so2203019d50.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933249; x=1790538049; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=k5hDLFKTi0Cs1ZiX/XYeG+c49YMslw+nL6Py3nD0h7s=;
        b=CkPZ+I8dcYINXvw4BS5ou++l9NAD5XvjGWPjmcLO501yJZAnxp2tVTrPsLAS/gXZ3p
         gjgRUouLh6FOWXF7F/AAO1dKjIzoehrR6gUSPs3/quO5tefTFtne0s0Kmy86gCfES+Ib
         +oDVxqtyXqW5Dv1P8K3YSh5bvVJWjEO/aHmgaNq94/gON1EjqBFdSnDVTPpjCoTRK4qD
         oGeh55xGShP2U8KK5ihTpTsr0Lhjk4BgcwKEwM/iTM5/KGC9kGeIc8nJRWVorMupboaL
         /EG3b9/OMTRy/nDYxncdlNlakgl1uvh3+12OYsUiz+CMDtFBkLGgvlmgqPAAfa8WsCWV
         j7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933249; x=1790538049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k5hDLFKTi0Cs1ZiX/XYeG+c49YMslw+nL6Py3nD0h7s=;
        b=Ckb7EP0jOvpnrtimfkFXUaJ8uhhz6y9tSB29q8qYoGwfsVrlGoAYxEQXNBrJaRKBqT
         3LXgXx/sA0WDnborVX+Qvu0MdRzIV81V7vnW4eMu7icfzcGm9xaa6XVU5f2GtOoPTRt6
         2xvoNa1nNVQWlhJujk5WNt7bgIjwq62MMas4dr8mtSYnOZv7zm3wcQndVOigZYVCmDRe
         ce8SjPOdeNAeqs6zlCWy5gPN6WXuTIhz8Dl+WnTtOqXbewnTt24VuIlMh8mnHKm0OfNp
         c/xjRFllzcYj8ZIif+SBWdL+WR4mnfnhLuM0i3TB4uiQV51/sjz7McM/HqpnjV59Er49
         CRTQ==
X-Forwarded-Encrypted: i=1; AKwUvBwY0XpS1/Iyl3KXprt3+DZkv2AntLx2OUWOSzoqjW1sgSbOLKiIv22aFE86TrqWHXHhZ+CR/0SjGQ==@kvack.org
X-Gm-Message-State: AFuF++meb99cXATZ+GLM3XLugbsB1lU/UX6aBybkgHjj+hWgKUe34EJq
	pbtinIXSFxmghSTWm3PS6KVPviDGAYPNld1woRg5eNN0xAxWq0XKMG7j78oz9QklZbg=
X-Gm-Gg: AYBFou3cJP26x4sGN6dToNGnGiW4mJOg9RRh7X6z27V3i0AMz+IEGlVKwGZ+k1cUDVs
	smZ45/8Wf9Jr4WdcXHL8wd+whUDAUnUOXaRC+q+hOXEj4s3QqIg1fTmupAmVFTDyDX300a9oQGL
	2/u1pxTjcVJTkoJ+kJVWxeYrVoSQiEfjZXitheBF+UyUTZcr1YQSCnG0jPty7/s9WKWi7jb8x/A
	AZqCVvrfXWrIUDY0GK49OGiYqR1HXBUh/0do1ddMIzru2UFf+W+omBKXH6iX3Oul8OT5P/tKoP9
	bLXE+C+J6pajWU+R/0CUwKPp/Le7OTzLx2+iEm8WzHBxED/GqHrYLyybe1eZn2fg3GhPV6tVuX5
	tc4Kqeby7vj9G5n9QU8qmIGtjDwsu+79dFW+lPEwLQcPFez2BzSqRSoEF80O3Rq9pC2QA2wwoy1
	cq7/u48vUWNDbOl+QuCCFWaG1UDjQUSpnWiU3ko7IB2NJ6VGS0Mnj78lLWx1HMCebT+dZZp4hbP
	FdqwbWEGxGSRtLrpLJ5c26tTQQooClE9zMFy4f7RrFhGttBGZvIjt2H631EdXl7FHNn/SJf+uZc
	1HCYii15j8XF+FbJ+XjvhXBKXeSwNQ==
X-Received: by 2002:a05:690e:4085:b0:671:5653:8564 with SMTP id 956f58d0204a3-6717fe32f3dmr3086661d50.91.1789933249448;
        Sun, 20 Sep 2026 12:40:49 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67298d74ef4sm2650188d50.0.2026.09.20.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:48 -0700 (PDT)
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
Date: Sun, 20 Sep 2026 15:36:43 -0400
Message-ID: <20260920193650.3373435-40-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D12380007
X-Rspam-User: 
X-Stat-Signature: fcdxrygcghz7apn8n3x77pah9h87r6un
X-HE-Tag: 1789933250-886316
X-HE-Meta: U2FsdGVkX1+HcWhSvfwhL+qyx5CvoOqT+ARwbD8k1URrEz0FKnyssij/kkrKVBOFjC581fHSP6CLQyRAoMfdcOWyqPvaoC3JTG3Y/PILwQMJYDc2t0S+VqyY6+pnfIM3NRmBhsV+eKRk4sZvd4UNgfqxuwAyUqGjCWrcwFjdN6E6GcV+EOIC93Dj2N5Kk9dkDq9a2Z55IgeeKaLVke+IEX7H/KslzGNDW+MKEiaeCd5O7ldM5nSCul66IX6iABOYWqBZSmluCnasl4geGZphKBls2llkxFDwHBBnpmV2KjUikwd0VLkAcKX19JlALnEoZDKmXnTzdI+WjO0okjAVVn3Sgtqp3sjbDddj2RdLubvfURsc7vLfSvtXbLXtgsXfmzFI1K0UOCPr28qBqTD5qw637S1Oc0E63azqKEv7CzIW6oKF8yKBLX9L/CmOw6VClEo4xqPdey2SR7/9Ev6lm5ZS5G4z14oaAGd5Y76BDhelnqnNdf1Wqc1w6mkAaxp1sze1PuXqSvwkDg9oR8sbH1xyv0zljbIoDHK9Gt6DFZtv7SFOqgShKXA+OLhh0QclW5HwHUskvXYwuBeeNKWsH9LXE6xVN8GNJtCV4fUMpkOgNs9XAPfB5stxLU3IIcgkflgvJFy2zlD3Cx4BR23J7VN6d4pqzVeitvGFr7sFEVEHsP0m51y8UxCmF6SaJ/SVYSqlYLgeJ7bNo8Y+5LTcC5vZhBJMoK6pNS/QUK+JC0RuGR+/3Fn1bEXB6J7ihfMd9KMt8ihNGT96rlnxdqI6DjWmsYUQMkP/yB7+NYM47dDlY2gN4fAQJGzhFX3HVEb1YLpUGZK7Bytc1UmJp2nxapxhSMbedST2b5+D5WRZeqgUx+WNemBaPVkWHKxmIz3twoUlbavqbus58DH/JaUpa3SAudSmmD0DkV1paY/bxqSFSAat/IEUDcB/054M4A46swLtrBXxMcG3GuttRsH
 zesfsCot
 /xlacRBQtFpoJB6l8nZ3JSvq2GMkKnySECbkzxBWbCkAuTyI1IdCzH36t5YZ1sDHlHFLQAljUYBy1fdc+uyXQQ4yttvyWOD1rDNVBKMLa7nm3x7Jr+0enBtxJzkw4qqVHhA/VkpLzaOjjjZDtxsqB7sd4CpMc3C+Pm4zvfWhJNvRFwCYtQ7cdmcivr5ieS0cP9yd3s5eBVmPWiu/RnGSKLYTkIEupI7X/UYjFmdY7OXmdoQf1dbUYLeIZA2xbo/eSIS6rjkPlI1/c3nDz9Atg56GVwKNYsDofQKbZ2lARYKXX2EvjrplRvaMg2CltKxpU+rRM+NE5uaWvmO8=
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



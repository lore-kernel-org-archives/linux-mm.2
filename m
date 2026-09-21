Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDDBC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBFD6B009D; Mon, 21 Sep 2026 17:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACFA6B009E; Mon, 21 Sep 2026 17:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91916B009F; Mon, 21 Sep 2026 17:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE476B009D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:01:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EBC81A02E3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:59 +0000 (UTC)
X-FDA: 85238989038.22.20BA99B
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 847921C0014
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:00:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KUQN4u4V;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790024457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9yjuK1GvA7WV81vpr4lLFMgvL9Udfn1vNj/C/kFbiw=;
	b=g+pB3f4mE4aLDOC8f1sMbBHQHWU4lCdacuxocUjcDlbM5A/j3O7HbMOS3S6GlVOG/K/nYY
	dNo/YSB3WPhdY4Pvr4wXsvW5RR0aPUiHBm4xwhmZsFelYPs2XlhKjHUZixGNJloG81NFjZ
	3DqLrVD7wXtSOrlp8vFulZ9hZ4bOZNs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KUQN4u4V;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790024457;
	b=puQCtoA9M82w7g0CR3CypJxT1bPVJWIHA0g0PgtiZOV0IMvnyQe7hpYcn59MdCOB2BzmBo
	Vx84CF73moHemzcVIh6Zaj7BsDT1R03fqpmsAQYLi13Xd6bJ3IfCZM+FWqEuDaFVrKf0VS
	EzyqH8Ji9ZSeNwKqr0DRcoV5sWpu56M=
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-89666eea29cso25292277b3.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024456; x=1790629256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=R9yjuK1GvA7WV81vpr4lLFMgvL9Udfn1vNj/C/kFbiw=;
        b=KUQN4u4VYQnXBm2DfNooqfoRFD09H/sQl5njvRjGeinMz0DhmoE7Tq3yWHYesNZFGZ
         hpz0l9nLCoZZm4H3tSclOJwgMGTJy0PMsdX0fyT1qghsRbOHCdpIe4BjnjPjOZ2VqCY4
         oQLjw+4N9tuoeGcoSKUTdK9FJwtoLUQcXWc9sP9Rk2d1QXx30Smq2rsCZipoiUsqTB+r
         PhS8A/tyjiljH68jCSASfVydj/A36MOkKJDYwmhS9veL8LlKSZlYO8PQ2MlV+BeMEZHg
         a4aBaXwmC6FVEuptROQlZqb6CUfT/7YgbReN5BkdU254psxUjHyYPASQGnuA665ZjTQP
         j58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024456; x=1790629256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=R9yjuK1GvA7WV81vpr4lLFMgvL9Udfn1vNj/C/kFbiw=;
        b=1JsSfy9uGRqxYrClHybEAb0nlCNo1MsLbGw8ZJH2XSse/wo5ItLX6DKbTcSxFra9rv
         cVAM1jSL3zI+aB5NSYF9BYxnpRj+wU31Lz+90Vfyn8ua/JF1Xr/wcgUKYaqY70n+Lghl
         Om5/bawwYW2TA0MamQiWNs9tdF8XMYaeh3xSgKoo5aqFr1aC8TTkrwNbLWqP5oDpm0E/
         eqleclU6Hx/pw5U623bDFzuQ1rmiGFk9hjpsQ9SGXnBD7NDSmpqXom3YM5DAU8naCN7/
         a4B/Oq78OtLD2Uf6EYLRkG+cxtybXGpIB1LA4n8hqFMniFCvJdY2dzvc56rP59pQ2VXa
         /xrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwqDihEVAf8NMV6Ohf6hzjR9XE2QbzDFRgR+qKAWQi1UArHCMRwQJyF+qOrbiM2dlv1TzZQB2Z1Tw==@kvack.org
X-Gm-Message-State: AFuF++kzB8sd64nLhdTYXtgIESKD/wOtj2nSTvWrDSN/LQ4H5R3C/Yt6
	KwJwI0ZYlc6H0IWtEv2QQSEXUgdFHo3DU8Zy7MkAcct6PZ8y85dKUi+++NIpxSeJ80A=
X-Gm-Gg: AYBFou3t+JP4gwqForHDOMUKQ6SQmw0GVk2SOiUjmceiOpd1nzJfsUbG+h1/Z/6cFzC
	hePjmY7l77MWJ613JGjYkZi88H++1IuA6OlwQCeq0tyI8Iyqv1XspBr8l0uM12vTOKXjtpqgzDA
	HeQlmxEz2/jwrLWIuf0lOjbcvKM2GOsKJHTifP7XLlobb5Gu7lkv7MDPyi6ZIFODGPr67DKmWDp
	G2AETLfmqvoMFtuZ66Ww+TH3RKfTnu/Le+8ITITot8UpVwX3oXylCYzkSpPb6n+zvyPBUx1OTd5
	sTH8PYTwERIKhg10xTTYqOebSy3Mu7fp8zaV8tBx9GL3w9i21+Lyy/ElgawXDG3DcJBumJ4vrNY
	y9mgTyG8SZ3Px7hRCXGusDN/z6nNr7CFDC+Cucz2JBkHU/N2Yyob7TTG4CIaHTqSODB/fsWQyVw
	poBjGl2M6/616VFiF5UHpYflh4jt1jIFrbVLtDClLyIvphsIIqSAOURNQb5Cf6v/w2/hVpkGSac
	I0SzTGZo8WDf1aOuSuEq3IJHmTghoISXnz25CTsC2dTmRkAPLX5HXGRlxZTzqyUx3aJiFgAZRCb
	AGMrDwMHoCRY6wCAaQY=
X-Received: by 2002:a05:690c:60c7:b0:873:5bd1:98bc with SMTP id 00721157ae682-89737319ab8mr34742607b3.46.1790024456175;
        Mon, 21 Sep 2026 14:00:56 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:55 -0700 (PDT)
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
Subject: [RFC PATCH 46/46] KVM: arm64: Implement Caretaker vCPU run loop and LUO detach/attach lifecycle
Date: Mon, 21 Sep 2026 17:00:34 -0400
Message-ID: <20260921210034.180424-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kwjqdmhourrqdiuosmdx4e31wyc585eu
X-Rspamd-Queue-Id: 847921C0014
X-Rspamd-Server: rspam07
X-HE-Tag: 1790024457-914486
X-HE-Meta: U2FsdGVkX1+Bt1HXY9yARyZVYIGqMlsvk22mzgdAurwDjUnXJBO+TbBbz5PA5a2DLGbbP8o3RVyVq31VAh44b6DPq0LRj2a3bo+4Iju1GR90AJ1B7O8MeCL4TU8m3cB3hpWkn/twgM3N8ZdJGwJ49Cgzstck1UhjMhFtZuZIwXlcDuiS1qPfNLJcp5WKl30rULYKAe6rLmlmaQFUsQmlooBKNxG1Lbu8NPsYtelo8IxOUW79w5SzWYe9IuNlYe7XoRClOC9rCWNko2jk/D+baN9KTiyc4JSKO7vP9sgAClNdnyTgok9MHd64s2lqnb+l5NA1XRYUVDRGfpRi2dLZkIuXPM3voBseAsS6BgV5mV4X6slnvHqvsebkXtsWlneIjKshiIrKxtJ/3pgZ4bczhVEr5H7+dDwpksmNZkw7K3Fjsu/HXk84Dl2iJim6LjyqE/4VJlnKNPToNJ9UF3p/2CwujkkzpjOshhWoG5DXgqur1recA2j5lCyCxfVAcE9AtuIMqT9i9C7EGriRbDPZMtcs1qE3Ed6zqxxNygDCSRBbzh9hM8jRBVJ4I3fusXrY1uL2tnx9oWjy8Q/Wg3pYU8BlCrm8YziiS4/eVwrYM8vTqLpBEZuUGLmc7t1ilzpLoM7i0/J1HWlDM2r0p3xogsaUiMrBlH7yJbwvcyRJRsspm6kGLV5xa8gOzwDyz8+xuv09FPlh/2BnUgNfT8a+hIXf9n3G435MYT9YWuWfoBrMtQ3PBa3zSi0oK7ob3C6vXq1Gl8Mc8PeH8BILK7L2tN3gKj3+jw/INRFjS7gfK3LCRTfa3t5VHvI+i1poLr1GAOyYtEszpvOPjYneqV+rkTzH21vBHR+bTCx5NKopmDO7Aqp+PFrTdh1wCN07iNNExTWGtkzXRY6ovBH8mH1rWRahz/lS0H5SW7tIF9KOa7BqG/XvZECIcAnoF0Y833Dkw+lGM3/1hV0NHKaVbt9
 nMc7gtt0
 ImX8nDYBWp8hMpeAiE1vyIRtn/5WRFybHMzTy8xl8g217hJqJ6JHiz7K01LH8kSBSQ6MQunbZKv7NTNdcSbzCxgDbRDp3Ws31qqLNjB6avQVAV7HO9UDYFzdc/nDeZLULt2IGH/std1RSi/Ycvo2T6RG552HKSbkpPnVyoRGRIo0Moj9FXG9yTXSQVZ7XRyHcGKDZl1xhsk0dFA3WGRbp3ncCexNDMTgQ7bcv7MLJwv4yIVg/M6mZurK5a/OfFiEOCo3wGZiQ28XuDyPiMhvfL0agluKas7K8KqeuLYKHsgDmXdnxcCauRbV+fxOmqFbuRgb7O2FxtK8CK9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Complete ARM64 Caretaker vCPU execution loop, detach-time state
serialization, and LUO integration in arch/arm64/kvm/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/Kconfig     |   1 +
 arch/arm64/kvm/Makefile    |  12 ++
 arch/arm64/kvm/caretaker.c | 243 ++++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/kvm_luo.c   | 103 ++++++++++++++++
 4 files changed, 357 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index fd25b3c0d8ca..9c43010873a3 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
 	select HAVE_KVM_ARCH_VCPU_PRESERVE
+	select HAVE_KVM_ARCH_CARETAKER
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index d5e888d1bd50..58550a0a8160 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -12,6 +12,18 @@ obj-$(CONFIG_KVM) += hyp/
 
 CFLAGS_sys_regs.o += -Wno-override-init
 CFLAGS_handle_exit.o += -Wno-override-init
+KASAN_SANITIZE_caretaker.o := n
+KCSAN_SANITIZE_caretaker.o := n
+UBSAN_SANITIZE_caretaker.o := n
+KCOV_INSTRUMENT_caretaker.o := n
+CFLAGS_REMOVE_caretaker.o = $(CC_FLAGS_FTRACE)
+CFLAGS_caretaker.o += $(call cc-option,-mbranch-protection=none) \
+		      -fno-stack-protector \
+		      $(call cc-option,-ftrivial-auto-var-init=uninitialized) \
+		      $(call cc-option,-fno-jump-tables)
+AFLAGS_caretaker_vmenter.o += -D__KVM_VHE_HYPERVISOR__
+
+kvm-$(CONFIG_KVM_CARETAKER) += caretaker.o caretaker_vmenter.o
 
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o config.o \
diff --git a/arch/arm64/kvm/caretaker.c b/arch/arm64/kvm/caretaker.c
index 6980c1f6b998..8cd73099a60a 100644
--- a/arch/arm64/kvm/caretaker.c
+++ b/arch/arm64/kvm/caretaker.c
@@ -193,6 +193,9 @@ int arm64_kvm_caretaker_preserve(struct kvm_vcpu *vcpu,
 	cap->ctx.vtcr_el2 = mmu->vtcr;
 	cap->ctx.vttbr_el2 = kvm_get_vttbr(mmu);
 
+	if (irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm))
+		kvm_vgic_map_resources(vcpu->kvm);
+
 	if (vgic_initialized(vcpu->kvm)) {
 		int i;
 
@@ -504,8 +507,8 @@ __caretaker_text static void caretaker_vgic_v3_save(struct vgic_v3_cpu_if *cpu_i
 	used_lrs = min3(used_lrs, max_lrs, (unsigned int)VGIC_V3_MAX_LRS);
 
 	for (i = 0; i < used_lrs; i++) {
-		cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
-		__gic_v3_set_lr(0, i);
+		cpu_if->vgic_lr[i] = caretaker_gic_v3_get_lr(i);
+		caretaker_gic_v3_set_lr(0, i);
 	}
 
 	cpu_if->vgic_vmcr = read_sysreg_s(SYS_ICH_VMCR_EL2);
@@ -921,3 +924,239 @@ static void arm64_caretaker_sync_vcpu(struct kvm_vcpu *vcpu,
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 }
 
+static __caretaker_text void
+arm64_caretaker_op_pre_run(void *data)
+{
+	struct caretaker_arm64_page *cap = data;
+
+	local_daif_mask();
+	arm64_caretaker_save_ptrauth(&cap->ptrauth_keys);
+
+	/* Pre-job: load guest context */
+	cpu_preserved_inval(cap);
+
+	arm64_caretaker_load_sysregs(&cap->ctx.ctxt);
+
+	if (cap->ctx.vgic_initialized)
+		caretaker_vgic_v3_restore(cap);
+
+	write_sysreg(cap->ctx.cntvoff_el2, cntvoff_el2);
+	write_sysreg_el0(cap->ctx.cntv_cval_el0, SYS_CNTV_CVAL);
+	write_sysreg_el0(cap->ctx.cntv_ctl_el0, SYS_CNTV_CTL);
+	isb();
+
+	if (cap->ctx.vtcr_el2 && cap->ctx.vttbr_el2) {
+		write_sysreg(cap->ctx.vtcr_el2, vtcr_el2);
+		write_sysreg(cap->ctx.vttbr_el2, vttbr_el2);
+		asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
+		__tlbi(vmalle1);
+		asm volatile("ic iallu");
+		dsb(nsh);
+		isb();
+	}
+
+	write_sysreg(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
+		     CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN,
+		     cpacr_el1);
+	isb();
+
+	fpsimd_load_state(&cap->ctx.ctxt.fp_regs);
+
+	gicv3_caretaker_enable_sgi();
+	write_sysreg_s(ICC_CTLR_EL1_EOImode_drop, SYS_ICC_CTLR_EL1);
+	write_sysreg_s(ICC_SRE_EL1_SRE, SYS_ICC_SRE_EL1);
+	write_sysreg_s(0, SYS_ICC_BPR1_EL1);
+	gicv3_caretaker_clear_active_priorities();
+	write_sysreg_s(ICC_PMR_EL1_MASK, SYS_ICC_PMR_EL1);
+	write_sysreg_s(ICC_IGRPEN1_EL1_MASK, SYS_ICC_IGRPEN1_EL1);
+	caretaker_gic_drain_iar();
+	dsb(sy);
+	isb();
+}
+
+static __caretaker_text void
+arm64_caretaker_op_post_run(void *data)
+{
+	struct cpu_preserved_stack_context *sctx;
+	struct caretaker_arm64_page *cap = data;
+	int cpu = cap->abi.cb.pcpu_id;
+	phys_addr_t pgd_pa;
+
+	/* Post-run: restore host hypervisor mode then save guest context */
+	write_sysreg_s(0, SYS_CNTHP_CTL_EL2);
+	caretaker_restore_host_el2();
+
+	fpsimd_save_state(&cap->ctx.ctxt.fp_regs);
+
+	cap->ctx.cntv_cval_el0 = read_sysreg_el0(SYS_CNTV_CVAL);
+	cap->ctx.cntv_ctl_el0 = read_sysreg_el0(SYS_CNTV_CTL);
+
+	if (cap->ctx.vgic_initialized)
+		caretaker_vgic_v3_save(&cap->ctx.vgic_v3);
+
+	arm64_caretaker_save_sysregs(&cap->ctx.ctxt);
+
+	sctx = cpu_preserved_get_stack_context();
+	if (sctx && sctx->session_pgd_pa)
+		pgd_pa = sctx->session_pgd_pa;
+	else
+		pgd_pa = cpu_preserved_get_pgd(cpu);
+
+	if (!pgd_pa)
+		pgd_pa = READ_ONCE(arm64_caretaker_pgd_pa);
+
+	write_sysreg(0, ttbr0_el1);
+	if (pgd_pa && read_sysreg(ttbr1_el1) != pgd_pa) {
+		write_sysreg(pgd_pa, ttbr1_el1);
+		isb();
+		arm64_flush_host_tlb_local();
+	}
+
+	cpu_preserved_clean(cap);
+
+	if (smp_load_acquire(&cap->abi.cb.state) >= KVM_CARETAKER_STOPPING ||
+	    kvm_caretaker_should_exit(&cap->vcpu)) {
+		local_daif_mask();
+		isb();
+
+		caretaker_gic_drain_iar();
+		gicv3_caretaker_clear_active_priorities();
+		write_sysreg_s(0, SYS_ICC_IGRPEN1_EL1);
+		write_sysreg_s(0, SYS_ICC_PMR_EL1);
+		write_sysreg_s(0, SYS_ICC_BPR1_EL1);
+		gicv3_caretaker_clear_sgi();
+		dsb(sy);
+		isb();
+	}
+
+	arm64_caretaker_detach_serialize(cap);
+
+	arm64_caretaker_restore_ptrauth(&cap->ptrauth_keys);
+	caretaker_restore_host_el2();
+}
+
+static struct kvm_caretaker_ops arm64_caretaker_ops __cpu_preserved_data = {
+	.enter_guest = arm64_caretaker_op_enter,
+	.decode_exit = arm64_caretaker_op_decode_exit,
+	.handle_arch_exit = arm64_caretaker_op_handle_exit,
+	.advance_rip = arm64_caretaker_op_advance_rip,
+	.arm_timer = arm64_caretaker_op_arm_timer,
+	.disarm_timer = arm64_caretaker_op_disarm_timer,
+	.pre_run = arm64_caretaker_op_pre_run,
+	.post_run = arm64_caretaker_op_post_run,
+};
+
+static __caretaker_text enum oncore_exit_reason
+caretaker_arch_run_page(struct caretaker_arm64_page *cap, u64 deadline_ticks)
+{
+	enum oncore_exit_reason reason;
+	int cpu;
+
+	if (!cap)
+		return ONCORE_EXIT_ERROR;
+
+	cpu_preserved_inval(&cap->abi.cb);
+	cpu = cap->abi.cb.pcpu_id;
+	if (cpu < 0 || cpu >= ARRAY_SIZE(arm64_caretaker_faults))
+		cpu = arm64_caretaker_get_pcpu();
+
+	cap->abi.cb.pcpu_id = cpu;
+	if (cmpxchg(&cap->abi.cb.state, KVM_CARETAKER_PAUSED,
+		    KVM_CARETAKER_RUNNING) != KVM_CARETAKER_PAUSED ||
+	    cpu_preserved_should_exit(cpu)) {
+		arm64_caretaker_detach_serialize(cap);
+		smp_store_release(&cap->abi.cb.state, KVM_CARETAKER_STOPPED);
+		cpu_preserved_clean(&cap->abi.cb);
+		return ONCORE_EXIT_ATTACH_SIGNALED;
+	}
+	cpu_preserved_clean(&cap->abi.cb);
+
+	cap->vcpu.ops = &arm64_caretaker_ops;
+
+	reason = kvm_caretaker_vcpu_run(&cap->vcpu, deadline_ticks);
+
+	cpu_preserved_inval(&cap->abi.cb);
+	if (reason == ONCORE_EXIT_ATTACH_SIGNALED ||
+	    reason == ONCORE_EXIT_ERROR ||
+	    cpu_preserved_should_exit(cpu) ||
+	    cmpxchg(&cap->abi.cb.state, KVM_CARETAKER_RUNNING,
+		    KVM_CARETAKER_PAUSED) != KVM_CARETAKER_RUNNING) {
+		reason = ONCORE_EXIT_ATTACH_SIGNALED;
+		arm64_caretaker_detach_serialize(cap);
+		smp_store_release(&cap->abi.cb.state, KVM_CARETAKER_STOPPED);
+		cpu_preserved_clean(&cap->abi.cb);
+	} else {
+		cpu_preserved_clean(&cap->abi.cb);
+	}
+
+	return reason;
+}
+
+__caretaker_text enum oncore_exit_reason
+kvm_arch_vcpu_caretaker_run(void *data, u64 deadline_ticks)
+{
+	struct kvm_caretaker_cb_ser *cb = data;
+
+	/*
+	 * @data is always a struct kvm_caretaker_cb_ser: kvm_caretaker_vcpu_preserve()
+	 * installs it with oncore_job_set_data() before activating the job.
+	 */
+	if (!cb)
+		return ONCORE_EXIT_ERROR;
+
+	return caretaker_arch_run_page(container_of(cb,
+						    struct caretaker_arm64_page,
+						    abi.cb),
+				       deadline_ticks);
+}
+
+void kvm_arch_vcpu_luo_pre_retrieve_caretaker(struct kvm_vcpu *vcpu,
+					      struct kvm_vcpu_ser *ser)
+{
+	if ((ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) && ser->cb.phys) {
+		struct kvm_caretaker_arch_ser *abi = phys_to_virt(ser->cb.phys);
+		int pcpu = abi->cb.pcpu_id;
+
+		if (pcpu >= 0) {
+			kvm_caretaker_wait_for_attach(&abi->cb, pcpu);
+			cpu_preserved_inval(abi);
+			if (ser->arch_state.phys) {
+				struct kvm_vcpu_arch_ser *state =
+					phys_to_virt(ser->arch_state.phys);
+
+				cpu_preserved_inval(state);
+				cpu_preserved_inval_sz(state,
+						       struct_size(state, sysregs,
+								   state->num_sysregs));
+			}
+		}
+	}
+}
+
+void kvm_arch_vcpu_luo_attach_caretaker(struct kvm_vcpu *vcpu,
+					struct kvm_vcpu_ser *ser)
+{
+	if ((ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) && ser->cb.phys) {
+		struct kvm_caretaker_arch_ser *abi = phys_to_virt(ser->cb.phys);
+
+		arm64_caretaker_sync_vcpu(vcpu, abi);
+	}
+
+	kvm_caretaker_post_attach_vcpu(vcpu);
+}
+
+void arm64_kvm_caretaker_unpreserve(struct kvm_vcpu_ser *ser)
+{
+	if (ser->cb.phys) {
+		kho_unpreserve_free(phys_to_virt(ser->cb.phys));
+		ser->cb.phys = 0;
+	}
+}
+
+void arm64_kvm_caretaker_finish(struct kvm_vcpu_ser *ser)
+{
+	if (ser->cb.phys) {
+		kho_restore_free(phys_to_virt(ser->cb.phys));
+		ser->cb.phys = 0;
+	}
+}
diff --git a/arch/arm64/kvm/kvm_luo.c b/arch/arm64/kvm/kvm_luo.c
index 59c56836cda8..ae8baef49f97 100644
--- a/arch/arm64/kvm/kvm_luo.c
+++ b/arch/arm64/kvm/kvm_luo.c
@@ -6,6 +6,7 @@
  * ARM64 KVM LUO preservation and retrieval handlers.
  */
 
+#include <linux/cpu_preserve.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/kvm_arm64.h>
 #include <linux/kvm_host.h>
@@ -17,15 +18,100 @@
 #include <kvm/arm_arch_timer.h>
 #include <kvm/arm_vgic.h>
 
+#include "caretaker.h"
 #include "sys_regs.h"
 #include "vgic/vgic.h"
 
+#ifdef CONFIG_KVM_CARETAKER
+struct arm64_stage2_kho_walk {
+	struct kvm_kho_folios_ser *kp;
+	unsigned int count;
+};
+
+static int stage2_kho_visitor(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
+{
+	struct arm64_stage2_kho_walk *w = ctx->arg;
+
+	if (kvm_pte_valid(ctx->old) && ctx->level != KVM_PGTABLE_LAST_LEVEL &&
+	    FIELD_GET(KVM_PTE_TYPE, ctx->old) == KVM_PTE_TYPE_TABLE) {
+		u64 phys = kvm_pte_to_phys(ctx->old);
+		struct page *p = phys_to_page(phys);
+
+		if (!p)
+			return 0;
+
+		if (!w->kp) {
+			w->count++;
+			return 0;
+		}
+
+		if (w->kp->nr_folios >= w->count)
+			return -ENOSPC;
+
+		if (kho_preserve_folio(page_folio(p)))
+			return -ENOMEM;
+
+		w->kp->folios_pa[w->kp->nr_folios++] = phys;
+	}
+	return 0;
+}
+#endif
+
 int kvm_arch_vm_luo_preserve(struct kvm *kvm, struct kvm_luo_ser *ser)
 {
+#ifdef CONFIG_KVM_CARETAKER
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct arm64_stage2_kho_walk walk = {};
+	struct kvm_pgtable_walker walker = {
+		.cb = stage2_kho_visitor,
+		.flags = KVM_PGTABLE_WALK_TABLE_PRE,
+		.arg = &walk,
+	};
+	struct kvm_kho_folios_ser *kp;
+	int ret;
+#endif
+
 	ser->type = kvm_phys_shift(&kvm->arch.mmu);
 	if (kvm_vm_is_protected(kvm))
 		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
 
+#ifdef CONFIG_KVM_CARETAKER
+	kvm->caretaker_vm = NULL;
+
+	if (mmu->pgd_phys)
+		walk.count++;
+	if (mmu->pgt) {
+		ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
+		if (ret)
+			return ret;
+	}
+
+	kp = kvm_kho_folios_alloc(walk.count);
+	if (IS_ERR(kp))
+		return PTR_ERR(kp);
+	walk.kp = kp;
+
+	if (mmu->pgd_phys) {
+		ret = kho_preserve_folio(page_folio(phys_to_page(mmu->pgd_phys)));
+		if (ret) {
+			kvm_kho_folios_unpreserve(kp);
+			return ret;
+		}
+		kp->folios_pa[kp->nr_folios++] = mmu->pgd_phys;
+	}
+
+	if (mmu->pgt) {
+		ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
+		if (ret) {
+			kvm_kho_folios_unpreserve(kp);
+			return ret;
+		}
+	}
+
+	kvm->kho_folios = kp;
+	KHOSER_STORE_PTR(ser->kho_folios, kp);
+#endif
 	return 0;
 }
 
@@ -36,6 +122,10 @@ int kvm_arch_vm_luo_retrieve(struct kvm *kvm, struct kvm_luo_ser *ser)
 
 void kvm_arch_vm_luo_unpreserve(struct kvm *kvm, struct kvm_luo_ser *ser)
 {
+#ifdef CONFIG_KVM_CARETAKER
+	if (kvm)
+		kvm->caretaker_vm = NULL;
+#endif
 }
 
 void kvm_arch_vm_luo_finish(struct kvm_luo_ser *ser)
@@ -119,6 +209,17 @@ int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
 	kfree(indices);
 
 	KHOSER_STORE_PTR(ser->arch_state, state);
+
+	if (ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) {
+		int ret = arm64_kvm_caretaker_preserve(vcpu, ser);
+
+		if (ret) {
+			kho_unpreserve_free(state);
+			ser->arch_state.phys = 0;
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -186,6 +287,7 @@ int kvm_arch_vcpu_luo_retrieve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
 
 void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser)
 {
+	arm64_kvm_caretaker_unpreserve(ser);
 	if (ser->arch_state.phys) {
 		kho_unpreserve_free(phys_to_virt(ser->arch_state.phys));
 		ser->arch_state.phys = 0;
@@ -194,6 +296,7 @@ void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser)
 
 void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser)
 {
+	arm64_kvm_caretaker_finish(ser);
 	if (ser->arch_state.phys) {
 		kho_restore_free(phys_to_virt(ser->arch_state.phys));
 		ser->arch_state.phys = 0;
-- 
2.55.0.1082.g2b9226bbc0-goog



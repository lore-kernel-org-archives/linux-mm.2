Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06692C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28876B009F; Sun, 20 Sep 2026 15:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF496B00A0; Sun, 20 Sep 2026 15:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEDDF6B00A1; Sun, 20 Sep 2026 15:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 771286B009F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE10C1204DF
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:44 +0000 (UTC)
X-FDA: 85235150448.12.F1EF24E
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC98F40002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AXb6kiWf;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933062;
	b=JF0Ikt3zXhKHyQGT6be6R2bw9mI2IVo4wwFaQrcOUSnqKqxYKlSv6CJYZiJ75prmRb//HX
	8UdnmvOZ4Gp1CfnhYQF+QvCSgAmX1il8QPdMxXrO9I6jduideTfCRqVjB/vn6/8mfvc7sk
	5DP2tqath9LZFYPFhIvI/oxXWj5JE8A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AXb6kiWf;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LP9MAkgaZIZB/G//n4eIZm11yhyh4okaQRNwKZew5U0=;
	b=khVKa83uHtnGo4o5nOq0sOyBW/MAaf2ptcCj4G5Fb/VJLjwNNPj/58it4Pk9F9t5Db4waz
	V4qb5/zqGCRLrcxSqUU93oMhuLM8x+0ia/SV5Hd/ltXuQNSjBNayaBMB9PwLeXy19oQvzI
	luRdRuz0KVRaqhwP2IJYjV7wgCd0dzo=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aac929eso2018947d50.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933062; x=1790537862; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LP9MAkgaZIZB/G//n4eIZm11yhyh4okaQRNwKZew5U0=;
        b=AXb6kiWffYHKaTx5nC9p3Wdhvd9omggxv2pY8h9m3Yyq8jSPaNdshWDJcbDwYuL57S
         xS7twt4DgelJN2LpuFiPuwASkOkkmZuSNXyJHD7VnsSAVSi4MsuhuyMrDu/AvEdAwinQ
         JOAKcVBABp239H4EmDIIMgSxBcBxkIMBf97a6Jjj3YC6Kik0eY3UCjnM6WBh1h37zUZ4
         ++LUwOiURsTbk6IzYGZXOtt9uhv1ve8WTWSuqV5GQBXH0yhK40SpoLWffAcIxHHYwuiR
         M9nVR4id59gCVV11AcGnjwR5EyQNns0XGobugrlYAMFkACdoGzTk1qskBhjn2eIc7id3
         SBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933062; x=1790537862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LP9MAkgaZIZB/G//n4eIZm11yhyh4okaQRNwKZew5U0=;
        b=Bn+g74Qzx+pX3XSi/kIl8CZbNMHeTYlN+R8buBuCnwKOGr+jWWLzlgoeBxWDAAZODR
         SZecv/6fQ9mfANnara6MNgUQfM59trech/6ouMxVZMialKXjeJ7zJGKaVJw5tKW3zhWF
         vQhGxDkg3K/dGaGHuxSN+xnZqpLmK2znfLrxUo38nIyYTchcPVvJjqZXCwRYOPJGOm+P
         PH577uccJdlFNX3t/7LWz/DOuDJOlM8Hl+xRtuh1/+F7QxRwqnIC7A9PQIy8n1j5PVlk
         ChyhuU99ex8Gf95gimBgfosxDkzhLnDIRBv2RD8TJ4mRs8hYOd9uU0Q2Xi1uVS9I9f4l
         ALXA==
X-Forwarded-Encrypted: i=1; AKwUvByhhU3Ksj4OoLVWqx5qqnBHLv7iWsI041n/i7NEqRVOpafjU1w6z6BbIBNdk/y8IfS0TDasNvJr6g==@kvack.org
X-Gm-Message-State: AFuF++nXsXpH0KcP4IvneWAkt+pXaWOX5yi+MwnlHDKqiENleToEnnEA
	hN4tXRPwQC6SUQZAtM4T6zboi/YQ++W9EKdoMjeV7EF6U0coH+ODV2FzBpTMQIyH87k=
X-Gm-Gg: AYBFou2a8wUxnyV6MfqEcyAhBfNSNZwZzcwEjmQOPjOV4ld8t9Zkbx+PG2Fs22XAMQT
	7Zftop5R2Ge8QxxwHBq9NawvfVISAs/qYUv38n7hrhnCSmsifwiaWWy/ryTtCpRWJVaktGs1I1d
	1R0M1TxzQA+8qXC6dddtjG179fHXouIwbb2gOBOtaP1TIZTBQ3wEY5QFppVJR076LdYG1h+I0J2
	GNzZdM/zU58gziroBOFjIi6tSMaxxLWQOK7opHmnPb5U5k7UAvz/HjF4udcpeEDA0g+ETEOaI2G
	/fmgQdw5FyBeWPzV20o9QW2x11cJfTXNOSx+wqowU08JqD4fFvAuedHoIj+Sf85w5remKNkOIOs
	q/o4sM68MePQ4m+UqOypSEEsftpmUfb/SXaVXxsSzbIdFQQtwkNJoZVdAbGwJ6yQdCA9bLk2qcD
	A2QJ35eAvdfIy0A2YP8dSR7xzVaXtXp9ugubcqYF/SrkAoPf232BBTmV9Jl9zcuBR+7HeAL/WSZ
	dm02qDl2J7ARHrEXZi5Tglh8/yBqi2Lks41V4coFKD/sQEnLJdvKS2PDeTzWTTD9Uqh0tMnJneU
	qxDKIICyk5vBoIBK7TkV
X-Received: by 2002:a05:690e:128f:b0:668:8dc0:bcc3 with SMTP id 956f58d0204a3-6717fadb1fcmr2667214d50.0.1789933061983;
        Sun, 20 Sep 2026 12:37:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a489aef57sm18632047b3.43.2026.09.20.12.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:41 -0700 (PDT)
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
Subject: [RFC PATCH 08/46] KVM: x86: Add x86 vCPU LUO preservation ABI and register helpers
Date: Sun, 20 Sep 2026 15:36:12 -0400
Message-ID: <20260920193650.3373435-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC98F40002
X-Rspam-User: 
X-Stat-Signature: 3kbwnbag3t8wauam3hphfrwm3s1octgd
X-HE-Tag: 1789933062-422554
X-HE-Meta: U2FsdGVkX18lr1+gcUr3AbCK9i1ES1ijALY+baZI9+pdxfRE0q0WmfbeTkWxmbRVaqxCJ4+pyZRZMr7vilhF2q9XD6bTQMgrGkMoERwp+H1R4DICyWLpNqFmNdSdV8HsEkuns2zy+Fq8tsqB4EU1hyl8da2u02nfEt/gviqywk1qJbnae5x6vyp2q+6FZ04aluAYAHuT+jH9mZBspveusM5cdme+E8rNvUZfE7mVoYaovtnQTjOAlMTt7tAKlOwz3k3xymnjDSFai3LizuTp5HL+znIBiTZnJiSVtKZ876yYk2c75ZELON6VKDJuhIafWBYPLnZZCYRQz5RBb4EaXyggIqufVePorP+GCuLAwvJEHjDbUG1P+i7d3bJMtiFwVPNX8y7aOTFFNM/vTn4KUT9+TU2wQWkC4xyAT/uL+Cs9+kd5TIrLtzcjujJMqx6JytdTT5RHDMEPfRrTBLa2AWSbMd65CHwSruPZLhFuwuBIyPn6Nad8anATyxZbP3MQ5hxtkAyb1dQDZA1u1Y2jCXMNx/fgXeqjrqHkiKi0EfTyISKZ/0z5b7PqOj0WHBmw3eHp9WqrhLnEQXAV2NliRBpRjCFVNNTSS/EWJwzuBFmX0HVXsmFEalqFifFjJWBK58aAeH17zP5Zob93Byvr0DtaipQfigkqQN/UF+XggEBF9GMAp8hsjw/tl0CsY5RsjxNhLuKVizAGwdly72Gj/7SXl1CnMRcHhlWoZ5vVxFTQrUKFetTsQMxfYkMT9ENhRsFjyisC9RMA8zrodJ2OxxpbBiENgiH1NZy/M3g/rwBEz1ok3mOgaSOZrtB7ijRJc/sgGnBoS8rADj0PYgGnx0BMRuIEcBwtPPZZYTUV5K7o0dAnszDg8sS276Lh7xVFPu+B9+Xa7pDUkk4z+dlyTIkXs0X7AWP62oF4HJKfuHdoAyJN9ltFsgeaHrdf/fBYAQG/8uiuf8glOxguxCy
 m6TYfvUk
 1ZHRPYG1YQuaLtYSB8KUZaBgbUriJZvcBXzFjZAqONU3YXkj0Pfscv/EnsAYYzZcs5hc4XDBk6CvfUOeAWrt/rQRb5tea1Hz2UlevSQiFYLy7dilv7q9tt7E+TRNywobtu7JtR9Q9GD50o6/9Nje4HTCFZYP3hOeUsJRxC8Th5iqfRgfPRpwINoJWpQEI0VnKJ+rGSJfZ7vFl5opih0/zBPcEO1w3GGg7hPfmBfy76ywOcD/CrvmrCMbs1kxyByeXIEkzNOPx+gXbHwZRD+b23/17wDrI/mWxVQCqO1sveBSTTN6RdFSvaFUDTmXq0mTVCrBqc6Y0mXfBg5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add struct kvm_vcpu_arch_ser in include/linux/kho/abi/kvm_x86.h
and export x86 register and MSR access helpers for LUO state save/restore.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/cpuid.c            |  4 +-
 arch/x86/kvm/cpuid.h            |  1 +
 arch/x86/kvm/msrs.c             | 15 ++++++
 arch/x86/kvm/msrs.h             |  2 +
 arch/x86/kvm/regs.c             |  8 ++--
 arch/x86/kvm/regs.h             |  4 ++
 arch/x86/kvm/x86.c              |  8 ++--
 arch/x86/kvm/x86.h              |  4 ++
 include/linux/kho/abi/kvm_x86.h | 84 +++++++++++++++++++++++++++++++++
 9 files changed, 120 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/kho/abi/kvm_x86.h

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 851f151efb35..5aba16e0610b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -507,8 +507,8 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 }
 
-static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
-                        int nent)
+int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+		  int nent)
 {
 	u32 vcpu_caps[NR_KVM_CPU_CAPS];
 	int r;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8d863f45585d..e5ec112d39cc 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -21,6 +21,7 @@ static inline void kvm_finalize_cpu_caps(void)
 }
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
+int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
 					       int nent, u32 function, u64 index);
 /*
diff --git a/arch/x86/kvm/msrs.c b/arch/x86/kvm/msrs.c
index dd3bb04878ca..ae849e0b7d14 100644
--- a/arch/x86/kvm/msrs.c
+++ b/arch/x86/kvm/msrs.c
@@ -339,6 +339,21 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
 			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
 static unsigned int num_msr_based_features;
 
+unsigned int kvm_num_msrs_to_save(void)
+{
+	return num_msrs_to_save + num_emulated_msrs;
+}
+
+u32 kvm_get_msr_to_save_index(unsigned int i)
+{
+	if (i < num_msrs_to_save)
+		return msrs_to_save[i];
+	i -= num_msrs_to_save;
+	if (i < num_emulated_msrs)
+		return emulated_msrs[i];
+	return 0;
+}
+
 int kvm_get_msr_index_list(struct kvm_msr_list __user *user_msr_list)
 {
 	struct kvm_msr_list msr_list;
diff --git a/arch/x86/kvm/msrs.h b/arch/x86/kvm/msrs.h
index 7cc182a15b3b..3a5e39041d99 100644
--- a/arch/x86/kvm/msrs.h
+++ b/arch/x86/kvm/msrs.h
@@ -65,6 +65,8 @@ int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
+unsigned int kvm_num_msrs_to_save(void);
+u32 kvm_get_msr_to_save_index(unsigned int i);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_rdmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/regs.c b/arch/x86/kvm/regs.c
index 8f66438989e4..02f041c355cc 100644
--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -51,7 +51,7 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_rflags);
 
-static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
 		/*
@@ -99,7 +99,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
-static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = true;
 	vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
@@ -498,7 +498,7 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->apic_base = vcpu->arch.apic_base;
 }
 
-static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	__get_sregs_common(vcpu, sregs);
 
@@ -635,7 +635,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	return 0;
 }
 
-static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	int pending_vec, max_bits;
 	int mmu_reset_needed = 0;
diff --git a/arch/x86/kvm/regs.h b/arch/x86/kvm/regs.h
index 447f0ec3e63e..40947b1be404 100644
--- a/arch/x86/kvm/regs.h
+++ b/arch/x86/kvm/regs.h
@@ -517,5 +517,9 @@ int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 				     struct kvm_debugregs *dbgregs);
 
+void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs);
+int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79468ddfe473..69e0d67a309b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2959,8 +2959,8 @@ void kvm_handle_exception_payload_quirk(struct kvm_vcpu *vcpu)
 		kvm_deliver_exception_payload(vcpu, ex);
 }
 
-static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
-					       struct kvm_vcpu_events *events)
+void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
+					struct kvm_vcpu_events *events)
 {
 	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
 
@@ -3028,8 +3028,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	}
 }
 
-static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
-					      struct kvm_vcpu_events *events)
+int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
+				       struct kvm_vcpu_events *events)
 {
 	if (events->flags & ~(KVM_VCPUEVENT_VALID_NMI_PENDING
 			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 0f5919b092e4..936ee660ccec 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -492,6 +492,10 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
 int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
+void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
+					struct kvm_vcpu_events *events);
+int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
+				       struct kvm_vcpu_events *events);
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
 int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 
diff --git a/include/linux/kho/abi/kvm_x86.h b/include/linux/kho/abi/kvm_x86.h
new file mode 100644
index 000000000000..316250482db5
--- /dev/null
+++ b/include/linux/kho/abi/kvm_x86.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_KHO_ABI_KVM_X86_H
+#define _LINUX_KHO_ABI_KVM_X86_H
+
+#ifdef CONFIG_X86_64
+
+#include <linux/build_bug.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/kho/abi/kvm.h>
+#include <uapi/linux/kvm.h>
+#include <uapi/asm/kvm.h>
+
+/**
+ * DOC: x86 KVM Live Update ABI
+ *
+ * x86 KVM uses the ABI defined below for preserving architectural VM and vCPU
+ * state across a kexec reboot using LUO.
+ *
+ * The vCPU-level architectural state contains the compact register sets and
+ * CPUID table for each vCPU.
+ *
+ * All sub-structures (struct kvm_regs, struct kvm_sregs, struct kvm_mp_state,
+ * struct kvm_cpuid_entry2) are uAPI contracts.
+ */
+
+/**
+ * struct kvm_vcpu_arch_ser - Preserved x86 architectural vCPU state in RAM.
+ * @regs:          General-purpose registers (uAPI struct kvm_regs).
+ * @sregs:         Segment and control registers (uAPI struct kvm_sregs).
+ * @mp_state:      Multiprocessor state (uAPI struct kvm_mp_state).
+ * @pad:           Padding to maintain 64-bit alignment after mp_state.
+ * @xcrs:          Extended control registers including XCR0 (uAPI struct kvm_xcrs).
+ * @lapic:         In-kernel local APIC register state (uAPI struct kvm_lapic_state).
+ * @pad_xsave:     Padding that aligns @xsave to 64 bytes; see the static_assert
+ *                 below.  Must be zero.
+ * @xsave:         Extended processor state (uAPI struct kvm_xsave).  This is the
+ *                 only copy of the guest FPU state; there is no kvm_fpu twin.
+ * @events:        vCPU exception, interrupt, NMI and SMI events (uAPI struct kvm_vcpu_events).
+ * @debugregs:     Hardware debug registers DR0-DR7 (uAPI struct kvm_debugregs).
+ * @num_msrs:      Number of valid MSR entries in msrs.
+ * @cpuid_nent:    Number of valid CPUID entries immediately following msrs[num_msrs].
+ * @msrs:          Array of preserved architectural and paravirtual MSR entries,
+ *                 followed by @cpuid_nent struct kvm_cpuid_entry2 entries.
+ */
+struct kvm_vcpu_arch_ser {
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct kvm_mp_state mp_state;
+	u32 pad;
+	struct kvm_xcrs xcrs;
+	struct kvm_lapic_state lapic;
+	u8 pad_xsave[40];
+	struct kvm_xsave xsave;
+	struct kvm_vcpu_events events;
+	struct kvm_debugregs debugregs;
+	u32 num_msrs;
+	u32 cpuid_nent;
+	struct kvm_msr_entry msrs[];
+} __packed;
+
+static_assert(offsetof(struct kvm_vcpu_arch_ser, msrs) % sizeof(u64) == 0,
+	      "msrs must be 64-bit aligned");
+
+/*
+ * @xsave must be a legal XSAVE destination.  The structure is __packed, so
+ * without @pad_xsave the member lands at offset 1880, which is not even
+ * 16-byte aligned, and the XSAVE/XRSTOR family faults on anything less than
+ * 64.  The allocation itself is fine: kho_alloc_preserve() returns a folio
+ * address, so the base is page aligned.
+ *
+ * If this assert fires, a member above @xsave changed size; adjust
+ * @pad_xsave rather than deleting the assert.
+ */
+static_assert(offsetof(struct kvm_vcpu_arch_ser, xsave) % 64 == 0,
+	      "xsave must be 64-byte aligned to be XSAVE-able in place");
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _LINUX_KHO_ABI_KVM_X86_H */
-- 
2.55.0.1082.g2b9226bbc0-goog



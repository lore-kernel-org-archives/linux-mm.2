Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C951C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996748E000F; Wed, 23 Jul 2025 06:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9481A8E0001; Wed, 23 Jul 2025 06:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80EBD8E000F; Wed, 23 Jul 2025 06:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8468E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 107C312FE34
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:31 +0000 (UTC)
X-FDA: 83695203102.18.F087A8B
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23F10140005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hthdcV6Y;
	spf=pass (imf26.hostedemail.com: domain of 3v72AaAUKCIg5mnnms00sxq.o0yxuz69-yyw7mow.03s@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3v72AaAUKCIg5mnnms00sxq.o0yxuz69-yyw7mow.03s@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dI/U/oYHl7SbTRHchHRnd9Afhfi1zSevTkWSx2K0gQ4=;
	b=QjiKr3Kv9B7LXpn8nybvdRY7JjAvIU3Ma1HmS3LjKgBIgsZbWfFlCz5GMidmuVQezIO9GM
	ZGpW+cE805nrtm0rU/gy8gMV93AQdWJ3SkukczUnpWMUkU0PdBaf1JPFr7ZKZkgv4Ek6o1
	CdFM39uowHrdu2vBfOoU/FqOnHa46ns=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hthdcV6Y;
	spf=pass (imf26.hostedemail.com: domain of 3v72AaAUKCIg5mnnms00sxq.o0yxuz69-yyw7mow.03s@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3v72AaAUKCIg5mnnms00sxq.o0yxuz69-yyw7mow.03s@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267649; a=rsa-sha256;
	cv=none;
	b=1H6hJrqdl7NVWgZ46Iy7LIChX1Qcz3anGYsjPQXpoaA+fvodqBOMArmW2XpUWQkktKRk44
	NabT8cmaXQRKm9Yzn4FPpG6GnUrCKVaO28I9f+RMohCRucbVwi469JDEE6fPm3ScYdoaWr
	QnyhjCYqcB4n8IWrxgTWlwdO9/NMiBs=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45626532e27so43561315e9.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267648; x=1753872448; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dI/U/oYHl7SbTRHchHRnd9Afhfi1zSevTkWSx2K0gQ4=;
        b=hthdcV6YAyAeJ1vL0AJvmweUF1X0vQoaI/F5L7oTwEx9Ylk4oQEN8P7DL7zIC4RfIh
         r3H536GdI2OuwObbsA1cQ+Ip4aiM6oRYfWmmoRwX/yXcOVMAZ2/0SCCh/bZAvYXxGpwK
         cAa0Y0NP/G2aG39EYH3LmVZQLGay/J9mNRF1cODJfAHBM9VNL6+dHMWkzRhV0Kw72GdN
         /3sMI0Npne2LGZsqlTUBdNXge4hpoHEB0RdGBv4qU8MY91jZUNVEhwb0IFTN+1E75H6O
         +bAexzhQhDGZSaiAmnWE1K5QVeH0sCmU+kN0sAU2TWQ0cF+IEEi8W0Ei2bMiNK9m/JLX
         HjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267648; x=1753872448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dI/U/oYHl7SbTRHchHRnd9Afhfi1zSevTkWSx2K0gQ4=;
        b=BxGiB3a46U+83tSrKF4fLYB4HZhc9SGnkwhCQCRL4N0ZUGEyQBGwD6f+1wgcJ/BrEL
         klC8MM/pT6kQfOJ7FpUJVFAFixn5xAVpJnk7qlAqmoPhQ3hp5QRnDZ27yKoVHvrcAwZR
         GfD6NdViTGhqeqBA09zV89LwCbDqmEtziKAZdNkosUG95wuG8ZfAZHzsApF8GVolO6mk
         dCOT1u+Q+brvatbUBCkVv2JNP9wxPSu3+irlezXmOAflR9+RbVLUE+UIh44c6gjWJBie
         U3rz5iz4g+LD1jFSUiZNFIrPX/rj6IVnKM0KBoKlRPb90p2lB9tEUw6el1ZgV4uB/v3X
         VXUw==
X-Forwarded-Encrypted: i=1; AJvYcCV+1/991his6QljRlDnKnSxvzAEmuOc2S6eqQPJjEbjK9pccl91CIPyo8gDlFQEIcWxh9HSq01wXw==@kvack.org
X-Gm-Message-State: AOJu0YwphrqCWGNnQYQL2Qrn55WPPueRJjaifkbRjLniB+1PM82JesND
	5oHepHnLzk65vUFAQqGt/JJwusOEjCtdNwBrEmS+hks8LrEg5HvZa47uNgxgpSryn6sYQkinFBH
	IYw==
X-Google-Smtp-Source: AGHT+IE5kMPT15Ys/YoF5vwgUSyGywBq26LqsO4J0CU4uOx7gmv90cAgxkZpKsQ661FH6hYUa8/7X7SiFA==
X-Received: from wmbei27.prod.google.com ([2002:a05:600c:3f1b:b0:456:1b6f:c878])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c2a:b0:44b:eb56:1d48
 with SMTP id 5b1f17b1804b1-45868c91ac6mr20390065e9.4.1753267647419; Wed, 23
 Jul 2025 03:47:27 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:04 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-13-tabba@google.com>
Subject: [PATCH v16 12/22] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 23F10140005
X-Rspamd-Server: rspam06
X-Stat-Signature: gd1kn44ptac6qouy65cw3jn5czqieioa
X-HE-Tag: 1753267648-476378
X-HE-Meta: U2FsdGVkX18UPL/86Ffn1ZQYyvAeKM4bhj5Azl71urka6qQdjUZJcrJjp85h5kkochW1S26DEpOssjSI+ZSCrgmUndhXR0sIJPHXE3itYeC5lEfsm6rNjSz7EwSQYtAFGwF9Ba5CiM+GPsVmArn6D+O3WvmAW9rL1SnE85yYVISBZdU31VD3PvbfBUtoAH+xAW5CqFSyS7dvg26ZhUWWgBn13H9s5sJFOS95RUM1zOUt1J/Bd0oyYFJGamouqfxXGiQBNFhJfTLlrWJCehwNGiC3C5ppMRi9PzOY7cetKz6/AENMTzExaa+EosuUuzRbH8vRqSKxsQZehCOJzIwvYcYwcbuPT2pGycCXYiJFbQ5ermphT+dxXCSUGFUGHBkRe1zpQt+EQlK2Wxitl3N5W7S+i6KI98goMZC5O1c1tIpTnOv/+qb9zxmvNcaXTk521fQoUpH+RchnJuRcvFjd1Qg016qgiWNIvUIpi5KuY8ZbHC3mjWv431bKgy8PWbBkXeW5EBuMQKiOblBLr96tfDOi2dhkODv34md13C1kwiL82EcjFAJRyL/+GQYYF24wbOmFrNIFm0O+a6umd0v+SBcOqWNdNbBiAuvcDJVAnUdoOB+1VHtxaeJEQ0MGcoM0T55LlXH0ZmhFAHlxX89xza51oTy70OBBe64s9clcok5OjkPlva2hAEqMTCTNU1WQCKDATkv6bS5A8RThiKi1TG5Q+ZQTvWMcI/eG6KTH+M19WQZzs5Xsh9bh9L0Bz9CRExNZVtGfHohOhLVhk0J0Uw7J0YqB+hcqF0qr+Ckx8XanHSwffESu9qu7k2/Eh/0weizFiDMfG4/mYtBz0dz7G62jdMrcaVARKh2XRO5Ra+TdTQlwcjx+UbSn6QwRIgoYlUshiw69/Ri5ZQuedbk2tWYeawBxtdX/DBe21wKrUj08kNVLtzHhFNPPq6zzAuas67ikdBQmeE2RxVomfPq
 m4Q8+oVT
 nH7Gfn7yy8vAwEWfSl8WQ8CZnWLQ6BL6FXteKzdnH5zgNta9vOhWwuuue8XANMTxrf4NoUF2g3EbVo8TjjiROsy1GxJPcTSgDelLNumJdmkq0R+0NVwjacCb/1Jf/wknU4uJFDENpe3Ckg0AgbLY0kq7QGNllRSMqBA5Nj6H/5+P5hWK60Kgd3hPUzF6J8gAe9K6+1LxapBSKvUCNvsZsHf6w9t9MO0H4y2VHI/GEDfHKipZptK/jRftqGfi7ERHC92lJ4FTkH8EmkhL/MY97550dR9j22+MFscUX+GikxR8HHaC73Oo8r8+6Bl9RbD22PBJtYxQ/mTEmRaqDqeAUISYVwBEY5dmvxi1OZzi/ktFWNBBbFOeImT2soQXtdx+hd1NG1FtpaeTDb4rpfVhfvmXHXm9SP67NjdcquqRKfwLhMZBykyBA2warPm4Fpltom2Z6xU1HM9ITgQONmYAZR1lsT+g+Ye1Caqut31CzOe7ZmzpfjRa3A26UpapKwnCeaDvKX18Xb7pl1sH8zJm9hSBVdKZ1eH7U5jErJktid68ls9ZUZVaXceHvIfCZqKNCGVo5PrFibjOqeIdc2GoG1L1edOFOjWOBDHAsp56Bs7sm9QPrfu5+EcTxFAQU/G7CR1nydQejw0eOdR2X8NdvsRMzYC5JcGIuoEnoNes8On0LtdpmfpzkkWgPGLTLtrSYsw55
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
in anticipation of extending guest_memfd support to non-private memory.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/mmu/mmu.c             | 2 +-
 arch/x86/kvm/svm/sev.c             | 2 +-
 arch/x86/kvm/svm/svm.c             | 2 +-
 arch/x86/kvm/svm/svm.h             | 4 ++--
 arch/x86/kvm/vmx/main.c            | 6 +++---
 arch/x86/kvm/vmx/tdx.c             | 2 +-
 arch/x86/kvm/vmx/x86_ops.h         | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 18a5c3119e1a..62c3e4de3303 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -145,7 +145,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
-KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
+KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50366a1ca192..c0a739bf3829 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdc2824755ee..b735611e8fcd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4532,7 +4532,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7744c210f947..be1c80d79331 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..8a66e2e985a4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5180,7 +5180,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
-	.private_max_mapping_level = sev_private_max_mapping_level,
+	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..d84a83ae18a1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..dd7687ef7e2d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -831,10 +831,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	if (is_td(kvm))
-		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, pfn);
 
 	return 0;
 }
@@ -1005,7 +1005,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
+	.gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 573d6f7d1694..0d84fe0d2be4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3338,7 +3338,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return PG_LEVEL_4K;
 }
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2b3424f638db..6037d1708485 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.1.470.g6ba607880d-goog



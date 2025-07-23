Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED07C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA78C8E0012; Wed, 23 Jul 2025 06:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A580D8E0001; Wed, 23 Jul 2025 06:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA738E0012; Wed, 23 Jul 2025 06:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AACE8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 409B7BA593
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:34 +0000 (UTC)
X-FDA: 83695203228.26.28C5096
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 60D2F140005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0YrtzNt1;
	spf=pass (imf23.hostedemail.com: domain of 3wr2AaAUKCIs8pqqpv33v0t.r310x29C-11zAprz.36v@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3wr2AaAUKCIs8pqqpv33v0t.r310x29C-11zAprz.36v@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ew3dVk5+ay5qzekeBZl+5uhpvVmEbTs/qm55dG7cn/M=;
	b=mkeTL/MozwLV2zDMEPzz3rcThrfFAme7MERFG3ih407+6l6pw7mtG0XZxxood+7Kgt6JHr
	s6yISR70AtsxXpF3UR+VuVDNLbta4deb44OJYBziWtOAMoQhDNLSeiS4LMefdjrz/n6hR7
	p8Fvl8EqdPeBzjInvsp7KPvmOMC2ls8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0YrtzNt1;
	spf=pass (imf23.hostedemail.com: domain of 3wr2AaAUKCIs8pqqpv33v0t.r310x29C-11zAprz.36v@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3wr2AaAUKCIs8pqqpv33v0t.r310x29C-11zAprz.36v@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267652; a=rsa-sha256;
	cv=none;
	b=urdEVKuw4BzlMSrmjJQHFhzp6lRS07YZkMe0AdhHR3JXNAhOMBPpBIyFuEWqFYv/cejwIM
	7PDuBfB5iB1yCdIywvjrS5AgnLXO+h9FOcS9Dns3FIJSDfpKWAkqee3X8rfjkrH2oDZt7C
	6cpdrUPwHXPyfutcEXIKBkXV7BKRlio=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so3760032f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267651; x=1753872451; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ew3dVk5+ay5qzekeBZl+5uhpvVmEbTs/qm55dG7cn/M=;
        b=0YrtzNt1fRo/WeHpCESP8eIxcQSXrTBrtb4Rh+ekuQXwcmjlS2ZaF4HVR30H+JW3OI
         diiVh/iHqvq/oEoHiSm0wcysvhzyo6KKsp8q3sCgBRvYzYx4FAT1IYQlVXgNe6Vxmxs0
         4EZ7tnynJ6tTaaFRzH44/kplFJr9mFf826cFztaHV5fgoUaql4mBsCnteO9e5jmEiRxB
         HglWtzATLIZ7VfiBbuVr+fD3AC9sCIXuCmx41Ebk3CaH24IOutdimweIMKBojmkVUzao
         b48qjeQ4wxJjHzU6jzCmfdwRoIASVd0elR+JzeqHxnNp32oq4tsqerT0dKk/L40/EAyR
         pfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267651; x=1753872451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ew3dVk5+ay5qzekeBZl+5uhpvVmEbTs/qm55dG7cn/M=;
        b=ndtXspa7NLV8gpYy3frNSdUqFhRX4rg3oOjY/3gYF1OWXcSXhBCMmVuYVwcaogR6YU
         1qggC6NkiHQjN4pmiq3JAd1AUzhOOOBnAFl/xnxSqAwwjs5TMoxUA5kH7YjxJKc9UrI2
         r83AWOUW5QiH09SGLWqVG3bGqHSu40Tfux3LG0eEBRV1nVBk9aEMXEmZuQYu1mZiFInQ
         RH+sscMKWWDR36yTi3oge+xy/GgRYmFoI6kFcQ0BpRS+h+8/WYNHAJfPphWLQHCOCSjX
         l0bC0jgXv8rtWw6JJJ5T24kuMsiErpq0sJHAVvl6d0IhkV+yxAczdVKRJuB3d+lt5zDC
         605g==
X-Forwarded-Encrypted: i=1; AJvYcCVq8ZSiyoDTOaHkxhUH3nTS53tNxt9zvZW03uUbbosos0kIjrJgtaYUsDNpfYfb0MDe7qv3U5abPw==@kvack.org
X-Gm-Message-State: AOJu0YwRWufqXJfiEC68gM0JRob7kLuRqhIhUGvwFQctr4MeuUJojnJw
	z0LSZ2Rwn4Z0xeWCWA3aOizpTPkaIVjrDC629OisNNyzmr3fcEtRK6XS7/BaJ6Vhba3Dw16r5bQ
	INw==
X-Google-Smtp-Source: AGHT+IG5QM7+4yl5LSLpnYIEZUfkj7Qa6xIUOEe0hQKZQ77BuTEsaT+1bAcGhHUv94wQAK7RvfJxA+CrMg==
X-Received: from wmbdv7.prod.google.com ([2002:a05:600c:6207:b0:456:365f:4281])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:430d:b0:3b6:176c:2a13
 with SMTP id ffacd0b85a97d-3b768ee09c6mr1798667f8f.15.1753267650882; Wed, 23
 Jul 2025 03:47:30 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:07 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-16-tabba@google.com>
Subject: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
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
X-Rspamd-Queue-Id: 60D2F140005
X-Rspamd-Server: rspam06
X-Stat-Signature: g14qo7t8yxehgna7s1notgedfu7j4q13
X-HE-Tag: 1753267652-204874
X-HE-Meta: U2FsdGVkX18cwsoHsxWJtl1rOemfEYA1QCZoOnoIM8JL0Vr3P54wYYovPcmK8nihRds2F+XuX78FNFZ12Tw96BmfKIy0M9Q8PZwaoilLBodOS6tyu8uw3ZmYQ3oWHIJVS64s61VYkF9bVTOaDIv9i8b/7dJvh54xmdScoacPiwa9BHY0zkpXtXbNaZYPbeD6SRvCNro04Fn2JbchEwcYLPZ5rB9BkiBBnsHyLeqZnA8QdSO/pVxGJHngSAbDrtaQDJ38Ro+H6bBhh0r3vUhnIi1ns22aUl9nrZt6MNjNH3V3lR3ILbj5I8az9+u4f1Cl89PhkfEd2TBUHRORb5G1/9Tb+yhe2F4PjhHN+3ZipzNBfZa67aT4ACoj9f+ytBPauiv4kXCJvloXzPi/Kv9YsLG/sMDK9FzumH9rrxGfOke9r7Gy21ZRmFsIcMNO7MNfMl4pAEkDtpoOsdpRXbFJ5iSb2ELRLLU6757j2Nc7DNKOQPsflISbg7TyI3CGUA7rDPEe7vyL5LZ2OY8huXXjot3KdMeHIO1faptlgryAulLkav3tkLMCaNKjj2r/OzmFUuH7jlavMSEVl2pvJFBWWS1jFRSP2UZUmCnXj059g9G+OwgQsUQmxs2V4ainq59GTUkQvRbpiCtp3kw5p2cbFqdhRbgOSg24o5IH7MTfpHighxLS3yodwyq0i8vfhmnBcjVY2BCJyEZn+6JjS9dY/E0mlIJW5nPZYwTXel94EQvwhK39PwbqE+zzZDi9eL/IN2twlKvQ8TrIN9V5k9K5xI06tj5TPSysoMP8WQxfyCyIEfRn2PhWJ/W89JpAkDSwpC3XM1x/OnxeC5tC+lkAoiaaeqKU4Y2oOPdF/yeVKDzEJut21zLhcd3kJQ+YmCjxnJswZWwFCzSDkG+aQ8zYNZ3Ow0QPhLe8pxAgeuHh4QqSA5S7V9y86G5uh3ssII1q3CUdzVzyAry86c4nfuH
 ybE2kMwZ
 KXdllaPMnFvVFWOdDNL/O8nnq5f7kwY4GJgk7DpIzcibKLffq+Tt2Z3bsJOC97kdvq1vqIMU42/CWqzJAKVkBwDhaEMJ5Fb+ZEkVRA3r5tYNOYXnOocP4A4SPILPh5iZwoqMkgPaq+0EVkM07fYBrFe+S56q1B3pgXVrjqlIkqeqDUnCy95+H80NyEndydBrHrAuJTlO1/bcb18xAGEnmiA6YvqwI6wDABCwi9tYhDkzus15k9rxA1S3E666S4bT6FSX2WkNwp/sXTx8Ouma6eUG8nFevrursDpD3tBbsIuSIHEJyfZ0NYJ28fgG3fE1LNmParyfbLFz/yUJfQsFjcfrU60N6PE9LREusS6Emw1zGdtkioC16kbKaPeDG5CS2eUk9RUDQdp6YVt7K9SoK19TBm2OQn0OIk5gAYEMGjBn+tpm7L1fh/DnGttAZoJtpoYiEIrShfSbotbX56nwD6+kqjZhgDNDah1Y240tImzV5uT6YqgBSnVx6lWNsFZovqePL1+nHgDGEXaSdY4W3agReNGFlOT86FkTcbb4VX0kiKMkbAJa984KBJrO50StTmMu+SimvG118ihPp9KVfC6I3nCQcI3poGarcEKognc2R5yTk69VC7jIgTERda3IBD8vjhGY9WNYcl9P/w5l5rZmhkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
not just private mappings, so that hugepage support plays nice with the
upcoming support for backing non-private memory with guest_memfd.

In addition to getting the max order from guest_memfd for gmem-only
memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
restrictions on page size only apply to Secure EPT mappings.  Do nothing
for SNP, as RMP restrictions apply to both private and shared memory.

Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++++++-------
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/main.c         |  5 +++--
 arch/x86/kvm/vmx/tdx.c          |  5 ++++-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 7 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c0a739bf3829..c56cc54d682a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6148cc96f7d4..57c18ab91646 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,12 +3302,13 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
-					const struct kvm_memory_slot *slot, gfn_t gfn)
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+				     const struct kvm_memory_slot *slot, gfn_t gfn,
+				     bool is_private)
 {
+	u8 max_level, coco_level;
 	struct page *page;
 	kvm_pfn_t pfn;
-	u8 max_level;
 
 	/* For faults, use the gmem information that was resolved earlier. */
 	if (fault) {
@@ -3331,8 +3332,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
 	if (max_level == PG_LEVEL_4K)
 		return max_level;
 
-	return min(max_level,
-		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
+	/*
+	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+	 * restrictions.  A return of '0' means "no additional restrictions", to
+	 * allow for using an optional "ret0" static call.
+	 */
+	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
+	if (coco_level)
+		max_level = min(max_level, coco_level);
+
+	return max_level;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
@@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	if (is_private)
-		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	if (is_private || kvm_memslot_is_gmem_only(slot))
+		host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
+							is_private);
 	else
 		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index be1c80d79331..807d4b70327a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d84a83ae18a1..70df7c6413cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dd7687ef7e2d..bb5f182f6788 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -831,10 +831,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+				     bool is_private)
 {
 	if (is_td(kvm))
-		return tdx_gmem_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, pfn, is_private);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0d84fe0d2be4..ff44f4bd76b5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3338,8 +3338,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
+	if (!is_private)
+		return 0;
+
 	return PG_LEVEL_4K;
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6037d1708485..4c70f56c57c8 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.1.470.g6ba607880d-goog



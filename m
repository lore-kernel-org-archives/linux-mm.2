Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B8BC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773AD8E0011; Wed, 23 Jul 2025 06:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD638E0001; Wed, 23 Jul 2025 06:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5298E0011; Wed, 23 Jul 2025 06:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 455318E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E362160605
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:33 +0000 (UTC)
X-FDA: 83695203186.25.17C9DC6
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F67D4000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z87c5oOW;
	spf=pass (imf27.hostedemail.com: domain of 3wb2AaAUKCIo7oppou22uzs.q20zw18B-00y9oqy.25u@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3wb2AaAUKCIo7oppou22uzs.q20zw18B-00y9oqy.25u@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNpw8dEYDgHm3c1x7JAg5Wcl6lEIP1F4CrB+GslJPCY=;
	b=wXJ+ryzHahGZS2feWIQW+rtCJj4Q8WAxdXcxWjf0gilw5IJKXIVz9bujjr6pgW3o50oBd2
	O4+/u/4kAA+o8rY8qZ9LR80IBwO1LeUwScy67Wj3zTpFeusDETIj2cqRqDizdkg6xmK195
	ojF7oKANAqAjIuqBsLvC1JsdF61njIM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z87c5oOW;
	spf=pass (imf27.hostedemail.com: domain of 3wb2AaAUKCIo7oppou22uzs.q20zw18B-00y9oqy.25u@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3wb2AaAUKCIo7oppou22uzs.q20zw18B-00y9oqy.25u@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267651; a=rsa-sha256;
	cv=none;
	b=UyBAaKALVkZBjBNHWlwQCEnC1JoQpOrwj+wRKbGfBnQzEj5tXzSEsjnY5JJht3+oJws+cH
	wOpxUs9oxzUo3mJxZUETKJraoAqG4TtrMadjdWYiKAr1gQeAIlNOf8ymcpuY0omE5YV2fd
	luydBIJMo8q3/IzW3oU9A98wEX3c8k8=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so3760010f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267650; x=1753872450; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kNpw8dEYDgHm3c1x7JAg5Wcl6lEIP1F4CrB+GslJPCY=;
        b=z87c5oOWHUI8wtyPdwIn3pr8ON0AHdmWi33HCkigA9ZD3RhaDdjoO4kNnHL+1MaykP
         nYOO+TSTecSAifJZoNh466N8ejrZYJadF3Z2aWeT0V2QB3sSoU3dVGWE1pVSliRXY/k3
         Mn4oEbx2ocrxiRKiD3CnPaEumzvFKuYMkPIlozJN17S34CHSSZFuBnfqdcRH1kKgZnwc
         q7/9Hhy9XBVCE91FnJv28OpAgqV5DdQatHpHX8ptVRMSv8moYzz25KGC1pu6NcOGIYXy
         4gD49jOx5QK2LHiubk6PXJ0RiTxFt/CZyRz9O7K/zXmb74qjgaxgsKF2ukZPMlZgW4eJ
         Qnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267650; x=1753872450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kNpw8dEYDgHm3c1x7JAg5Wcl6lEIP1F4CrB+GslJPCY=;
        b=egcFKilT6VQLLVKCwRdf7IfHmPSaqQA/JLzjYBFHfNOlor5jOrNvZiaN4+hwcJdXky
         e4xtk0QyN22rOu2emjjSp57VJTMUT5SG1nEHf4VZJA8CoTXQcJ45rjksLWL2UlCNmTXr
         bocHfgNwTHH8B9J7bvHsE3AAI1EDIXURykuSyu1xhJZQuhsJBSKjqbjMYX/30R9eF14r
         9hUrtMwuypwoJZ5qaL3h4dcHPP6J9hOuYVZUi3/jQsKzA3vNhh82KxwgnteCLWLvFM85
         I2vjgjrhYF6yrmsUQCisYnq5z9z1juqjxUGaCgRwu+m5waVHaxPX24V3zP9B2jQqS6Pz
         YM0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXC3ditEcLCAyfQDCOle93OchixRwbEV9ZsMZNtQUA5OpKWz56yL+n4cxrNALx3PST63SG/MDF7SQ==@kvack.org
X-Gm-Message-State: AOJu0YwGrwWdvJjxtr+D0bWEeDCkrVWsGy+QNt4DDNwNbPWjJM/WUY53
	oDK2eoRyB0UsDHdKP250N38oPiDBRAQMONXPEP6uJLYuFYIPRCEcxIFe8YAVXo1EK7UB8AKr71y
	jaw==
X-Google-Smtp-Source: AGHT+IGPjBKj+KAWv4XkFzcfTl/YRyCMWXzAl83SWfZSthKuLUV9vgxqxBfiL6V7YHmBDUBAbKathzOw8w==
X-Received: from wmqa3.prod.google.com ([2002:a05:600c:3483:b0:456:2817:b9ba])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d0f:0:b0:3b7:6716:12c5
 with SMTP id ffacd0b85a97d-3b768f2e272mr2065909f8f.54.1753267649660; Wed, 23
 Jul 2025 03:47:29 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:06 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-15-tabba@google.com>
Subject: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order when
 recovering hugepages
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
X-Stat-Signature: 3mzsbwh3tf1gntugtzjs6ywa7w63q5mz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F67D4000F
X-Rspam-User: 
X-HE-Tag: 1753267650-836286
X-HE-Meta: U2FsdGVkX1/sSE0hJNhZCg318bh/7MBDiggyMnOWLrTjdhTHk9S2pGugKLPOwz/xxmfZ+H3mLF/dQN+sL+0UDiT+Ne2yuIM3iX339bBG1LHP/F6pRbMQy7Pg77ssL6A8GdhvjXKQVfXc2i95o9RLxrkwCbk8P+GYYBD9tguedBLuCRZtDkK8JTPHa1eJp7Mdh/lDOouOTTQdZFbOg9umFM6KZhH7sNBt3xWfza31pWyRHVjKdxKyK8JRk3/ce4JzI0hSFRFndCyT+fOVLB3gPEIXFcehI2eGyOyBDg8qBPHPRdwz0qGbtWd8yNlwUQUYNC+7OdgSHNfM9IvXwUnHMM3a2iZbktUesxvozPBHk3LsaZL4LbqdmYI1yAVE0tRmnllO9vPezI7+bg7rP7Qc7BpXtBXs4YrQAjuARyj1EeQWtGSz70hqUbAZnudqqrwdJKA2VZ+8G2M07k5p+15RJyhAbgORbozwe6X3IlrocBgaun69rFMbyM9/fl2pYiyM+5q6b7GE3vScBcxz+780Uy57BjPN2/+fZot/3wk++T/JcYtlQL20NsUj9lf0dUKT6/YOZRsykpTxRczPwiyfYb9kvBXbXZDXiyI/VDnONsofbbmb8SdTAb+1z1jvYd1X87hQi43qGIuI+OU1/PaTgfEv+jHcJECR2qc3a9JjGULqMQgYhQ3SXqqYOdUguyMRw3gHkvRxtINCAgRHWDlnNt6xKu8+a9p0P8R9GDAGoz8nGd+lV9Rz0uNt8s3D+meXqxs7VpHpMU56qMb6fzLzd+kdbeg889KSx1oTMesxMMlOEo7M7J6I4g9snGBv2ddLLed+fsnDa+W1LIFMlkY/1PUsSX90Ra+Yx0NiYgZ6aZU++fJoidDZkUDY2Y0Dyx3zcIQ5tQ9hevn+q0pEgkU7CwffpiBvXGaqJ87FZ10OgcDCF/5h6hpPFZb4hpz5mSlFH78+H90naMxYTPflTPX
 8AmlSi1E
 OoPuj+uDoSmRQ1JXjZg9eqhVH8acqQpvQlIbvmIPS4OEsIe7r4/QYfcJqZeFLRkS7S7uTgymMCCSQV3qhXaJXdsxpxJFSpM49zOKt3CEetiLT4gGr32gyk5/YYPkbUbNYiMqFFduc1EZk3SgJVM1vXpGotiwlIbPffxWkF6R1ndm0vOVNrB0u37Co2YJlscTDnHpHlAjAucCSXuHE542sUUsq6lSSU+ECfZ69dfJrvoaSIy0Wwsl+FIDV1TVbQ8tUCH7Nu0U4V6sREnqvl5cH8lDPnxKMfx2XWLSfvrWsouQqcYK3iBxGxNYeGPxX4gOGFYf3rBSuK1Mctao2r/pITE294K/RDPAImxuDXnmYeY7sQkyhvrM5lEPeJrTKrC6GJKOfGd5+WnkCFtSCKlIidbiLvsuIraib2t7d01LcUy3/hI5mxMTXLBziYrj56SfkhS9j4/KVlPPJKqYjKrHw4skY3Ap2uAFb1MV5owkloVhMcCN7F9c2xOz3TKptvksf2uiYO1hWt43iCjEGxH2g3cbRfoaBZSE2hNzIv7jA/NqOKYe6idlCla16Kz81Ktqt1FNdDHIxz3jVAgWpe6ltI5yqnUYy+DczzMjqo8zEDRhJ5cLKFSAFDJnEnyRMs+PqjWqEPT0V/smrH/0oZUBF3BSQvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
vendor code when recovering hugepages, e.g. after disabling live migration.
The flaw has existed since guest_memfd was originally added, but has gone
unnoticed due to lack of guest_memfd hugepage support.

Get all information on-demand from the memslot and guest_memfd instance,
even though KVM could pull the pfn from the SPTE.  However, the max
order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
avoids adding a new gmem API, and avoids having to retrieve the pfn and
plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
consult the RMP).

Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
of the gfn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 83 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 20dd9f64156e..6148cc96f7d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,31 +3302,55 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+					const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	u8 req_max_level;
+	struct page *page;
+	kvm_pfn_t pfn;
+	u8 max_level;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+	/* For faults, use the gmem information that was resolved earlier. */
+	if (fault) {
+		pfn = fault->pfn;
+		max_level = fault->max_level;
+	} else {
+		/* TODO: Constify the guest_memfd chain. */
+		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
+		int max_order, r;
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
+		if (r)
+			return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+		if (page)
+			put_page(page);
 
-	return max_level;
+		max_level = kvm_max_level_for_order(max_order);
+	}
+
+	if (max_level == PG_LEVEL_4K)
+		return max_level;
+
+	return min(max_level,
+		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
 }
 
-static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
+	int host_level, max_level;
+	bool is_private;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (fault) {
+		max_level = fault->max_level;
+		is_private = fault->is_private;
+	} else {
+		max_level = PG_LEVEL_NUM;
+		is_private = kvm_mem_is_private(kvm, gfn);
+	}
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3335,25 +3359,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
-		return max_level;
-
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	if (is_private)
+		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	else
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	bool is_private = kvm_slot_has_gmem(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
-}
-
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3374,9 +3389,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						       fault->gfn, fault->max_level,
-						       fault->is_private);
+	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
+						     fault->slot, fault->gfn);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4564,8 +4578,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -7165,7 +7178,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct &&
-		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
+		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 65f3c89d7c5d..b776be783a2f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..740cb06accdb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.50.1.470.g6ba607880d-goog



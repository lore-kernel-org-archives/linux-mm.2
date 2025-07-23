Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53374C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7CA08E0013; Wed, 23 Jul 2025 06:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2CBF8E0001; Wed, 23 Jul 2025 06:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4D18E0013; Wed, 23 Jul 2025 06:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 948D38E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A6B48060A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:35 +0000 (UTC)
X-FDA: 83695203270.23.75F92E6
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7979840004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yEDrVLRV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3w72AaAUKCIw9qrrqw44w1u.s421y3AD-220Bqs0.47w@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3w72AaAUKCIw9qrrqw44w1u.s421y3AD-220Bqs0.47w@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+fLkfgL88h+tO0xVydb7iwa6WgvQBL+gdr0IXZFNkw=;
	b=eRgSPeW+GPfL2q91979W8WpwLtn0ssnb3ZQWHfWMQCjNKLgnjWGkXnggN5seZ0oJKvRvNj
	+m18EZq+UpnRvacRS2YVVg4wYyejDPcp7v25cByuYgjFti1LitbMOYZby3y5ieUUkZ97I0
	NEzDu62fRR7cFwb5Q5/0Ave8alH15rc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267653; a=rsa-sha256;
	cv=none;
	b=kxhfk2Hkxn0bgLp3gfLngO1mOiIdpSUwY2zk/tCnedvuh+BQzred75ELp0WHeME5tR0cFY
	tZAxLDcWynAntabLJF5P/2OAsnBcvirku1o/T4OAkECYms4rJTPjOkvAm+JlLj4vYT2PfC
	QdmDjlUdJHyg/GeQxw6i9dowxreCGLk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yEDrVLRV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3w72AaAUKCIw9qrrqw44w1u.s421y3AD-220Bqs0.47w@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3w72AaAUKCIw9qrrqw44w1u.s421y3AD-220Bqs0.47w@flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7691b297aso496074f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267652; x=1753872452; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z+fLkfgL88h+tO0xVydb7iwa6WgvQBL+gdr0IXZFNkw=;
        b=yEDrVLRVXlQ501UA4GfC8vQfUF5PEqqYT3PWUYo+crRAOuyxsBEfpLph7Lzk5Nky9Z
         cZQ8Js8dVcpCsGjFP/9foXdmVC0XwGd4y6y1yjsEpp8slAGplYcbAE/z+JX4WTkkYsBQ
         b072bBF4yRu4IlP6RokOdO1o8ktbGirbbS1saCqvQE7W64iOn9xvDr54ebUiDOqPQR/t
         x7n/Qdr6q67rN5dhq2aqnrxizqpRMNO5Iz8shlKyY9ZGKt25xFuILFVa60jpJh2GLREp
         ppJrQKXU/Osyhb3UAZNCQG5/AczUx3cYW/idHig3COKFYGGpjUfevoePPxmDKsXG6HzZ
         iHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267652; x=1753872452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+fLkfgL88h+tO0xVydb7iwa6WgvQBL+gdr0IXZFNkw=;
        b=KfLI+PurRNyvkR67YizPUClf46I0NXw0s4zDUBDwtKtKrQ6No28wRfD6A1dC+/e5nd
         GV4aThY9iwa1dQoLciw5HzhRhi//USHq9ZBsv+ZwrLDr/0fYFy63d5TNGJQF2EQdUvH1
         aiYlM57uWFbza1oKDyZfUXrX4aa5UVcqRF4pqmzyRYeaJ5aUNxc6u0/nUEJJKnthpdF2
         WXD//emaZkAMft9Pay/ujO2NkCiC8Z0fClZB3iaVtx0QbkWBHOsMcJ0xmMvhuKWoHEub
         X65Fa91Y9lQyTWAunAAl6OzDGyUi+8/BY1rGHIH2oDgR4E93TxM+IGY718CjDxJAzRpE
         Lo5A==
X-Forwarded-Encrypted: i=1; AJvYcCUijVY6UaKQNAMivV96HaoXDMUpSCZezeXhautdZiqCz+bx45Mg0ly/e1W3JM88uEQ4vjkZxWeEDg==@kvack.org
X-Gm-Message-State: AOJu0YwDsd80ytfK0+ndzWwZBxtJH2RPjXjh4r78VmoymjCas47q8UAd
	y8V35IKApVUd9eiqk0dyM4Q17yH/4N9KUl/4wndM+pk0LYlFCENvapfod3+tUvLCqSQrtgeddHU
	x9Q==
X-Google-Smtp-Source: AGHT+IGemjh4J5zgVNvMoUGimMIOmO7YayMaj0+Nw9hXSt0/vN3svhdizRtFAyZI1caMFRDiRP8hFB4biQ==
X-Received: from wrhs4.prod.google.com ([2002:adf:e004:0:b0:3b3:a665:e00e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:40da:b0:3b3:a6c2:1d1b
 with SMTP id ffacd0b85a97d-3b768ef3a79mr1949363f8f.28.1753267651964; Wed, 23
 Jul 2025 03:47:31 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:08 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-17-tabba@google.com>
Subject: [PATCH v16 16/22] KVM: arm64: Refactor user_mem_abort()
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
X-Stat-Signature: 7dzm7169gpnbxuxanhosy5hnuf5uazen
X-Rspamd-Queue-Id: 7979840004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753267653-433601
X-HE-Meta: U2FsdGVkX1+M9mLKD8KwUR/k1+iYbhFaVU+i3JRev7in+suX2qEkc9brUOPNa9BYFODh8GmvyCaZWhjQW7Yz8S8lYpcwdJ9jS9WMNyqz0A8G8cmy5bOWvhWtYWZ0cjSuMgys+oIES53IxaOXBfxU1vGyV/ETRrEiVBzb4+eMqPn87hq4z6hE2E4IDSerYE5aYOpcVdKW8ZrF9SePs1X6SMQqa0TxV1eIXDUYiS16U0a+PrFUd3YLApoKrnZw6vDasNmNtX1Jjc2PHcNQtvT/Ckpv5Rc4sXeb2oD4Wn8EJgtzUdXtmteSjv4L4+EVm1y5FJ16LWj3KUAuW4zfu4imqL4Xqo006Xs/gmv8iAOCkb1Z9ET2tGLnfSFKCy1KiexMS4cbYgmYLEsopE99U+0uNxQjERyVuScneQAVICerB1H5LsRGjRscJoU9DPZJvfe7567nWLFteltgKvlfLS6EnW+2LoCKubH9MAufAl6yJdoy3fiBhsNP2EBr5l4s9nXyqRYCslP3cuFY6sf5dk99IQM6V7D6wf2+cXEey9yGjRAPuvN1ZDME4/moxOsBHa4Q15AxZ/xhIaiUZ28uQ9KeyjSKVHy+FIGXnS0dQcFyUZ2IFTummPz8tCyT1Vwcq9GVjv5qsBO8vQnAVtqdGxJXAzQuW3jtdJkpIExVq3+FMu47r2Kv9TDcAeGSumfA0k4Xtk8x3YEmHN3AACYH1Bz4gaP6wflnDxgvlsH6fggsLiIT/nroWN0erIQ1XEHxyhTDmL+RzhIaXdRvurEdhb8dSa7o9kEEdXghSXxoDjsrJwP1GwAec3bDQv6Z2hlk2Xm5ioIyc7e7Nf+HR/HWjOkLDoAxUrLRWST9oJBw1e+TJvVtmZBmLZ1p73q0EswZHnKfpytWYzgqC+RB5xDQjCxVnlLNdqA9xdhyPgnLLE55T3hJH4OYLsykzpVq7SQqAVWQfjxj1ioqeTiRGYQcQyJ
 P7KQa5oB
 osI7Jhhb5S33SXN4ZSvQRBPVgELPx5B5xC31P/42hGYfsMcHH8IrZeo7f8pVapy8at3Y8UZS12yapySXkjZmyUjKbFhohW4fj8p3iX1Y1NiU/GXhf+hpBItHJoNovhpVCzF7RuPW1uI07ZzgyrDmJqu6CY1Ft71WtmFCrJD5jm44f4fsN+MF8wu2RKLO2Z6x98vbJUlSntzhoYBOnachLuS3NFhY3ryOGFXMEdkDuTir/giRNFKStp9PUygLnyqhg1fgrAu/XpI50qTXH9NW/+3S/dREBMo0HvaGlMjVN43PjaiuEy4vPbRuTGmEPxvl7sgh5isvR6GRxfeVhFcD8Td5vcKo15Ru7HNv8Jp0fR2xkL4m+o5SbTgPRkp2jRsB/SiTN5DRV0s5JOVYKPWXetVsBRK3NmORHBv4JOHAum3c+1NaPkr8qClDjN20SAv6/W0zZGv/POUMKvVE1UMSiUgYfZXOUfI6nz6bt6l7OYI01gqSw40sK6fFag3u+N+yWind9YEb3xJ8KgPLf2k+5xjXvh9e7R93QaP0dZQXNwRKmikkaJY2XKI+dsRgzSyURRVaxrGa10Tk1K+2zChmG8Z3w4p+EoGhtITKoXw2PHe6nftr03GT/5qTSxMZXEVEmdaaiZxgKCP7gC542ljasiqXCuv5h0i51z2Gc6AypAhQwC74yqkfcyx3FK7PkOqXv90K1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor user_mem_abort() to improve code clarity and simplify
assumptions within the function.

Key changes include:

* Immediately set force_pte to true at the beginning of the function if
  logging_active is true. This simplifies the flow and makes the
  condition for forcing a PTE more explicit.

* Remove the misleading comment stating that logging_active is
  guaranteed to never be true for VM_PFNMAP memslots, as this assertion
  is not entirely correct.

* Extract reusable code blocks into new helper functions:
  * prepare_mmu_memcache(): Encapsulates the logic for preparing and
    topping up the MMU page cache.
  * adjust_nested_fault_perms(): Isolates the adjustments to shadow S2
    permissions and the encoding of nested translation levels.

* Update min(a, (long)b) to min_t(long, a, b) for better type safety and
  consistency.

* Perform other minor tidying up of the code.

These changes primarily aim to simplify user_mem_abort() and make its
logic easier to understand and maintain, setting the stage for future
modifications.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Tao Chan <chentao@kylinos.cn>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 110 +++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..b3eacb400fab 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1470,13 +1470,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
+				void **memcache)
+{
+	int min_pages;
+
+	if (!is_protected_kvm_enabled())
+		*memcache = &vcpu->arch.mmu_page_cache;
+	else
+		*memcache = &vcpu->arch.pkvm_memcache;
+
+	if (!topup_memcache)
+		return 0;
+
+	min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+
+	if (!is_protected_kvm_enabled())
+		return kvm_mmu_topup_memory_cache(*memcache, min_pages);
+
+	return topup_hyp_memcache(*memcache, min_pages);
+}
+
+/*
+ * Potentially reduce shadow S2 permissions to match the guest's own S2. For
+ * exec faults, we'd only reach this point if the guest actually allowed it (see
+ * kvm_s2_handle_perm_fault).
+ *
+ * Also encode the level of the original translation in the SW bits of the leaf
+ * entry as a proxy for the span of that translation. This will be retrieved on
+ * TLB invalidation from the guest and used to limit the invalidation scope if a
+ * TTL hint or a range isn't provided.
+ */
+static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
+				      enum kvm_pgtable_prot *prot,
+				      bool *writable)
+{
+	*writable &= kvm_s2_trans_writable(nested);
+	if (!kvm_s2_trans_readable(nested))
+		*prot &= ~KVM_PGTABLE_PROT_R;
+
+	*prot |= kvm_encode_nested_level(nested);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool topup_memcache;
+	bool write_fault, writable;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
@@ -1488,6 +1531,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool force_pte = logging_active;
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
@@ -1498,17 +1542,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-	VM_BUG_ON(write_fault && exec_fault);
-
-	if (fault_is_perm && !write_fault && !exec_fault) {
-		kvm_err("Unexpected L2 read permission error\n");
-		return -EFAULT;
-	}
-
-	if (!is_protected_kvm_enabled())
-		memcache = &vcpu->arch.mmu_page_cache;
-	else
-		memcache = &vcpu->arch.pkvm_memcache;
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
 	/*
 	 * Permission faults just need to update the existing leaf entry,
@@ -1516,17 +1550,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	if (!fault_is_perm || (logging_active && write_fault)) {
-		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
-
-		if (!is_protected_kvm_enabled())
-			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
-		else
-			ret = topup_hyp_memcache(memcache, min_pages);
-
-		if (ret)
-			return ret;
-	}
+	topup_memcache = !fault_is_perm || (logging_active && write_fault);
+	ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
+	if (ret)
+		return ret;
 
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
@@ -1540,16 +1567,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	/*
-	 * logging_active is guaranteed to never be true for VM_PFNMAP
-	 * memslots.
-	 */
-	if (logging_active) {
-		force_pte = true;
+	if (force_pte)
 		vma_shift = PAGE_SHIFT;
-	} else {
+	else
 		vma_shift = get_vma_page_shift(vma, hva);
-	}
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -1601,7 +1622,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			max_map_size = PAGE_SIZE;
 
 		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min(vma_pagesize, (long)max_map_size);
+		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
 	}
 
 	/*
@@ -1630,7 +1651,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
 	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
@@ -1665,24 +1686,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	/*
-	 * Potentially reduce shadow S2 permissions to match the guest's own
-	 * S2. For exec faults, we'd only reach this point if the guest
-	 * actually allowed it (see kvm_s2_handle_perm_fault).
-	 *
-	 * Also encode the level of the original translation in the SW bits
-	 * of the leaf entry as a proxy for the span of that translation.
-	 * This will be retrieved on TLB invalidation from the guest and
-	 * used to limit the invalidation scope if a TTL hint or a range
-	 * isn't provided.
-	 */
-	if (nested) {
-		writable &= kvm_s2_trans_writable(nested);
-		if (!kvm_s2_trans_readable(nested))
-			prot &= ~KVM_PGTABLE_PROT_R;
-
-		prot |= kvm_encode_nested_level(nested);
-	}
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
 
 	kvm_fault_lock(kvm);
 	pgt = vcpu->arch.hw_mmu->pgt;
@@ -1953,6 +1958,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
+	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
+			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
+
 	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
 			     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
-- 
2.50.1.470.g6ba607880d-goog



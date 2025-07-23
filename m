Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8943C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D675F8E0014; Wed, 23 Jul 2025 06:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18938E0001; Wed, 23 Jul 2025 06:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8B18E0014; Wed, 23 Jul 2025 06:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7A6B8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C2151A0528
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:36 +0000 (UTC)
X-FDA: 83695203312.23.141F34C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id D466D1C0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VX1Qpb0b;
	spf=pass (imf20.hostedemail.com: domain of 3xb2AaAUKCI4Bsttsy66y3w.u64305CF-442Dsu2.69y@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3xb2AaAUKCI4Bsttsy66y3w.u64305CF-442Dsu2.69y@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267655; a=rsa-sha256;
	cv=none;
	b=oSetEG95heQjgYGxbrr9iKNUUqe6bBlB1wkssctZx/B1vPUBFpLKH5H/KRZVLqHcACs/Ng
	2DEc3Vhj5zlNAbFEkFyRLqV6Mzds2SC6XtuDS8yaZnjF8kIT6GyhI07t+SYYbp2bXYReR1
	anLb3o0VfbIL/x1V+00zSTQWGA9bUr8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VX1Qpb0b;
	spf=pass (imf20.hostedemail.com: domain of 3xb2AaAUKCI4Bsttsy66y3w.u64305CF-442Dsu2.69y@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3xb2AaAUKCI4Bsttsy66y3w.u64305CF-442Dsu2.69y@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hNLT3q6FGDV+rEHRPNootJHOVFuUm+ghBMVRNnmNc4=;
	b=CWmILD9spz6fUo9+0hyzl/l8evtSMGKHrIHID+X3Ul27P8ayEXeZBonWABwduRq5jELSpH
	u5PeINCKbBPWsDJ7higP0HMDHHcGjFFNfRJt5XlXK3CLMy2JJbAOWwVe73i5CWCplPxDop
	CVoltvFjBkfZJ/riuSTBxONbqrdnhG4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45611579300so47528145e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267653; x=1753872453; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0hNLT3q6FGDV+rEHRPNootJHOVFuUm+ghBMVRNnmNc4=;
        b=VX1Qpb0b9o3dJ3rPy69GHyCi7yYdlqtWQxpqbNmeYE7ZhdlEgbKE3icC+f/i8PLOfM
         xqykbf7Q+jX3QbWtetF0VCDFkdQeMP4qs5B/5JLOgk74Wb84XtbfJiJI7s75+QFVcvTH
         XLMVv0Ia2Y8CSSOIqyKk5CLM++Z9P1R4y8M/gRms4zpjQ4WIHY/wDBRYymMPzk13Rt+r
         zDNo/vYmYZqn7NBGWvPc0X2AN05y/OyzTS++mSytjIAverqLu3kaVxJ6eVAsMHTevoh3
         8pyVDG9cvX9LEYttpeZx4dCgHN4EEHYJKDaRz+J+C3qH//YKopAKsZRVpT0R+h+t9jy/
         V0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267653; x=1753872453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0hNLT3q6FGDV+rEHRPNootJHOVFuUm+ghBMVRNnmNc4=;
        b=qYHLS6hHRdX1CGQNVkGpYuQ+6Az+gRNzFYKiaZONtx+iJ4CoxDfLzdO0IPzCnX50ng
         q7NpLEIlqF1fMOI5qolI+5M/K5rkl/DXO+09ODi6FGXOvuPb/jDxlSwXMQKF0kKoq/Rf
         JNlCouB7+I1FPRFTJl1ZiY2kFXXzbQmI5FEIeaqYgIH6q1R51EnGqJGOSe+ha/EwJeYM
         CoxgEQMS+8DqE7RAfoWj3K/CD15jL51T54ugXLx6hosHt49YlGuWG80vnODICfFl0zlg
         tpEGx+DLLGI+X5yMo6H20wrR/JL/5b8VvosYOeNuopnjfGzFz65WSj+e5Ak9Y7p36QEe
         TMQg==
X-Forwarded-Encrypted: i=1; AJvYcCXiXKrYD63l0XxoVH0RbvLC9+TUJB4NFQBNVEWXcQqc380cCrL2InmjuWatyYaR1cKorxP6XylOzA==@kvack.org
X-Gm-Message-State: AOJu0Yz2T06MJu4UTGLOvbIBZEmCSeFJMFK9VkrXR7XaGo5s3WoKqGiV
	2a7+XfO/huZoCgFftfCz9EeiHoUO+2g4tsUdSz9d/SNR6QR7TvTnJ+2gwvMCj5eFfjOzmnpQCEr
	8wQ==
X-Google-Smtp-Source: AGHT+IEdr/R4SHXIN/Osc6SC6u8xoWyR2XoDwoRplQ/guvfFP9V2bgXvk5bMDQWHMCkMpZwIcu7+3mnSgA==
X-Received: from wmbej12.prod.google.com ([2002:a05:600c:3e8c:b0:453:5f7b:74b9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:358f:b0:456:43d:1198
 with SMTP id 5b1f17b1804b1-45868d4dbf7mr19146205e9.32.1753267653310; Wed, 23
 Jul 2025 03:47:33 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:09 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-18-tabba@google.com>
Subject: [PATCH v16 17/22] KVM: arm64: Handle guest_memfd-backed guest page faults
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D466D1C0007
X-Stat-Signature: grkrju35cebc37mw5qkpq3u6ufxc19kw
X-HE-Tag: 1753267654-801420
X-HE-Meta: U2FsdGVkX1+8qTlL/9vC79Fbkt4FlInHx8t4O46nEtc6KLW4aNQ6rZGRM+X6Az7To0BmNQiKMPh3B0PvZkF/wkrGDm9cglCyRb+JOglDzvmX4anWCl/i6631rNchxmX4QpimD2ofvvchWJP6U5ARtafhVoBKzhvSrplol+DnSt1RpT8bEn5di4rQmsyLAwv/53X7Qy/ZtvCmRWKa/ZESWtnvK3S46/0ye7/JykZfYI/OBDtyU4AD0Z4ctr/nkAWThzfnRJj/zFTd19V21KBBHMHpSxMY72bROoPp2iBCOkvk0uIxZL4Bk4hTBgp6ulgiEhizelewc5NuvT01vWm36ePl/uqVHqnKW3noIMsi1uhxTnUeuIAmrcKmDT9ZhgcCJjAyugJQkiqrI9Mpvn9jQFy9sO+3uwGjzRBJO8PgsIpxCtKk3Y8fhGA5ZgRrqdC7shFS6Yfoavg3lKv2JXpuEovGBfrJzStSeiKGH0spKfJv185scgxVK7+h0vZiX/G3CiUPPrQ1HwEjITvWQXSOnq6gt3Iwcs1MCgquJvUte7dNXjBmuUeW1xBiV4miLVZ7g640HLs6yIO+FDnc7AZAjuW1F6GJbWhSKhPsU4wE2j/vUtYzAYBZ50yPyjWJzwuu2QJuXBU/927uRlbIPNbJ8zNG51soPwlcWyk4zxaU6w8seqIOKDNmzQZXrUrlSyGceR2QgXWJ8wJ8/t6DqGZMbBtV8YwQC3fh1IVp4rIjT9Yo9ZTABjIFlEBLmAdbNP0gfJ2XfUuWf36WPoNG8C4r0d86sp9Hr0FAXGC767nGyAnlVJVEOi1sRY++jJai8/UtgHioAeSQ//kI0nzGkvr4wQd4QA3vcY1H2grLPwH0TGDdc3lJR1Dj2DuuP1FGkcegOyxiOqqxzqVOeCdws81ts0+apIy+5wODYS8C28hRIslbbaz1mt8J1WzNxAZG2wTtPDy7n8KMvfdu99GLf+C
 wqPyaN+n
 KkJ5HJaz+8ohsbYxpQ5hiSoOOZz+r+K/bnKLVFCy3vFewAe+uNjI+m23KOzJhTvjbrv43nh59dHM8SV3OpIcAiwrbwkoLnLJE1s3h053rzM2PEBfd01VXSKFea1puRrHvFoAMokKDC3tE4JJGiVsrwZ9AMHgzCi0Orl6MNYRkQvFHqRpwIXSTr7PXlJ1GfyBAzkxDcMts0EgSw6UHlMmroogcZb0lphCFWdwPwCDMIRV4gXDKvcwIaVvlshfM7AKomiEz3Xp9rH9IK3JWvqfYMfxPsHvXMc9DNxrXeaHnwvT5GX1HZLl+jRRx17C04yPyjZsw7UkOEapRGgsBJdyzG/1BhRtZLqGWVtEbeeg2hVNxCCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arm64 architecture support for handling guest page faults on memory
slots backed by guest_memfd.

This change introduces a new function, gmem_abort(), which encapsulates
the fault handling logic specific to guest_memfd-backed memory. The
kvm_handle_guest_abort() entry point is updated to dispatch to
gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
determined by kvm_slot_has_gmem()).

Until guest_memfd gains support for huge pages, the fault granule for
these memory regions is restricted to PAGE_SIZE.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 86 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b3eacb400fab..8c82df80a835 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1512,6 +1512,82 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	bool write_fault, exec_fault, writable;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	unsigned long mmu_seq;
+	struct page *page;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	ret = prepare_mmu_memcache(vcpu, true, &memcache);
+	if (ret)
+		return ret;
+
+	if (nested)
+		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	else
+		gfn = fault_ipa >> PAGE_SHIFT;
+
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
+
+	mmu_seq = kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	writable = !(memslot->flags & KVM_MEM_READONLY);
+
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
+
+	if (writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault ||
+	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+	     (!nested || kvm_s2_trans_executable(nested))))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+						 __pfn_to_phys(pfn), prot,
+						 memcache, flags);
+
+out_unlock:
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_fault_unlock(kvm);
+
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1536,7 +1612,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1961,8 +2037,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
 			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
+				 esr_fsc_is_permission_fault(esr));
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.50.1.470.g6ba607880d-goog



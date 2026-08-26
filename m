Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A8BC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B176B009F; Wed, 26 Aug 2026 05:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222496B00A0; Wed, 26 Aug 2026 05:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C1E6B00A1; Wed, 26 Aug 2026 05:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D603A6B009F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E31801C171C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:22 +0000 (UTC)
X-FDA: 85142869644.23.CA2C3D8
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 24485C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tXssxAQy;
	spf=pass (imf10.hostedemail.com: domain of 3W6-OagsKCFAsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3W6-OagsKCFAsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8ccBHCM5YU+7L1JIoIBmJzcK+1OP4Tx7QbvPF9cByU=;
	b=Ji5ibCAn66j1nkws6RRVjLLkWSuGTPCbZ/3CKciENZ2f0W+JXl09IJM5jBiWbeFXl35H8x
	AqiLKwaskZrLLETExK8ATCSTsI5cw1k5LPr2ZOLrAIxu+zK8v3ot/nAX9F595ANZDywMeW
	44JpLHR1eTjf87b+Rzt6kERLE+h/Fng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tXssxAQy;
	spf=pass (imf10.hostedemail.com: domain of 3W6-OagsKCFAsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3W6-OagsKCFAsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735901;
	b=x4fiHhGUJSmL0slOQl3iNjXfFkn0syFTM08x1oeOtwuJkeCGCVo0p1q18QK2wsiuD0X5IW
	X2yu6H5o7+f9nPuLPvm3N+nfCsrM+XrCkSOMkvaYBItSY+DBtKVSJYxRnSHKEhwoLopTFD
	CFrL4Lf6z61H47TzkDZOcAabBL+Bi5U=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84eee2147ffso1060627b3a.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735900; x=1788340700; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t8ccBHCM5YU+7L1JIoIBmJzcK+1OP4Tx7QbvPF9cByU=;
        b=tXssxAQyYXgSbQjMTR7ojEF808ERTdzpwncyYKYkGZOf5Nei1VhLqszWQxu6/eETYG
         uBuI28xjQtJCRdZUuilIT8yQ3E7KHmY4SQ9ZpTsYk8fFbzHUM6n+ES1ecDo7lPIXkwad
         U2rwvf4sMUcHohPXNGOaqEhBD2sLh7BdIc+2VlHHxcaWz7ZNDH1XEUXm8hjsNqjIJWDl
         Tl0WZFUEXoJGVxRQEMDOX3odgeNowXoCwWrP5bv6Zgw4QnFnRM8ufFXMjzqCZdOPrNj5
         rYbap8/88/hyze/Fmb1VFYfc6fR7nqkl4JkB0xMxFyfkaPX40eDv5kklYyjQWKZToNkd
         X8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735900; x=1788340700;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t8ccBHCM5YU+7L1JIoIBmJzcK+1OP4Tx7QbvPF9cByU=;
        b=evaCpxn8kCii5rQGA2QbVTrAurFcrUYAC+0CXICcPsq2BVSdD5ieF+Q9dVTlDOXNSq
         SXq8/JCcoXYDH5BhBc8g3oy9fWfyYujiuuKuE1p4t1Ba620Iaj73273K7k60EHAFmnub
         SJSTP5q7UMm72zmVm7th/+a1TOqKeWwJO6T3cNU/zxTfLy7b17WizIFKIIjJod2x2m+Z
         IugWxhaTbsO5G138lA1pxuyt/NU/itoXspiHGu3/bWNVCRH/W3xslMAUMLGMJsWBoVA8
         +T9U6nZN7mu7pleUUWvZqcnf/2jnNSu9DxsPEhn9c73oARo2rkdcz3bL/fjNgIElPYb/
         U0xA==
X-Forwarded-Encrypted: i=1; AHgh+RqWx4ZkCQy3qa8s88pU0MXpRbVgUjFebQUszA4pgivWubG7UlLuqfpeWlLmj5bJfgdZM6u/0OfCsA==@kvack.org
X-Gm-Message-State: AFuF++kWsp9OpCdIuxva5pExLURFIIs3gcqCaxWQHDDTc8a983fSyTY1
	pw7GI81ckVRb/Xj+TI5br+AsFRavm9i2SDMHmh3IGwpvfCcnC8zWwYyXFN8N/tNmaBlwfCjRdWh
	hDc1osWCuEBDNQvbo71asRZiJWg==
X-Received: from pgmc3.prod.google.com ([2002:a63:1c43:0:b0:c9e:a22d:15e8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1392:b0:852:131f:b9d2 with SMTP id d2e1a72fcca58-853721a4ffamr9144251b3a.2.1787735899281;
 Wed, 26 Aug 2026 02:18:19 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:05 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=4963;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=adODHppsIc1wwdLxXXaubDfwAX6RazWFw20vgvX1ukU=; b=qAec0tsGFxGYk1SoSRFBiiuqAJZEJlc7qzpxmaWzfOGs28joKteKQEPT49Se3lIk9vstlpjPB
 7Av3Au/QmG8ApmYCsv64FqojNn5zmavT5iPhsNBkXGeY43AYhlcl7lG
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-7-0a15d8a799aa@google.com>
Subject: [PATCH v11 07/46] KVM: Rename kvm_mem_is_private() to kvm_is_private_gfn()
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: m4jnfbwb3u4nyeg8x3nkb8demcwmck9o
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24485C0007
X-Rspam-User: 
X-HE-Tag: 1787735900-323598
X-HE-Meta: U2FsdGVkX19yNybXBr6oh1Bb/111FWRqJY8Bi86n9UtTyNYRMCONnDO3GeTEbH7b4Cek5P4vE9RAGQE15VZX6ycN5N4/h0JN0uLLjQVLcz57PHkDN+xXPAwDZU8ddG1BFq0MTghFMUC06pqtpIrezA3+RMQigjnxueCY+v4j3V8hLaAOewP9dJqniQCaKHuxLaIg5xguWGQtYMoPFaYW72EVddzwcBJXBrAQb/bcAeopdCSavHWaWF51ikcDeqU7rNOKZzHcMhR/q4jM1XfmrO2fmv9ni2RYmi0ali6dwOdykFPkjA0ww0pndL+t3RhT7zP2zMm1uNg4B6dWn/si2CZdxQnp4IT+tPhn/iGb5A9E5ACS10lRy9iIsEyMnb+Bnf6NoTiVKwZIoqRJ5rN+P3fBgGgKD+vLJumiHggbtERUpeCIOcQvYGUm43odiCLNynRs0e+ghLzjEc4G/e2hxsQq5nnY6HNuWEl9gycE3pGOD/SGPJPyLUZN/4c1BKR4G6VXBUJgvA9BVgypQPsXAS7RuGvoC1ut3WEW+Bjj0zi5pfv7lkjbWsFJhe6r68SPW6QYh0NlaI0QH+IkQVdzjmAJQqSsaahmUwBSZUysEaNGus9GDXJz5iNx3LxLZM1SSOOrBAKlEHP6of976F1fXvmfXCQ6OypSJEC4ePusPKLKdf/lJD+S+S1J7DTQ3lhKN4Rro2KF2R8UqjBopbYxY1Ctlb1CdpoIQJppEnXdN+AVha4YAS7kYtWwyDLmLtgjg6wCNtYDlnXQoBExmUpfrYgXmDtow7FJzMVr6IrIocr6/jxGU846YbjJj4gZAaKAkomVtN1TEeIConJ/ojgceukRoKSfm9NNZ2aRZ+JSRHuvJ0hLUS1snZSgaGZ+xo0gdVDO9siEj5rhIizv/4gZThwUvU0VpYIIM+6KSpUdu3ylWUGwhTGD8+MLDOtzJ8h4bHSL5wXsb8qRlu/UUXW
 x0AReBtX
 8q2RX6Lc5xvke6kRzqQNr0BV8JfvnZAHuGqe3qMhxhCl6PBjdjaku92OpCSLeutwLlJSqi/7JQUhvQ1HdQ6wCiI18Yl/f94VoeGO5ymsVsvWEnhLp7UR01KPe+50vpL4pxiss7h/Sv7RUV/mc16C2VMYwm1HrvwtTYarRjjoNBQqAJ8wJKXSquJsbkrlBgCuKBOXv6P8WKDmC5j4/8+cfYO7Xj522Dzrf1JJvrxZDOtOcpjnpD/Fx78Iav0emQdiT87Vf88Z9mW/lVEBggapgYHOqC3C6ORJA1Zbx+lexgCKP1OkrYMcwzm+jdswQ7FQ3cCmYJC8ZTBawfwLq0NDat9NCsncACKxu2MpilL+t0DG9Eew/przGyP8vVE2AtwWePvXE3T3zI49h1XlHgMb41L7Yl9ez8yb8A0DONj+sgkIfnMizsdEQFYJMT5lXTk5C0R/D5sL3b6Ny3Ljn/79RSX2Zm/qSmplLMWLv1FaqyDz0d1Zls1tHvdpSJKeYQ/6+GodDOKyqPjvL7GgsFOkkbJSoUPbV+b2Nv3Am3j2Ft2n89y8QVITVDsNwqfRv7BJtQ/AxkQlT9Dy+C0GknBgN1KdHCfCsKF/sPVAWVqqiZ/4Cerb+A8Au4oFCSMe01x+0qrjWMx0Aq05lB/Hs/ItX4dV1sgxprlAgU8RAyKWHTwAtbao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename kvm_mem_is_private() to kvm_is_private_gfn() to prepare for in-place
conversion, where there will be two lookup functions,
kvm_vm_is_private_gfn() and kvm_gmem_is_private_gfn().

This renaming allows consistent prefixing of "vm" vs "gmem" for
kvm_*_is_private_gfn(), as opposed to kvm_gmem_mem_is_private(), which
looks like a typo.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 12 ++++++------
 arch/x86/kvm/svm/sev.c   |  2 +-
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/guest_memfd.c   |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 10e59507d252f..62f751952ad8a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3421,7 +3421,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 		is_private = fault->is_private;
 	} else {
 		max_level = PG_LEVEL_NUM;
-		is_private = kvm_mem_is_private(kvm, gfn);
+		is_private = kvm_is_private_gfn(kvm, gfn);
 	}
 
 	max_level = min(max_level, max_huge_page_level);
@@ -3634,13 +3634,13 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
 	 * guest spinning on a #PF indefinitely, so don't attempt the fast path
 	 * in this case.
 	 *
-	 * Note that the kvm_mem_is_private() check might race with an
+	 * Note that the kvm_is_private_gfn() check might race with an
 	 * attribute update, but this will either result in the guest spinning
 	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
 	 * case might go down the slow path. Either case will resolve itself.
 	 */
 	if (kvm->arch.has_private_mem &&
-	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
+	    fault->is_private != kvm_is_private_gfn(kvm, fault->gfn))
 		return false;
 
 	/*
@@ -4708,7 +4708,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
 	 * private vs. shared mismatch.
 	 */
-	if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
+	if (fault->is_private != kvm_is_private_gfn(kvm, fault->gfn)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
@@ -5111,7 +5111,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 
 	direct_bits = 0;
 	if (kvm_arch_has_private_mem(vcpu->kvm) &&
-	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
+	    kvm_is_private_gfn(vcpu->kvm, gpa_to_gfn(range->gpa)))
 		error_code |= PFERR_PRIVATE_ACCESS;
 	else
 		direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
@@ -6584,7 +6584,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
 	    !(error_code & PFERR_RSVD_MASK) &&
 	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
-	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+	    kvm_is_private_gfn(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
 		error_code |= PFERR_PRIVATE_ACCESS;
 
 	r = RET_PF_INVALID;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0a887f8e05d3a..dff684b88f153 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5030,7 +5030,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	 * userspace via KVM_EXIT_MEMORY_FAULT events, however, so RMP faults
 	 * for shared pages should not end up here.
 	 */
-	if (!kvm_mem_is_private(kvm, gfn)) {
+	if (!kvm_is_private_gfn(kvm, gfn)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault for non-private GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6ca81f5349db8..9b97266f61ec8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2573,12 +2573,12 @@ bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
 					    struct kvm_gfn_range *range);
 
-static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
-static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 154fc9622640d..b9fee68c90311 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -879,7 +879,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_mem_is_private(kvm, gfn)) {
+	if (!kvm_is_private_gfn(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}

-- 
2.55.0.887.g758fc8c411-goog



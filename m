Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B022C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996776B00B5; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921DC6B00B6; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9B16B00B7; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 316096B00B5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42A341404E1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:43 +0000 (UTC)
X-FDA: 85199512566.05.583A341
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3122A4000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3YaFg4h;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084541;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k13uvf5Xp3Pxkjkax5Li8CiUKqLIgj9gaLjed2dFOGQ=;
	b=3Ga9Ob7hGokW+KoFrt5DA85bntdP/z3sDaenflUZLHhuFhwhiMSPoT+RvYCXCBFubFWM/H
	k3XI9l33OdeAHM1RDFb0WusBObVterUxWbsZgbRkcH56IFgFOI/dPnDNLR/ZqtU8XNDgXP
	VCxjShUdlVADvb1u4pFx0tc75jBOcYE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084541;
	b=WZRtXPCWkWfxLIhe9CGicNznkPPjzSJQbl8v+YoMAabWvdhHv4Bt+EmoyJY4llAFtfsaex
	g4HbnfJHpVnG/wHKJjw3aespbkVD+LJ3Equ1RXwpCxrCls9f0LCYYOCZHFfwkrUhLTysJa
	7QsW4qUnZ6zIj96US2yhPUc+2I9pOPQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3YaFg4h;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9043644809;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BF87C2BD01;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=X5z2Mg/aO1440TIvkIqoN17cxEwJlxc6e0/tZr5i1RE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M3YaFg4ho6n/xwstgdw0KlfDiAy8My+iNDmjN+S9/dQAg1YBtMW+gymTikfg2+MFb
	 6a42Nuivr1055AFiILumpv2E885jL9u+/e104x3kWk5iTvAE+7eEGfCFHms4tijQg/
	 p3aKU/K94ZxMgrvmn8VNYGyYEwd0GjBAK9DOMY10zj9rVkVCcZASy+fwlEUcLa3Bg1
	 n8qZg8Rdan9kECy3VSmLoQ85GEbwP6VvgEdSvbD+Lzh+pg5pbVAYulfqRqZ7RpOTGh
	 X5dDbEICmSnEsOtZAh5qkRzo3z5Sb2Z1a9N9fgybBRKGstAjyPy1ZXiGAFJwJi+9Rc
	 W5b7DC/oefRxw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D3CC88E46;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:33 -0700
Subject: [PATCH v13 07/44] KVM: Rename kvm_mem_is_private() to
 kvm_is_private_gfn()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-7-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5064;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=42vIP1QOcyyilB1ARC5YjkRdIK/quJ/7RkV/A5qevOk=;
 b=zH3FkI1kxSXhRG4Hcud/VcL6gjXkCNrWidvNnXq9I0WwDRZx3g1aV7PAAnyYUhrnAxg1do6Xl
 ZfWtE48/6pgA6RY4A0ACVo6BM8/jic5wrqo05HvqY73tCE5E6OJSuoV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3122A4000B
X-Stat-Signature: 5nncqx681rwx4i5yxwxw939ye4qw9srk
X-Rspam-User: 
X-HE-Tag: 1789084541-17188
X-HE-Meta: U2FsdGVkX19TbA91iY/AUtsV4QHUMGHOcG1kN2348D5qzYdsTBz+k7vaZ9EJWxcNuLYiHgFkMFZ2aNcEnIFXEjnQDZp4gdPH2tJ80zWQ92eHwB25pwsQ+7rfgBWles27JCZFzeJeR7tuQuuNBOX+ZLtbTEM6yYHjNCI1mrV7e7w+m+o++Cl5e0L498gFEVnSbgub5H1s+BoH4n79zrbQzT5gcHpIojC6/lT/sEBtFce6wDorHiazlpKdFt3kUPKhA8/joO5FWXZvvWTWZTkOvMybACahs6O/MbXo4Jw9PAuSuDHEqVSsz9ULlgtigpUFx0nuozjcFtjRpkol8pOfGtM/D3cfyeaOXZpceK8te9RHdNmuLmP0TuZUaaGMjF42oYNG4g79Xnhs4nQniVJCdy0/YjVs2zeBvOQFI/9xhQopZ/kpu81ZX0kft7zVTsA3IoGpw4IojFutI1QvwDzSQyQtR2ZQUlBka7vf8BiOvvQGjcB3jHBnsKkwpryIsWU8+sQKaixav+HK1a9DW5reNjCehOLKfx65UMgmX8/48U2JhSZR0fupoY6FJrGr0P/uqN3Et6sEPMwcS73pjMlJkctG7D/NasxeXJ7sIgVveN4Kx7MQRowgk1h4tAB3rUWD40LBWwvNy75hcAz4N5ct01E2hjmONzvPt9tBhwwcEb0xjjPv6YkOgMZG7jmfvZCNJg+uk+fffsQt7Z504yoUwReROEnxiF9jogNVOn27hnvZIK9oqFuf4+eIQhEAjFmwMxeAQ5AEiO60KThL3T+sbR/mFGHGlJF8Mlu57aXXUdWyG36hzW1rY/rzoBvedg2dnrrGnxS/sBufRmHork19MNkU2jVoGklHXEl2Vz8EoHu9+IAZbUiVF5jL/SJV3hdF+R61gJQxnjhimcwwVNfw/SWe0otZtStLAAiId5y1vg75ISztFOqCBY8at98JrEJLLu4QHPpnKBZvULjt4JR
 YfQp6oBf
 6BEscJAo/374iepfxmYIRMWt1m42EZHQ3uMhlbvILdKP5fmX1A+6UE2YzMsfef1hRFT/ueHey+ha69XsAWS/dR3lJIY69nESQpke9Cnx3zC9BMqK78e6m6RLZ9OP3lyckP26vUywqYXNOxX8UM/CqLa6OOaO5MRIGqZWwvCyWSvleU7Oz6HSEtUHcvbtGYGUqkc3Ixi7lZNQcN3pEwXtkBGTHnOCJP+elDoWUAiZY6xnOJDU6ZIb1w5zEqDbNrXghOJbPZAzntUlPYoqxfZDWvkgMrn8suUcB5ge4c7uNBS3U4gBF2twU5qDAa5OQCc2VlNCIN3gZ2zCJz+jdGVc5qg1/Wx/z8RiQMyNWQQwpE/np6reSGdWGXG/T3tQdfP4zJ1XF4xNjIzsJ1O+D29vT3Q+HKPcYMjaHie7y+uRED9+4n9BDEGdOSzslKn0IJw3hP4Y9dX1VWu0GTtUB9YzehJa13VRIcjUSwWEnn9FNChI2RL40QE8nZR002WtHkuvSUHK6ZWvZYHgf0sM3n/lnZ1ZcTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Rename kvm_mem_is_private() to kvm_is_private_gfn() to prepare for in-place
conversion, where there will be two lookup functions,
kvm_vm_is_private_gfn() and kvm_gmem_is_private_gfn().

This renaming allows consistent prefixing of "vm" vs "gmem" for
kvm_*_is_private_gfn(), as opposed to kvm_gmem_mem_is_private(), which
looks like a typo.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
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
index e32ac2c28cbef..ce5efcacda36e 100644
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
2.55.0.1007.g17ff1f9808-goog




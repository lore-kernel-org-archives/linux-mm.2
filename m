Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8217EC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBC46B009E; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D932C6B009F; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9CB6B00A0; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9957A6B009E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E356A33A1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:21 +0000 (UTC)
X-FDA: 85142869602.19.54C170F
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3C7E240003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f6AONQ81;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3Wa-OagsKCE4qs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Wa-OagsKCE4qs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXOFbAvR9CFwlqoBiLg/DMTF/cTrNs6QB3JLriOW7Tc=;
	b=hNvAG0w6F5zlNYxypiZSHk+QHAr2uktrWdynl4skLd62RGR9WRSC+wXySOWe18hm7KN/0G
	ibDloZYoZXFEFUW2ocOpzxl52k18d3eEMGfadBigG5Li5AvblxWmJpjjvKO2y6r4TTJRJl
	1aoT3GLjX2crI5tFfkqE3d7iXN2w4VU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f6AONQ81;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3Wa-OagsKCE4qs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Wa-OagsKCE4qs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735899;
	b=1uFBmCqTdTxnpeTEoiBCdicZ+NwRhnumrF2M/ekV92ecUD74NiHuiuf8opcQ92c+XNOPvc
	I29XXCGjucwzJYo+WS0PFAFLWzMTtQMRtOFK+zEy9DeNu4ROnI9nEm98N08Qrx6ZWPlLy0
	3RZsfZxRu7TkVCNSrPbU5y/o0JMS6c8=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso1042686a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735898; x=1788340698; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXOFbAvR9CFwlqoBiLg/DMTF/cTrNs6QB3JLriOW7Tc=;
        b=f6AONQ81eLsTks7JN5glqRng8e0Cu28I69aVHDxFD/7Y3zlTYjKeltgPV8JywoVEZA
         IqpIE246x4G6NQtlSBskkFkD/0XpI++EGFwGN0ozS3soGcivy/8JQvjTg3aOS0a7sdK/
         WWgXzJP45bHdaO92Du8nU2TUpvLlgqBCmhXUSIFrKmjTXjc9jL2PkRwgmXtu7kopM75P
         wVpHibUV/4TdhffiOMh2EG+OHhQPh2s5K4WPsbN+mPVG0gFn2JCJtE8Wo5YEclwbot4a
         vry5kUAETYviAJSsFCQXjyPf64u1AvuCwRaUxc54FD+pxKDXDuQRxLHgySCNrAV/Nxxd
         NNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735898; x=1788340698;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VXOFbAvR9CFwlqoBiLg/DMTF/cTrNs6QB3JLriOW7Tc=;
        b=D7cPpqo6v5HjlRJkhwfnEcr6KeWmqCqWm8yC1oVrxlD1/vXWY7QSKB25K4zitQs9Y1
         BlzJ1Y44M+gAns7pw2bObnMa/M6ia9Qic8y/yoNUmOz8Imhx9693T+4J9Zr8RyZcg4Yy
         GHd3Fz8OpoXt0eqRK4UN2ompDv3HJnqMlqyABRFVabGUmGi3SlNW0APs7H64PsmxcqYc
         SFp8Y6TatAuUhwK69GccXjcVztRNJ8/aQd2fQGpnJ016mMdcZt+2BvNjjmOwe6y/WFik
         +P1HW/bHb+zyMfYW3ItHMilLbsRUqGAyIOfQYU1R3ncPJAwPhRqGyOudkp5XRzAbP1Bl
         ps5A==
X-Forwarded-Encrypted: i=1; AHgh+Ro/gRTsUG7ssc+7ADbM5DMn0LXf7K24BliDa/69UQFcb5449yi0T6h4Mj+fsNxpYNug0uqzT3Oz2g==@kvack.org
X-Gm-Message-State: AFuF++nm7/P5a0IHB9/nBtH4RZEm+mSnF/YP6j7FpubCBIVZ0Kowj/1p
	PgpxrIUlU49BL2lLCGKer0+WRmyA2E3cOS9TFQY3wqMeMbdiNA/WoGw5OD6zU/6Twfkr3KtowgB
	SNFpxqW98avzaZ2Zu1Z33GBhKNA==
X-Received: from pgce14.prod.google.com ([2002:a05:6a02:1ce:b0:c9e:3c0b:5818])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6110:b0:3c3:a140:9392 with SMTP id adf61e73a8af0-3cf65e236a2mr11811035637.0.1787735897575;
 Wed, 26 Aug 2026 02:18:17 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:04 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=10021;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xUTR+KBThxIL2VCY+rMmkFcBUSeCA9bg9Znh3WlP2BE=; b=phNGPU6RaIIi7Yysjmn2Yai4fsOrF9ZD48sQMI2wD7rCP8bn0JGHxxnBB0E0/dsD2HaHdWwUn
 Hpordy+nL24ANiwgM5xb4wK/6VyuNo+N3pcTMNM3ENXbi1x0UJCqfFV
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-6-0a15d8a799aa@google.com>
Subject: [PATCH v11 06/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8ijdosyymuqmrh337wgiwzyhoshmdkeh
X-Rspamd-Queue-Id: 3C7E240003
X-HE-Tag: 1787735899-258276
X-HE-Meta: U2FsdGVkX199B5cGd2Oh60hAO7jlYiuEmoJmOeqyBaDV1uEhsI9YLLuhd+Xh9JzNz/W3ZRTI7tjLXM9EWrpfM78b+5T9MaFswQHk7LJdD2TkXckPa6+9QHIWKaZzihjv/Wq10H4CfZNUI2eW5vJlqvRngTC1CKnNeeU9DiqIEhBTJDgAxrRgH3qQRY2N6+2dm47VDgHruHlGYo4PDNwRQ9St7jTrtLTQh5GXWP5bp3lnybIJYhNX2WAW1aMkVEzstPmR24XJ/AX0am03WJlfaNThUBeQJDpLVpUnabuW6VRGD14+ExAccFm4cQvCWQOhqv0yvKK/rJlmdl/aVFSHCov1XBuSbuhc0Y3X/xzJYCxwUhkFHKJ735leXRN3ZgrLVE4oxLc7i6NIjgVNVz7FmT/cE6qfskQc/LtKV6wALi/hkqi+3lNrs12D9BZhDQEH7OFuHe/Qvf1WUlORGG2HNSFH9RfXr5bb2yOHVKxUkPXn7yGmvK/CRYfhkyzvb3c1Nj0MEul5ytqg4mnPgfpSd6OxH1mePyy7h4KqmS70P8za0E6RHWOX+37MuAsAPKWZukxxTKa5mjYbQwYmmUE9zRgCIVXHSSF1JWAsw4MvlWDmihAurUtXMCd1XxI5YVVjzji8DCx6mYLFfM3/cMHq9ADK8hosUTx9OYTjIgArBVyCHTsfdQ6FiJquITDGxdlt4aTBWv4rXC79QCDHwwxx5IueYx/CqX0cpx6wHXqlx+uOgW52OmxJdtay6YDbQtiVRFpDTXiqSXFE6xxr/VfM2Nieh1RGM+VlVCSIbO86is2UyTsTB51crawXYyTQbEpdTTxpo0EyUoHQArh0rE6wUwu5UL39H4TRk79IwIbjfMVLtQyfglMM3RF5Wtph6b9IIMP1JwZMwGhta5eUr1NotXvTm5WxnukJLO4ECuUpHph1EFOdfvLlb/3Fm3aWUZZbpSFfYicZBqubVfDHovt
 jO+rp2OO
 IOlfj0kwFAaTE4qYjHH9K8J0Ss3nu0cGr3d8Upx5q13YU0mnqO6q5OcijPGaBWduZg83fCbOSEzNyyxgp5ZD5ROD/gg7QCyeSIeiF0rml1uuwsspB2eULefKreoYXGENWmzZWD/YhfWzCFPH+9of17Hx2LafQEvI64DreizZ49LafNoXO9hSVOEfecdHamzCyZXu9IrJ2sJ2pF/q3UqKMbQj1Qr5AGo/87KwH7cN3zLvzERkdGOnMMNK+wlW1Qj4vC9TgFeUnvQESSCe7HFq40RbvvdvMLq2NGjzuaCxmQn2DqxfCb2qg14PCUdh0E7LmqPLPhDNdT8bYNzvru8rBIHPLjNl/Nx7UfVYoY9jvF+Yqcm9SeKBvPgict1wj6PgerCW3Byjh6ZdT6IwwJEyyne5UiaV/m3XWw4qHExne8IFn2YfJvG0o06TNOSzLPuoYmd8NU6rVddUmkJ7VS+zglW8M/tEjFjghY1tSxKMYLrj6OQf7pizzs+i9E8eWPf6aDMzFCR4N7nh15q9p4fUNJgZ767n7ClYVOMNOgBrDyqexNp7H7C6mQdvnGclN4KQ7ZmqU+sJElzgCbERUU93f9M7dxmyS7pUPluwWBIad7995JX7EsqHcewbzgy8U1meHpB75jUc8WNUhYYWI8gdYNBe/heX4/VjL0sTS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename memory attribute APIs to add a "vm_" in the name in anticipation of
moving PRIVATE tracking into guest_memfd, to allow in-place conversion
between SHARED and PRIVATE.  At that point, there will effectively be two
(potential) sources of memory attributes: the VM and guest_memfd.

kvm_vm_set_mem_attributes() already has "vm" in the name to indicate that
it is a VM ioctl. Rename it to kvm_set_vm_mem_attributes() to show that it
is setting the VM's memory attributes. (Drop the VM-ioctl scoping since it
is a helper local to the file.) Update the accompanying trace function to
match.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 14 +++++++-------
 include/linux/kvm_host.h   | 16 ++++++++--------
 include/trace/events/kvm.h |  2 +-
 virt/kvm/kvm_main.c        | 32 ++++++++++++++++----------------
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b88c00e11854a..10e59507d252f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8116,8 +8116,8 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
 }
 
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range)
+bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
+					   struct kvm_gfn_range *range)
 {
 	struct kvm_memory_slot *slot = range->slot;
 	int level;
@@ -8186,18 +8186,18 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
-		    attrs != kvm_get_memory_attributes(kvm, gfn))
+		    attrs != kvm_get_vm_memory_attributes(kvm, gfn))
 			return false;
 	}
 	return true;
 }
 
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range)
+bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
+					    struct kvm_gfn_range *range)
 {
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
@@ -8290,7 +8290,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 		 * be manually checked as the attributes may already be mixed.
 		 */
 		for (gfn = start; gfn < end; gfn += nr_pages) {
-			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
+			unsigned long attrs = kvm_get_vm_memory_attributes(kvm, gfn);
 
 			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b45fb80b0aca0..6ca81f5349db8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2561,21 +2561,21 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+static inline unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+					unsigned long mask, unsigned long attrs);
+bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
+					   struct kvm_gfn_range *range);
+bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
+					    struct kvm_gfn_range *range);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 1ba72bd73ea2f..c4d514d2350cf 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -364,7 +364,7 @@ TRACE_EVENT(kvm_dirty_ring_exit,
  * @end:	End address of guest memory range
  * @attr:	The value of the attribute being set.
  */
-TRACE_EVENT(kvm_vm_set_mem_attributes,
+TRACE_EVENT(kvm_set_vm_mem_attributes,
 	TP_PROTO(gfn_t start, gfn_t end, unsigned long attr),
 	TP_ARGS(start, end, attr),
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 050757544a1cb..91d5af7d60d0f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2420,7 +2420,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
+static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2434,19 +2434,19 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs)
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+					unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
 	unsigned long index;
 	void *entry;
 
-	mask &= kvm_supported_mem_attributes(kvm);
+	mask &= kvm_supported_vm_mem_attributes(kvm);
 	if (attrs & ~mask)
 		return false;
 
 	if (end == start + 1)
-		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
+		return (kvm_get_vm_memory_attributes(kvm, start) & mask) == attrs;
 
 	guard(rcu)();
 	if (!attrs)
@@ -2517,8 +2517,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
-					  struct kvm_gfn_range *range)
+static bool kvm_pre_set_vm_memory_attributes(struct kvm *kvm,
+					     struct kvm_gfn_range *range)
 {
 	/*
 	 * Unconditionally add the range to the invalidation set, regardless of
@@ -2533,18 +2533,18 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 	 */
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
 
-	return kvm_arch_pre_set_memory_attributes(kvm, range);
+	return kvm_arch_pre_set_vm_memory_attributes(kvm, range);
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+static int kvm_set_vm_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long attributes)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.handler = kvm_pre_set_memory_attributes,
+		.handler = kvm_pre_set_vm_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_start,
 		.flush_on_ret = true,
 		.may_block = true,
@@ -2553,7 +2553,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.handler = kvm_arch_post_set_memory_attributes,
+		.handler = kvm_arch_post_set_vm_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_end,
 		.may_block = true,
 	};
@@ -2563,12 +2563,12 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	entry = attributes ? xa_mk_value(attributes) : NULL;
 
-	trace_kvm_vm_set_mem_attributes(start, end, attributes);
+	trace_kvm_set_vm_mem_attributes(start, end, attributes);
 
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*
@@ -2607,7 +2607,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	/* flags is currently not used. */
 	if (attrs->flags)
 		return -EINVAL;
-	if (attrs->attributes & ~kvm_supported_mem_attributes(kvm))
+	if (attrs->attributes & ~kvm_supported_vm_mem_attributes(kvm))
 		return -EINVAL;
 	if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
 		return -EINVAL;
@@ -2624,7 +2624,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	return kvm_set_vm_mem_attributes(kvm, start, end, attrs->attributes);
 }
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
@@ -4945,7 +4945,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
-		return kvm_supported_mem_attributes(kvm);
+		return kvm_supported_vm_mem_attributes(kvm);
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:

-- 
2.55.0.887.g758fc8c411-goog



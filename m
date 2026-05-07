Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32209CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8AF6B0099; Thu,  7 May 2026 16:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD03A6B009B; Thu,  7 May 2026 16:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FC26B009D; Thu,  7 May 2026 16:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76BF16B0099
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EA791C126E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:55 +0000 (UTC)
X-FDA: 84741747510.27.64E246E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0AB93100011
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XvC+UzUS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185373; a=rsa-sha256;
	cv=none;
	b=Qc8ETYuKcuDZXcW0adIcHjOFyX2x6xLBD/GXtb1enMaXIMfO9N4ljqW4IqzwBCudt/O4+Z
	w5UhAnyK/fSXnrGRSQU/KP2cjQBWh6UsJPnem/+1Wi0X1BUVrTWyvQ1c9K8tDiGT78GYWj
	4hd33kU5fgMb9FF0RWmk9Y3FJ2rXVbg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XvC+UzUS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185373;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzzuB3YKQK7xoQ1PQVTLk6RuKKAQzsSp4tz5iatHOp0=;
	b=ov/3QWnG01xi06iRikx44aXTCbDCbK3J+R3c0S4aUc5w7pg7C26g11i9+0TnT24fB/UOEs
	LgLokHWwc4DUuHByhmGP0Q/pyd52m9nNo0qPd6CU/p4wuAqAm45PRVylySPSlZZilE6xbB
	M3WhGIb+fACvSsadHRx3ltMnbNpJOtc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64D67445D3;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35B32C2BCC7;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=rE/8cKNqZaeVjXxwfBww6tbTvn1fWAuFQWquxX7xXVo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XvC+UzUS6iBGIFHVAwkb2+EBpdCFlcRL2nbl5Rko4MtHF2EfiJTN5s1eKxS8b3pW2
	 wThAsh142wRD6Gu6nQ+ARpn3Iw8/5RQjV8dGWb7Dqpi8bYvpUIWTjd6t8y/BckSGNk
	 Kwopn7Kyn0UxzRuKMm3moafdTRhnDq+zQ953az0jVMSZfbgTuRm4lPC3DzKdkOm4Uj
	 kelq47KQO1TKWefAl0kxXll2Gwtp4jkv2IJ4p3OA2fU4JwHkQSSlGIVuSmxDovy1l1
	 9XhywJFBvEk+HFPx9Y1mfQ+wBa5xpv4aR/iXSQRctQSE6yiyf+1mAEC8VSXKao8e+W
	 zwO0RdbQ+w4Ww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A9ACD3446;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:26 -0700
Subject: [PATCH v6 07/43] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-7-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=5801;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xlmVc8K5kdL963hvctsSRqBmupjI5qxymxl1Xu3T0UI=;
 b=96gogwYRiScuQvD/ROeLWLvCx1B/jqbXVTHeK9UrPJ+YO0+OrZafzdC2iYxTs6p0KtdFouB73
 fsUr9AO4eW4CMbXiQWWBftI5XHfkuCK6kIOIKdvbrFJUy1YueHDC5sO
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: w38mwxnnsmtts3jt5yhdxuhih3xjrm6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AB93100011
X-Rspamd-Server: rspam07
X-HE-Tag: 1778185372-258364
X-HE-Meta: U2FsdGVkX19pme7+8L+x7P4knsAFhLxUL3iWbhwYRtt5b0BZQ+fy0iG3X6YWxkRK6p7hNb80enBENoKwymU60I5NWOkCP3Nc9L56CooO5dMxxRcuMh2SQkUKvCqYhDVyijgCTgR1vhSAszx337afEdEvK6YRUePGKWmZZRt1RmQyHewjXB3vrcOaxiXOduPm24g2oQWwxtDhRiMIHxJQcHJJT6Uqp+1TaKrI0aY2bAr3yljjWLtZOIga7bpArRX8kqLJwMDVS6PjhKK+CnG/teTyzPhm+Cp1xm3aMIpW8klrwN8PDBIYzl7Rn1ze68LOwzsP79fZTgDO13XkTOqW9cHr6S84qUIcCGGl0EhqOfGs5GBi7TjwnC+iH1ZvpaeDc6SS47q6UyGA+f+WFNkQRxm01/09IgK60kjjFQd7Ju7N2/VG68W9wV17Z5yM7nOZwucU3N9GyEHipGie3sPn/o8DXJBeHtd2AQXjpxPWyq4rgogeB3VYkf/8T4y9FfAkuKbecKW3S9TtF7IxHx4fYUDvwBl2dQyMv4kUYESxfPXStYn3ux6AW3IU+Pc7VP/6AFODgShrXxdD5l6EoNbBBUFe5Lk1yEPRsHmv073WAMonsOGU97P7xzBuzRxtK2e9tZYWSfkEeG57jA/XLMEd0aKPA5MZdw+xkUO0Kgx1ScSZLAfluPgcX0PIMzZ3ATd5+EFvsSyfXWNBtwkFndrO9jvgQoVPAldlXGvvD/16SJulj9SMJIm+t1v+aAU/gvR3AlOeNo1L7lPRDlAOV57MEDIuV3Kfbaedjk8HMXfdtHdhUpNK6Y5uG6EAIei9Wz//SXz/3VvAo653/+dKYxZmeGzSx93nc2oB3txrYKSstmRQfPdxEjEowBrwFkdILnMlt97fyQQ8LMxGKEr+rybo0ajCMKd7wRb6VmDZRGzgz4Wu0jReNpdyBXgm7LJrreNCnVy6tjUjwB4DA1TQW6r
 ufLKrRWa
 PnDwpwA4mSali9DuuzXgcapVriHYh6dR336qsMAmDhmgLfVntS4OCFSIGFHjuH7yjDnmzJZ11HimnBBAX2wmw8NOXyZzVxDDRv6hGWOXhLqbpJApZRz8F4/O8KRrTmV2XoQRD5UP6cmlpkEzFKQpKFMsbvDBkY2FlPtF9fJx47YesBGOapG43qy8mVz9z1LLsPJo2ZYPllR7R9tHhj2TvXQXNnvKlizxQtp3/ty2LZplsx9HYW+2Lg6KPKI3aYGRV1VYNi+y9gRETEP4mE0iMFUYFHzpEJpD241TlopAniXr/BpEk3cblv9mo7cME8Ds2w2vtvZ4VeRjU7mH9Dfgd6qhf7EEYMCZCfZXtG3Aad4xu67pDilNgwdYGM3QyNzRuk0zIzEwBHqd2mCyOfm4dCq5aRkPTxVFqm+PtXd0h1C9zyxj5H/1605nSYHt5Yol0o02k9kb0ZerZ7aouIFmzxrY0bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update the guest_memfd populate() flow to pull memory attributes from the
gmem instance instead of the VM when KVM is not configured to track
shared/private status in the VM.

Rename the per-VM API to make it clear that it retrieves per-VM
attributes, i.e. is not suitable for use outside of flows that are
specific to generic per-VM attributes.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h | 14 +++++++++++++-
 virt/kvm/guest_memfd.c   | 24 +++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  8 +++-----
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 153bcc5369985..bfcf9be25598e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7997,7 +7997,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 28a54298d27db..1deab76dc0a2c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2549,12 +2549,24 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+extern bool vm_memory_attributes;
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
+#else
+#define vm_memory_attributes false
+static inline bool kvm_range_has_vm_memory_attributes(struct kvm *kvm,
+						      gfn_t start, gfn_t end,
+						      unsigned long mask,
+						      unsigned long attrs)
+{
+	WARN_ONCE(1, "Unexpected call to kvm_range_has_vm_memory_attributes()");
+
+	return false;
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f055e058a3f28..9d025f518c025 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -924,12 +924,31 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
+				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	if (vm_memory_attributes)
+		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	mt_for_each(&gi->attributes, entry, index, end) {
+		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			return false;
+	}
+
+	return true;
+}
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 				struct file *file, gfn_t gfn, struct page *src_page,
 				kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct gmem_inode *gi;
 	struct folio *folio;
 	kvm_pfn_t pfn;
 	int ret;
@@ -944,9 +963,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	gi = GMEM_I(file_inode(file));
+	if (!kvm_gmem_range_is_private(gi, index, 1, kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4139e903f756a..0a4024948711a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,9 +103,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static bool vm_memory_attributes = true;
-#else
-#define vm_memory_attributes false
+bool vm_memory_attributes = true;
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
@@ -2450,7 +2448,7 @@ static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
@@ -2584,7 +2582,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*

-- 
2.54.0.563.g4f69b47b94-goog




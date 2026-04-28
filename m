Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6831EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF666B00FD; Tue, 28 Apr 2026 19:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FC16B00FE; Tue, 28 Apr 2026 19:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F1A6B00FF; Tue, 28 Apr 2026 19:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB2C6B00FD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD75A1A0A45
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:23 +0000 (UTC)
X-FDA: 84709548126.11.7E3BB5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB9B840004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyqA6YHo;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418721;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igR6N/Wdrhv9te6FfutCjMYM77aLMoyugVjoV0cnn6k=;
	b=oLlSrQ31B/m9BfYXx8EKNES79ZiHoZfwbNy2XCpdVeQU/SXCaOxuFexGaY789BtFnKeQoN
	zOOvlj7VWeS+Z2nGa24b0iMZTHRgX4/BJwXw8asm4ksG8cbDmGaBOd3fvB9R2k4hMayavO
	wWxh0re8gp9yKTtueYO9xQz9NRq3+OQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyqA6YHo;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418721; a=rsa-sha256;
	cv=none;
	b=LmGh3rPNsd6dD+sshnTC+C8SHOJUmXpMZbzAGgQTTIG7R04UNqozpBYu9fjVCr39Qw/GPW
	PRRJ00aMppECeZbx+GDDZARGo/kR/m+mn7RmFcD2N3ynsukWA5/zmqW6h03Vay0zPfmRgm
	yfnUGHBckPjaAOmgBoySRNL+sIpPTT0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BBB744738;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A22D9C4AF10;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418717;
	bh=ubAc1CPxXRSw/UEwcXkAvbq0+n6LQH67PumM7JjBqAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FyqA6YHok/aAKoE9OG/UqelbD0Zes24pZmdJORUE8xsJOCzU6Kry5GbZU9jRm8kxq
	 tZ467m7WED6FbFlCmSjVCaFqkj1jUeIOo3hpHWcCImrx78NLOWK9Ed6ChJ3kppRNK/
	 22JUo2643hp5KnFRcxK9/ew3PHJZmQEeFAxGrJ1a/d5DhQRj4cOhTx57ai+tEEop7j
	 jqYlHBGJTMLDD/sP8rNtmAB7N0JuCX4+v1JgiNGmodMkJip3GXIpdav4o9PRBbSLzh
	 kwHowqAQ/DUKBgIDV2mALrfRG6Mo/Y7qLwXxxwA0jZXAOmvJA7cv5A0WouaqmpSSWl
	 hon987JeFYo4A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6A0FF885A;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:02 -0700
Subject: [PATCH RFC v5 07/53] KVM: guest_memfd: Update kvm_gmem_populate()
 to use gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-7-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5801;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=QPxDAv4i49Lp2kh12cGxu3WGIDzywKuUGdyQ/nfUisI=;
 b=H7Gk4J0tyHq3MQv7cJZbXEyzOJDX6sNaPQffh/1UX3d0J6XV3uP86zbyCK+G5WFmDwe9hN+76
 0GodstiPPcuDHZU/9hc7J1GoIETKUrg15mUByBNAMgFhtDQkJk6f/4+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: pkkpdjieztteyftgkg9wjtdoq5xtzkmi
X-Rspamd-Queue-Id: BB9B840004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418721-503524
X-HE-Meta: U2FsdGVkX18Y21vjnhw6n8yt4FWkm1eDT04VNa9huxotVHfiMmAYeM4jTIieajbFxYPmDIfbPmm4P3pJzTCLAreiOAfTF1EZ7d9Rx4NBgWkrZT8JwY/etaaIC+SOqrIl4RvB7zxv5G67GMdWWY/0Gf8ErD33XI04aCObDYCL7chSbJN6DForVp2DEZBiTTiY/wn/s2gz1Ss+8Jvyc8sb1TMMtn/qGegNXoGf7F7M0vtCFj8h4uzRiMEIXjv6HJiIgr6qlYv5IOryH2lEAteWnKCl7GR9wLJxNwlFXOrNgbIC6yVhn2Sh7MW07rniraYxyH8Hc1j8ddToG+x+2FuMPg/PYVirX0E3Od0fFVNB+K96cfNwD6Uc01fsP98gd6o3Q9+cNuQP7Q/Ns0w2CCczURNtzCtct6KCCELml5QPOYLbCownVxEK8j6Y94h/ir636Q5h7XYU9fM5FKU7xBLN5B+v8P9XWN8lPICPE2LJCbpOTWMcl/5BCOutUFk4eGQ+zDesuXUJ6nLIF2RLdYzToJgxB31rJgW6UaKegouqQE16sEdbOj9ypZRJ0EPhYFaXX+YBBl4bc+J9p/EZ7KqUzXNtPlABhoLTZex+ebuUNBKf0gQyC3aS5wZ2IE383lrUl1AqcHscN7xnVXqIFV5/9Z+l0iCrejK/oTiN9ghLYBJPKI6L34d+uqt8bOYuxlqyL1Br2Ts87NpN10lRkORHVsXMJNtqjYIowPLomc2sjbEv8ChBSYGzIgdH+9gnT8tQc73toYsQZ8JD6zTPv5JmBaFWANWscH4HQrl0ZIh0G7c1C02MSIob2tnAqVswMaZPPgnZBhzZPxroMWIayUltlu7QuddE0cpxuAWbyfCAXKVwKGAPtxy0mbStOrWZ+ycGRwO2VVVuIRoOtb/MDeCJ8TuXS+KsudrCQuVE51Xu85w/akoV6sd7q9JielEAQ5KghDOjvY/lPGiVTmkGZZ3
 UVr3tAW4
 MagN6FOYagB/L8WSrH08IIrgi63mUGz+e2ssrj7iSDH5CM1aU8CdgujFI+VSmD9VQ0xuffsF/hXl7TBzP3SIoj+mTD6rtUAW7+Lk7TF20dx7E/skyKSsNFUObs9fXe+BIGg1N8mSaerRNvPWIVdbSOnh8I156I3OWk7acULdwmhJJoqBIQgoTuqJRsqVqLR86euy6lgvDaPMJ5yfGc6U7sxP/PzwiC9Gm6nLfCfMx5i2LQbmiwzwyRoRfGapNL8pn3LVDxNYHnZjYWiAweStdfXj8maLy8qRmz2V7fQnb9QuEzvf2fNHsshl8K0ThLmwCIcYFcVP9mu0D/ZZ4G07k81BvDDKS27LycyNC26f35sOGD9mVYKcFHu4No4pRqRCYfMEb+19yLrkfczyxFda8ynhq1w19Cwj/LMqe80yGj847caa/KyxQTOv9/sgYFlkZUc0bMvx2v6rtA+ZjT/mcSkMs6Q==
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
index 2cc848bddf190..d3da387340a9d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8004,7 +8004,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
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
index e56f89640d050..758ac24a0ff40 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -936,12 +936,31 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -956,9 +975,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
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
2.54.0.545.g6539524ca2-goog




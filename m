Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F655CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468EB6B0088; Thu,  7 May 2026 16:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4401A6B008A; Thu,  7 May 2026 16:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355D26B0092; Thu,  7 May 2026 16:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24A3E6B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C356C8D0EB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:51 +0000 (UTC)
X-FDA: 84741747342.03.3772B2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DAE1BA0003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FxmCwJCR;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185369;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gt1cXhYkgEd+X7QjiyUmEaRF+HUK7MswBT1DrnwFhgw=;
	b=7uTHg90NpEaXSi3rIDYVQQmjP7ODcgEJYNUnBFyffbjAAFlEgfe5Ku2ZUntsmG50hYvST2
	l148O1MDKjp26cZLXAuZuloy5RtcBc3ki6Gf5+JIbauSzCDcEZCZhYCrszIMAzGl6D76LV
	XF19e8P2QHvL7b9Pay9U69pBQz68bk0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FxmCwJCR;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185369; a=rsa-sha256;
	cv=none;
	b=u9MAG5gegYr57g9mQHVQdtTOvR4iuBxjTY41HAKJk8wA9d1KC+N9VxQl+/WPtW3m3fFmVm
	7Rw5KkXL/MPhuk+1ecRxV4dPcMPTvEAtgjwSVK9tWjglA3aq81xy5j2bVD11uvyoAfnv/t
	3b2d3ZdtrQi9+9g/0rQRguX/zPjHXIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26E1361119;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D583AC2BD01;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185368;
	bh=SGgz4WnWrWNAQURGv7FcScbygRGgoXiTWIhW/1T4eDk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FxmCwJCRuFSSpKjQUPM3D6lb3UAwlH0jiz/93H4VjPYmYWXOVT4SG33dvX480scMb
	 46GwyFSPB/aYq8LTJ+KLRdzOrFrxtO99neJKSi1Iqh6Tv/FKcJbMveIzheRIBCf5Gj
	 i8L2fB8zuGV2Pw5SUkFsP9mM4E2kmORWcg8Jt1fChREAG1oAQZ4MyaptBZHpD2qGN1
	 xDH/1VaMUL8XQZYTX145xgYE0opmsYhA4asY+A1TWHJoj0xezafjToxrBN7HiO703q
	 vtoFE/7/k02J1vD2kqBgg71UY+27GkP8wOcOa/QlRZCa8hSSaOpD/JP8R5sEHyyzL/
	 1qgsPIfWkjbvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF11CD343F;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:23 -0700
Subject: [PATCH v6 04/43] KVM: Stub in ability to disable per-VM memory
 attribute tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-4-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=7274;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EYgKcaGJy43Vv1gUJyi959Hx8yU8hB2vLuSQuVzjHc8=;
 b=mI2ReXmtjKSxVCTSRHg+SnxUFY6j3CgHvtQUTQW6HwOtRBOyFa6u3pGvUWHTW428t+iHAB4Qj
 /goa9A33Q3UDJkchUNdXFGdcLfNjSu7wIKttkOUIwjpeXkT+q4OfF/B
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: rg5fr9hfnriibeqcompp5eqrins3ye83
X-Rspamd-Queue-Id: DAE1BA0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778185369-638530
X-HE-Meta: U2FsdGVkX19eJ7BdziewM01qAUku9N0rUgukHjnTzzM10JchysoLAP4vxyrKrqQCHfYSExDjmPJI2eblqEOR2RhrLPU77apSJGeM/3eOma7ZGoGPqqNLU3Fp/Lp1ukxFIHi3O9ocjPRJBs7sldpteireaZ4ZRpGBv9MJRIZKCgUdsuQo7Z13a9WrTTnTpOBIYB1RaiySNpnZULaoxAh8r+hYncogTFEwSnEEPIX9pODBbGUgaPufRNcWzH52VT5VHYkL/2Y6a6YCdJaXHdZxwTDC6P63Hby8szETovonuCTX2jOL5aSTSR2maV/8fTuewM8GjCrLj+DdyrRrOuF4lzhEYL43xLHjfKOV54wY1ho3xxsJbrETyxGPE+dH9RfbzYjZCpIskas6cDJNwNFTqOJfNVUtv4PmxKEcmN7IRFFur9ouKpM/GAMznTVU4SqxkqrS433uXIdbdi5fboL40ABqbVZvw49GbXPzmiKfJj/PzIW9qqz82vFvhyV6fL8WPFyokaGFCG+jhniDdXEAsxzIBdWEysXbckJvLsxzMPn1FwpzW+PpD7h/Aqqq32CjSBdiTJH9s14BWzSbyFNDXwak9G0sl4/Cwq2f7fbnSoo/Ozi4uo5djV7pqqjVmoWH8D7L12C8ZPgLCMYkmgf6vQhS5iUdieopzr8Mv09yfQtBMNWQWF/vy8VAlLJKVU8H1b5jJAAubd2RSLJnGSjf2ZQk7rAaRCXwuyZsYfv9V8Pz0to9437qqullPdR4iP9nQDAUM9OAHZM0zZgW8cCBZJwGE4N+/L0jJQoTCTdASQM0xPLGIHM6fvXEYxb08nmMUxq9lCnGu1NEscqjXkDh8n+63LSanz5unO3VeKNzEd68r2wGxd3cBu02PJTL2zNM/JhBoECUbCjlfUdyEjJUHo1i6cNYThJZ+u2S3B3LS46QJvkSqD0RHm23N2TqsSJBpAiXjX+aIkNw4W8cRTD
 /7ic1URO
 H3rGktYg1ctzEBR2nmz6WwbJZ/uK4yjsqRkSEJu8I0UBX0Qj+433Y/bxzJEtNuPOs746eqdNWdVEn05vXDVjvumJFtNPXlXenTghkTqV8Gfh0rqVzvvntgZfLWt8Lnhy8kayXrdFYBq1hEwzjSNeapApZKgKI2ach5fhwFY/69+XP38W/ZEf2Wn3eFplgjCJrhX/jarg9e/RcagjM1ar+8B5v2er/z2IBuxTMd+B6u/fA3HOD5yMIyCUEPwcEKJmbycUA/v9XQyDpbB1ojHcWw871HLfn0JLpVS31vCHgCKuWTOGqwyTsWXrU9STp+e0ollkr6XTDSiQ37vflpSz/7hxXwtxTOI0g6fbUwklyz6zggCp6iXF8jBlP0JBol5QG39ZS8Wq8SEr7sPCL50eeu4GQm2vpN0Y52OBJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce the basic infrastructure to allow per-VM memory attribute
tracking to be disabled. This will be built-upon in a later patch, where a
module param can disable per-VM memory attribute tracking.

Split the Kconfig option into a base KVM_MEMORY_ATTRIBUTES and the
existing KVM_VM_MEMORY_ATTRIBUTES. The base option provides the core
plumbing, while the latter enables the full per-VM tracking via an xarray
and the associated ioctls.

kvm_get_memory_attributes() now performs a static call that either looks up
kvm->mem_attr_array with CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled, or
just returns 0 otherwise. The static call can be patched depending on
whether per-VM tracking is enabled by the CONFIG.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 23 ++++++++++++---------
 virt/kvm/Kconfig                |  4 ++++
 virt/kvm/kvm_main.c             | 44 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 60b997764beef..c9aa50bcdac2d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2369,7 +2369,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7d079f9701346..c5ba2cb34e45c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2528,19 +2528,15 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
+DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
+
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
-	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
-
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
@@ -2550,6 +2546,15 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
+#endif
+
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long mask, unsigned long attrs);
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range);
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 5119cb37145fc..3fea89c45cfb4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,7 +100,11 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 config KVM_MMU_LOCKLESS_AGING
        bool
 
+config KVM_MEMORY_ATTRIBUTES
+       bool
+
 config KVM_VM_MEMORY_ATTRIBUTES
+       select KVM_MEMORY_ATTRIBUTES
        bool
 
 config KVM_GUEST_MEMFD
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index abb9cfa3eb04d..ee26f1d9b5fda 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,6 +101,17 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+static bool vm_memory_attributes = true;
+#else
+#define vm_memory_attributes false
+#endif
+DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2418,7 +2429,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
@@ -2429,6 +2440,12 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+}
+
 /*
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
@@ -2625,7 +2642,24 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
 	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
 }
+#else  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	BUILD_BUG_ON(1);
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+static void kvm_init_memory_attributes(void)
+{
+	if (vm_memory_attributes)
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_get_vm_memory_attributes);
+	else
+		static_call_update(__kvm_get_memory_attributes,
+				   (void *)__static_call_return0);
+}
+#else  /* CONFIG_KVM_MEMORY_ATTRIBUTES */
+static void kvm_init_memory_attributes(void) { }
+#endif /* CONFIG_KVM_MEMORY_ATTRIBUTES */
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
@@ -4925,6 +4959,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
+		if (!vm_memory_attributes)
+			return 0;
+
 		return kvm_supported_mem_attributes(kvm);
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
@@ -5331,6 +5368,10 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_SET_MEMORY_ATTRIBUTES: {
 		struct kvm_memory_attributes attrs;
 
+		r = -ENOTTY;
+		if (!vm_memory_attributes)
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&attrs, argp, sizeof(attrs)))
 			goto out;
@@ -6527,6 +6568,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();

-- 
2.54.0.563.g4f69b47b94-goog




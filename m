Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BBBFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC456B009E; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8947A6B009F; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE716B00A0; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6598F6B009E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C0481B9FBD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
X-FDA: 84709548042.04.3112460
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7FBA640003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9Aw89wW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418719;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCsEUXAODfrsimnV2bwF/z9hKMPrU/LNx3gVDCzBXBs=;
	b=crd/Y1QjC96MDlNGyhjM/IHW7ihD5MMLr/VSNQv7yXYqIuVXe/UymF4pZlfE52VbQHgliw
	3v3aYTmwhjo52tLFess044VTCfFIXrQefBIl83K/kX/tBsXnVtS6j5kDhaAgBgIDfDoZgt
	Xaiuv4tBigdOS0SA56npGwbuEZF1dXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418719; a=rsa-sha256;
	cv=none;
	b=hpnHyogWnpHjEdo01Y1+sbtsI3Lzx0z77Dnx/FpNeiQLIyxRc9NyBbj/1JNfw72ZdakJzb
	s+5xZwL6/9Nfp2V3+vHFKXCSzjkdxAuhWz6L7bdwYRro6KMeKBUyHNGwFJS6rZxS6shgsP
	Jvm9o+vrhhJEKvbPQW7sLP61mth4sLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9Aw89wW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9608744429;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E396C2BCC4;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418717;
	bh=TQ/JQVZ8EBe4lZfpLA18QGX1cWC5Jk/GnFPrFM938QU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R9Aw89wW+KLgW6e9c/KhyMPtAw+afmBOUH+d85XImwdn05f4e7RZxxuZQq0X8fd4R
	 5NkH9SrwunvpKEV/RFVGEzLv81n2VRK5gJBVpyDwceT5k6lbW5E4AoHywPksYwCgJ8
	 RnAkMqdm+zRK8O1D3F1CBADGY1HXJhkN2ieu46DPNRdA6y98YY17g3Q4ey/x6BRlB0
	 +5YFix2Mm72o0SbiCC4uJ4A8aOThdx0zoUwTlTmaFDQf6uVw1ZRnb2KOza//936MUS
	 NWm+F6P10JWMPkL4Do7+bW8DB9mYIYkM2gSfhNKEk5XY5fhm+TiuLRVXxw2/xEo/IV
	 da6jnh5cZXJiw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21950FF8877;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:24:57 -0700
Subject: [PATCH RFC v5 02/53] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to
 KVM_VM_MEMORY_ATTRIBUTES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-2-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=8643;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=R5hxyIDJM37Y03IAeGOj9ROZD1bt2m8hfonDs7rwrYs=;
 b=fXuzweXcoo+FBFFkvzmmqNTRVgxROB02Jy3dKKbmYmFyzYwvmuWSlB394LnOE1wK4Ta8apGvP
 h7jbFF9hs3zBiWoNFTDkiVk23/sIMJAhFhoLcXUeyzc6XJeSdCmyIdf
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FBA640003
X-Stat-Signature: kdh4ixuxyaj8ja8pqirf4uq5fgzrj5td
X-Rspam-User: 
X-HE-Tag: 1777418719-266692
X-HE-Meta: U2FsdGVkX18+9MCZs2GKXaPLGcNm3ytkZYi/HosdbbVwFdFpSGtDWQpyatOBoD166HqUgrWdW+sy3Rtmx2gm6xGMgPxgk0QebBpP49r0E18gZiE24w4zT+SpADs9havOcNIxOsawt8MK1/cPDcyxhaNHvjzuj0i9lkXQPVxZhMDmHM09IVZvIC6pvWgR7pCK77bx/5EGOzyt56ubo14o1gvgio3+beFtGbup45Qi9iSghmL90gc0oG5Xcj2bBHK04AXGO5Aj7QGlon3hlOU1q+uaM8bPmIS4+pAB6/rZHUumuXeK9hlupNfm+ZBogVHt/Z5DwSmbSWILEOxukGDjGIaDapZ+qdhoeYf9h0JqoXWa+ARjtSimHkeq3KNPigYyWLjeE29XxUnMMt6Ka71t3zIzT5Hovnx702DU9KKjwVXZjesWMgvSB74XKGAm+i/QQn6eDv+OooNc058Qzn626c04l+ATfpxO3sE8gPY134dPEbTGA26R7hEWx2yrL86cM69NgJrvrPrD8JAYBdkLLitrm834SM7aO2Tm9hicNuQI+EMx6rtgX0ufA3wBFBspdfGzBmUQ6T/vNxlaKSGa+tg9uqswSGfcktMU1RMGpK3axn3Lvt8fTomn0zFZ26J0lV8JcUl+iOStGks1xnZIInBSx38NiGgxA2/hcaaC1MRsy4g2GVlsYO8W3NlUqQE6H40HDs+xXZoXNFBbH2O/+qLn7Tg5DxHXhWSOmQUH5tlvXTpsRHXlR3TMLJkHZcCe/vACPrBk/B6ESzIkVWmmKnLWMsYf5S5MIjtPQygwMuVnmv8WA5/t9jezx6F4SNDgKvWLj1qdy+bvu9XFEnhhM0+Zt/o3+hojNN4tJYQTqAhWCRZRsaOgy/Z46o7AzyU/l6mdZ5V1w+HPci7EFJMbTRS8YdId4igbezg1qVbfr6xaRbThvcptMTdZj6XwAtchYm3p2nQBH+nl+R7I01d
 ta7AqOOA
 pRLyH4NY37K+4KysrBoZ8IoL/dccTjBUYwFAhaETlteOcZrCzUi7XDcqjq2fS1h/VXIW1B4i/q1owHNhm3fhCwBJT2FZ6qcgMCbJMVwDrz2Tt7P+jf0junIDGPIItLpIixvzt3dSErPpZtYD3+mn/iJG4VGb+7U9Xbczeq7/p2u5ME3LP+TL5wmA3xAEmpAgACk9GKnDiiDecRZn6pCdvAmjWHoPH/DNLJJF961uzcsq5QHQWLLj4SUWeKMoQgOGtrf4LluR5ZAE/zxgCOMov4EyE7UfAdfL8aaz1gke1Duy9/VmaZaH97nMRofOqg6KPWa4t6UYRl6wTwkbsHkixnNl3pN/8ciqTcS8qlf3CPwB6JVWi/wglfaeylAKIpXvHx7ZoSlX2u5V7N3gbZTnBmO4+PrMECAFJSsLWfLkOybKOoEpcCJrvYk69xfA3nHUydxAgveY1n6Vv3MYgdjz8lvdiJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename the per-VM memory attributes Kconfig to make it explicitly about
per-VM attributes in anticipation of adding memory attributes support to
guest_memfd, at which point it will be possible (and desirable) to have
memory attributes without the per-VM support, even in x86.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/Kconfig            |  6 +++---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 include/linux/kvm_host.h        |  8 ++++----
 include/trace/events/kvm.h      |  4 ++--
 virt/kvm/Kconfig                |  2 +-
 virt/kvm/kvm_main.c             | 14 +++++++-------
 8 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c470e40a00aa4..60b997764beef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2369,7 +2369,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 801bf9e520db3..26f6afd51bbdc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -84,7 +84,7 @@ config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_VM_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -135,7 +135,7 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -159,7 +159,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24fbc9ea502a3..8276d7ca02036 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7906,7 +7906,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 		vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 				int level)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a1b63c63d1a9..1560de1e95be0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13625,7 +13625,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	kvm_mmu_init_memslot_memory_attributes(kvm, slot);
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c14aee1fb063..7b9faa3545300 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -871,7 +871,7 @@ struct kvm {
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
@@ -2528,7 +2528,7 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
@@ -2550,7 +2550,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index b282e3a867696..1ba72bd73ea2f 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -358,7 +358,7 @@ TRACE_EVENT(kvm_dirty_ring_exit,
 	TP_printk("vcpu %d", __entry->vcpu_id)
 );
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 /*
  * @start:	Starting address of guest memory range
  * @end:	End address of guest memory range
@@ -383,7 +383,7 @@ TRACE_EVENT(kvm_vm_set_mem_attributes,
 	TP_printk("%#016llx -- %#016llx [0x%lx]",
 		  __entry->start, __entry->end, __entry->attr)
 );
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 TRACE_EVENT(kvm_unmap_hva_range,
 	TP_PROTO(unsigned long start, unsigned long end),
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 794976b88c6f9..5119cb37145fc 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,7 +100,7 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 config KVM_MMU_LOCKLESS_AGING
        bool
 
-config KVM_GENERIC_MEMORY_ATTRIBUTES
+config KVM_VM_MEMORY_ATTRIBUTES
        bool
 
 config KVM_GUEST_MEMFD
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 89489996fbc1e..306153abbafa5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1115,7 +1115,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_init(&kvm->mem_attr_array);
 #endif
 
@@ -1300,7 +1300,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	srcu_barrier(&kvm->srcu);
 	cleanup_srcu_struct(&kvm->srcu);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_destroy(&kvm->mem_attr_array);
 #endif
 	kvm_arch_free_vm(kvm);
@@ -2418,7 +2418,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2623,7 +2623,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
 	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
 }
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
@@ -4921,7 +4921,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 	case KVM_CAP_DEVICE_CTRL:
 		return 1;
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		return kvm_supported_mem_attributes(kvm);
 #endif
@@ -5325,7 +5325,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_SET_MEMORY_ATTRIBUTES: {
 		struct kvm_memory_attributes attrs;
 
@@ -5336,7 +5336,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
 		break;
 	}
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 	case KVM_CREATE_DEVICE: {
 		struct kvm_create_device cd;
 

-- 
2.54.0.545.g6539524ca2-goog




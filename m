Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0AECD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF626B0098; Thu,  7 May 2026 16:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51F26B0095; Thu,  7 May 2026 16:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19936B0098; Thu,  7 May 2026 16:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B66956B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76AE51C0508
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:52 +0000 (UTC)
X-FDA: 84741747384.24.B9D790A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DA014000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/T2b4Ob";
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185370;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=da35J6wrqBd5GR1prqvFVMfQOwMwaLra10OKUYU8/3o=;
	b=g9Dao9jXSHFmHq/JRHxNsjAxZRLoc5h46VeliYJ5gVZEBjCqogv0L33japL2beBFnqaG/1
	U8Dk9xzEU8ttkytn4zqLJdDYawUszqUyfnUjOxtxwUUU2swcJnRRmDGRe4WwDLeAwPcc7z
	xudE+7P9sAV21upP7pVWzUcAVCzK1P0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/T2b4Ob";
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185370; a=rsa-sha256;
	cv=none;
	b=mAbl8cVHIlcMn8zQTuCl4sSfbDTFoWbSwKYz4Zr3ACtbSuZUNj0ruSnB6d7PNEBFjagJx2
	/jd2CZUjoiu8z7ci+01hVHftl48Aw4f/+gALKJ5SaG00qeP3Q0b3WPRGJEm7ty7V4KsgFn
	E3FlLSyq8qie0R+DrFFciqKSHTktoGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1FEE4454C;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94EF2C2BCFD;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185368;
	bh=JA8Fi37bShdUwRwGlTf3zYRZQh9CBUDbJAtiXXRsyc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=I/T2b4ObRfIWWrdulLmL1Foj0IEgZM5HidSNUww3UPlgIDcf9X7bGFvFdDOe9I4Es
	 Qr4anARA8+pwBYJhtOIq5nbHdMM+VdpE6laxu92caJIjjSI8NaKyKqiM+oFlqJW5MP
	 td0KbVcrnG8JI/ahAXg5iQuIImvaQro/f3MkVLYfJqckTVj3iMWHH218xU3lGPt6EU
	 rsfoH8VlUylQb5qYeYuPg1oKvHxV+0l3QSs24fjQCrjAhIVP1vSL0J8ktfsLx+XlC7
	 QH6Q7huRjNvuCsEyCiJU5HM0E5SW0YMjWzveDCXUPBb+A6WflU1bRWX12AZ/wRitlj
	 UorPpINdbVK0w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B7DCD3446;
	Thu,  7 May 2026 20:22:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:21 -0700
Subject: [PATCH v6 02/43] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to
 KVM_VM_MEMORY_ATTRIBUTES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-2-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=8643;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5AvW/VD5l4GjbhWw7Cp0M+F0U0H4w9Qg5LEgC4xRgUU=;
 b=ygxPbZxUVtqom0x2rm157yeB/SgbAtT0xd8oCqXIMS90HgbHnsIS8XLd+RQ8CZR+UhklPFIqQ
 2uRXYLf0z0NDuMaCYGUyddoFAbkTbX/g6/YTeedBBZoJt8FdbocRLr1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DA014000E
X-Rspam-User: 
X-Stat-Signature: 9cm3idqqf3fwf3i8ixp43ktfnqz33q6r
X-HE-Tag: 1778185370-463679
X-HE-Meta: U2FsdGVkX1+EvFSuinKvoEnt4Kob+9YJP/T3c5BToiJfRriI9hu6PmyakArKLlj4yzO45dZbSds6eC+xuDkpQ1+EFwugbrfHas68cle6oFzkYmRNzVpam9Iqs8IwiMz637oz82S6ZUv73C0o341fXQRI6PsW5+hyX5JOcUfrEeDErgCHRBFxbXrgRJQDxz6XWfzUank0+q8Qy7x6aXffumt91/3F238eION7BmM7Qv0H9KSmCaoueMBaNGX1gpAcCxPbTZbWTCFnMGdhg/mSXAI14kuJ5eHibmbczFISqwJPkYCA3vZHcZ8QVl8YrJ5UrGNHNCWZQ3TlrV7CSFGEzzMf4V+zsGcGyFv2Ct16Ke25ogiDDtQUtjApibvRsGxA7xjPe5m9h3vktE9lWd4j/hdB+oqI1AI/Hn6cxEOXWog8w/t3yxkQHbcAWSqWQrlLLpu//Ph7pC3d9xtyqShKyYM2/LeVY4QTcgergRf8RFJswgvwbGtO//n2L4Ic92nSUygmDH16DWmY4sCnQ5RH+5Z61OAzQpIuGroy47Z96A+d5f7l8ZgWmOapQFkqZZm7PS0udLLHGI/Hqufv1LHjppgi3D08PUjUs0r3JSS02Hw/DjfftnL6fToRvjaJ1xCOCjf8WQwarOqnYrF0CTRNrf1BHuY/5/IoVPQdhqJeQ24UGV7go1iSnNKIynHkSwbjJ7AaVvS69fs8CAKXIkCRYNYam1XY/7gYSjVw90ThS8xyJiJ7ZO59domIf/kQ0QmgaZSr1OpYSyCPwnWDc/t9nl3XNsQxctDYLj1AUVw+AxumYTMVdLLCjK9JHrE+HBJLZ9YSm7HUji9vL+qo8VA0fwXp4GkLLDPiU3EVV7mgrJCwT70H8+6bMgsuvzbT0s8N1wSVryG8DlkSRtfKCLKivRuTvvzjPy/tsmDeO6S9SBIAztqtiyR8Pz+EvIwKoMWq4s2QmkhggBhen7+KNmc
 mUIxHsFB
 5a4Db/F+YQu3FoTw1ZeAhLkEwrUjtO1BwNVfeXIKpTWgUCpRFs/+qePHXIKSx9m6Y7bWMcI1zuq0w0XCE+jSvV7uThTJoimBo/N84dDm9sVloVw5uunm5XGLwIJQ/aCkxfOTY8e7K71mMurhweuBUri1hwQeDaOWPwLy/gRI8j1SV3cvOapbGRfSPXqqUOfTME4dRThiY6z1peOlqUNHfCcaBI1+ZqcEUymcxLn0DHeehHBxmU5ryMO0kveuf6qd3A3qy8qp91FXs0/U5IjxmgAUvXxVegikSZ+RfSy+shVoKBUY/kazvMk8sDDy3PtZK45iKqeB/n9vJrRrHe4RxL6WRg/oZst7o9kCq68sSGEWaHZFIAkzygXRtnNcdc6yMu6Jkg+0F/0k1+SVuNAx5wIc2Rf5ILny9L6vGzxvKZ5FMXB7/wwNrB0Y/twrVqss2Pyj/AbOi1cB2jTVe46ksXEX6xA==
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
index 892246204435c..a80a876ab4ad6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7899,7 +7899,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
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
2.54.0.563.g4f69b47b94-goog




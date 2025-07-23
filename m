Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C356C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59EAA8E000C; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5772F8E0001; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E7D8E000C; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 296258E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDAEB1A0638
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:27 +0000 (UTC)
X-FDA: 83695202934.12.7593567
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 21AEF1C000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Crs6nftd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3vL2AaAUKCIU2jkkjpxxpun.lxvurw36-vvt4jlt.x0p@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3vL2AaAUKCIU2jkkjpxxpun.lxvurw36-vvt4jlt.x0p@flex--tabba.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267646; a=rsa-sha256;
	cv=none;
	b=Jv8Wc6VKjwCEsxEAz8io5JlJXtk0vXr57T34Y+CwNpekUEinqn2MhlJs26cI4FLLaiw8Qp
	66T2sa7xlJ5Oi6PNlhy4yIjTe2+FLMbIydIvKnseH/QeBOjGB2McpFy3TBCn+n5+TgPQeY
	QQyv6PEOKbP2yUQOC5jILS89oPWNvtA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Crs6nftd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3vL2AaAUKCIU2jkkjpxxpun.lxvurw36-vvt4jlt.x0p@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3vL2AaAUKCIU2jkkjpxxpun.lxvurw36-vvt4jlt.x0p@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVZMjpRm02pM+s1bH/p5kOhiKIrqbu4P3W/nBYdl9H0=;
	b=DDVpOhHerC/o5CfHW+mhLvgd/xBBslaJkKlxyGYTEO7zrfbuzFjoOF++9G1vyRu5+nu+l7
	2ZjuIMG1laPCvDB0064sws9cuXqzETz7N6un6JmnPNIAmY24y26GXWGDuGGw35w58Rxmb4
	fAIHg5UpN9GLsa1OzC2knyrHUUmiYwM=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f8fd1847so2422697f8f.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267645; x=1753872445; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oVZMjpRm02pM+s1bH/p5kOhiKIrqbu4P3W/nBYdl9H0=;
        b=Crs6nftdHvuiL/qnCev54IygIO7UzWxIIk2rr09jIq2oMLSNMfl/DjwHSCh169RBJQ
         qWhSqKursAXuyUoCAtSC2xlUxdJKwgCK5egfSCX5CyJ//OVLCUu/HafNc6E4fjAoa3d3
         CoOuYEKjdsghYClXBtq8JQNBZttNS428ISzlIOIC4T9HtnndkC/MF/+KNhmV+wTxDxig
         NexXEaTh/9SzDHcJ1wCLP/6CLPPUsHo96fh+npty8NlxSDkSNWdd5DSMqGeYbkyR7/BO
         vswP+FNag+QAu/BMa7H+v/YyUeLgN2n2Q6siHHrtx1woukvpx3/F1gvGqViId10KH1un
         cJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267645; x=1753872445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVZMjpRm02pM+s1bH/p5kOhiKIrqbu4P3W/nBYdl9H0=;
        b=vUoUclyQVkjmcJSNzyJD4zBLitVhJMMqJ6JmRKtex2GPxkYiSc9asIrdL7PSBFSkKI
         f9+PndF2hp92AvtX7zKnM/9VC+SwCHCtVrp8ejqbBNGLFd/WnA/KLMmU89RP6TinmACk
         dvLdYjqi2dbWytcyZrO9AaQwTBRSDnOFPSuSQC7SLVSJQuweoq14z/fIWbLnvWD6eN4s
         5OE+UY4eDpkC+6XzGdtE6gqNGcDiWwwNda0klqIqhs0XG5QcCSI/zSEajfnaaeQBhyGX
         jmD0z4wrmw8PTj0J9if0RLtyB0iQsXrN5G4n0AS2Msue3fGaRwc5MYw1BEqGY1JX2a84
         2umA==
X-Forwarded-Encrypted: i=1; AJvYcCWDdfjqGhlK3pZv4NtanOE7wV4tt9NPMk3Wljx0dWHqJyvEOdCivw0cbrx5uaAQlZ2clXZR8BDY8g==@kvack.org
X-Gm-Message-State: AOJu0YyAo+yPH3i9JTlYbmKMwGpjxS2tVAwALtHZ6SIVtfVqc7wgbslm
	sMwlPI0xyWzvmvC53CCFg6q+BkW48mXzIdRc0Q9Dby7AZTz3BjFRPbXI9uB2b5zrX9vWiG/yVa7
	fiQ==
X-Google-Smtp-Source: AGHT+IHLzuLINdJSWTguMGiWOg3ozLl75dp1Qprfo0bHjzS8AWsGSIsnNSxbTc+BmMB/sQkP4J6w00TZ8w==
X-Received: from wrjb12.prod.google.com ([2002:adf:e30c:0:b0:3a4:e3a1:4e8e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64c5:0:b0:3a5:5270:a52c
 with SMTP id ffacd0b85a97d-3b768c6cbf4mr2019207f8f.0.1753267644477; Wed, 23
 Jul 2025 03:47:24 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:01 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-10-tabba@google.com>
Subject: [PATCH v16 09/22] KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21AEF1C000D
X-Stat-Signature: acs3k7j97dsbei7k3s9equj73wt69sen
X-HE-Tag: 1753267645-635873
X-HE-Meta: U2FsdGVkX1+z+XquSJWMjVEpmpY64my4nckg3iD/DEYNGMYOI760vBP+xDWIqwzZHMV/KRNCRr9NAjpC0Y9oBKUsq4CDL2RaHBiT62BniQkscQjy8J+YCb4e/DO4LfwnJ6WVa9FXOvNsIK4aO6F1Jh3xVpLhVMigQkhq9esrHPgwa2tHUWitb/mnO8eut9Cok6e0rDu+8tL5tD3xM8SRrYHvACy0TcEDmWycZfP1IqJM9+YocGqVsxS1sCJcLDkWdf63pn5oY+FyKSPu3Em4WLQQytiCLjYUpZ9Ja6gtpPyTQeRpXGFsOswoxa2ylS34soguCq9BvrqmrlAjcpa50CUXite5q3aVI3FFYpd7g9e8jQla5oUxZPsPIAqC1n+RC7i8fU77qcEMlRkJ0YNdc81Y8xg+m2h/hEklqTeoNkX7jqS5S9kYyBteRhswLX4qvCDzaffibXDFC9B6WFK7fjMvqtSC9acQypSAYpW/SM6YIzwwlUba94gMJbRtLdfS0m+kJytOPO0WRn86UFp0uwg4N3IXAR4K7nPitI2seGdM0EhPYbycqss5wqnEFXnAgBq6uO8vvwZi32Pt/LS0r9ErqnJahdAEnEGXqqb79HlREGwsyMy+Mb6JwvFkbqsNv/qe0YSnMvPlBnBeV3EaNHU0POtxPt2dKUP17WRdUuBOtN3JgDxc/HDwCaXcUtdaqK2igCV6npz9+VTViv1M3WdqJxaXASIyYJ0PN5s0XgpCya1ugxxm7WKQcSMAaDyXbpTe7pm6FyRbkRZt0R+O12aYBho0vU4+Zq37gVSxA58L2Xjl2vkqT1mqdl8/HJ/WGsITATqffFljudqDX7L54o7l+k2lK6MS8PvWsPnMn4hcw+gDJwp4YvOEgNAgHrDbLi1h7ylWFJZhzAsKm55Gc3VvtcN1CNBi6zvOSJ1cBEp8LdxgzBTUpWfE8S37tJ5UGy2LeYiQ0tLpZkI8CSk
 HflEkVeQ
 HYlv70bmFXjmFfUWrrhnvAtLE6UVvJXs8Dka1tyib0IqEXVIo2Rg+zFaz6a7L93jtUIaspLUWBzNc4tOBBPFUf4v/XutAQhN4c4xIFl3wdunSS8SwKPhBbiSpZQdNGInurmFj/Lw35myhPRqZ6jOpFumc0+Qk7bmZKq0eTCO1Xf7qzYZkIsKrwguPG4EINOeWc2chXWTeWrW+jThd+Z6Dx4I8iTc2DhdwjvEPkxF+zJ030+mHPkBgdQaTGT8hjr3XXjlppbHYaX3gR77+Dh/CYI4YeXhTDc3VYVi0uWSS+AQ+HRcKRCtTvGLoik7CM6EgpvIFmRA7sKhfqJjByCwRtZFef9pyNlYedKtOEc5meuBk8WieZJTFb0vHnZNAAUYUBv03sJdC+sbj45hRw1oT6KJlVjKylM8zYuR0ppMqv8GLVm58LDqS8U/UMWjGfYVNzIy9ec1VV/X/b22LPyucrjP37DR4BwK6VrM1suhm5fcxF7DFrAYMshZStGjnHxYC3vE7+aUraxlTKEUDElsS0D3rqOyESSgJXqMU1IoA1aqXS5dmWzKpX7WAJTFgliw79Ey6nq904R/mqQSum2c1apTHdUuWWWD1Ers0f4uOg11dCNOyngEBphP27JijapcelakTtxcxbpLaf0sLajslXffbNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable KVM_GUEST_MEMFD for all KVM x86 64-bit builds, i.e. for "default"
VM types when running on 64-bit KVM.  This will allow using guest_memfd
to back non-private memory for all VM shapes, by supporting mmap() on
guest_memfd.

Opportunistically clean up various conditionals that become tautologies
once x86 selects KVM_GUEST_MEMFD more broadly.  Specifically, because
SW protected VMs, SEV, and TDX are all 64-bit only, private memory no
longer needs to take explicit dependencies on KVM_GUEST_MEMFD, because
it is effectively a prerequisite.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +---
 arch/x86/kvm/Kconfig            | 12 ++++--------
 include/linux/kvm_host.h        |  9 ++-------
 virt/kvm/kvm_main.c             |  4 ++--
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0f2b3e492d..50366a1ca192 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2276,10 +2276,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_GUEST_MEMFD
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
-#else
-#define kvm_arch_has_private_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c763446d9b9f..4e43923656d0 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
+	select KVM_GUEST_MEMFD if X86_64
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
@@ -79,16 +80,11 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
-config KVM_X86_PRIVATE_MEM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
-	select KVM_GUEST_MEMFD
-	bool
-
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -138,7 +134,7 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +158,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 56ea8c862cfd..4d1c44622056 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -719,11 +719,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
- * enabled.
- */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GUEST_MEMFD)
+#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -2505,8 +2501,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_GUEST_MEMFD) &&
-	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aa86dfd757db..4f57cb92e109 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -4917,7 +4917,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return 1;
 #endif
 	default:
 		break;
-- 
2.50.1.470.g6ba607880d-goog



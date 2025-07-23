Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D59BC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3E78E0008; Wed, 23 Jul 2025 06:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883638E0001; Wed, 23 Jul 2025 06:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773348E0008; Wed, 23 Jul 2025 06:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEA68E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AF0B1131B2
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:23 +0000 (UTC)
X-FDA: 83695202766.26.1D09FFD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 59DC3140011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SisjHm6h;
	spf=pass (imf09.hostedemail.com: domain of 3t72AaAUKCIAxeffeksskpi.gsqpmry1-qqozego.svk@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3t72AaAUKCIAxeffeksskpi.gsqpmry1-qqozego.svk@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/iLEXFMU4kw9alr2fNpv+K1GdCI87fKjWZbDt0URPA=;
	b=ZS/2/sImW4V7oBJNOoFDsk1kOwT8IHQk5mdo26v+T5LBPwB5lYiOywdiAkNof46S4rnsv4
	Fxw7u4h9iBTbJMWDsECDxO/ehXGEgVLKbFsD6gPKBLQoLKtPjU/k3SF5aLjM2RI1r19aIJ
	SSKmWVb+uOokES9sZnz3qpMPpzNqvUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267641; a=rsa-sha256;
	cv=none;
	b=zAOyE8CVvqBomnwShx9EkYeem0ItfYXtFIn4LvfWikl7mcJqEcITe7oxEQA4pmzJ/ku0kD
	m89bM/HneB+2Zbgx0oOnmLECps52aRSd6fNr6/AA/eddZ2YRd1q4VDm7Fw31+Wned7A1Kx
	X1sHEM+khJUIoZbezK+muXbjk0H3IMI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SisjHm6h;
	spf=pass (imf09.hostedemail.com: domain of 3t72AaAUKCIAxeffeksskpi.gsqpmry1-qqozego.svk@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3t72AaAUKCIAxeffeksskpi.gsqpmry1-qqozego.svk@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso42567065e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267640; x=1753872440; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/iLEXFMU4kw9alr2fNpv+K1GdCI87fKjWZbDt0URPA=;
        b=SisjHm6hBu1C6B/Iwl0ICuCqzvpnFs1fdts/xXSDbrWK+TyRgDDsc3EJuG/CKpLbBx
         mSjfcYMtpedu2mms8kV0yVXUfBbwygsbuDaqQbdlcjtbhwuE93k94bYewwGj/5ALlvfg
         c7cXKv83zZN0jRreDs4a++ghCYQP42bHX7bCmnbfftycmmqOHbwWdmrkpZ3hUdsSBvik
         FGzCRXpnn648eoof8QSZ4uCZ4fE2/l1NUk9vw73Zu6qQJAhPj1JXpWo4f/Hy3tvrcU+6
         h4ZQJCyuhYIYszp+LxFbVUCo81gxfvCQauhAa1bet+TrDa4w5pXJE2qN77Rv4F4J34pn
         iaog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267640; x=1753872440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/iLEXFMU4kw9alr2fNpv+K1GdCI87fKjWZbDt0URPA=;
        b=J/NGQmVG9AzMWDpZ06ERK5kKEHhFAq3ih5FzJqNBvwghFEGo+k9SjHkTpalhiEabX6
         oam8f9JoOK3AbpmVyKXuqkDxiZrrd6fY5rQA7xGozBXUe57XnUOGiLfNn2zuqXLsNinI
         qW76+iHEiy244fIlqR7R7IykUIGvgdfXoPICWdZpZ/eMqtELMMOYKVzOuAlrtD+eua14
         12Azp80a71J6TGlAekgp6epDrsETb7e7H4LU+gqD0OFWxUzhECAcDax7BW10kDFQ7kHM
         2XLgDrVpLELzID8oPkY6ww3gVRnGfP906QsuOqz0Mz83oLiRZCA9UQ4wV/ESZdAB61o+
         TbJw==
X-Forwarded-Encrypted: i=1; AJvYcCUcxxW3d+R4K4T3SgtsImgEb+dzxzGUtvKF27rhE1z9a4xI9h1C6aHcCztvpOQXd2TzVztzuor5Nw==@kvack.org
X-Gm-Message-State: AOJu0Yz9o8pc5x1OPPxDA9Ql/o9ACItSGsvZHbNuVpbz/5htJzX9gqc9
	CtCqd9FAj3qEraA68UNxscpTj8gyOLB8g/4qudzyYYhy6MrEpjiPLs4M3feoTdk8ubqtWqFHozP
	YBQ==
X-Google-Smtp-Source: AGHT+IH3WXM76dEJWXSMwuAToHQi81PRJw+VhhRbD1bW3aY/uCINmpRjg47P6NrMDnaKGwQgz0FVu4rmyw==
X-Received: from wmhf21.prod.google.com ([2002:a7b:cc15:0:b0:456:23aa:8bf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e28:b0:450:d3b9:4ba4
 with SMTP id 5b1f17b1804b1-45868c7903cmr21488365e9.2.1753267639741; Wed, 23
 Jul 2025 03:47:19 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:57 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-6-tabba@google.com>
Subject: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
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
X-Rspamd-Queue-Id: 59DC3140011
X-Stat-Signature: 8gsbou8igxwx5swdc9i3kuorpqmbgfwx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753267641-492393
X-HE-Meta: U2FsdGVkX18BfECIVVRJRVdL88ErRSHEWNyJOhOuSFKdlA7UcdKcpJepCYMVLZdJlD59x1dhiwyvEtSlSRQCuCufJJ0UtHl4q2uKDDYW9V93z/L0llgFtz/7Hj235XpuurYCzyoIXFBm70uOUMVaUQKVrsbTj1KEo9Rvu2djA56hFMPZJNDKDgErsR+oLkdQuf4KpdkYk38BO+Xw532gaGsN2aCv5Fhp+wBNFcbJpZmmR2rYdyuheJX6qS90MjcD1rjxlGEKk+deCoJi204z8FPyd9Zisml44Gp69P2cuDXT9Q6lX0OxxNClAe4HemgI4j2zdGfVmSyq9PH27wjjGjQvTRfWNs8DLy2ItN2H4Vyu+wpwDPSQ8BSeHIOUM3qKu/fZuODSG2pdk5bfb3+h66pI+S09DmCkvVjAsMdX5qm3I8PN8oSVwAeL5xtgTxuWO4Y/JHENXNM1iv3dyiXWOVzWH4uGlnzCN0Ky42Ii8u66QT2QiM8etMsotGYuVQRBJL/PR6003RzE4ujpYMC6/YHTZvHBXahTw5+NsFQYARGZ11H4fy0Vg/IgN5EwmEEKr2iA3DCpuvOtMRt0Ht5hB3rOZiHVnDD5WMFtHG9i13qza+pi3QnSbQePOAD2j0uG2Uv8KRODFjOEl7HlTlsheuIGnP6OlOJFenvWnuqoVS7AdUCXwaDa7LZLuXCKHBEQoknVDjndCwTc1IMDHtlYFv0kOorGg/OM1bmse105PvMf91mUtXvr9moV/QuaJZQt/hDOcYtrj1sD1d7lzT+Pvx/p9KVbxzuvlw7d3FD+PVOWrnsUw8r9sINllbAOKFbNYCbmw59vGnJNVO9BW+PzQfNapHtCx23nhENlWrIOT7TDAz6aVkLYDPjpZCGUr6g85XaT7pvNsU9PuaCe5QCC6xo8EoRD5M8NqKHDKBVBs/KQ7ezD1eOLM2typUfh+SqmxZhJWDTZP7HtXtQuzv2
 DRf/jJCM
 8tvMi3JsQgTkw8i5fHxXrGr+mOf4vEDgsqhKk8Hz2nmBl7iO2nq/TCoBLZOL+RwX8wt4m/fhAj1kpQjlq4atj2BVVh+leMQeBpjBkorD/C+/blbbleCUJIIlt7Y//to+uZRfzYDJ24l3Q5UI0Ltio6Ai9UNJqHvvifmfqqXs7sAtQU9x2DmwzFEdqyYieucmswPqPjzQs0oeqv7ZCHXLhL4oAS1814c6KkN+guoEfz4mtOeD/lei2tDvDQcfp/a/SlNdfKPkBpmwc9LFAFjDqY6/AInKy/Ea8SeoCS4lH8ORYCDkeUCUUj9loiSjMmzTrj4hJ0/nMVWTkktAZIemhSa+8xv9qBYw8IypxvwqPl90sNFEnMyCM+lB2AkHI4EAN7iQ4duzevIrC4AuTRBWaAAS3kqA3mLnGSjUWJZO43dKyC5hFEPuEPTvTt/kVeml4oFNASk5y1nYL7CXjFxOyfR7R5igMlXbWjaHqLE7dQgXvIUXBgiL5+wb2CPXOYRqwosiEvgKXxWE/QF+LrBfwPowDx4Djx+aS1xSYybI/BA3HDzzG7mTlY3YcHGXkaNIEiIBZZgt0K4o2R5u1r0F6GOueRp67PtkY34Wehfaykkx7VfcoxoFVGYvaNL88ar6Ly0lhy94kcjIUHr5CkYMfUy+yYMaV7ZnUH2sfs/0gGew00iQFmwddK06ZzhPQCRz/Bd6F+wkh3SJKVRAftEk1rWiUsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The original name was vague regarding its functionality. This Kconfig
option specifically enables and gates the kvm_gmem_populate() function,
which is responsible for populating a GPA range with guest data.

The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
option: to enable arch-specific guest_memfd population mechanisms. It
also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
options.

This improves clarity for developers and ensures the name accurately
reflects the functionality it controls, especially as guest_memfd
support expands beyond purely "private" memory scenarios.

Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
function. Therefore, ensure that the correct configuration is selected
when KVM_SW_PROTECTED_VM is enabled.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig     | 14 ++++++++++----
 include/linux/kvm_host.h |  2 +-
 virt/kvm/Kconfig         |  9 ++++-----
 virt/kvm/guest_memfd.c   |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 13ab7265b505..c763446d9b9f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -79,11 +79,16 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_GUEST_MEMFD
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_X86_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -133,8 +138,8 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_GENERIC_PRIVATE_MEM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_X86_PRIVATE_MEM
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
@@ -157,9 +162,10 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_X86_PRIVATE_MEM
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching encrypted VMs which use Secure
 	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8cdc0b3cc1b1..ddfb6cfe20a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2534,7 +2534,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 /**
  * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
  *
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index e4b400feff94..1b7d5be0b6c4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -116,11 +116,6 @@ config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool
 
-config KVM_GENERIC_PRIVATE_MEM
-       select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_GUEST_MEMFD
-       bool
-
 config HAVE_KVM_ARCH_GMEM_PREPARE
        bool
        depends on KVM_GUEST_MEMFD
@@ -128,3 +123,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config HAVE_KVM_ARCH_GMEM_POPULATE
+       bool
+       depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7d85cc33c0bb..b2b50560e80e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -627,7 +627,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-- 
2.50.1.470.g6ba607880d-goog



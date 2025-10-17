Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF8FCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04E88E0010; Fri, 17 Oct 2025 16:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941A88E0006; Fri, 17 Oct 2025 16:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793D38E0010; Fri, 17 Oct 2025 16:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 632928E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6C2C13A753
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:34 +0000 (UTC)
X-FDA: 84008703828.21.BF5F8E1
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1BA8B1C000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eZ3Ge1pq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3L6PyaAsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3L6PyaAsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkQY0C2GyFxGETmxiim/CLb/uxyqVUP+Le02f+YwSp8=;
	b=ulCQufCXu7shyVRCI1OYaNSHq4U+NRWJ5DhQmu55iULjgeFUc9yVp/eQymo1t0y+h6lp2l
	/NCUxF9RlBF8BLIuANZ7fun2+jMZ2Lhflv8VBbYUtKZPiRl1jMK2VnVJAtf8kT9zzzKcyz
	dNG/EQggrS7ocz+96W+kz0jZEejv8As=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731953; a=rsa-sha256;
	cv=none;
	b=xd61am1hILiLTQOfffmwN6z/WFla5SZTP9RUvsSG/bXKDtEqlA7tbibw4ZHLrhqttJFepE
	LEqGpoVRYzN1wZEpAmLuGNba4rn+OkEAFBGjGaf3Gz2jWHv7Clq6JfP+MVg6DMgMOPR9jT
	Y9nYX4KtKmmIheeJ2pjGp1bB5EfRX6g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eZ3Ge1pq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3L6PyaAsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3L6PyaAsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so2198890a91.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731952; x=1761336752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YkQY0C2GyFxGETmxiim/CLb/uxyqVUP+Le02f+YwSp8=;
        b=eZ3Ge1pq0t1jWJZycM1szEN1jCD/2mUW/DKYcWKi6u08lBiYDZ1pFDpYckx8B5neve
         0khfvyyH5aLuSjcH6hI9u2BHgB2sgeFCqE7J+LmBPHUGSliTkGsfaSKYowX3QzT+XhEP
         ijvhp2hL06iBcziDGUuITyhSKxgcj7mXBk/CGSaLaT9GrOY4Is453BNTunKzcLuzo1Z1
         mSQXihBw3HWReZstTFTGuCH7vMOzlrRekzVs2j9OSPRxIgLRDbnDvahwyzkA0Bwankhx
         nEfmo4v0EhBYGoUzjfvzjVnW1pJ50U5kgMfmG1X0ELIj0Pq1dK2MG0WG/QdijRLrDmNo
         JInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731952; x=1761336752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YkQY0C2GyFxGETmxiim/CLb/uxyqVUP+Le02f+YwSp8=;
        b=wp9kDJ9wCzpEDcXQijQvhgqWnzYlkxUUt3pOS25baWSbDc80bygHK0hC9fRGDSofIA
         AmxOCc7R3ImWWs5nz3ujh+P9QKTAA3cpkia7fFjBEiwaHaKL0QoLz2XxVPZBLF5CDWN4
         OrjJT2KrffuFsaMHgJNP2Lq+10E64x1YIguQZaInd0QIKi+6gkIUUA/q6LDFZjAA1Kct
         zkneiyk+RcwRZW2kMvOyV0vtIdnvnz3Z8zd44ec3iuTk9+tGXST5DHAEtacifSm8MfzV
         Pohn+bv6c6KWQv0IsTMxRxwubSaFbiYP+oiJAy1pMPoQEhuOBxhafMCYMKGCyHWR7fqt
         QQww==
X-Forwarded-Encrypted: i=1; AJvYcCVRAZdbfemK56F6uLK7lx7QN6/TSidB7gIkJSqmU8XDPTR308+h5UyRZ1XP3d/2sF6JX/8ZZibJ4Q==@kvack.org
X-Gm-Message-State: AOJu0YxZ9B9hbpz7WMNzim5JgR6jpC1bJM/v6EKGDNgL0oF36DCGswk5
	JY2Q/eds1b6oWKBfmka1YWKyhG7HFUpxtFAM9aOgST9s8bBlI3n92D9iDJlO0899ziJn56QTVRg
	zHDcxf6XauWs3NBJweKlbjBhEfA==
X-Google-Smtp-Source: AGHT+IFkGPr4YdLNxY8qTP/AAx1XyUe3sO+8GjEBnMuobjzPF3tU486njyTsE2mHlvi3N0LFt6amdyv+9G2JDMbdOQ==
X-Received: from pjboh7.prod.google.com ([2002:a17:90b:3a47:b0:332:8246:26ae])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:58ae:b0:33b:e034:c1c0 with SMTP id 98e67ed59e1d1-33be034c22fmr3157843a91.23.1760731951854;
 Fri, 17 Oct 2025 13:12:31 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:43 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <ab5637df3ddbd8aadcad6ef7e4b9476ac3bd80af.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 02/37] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BA8B1C000D
X-Rspamd-Server: rspam02
X-Stat-Signature: e77d6yktrbbubwcmgw7rgx7du3hp3xf3
X-HE-Tag: 1760731952-44578
X-HE-Meta: U2FsdGVkX19YFdJ3+v9Hjp2TiC4iYXQLfAYJk/wsn3pu+XRbH/5KAkUJziZsUPrroYubMjzHWTNQi4r2PkzkqSCZf4sD21hx05oMrCqOgBCmjUZNeM6+L6hyaIJdS+JseGNm8J5bW6q59iCthCdJSOIPdt9SQSeXXDLzbwacFkLkkbya0VnKFKMgDcm5/5X2DdDgSC5OwfaJ0fvEE8BG0V4niOHci8Q4I65v+5XsEX/7Sx7Xw1KNBLUcPiXcJ3kaeFJ1rqmjnPIy7Ryldpk5XM9QFGMtV1eEZa2pw4ZlaSt1nevbdkpjTsOx7E61eWtVMPw2QUcqQ5RaXtCDMIQZ748uOQJ7ze2kL8OAhqYO+eJy0QdtAzUYFG7/LmdQ+xd06woLWQgBPcj1WJ11v9aphrOG22/mKxDundkJn+PfZpH8rp1gtXIkR0cdK6AOxzrZzoV1riKLX5bUZQm0Yi4uWTCT6qAl3ybRWfdoUtRx7UdTCxAZiUHBQiV+9sJJK6zPLYeTcB6u9JGAKdJsV7Iw4/oEOEwH6Y0bWN7ERaoDRWvGDvXIbRvhCWVbBZrK7Z0FJ3wYPSDaHbs+lwW3S+cnlS+R28snxDGNNNgfoTIJMHDrPY7LLIYwp/zs90xLeSiLkvAh4CHta2tVnK3oWaFjCq1QywHyvwgLMC9e18a/3t2ldA8HJKiYNTWULcseo1VHCFm2QscisrfaNVO31eG0EWqQmg6ZIIjSgEisIL8neJ9n+nLoBS755u1FmioEu+46G9dmTtyY0s39Ti2IUQzJIaoIBwlRKlyQJHJgySo8YU+SdmbsUjdeWSi1fitREAbumRW3MG6PE+G1YMXbiAQOoXAX2eOPM0L5CNgHPuTKGSudZvt1Hp5m0sADiR8R2mC3lLdB4G2zNb3pwnxpwSqYcx6Iv6KLOC7t4b+t6qfW9MVMjHTqA7KITIs1G4Tf3ZH6ETtYe1pCIEbzNC7x6mv
 g9yOdyC+
 1Lnn6dK2K/rjKkGnD4wbhzDGnpXueYo66uBXiZKJMzCTmobwikDDkxPyfGrGGmoX68y9ii39h/Vx/pgRgu6+oml6FWXDH3XIN+KUk+Zf8cZBegAnYQI3Tt9ns7q1waFLwi5IIGJtM3bFwI3bLcrUe8q5AX6gowWR7ih4uHykpHRPS3YD+Hj8Om+JwI/ugJbt/pHdj4ijDgJU3no0zNPDVjlF3K9JH2Qz+M0NgsPYpGmpVzSJkcPcOtnYSi76KbdURGxjTwhJENLuaPJ3MSq9Y1/NKmUbV4i/0eFQhSkbJk9FZJsx7KgYY9066fvmJYx7CR7wA8YtSjMHD3xR5LP8ZSq08l5B/PT3k22us/SwR3VdISvCNLrn11lQGl5ieEPPccXBt5sTOEeBe7ADtM84B61PaBnRoUw5DbaxvMgCso8B27AhWsuN2lgLlCAhpCxi7o/t9C4K5SB97nGaBVvg9M4WC3F7IWSrm+gazszai8w43DAxt9P0QXYSq+MsPmub7HdDV3C5gX054rozEqNV7A7AVilPhbjEOAXfx/ZnBmUuNyOzzRdIM98v0zsY4jgngSbBqJghRvLdAdtCHl49o7N5MPJavNIWVLm31ntD5HuP7DMo5hJDZF3SV+RidYBrkIn6BGP7WxjPXn0osSstyHqEjTyKzjpldf6L8ktNIJo1Bo77kTa0KmT8D/mKwt2IXg5hLZf+Ag0AE6YU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 48598d017d6f3..efb0b2e1808d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2301,7 +2301,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 4e43923656d0e..acb03b45ba050 100644
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
@@ -134,7 +134,7 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -158,7 +158,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5e..e4542b37b0db6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7808,7 +7808,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 		vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 				int level)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe3dc3eb43312..5e38c4c9cf63c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13398,7 +13398,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	kvm_mmu_init_memslot_memory_attributes(kvm, slot);
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 680ca838f0181..fddb373fcbaaf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -721,7 +721,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
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
@@ -2514,7 +2514,7 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
@@ -2536,7 +2536,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
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
index a01cc5743137c..9dd7873114b59 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -108,7 +108,7 @@ config KVM_MMU_LOCKLESS_AGING
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_GENERIC_MEMORY_ATTRIBUTES
+config KVM_VM_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4845e5739436a..f73047ea4333e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1131,7 +1131,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_init(&kvm->mem_attr_array);
 #endif
 
@@ -1322,7 +1322,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	srcu_barrier(&kvm->srcu);
 	cleanup_srcu_struct(&kvm->srcu);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_destroy(&kvm->mem_attr_array);
 #endif
 	kvm_arch_free_vm(kvm);
@@ -2425,7 +2425,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2630,7 +2630,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
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
2.51.0.858.gf9c4a03a3a-goog



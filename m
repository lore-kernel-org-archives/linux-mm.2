Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42EB010AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0186B008A; Thu, 26 Mar 2026 18:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697A06B008C; Thu, 26 Mar 2026 18:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512466B0092; Thu, 26 Mar 2026 18:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407B86B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 145AD5CA04
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:31 +0000 (UTC)
X-FDA: 84589644342.26.C0C674E
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3413DA0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BFCSwJlV;
	spf=pass (imf15.hostedemail.com: domain of 3G7LFaQsKCOoMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3G7LFaQsKCOoMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRzhOWKsVJmkjknbsmsUCquvBozs/br4JAMQ/wymcsI=;
	b=d9DAjK3k6sAgLoWW6KqFv5BIuSqbklPl/TJ2T7xJ/I5ENUFCT8VPTxthsGUYcQV+rT9Jk1
	rSOw05NSB2W95n835YFZKCZ3Gs7Q2ya7GQnWkkQXA92BGjF7cwDI8DklxVkBg/w2agTS1O
	TMeqSEqFYVZv9K390KMmj82TQsjx0tY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BFCSwJlV;
	spf=pass (imf15.hostedemail.com: domain of 3G7LFaQsKCOoMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3G7LFaQsKCOoMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563869; a=rsa-sha256;
	cv=none;
	b=2f8UFIHRaAfh+py/jvY0mMYB7apEq0UCICO0+FA7k98yii1uYjh9ya/avg81ImugP8hGmk
	LCXphlraDzGrLKk0DQzJlbYbdR3w4Olh+htlfjyR2++pt/xSwtdwTF6EzDN3SG1ZZRcgCk
	fkKSivKxwG8Nj8P/2EMXCSct/avF4wU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c738bebd53fso2513454a12.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563868; x=1775168668; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRzhOWKsVJmkjknbsmsUCquvBozs/br4JAMQ/wymcsI=;
        b=BFCSwJlVZyr14BID39JHF6f14TD9XOnXcpT0frGnwhfegtT2pz8gsPW4JJHNKFq5yD
         8oKrBC9S0om3BV0L2t7325GXlOZdCarAcBpM3lqJQ6FbeyAtnQ92iAF/6QYEAt/NT3Yx
         k1f75kFBDsGbvWhuhGiedhecCeHXoLmYyTK34J4ju+oS0JFYC0V0KbJ50msrDyb87u95
         1HGeZ6k5ISr3UZfUBRwhMqC8TYKszsgj0AWjWg1ytQ4BT79yyfl42uXJmzD7pBxzRpzj
         0l2hsVoqwIQNop2ZkBAA+n3iu67EKCcTXPC8oZ203yQ+Q0ytv6w04M0OAQioQpzLnNEj
         FPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563868; x=1775168668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRzhOWKsVJmkjknbsmsUCquvBozs/br4JAMQ/wymcsI=;
        b=dGF5s82IZiyyiubj1yyLFjXt09eAC+BA811zcMtvQppDRFGVxswjxflRiFsiy8ls4y
         7qvKO4SgxOEvu0BWxFpK8O3gsL75DDc+HE7/jyXDmtk3iVFeKvG7wU7pDme3ie8WuUfI
         Ngk+mVINZogzmAD7S+/TVJm7Iy+WDL3aM53KJDb6Om7zaKkdeZTlK9UdKYoi+yPNktSp
         iQhbjdIqDAp5vo6QjSzJxkiNov+z5NYcMped2Xn6Oa0I89LgO9yppaNYgfEvzjRGke2w
         5I/ORNyxNNm1beGq7MYPHENzPasZBnKPkgsT8TszhHTOlxRuY4nroaZmSkpJUjB09Xy9
         5Jxg==
X-Forwarded-Encrypted: i=1; AJvYcCX8PXQ4+9fqaZkcWCCPVaLkYibKQiJ0eqIODju5VOsOTSnKnDpKh3Gle+MXkgVSzrrX0cDWuwTnVg==@kvack.org
X-Gm-Message-State: AOJu0YxqVjrTMxOzZ3cc2Yplrb77+5BXAj7/xuqg2jcVxXbDgC9nVcYg
	DGXaM+0u81bivvbSiIEBkI3pA+McUEEK/2y19MajEGQqaJPpSlIH2CdQFxiG4jugsaft4ZedI8x
	OHMov4zLnnQ2lPBQhZYozrVy6dQ==
X-Received: from pfbmb26.prod.google.com ([2002:a05:6a00:761a:b0:829:a3d9:9345])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:938c:b0:398:7874:35d3 with SMTP id adf61e73a8af0-39c8787ce0dmr349724637.10.1774563867320;
 Thu, 26 Mar 2026 15:24:27 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:11 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=8590;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=W1zJkAfZkcw61WvJ+RZ3gwzvU8jdJUXcVpR4YoBXm0g=; b=R6/KWXLba+toxe7GZnl+/a3Ivn6ZDGzwkgdfWMGavAFcE8OXmHI6WDUv2dCoNkWsNwNwKMkc+
 ZZPmatvckdoAa4iACPXijGshHI1bBWO0jucn2vTG3lzgv6vD7SoXW2F
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-2-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 02/44] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3413DA0008
X-Stat-Signature: u5c1ceynejtg8t5wcbr9qh83neq3k8kd
X-Rspamd-Server: rspam06
X-HE-Tag: 1774563868-190407
X-HE-Meta: U2FsdGVkX19+ZtNkl6qyWOf+ODgtVSQU847wTnA/lNMdPPPjTBzz29vs/08QSJWUZrfZ4WyFVxGKXVfuWDMhnQJc+yO5Y+3ppR6eVXEY2srNWVV89EaqBumFfu0dM1pr7Z2KAcS/6MvxWyjjv3XQWQ32HwBYIOdqFqTXIqgbtAc7V8Sm0Fd7hszC3/GTnY0kjSybdrIt4r1eg9piZr2S5zASIkCn97HzkWa8gH2KKwZhXTJgIUiS2c3WjnYRD5mfJTivPJUilwAXgjuTZ7DQQ0aHMuhunHInk+i5jWo39vBgq2lCvAT2W2xHoxXW5XyPwPjhUv0n4zJSOy5F0G5We8nZQ4C7wbackYYufudbYBSzKQAfIEud1jZnaeeR3Mvm81j/5YFQNO2DMT3oqplzqeZfaU7QqT9NskUi+V5E8H7TFrbfT7tnGUPxuYhDPuyyErw8JjIvLHKmHHF8FN/rwG/OS9hhFigAnTaWmiGWV/wSU2uqIuGVL/1YPz41vc4n6dp1k5k6nHvBekgmVKsC5JTqqg5SNkrSi1bFlAR2+zLTrUQRtLKmLavCAfd7CaiJj0VKmd3wOhL6+Vd8iSv35oxUjwLazv34zvx5w+K3azRcEun/e5CPr8hcUnpURwUz5d1Uf1y1C3YwNxQawGBzJ4wTMGhP9k8R2Ec9qyY2yZzwVTzQ3PPEz0OOz+ACmL0xr0aiEv6AYruaXdhIvaPptDcJ0QKZkJ7iii025m9z9Q7k300/6OEuZ22uhhRGP9ab5juZYcOEupAOD5NYzPJF03HXq0IVw+FmKCd/XWMdl0C7pKeh68aeGqqwbYdUCngkEzDOc34tUFY4qy7Kh7kopEviRko9txGDvaaonT3VD/xhhJ/K/dKHpjzHl9RWudENQK9xSaenumbw3JQE47O77l8GZoIOFY6VOpnXmtUVSJ6/X9f4nGl1NQaEl9rexg8Fj0DcNtggCu9rsLLikNx
 tWKst2H9
 eb9HdRtASDfPUHDVJ+7ujqSTYS3lDmY9P6tpQNUtx/dDn/oVteEMIyF5Tye1SQB1S/3telsNCE1ngVHt6x4rteWi9rZL2xVyD30KYZ9l9xvJgQ2PxlG5tHK2JgPV3G0DyfUNPF6DJCzGztvynfFzprpPXwlKXFu2dkEyJ3rDtiHD5ra/dFM9NaTNjT5b5pNKXHf+YhdbbsvATrYZUj+D4DS542aLK5zd2UBOAVUwDtepjjVbMqhUUsQLGkdChKuPPl9PU/bBLEo1kyYgPeBFzi8KmDFRQ2A7ubMo8lmzEaMQ8k3Sobqsb0y8zcA7IZ39AmxzbPEu254aZPP0HTe1nAE73fabnbW4PJSAQEbGs4WzmBArurPbhntahMlLyY4RGknG1nm+ruP3NXBqsc0bt/KerwIP09OjVxmO7Ojz/UednZevk/O3Sj4rCPQkjt83EqnhCPLRoEMTZrvRiHm50QdpxTcEB7V0HachyUh7t3TiA1P1ue9JArf+XWHI9ypTEDOYaovZLoZwKFPfEmh5qBRSM2V9oqDlBa+gdkPqZjEMy2jyNzoWfg7b10X4iCBOwbgkjYPsB+KkCQwV1b44g7SD8yUH/g5wMpkjPERMRaTGS1IVWPbkAbvrAtE8KoEiTcZcvZG6VjC2fioVhI+ug37RNds8uVyovny7B/mIkwfnpvr6GrfL/mk8wkQlIkCZLmGebUSarfHzhTNu5eJARERf5EQ==
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
index 6e4e3ef9b8c72..cf3d2bdababc7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2329,7 +2329,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
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
index b922a8b000577..792701b093234 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7889,7 +7889,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 		vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 				int level)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd1c4a36b5936..7e133a9da11f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13509,7 +13509,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	kvm_mmu_init_memslot_memory_attributes(kvm, slot);
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6b76e7a6f4c22..e75f7295af5d0 100644
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
@@ -870,7 +870,7 @@ struct kvm {
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
@@ -2513,7 +2513,7 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
@@ -2535,7 +2535,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
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
index 9093251beb398..301d7ddac6ba6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1122,7 +1122,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_init(&kvm->mem_attr_array);
 #endif
 
@@ -1307,7 +1307,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
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
@@ -4928,7 +4928,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 	case KVM_CAP_DEVICE_CTRL:
 		return 1;
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		return kvm_supported_mem_attributes(kvm);
 #endif
@@ -5332,7 +5332,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_SET_MEMORY_ATTRIBUTES: {
 		struct kvm_memory_attributes attrs;
 
@@ -5343,7 +5343,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
 		break;
 	}
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 	case KVM_CREATE_DEVICE: {
 		struct kvm_create_device cd;
 

-- 
2.53.0.1018.g2bb0e51243-goog



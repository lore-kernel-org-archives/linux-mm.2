Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6F9C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB016B0099; Wed, 26 Aug 2026 05:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382756B009B; Wed, 26 Aug 2026 05:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248A36B009D; Wed, 26 Aug 2026 05:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E99D76B0099
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43E1F4031A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:17 +0000 (UTC)
X-FDA: 85142869434.15.5D1311F
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7360FC0009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sdS+6jSY;
	spf=pass (imf22.hostedemail.com: domain of 3Va-OagsKCEomowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3Va-OagsKCEomowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBz9N4MFbqHkEOIZ4nKMBqouKjOi9Jg3kSfpTttXCxI=;
	b=zeW9RCfOlqF1hoWHQ7kixPiMbhhPspuqAY4dd/KMV5fcqJisJ5kh5mjcFNryp0ua3ZDpx9
	o/X2GLMY2vDen3Lhh5e5DELO6z6ajFZ4fPmo1/f2zmIQ290zZ/QmamfysCd+kTwVOyZq35
	oGI7VTu31r3450mahp3W9kFZMIb0lLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735895;
	b=jR6ngJOnbO3OeLauprmwlh4SvKo3PlRmnpRURyDsfT0fPNd+kyJZOJ13Jlj9XPT9ZY4ROg
	X+nmlDBsEXwdmtUBulQvbLp1CeUYUsrASUgMUutZhJughSU0gFzpXREijtk/6KDTUMFaQM
	Bv9OAt5RA0HUne/XsWXlcWpBdrWODKY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sdS+6jSY;
	spf=pass (imf22.hostedemail.com: domain of 3Va-OagsKCEomowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3Va-OagsKCEomowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d04908139bso12124245ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735894; x=1788340694; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBz9N4MFbqHkEOIZ4nKMBqouKjOi9Jg3kSfpTttXCxI=;
        b=sdS+6jSYgQVB9dfBgH1CRaAx6gZtFxSYCReqC+fafPfGEIoI0HYzmexyMkwoNxiqR8
         oCatGCOVTAT8cbqtCZ8NAdUX6uWv79Q/uuKBAlPFut2dqnzxt99ILmLlblEERvu7HW+u
         vwn2Bu+y3qgqkRYNg4BxNmtWqlaiACys5jZqVISU4uIXpg7GsBao4yLrXisb6Lgsnfaf
         tXkQv06FlFvF9P8rSnt8SVjX8KwnAdUrNXuMoaQYO8KH009G3RkIh6057Q6Yn0fqszUh
         7Qvv/S1q7LuBcKO4+dwztW8Xk093GNq0NRt1B5DlIeDhtxzvlHFYmftYF72RWw188lNm
         BYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735894; x=1788340694;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBz9N4MFbqHkEOIZ4nKMBqouKjOi9Jg3kSfpTttXCxI=;
        b=fruAVlFljMOihxfj/Jhg9lL3F2E3/jmi3q8qpW30mqQSlBi6X+e3DaCEMhy+wRzcXm
         lotevpA1et8kPBUU4uleeV+XaIf8dP2lRX27627e4CPH1aeVxX85CJhcoWRuJPC7fWlW
         EgAeAcX36H8WL3f3tiGojtuP72ARUGuwFVBSTuRVDeGx57W+GBIYiqQYTjD1AHEjrLb3
         w2mquSS6KaBI8aLfFupqkwrJu1NSH9OmLMfAONH+jvtTekHgGv1xN99fRogGHFkfy50F
         GEcr8zGlv/TezUZoD0es0Mup4l3nYn69XJeY5CwoGCTJ//XQzKVkbnFoBWmxzPG6KFuf
         QJtg==
X-Forwarded-Encrypted: i=1; AHgh+Rodb+jeu3OIEewBy3JEcYXC83yVuoQDRUeOeTTaT3WI0dQN3J62WXoNMLkAPB2yGrQHMm5pAA2eoQ==@kvack.org
X-Gm-Message-State: AFuF++lPYEv2Y+0FyyefdxJUipAGtahsucQIF2dHPDuSZaNVg+bkZjZV
	ueZpDG6SUC/eBwY7dq+iyvH+DiSENmCT/avzFz2Hs9KmjyxvnThFOUNe1fSOAsgsfd45/MbgQmG
	xfMhw0hh9H5YfRc2C2P7Rv/8TYQ==
X-Received: from plv18.prod.google.com ([2002:a17:903:bd2:b0:2ca:b907:d842])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b24:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2d707954e7amr92794715ad.3.1787735893912;
 Wed, 26 Aug 2026 02:18:13 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:02 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=8898;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hQPdfbzAcJ80Cu7pf4GOOlMLi8LkOym9DUQ6K7ygW88=; b=Mj2w5CpRm6N4W+MCTHfhjQSjmqnutb7zrhZNzMCgBzqdxU6jlb5t809lCBh5WWIiVPZvXZulc
 zV9OM+FTWayDcblR2qgsxFMI9EpxlNVZazn/9exm5KXRmu2JWMmhuBg
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-4-0a15d8a799aa@google.com>
Subject: [PATCH v11 04/46] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
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
X-Stat-Signature: zgwbi6jnhu3n6ztf6xros8n89pw8y494
X-Rspamd-Queue-Id: 7360FC0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787735895-142684
X-HE-Meta: U2FsdGVkX1+IqzBvwwz/CkGuvXAGbW6BCjMsEhPgPy+bMc2Wf6HTqC1FHIvnSmyUyuGVK86F1cjrhf7YCVE4cJVXggtPfoWQXOqtMyPjgkM/lQIwhoF+epulwgv5v5pTYwvCiHXGdtT4PGYL9HBM7mXATbnY/K9/OY0ZTV1L26HjNqqXrB5UepDIGhIklf5t2hqhlulrBHxS0dVYoAcJAFjn9xJn2U6EpFyogDu+HtvLSuLGg8SFb6ZZT/iU5dx3/qlT7ziMp6CigOIHC1VaIicnFg7MLWZH/Uikn1DMihLf+R4fpUsNTJWyuIzgtKKNHMf+uGrtjI5gqXrCp3k+uEUlOIfLcul5AZv3zjWKOOXPFKpyB/n4iYKbQcCbsvU0rjOh1J4S1bZ4LxP+3oR6GVDiTYclpeVwNjBI8X1ey9zQCI1X6KNRGNzLs6J6tKv+6kn+y9QZCjRtR+j4KbC/8uAT3sUDRVttyGZGRcuoWY17gX8OWJWc/hlTZ3GUcZ9w9YzHwu3/hKzzJpqS1VCdFFApYr3gdU4LMqOgkDxYcxOkqz0VFHTdSSkUqxsyW4KtpSBYgdgu69Hs1aTI1jtaP5iv0VYm3LncGf2pzqAYZhcbNsVItsz1/XTGEQnIEU/x00/ou2zyXi+uCaNbhqdOLBdmthlkajoJzsuTNiyEgVhSQrJJxeOhhigkiwTN1ifgW07zfkJ9KktSWvu90Yb+bWHhtTliUkc4lCW3oCJs3f7dReqae8zxylv9gUEzYsSfir5/LmR/rQLfxZeVTTiEJoX4xlCzbLVr9Lji+4x6klaA7fg8Ufwn4sd4cBCNmdDFb2mbCCr4B653QQ/CZkMYet/ZVCXg70/m8/SnWV7HhG99uY1e23XRcJx6RbXvvLScEatg65P1hWWhNEpwkzMkGcTynl1w5nDcoQi1m6+KwHst8ELKNfKCxHAZfRSosLcoID5z1HxIO4BTd4ma/gu
 1vNA4JPN
 4A1wtdguDpaNlQQ/aaiajUKIPchjqeVB2HnqvihOiX/O1IkpdryHP5l9JAynV2bvM8xjdA19NZxXEmNwpVSj8Wvi/DxULyFKsTcfmjxj0UrrBBk5RLPiZ9OYVxw1PbBU1vEs43cLAU/2Rcw4DjGgwc6nzonCJaHIErxJhmoV5lmGdsbHPXuDSLaeWm8XiyopC+7Rt2xCyfG3UhHy2oZb7535ElsMsGDe7nzO7f5HVZPWkJzBvDDWliBLmfdzs+o0tKTYAQOw1tLo3CqG6iCjwhCYKvuNaFi0e6YSFc8rUEhGeK35KfTCE5D3AhhCIjkij4tGf0fqpEaS6QqwxWStbTn0yAvuoG3v1P5MDedA08JCxm1z3GqklAPnOGoDSRMmVFSQ5yFSYRvcYFjVYHiLv4wqtOCeyvjil0NgjTVodM82y/2EGLmucZTtvdeN368XlYTV96QSbGYSWMFGTQvoZkcWrhJxVLF9tSc1JxnmchdNai1e55CYGUW6sZrH0FyvggJabczEWyFYeDe/xYO5sw62pp/Xi9t+SYVXKIpxNrwDwNZEvvHlfs1OATgPU5II9uleuW1A/gR/M8I4K+sdiQZCkl2yMlESrhuu2R5OCNYj87UiLxfh9wWYbjz+hPCIH9/ZgM6ivJReQv87T0IVVpHP6AR3doXz3hEkqoYaI2JNKZ7mPL6wXQA/oxI+GiwqHI74irO9XhQ/pORb0RnuitT6fPg==
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
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
index 6beddd8a0c749..744c1f6ff03ed 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1851,7 +1851,7 @@ enum kvm_intr_type {
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
 	 (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 538ed1e803326..2f8e1b5a8a72c 100644
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
 	select HAVE_KVM_ARCH_GMEM_CONVERT
 	select HAVE_KVM_ARCH_GMEM_RECLAIM
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 947c9cd843450..b88c00e11854a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8097,7 +8097,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 		vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 				int level)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b3681796c752..29e41d334cedf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10140,7 +10140,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	kvm_mmu_init_memslot_memory_attributes(kvm, slot);
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b7516e19ef419..cffa16647f2ab 100644
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
@@ -872,7 +872,7 @@ struct kvm {
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
@@ -2560,7 +2560,7 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
@@ -2582,7 +2582,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
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
index c3c0ee253fc77..df575449d97b5 100644
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
index 65eb26a0520d8..7d5325e3cb44b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1116,7 +1116,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_init(&kvm->mem_attr_array);
 #endif
 
@@ -1301,7 +1301,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	srcu_barrier(&kvm->srcu);
 	cleanup_srcu_struct(&kvm->srcu);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	xa_destroy(&kvm->mem_attr_array);
 #endif
 	kvm_arch_free_vm(kvm);
@@ -2419,7 +2419,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2624,7 +2624,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
 	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
 }
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
@@ -4941,7 +4941,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 	case KVM_CAP_DEVICE_CTRL:
 		return 1;
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		return kvm_supported_mem_attributes(kvm);
 #endif
@@ -5345,7 +5345,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_SET_MEMORY_ATTRIBUTES: {
 		struct kvm_memory_attributes attrs;
 
@@ -5356,7 +5356,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
 		break;
 	}
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 	case KVM_CREATE_DEVICE: {
 		struct kvm_create_device cd;
 

-- 
2.55.0.887.g758fc8c411-goog



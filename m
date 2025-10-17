Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA13FCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D407C8E001F; Fri, 17 Oct 2025 16:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA218E0006; Fri, 17 Oct 2025 16:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B650E8E001F; Fri, 17 Oct 2025 16:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03058E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79B6CB7FF9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:38 +0000 (UTC)
X-FDA: 84008703996.09.1928242
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9ADB940009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4fP3Bn6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3M6PyaAsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3M6PyaAsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X801w8PuUrJmaegQKcScTVv31uPM2rOwC4B+emIFE+k=;
	b=cgFG0riVf8WlrPI48dL4+RNWy0rUzMEPeSIaE0AKzR/2G3+1F+4CA+X4RJs21IOjHXu4Gv
	8N95UjlaDsCKgJDcOVcX55LtqyxyGZnTAzN+3hZJfNrkNXjFqOdImFoql6tR4NwUXWY/5t
	UJPTBdQd0HFDylfnmhTCsU39P1v8Vl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731956; a=rsa-sha256;
	cv=none;
	b=39nf+PBhU82N7CKVc5n1EaTg7Y7plzRpqkl+tNvMrYEDai/BaoNufnztd670UVe3g6nR9J
	DpauJDsalnzLLPNYvphWQtmwBeNkZmlmZtsD8XasVjQC1JOc7KfZvM85Cp7099CwtNmBA+
	+vZJLMEfGxxR9zYYqLRh/IQAF7h+l0I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4fP3Bn6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3M6PyaAsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3M6PyaAsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so1789280a12.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731955; x=1761336755; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X801w8PuUrJmaegQKcScTVv31uPM2rOwC4B+emIFE+k=;
        b=4fP3Bn6ND90+t2iznmKRE+pVd6pu57s3ov1+NEE77wW0yQ9a8BO/HYZQeeUFmmODKZ
         g7mtuJvWXzi0uPYTG0Pffwu4O3sKavvObgcmJy0RO8a8z2Sg8fLYNVXSd32jUqWZ1D7y
         GZSfY3411hQCcYVUBUHE7gDd4zMuyh4tfLQAY5Yn3AJ1v1fNc202nwgoQRz9mC4PbQhI
         sC5xs6UUfMquL6/YP1Z6b4FjERtG3kOXh3pZR97M/QHLRTYxwQDkNKxkxj9CSsI8Ki+G
         h4LmcfMP8zrtc+/EycAP8dM8KHjzpbbGMZz6Cf2grAuWGOOS3EbZJZ9wEUZFFostj1I6
         MiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731955; x=1761336755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X801w8PuUrJmaegQKcScTVv31uPM2rOwC4B+emIFE+k=;
        b=Uao656CtQrfxhV9mRqqY8ujD9pAf5Ez/zNb/4H7Hfg0R4a6f5b4LzokYyp907tYITs
         CTqjMe2ufoklfnXXYjOKU5ALS+qN5oOO6i1iGI4MV/dwfneByJpgeyHRRnLH9++SMT9R
         iIkGCymltOeOnoorWpiYhe56cnH+8U7MGfSm5CKE5HBlRH0cvDHEcFtvCK97w4G+Fptr
         7y7NBJkwChTfIxlLFGp/kIcV+O4YV0iwaol4ByP7mDLgKiEkt8O1jVflnU4seQvXv75H
         eKuI3U7tlI9TBWTeGXyGi6LidrZzjEq63XgpQB7VDJj38dLs3864A7m956YT7vGu5S3f
         qnoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkvFTQR/E6Y1bQ137fIpyf2My5fbDRScaWWWD/KSbWB5Qe2yr7ARlM5B2k0yqwDGaH0DvJ0cBPJQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3M3nOay9k/6ad21DNGt9P/TMa9m6p1Im9VfI95RkXFdTFyAAu
	RxEPfmcmyWYnpQPUE1wqUBAb2MNW6cnyiG4Zt5rJot0UZqqdFfWK9UQPinJhnNTpYp3Ta3ie/b7
	PzuG3yi2D8fj15SSjSTVj2XPsWQ==
X-Google-Smtp-Source: AGHT+IGU4C5ckx0x3MXQbWEOI5N6qnZ05m/AWSE4UXdG4wN2ZO+xuAl9xRpx3d+vYpPUkqqKlpsZCTwULeIPVKxVzA==
X-Received: from pjbnk18.prod.google.com ([2002:a17:90b:1952:b0:33b:51fe:1a7c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d8b:b0:32e:d282:3672 with SMTP id 98e67ed59e1d1-33bcf8e4a07mr5508977a91.23.1760731955330;
 Fri, 17 Oct 2025 13:12:35 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:45 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <2737fd9776aaa1ff7537244e128083ace0cf2cc8.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 04/37] KVM: Stub in ability to disable per-VM memory
 attribute tracking
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
X-Rspamd-Server: rspam01
X-Stat-Signature: px84gbiw717yyrdaqz3jq6iqnohjkxxs
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ADB940009
X-HE-Tag: 1760731956-68730
X-HE-Meta: U2FsdGVkX1/n+wlufvtYMGh9FmQJKBw39iAavsZmE1jhc+NPRjXBWDuBvKpqsBDilozXp5ED9wHtxh8h2IzOVx11jO+d/QYl/CmVPvUr9k1TJ1SwoFZTbQlV++jlvm3sLOiPd3QCtBxkezk1c0EexYZp0Y0xFDmKKd/HUhP8Aq/VJJjtplal/L7TGHRRoXfENKfZ5WUYn6I8mBUyaDGyRhsglGH7BhPRFcWC8p/8H6UJR8MyZdh/PgMLYYBVHsqeb8PzzK/5eXgeCu2cCJqJW3OAdJg6f38WDYyGYOVyn81uAsKRfEmdKEGdKiOO/8Jxy2Bm/pOJUTAYnewRzW8V5fj3Il5mDbDJqbrXyCtx64FFN1UlVN62XNAU67jnQBvD8vaq8NJm6Eqwyt9e+zIldEEzKhKdVHy5IMzmfZB03lWriFAu4nXFt3SG6b3U3FP7LET2P3kFlTglceQSKgY6pC517/+gmc0QCfYEKG6XX78dODiz6pWXAoRa+IwE8uA/6JmQOisxTfXOMUuRzvOpYTlZ1FW5PJwGZRTJFVn5Q63FiuVQEFicDwt214L/VkYp4bg/Qx48mogHlxO0pCjE7uSBIrOFwC2eS8RbiaXFGt08OHYDW3AEDHdnFvQx+vqvHzlqFLA1+AXURoB5unf8eBwDfhoPoD3q4rLWcLPFlSoVq86OXhKUWMqg7J09n6NMktXdt59J2iDfyZK1bEDxXAko4Ilnoq1h2h3MxurGCAyzBs90TrdPua+2/Nv1cdX084I8fvHlfQfQ2n+RKVqJmK8hjIHXp9rwbFnNgfpOOk4Yw7XKlCMKJ5GwifftMCfMMXWKOtBUkB7zRVB4NJ7mJoAUSfdw4fQ70Ey5U+EgU2tD5CtcJny2l7CR/IKcccXDHiQUDZjSUPvNwKaUT5WKI2cDoQWt6u1EB18RbL82rhXdMm1cIJRLrnz9IWMPh845IAUhxOf537zI2OZmT9r
 wJkDAM3a
 HJhs8OdPOAM16q4rkSlO6sOGkNVWlAabZvFjjF0sjUE1sT1WyXuY7jdinc9ZjHAdm7hLSSmairmTsn0sV/sgqVRts8ERpfTRFSbGNZZoKXkWwvJliw8zz9X6o89WMlVbN+7Nra3RP84dZd8d78A6qpwoNNPlrSI2OSF5GvuDcKlQjEtvUf1QgJJJOcJvBFjW03JAvitLrsFfMkLA5b27fNCIzuHqV7A4Fr+iuJrvy5ke8p49Zb63XWyj9GmVuoaiJGJwgBUyfxz1TehSUPyVz7wmyngn6wW3qls7GXEhc767hvoPhAWRdub3p9TOnbatQVYxdfdHVMS5Cnu7p2ZDlTSuNmOkqn3y9gTcjXylBsWE+6FIgCoZyzjkCoxh+11COOgZIRqqjgP1SgKHrtzjSGy9Ne9ZP0jL/9C3DXzCCzRo6iqu7ouI8InTWytAiofysslWtF82qyMuVwCx7jjFVoqM5ITNxUEEKUcWZdHhA+X1CYzTJr30oIbJGY4Rvui6r/JDnZRlbTcQLNWDRw/ATlsTqKsKDwJTq5rQWGQ/Y0g15gmIv4oWfcNaUcD/fKiDpAfgMFNgpPcGoW24iWvDr4ctJpaZs+fDTr6nQBzCQSrbUOkMhNExAMw4c4FqF6lWOP1aOt+uTr2m+L9D1aZCyTHOHqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 23 ++++++++++-------
 virt/kvm/Kconfig                |  6 ++++-
 virt/kvm/kvm_main.c             | 44 ++++++++++++++++++++++++++++++++-
 4 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index efb0b2e1808d5..197b28ae0e28c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2301,7 +2301,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 21bf30e8d3cc1..512febf47c265 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2514,19 +2514,15 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
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
@@ -2536,6 +2532,15 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
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
index 9dd7873114b59..395996977fe5a 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -108,10 +108,14 @@ config KVM_MMU_LOCKLESS_AGING
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
+config KVM_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
+config KVM_VM_MEMORY_ATTRIBUTES
+       select KVM_MEMORY_ATTRIBUTES
+       bool
+
 config KVM_GUEST_MEMFD
        depends on KVM_GENERIC_MMU_NOTIFIER
        select XARRAY_MULTI
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 591795a3fa124..6c29770dfa7c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,6 +101,17 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool allow_unsafe_mappings;
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
@@ -2425,7 +2436,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
@@ -2436,6 +2447,12 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
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
@@ -2632,7 +2649,24 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
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
@@ -6513,6 +6554,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-- 
2.51.0.858.gf9c4a03a3a-goog



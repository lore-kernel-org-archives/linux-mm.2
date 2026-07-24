Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6559AC531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E436B00AB; Thu, 23 Jul 2026 21:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEDD6B00AC; Thu, 23 Jul 2026 21:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD736B00AD; Thu, 23 Jul 2026 21:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 232A56B00AB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 070B480268
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:37 +0000 (UTC)
X-FDA: 85021953114.21.516F6F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05733100006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FOFqOuMX;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmG4KDvtxag7hsVnR/hZC54Qonf4BczxEK6GS3DrpEE=;
	b=i9PlbkveUYyMLz3xthf7jY7GK0SvCDtvziqE9OnvWMCl4ErcoqvPcdYuh+l+YCLo9di1n7
	TK+cC19HllfZBdRYxqPrvKGcXe5z9CnAT1u8DC78AnFq3D0ROpk9fztoPipeqnU5Yv67qf
	Ddq3d6CdukGSqh/4oknnunkCv5QbCO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856935;
	b=uE/ym1T4aFQiG6nWDJhu4e5zHRDbSvW8ZzD4LGEi3HZDwJKYmhYfj0kdjwIqfAhhLRk/EX
	p58ntS3rR4C7Q9VtBVptHzeg7CW8gTD5CZ9GZ2AL2dSsph4fnrYeDhD96tEVDmxAzg/jXb
	fi1PkJhu63MV9OWptWgopsnEoPrF7W0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FOFqOuMX;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmG4KDvtxag7hsVnR/hZC54Qonf4BczxEK6GS3DrpEE=;
	b=FOFqOuMXM2NN0upw/K2Q9ym4v43eygOlKqS5t4RITK7uckIo/BoUez+2DjYYX61Ve8DZ7g
	bxZEIg/OmvTOKy9YVlHxbu52Z4OR4/taVoNEqKPw90bLsGKKKnEDxgFsAd3XOaQoMa2zy4
	Vz1gwVWNd9iVFcjTfvW9DQiJO6fOxk0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-nBgHwHz4N2iQtQ_cZCqREw-1; Thu,
 23 Jul 2026 21:35:29 -0400
X-MC-Unique: nBgHwHz4N2iQtQ_cZCqREw-1
X-Mimecast-MFC-AGG-ID: nBgHwHz4N2iQtQ_cZCqREw_1784856926
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B430183130F;
	Fri, 24 Jul 2026 01:35:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04A5C180059A;
	Fri, 24 Jul 2026 01:35:22 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 12/14] treewide: introduce arch_has_pmd_leaves()
Date: Thu, 23 Jul 2026 21:34:16 -0400
Message-ID: <b6799a44719adc8dee18810c0a2ee223e713f756.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: BaesND7EvWX7eAnksk70yGpcLP3utbJTVVMZn5QjULY_1784856926
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05733100006
X-Stat-Signature: t7i3q9t5rtntg7qwjcs4fhw5wzqxrtn3
X-Rspam-User: 
X-HE-Tag: 1784856934-130744
X-HE-Meta: U2FsdGVkX1/TfMevBC1RQrG+B/vixg1TjeAKSoCnuNcM+UwvU+2oGq9tAb56NPnzxoTP0XZ6DaWCHMUiy7HU03W3mTUBuYkl/pDA1IQn+V+odkBxuQCTxQhmhnH+HI9aEdS5It9rtoBXU/buia01vaUnE83bWopXvEtytbpaH2JOi0XUmuAs+KpJR0zoQhXQ+/lKSB5FcU9W/9axrrg9vrz27Ubyp3+Rk9QjBgWa3PwPXNonR1Zm0gKJADPHCvfYgXyXvE6y3IGL2C+a2ET7cDvqJOPQEnvtHsh9zMWzioA0uazbD8/KuAcosMhdJ1NbCwQAbr+pkYcYhuyj3JO3Phs8EY01aHrOI4+JWXyxSUpIlDeEV239TowLyFM7OznOoBjOPlEc7XE9bL7czYC7AbDfj9ua9UdGc1VzT7KyawTH018ykLS71SD6J7SCGNsXMR2yzq8XjE9dNBUmQGZywmz3Dkzs0CU4R+Id+SF0p2sOYXXDpq3zORcwuXali7xIt21LlhZLyEqDKJDWWrcmk4b9kAiFknfeLVfqH+unZOSljl7zj52DAXurV5bKbYik51AeUomt1OrP8GtLwNDVlyDdggMNsAAPd7anJRj1IS0CnijKcNDxeDlvQtRzx8cJdggF+2D3zEj007CRmVW4ba0WXEB9+ILFRXBPtKMLbpUj/UmO2Kdr3ZouSsVk4hLfeCU+Cd0BTR8NrNdVoagXfnewoNUQ34kbXNK8I20BGUp+21uK62RubfQuEh4svsn5u1k+k5grM1dgs8yJpS+M2DzGeWn4ofW2dJ2bDqQ4q+tEOrC5PmOeCg4efOcJfVrNdDHPUfDI1t0z6Mhu6SUj4PZ9lBjy9XUS1On8dK4thwDLnAL+o1CD7Bjkzg5HfvqShhgdlVEP1UbZzYvAfQmIgOgE7mgBINcR3Aqrfjz4KyLvBCAgSJHc2EZTqk6/qkloqilIEiNcGyzLiZf+V14
 JpaXNgGR
 aMd7DI2leS9d0MceM2toeOPPv2OrA5T6dInVxGOYPpKyWFnJTTzO1udNFnyuHhn57Xdb5vNsnky+p4PHNI02zT/dwyAuA6LsqGlMMmQmqZEO1uxmphdw0N7mp/iS24FcVfQLmpCCT9nt7/4uDcTrr9Ykqz6T2OXZzl0TvtGuuNv6h9vyp356m4MwV9crIfWlEVldV3Se/MlZVmnQzyPzpkYoR2DHNVY5bR4f24plJOrMrC+i5ZhLflOk+Vo4WMUVTlcFGvM8ASZHhweNE3FLOV7igfGAYGyyqVSlHx7R4KZMvrv2pb+6kVtIPlesONhKz4qo6wqfncvqAa+aHfNhsvgCoVgVNeI0oTEbFfCnLlxaSmGjrPVd+1jn6zGoPl6ZPPAV1O4yvkirXgZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the has_transparent_hugepage() callers have been converted
to pgtable_has_pmd_leaves(), this commit does two things:

1. Rename has_transparent_hugepage() arch implementations to
   arch_has_pmd_leaves(), since that's what the helper checks for

2. Introduce the default implementation of arch_has_pmd_leaves() as
   IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE). This means that if
   the arch doesn't implement arch_has_pmd_leaves() we default to checking
   CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE as a way to determine if
   PMD-sized pages are supported

Note that arch_has_pmd_leaves() is supposed to be called only by
init_arch_has_pmd_leaves(). The remaining exception is hugepage_init()
which will be converted in a future commit.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/mips/include/asm/pgtable.h               |  4 ++--
 arch/mips/mm/tlb-r4k.c                        |  4 ++--
 arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
 arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
 arch/s390/include/asm/pgtable.h               |  4 ++--
 arch/x86/include/asm/pgtable.h                |  4 ++--
 include/linux/pgtable.h                       |  4 ++--
 mm/huge_memory.c                              |  2 +-
 mm/memory.c                                   |  2 +-
 12 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index b038da872ec6..2a0a7ddf8bee 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -740,8 +740,8 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#define has_transparent_hugepage has_transparent_hugepage
-extern int has_transparent_hugepage(void);
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+extern int arch_has_pmd_leaves(void);
 
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index f4e369342a56..9339ebb0815f 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,7 +432,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #endif
 }
 
-int has_transparent_hugepage(void)
+int arch_has_pmd_leaves(void)
 {
 	static unsigned int mask = -1;
 
@@ -448,7 +448,7 @@ int has_transparent_hugepage(void)
 	}
 	return mask == PM_HUGE_MASK;
 }
-EXPORT_SYMBOL(has_transparent_hugepage);
+EXPORT_SYMBOL(arch_has_pmd_leaves);
 
 /*
  * Used for loading TLB entries before trap_init() has started, when we
diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index 79511e6abfca..d532e3f0dfc3 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -167,7 +167,7 @@ extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
 #endif
 
-extern int hash__has_transparent_hugepage(void);
+extern int hash__arch_has_pmd_leaves(void);
 #endif /* !__ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
index a4a44a112ff9..d523c80f44f7 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -280,7 +280,7 @@ extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
 #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
 
-extern int hash__has_transparent_hugepage(void);
+extern int hash__arch_has_pmd_leaves(void);
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_HASH_64K_H */
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 2a795f6d9263..41166d44fa75 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1432,14 +1432,14 @@ static inline bool arch_needs_pgtable_deposit(void)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-extern int hash__has_transparent_hugepage(void);
-static inline int has_transparent_hugepage(void)
+extern int hash__arch_has_pmd_leaves(void);
+static inline int arch_has_pmd_leaves(void)
 {
 	if (radix_enabled())
-		return radix__has_transparent_hugepage();
-	return hash__has_transparent_hugepage();
+		return radix__arch_has_pmd_leaves();
+	return hash__arch_has_pmd_leaves();
 }
-#define has_transparent_hugepage has_transparent_hugepage
+#define arch_has_pmd_leaves arch_has_pmd_leaves
 
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
 pte_t ptep_modify_prot_start(struct vm_area_struct *, unsigned long, pte_t *);
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 50545cf519bd..e8b74528953f 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -307,7 +307,7 @@ static inline int radix__has_transparent_pud_hugepage(void)
 }
 #endif
 
-static inline int radix__has_transparent_hugepage(void)
+static inline int radix__arch_has_pmd_leaves(void)
 {
 	/* For radix 2M at PMD level means thp */
 	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index 50316f3fc5d3..a67bc1723404 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -393,7 +393,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-int hash__has_transparent_hugepage(void)
+int hash__arch_has_pmd_leaves(void)
 {
 
 	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
@@ -422,7 +422,7 @@ int hash__has_transparent_hugepage(void)
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
+EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 5aa8f621df04..24ee90c7e9bf 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1827,8 +1827,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#define has_transparent_hugepage has_transparent_hugepage
-static inline int has_transparent_hugepage(void)
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+static inline int arch_has_pmd_leaves(void)
 {
 	return cpu_has_edat1() ? 1 : 0;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3c62b33147fa..3c6a641e6c21 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -331,8 +331,8 @@ static inline pud_t pud_mkspecial(pud_t pud)
 #endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#define has_transparent_hugepage has_transparent_hugepage
-static inline int has_transparent_hugepage(void)
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+static inline int arch_has_pmd_leaves(void)
 {
 	return boot_cpu_has(X86_FEATURE_PSE);
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4c00cf53e183..d571d161a84b 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2344,8 +2344,8 @@ static inline void __init pgtable_leaf_support_init(void) { }
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
 #endif
 
 #ifndef has_transparent_pud_hugepage
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 04e8a6b55343..3f3a929e3069 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1010,7 +1010,7 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!has_transparent_hugepage()) {
+	if (!arch_has_pmd_leaves()) {
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
diff --git a/mm/memory.c b/mm/memory.c
index d6540d6d4ef9..b0d3a8a8a25d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -169,7 +169,7 @@ EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
 
 void __init pgtable_leaf_support_init(void)
 {
-	if (!has_transparent_hugepage())
+	if (!arch_has_pmd_leaves())
 		static_branch_disable(&__arch_has_pmd_leaves_key);
 }
 
-- 
2.55.0



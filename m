Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 295E5C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39A26B00D4; Mon, 31 Aug 2026 23:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BC96B00D6; Mon, 31 Aug 2026 23:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15D26B00D7; Mon, 31 Aug 2026 23:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 583016B00D4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3E98A02B6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:37 +0000 (UTC)
X-FDA: 85163723274.23.5AC5F39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8D88160003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JwmvH/NZ";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHn9TD6sOT1RAi8FF05petGcyHv8TIvSIsX6lDHGiZs=;
	b=u5PZkAn6cmXy5AGHeS3OM/M8+6IhdoFSODBDYsfhcaEuyy+CHz1kpeMDntTnUERhlTQEnS
	CpkX8IYaA1iMyvXZEXm2WcivJrD+CEtzYBv+TZDmCVTu+THWPoptwuafBCj6qNrXwnAfUI
	7cztXYuzhKZK8igkpVYNPVHEjjrPHt0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JwmvH/NZ";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232415;
	b=pB0eT179sbwEpag/03VTCxpM7JcfqOt7OyGppY3RnBlOgWf6JObZrOvMPrjAt7MFBr3voc
	DCIOgEmYllmn4q+2g1PWvXKITJKLrD+eB91bDqUTlGq7luQeUImsDVSz1itAGf46DoAlha
	oenUii2L4/ZnQ2IUHtTXJLqh9B3MzQA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KHn9TD6sOT1RAi8FF05petGcyHv8TIvSIsX6lDHGiZs=;
	b=JwmvH/NZw6Dxn7ykDnMOVBdFdUgl7CW4/Y6D7Tgse24SoqPm4CVokNYbJZAmww1UNhYFHt
	gesoUhY0LWcwGJOIIGg/ZX/iKZcGIzHKnpkfnEeSNK4CdLf3vdOxW3LCX68OIGb5jmuBIz
	5NaKRI/suJajx0cjfMWM0NLMZPJxQ9g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-rHF_4iuPM1ObqYEwEMvJhw-1; Mon,
 31 Aug 2026 23:13:31 -0400
X-MC-Unique: rHF_4iuPM1ObqYEwEMvJhw-1
X-Mimecast-MFC-AGG-ID: rHF_4iuPM1ObqYEwEMvJhw_1788232408
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAA10192E266;
	Tue,  1 Sep 2026 03:13:28 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D27018005B7;
	Tue,  1 Sep 2026 03:13:25 +0000 (UTC)
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
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 12/14] treewide: introduce arch_has_pmd_leaves()
Date: Mon, 31 Aug 2026 23:12:16 -0400
Message-ID: <e0b69f7a9c99dec84b297cac6e478286c9fa4770.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: _-wXrJxTuPPgiqCf949ruXnB4qREwAjak_2GVSmMMko_1788232408
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: dn9yrhgqfjkj8rgmbam7xz8qexepunbn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8D88160003
X-Rspam-User: 
X-HE-Tag: 1788232415-632748
X-HE-Meta: U2FsdGVkX1804uCjFEkhT+TidPHZwdUAkmj1aWXhte920leJONrRLRaQWKORZlDYhH7Dfdf+EbHfTaAoyuUO5nEoyyrOu/v365wDDqJG743NolkYgfgnRj3wdaWgLy9QAcCFoOPE5gE02FoRkk0KWOy9ePRMinDfS2YfQLruIaBKEBeIeJZ24MvbYTcdzWbUOLgcU9FzqhOEl7M9VxYtuKRRin+NPnPBSW06/PnnW9G1lLdPt2FIpkzjXwGpoepZ54Gu0JSC8unmaklTSXdSOCOZdzZ4CaTLbCIffrxS4gjtFc9EvaJ58bPRWYaDdOj7Sevjx3tcoKEw+26oZTXO2o7ofsbzLYK18SlNKvxoerEUtiPK41mV9r4GeA95uBmQEd5Sp4tOlbolE90oXgfYKc5qjA0ECFGktj/JGiKAMzJkFZLH2PsTlRYrCjYx/4Ckull8FNan9TFPwLz49n1U+8CQAeNIzCY9zNlo6aM43HzcvJPep6VJg9tuFWZgYyy+RniKWCMr7825rSZQtgJKLzpczniX0VyU21YUPF6/9scuUpA7bxHKdPWPAhxXc/CCcyl9Wv20x4ink7LBZz4dAqyZEOIP5o4dgActjpUR4Z/LFMOKNmSDJxdocv7D+d6mNn9w/KsnzvHQTXUzTEi5IujmrBQeRY67TBOzrSUc8d5buJpcFDhIAvLl8ZSj015Yhy1tptEbAMOOuz9waPkQmQn638Kzu/ErTIWThSG/WT/nb+/w5q+dyAwI7+VqWN+wkUU9IJeIPYsQiwkN/adx84QioPY9aIL7wVgiZCP26v+XVydDT9CWK9Hl3h/uVr948tTWkdyrspEcIFOxUgeDygHt/HNoBP5FEw7AU0RXRWQ0e9/RtxJmroK0e7Ys1LdIBnMktTHHS+UG0nvFglLfBBsZwu21dcrxcG0FQEsH1zJVwtsbM4oVYDOQN0VrxAouk+X/kcb9TZvUbDlXvio
 bxoRE2qH
 2qo4IDswbFNnwCWZZlSwxr1STIHmkuyrSNS6a4qgawa8DcwBrvbJ1NhxtKvc4CWAGHXpyKVDn7e3/bqOIFOX6atTl5ufQHVgD3qJESrPTiNk32cTQy5T3tME9cVc4I38T1lbz8MxDbcpKXlhTPwfz4JUK62KcIffA004z4UosTaBpf0ipY+UMEQhQxncAPTvlkaDmQJKDY14i81BA5ODc97QdNDCOzsZVvfr5iw2Nvek78ZWYmEIpPKGbZPwAS3AevG2WkEfq0E7Bst3+BEwlJrnWSpCHiA+STPdYSxwWoIXVYxW+NN+kT3p+ewlwIDh6kOPgVCMxtWr8A3BlBOQcnf5vxNlMmxuprJG89rv7kKmVKJ+RZEdXDK/dsUYCfAV5iRclYcXgJ+xV7E0=
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
pgtable_leaf_support_init(). The remaining exception is hugepage_init()
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
index f207e5268918..17b060184b1d 100644
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
index 4c00cf53e183..98b0a8759ab1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2344,8 +2344,8 @@ static inline void __init pgtable_leaf_support_init(void) { }
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
 #endif
 
 #ifndef has_transparent_pud_hugepage
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..469d98e01b5f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1095,7 +1095,7 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!has_transparent_hugepage()) {
+	if (!arch_has_pmd_leaves()) {
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 69ab1bb54853..ed5029745dfb 100644
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



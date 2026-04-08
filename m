Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CB210F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254986B0088; Wed,  8 Apr 2026 16:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169486B0089; Wed,  8 Apr 2026 16:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031726B008A; Wed,  8 Apr 2026 16:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E73B36B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:23:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9BBB13A0E6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:34 +0000 (UTC)
X-FDA: 84636513948.19.558CC7A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A24118000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WkNMGZ/J";
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMILsKyKkjAgwbk1mi7gAYhxxmVLpdhMMj3vgFOlQbU=;
	b=rvexCE3ldWAGWYNXbX/z5h9oLXD9KZEaZmFx3qNdkKsJvYR6/VmcHyeUHSOYEy421eqD6y
	qCVXh0rRwTsamNpNoXbM+ahRsuuABEn2kGHYDqej2GdSPDKGqLr61lpAzFJ9H18cUuOrMp
	5sJudMQmSKcJNuiW5lBwNCVwV5wY5BE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WkNMGZ/J";
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679812; a=rsa-sha256;
	cv=none;
	b=1P6EKubsm9A6zTtl7Ud5i9USb/VvKLN4diZDMIvm8XcEnYoA9HEYu7XhMrnklofYEuG69m
	7f+b2eWox36olV0Z8Iu48osaQxdUiG9tdSnhCBXfyBqVtt6802aYy67t/9v5/WeMp6IzUz
	fYIZFnCbzWUOuY9AUHX/CJ1f7fTqdcY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sMILsKyKkjAgwbk1mi7gAYhxxmVLpdhMMj3vgFOlQbU=;
	b=WkNMGZ/J/19GXP3FaSHRRC6Gsjf0g3ulxXtNZcT26Fub4JQzV0qyX33d7OHXcaI32HjpWJ
	Nt23nDZ+VBXk1rfjwWeUdWfJK6nwi4kQ0pvUDPmRvu2COWDnUhxi8Gn2IEw2/gtATh/Iz6
	G+5LIqSMWVHlODUX2rt6hdonJzpGbxU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-KmQ_8gqlOUio8jhAtiEmXw-1; Wed,
 08 Apr 2026 16:23:28 -0400
X-MC-Unique: KmQ_8gqlOUio8jhAtiEmXw-1
X-Mimecast-MFC-AGG-ID: KmQ_8gqlOUio8jhAtiEmXw_1775679805
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B697D1956052;
	Wed,  8 Apr 2026 20:23:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C9BB1800673;
	Wed,  8 Apr 2026 20:23:24 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 07/10] treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
Date: Wed,  8 Apr 2026 16:23:02 -0400
Message-ID: <4f640655f26b4cc2056a62bebfd570686dd6dc3c.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: xEdpZlh3luASagwzRRri58yQYAV2qetlX5fmNRTLWdY_1775679805
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 3A24118000F
X-Stat-Signature: 6a5mb8ynbn1t3744kpry81ayed7zepnw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775679812-115257
X-HE-Meta: U2FsdGVkX19VlnwlHL734K7/teldmt6S6BhBsUJ9IQrPbBgfIv8tFLcEW0uOwiWwDzVcy0uwPXGF2Fvcut/aN+XAGBnqit8VFVj1nhFUiHE+r5s1vPCLHHmVCrbxU1nG+WLMiZW9L+fIMd1b79/4d0cbcy3q7A+CX28mQHz+b0jQWhBJOmvtaIVibFKP/DCzeTeHupm2nK7jExZJwx+t8lwClBYY2vpVACJuec8p2SdA/2gr8PWrmYXDDEsRC/iYD7Pl0HivCSI3yH1dBFd4d+goeb0vywC6waOmBukbAUWz9zRNO5n6jlCQpxumCgzvujWRJZoq+dUDOx4cYdcbZOM4R/MTHcJ4eAWDiYkmgslcbhCBT68Ez4AB3ZWEjmO708Hn0D/B3qoZwGpGKynPMoMFB/MUxKoq6eTsqtjB+uQLJKqW+VxdyXa/CpOu+cPndEA4OkMf7N9kkOfRPHgnoklG8pDMtUM1iEuvwyn2Oo4nVke7SdscuL82jSjssGU6xedbwcBTCAgy+PpAFfeWGXtyH9Jz7ZtwUJiO09y0WL95+7LXZ3lefqXXfz0A8zWd5VVadXtLJ0krtlBqPcC9jVbT1iNJsgyeAQkRi1JgZOfdDnr9oZvAiFm2a3DhyR7P+j5LGOXcWCodTa/q0UBmRW1cyD6fyh6IwMIGerVT2LE9Yv7uFtCE1U6SRglPnqLoqfwr2GZfDrvi1YRVpSCowfgTlGXwcgSmW7EALY3n68vXm9ymoHrVnW7hnJDXXEwOlM+QMYaJ45D29e+mCkADQt22yjS3FZGdNqBuySV4FxGlZ6kKY+0wzdgCcpSzQ3MKPQS4d1c7Ua/oLfeyyCH4w+4n6tpZxfsHpqobyJn6WxNR4XOAu0Rg8DrN27fGZd/KM8PvTxdtFSDpXV1ZO+PZ8RIaKOh9FllPllftC49Q+6Gp4l+T0HTr/q2zKU2I2FUBATxc7kik76PeHj2yojT
 OJVlULMI
 ZTIFjFtQSjaliKkkFwzJE5iT3IUOvGbTlxwd5rLFSXZ6IcW7r1Mjwpq2hbFSyl56rHV1PUF5QiK/P40mCiGcD1scNmUK/mdB8+bo9a+nlktGywa7PV9CeEKUdRKMjXIan0/H3Lx+tFqrgriVydhXJHDxomMLsv3mycQ5+MAD6HLED0mWqLha68nL+HiX4Crb1f52akOD6gHHaCx9FoC+EE5qDaYdtdD+/BHJexSZX2JyfTHly/RAnWfpqX0GKct7bOfBRJcCHdNPG20CLooxtPaCXf9O80PQJZoPgUWKnE23zpdWUmEKLHG5qZxzobkbdAXyOvZJDmKv5pqJMktyCsB7UGiymbRfYNLyNaYcajVhlV4ySoMv3ME+KX3cp+T4K7qZX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the has_transparent_hugepage() callers have been converted
to pgtable_has_pmd_leaves(), rename has_transparent_hugepage() to
arch_has_pmd_leaves() since that's what the helper checks for.

arch_has_pmd_leaves() is supposed to be called only by
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
index fa7b935f947c..a97b788315e2 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -615,8 +615,8 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
 /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
 #define pmdp_establish generic_pmdp_establish
 
-#define has_transparent_hugepage has_transparent_hugepage
-extern int has_transparent_hugepage(void);
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+extern int arch_has_pmd_leaves(void);
 
 static inline int pmd_trans_huge(pmd_t pmd)
 {
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 24fe85fa169d..c423b5784337 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-int has_transparent_hugepage(void)
+int arch_has_pmd_leaves(void)
 {
 	static unsigned int mask = -1;
 
@@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
 	}
 	return mask == PM_HUGE_MASK;
 }
-EXPORT_SYMBOL(has_transparent_hugepage);
+EXPORT_SYMBOL(arch_has_pmd_leaves);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
 
diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index 8e5bd9902bed..6744c2287199 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
-extern int hash__has_transparent_hugepage(void);
+extern int hash__arch_has_pmd_leaves(void);
 #endif
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
index 7deb3a66890b..9392aba5e5dc 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
-extern int hash__has_transparent_hugepage(void);
+extern int hash__arch_has_pmd_leaves(void);
 #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif	/* __ASSEMBLER__ */
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..e4d9b884af5c 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
 {
 }
 
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
 
 static inline int has_transparent_pud_hugepage(void)
 {
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..c884a119cbd9 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
 pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
 				     unsigned long addr, pud_t *pudp);
 
-static inline int radix__has_transparent_hugepage(void)
+static inline int radix__arch_has_pmd_leaves(void)
 {
 	/* For radix 2M at PMD level means thp */
 	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index ac2a24d15d2e..f7933c52cca9 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -370,7 +370,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 	return old_pmd;
 }
 
-int hash__has_transparent_hugepage(void)
+int hash__arch_has_pmd_leaves(void)
 {
 
 	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
@@ -399,7 +399,7 @@ int hash__has_transparent_hugepage(void)
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
+EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 1c3c3be93be9..e638d914fbad 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1776,8 +1776,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
 	return pmd_leaf(pmd);
 }
 
-#define has_transparent_hugepage has_transparent_hugepage
-static inline int has_transparent_hugepage(void)
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+static inline int arch_has_pmd_leaves(void)
 {
 	return cpu_has_edat1() ? 1 : 0;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1662c5a8f445..8fe95270b713 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -314,8 +314,8 @@ static inline int pud_trans_huge(pud_t pud)
 }
 #endif
 
-#define has_transparent_hugepage has_transparent_hugepage
-static inline int has_transparent_hugepage(void)
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+static inline int arch_has_pmd_leaves(void)
 {
 	return boot_cpu_has(X86_FEATURE_PSE);
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index c4c5282f795c..4b52a3abeab5 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2222,8 +2222,8 @@ static inline void __init init_arch_has_pmd_leaves(void) { }
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
 #endif
 
 #ifndef has_transparent_pud_hugepage
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b298cba853ab..9e4889d1673f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -908,7 +908,7 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!has_transparent_hugepage()) {
+	if (!arch_has_pmd_leaves()) {
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 5ee312c30f2d..87a65f6eabfb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -182,7 +182,7 @@ EXPORT_SYMBOL(__arch_has_pmd_leaves);
 
 void __init init_arch_has_pmd_leaves(void)
 {
-	__arch_has_pmd_leaves = has_transparent_hugepage();
+	__arch_has_pmd_leaves = arch_has_pmd_leaves();
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
-- 
2.53.0



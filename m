Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C65CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D48D6B009B; Fri,  1 May 2026 15:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2B16B009D; Fri,  1 May 2026 15:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A166B009E; Fri,  1 May 2026 15:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19EAA6B009B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA089A022F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:29 +0000 (UTC)
X-FDA: 84719817378.08.3E15535
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 003E8C0012
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AHd6IqYH;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNavbFWlO0DIPnynD7O4aaFA2GWbjCiwD9QcVuw7hgQ=;
	b=a+EfbCLSX8aUR6rLFZj6lgVvK/VNxx3GTWAdAKqLMX1Th5uhG/oNiwzujEzNmKqNFiBd8g
	Q9ZdXFZYGMJXHZNHd5SEKTEbGjqXNGTS71Sf1Gjd1TTU503G1vCF0PmtuJ5BJ4mZ5FPBP5
	KAj+WjPhXH9m7joaUfwRPGgxTBj/iBA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AHd6IqYH;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663228; a=rsa-sha256;
	cv=none;
	b=DNkQHYJ5TLXtiE5gKt7wZ9LwMWsieLaHnaDhyy1GP1S0qcfj2Lz7BGGN90gT8CU4sYwbGy
	OdtP4AQ8DSuIdOx3W3+mPjfnETYsD/5gkrP8IgwAk10bu/lwLMaddxK0hsaHZomaOf1MlJ
	zXg/W8c+gzG7JLXFBov+3k6dV9MxDBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qNavbFWlO0DIPnynD7O4aaFA2GWbjCiwD9QcVuw7hgQ=;
	b=AHd6IqYHje8zgCrVn529XPL0/qurK80c56EakxaGBjDkJbQ+e4b1Rt5vzmm76HZC/muMmE
	m9L0/QiqWU2rjmfY5VTFZEMvTXDDQVAqziZKPJ14WQzd98NBkcyDxCIW3aO724JQqSYQms
	ymSL8gW/00xhtSNuRnv3urzEEe8geyA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-sBIt2aBvMIyjX3xsRgeTCw-1; Fri,
 01 May 2026 15:20:23 -0400
X-MC-Unique: sBIt2aBvMIyjX3xsRgeTCw-1
X-Mimecast-MFC-AGG-ID: sBIt2aBvMIyjX3xsRgeTCw_1777663221
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADDE71956053;
	Fri,  1 May 2026 19:20:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A31AF1800480;
	Fri,  1 May 2026 19:20:17 +0000 (UTC)
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
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 7/9] treewide: introduce arch_has_pmd_leaves()
Date: Fri,  1 May 2026 15:18:49 -0400
Message-ID: <85674af7934cd363ceadd1d4f2b784d833a183cc.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: KeeohaGT-BqSRiJGAk6MwlPZpeWq5fMN-aJ4JS0rdKk_1777663221
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 003E8C0012
X-Stat-Signature: sn9k6utcswuoyycd4c6c4erhqej3fmhd
X-HE-Tag: 1777663227-772243
X-HE-Meta: U2FsdGVkX1+IvMupBTvaVziP1RqYadINtuUvSY01+UBBZ9G+TgHd7bimY+WbO69NJxAOO1bCcMmVh4wbtMSkXbP6J2Zx69iV4A/eRbx0bYZ2JxkGX3OHm3lb51z1GYSt5PVq9T/Jskj27S3N0SKHH94uKUq8p/mj8OoTET/1nkm44vtRflve996m9WXEEQzqmEIO80Anyon5fo6SVsotFFGIZW8ovNnDwAmNetUeSAeoIQb+xGyTnWWvZT2FtXWCEjTmWkXcw4dVvjy7Gof6uzAsvylDsBorsEZpKFEjJ+HBLkqlDWTa/g6uc5NygPLukW0YBA/u103UAEX8xJr2r5DU6TshORxfbA+7q3DvR77sFIXQjWRXgLbrPfF5oKlzJLcObrqNtD48apiiYLq38o5jB5qe1KYQG0Vg8BotKdaE2cvzoP6USYqL5bxnira9WLfWf7COR9JKmAhG98iRUnA5Ga/wV2eBGh8xTCH90Uoo97nIu7sj/qQE3blVfY/Qz4mOZb8YpiuMxFOEAN9PZ8ZchR/ScCioq15fx+b9rphjgROEiy1h6F3Y4FyXETurR2O2LFQ+tj+INKFlW4myRM87HlG5xA5WMcvLYS+9c6CTn4UJUU9AbUkoshHaIzojSN3sw63Jf1kes7ydQLljbh2B08YL2+MDUrdlOfVDczKIlS9waUfFtb9TiHk97g8L15iKOYAhE3DksAKiVSwyUtnmDWVypsIcMrYhprnZxwioj5gD8xdctQCiTqkhGUvj1HgfAzOciukobE0/kmJ3rQ9WYP6T4KhKy8M10iLj8YeM+WALcR4LU0Ilh8OmHSoy+kbd06mdC2pjgXes1yO1XYaISQo3lbxP7UGJlH+Sp9LXv17ASo7kJlUVF4Fvjfqrj6RHkG9Pxadf0ByilHno0oLDMuo5wXVOdnmyccFplj0BZKDpFMhDd30eamkvodm2FvtNoGI3AZGB9TeUJco
 sEUFsPkW
 B+wyZl27vApjd15Pd/jbG6oxUYlQNGmemxCJYpQPXWxr4bOfwakOCbEjfFVH66bWgK/bTHn6IaEHUBJUeFZYEFpn09HGjQPklA6QGJJboyMA4Wh7DGha8764yh6yq8meg6ZpglKhjlVoZnZPYlQR2HlJiAWWSXDJXZ5DL+7E0G+FY2w514LP2iR/Dehp4fEmWCmKzid0g5feq0+vegUMMHxuv/DeBiABblass5TcWuhlwaWfRnd/oDa+bykSf7CpguNPfK+d6HyjElywNkn7XjO9efBXdixMjLGKjbPVxNcIontXfoYe7BVtEmfne4fcpUJVAB8aDPLxLMDdSF+OQyujuF6TU3x2TSwsnYaWLi2TRZNzPLGJti7KiYqxlYXkRs5C4TPG/YDnlnaM=
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
index e67e64ac6e8c..b6629c041e75 100644
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
index d9b5b751d7b7..88a4a2eab513 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -391,7 +391,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 	return old_pmd;
 }
 
-int hash__has_transparent_hugepage(void)
+int hash__arch_has_pmd_leaves(void)
 {
 
 	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
@@ -420,7 +420,7 @@ int hash__has_transparent_hugepage(void)
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
+EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e0..33b165dbf3db 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1799,8 +1799,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
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
index 2187e9cfcefa..2edd6c9d789c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -306,8 +306,8 @@ static inline int pud_trans_huge(pud_t pud)
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
index b365be3516bf..3d7eeb50c183 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2273,8 +2273,8 @@ static inline void __init init_arch_has_pmd_leaves(void) { }
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
 #endif
 
 #ifndef has_transparent_pud_hugepage
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..4da10e94bbb6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -969,7 +969,7 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!has_transparent_hugepage()) {
+	if (!arch_has_pmd_leaves()) {
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 90b2d9e84320..c62fce83b8d0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -169,7 +169,7 @@ EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
 
 void __init init_arch_has_pmd_leaves(void)
 {
-	if (!has_transparent_hugepage())
+	if (!arch_has_pmd_leaves())
 		static_branch_disable(&__arch_has_pmd_leaves_key);
 }
 
-- 
2.53.0



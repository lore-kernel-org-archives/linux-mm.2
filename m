Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7B2D5B866
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B846B009D; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560966B009E; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C3D6B009B; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29CB16B009B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA09F1A03B0
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:22 +0000 (UTC)
X-FDA: 84222966324.27.00C1793
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 772E24000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cZ4ey8jh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833441; a=rsa-sha256;
	cv=none;
	b=dkRzBfEHAU3jwd1wVhjexWiBeA3AHlKrM1RFkRIGx0/6yYwjoqZL4Nxjx1bq/xXBufZw/q
	/+N2Gp77xPQtsM5p0HKzjDeOvcvcM+goOydpCuVx9J9wQYrMw9YoXFn7RllZbXoFEdmEaI
	gNXXuPvLLLvBB7dM7+MJP94CcRtYPKA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cZ4ey8jh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4sxb4FZeauU7Nv1sf7Acs/cNBEGuI92zvzNB94GGvM=;
	b=0sQuiKuQ28sF62eBWvWR4J0R0+FPzNnuS5qhZ4UxjXL9OeWj42wpozHb/doNdlYS7z6mZK
	WkmMfgsCWuo4dNvtxoKMMvW1O4JH1lqReQ38fHwdm1LI41z1GLiSADLmzITE942U4xP4X+
	ds+CTRzw/+V3hfnvgSz81qRAhd3j5X4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4sxb4FZeauU7Nv1sf7Acs/cNBEGuI92zvzNB94GGvM=;
	b=cZ4ey8jh6VcPa08XjhGw2oNNpwzdH6FKFaGoonYchxsaccbPKULHohPfKmrgfTpRj4rb+v
	rmUvD/amu2jM0dPtlCkbZvyL8xtMuN/AexCZtzksdAf7PpAjHMukhX1ETPJsWiqoEB72/F
	p6KdafM0INPeYcEsqsNwQ18oRB7A4vg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-r0wFALxjPWS7RLxyOvXKfA-1; Mon,
 15 Dec 2025 16:17:17 -0500
X-MC-Unique: r0wFALxjPWS7RLxyOvXKfA-1
X-Mimecast-MFC-AGG-ID: r0wFALxjPWS7RLxyOvXKfA_1765833436
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C13018009C0;
	Mon, 15 Dec 2025 21:17:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F79C1956056;
	Mon, 15 Dec 2025 21:17:15 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 08/11] treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:50 -0500
Message-ID: <3825de5839a1a89d7a274258196fa3eb6824a7af.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 772E24000B
X-Stat-Signature: cmmrmnpna9h7yjyr38y4kic9a375fxhc
X-Rspam-User: 
X-HE-Tag: 1765833441-136677
X-HE-Meta: U2FsdGVkX1/Jpm3jQbZ7ZMix1vaNe+kv+FcPXFXeHnv+7rbYYauKnc8BqXOM+TZz8FJWrVRyHyNRm2P/oQZp4yMJuY95X8Wkl851SSyB+vMrsqRl4/M+2mtEIAJ/BgjlCfqGvUiwC0RlYz3Fx9gRUWftt/GvpTkye4dmEMbHs8SbwacoUb4XT4NC5WRtI17uiIxmjXXmW9FEFXNdHbKA22JF6N5a/Dh6Jr0vcLGeApZIQcmCmhKzaszi9h9UPKgq99BeepfeBL5YOX7a85tFKca3UALB6LdcVlX/Bas+KnPh8Wkp/gU5HkeNaeQICCJdKPDM9C810JKP/Ul3WDA6GkO4OHunDrS4Pumd9G3cve5QmQaYWYLwy4LAbkvuIC9HAfHFCh0bu9qKYm/OvWabCIXYDnk+yxwYF49NVUBp9KfiN3nVej3M1O3Dtb0tDmN/nkyRpPq1erTt7hbRWyZ9MQI7AQb0CKQrf4d3nj/cG7LLYmXaNJJy+jwhjyqgL8DvipJQGMLH88Yxe/JmlLGzdfrpiZEQ3AlHt8uZy2ko6o75sWYgZTc8z7dSc51qgYOVVFkNxfOTKCcXSwH25gnP0P58j89Kh3RO/WP+HS9XpyNT8ktpDQPENF3RSX2Z3G0pqpJStTEFT3jwltastt6drY16pf055c2wgzT1v2NcpRfppP1XqW/CMCPligl3GzukAmFOHCFKy+3To81u8RPYds3ktGzwIkMGYkAwTS4lMO0DsvY2s+ZZ+chUz028rtStPNn3XVOKgeoHldxxv6rNgQD0sieG5TyUAOSVyKwuw1VxGRhdS1l47aMpjkAEeho1UjgeTzynJ7nHeop9WZQjrmQTWLoX8pxGUiXh90ceptfj9v0E1ahVZIbqup4aWNIEh4Jr+NhaghpSmmkebZp+KAsurteKE/e+kYVANhKxOUFF5nD4HosVKNGFJG3cDZGYW2MKpfuxiZ/zIMWDHmu
 2vn8+IkL
 4+zedH/Z0/eW1SaAQSLIanc53ft/cRkpyPnJj8nuHY820U+W3ljGtYubLzkbNcHHSeqiRGrmHrvR49loUXGC1LXG8IpdskVN2fDWSsBOZHHw0Ua0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all has_transparent_hugepage() callers have been converted to
pgtable_has_pmd_leaves(), rename has_transparent_hugepage() to
arch_has_pmd_leaves() since that's what the helper checks for.

arch_has_pmd_leaves() is supposed to be called only by
init_arch_has_pmd_leaves(). The only temporary exception is
hugepage_init() which will be converted in a future commit.

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
index 9c06a612d33a..0080724a7df5 100644
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
index 44a662536148..4fcc8195a130 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,7 +432,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
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
index aac8ce30cd3b..6ed036b3d3c2 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1094,14 +1094,14 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
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
index 82d31177630b..1dec64bf0c75 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -366,7 +366,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 	return old_pmd;
 }
 
-int hash__has_transparent_hugepage(void)
+int hash__arch_has_pmd_leaves(void)
 {
 
 	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
@@ -395,7 +395,7 @@ int hash__has_transparent_hugepage(void)
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
+EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index bca9b29778c3..4398855d558e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1866,8 +1866,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
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
index e33df3da6980..08d109280e36 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -313,8 +313,8 @@ static inline int pud_trans_huge(pud_t pud)
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
index 6733f90a1da4..b4d10ea9e45a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2039,8 +2039,8 @@ void __init init_arch_has_pmd_leaves(void);
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
 #endif
 
 #ifndef has_transparent_pud_hugepage
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..b80a897b9b6f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -905,7 +905,7 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!has_transparent_hugepage()) {
+	if (!arch_has_pmd_leaves()) {
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 79bd59d5243f..e816d4b53bc0 100644
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
2.52.0



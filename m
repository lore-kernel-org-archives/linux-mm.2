Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE91E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8276B009D; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1376B009F; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAFA6B009D; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69FF66B009F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 403E51C0C7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:04 +0000 (UTC)
X-FDA: 84426324528.14.4928643
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 626D84000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IJdAFLHf;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F02NDJ/4e/AhBShhBicj4QcAadjr+UPg+7jj9VQCrJM=;
	b=Aw/QJXhih8N0TkfBnhJsXOulCRYVLobrVHRr0vheUIAb0Fjm4CM4WzCYf86sbuyjjac9s3
	W+JXc6Mr6iGxK+KKLZp0UJp769nQSQIr73TdSiHLfpjOhOgvTyvEUJeguqA3HSi5hzbuVE
	gn28aXwqwsRHQjnoQP7oYi7AkiSOl8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675302; a=rsa-sha256;
	cv=none;
	b=taVGg/eMYZ6EoME1zRXXvqEeufXLCZE8mTjEtZwf+VjG/bN7SGczH+IbRRyGu0sUAnZfT/
	wWZkh3ZiF243xh4LlPUF29otNBEOz7kViRuEme1UVFgabSQ0Q9IHYmJ7crhMVR3WKUHP3u
	1P/Kym21mpPyz9L6Lf7uFFvd6ANZ6UI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IJdAFLHf;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F02NDJ/4e/AhBShhBicj4QcAadjr+UPg+7jj9VQCrJM=;
	b=IJdAFLHfXhzJ91fIimekcssnzD2AHRIT5vZAiNa9nXKArBXDAAwKPZKTCJ0E2KjYGLZkb2
	o/tQb3ZMn1mmcwPMnoo5mqiL/bdB8mctQofrc1oiGrVYaztnbwOyKc5eO32iv/ZQGM4Imo
	eFXMYVVTYhhOkEWo6Djr1By1ds6Yd6s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-379-RqLU3oj3OsqVPV6ncdbptA-1; Mon,
 09 Feb 2026 17:14:58 -0500
X-MC-Unique: RqLU3oj3OsqVPV6ncdbptA-1
X-Mimecast-MFC-AGG-ID: RqLU3oj3OsqVPV6ncdbptA_1770675297
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3383B18005BC;
	Mon,  9 Feb 2026 22:14:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1379618003F6;
	Mon,  9 Feb 2026 22:14:55 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 08/11] treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:30 -0500
Message-ID: <a340a5f453e125c9d77a903a18bb9c44aed56f65.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: selcxL01DcVBvfr_sAdcm1SoKa8znkTz694tS9fww2s_1770675297
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 626D84000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: emb3czhojb8ftxnndmk61nmazqjfrofa
X-HE-Tag: 1770675302-207419
X-HE-Meta: U2FsdGVkX1+9UahyFh+YAY+gaMX6Wr5173TlEvX1Qz95Sdi8T2ArAKkSF/MlEkC6HkJlj+wYCxJbvGdOWJbtSF/9cdsenDqA1nPdVIWzodWNUj5BqqHrhvCQA9zPIFNd7S9P7BiwGSnATgpFhfhiRjkjShyBCSzRGs5WtM46jMUurq1o6lcADwOA351aI1WFOjD9RKGyIMVvLDcf8QZczJ/RwpIciDp+OP5NyaoyMKNnYhy/TJKzwwCaqBvGOYyzkef1SDd9xBbRlbhpphyWc38ZmZbN6M/wl96FvZqC0mfXZyTO//JnIPjyG6NEAhl/bMy1t7Cnu+v+88ho7Nl3lZq2fhE5AVzYEMBVnxJfTQjAAUxPNU8atryTYFhwv/UitzzsqtWac8b5Jec8MYHhb2I8Lio1nuWoML1w8LJ18ddGw76H3vmz5aScQdQ00K/wDcvfxD23VU4J0HoSmFRAqJ+F0SDYS93QPLl6AacdzLxvrHgHsaYq0fAEXQ+TZJkvgxFMdZJ++siYX6ntpYKkpLaKAvjvjVDQsjxpC6jCBpJRHuG8UrU2eKRgUztsfWI+3vrfMcltegNJP37u/bm6GRMxUoY9WJ9JkZAchDOooQNKVVA0/wQr67AuPnnXHB+PmcjIuStmbI2RLXSx+wkkphqTCJQIn4mNOeMowWaWZ6uS4CjIVCvs/wCQ6VUcDiXJc5Cg3Nx+H2YRY3IghLmm9lDveBesZQspOCL+L/HsjMyBvOPe+CJkFm7tJf20/79yvoa6NPAuA2asiO4daTjSllzcuzJTsQxwvvW7hcy2f6gmSq2eNNntUkJeIxcDC2CUssW29IYnS5O3IfLret7aCdNYqYb8+jgcklLoAuK3MpdGjHLZLvXofoYGFrvxRKpDgiGBAvdzxj5NOL5r0xCyc57/QGWuTIqNdr0nGy8i5lziQH5eTQKc6CV3rAMYGk8MfSF+RTi+N+pUj8JfwDo
 Y2RwvUQs
 /tZSYSPMm3LBuaB21gRNq60hXhX4OQhfAD+bPs5YzkDAAMxyqDFGH2wDIZ+rWbGQUDirAcjMRwlGyRJ7M5rLOc87kaydgViMybRwOzd+nen9hxyDys00cp6pVA4yA+H8gWc+Wk/vhxRVtIG+YsHq59EJ4MUvObUDy15tG1Y63VdLgcYywxywikXhMa2KcGdZu/tmhJN+Fu8+KBq1ns/OG0oj4ABISPLby6ajXeQsxnzzwnwek2Q2jd0KZHmQLETXmmIPpOS2aL9zSUAKkg9D/97B/3mdrnh1IO9OneYVyRLmPDPWDuOOcj0/RS/ITc3UCYo7A5DLqZBfL+iQL3NYSOjqIi6FBmNoQk8ozOk78AXcHh7iXlkWwipADAZcm9hqJ+TxO
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
index 4c25a3c453c6..9794429df015 100644
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



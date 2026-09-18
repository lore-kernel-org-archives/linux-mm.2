Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD573C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65376B008C; Thu, 17 Sep 2026 21:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3AFE6B00A4; Thu, 17 Sep 2026 21:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AFC6B00A5; Thu, 17 Sep 2026 21:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2426B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E61D840543
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:54 +0000 (UTC)
X-FDA: 85225194348.14.04D4BA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1355040004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BPx1IU5R;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2dWVXBpZG49NjWH2QMhsNOO3sOsZgIwbcpTmyxFl0I=;
	b=vY/3JYBCpv7TAOiloT0Vk7hvGltrpX0EHgv6jHHvlsDmd6GNHSe9GobI0qG/NOlZ/vCOz7
	EDoVuYSQPCMpPRfJvPfT6Zv8qApqRtnp085vUPzFO/FQW9HRxgpMDb1H2zl0aZ3Yp6kYAy
	1KZSdgs66Z3WxNTwdHwatWuO250TNZA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BPx1IU5R;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696013;
	b=UsjUZW/chEa96RA9WJbWt6gnCqZX6gP40uQZaV8EWsBc7IMCGmDups9XWd0F+qwpNY5bum
	kexaXMl5eKqvYXFqakOBOVeudUMfSmsoiD6bo56emU0O63MgHePS5k5/2OsendkIwZJavL
	dXXlgLW9yVwIokRuOYN1o6GdQduOt0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2dWVXBpZG49NjWH2QMhsNOO3sOsZgIwbcpTmyxFl0I=;
	b=BPx1IU5RK4C//zowU/I2m+8h2ilAhVk2zDswFI4uCVobW9R+968IHS7mny5pEnOgqR4TU/
	eROkgQoKAv6k5vOGBZOd5KLTonDBa/vx1AHFnlnlOSVD36YKHA84lHaGZU6i1yMz+e7z0v
	6qiZBQLbvA7WfgbCg1U6E0fVIUwVWxs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-9O-xqn6wNoWNUpA0430b-Q-1; Thu,
 17 Sep 2026 21:46:45 -0400
X-MC-Unique: 9O-xqn6wNoWNUpA0430b-Q-1
X-Mimecast-MFC-AGG-ID: 9O-xqn6wNoWNUpA0430b-Q_1789696002
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9415195FCFB;
	Fri, 18 Sep 2026 01:46:42 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F74B18002A6;
	Fri, 18 Sep 2026 01:46:39 +0000 (UTC)
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
Subject: [PATCH v8 09/14] powerpc: move has_transparent_hugepage() out of THP guard
Date: Thu, 17 Sep 2026 21:45:30 -0400
Message-ID: <05a71b6011a6eab7b096f262485fcb8b4987976f.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: MZpiSFgdBdidjoHLnDFoQKwICazxODoGBrZLGuHyskQ_1789696002
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: 9xof8d45y8h4by94pnu5651kr3r6b8sq
X-Rspamd-Queue-Id: 1355040004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789696012-357644
X-HE-Meta: U2FsdGVkX19Qy+I9jAG+mIA9GGp+xP2r5sK7hcnGBWlzmK9rB6Xh5L5EVm+q2Q1lTlB94VfpHHrsq7bD5BfgSGHLsXmfuv+Q1QOYIkshCMvFRHv9qwyZ7kkiVl8/ZsE1+dapKDconbotSWTpfLgGHYdb1g0iVpaDTXpV94ysc76ZxLyKJ/eUTERkOrJtkTiE0M5LXs/BGTlPTfwf6LmNYU7R22YdFzuWWVgkdWspWF5bWC6icNSlTpdek/l6YNJ/+LkVJVdD2MyV73D/cs6DDhAFUY8EC304lPsSSCtifPrcMNZInbxjzwHEUAcPukhQz1pGVL572m9scV7nkthM+oaBs0ORgw3urx8ntFnonnFBgtCROdazIzhRQ0JzQ6YS4ZowqT9E98yhi+VLOAOpNLWmFf2wfJutnltrflrzwytRcu42z/MtKs4DqSa4eo57u+cqTSmGGZLFr3qlWtPr/k8MCKagsww5qOVZqHdrSP5O0qJynCMst+En2O+T3GEnptLzQo3NWLJ/g69kwPTxFobtGDo7oTgMQ8qDlV5ZVw0SAo5fHVy4gYIF6lgIVglpU/hd+Dv+9kT1aUArUwKL5zFoBpbKU4gURT4OHX3GfY9SEsbK+bGUMmLtE63lH8tSDTe1s8ntaQXmTObAWYYRSs0omcRGfj/MuevoC3TINtDnA+kjIxokeRDZRxl4pc0oudPnWda4bHtguOyxTrgVrx7UlgRebpZzDQYYIvY8EjVYumxNVH0O1vI7dzPqTqa9+KDXzu+Ee4wcyByQSVNciw2lzEoAPh3P8tk6gAfCuhn0+qY4Ul5+qRjqL58oWINjNfrfeVM/yjFohXLhSphw0r8Zx3GEabAp6ZeNaaP+UCr7uN6+TBtpIDPiR18zlf3iKiBu367uDCbdHypShwzGdebLOSEapDzCfz7rEDAsxkLA3M2VWTUx1nJaeS7SA3RDsutY8PLMefFh2CAtal5
 jO0Sk5TT
 LhMZ5xi8v3burd1BrE6tKDsLhTkReWiRhx8+73MkcbuJfV8nMD7WPkHth2mleOlS4k0ZbpeWYjrxEJ/JOMxXW7cDnIKk05X3EbycDVrnKsbIIKXOdauJeFK5wyl7s8S6kk4DumuZShSwcRfy/B5OwOyn6C2VFZBOC9pc/CWY9Krwg1a5iFgUt8o4ROT2c0oCLf+gPK6R7+Xcl7UrJnpSswYhxvgxdi4vaodVYfMhAWtV+uKZzEp23ilNqYdhjWpW53DKG8f1hL0hKDoPlzOB4roaEj/Avj6jT2bCZsclA9NX0T5EUTO3//vWLO/LfbrYz232Kn72Ionv8j4DKP4AA2fFROSQSeYHIZAKVnj7zCdNxpNWjAo67N0TBQyloYpXIe+eAP96OmDVdKwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future commit will introduce a kernel API to allow for checking if the
CPU supports PMD-sized pages. This API will be based on the
has_transparent_hugepage() implementation but will be orthogonal to THP
and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

Move its definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 +++++++++---------
 arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index 8e5bd9902bed..79511e6abfca 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -165,9 +165,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
-extern int hash__has_transparent_hugepage(void);
 #endif
 
+extern int hash__has_transparent_hugepage(void);
 #endif /* !__ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
index 7deb3a66890b..a4a44a112ff9 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -278,9 +278,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
-extern int hash__has_transparent_hugepage(void);
 #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
 
+extern int hash__has_transparent_hugepage(void);
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_HASH_64K_H */
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047d..522bb58b6241 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1114,15 +1114,6 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
 {
 }
 
-extern int hash__has_transparent_hugepage(void);
-static inline int has_transparent_hugepage(void)
-{
-	if (radix_enabled())
-		return radix__has_transparent_hugepage();
-	return hash__has_transparent_hugepage();
-}
-#define has_transparent_hugepage has_transparent_hugepage
-
 static inline int has_transparent_pud_hugepage(void)
 {
 	if (radix_enabled())
@@ -1434,6 +1425,15 @@ static inline bool arch_needs_pgtable_deposit(void)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+extern int hash__has_transparent_hugepage(void);
+static inline int has_transparent_hugepage(void)
+{
+	if (radix_enabled())
+		return radix__has_transparent_hugepage();
+	return hash__has_transparent_hugepage();
+}
+#define has_transparent_hugepage has_transparent_hugepage
+
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
 pte_t ptep_modify_prot_start(struct vm_area_struct *, unsigned long, pte_t *);
 void ptep_modify_prot_commit(struct vm_area_struct *, unsigned long,
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..50545cf519bd 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -298,22 +298,22 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
 pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
 				     unsigned long addr, pud_t *pudp);
 
-static inline int radix__has_transparent_hugepage(void)
+static inline int radix__has_transparent_pud_hugepage(void)
 {
-	/* For radix 2M at PMD level means thp */
-	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
+	/* For radix 1G at PUD level means pud hugepage support */
+	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
 		return 1;
 	return 0;
 }
+#endif
 
-static inline int radix__has_transparent_pud_hugepage(void)
+static inline int radix__has_transparent_hugepage(void)
 {
-	/* For radix 1G at PUD level means pud hugepage support */
-	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
+	/* For radix 2M at PMD level means thp */
+	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
 		return 1;
 	return 0;
 }
-#endif
 
 struct vmem_altmap;
 struct dev_pagemap;
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index d9b5b751d7b7..50316f3fc5d3 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -391,6 +391,8 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 	return old_pmd;
 }
 
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 int hash__has_transparent_hugepage(void)
 {
 
@@ -422,8 +424,6 @@ int hash__has_transparent_hugepage(void)
 }
 EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
 
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 #ifdef CONFIG_STRICT_KERNEL_RWX
 
 struct change_memory_parms {
-- 
2.55.0



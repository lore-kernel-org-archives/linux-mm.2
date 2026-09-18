Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 708A9C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EEAA6B00A9; Thu, 17 Sep 2026 21:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0779D6B00AA; Thu, 17 Sep 2026 21:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E817A6B00AB; Thu, 17 Sep 2026 21:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9DD06B00A9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:47:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E07CC120540
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:04 +0000 (UTC)
X-FDA: 85225194768.18.B354EB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4991100006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sa6uWdhk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696023;
	b=og0xIifqxPMX+u06A3t8LmUtJgDH3jfTur0zaxBDuywviNRpuFhMQFP/0j6B9uDUUSOv/e
	4Nktzm7w1Tt1sLeT2cx35510QViGdYHtpHGiuVv7yTby4f1+YuJU64ouVPEo+Bi/TXtnSG
	RplUQ/dAoX3AXVLuoBCXu6E9fKlIQN4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sa6uWdhk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpHNqD7FSx1oS9y8BZOXFxpy/SRXGBAvNFZHcdjJfGA=;
	b=Lf3szhbtcq+FFuGOT6EG/EqJ7iJq0eUtGubFavs/gVbSFW30RoQznCNqRihBAeT1+PIons
	0mkbH2g6NCgJ+HNBucX3XWrsr+stEHEaeNYNqoDwl6qhCUAMWg9fnBYXhl1MHs15RXRSfP
	lChZz6mBGiUSeq//i3r74EpszSzr/FM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wpHNqD7FSx1oS9y8BZOXFxpy/SRXGBAvNFZHcdjJfGA=;
	b=Sa6uWdhktM89Skx/st63zf0x9IkO2+1H7e2MEeXPS9gD5A800XDd/6YzBGfX/41kO7XDYd
	hHFMS1YEAA4jmUOe7EJc0McR6uTKF8N0TvJ/4d8vBbkLAV72UU2v44uZkGtZZpo66XwV6/
	3cce9Ce5mF5AgxE7zvJZ2gMX4Vu4MKo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-6hXUuFnvMGKIPYP_MlfA5A-1; Thu,
 17 Sep 2026 21:46:57 -0400
X-MC-Unique: 6hXUuFnvMGKIPYP_MlfA5A-1
X-Mimecast-MFC-AGG-ID: 6hXUuFnvMGKIPYP_MlfA5A_1789696014
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25C86195FD00;
	Fri, 18 Sep 2026 01:46:54 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C20318005B5;
	Fri, 18 Sep 2026 01:46:50 +0000 (UTC)
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
Subject: [PATCH v8 12/14] treewide: introduce arch_has_pmd_leaves()
Date: Thu, 17 Sep 2026 21:45:33 -0400
Message-ID: <50af0b07cbb36e911ecd1f90698bfebcdaa8a390.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: M-VR0Qyug3pEMOdEDi0ua62G2ItSi5urGY3mRW7oP6w_1789696014
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4991100006
X-Stat-Signature: pwarbgg65mwyuoy4btgu1qsf55qw3uag
X-HE-Tag: 1789696022-447873
X-HE-Meta: U2FsdGVkX1/4Tlch0ipZJBctxsuFjJ+YnkeHHBwEVFUjHDwgIavUk9xtBfzEl63MXYUOSAhyu5DSIBP6dOX1LWAkWnxIRJ3wXnolZbsBHErP2wezYgcPGIw7yleN6EtukyVWJpN3pWbOszz4bOvIkwnMhqVQpP1mu+QRvIkONfhGIML6xDL4ORzlFTUnyxVAynL1V9p1JY1swbEIi9V2kzDPPQ/URjFhiXgsZrIYZx72De9jWxH7kmSR2AwwJSzVVNolZbVIfDjNYVvakkFI4dWODSdJOf9n6tmJ08ox0AJBJsCeSc+A2/FzgjWUdu7iydrjAZnY4kMAS7dXFFXCP4Ds8tzSCKgDypVKB0eYqz9V/2YADYu4qJiyoWtyCMxAnzriByL0jRVCDCSal7rYTdyK9xUDlhS7Yk2sBGstWu+18ggI9/T7TjFSrx5f9VmIA3qByo/kQfSAA1prYjTyD5DG0xf9+8JaQPxi0VTE8/c39/7dafg7/5+ZPwMYL7iTal9+PquJd4outpV5z6JbcV/Mg9zLGZ/suXpQRPm5zvCGkBniQMztXOKVpLKsjLscm6W+B4Qf4U8FAIg2L3U3hADvOh1ZOdxPPq91Z1k853oPilHSdvZm5RxoNK5TXj/4gsv5ZrorbLGtbmnB7mzZZvbaA6G9R6giTKehaHqAL0dd/EOdMRiKK83kNpKMDA5dZYQej1DWGmfb9rbOY3QJc602IdJaMwvAZAzb3aybOe7JLfs468G75DX7X885UsbRsvRFLfoOmIKhLrn49dOCqg+sv3InV6ToqGZxzN2Hk6pKipJ3UZE9v0IBpRyQ0G+Kbou9DvP/sq3w3XBmb9j9Ymg2BDXoqTuWFp253mEAuA/KFlIE86uJSZM6bfUGxX8aXockZs/qWZskqtQnRbz+Z67iB0B2LjZjIIP/TUdnsAZAU4GeUc/RvnXU7A0FO+ogycz/g8VKnrniNEf5ahO
 L8oIkSkS
 CpMWMeNYaCpuyg/Bl43ztnrQlHozhS6dcYSSf7r/oIFGFTzOr3eRWTCQ4CmUPYzkXfkzk9SooYXl7TpNuwU0dmCSjPM8znCJsBz2z/TrMt70GjpfrRXJrXNrX8SgJUr84sFtQi8qvfesu+2sLImW1NamQtRV9QOF6Dydd4s+zpQFc5FlGB65VGW8BRpjiKpgXT2oHeTscigOmNteSdUtlbN9Lr3yntn2WrActVu/rIjlLsTbXxlYaZqvRfhS8I+9hJCgV5LhABVYkclUn1mvmf2eI7XC+C84ul8fsjoi0yeh55Ee0Hu6KCKS0IZET4LwbCsk8in8s4NUIJ0vHNlp3zY/VqEgCxu2xxSUdNELCHtXeo5GHBmdqVbc1I/TVSjuD1TL5xu1J+qLPimA=
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
 arch/mips/mm/pgtable.c                        |  6 +++---
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
 12 files changed, 23 insertions(+), 23 deletions(-)

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
diff --git a/arch/mips/mm/pgtable.c b/arch/mips/mm/pgtable.c
index 4515fa42f0b3..f498fc58bd7a 100644
--- a/arch/mips/mm/pgtable.c
+++ b/arch/mips/mm/pgtable.c
@@ -25,7 +25,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 EXPORT_SYMBOL_GPL(pgd_alloc);
 
 #ifdef CONFIG_CPU_SUPPORTS_HUGEPAGES
-int has_transparent_hugepage(void)
+int arch_has_pmd_leaves(void)
 {
 	static unsigned int mask = -1;
 
@@ -42,9 +42,9 @@ int has_transparent_hugepage(void)
 	return mask == PM_HUGE_MASK;
 }
 #else
-int has_transparent_hugepage(void)
+int arch_has_pmd_leaves(void)
 {
 	return 0;
 }
 #endif
-EXPORT_SYMBOL(has_transparent_hugepage);
+EXPORT_SYMBOL(arch_has_pmd_leaves);
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
index 522bb58b6241..88c417e3f016 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1425,14 +1425,14 @@ static inline bool arch_needs_pgtable_deposit(void)
 
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
index e7a2bf9636b7..d4a7c938e2e4 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1816,8 +1816,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
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
index f46c1b502eb1..b4de9068d461 100644
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
index ad852a415114..fd2c73335604 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2359,8 +2359,8 @@ static inline void __init pgtable_leaf_support_init(void) { }
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
 #endif
 
 #ifndef has_transparent_pud_hugepage
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b49bffe36d22..c9ee387a59f9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1091,7 +1091,7 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!has_transparent_hugepage()) {
+	if (!arch_has_pmd_leaves()) {
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 900539acb7d9..cbd9082d33a0 100644
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



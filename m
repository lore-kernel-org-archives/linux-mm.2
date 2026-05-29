Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCF7CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4989D6B0093; Fri, 29 May 2026 10:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F9A6B00B1; Fri, 29 May 2026 10:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385C46B00B2; Fri, 29 May 2026 10:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC3D6B0093
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:57:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA10B8BB76
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:03 +0000 (UTC)
X-FDA: 84820759926.24.ED922B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id F23B016000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L/ndfPHt";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVZn07Juuz7codcZd9CwODv7+/A1W791hW0Q9G0Sgs4=;
	b=QTr151FygHzcx52YwU1QyIO4zB1xi/Y2VrgtSgSguwJ5mkYIlof12yz+tlTJ6j+OOKiTQJ
	hzX5OK8dy7p4AtMkRCwefpCHmIgBX0On7bXmex9Mbffy684CeHxCp4ai5v0O02C2zzDw6r
	YUu3p5GYmexj60K1Y7Ew2JPw/wJDEOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066622; a=rsa-sha256;
	cv=none;
	b=Thd2cOYcT//CASWWt77k6gHTmERUIrbMvLZubDTKim3w4h/VHpGP4vCxdYPrcL+v2UOxK0
	j0qxr9TKLQGZHlLc8a5noba4wrJE/FHWReW3EnZmXF/XZItD5pGNYXyrTybhBq6K8HYKtP
	D3nW8CA2VMhB1CgW8mUj+xc86wxbyD0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L/ndfPHt";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVZn07Juuz7codcZd9CwODv7+/A1W791hW0Q9G0Sgs4=;
	b=L/ndfPHtWTFO9/bCdvDUcUoHdGXIdY0/KbznEDZ1buEr9irAWWX+fuaMrRTinPnM4SVKzF
	M2q+yu2k9LOYK4V+MEPBrcFOrKM/yOh7MV1IUzyXNrmzexcnoY9KYk7olcc9rSwYrnqN+H
	MNsUsYF+Cg8dBQ/WmVj7YsTLiVG4euw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-ckWuyUj2P-69wVzznHplLQ-1; Fri,
 29 May 2026 10:56:54 -0400
X-MC-Unique: ckWuyUj2P-69wVzznHplLQ-1
X-Mimecast-MFC-AGG-ID: ckWuyUj2P-69wVzznHplLQ_1780066611
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6945C19560AA;
	Fri, 29 May 2026 14:56:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A2DC530001BB;
	Fri, 29 May 2026 14:56:47 +0000 (UTC)
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
	ljs@kernel.org
Subject: [PATCH v5 12/14] treewide: introduce arch_has_pmd_leaves()
Date: Fri, 29 May 2026 10:55:30 -0400
Message-ID: <2f9788c193795398b0b1a3dacee7043d1e53d5c2.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: esOkG_IsVdEfHShJ_Er78AjgpESP2KGGEQFBTNjeGG0_1780066611
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: am4e6ndcahgp1xxrkt6xadgmzd8wzigg
X-Rspamd-Queue-Id: F23B016000A
X-Rspam-User: 
X-HE-Tag: 1780066621-176830
X-HE-Meta: U2FsdGVkX19XT1KYAN+PIV5SYnDn2T7uNr9T214rMXFSBiaGujTnbJuQ0tIv1+LGOVlFEp9o4Iw7q6M0lL1bWhG7JXDfX8cdRj6M3kue0wFhZTr5eKo3SC8kwD6aUSSyEpI+X/7nAXsJg6yvl41dqYH7alN07K082eWweqh5opM0rPYWta2scSmfFwMWp2H7nLCTOgiPEFrQL7lpL4hDA+7hLVNp+Lk311uO3f0Nk/bYDYCxKCZ4CvqfipOCgJWOZpT+etaRaD2FhC7fQbW9Ux2T2u0JNiwPXcucP+6CZ+twb6G0n/0yYBTwr1vu1E9C1hu3hpuQeq2DJ7EU1Q+inCGFa9tk9OVEwSsLcAov9cSRDAYkopWVQEixk8vl755AHs70OAvAz3TGNkL9DO6YqMaQ1vQuAkExlvUrV1gc3S6yn3+aTmU6xygpBi45YzdQI/ZFuntJApxyIkbdiw5dVSBU4U9AVBNMp+li8D60qdlTksG/rc139hPsDQxTWrR42csvdVq85bB/iipiNriNNssFd1VpHNqHFWfTetibG7sRsY6TjKESetgoq6X8cpX1+vhU+tv913s5YUNdWX6INwMHmkhVP1CQbGBh8R4Ii1xjGbw3oahWpCW7dyoO2d/lky2f0IzI91Taad8sQAktI9Bk+WXFsjdej9Z6mfj7yqq5s3PSlTdmrejbLgZsRIjOsHXjh9YFSO4lI2kWfcp/sR4wnKjXFRAUeIoqbE76RKntttYgaOe4093+YFFcS4YHYq1voRASVRvn318z4CuZ/+Em8JTypemwVu7gi8GYf7oWirdWNn/GB22Ffn8rFw3m/+6CzHeKoEpq5w1BNSdzGyZUIoRGruHuCIXu3G4j4C8KKaDUPQ7bR6aTBGUpKS4blNFMew1XOdVLHF2H5mmSckgsFp3aa1Lf6O50VTqUaowt+LogENjDzu/li4KdZCwMHqgYtqm/yEpMhHH9QFS
 J1qEPOE1
 T3mfe7dIr9sMX9eYMEDT/7cdZFzyRq654Dd1u4szcs2++Tt7nWz0N7K9z7IVQ9XQFcM/M8G9wlTcwerru6SgIIZyJmIZdxZb/8dtUmenuangVPMuEnOfi0qawHpakFTsovfVTFGQuzeU8h+cOqq8LGgZietlDXDVn2xv5pTTMweTm8Lu/+QAaFxxP1ng9Ro0lvySeAmsdFurrqqw8DhEx4PlGxuVj13R09j02+6PswzPSt5liPYVvpiS0PZlqqgVX06fEK00I4x86RVyfRztXqUPMMTV1rGuVXEBGyldaWuc9Hyd7+AHcQaA7OWlM8c9CXvHzwzk0pvpWu8YXVBFWBicCwSYjS5l+BBtM
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
index 49c8beef96bb..a5005d1d2a7d 100644
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
index 5ed14221cc0e..f949d6988a41 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1800,8 +1800,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
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
index 30fd1fa034e4..2badbe882637 100644
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
index d7899b95d3f1..57148c50f6d9 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2274,8 +2274,8 @@ static inline void __init pgtable_leaf_support_init(void) { }
 #endif
 #endif
 
-#ifndef has_transparent_hugepage
-#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
+#ifndef arch_has_pmd_leaves
+#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
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
index 2f2bf7950daf..953d8d1ea268 100644
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
2.54.0



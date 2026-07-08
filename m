Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979CEC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638886B0088; Wed,  8 Jul 2026 07:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6105D6B008A; Wed,  8 Jul 2026 07:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D79A6B008C; Wed,  8 Jul 2026 07:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5456B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94B8B1C752D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:25 +0000 (UTC)
X-FDA: 84965350890.14.A885E8F
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9AC671C0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F Z6VQ/u";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mA+TSjtr;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7x6+9xfPRDiiwVGQoLBhBDmj69+hy8kSxrhpgfkgMgk=;
	b=hGntRqIInOt7hQReSZ80Rk8GmsTFN02SgYp9fpFp2LH+R7o4TusJp1NeBE8h8BiolAiuMt
	B8Syj84Jme05TTWHxpmkxi2x5O1JLtAWewQa4/w9Nzl5ODmIEod8EfGCfPdOLxUsl+amNv
	rZ7RKYLycI8xh7An06hqrrkerBDucJ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F Z6VQ/u";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mA+TSjtr;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509263;
	b=leVUYNT1x8n5INMB536uDIx9enuyS70rBW1NYz8TGfOgDblfuREAOlLxebzePYDXy1q66B
	+9E1lwxcYvdeei9ZgSGRdLQGi7zCqT8IHFEo5V/mIHePE9WdW02bwvWH58GELxqRcUt98N
	ubxZSJa3sm0ON+YNGA+Z94fzYQN7HDk=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 6B93B1D00181;
	Wed,  8 Jul 2026 07:14:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 08 Jul 2026 07:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509262; x=
	1783595662; bh=7x6+9xfPRDiiwVGQoLBhBDmj69+hy8kSxrhpgfkgMgk=; b=F
	Z6VQ/ul36TWnVH9WUFCQeb2OF74F1PRFDDfdOpQ2xDC1vTYH99O9vTpvQLX/ddgK
	Zequ0CvtboMrhscQd+20dATn94V19Ztye+jgtJ2O+Wo88Utv8pE4GH9MCM6hjrpS
	83jhtSgpTKtnn8CEozpye84utQrHDAD8SyzSW20C+qERKZPPnIomup0DcKk034Cp
	EXh8EmaiJQyywu2/eIkHFigD/RE+FznmZK4Px8PFvUpqgnU6tLXlb2gS1RY2WqIy
	unz8tBqG5m1uGPR0J1jT8dGGdB7nP41K1N7AGME0JTTuwTJTMXrKg2lYZTQFuMrA
	4q0BZPnNbAJETCwlwqjog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509262; x=1783595662; bh=7
	x6+9xfPRDiiwVGQoLBhBDmj69+hy8kSxrhpgfkgMgk=; b=mA+TSjtrqb1j9wphi
	0q1CevJ8Ib8o2Bovhv2RICmTAJVPU62gAp1sttK95hM4D0lAGaf1mqPf6MLoa5qV
	JqigH/TPAgG46rwDOqTzFW1+VWLJ8yPm0nIfnSMrtIYhLhSYF6qXjlv9K2uQVrx1
	oFxp30y6XOIhfcSnLENAGRAn/EkyBgVOjwVKhLfayjho1nlQKG+32nvx9nvwP9Cz
	GI/KuWyb0wOPxMhN3bzQkQT5PRQRTVUZ8f/dz80hAchhT6RlgDBMcwwVc97xm1/D
	Nav0WZkd/PvuVegh5KuOeNGDWyXpBO0OfkMnlIWzEwTGOBPIQkqvX6JhqJbhpmi2
	Ft/2w==
X-ME-Sender: <xms:DTFOaqCJKIezWCzWlsAmDnQanGAGFogUK-Q5K7ZhOCQkvON2MO5-eQ>
    <xme:DTFOaoegkmXXd2uv-P4jlRGD5Y42tFguSq48uWfJHXO1lS1uOSzORL7Kgn2NL_rey
    PHNovYp9KiZzOCTE5ri0HwxtkqnSs124a44UhWF1zEJjOr90CCdXDY>
X-ME-Received: <xmr:DTFOamHj2FLBbpO6Q4g9BnVHYQu19QhA3eoKvPS1C9tsNIAzDB-sc6JMR7TSEA>
X-ME-Proxy-Cause: dmFkZTGp+lp1jxge+zfWWQDOmFev1Aj93weD2lzg4uPZWx+Z3SZe1CWKpSY34hOQnXWdCH
    X3J4fIJFgTBESvc4xWiwx5/MD14dlgPgF9nEAAA62nAEEbDoeWJIotrsSVP/3RfCG4AL69
    GWjO5h6ISMv13p/WrSnOtYbJToRcDYMu+oxe1Md/9ogUnUkXvzdGTImpAvqmGUHyhNQHgM
    9EFSvv/v+Vr6S4j4lzrtAd/spoCmUPXwfzSzofPeR7pTVQTh2KO7mHNCViFZXuf2LlCk37
    tL6Z2TITbN4EPiDlJfbqtg+HqWMejqgZ48pmgyHt4ULCT1Smmr1CePpfQyTeBk4h4LlJL9
    vKufpA7r0i174OPMA5NbvzhDka/NJwgrR5pEfL5janCRZrGU9pCFuxDbVWewmLLeegEBEv
    lDr6jlOTem1GeH9/F+ouLDRQxe+8qLW+/7WtgmLNEeovCq5soLC2MxUncMBVgvqt+V5v9A
    76/jzo8rn0986u4+iDYa/2u8Tmmv5xNoIdhLgVEBTyvkB8fmymzSnlpETcwNsd/wgvTy2E
    W6sby9ED6IuMkzC5EsFKkS7BKlw576jJavUn924xUQQw7LUfbiRkc/T9dPAy7xh/6p1F4a
    EJAKhNbmwtF63FgnTEAWY2zZ2Xq4Mv4ee/WUKXUj4z8GVRQTSnLd1qPl9MoA
X-ME-Proxy: <xmx:DTFOaiUH6k9CUIijaQWkd2ITYRPnRblcxRUcrb6ZwSQFDQF_zt8rzQ>
    <xmx:DjFOamyb9MMDRCKqXW2A_gp7l6iE0xIVwSEy0GWevSlamihmlYmrdQ>
    <xmx:DjFOattGoiGUrMzszvPhJQm8HSFHwifgWG6Z8dHhTM3aZi3v-yp7EQ>
    <xmx:DjFOanATlqlAzGI82b1N73AE27_WaVWzT85iF0jZa-3mgR8sLlOFpw>
    <xmx:DjFOasDmXisj5FEzuxffVRgeUQLRNSW7J9F2jdC3V1e1a05IKIQZem6V>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:21 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v10 01/15] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Wed,  8 Jul 2026 12:14:02 +0100
Message-ID: <20260708111417.173443-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AC671C0004
X-Stat-Signature: waboruu3dckkot14gfewqjcynj4on4bi
X-HE-Tag: 1783509263-183237
X-HE-Meta: U2FsdGVkX19G1YffrRgEnt0ZpjI1lUAxu7cJnITtUkazNpVBVNDSW/EGylqeojgNoK+Z5yq3fYfQO5gNbuCnI2Be2Tje2hqzeVA9xOf5AM0iZrqIl9eMYoQ1QD0/Tna0pzPceq/23N+mAjDp7lbWN3XqwD1LZI/vWe8bdrkExLhDSctE3CKgcUYI2Efd1xCMV4ns0cbQdDfYbuyRtsnyG4gKU43XSdGsQstFGXK2+hEkMUGoRrl9jEcEa9FIrywp0PX2ChRnlbZ5wTRkRFOXpDDH6gc1WuXGWBg/g5EK8KDTQm/ivkkVQANFjCwqZh+y/PAZosHvda7+N5J1MSmN5BdLQFh+q5kj24EqHFfl/OWY+oo+IENcDaljkLzkezGhPr1cqXk5YMU72ccApGldUlz4xGgSZd8HCW4Rl21Vqqts2YGUR2z82MKG+WC9vsd1gmC1uFhHHHG2h5ndFocgbWoQ97WDVnIywcXuV6Kzqco2HhSk/xS5oA7WCQSU4nIve32tR5TFcfOOVYsba3twmva43P4hoSIjOc8mz6QeQ3zUEzXhAmRUGpJ8I2G3rm5qan7yMBnE5gRqh9y43vMt3nEF6qOIwHzERfQ/VB2jd9VBrThe+iyrcA8GXEM4FvaHN1UFpsD7qWfz7Lqn4nLQf/N42wr4ilFUHBOsY8tRqosRHbx35cWLG3EFMyvKfctVq/+CSH2Z5i2ilJ66GtK1aFCQ1XbND76Oc8/0hMt31gxNVLS0SQjrw24392poe5inRwHfeOSRBFlbVwLQuy8CDwhnzV1QZi86uFCQdiQ2K1Ux6Fpo4tKM9XqWARtfgp0zerWXd1R+yU6XtR2+2dS27OJMvnwJxArI5OP2JWe42oeY55YtLH6fCbHRArC2uQSgP87s6SzbnR8xbbAzCu83O34Vgs/BLfeSvsi1tnotxV3lY+L+fKke3Kp1r9U64KFrOmF2XJScgmudxwF/AH1
 +NExlIkr
 U6TScJv4NTnjENoEZO/GONqq2kaAYvXox7ezbKseu75CRHVn7MoaxvdFxbdvsViMLavLSmw3Kbm7E7eKgUHJNc3Qm4mNnOTxsPb//uGytkngU3EQJkXjtngLpMUZwUEQLuykBLX8n4fLqASLBBSFwpAV6HT0ckPEz7K9J5EZNRST1yJoAwhyv6lZBfeU/mU25cDpz2d/K7VsPIE8KV0jdDbAS1TuyERbal36h9LxSrJwRgr8sVoBQlYVJTvToqALtnplRgAhVlJeb6EPwRKb3xPuD+sHnRYe3KhMjo/MKilXhdDs3q5rZ3TR45WE8NirZOVxuFXUoHYmkuppaB9c3R1QvqgtjEWBq18pXS9tJUlVdZRtbqR3Y3fbfqDZ8ZlTSL1ITxZGtDwk5ZFfnXpBb1+fGKwYqKynYLXiewj0InYA2Q0A1o0g7jhVN86aQjMwDmyjN3w/soGXzDLO85IO7q7dMho4mTOPXw5gfHDj/dl9SkZqpJZRk4hlAkzhp8FtBfOc2e1zUtdr54uixsv/h3Wsjib4KlK1fosNJ+5z5A/w8KDOQ6i9SopXszBdCQ1DU3diGYWa099H3+FTvf2TnR+P39WHK3No8IhD4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

pte_protnone() and pmd_protnone() detect present-but-inaccessible page
table entries. This capability is useful beyond NUMA balancing -- for
example, userfaultfd working set tracking uses protnone PTEs to track
page access without unmapping pages.

Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
infrastructure from CONFIG_NUMA_BALANCING. The six architectures that
support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch)
now select this option, and CONFIG_NUMA_BALANCING depends on it.

No functional change -- the same set of architectures continues to have
working protnone support, but the infrastructure is now available
independently of NUMA balancing.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/Kconfig                           |  1 +
 arch/arm64/include/asm/pgtable.h             |  7 ++---
 arch/loongarch/Kconfig                       |  1 +
 arch/loongarch/include/asm/pgtable.h         |  4 +--
 arch/powerpc/include/asm/book3s/64/pgtable.h |  8 ++---
 arch/powerpc/platforms/Kconfig.cputype       |  1 +
 arch/riscv/Kconfig                           |  1 +
 arch/riscv/include/asm/pgtable.h             |  7 ++---
 arch/s390/Kconfig                            |  1 +
 arch/s390/include/asm/pgtable.h              |  4 +--
 arch/x86/Kconfig                             |  1 +
 arch/x86/include/asm/pgtable.h               |  8 ++---
 include/linux/pgtable.h                      | 32 ++++++++++++++------
 init/Kconfig                                 |  8 +++++
 mm/debug_vm_pgtable.c                        |  4 +--
 15 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e136e5abdb33..11a9c534b7b4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -78,6 +78,7 @@ config ARM64
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ed1cc6dba780..313f75af1207 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -553,10 +553,7 @@ static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	/*
@@ -575,7 +572,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index c6c611f44f3f..e20acbe5fe7b 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -67,6 +67,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE if 64BIT
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..1952e34bc8ee 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -623,7 +623,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline long pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PROTNONE);
@@ -633,7 +633,7 @@ static inline long pmd_protnone(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _PAGE_PROTNONE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 800ff3cc5f71..f4db7d7fbd5c 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -490,13 +490,13 @@ static inline pte_t pte_clear_soft_dirty(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
 		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_hw_valid(pte_t pte)
 {
@@ -1067,12 +1067,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 9f6847b53e37..f0adbf7ecb7f 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -87,6 +87,7 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_SUPPORTS_HUGETLBFS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 2b7b69e38383..bf12b0fe35c2 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -71,6 +71,7 @@ config RISCV
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
+	select ARCH_HAS_PTE_PROTNONE if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 23eae82c26a6..cbc58ec42752 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -534,10 +534,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 					PAGE_SIZE)
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/asm-generic/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) == _PAGE_PROT_NONE;
@@ -547,7 +544,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6b317717bf48..ab8fccc2cc4e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -148,6 +148,7 @@ config S390
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 645fa2d99c6a..e882663a58e7 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -842,7 +842,7 @@ static inline int pte_same(pte_t a, pte_t b)
 	return pte_val(a) == pte_val(b);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return pte_present(pte) && !(pte_val(pte) & _PAGE_READ);
@@ -853,7 +853,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	/* pmd_leaf(pmd) implies pmd_present(pmd) */
 	return pmd_leaf(pmd) && !(pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50acb2830570..fb298e219179 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
+	select ARCH_HAS_PTE_PROTNONE		if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_CFI		if X86_64
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index f69b02c1d3d3..ef61a75cd98b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -985,11 +985,7 @@ static inline int pmd_present(pmd_t pmd)
 	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
@@ -1001,7 +997,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	return (pmd_flags(pmd) & (_PAGE_PROTNONE | _PAGE_PRESENT))
 		== _PAGE_PROTNONE;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline int pmd_none(pmd_t pmd)
 {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 3df6db1e9e39..8c093c119e5a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2110,18 +2110,26 @@ static inline int pud_trans_unstable(pud_t *pud)
 	return 0;
 }
 
-#ifndef CONFIG_NUMA_BALANCING
+#ifndef CONFIG_ARCH_HAS_PTE_PROTNONE
 /*
- * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
- * perfectly valid to indicate "no" in that case, which is why our default
- * implementation defaults to "always no".
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It
+ * is perfectly valid to indicate "no" in that case, which is why our
+ * default implementation defaults to "always no".
  *
- * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
- * page protection due to NUMA hinting. NUMA hinting faults only apply in
- * accessible VMAs.
+ * In an accessible VMA, pte_protnone() reliably indicates a present
+ * PROT_NONE page protection. Today the kernel uses such PTEs for two
+ * purposes: NUMA hinting faults, and userfaultfd RWP tracking on
+ * VM_UFFD_RWP VMAs. The two are distinguished by the uffd PTE bit and
+ * the VMA flag; see include/linux/userfaultfd_k.h.
  *
- * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
- * looking at the VMA accessibility is sufficient.
+ * So, to reliably identify PROT_NONE PTEs that require kernel handling,
+ * looking at the VMA accessibility (and the uffd bit on RWP VMAs) is
+ * sufficient.
+ *
+ * Architectures without CONFIG_ARCH_HAS_PTE_PROTNONE get the always-zero
+ * stubs below; PAGE_NONE references that survive to runtime fire the
+ * BUILD_BUG() fallback, since callers should have folded such paths to
+ * dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -2132,7 +2140,11 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifndef PAGE_NONE
+#define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
+#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #endif /* CONFIG_MMU */
 
diff --git a/init/Kconfig b/init/Kconfig
index 5230d4879b1c..9d91074c5d0a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,6 +944,13 @@ config SCHED_PROXY_EXEC
 
 endmenu
 
+#
+# For architectures that support present-but-inaccessible (PROT_NONE) page
+# table entries detectable via pte_protnone() / pmd_protnone():
+#
+config ARCH_HAS_PTE_PROTNONE
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
@@ -1010,6 +1017,7 @@ config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
+	depends on ARCH_HAS_PTE_PROTNONE
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 7987962950c1..2875fd22d7bb 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -672,7 +672,7 @@ static void __init pte_protnone_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	pr_debug("Validating PTE protnone\n");
@@ -685,7 +685,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	if (!has_transparent_hugepage())
-- 
2.54.0



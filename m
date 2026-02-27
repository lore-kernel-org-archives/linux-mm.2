Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89908FD9E3C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC566B0088; Fri, 27 Feb 2026 01:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64E86B0089; Fri, 27 Feb 2026 01:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91C26B008A; Fri, 27 Feb 2026 01:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C25836B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:17:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F0C2C1F76
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:17:02 +0000 (UTC)
X-FDA: 84489228684.25.ABD1CCE
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8310C000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:17:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PMPgSxth;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772173020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scUOVzAnRBW38ibEW6xQpgzOJyOZg1ewr63AX7NvRVM=;
	b=Wahk5Q1LpAUlei4eTDfKJpDt9S1pnWqCL+VkkivfKpTbuKiMV9lYr8WwM4kd8wX/yS9XUM
	usKfv5q5hMog/pydfuQ/q19Msk0/ba+pQAd2e98XWzo1Ak/cvEh006GZC+R3am4x43MpeA
	NHoy+6U58HG7ahmCQsGAN9YBqFEmHX8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PMPgSxth;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772173020; a=rsa-sha256;
	cv=none;
	b=pELnOkiGTw23kuuIwl2udjW1LRn06Mh79iKZ1PhyXanSrxaHjz38WjmG9b4TdFCqNbO5av
	vTUP4wOc3AiFYQcU1GNE5An9Kp8AoxaiXFoHHNwXo8+7J6b4lMBW0fk2PIPOiZhzRwOuHO
	DaWImJfaCHyP1eATMTrHC+l3AMEVQt0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aae146b604so13028735ad.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772173020; x=1772777820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scUOVzAnRBW38ibEW6xQpgzOJyOZg1ewr63AX7NvRVM=;
        b=PMPgSxth7dilL5J7HcqejkaXsUY4pKIfEwK6lDriJvga89w8yRRQeI38vGD0VnEG5s
         Ko7oVK4NdkV26xb44prsRk2qCRxzj/LTrux77sVQJyM3rgTqgMTrLV+MPYofw7AC2mPO
         sLIaXAjf3lHUnaa4uDKsrIGvLIfqKwvhNdbBja2VDCxnE/ayF9sl63BMSSg2eq+A6O8B
         HuzdInnJwPycvs+eM2wpOUhOmcTYBrosoBBts38/kDPUuqRissyEAr5og5K+/yNm1C4o
         htNiYEMo5GvSGRP53VMgB0EdpUCs7wCBV5sYWpbpYgDU0F1yqQBeqetKNsa5P6r/CH38
         qNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772173020; x=1772777820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scUOVzAnRBW38ibEW6xQpgzOJyOZg1ewr63AX7NvRVM=;
        b=Zn4Ykkg1OFy34J9acopOA+L+EBnsXoyP2Fv4hfQWm+JT2UEaRNPOPMQftGcgAlcVHZ
         Fcn+8CR/7SF0RhaFI69iAQ5re8zapzV44tUWahjMeZHCM2VmSkfFUtkjMAzXYkOU3/wE
         9SIxpsLpyCZAHWqa6qtIM1r1YqhEqGshEGIP7pC8NoCUabCyMCcJJYV2pkmMA1Igka3M
         B1nQtiZlS1DyWo5cKqXU8AjvPMXB1R3aWOvk+SHp+fmjpL0SWWuTxKZn6s5raWzoEHlL
         A6d4oOrg5YVYUCAZaX/RdQh4FEHEiIcJecusaQb3VPPUi+7axUfkZO7nNkwf9hPmnN17
         7vIQ==
X-Gm-Message-State: AOJu0YyKZ6C3RcYkrJNab3FK0Dz/Shvu2JfHsMJrTO4x3SRbfa7TrfNa
	RuzD7RPUCF5ZiQ+jdVGEyo4/QeFGqrmXGAW6Kt/Av/B14spzdV3Gr/AE
X-Gm-Gg: ATEYQzy8XlGFLPP2u3g92xJ/6xW9gOlbqzfF/r/bWPavqzdlLi38iPZHtJyPcKUfmCM
	lZzIwiowKZ9Mc2Uft1vSzBTc6tIXIbcQCtxLrFRtPhHek5eiVXOhBPEHwOWfq1bEwMdrOxnoo9f
	mtRFn6pQk8jhrDYhcy3392A+kGax9h9bvPypO5/jG4KSyt7FCqL9YfkEPUVGPAVCcgul44jE6Aq
	SKggOzLzUBhwv0HLMpew9zl8FjhJus4kvN+NA6UjXAJBTe1U1+Ihml/Pexr8Yd8EeOnSHIN0NNV
	z4EHJnWdoQeFCsnCmtYn5BoJGYfC3oWTbmYodVpZ9Brr2LNMbjuEfQlPuRMX4hL6PdiWeHxOPj0
	DemLmTBBcuvgH5x61rWMUc+7fftnkLDPDB0aV21MF8vFmFdY3ZGy7Dt01MRP4TfdoHpKVkU5bP9
	6HflMP1cYhH7OVW/UZZtbjojJoILZW
X-Received: by 2002:a17:903:1a06:b0:2aa:f0ec:3701 with SMTP id d9443c01a7336-2ae2e3e9a31mr15207155ad.2.1772173019761;
        Thu, 26 Feb 2026 22:16:59 -0800 (PST)
Received: from dw-tp ([203.81.243.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6d1913sm57837485ad.77.2026.02.26.22.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 22:16:58 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
Date: Fri, 27 Feb 2026 11:46:37 +0530
Message-ID: <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: spew35rhkdm45fxe9mssejmpxaax9ztw
X-Rspam-User: 
X-Rspamd-Queue-Id: D8310C000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1772173020-926715
X-HE-Meta: U2FsdGVkX19bmmUC8k+QjE1SewiNtH9IJgJKABIYDiCCnY422XDUe/Tt3cUGr59DwcHm395dqziYTrMH5R2LwbgIFP9jbi+8h+BfQt+9DZxay5MiGIT1Y97I4bGaz3DZ6sUXLbVm33Yfm14rfSkeaby2Ax6LZ39F2c3Dw7crMnLNDhGyB3felOnIrBwnPE7dXj9L2bwpnbu06XSI4jP2DGHCUBefCFl5JV01ISuDfipIuEC02wUHLZAfTTTnPK7uCqaai/+XVg+BDZ7hF+erKjbPWMU7S5do5uiojn9diRzEnHPIBY1DiolhUZYZwG/7A5FeJ3K/OpouVYj7dx4P4n59/VamcrxmGfdVqCMhGlBcO1YxnSu2lvMdtnYc7PTli3mtdUaEtEipdY+Cqi9wVNZR55JMxFJn5K0ItuP5eo7hsr3snJ9VwEfG6xc6R65+uUxfBYqE/vlsqP+GPtTRiLxJvQbO7fAjqRvrZcyTAv5aBFo8TGq4yugw9pdhyFAOf67AQncIolsssx8/8Tz8znW36wmhbzMNdfCY9r/uFcv55g/nFmSqTR4BCdlrGDJfMNzkbi/5pfeyTEjVHIP1UcQI93HaRmMHIGFJD8nJQw5TSjVejnazasuPzDD47NGQYBOsA/R6sZvl4SyjWQ/DLTHRH8/nN3v9vxDkRKqdFL9WCq2eunj/XiV61nHD7yi3C+9LBq07O2q1Dp+pFwDP4Drh0lDUGnnWemCgZvCyCfU3EJ42Wdqk0Ho4IofU+u9L0CXGl1bsN04rVfW/R//G/KIAHujiC6jtsvt01NSOzHBRp/pXXzMXjjTZYFDVef4Auig0j14Jx+S2mFL8U23MeSaNkP3B5P3UFOXgLlSaeO7pUHMl4N9rmF1hxMYJOvtUKoX9nMjE9pYMrX7x1+11p10rNxfBSyw7d9CSDs7PJUh9CzjhB7Ef3pxb3oYt5WjF88KK/thLVRnRjw5cLlJ
 7K65TBlp
 4lfImSL4kGVDsVCHXHqfPU3Vv5SOpIiEMzrTKsQhiMPyTDulGDevageZnJdS25tR670uHVlm8++/1rFipsdYTucG1tYQYiVoQoFacDmMv5WuLd//55dRGCh8cWu1I/zUH07axtiQYQ7QmQQGORAtf3LvZuGGAlRtnpnsr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
This also adds support for {pte,pmd,pud}_pgprot helpers needed for
follow_pfnmap APIs.

This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
VFIO PCI core driver already supports fault handling at PMD / PUD level
for more efficient BAR mappings.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---

@linux-mm:
Is there any official test which I could use to verify this functionality.

For now I used basic ivshmem setup + vfio using Qemu and validated using some
basic test to see that we are seeing these prints.

[ 4351.435050] vfio_pci_mmap_huge_fault: 3 callbacks suppressed
[ 4351.435234] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x0: 0x100
[ 4351.457005] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x40: 0x100
[ 4351.463684] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x20: 0x100

 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++++++
 arch/powerpc/include/asm/pgtable.h           | 12 ++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..cf9283757e5d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -172,6 +172,7 @@ config PPC
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
+	select ARCH_SUPPORTS_HUGE_PFNMAP	if PPC_BOOK3S_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if !HUGETLB_PAGE
 	select ARCH_SUPPORTS_SCHED_MC		if SMP
 	select ARCH_SUPPORTS_SCHED_SMT		if PPC64 && SMP
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..639cbf34f752 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1289,6 +1289,29 @@ static inline pud_t pud_mkhuge(pud_t pud)
 	return pud;
 }

+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return pte_special(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pte_pmd(pte_mkspecial(pmd_pte(pmd)));
+}
+#endif
+
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return pte_special(pud_pte(pud));
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pte_pud(pte_mkspecial(pud_pte(pud)));
+}
+#endif

 #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index dcd3a88caaf6..2d27cb1c2334 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
 	return __pgprot(pte_flags);
 }

+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	return pte_pgprot(pmd_pte(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+	return pte_pgprot(pud_pte(pud));
+}
+
 static inline pgprot_t pgprot_nx(pgprot_t prot)
 {
 	return pte_pgprot(pte_exprotect(__pte(pgprot_val(prot))));
--
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372DBC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2516B6B00F4; Mon,  6 Jul 2026 04:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6C96B00FC; Mon,  6 Jul 2026 04:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA756B00FE; Mon,  6 Jul 2026 04:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38F96B00F4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DEA21C202C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:13 +0000 (UTC)
X-FDA: 84957724866.17.39565E4
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf10.hostedemail.com (Postfix) with ESMTP id 407AEC0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="R cfqvwp";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kLfniikh;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327691;
	b=6onANqXSMvGfPfG9A1sIxSYCJvAgYXz7tk6FiuNwEgoeTgm4S2F8wQOWQ9sujwzk4OcVz3
	A78FpLDFpLTpJKYrDPa40p03HXE+rxZYIvSFEbxQpmFOmxv4226zGFSXWsnNQ3iJgjGpHP
	9t9XGG9lSV+hcKvai83a11VCQfJSMF0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="R cfqvwp";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kLfniikh;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bi6ZCi9/zUIsKmhwfb8Lt5NG7YE3vAzXLT8nxhhcSmo=;
	b=M0yf8ni41EfzSuUN0qFKzPUMzE9MylZvoN6JcdesyW+/IzPtmFC7aUjxEc+YK1ncaqfYRF
	melN5M25Zj3fPMgKcGZgcJeuQzfPBXTJm2JX8lHtYZ9dKXsYnUPd0wV9FgKt+/uVsre8Eb
	+dfKEBBiT7o/uRSlq6KBU6gIm4ym10Q=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 13B461D00016;
	Mon,  6 Jul 2026 04:48:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 06 Jul 2026 04:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327689; x=
	1783414089; bh=Bi6ZCi9/zUIsKmhwfb8Lt5NG7YE3vAzXLT8nxhhcSmo=; b=R
	cfqvwpzxCwYdkNRtEjn1PbcJJNrlnpkumMNGDfbMNsYTenG9k9lhBD16uQC8LJVd
	WTBM244qbD8U36Rz5xoAU73hNZd43o2tIr3MF0cQn5RTqwVVu9Mi4Mb58pq3N9h8
	nzp79Lb/7d83OF/KlYM4P5tYgYJIS69OD6M3dW3nygXVdU8nuSQuINthiUWtrfgh
	abw7VBs24yMD84HwZNphojzBOYCrMD+iWaFrpThQcNGxy2jjYiy/FbPGjghGveWk
	zg+hxmUsfuvjKh5RRAPpBG50zV7KgyK4lt2PWH56FXl5Gu1Aw/OdeHZdnHoQEU5Y
	TebNnbEHEN8x8LRoVLvUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327689; x=1783414089; bh=B
	i6ZCi9/zUIsKmhwfb8Lt5NG7YE3vAzXLT8nxhhcSmo=; b=kLfniikhO0erjhPYx
	5tJcnwB4aQijhUaV92YscgVXk6ukaiEgxK4xKk4BXpOnPQi/nZ5m69fixDwC/GrD
	Cq5yZBwFYwDvvOH/I+ud01IBxugbrWTk2oUNSuRhGIogmMH8w2dEIQ9ndJdsxx18
	DKLRC6usmu836vcCqh94uvDtmrNgZico/ywHuo/ivbBpdntbFYV/dpXaiu5a1QSV
	IOe4eklkbFsffXUbFzWS3hiRxJ5+mOTZER6WbFVza3odCKA9rUqhq69YlcKJQid4
	v8tM5GCdAsxT28m6MZqbPmdmfMav0MYRXgcs58dhIr9Jk/j5iMTrw/tjlG9qZTJ4
	4XIGQ==
X-ME-Sender: <xms:yWtLaqvSfoWXTy-znKMrQysButvkqiwp3V5KD0boLAowsWvMlzeBig>
    <xme:yWtLajacExamGFwFc0b4b0DOqlplS4hTsR3ibjt8Mfc9H6Jt9dtkdhgTaET-g50hN
    sm-aU9kggVsp01SW5nY-wb4UXNzU-WUL9A34ugJPugwAsVFybPrOc4>
X-ME-Received: <xmr:yWtLauRGNyP9jTaWMRLxa1K7nTvaHANwza-xbMaKpo_u15QHSIHCFY62J9ux2Q>
X-ME-Proxy-Cause: dmFkZTGt1AJc/LOJxCUAoSds+Gzhml+wnGe8Rlk5Fr8cdEXFiim2zor5eK1l8ySzvTQLFe
    WvN3cCbjOrHzX5RbN3xVrJGWx0TgIGKlDIozhiQnB10QDwtbLEslnBO+Hk6WPVCMXakW1c
    Rp5P5f8pbI/vWlGAe91dmBYfuK3VxNpGYnnMJNG9bt9MfE2ixhoJA9U4fGLbeHnXYKZdah
    c1502vznm8HD+zb9FgXwZfM4O4LRfZ1xcQndIfrC04ucvmDI+r5t47JJlzQyM022PaOVVd
    lW4URGNSJSTvPjhqtU/E6JKzKMDLQCUU4kYYhs4Syobmig+TpBfzEXuVwfvCm1c0jfdpk6
    Z72qTN0Hx2Kc+MH5ZXyfJJaIn7DxRp6p37gY7/fGYl01eBahQv2tun+u5noy+Bt08G1CYX
    X+Xoc+uQe1T4m+qwIcJBQuQJwkU5Qzu73+dhj9FxNvQ3tpL+Js9bTD4zN3Oz+oPm24XHsf
    xY+rUjUgf1O4Su4G7zQN8OLu1n8nElZ09v6Vf28bNXA+B4Hsd5QRjtIeTej7/F5I01xJPt
    uFnxOvO8msB8827rbcK0qJm86QDxoORpgu5p7EXA00bCr+cEbj3JHUtWkapcbYzadLli2y
    nJbqTl4qVgGLjoILp0jtufKk9VYQmWNjHH8RLEM8TQFlPLif0U17PE9xVMoA
X-ME-Proxy: <xmx:yWtLauwXRiy_Q-gyJ2qQ5T5zGIndjFsF0ft0hWIEM4-3QOqa2QQZ1A>
    <xmx:yWtLaieKrleNTZ_nJuF0UXKjG_dYLd26HUgHtZCoyCchWbg6oa5law>
    <xmx:yWtLanrurFIJTfY-nrIFecjFKwV1Kf1h179SP2kITSm5AItu0DFSBg>
    <xmx:yWtLaiNMTIZFTeVzylXHUlr2j2W6e24MuiV3bYKbDKZDiWBMUPzv9A>
    <xmx:yWtLanNg0DnhYXee-BtMKyEWQ0y1BH9sArhAwjN-msIASyvioXpwmxsH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:09 -0400 (EDT)
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
Subject: [PATCH v9 01/15] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Mon,  6 Jul 2026 09:47:50 +0100
Message-ID: <20260706084805.8400-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 407AEC0002
X-Stat-Signature: cuqwfezt6fyhwefncmoo11tnbnq1jnjq
X-HE-Tag: 1783327691-680325
X-HE-Meta: U2FsdGVkX18vQFLjnliFXnfkxh2EEBMa6yhP3rqNGA9ZG2dLrv4FnLpRdmGM9o1+dwNlHIuFR3cqBaK8IrAkIxjcr5QUL+u/EObxb41esHglJsQZYzcjN/iQYIhtKlq3v2odjFyAFdoqPoUuF/dnaCH8Kcdv3a+rv0qyTXW3rvS2Hgw/sOdlzONy+MRhKwnKPCwjRbkCJlHwq3bYASeuVMjMwjyE0hF2fl77fwGXpEeGvWKNIcPAd8vTWYaHSBFNFfcUPTEMyc0xD/lcRQ3gtG61jQlzMrNY4ePSW6TUByPnS5pp1zFdlIs3X+dujZBeZ1E3oOTkOqIPkYu9sBcRLw+8uDbNCHocymrjVz/MhNpkSxVm/j7FqXc9kJAZKt+SbNvs+To5dEc1rj0oNUdZv/mUU+vMrqeKGd8dPgC9L5hZYZFBoj76RQG4AjdbGEqEMTqC+nAEVStBjqAVIR8C72ylbVN3ABM8zHJ3EKgQH9mQcySweVmMtoYGpg9HcjswxeNcgm3sZPIyT8REdMSvAmRe96M/CLK8lhLyZkySx+Yl+CaPjaPYifwx318aK5xrWmiYfLxcpBwOP4x8smoH7vNpRFV64RUHK0sEXgWI7/BK+5ZPTe280anbNyktxObJIvvEOQwg/Ga9IUoPHTBdxVAwnm5E8/S1uZSv8RPGX5sPbeGV2Ria1DWX7d8WfNeKu93P4jCIBFvYdNi7ruCo+uaIbJsGJiCdCF57cX+IJM0Hhwq4TRh1DLu/uQGUnCTIG1Zl3ft6iL6ZZcgozRjZn7qEcVfntOMWpVPRjLwNE+ec3c6vaq/sI2hUV7AB2+FYBrhTiQZZjY8EPGjUMD+vw6GgoSDwOC13SyrJLIfEn7xg+VFGN9kUOM2AciIOqNQH9qrnhrCRLMwr0KHkA8VQgADQyiGlTl4MgCKyK8Xkq//xj0wWS1d2+4ilVbecsdSIZGRSakgplduztvwbZF+
 FiemWLzG
 GZgjBeLZCfSly1H5VMjllTeblIgTnzADSkiEh3bx/11mNI85SjL6+adPU6gdKbm3iOpsrNSbC6hpkzx8SdFfEmBZ48m0gRmfw+767r+Cp9TJr5hgBNAYijPIiO9wdmYyJ/OPmDgY2nonR0wcEaC4WQLLILtVRwYOspQ47hCcWV2mt3tQIV/SQplHLvD5+VIx+4HTfrbPOHjR5uBEAxiGf8Ro8lDsvoEzw5GmpzvtxtAMs4JgUuZI2POyg6c0LEDEAyai5wHZCjGgnnaHkWidffu0oPUsdTDYNCfdh1KlUie8cqhEBSRpliJly+s/lKBlSigGsyhgY6p0yVmOXKfu1C4pl/nMlG3WzHnAw46c539W5nrheoJj7mpLI6RJaYstHuPflWctmcS0vq+GjRxFy5Viaz1xY9xJrGXOLDsMxHnUocZs8ZQ/DrqmtOxQho6jzHh+HaMRNVae4pjGceQ6HITGY0XMaSryDpw3fWFJ65uOi8v6aHXFvc6rmttPvkbGH5J98ro0Dca2JylMiDit2TkDwCeeeNAbGEP+ofe0CzSdZXfRQDpDmwjlW6fsELHeFjppc64Ur1m74i/xvxdY4/Fqixaj1RgMtqP3V
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
index b3afe0688919..6e123adca29b 100644
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
index 27689c62bd25..83eb707508cc 100644
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
index d8d252325017..177fb9dc6432 100644
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
index e67e64ac6e8c..53a0c5892548 100644
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
index bac02c83bb3e..36b64a24cf30 100644
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
index 3f0a647218e4..58c12f4fac66 100644
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
index 5d5756bda82e..8139e0b2f008 100644
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
index 84404e6778d5..ad56daa6f874 100644
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
index 859ce7c7d454..0689dfdba407 100644
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
index bdad90f210e4..380c4aacd42a 100644
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
index ac295ca6c92f..36c44350f843 100644
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
index 2981e386da7b..7d3dc8abc6c8 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2129,18 +2129,26 @@ static inline int pud_trans_unstable(pud_t *pud)
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
@@ -2151,7 +2159,11 @@ static inline int pmd_protnone(pmd_t pmd)
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
index 23dc3ee09561..5e9f3a35f924 100644
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



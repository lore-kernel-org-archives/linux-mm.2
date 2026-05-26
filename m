Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD1FCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90316B00C5; Tue, 26 May 2026 09:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41166B00C8; Tue, 26 May 2026 09:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08896B00C9; Tue, 26 May 2026 09:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE226B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 545D01A041F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:34 +0000 (UTC)
X-FDA: 84809592588.20.8C4FBF5
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54179C0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="o q3CavP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=effCe9JD;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAnWr4HZExOeax1r+Y5qX/ebuMdtOSIqyv4Q47MTSAo=;
	b=kD6X8s2H3hjeK9bb7vQw0gzhTXs6G9lshaEqX8kPbzbglKLggg3jEEf5zTsGNPBnNgEJ5P
	W8vl7CQi0dw26xCrXMu/YP4jNePalBinNpf2fNq4Zal6i3299hTI6KMieeA64X+l+VaiWO
	i/IiwUV0XcGqwwHOL7YxAbVmugirfyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800732; a=rsa-sha256;
	cv=none;
	b=Qalg+dHefqtkHOoZasFGhTxIulMX4rk1mSoHqB6z6O84DMzHqFo1Z22KuXT9TqQglmBnCB
	7WDHzSK6RK4+MnpCds3GVL1kr0RL2TEbQO7ifmTwYuXl+JBs8WdNm1cviEh71ztgU4n2aD
	qSw7upfgd71hNBLApuLGL+Llk4VWDqE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="o q3CavP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=effCe9JD;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 1571D1D00139;
	Tue, 26 May 2026 09:05:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 26 May 2026 09:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800730; x=
	1779887130; bh=KAnWr4HZExOeax1r+Y5qX/ebuMdtOSIqyv4Q47MTSAo=; b=o
	q3CavPEcYMoMYYO+zT6sPiWy4APW9LNywMzgkfF+Kav7aVL/I9uWDmEjNxos4bZY
	PwgsoPnJ6nXFDlQitwVuUtPHJncbdE/FxXbDX7Ka4eEgBTyLPGryfzhXNlJ42GGA
	2tTwBKJQ1Op/1Be1k8gI9e+5eoN7uaPzVFXQF7OVrOab45ZxVp+WVp6yABKkUomk
	EIbFKUQJSIEiB0bfMSZ8H+RPhjFqosR+qkO2UXpaKzZ+I92zE+aIXDQfPwmd7FMF
	dQXGLV+AH6NRTjlTLAwYhOCF/Kt/fB3P50DNb7+ev8ab/8Dc003prHgc17dEbo3G
	+N2/U2a2EY2Jo2vCtSftA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800730; x=1779887130; bh=K
	AnWr4HZExOeax1r+Y5qX/ebuMdtOSIqyv4Q47MTSAo=; b=effCe9JDOY6bFitOh
	q8qJzIoxG4JvotqH2CeEKQ2q71E0IEKvUfPSeRvvLju42dXWAxQaX7IrzUk4DGI9
	DPHCgTUbZb6SoxTvlynWTNYgow+Gd2Ke9BD87jQdbY7v5lELvlLoFkiMjgkVP8lb
	UpmMR0+M97KQxOfMW/VdzekDSPdeB7/cCROhibh7BK/c6ChmwcqCj5uAoo6k1lKZ
	C+7Fkgsf2uF7hOPW1O/CqRwl73nOpukdnh4RjNk1ki8SOJ+rESIeiWOmgyGw51rK
	nKX2T4DQsHw6FvoZT+LydI41rltU319qTxC9wAMlqFiBD7KCoQpraXRlOGLNkizH
	EpuRQ==
X-ME-Sender: <xms:mpoVatq8RNs_PsWhrpIl56DuyuiGJZHJU7BzkZllnTycbNsdQuwGFg>
    <xme:mpoVajmMEhG6z5Veatc03BJW_u4z_BDyk9zR2hkTsgzKnjG2capVSKUM2EOgxQDBZ
    1JlBszFwJlf1A-ujGF18yJqSWD5lEomaDXuMmxMTleukdacNvxGI6k>
X-ME-Received: <xmr:mpoVaisqKupDQoIJuRmF4X0v7VbLpTMzk8fKR9pVXpDuxD6_jq_QPf40e50yug>
X-ME-Proxy-Cause: dmFkZTEJiC033GhjL2GdnX/sXIn31a6xYH9Q9kJLS3tMsbkgwO/cImnHqXQKfEc55wOLx4
    i2tqVUZQjDS/XsxdV1Neul2ks/uVgINeMKnTDgBTDd49K013fUhaa7mbXp5KOF+CzusOdT
    UiYD/yezdXIvKfe8z5w2tcDXcgJNRSU5eSwZFLQl4UtnpivyD/d0gOKuFq22BcEw4tqdAi
    ZrLfx6gsOEL+8JLB9yUFNWntFWViMy1Q2hMU0QsTFycK4r8MnF1MjvTDo2QKxDh/PpEdKA
    ZnnGzw8DPiuoI+QbA8cmDBSDEJ+Eojxn1EXRLRmRJNLXOxLbY2LwfoxO6aBp6BbF/3ouHQ
    n5U+D6Jy8en4U5LNdI3hlF7xLvRmHvMy3bNSSH04fNcrXF7LI9fULmyvit3A0bnc6wN7Tn
    WbGpDsCIyOOQzATw0EcKNzlMqPkL8tx89piruJbrMI6OPEHKCR6A//4yzF7QN9wLtBBeS4
    Mdin5+v4F3TULcgCFpElwwGcz295oD7Jt84pUm2fv1Q0VXWpkcxWMKeoUMKJOrGpsBnlYg
    VH1JNe2ZrfGWmhy604VNIuzlGgoRCOaAR4S1QlnDzq4NIOfCxrX4c4vSxzf65erobNOGzr
    l3kenexXZLVjoU1aPh7xRTK/ujMhmZ+zB93Sxk+k/Szt7VSZbItSzWBBgtKw
X-ME-Proxy: <xmx:mpoVaienVjFLUywTAQCyb6-HXO4aLJ9OvjSEvrVNwO40XO0rvOdcMQ>
    <xmx:mpoVakaIzpSw_MeF3UVIy8xeKHKQRkYnDw3yl4V_pD7ZWEbQhkya8g>
    <xmx:mpoVaq37Lz73L6SkIBhTo5dABLyd4h4uyHORVO1zi-J1ooffYoQTGA>
    <xmx:mpoVatq8-O-oVyV1LBNqqapT31hF360Kxo3oCbhMEGfq5t537VaFlw>
    <xmx:mpoVair-2HJNKGHlbg3qm1EPLZ9-Y-EvdkiD6rue3SPq9IziKqBcwtYl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:30 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 05/18] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Tue, 26 May 2026 14:04:53 +0100
Message-ID: <20260526130509.2748441-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 54179C0007
X-Stat-Signature: puz17nb1bxbw8yjd7mucabwu4sxa867j
X-Rspamd-Server: rspam06
X-HE-Tag: 1779800732-562990
X-HE-Meta: U2FsdGVkX19VL5pqUhC20MI7lXeuHbehh7f4lUeN3O6ZEnsrXNB4qEBkBvfzSGpocz8FH9R+iRr2QvlPZd6uhnfXHySBsnFcO1dFk3bRbMPkLEEDID6C4ltVHnG3KdhgjmEBGRe60aqMRdM/qPnz64fs05xEAN4V+uiJxgVkcLGzaNLNw+MvQmxwJoqukNI957aZKe+wO2ohtGmkIDCDg/QFx2BIjOJVFm3GDqxzpE8LpatkvF1eMVaXiZEsfrEXQBqT8/aebC50/dfzZ85UKQ/+DAuQ4osGdjTaclX1eZ1BzqA4P10FrwxwJULjCbzIBIa1C5eykzDzwvfNmQdyBm5Ke81rFAyWohCFn0PnbGiUXkZahBhvDKKszC44YY0v+dKdixQHuNeD+wBhwGPULPdhsSUy+GygYcK4F1d5yU1ujYicED/lPEg51EPw+3exvdPuCgkDrB68Sv49Mm0fdVuYThtUEe8fyCesNp776u4PZ7nDTOc4R5/Glm8krPcroBJ50l07UdPVuKEIqwU9uFe0XUsx+reAqgvou8t1/kw4e8N4na+rUBcoYfVryu3A0lpAekKEsWfDkSn801fapmQLQAdciMbfax/UHPNTc7aJ63M1cWdUVCinK10m/X1hd2CE97GwSuvDZ1PKP98ZamykDGRwcAr4Lpg90vHV3zH4n4OC5pZB8Lm92Fu9jcP6lYqhxXM2ntWYfxCZlkqGc7Ng5zyCvoitAJv0ze+Ct1TduHo2jELBpb+nnayVTQK+DXAteHwHq779/gFZgOY9q4fDWHn72jx3hwRq/a1+Qfi7ZC8KZULCo98XxUXKxwtA3ASOR97xbF92eiYXhYoYATJa+U3HasVZfR/3jse+kJ0zVXdrMRrk56vJKHoZzPtNyyFw3j3CMmOU5QW448X3vJYUVdX7VT26RnW0s0Pkv8HCRqPDWHsPFICR/k4fm+0fUdi75sia+vKufgxfqv2
 6dpzZlyu
 OKDhcD1VHeJK8V7nNUjmjo991hZHURgsrL3d08FLZ9CkAXI43WBg/oERI3/WASH5KqvSfTgIt1QF21LPs+v2rxeG3XvVj1VRYeK5JGxEzLs1e6/36oexQ3E23f+o3/sPapnYo2ygGOhcSB5rliSegZGQNnF4Gfz+NqC5OPWX1J4WVZmQzgAZTZ2Y2/gyCoshE8A1UNgMK/MXgPtxDpk8McxM0hZoFEGKhzK+bL9x/R2jaOYWR17bL2I18AOtDiXww269kK0T7Lf+b5gccEO7VxKviNvvMjwAnzmetFxLET8cbdbKDsluzTwVNmmgPgzKh9UUMkriwlKaoda1vMV2XJ9/32g7Pew+/OXu0alSqrA2XoPqkdE2aFo0Axzg+9g6tU9LzHDxbuJzH+zZ/RshC1rmMhlHx36ZVvQHYzyEj+cQsTktNgsWrNBgmDdJc/iIPA7AgKDMfe6rF/7WoxUY2qg/ZZ98BXnlVpkCiT10yNIvqAAOLWNmi/TMmoQD2Xs8uiVl0qkcuP4A+brKCdrkjRvZyMJOE/qhHS4zgviW8nrAeKg5ewaR7qNHXrNlK5Ub4/aWcXdDdFvY9L3oatalt4BbNQReO/GbBvkcrrRk+qqnYiYi5Xck1oOdSXz4ciriSFDavMxNhGBR2skokDBUGQHmJkeL7PV7ZikAQ7ymYcmwYcVT8KpR+NxyET178XGm/emkf
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
index fe60738e5943..319470b3b1bb 100644
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
index 4dfa42b7d053..873f4ea2e288 100644
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
index 606597da46b8..c085f5067b3b 100644
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
index 2a0b63ae421f..d295447a2763 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -619,7 +619,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline long pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PROTNONE);
@@ -629,7 +629,7 @@ static inline long pmd_protnone(pmd_t pmd)
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
index c5754942cf85..e2c5776d18cf 100644
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
index a1a7c6520a09..48a127323b21 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -524,10 +524,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
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
@@ -537,7 +534,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ecbcbb781e40..bc5bef08454b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -151,6 +151,7 @@ config S390
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e0..97241dea5573 100644
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
index f3f7cb01d69d..9da1119e8ff6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,7 @@ config X86
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
+	select ARCH_HAS_PTE_PROTNONE		if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_CFI		if X86_64
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2187e9cfcefa..c7f014cbf0a9 100644
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
index cdd68ed3ae1a..b6516a11adfa 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2052,18 +2052,26 @@ static inline int pud_trans_unstable(pud_t *pud)
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
@@ -2074,7 +2082,11 @@ static inline int pmd_protnone(pmd_t pmd)
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
index 2937c4d308ae..58abb7f19206 100644
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



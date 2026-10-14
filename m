Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE65ECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176546B00A2; Tue, 13 Oct 2026 23:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127056B00A3; Tue, 13 Oct 2026 23:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016596B00A4; Tue, 13 Oct 2026 23:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D732A6B00A2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:59:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65BB2A03F5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:32 +0000 (UTC)
X-FDA: 85319877384.15.8B2560A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id E42D6C0009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="FSV+A/lJ";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791950370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzz+6ZrUL/XqwIV03DwVqkSlHpqf/7QArXuFo8Cud/0=;
	b=Mk2LMWh5TbzFBWn329zQPZMp5cpckNhNIBxJ+ZzWYQcniHQmfyFjhwjQlD/rcmKbT4QAup
	Ar/e3fmql1EBiCHkPk87O2y+wk2jU9lL8NotudptCBlNGGBAp6B1npEi26Pyo+lge0ZtJx
	OhWstomNCZbJ4aF+wudm/iLOICvQCj0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="FSV+A/lJ";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791950370;
	b=drkAyvXLNkw3e0uSqFQ8Ms6jF3D/TD+Yw5UxGlhoJg9GO4DDiC8AHjpmf33QHms6SBqtaP
	G7YrBJQwVe3WOqv0m6yoRSL7kFqu9eSpzFbqroCauYo5pY2x1LgIP4LI5Y8CoCPidqFYEy
	jb2a4eqIUs4zhuTPdSIk4IhdVWUqOJA=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so2988321a91.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791950369; x=1792555169; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uzz+6ZrUL/XqwIV03DwVqkSlHpqf/7QArXuFo8Cud/0=;
        b=FSV+A/lJNgCnBM17NtlrTT2ic1Fu7EZkiExqiLALLwTQI53TMqWIW1hO2ye8+gjtm/
         6jJAIPzCIrBJpPD5G9Mk0sZonQIyX3bMiOtKWCtEag1vl2a7j/qhYQrxQjGoyKVWb9NM
         YiYWaiA4th5f8ZFQ0mEt3CNbhA5u17JyRr0k+PlxBvpcci2KLRURHAeylF5sdymbNlUj
         KjQn1rg0isopsBUavyzXbD7O8OevXcLLSZ9rSlPmrIHaajIl3JxQTGW1Vm/Pj31DjxIF
         zV6+eYNjdKfJLH3c1bfhPmBfttOyRXFk4pLnFkbjQCU+Ahozk9Jh+/Ednr6WwVmK51BD
         eUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791950369; x=1792555169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uzz+6ZrUL/XqwIV03DwVqkSlHpqf/7QArXuFo8Cud/0=;
        b=0JnOXRdv7HgpcKet1WuUrqEYfeolN6cT2jVuw8a0iKhGB7gJvjmCvmw0FQlKSEUBOx
         wrHd9RwsrI8bTHftGkip03i4Jf2fdS/IpUGh8v5IyGSz7LZXrLWDaTHTa6JzuTkUYXil
         5cZI7xo/OwR43R8P+jpQvsiUb0fgR2BXE3AXI8WUzZ43lQHvs+sBEeRDUkHbasvuBgNx
         oecjtyFVXvzZXLQjWzgHCsvfCyUGJecQTWOM0d+5oIaI5yfpd52wmYHvM6TBZwDJIoXv
         A6zDf/csGnWM0JFHKax95JELwWslMbCF2UGq17wsivdun6H5gS7mRXFz1TfUyIoKOvpJ
         3SfA==
X-Forwarded-Encrypted: i=1; AKwUvByVkjx+y54wIN6EHVphNyH8pN7KR0+wLhaJApPeDYfiMeDEDImH0vJfsb+bPTIFZO9HERqqsbJGNw==@kvack.org
X-Gm-Message-State: AFq9FYKeci2Oa/A9Nd0+7zmkEnspttj20bPtuNqvUqq+moMUaL6iZXHs
	1yW6pRAb4a4TjM8uMGEnWz0FPhHJos/wVx+kgmDmkIwf5kf8elqiRKxFkZ0KMKAHYdE=
X-Gm-Gg: AYBFou2L2KwMVDhVSKIInLQGU1DhBRZ9Bev+c6mdfY0nSUiNAwGtomtBUN4mPIDQpYl
	uz5i+3NhXUsmIVbA+2gllziVfWrGrSqCtme3FarXYu1uui0+S11snowgHYAEbxYJ2VWS1duysY9
	9Bi9vpJhSt+qAf0EtaPEv1kTuvWdjDTVWhI9xTHOpvKJ8SmdfyjTYiJgayxoi94Hu8zcmXBFnoT
	J1tFKRlIAebMDh7aTjyjMe+IkxmT5TzBURvHKTBXeG/DEzTM1gGHUEPM+A5N9Ao2zQ2DuiNmMcC
	1OMV422zb466ua/j6FPwAEjMQ8aX3zCCz8YfA5dxqcM/UQlTAVWW+3B+QIFKnWUloAyXjUIVWb+
	mr4QvDBFcLIozFlaAO7jNsZoYA8deYLlICHbxMI+58dsfEQlNrhmjPoCS2NIa2QPj9L82g4ys9U
	R5kH6U2wvIagrueRclwjU+qxati/I0eBl5hZ6e9oSOXcSPQfe7vL2gLiecoJWgp6ezUfg3x/dJD
	EFAT9mkls3pZCOazYSh
X-Received: by 2002:a17:90a:d44d:b0:3a4:b0f3:6597 with SMTP id 98e67ed59e1d1-3ab39fea5c6mr13397037a91.0.1791950368643;
        Tue, 13 Oct 2026 20:59:28 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f24a538sm2492305a91.9.2026.10.13.20.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:59:28 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: generalize PMD page table allocation
Date: Wed, 14 Oct 2026 11:59:09 +0800
Message-ID: <20261014035910.687847-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014035910.687847-1-songmuchun@bytedance.com>
References: <20261014035910.687847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E42D6C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: jg9fq6t16gygjdtt53fdwmcs78gsq8fp
X-HE-Tag: 1791950369-796416
X-HE-Meta: U2FsdGVkX18z7ER8lQaYQ3jOM9EbviLvF3YOpG2nr9/SV2udKtDCfq50uPcND/yfKPO/bLnERrvzmOYFXxGbdKnm92EbuFrfRJVHLlhPcfBE4GRYoJUFy8fpvmU963ERo0HyUx2wpoMuzv7GagWER8AKWmckwKEZqCWaX4D5jZwlB/9MNB1hIFvxo4cnPhMBTy8521LTdsrzuYPokM66nC6vMGe8ve5/LhHFQAz6bvnOzpWtWnYK6CyIebPoofmFiV9b0+sBCqX2c6zTlKiVxagth++1tNy7rBczd8FI2FRYv8zYwVEEXsOZjMGLwKwKlSjAjXFnk66iXIXgX7ZTqTAOylFQzhnaqCivISAvbmqsd71Yqig2RRFCijuwRvnZGxewxila742tj3RL65GKHF+Pv1W1ObJ/IAvvYFSUGvfOgaBrWzUuzUhs458SGUtTtBdJuddNF3vAfyg1qp4eSikQdVGeKpOya0GpnWIZKQgCXhRC+tRD1+un4/YhreRQbkXE+gpUSJlxHhRaWOfELtTRtyZBEiYTacnI9JaBv2MKf/588DTVY3UZ+nastfj1aZaj+1wyCWO2r5tVoqZPRVIz+e/KGHnXWbvgawuOIX0VmY8XR8T3vONvOeR+F3SI9yCtzfqkzgG1Ti07KTTt+i1imVAA6zNoAkkl5a4qaI6G7pxad6q4Y/D+SiJHUvpEp7RGlmQp7DpirJ8ip1JqsaGd+PUL1liXB1Y6TP7+6McMkz2YGDtkXfNHo5DwMv2bwpBkeFdug1RT6xX+SJZjasj75Eqjj8DibYLlBsyqzsOvoV49Jllk1FijC72XAoZM6neUYx85wHGFGylfW9BJWt+YjtpnRfhGVa4Nl7PG8GoIUEx4gfpZGFvcnDi2qnwhxuohh2/MZxyrzHRnB5Pm5xnK6SEutu8OEJdSlf4fYDL2wcF6geSst/72UgyxA3lVkggzAkwD/9hHBjqHAug
 QgC3v1Nu
 Yq8jqBlmBeLBjEZYSIiPBteGSg2VqC9jmuM8gAdUqmbMO7SPf9mEuwNdba4PgiPm/7dNt8eIHi9PLTcr+WWGK46Kjg01sNN8MFAxZomI/10iWfzHD6dAaVKtA0AVjN3y8QTkGHLzvpWuHiA1U4JYQjpj75rKHL+DWP4+SVyMhZKoIX2OAjkrPq7GNnw4TilvX38GM659RJ57PHtP+HMIcfe3ZPysaqtFxAAsKIyJpXKMZQHCpB9vcHB1DCxr3Tu5nfOxKUipDUWymDPWKqx+zg+KrHT52GfECydhtwaVCe/gcBGoAkXr31gAk4uGHFqt6oEWKzGOsdcM8+01DefqyVTJQwTe/URbG8dS7t15Sbb9xy5+dv0ktwme+EIovv8AxlzzwItulFiRIpaF2GsMMf0Blml1TJLK3V7UAdYYfzueQDR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic PMD allocator assumes order-0 page tables and zero-valued
empty entries. MIPS and LoongArch need pmd_init() to install their invalid
entries, while MIPS and parisc use PMD_TABLE_ORDER to describe the
allocation size.

Default PMD_TABLE_ORDER to zero, honor architecture overrides, and invoke
pmd_init() from the generic allocator. MIPS, LoongArch, and parisc can then
use the generic GFP selection, constructor handling, and kernel ptdesc
marking instead of duplicating most of the helper.

Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/loongarch/include/asm/pgalloc.h | 21 ---------------------
 arch/mips/include/asm/pgalloc.h      | 25 -------------------------
 arch/parisc/include/asm/pgalloc.h    | 17 -----------------
 include/asm-generic/pgalloc.h        | 12 ++++++++++--
 4 files changed, 10 insertions(+), 65 deletions(-)

diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index a3f93a8b58be..1fc9a0751f19 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
@@ -47,26 +46,6 @@ extern pgd_t *pgd_alloc(struct mm_struct *mm);
 #define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
-
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *pmd;
-	struct ptdesc *ptdesc;
-
-	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, 0);
-	if (!ptdesc)
-		return NULL;
-
-	if (!pagetable_pmd_ctor(mm, ptdesc)) {
-		pagetable_free(ptdesc);
-		return NULL;
-	}
-
-	pmd = ptdesc_address(ptdesc);
-	pmd_init(pmd);
-	return pmd;
-}
-
 #define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 9ec9cf01e92e..2f123455e363 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
@@ -29,11 +28,6 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
-/*
- * Initialize a new pmd table with invalid pointers.
- */
-extern void pmd_init(void *addr);
-
 #ifndef __PAGETABLE_PMD_FOLDED
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
@@ -52,25 +46,6 @@ extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *pmd;
-	struct ptdesc *ptdesc;
-
-	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, PMD_TABLE_ORDER);
-	if (!ptdesc)
-		return NULL;
-
-	if (!pagetable_pmd_ctor(mm, ptdesc)) {
-		pagetable_free(ptdesc);
-		return NULL;
-	}
-
-	pmd = ptdesc_address(ptdesc);
-	pmd_init(pmd);
-	return pmd;
-}
-
 #define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
diff --git a/arch/parisc/include/asm/pgalloc.h b/arch/parisc/include/asm/pgalloc.h
index 3b84ee93edaa..880a3e9ad0cb 100644
--- a/arch/parisc/include/asm/pgalloc.h
+++ b/arch/parisc/include/asm/pgalloc.h
@@ -10,7 +10,6 @@
 
 #include <asm/cache.h>
 
-#define __HAVE_ARCH_PMD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 /* Allocate the top level pgd (page directory) */
@@ -29,22 +28,6 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 			(__u32)(__pa((unsigned long)pmd) >> PxD_VALUE_SHIFT)));
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct ptdesc *ptdesc;
-	gfp_t gfp = GFP_PGTABLE_USER;
-
-	if (mm == &init_mm)
-		gfp = GFP_PGTABLE_KERNEL;
-	ptdesc = pagetable_alloc(gfp, PMD_TABLE_ORDER);
-	if (!ptdesc)
-		return NULL;
-	if (!pagetable_pmd_ctor(mm, ptdesc)) {
-		pagetable_free(ptdesc);
-		return NULL;
-	}
-	return ptdesc_address(ptdesc);
-}
 #endif
 
 static inline void
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index a1de7d246754..68e473908758 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -125,6 +125,10 @@ static inline void pte_free(struct mm_struct *mm, struct page *pte_page)
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
+#ifndef PMD_TABLE_ORDER
+#define PMD_TABLE_ORDER	0
+#endif
+
 #ifndef __HAVE_ARCH_PMD_ALLOC_ONE
 /**
  * pmd_alloc_one - allocate memory for a PMD-level page table
@@ -140,11 +144,12 @@ static inline void pte_free(struct mm_struct *mm, struct page *pte_page)
 static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
 {
 	struct ptdesc *ptdesc;
+	pmd_t *pmd;
 	gfp_t gfp = GFP_PGTABLE_USER;
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	ptdesc = pagetable_alloc_noprof(gfp, 0);
+	ptdesc = pagetable_alloc_noprof(gfp, PMD_TABLE_ORDER);
 	if (!ptdesc)
 		return NULL;
 	if (!pagetable_pmd_ctor(mm, ptdesc)) {
@@ -152,10 +157,13 @@ static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
 		return NULL;
 	}
 
+	pmd = ptdesc_address(ptdesc);
+	pmd_init(pmd);
+
 	if (mm == &init_mm)
 		ptdesc_set_kernel(ptdesc);
 
-	return ptdesc_address(ptdesc);
+	return pmd;
 }
 #define pmd_alloc_one(...)	alloc_hooks(pmd_alloc_one_noprof(__VA_ARGS__))
 #endif
-- 
2.54.0



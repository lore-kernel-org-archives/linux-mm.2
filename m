Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14B4CD98D6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA75B6B0098; Thu, 11 Jun 2026 09:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DA56B0099; Thu, 11 Jun 2026 09:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44156B009B; Thu, 11 Jun 2026 09:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A924B6B0098
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E4BCA04D8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:59 +0000 (UTC)
X-FDA: 84867644358.29.9783468
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8E7494000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hERLDBDb;
	spf=pass (imf04.hostedemail.com: domain of 3w7EqagcKCCoGHGXTGYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abarnas.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3w7EqagcKCCoGHGXTGYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182917;
	b=73w6uNk6WzoeHmWQDeCSrD8kHPqFLcY05+ApdvJfDIFh5BBoUT522JKBBIHDLBtw5gSWHJ
	zqXvyYTx4qMTvVsYuljJxiWU8GhCLUDljBybL8DRlJgCLtjWsV2wJPxutmZWEnLXYW7eUT
	I0PN+80aeoe/UtI3BGcPTxfV9JwmRFo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hERLDBDb;
	spf=pass (imf04.hostedemail.com: domain of 3w7EqagcKCCoGHGXTGYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abarnas.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3w7EqagcKCCoGHGXTGYMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5h5bvBN14eW3fvu0tVxTv7/VrbeBwl0cY8Ur130Yko=;
	b=0QJtsYA5eTUOYL2PGbv72uOttJ0eTLo5jJin8hyK3sTgTdD3QCBUfUZdeVte63B+MCX/U9
	HOh3BrtBJqZdHfVoxLs0DphB/94FjA9uWeyj1K96L8Ds/BfYVqfaHLfYGlfhRBt3aopQv+
	PzEerV5wMak7e0j7ZpvHVczKzBWbreY=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45ef6b407b4so3473511f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182916; x=1781787716; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g5h5bvBN14eW3fvu0tVxTv7/VrbeBwl0cY8Ur130Yko=;
        b=hERLDBDbXq4jmWfAwHiHJ7vovhQWoeAOv6bCX/NINpVD9IXQuIEDIfLmCvz78Euusd
         2IVDL4VNrXoDXeJbg3YxXNv+29QSLD4Bp9l98/ipEWuf1iHObsFuUrZNsairGjLTlg3O
         4kU+n2C2qehiu4IHihsNdPB7/hntdMiJx4y8a+KoywFdNs3dfy8szaW3sgv8RAmhUU/x
         xUutWlFTSv1Eh2Y2p3793Tj1I9MvC1XeEaPtHjuHt29K+nJenLIgtRuCoJbiZTteZEJn
         pBQmoYUmOK4eexC0i8hXW5zT3bhth9OrQg3HJaqgFdDbuLlQNwEoIIUN305JRXz/Ree9
         uimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182916; x=1781787716;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g5h5bvBN14eW3fvu0tVxTv7/VrbeBwl0cY8Ur130Yko=;
        b=hmeYAym4HTcwGvfUlcjVatcduXt0l9qtOjBFtaFzlNnEIcJnGmEJ5KgUTNaILQ//VO
         dRKCdfnVYpaTIcWdMv7E5ZH1yZHln4a9cPQI5IMj4FoPEgu1F20A8JAPR3F3s2TYzXnr
         rnzwtiSarHcouzeGsKhw8jVBBHh0/f+gSajW9BWm9NTMM2YpPX8AbX0umC97k3GftD3/
         tiKyxFsFRa5S2DySc5dEgsGeom3mLU6OhgS/8zSMg2X8PBMVHg5IFOb8Rt0kTvtIizPV
         oSBKAWDDJ10h6X2emFwTtOW09SbdQ9DwWRTdUuHjUdCJ/UxkbBT98cHplQzEfSwKpxGm
         pDTg==
X-Gm-Message-State: AOJu0YxoqqQkRgv64MGRFDfLKy8blIPSutHAsSh94ogJvsZB+2CqcUDo
	wQWcQUGTlXtRBJpUdazDWHQVqIGbrSs9VHLKRKrwjDsY7ytHtQUp8+G/jGzmGCNF3yHKAsjWxUP
	/7kPipsnr8g==
X-Received: from wmbjw14.prod.google.com ([2002:a05:600c:574e:b0:490:e190:39cb])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c0cb:b0:490:b9c3:6c69
 with SMTP id 5b1f17b1804b1-490e561edd9mr24134875e9.30.1781182915837; Thu, 11
 Jun 2026 06:01:55 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:44 +0000
In-Reply-To: <20260611130144.1385343-1-abarnas@google.com>
Mime-Version: 1.0
References: <20260611130144.1385343-1-abarnas@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-7-abarnas@google.com>
Subject: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the linear map
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E7494000D
X-Rspam-User: 
X-Stat-Signature: j1qz3zjrkybrfjp4t7ian9iq6xacfp95
X-HE-Tag: 1781182917-972617
X-HE-Meta: U2FsdGVkX18kvnUDhS6u0utrxwx7KtXyjEF55OniT1U9pvv94X98gQVDa6kNixAjMNxRMCfOWRFIDxOnY1+rq2TjhMqg6fPdavWKedylz5D9rTQmS/v6OXpmn2MLdKygyR8cWlc24JnB3qXIxx7VUlXj9hjpyAoW7BWiynyDol+PH9Gi0So0rhshficOQDlyIuPUSaOofLvZ7ulSD+jkdjF+D73f5yCybHOt4vWvjPP4PftLI0ncCxhjvwmrTDZ3sS/HawR08upXI6pDGMoDhxBNm/nB3GnthoyIumPtY8hdaEHrm+9/Be2EBOuh+4bI5n+7zNoNuWs0KB9imLr4PeVTsROF3gdCwkB28MpBaJHqIHT2yitBCRksyBiiKquodDzSs7Nyh11PH23DD1QVxcyp5cptwAvEuBj5tRV9SeTf2zXhcQ0SJMW9Yv+J0+IrBd2Y+JepNP4TsTL+2+2R8YVfQzeNhY47uA1b/pEr+1hTN80I+4LVdo/TSk7WHDrRfOl5Fdru7jFd+53GwmCClAMFrp0n1qZyVIKLwRm6E2GoasqEs7b2qkAnEhHK7CrHSN5+XgEr7uV5I0kUaAh9mBDIGyr7Go1bAa62BXhWi7G6teeAkwSImT+AqNZqG+3GajJdlbLe2eFPqNl+5i4AM/tczLFOdNr2XaOsUkn4J9iEjl/QDq0c9HNMKo+0wgeeYF30/43a/pne4QC5XCTGtyL4asI8/Z51ch6oE4sB8ObSeBW1h979QNVBgKreFRMH0hddkyyNqK8V4uXaR4TjH/FLt8HpvwhHqAg2u89UGaLWCc/XNq4daLIz5VXr932p+EwhHI+9Qbd8ROkNOwmwGHw4v/wKt1oBySzB6CCDl5DUo71PEie61sEoXH7N/chDj+ZNEouvaVU6prlHPqGLrnc5VfMdYVIwstYbWkPKFJ7nGb9bCbHyopxmf5r7rpHNj1lISTLqohTIEKLD8GA
 w4LpsRFC
 l0vgRe+BfddTr5SO+EfIyD2oxUPGvHKLT2rSbMrtTyYJZwM+E6Z8ZIiuEbTmYE5kMr4CbUt4d60sbuKrJyKm8wIydY+DpzDhD/30eJUYSiifXcEp+7VUEgQJhvYMx7juU/tg6MdNguL6022U/DG9LutYGeccywibnzfPYXP+jdpdizJdeHOIAkJ0v901Sgzwqt1zzciLvNhOCfrvC3oKgaJ81mefl+0C5p8QXeCoF+yUGdqmcPyFo5zFecgpeAhsSL3pHRlCM+7NGaVBKbHzHw0LiPiGcq8LAf8upcSgm84sTy3Xo8eDyU9x+HnHBtrPehY2bet3ZybFyEP0QE3F161z9rYijsd/gifIrm5Uj7PgPIahfNfHi2mXM4FR7MGax4le5CsqWpYeGFJNpXB+hdbtB6cXSDlOfyoF9bYzvIWWZ3RKWg1dLj3Ej9yzwpY9w5gHRQg84A9GiLzCpoePCg0/oOh0PtQMLqUWAQDhEkOhR4VlIs8TCjQMHP5cNHThCjiw2CFKta8tfWj1Ukqun9U5k7WOWhiTQjlYJMujstAk8Ppbj5cxIg7JG9qcXHvakeQOOc+mZkzIoDTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement PMD block coalescing to merge fragmented linear mapping regions
back into huge pages when restoring the read-only attribute.

When memory allocated with VM_ALLOW_HUGE_VMAP (such as for the execmem
ROX cache) has its permissions modified, the PMD block mapping is split
into individual PTEs. Without this change, when that memory have its RO
attribute subsequently cleared and set the mapping remains permanently
fragmented into 4K pages.

Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
---
 arch/arm64/include/asm/mmu.h |  1 +
 arch/arm64/mm/mmu.c          | 95 ++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/pageattr.c     |  7 +++
 3 files changed, 103 insertions(+)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 137a173df1ff..19158bacb2df 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -80,6 +80,7 @@ extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *s=
ize, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
 extern int split_kernel_leaf_mapping(unsigned long start, unsigned long en=
d);
 extern void linear_map_maybe_split_to_ptes(void);
+void try_collapse_kernel_pmd(unsigned long addr);
=20
 /*
  * This check is triggered during the early boot before the cpufeature
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a6a00accf4f9..d74226fa1c9b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -769,6 +769,101 @@ static inline bool force_pte_mapping(void)
=20
 static DEFINE_MUTEX(pgtable_split_lock);
=20
+static inline bool __pte_can_be_collapsed(pte_t pte, unsigned long pfn, pg=
prot_t prot)
+{
+	if (!pte_valid(pte))
+		return false;
+	if (pte_pfn(pte) !=3D pfn)
+		return false;
+	if ((pgprot_val(pte_pgprot(pte)) & ~PTE_CONT) !=3D pgprot_val(prot))
+		return false;
+
+	return true;
+}
+
+static void __try_collapse_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr)
+{
+	pte_t *ptep;
+	pte_t first_pte;
+	unsigned long pfn;
+	pgprot_t prot;
+	int i;
+
+	ptep =3D (pte_t *)pmd_page_vaddr(pmd);
+	first_pte =3D __ptep_get(ptep);
+
+	if (!pte_valid(first_pte))
+		return;
+
+	prot =3D pte_pgprot(first_pte);
+	prot =3D __pgprot(pgprot_val(prot) & ~PTE_CONT);
+	pfn =3D pte_pfn(first_pte);
+
+	if (!IS_ALIGNED(pfn, PMD_SIZE >> PAGE_SHIFT))
+		return;
+
+	for (i =3D 1; i < PTRS_PER_PTE; i++) {
+		if (!__pte_can_be_collapsed(__ptep_get(ptep + i), pfn + i, prot))
+			return;
+	}
+
+	set_pmd(pmdp, pmd_mkhuge(pfn_pmd(pfn, prot)));
+
+	__flush_tlb_kernel_pgtable(addr);
+
+	if (static_branch_unlikely(&arm64_ptdump_lock_key)) {
+		mmap_read_lock(&init_mm);
+		mmap_read_unlock(&init_mm);
+	}
+
+	pte_free_kernel(NULL, ptep);
+}
+
+void try_collapse_kernel_pmd(unsigned long addr)
+{
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pmd_t pmd;
+
+	/*
+	 * collapse_pmd expects exact address of block to be collapsed
+	 */
+	if (WARN_ON(ALIGN_DOWN(addr, PMD_SIZE) !=3D addr))
+		return;
+
+	mutex_lock(&pgtable_split_lock);
+
+	pgdp =3D pgd_offset_k(addr);
+	if (pgd_none(READ_ONCE(*pgdp)))
+		goto out;
+
+	p4dp =3D p4d_offset(pgdp, addr);
+	if (p4d_none(READ_ONCE(*p4dp)))
+		goto out;
+
+	pudp =3D pud_offset(p4dp, addr);
+	if (pud_none(READ_ONCE(*pudp)))
+		goto out;
+
+	if (pud_leaf(READ_ONCE(*pudp)))
+		goto out;
+
+	pmdp =3D pmd_offset(pudp, addr);
+	pmd =3D pmdp_get(pmdp);
+
+	if (!pmd_table(pmd))
+		goto out;
+
+	lazy_mmu_mode_enable();
+	__try_collapse_pmd(pmdp, pmd, addr);
+	lazy_mmu_mode_disable();
+
+out:
+	mutex_unlock(&pgtable_split_lock);
+}
+
 int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
 {
 	int ret;
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index eaefdf90b0d5..11e0b60264c3 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -200,6 +200,13 @@ static int change_memory_common(unsigned long addr, in=
t numpages,
 			if (ret)
 				return ret;
 		}
+		/*
+		 * When setting a read-only flag on the linear region, the memory
+		 * may have been backed by a PMD before being split. Try to
+		 * collapse it back into a PMD to restore huge page performance.
+		 */
+		if (pgprot_val(set_mask) =3D=3D PTE_RDONLY && area->flags & VM_ALLOW_HUG=
E_VMAP)
+			try_collapse_kernel_pmd((u64)page_address(area->pages[0]));
 	}
=20
 	/*
--=20
2.54.0.1136.gdb2ca164c4-goog



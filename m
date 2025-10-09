Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EB2CCD189
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A69A8E0039; Wed,  8 Oct 2025 21:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE7C8E0002; Wed,  8 Oct 2025 21:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0678E0039; Wed,  8 Oct 2025 21:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 373D48E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8C3B16091B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:52 +0000 (UTC)
X-FDA: 83976917304.28.3996170
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id E73EA1C0006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=QpiXq7CO;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf18.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ec90szP6RRRVh+VBwVOMiqXzA3Ep/76H50/prlBRjCs=;
	b=MUH104R+TW5Z9sknZIbf/NFTj9JSHRezCzDJd9YdJSFHOeAOLjs7VxtSOnl5tR3gOpGXbw
	5ALJPBhiUz3+CB/ylHR73XAhFfYnChch0xd+Lm8foqfW2CKFbMQE5O6tH2z36t9dlhlMOM
	h4BhV2mSRRSMKuBeM356Re9MJtihJnU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975131; a=rsa-sha256;
	cv=none;
	b=b1G035UjLHqxTQShNcNZ8v2Phhs5QR18D0CZWQvrfg6EN/1MYQfgHil0FntZPaslILrf29
	3vi/jWo8ddgddJFWqClm2rspEmqlB2jM3vXpkUKkNVXjTvLzYn2Q3DqF0wI39F3pApEaKw
	X1GDDmGk/HGrPgX24gIrfe7A3h7HWE4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=QpiXq7CO;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf18.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-28832ad6f64so4949625ad.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975130; x=1760579930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ec90szP6RRRVh+VBwVOMiqXzA3Ep/76H50/prlBRjCs=;
        b=QpiXq7CO36Ix+7PFN7UufEpB5COGctQfqIwrcRMfsPoI9MxmTd/aqodCzlv9LlpBSp
         35D1PGTIwcVyU5RbGePK2vs67GoM/EGhj8ZcI7WMuZZqkYUSCFi9r2D9nk016J5HpFeK
         OovKpvfA52hy2qNSQRC73AXUP0t97nAwsrHgWMMTRaiHM4IFoLhBlwbVBBDvBECw912I
         n+/xl7mcvZUEsWrFV7os8fMHYIM+iLRPsPxTg0zTfzfAVcJHvdUMnahuEqaFcK9HRFwI
         Y+0iHrVRVRdcYjjfM35r4WqA5bKHc2tBeyVN0bkULwFxKGm/wm5zRhr3xzmhUdXVBrAU
         sSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975130; x=1760579930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ec90szP6RRRVh+VBwVOMiqXzA3Ep/76H50/prlBRjCs=;
        b=fVLnzFgSJRMeQ2TCvoPEkcMZONe1j0mNFe4mK4Cqwl4E9j/6HwLdBWPW0XSOJqd6Cu
         dH8XeEVCCCGy4fJ1Jdh1zt0LEgUTTwH7OBCvEKdo+ilvkw8Ry+5/7roQSCYEn7Bojg8X
         /Y4gvhIIRHpEvu4RurM74cswSWw0Bx72zcn2uMf+/w6ejB8CrifSn2mcc4FXSQ0tM9G2
         DFwGXEM4YYXJ4oBhAb6rqWmXfGvTLsKDDbJmj2PPbPqn6Q0URXJyXhcJ8x1wKe+advHh
         x8RRXYVq6zi1yZA+t3I95siCS7+gob+qJiz2+KnJXlEfaqMmdVv+oxF8kdi1ixp4e54k
         Ms/A==
X-Forwarded-Encrypted: i=1; AJvYcCUSzhXpDdGrUUjM/NhHriR/Tn4MdqHnwcv5PbE75x3IeW8rYzxjo/G7gOCyI8JlmvgptE4H4uv48A==@kvack.org
X-Gm-Message-State: AOJu0YwXkwUMs8p8iZ2HEGgLcJbOtNWMSsPhwawlLUA8Rqnifn5044rm
	AjgsM4QqjeSeLebnNzH/vbWFQRsch3Yr6d7nLXxPTYB5/lIiYDfkSKL585kagAH2sVM=
X-Gm-Gg: ASbGnct2qjNHBNnHIrsr5Ulq3VaBPl05MPLiSCKAWRjE183U9Ziu1TH8FSUUrMSF12R
	w0Wl3df9ysnFWc2FZLzxjO+aaC4r2j54rjboDAHM3/uLGC/iet8qseyJfc7KaTjy3JpAG12N4Gh
	xkgB5vPA/4RMpPXaoa10Sx+4QcxlAD0iwWrHGdiPHAiKZevyqVWFWrHkB9sQmNq5dNvPPMgJJkp
	Ub8v5LcuEY+ZganIp+jUkJ9HScGG1yb7kMq7DM/ndxxIbh1hraubzSHla9sD0ZMzliCcRQF7lIU
	s8wpfiJQU2w3E3asdOcUQDeNeo4wdk35GeeIhI6cFpBCGXbTySkm7KErZ3/6CiMAQ5gi4sOrpe0
	q8pkJV5U1fnvgUAuY8F3R8vickrjpiSxFNySEawbAzZmnntYMUqj0e7Gs96mPN2EuT0Tl
X-Google-Smtp-Source: AGHT+IGpkTz+5DqTXkYh21z2iDwfeA2aj1AmfA+AuBtWgtsAEZk0JO74N45z8X0OyPDJv6obEnt7aQ==
X-Received: by 2002:a17:903:8cd:b0:269:8d85:2249 with SMTP id d9443c01a7336-29027240d03mr62723845ad.22.1759975129634;
        Wed, 08 Oct 2025 18:58:49 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:49 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 07/18] riscv: mm: Always use page table accessor functions
Date: Wed,  8 Oct 2025 18:57:43 -0700
Message-ID: <20251009015839.3460231-8-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E73EA1C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: edk4su3m1weddtqtjain1n871xxucy73
X-HE-Tag: 1759975130-439189
X-HE-Meta: U2FsdGVkX1+kjfqntXplNbVK0e74jOiIyxBgK95jcbWOffVAgEWN7JKjrb3aRtc5/zm2N6o7P7xB4laeL0M6kKen3hZxqsIKOoi0BJ+9xyLA1nGJApRg3bDxvC/WnpmdoD7FEVGw0toeyfcgqr8qvn8/r7oraz56D7o5SYSnswhHh4rxW5cZgzexsubQ9uucA8ZC985MzjqNcDs/cgtw8T9GduvEzfYv92cx3YmhaBGljd3mIBuwgOPklIh1qIfDAL8zoW4JEhAqc5KGk+4V8pVMPYDYlNSTugAp/ZGjhGL+KdmEch9Hst2u+az7HYiUq8oDVUtvzfwkpto33w6UjYxkyIGFL0NGcroW1hjJjAs9Dd+GyH8yQUwZaJIt1M05UAjmKaaVgyAAPNDP3c9txb5+Y+Ku6nv5iloHhBKwDKUKd5WdZg9mBN3JrtqQvWUiEpOPWN3B+qN/IcdwzOJ61jbpkRKA+Ccp+CwQBrl/ISVLmmkjSO27cx35guiuxOJ1PXsq7xER9E6Oy1L9vnx+RbofcgEHqkEI3PefvGFgrGwqsRst7MP0Ug9Xbb3Q3FNt47jiFnwxVNX6U9TDnNLP4rkCG++mUWJdDlAcEU9YF+EkXdh+EHCwhw36ZLZ568xacRasf1dDM74WNl40PQgC7HUqnKn7gpFIjODe0m/gDwWqc44SCAU0ShidIc9aAguFhVUi3v19I0hAdtCMtyfDfPBdsOjpIdqW4qjmB/IbyKslE5rBQ63mEgW5LouAbnCeQkFBTEVOqzYzCnodB9Oh4ScrZ1z0jDpVwynsNldUjPRjBSZniuoJVAzhaHpCg4iG8ahIP86kTkXV1Cp/3P6cTD4TaijJQW4943r/D8zkOYcfqW5YmHZblofrUpmdLWaALenf0OpKKNeBLOTVIUpk5sQYRCx9MR4s7hJcXF7FZ7Qox7k72Y0HhDLpoAo2jPpxqG/wgeYUruALLnw7CZk
 SWf90UZv
 H/ob3QwhwwveFXdPSEviXh1nE76OCDFQS9pUWzy2RwiEg4/My/Oode9VtbxDgKKczTAW827bvl1O6tcjnx6ePwhZ6+0MQlG4tf/3T25mzux+jNtMbrscOKf9Y4f0TP8dbkOt/2a9ReDuITMkWng5YnxdIxAsQetpRJSWE70Ls/12uqR00PHX2cq1VhEmhC3hjXYCFVGwyCHom/azUR8GMftulPi1F2xRu0PXkYcNsspP7F1pC5WwIHFjEdhkn+lvGyO1lp4VHEI7xvUw1EiottHi8n+Ja0e1GJb1lk3Hs8PRq0KGTho0vpSqD7FRweVXmwjrrSg7k5VgNDMCQCAl44a+SwrePHD/zmKBUHaaPY5ELCoiZF4zBEj8tl+YEe8cGMH+Tdl1zVmwDdDFm0k94ycblLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the semantically appropriate accessor function instead of a raw
pointer dereference. This will become important once these functions
start transforming the PTE value on some platforms.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 arch/riscv/include/asm/pgtable.h |  8 ++--
 arch/riscv/kvm/gstage.c          |  6 +--
 arch/riscv/mm/init.c             | 68 +++++++++++++++++---------------
 arch/riscv/mm/pgtable.c          |  9 +++--
 4 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 8150677429398..2bc89e36406da 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -949,7 +949,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 #ifdef CONFIG_SMP
 	pud_t pud = __pud(xchg(&pudp->pud, 0));
 #else
-	pud_t pud = *pudp;
+	pud_t pud = pudp_get(pudp);
 
 	pud_clear(pudp);
 #endif
@@ -1126,13 +1126,15 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
  */
 #define set_p4d_safe(p4dp, p4d) \
 ({ \
-	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	p4d_t old = p4dp_get(p4dp); \
+	WARN_ON_ONCE(p4d_present(old) && !p4d_same(old, p4d)); \
 	set_p4d(p4dp, p4d); \
 })
 
 #define set_pgd_safe(pgdp, pgd) \
 ({ \
-	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	pgd_t old = pgdp_get(pgdp); \
+	WARN_ON_ONCE(pgd_present(old) && !pgd_same(old, pgd)); \
 	set_pgd(pgdp, pgd); \
 })
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index 24c270d6d0e27..ea298097fa403 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -154,7 +154,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
 	}
 
-	if (pte_val(*ptep) != pte_val(map->pte)) {
+	if (pte_val(ptep_get(ptep)) != pte_val(map->pte)) {
 		set_pte(ptep, map->pte);
 		if (gstage_pte_leaf(ptep))
 			gstage_tlb_flush(gstage, current_level, map->addr);
@@ -241,12 +241,12 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 		if (op == GSTAGE_OP_CLEAR)
 			put_page(virt_to_page(next_ptep));
 	} else {
-		old_pte = *ptep;
+		old_pte = ptep_get(ptep);
 		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		else if (op == GSTAGE_OP_WP)
 			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
-		if (pte_val(*ptep) != pte_val(old_pte))
+		if (pte_val(ptep_get(ptep)) != pte_val(old_pte))
 			gstage_tlb_flush(gstage, ptep_level, addr);
 	}
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 15683ae13fa5d..d951a354c216d 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -458,8 +458,8 @@ static void __meminit create_pte_mapping(pte_t *ptep, uintptr_t va, phys_addr_t
 
 	BUG_ON(sz != PAGE_SIZE);
 
-	if (pte_none(ptep[pte_idx]))
-		ptep[pte_idx] = pfn_pte(PFN_DOWN(pa), prot);
+	if (pte_none(ptep_get(ptep + pte_idx)))
+		set_pte(ptep + pte_idx, pfn_pte(PFN_DOWN(pa), prot));
 }
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -541,18 +541,19 @@ static void __meminit create_pmd_mapping(pmd_t *pmdp,
 	uintptr_t pmd_idx = pmd_index(va);
 
 	if (sz == PMD_SIZE) {
-		if (pmd_none(pmdp[pmd_idx]))
-			pmdp[pmd_idx] = pfn_pmd(PFN_DOWN(pa), prot);
+		if (pmd_none(pmdp_get(pmdp + pmd_idx)))
+			set_pmd(pmdp + pmd_idx, pfn_pmd(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (pmd_none(pmdp[pmd_idx])) {
+	if (pmd_none(pmdp_get(pmdp + pmd_idx))) {
 		pte_phys = pt_ops.alloc_pte(va);
-		pmdp[pmd_idx] = pfn_pmd(PFN_DOWN(pte_phys), PAGE_TABLE);
+		set_pmd(pmdp + pmd_idx,
+			pfn_pmd(PFN_DOWN(pte_phys), PAGE_TABLE));
 		ptep = pt_ops.get_pte_virt(pte_phys);
 		memset(ptep, 0, PAGE_SIZE);
 	} else {
-		pte_phys = PFN_PHYS(_pmd_pfn(pmdp[pmd_idx]));
+		pte_phys = PFN_PHYS(_pmd_pfn(pmdp_get(pmdp + pmd_idx)));
 		ptep = pt_ops.get_pte_virt(pte_phys);
 	}
 
@@ -643,18 +644,19 @@ static void __meminit create_pud_mapping(pud_t *pudp, uintptr_t va, phys_addr_t
 	uintptr_t pud_index = pud_index(va);
 
 	if (sz == PUD_SIZE) {
-		if (pud_val(pudp[pud_index]) == 0)
-			pudp[pud_index] = pfn_pud(PFN_DOWN(pa), prot);
+		if (pud_val(pudp_get(pudp + pud_index)) == 0)
+			set_pud(pudp + pud_index, pfn_pud(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (pud_val(pudp[pud_index]) == 0) {
+	if (pud_val(pudp_get(pudp + pud_index)) == 0) {
 		next_phys = pt_ops.alloc_pmd(va);
-		pudp[pud_index] = pfn_pud(PFN_DOWN(next_phys), PAGE_TABLE);
+		set_pud(pudp + pud_index,
+			pfn_pud(PFN_DOWN(next_phys), PAGE_TABLE));
 		nextp = pt_ops.get_pmd_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_pud_pfn(pudp[pud_index]));
+		next_phys = PFN_PHYS(_pud_pfn(pudp_get(pudp + pud_index)));
 		nextp = pt_ops.get_pmd_virt(next_phys);
 	}
 
@@ -669,18 +671,19 @@ static void __meminit create_p4d_mapping(p4d_t *p4dp, uintptr_t va, phys_addr_t
 	uintptr_t p4d_index = p4d_index(va);
 
 	if (sz == P4D_SIZE) {
-		if (p4d_val(p4dp[p4d_index]) == 0)
-			p4dp[p4d_index] = pfn_p4d(PFN_DOWN(pa), prot);
+		if (p4d_val(p4dp_get(p4dp + p4d_index)) == 0)
+			set_p4d(p4dp + p4d_index, pfn_p4d(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (p4d_val(p4dp[p4d_index]) == 0) {
+	if (p4d_val(p4dp_get(p4dp + p4d_index)) == 0) {
 		next_phys = pt_ops.alloc_pud(va);
-		p4dp[p4d_index] = pfn_p4d(PFN_DOWN(next_phys), PAGE_TABLE);
+		set_p4d(p4dp + p4d_index,
+			pfn_p4d(PFN_DOWN(next_phys), PAGE_TABLE));
 		nextp = pt_ops.get_pud_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_p4d_pfn(p4dp[p4d_index]));
+		next_phys = PFN_PHYS(_p4d_pfn(p4dp_get(p4dp + p4d_index)));
 		nextp = pt_ops.get_pud_virt(next_phys);
 	}
 
@@ -726,18 +729,19 @@ void __meminit create_pgd_mapping(pgd_t *pgdp, uintptr_t va, phys_addr_t pa, phy
 	uintptr_t pgd_idx = pgd_index(va);
 
 	if (sz == PGDIR_SIZE) {
-		if (pgd_val(pgdp[pgd_idx]) == 0)
-			pgdp[pgd_idx] = pfn_pgd(PFN_DOWN(pa), prot);
+		if (pgd_val(pgdp_get(pgdp + pgd_idx)) == 0)
+			set_pgd(pgdp + pgd_idx, pfn_pgd(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (pgd_val(pgdp[pgd_idx]) == 0) {
+	if (pgd_val(pgdp_get(pgdp + pgd_idx)) == 0) {
 		next_phys = alloc_pgd_next(va);
-		pgdp[pgd_idx] = pfn_pgd(PFN_DOWN(next_phys), PAGE_TABLE);
+		set_pgd(pgdp + pgd_idx,
+			pfn_pgd(PFN_DOWN(next_phys), PAGE_TABLE));
 		nextp = get_pgd_next_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_pgd_pfn(pgdp[pgd_idx]));
+		next_phys = PFN_PHYS(_pgd_pfn(pgdp_get(pgdp + pgd_idx)));
 		nextp = get_pgd_next_virt(next_phys);
 	}
 
@@ -1568,14 +1572,14 @@ struct execmem_info __init *execmem_arch_setup(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 {
-	struct page *page = pmd_page(*pmd);
+	struct page *page = pmd_page(pmdp_get(pmd));
 	struct ptdesc *ptdesc = page_ptdesc(page);
 	pte_t *pte;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PTE; i++) {
 		pte = pte_start + i;
-		if (!pte_none(*pte))
+		if (!pte_none(ptep_get(pte)))
 			return;
 	}
 
@@ -1589,14 +1593,14 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 
 static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
 {
-	struct page *page = pud_page(*pud);
+	struct page *page = pud_page(pudp_get(pud));
 	struct ptdesc *ptdesc = page_ptdesc(page);
 	pmd_t *pmd;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		pmd = pmd_start + i;
-		if (!pmd_none(*pmd))
+		if (!pmd_none(pmdp_get(pmd)))
 			return;
 	}
 
@@ -1611,13 +1615,13 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemm
 
 static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 {
-	struct page *page = p4d_page(*p4d);
+	struct page *page = p4d_page(p4dp_get(p4d));
 	pud_t *pud;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		pud = pud_start + i;
-		if (!pud_none(*pud))
+		if (!pud_none(pudp_get(pud)))
 			return;
 	}
 
@@ -1662,7 +1666,7 @@ static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, un
 
 		ptep = pte_base + pte_index(addr);
 		pte = ptep_get(ptep);
-		if (!pte_present(*ptep))
+		if (!pte_present(ptep_get(ptep)))
 			continue;
 
 		pte_clear(&init_mm, addr, ptep);
@@ -1692,7 +1696,7 @@ static void __meminit remove_pmd_mapping(pmd_t *pmd_base, unsigned long addr, un
 			continue;
 		}
 
-		pte_base = (pte_t *)pmd_page_vaddr(*pmdp);
+		pte_base = (pte_t *)pmd_page_vaddr(pmdp_get(pmdp));
 		remove_pte_mapping(pte_base, addr, next, is_vmemmap, altmap);
 		free_pte_table(pte_base, pmdp);
 	}
@@ -1771,10 +1775,10 @@ static void __meminit remove_pgd_mapping(unsigned long va, unsigned long end, bo
 		next = pgd_addr_end(addr, end);
 		pgd = pgd_offset_k(addr);
 
-		if (!pgd_present(*pgd))
+		if (!pgd_present(pgdp_get(pgd)))
 			continue;
 
-		if (pgd_leaf(*pgd))
+		if (pgd_leaf(pgdp_get(pgd)))
 			continue;
 
 		p4d_base = p4d_offset(pgd, 0);
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 8b6c0a112a8db..c4b85a828797e 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -95,8 +95,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	flush_tlb_kernel_range(addr, addr + PUD_SIZE);
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
-		if (!pmd_none(pmd[i])) {
-			pte_t *pte = (pte_t *)pmd_page_vaddr(pmd[i]);
+		if (!pmd_none(pmdp_get(pmd + i))) {
+			pte_t *pte = (pte_t *)pmd_page_vaddr(pmdp_get(pmd + i));
 
 			pte_free_kernel(NULL, pte);
 		}
@@ -158,8 +158,9 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		      pud_t *pudp)
 {
-	VM_WARN_ON_ONCE(!pud_present(*pudp));
-	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
+	VM_WARN_ON_ONCE(!pud_present(pudp_get(pudp)));
+	pud_t old = pudp_establish(vma, address, pudp,
+				   pud_mkinvalid(pudp_get(pudp)));
 
 	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
 	return old;
-- 
2.47.2



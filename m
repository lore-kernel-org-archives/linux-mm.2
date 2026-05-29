Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74009CD6E54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEA66B00C2; Fri, 29 May 2026 11:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1E76B00C1; Fri, 29 May 2026 11:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8536B00C2; Fri, 29 May 2026 11:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49CD26B00BE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04E848C124
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:26 +0000 (UTC)
X-FDA: 84820773534.18.DD41B34
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8A3B140034
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CgrBDeml;
	spf=pass (imf09.hostedemail.com: domain of 3f6oZaggKCJIwDzx+24F2AA270.yA8749GJ-886Hwy6.AD2@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3f6oZaggKCJIwDzx+24F2AA270.yA8749GJ-886Hwy6.AD2@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwwWx+36ZO5AyFG8PbXK1ZtkzsCWR7UH7LxbrRw2oLU=;
	b=DAzxtJgJyDMK4uFTcfhc3Wuel8TO2SaWTFt9ppgtRN1FLPtk5V3IUdiTCQKKZiQuvZ4suW
	tH4rYVKoGBDIxL+qyBnqYKvLxFkkdwwUWSeOrSaT5Swzsb0sY7EzuJ6oujnAt013SFvTy0
	ei1X/Kn4mqV5NSZY2VHsqLlZleG3swY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CgrBDeml;
	spf=pass (imf09.hostedemail.com: domain of 3f6oZaggKCJIwDzx+24F2AA270.yA8749GJ-886Hwy6.AD2@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3f6oZaggKCJIwDzx+24F2AA270.yA8749GJ-886Hwy6.AD2@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066945; a=rsa-sha256;
	cv=none;
	b=NHpcDDrXSeIlD6DVdxLO43/B2uu7Jp5mfn0LG+Ryi3D8tCB9HXdTeUZrjLS2h39DdaGDXf
	oGU2VMbNS3g8+VGlNeJCpWmcjXDLvV+4G7DUedvOoweiSq3jFOIEIj3Ng4Qe6aQbGQctCE
	2dwM3txZ3r6od4e0aeXGI011Z4C/cVM=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49051422d55so69832905e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066943; x=1780671743; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KwwWx+36ZO5AyFG8PbXK1ZtkzsCWR7UH7LxbrRw2oLU=;
        b=CgrBDemlVLIKIjXjAkhfQ/LlZ0Mnluq6aVZSC6d3lmG09k4Nt4Yg/mzv3uIO2kJcTS
         t1edNjnMNIYyebcGntge3c35vzmuqG0TDCbPc9jRUxNFxM7VyBCEMkvD5ymebNDuylII
         pnTaRvINlOP0CgYTMXZwfyNskz6epRZHg2N0i2OO9roTekEtvLBFooxd+1Hrrt+KsuOG
         fqSaEkpUegeYkM9d4uPSJWcBSQumC99B3B0hI6PABJi6oUxhysIW3J7uvQFbt5sG7gND
         xB1zKnNw8P1Lv5uAA/5iNUtrbGSvmmCZPLTsqr+pkERRag9y0QqpL2eJkBemql+8jNdf
         /o+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066943; x=1780671743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwwWx+36ZO5AyFG8PbXK1ZtkzsCWR7UH7LxbrRw2oLU=;
        b=BShjnmZd32YpMgEiKpoB+LU/53CuhpklWckwZ44guK42yMCyNnMg9R5LQkCnYBt2+g
         vxL/G0UkxPhz56zVuHYpEV9bcLv1jIQRUGgDdt6gwIiJQQIUmzqEB8q8KUA3Xfz2ILJU
         ECh5XDlsLHA9aMcLcrxCWislrWuJRviYBIkrP8S19M6Tr4OtYq7JRoazDi6QJIKcuFgQ
         YpipABk2LN+oXLyaVf11UXUtZuy8d2PrfI0tO6emph09mz6cI+LKPvbFYIs++qAtwR7h
         2iZ977eopD1ektGwbZ6+lFNFdJEOHtyMbPtx9uuWgGLuaBhMDYpFPtmDk9pyDhfzOrT6
         8uAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+XZClWM5m6EIwAos0xrXhAPR66/00WJRERiUut1NXBAvMnIeZPwqbE3Nf6+eAwkFVvVhjmX1+xiA==@kvack.org
X-Gm-Message-State: AOJu0YzZJMqht8FVd1GyVBKI/5EueZA+XPvME8qoUWkAWPq29LDDLPPv
	fQGexrpR6KMkBkdY0a6H60gr0RFkywsryVQImFhjsLfDGEESGLr7Ugfm80WbetBhg9DMp3qlFg=
	=
X-Received: from wmbiv7.prod.google.com ([2002:a05:600c:5487:b0:48f:de29:3f52])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:2313:b0:490:6237:5213
 with SMTP id 5b1f17b1804b1-4909c0af69cmr42420765e9.23.1780066943345; Fri, 29
 May 2026 08:02:23 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:56 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3700; i=ardb@kernel.org;
 h=from:subject; bh=JEV2e9VnURwytUBvbY/jPf+EEXewGZ41iq/e9jE9rQo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVap1rG3Fm6CS7u4UZS4lT7Z9HxxXNudcEuL6naq74
 afp7KCOUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJGPCgx/uKQ8e8xyJPt5JLP2
 bi5SltRnOvLycG3KFEeBXT7tu08rMTKsXffM79eljW7bhWbvntV0WFru9cWYiprdF6/MlLIvbk5 kAAA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-22-ardb+git@google.com>
Subject: [PATCH v7 05/15] arm64: mm: Preserve non-contiguous descriptors when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 5am64xpb9xzkh1xh7ki8hmb65z1eu4og
X-Rspam-User: 
X-Rspamd-Queue-Id: D8A3B140034
X-HE-Tag: 1780066944-318827
X-HE-Meta: U2FsdGVkX1/pWmLOLZ2Of646lkdp25MGPCr8HeU++wt22AvcW5ChBdvy7mOk8BPLC1doEinwOpb1kupYDw3SiTa+IzcFCe7Ve7qxv897wsf0JO6YVF+XByGCmKNkS/yMErM/8gVxP7z0G2zGM3se66lcdVhT2JImVGVZiYUmvzY/woFoz8LV7IuvB+LYB5LNID1M6k5Dheg0M0IgwyjyUCEHtQ1CCBkNu3Fdy9noOh9P1vp5D1VLX/x2l07DoBjeoN8lhSXJxSC7NrtVgHo8XJbfinM8tmSA9qxQtfN4YcmCj0dB6Xi9zf2SRVdliKS59j0sABz1YW+xqPUzXyIL1BABm9rp7xJ9VP/hkF43f/MfP/397ePrY7a/28XsijYjGwKJ1Kr8murKjwtT58/J/lqsTCWU+Lg5Mq6F0c/7HrSld3NlZGvPo04AG+BZ96mkQG4nQemk3vTc281MBotp6KsPxjgo0Ud3OzeB9R3DREtPGhNy46f6RnbRNNFpOJ3Cxt4YIcKbvQXwkqEKwyTCEkHj3R9eigZpNv7hcJCIGwm4Zc4FkwdRpopGMU9qNYC2uv2xS7ybKEuMPV4GB29crt7G3aJjH3LQHvxSDEi3XRsE+EUmRJZXGfuczvupncnLXJB+EhHWt1U7AErHZzFDxllzbC9ZSov7QMopTDNWnPMjQFLlxIfDJBrTXQBEPq/ucpnvVZ6hI908ZFlQX2vnGkddgX05AakCuDLdhzYQ/00iX9GOdioInD+Rj2g7bn8ljVYQd7NuawzDZ1stiQ4/qbt2DimeBaHJoQxMATfaiP5nL3pzGpf57Bv6vQ2nVZcV76AFrzguMu8D8XGB7qBiEM4Rw5BTcUF21Qm84tcGkErBCE+ooAWv2/TRmH+1NeuZ7QpfSTeoN52oV4A9nVF/DVekYtZqDzc0w2tjW1rK/eQt8AoheXJYEd0OPcqU3S011HgIhBGuLNAaPBmRq0N
 YY/DD0l4
 T/Jj36oIV35ReCtimXlR1Sgyjc2OmCpL90Tc8p/hv9M8N+KXQX/xPbJRm2I/nXJYL5MVm8HmBrNhSCdMQ8Olc3QVGUPSwJBQ6MQeJ5VaM4brIFKcC3vJCcbrzaGL9+RnObD4ZR/2xKOV8zHM3KhCG51lNMSGUJ+u+BzA4GzBpD3rhNMrrE8es4DIMumAJ6+JEjZYXeVdGGovsBgt9gZcPhPoDhx4DFzG64ln+1G/c2+ZCkwIH/TZGgjwz3Cx5sID8PKKr1FKJKgkr8wCKpKrjsW2pGenCEM+WljBnf/x88DTzhdI7RjW5P0nzPooDMfeLGgbyGAtTiuNakxxu5gn89gcrpKwViQKXVEFhbjNn4w4k4A1o9emQ0zK5BJC1Ul94/iqkWHnIKoEXMbnoDmSTbXeA/m7bQTrB21M1giUaVr9NmCETGaAwbVgIhOU9+4n+0MKGioLNb+4XcoaM44Vt9L2gMM7UHJwtBpzxN1BDrU2X048XCQKikslUzI1zUWR6pBPb4B50+aUf2SEz/YSUEBtYCNArmbEp+nEJ4bYlvbQ/9KPOmWOAlj9G/121l8RR83ghZ+aOcCoX/BM0AxR78aiLxXI1nhpbFCwML//hoGyF2q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of blindly overwriting existing live entries regardless of the
value of their contiguous bit when mapping DRAM regions at
contiguous-hint granularity, check whether the contiguous region in
question contains any valid descriptors that have the contiguous bit
cleared, and in that case, leave the contiguous bit unset on the entire
region. This permits the logic of mapping the kernel's linear alias to
be simplified in a subsequent patch.

Note that this can only result in a misprogrammed contiguous bit (as per
ARM ARM RNGLXZ) if the region in question already contains a mix of
valid contiguous and valid non-contiguous descriptors, in which case it
was already misprogrammed to begin with.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  4 ++++
 arch/arm64/mm/mmu.c              | 22 ++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..a1c5894332d9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -181,6 +181,10 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
  * Returns true if the pte is valid and has the contiguous bit set.
  */
 #define pte_valid_cont(pte)	(pte_valid(pte) && pte_cont(pte))
+/*
+ * Returns true if the pte is valid and has the contiguous bit cleared.
+ */
+#define pte_valid_noncont(pte)	(pte_valid(pte) && !pte_cont(pte))
 /*
  * Could the pte be present in the TLB? We must check mm_tlb_flush_pending
  * so that we don't erroneously return false for pages that have been
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5c827fa3cd38..6b42d724bd1b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -187,6 +187,14 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 }
 
+static bool pte_range_has_valid_noncont(pte_t *ptep)
+{
+	for (int i = 0; i < CONT_PTES; i++)
+		if (pte_valid_noncont(__ptep_get(&ptep[i])))
+			return true;
+	return false;
+}
+
 static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
@@ -224,7 +232,8 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 
 		/* use a contiguous mapping if the range is suitably aligned */
 		if ((((addr | next | phys) & ~CONT_PTE_MASK) == 0) &&
-		    (flags & NO_CONT_MAPPINGS) == 0)
+		    (flags & NO_CONT_MAPPINGS) == 0 &&
+		    !pte_range_has_valid_noncont(ptep))
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 		init_pte(ptep, addr, next, phys, __prot);
@@ -283,6 +292,14 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	return 0;
 }
 
+static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
+{
+	for (int i = 0; i < CONT_PMDS; i++)
+		if (pte_valid_noncont(pmd_pte(READ_ONCE(pmdp[i]))))
+			return true;
+	return false;
+}
+
 static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
@@ -324,7 +341,8 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 
 		/* use a contiguous mapping if the range is suitably aligned */
 		if ((((addr | next | phys) & ~CONT_PMD_MASK) == 0) &&
-		    (flags & NO_CONT_MAPPINGS) == 0)
+		    (flags & NO_CONT_MAPPINGS) == 0 &&
+		    !pmd_range_has_valid_noncont(pmdp))
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 		ret = init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
-- 
2.54.0.823.g6e5bcc1fc9-goog



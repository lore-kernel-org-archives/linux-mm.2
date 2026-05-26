Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D10DCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58646B0095; Tue, 26 May 2026 13:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA936B0096; Tue, 26 May 2026 13:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9BD6B0098; Tue, 26 May 2026 13:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 892506B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E720C1C83
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:30 +0000 (UTC)
X-FDA: 84810333300.17.8865185
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7607618000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a7D45uSs;
	spf=pass (imf06.hostedemail.com: domain of 3ft8VaggKCOsNeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3ft8VaggKCOsNeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVtRZrGktzRjCdUnH3kN7Vy8R0F1sW5LmttIAYz/k8A=;
	b=q7NJgPVauV+bbKx6hO8Hxh228J9+15xNUsuOkWheNEm9NbIwmwnhiLvYpR3RuPJsyPvfw6
	crFAqZcRiKiXmPCsdfyf/EMGjK8dFj1DeBpQKmcd9jAIdgQP0Qmg0nu4OnVa88Ci50TxLR
	o+IaODjcBh0qVC88VIUo3K6pRODYnys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818368; a=rsa-sha256;
	cv=none;
	b=SDnokEiBowKs1k6d293ZWXEYx0KyHV/TcJnE1UUhBGIMFZcf8ZvCXLNUXaUNxaXiuZLeqK
	Pbsb1bG30pBLR8wtOZZ/7LeEdtPFI7rxnqN7TASHYXPPtjlf3kTFLqTdU+cTn07DIR1OeT
	r6Vxb5M+kQ80X2R1sBrYAT2R68Cn784=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a7D45uSs;
	spf=pass (imf06.hostedemail.com: domain of 3ft8VaggKCOsNeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3ft8VaggKCOsNeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6884ab142c6so4019154a12.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818367; x=1780423167; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cVtRZrGktzRjCdUnH3kN7Vy8R0F1sW5LmttIAYz/k8A=;
        b=a7D45uSstq0o3WhZyN+MmRxjYVuQVysmjLzLnMTtQaVLQulg8Bpm8yDCABVSzjzCDb
         Ht4h4ucWtsy5+rax5+1ELyQmmKlbX+fMPi/lP2yPZWqLGYQO6lgTz9H2sr129t1iNiTA
         e+8UusakwxijWawHlU/slDraVolTxjo4pzuuj04WusIlo53jyDol6L1HpkWMwhJO6R/+
         yi1MT/w2svKS9JiOrrMHrecLJeXoAsKC4v18Cgr6TA9WcPLyTQlOK5ICzGI8uUfgPEsy
         7N1HlpdzXf2Ef7rhnjjj8nC6QEc3zj4sSnGHuLCsLrRpTexMASikHLfEeQO0ug6RkotD
         laTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818367; x=1780423167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVtRZrGktzRjCdUnH3kN7Vy8R0F1sW5LmttIAYz/k8A=;
        b=mkWspxMy8vwtisRHhk7DqV3f3Z9feQtsVirc0u6WfOeKfJfS2ZEAmtzp0fynAzW9T8
         gorlJmFsWTQ7e6tj7jI5ieNfwVKxXeAhGa5Wni6rCd7BoaLP+JMWXO19MIhOitUgaSeK
         5UAWnUr/iw/Y5335XXwQCj1xvVKwMlm+/ejtVB8UtWJW+YA2U8sRmlSiLKkg4H9LkZ8J
         czK0aOWV3cE0pg8iC3jWpOTiwcUawD9QBYukVmSv7gR89Yh3z40KiulH+AUjdzAkeGRD
         YEk3eJHGoRp5soCkJc2M2+oFTOhxVGmb/u9wjzeU5JKRrZGKJhJ9+9q8Lp1JURb2hKAU
         WHFQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mBswuEOXSuu3k9uKgae0zSN3pvqb/EPIYYIM+CQKGib/RA+QS9pTzMSfijS5EpoLCPHP4HhfjFQ==@kvack.org
X-Gm-Message-State: AOJu0YzmTxc+aiOieogT0KJbPG5PDgxP9v3unJ0g/+xE9uQnIumU0l5q
	azpd7NWQVgq1lGVqabpHvYhfcDAXplrMZrcOOi8azlZRhhcaRO8JkzVI/ha7sVoIWF10Y5NwIQ=
	=
X-Received: from edgg7.prod.google.com ([2002:a05:6402:1ec7:b0:687:a46:a91a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3891:b0:683:1cc8:84b0
 with SMTP id 4fb4d7f45d1cf-6889c41ece7mr9857461a12.1.1779818366685; Tue, 26
 May 2026 10:59:26 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:52 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3700; i=ardb@kernel.org;
 h=from:subject; bh=z6XqclO2VktRYngIWmFbVHfouJpd6sLXvnE8xwKtYlk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0flxH4ekTmyZ0HhJ9JL0wwCSxxnH9nteLX//dwO4dq
 58gueBoRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhI3R2G36zF1sq/DnmIFKhu
 n6+5tapE4TVTQeM123nvlwhbO97ZVc/wV4jD64xshEfNl9JbBTcNtzWsVTgTNfuZcwu3tFeOvPJ UZgA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-22-ardb+git@google.com>
Subject: [PATCH v6 05/15] arm64: mm: Preserve non-contiguous descriptors when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7607618000F
X-Stat-Signature: 69oncexjwqmbdxzw73a3ukf4438wi36k
X-Rspamd-Server: rspam06
X-HE-Tag: 1779818368-598259
X-HE-Meta: U2FsdGVkX1+jQ/HB32QSAPh+3SOkWkxPs4eD+3N8FsupKq6IN06ZYs9uSMESU0j4chOAvJeJkxTuW7EvxUXEvZru10NVxLtuAYWrgfuKU3qpyNWPRXMbNf6ip4zFmT68LiYUmjvSLXLq6JoROBGDBGdEK51rWwQeUCXpYiUIQbWqfEdkUiB7KzODM78mSe22qYxxqo9o/mxmGwjADoQ1nkmka+n7OcJvJIsOtJxrvBtjC3P554K04wcobVaAl0GGur8zbTrpUdYuda4cqheoekbZ8en/OJeoHYuSJyUpZLg/3YIVTAAfOiZx00wPEiR0L5GCTRXxmGVRqiPiz+aBq+C4loPvfr6v0KM9dNVmXmmvdN9TDe6HV959Eyl/WDima6xqD8g1iYZcK2aaUZ+7jQww5oqI2X1G3IZQ89uOkV2O7ay3sjGE9k1FI8TsRjksmPBesYAKBkQAKsoZXZSLOyKVvUu7vdsUoXT2og9ELxUl3uys8nliUl3RxIQUhWyyDVFI6aC0yo8dxJ0Y1D6rSTQP6fdPBLzI11enG5eQfDfNt/H+CzFE7zN3uN/raYMGrWgFfEoJhWSHwrEzuXfET+lAO7cFBb79kIgZT21hru2ljoJNqvPfTJ3C5BD9hnHyw/fA/zPJvU2PqL8YdLoT23xbTA/lBb1WI/59hfII47dVD4t7hck7757kiFx3/dw9a/Bql7SeY2ifzlCXKEMbKWH24liFktOAeWY//wr3CWOp9+Kod6it2pX/UMr8zG+MXio0jtkPwXdTrdf9APrzUSZfau9jbYustvIK7S8s4BWoFuUB3XEodHT2oQWAWCdVnzY8XpPo6YVwUWSQJSCo5ZpQ7XBlVktuZMopgve0idbHeAtkRyVwIJ/jhXRzD7RcDS80M10bd2EoF41xajfqBQPQ1qS3dwIZvPyGaiyvSV+YAktjAe6LARqNZMTYV5IHpc9VhhflZBNwEGXR1Hf
 oSbvPdZm
 TNqxMOBSTaPP547WtrqZ4CBnZuPD5X4gBbVP3tRn8W/Y1zhlogykxJ93h1UaYD914J9WAf4kK4j7kpIgV5jJ+82vK+nNV2EseBA+106Q7gHa36hJXONSce9aN60lwLdik8oL42uKiNMt4yYo8aeLuDurGUn2ShCo0loCX6UU6NbXNG+HLxZ+dvwYLk6hLs2FVmiEzK3wp4nGZ7pO0ss9TvNaoDEHW/jM/wgRk70GqJz6sZ66SBE7N+Q6Z9UVmbhVXeWd0P+XhPjU8ESp57sNvGsVO+jHzLsYttw22mkV8u764Ei/3Gj2QK1ytIQYjls/m8yBP6zQQL/ziMEvDRmm6kjm8U/380zNycpZPgiPfvRqXLS6Ymkg/nsOj8cMgKvOxkr2b7TFLwLOmyDbxWEN3N3U7M9XriPZqI+6DqqSBBXyircA04SKaVunEEyWnJCATESDWR+DVKeWVpdwmQB2615A2LVedeEM/iJwA+ok+96SPeR0zXims4xjab01Soy2zwahsE9W2RYt4xXfnoRgyjbrFDRelVZEAIoI3BMZ4c0aIoFQuCATci1k5gXfJu+3ZqkED
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
2.54.0.794.g4f17f83d09-goog



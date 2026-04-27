Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D64CFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1906B009B; Mon, 27 Apr 2026 11:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78A96B009D; Mon, 27 Apr 2026 11:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB67C6B009E; Mon, 27 Apr 2026 11:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A9B646B009B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:54:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E079A12EF
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:43 +0000 (UTC)
X-FDA: 84704735766.25.ED0A0BD
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4ADAD10000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YmHMM70i;
	spf=pass (imf14.hostedemail.com: domain of 3SoLvaQgKCGMBSEC+HJUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3SoLvaQgKCGMBSEC+HJUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prYizMoqeWKaDZjQ0nuvo6tbUP8AzcnCOIOw0eqIeeQ=;
	b=DW0TmIrgrar/hb0hsLHCtWlYQ1ihmwq/qkZWdzgSuf8cXY8IaCPEidVMVC+XnTST7+Q6L+
	oYAYz8UBlkjNRoS830H7BOUBDe2ENX2jaYVQ1qbXOtXlmNUvcz6y0GzRIf7Ca+OGcGb8y4
	JxqKRh1r7cp2BaASvlV6ijouHV/BcFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304140; a=rsa-sha256;
	cv=none;
	b=dh4rVF+gYo6Z+HoWW+bsgvZ6oDNXXO+y72jOBSoMAt4/pTUVhz/R0SHKezIN7PQUuof9m/
	j6tW0XFH50L2mpLgLep3WwVHEXEAe5+oTxFQpvSphWkTp9xj8ILmBhog2pI/LeziPGfWbJ
	Dhv5IsWBEv48s6qkpiHeeD8aG1T7Z14=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YmHMM70i;
	spf=pass (imf14.hostedemail.com: domain of 3SoLvaQgKCGMBSEC+HJUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3SoLvaQgKCGMBSEC+HJUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43fe4674d3eso8734169f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304139; x=1777908939; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=prYizMoqeWKaDZjQ0nuvo6tbUP8AzcnCOIOw0eqIeeQ=;
        b=YmHMM70ilLxOr1IIdpMyvW/0lEyjK1ATN9XOvqLy2n3L9DFh08ILEqiLpTwgQacYkK
         u8gvLKV+OITNYZCwYosA78kPZwkyFpoMlBySj8l21MvtFeXPBo71gc+zP4UqmmM5QCDs
         JzH6N8M4xxEup2Szp+qTjk0w2ljI/7AWuzgZZzXjnkRN5n2oVg/VLKd9QHHTdaWkHUbO
         QUaRysSil5X6rtj+LwrRWeXrGhAlAJe0LMPDwcPPNYi5Ktt3UewLIn2s7e35O/gWv6hz
         pf9OQY9rWkcP9sqXmtvoy6FgIflYPX1m3d0JbtmYolcVzRnGImUIIJ+VNTqoKu2cx6bl
         WC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304139; x=1777908939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=prYizMoqeWKaDZjQ0nuvo6tbUP8AzcnCOIOw0eqIeeQ=;
        b=GaRvfRyrLutopSVut47FryxvLMqfSrqfe99ggytejzsMzuPYa/W1Ef8hF6/qooOQC4
         25F8BPz+GVcahZh6ibiEvJ+C3PxTw5+NG/Q2QXe3DHXIy6Qlvlas7quDnsNPwXkbm1zy
         MHf4WIFpqg8YUexVj4v2hftLoNiLd66JOaO/MVw49GOrm1QmRn6fRBby1g8lVRZolKgl
         MHUcbdxTYf/hiKXY0UWXyVhkbuTBD064N66lsFTHbiyRV5RVpzIW0rI4pshf/BN6zwY1
         WRjqPxgTbuA16YS8PHrgCALVpOmq+Ef2vYR+mYmSi7yyPYZzqfP42czpWqbzR2dsBub9
         HN9Q==
X-Forwarded-Encrypted: i=1; AFNElJ+nlOq0fvrhNCG5q7WvVy+odOES6CviZAd9ppuBr6BKVVgfzR2QvYQA4WoU3ihA8gvyXvAJE2wfPA==@kvack.org
X-Gm-Message-State: AOJu0Yx67cjBh2euE3LpcC4oh/67PyZif9B8CDjmLltWw3W5+BBWrqBW
	STojZsBy1FAm/isH6+8bXix/aV54uOpVcWVWW39xBzf95Az7+2SF0YytC9bc1QaZxt/hWBH39A=
	=
X-Received: from wrpx17.prod.google.com ([2002:adf:f651:0:b0:441:2eb5:f2f3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:621a:b0:48a:6268:18a9
 with SMTP id 5b1f17b1804b1-48a626818cdmr232216125e9.13.1777304138328; Mon, 27
 Apr 2026 08:35:38 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:21 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2701; i=ardb@kernel.org;
 h=from:subject; bh=aEcnYdyzs+Jl6x1LXyRc2wvdSGWl6fC+aTg1LsbHjwQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN94//XXIcrTPk7rYUCN2cm+KhM2sqjKyt3IviukIL3z
 nmlYokdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCITmhn+h+c0/z7TXLNLwT+5
 2H668O/amKwlTWfv3NYJ/6xb++rrQYb/3i4e3oYrxG//mbFf4HQ3M8eGnkiV+PfzOz49Fdq1VO4 XGwA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-21-ardb+git@google.com>
Subject: [PATCH v4 04/15] arm64: mm: Preserve non-contiguous descriptors when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ADAD10000A
X-Rspam-User: 
X-Stat-Signature: bm1jj1hm8fbi4ax6gwoxfgqwym3kwizp
X-HE-Tag: 1777304139-275025
X-HE-Meta: U2FsdGVkX1/f+nlMfsAicyy12HBsoYgdRZGCdoj0yMIB/WhL6l4OizrnX1ENzXPr3yMC+7yHarBlhzBbis+ntRJsUz0fDsJKpYgL8fWEIu6q7e14n0SmEP1gdW9tdWc1xbVR8RQZasasgDWezaBqQ3FxBGKJ225nsZHjnqFXegUzTU46grNfIJq3i/mq8XK12HkggbiHzHdDP2jo3tvIPIbFv3gWUVizh22ryKKE4qS/7hvxON/qt2wFgkzPF4RIPPJN6B0sAlO+k5UtSYy0/bpMOAC7O41cg9H86ZVhHzmnjtlR3mlRd+DdLC+wsRD8dLtDwbBFWxFS/wXjIsyUdFe2Zrl5LrunrT+fh79PAtLcWxP6Tm2wOVqUtXU7mC3+L4r8/TNCZRn6+0q1Fv2NmdoRNSsygVwt79GsOpDYr3GDXHZ7O/NV5bwwOQkj8QQw4qNSzB5KwsKNxYPqQXC7ATXNxlolQWaSQPW5KYy+zZRkiaYJLBmypoQhu5+Ne+91lOh5EwxoNvRTSzt+C2NsT6LaCFjXtQx1MOhsjPpBzPnOiuRKPtxv4bm+03GOy/ju6pKq/XgFwaKyr+pYs2h7WGORkKqItCcujDKuvPFFghvoRpjNdNTEzNGLUNlX7dON+JjOujAzJjFO7SyIrxqQ/1eJuxRwVK4nEsoNQecDOlaPQSkyquA2YbDHFa9W6ZU1FuFWQ9T7EbdpsICHoMAPvG9kGnAM+/oMlC9Tc7yfRISVpJV8M8GoxF7ZstcNtT7rnpNfY8pTxL4Y1Hv3IhZpM+y+/aDGekoJBt+WuPc4iIzhz/Q+kSX/zdThDOp6zaN8XaTHjJ/20Dz9YquTQ62RFNR8TteHACH7CL96RtWKAHj9jDQhT5K1prIu9HyTtDrnFzJCEov8G9c88riI/g6PbzAp1svFCgLzXJNn07JcfOZbqxJRtfzb1V9vCPNqXE8HmknUlLAaMp8S/5Ajzqw
 ucwrLxtb
 w5mi5Uf8LL+8DFGfbDZjPj8zccT1d0nxce6jUEVeFTuSk9YueGqT6xA32y46CKIjAwdtPHyD7NZtLbj6lSO+NuFChwv5+s8x+Qm3wJBaHfgb6ljSw0BknzHZ7pztzoObn8gvqgb1Uibpb5rC2gKDk329aPGfxXM7LQ4SyKBGY45sFhsLY2RMeXboriQj1k7Af4ps1tubmg3SJT2hJ3XontiwXJ467WWQ7d8oiYgdVlL4eoBk+1Pd4KRhST5PWKEsn3OmpNblODQHuRv4XgnGawWLtBEVHxB2QIgBDDlJtuqdvb1wNkY0Qpac11gYxdrgxbrWrzb9XRrsKHb+tSj6lnbJ+isMhqcoSwLbOh4dRYPmqi0EdDP1982LFY24gUwW54yQ7JuRQkqIILbdiED4+v0vuYcYM8xvZf6GvJWz+9JoznQq54/S46Pxdgm1sFZSHC8b1uWL0YpkLzuQ9wEsiuXxxwEJBWDb5zAqkhiUtFNb4ZC6BUD7Bizgkjz8qAmPY4a4s4BM02GPwBSyhCSP2PPxSR8XHG5ND7uvLAOxJwGnk5qQQTCjc7DcmqH0qLkwfPgcbMnz6j0pBq7otxDgUBfH1aA1q7a9dmHZoSJgp4N3TAIBryrl6qVXok4LXwgTM8hez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of blindly overwriting existing live entries with the contiguous
bit cleared when mapping DRAM regions, check whether the contiguous
region in question starts with a descriptor that has the valid bit set
and the contiguous bit cleared, and in that case, leave the contiguous
bit unset on the entire region. This permits the logic of mapping the
kernel's linear alias to be simplified in a subsequent patch.

Note that not setting the contiguous bit on any of the descriptors in
the contiguous region can only result in an invalid configuration if it
was already invalid to begin with.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 4 ++++
 arch/arm64/mm/mmu.c              | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

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
index 801a54ade76f..005844e521bd 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -224,7 +224,8 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 
 		/* use a contiguous mapping if the range is suitably aligned */
 		if ((((addr | next | phys) & ~CONT_PTE_MASK) == 0) &&
-		    (flags & NO_CONT_MAPPINGS) == 0)
+		    (flags & NO_CONT_MAPPINGS) == 0 &&
+		    !pte_valid_noncont(__ptep_get(ptep)))
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 		init_pte(ptep, addr, next, phys, __prot);
@@ -324,7 +325,8 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 
 		/* use a contiguous mapping if the range is suitably aligned */
 		if ((((addr | next | phys) & ~CONT_PMD_MASK) == 0) &&
-		    (flags & NO_CONT_MAPPINGS) == 0)
+		    (flags & NO_CONT_MAPPINGS) == 0 &&
+		    !pte_valid_noncont(pmd_pte(READ_ONCE(*pmdp))))
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 		ret = init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog



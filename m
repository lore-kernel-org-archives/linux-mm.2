Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1758ACD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796CD6B009B; Tue, 19 May 2026 11:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D21C6B009D; Tue, 19 May 2026 11:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599986B009E; Tue, 19 May 2026 11:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47B236B009B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C36BC1FFE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:26 +0000 (UTC)
X-FDA: 84784525812.13.B219396
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E16440003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YuPOwGMb;
	spf=pass (imf01.hostedemail.com: domain of 3PH8MaggKCMMj0mk+pr2pxxpun.lxvurw36-vvt4jlt.x0p@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3PH8MaggKCMMj0mk+pr2pxxpun.lxvurw36-vvt4jlt.x0p@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CS1BtfvkhqK/WG7QMDSO/xvMHjZnFGS59EcNSZDS0Dk=;
	b=TDHxC8DqtR40qW+f1KyMXlPQkeMmV/5WaBakxpStJepjZqLTQ/sy/v7OpQJA2djMGta8Ca
	41drQzeN0kNHpqOtjk34Ocx9vtewKTFZfaLcnaezKxkZulkpTw96Ejsg2hss0qL1frOUs/
	iv0rZQb5QW33HxJrvn1ZYwTovq7Ginc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YuPOwGMb;
	spf=pass (imf01.hostedemail.com: domain of 3PH8MaggKCMMj0mk+pr2pxxpun.lxvurw36-vvt4jlt.x0p@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3PH8MaggKCMMj0mk+pr2pxxpun.lxvurw36-vvt4jlt.x0p@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203904; a=rsa-sha256;
	cv=none;
	b=T8KxR2coyaVNruaxw+ysxSKMOtImbI05gMxlqP9nCnYA3dWpbt41QizyrWB7ErtClqly7T
	xuZgNv2XiIoAg8ugSrmqgR/lL4wACr7dBYRSZEYugSF7feYJm0dZV+23xh5j1nh8GW9FzM
	qzi8sT+Vh6+905n/m28nOK2I/tSKyU8=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d789cebcfso3163154f8f.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203903; x=1779808703; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CS1BtfvkhqK/WG7QMDSO/xvMHjZnFGS59EcNSZDS0Dk=;
        b=YuPOwGMbWrWfDIXrXcGTCCBkSKj5qL7EsWH/xG3o9ZXAeGFH26av+TtCBuVd+NHlFb
         CzAM6mo6+mZxqpmg72oLPSE/jFoAICr04LPpGn0kuHrEQ8amDPhDvAtVd72i+7qKmkNi
         nlXGR0txGskp1TTtWEtemdc1wEuJXA2bQOLumv1CVgh88LaRW06stgUB8xZG7IUBZozL
         xjrD84oL9BR/b+Uo2k4RIruPzelUqO4MS5HIOP8VJRThFrmryG1g7OTYXaKP6Xf7DPhG
         NHQ/vkih3tZpqt6ghOTjnA9cvGfe77RqLboTogOyM5zHyKc2NtuOMPtUJK4/sWed7aRZ
         39XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203903; x=1779808703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CS1BtfvkhqK/WG7QMDSO/xvMHjZnFGS59EcNSZDS0Dk=;
        b=XH/kB15mFJcSIUyDdN7UjqsUagEzga8D3W45N704qn/qsE7/BDDBxvNUdRZ/UGO7sP
         YcsFhz99kxhSEnP/jbFvxXxxaQ556OhPcTgc3FB6TPaLTsDAqxPxjyKVP4c21qHx95il
         bkvdH26rSjRu3a/4dtMVirh0v4baIcJl9t6qLVUaH8uwWaVSZ2AcpgYplkOfqRhbIlNE
         +Cn7BJCVBKuzxxiOa54TuRn3/c4PNz0gZu/yPvnLbDZJMfe+KCKvRXTnR50Zrz4Cdq3p
         QxLcIUKclIqyLN5UScbS0Q5TIP6MpH4jUNXFInSwvzlGSG3PIOpaD3aQM6kFAMW0pZKK
         DQcA==
X-Forwarded-Encrypted: i=1; AFNElJ825IuhSFoVdHMJnSC67JQZyAMvex4ifSZv+51vTO0UxGgF8c0QXn0WvSfWS4HFjdU3UaQL1zfeOQ==@kvack.org
X-Gm-Message-State: AOJu0YzVeyna+TTeKlVHxvyK9ykz13DDfoxii5RtOdYEpuvxUCfM0sy9
	z+glbY5bmHhWNt4wkCCNjmw09Nc3pBnoOT/XVQIOmz3YPtOdXucQuvtNjh7mn49Em9eQS78fAg=
	=
X-Received: from wrbhg12.prod.google.com ([2002:a05:6000:1e4c:b0:43d:7480:5bfc])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2885:b0:44b:5a37:36c4
 with SMTP id ffacd0b85a97d-45d941b198fmr40017031f8f.26.1779203900883; Tue, 19
 May 2026 08:18:20 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:21 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2697; i=ardb@kernel.org;
 h=from:subject; bh=suqWUpRPoN3mdRoFNlLmQlr8b1d/8QdQDtjxwFffruk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7vhPi2CHG4Vsp5Yef6FSIcbLk+jJoX4rguX5KsV15
 tJ3GHk7SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwERu5DMy9C7UkCzh3eQ0N8Zg
 EeM83iu5V5tysvp+HHm5smhdUXqWOyPD3pP9D/9fkf3xM3Jr+f7UbV8D2Y/5b+u9ur+madPEK3o nOQE=
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-19-ardb+git@google.com>
Subject: [PATCH v5 04/13] arm64: mm: Preserve non-contiguous descriptors when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E16440003
X-Stat-Signature: z7f4o5hbee3gzqrdqpihdnhyoriwjcjo
X-HE-Tag: 1779203903-706444
X-HE-Meta: U2FsdGVkX1+SAA+e4cK/0j54QXt1vR/ghwCX4j7XjDPMrYbSd7oDGjMOq4GoVcImRhOF01+RAAQ4r4/YZEJreDXOCphe1oskpoP2BpvV1g/TFDAz0SMJ9und7bBVvkmWaA19WJ6E+tClNGTabYxKjkV+vHFoCXDabbPvGIT+HntqZ47qm3EWqK/HC8dxh6pyE+PEhLTHSzDrT4x8LRaFjerVvkKyOZjQhowdjsfiupLn5IVaKgU/rpe0bsT1Mmls+FJBSZGnMR7kK0Je110X8/g6VS3kQF2X1MSSKL59+kxvS4EhBdgK0HyhFsTq/27chiSQwlM+xeX3shAEe2/YIcOULQS5LR8P/mLRh9mrUjWuOOBH8dHfIcq+IXnhBiqKOgwkWW/k/B4wNVsCH7nuwNOgTcRSciXAnYeNd1eAOmrvqjfSDqFLqsC+S+gUkrnMQvRGfoCe4qqj8Jq2dAEaiMo8eIX46lSNMmeZlZkXo+4hHh/bnOgcO0kv6CnDSdAyq1JS+iK+NGR8QIRixA3QWgCD3P9zwVN9W+augZte0QGZ1KlL3VxZncemZ4vRMwbXaqB+nZ8mU+0QL1iPaOPhbakGJcq1rEDnfADHNMwqxzqZQpDS5BNrxcbca29TY6C4Dvfh/tHXMy4eT/qfQzNTDMb5A8BxK5zc3TTuoP/2z4pWkry4fop4iJe9w3XfJf7u95cs4xe35/7fwzyYAOoRfucPJ0m0t6NBFVu0zf2+D8JK4GxxvJrtn5xhgXOtcEPgD5qHfoK37MXRUWLzABR+XB/EwkUFYZkOFLlVwmfJBGznG10ac7a8veYkm90Au9578Oe0gb9mUYqCB4THMRJlu+MrveReNpmisnCy43G/QpiiKqjOOZ4zRdBq4ujcJMTCg7nVWC17oteJdoBV+0lmkdvLuWouzMoDFI4rF1H1WpUWqra0CmIz+KlfEAW6MzNommscr73IkfTkPLCGdf3
 +G3yEzDv
 8+KqD7Tl0qxiBkIiGXoNXUI2jrDfGvm4T1vIiy99+f7XDLNGxoeF/OE/VeauwT8f8vUDtpqvR83sQs8agXSSGK1zg0FdUw5wYYp8WZL4Pz4aDqm9sswL9+iHvqvMYHV60DumaCMGfTWQFacbTmy4J46Zj8xx1nAUWGbMHOv2Jbl1EiZh1DSdMw4It1rmS2BRYniA80ntcaHaxaTYfQY5IdZ/GUEkuNi5/KsV0U+3in3RorCuT/hJYNppNyV1hfHiaGjelZz5OPvGdoi8kO1eu+/Tam34A4q0GqpWH6JlTRZP1JnDRx+Y/X7nwtq+3I4Mgjii8CzXSnP6vqrk1TpmC1/T2sB1q2PHKphTbUPLFNCgd+CIVfUw/iIXWeFIwk+e3Yivj+8NkDtlGqNAv3QdMldMgBnCA6cwYP/lceS7zkonKsOIedBUAjpSHia3aC2TV83twglm55+bsq6p4Vs/zHMn4iM257nhI5rJgDUK+1yKPNn0i1+HAfPa7Y4PytqQV0ccIFaC5e8dcdiygqgnrJKcFQSKAhlX9Sp8ZlKf1vo32fnvP+DZ+fVrufoxiiSul+zQPvx+IL8ss777m5CPH9ngLgi3CGYpjvKqlrvWs9amJn4zLedgSAkYB9BS63DESR0at
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
index bd2764f02a7d..4c6ef0d35714 100644
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
2.54.0.563.g4f69b47b94-goog



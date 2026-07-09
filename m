Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25144C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DCB6B0099; Thu,  9 Jul 2026 03:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2549A6B009B; Thu,  9 Jul 2026 03:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192996B009D; Thu,  9 Jul 2026 03:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4AF36B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:38:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77CAF1C84D5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:54 +0000 (UTC)
X-FDA: 84968436588.28.20EC397
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 977891A0008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MlIma/5C";
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582732;
	b=cviaNkjP+wDCH7SPzdRw6D5tDsZHWo7waY0d49NcjAMtSyVB73EtqELshpIBDPTaEeBZzg
	wQfrYCyGBmy6NJSkg+LNbiUkhS8ONWforJ8c8RenkQlqO2CVG+H2qYcl8NRKpgW+wiXn1v
	70Tvq6u+p8aM7tV1PTP5iVKc8xdsQJc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MlIma/5C";
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0spoNjs2N2IikfxIi4vPxdEU/Zh2HTYHpAsMmHsIBMM=;
	b=rPN6r9b5sXDm+rOtHHVJ5H4XPy7g1LtZbhb1VQmM8wOonqAatlMCwHJn1doXtNAUBDjLwB
	9qWXkWK5NkPtH9Z5aNB6S24Nju7S1dtBBOvL/0EkLJZffkCuf1eG2GXXQahR4sWUlGkCIM
	YDB+VzqklauOhEzX0H1D5rBhTfIK3Qg=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c88a4d79ba5so434978a12.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582731; x=1784187531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0spoNjs2N2IikfxIi4vPxdEU/Zh2HTYHpAsMmHsIBMM=;
        b=MlIma/5CDVUIGOZA7L4BViSssrQVPsxhmWguR6r0hoo/HIeMixMqnWWLb3Y+8fSD8y
         +VQFxElJjRox/MJoJU2BkTs5V3c7HrmPZSQo+7+RXbxNncjx4CEkzTiBSwIM18pYL4BE
         jhEpffMinDCc16ZZz9OTc2hRa+LfwItXL4S5A2tfPeG//KVBprafz3okaay3gAVNqcx0
         hBbl/z0ZBNGIlo57j7lEbFBcZXHwuUwTU+sSfFQWd5RUublDBeLewL0wb+06IPcYaqZ6
         IP2RZtXYBM7a2BZkqTbPFvHi36uMfsy3Ue8t5O6SoypPP6nDU75CbBWHm+GvTyqRLrrJ
         nASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582731; x=1784187531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0spoNjs2N2IikfxIi4vPxdEU/Zh2HTYHpAsMmHsIBMM=;
        b=gRihi2gCCIchvjvAO/gAwWfdlZvrHLVooOXpoEAVzzm0Rz7wbBd5c3ObcYxUJI/uNv
         0+obwWtdwCIlglSe5s0afxKYjaOsBu8p59yumrj4ZDNWX+Un5Ko+C0ierwu3wmomSE7p
         /qXKa4t9bfd3+i7sQg5JBb88RAkHSgo4QgqDH/OhDYaKm0WbKydiJoO8spkvAgWNt0vJ
         RyVCUpHUW/BbFcOUUft4o6oLFGwtNavnWOkRJdWzYF+53LT0pA6ln0BQwydch/DxNKD9
         7GhZT2Anh/0GeyvSNwJO0s4BNZ7finb0MdGDDXvRVFBvqtd3kI8F+UIuYzZV2dLfUlQd
         ftBw==
X-Forwarded-Encrypted: i=1; AHgh+Rr3y9mW79468FVXP5Qu9znS7gxzT4TdP/W8MiR93oNxs7WiyOafacgS6IlSnWBE8bXQOBLuji2JZA==@kvack.org
X-Gm-Message-State: AOJu0YxEpGXzoLgit12Uxm2g3BfKivOnre+QbRmqkB9pKuBRcOXq/RjG
	QdTHmnMSQAhNi/43DJu1CERNjhIIUy2PVtlDa3wmmCszQqTkhkf3FaSD
X-Gm-Gg: AfdE7cnfloO4McOISGgu51fLK0m/p6/bLkCThfq6XDLA23mDlO9+Hj6P21fckP6nsMQ
	Dg0Xv9OuitT8Qp/aMpb4A8NxDa/EcNTF6P3ytrvp5b2gwwYKlUQNxhlxrQuO7FPiEzSJgEOBu0t
	mvTuSFHiEavF0aaMG5lEpTmQOVLGly3jhD9ozEAFJ5/cN9pM6w+aQVkHlYQwL8g+gHmTOyz0rUl
	xQCUxGpWMR62r+Xl+64LybExx/bfIppMpBwhuAW1eKtHaQLrWJwZylArmSPx0xo/k9t8gFqDRP6
	k2sfNnaZebVFakyjVafpV1DF4+6DuTvVg9zJbodRMHNuzxEgAg+erDGTemQJCaHae6HnJBZRExs
	0irfkIETitj61e5hCxeRMxz1mkSPlp/DCfiQgihZWAGJQ3KCkaLKyj1YDudi/DDl+csolwhkWRB
	9EOhii1xB2Wwk+GxjMnMkYStLY1gd6f2uY3jU=
X-Received: by 2002:a05:6a20:3d0c:b0:3a2:d838:bfc6 with SMTP id adf61e73a8af0-3c0bccbbc8amr6866655637.29.1783582731389;
        Thu, 09 Jul 2026 00:38:51 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:38:51 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v6 3/6] mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Thu,  9 Jul 2026 15:38:20 +0800
Message-Id: <20260709073823.6643-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 977891A0008
X-Stat-Signature: piorf8k6oniahwbd7j5txq7w59y9zmg8
X-HE-Tag: 1783582732-563496
X-HE-Meta: U2FsdGVkX1804yonyjDCyp3kMJS9Q7poskwdLEwxHWjeo4RHFPK7JvOciTHuXCJeM+u7gc7prB91et/i3ZVUCgmK0gBxUiAsG/VziXStsPoTxEPJg3TEHhR0xYb/0a5YELQByJ89YnYqVtplMGpxUkB3a5EPR/3jEe1mb5pd/2qbfNVUxi5cAGtSjuNOA1efx+Yi3bohV00aEs9hUjQCPQXqPZncnFQho4joHqawMhGtWLhreQOhg7nJA30bsZNIycV10VwI8DUUT1xl+2ekrBTBPUV0xzAB0ZgIBf85a5q73URQ6ikan9uExE2wk+LXwIbye7Hko44DFbkwN5y1ErPG7SCu0ngAqahkOukeNrbEDvKFkUElkUMlC14pZ1HSr6DQBTxvdaMC6xBUSS6mbgQ5z/7dP6A9t0CTB5RWgOkRGQAAgOEAUwRSTGnbDcW6CX+28o3Tz2lE2EV8BNz9iTRMDKi5RvjnTORpQV29GV9Q3eDxi9ngTu02YV0pnlFeg0nSycBLCzIn6wKXGqKhyoXvf9MgIoFwVYZi5VbFXUFRN9YYkyhbxYrco4av4MrqPa4PRb8GhSBDEGVGUh6u2eQQ1ZvCxY3aIPxSmQxjdv7zEZvBBGPffHqYr5iKccZtT6O4XnlZ0z6JwyGoNJG9h+dtoux7WVaLti2Gq0RcnsW+VicFiyzlekR3L2dFpQInG47ffUnnr3ywQvdu45Z0O51XB6cRlOg6/MpCjOuOF4QoIOHX9kSZ1B9zPj2/LgStauD6YRy9rJTiEGGok74/Tja5x72zDn9uuz+MgM7oA2WFQdKGwESHXsyLnsZGeAEGuWaUgeiYRJGhSuWgnWnpoiANVopFP+ZJ9yGft0SJGGycPTjqYkJcuUNFWCSz2k7fsTLcfmh79Xwywugt6B4zMzXiepIJkQzLLZJHFzb6t5ETsIeyyjgOwOoYJPEApB3ZftQkZemKEdzcL1J5x9Q
 eR7vO8OP
 Md43c8bHV2zSBoJYtPDQ88LPdIsk8xLPsBprsgOC5iA526VWFSWIFxvpcMW0mzML9r2vpkXoikxeUFvIW18PPThbFDyDzd3hDt+SsW1XTiOO3QFQU4vHHR0Buh+kOfuzw9Uf2+GuZoI6di5XrD+NGiampvktaC4lThhiGbp35YOTrEQ1FNi6MIhYgUoW9nveNGyoZkJXrSqnwR5DFKwdecWJn03fZr3YOd35bQAC8tB4bImi/RZKzTtoBa1bJhb5fqSX8EtQ2uqt0c23VCwHXKTzu5eycCOv7jgSfawrJTrKlv9j+0GEfQQFcy9k7NlmlGVnjrjZwSA5EDIzT5T4C9SPDLwVcn6aYmKxtCrssObO4aEnZcdTL6vweprgwIEUr99cHj1oGXVHI6V9Scv3Cl7LPV73QwFEmcFbnBN236M9Z24/SRQXGz1dZ97fC0YE0EFEp+fHfmZ6IMNlLJGdwLeB1OyHaPdz30T9rLnDk9s3tvrXlDwffbmpRoUa5WsgOKqHN3bR0RlpSRIKN9BiXwo1jGtr/Xtm9r9+vxVRbgpu5IOCTX/Nt7DvirBp/GKxrkydeKxtdf2SBhj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
so callers no longer need to handle the conditional compilation.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2c2f74a07f396..d7fef85b241c4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -91,6 +91,33 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		pte_t entry = pfn_pte(pfn, prot);
+
+		entry = arch_make_huge_pte(entry, ilog2(size), 0);
+		set_huge_pte_at(&init_mm, addr, pte, entry, size);
+		return size;
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -119,19 +146,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-#endif
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		pfn += PFN_DOWN(size);
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
-- 
2.34.1



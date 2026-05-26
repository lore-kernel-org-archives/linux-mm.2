Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB96BCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05556B0099; Tue, 26 May 2026 13:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FC26B009D; Tue, 26 May 2026 13:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93A56B009E; Tue, 26 May 2026 13:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31016B0099
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 787161C03A4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:33 +0000 (UTC)
X-FDA: 84810333426.05.29ADBCB
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 46B15120010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V1GMNqBD;
	spf=pass (imf29.hostedemail.com: domain of 3gd8VaggKCO4QhTR+WYjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3gd8VaggKCO4QhTR+WYjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVwVNe3cqI0RCHG1xJv3LRo5BwxDkOUdlieXkffr7Nw=;
	b=jxdqqbgq2ZqHSkJX3zLRfDWKFu90D3oFh66s3kvnuyzxMxCGRrRHmNsIvDZJ9b5mjRPNfE
	62PLHDsLLvYfhPDFDS+mmmLVZC4AzGAsWd+k7BFdj37Uor+//mUCen7AcLWKWnO51jKsz2
	N3vAM5lK9nOxHGZ45E5EvAsBg/fUQfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818371; a=rsa-sha256;
	cv=none;
	b=FoZS2JaVn3oszFEHZTgDV5G2dC3JyM5fJj2SiF7pu2KY0T46mYUnDAjBvfMALXWxOJRhkM
	xgOD7nE67mPKS3TvdX3vmpbhNF7NsWYsIenG+16mTZXe+B7qI9AZpC29az73SEx2jkwK0g
	FON8h+8J6MoIHULoFxGC1fLJstYJLlo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V1GMNqBD;
	spf=pass (imf29.hostedemail.com: domain of 3gd8VaggKCO4QhTR+WYjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3gd8VaggKCO4QhTR+WYjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44bf1ac8893so7965445f8f.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818370; x=1780423170; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uVwVNe3cqI0RCHG1xJv3LRo5BwxDkOUdlieXkffr7Nw=;
        b=V1GMNqBDv9JfDt3/Cd5nIyIHKPolPAQe4DspYWwUTp8dhr757THGu/E9UtPwbq/eSB
         cqmaiSGebOmnCnTntSPl2v0aWQhuBobnUJvYoZq5BwqIb12/D2K5kSnkEF8FqFoYfOgE
         qkC/X4qdIZfRWfs8C18trrIyLY5gNtWjSISNLiGV0JEd/965nJt8zcxEdwBOnB18Z2+q
         CjXwzIWO4Sw2D2l07uNsPwjqIQYvX+Vq7j/aNWIG8OctSLBP3H8fwzB4ZrSJpK9DqwLZ
         bpY9UMY9S4hSFWD8G6Gyf+qIZIZNq8BA6okTFc91TJNxOF/RklHUE+54XOMx653op83W
         7pUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818370; x=1780423170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uVwVNe3cqI0RCHG1xJv3LRo5BwxDkOUdlieXkffr7Nw=;
        b=HP7E3e0K8tmyplyShALpKltM6T4rEt2Ddp4y3RbZTJ3LvOyDM1R8u+H+VG4c5SOiB6
         q24q5IbuozJfwe1dCzd9ue9gJk8YdCLKkZjj9aWaTZ3sumFZqrQoBUQ/kQloRyuQEgO2
         tu15v7OfcJuIwIU7FDUiuVpMeaaih+bspHJW1+6510zYeYsrZBPnKQTKTfNiOIwke52v
         d5gTDAouFFT6BbXixnnC4/n+AcI9Ue/ChUuekYkE0j+u9/sdqw3prVbYs0Dlnpl/gjjg
         ARPpx4wwfClMEycHvhWarQbeqKA6qQiWVg2gsG2jVs1AGKLRUEsieki56NeSd4G4ha3v
         7tiw==
X-Forwarded-Encrypted: i=1; AFNElJ+950Qi4t9YKyCDGcNvhdbomLkeP8/Ip7AQL1oT4ujAYdbR1mLi2LGa6SAW60n11h02o4U3Lrf6Mg==@kvack.org
X-Gm-Message-State: AOJu0YyPiX8BWekHjBveRPpdZ9YjCppYdNYsdrJk78NK3iwp8C5QplxL
	baJpBGTKbLLpdnJHbNCRD+JWnHtp2JtMZMW+iw9EbAwwWHsG+Ykk+9OLi/NdBhADrDpSGo5ctA=
	=
X-Received: from wmxb15-n2.prod.google.com ([2002:a05:600d:844f:20b0:48f:d328:60c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e14:b0:490:5cb3:e936
 with SMTP id 5b1f17b1804b1-4905cb3eb00mr223400195e9.4.1779818369475; Tue, 26
 May 2026 10:59:29 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:54 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3123; i=ardb@kernel.org;
 h=from:subject; bh=p/GjcIFRscd8SARDtYvyFpPt1lS/DKkRLXn2dxWNXF4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fsKpx8vWnXp9PDbK7d7pQ5f7tV6IZt198fXxgbl3+
 RdMT7Zr6ShlYRDjYpAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQAT0bvEyHDiTj+j5qWAr0Y/
 aoUNp/5XU7S1WV4v/ue8Dkfu9tf7llszMqzS+fykyFm2qtwylU02r291afDEKR3P9d4q/j84eW/ EbjYA
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-24-ardb+git@google.com>
Subject: [PATCH v6 07/15] arm64: kfence: Avoid NOMAP tricks when mapping the
 early pool
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
X-Rspamd-Queue-Id: 46B15120010
X-Stat-Signature: ui3pmdtay47fxj63tpjr1pki1ok7bxr3
X-Rspamd-Server: rspam06
X-HE-Tag: 1779818371-132967
X-HE-Meta: U2FsdGVkX18fLTWXtmfCEuVagYuXF8UiC/nP6E4pFdVzRt99wfU7mKYpprYcBGFRVplRcw92Nu81Dlqr912Crs4lk45iGb7Bc2JAWvOE+cz+ggs27m9PrJdDfz2RG/KKGCiwQ2PPKNtLI8sgGSlWtbsSvtHu7eSyoYIkz1Q0+zE53MM8rp2qting0vVvfDUETU8/6FtsdnJTulKCjWPeYeQaScE3m211fk+JP8IUWPLBLVMzpo++0UFTq7YRJJxZ1ijFBQ9infQWQmeTin771lR0TcscqL8nkkeppj6gfV72CGwMD1aHIN1tTp4LiEY5kF9Trei1ozOT+ksY7LwrKekTpq0gZ3VXUb2IMjGE52YtPZ5B4WgCrpykCSILJS+V4BFxX6onMU1B0DUDMryuIG3/r8LR6KB/GdeIoJCz7h73zEqYmLbv2LT8SrK23zUJ++hFnQedj1h+Xvhk2za9P27mAE6SJHwsJGb6DOLvJ+wqWsEdZ+rCajXtmIOOF+Un8qSUk7X17JX8QTUbvAeW6v3PK7NQLowj1yDesSsn0TGeJ4fH8FPuEPoPU/nskphjOAmeaNNWOQqZZL6x/1OO45us/igACamLx9XqQ+FIC0pYRfqoMSuoi5ptfUAnjViCSDvCxpOpEsBXQadHzX6VyAu5Z+n8shJEzmU7hNG1DQxF17xQackULH0Mor75LV2Jk2e3SwXPYNTpIn/oRX1+F0iRoAOehvnxu3FdKCNP0EuhoIMhNKk5TlUXEXOYVIHJlW2qrh3g1B6++0agrJlF9Z0B+9LBMOMTfleF9R1pGcWanv9BCvmtPgpP110lgxjViPhcVloiC2cPtYfJ5oMjTRp8ZPn0xkBOOrriNG4Nju8Rg81mxSY4EWD5rclqeKqpm7LpNerblFkadO8RG0sZWvwAVh9QkXXeBHXhrn1pGgRHd/inWwOpjhxUYXcUEFiha4SZjWD8H8n7LbNYHdo
 dGkF9JvP
 6Vcim2WozJvhLgbC7scW2De3x1TICni9QxdbczkILPMN+i8545408SGJ31WdBKhV7vcNFw+2bDzJ3pwzOw/iBOlH1TW074bSrpvtwT0RbnaHs8V12Ey2t+LIDCfNtXoIaD7CUNpqlK+0XlaXcJfhE67/6VoE7ppFejXubK1jR0i0mSNf76J1bRD0vWcWWPQQDWCHiyVX98pkjCXjLSWEi2o7eag13cgJYtmKWCSlki4pQlGxo2jqyoZwWIma2cR0Y1cdA0NETZHe6LG+cYJuG5AxjTSAU0JBm4TWHgyi7e1r1zNcFUCCQciQOJdMAd7GXaa7HddVChM7GMnD8j6oMm25Em5sIIcS3KETWTZMmQh+i3AHqRg/SIjqojdQavzkcmwnFVEzf1bIBVu5ANt9NCUBAJFM4bOljK2lMiOu3xUCvAsH7CggGCEzpydgZimXOtUu1JwVDfQobU1XaIbwaf3JJCuHorkS6rfLEL5GCMT6q90/aJkIvIHMAdYEdUwAUNPckaBKvCMeSYZUiy0pLlL5z5aHHul32O98JXuEAeLQREMd+HNJG8DhPx0XEfdYO5wqK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the map_mem() routines respect existing page mappings and
contiguous granule sized blocks with the contiguous bit cleared, there
is no longer a reason to play tricks with the memblock NOMAP attribute.

Instead, the kfence pool can be allocated and mapped with page
granularity first, and this granularity will be respected when the rest
of DRAM is mapped later, even if block and contiguous mappings are
allowed for the remainder of those mappings.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 25 ++++----------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d7a6991e1844..55bb40348a47 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1083,36 +1083,24 @@ static int __init parse_kfence_early_init(char *arg)
 }
 early_param("kfence.sample_interval", parse_kfence_early_init);
 
-static phys_addr_t __init arm64_kfence_alloc_pool(void)
+static void __init arm64_kfence_map_pool(void)
 {
 	phys_addr_t kfence_pool;
 
 	if (!kfence_early_init)
-		return 0;
+		return;
 
 	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
 	if (!kfence_pool) {
 		pr_err("failed to allocate kfence pool\n");
 		kfence_early_init = false;
-		return 0;
-	}
-
-	/* Temporarily mark as NOMAP. */
-	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
-
-	return kfence_pool;
-}
-
-static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
-{
-	if (!kfence_pool)
 		return;
+	}
 
 	/* KFENCE pool needs page-level mapping. */
 	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
 			pgprot_tagged(PAGE_KERNEL),
 			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
-	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
 	__kfence_pool = phys_to_virt(kfence_pool);
 }
 
@@ -1144,8 +1132,7 @@ bool arch_kfence_init_pool(void)
 }
 #else /* CONFIG_KFENCE */
 
-static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
-static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
+static inline void arm64_kfence_map_pool(void) { }
 
 #endif /* CONFIG_KFENCE */
 
@@ -1155,7 +1142,6 @@ static void __init map_mem(void)
 	phys_addr_t kernel_start = __pa_symbol(_text);
 	phys_addr_t kernel_end = __pa_symbol(__init_begin);
 	phys_addr_t start, end;
-	phys_addr_t early_kfence_pool;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
 
@@ -1172,7 +1158,7 @@ static void __init map_mem(void)
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end) &&
 		     pgd_index(_PAGE_OFFSET(VA_BITS_MIN)) != PTRS_PER_PGD - 1);
 
-	early_kfence_pool = arm64_kfence_alloc_pool();
+	arm64_kfence_map_pool();
 
 	linear_map_requires_bbml2 = !force_pte_mapping() && can_set_direct_map();
 
@@ -1210,7 +1196,6 @@ static void __init map_mem(void)
 	 */
 	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.794.g4f17f83d09-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3A2CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A736B00BA; Fri, 29 May 2026 11:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D636B00BE; Fri, 29 May 2026 11:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D71C6B00BC; Fri, 29 May 2026 11:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 451B46B00BB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC949160CFC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:24 +0000 (UTC)
X-FDA: 84820773408.28.562E17C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2CF4240019
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fgML6bBa;
	spf=pass (imf11.hostedemail.com: domain of 3e6oZaggKCI4s9vt+y0By66y3w.u64305CF-442Dsu2.69y@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3e6oZaggKCI4s9vt+y0By66y3w.u64305CF-442Dsu2.69y@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHwZV4K/OQyLo87ubxB2N7tui2RqyNeWqpTDKGM1mWQ=;
	b=75y4XvBeHQjRVwRy6jjX7N7Srhx0nAk2pe4fVnJLdQaq+PmvXYYZrlpGM7Z4msmIU7GKlF
	cAmf3zPuRs/c64H6cZtwM2kdHcEV/WFFu3zvy7dvD8y9ByGnpqkTprgXI71EUpVruKf1rb
	pUmehzsMwmOdZZRo0WkziMb2ayFUpJA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fgML6bBa;
	spf=pass (imf11.hostedemail.com: domain of 3e6oZaggKCI4s9vt+y0By66y3w.u64305CF-442Dsu2.69y@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3e6oZaggKCI4s9vt+y0By66y3w.u64305CF-442Dsu2.69y@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066941; a=rsa-sha256;
	cv=none;
	b=ynzDyWva9fVhECfKjhbd3+akRFCMuodKGtgbyj9uw2wcm8iLzYp3OzRzcIRonay7R6Vgpo
	kL0GDkfwNMTOrNWz8MVD15x26KT0LHJDH+b9jl+g8kcIxzrowZzGA1Ut0JISRrMQ6Q2LAF
	MQxOIp+iqLYpB0G3RcHq3S4LujRXmpw=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49058e91639so46545775e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066940; x=1780671740; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RHwZV4K/OQyLo87ubxB2N7tui2RqyNeWqpTDKGM1mWQ=;
        b=fgML6bBaM0EX4iXGBlHZBJXK+HU4v2vX169Ld5umBiBXJ50XXhFLhDSIcmSDn6ho9d
         zqAgYt1MPhwVGWMxEOujO4J4t6V0uLNhkt5ljTLTzoEBYx5vdS2Pu+EnPqenVCNhIW4x
         KFJM9z9wibbnqPRBtO55q8qzQPrOkj15USQyV0Zzvv8dNqyLfPjzQeUQd9O1DXDZ9MST
         QJgsQTr0w3rWqpWP1H/W3m6SZ5KcnKxwkefoKZlBHRihza37fp1DMcMAMB+7s7QNBj+X
         s1wyOryLQ4tGjZTFhgzSno+GdNzYobk629f7ztJE4OBcCG5aCb2TdQW1vBPq26DCDisW
         DStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066940; x=1780671740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RHwZV4K/OQyLo87ubxB2N7tui2RqyNeWqpTDKGM1mWQ=;
        b=Px7sLdruKetifrRX8LoG2N97ORbAbdp569bn5ukUYHg5Zxwp+PbOPoPu9EmxGekBfW
         Jw7cYwla5jVxOcqraP76V+57ifViJ60ZByKfI4C3DR1tSYJyJxEOtIG/uYVqI46mfIoG
         jVYhPCKVo/BD6BCiQsACZ9JfAwPbVDHxePGKBcoAttzxZ8b1nUoYF2Tw4wQuF4dCWksq
         rdtgm1r2eLZQqrEt30viL27sGkIUonM1WWwm3vs/TLKHv8Z5exALO44OgO8w0J8o6Hm8
         fooeC7Id10luasAY3eyBT+W6doNkJi36M1LSjQX4s+xT3/+f48nQSHDssa7jLQjUkvJT
         Ca6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8EiJOfDGuH2FZwk8gXzze0+c3KsINi3GR2qlAnFaJbySCP/v++POEJVJQp6sSXixRKWnp5NrfxAA==@kvack.org
X-Gm-Message-State: AOJu0YzlOCKlspoHnHD9a9EfjBypl7PaEA4kI6U014oNkieIOg411zuQ
	iAsfxiN8qrgXO/g6LI6+N+HRO6GJCDZbgjT17QNXfs8YFKcOni9NpeA5AWRK9L8MAOiTWXFKnQ=
	=
X-Received: from wmbz2.prod.google.com ([2002:a05:600c:c082:b0:490:3d2f:edc])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:828d:b0:490:507c:bdb1
 with SMTP id 5b1f17b1804b1-490a291cbbemr329805e9.15.1780066939649; Fri, 29
 May 2026 08:02:19 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:53 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3439; i=ardb@kernel.org;
 h=from:subject; bh=RVK4+kwUNBzT2vP63qv/oNPK4oNSEDZX2ULcXiZameE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVeK1gth6p/IV1dd2mU+oVf+4YqKnwbIQxumu9bquP
 Yfu1HZ2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIncvMPIcGzv+x2vrDJc2eUk
 LtltCDno/Lq1Z7LA5Ge9k44qbfyXuZqR4dqGMNajx9vSleJns73yeprz3enQ4h9HLk24LK1xMO+ dISMA
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-19-ardb+git@google.com>
Subject: [PATCH v7 02/15] arm64: mm: Drop redundant pgd_t* argument from map_mem()
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
X-Stat-Signature: 1smgwixejf8hi6iubx6wq1wx1qgqo61n
X-Rspamd-Queue-Id: 2CF4240019
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780066940-211731
X-HE-Meta: U2FsdGVkX195LKpczp6LBc4iG7a9nryoYtRur+nFgvuQGcJuod0tNzvUCe9JmsEcxW5LT/IiAg5K7BgFKpLEH0PTk0eU457h1169atRmDAJvRXxZZJ09Rp6mRdddG9Sar0MJPwqoKyEHUOIpUb51pvk53cenWoRlnno7ogxhrI3ubsppQZqDZseLHspdgMT2Fy2W6OY3afEMddelCiR/FqhgvW2WcgI2UTClaXz5b0B8H/dR9+qgXIz4L8+pBgytUa1muMUCRZaLmnWILbxWWtdntDfMlhGHkw/Ffp5AN4Lhsr5uHQ+OPZP5zrbpA/DgJ5GXkU3L75KIasxI1v/iMolNPpARFBX8RRy6zLQcY5q/rdCvZKsUfXUBzoQn7+oybJYqT7I5BBs0Y6ZEwVxfRFQnlx0vsSDz7jY6vWQI34QjNkKJLkUFmQWYeOf7pOHkwvKLsEX2tn5z6A6il9SOpSNbTWLXbwLCPgVqoGbiqOjWC/+IPWi9lKPe3jBZMXAOub2mLdOY/p5qrNO32p/EtynQm2gjzipnur3Q8dzvOvuFmq2Bjdy/i5JzyxsvZRbWk96N85K9ddwuav85ojuhR/RbFNZffqX2sYL68Q8naWk4GsNrW8DICojmBJy2p09TLeX1E1UlPPmBD0xGW241UQHf8BbRYq5Ks7Lo1tce1nR3VRzGyz2nIOCCu5S/eDrNBIgMbGAyVVxmfemMRY8Rn5xA5AkrLTqcjV7z7PQHkeFTI2YHuqFEVgSxtqAJx2icrPaxkU5qs/ex4nrxEsqDlrYcz/wrzluxCgwvCG1Vmc4TgnEF8oRtlXSHBVzW2sB/vKKA8NuFxdLqj3UxbfRcpFbRdXdXrWVn9NbERv74xnFcHDH0Nc9Nbg3K/PaS/VY3Foqz7lyxqGlg9frJyLOfKftvbkUutcDxGHzd7lXsRN2YC6BO3YLMDXjmd3bmCf61xe+BmNrXuVDvwGRMd5m
 h4XEuNg1
 ywQKW+cS1ttxr0qF9Cqj9k++l1CDwyVopDFBjbudvyG5rzid7HhfwAEc7ZTd3NS6vEdp+Dv7PmRWgnZFsc8ThJ+psKg9o2BuOSD4d61mzIUCTeQovYEb3TzUT4YiEWWCM5vnoRk/g+fsvCxqg7+QrR0H8LZ6aunqsz1aCyOxEU21f4kTXO+xVedRE6Ae67x5DhPcRu4jW74UF2q5p/os18QUcY4i716TucTFQCzrbWgFjRunNEIJrzOuRvlvT0wGoxaS+3uV/IPr88keJqx9sqRAUp8HwSJBgHpD9hq4/vznIad1HZzaJdm7GeKHc9p7NUxOrwNirG5vIhQNQgLOSiNl7k1fvShcdxrTPb0oVKVKfbcepulzh6wj3ihGWvji/SQBpVwaWpUJozSl8qGyYjc3Qqd6MO9z9db1WPKK6t3tJFCq5MVKfc+WMq0CN+KcfVZuJF6EPfomhuuzyqNlDEIZZp2Uu5INFwCz0BAqovHB5Omuz2NIFHwrN7bobg7GeLVQKPtk++VNu2tmRlqYJKYA8lMi9Ulxq+jgyryDfO46pSwtCBIfE8I88GHSYM9HBGDdkVPUjTqocQt4eolshCIstsHKHmkBfN2mih4HWPrKEMFDzLWTwNa88AilQNWDKXR8503rN2abS7M60RiCruD9+llRF/wXizkHGYcswBj3J4JU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

__map_memblock() and map_mem() always operate on swapper_pg_dir, so
there is no need to pass around a pgd_t pointer between them.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 25 ++++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 112fa4a3b0eb..aa0e2c6435f7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1035,11 +1035,11 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 	flush_tlb_kernel_range(virt, virt + size);
 }
 
-static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
-				  phys_addr_t end, pgprot_t prot, int flags)
+static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
+				  pgprot_t prot, int flags)
 {
-	early_create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
-				 prot, early_pgtable_alloc, flags);
+	early_create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
+				 end - start, prot, early_pgtable_alloc, flags);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -1087,13 +1087,13 @@ static phys_addr_t __init arm64_kfence_alloc_pool(void)
 	return kfence_pool;
 }
 
-static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp)
+static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
 {
 	if (!kfence_pool)
 		return;
 
 	/* KFENCE pool needs page-level mapping. */
-	__map_memblock(pgdp, kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
+	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
 			pgprot_tagged(PAGE_KERNEL),
 			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
@@ -1129,11 +1129,11 @@ bool arch_kfence_init_pool(void)
 #else /* CONFIG_KFENCE */
 
 static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
-static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) { }
+static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
 
 #endif /* CONFIG_KFENCE */
 
-static void __init map_mem(pgd_t *pgdp)
+static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
@@ -1178,7 +1178,7 @@ static void __init map_mem(pgd_t *pgdp)
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
-		__map_memblock(pgdp, start, end, pgprot_tagged(PAGE_KERNEL),
+		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
 
@@ -1192,10 +1192,9 @@ static void __init map_mem(pgd_t *pgdp)
 	 * Note that contiguous mappings cannot be remapped in this way,
 	 * so we should avoid them here.
 	 */
-	__map_memblock(pgdp, kernel_start, kernel_end,
-		       PAGE_KERNEL, NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool, pgdp);
+	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
@@ -1417,7 +1416,7 @@ static void __init create_idmap(void)
 
 void __init paging_init(void)
 {
-	map_mem(swapper_pg_dir);
+	map_mem();
 
 	memblock_allow_resize();
 
-- 
2.54.0.823.g6e5bcc1fc9-goog



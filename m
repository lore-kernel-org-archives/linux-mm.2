Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90D5CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25736B009E; Tue, 19 May 2026 11:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCE36B009F; Tue, 19 May 2026 11:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC66D6B00A0; Tue, 19 May 2026 11:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B60786B009E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F8311C1924
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:27 +0000 (UTC)
X-FDA: 84784525854.30.32717DE
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 939E540013
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ecBxHS5s;
	spf=pass (imf27.hostedemail.com: domain of 3P38MaggKCMYm3pn+su5s00sxq.o0yxuz69-yyw7mow.03s@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3P38MaggKCMYm3pn+su5s00sxq.o0yxuz69-yyw7mow.03s@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ablq7SDSYy4OVFkmF058uoPsxyfZ6hOzCdrY1mFL1gw=;
	b=gg6EpCSO278zG36NF3MqVJVVdyU4GUrOej8wNU0O9yaaqa6OODathO77vWx9O1BVa1e4Uy
	+l3es4cmv9Duw29aJQhkkCDmcWZUlVFv0zTNqoQ1Z8Sxwt//Qyw7YeIKp0Lgxn3uHDTm68
	1xGSLgdTtiMW9aWcOWj8x2ZJjrJYPQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203905; a=rsa-sha256;
	cv=none;
	b=BCpf/ICfISQ8R5f8D99Rj0rHQOPJ/Sv0Nc2wMV3R4GWvaYf8VI2ErVb0HwLbUrBs2Y46hq
	0hl2PzsxyLb+rIc8hNedlhLFYDuVBEC4oz7/bsP1t9SbcAXsVSPH3CeI4jOtYh3VtnaANC
	/Jm4pBfciNTCU+FVEx6y2tHK51wi6OU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ecBxHS5s;
	spf=pass (imf27.hostedemail.com: domain of 3P38MaggKCMYm3pn+su5s00sxq.o0yxuz69-yyw7mow.03s@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3P38MaggKCMYm3pn+su5s00sxq.o0yxuz69-yyw7mow.03s@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-67fef61ba87so3272575a12.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203904; x=1779808704; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ablq7SDSYy4OVFkmF058uoPsxyfZ6hOzCdrY1mFL1gw=;
        b=ecBxHS5srDedJc72ETuOhggIxxEgarYNQabCqFiTwq1gY925Q5cdRv70f8FR/YBEYM
         S91UMxGINgJLe2HzqzDrVaIGM47DSRyvLlf6CylhTTpmgnF7NPRdoBf6gYV/apSng1HZ
         vySgYCQ9hr3ptlVw85cTudtVEA3Al75uAPjBae2guJ0z6f3Q4kH5x3wWFMLevybW5Blf
         BW65yhCg9pKZ42as4x+wkY1kkZEb7OSSt2b3BJWRz5PQ22dCY6htMVTk706DNwYCh/E4
         quMzP6oXr8Nw3KbSw3+I7FA5xShJ3YGiZF3fTKkJa5KkuCxVLjd+gy04NCjJ5zZvUvK2
         cKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203904; x=1779808704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ablq7SDSYy4OVFkmF058uoPsxyfZ6hOzCdrY1mFL1gw=;
        b=lkyuAqj8sZcknuDi9D15KXGFHVXt3+7k2YxY59grmEk/LygaGTZHWtXJFP+B+dJ0Xa
         AT+SbT2kExLLXLWyzry8O8VnocPW/I388V2Q8Rg8TNKuCJn2ULnTUUa5kIPsVRw6r64/
         GO4ujEm+zRi4cfviuVcbQo3JJnUFrPbIWW4MdWklOdwRuDbncEQXORP/ei401koStK26
         vrQs1Yrn2/pMKylW74I3ny8GzaCfnE/YA8WPeijVqlqjgLVMXRftkUu4oCpoL+7MORPN
         Hzbm8lcKZya7LDhs0Ek3NigeVfaDLGv0FU6OFCiUbvqjRM//J2ANMjO6wbYr/UgTQ4nr
         N5UA==
X-Forwarded-Encrypted: i=1; AFNElJ8mAspjMyXeNM52u+3bstZu6eBYd0laQEptNdRYL3SzdB2cuVmbcurVrk69re5rv2527V8hF4z3Ew==@kvack.org
X-Gm-Message-State: AOJu0Yz6T1XTd8jF5nrSDsVOXj+2nd5oHEy+zBzjeTuFOyZpgstGrlep
	zw+lu66VSzyvgPHqghRrA31CF+WGlgfsS7QxtxwXwDuddmQHd+IAGpx2E8Qq793ilwvi2m+q+A=
	=
X-Received: from edbes15.prod.google.com ([2002:a05:6402:380f:b0:684:6ea:e4eb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:d5d6:0:b0:67b:7a8f:3e2c
 with SMTP id 4fb4d7f45d1cf-683bd38d8b7mr7725381a12.25.1779203903770; Tue, 19
 May 2026 08:18:23 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:23 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3481; i=ardb@kernel.org;
 h=from:subject; bh=x6k1+hxAgsJePfYGlvJneg2rmFUShXoMj4/fbl0R3E4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7tQtN6G1hgdtjmgLWLOkd5w6PlPKS1nrbeH9NZPkW
 yVueP/qKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNRMGP4X3OrUs34rDx3WHeP
 pWTXf/+ikjP81+7duOheUz55P7PXI0aGv4L+DLsrlFS2MG23Y1S+X9HDsL3d9bP+5tYiBT1N60J WAA==
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-21-ardb+git@google.com>
Subject: [PATCH v5 06/13] arm64: mm: Drop redundant pgd_t* argument from map_mem()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 939E540013
X-Rspam-User: 
X-Stat-Signature: s7g96n76a6jgdo9msqx8d7q13z5e6wg4
X-HE-Tag: 1779203905-292525
X-HE-Meta: U2FsdGVkX19MIXKCtV6MsJ0Lt3kNeA6T/qEWDoxe9/sbAtgMZHThlTwcG5Dc9+uHYknrzaWwXaqBP+pf7MKK7lyv2eWJ1H31g74PnfABONtmLInAfxOjxWrGVTkakjklvmYcWbr+bxYqE/tgtxUxXNnbtVxrKGMrH/M5PSqSsY4/MIQre/FqEVcZLV3TMHRKZzWGIAKP+onCFT43IwSD5/bxiKflXpCFFvuqbagfx5YLJwfF0qNYFMamCOBQWK1tRpVSTsy1LLzR2TCAsOKoYPQ57PLeRmZmAZeq0A0L8Fpj3nMp0BEJDgpMGzaYYBEFy0twjZrsq+Ti3btkZx8WjJxNcnSIxP0yKVhGfLs4Uai745fT+AzyIqDFjXXlsXlpro9FWgImP9eqUGpU8hBWJ5AnSgTB0a5gAtG7eyNcdOHh98Q8xXS28O9o6BcRkQ95snGgKOG0/JJCncOlD0SNv/EvgQR+oUYS/d1rRqikgv5VY9Jw8F3+7XkpYk/epNr3jYNGv0GHrJo8fwR45pXw8NJh3vD0vA9Peez8MS5X6DNxDzOBbBmNJqS9DUOz6pOoUMFQu4bruJQYuldn5Pyr9lu9RPBtE6W8Eg2JmBYerdy/BWvOoI3Gi0009k1jaIiiDKSkurKSrIsxv1cj6+CYBC6vocXC1ZhIiKpLZScmPPbLf7rVDJuWye5QldSkKI7sKbUpAKw5Izqlw++LTqHrFpde9DQXkVUKvUQijfmh2bPotY4Ty/tFLZPPgiWb4jU88hGsFaaFWHrOqR3yINjwdY3eqNR55DucJ7v0Obuy1zdHOmYvVHDMFwn1tO7Qy0HMdPCVKteGpWGOWur2W2SPk61+QCOFJKvI7bilBpK6IlmYlrh50aCGljmBSczsw6g6w2GyOqYocGxYJfVcalG+8+BqBotZGpoy8sQqZJVpT7RKcByimWDIJHqZ55jPCaC3dosT3SZUHdvWcxKNzbM
 jE5L4Bh3
 /wVsDcK+QfeTa3/UApD8V+s3DT44oftYUICZPUk6avEm2aIfI1gb4Y2DyWtwROetEmXx9O8cugNOpPONoFPg18G24DScYRn1Bgjfd5O0Z5WxDbnxjmPATAlx33k+gMUpnWPKJXwX3dhZAPs2FKR/Vo1+usfM2u0OEgk6mx0b84FSlFAGcy69vtq4TMH2KlQ8BEC+ZoxRPdPShRquuDJP+oahEjbaIswv8Y/XiL2its68dse5SQsxtDpugl/zL5+NnO5V/hbMbe30k1ndoP0EuI+e4JEW1feRJ01lLZ5qL56IRnfVahNeNx/IKOLi00Q52hE+Y73mIHoHgOI6Mu2RImpQdVan8bWyeUqO48s0X4s+pIw2+f0hFi9MQovWsNd2soX1fgKdh9dKhXWW0TRBtdB0FQTfESW4iR6ssZ2eqWv1ZwpP8N9psLqAgh26WN84+r3JrwXnuwtuBTo4VMcI2XxgVAu2eW9woIZoQg8yBpn0r6IXQdiFOd1fuDRntjCNMOuLRnKRK76HM5bAyLeebsVapHxMUIOaeeflc4TBieyI78rbke9zppY/4ChF4aeNF4n/rtUnp1pR2rzlgDRTpFpB7M9cjjxPbs7mCcQ/Ee7XngKV92zoFT6SEQn5gDd73J6+gAUIyr3njDkPjLbYvxCnYXEyfDGE5qDCUKYhheuDWPjsHwS9kOz3IaUfzBtURJ6PSU5gM4kgmMBD6wVW4c9Wog8eO5+e20VIIzcRyKI6TZGBCpWkMW7KJesGPchII2teT
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
 arch/arm64/mm/mmu.c | 26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index cd841a392b44..0405fac18959 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1039,11 +1039,11 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
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
@@ -1091,13 +1091,13 @@ static phys_addr_t __init arm64_kfence_alloc_pool(void)
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
@@ -1133,11 +1133,11 @@ bool arch_kfence_init_pool(void)
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
@@ -1182,7 +1182,7 @@ static void __init map_mem(pgd_t *pgdp)
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
-		__map_memblock(pgdp, start, end, pgprot_tagged(PAGE_KERNEL),
+		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
 
@@ -1196,10 +1196,10 @@ static void __init map_mem(pgd_t *pgdp)
 	 * Note that contiguous mappings cannot be remapped in this way,
 	 * so we should avoid them here.
 	 */
-	__map_memblock(pgdp, kernel_start, kernel_end,
-		       pgprot_tagged(PAGE_KERNEL), NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
+		       NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool, pgdp);
+	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
@@ -1421,7 +1421,7 @@ static void __init create_idmap(void)
 
 void __init paging_init(void)
 {
-	map_mem(swapper_pg_dir);
+	map_mem();
 
 	memblock_allow_resize();
 
-- 
2.54.0.563.g4f69b47b94-goog


